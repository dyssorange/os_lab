**分工：**

苏奕扬：练习1代码和报告的书写

侯懿轩：练习2代码和报告的书写

姚鑫秋：challenge部分的构思和报告的书写

## 练习1：完成读文件操作的实现

### 一、整体设计思路

文件读写以 **磁盘块（Block）** 为基本单位，但用户请求的读写偏移和长度往往不是块对齐的。因此，本函数将整个 I/O 操作划分为三部分：

1. **首块非对齐部分**

2. **中间连续的完整块**

3. **尾块非对齐部分**

通过三段式处理方式，实现任意偏移和长度的正确读写。

### 二、代码实现

首先在文件读写前完成 inode 类型校验、参数合法性检查以及读写边界裁剪，确保读操作不越过文件末尾，写操作不突破文件系统最大文件大小，从而为后续块级 I/O 操作提供安全可靠的边界条件。

```c++
static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->type != SFS_TYPE_DIR);
    off_t endpos = offset + *alenp, blkoff;
    *alenp = 0;
    // calculate the Rd/Wr end position
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    if (offset == endpos) {
        return 0;
    }
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    if (!write) {
        if (offset >= din->size) {
            return 0;
        }
        if (endpos > din->size) {
            endpos = din->size;
        }
    }
```

然后通过函数指针统一读写操作接口，并初始化 I/O 过程中所需的控制变量，同时根据文件偏移与结束位置计算起始逻辑块号及需处理的完整块数量，为后续分块读写操作提供必要的参数准备。

```c++
    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    int ret = 0;
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;          // The NO. of Rd/Wr begin block
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;  // The size of Rd/Wr blocks
```

**首块非对齐部分处理**

当 `offset` 未与块大小对齐时，需先处理从 `offset` 到当前块末尾的部分数据。处理步骤如下：

1. 计算块内偏移 `blkoff`

2. 调用 `sfs_bmap_load_nolock` 获取物理块号

3. 使用 `sfs_buf_op` 执行部分块读写

```verilog
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            return ret;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            return ret;
        }
        alen += size;
        if (nblks == 0) {
            *alenp = alen;
            return 0;
        }
        buf += size;
        blkno ++;
        nblks --;
    }
```

**中间完整块处理**

对于中间对齐的完整块，采用整块读写方式：

1. 通过 `sfs_bmap_load_nolock` 获取磁盘块号

2. 使用 `sfs_block_op` 执行整块读写

3. 更新缓冲区指针及块号

```verilog
    while (nblks > 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            return ret;
        }
        if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
            return ret;
        }
        alen += SFS_BLKSIZE;
        buf += SFS_BLKSIZE;
        blkno ++;
        nblks --;
    }
```

该部分具有最高的 I/O 效率。

**尾块非对齐部分处理**

当结束位置 `endpos` 未与块边界对齐时，需处理最后一个块的前 `endpos % SFS_BLKSIZE` 字节。

该过程与首块处理方式类似，但块内偏移为 0。

```verilog
    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            return ret;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            return ret;
        }
        alen += size;
    }
```

最终将本次实际处理的字节数 `alen` 写回调用者。检查写操作是否超出了原文件大小，如果是，则更新磁盘 inode `din->size`，并将内存 inode `sin` 标记为 `dirty`，表明需要写回磁盘。返回最终状态码 `ret`，上层调用者据此判断操作是否成功。

```verilog
out:
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;// 更新文件大小
        sin->dirty = 1;// 设置dirty位
    }
    return ret;
}
```

## 练习2：完成基于文件系统的执行程序机制的实现

改写proc.c中的load\_icode函数和其他相关函数，实现基于文件系统的执行程序机制。执行：make qemu。如果能看看到sh用户程序的执行界面，则基本成功了。如果在sh用户界面上可以执行`exit`, `hello`（更多用户程序放在`user`目录下）等其他放置在`sfs`文件系统中的其他执行程序，则可以认为本实验基本成功。



### 1. 我们在proc.c文件中改动了以下部分：

* 实现了 `load_icode`：ELF 读取、VMA 映射、段拷贝、BSS 清零、用户栈构建、设置 `trapframe`，并切换到新 `pgdir`

* 新增辅助函数：`copy_to_user_pages、zero_user_pages`（用来往用户地址空间拷贝/清零）

* 用户栈参数大小检查：防止 argv 超过 `USTACKSIZE（stack_limit）`

* `do_execve` 中补了 `sysfile_close(fd)`，成功/失败都关闭



### 2. 新增：ELF 文件随机读取：`load_icode_read`

```c++
// load_icode_read is used by load_icode in LAB8
static int
load_icode_read(int fd, void *buf, size_t len, off_t offset)
{
    int ret;
    if ((ret = sysfile_seek(fd, offset, LSEEK_SET)) != 0)
    {
        return ret;
    }
    if ((ret = sysfile_read(fd, buf, len)) != len)
    {
        return (ret < 0) ? ret : -1;
    }
    return 0;
}

```

这个函数创建的目的是为基于文件系统的 `exec` 提供“按偏移读取 ELF 文件内容”的能力，使装载器能够按 ELF 头与段表描述进行**随机访问**读取。我们封装 `sysfile_seek(fd, offset, LSEEK_SET)` + `sysfile_read(fd, buf, len)`，从而把“读取文件某位置的固定长度数据”抽象为统一函数。

**关键点**：

* ELF 的`  Program Header  `与段内容不一定连续，必须支持 `offset` 定位读取。

* 对 `read` 的返回值进行“读满校验”，避免后续解析使用不完整数据导致非法映射/越界拷贝。

**错误处理**：

