#include <pmm.h>
#include <list.h>
#include <string.h>
#include <slub_pmm.h>
#include <memlayout.h>
#include <stdio.h>
#include <best_fit_pmm.h> // Best-Fit PMM

#ifndef offsetof
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#endif

#ifndef container_of
#define container_of(ptr, type, member) ({                      \
    const typeof(((type *)0)->member) * __mptr = (ptr);    \
    (type *)((char *)__mptr - offsetof(type, member)); })
#endif

#ifndef bool
#define bool int
#define true 1
#define false 0
#endif

static free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

//使用标准的 container_of 宏
#define le2slab(le, member) \
    container_of(le, slab_t, member)

// 引用底层 PMM (Best-Fit)
static const struct pmm_manager *base_pmm = &best_fit_pmm_manager;


// 声明外部结构体 (它们在 slub_pmm.h 中已定义并 typedef)
static cache_t caches[3];//简化实现，3个cache
static size_t cache_n=0;//cache计数器

static size_t calculate_objs_num(size_t obj_size) {
    
    size_t slab_struct_size = sizeof(slab_t);
    size_t objects_per_slab = ((PGSIZE - slab_struct_size) / (obj_size + 1.0 / 8.0));
    if (objects_per_slab == 0) {   
        objects_per_slab = 1;
    }
    return objects_per_slab;
}

//为缓存初始化
static void cache_init(void){
    
    cache_n=3;
    size_t sizes[3]={32,64,128};
    for(int i=0;i<cache_n;i++){
        caches[i].obj_size=sizes[i];
        caches[i].objs_num=calculate_objs_num(sizes[i]);
        list_init(&caches[i].slabs);
    }
}


static void
slub_init(void) {
    base_pmm->init();       // 初始化底层 PMM
    cache_init();           // 初始化第二层：SLUB 缓存
}


static void
slub_init_memmap(struct Page *base,size_t n){
    base_pmm->init_memmap(base,n); // 调用底层 PMM 的 init_memmap
}


// SLUB PMM 的页分配封装函数
static struct Page *
slub_alloc_pages(size_t n) {
    return base_pmm->alloc_pages(n);
}

static void
slub_free_pages(struct Page *base, size_t n) {
    base_pmm->free_pages(base, n);
}

static slab_t* create_slab(size_t obj_size,size_t objs_num){
    struct Page* page=base_pmm->alloc_pages(1);
    if(!page)return NULL;
    void* kva=KADDR(page2pa(page));
    slab_t *slab=(slab_t*)kva;
    slab->free_cnt=objs_num;
    slab->objs=(void*)slab+sizeof(slab_t);//指向对象存储区域
    slab->bitmap=(unsigned char*)((void*)slab->objs+obj_size*objs_num);//指向位图区域
    memset(slab->bitmap,0,(objs_num+7)/8);
    list_init(&slab->list);
    return slab;
}


static void* slub_alloc_obj(size_t size){

    if(size<=0) return NULL;

    // ... (查找 Cache 逻辑不变)
    cache_t *cache=NULL;
    for(int i=0;i<cache_n;i++){
        if(caches[i].obj_size>=size){
            cache =&caches[i];
            break;
        }
    }
    if(cache==NULL) return NULL;

    // ... (查找 Slab 和分配对象逻辑不变)
    list_entry_t *le=&cache->slabs;
    while ((le = list_next(le)) != &cache->slabs) {
        slab_t *slab = container_of(le, slab_t, list);
        if (slab->free_cnt > 0) {
            for (size_t i = 0; i < cache->objs_num; i++) {
                size_t byte = i / 8;
                size_t bit = i % 8;
                if (!(slab->bitmap[byte] & (1 << bit))) {
                    slab->bitmap[byte] |= (1 << bit); // 标记为已分配
                    slab->free_cnt--;
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
                }
            }
        }
    }
    
    // 扩容：创建新的 Slab
    slab_t *new_slab=create_slab(cache->obj_size,cache->objs_num);
    if(!new_slab) return NULL;

    list_add(&cache->slabs,&new_slab->list);
    new_slab->bitmap[0] |= 1;
    new_slab->free_cnt--;
    return new_slab->objs;
}

