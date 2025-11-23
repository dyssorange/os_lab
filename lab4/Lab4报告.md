**分工：**

侯懿轩：练习一代码和练习一报告的书写

姚鑫秋：练习二三代码和练习二报告的书写

苏奕扬：练习三代码和练习三和扩展练习报告的书写

## 练习1：分配并初始化一个进程控制块

### 代码实现

```c++
alloc_proc(void){
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL)
    {
        // LAB4:EXERCISE1 2311076
        /*
         * below fields in proc_struct need to be initialized
         * enum proc_state state;                      // Process state
         * int pid;                                    // Process ID
         * int runs;                                   // the running times of Proces
         * uintptr_t kstack;                           // Process kernel stack
         * volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
         * struct proc_struct *parent;                 // the parent process
         * struct mm_struct *mm;                       // Process's memory management field
         * struct context context;                     // Switch here to run process
         * struct trapframe *tf;                       // Trap frame for current interrupt
         * uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         * uint32_t flags;                             // Process flag
         * char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;      // Process state
        proc->pid = -1;                 // Process ID 
        proc->runs = 0;                 // Running times
        proc->kstack = 0;               // Kernel stack
        proc->need_resched = 0;         // No need to reschedule
        proc->parent = NULL;            // No parent
        proc->mm = NULL;                // No memory management
        memset(&(proc->context), 0, sizeof(struct context)); // Context
        proc->tf = NULL;                // Trap frame
      
        proc->pgdir = boot_pgdir_pa;    // Page directory
        
        proc->flags = 0;                // Process flags
        memset(proc->name, 0, PROC_NAME_LEN + 1); // Process name
        
    }
    return proc;
}
```

在`alloc_proc`函数中，进程控制块的初始化是一个系统性的过程。首先，通过`kmalloc`函数为新的`proc_struct`结构分配内存空间，这是整个初始化过程的基础。如果内存分配成功，就开始对各个字段进行逐一设置。&#x20;

初始化的核心是将进程状态设置为`PROC_UNINIT`，这标志着进程处于未初始化阶段，还不能被调度执行。进程标识符pid被设置为-1，表示尚未分配有效的进程ID，这个值后续会由`get_pid`函数分配唯一的正数值。运行次数`runs`初始化为0，反映出这是一个全新的进程，还未开始执行。

在资源管理方面，内核栈指针`kstack`初始为0，表示尚未分配内核栈空间；`need_resched`标志设为0，说明当前不需要重新调度；父进程指针`parent`设置为`NULL`，表明暂时没有父进程关联。对于内存管理，`mm`指针初始为`NULL`，这是因为在当前的实现中，内核线程共享内核地址空间，不需要独立的内存管理结构。

进程的上下文信息通过`memset`将`context`结构体全部清零，确保没有残留数据影响后续的上下文切换。陷阱帧指针`tf`也初始化为`NULL`，因为此时还没有任何中断或异常上下文需要保存。页目录基址`pgdir`被设置为`boot_pgdir_pa`，这意味着所有内核线程都共享内核的页表，这是内核线程设计的关键特性。

最后，进程标志`flags`清零，进程名称数组通过`memset`全部置为0，确保进程名称字符串以空字符结尾。这些初始化为后续的进程设置和调度做好了准备。

### 问题：请说明proc\_struct中struct context context和struct trapframe \*tf成员变量含义和在本实验中的作用是啥？

###### 1. struct context context

struct context 是进程的上下文结构，用于保存进程切换时需要保存和恢复的CPU寄存器状态。

在代码中的作用：

```c++
// 在 alloc_proc 中初始化
memset(&(proc->context), 0, sizeof(struct context));

// 在 copy_thread 中设置关键寄存器
proc->context.ra = (uintptr_t)forkret;    // 返回地址
proc->context.sp = (uintptr_t)(proc->tf); // 栈指针

// 在 proc_run 中进行上下文切换
switch_to(&(prev->context), &(current->context));
```

* **进程切换时保存现场**：当从进程A切换到进程B时，将进程A的寄存器状态保存到`A->context`中

* **进程切换时恢复现场**：从`B->context`中恢复进程B之前保存的寄存器状态

* **指定新进程的起始执行点**：通过设置`ra（返回地址寄存器）为forkret`，确保新进程第一次被调度时从正确的位置开始执行

###### 2. struct trapframe \*tf

struct trapframe 是陷阱帧结构，用于保存发生中断/异常/系统调用时的完整CPU状态。