* `seek` 失败直接返回错误码。

* `read` 未读满 `len`：若为负值则透传错误码，否则返回 `-1` 表示短读异常。

### 3. 按需分配用户页并写入/清零：`copy_to_user_pages` / `zero_user_pages`

```c++
static int
copy_to_user_pages(pde_t *pgdir, uintptr_t dst, const void *src, size_t len, uint32_t perm)
{
    const uint8_t *s = src;
    while (len > 0)
    {
        uintptr_t page = ROUNDDOWN(dst, PGSIZE);
        size_t page_off = dst - page;
        size_t n = PGSIZE - page_off;
        if (n > len) n = len;

        struct Page *p = get_page(pgdir, page, NULL);
        if (p == NULL)
        {
            if ((p = pgdir_alloc_page(pgdir, page, perm)) == NULL)
            {
                return -E_NO_MEM;
            }
        }
        memcpy((uint8_t *)page2kva(p) + page_off, s, n);
        dst += n; s += n; len -= n;
    }
    return 0;
}

static int
zero_user_pages(pde_t *pgdir, uintptr_t dst, size_t len, uint32_t perm)
{
    while (len > 0)
    {
        uintptr_t page = ROUNDDOWN(dst, PGSIZE);
        size_t page_off = dst - page;
        size_t n = PGSIZE - page_off;
        if (n > len) n = len;

        struct Page *p = get_page(pgdir, page, NULL);
        if (p == NULL)
        {
            if ((p = pgdir_alloc_page(pgdir, page, perm)) == NULL)
            {
                return -E_NO_MEM;
            }
        }
        memset((uint8_t *)page2kva(p) + page_off, 0, n);
        dst += n; len -= n;
    }
    return 0;
}

```

* 按页对齐计算目标页 `page`，并计算页内偏移 `page_off` 与本次处理长度 `n`。

* 通过 `get_page(pgdir, page, NULL)` 检查该用户页是否已存在；若不存在则调用`pgdir_alloc_page(pgdir, page, perm)` 分配并建立映射。

* 分别以 `memcpy` / `memset` 完成写入与清零。

这两个函数在装载段内容与清零 BSS/栈参数时，提供对用户虚拟地址的统一写入方式，并在写入过程中实现**缺页即分配**。我们通过将“页表建立 + 页面分配”隐藏在拷贝/清零的底层函数中，使 `load_icode` 上层逻辑只需关注**ELF 语义**（拷贝 filesz、清零 BSS、构建栈）而不反复处理页表细节。`perm` 由段权限（R/W/X）与用户位（U）决定，确保装载后的页表权限与 ELF 描述一致。



### 4. load\_icode函数核心改动

#### 4.1 新地址空间创建：`mm_create` + `setup_pgdir`

```plain&#x20;text
if ((mm = mm_create()) == NULL)
    {
        return -E_NO_MEM;
    }
    if ((ret = setup_pgdir(mm)) != 0)
    {
        goto bad_destroy_mm;
    }

```

* `mm_create()` 分配并初始化 `mm_struct`。

* `setup_pgdir(mm)` 建立该 mm 的页表根，并准备内核共享映射等基础结构。

错误处理:

`mm_create` 失败直接返回 `-E_NO_MEM`。

`setup_pgdir` 失败跳转 `bad_destroy_mm`，销毁 mm，避免泄漏。

#### 4.2 ELF Header 读取与校验：魔数检查

```plain&#x20;text
if ((ret = load_icode_read(fd, &elf, sizeof(elf), 0)) != 0)
    {
        goto bad_pgdir_cleanup_mm;
    }
    if (elf.e_magic != ELF_MAGIC)
    {
        ret = -E_INVAL;
        goto bad_pgdir_cleanup_mm;
    }

```

从文件起始位置读取 `elfhdr`，并检查 `e_magic` 是否等于 `ELF_MAGIC`,它第一道安全边界，避免将任意文件按 ELF 结构解释导致的异常映射与内存破坏，当读取失败或魔数不匹配均进入 `bad_pgdir_cleanup_mm`，执行统一资源回收。

#### 4.3 Program Header 表读取：为段映射与装载提供描述信息

```c++
if (elf.e_phnum > 0)
    {
        phdrs = kmalloc(sizeof(struct proghdr) * elf.e_phnum);
        if (phdrs == NULL)
        {
            ret = -E_NO_MEM;
            goto bad_pgdir_cleanup_mm;
        }
        for (i = 0; i < elf.e_phnum; i++)
        {
            off_t phoff = elf.e_phoff + i * elf.e_phentsize;
            if ((ret = load_icode_read(fd, &phdrs[i], sizeof(struct proghdr), phoff)) != 0)
            {
                goto bad_pgdir_cleanup_mm;
            }
        }
    }

    if ((buffer = kmalloc(PGSIZE)) == NULL)
    {
        ret = -E_NO_MEM;
        goto bad_pgdir_cleanup_mm;
    }

```

这段代码读取 ELF 的段表，获得每个可装载段的：虚拟地址、文件偏移、filesz/memsz、权限标志等，从而驱动后续 VMA 注册与段拷贝。

* 通过 `e_phentsize` 计算偏移，保证对不同 ELF 头参数的适配性。

* 使用单页缓冲按页循环读段内容，降低实现复杂度且便于错误处理。

实现方式：

为 `phdrs` 分配数组空间。

依据 `e_phoff + i*e_phentsize` 对每个 PHDR 逐条随机读取。

另外分配 `PGSIZE` 的 `buffer` 作为段内容读取的中转页缓冲。

#### 4.4 VMA 映射：先注册段区间与栈区间