static void
slub_free_obj(void* obj){
    for (size_t i = 0; i < cache_n; i++) {
        cache_t *cache = &caches[i];
        list_entry_t *le = &cache->slabs;
        while ((le = list_next(le)) != &cache->slabs) {
            slab_t *slab = container_of(le, slab_t, list);
            if (obj >= slab->objs && obj < (slab->objs + cache->obj_size * cache->objs_num)) {
                size_t offset = (char*)obj - (char*)slab->objs;
                size_t index = offset / cache->obj_size;
                size_t byte = index / 8;
                size_t bit = index % 8;
                if (slab->bitmap[byte] & (1 << bit)) {
                    slab->bitmap[byte] &= ~(1 << bit); // 标记为未分配
                    slab->free_cnt++;
                    memset(obj, 0, cache->obj_size);//释放清零
                    // 如果整个slab都是空闲的，可以将其释放
                    if (slab->free_cnt == cache->objs_num) {
                        list_del(&slab->list);
                        base_pmm->free_pages(pa2page(PADDR(slab)), 1); // 修正：使用 base_pmm
                    }
                }
                return;
            }
        }
    }
}


static size_t
slub_nr_free_pages(void) {
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
}


static void
slub_check(void) {
    // ... (slub_check 函数体保持不变)
    cprintf("Starting SLUB allocator tests...\n\n");
    cprintf("The slab struct size is %d\n",sizeof(slab_t));
    cprintf("----------------------START-------------------------\n");
    //检查初始化后的大小
    //对于32字节的slab，应该有126obj/slab
    //64字节：63obj/slab
    //128字节，31obj/slab
    size_t nums[3]={126,63,31};
    for(int i=0;i<cache_n;i++){
        assert(caches[i].objs_num==nums[i]);
    }
    size_t nr_1=slub_nr_free_pages(); // 使用 slub_nr_free_pages
    //——————————边界检查
    {
        void* obj=slub_alloc_obj(0);
        assert(obj==NULL);
        obj=slub_alloc_obj(256);
        assert(obj==NULL);
        cprintf("Boundary check passed. \n");
    }
    //——————————分配释放功能检查
    {
        void* obj1=slub_alloc_obj(32);
        assert(obj1!=NULL);
        cprintf("Allocated 32-byte object at %p\n", obj1);
        memset(obj1,0x66,32);
        for(int i=0;i<32;i++){
            assert(((unsigned char*)obj1)[i]==0x66);
        }
        cprintf("Memory alloc verification passed. \n");
        slub_free_obj(obj1);

        void* obj2=slub_alloc_obj(32);
        cprintf("Allocated 32-byte object at %p\n", obj2);
        for(int i = 0; i < 32; i++) {
            assert(((unsigned char*)obj2)[i] == 0x00);
        }
        slub_free_obj(obj2);
        cprintf("Memory free verification passed. \n");
    }
    //——————————多个分配释放功能检查
    {
        const int NUM_TEST_OBJS = 10;
        void* test_objs[NUM_TEST_OBJS];
        cprintf("Allocating %d objects of size 64 bytes.\n", NUM_TEST_OBJS);
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
            test_objs[i] = slub_alloc_obj(64);
            assert(test_objs[i] != NULL);
            // 赋值
            memset(test_objs[i], i, 64);
        }
    
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
            for(int j = 0; j < 64; j++) {
                assert(((unsigned char*)test_objs[i])[j] == (unsigned char)i);
            }
        }
        cprintf("Memory verification for 64-byte objects passed.\n");
        // 释放对象
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
            slub_free_obj(test_objs[i]);
            cprintf("Freed 64-byte object at %p\n", test_objs[i]);
            // 验证内存是否被清零
            for(int j = 0; j < 64; j++) {
                assert(((unsigned char*)test_objs[i])[j] == 0x00);
            }
        }
        cprintf("Memory free verification for 64-byte objects passed.\n");
    }
    //——————————大量分配释放检查
    {
        size_t nr_2,nr_3,nr_4;
        cprintf("Bulk allocation release check start.\n");
        assert(nr_1==slub_nr_free_pages());

        void *objs_bulk[50000];
        for(int i=1;i<=10000;i++){
            objs_bulk[i-1]=slub_alloc_obj(25);
            assert(slub_nr_free_pages()==nr_1-(i+125)/126);
        }
        nr_2=slub_nr_free_pages();
        
        for(int i=1;i<=10000;i++){
            objs_bulk[i+9999]=slub_alloc_obj(62);
            assert(slub_nr_free_pages()==nr_2-(i+62)/63);
        }
        nr_3=slub_nr_free_pages();
    
        for(int i=1;i<=10000;i++){
            objs_bulk[i+19999]=slub_alloc_obj(124);
            assert(slub_nr_free_pages()==nr_3-(i+30)/31);
        }
        nr_4=slub_nr_free_pages();

        for(int i=1;i<=10000;i++){
            objs_bulk[i+29999]=slub_alloc_obj(129+i%666);
            assert(objs_bulk[i+29999]==NULL); 
        }

        for(int i=0;i<40000;i++){
            if(i<30000){
                assert(objs_bulk[i]!=NULL);
                slub_free_obj(objs_bulk[i]);
            }
        }
        assert(slub_nr_free_pages()==nr_1);
        cprintf("Bulk allocation release check passed. (nr_free: %lu)\n", slub_nr_free_pages());
    }
    //——————————复杂流程检查
    {
        cprintf("Mixed check start.\n");

        void* obj1=slub_alloc_obj(32);
        assert(obj1!=NULL);
        cprintf("Allocated 32-byte object at %p\n", obj1);
        assert(slub_nr_free_pages()==nr_1-1);

        void* obj2=slub_alloc_obj(64);
        assert(obj2!=NULL);
        cprintf("Allocated 64-byte object at %p\n", obj2);
        assert(slub_nr_free_pages()==nr_1-2);


        void* obj3=slub_alloc_obj(128);
        assert(obj3!=NULL);
        cprintf("Allocated 128-byte object at %p\n", obj3);
        assert(slub_nr_free_pages()==nr_1-3);


        void* obj4=slub_alloc_obj(32);
        assert(obj4!=NULL);
        cprintf("Allocated second 32-byte object at %p\n", obj4);
        assert(slub_nr_free_pages()==nr_1-3);


        void* objs[100];
        for(int i=1;i<=29;i++){
            objs[i]=slub_alloc_obj(128);
        }

        void* obj5=slub_alloc_obj(128);
        assert(obj5!=NULL);
        cprintf("Allocated 31th 128-byte object at %p\n", obj5);
        assert(slub_nr_free_pages()==nr_1-3);

        void* obj6=slub_alloc_obj(128);
        assert(obj6!=NULL);
        cprintf("Allocated 32th(new slam) 128-byte object at %p\n", obj6);
        assert(slub_nr_free_pages()==nr_1-4);

        for(int i=1;i<=29;i++){
            slub_free_obj(objs[i]);
        }
        assert(slub_nr_free_pages()==nr_1-4);

        slub_free_obj(obj1);
        assert(slub_nr_free_pages()==nr_1-4);

        slub_free_obj(obj2);
        assert(slub_nr_free_pages()==nr_1-3);

        slub_free_obj(obj3);
        assert(slub_nr_free_pages()==nr_1-3);

        slub_free_obj(obj4);
        assert(slub_nr_free_pages()==nr_1-2);

        slub_free_obj(obj5);
        assert(slub_nr_free_pages()==nr_1-1);

        slub_free_obj(obj6);
        assert(slub_nr_free_pages()==nr_1);
    
        cprintf("Mixed check passed.\n");
    }
    cprintf("----------------------END-------------------------\n");
}
const struct pmm_manager slub_pmm_manager = {//配置那些函数
    .name = "slub_pmm_manager",
    .init = slub_init,
    .init_memmap = slub_init_memmap,
    .alloc_pages = slub_alloc_pages, 
    .free_pages = slub_free_pages,   
    .nr_free_pages = slub_nr_free_pages,
    .check = slub_check,
};