```c++
// 在 kernel_thread 中设置初始陷阱帧
memset(&tf, 0, sizeof(struct trapframe));
tf.gpr.s0 = (uintptr_t)fn;        // 保存线程函数指针
tf.gpr.s1 = (uintptr_t)arg;       // 保存线程参数
tf.status = ...;                  // 设置状态寄存器
tf.epc = (uintptr_t)kernel_thread_entry; // 设置入口点

// 在 copy_thread 中复制到进程内核栈顶
proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
*(proc->tf) = *tf;

// 设置子进程的返回值
proc->tf->gpr.a0 = 0;  // 子进程返回0
```

当发生中断、异常或系统调用时，处理器会自动切换到特权模式，此时需要**完整保存被中断程序的执行现场**，**这就是陷阱帧的核心作用**。陷阱帧作为一个完整的内存区域，负责保存发生中断瞬间的所有寄存器状态，包括通用寄存器、程序计数器、状态寄存器等，确保在中断处理完毕后能够精确恢复到中断前的执行状态，实现程序的透明中断和连续执行。

在内核线程的创建过程中，通过**预先设置一个完整的陷阱帧结构**，可以为新创建的内核线程构建一个虚拟的"中断返回"场景。这个精心构造的陷阱帧包含了线程的**入口函数指针、参数信息以及初始的寄存器状态**，当线程第一次被调度执行时，实际上是从这个预设的中断返回路径开始运行，从而实现了线程的顺利启动。

在系统调用的实现机制中，**陷阱帧承担着参数传递的重要作用**。当用户程序通过系统调用陷入内核时，所有的调用参数都保存在陷阱帧的寄存器字段中。**内核通过读取陷阱帧中的特定寄存器来获取用户传递的参数，**&#x5904;理完系统调用后，又将返回值写回陷阱帧的相应位置。这样在返回到用户态时，用户程序就能从正确的寄存器中获取系统调用的执行结果，实现了用户态和内核态之间的无缝参数传递。

对于新创建的进程而言，陷阱帧中&#x7684;**`epc`寄存器指定了进程开始执行的入口地址**。在内核线程的初始化过程中，`epc`被设置为`kernel_thread_entry`函数的地址，这确保了当进程第一次获得`CPU`执行权时，会从指定的入口函数开始执行。这个入口函数会进一步从陷阱帧中提取出实际要执行的函数指针和参数，完成线程函数的调用链，实现了进程执行流程的精确控制。

在`fork`系统调用的实现中，陷阱帧还承担着**区分父子进程**的重要功能。通过设置陷阱帧中**a0寄存器**的不同值，系统能够在返回时让父子进程获得不同的返回值。**子进程的a0寄存器被设置为0，而父进程的a0寄存器保存着新创建子进程的`PID。`**&#x8FD9;种巧妙的设计使得同一个代码路径在返回用户态时，父子进程能够通过检查返回值来采取不同的执行分支，实现了`fork`语义的正确性。

## 练习2：为新创建的内核线程分配资源

完成 `do_fork` 函数的实现，该函数负责创建一个新的内核线程，包括分配进程控制块、内核栈，复制内存管理信息和上下文，并将新线程加入就绪队列。

**根据实验指导书的要求，`do_fork` 函数需要完成以下7个关键步骤：**

1. 调用 `alloc_proc` 分配并初始化进程控制块

2. 调用 `setup_kstack` 为进程分配一个内核栈

3. 调用 `copy_mm` 复制或共享内存管理信息

4. 调用 `copy_thread` 设置进程的中断帧和上下文

5. 将新进程添加到进程链表

6. 将新进程状态设置为就绪态（RUNNABLE）

7. 返回新进程的PID

### 代码实现

在 `kern/process/proc.c` 中实现的 `do_fork` 函数如下：

```c
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }
    ret = -E_NO_MEM;
    
    //alloc_proc分配一个proc_struct
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }
    proc->parent = current;
    
    //setup_kstack为子进程分配内核栈
    if (setup_kstack(proc) != 0) {
        goto bad_fork_cleanup_proc;
    }
    
    //copy_mm复制或共享内存管理信息
    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }
    
    //copy_thread设置进程的中断帧和上下文
    copy_thread(proc, stack, tf);
    
    //将新进程添加到进程列表和哈希表
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        proc->pid = get_pid();
        hash_proc(proc);
        list_add(&proc_list, &(proc->list_link));
        nr_process++;
    }
    local_intr_restore(intr_flag);
    
    //唤醒新进程（设置为RUNNABLE状态）
    wakeup_proc(proc);
    
    //返回新进程的pid
    ret = proc->pid;

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```