```c++
for (i = 0; i < elf.e_phnum; i++)
    {
        struct proghdr *ph = &phdrs[i];
        if (ph->p_type != ELF_PT_LOAD)
        {
            continue;
        }
        if (ph->p_filesz > ph->p_memsz)
        {
            ret = -E_INVAL;
            goto bad_pgdir_cleanup_mm;
        }

        uint32_t vm_flags = 0;
        if (ph->p_flags & ELF_PF_R)
        {
            vm_flags |= VM_READ;
        }
        if (ph->p_flags & ELF_PF_W)
        {
            vm_flags |= VM_WRITE;
        }
        if (ph->p_flags & ELF_PF_X)
        {
            vm_flags |= VM_EXEC;
        }
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
        {
            goto bad_pgdir_cleanup_mm;
        }
    }

    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE,
                      VM_READ | VM_WRITE | VM_STACK, NULL)) != 0)
    {
        goto bad_pgdir_cleanup_mm;
    }

```

这段代码主要实现方式为：

* 遍历 Program Header，只处理 `ELF_PT_LOAD` 段。

* 将 ELF 段标志 `ELF_PF_R/W/X` 转换为 `VM_READ/VM_WRITE/VM_EXEC`，并调用 `mm_map(mm, p_va, p_memsz, ...)` 注册 `[p_va, p_va+p_memsz)`。

* 同时为用户栈注册 `[USTACKTOP-USTACKSIZE, USTACKTOP)`，带 `VM_STACK` 标志。

**关键点**：

* 检查 `p_filesz <= p_memsz`，防止出现不符合 ELF 语义的段导致装载越界。

* “先 VMA，后拷贝/清零”的结构使地址空间布局与实际页分配解耦：VMA 决定合法范围，页表/页面在写入阶段按需建立。

#### 4.5 段拷贝（filesz）与 BSS 清零

```sql
//段拷贝
uintptr_t start = ph->p_va;
uintptr_t end   = ph->p_va + ph->p_filesz;
off_t offset     = ph->p_offset;

while (start < end) {
    size_t to_read = end - start;
    if (to_read > PGSIZE) to_read = PGSIZE;
    if ((ret = load_icode_read(fd, buffer, to_read, offset)) != 0) goto bad_pgdir_cleanup_mm;
    if ((ret = copy_to_user_pages(mm->pgdir, start, buffer, to_read, perm)) != 0) goto bad_pgdir_cleanup_mm;
    start += to_read;
    offset += to_read;
}
//bss清零
end = ph->p_va + ph->p_memsz;
if (start < end) {
    if ((ret = zero_user_pages(mm->pgdir, start, end - start, perm)) != 0)
        goto bad_pgdir_cleanup_mm;
}

```

* 将段标志转换为 PTE 权限 `perm`（包含 `PTE_U`，并按 `R/W/X` 设置）。

* 按页循环读取文件：每次最多读 `PGSIZE` 到 `buffer`，随后调用 `copy_to_user_pages` 写入用户虚拟地址。

* 文件内容写完后，对剩余区间调用 `zero_user_pages` 清零。

我们主要在段拷贝与 BSS 清零阶段通过“写入即分配”的方式隐式建立页表：`copy_to_user_pages/zero_user_pages` 内部遇到缺页会 `pgdir_alloc_page`。而`perm` 在装载阶段统一传递，避免出现“段可执行但 PTE 不可执行”等权限不一致问题。当任意一次文件读取、页面分配或写入失败均跳转 `bad_pgdir_cleanup_mm`，统一释放 `buffer/phdrs` 并撤销 mm 与页表。



#### 4.6 用户栈构建：压入参数字符串与 argv 指针数组

```c++
uintptr_t stacktop = USTACKTOP;
    uintptr_t stack_limit = USTACKTOP - USTACKSIZE + PGSIZE;
    uintptr_t uargv[EXEC_MAX_ARG_NUM];
    for (i = argc - 1; i >= 0; i--)
    {
        size_t len = strnlen(kargv[i], EXEC_MAX_ARG_LEN) + 1;
        if (stacktop - len < stack_limit)
        {
            ret = -E_NO_MEM;
            goto bad_pgdir_cleanup_mm;
        }
        stacktop -= len;
        if ((ret = copy_to_user_pages(mm->pgdir, stacktop, kargv[i], len, PTE_U | PTE_R | PTE_W)) != 0)
        {
            goto bad_pgdir_cleanup_mm;
        }
        uargv[i] = stacktop;
    }

    stacktop = ROUNDDOWN(stacktop, sizeof(uintptr_t));
    size_t argv_size = (argc + 1) * sizeof(uintptr_t);
    if (stacktop - argv_size < stack_limit)
    {
        ret = -E_NO_MEM;
        goto bad_pgdir_cleanup_mm;
    }
    stacktop -= argv_size;
    uintptr_t argv_local[EXEC_MAX_ARG_NUM + 1];
    for (i = 0; i < argc; i++)
    {
        argv_local[i] = uargv[i];
    }
    argv_local[argc] = 0;
    if ((ret = copy_to_user_pages(mm->pgdir, stacktop, argv_local, argv_size, PTE_U | PTE_R | PTE_W)) != 0)
    {
        goto bad_pgdir_cleanup_mm;
    }

```

在这段代码中，以从 `USTACKTOP` 向下增长的顺序，倒序把每个参数字符串拷贝到用户栈，并记录其用户地址到 `uargv[i]`。对齐 `stacktop` 后，再把 `(argc+1)` 个指针组成的 `argv_local[]` 整体拷入用户栈，其中 `argv_local[argc]=0`。参数字符串与 argv 指针数组均落在**用户空间**，并通过 `copy_to_user_pages` 保证对应页存在且可写。这段代码设计的目的是在新进程用户栈上构建 `main(argc, argv)` 所需的参数布局，使用户态程序能以标准 ABI 方式获取参数，当遇到错误时立即回滚（`goto bad_pgdir_cleanup_mm`），避免留下部分写入的栈布局。



