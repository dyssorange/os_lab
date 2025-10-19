      
#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <buddy_pmm.h>

//将整个可用物理内存看作一个大的 2^k 大小的块。
//当需要分配内存时，如果找不到大小合适的块，它会从更大的块中分裂出一半，
// 直到产生大小合适的块为止。

//分裂出的两个 2^k 的块互为“伙伴”。
//它们在物理地址上是连续的，并且满足特定的地址对齐关系。


//会产生内部碎片（5-8）

// 最大阶数定义
#define MAX_ORDER 15

// 空闲链表数组的定义
static free_area_t free_area[MAX_ORDER];


// 辅助宏，方便访问
#define free_list_at(order) (free_area[order].free_list)
#define nr_free_at(order) (free_area[order].nr_free)

/* -------------------- 辅助函数 -------------------- */

// 计算满足 n 个页面的最小阶数 k (2^k >= n)
static size_t pages_to_order(size_t n) {
    size_t order = 0;
    size_t size = 1;
    while (size < n) {
        size <<= 1;
        order++;
    }
    return order;
}

// 得到伙伴块的 Page 指针
static struct Page* __get_buddy(struct Page *page) {
    size_t order = page->property;
    if (order >= MAX_ORDER - 1) {
        return NULL;
    }
    // `page - pages` 通过指针运算直接得到 page 在全局 pages 数组中的索引（等同于页号）
    // 这是最直接、最不会出错的方式
    uintptr_t page_idx = page - pages;
    
    // 通过异或运算找到伙伴的索引
    uintptr_t buddy_idx = page_idx ^ (1 << order);
    
    // 通过索引直接从全局 pages 数组中获取伙伴的 Page 结构体指针
    return &pages[buddy_idx];
}


/* -------------------- 伙伴系统核心实现 -------------------- */

static void buddy_init(void) {
    for (int i = 0; i < MAX_ORDER; i++) {
        list_init(&free_list_at(i));
        nr_free_at(i) = 0;
    }
}

static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    
    // 1. 像以前一样初始化所有页面
    for (struct Page *p = base; p != base + n; p++) {
        assert(PageReserved(p));
        p->flags = 0; 
        // 关键：将每个页面的初始阶数设为 0
        p->property = 0; 
        set_page_ref(p, 0);
    }

    // 2. 遍历所有页面，调用 free_pages
    //    free_pages 会读取 p->property (为 0)，
    //    并自动触发合并逻辑，构建出正确对齐的 O1, O2, O3... 块
    for (struct Page *p = base; p != base + n; p++) {
        // free_pages 接口是 (base, n)，但我们的 buddy_free_pages
        // 实际上只使用 base 和 base->property。
        // 传递 n=1 是安全的。
        free_pages(p, 1);
    }
}


//分配页面
static struct Page *buddy_alloc_pages(size_t n) {
    if (n == 0) return NULL;

    //计算满足n的最小阶数order
    size_t order = pages_to_order(n);
    if (order >= MAX_ORDER) return NULL;


    // 从 order 阶开始，向上寻找第一个有空闲块的链表
    size_t current_order;
    for (current_order = order; current_order < MAX_ORDER; current_order++) {
        if (!list_empty(&free_list_at(current_order))) {
            break;//找到了
        }
    }
    if (current_order == MAX_ORDER) return NULL;//没有足够大的块


    //从找到的链表中取出一个块
    list_entry_t *le = list_next(&free_list_at(current_order));
    struct Page *page = le2page(le, page_link);
    list_del(le);
    nr_free_at(current_order)--;

    //如果找到的块过大，则进行分裂
    while (current_order > order) {
        current_order--;

        // 1. 使用与 __get_buddy 相同的 XOR 逻辑来找到伙伴
        uintptr_t page_idx = page - pages;
        uintptr_t buddy_idx = page_idx ^ (1 << current_order);
        struct Page *buddy_page = &pages[buddy_idx];// 计算伙伴块的地址

        // 2. 继续拆分地址较低的块，并将地址较高的块放入空闲链表
        struct Page *page_to_free;
        if (page < buddy_page) {
            page_to_free = buddy_page;
            // 'page' 已经是较低的块，不需要改变
        } else {
            page_to_free = page;
            page = buddy_page; // 'buddy_page' 是较低的块，我们保留它
        }
        
        // 3. 将地址较高的块(page_to_free)加入空闲链表
        page_to_free->property = current_order;
        SetPageProperty(page_to_free);
        list_add(&free_list_at(current_order), &(page_to_free->page_link));
        nr_free_at(current_order)++;
    }

    ClearPageProperty(page);
    page->property = order; 
    
    return page;
}