### 关键函数分析

#### 1. alloc\_proc 函数

该函数分配并初始化一个进程控制块，将各成员变量设置为初始状态：

```c
static struct proc_struct *alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        proc->state = PROC_UNINIT;
        proc->pid = -1;
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
        proc->tf = NULL;
        proc->pgdir = boot_pgdir;
        proc->flags = 0;
        memset(proc->name, 0, PROC_NAME_LEN);
    }
    return proc;
}
```

#### 2. copy\_thread 函数

该函数设置新进程的中断帧和上下文，是进程创建的关键步骤：

```c
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
    // 在内核栈顶部分配trapframe空间
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
    *(proc->tf) = *tf;
    
    // 将子进程的返回值设置为0
    proc->tf->gpr.a0 = 0;
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
    
    // 设置上下文的返回地址为forkret，栈指针指向trapframe
    proc->context.ra = (uintptr_t)forkret;
    proc->context.sp = (uintptr_t)(proc->tf);
}
```

这里的关键设计是：

* 将中断帧复制到新进程的内核栈顶部

* 将 `a0` 寄存器设置为0，这样子进程从 `do_fork` 返回时会得到0

* 将上下文的 `ra` 设置为 `forkret`，这样进程切换后会跳转到 `forkret` 函数

### 问题

**请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。**

是的，uCore通过 `get_pid()` 函数保证了每个新fork的线程都有唯一的PID。

分析如下：

1. **PID分配机制**：`get_pid()` 函数使用静态变量 `last_pid` 和 `next_safe` 来管理PID分配，确保分配的PID在 `[1, MAX_PID]` 范围内且不重复。

2. **原子性保证**：在 `do_fork` 中调用 `get_pid()` 和将进程加入哈希表、进程链表的操作都在关中断的临界区内完成：

```c
bool intr_flag;
local_intr_save(intr_flag);
{
    proc->pid = get_pid();
    hash_proc(proc);
    list_add(&proc_list, &(proc->list_link));
    nr_process++;
}
local_intr_restore(intr_flag);
```

1. 这保证了PID分配过程的原子性，避免了并发情况下的PID冲突。

2. **冲突检测**：`get_pid()` 函数会遍历进程链表检查PID是否已被使用，如果发现冲突会重新分配：

   * 使用哈希表快速查找PID是否已存在

   * 通过 `next_safe` 变量优化查找范围

   * 当PID用尽时会循环查找可用的PID

因此，uCore的设计确保了每个新创建的线程都能获得一个唯一的ID。

## 练习3：编写proc\_run 函数

### 代码实现

```c
void proc_run(struct proc_struct *proc)
{
    if (proc != current)
    {
        bool intr_flag;
        struct proc_struct *prev = current;
        
        // 步骤 2: 禁用中断
        local_intr_save(intr_flag);
        {
            // 步骤 3: 切换当前进程
            current = proc;
            
            // 步骤 4: 切换页表 (SATP 寄存器)
            //    lsatp() 会加载新进程的页表基址到SATP寄存器
            //    对于内核线程，它们都共享 boot_pgdir_pa
            lsatp(current->pgdir); 
            
            // 步骤 5: 实现上下文切换
            //    保存 prev 进程的上下文到 prev->context
            //    并从 current->context 加载新进程的上下文
            switch_to(&(prev->context), &(current->context));
        }
        // 步骤 6: 允许中断
        local_intr_restore(intr_flag);
    }
}
```

首先，把当前进程指针保存到 `prev`，以便后面把当前的上下文保存到 `prev->context`，并从 `proc->context` 恢复。然后完成中断状态的保存，调用了local\_intr\_save函数，并将保存的中断状态存储在intr\_flag变量中。

然后，开始上下文切换。

* 将current指针更新为要运行的进程proc，这表示从现在起，系统将认为proc是当前正在运行的进程。

* 把当前进程的页表物理地址写入 `satp` 寄存器，从而切换当前的地址空间。

* 调用switch\_to函数，保存当前进程的上下文到 prev->context，并从 current->context 加载新进程的上下文，实现上下文切换。

最后，在完成进程切换相关的核心操作后，通过调用local\_intr\_restore函数，并传入之前保存的中断状态intr\_flag，来恢复系统的中断状态。