#### 4.7 trapframe 设置：入口、栈顶、参数寄存器与特权级返回语义

```plain&#x20;text
uintptr_t sp = ROUNDDOWN(stacktop, 16);
    struct trapframe *tf = current->tf;
    tf->gpr.sp = sp;
    tf->gpr.a0 = argc;
    tf->gpr.a1 = stacktop;
    tf->epc = elf.e_entry;
    tf->status = (read_csr(sstatus) | SSTATUS_SPIE) & ~SSTATUS_SPP & ~SSTATUS_SIE;

```

这段代码完成新程序&#x7684;**“用户态上下文”**&#x8BBE;置，使内核从陷入返回用户态时，CPU 能从 ELF 入口开始执行，并携带正确的 `argc/argv`。

实现步骤：

* `epc = elf.e_entry`：设置用户态 PC。

* `sp` 16 字节对齐后写入 `tf->gpr.sp`。

* 按 RISC-V 调用约定设置 `a0=argc`、`a1=argv`（此处 `a1=stacktop` 指向压入的 argv 数组）。

* 配置 `sstatus`：清 `SPP` 以返回 U-mode，并设置 `SPIE` 等位以满足返回语义。



**trapframe 是 exec 成功与否的最终落点**：段与栈装载完成后，必须用 trapframe 将“下一条用户态指令”和“用户态栈”明确指定，否则无法正确启动新程序。

#### 4.8 安装新 mm 并切换到新页表

```plain&#x20;text
current->mm = mm;
    mm_count_inc(mm);
    current->pgdir = PADDR(mm->pgdir);
    lsatp(current->pgdir);
    flush_tlb();

    if (buffer != NULL)
    {
        kfree(buffer);
    }
    if (phdrs != NULL)
    {
        kfree(phdrs);
    }
    return 0;

```

* 将新 `mm` 绑定到 `current` 并增加引用计数。

* 将 `current->pgdir` 指向新页表根的物理地址。

* 调用 `lsatp` 切换页表寄存器并 `flush_tlb` 刷新 TLB。

* 成功后释放临时缓冲并返回 0。



这段代码目的是使新地址空间立即对 CPU 生效，保证随后的用户态取指/访存均在新页表下进行，从而真正完成 exec 的“程序替换”。

### 5. do\_execve函数补充内容

```sql
path = argv[0];
    unlock_mm(mm);
    files_closeall(current->filesp);

    /* sysfile_open will check the first argument path, thus we have to use a user-space pointer, and argv[0] may be incorrect */
    int fd = -1;
    if ((ret = fd = sysfile_open(path, O_RDONLY)) < 0)
    {
        goto execve_exit;
    }
    if (mm != NULL)
    {
        lsatp(boot_pgdir_pa);
        if (mm_count_dec(mm) == 0)
        {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    ret = -E_NO_MEM;
    ;
    if ((ret = load_icode(fd, argc, kargv)) != 0)
    {
        goto execve_exit;
    }
    sysfile_close(fd);
    put_kargv(argc, kargv);
    set_proc_name(current, local_name);
    return 0;

```

**函数入口改造**的目的是将 exec 的程序来源从“内核内置镜像/固定数据”切换为“文件系统中的 ELF 文件”，从而实现**基于文件系统的执行程序机制**。

**实现**：

* 从 `argv[0]` 取路径并调用 `sysfile_open(path, O_RDONLY)` 获取 `fd`。

* 在释放旧 `mm` 前调用 `lsatp(boot_pgdir_pa)` 切回内核页表，再执行 `exit_mmap/put_pgdir/mm_destroy` 回收旧地址空间。

* 调用 `load_icode(fd, argc, kargv)` 在新 mm 中完成 ELF 装载。

* 成功后关闭 fd、释放 kargv 并更新进程名。

**关键点**：

* “先切回内核页表，再销毁旧 mm”是稳定性关键：避免内核继续运行在即将被回收的用户页表之上。

* `fd → load_icode` 的传递链条，构成了文件系统 exec 的最核心数据通路。

**错误处理**：

* `sysfile_open` 失败直接 `goto execve_exit`。

* `load_icode` 失败同样进入 `execve_exit`，由上层统一清理（如释放 kargv、关闭已打开资源等，取决于你的 `execve_exit` 实现）。



**练习2**实现了一个**基于文件系统（sfs）加载并执行用户程序**的机制：在 `do_execve` 中不再使用内核内置的程序镜像，而是通过 `sysfile_open(path, O_RDONLY)` 打开位于 sfs 中的 ELF 可执行文件，拿到 `fd` 后交给 `load_icode(fd, argc, kargv)` 完成装载；在 `load_icode` 内部新增/使用 `load_icode_read(fd, buf, len, offset)` 以 `seek+read` 的方式按 ELF 结构随机读取 ELF Header 和 Program Header，并对每个 `PT_LOAD` 段先用 `mm_map` 建立 VMA，再按段的 `p_offset/p_filesz` 循环读取文件内容并通过 `copy_to_user_pages` 写入用户虚拟地址（缺页时用 `pgdir_alloc_page` 按需分配并建立映射），同时对 `p_memsz-p_filesz` 的 BSS 区间用 `zero_user_pages` 清零；随后在用户栈上压入参数字符串与 `argv[]` 指针数组，设置 trapframe（`epc=elf.e_entry`、`sp`、`a0=argc`、`a1=argv`、并清 `SPP` 以保证 `sret` 返回 U-mode），最后把新 `mm/pgdir` 安装到当前进程并通过 `lsatp + flush_tlb` 切换到新页表，使 CPU 在新地址空间下从 ELF 入口开始执行。实现“从 sfs 读取 ELF → 装载到新地址空间 → 返回用户态运行”的基于文件系统 exec 机制。

