#ifndef __KERN_MM_SLUB_PMM_H__
#define __KERN_MM_SLUB_PMM_H__

#include <pmm.h>
#include <list.h>
#include <defs.h>
#include <mmu.h>

// 假设页大小 PGSIZE = 4096，这是 SLUB 内存计算的基础
#define SLAB_PAGES 1 // 每个 Slab 占用 1 个页

// 前向声明
typedef struct cache_s cache_t;

// =========================================================================
// Slab 结构体：代表一个或多个连续的页，包含多个对象
// 与 Page 结构体不同，它位于分配页的起始地址
// =========================================================================

typedef struct slab_s {
    list_entry_t list;       // 链接自身的 (到 cache_t->slabs 列表)
    size_t free_cnt;         // Slab 中空闲对象数量
    void *objs;              // 对象寻址指针 (实际对象数据的起始地址)
    unsigned char *bitmap;   // 位图 (标记对象的使用与否)
    cache_t *cache;          // 指向所属的 kmem_cache
} slab_t;


// =========================================================================
// kmem_cache_t: 针对特定大小对象的内存池
// =========================================================================

typedef struct cache_s {
    list_entry_t cache_link; // 链接所有 kmem_cache (全局列表)
    const char *name;
    size_t obj_size;         // 每个对象的大小
    size_t objs_num;         // 一个 Slab 中可容纳的对象数
    
    list_entry_t slabs;      // 链接 Slab (所有部分/完全空闲的 Slab 列表)
    
    // 统计信息
    size_t slabs_total;      // 总 Slab 数量
    size_t objects_free;     // 当前空闲对象总数 (用于 nr_free_pages/check)
} cache_t;


// =========================================================================
// SLUB PMM Manager 接口
// =========================================================================

// kmem_cache_create - 创建一个新的 kmem_cache
cache_t *kmem_cache_create(const char *name, size_t size, size_t align);

// kmem_cache_destroy - 销毁一个 kmem_cache
void kmem_cache_destroy(cache_t *cache);

// kmem_cache_alloc - 从指定的 cache 中分配一个对象
void *kmem_cache_alloc(cache_t *cache);

// kmem_cache_free - 释放一个对象到指定的 cache
void kmem_cache_free(cache_t *cache, void *obj);

// SLUB PMM 接口，供 pmm.c 使用
extern const struct pmm_manager slub_pmm_manager;

#endif // __KERN_MM_SLUB_PMM_H__