### 问题：在本实验的执行过程中，创建且运行了几个内核线程？

本实验里一共创建并运行了 2 个内核线程：

* 第一个内核线程：idleproc

```c
if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
{
    cprintf("alloc_proc() correct!\n");
}

idleproc->pid = 0;
idleproc->state = PROC_RUNNABLE;
idleproc->kstack = (uintptr_t)bootstack;
idleproc->need_resched = 1;
set_proc_name(idleproc, "idle");
nr_process++;

current = idleproc;
```

调用 `alloc_proc()` 创建了一个 **内核线程 idleproc，**&#x624B;动设置它的 pid、state、栈等，将 `current` 指针指向它，这是**第 1 个内核线程**，名字叫 `"idle"`，PID=0。

这个线程之后会在 `kern_init` 末尾调用 `cpu_idle()`，在 while(1) 里作为“空转线程”，负责调度别人（`schedule()`）。

* 第二个内核线程：initproc

```c
int pid = kernel_thread(init_main, "Hello world!!", 0);
if (pid <= 0)
{
    panic("create init_main failed.\n");
}

initproc = find_proc(pid);
set_proc_name(initproc, "init");
```

`kernel_thread(init_main, "Hello world!!", 0)` 会构造一个 trapframe，调用 `do_fork` 创建一个新的 `proc_struct`，给它分配自己的内核栈、初始化 context/pgdir 等，返回它的 pid（这里应该是 1）。

这是**第 2 个内核线程**，入口函数是 `init_main`，后面被命名为 `"init"`，PID=1。

## 扩展练习 Challenge

1. 说明语句`local_intr_save(intr_flag);....local_intr_restore(intr_flag);`是如何实现开关中断的？

两个语句的相关定义如下所示：

```c++
static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

#define local_intr_save(x) \
    do {                   \
        x = __intr_save(); \
    } while (0)
#define local_intr_restore(x) __intr_restore(x);

#endif /* !__KERN_SYNC_SYNC_H__ */
```

当调用local\_intr\_save时，会读取sstatus寄存器，判断SIE位的值，如果该位为1，则说明中断是能进行的，这时需要调用intr\_disable将该位置0，并返回1，将intr\_flag赋值为1；如果该位为0，则说明中断此时已经不能进行，则返回0，将intr\_flag赋值为0。这样就可以保证之后的代码执行时不会发生中断。

当需要恢复中断时，调用local\_intr\_restore，需要判断intr\_flag的值，如果其值为1，则需要调用intr\_enable将sstatus寄存器的SIE位置1，否则该位依然保持0。以此来恢复调用local\_intr\_save之前的SIE的值。

* 深入理解不同分页模式的工作原理

get\_pte()函数（位于`kern/mm/pmm.c`）用于在页表中查找或创建页表项，从而实现对指定线性地址对应的物理页的访问和映射操作。这在操作系统中的分页机制下，是实现虚拟内存与物理内存之间映射关系非常重要的内容。

```c++
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
    if (!(*pdep1 & PTE_V))
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V))
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
}
```

**get\_pte()函数中有两段形式类似的代码， 结合sv32，sv39，sv48的异同，解释这两段代码为什么如此相像。**

在本实验的 RISC-V 分页机制中，get\_pte() 需要根据线性地址 la 逐级遍历页表结构，以找到最终的页表项。
在 Sv32 / Sv39 / Sv48 等模式下，虽然虚拟地址位宽和页表级数不同，但**每一级页表的访问模式是完全相同的**：

* 通过某几位 VPN 作为索引，从当前页表页中取出一个 PTE；

* 若该 PTE 有效，则表示指向下一层页表或最终物理页；

* 若该 PTE 无效而又允许创建，则分配一个新的页表页并用 PTE 指向它。

get\_pte() 中前后两段操作 `pdep1` 和 `pdep0` 的代码结构几乎完全相同，正是这一“逐级索引 + 若无则分配”的模板在两级页表上的两次展开。对于 Sv32，可以将 `PDX1` 理解为高层 VPN 索引（例如 VPN\[1]），`PDX0` 理解为下一层 VPN 索引（VPN\[0]）；而在 Sv39 / Sv48 中，只是页表级数和各级索引位数进一步增加，但每一层的访问逻辑依然是这样的循环模式，因此代码看起来非常相似。

**目前get\_pte()函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？**

**优点：**