## Challenge 1: 完成基于"UNIX的PIPE机制"的设计方案

### 管道机制概述

UNIX管道是一种进程间通信(IPC)机制,允许一个进程的输出作为另一个进程的输入。管道提供了一个单向的数据流通道,写入端将数据写入管道,读取端从管道中读取数据。管道本质上是一个内核维护的缓冲区,遵循先进先出(FIFO)的原则。

### 数据结构设计

为了在ucore中实现管道机制,需要定义以下核心数据结构:

```c
// 管道缓冲区结构
struct pipe_buffer {
    char *data;                    // 缓冲区数据指针
    size_t size;                   // 缓冲区总大小
    size_t read_pos;               // 当前读位置
    size_t write_pos;              // 当前写位置
    size_t data_count;             // 当前数据量
};

// 管道结构体
struct pipe {
    struct pipe_buffer buffer;     // 管道缓冲区
    semaphore_t read_sem;          // 读信号量(用于同步)
    semaphore_t write_sem;         // 写信号量(用于同步)
    semaphore_t mutex;             // 互斥锁(保护共享数据)
    int reader_count;              // 读端引用计数
    int writer_count;              // 写端引用计数
    bool closed;                   // 管道是否已关闭
};

// 扩展文件结构以支持管道
struct file {
    enum {
        FD_NONE,
        FD_INIT,
        FD_OPENED,
        FD_CLOSED,
        FD_PIPE                    // 新增:管道类型文件
    } status;
    bool readable;
    bool writable;
    int fd;
    off_t pos;
    struct inode *node;
    struct pipe *pipe;             // 新增:指向管道结构的指针
    int open_count;
};
```

### 接口设计

需要提供以下系统调用接口和内核函数:

1. **系统调用接口**

```c
// 创建管道
// 功能: 创建一个新的管道,返回两个文件描述符
// fd[0]: 读端文件描述符
// fd[1]: 写端文件描述符
// 返回: 成功返回0,失败返回-1
int sys_pipe(int *fd);

// 关闭文件描述符(已有系统调用,需扩展以支持管道)
// 功能: 关闭文件描述符,如果是管道需要更新引用计数
// 返回: 成功返回0,失败返回-1
int sys_close(int fd);

// 读取数据(已有系统调用,需扩展以支持管道)
// 功能: 从文件描述符读取数据,如果是管道则从管道缓冲区读取
// 返回: 实际读取的字节数,失败返回-1
ssize_t sys_read(int fd, void *buf, size_t len);

// 写入数据(已有系统调用,需扩展以支持管道)
// 功能: 向文件描述符写入数据,如果是管道则写入管道缓冲区
// 返回: 实际写入的字节数,失败返回-1
ssize_t sys_write(int fd, const void *buf, size_t len);
```

* **内核函数接口**

```c
// 创建管道对象
// 功能: 分配并初始化一个新的管道结构
// 返回: 成功返回管道指针,失败返回NULL
struct pipe *pipe_create(void);

// 销毁管道对象
// 功能: 释放管道占用的资源
void pipe_destroy(struct pipe *pipe);

// 从管道读取数据
// 功能: 从管道缓冲区读取指定长度的数据
// 返回: 实际读取的字节数,失败返回负数错误码
int pipe_read(struct pipe *pipe, void *buf, size_t len);

// 向管道写入数据
// 功能: 向管道缓冲区写入指定长度的数据
// 返回: 实际写入的字节数,失败返回负数错误码
int pipe_write(struct pipe *pipe, const void *buf, size_t len);

// 检查管道是否可读
// 功能: 判断管道中是否有数据可读
// 返回: 有数据返回true,否则返回false
bool pipe_can_read(struct pipe *pipe);

// 检查管道是否可写
// 功能: 判断管道缓冲区是否有空间可写
// 返回: 有空间返回true,否则返回false
bool pipe_can_write(struct pipe *pipe);
```

### 核心实现逻辑

* **管道创建过程(sys\_pipe)**

sys\_pipe系统调用的实现流程如下:

(1) 调用pipe\_create()创建一个新的管道对象,分配固定大小的环形缓冲区(如4KB)。

(2) 初始化管道的同步机制,包括互斥锁mutex(初始值为1)、读信号量read\_sem(初始值为0)和写信号量write\_sem(初始值为缓冲区大小)。

(3) 设置reader\_count和writer\_count均为1,表示有一个读端和一个写端。

(4) 在进程的文件描述符表中分配两个文件描述符,一个用于读端(只读模式),一个用于写端(只写模式)。

(5) 创建两个file结构体,将它们的pipe指针指向同一个管道对象,并设置相应的读写权限。

(6) 将两个文件描述符返回给用户空间。

* **管道读取过程(pipe\_read)**

从管道读取数据的实现需要考虑同步问题:

(1) 获取互斥锁mutex,确保对管道状态的访问是原子的。

(2) 检查管道中是否有数据可读(data\_count > 0)。如果没有数据且所有写端都已关闭(writer\_count == 0),则释放互斥锁并返回0表示EOF。如果没有数据但写端仍然打开,则需要等待。

(3) 如果需要等待,释放互斥锁mutex,然后在read\_sem上等待(down操作)。被唤醒后重新获取互斥锁,继续检查。

