#ifndef __KERN_FS_SWAP_SWAPFS_H__
#define __KERN_FS_SWAP_SWAPFS_H__

#include <memlayout.h>

static inline size_t
swap_offset(swap_entry_t entry)
{
    return entry >> 8;
}

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct Page *page);
int swapfs_write(swap_entry_t entry, struct Page *page);

#endif /* !__KERN_FS_SWAP_SWAPFS_H__ */