* 对调用者很方便，**一站式完成“查找 + 按需创建”**：

  * 建立映射时：直接 `get_pte(pgdir, la, 1)`，内部自动帮你把中间页表建好；

  * 只想查映射时：用 `get_pte(pgdir, la, 0)`，不会修改现有结构。

* 这种“查找与按需创建合并”的写法在实际内核代码中非常常见，接口数量少，代码也比较简洁。

**缺点 ：**

* 同一个函数根据 `create` 标志做两种行为，**语义不够单一**：

  * 一个是“纯查找”，一个是“查找 + 可能修改页表结构”；

  * 如果调用者传错 `create`，可能无意中创建了页表，调试起来比较隐蔽。

* 从“接口职责单一性”的角度看，查找和分配其实是两个概念，放在一个函数里会稍微降低可读性和约束性。

从工程设计角度，可以考虑拆成两个更明确的接口，例如：

* `pte_t *get_pte(pde_t *pgdir, uintptr_t la);`->只查找，不会修改页表结构；

* `pte_t *get_pte_create(pde_t *pgdir, uintptr_t la);`->查找，如缺则负责分配所有中间页表。

这样，调用者一看函数名就知道会不会改变页表状态，在只读场景下也不会误用“带创建”的版本，接口语义更清晰。

## 一些核心宏和结构体说明！！

* `pte_t`/`pde_t`：页表项 / 页目录项类型（本质是 64 位整数，存储物理页号 + 权限位）。

* `PDX1(la)`：从虚拟地址`la`提取**第一级页表索引**（高 9 位）。

* `PDX0(la)`：提取**第二级页表索引**（中间 9 位）。

* `PTX(la)`：提取**第三级页表索引**（低 9 位）。

* `PTE_V`：页表项有效位（表示该页表项指向的下一级页表 / 物理页存在）。

* `PTE_U`：用户态可访问位（权限位）。

* `alloc_page()`：分配一个物理页框（返回`struct Page`指针，内核页管理结构体）。

* `page2pa(page)`：将`struct Page`转换为物理地址（PA）。

* `page2ppn(page)`：将`struct Page`转换为物理页号（PPN，物理地址右移 12 位，因为页大小 4KB）。

* `PDE_ADDR(pde)`：从页目录项中提取纯粹的物理地址（屏蔽权限位，只保留 PPN 部分并左移 12 位）。

* `KADDR(pa)`：将物理地址转换为内核虚拟地址（RISC-V 中内核映射物理内存到固定虚拟地址段，CPU 只能通过虚拟地址访问内存）。

* `PGSIZE`：页大小（通常 4KB，即 0x1000）。

* `pte_create(ppn, flags)`：构造页表项（将 PPN 和权限位组合为 64 位的 pte\_t）。

* `set_page_ref(page, n)`：设置物理页的引用计数（内核管理物理页的关键，防止重复释放）。

* `page_ref_inc(page)`：将物理页的引用计数**加 1**（表示该页被多一个虚拟地址映射）。

* `page_ref_dec(page)`：将物理页的引用计数**减 1**（若减到 0，内核会释放该物理页）。

* `pte2page(pte)`：从页表项（`pte_t`）中提取物理页号，转换为对应的`struct Page *`指针（与`page2ppn`反向操作）。

* `page_remove_pte(pgdir, la, ptep)`：删除虚拟地址`la`对应的页表项映射（清除`PTE_V`位，并将旧物理页的引用计数减 1）。

* `tlb_invalidate(pgdir, la)`：刷新 TLB 中虚拟地址`la`的缓存项（RISC-V 中 TLB 是硬件缓存的虚拟地址到物理地址的映射，页表修改后需手动刷新，否则 CPU 会使用旧的缓存数据）。

* `-E_NO_MEM`：内核错误码，表示 “内存不足”（自定义的负数错误码，区别于正常返回的 0）。

* `perm`：传入的页表项权限位（如读、写、执行权限，与`PTE_V`组合后构成完整的页表项权限）。

* `page_ref(page)`：获取物理页的引用计数值（与`set_page_ref`、`page_ref_inc`、`page_ref_dec`配套的引用计数查询函数）。

* `free_page(page)`：将物理页释放回内核的空闲物理页链表（仅当引用计数为 0 时调用，否则会导致使用中的物理页被错误释放）。

* `static inline`：`page_remove_pte`被声明为静态内联函数，目的是**减少函数调用开销**（因为它会被`page_remove`和`page_insert`频繁调用），且仅在当前源文件中可见。