(4) 从read\_pos位置开始读取数据,每次读取一个字节并将read\_pos向前移动,采用环形缓冲区方式处理(read\_pos = (read\_pos + 1) % size)。

(5) 更新data\_count减少已读取的字节数。

(6) 对write\_sem执行up操作,唤醒可能在等待写入空间的写进程。

(7) 释放互斥锁mutex,返回实际读取的字节数。

* **管道写入过程(pipe\_write)**

向管道写入数据的实现也需要处理同步:

(1) 获取互斥锁mutex。

(2) 检查所有读端是否都已关闭(reader\_count == 0)。如果是,则产生SIGPIPE信号(在ucore中可能简化为返回错误),释放互斥锁并返回-EPIPE。

(3) 检查管道缓冲区是否有空间(data\_count < size)。如果没有空间,释放互斥锁,在write\_sem上等待,被唤醒后重新获取互斥锁。

(4) 从write\_pos位置开始写入数据,采用环形缓冲区方式(write\_pos = (write\_pos + 1) % size)。

(5) 更新data\_count增加已写入的字节数。

(6) 对read\_sem执行up操作,唤醒可能在等待数据的读进程。

(7) 释放互斥锁,返回实际写入的字节数。

* **管道关闭过程**

当进程关闭管道的某一端时:

(1) 获取互斥锁。

(2) 如果关闭的是读端,将reader\_count减1;如果关闭的是写端,将writer\_count减1。

(3) 如果reader\_count和writer\_count都变为0,调用pipe\_destroy()释放管道资源。

(4) 如果只是一端关闭,唤醒等待在read\_sem和write\_sem上的进程,让它们检测到端口关闭状态并适当处理(读端返回0表示EOF,写端返回错误)。

(5) 释放互斥锁。

### 同步互斥问题处理

管道机制中主要涉及以下同步互斥问题:

* **互斥访问管道状态**

使用互斥锁mutex保护管道结构体中的共享数据(如read\_pos、write\_pos、data\_count等),确保对这些数据的读写操作是原子的,避免出现竞态条件。

* **读者-写者同步**

- 当管道为空时,读进程需要等待直到有数据可读,使用read\_sem信号量实现。读信号量的初始值为0,每次写入数据后执行up操作,读进程在没有数据时执行down操作阻塞。

- 当管道满时,写进程需要等待直到有空间可写,使用write\_sem信号量实现。写信号量的初始值为缓冲区大小,每次写入数据执行down操作,读取数据后执行up操作释放空间。

* **写端关闭检测**

读进程需要能够检测到所有写端都已关闭的情况。通过维护writer\_count引用计数实现,读进程在等待数据前检查writer\_count,如果为0且没有数据则返回EOF。

* **读端关闭检测**

写进程需要能够检测到所有读端都已关闭的情况。通过维护reader\_count引用计数实现,写进程在写入前检查reader\_count,如果为0则返回错误避免无意义的写入。

* **避免死锁**

在实现中始终遵循固定的加锁顺序,先获取互斥锁,再根据需要在信号量上等待。等待前必须释放互斥锁,避免持有锁时等待导致死锁。

### 与VFS的集成

为了将管道集成到ucore的虚拟文件系统中:

(1) 在file结构体中添加pipe类型标识和pipe指针字段。

(2) 扩展sys\_read和sys\_write系统调用,增加对管道类型文件描述符的判断和处理分支。

(3) 修改sys\_close系统调用,增加对管道引用计数的管理逻辑。

(4) 在进程fork时,正确处理管道文件描述符的继承,增加对应的引用计数。

(5) 在进程exit时,确保关闭所有打开的管道文件描述符,正确释放资源。

### 使用示例

用户程序可以通过以下方式使用管道:

```c
int fd[2];
char buf[128];

// 创建管道
if (pipe(fd) < 0) {
    printf("pipe failed\n");
    return -1;
}

int pid = fork();
if (pid == 0) {
    // 子进程: 关闭读端,向写端写入数据
    close(fd[0]);
    write(fd[1], "hello from child", 16);
    close(fd[1]);
    exit(0);
} else {
    // 父进程: 关闭写端,从读端读取数据
    close(fd[1]);
    int n = read(fd[0], buf, sizeof(buf));
    buf[n] = '\0';
    printf("received: %s\n", buf);
    close(fd[0]);
    wait(NULL);
}
```

***

## Challenge 2: 完成基于"UNIX的软连接和硬连接机制"的设计方案

### 链接机制概述

UNIX系统提供了两种链接机制:硬链接(hard link)和符号链接(symbolic link,也称软链接)。硬链接允许一个文件在文件系统中拥有多个文件名,所有硬链接指向同一个inode。软链接是一个特殊类型的文件,其内容是另一个文件的路径名,类似于Windows中的快捷方式。

### 数据结构设计

为了在ucore中实现链接机制,需要对现有数据结构进行扩展:

```c
// 扩展inode结构以支持链接
struct inode {
    // ... 原有字段 ...
    
    uint32_t nlinks;               // 硬链接计数
    uint16_t type;                 // 文件类型(普通文件/目录/符号链接)
    
    // 对于符号链接,使用以下字段存储目标路径
    char *symlink_target;          // 符号链接目标路径
    size_t symlink_len;            // 目标路径长度
};

// 文件类型定义
#define INODE_TYPE_FILE      0x01  // 普通文件
#define INODE_TYPE_DIR       0x02  // 目录
#define INODE_TYPE_SYMLINK   0x03  // 符号链接

// 扩展dirent结构
struct dirent {
    uint32_t ino;                  // inode编号
    char name[SFS_MAX_FNAME_LEN + 1];  // 文件名
    uint16_t type;                 // 文件类型(用于快速判断)
};

// 符号链接在磁盘上的存储格式(在SFS中)
struct sfs_symlink {
    uint32_t target_len;           // 目标路径长度
    char target_path[0];           // 目标路径内容(变长)
};
```