//释放页面
//释放过程是“从下到上”的。释放一个块后，立即检查其伙伴是否空闲。
// 如果空闲，就将两者合并成一个大一阶的块，
// 然后继续对这个新块检查其伙伴，如此递归，直到无法合并为止。
//块地址和大小都受到严格的对齐约束，这是 __get_buddy 能够正确工作的根本原因。
static void buddy_free_pages(struct Page *base, size_t n) {

    assert(n > 0);
    
    // 获得被释放块的阶数
    size_t order = base->property;

    // 循环尝试与伙伴合并
    while (order < MAX_ORDER - 1) {
        // 1. 找到伙伴
        struct Page *buddy_page = __get_buddy(base);

        // 2. 检查伙伴是否满足合并条件
        if (buddy_page == NULL || !PageProperty(buddy_page) || buddy_page->property != order) {
            break; // 伙伴不空闲或大小不同，停止合并
        }

        // 3. 执行合并：从空闲链表中移除伙伴
        list_del(&(buddy_page->page_link));
        nr_free_at(order)--;
        ClearPageProperty(buddy_page);

        // 4. 确定新块的头部（总是地址较小的那个）
        if (buddy_page < base) {
            base = buddy_page;
        }

        // 5. 新块的阶数加一，并更新 property 以便下一次循环正确工作
        order++;
        base->property = order;
    }

    // 将最终的块（可能已被合并过多次）加入到它所属阶数的空闲链表中
    SetPageProperty(base);
    list_add(&free_list_at(order), &(base->page_link));
    nr_free_at(order)++;
}


static size_t buddy_nr_free_pages(void) {
    size_t total_free = 0;
    for (int order = 0; order < MAX_ORDER; order++) {
        total_free += nr_free_at(order) * (1 << order);
    }
    return total_free;
}

/* -------------------- Check Function (无需修改) -------------------- */
static void show_buddy_info(const char* title) {
    cprintf("------------ %s ------------\n", title);
    cprintf("Total free pages: %u\n", buddy_nr_free_pages());
    int has_free = 0; 
    for (int i = 0; i < MAX_ORDER; i++) {
        if (!list_empty(&free_list_at(i))) {
            cprintf("  Order %2d (size %5d): %u blocks\n", i, 1 << i, nr_free_at(i));
            has_free = 1;
        }
    }
    if (has_free == 0) {
        cprintf("  No free blocks available!\n");
    }
    cprintf("----------------------------------------\n");
}

static void check_simple_alloc_free(void) {
    cprintf("\n[Test 1: Simple Alloc & Sequential Free]\n");
    struct Page *p0 = alloc_pages(5); struct Page *p1 = alloc_pages(7); struct Page *p2 = alloc_pages(5);
    assert(p0 != NULL && p1 != NULL && p2 != NULL);
    show_buddy_info("After allocating 3 blocks (5, 7, 5 pages)");
    free_pages(p0, 5); show_buddy_info("After freeing the first block (5 pages)");
    free_pages(p1, 7); show_buddy_info("After freeing the second block (7 pages)");
    free_pages(p2, 5); show_buddy_info("After freeing the third block (5 pages)");
}
static void check_edge_cases(void) {
    cprintf("\n[Test 2: Edge Case Alloc & Free]\n");

    //分配1页
    struct Page *p_min = alloc_pages(1); assert(p_min != NULL);
    show_buddy_info("After allocating 1 page (max splitting)");

    //释放1页
    free_pages(p_min, 1); show_buddy_info("After freeing 1 page (max merging)");

    //查找当前最大可用阶数，分配最大块
    size_t max_order = 0;
    for(int i = MAX_ORDER - 1; i >= 0; i--) { if(!list_empty(&free_list_at(i))) { max_order = i; break; } }
    size_t max_size = 1 << max_order;
    struct Page *p_max = alloc_pages(max_size); assert(p_max != NULL);
    show_buddy_info("After allocating the largest available block");

    //释放最大块，验证内存完全恢复
    free_pages(p_max, max_size); show_buddy_info("After freeing the largest block");
}
static void check_complex_merge(void) {
    cprintf("\n[Test 3: Complex Alloc & Out-of-Order Free]\n");
    struct Page *b0 = alloc_pages(4); struct Page *b1 = alloc_pages(15); struct Page *b2 = alloc_pages(4); struct Page *b3 = alloc_pages(15);
    assert(b0 && b1 && b2 && b3);
    show_buddy_info("After allocating 4 blocks (4, 15, 4, 15 pages)");
    cprintf("--> Freeing b1 (15 pages)...\n"); free_pages(b1, 15); show_buddy_info("State after freeing b1");
    cprintf("--> Freeing b3 (15 pages)...\n"); free_pages(b3, 15); show_buddy_info("State after freeing b3 (should merge with b1)");
    cprintf("--> Freeing b0 (4 pages)...\n"); free_pages(b0, 4); show_buddy_info("State after freeing b0");
    cprintf("--> Freeing b2 (4 pages)...\n"); free_pages(b2, 4); show_buddy_info("State after freeing b2 (should merge with b0, and trigger further merges)");
}
static void buddy_check(void) {
    cprintf("\n=============== BEGIN BUDDY SYSTEM CHECK ===============\n");
    size_t total_pages_initial = buddy_nr_free_pages();
    check_simple_alloc_free();
    assert(buddy_nr_free_pages() == total_pages_initial);
    cprintf(">>> Test 1 PASSED: Memory fully recovered.\n");
    check_edge_cases();
    assert(buddy_nr_free_pages() == total_pages_initial);
    cprintf(">>> Test 2 PASSED: Memory fully recovered.\n");
    check_complex_merge();
    assert(buddy_nr_free_pages() == total_pages_initial);
    cprintf(">>> Test 3 PASSED: Memory fully recovered.\n");
    cprintf("\n=============== BUDDY SYSTEM CHECK SUCCEEDED ===============\n");
}


const struct pmm_manager buddy_system_pmm_manager = {
    .name = "buddy_system_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};

    