### 接口设计

需要提供以下系统调用接口和内核函数:

1. **系统调用接口**

```c
// 创建硬链接
// 功能: 为oldpath创建一个新的硬链接newpath
// 限制: 不能对目录创建硬链接,不能跨文件系统
// 返回: 成功返回0,失败返回-1
int sys_link(const char *oldpath, const char *newpath);

// 创建符号链接
// 功能: 创建一个符号链接newpath,其内容指向target
// 特点: target可以是任意字符串,可以是不存在的路径
// 返回: 成功返回0,失败返回-1
int sys_symlink(const char *target, const char *newpath);

// 读取符号链接内容
// 功能: 读取符号链接path的目标路径到buf中
// 返回: 成功返回写入buf的字节数,失败返回-1
ssize_t sys_readlink(const char *path, char *buf, size_t bufsiz);

// 删除文件或链接(已有系统调用,需扩展)
// 功能: 删除文件路径,对于硬链接减少引用计数,
//       对于符号链接直接删除,对于普通文件根据引用计数决定是否释放
// 返回: 成功返回0,失败返回-1
int sys_unlink(const char *path);

// 打开文件(已有系统调用,需扩展)
// 功能: 打开文件,如果是符号链接默认追踪到目标文件
// 标志: O_NOFOLLOW - 不追踪符号链接,直接对符号链接操作
// 返回: 成功返回文件描述符,失败返回-1
int sys_open(const char *path, int flags);
```

* **内核函数接口**

```c
// 创建硬链接
// 功能: 在指定目录中为inode创建新的目录项
// 返回: 成功返回0,失败返回错误码
int vfs_link(struct inode *old_inode, struct inode *dir, const char *name);

// 创建符号链接
// 功能: 创建一个新的符号链接inode并初始化其目标路径
// 返回: 成功返回0,失败返回错误码
int vfs_symlink(struct inode *dir, const char *name, const char *target);

// 读取符号链接
// 功能: 读取符号链接inode的目标路径
// 返回: 成功返回读取的字节数,失败返回错误码
int vfs_readlink(struct inode *symlink_inode, char *buf, size_t bufsize);

// 路径解析(需扩展以支持符号链接追踪)
// 功能: 解析路径字符串,自动追踪符号链接
// 参数: follow_links - 是否追踪符号链接
//       max_depth - 最大追踪深度(防止循环链接)
// 返回: 成功返回最终的inode,失败返回错误码
int vfs_lookup(const char *path, struct inode **result, 
               bool follow_links, int max_depth);

// 增加硬链接计数
// 功能: 增加inode的nlinks计数
void inode_ref_inc(struct inode *inode);

// 减少硬链接计数
// 功能: 减少inode的nlinks计数,如果降为0则释放inode
void inode_ref_dec(struct inode *inode);
```

### 核心实现逻辑

* **硬链接创建(sys\_link)**

创建硬链接的实现流程:

(1) 解析oldpath,获取目标文件的inode,确保目标不是目录(UNIX标准不允许对目录创建硬链接以防止循环)。

(2) 解析newpath的父目录,确保父目录存在且有写权限。

(3) 在父目录中检查newpath的文件名是否已存在,如果存在则返回错误EEXIST。

(4) 在父目录中创建新的目录项(dirent),将其inode编号设置为oldpath对应的inode编号。

(5) 增加目标inode的硬链接计数nlinks。

(6) 更新父目录的修改时间,将修改同步到磁盘。

(7) 返回成功。

* **符号链接创建(sys\_symlink)**

创建符号链接的实现流程:

(1) 解析newpath的父目录,确保父目录存在且有写权限。

(2) 在父目录中检查newpath的文件名是否已存在,如果存在则返回错误EEXIST。

(3) 分配一个新的inode,设置其类型为INODE\_TYPE\_SYMLINK,初始化nlinks为1。

(4) 将target路径字符串存储到inode的数据块中。在SFS文件系统中,可以将target存储在第一个数据块,格式为sfs\_symlink结构。

(5) 在父目录中创建新的目录项,指向新分配的符号链接inode。

(6) 更新父目录的修改时间,同步到磁盘。

(7) 返回成功。

* **读取符号链接(sys\_readlink)**

读取符号链接内容的实现:

(1) 解析path,获取其对应的inode,注意这里不应该追踪符号链接(使用O\_NOFOLLOW标志)。

(2) 检查inode类型是否为INODE\_TYPE\_SYMLINK,如果不是则返回错误EINVAL。

(3) 从符号链接inode的数据块中读取目标路径字符串。

(4) 将目标路径拷贝到用户提供的buf中,最多拷贝bufsiz-1个字节,并添加null终止符。

(5) 返回实际拷贝的字节数。

* **删除链接(sys\_unlink)**

删除文件或链接的扩展实现:

(1) 解析path的父目录和文件名,获取要删除的inode(不追踪符号链接)。

(2) 从父目录中删除对应的目录项。

(3) 减少inode的nlinks计数。

(4) 如果是符号链接,释放其存储的目标路径字符串资源。

(5) 如果nlinks降为0,则释放inode占用的所有数据块和inode本身。如果nlinks仍大于0,仅更新inode的元数据。

(6) 更新父目录的修改时间,同步到磁盘。

(7) 返回成功。

* **符号链接追踪(vfs\_lookup扩展)**

路径解析需要支持自动追踪符号链接:

(1) 从根目录或当前目录开始,逐个解析路径的每个分量。

(2) 对于每个分量,在当前目录中查找对应的inode。

(3) 如果找到的inode是符号链接且follow\_links为true,则读取其目标路径。

(4) 递归或循环解析目标路径,继续追踪。为防止无限循环(如A->B, B->A),设置最大追踪深度(通常为8或40),超过则返回错误ELOOP。

(5) 如果目标路径是相对路径,需要相对于符号链接所在目录进行解析。

(6) 继续处理路径的剩余分量,直到解析完成。

(7) 返回最终的inode。

### 同步互斥问题处理

链接机制涉及的主要同步互斥问题:

* **目录修改的互斥**

多个进程可能同时在同一目录中创建或删除链接。需要对目录的inode使用互斥锁保护,确保目录项的创建、查找和删除操作是原子的。具体实现:

* 在SFS中使用inode级别的互斥锁(sfs\_inode->sem)。

* 创建或删除链接前,对父目录的inode加锁。

* 完成操作后释放锁。

- **引用计数的原子更新**

硬链接计数nlinks的增减必须是原子操作,避免竞态条件导致计数错误。可以通过以下方式保证:

* 使用原子操作函数(如atomic\_add, atomic\_sub)更新nlinks。

* 或者在持有inode互斥锁的情况下更新nlinks。

- **符号链接追踪中的竞态**

在追踪符号链接时,符号链接本身或其目标可能被其他进程修改或删除。需要注意:

* 每次读取符号链接内容时,持有符号链接inode的锁。

* 追踪过程中,如果发现目标不存在,应该返回合适的错误(ENOENT)而不是系统崩溃。

* 可以考虑对整个追踪过程加锁,但这可能影响性能,需要权衡。

- **删除链接时的同步**

删除硬链接时,必须确保减少引用计数和释放资源的操作是同步的:

* 对inode加锁后,检查nlinks计数。

* 减少nlinks,如果变为0,在持有锁的情况下释放inode的数据块和inode本身。

* 确保在释放前没有其他进程持有该inode的引用。

- **跨目录操作的死锁避免**

创建链接涉及两个inode(源文件和目标目录),需要避免死锁:

* 采用全局一致的加锁顺序,例如按照inode编号从小到大加锁。

* 如果需要同时锁定多个inode,使用trylock机制,失败时释放已持有的锁并重试。

### 与SFS文件系统的集成

为了将链接机制集成到SFS文件系统中:

* **磁盘格式扩展**

- 在sfs\_disk\_inode结构中添加nlinks字段(32位)和type字段(16位)。

- 对于符号链接,使用第一个数据块存储目标路径,格式为sfs\_symlink结构。

- 在目录项dirent中可以添加type字段用于快速判断文件类型,避免每次都读取inode。

* **inode操作扩展**

- 扩展sfs\_inode结构,添加内存中的nlinks和type字段。

- 在加载inode时,从磁盘读取这些字段。

- 在同步inode时,将这些字段写回磁盘。

* **目录操作扩展**

- 修改sfs\_dirent\_create函数,支持创建指向已存在inode的目录项(用于硬链接)。

- 修改sfs\_dirent\_delete函数,支持删除目录项并更新inode的nlinks。

- 添加sfs\_dirent\_link和sfs\_dirent\_symlink函数,封装具体的链接创建逻辑。

* **路径查找扩展**

- 修改sfs\_lookup函数,增加对符号链接的识别和追踪。

- 添加follow\_links参数,控制是否追踪符号链接。

- 实现循环检测机制,防止无限递归。

### 使用示例

用户程序可以通过以下方式使用链接:

```c
// 创建硬链接
if (link("/home/file.txt", "/home/file_link.txt") < 0) {
    printf("link failed\n");
}

// 创建符号链接
if (symlink("/home/file.txt", "/tmp/file_symlink") < 0) {
    printf("symlink failed\n");
}

// 读取符号链接
char buf[256];
ssize_t len = readlink("/tmp/file_symlink", buf, sizeof(buf) - 1);
if (len >= 0) {
    buf[len] = '\0';
    printf("symlink points to: %s\n", buf);
}

// 打开符号链接(自动追踪到目标文件)
int fd = open("/tmp/file_symlink", O_RDONLY);

// 打开符号链接但不追踪
int fd2 = open("/tmp/file_symlink", O_RDONLY | O_NOFOLLOW);

// 删除链接
unlink("/home/file_link.txt");  // 删除硬链接,nlinks-1
unlink("/tmp/file_symlink");    // 删除符号链接
```

### 实现要点总结

**硬链接的关键点:**

* 所有硬链接共享同一个inode,因此文件内容、权限、时间戳等完全相同。

* 删除一个硬链接只是减少引用计数,只有最后一个链接被删除时才真正释放文件数据。

* 不能对目录创建硬链接,避免文件系统中出现环路。

* 不能跨文件系统创建硬链接,因为inode编号在不同文件系统中没有意义。

**符号链接的关键点:**

* 符号链接本身是一个独立的文件,有自己的inode和数据块。

* 符号链接的内容是目标文件的路径字符串,可以指向任意路径,甚至是不存在的文件。

* 删除符号链接不影响目标文件,删除目标文件会导致符号链接变成悬空链接(dangling link)。

* 符号链接可以跨文件系统,因为它存储的是路径而不是inode编号。

* 需要检测和处理循环符号链接,避免无限循环。

通过以上设计,可以在ucore中实现完整的UNIX链接机制,提供灵活的文件组织和共享方式。
