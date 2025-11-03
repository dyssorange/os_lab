
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	08428293          	addi	t0,t0,132 # ffffffffc0200084 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <test_exceptions>:
    grade_backtrace1(arg0, arg2);
}

void grade_backtrace(void) { grade_backtrace0(0, (uintptr_t)kern_init, 0xffff0000); }

void test_exceptions(void) {
ffffffffc0200054:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    // 测试非法指令异常
    cprintf("Testing illegal instruction exception...\n");
ffffffffc0200056:	00002517          	auipc	a0,0x2
ffffffffc020005a:	fba50513          	addi	a0,a0,-70 # ffffffffc0202010 <etext>
void test_exceptions(void) {
ffffffffc020005e:	e406                	sd	ra,8(sp)
    cprintf("Testing illegal instruction exception...\n");
ffffffffc0200060:	0c2000ef          	jal	ffffffffc0200122 <cprintf>
    asm volatile(".word 0x00000000");  // 非法指令
ffffffffc0200064:	00000000          	.word	0x00000000
    
    // 测试断点异常
    cprintf("Testing breakpoint exception...\n");
ffffffffc0200068:	00002517          	auipc	a0,0x2
ffffffffc020006c:	fd850513          	addi	a0,a0,-40 # ffffffffc0202040 <etext+0x30>
ffffffffc0200070:	0b2000ef          	jal	ffffffffc0200122 <cprintf>
    asm volatile("ebreak");
ffffffffc0200074:	9002                	ebreak
    
    cprintf("All exception tests passed!\n");
    return;
}
ffffffffc0200076:	60a2                	ld	ra,8(sp)
    cprintf("All exception tests passed!\n");
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	ff050513          	addi	a0,a0,-16 # ffffffffc0202068 <etext+0x58>
}
ffffffffc0200080:	0141                	addi	sp,sp,16
    cprintf("All exception tests passed!\n");
ffffffffc0200082:	a045                	j	ffffffffc0200122 <cprintf>

ffffffffc0200084 <kern_init>:
    memset(edata, 0, end - edata);
ffffffffc0200084:	00007517          	auipc	a0,0x7
ffffffffc0200088:	fa450513          	addi	a0,a0,-92 # ffffffffc0207028 <free_area>
ffffffffc020008c:	00007617          	auipc	a2,0x7
ffffffffc0200090:	41460613          	addi	a2,a2,1044 # ffffffffc02074a0 <end>
int kern_init(void) {
ffffffffc0200094:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200096:	8e09                	sub	a2,a2,a0
ffffffffc0200098:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020009a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020009c:	763010ef          	jal	ffffffffc0201ffe <memset>
    dtb_init();
ffffffffc02000a0:	3e2000ef          	jal	ffffffffc0200482 <dtb_init>
    cons_init();  // init the console
ffffffffc02000a4:	3d0000ef          	jal	ffffffffc0200474 <cons_init>
    cputs(message);
ffffffffc02000a8:	00003517          	auipc	a0,0x3
ffffffffc02000ac:	f6850513          	addi	a0,a0,-152 # ffffffffc0203010 <etext+0x1000>
ffffffffc02000b0:	0a8000ef          	jal	ffffffffc0200158 <cputs>
    print_kerninfo();
ffffffffc02000b4:	100000ef          	jal	ffffffffc02001b4 <print_kerninfo>
    idt_init();  // init interrupt descriptor table
ffffffffc02000b8:	71c000ef          	jal	ffffffffc02007d4 <idt_init>
    pmm_init();  // init physical memory management
ffffffffc02000bc:	7d8010ef          	jal	ffffffffc0201894 <pmm_init>
    idt_init();  // init interrupt descriptor table
ffffffffc02000c0:	714000ef          	jal	ffffffffc02007d4 <idt_init>
    clock_init();   // init clock interrupt
ffffffffc02000c4:	36e000ef          	jal	ffffffffc0200432 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc02000c8:	700000ef          	jal	ffffffffc02007c8 <intr_enable>
 cprintf("Before calling test_exceptions()\n");
ffffffffc02000cc:	00002517          	auipc	a0,0x2
ffffffffc02000d0:	fbc50513          	addi	a0,a0,-68 # ffffffffc0202088 <etext+0x78>
ffffffffc02000d4:	04e000ef          	jal	ffffffffc0200122 <cprintf>
test_exceptions();
ffffffffc02000d8:	f7dff0ef          	jal	ffffffffc0200054 <test_exceptions>
cprintf("After calling test_exceptions() - should not reach here if infinite loop\n");
ffffffffc02000dc:	00002517          	auipc	a0,0x2
ffffffffc02000e0:	fd450513          	addi	a0,a0,-44 # ffffffffc02020b0 <etext+0xa0>
ffffffffc02000e4:	03e000ef          	jal	ffffffffc0200122 <cprintf>
    while (1)
ffffffffc02000e8:	a001                	j	ffffffffc02000e8 <kern_init+0x64>

ffffffffc02000ea <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	ec06                	sd	ra,24(sp)
ffffffffc02000ee:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc02000f0:	386000ef          	jal	ffffffffc0200476 <cons_putc>
    (*cnt) ++;
ffffffffc02000f4:	65a2                	ld	a1,8(sp)
}
ffffffffc02000f6:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc02000f8:	419c                	lw	a5,0(a1)
ffffffffc02000fa:	2785                	addiw	a5,a5,1
ffffffffc02000fc:	c19c                	sw	a5,0(a1)
}
ffffffffc02000fe:	6105                	addi	sp,sp,32
ffffffffc0200100:	8082                	ret

ffffffffc0200102 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200102:	1101                	addi	sp,sp,-32
ffffffffc0200104:	862a                	mv	a2,a0
ffffffffc0200106:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200108:	00000517          	auipc	a0,0x0
ffffffffc020010c:	fe250513          	addi	a0,a0,-30 # ffffffffc02000ea <cputch>
ffffffffc0200110:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200112:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200114:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200116:	1c1010ef          	jal	ffffffffc0201ad6 <vprintfmt>
    return cnt;
}
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	4532                	lw	a0,12(sp)
ffffffffc020011e:	6105                	addi	sp,sp,32
ffffffffc0200120:	8082                	ret

ffffffffc0200122 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200122:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200124:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc0200128:	f42e                	sd	a1,40(sp)
ffffffffc020012a:	f832                	sd	a2,48(sp)
ffffffffc020012c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020012e:	862a                	mv	a2,a0
ffffffffc0200130:	004c                	addi	a1,sp,4
ffffffffc0200132:	00000517          	auipc	a0,0x0
ffffffffc0200136:	fb850513          	addi	a0,a0,-72 # ffffffffc02000ea <cputch>
ffffffffc020013a:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc020013c:	ec06                	sd	ra,24(sp)
ffffffffc020013e:	e0ba                	sd	a4,64(sp)
ffffffffc0200140:	e4be                	sd	a5,72(sp)
ffffffffc0200142:	e8c2                	sd	a6,80(sp)
ffffffffc0200144:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc0200146:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc0200148:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020014a:	18d010ef          	jal	ffffffffc0201ad6 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020014e:	60e2                	ld	ra,24(sp)
ffffffffc0200150:	4512                	lw	a0,4(sp)
ffffffffc0200152:	6125                	addi	sp,sp,96
ffffffffc0200154:	8082                	ret

ffffffffc0200156 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200156:	a605                	j	ffffffffc0200476 <cons_putc>

ffffffffc0200158 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200158:	1101                	addi	sp,sp,-32
ffffffffc020015a:	e822                	sd	s0,16(sp)
ffffffffc020015c:	ec06                	sd	ra,24(sp)
ffffffffc020015e:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200160:	00054503          	lbu	a0,0(a0)
ffffffffc0200164:	c51d                	beqz	a0,ffffffffc0200192 <cputs+0x3a>
ffffffffc0200166:	e426                	sd	s1,8(sp)
ffffffffc0200168:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020016a:	4481                	li	s1,0
    cons_putc(c);
ffffffffc020016c:	30a000ef          	jal	ffffffffc0200476 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200170:	00044503          	lbu	a0,0(s0)
ffffffffc0200174:	0405                	addi	s0,s0,1
ffffffffc0200176:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc0200178:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020017a:	f96d                	bnez	a0,ffffffffc020016c <cputs+0x14>
    cons_putc(c);
ffffffffc020017c:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc020017e:	0027841b          	addiw	s0,a5,2
ffffffffc0200182:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc0200184:	2f2000ef          	jal	ffffffffc0200476 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200188:	60e2                	ld	ra,24(sp)
ffffffffc020018a:	8522                	mv	a0,s0
ffffffffc020018c:	6442                	ld	s0,16(sp)
ffffffffc020018e:	6105                	addi	sp,sp,32
ffffffffc0200190:	8082                	ret
    cons_putc(c);
ffffffffc0200192:	4529                	li	a0,10
ffffffffc0200194:	2e2000ef          	jal	ffffffffc0200476 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200198:	4405                	li	s0,1
}
ffffffffc020019a:	60e2                	ld	ra,24(sp)
ffffffffc020019c:	8522                	mv	a0,s0
ffffffffc020019e:	6442                	ld	s0,16(sp)
ffffffffc02001a0:	6105                	addi	sp,sp,32
ffffffffc02001a2:	8082                	ret

ffffffffc02001a4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001a4:	1141                	addi	sp,sp,-16
ffffffffc02001a6:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001a8:	2d6000ef          	jal	ffffffffc020047e <cons_getc>
ffffffffc02001ac:	dd75                	beqz	a0,ffffffffc02001a8 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001ae:	60a2                	ld	ra,8(sp)
ffffffffc02001b0:	0141                	addi	sp,sp,16
ffffffffc02001b2:	8082                	ret

ffffffffc02001b4 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02001b4:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001b6:	00002517          	auipc	a0,0x2
ffffffffc02001ba:	f4a50513          	addi	a0,a0,-182 # ffffffffc0202100 <etext+0xf0>
void print_kerninfo(void) {
ffffffffc02001be:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001c0:	f63ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001c4:	00000597          	auipc	a1,0x0
ffffffffc02001c8:	ec058593          	addi	a1,a1,-320 # ffffffffc0200084 <kern_init>
ffffffffc02001cc:	00002517          	auipc	a0,0x2
ffffffffc02001d0:	f5450513          	addi	a0,a0,-172 # ffffffffc0202120 <etext+0x110>
ffffffffc02001d4:	f4fff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001d8:	00002597          	auipc	a1,0x2
ffffffffc02001dc:	e3858593          	addi	a1,a1,-456 # ffffffffc0202010 <etext>
ffffffffc02001e0:	00002517          	auipc	a0,0x2
ffffffffc02001e4:	f6050513          	addi	a0,a0,-160 # ffffffffc0202140 <etext+0x130>
ffffffffc02001e8:	f3bff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001ec:	00007597          	auipc	a1,0x7
ffffffffc02001f0:	e3c58593          	addi	a1,a1,-452 # ffffffffc0207028 <free_area>
ffffffffc02001f4:	00002517          	auipc	a0,0x2
ffffffffc02001f8:	f6c50513          	addi	a0,a0,-148 # ffffffffc0202160 <etext+0x150>
ffffffffc02001fc:	f27ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200200:	00007597          	auipc	a1,0x7
ffffffffc0200204:	2a058593          	addi	a1,a1,672 # ffffffffc02074a0 <end>
ffffffffc0200208:	00002517          	auipc	a0,0x2
ffffffffc020020c:	f7850513          	addi	a0,a0,-136 # ffffffffc0202180 <etext+0x170>
ffffffffc0200210:	f13ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200214:	00000717          	auipc	a4,0x0
ffffffffc0200218:	e7070713          	addi	a4,a4,-400 # ffffffffc0200084 <kern_init>
ffffffffc020021c:	00007797          	auipc	a5,0x7
ffffffffc0200220:	68378793          	addi	a5,a5,1667 # ffffffffc020789f <end+0x3ff>
ffffffffc0200224:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200226:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020022a:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020022c:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200230:	95be                	add	a1,a1,a5
ffffffffc0200232:	85a9                	srai	a1,a1,0xa
ffffffffc0200234:	00002517          	auipc	a0,0x2
ffffffffc0200238:	f6c50513          	addi	a0,a0,-148 # ffffffffc02021a0 <etext+0x190>
}
ffffffffc020023c:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020023e:	b5d5                	j	ffffffffc0200122 <cprintf>

ffffffffc0200240 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200240:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	f8e60613          	addi	a2,a2,-114 # ffffffffc02021d0 <etext+0x1c0>
ffffffffc020024a:	04d00593          	li	a1,77
ffffffffc020024e:	00002517          	auipc	a0,0x2
ffffffffc0200252:	f9a50513          	addi	a0,a0,-102 # ffffffffc02021e8 <etext+0x1d8>
void print_stackframe(void) {
ffffffffc0200256:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200258:	17c000ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc020025c <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025c:	1101                	addi	sp,sp,-32
ffffffffc020025e:	e822                	sd	s0,16(sp)
ffffffffc0200260:	e426                	sd	s1,8(sp)
ffffffffc0200262:	ec06                	sd	ra,24(sp)
ffffffffc0200264:	00003417          	auipc	s0,0x3
ffffffffc0200268:	dcc40413          	addi	s0,s0,-564 # ffffffffc0203030 <commands>
ffffffffc020026c:	00003497          	auipc	s1,0x3
ffffffffc0200270:	e0c48493          	addi	s1,s1,-500 # ffffffffc0203078 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200274:	6410                	ld	a2,8(s0)
ffffffffc0200276:	600c                	ld	a1,0(s0)
ffffffffc0200278:	00002517          	auipc	a0,0x2
ffffffffc020027c:	f8850513          	addi	a0,a0,-120 # ffffffffc0202200 <etext+0x1f0>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200280:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200282:	ea1ff0ef          	jal	ffffffffc0200122 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200286:	fe9417e3          	bne	s0,s1,ffffffffc0200274 <mon_help+0x18>
    }
    return 0;
}
ffffffffc020028a:	60e2                	ld	ra,24(sp)
ffffffffc020028c:	6442                	ld	s0,16(sp)
ffffffffc020028e:	64a2                	ld	s1,8(sp)
ffffffffc0200290:	4501                	li	a0,0
ffffffffc0200292:	6105                	addi	sp,sp,32
ffffffffc0200294:	8082                	ret

ffffffffc0200296 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200296:	1141                	addi	sp,sp,-16
ffffffffc0200298:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020029a:	f1bff0ef          	jal	ffffffffc02001b4 <print_kerninfo>
    return 0;
}
ffffffffc020029e:	60a2                	ld	ra,8(sp)
ffffffffc02002a0:	4501                	li	a0,0
ffffffffc02002a2:	0141                	addi	sp,sp,16
ffffffffc02002a4:	8082                	ret

ffffffffc02002a6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a6:	1141                	addi	sp,sp,-16
ffffffffc02002a8:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002aa:	f97ff0ef          	jal	ffffffffc0200240 <print_stackframe>
    return 0;
}
ffffffffc02002ae:	60a2                	ld	ra,8(sp)
ffffffffc02002b0:	4501                	li	a0,0
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	8082                	ret

ffffffffc02002b6 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002b6:	7131                	addi	sp,sp,-192
ffffffffc02002b8:	e952                	sd	s4,144(sp)
ffffffffc02002ba:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002bc:	00002517          	auipc	a0,0x2
ffffffffc02002c0:	f5450513          	addi	a0,a0,-172 # ffffffffc0202210 <etext+0x200>
kmonitor(struct trapframe *tf) {
ffffffffc02002c4:	fd06                	sd	ra,184(sp)
ffffffffc02002c6:	f922                	sd	s0,176(sp)
ffffffffc02002c8:	f526                	sd	s1,168(sp)
ffffffffc02002ca:	ed4e                	sd	s3,152(sp)
ffffffffc02002cc:	e556                	sd	s5,136(sp)
ffffffffc02002ce:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002d0:	e53ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002d4:	00002517          	auipc	a0,0x2
ffffffffc02002d8:	f6450513          	addi	a0,a0,-156 # ffffffffc0202238 <etext+0x228>
ffffffffc02002dc:	e47ff0ef          	jal	ffffffffc0200122 <cprintf>
    if (tf != NULL) {
ffffffffc02002e0:	000a0563          	beqz	s4,ffffffffc02002ea <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc02002e4:	8552                	mv	a0,s4
ffffffffc02002e6:	6ce000ef          	jal	ffffffffc02009b4 <print_trapframe>
ffffffffc02002ea:	00003a97          	auipc	s5,0x3
ffffffffc02002ee:	d46a8a93          	addi	s5,s5,-698 # ffffffffc0203030 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc02002f2:	49bd                	li	s3,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002f4:	00002517          	auipc	a0,0x2
ffffffffc02002f8:	f6c50513          	addi	a0,a0,-148 # ffffffffc0202260 <etext+0x250>
ffffffffc02002fc:	341010ef          	jal	ffffffffc0201e3c <readline>
ffffffffc0200300:	842a                	mv	s0,a0
ffffffffc0200302:	d96d                	beqz	a0,ffffffffc02002f4 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200304:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200308:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030a:	e99d                	bnez	a1,ffffffffc0200340 <kmonitor+0x8a>
    int argc = 0;
ffffffffc020030c:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc020030e:	fe0b03e3          	beqz	s6,ffffffffc02002f4 <kmonitor+0x3e>
ffffffffc0200312:	00003497          	auipc	s1,0x3
ffffffffc0200316:	d1e48493          	addi	s1,s1,-738 # ffffffffc0203030 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020031a:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020031c:	6582                	ld	a1,0(sp)
ffffffffc020031e:	6088                	ld	a0,0(s1)
ffffffffc0200320:	471010ef          	jal	ffffffffc0201f90 <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200324:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200326:	c149                	beqz	a0,ffffffffc02003a8 <kmonitor+0xf2>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	2405                	addiw	s0,s0,1
ffffffffc020032a:	04e1                	addi	s1,s1,24
ffffffffc020032c:	fef418e3          	bne	s0,a5,ffffffffc020031c <kmonitor+0x66>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200330:	6582                	ld	a1,0(sp)
ffffffffc0200332:	00002517          	auipc	a0,0x2
ffffffffc0200336:	f5e50513          	addi	a0,a0,-162 # ffffffffc0202290 <etext+0x280>
ffffffffc020033a:	de9ff0ef          	jal	ffffffffc0200122 <cprintf>
    return 0;
ffffffffc020033e:	bf5d                	j	ffffffffc02002f4 <kmonitor+0x3e>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200340:	00002517          	auipc	a0,0x2
ffffffffc0200344:	f2850513          	addi	a0,a0,-216 # ffffffffc0202268 <etext+0x258>
ffffffffc0200348:	4a5010ef          	jal	ffffffffc0201fec <strchr>
ffffffffc020034c:	c901                	beqz	a0,ffffffffc020035c <kmonitor+0xa6>
ffffffffc020034e:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200352:	00040023          	sb	zero,0(s0)
ffffffffc0200356:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200358:	d9d5                	beqz	a1,ffffffffc020030c <kmonitor+0x56>
ffffffffc020035a:	b7dd                	j	ffffffffc0200340 <kmonitor+0x8a>
        if (*buf == '\0') {
ffffffffc020035c:	00044783          	lbu	a5,0(s0)
ffffffffc0200360:	d7d5                	beqz	a5,ffffffffc020030c <kmonitor+0x56>
        if (argc == MAXARGS - 1) {
ffffffffc0200362:	03348b63          	beq	s1,s3,ffffffffc0200398 <kmonitor+0xe2>
        argv[argc ++] = buf;
ffffffffc0200366:	00349793          	slli	a5,s1,0x3
ffffffffc020036a:	978a                	add	a5,a5,sp
ffffffffc020036c:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020036e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200372:	2485                	addiw	s1,s1,1
ffffffffc0200374:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200376:	e591                	bnez	a1,ffffffffc0200382 <kmonitor+0xcc>
ffffffffc0200378:	bf59                	j	ffffffffc020030e <kmonitor+0x58>
ffffffffc020037a:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020037e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200380:	d5d1                	beqz	a1,ffffffffc020030c <kmonitor+0x56>
ffffffffc0200382:	00002517          	auipc	a0,0x2
ffffffffc0200386:	ee650513          	addi	a0,a0,-282 # ffffffffc0202268 <etext+0x258>
ffffffffc020038a:	463010ef          	jal	ffffffffc0201fec <strchr>
ffffffffc020038e:	d575                	beqz	a0,ffffffffc020037a <kmonitor+0xc4>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200390:	00044583          	lbu	a1,0(s0)
ffffffffc0200394:	dda5                	beqz	a1,ffffffffc020030c <kmonitor+0x56>
ffffffffc0200396:	b76d                	j	ffffffffc0200340 <kmonitor+0x8a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200398:	45c1                	li	a1,16
ffffffffc020039a:	00002517          	auipc	a0,0x2
ffffffffc020039e:	ed650513          	addi	a0,a0,-298 # ffffffffc0202270 <etext+0x260>
ffffffffc02003a2:	d81ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc02003a6:	b7c1                	j	ffffffffc0200366 <kmonitor+0xb0>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003a8:	00141793          	slli	a5,s0,0x1
ffffffffc02003ac:	97a2                	add	a5,a5,s0
ffffffffc02003ae:	078e                	slli	a5,a5,0x3
ffffffffc02003b0:	97d6                	add	a5,a5,s5
ffffffffc02003b2:	6b9c                	ld	a5,16(a5)
ffffffffc02003b4:	fffb051b          	addiw	a0,s6,-1
ffffffffc02003b8:	8652                	mv	a2,s4
ffffffffc02003ba:	002c                	addi	a1,sp,8
ffffffffc02003bc:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003be:	f2055be3          	bgez	a0,ffffffffc02002f4 <kmonitor+0x3e>
}
ffffffffc02003c2:	70ea                	ld	ra,184(sp)
ffffffffc02003c4:	744a                	ld	s0,176(sp)
ffffffffc02003c6:	74aa                	ld	s1,168(sp)
ffffffffc02003c8:	69ea                	ld	s3,152(sp)
ffffffffc02003ca:	6a4a                	ld	s4,144(sp)
ffffffffc02003cc:	6aaa                	ld	s5,136(sp)
ffffffffc02003ce:	6b0a                	ld	s6,128(sp)
ffffffffc02003d0:	6129                	addi	sp,sp,192
ffffffffc02003d2:	8082                	ret

ffffffffc02003d4 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003d4:	00007317          	auipc	t1,0x7
ffffffffc02003d8:	06c32303          	lw	t1,108(t1) # ffffffffc0207440 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003dc:	715d                	addi	sp,sp,-80
ffffffffc02003de:	ec06                	sd	ra,24(sp)
ffffffffc02003e0:	f436                	sd	a3,40(sp)
ffffffffc02003e2:	f83a                	sd	a4,48(sp)
ffffffffc02003e4:	fc3e                	sd	a5,56(sp)
ffffffffc02003e6:	e0c2                	sd	a6,64(sp)
ffffffffc02003e8:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003ea:	02031e63          	bnez	t1,ffffffffc0200426 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003ee:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003f0:	103c                	addi	a5,sp,40
ffffffffc02003f2:	e822                	sd	s0,16(sp)
ffffffffc02003f4:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003f6:	862e                	mv	a2,a1
ffffffffc02003f8:	85aa                	mv	a1,a0
ffffffffc02003fa:	00002517          	auipc	a0,0x2
ffffffffc02003fe:	f3e50513          	addi	a0,a0,-194 # ffffffffc0202338 <etext+0x328>
    is_panic = 1;
ffffffffc0200402:	00007697          	auipc	a3,0x7
ffffffffc0200406:	02e6af23          	sw	a4,62(a3) # ffffffffc0207440 <is_panic>
    va_start(ap, fmt);
ffffffffc020040a:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020040c:	d17ff0ef          	jal	ffffffffc0200122 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200410:	65a2                	ld	a1,8(sp)
ffffffffc0200412:	8522                	mv	a0,s0
ffffffffc0200414:	cefff0ef          	jal	ffffffffc0200102 <vcprintf>
    cprintf("\n");
ffffffffc0200418:	00002517          	auipc	a0,0x2
ffffffffc020041c:	f4050513          	addi	a0,a0,-192 # ffffffffc0202358 <etext+0x348>
ffffffffc0200420:	d03ff0ef          	jal	ffffffffc0200122 <cprintf>
ffffffffc0200424:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200426:	3a8000ef          	jal	ffffffffc02007ce <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020042a:	4501                	li	a0,0
ffffffffc020042c:	e8bff0ef          	jal	ffffffffc02002b6 <kmonitor>
    while (1) {
ffffffffc0200430:	bfed                	j	ffffffffc020042a <__panic+0x56>

ffffffffc0200432 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200432:	1141                	addi	sp,sp,-16
ffffffffc0200434:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc0200436:	02000793          	li	a5,32
ffffffffc020043a:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043e:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200442:	67e1                	lui	a5,0x18
ffffffffc0200444:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200448:	953e                	add	a0,a0,a5
ffffffffc020044a:	2c3010ef          	jal	ffffffffc0201f0c <sbi_set_timer>
}
ffffffffc020044e:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200450:	00007797          	auipc	a5,0x7
ffffffffc0200454:	fe07bc23          	sd	zero,-8(a5) # ffffffffc0207448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200458:	00002517          	auipc	a0,0x2
ffffffffc020045c:	f0850513          	addi	a0,a0,-248 # ffffffffc0202360 <etext+0x350>
}
ffffffffc0200460:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200462:	b1c1                	j	ffffffffc0200122 <cprintf>

ffffffffc0200464 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200464:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200468:	67e1                	lui	a5,0x18
ffffffffc020046a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046e:	953e                	add	a0,a0,a5
ffffffffc0200470:	29d0106f          	j	ffffffffc0201f0c <sbi_set_timer>

ffffffffc0200474 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200474:	8082                	ret

ffffffffc0200476 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200476:	0ff57513          	zext.b	a0,a0
ffffffffc020047a:	2790106f          	j	ffffffffc0201ef2 <sbi_console_putchar>

ffffffffc020047e <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc020047e:	2a90106f          	j	ffffffffc0201f26 <sbi_console_getchar>

ffffffffc0200482 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200482:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc0200484:	00002517          	auipc	a0,0x2
ffffffffc0200488:	efc50513          	addi	a0,a0,-260 # ffffffffc0202380 <etext+0x370>
void dtb_init(void) {
ffffffffc020048c:	f406                	sd	ra,40(sp)
ffffffffc020048e:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200490:	c93ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200494:	00007597          	auipc	a1,0x7
ffffffffc0200498:	b6c5b583          	ld	a1,-1172(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	ef450513          	addi	a0,a0,-268 # ffffffffc0202390 <etext+0x380>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004a4:	00007417          	auipc	s0,0x7
ffffffffc02004a8:	b6440413          	addi	s0,s0,-1180 # ffffffffc0207008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004ac:	c77ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004b0:	600c                	ld	a1,0(s0)
ffffffffc02004b2:	00002517          	auipc	a0,0x2
ffffffffc02004b6:	eee50513          	addi	a0,a0,-274 # ffffffffc02023a0 <etext+0x390>
ffffffffc02004ba:	c69ff0ef          	jal	ffffffffc0200122 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02004be:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	ef850513          	addi	a0,a0,-264 # ffffffffc02023b8 <etext+0x3a8>
    if (boot_dtb == 0) {
ffffffffc02004c8:	10070163          	beqz	a4,ffffffffc02005ca <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02004cc:	57f5                	li	a5,-3
ffffffffc02004ce:	07fa                	slli	a5,a5,0x1e
ffffffffc02004d0:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02004d2:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc02004d4:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02004d8:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed8a4d>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004dc:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004e0:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e4:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e8:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f2:	8e49                	or	a2,a2,a0
ffffffffc02004f4:	0ff7f793          	zext.b	a5,a5
ffffffffc02004f8:	8dd1                	or	a1,a1,a2
ffffffffc02004fa:	07a2                	slli	a5,a5,0x8
ffffffffc02004fc:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004fe:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc0200502:	0cd59863          	bne	a1,a3,ffffffffc02005d2 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200506:	4710                	lw	a2,8(a4)
ffffffffc0200508:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020050a:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020050c:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200510:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200514:	01865e1b          	srliw	t3,a2,0x18
ffffffffc0200518:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020051c:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200520:	0186959b          	slliw	a1,a3,0x18
ffffffffc0200524:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200528:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052c:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200530:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200534:	01c56533          	or	a0,a0,t3
ffffffffc0200538:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053c:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200544:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200548:	0ff6f693          	zext.b	a3,a3
ffffffffc020054c:	8c49                	or	s0,s0,a0
ffffffffc020054e:	0622                	slli	a2,a2,0x8
ffffffffc0200550:	8fcd                	or	a5,a5,a1
ffffffffc0200552:	06a2                	slli	a3,a3,0x8
ffffffffc0200554:	8c51                	or	s0,s0,a2
ffffffffc0200556:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200558:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020055a:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020055c:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020055e:	9381                	srli	a5,a5,0x20
ffffffffc0200560:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200562:	4301                	li	t1,0
        switch (token) {
ffffffffc0200564:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200566:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200568:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc020056c:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020056e:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200570:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200574:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200578:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020057c:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200580:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200584:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200588:	8ed1                	or	a3,a3,a2
ffffffffc020058a:	0ff77713          	zext.b	a4,a4
ffffffffc020058e:	8fd5                	or	a5,a5,a3
ffffffffc0200590:	0722                	slli	a4,a4,0x8
ffffffffc0200592:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc0200594:	05178763          	beq	a5,a7,ffffffffc02005e2 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200598:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc020059a:	00f8e963          	bltu	a7,a5,ffffffffc02005ac <dtb_init+0x12a>
ffffffffc020059e:	07c78d63          	beq	a5,t3,ffffffffc0200618 <dtb_init+0x196>
ffffffffc02005a2:	4709                	li	a4,2
ffffffffc02005a4:	00e79763          	bne	a5,a4,ffffffffc02005b2 <dtb_init+0x130>
ffffffffc02005a8:	4301                	li	t1,0
ffffffffc02005aa:	b7d1                	j	ffffffffc020056e <dtb_init+0xec>
ffffffffc02005ac:	4711                	li	a4,4
ffffffffc02005ae:	fce780e3          	beq	a5,a4,ffffffffc020056e <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02005b2:	00002517          	auipc	a0,0x2
ffffffffc02005b6:	ece50513          	addi	a0,a0,-306 # ffffffffc0202480 <etext+0x470>
ffffffffc02005ba:	b69ff0ef          	jal	ffffffffc0200122 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02005be:	64e2                	ld	s1,24(sp)
ffffffffc02005c0:	6942                	ld	s2,16(sp)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	ef650513          	addi	a0,a0,-266 # ffffffffc02024b8 <etext+0x4a8>
}
ffffffffc02005ca:	7402                	ld	s0,32(sp)
ffffffffc02005cc:	70a2                	ld	ra,40(sp)
ffffffffc02005ce:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc02005d0:	be89                	j	ffffffffc0200122 <cprintf>
}
ffffffffc02005d2:	7402                	ld	s0,32(sp)
ffffffffc02005d4:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005d6:	00002517          	auipc	a0,0x2
ffffffffc02005da:	e0250513          	addi	a0,a0,-510 # ffffffffc02023d8 <etext+0x3c8>
}
ffffffffc02005de:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005e0:	b689                	j	ffffffffc0200122 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005e2:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e4:	0087579b          	srliw	a5,a4,0x8
ffffffffc02005e8:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ec:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f0:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f4:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005fc:	8ed1                	or	a3,a3,a2
ffffffffc02005fe:	0ff77713          	zext.b	a4,a4
ffffffffc0200602:	8fd5                	or	a5,a5,a3
ffffffffc0200604:	0722                	slli	a4,a4,0x8
ffffffffc0200606:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200608:	04031463          	bnez	t1,ffffffffc0200650 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc020060c:	1782                	slli	a5,a5,0x20
ffffffffc020060e:	9381                	srli	a5,a5,0x20
ffffffffc0200610:	043d                	addi	s0,s0,15
ffffffffc0200612:	943e                	add	s0,s0,a5
ffffffffc0200614:	9871                	andi	s0,s0,-4
                break;
ffffffffc0200616:	bfa1                	j	ffffffffc020056e <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc0200618:	8522                	mv	a0,s0
ffffffffc020061a:	e01a                	sd	t1,0(sp)
ffffffffc020061c:	141010ef          	jal	ffffffffc0201f5c <strlen>
ffffffffc0200620:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200622:	4619                	li	a2,6
ffffffffc0200624:	8522                	mv	a0,s0
ffffffffc0200626:	00002597          	auipc	a1,0x2
ffffffffc020062a:	dda58593          	addi	a1,a1,-550 # ffffffffc0202400 <etext+0x3f0>
ffffffffc020062e:	197010ef          	jal	ffffffffc0201fc4 <strncmp>
ffffffffc0200632:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200634:	0411                	addi	s0,s0,4
ffffffffc0200636:	0004879b          	sext.w	a5,s1
ffffffffc020063a:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020063c:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200640:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200642:	00a36333          	or	t1,t1,a0
                break;
ffffffffc0200646:	00ff0837          	lui	a6,0xff0
ffffffffc020064a:	488d                	li	a7,3
ffffffffc020064c:	4e05                	li	t3,1
ffffffffc020064e:	b705                	j	ffffffffc020056e <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200650:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200652:	00002597          	auipc	a1,0x2
ffffffffc0200656:	db658593          	addi	a1,a1,-586 # ffffffffc0202408 <etext+0x3f8>
ffffffffc020065a:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200660:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200664:	0187169b          	slliw	a3,a4,0x18
ffffffffc0200668:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066c:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200674:	8ed1                	or	a3,a3,a2
ffffffffc0200676:	0ff77713          	zext.b	a4,a4
ffffffffc020067a:	0722                	slli	a4,a4,0x8
ffffffffc020067c:	8d55                	or	a0,a0,a3
ffffffffc020067e:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200680:	1502                	slli	a0,a0,0x20
ffffffffc0200682:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200684:	954a                	add	a0,a0,s2
ffffffffc0200686:	e01a                	sd	t1,0(sp)
ffffffffc0200688:	109010ef          	jal	ffffffffc0201f90 <strcmp>
ffffffffc020068c:	67a2                	ld	a5,8(sp)
ffffffffc020068e:	473d                	li	a4,15
ffffffffc0200690:	6302                	ld	t1,0(sp)
ffffffffc0200692:	00ff0837          	lui	a6,0xff0
ffffffffc0200696:	488d                	li	a7,3
ffffffffc0200698:	4e05                	li	t3,1
ffffffffc020069a:	f6f779e3          	bgeu	a4,a5,ffffffffc020060c <dtb_init+0x18a>
ffffffffc020069e:	f53d                	bnez	a0,ffffffffc020060c <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02006a0:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02006a4:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02006a8:	00002517          	auipc	a0,0x2
ffffffffc02006ac:	d6850513          	addi	a0,a0,-664 # ffffffffc0202410 <etext+0x400>
           fdt32_to_cpu(x >> 32);
ffffffffc02006b0:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02006b8:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02006bc:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c0:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0187959b          	slliw	a1,a5,0x18
ffffffffc02006c8:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006cc:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d0:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d8:	01037333          	and	t1,t1,a6
ffffffffc02006dc:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e0:	01e5e5b3          	or	a1,a1,t5
ffffffffc02006e4:	0ff7f793          	zext.b	a5,a5
ffffffffc02006e8:	01de6e33          	or	t3,t3,t4
ffffffffc02006ec:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006f0:	01067633          	and	a2,a2,a6
ffffffffc02006f4:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02006f8:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006fc:	07a2                	slli	a5,a5,0x8
ffffffffc02006fe:	0108d89b          	srliw	a7,a7,0x10
ffffffffc0200702:	0186df1b          	srliw	t5,a3,0x18
ffffffffc0200706:	01875e9b          	srliw	t4,a4,0x18
ffffffffc020070a:	8ddd                	or	a1,a1,a5
ffffffffc020070c:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200710:	0186979b          	slliw	a5,a3,0x18
ffffffffc0200714:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200718:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071c:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200720:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200724:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200728:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200730:	08a2                	slli	a7,a7,0x8
ffffffffc0200732:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200736:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073a:	0ff6f693          	zext.b	a3,a3
ffffffffc020073e:	01de6833          	or	a6,t3,t4
ffffffffc0200742:	0ff77713          	zext.b	a4,a4
ffffffffc0200746:	01166633          	or	a2,a2,a7
ffffffffc020074a:	0067e7b3          	or	a5,a5,t1
ffffffffc020074e:	06a2                	slli	a3,a3,0x8
ffffffffc0200750:	01046433          	or	s0,s0,a6
ffffffffc0200754:	0722                	slli	a4,a4,0x8
ffffffffc0200756:	8fd5                	or	a5,a5,a3
ffffffffc0200758:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc020075a:	1582                	slli	a1,a1,0x20
ffffffffc020075c:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020075e:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200760:	9201                	srli	a2,a2,0x20
ffffffffc0200762:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200764:	1402                	slli	s0,s0,0x20
ffffffffc0200766:	00b7e4b3          	or	s1,a5,a1
ffffffffc020076a:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc020076c:	9b7ff0ef          	jal	ffffffffc0200122 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200770:	85a6                	mv	a1,s1
ffffffffc0200772:	00002517          	auipc	a0,0x2
ffffffffc0200776:	cbe50513          	addi	a0,a0,-834 # ffffffffc0202430 <etext+0x420>
ffffffffc020077a:	9a9ff0ef          	jal	ffffffffc0200122 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020077e:	01445613          	srli	a2,s0,0x14
ffffffffc0200782:	85a2                	mv	a1,s0
ffffffffc0200784:	00002517          	auipc	a0,0x2
ffffffffc0200788:	cc450513          	addi	a0,a0,-828 # ffffffffc0202448 <etext+0x438>
ffffffffc020078c:	997ff0ef          	jal	ffffffffc0200122 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200790:	009405b3          	add	a1,s0,s1
ffffffffc0200794:	15fd                	addi	a1,a1,-1
ffffffffc0200796:	00002517          	auipc	a0,0x2
ffffffffc020079a:	cd250513          	addi	a0,a0,-814 # ffffffffc0202468 <etext+0x458>
ffffffffc020079e:	985ff0ef          	jal	ffffffffc0200122 <cprintf>
        memory_base = mem_base;
ffffffffc02007a2:	00007797          	auipc	a5,0x7
ffffffffc02007a6:	ca97bb23          	sd	s1,-842(a5) # ffffffffc0207458 <memory_base>
        memory_size = mem_size;
ffffffffc02007aa:	00007797          	auipc	a5,0x7
ffffffffc02007ae:	ca87b323          	sd	s0,-858(a5) # ffffffffc0207450 <memory_size>
ffffffffc02007b2:	b531                	j	ffffffffc02005be <dtb_init+0x13c>

ffffffffc02007b4 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02007b4:	00007517          	auipc	a0,0x7
ffffffffc02007b8:	ca453503          	ld	a0,-860(a0) # ffffffffc0207458 <memory_base>
ffffffffc02007bc:	8082                	ret

ffffffffc02007be <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02007be:	00007517          	auipc	a0,0x7
ffffffffc02007c2:	c9253503          	ld	a0,-878(a0) # ffffffffc0207450 <memory_size>
ffffffffc02007c6:	8082                	ret

ffffffffc02007c8 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02007c8:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02007cc:	8082                	ret

ffffffffc02007ce <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02007ce:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02007d2:	8082                	ret

ffffffffc02007d4 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02007d4:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02007d8:	00000797          	auipc	a5,0x0
ffffffffc02007dc:	43078793          	addi	a5,a5,1072 # ffffffffc0200c08 <__alltraps>
ffffffffc02007e0:	10579073          	csrw	stvec,a5
}
ffffffffc02007e4:	8082                	ret

ffffffffc02007e6 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007e6:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc02007e8:	1141                	addi	sp,sp,-16
ffffffffc02007ea:	e022                	sd	s0,0(sp)
ffffffffc02007ec:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007ee:	00002517          	auipc	a0,0x2
ffffffffc02007f2:	ce250513          	addi	a0,a0,-798 # ffffffffc02024d0 <etext+0x4c0>
void print_regs(struct pushregs *gpr) {
ffffffffc02007f6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02007f8:	92bff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02007fc:	640c                	ld	a1,8(s0)
ffffffffc02007fe:	00002517          	auipc	a0,0x2
ffffffffc0200802:	cea50513          	addi	a0,a0,-790 # ffffffffc02024e8 <etext+0x4d8>
ffffffffc0200806:	91dff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020080a:	680c                	ld	a1,16(s0)
ffffffffc020080c:	00002517          	auipc	a0,0x2
ffffffffc0200810:	cf450513          	addi	a0,a0,-780 # ffffffffc0202500 <etext+0x4f0>
ffffffffc0200814:	90fff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200818:	6c0c                	ld	a1,24(s0)
ffffffffc020081a:	00002517          	auipc	a0,0x2
ffffffffc020081e:	cfe50513          	addi	a0,a0,-770 # ffffffffc0202518 <etext+0x508>
ffffffffc0200822:	901ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200826:	700c                	ld	a1,32(s0)
ffffffffc0200828:	00002517          	auipc	a0,0x2
ffffffffc020082c:	d0850513          	addi	a0,a0,-760 # ffffffffc0202530 <etext+0x520>
ffffffffc0200830:	8f3ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200834:	740c                	ld	a1,40(s0)
ffffffffc0200836:	00002517          	auipc	a0,0x2
ffffffffc020083a:	d1250513          	addi	a0,a0,-750 # ffffffffc0202548 <etext+0x538>
ffffffffc020083e:	8e5ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200842:	780c                	ld	a1,48(s0)
ffffffffc0200844:	00002517          	auipc	a0,0x2
ffffffffc0200848:	d1c50513          	addi	a0,a0,-740 # ffffffffc0202560 <etext+0x550>
ffffffffc020084c:	8d7ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200850:	7c0c                	ld	a1,56(s0)
ffffffffc0200852:	00002517          	auipc	a0,0x2
ffffffffc0200856:	d2650513          	addi	a0,a0,-730 # ffffffffc0202578 <etext+0x568>
ffffffffc020085a:	8c9ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020085e:	602c                	ld	a1,64(s0)
ffffffffc0200860:	00002517          	auipc	a0,0x2
ffffffffc0200864:	d3050513          	addi	a0,a0,-720 # ffffffffc0202590 <etext+0x580>
ffffffffc0200868:	8bbff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020086c:	642c                	ld	a1,72(s0)
ffffffffc020086e:	00002517          	auipc	a0,0x2
ffffffffc0200872:	d3a50513          	addi	a0,a0,-710 # ffffffffc02025a8 <etext+0x598>
ffffffffc0200876:	8adff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020087a:	682c                	ld	a1,80(s0)
ffffffffc020087c:	00002517          	auipc	a0,0x2
ffffffffc0200880:	d4450513          	addi	a0,a0,-700 # ffffffffc02025c0 <etext+0x5b0>
ffffffffc0200884:	89fff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200888:	6c2c                	ld	a1,88(s0)
ffffffffc020088a:	00002517          	auipc	a0,0x2
ffffffffc020088e:	d4e50513          	addi	a0,a0,-690 # ffffffffc02025d8 <etext+0x5c8>
ffffffffc0200892:	891ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200896:	702c                	ld	a1,96(s0)
ffffffffc0200898:	00002517          	auipc	a0,0x2
ffffffffc020089c:	d5850513          	addi	a0,a0,-680 # ffffffffc02025f0 <etext+0x5e0>
ffffffffc02008a0:	883ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02008a4:	742c                	ld	a1,104(s0)
ffffffffc02008a6:	00002517          	auipc	a0,0x2
ffffffffc02008aa:	d6250513          	addi	a0,a0,-670 # ffffffffc0202608 <etext+0x5f8>
ffffffffc02008ae:	875ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02008b2:	782c                	ld	a1,112(s0)
ffffffffc02008b4:	00002517          	auipc	a0,0x2
ffffffffc02008b8:	d6c50513          	addi	a0,a0,-660 # ffffffffc0202620 <etext+0x610>
ffffffffc02008bc:	867ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc02008c0:	7c2c                	ld	a1,120(s0)
ffffffffc02008c2:	00002517          	auipc	a0,0x2
ffffffffc02008c6:	d7650513          	addi	a0,a0,-650 # ffffffffc0202638 <etext+0x628>
ffffffffc02008ca:	859ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc02008ce:	604c                	ld	a1,128(s0)
ffffffffc02008d0:	00002517          	auipc	a0,0x2
ffffffffc02008d4:	d8050513          	addi	a0,a0,-640 # ffffffffc0202650 <etext+0x640>
ffffffffc02008d8:	84bff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc02008dc:	644c                	ld	a1,136(s0)
ffffffffc02008de:	00002517          	auipc	a0,0x2
ffffffffc02008e2:	d8a50513          	addi	a0,a0,-630 # ffffffffc0202668 <etext+0x658>
ffffffffc02008e6:	83dff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc02008ea:	684c                	ld	a1,144(s0)
ffffffffc02008ec:	00002517          	auipc	a0,0x2
ffffffffc02008f0:	d9450513          	addi	a0,a0,-620 # ffffffffc0202680 <etext+0x670>
ffffffffc02008f4:	82fff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02008f8:	6c4c                	ld	a1,152(s0)
ffffffffc02008fa:	00002517          	auipc	a0,0x2
ffffffffc02008fe:	d9e50513          	addi	a0,a0,-610 # ffffffffc0202698 <etext+0x688>
ffffffffc0200902:	821ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200906:	704c                	ld	a1,160(s0)
ffffffffc0200908:	00002517          	auipc	a0,0x2
ffffffffc020090c:	da850513          	addi	a0,a0,-600 # ffffffffc02026b0 <etext+0x6a0>
ffffffffc0200910:	813ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200914:	744c                	ld	a1,168(s0)
ffffffffc0200916:	00002517          	auipc	a0,0x2
ffffffffc020091a:	db250513          	addi	a0,a0,-590 # ffffffffc02026c8 <etext+0x6b8>
ffffffffc020091e:	805ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200922:	784c                	ld	a1,176(s0)
ffffffffc0200924:	00002517          	auipc	a0,0x2
ffffffffc0200928:	dbc50513          	addi	a0,a0,-580 # ffffffffc02026e0 <etext+0x6d0>
ffffffffc020092c:	ff6ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200930:	7c4c                	ld	a1,184(s0)
ffffffffc0200932:	00002517          	auipc	a0,0x2
ffffffffc0200936:	dc650513          	addi	a0,a0,-570 # ffffffffc02026f8 <etext+0x6e8>
ffffffffc020093a:	fe8ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc020093e:	606c                	ld	a1,192(s0)
ffffffffc0200940:	00002517          	auipc	a0,0x2
ffffffffc0200944:	dd050513          	addi	a0,a0,-560 # ffffffffc0202710 <etext+0x700>
ffffffffc0200948:	fdaff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc020094c:	646c                	ld	a1,200(s0)
ffffffffc020094e:	00002517          	auipc	a0,0x2
ffffffffc0200952:	dda50513          	addi	a0,a0,-550 # ffffffffc0202728 <etext+0x718>
ffffffffc0200956:	fccff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc020095a:	686c                	ld	a1,208(s0)
ffffffffc020095c:	00002517          	auipc	a0,0x2
ffffffffc0200960:	de450513          	addi	a0,a0,-540 # ffffffffc0202740 <etext+0x730>
ffffffffc0200964:	fbeff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200968:	6c6c                	ld	a1,216(s0)
ffffffffc020096a:	00002517          	auipc	a0,0x2
ffffffffc020096e:	dee50513          	addi	a0,a0,-530 # ffffffffc0202758 <etext+0x748>
ffffffffc0200972:	fb0ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200976:	706c                	ld	a1,224(s0)
ffffffffc0200978:	00002517          	auipc	a0,0x2
ffffffffc020097c:	df850513          	addi	a0,a0,-520 # ffffffffc0202770 <etext+0x760>
ffffffffc0200980:	fa2ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200984:	746c                	ld	a1,232(s0)
ffffffffc0200986:	00002517          	auipc	a0,0x2
ffffffffc020098a:	e0250513          	addi	a0,a0,-510 # ffffffffc0202788 <etext+0x778>
ffffffffc020098e:	f94ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200992:	786c                	ld	a1,240(s0)
ffffffffc0200994:	00002517          	auipc	a0,0x2
ffffffffc0200998:	e0c50513          	addi	a0,a0,-500 # ffffffffc02027a0 <etext+0x790>
ffffffffc020099c:	f86ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009a0:	7c6c                	ld	a1,248(s0)
}
ffffffffc02009a2:	6402                	ld	s0,0(sp)
ffffffffc02009a4:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009a6:	00002517          	auipc	a0,0x2
ffffffffc02009aa:	e1250513          	addi	a0,a0,-494 # ffffffffc02027b8 <etext+0x7a8>
}
ffffffffc02009ae:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02009b0:	f72ff06f          	j	ffffffffc0200122 <cprintf>

ffffffffc02009b4 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc02009b4:	1141                	addi	sp,sp,-16
ffffffffc02009b6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02009b8:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc02009ba:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc02009bc:	00002517          	auipc	a0,0x2
ffffffffc02009c0:	e1450513          	addi	a0,a0,-492 # ffffffffc02027d0 <etext+0x7c0>
void print_trapframe(struct trapframe *tf) {
ffffffffc02009c4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02009c6:	f5cff0ef          	jal	ffffffffc0200122 <cprintf>
    print_regs(&tf->gpr);
ffffffffc02009ca:	8522                	mv	a0,s0
ffffffffc02009cc:	e1bff0ef          	jal	ffffffffc02007e6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc02009d0:	10043583          	ld	a1,256(s0)
ffffffffc02009d4:	00002517          	auipc	a0,0x2
ffffffffc02009d8:	e1450513          	addi	a0,a0,-492 # ffffffffc02027e8 <etext+0x7d8>
ffffffffc02009dc:	f46ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc02009e0:	10843583          	ld	a1,264(s0)
ffffffffc02009e4:	00002517          	auipc	a0,0x2
ffffffffc02009e8:	e1c50513          	addi	a0,a0,-484 # ffffffffc0202800 <etext+0x7f0>
ffffffffc02009ec:	f36ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc02009f0:	11043583          	ld	a1,272(s0)
ffffffffc02009f4:	00002517          	auipc	a0,0x2
ffffffffc02009f8:	e2450513          	addi	a0,a0,-476 # ffffffffc0202818 <etext+0x808>
ffffffffc02009fc:	f26ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a00:	11843583          	ld	a1,280(s0)
}
ffffffffc0200a04:	6402                	ld	s0,0(sp)
ffffffffc0200a06:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a08:	00002517          	auipc	a0,0x2
ffffffffc0200a0c:	e2850513          	addi	a0,a0,-472 # ffffffffc0202830 <etext+0x820>
}
ffffffffc0200a10:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a12:	f10ff06f          	j	ffffffffc0200122 <cprintf>

ffffffffc0200a16 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc0200a16:	11853783          	ld	a5,280(a0)
ffffffffc0200a1a:	472d                	li	a4,11
ffffffffc0200a1c:	0786                	slli	a5,a5,0x1
ffffffffc0200a1e:	8385                	srli	a5,a5,0x1
ffffffffc0200a20:	0af76a63          	bltu	a4,a5,ffffffffc0200ad4 <interrupt_handler+0xbe>
ffffffffc0200a24:	00002717          	auipc	a4,0x2
ffffffffc0200a28:	65470713          	addi	a4,a4,1620 # ffffffffc0203078 <commands+0x48>
ffffffffc0200a2c:	078a                	slli	a5,a5,0x2
ffffffffc0200a2e:	97ba                	add	a5,a5,a4
ffffffffc0200a30:	439c                	lw	a5,0(a5)
ffffffffc0200a32:	97ba                	add	a5,a5,a4
ffffffffc0200a34:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a36:	00002517          	auipc	a0,0x2
ffffffffc0200a3a:	e7250513          	addi	a0,a0,-398 # ffffffffc02028a8 <etext+0x898>
ffffffffc0200a3e:	ee4ff06f          	j	ffffffffc0200122 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200a42:	00002517          	auipc	a0,0x2
ffffffffc0200a46:	e4650513          	addi	a0,a0,-442 # ffffffffc0202888 <etext+0x878>
ffffffffc0200a4a:	ed8ff06f          	j	ffffffffc0200122 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200a4e:	00002517          	auipc	a0,0x2
ffffffffc0200a52:	dfa50513          	addi	a0,a0,-518 # ffffffffc0202848 <etext+0x838>
ffffffffc0200a56:	eccff06f          	j	ffffffffc0200122 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200a5a:	00002517          	auipc	a0,0x2
ffffffffc0200a5e:	e6e50513          	addi	a0,a0,-402 # ffffffffc02028c8 <etext+0x8b8>
ffffffffc0200a62:	ec0ff06f          	j	ffffffffc0200122 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a66:	1141                	addi	sp,sp,-16
ffffffffc0200a68:	e406                	sd	ra,8(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();
ffffffffc0200a6a:	9fbff0ef          	jal	ffffffffc0200464 <clock_set_next_event>
            ticks++;
ffffffffc0200a6e:	00007797          	auipc	a5,0x7
ffffffffc0200a72:	9da78793          	addi	a5,a5,-1574 # ffffffffc0207448 <ticks>
ffffffffc0200a76:	6394                	ld	a3,0(a5)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a78:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200a7c:	28f70713          	addi	a4,a4,655 # 28f5c28f <kern_entry-0xffffffff972a3d71>
            ticks++;
ffffffffc0200a80:	0685                	addi	a3,a3,1
ffffffffc0200a82:	e394                	sd	a3,0(a5)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200a84:	6390                	ld	a2,0(a5)
ffffffffc0200a86:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200a8a:	1702                	slli	a4,a4,0x20
ffffffffc0200a8c:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <kern_entry-0xffffffff63f70a3d>
ffffffffc0200a90:	00265793          	srli	a5,a2,0x2
ffffffffc0200a94:	9736                	add	a4,a4,a3
ffffffffc0200a96:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200a9a:	06400593          	li	a1,100
ffffffffc0200a9e:	8389                	srli	a5,a5,0x2
ffffffffc0200aa0:	02b787b3          	mul	a5,a5,a1
ffffffffc0200aa4:	02f60963          	beq	a2,a5,ffffffffc0200ad6 <interrupt_handler+0xc0>
                print_ticks();
                num++;
            }
            if (num == 10) {
ffffffffc0200aa8:	00007797          	auipc	a5,0x7
ffffffffc0200aac:	9b87a783          	lw	a5,-1608(a5) # ffffffffc0207460 <num>
ffffffffc0200ab0:	4729                	li	a4,10
ffffffffc0200ab2:	04e78263          	beq	a5,a4,ffffffffc0200af6 <interrupt_handler+0xe0>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200ab6:	60a2                	ld	ra,8(sp)
ffffffffc0200ab8:	0141                	addi	sp,sp,16
ffffffffc0200aba:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200abc:	00002517          	auipc	a0,0x2
ffffffffc0200ac0:	e3450513          	addi	a0,a0,-460 # ffffffffc02028f0 <etext+0x8e0>
ffffffffc0200ac4:	e5eff06f          	j	ffffffffc0200122 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200ac8:	00002517          	auipc	a0,0x2
ffffffffc0200acc:	da050513          	addi	a0,a0,-608 # ffffffffc0202868 <etext+0x858>
ffffffffc0200ad0:	e52ff06f          	j	ffffffffc0200122 <cprintf>
            print_trapframe(tf);
ffffffffc0200ad4:	b5c5                	j	ffffffffc02009b4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200ad6:	00002517          	auipc	a0,0x2
ffffffffc0200ada:	e0a50513          	addi	a0,a0,-502 # ffffffffc02028e0 <etext+0x8d0>
ffffffffc0200ade:	e44ff0ef          	jal	ffffffffc0200122 <cprintf>
                num++;
ffffffffc0200ae2:	00007797          	auipc	a5,0x7
ffffffffc0200ae6:	97e7a783          	lw	a5,-1666(a5) # ffffffffc0207460 <num>
ffffffffc0200aea:	2785                	addiw	a5,a5,1
ffffffffc0200aec:	00007717          	auipc	a4,0x7
ffffffffc0200af0:	96f72a23          	sw	a5,-1676(a4) # ffffffffc0207460 <num>
ffffffffc0200af4:	bf75                	j	ffffffffc0200ab0 <interrupt_handler+0x9a>
}
ffffffffc0200af6:	60a2                	ld	ra,8(sp)
ffffffffc0200af8:	0141                	addi	sp,sp,16
                sbi_shutdown();
ffffffffc0200afa:	4480106f          	j	ffffffffc0201f42 <sbi_shutdown>

ffffffffc0200afe <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200afe:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200b02:	1141                	addi	sp,sp,-16
ffffffffc0200b04:	e022                	sd	s0,0(sp)
ffffffffc0200b06:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200b08:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200b0a:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200b0c:	06e78763          	beq	a5,a4,ffffffffc0200b7a <exception_handler+0x7c>
ffffffffc0200b10:	04f76963          	bltu	a4,a5,ffffffffc0200b62 <exception_handler+0x64>
ffffffffc0200b14:	4709                	li	a4,2
ffffffffc0200b16:	04e79a63          	bne	a5,a4,ffffffffc0200b6a <exception_handler+0x6c>
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
             // 非法指令异常处理
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200b1a:	10853583          	ld	a1,264(a0)
ffffffffc0200b1e:	00002517          	auipc	a0,0x2
ffffffffc0200b22:	df250513          	addi	a0,a0,-526 # ffffffffc0202910 <etext+0x900>
ffffffffc0200b26:	dfcff0ef          	jal	ffffffffc0200122 <cprintf>
            cprintf("Exception type: Illegal instruction\n");
ffffffffc0200b2a:	00002517          	auipc	a0,0x2
ffffffffc0200b2e:	e0e50513          	addi	a0,a0,-498 # ffffffffc0202938 <etext+0x928>
ffffffffc0200b32:	df0ff0ef          	jal	ffffffffc0200122 <cprintf>
            cprintf("Before update: epc = 0x%08x\n", tf->epc);
ffffffffc0200b36:	10843583          	ld	a1,264(s0)
ffffffffc0200b3a:	00002517          	auipc	a0,0x2
ffffffffc0200b3e:	e2650513          	addi	a0,a0,-474 # ffffffffc0202960 <etext+0x950>
ffffffffc0200b42:	de0ff0ef          	jal	ffffffffc0200122 <cprintf>
            tf->epc += 4;
ffffffffc0200b46:	10843583          	ld	a1,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b4a:	60a2                	ld	ra,8(sp)
            cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200b4c:	00002517          	auipc	a0,0x2
ffffffffc0200b50:	e3450513          	addi	a0,a0,-460 # ffffffffc0202980 <etext+0x970>
            tf->epc += 4;
ffffffffc0200b54:	0591                	addi	a1,a1,4
ffffffffc0200b56:	10b43423          	sd	a1,264(s0)
}
ffffffffc0200b5a:	6402                	ld	s0,0(sp)
ffffffffc0200b5c:	0141                	addi	sp,sp,16
    cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200b5e:	dc4ff06f          	j	ffffffffc0200122 <cprintf>
    switch (tf->cause) {
ffffffffc0200b62:	17f1                	addi	a5,a5,-4
ffffffffc0200b64:	471d                	li	a4,7
ffffffffc0200b66:	00f76663          	bltu	a4,a5,ffffffffc0200b72 <exception_handler+0x74>
}
ffffffffc0200b6a:	60a2                	ld	ra,8(sp)
ffffffffc0200b6c:	6402                	ld	s0,0(sp)
ffffffffc0200b6e:	0141                	addi	sp,sp,16
ffffffffc0200b70:	8082                	ret
ffffffffc0200b72:	6402                	ld	s0,0(sp)
ffffffffc0200b74:	60a2                	ld	ra,8(sp)
ffffffffc0200b76:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200b78:	bd35                	j	ffffffffc02009b4 <print_trapframe>
            cprintf("=== BREAKPOINT EXCEPTION ===\n");
ffffffffc0200b7a:	00002517          	auipc	a0,0x2
ffffffffc0200b7e:	e2650513          	addi	a0,a0,-474 # ffffffffc02029a0 <etext+0x990>
ffffffffc0200b82:	da0ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200b86:	10843583          	ld	a1,264(s0)
ffffffffc0200b8a:	00002517          	auipc	a0,0x2
ffffffffc0200b8e:	e3650513          	addi	a0,a0,-458 # ffffffffc02029c0 <etext+0x9b0>
ffffffffc0200b92:	d90ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Exception type: breakpoint\n");
ffffffffc0200b96:	00002517          	auipc	a0,0x2
ffffffffc0200b9a:	e4a50513          	addi	a0,a0,-438 # ffffffffc02029e0 <etext+0x9d0>
ffffffffc0200b9e:	d84ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Before update: epc = 0x%08x\n", tf->epc);
ffffffffc0200ba2:	10843583          	ld	a1,264(s0)
ffffffffc0200ba6:	00002517          	auipc	a0,0x2
ffffffffc0200baa:	dba50513          	addi	a0,a0,-582 # ffffffffc0202960 <etext+0x950>
ffffffffc0200bae:	d74ff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Instruction at epc: 0x%08x\n", *instr_ptr);
ffffffffc0200bb2:	10843783          	ld	a5,264(s0)
ffffffffc0200bb6:	00002517          	auipc	a0,0x2
ffffffffc0200bba:	e4a50513          	addi	a0,a0,-438 # ffffffffc0202a00 <etext+0x9f0>
ffffffffc0200bbe:	438c                	lw	a1,0(a5)
ffffffffc0200bc0:	d62ff0ef          	jal	ffffffffc0200122 <cprintf>
    tf->epc += 2;
ffffffffc0200bc4:	10843583          	ld	a1,264(s0)
    cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200bc8:	00002517          	auipc	a0,0x2
ffffffffc0200bcc:	db850513          	addi	a0,a0,-584 # ffffffffc0202980 <etext+0x970>
    tf->epc += 2;
ffffffffc0200bd0:	0589                	addi	a1,a1,2
ffffffffc0200bd2:	10b43423          	sd	a1,264(s0)
    cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200bd6:	d4cff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Stack pointer: 0x%08x\n", tf->gpr.sp);
ffffffffc0200bda:	680c                	ld	a1,16(s0)
ffffffffc0200bdc:	00002517          	auipc	a0,0x2
ffffffffc0200be0:	e4450513          	addi	a0,a0,-444 # ffffffffc0202a20 <etext+0xa10>
ffffffffc0200be4:	d3eff0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200be8:	640c                	ld	a1,8(s0)
}
ffffffffc0200bea:	6402                	ld	s0,0(sp)
ffffffffc0200bec:	60a2                	ld	ra,8(sp)
    cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200bee:	00002517          	auipc	a0,0x2
ffffffffc0200bf2:	e4a50513          	addi	a0,a0,-438 # ffffffffc0202a38 <etext+0xa28>
}
ffffffffc0200bf6:	0141                	addi	sp,sp,16
    cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200bf8:	d2aff06f          	j	ffffffffc0200122 <cprintf>

ffffffffc0200bfc <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bfc:	11853783          	ld	a5,280(a0)
ffffffffc0200c00:	0007c363          	bltz	a5,ffffffffc0200c06 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200c04:	bded                	j	ffffffffc0200afe <exception_handler>
        interrupt_handler(tf);
ffffffffc0200c06:	bd01                	j	ffffffffc0200a16 <interrupt_handler>

ffffffffc0200c08 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200c08:	14011073          	csrw	sscratch,sp
ffffffffc0200c0c:	712d                	addi	sp,sp,-288
ffffffffc0200c0e:	e002                	sd	zero,0(sp)
ffffffffc0200c10:	e406                	sd	ra,8(sp)
ffffffffc0200c12:	ec0e                	sd	gp,24(sp)
ffffffffc0200c14:	f012                	sd	tp,32(sp)
ffffffffc0200c16:	f416                	sd	t0,40(sp)
ffffffffc0200c18:	f81a                	sd	t1,48(sp)
ffffffffc0200c1a:	fc1e                	sd	t2,56(sp)
ffffffffc0200c1c:	e0a2                	sd	s0,64(sp)
ffffffffc0200c1e:	e4a6                	sd	s1,72(sp)
ffffffffc0200c20:	e8aa                	sd	a0,80(sp)
ffffffffc0200c22:	ecae                	sd	a1,88(sp)
ffffffffc0200c24:	f0b2                	sd	a2,96(sp)
ffffffffc0200c26:	f4b6                	sd	a3,104(sp)
ffffffffc0200c28:	f8ba                	sd	a4,112(sp)
ffffffffc0200c2a:	fcbe                	sd	a5,120(sp)
ffffffffc0200c2c:	e142                	sd	a6,128(sp)
ffffffffc0200c2e:	e546                	sd	a7,136(sp)
ffffffffc0200c30:	e94a                	sd	s2,144(sp)
ffffffffc0200c32:	ed4e                	sd	s3,152(sp)
ffffffffc0200c34:	f152                	sd	s4,160(sp)
ffffffffc0200c36:	f556                	sd	s5,168(sp)
ffffffffc0200c38:	f95a                	sd	s6,176(sp)
ffffffffc0200c3a:	fd5e                	sd	s7,184(sp)
ffffffffc0200c3c:	e1e2                	sd	s8,192(sp)
ffffffffc0200c3e:	e5e6                	sd	s9,200(sp)
ffffffffc0200c40:	e9ea                	sd	s10,208(sp)
ffffffffc0200c42:	edee                	sd	s11,216(sp)
ffffffffc0200c44:	f1f2                	sd	t3,224(sp)
ffffffffc0200c46:	f5f6                	sd	t4,232(sp)
ffffffffc0200c48:	f9fa                	sd	t5,240(sp)
ffffffffc0200c4a:	fdfe                	sd	t6,248(sp)
ffffffffc0200c4c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c50:	100024f3          	csrr	s1,sstatus
ffffffffc0200c54:	14102973          	csrr	s2,sepc
ffffffffc0200c58:	143029f3          	csrr	s3,stval
ffffffffc0200c5c:	14202a73          	csrr	s4,scause
ffffffffc0200c60:	e822                	sd	s0,16(sp)
ffffffffc0200c62:	e226                	sd	s1,256(sp)
ffffffffc0200c64:	e64a                	sd	s2,264(sp)
ffffffffc0200c66:	ea4e                	sd	s3,272(sp)
ffffffffc0200c68:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c6a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c6c:	f91ff0ef          	jal	ffffffffc0200bfc <trap>

ffffffffc0200c70 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c70:	6492                	ld	s1,256(sp)
ffffffffc0200c72:	6932                	ld	s2,264(sp)
ffffffffc0200c74:	10049073          	csrw	sstatus,s1
ffffffffc0200c78:	14191073          	csrw	sepc,s2
ffffffffc0200c7c:	60a2                	ld	ra,8(sp)
ffffffffc0200c7e:	61e2                	ld	gp,24(sp)
ffffffffc0200c80:	7202                	ld	tp,32(sp)
ffffffffc0200c82:	72a2                	ld	t0,40(sp)
ffffffffc0200c84:	7342                	ld	t1,48(sp)
ffffffffc0200c86:	73e2                	ld	t2,56(sp)
ffffffffc0200c88:	6406                	ld	s0,64(sp)
ffffffffc0200c8a:	64a6                	ld	s1,72(sp)
ffffffffc0200c8c:	6546                	ld	a0,80(sp)
ffffffffc0200c8e:	65e6                	ld	a1,88(sp)
ffffffffc0200c90:	7606                	ld	a2,96(sp)
ffffffffc0200c92:	76a6                	ld	a3,104(sp)
ffffffffc0200c94:	7746                	ld	a4,112(sp)
ffffffffc0200c96:	77e6                	ld	a5,120(sp)
ffffffffc0200c98:	680a                	ld	a6,128(sp)
ffffffffc0200c9a:	68aa                	ld	a7,136(sp)
ffffffffc0200c9c:	694a                	ld	s2,144(sp)
ffffffffc0200c9e:	69ea                	ld	s3,152(sp)
ffffffffc0200ca0:	7a0a                	ld	s4,160(sp)
ffffffffc0200ca2:	7aaa                	ld	s5,168(sp)
ffffffffc0200ca4:	7b4a                	ld	s6,176(sp)
ffffffffc0200ca6:	7bea                	ld	s7,184(sp)
ffffffffc0200ca8:	6c0e                	ld	s8,192(sp)
ffffffffc0200caa:	6cae                	ld	s9,200(sp)
ffffffffc0200cac:	6d4e                	ld	s10,208(sp)
ffffffffc0200cae:	6dee                	ld	s11,216(sp)
ffffffffc0200cb0:	7e0e                	ld	t3,224(sp)
ffffffffc0200cb2:	7eae                	ld	t4,232(sp)
ffffffffc0200cb4:	7f4e                	ld	t5,240(sp)
ffffffffc0200cb6:	7fee                	ld	t6,248(sp)
ffffffffc0200cb8:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200cba:	10200073          	sret

ffffffffc0200cbe <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200cbe:	00006797          	auipc	a5,0x6
ffffffffc0200cc2:	36a78793          	addi	a5,a5,874 # ffffffffc0207028 <free_area>
ffffffffc0200cc6:	e79c                	sd	a5,8(a5)
ffffffffc0200cc8:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200cca:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200cce:	8082                	ret

ffffffffc0200cd0 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200cd0:	00006517          	auipc	a0,0x6
ffffffffc0200cd4:	36856503          	lwu	a0,872(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200cd8:	8082                	ret

ffffffffc0200cda <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200cda:	711d                	addi	sp,sp,-96
ffffffffc0200cdc:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200cde:	00006917          	auipc	s2,0x6
ffffffffc0200ce2:	34a90913          	addi	s2,s2,842 # ffffffffc0207028 <free_area>
ffffffffc0200ce6:	00893783          	ld	a5,8(s2)
ffffffffc0200cea:	ec86                	sd	ra,88(sp)
ffffffffc0200cec:	e8a2                	sd	s0,80(sp)
ffffffffc0200cee:	e4a6                	sd	s1,72(sp)
ffffffffc0200cf0:	fc4e                	sd	s3,56(sp)
ffffffffc0200cf2:	f852                	sd	s4,48(sp)
ffffffffc0200cf4:	f456                	sd	s5,40(sp)
ffffffffc0200cf6:	f05a                	sd	s6,32(sp)
ffffffffc0200cf8:	ec5e                	sd	s7,24(sp)
ffffffffc0200cfa:	e862                	sd	s8,16(sp)
ffffffffc0200cfc:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200cfe:	31278b63          	beq	a5,s2,ffffffffc0201014 <default_check+0x33a>
    int count = 0, total = 0;
ffffffffc0200d02:	4401                	li	s0,0
ffffffffc0200d04:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d06:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d0a:	8b09                	andi	a4,a4,2
ffffffffc0200d0c:	30070863          	beqz	a4,ffffffffc020101c <default_check+0x342>
        count ++, total += p->property;
ffffffffc0200d10:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d14:	679c                	ld	a5,8(a5)
ffffffffc0200d16:	2485                	addiw	s1,s1,1
ffffffffc0200d18:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d1a:	ff2796e3          	bne	a5,s2,ffffffffc0200d06 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200d1e:	89a2                	mv	s3,s0
ffffffffc0200d20:	33f000ef          	jal	ffffffffc020185e <nr_free_pages>
ffffffffc0200d24:	75351c63          	bne	a0,s3,ffffffffc020147c <default_check+0x7a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d28:	4505                	li	a0,1
ffffffffc0200d2a:	2c3000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200d2e:	8aaa                	mv	s5,a0
ffffffffc0200d30:	48050663          	beqz	a0,ffffffffc02011bc <default_check+0x4e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d34:	4505                	li	a0,1
ffffffffc0200d36:	2b7000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200d3a:	89aa                	mv	s3,a0
ffffffffc0200d3c:	76050063          	beqz	a0,ffffffffc020149c <default_check+0x7c2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d40:	4505                	li	a0,1
ffffffffc0200d42:	2ab000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200d46:	8a2a                	mv	s4,a0
ffffffffc0200d48:	4e050a63          	beqz	a0,ffffffffc020123c <default_check+0x562>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200d4c:	40aa87b3          	sub	a5,s5,a0
ffffffffc0200d50:	40a98733          	sub	a4,s3,a0
ffffffffc0200d54:	0017b793          	seqz	a5,a5
ffffffffc0200d58:	00173713          	seqz	a4,a4
ffffffffc0200d5c:	8fd9                	or	a5,a5,a4
ffffffffc0200d5e:	32079f63          	bnez	a5,ffffffffc020109c <default_check+0x3c2>
ffffffffc0200d62:	333a8d63          	beq	s5,s3,ffffffffc020109c <default_check+0x3c2>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200d66:	000aa783          	lw	a5,0(s5)
ffffffffc0200d6a:	2c079963          	bnez	a5,ffffffffc020103c <default_check+0x362>
ffffffffc0200d6e:	0009a783          	lw	a5,0(s3)
ffffffffc0200d72:	2c079563          	bnez	a5,ffffffffc020103c <default_check+0x362>
ffffffffc0200d76:	411c                	lw	a5,0(a0)
ffffffffc0200d78:	2c079263          	bnez	a5,ffffffffc020103c <default_check+0x362>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d7c:	00006797          	auipc	a5,0x6
ffffffffc0200d80:	7147b783          	ld	a5,1812(a5) # ffffffffc0207490 <pages>
ffffffffc0200d84:	ccccd737          	lui	a4,0xccccd
ffffffffc0200d88:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac582d>
ffffffffc0200d8c:	02071693          	slli	a3,a4,0x20
ffffffffc0200d90:	96ba                	add	a3,a3,a4
ffffffffc0200d92:	40fa8733          	sub	a4,s5,a5
ffffffffc0200d96:	870d                	srai	a4,a4,0x3
ffffffffc0200d98:	02d70733          	mul	a4,a4,a3
ffffffffc0200d9c:	00002517          	auipc	a0,0x2
ffffffffc0200da0:	4d453503          	ld	a0,1236(a0) # ffffffffc0203270 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200da4:	00006697          	auipc	a3,0x6
ffffffffc0200da8:	6e46b683          	ld	a3,1764(a3) # ffffffffc0207488 <npage>
ffffffffc0200dac:	06b2                	slli	a3,a3,0xc
ffffffffc0200dae:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200db0:	0732                	slli	a4,a4,0xc
ffffffffc0200db2:	2cd77563          	bgeu	a4,a3,ffffffffc020107c <default_check+0x3a2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200db6:	ccccd5b7          	lui	a1,0xccccd
ffffffffc0200dba:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac582d>
ffffffffc0200dbe:	02059613          	slli	a2,a1,0x20
ffffffffc0200dc2:	40f98733          	sub	a4,s3,a5
ffffffffc0200dc6:	962e                	add	a2,a2,a1
ffffffffc0200dc8:	870d                	srai	a4,a4,0x3
ffffffffc0200dca:	02c70733          	mul	a4,a4,a2
ffffffffc0200dce:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dd0:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200dd2:	4ed77563          	bgeu	a4,a3,ffffffffc02012bc <default_check+0x5e2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200dd6:	40fa07b3          	sub	a5,s4,a5
ffffffffc0200dda:	878d                	srai	a5,a5,0x3
ffffffffc0200ddc:	02c787b3          	mul	a5,a5,a2
ffffffffc0200de0:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200de2:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200de4:	32d7fc63          	bgeu	a5,a3,ffffffffc020111c <default_check+0x442>
    assert(alloc_page() == NULL);
ffffffffc0200de8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200dea:	00093c03          	ld	s8,0(s2)
ffffffffc0200dee:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200df2:	00006b17          	auipc	s6,0x6
ffffffffc0200df6:	246b2b03          	lw	s6,582(s6) # ffffffffc0207038 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200dfa:	01293023          	sd	s2,0(s2)
ffffffffc0200dfe:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200e02:	00006797          	auipc	a5,0x6
ffffffffc0200e06:	2207ab23          	sw	zero,566(a5) # ffffffffc0207038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200e0a:	1e3000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e0e:	2e051763          	bnez	a0,ffffffffc02010fc <default_check+0x422>
    free_page(p0);
ffffffffc0200e12:	8556                	mv	a0,s5
ffffffffc0200e14:	4585                	li	a1,1
ffffffffc0200e16:	211000ef          	jal	ffffffffc0201826 <free_pages>
    free_page(p1);
ffffffffc0200e1a:	854e                	mv	a0,s3
ffffffffc0200e1c:	4585                	li	a1,1
ffffffffc0200e1e:	209000ef          	jal	ffffffffc0201826 <free_pages>
    free_page(p2);
ffffffffc0200e22:	8552                	mv	a0,s4
ffffffffc0200e24:	4585                	li	a1,1
ffffffffc0200e26:	201000ef          	jal	ffffffffc0201826 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e2a:	00006717          	auipc	a4,0x6
ffffffffc0200e2e:	20e72703          	lw	a4,526(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200e32:	478d                	li	a5,3
ffffffffc0200e34:	2af71463          	bne	a4,a5,ffffffffc02010dc <default_check+0x402>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e38:	4505                	li	a0,1
ffffffffc0200e3a:	1b3000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e3e:	89aa                	mv	s3,a0
ffffffffc0200e40:	26050e63          	beqz	a0,ffffffffc02010bc <default_check+0x3e2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e44:	4505                	li	a0,1
ffffffffc0200e46:	1a7000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e4a:	8aaa                	mv	s5,a0
ffffffffc0200e4c:	3c050863          	beqz	a0,ffffffffc020121c <default_check+0x542>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e50:	4505                	li	a0,1
ffffffffc0200e52:	19b000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e56:	8a2a                	mv	s4,a0
ffffffffc0200e58:	3a050263          	beqz	a0,ffffffffc02011fc <default_check+0x522>
    assert(alloc_page() == NULL);
ffffffffc0200e5c:	4505                	li	a0,1
ffffffffc0200e5e:	18f000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e62:	36051d63          	bnez	a0,ffffffffc02011dc <default_check+0x502>
    free_page(p0);
ffffffffc0200e66:	4585                	li	a1,1
ffffffffc0200e68:	854e                	mv	a0,s3
ffffffffc0200e6a:	1bd000ef          	jal	ffffffffc0201826 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200e6e:	00893783          	ld	a5,8(s2)
ffffffffc0200e72:	1f278563          	beq	a5,s2,ffffffffc020105c <default_check+0x382>
    assert((p = alloc_page()) == p0);
ffffffffc0200e76:	4505                	li	a0,1
ffffffffc0200e78:	175000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e7c:	8caa                	mv	s9,a0
ffffffffc0200e7e:	30a99f63          	bne	s3,a0,ffffffffc020119c <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200e82:	4505                	li	a0,1
ffffffffc0200e84:	169000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200e88:	2e051a63          	bnez	a0,ffffffffc020117c <default_check+0x4a2>
    assert(nr_free == 0);
ffffffffc0200e8c:	00006797          	auipc	a5,0x6
ffffffffc0200e90:	1ac7a783          	lw	a5,428(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200e94:	2c079463          	bnez	a5,ffffffffc020115c <default_check+0x482>
    free_page(p);
ffffffffc0200e98:	8566                	mv	a0,s9
ffffffffc0200e9a:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200e9c:	01893023          	sd	s8,0(s2)
ffffffffc0200ea0:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200ea4:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0200ea8:	17f000ef          	jal	ffffffffc0201826 <free_pages>
    free_page(p1);
ffffffffc0200eac:	8556                	mv	a0,s5
ffffffffc0200eae:	4585                	li	a1,1
ffffffffc0200eb0:	177000ef          	jal	ffffffffc0201826 <free_pages>
    free_page(p2);
ffffffffc0200eb4:	8552                	mv	a0,s4
ffffffffc0200eb6:	4585                	li	a1,1
ffffffffc0200eb8:	16f000ef          	jal	ffffffffc0201826 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200ebc:	4515                	li	a0,5
ffffffffc0200ebe:	12f000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200ec2:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200ec4:	26050c63          	beqz	a0,ffffffffc020113c <default_check+0x462>
ffffffffc0200ec8:	651c                	ld	a5,8(a0)
ffffffffc0200eca:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200ecc:	8b85                	andi	a5,a5,1
ffffffffc0200ece:	54079763          	bnez	a5,ffffffffc020141c <default_check+0x742>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200ed2:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200ed4:	00093b83          	ld	s7,0(s2)
ffffffffc0200ed8:	00893b03          	ld	s6,8(s2)
ffffffffc0200edc:	01293023          	sd	s2,0(s2)
ffffffffc0200ee0:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200ee4:	109000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200ee8:	50051a63          	bnez	a0,ffffffffc02013fc <default_check+0x722>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200eec:	05098a13          	addi	s4,s3,80
ffffffffc0200ef0:	8552                	mv	a0,s4
ffffffffc0200ef2:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200ef4:	00006c17          	auipc	s8,0x6
ffffffffc0200ef8:	144c2c03          	lw	s8,324(s8) # ffffffffc0207038 <free_area+0x10>
    nr_free = 0;
ffffffffc0200efc:	00006797          	auipc	a5,0x6
ffffffffc0200f00:	1207ae23          	sw	zero,316(a5) # ffffffffc0207038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200f04:	123000ef          	jal	ffffffffc0201826 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f08:	4511                	li	a0,4
ffffffffc0200f0a:	0e3000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200f0e:	4c051763          	bnez	a0,ffffffffc02013dc <default_check+0x702>
ffffffffc0200f12:	0589b783          	ld	a5,88(s3)
ffffffffc0200f16:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200f18:	8b85                	andi	a5,a5,1
ffffffffc0200f1a:	4a078163          	beqz	a5,ffffffffc02013bc <default_check+0x6e2>
ffffffffc0200f1e:	0609a503          	lw	a0,96(s3)
ffffffffc0200f22:	478d                	li	a5,3
ffffffffc0200f24:	48f51c63          	bne	a0,a5,ffffffffc02013bc <default_check+0x6e2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200f28:	0c5000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200f2c:	8aaa                	mv	s5,a0
ffffffffc0200f2e:	46050763          	beqz	a0,ffffffffc020139c <default_check+0x6c2>
    assert(alloc_page() == NULL);
ffffffffc0200f32:	4505                	li	a0,1
ffffffffc0200f34:	0b9000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200f38:	44051263          	bnez	a0,ffffffffc020137c <default_check+0x6a2>
    assert(p0 + 2 == p1);
ffffffffc0200f3c:	435a1063          	bne	s4,s5,ffffffffc020135c <default_check+0x682>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200f40:	4585                	li	a1,1
ffffffffc0200f42:	854e                	mv	a0,s3
ffffffffc0200f44:	0e3000ef          	jal	ffffffffc0201826 <free_pages>
    free_pages(p1, 3);
ffffffffc0200f48:	8552                	mv	a0,s4
ffffffffc0200f4a:	458d                	li	a1,3
ffffffffc0200f4c:	0db000ef          	jal	ffffffffc0201826 <free_pages>
ffffffffc0200f50:	0089b783          	ld	a5,8(s3)
ffffffffc0200f54:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200f56:	8b85                	andi	a5,a5,1
ffffffffc0200f58:	3e078263          	beqz	a5,ffffffffc020133c <default_check+0x662>
ffffffffc0200f5c:	0109aa83          	lw	s5,16(s3)
ffffffffc0200f60:	4785                	li	a5,1
ffffffffc0200f62:	3cfa9d63          	bne	s5,a5,ffffffffc020133c <default_check+0x662>
ffffffffc0200f66:	008a3783          	ld	a5,8(s4)
ffffffffc0200f6a:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200f6c:	8b85                	andi	a5,a5,1
ffffffffc0200f6e:	3a078763          	beqz	a5,ffffffffc020131c <default_check+0x642>
ffffffffc0200f72:	010a2703          	lw	a4,16(s4)
ffffffffc0200f76:	478d                	li	a5,3
ffffffffc0200f78:	3af71263          	bne	a4,a5,ffffffffc020131c <default_check+0x642>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200f7c:	8556                	mv	a0,s5
ffffffffc0200f7e:	06f000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200f82:	36a99d63          	bne	s3,a0,ffffffffc02012fc <default_check+0x622>
    free_page(p0);
ffffffffc0200f86:	85d6                	mv	a1,s5
ffffffffc0200f88:	09f000ef          	jal	ffffffffc0201826 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200f8c:	4509                	li	a0,2
ffffffffc0200f8e:	05f000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200f92:	34aa1563          	bne	s4,a0,ffffffffc02012dc <default_check+0x602>

    free_pages(p0, 2);
ffffffffc0200f96:	4589                	li	a1,2
ffffffffc0200f98:	08f000ef          	jal	ffffffffc0201826 <free_pages>
    free_page(p2);
ffffffffc0200f9c:	02898513          	addi	a0,s3,40
ffffffffc0200fa0:	85d6                	mv	a1,s5
ffffffffc0200fa2:	085000ef          	jal	ffffffffc0201826 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fa6:	4515                	li	a0,5
ffffffffc0200fa8:	045000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200fac:	89aa                	mv	s3,a0
ffffffffc0200fae:	48050763          	beqz	a0,ffffffffc020143c <default_check+0x762>
    assert(alloc_page() == NULL);
ffffffffc0200fb2:	8556                	mv	a0,s5
ffffffffc0200fb4:	039000ef          	jal	ffffffffc02017ec <alloc_pages>
ffffffffc0200fb8:	2e051263          	bnez	a0,ffffffffc020129c <default_check+0x5c2>

    assert(nr_free == 0);
ffffffffc0200fbc:	00006797          	auipc	a5,0x6
ffffffffc0200fc0:	07c7a783          	lw	a5,124(a5) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200fc4:	2a079c63          	bnez	a5,ffffffffc020127c <default_check+0x5a2>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200fc8:	854e                	mv	a0,s3
ffffffffc0200fca:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0200fcc:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0200fd0:	01793023          	sd	s7,0(s2)
ffffffffc0200fd4:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0200fd8:	04f000ef          	jal	ffffffffc0201826 <free_pages>
    return listelm->next;
ffffffffc0200fdc:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fe0:	01278963          	beq	a5,s2,ffffffffc0200ff2 <default_check+0x318>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200fe4:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fe8:	679c                	ld	a5,8(a5)
ffffffffc0200fea:	34fd                	addiw	s1,s1,-1
ffffffffc0200fec:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fee:	ff279be3          	bne	a5,s2,ffffffffc0200fe4 <default_check+0x30a>
    }
    assert(count == 0);
ffffffffc0200ff2:	26049563          	bnez	s1,ffffffffc020125c <default_check+0x582>
    assert(total == 0);
ffffffffc0200ff6:	46041363          	bnez	s0,ffffffffc020145c <default_check+0x782>
}
ffffffffc0200ffa:	60e6                	ld	ra,88(sp)
ffffffffc0200ffc:	6446                	ld	s0,80(sp)
ffffffffc0200ffe:	64a6                	ld	s1,72(sp)
ffffffffc0201000:	6906                	ld	s2,64(sp)
ffffffffc0201002:	79e2                	ld	s3,56(sp)
ffffffffc0201004:	7a42                	ld	s4,48(sp)
ffffffffc0201006:	7aa2                	ld	s5,40(sp)
ffffffffc0201008:	7b02                	ld	s6,32(sp)
ffffffffc020100a:	6be2                	ld	s7,24(sp)
ffffffffc020100c:	6c42                	ld	s8,16(sp)
ffffffffc020100e:	6ca2                	ld	s9,8(sp)
ffffffffc0201010:	6125                	addi	sp,sp,96
ffffffffc0201012:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201014:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201016:	4401                	li	s0,0
ffffffffc0201018:	4481                	li	s1,0
ffffffffc020101a:	b319                	j	ffffffffc0200d20 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc020101c:	00002697          	auipc	a3,0x2
ffffffffc0201020:	a3468693          	addi	a3,a3,-1484 # ffffffffc0202a50 <etext+0xa40>
ffffffffc0201024:	00002617          	auipc	a2,0x2
ffffffffc0201028:	a3c60613          	addi	a2,a2,-1476 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020102c:	0f000593          	li	a1,240
ffffffffc0201030:	00002517          	auipc	a0,0x2
ffffffffc0201034:	a4850513          	addi	a0,a0,-1464 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201038:	b9cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020103c:	00002697          	auipc	a3,0x2
ffffffffc0201040:	afc68693          	addi	a3,a3,-1284 # ffffffffc0202b38 <etext+0xb28>
ffffffffc0201044:	00002617          	auipc	a2,0x2
ffffffffc0201048:	a1c60613          	addi	a2,a2,-1508 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020104c:	0be00593          	li	a1,190
ffffffffc0201050:	00002517          	auipc	a0,0x2
ffffffffc0201054:	a2850513          	addi	a0,a0,-1496 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201058:	b7cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(!list_empty(&free_list));
ffffffffc020105c:	00002697          	auipc	a3,0x2
ffffffffc0201060:	ba468693          	addi	a3,a3,-1116 # ffffffffc0202c00 <etext+0xbf0>
ffffffffc0201064:	00002617          	auipc	a2,0x2
ffffffffc0201068:	9fc60613          	addi	a2,a2,-1540 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020106c:	0d900593          	li	a1,217
ffffffffc0201070:	00002517          	auipc	a0,0x2
ffffffffc0201074:	a0850513          	addi	a0,a0,-1528 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201078:	b5cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020107c:	00002697          	auipc	a3,0x2
ffffffffc0201080:	afc68693          	addi	a3,a3,-1284 # ffffffffc0202b78 <etext+0xb68>
ffffffffc0201084:	00002617          	auipc	a2,0x2
ffffffffc0201088:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020108c:	0c000593          	li	a1,192
ffffffffc0201090:	00002517          	auipc	a0,0x2
ffffffffc0201094:	9e850513          	addi	a0,a0,-1560 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201098:	b3cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020109c:	00002697          	auipc	a3,0x2
ffffffffc02010a0:	a7468693          	addi	a3,a3,-1420 # ffffffffc0202b10 <etext+0xb00>
ffffffffc02010a4:	00002617          	auipc	a2,0x2
ffffffffc02010a8:	9bc60613          	addi	a2,a2,-1604 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02010ac:	0bd00593          	li	a1,189
ffffffffc02010b0:	00002517          	auipc	a0,0x2
ffffffffc02010b4:	9c850513          	addi	a0,a0,-1592 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02010b8:	b1cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010bc:	00002697          	auipc	a3,0x2
ffffffffc02010c0:	9f468693          	addi	a3,a3,-1548 # ffffffffc0202ab0 <etext+0xaa0>
ffffffffc02010c4:	00002617          	auipc	a2,0x2
ffffffffc02010c8:	99c60613          	addi	a2,a2,-1636 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02010cc:	0d200593          	li	a1,210
ffffffffc02010d0:	00002517          	auipc	a0,0x2
ffffffffc02010d4:	9a850513          	addi	a0,a0,-1624 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02010d8:	afcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(nr_free == 3);
ffffffffc02010dc:	00002697          	auipc	a3,0x2
ffffffffc02010e0:	b1468693          	addi	a3,a3,-1260 # ffffffffc0202bf0 <etext+0xbe0>
ffffffffc02010e4:	00002617          	auipc	a2,0x2
ffffffffc02010e8:	97c60613          	addi	a2,a2,-1668 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02010ec:	0d000593          	li	a1,208
ffffffffc02010f0:	00002517          	auipc	a0,0x2
ffffffffc02010f4:	98850513          	addi	a0,a0,-1656 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02010f8:	adcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010fc:	00002697          	auipc	a3,0x2
ffffffffc0201100:	adc68693          	addi	a3,a3,-1316 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc0201104:	00002617          	auipc	a2,0x2
ffffffffc0201108:	95c60613          	addi	a2,a2,-1700 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020110c:	0cb00593          	li	a1,203
ffffffffc0201110:	00002517          	auipc	a0,0x2
ffffffffc0201114:	96850513          	addi	a0,a0,-1688 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201118:	abcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020111c:	00002697          	auipc	a3,0x2
ffffffffc0201120:	a9c68693          	addi	a3,a3,-1380 # ffffffffc0202bb8 <etext+0xba8>
ffffffffc0201124:	00002617          	auipc	a2,0x2
ffffffffc0201128:	93c60613          	addi	a2,a2,-1732 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020112c:	0c200593          	li	a1,194
ffffffffc0201130:	00002517          	auipc	a0,0x2
ffffffffc0201134:	94850513          	addi	a0,a0,-1720 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201138:	a9cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(p0 != NULL);
ffffffffc020113c:	00002697          	auipc	a3,0x2
ffffffffc0201140:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0202c48 <etext+0xc38>
ffffffffc0201144:	00002617          	auipc	a2,0x2
ffffffffc0201148:	91c60613          	addi	a2,a2,-1764 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020114c:	0f800593          	li	a1,248
ffffffffc0201150:	00002517          	auipc	a0,0x2
ffffffffc0201154:	92850513          	addi	a0,a0,-1752 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201158:	a7cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(nr_free == 0);
ffffffffc020115c:	00002697          	auipc	a3,0x2
ffffffffc0201160:	adc68693          	addi	a3,a3,-1316 # ffffffffc0202c38 <etext+0xc28>
ffffffffc0201164:	00002617          	auipc	a2,0x2
ffffffffc0201168:	8fc60613          	addi	a2,a2,-1796 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020116c:	0df00593          	li	a1,223
ffffffffc0201170:	00002517          	auipc	a0,0x2
ffffffffc0201174:	90850513          	addi	a0,a0,-1784 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201178:	a5cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020117c:	00002697          	auipc	a3,0x2
ffffffffc0201180:	a5c68693          	addi	a3,a3,-1444 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc0201184:	00002617          	auipc	a2,0x2
ffffffffc0201188:	8dc60613          	addi	a2,a2,-1828 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020118c:	0dd00593          	li	a1,221
ffffffffc0201190:	00002517          	auipc	a0,0x2
ffffffffc0201194:	8e850513          	addi	a0,a0,-1816 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201198:	a3cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020119c:	00002697          	auipc	a3,0x2
ffffffffc02011a0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc0202c18 <etext+0xc08>
ffffffffc02011a4:	00002617          	auipc	a2,0x2
ffffffffc02011a8:	8bc60613          	addi	a2,a2,-1860 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02011ac:	0dc00593          	li	a1,220
ffffffffc02011b0:	00002517          	auipc	a0,0x2
ffffffffc02011b4:	8c850513          	addi	a0,a0,-1848 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02011b8:	a1cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011bc:	00002697          	auipc	a3,0x2
ffffffffc02011c0:	8f468693          	addi	a3,a3,-1804 # ffffffffc0202ab0 <etext+0xaa0>
ffffffffc02011c4:	00002617          	auipc	a2,0x2
ffffffffc02011c8:	89c60613          	addi	a2,a2,-1892 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02011cc:	0b900593          	li	a1,185
ffffffffc02011d0:	00002517          	auipc	a0,0x2
ffffffffc02011d4:	8a850513          	addi	a0,a0,-1880 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02011d8:	9fcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011dc:	00002697          	auipc	a3,0x2
ffffffffc02011e0:	9fc68693          	addi	a3,a3,-1540 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc02011e4:	00002617          	auipc	a2,0x2
ffffffffc02011e8:	87c60613          	addi	a2,a2,-1924 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02011ec:	0d600593          	li	a1,214
ffffffffc02011f0:	00002517          	auipc	a0,0x2
ffffffffc02011f4:	88850513          	addi	a0,a0,-1912 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02011f8:	9dcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011fc:	00002697          	auipc	a3,0x2
ffffffffc0201200:	8f468693          	addi	a3,a3,-1804 # ffffffffc0202af0 <etext+0xae0>
ffffffffc0201204:	00002617          	auipc	a2,0x2
ffffffffc0201208:	85c60613          	addi	a2,a2,-1956 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020120c:	0d400593          	li	a1,212
ffffffffc0201210:	00002517          	auipc	a0,0x2
ffffffffc0201214:	86850513          	addi	a0,a0,-1944 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201218:	9bcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020121c:	00002697          	auipc	a3,0x2
ffffffffc0201220:	8b468693          	addi	a3,a3,-1868 # ffffffffc0202ad0 <etext+0xac0>
ffffffffc0201224:	00002617          	auipc	a2,0x2
ffffffffc0201228:	83c60613          	addi	a2,a2,-1988 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020122c:	0d300593          	li	a1,211
ffffffffc0201230:	00002517          	auipc	a0,0x2
ffffffffc0201234:	84850513          	addi	a0,a0,-1976 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201238:	99cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020123c:	00002697          	auipc	a3,0x2
ffffffffc0201240:	8b468693          	addi	a3,a3,-1868 # ffffffffc0202af0 <etext+0xae0>
ffffffffc0201244:	00002617          	auipc	a2,0x2
ffffffffc0201248:	81c60613          	addi	a2,a2,-2020 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020124c:	0bb00593          	li	a1,187
ffffffffc0201250:	00002517          	auipc	a0,0x2
ffffffffc0201254:	82850513          	addi	a0,a0,-2008 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201258:	97cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(count == 0);
ffffffffc020125c:	00002697          	auipc	a3,0x2
ffffffffc0201260:	b3c68693          	addi	a3,a3,-1220 # ffffffffc0202d98 <etext+0xd88>
ffffffffc0201264:	00001617          	auipc	a2,0x1
ffffffffc0201268:	7fc60613          	addi	a2,a2,2044 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020126c:	12500593          	li	a1,293
ffffffffc0201270:	00002517          	auipc	a0,0x2
ffffffffc0201274:	80850513          	addi	a0,a0,-2040 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201278:	95cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(nr_free == 0);
ffffffffc020127c:	00002697          	auipc	a3,0x2
ffffffffc0201280:	9bc68693          	addi	a3,a3,-1604 # ffffffffc0202c38 <etext+0xc28>
ffffffffc0201284:	00001617          	auipc	a2,0x1
ffffffffc0201288:	7dc60613          	addi	a2,a2,2012 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020128c:	11a00593          	li	a1,282
ffffffffc0201290:	00001517          	auipc	a0,0x1
ffffffffc0201294:	7e850513          	addi	a0,a0,2024 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201298:	93cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020129c:	00002697          	auipc	a3,0x2
ffffffffc02012a0:	93c68693          	addi	a3,a3,-1732 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc02012a4:	00001617          	auipc	a2,0x1
ffffffffc02012a8:	7bc60613          	addi	a2,a2,1980 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02012ac:	11800593          	li	a1,280
ffffffffc02012b0:	00001517          	auipc	a0,0x1
ffffffffc02012b4:	7c850513          	addi	a0,a0,1992 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02012b8:	91cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02012bc:	00002697          	auipc	a3,0x2
ffffffffc02012c0:	8dc68693          	addi	a3,a3,-1828 # ffffffffc0202b98 <etext+0xb88>
ffffffffc02012c4:	00001617          	auipc	a2,0x1
ffffffffc02012c8:	79c60613          	addi	a2,a2,1948 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02012cc:	0c100593          	li	a1,193
ffffffffc02012d0:	00001517          	auipc	a0,0x1
ffffffffc02012d4:	7a850513          	addi	a0,a0,1960 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02012d8:	8fcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012dc:	00002697          	auipc	a3,0x2
ffffffffc02012e0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc0202d58 <etext+0xd48>
ffffffffc02012e4:	00001617          	auipc	a2,0x1
ffffffffc02012e8:	77c60613          	addi	a2,a2,1916 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02012ec:	11200593          	li	a1,274
ffffffffc02012f0:	00001517          	auipc	a0,0x1
ffffffffc02012f4:	78850513          	addi	a0,a0,1928 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02012f8:	8dcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012fc:	00002697          	auipc	a3,0x2
ffffffffc0201300:	a3c68693          	addi	a3,a3,-1476 # ffffffffc0202d38 <etext+0xd28>
ffffffffc0201304:	00001617          	auipc	a2,0x1
ffffffffc0201308:	75c60613          	addi	a2,a2,1884 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020130c:	11000593          	li	a1,272
ffffffffc0201310:	00001517          	auipc	a0,0x1
ffffffffc0201314:	76850513          	addi	a0,a0,1896 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201318:	8bcff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020131c:	00002697          	auipc	a3,0x2
ffffffffc0201320:	9f468693          	addi	a3,a3,-1548 # ffffffffc0202d10 <etext+0xd00>
ffffffffc0201324:	00001617          	auipc	a2,0x1
ffffffffc0201328:	73c60613          	addi	a2,a2,1852 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020132c:	10e00593          	li	a1,270
ffffffffc0201330:	00001517          	auipc	a0,0x1
ffffffffc0201334:	74850513          	addi	a0,a0,1864 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201338:	89cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020133c:	00002697          	auipc	a3,0x2
ffffffffc0201340:	9ac68693          	addi	a3,a3,-1620 # ffffffffc0202ce8 <etext+0xcd8>
ffffffffc0201344:	00001617          	auipc	a2,0x1
ffffffffc0201348:	71c60613          	addi	a2,a2,1820 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020134c:	10d00593          	li	a1,269
ffffffffc0201350:	00001517          	auipc	a0,0x1
ffffffffc0201354:	72850513          	addi	a0,a0,1832 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201358:	87cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020135c:	00002697          	auipc	a3,0x2
ffffffffc0201360:	97c68693          	addi	a3,a3,-1668 # ffffffffc0202cd8 <etext+0xcc8>
ffffffffc0201364:	00001617          	auipc	a2,0x1
ffffffffc0201368:	6fc60613          	addi	a2,a2,1788 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020136c:	10800593          	li	a1,264
ffffffffc0201370:	00001517          	auipc	a0,0x1
ffffffffc0201374:	70850513          	addi	a0,a0,1800 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201378:	85cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020137c:	00002697          	auipc	a3,0x2
ffffffffc0201380:	85c68693          	addi	a3,a3,-1956 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc0201384:	00001617          	auipc	a2,0x1
ffffffffc0201388:	6dc60613          	addi	a2,a2,1756 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020138c:	10700593          	li	a1,263
ffffffffc0201390:	00001517          	auipc	a0,0x1
ffffffffc0201394:	6e850513          	addi	a0,a0,1768 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201398:	83cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020139c:	00002697          	auipc	a3,0x2
ffffffffc02013a0:	91c68693          	addi	a3,a3,-1764 # ffffffffc0202cb8 <etext+0xca8>
ffffffffc02013a4:	00001617          	auipc	a2,0x1
ffffffffc02013a8:	6bc60613          	addi	a2,a2,1724 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02013ac:	10600593          	li	a1,262
ffffffffc02013b0:	00001517          	auipc	a0,0x1
ffffffffc02013b4:	6c850513          	addi	a0,a0,1736 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02013b8:	81cff0ef          	jal	ffffffffc02003d4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02013bc:	00002697          	auipc	a3,0x2
ffffffffc02013c0:	8cc68693          	addi	a3,a3,-1844 # ffffffffc0202c88 <etext+0xc78>
ffffffffc02013c4:	00001617          	auipc	a2,0x1
ffffffffc02013c8:	69c60613          	addi	a2,a2,1692 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02013cc:	10500593          	li	a1,261
ffffffffc02013d0:	00001517          	auipc	a0,0x1
ffffffffc02013d4:	6a850513          	addi	a0,a0,1704 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02013d8:	ffdfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02013dc:	00002697          	auipc	a3,0x2
ffffffffc02013e0:	89468693          	addi	a3,a3,-1900 # ffffffffc0202c70 <etext+0xc60>
ffffffffc02013e4:	00001617          	auipc	a2,0x1
ffffffffc02013e8:	67c60613          	addi	a2,a2,1660 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02013ec:	10400593          	li	a1,260
ffffffffc02013f0:	00001517          	auipc	a0,0x1
ffffffffc02013f4:	68850513          	addi	a0,a0,1672 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02013f8:	fddfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013fc:	00001697          	auipc	a3,0x1
ffffffffc0201400:	7dc68693          	addi	a3,a3,2012 # ffffffffc0202bd8 <etext+0xbc8>
ffffffffc0201404:	00001617          	auipc	a2,0x1
ffffffffc0201408:	65c60613          	addi	a2,a2,1628 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020140c:	0fe00593          	li	a1,254
ffffffffc0201410:	00001517          	auipc	a0,0x1
ffffffffc0201414:	66850513          	addi	a0,a0,1640 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201418:	fbdfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(!PageProperty(p0));
ffffffffc020141c:	00002697          	auipc	a3,0x2
ffffffffc0201420:	83c68693          	addi	a3,a3,-1988 # ffffffffc0202c58 <etext+0xc48>
ffffffffc0201424:	00001617          	auipc	a2,0x1
ffffffffc0201428:	63c60613          	addi	a2,a2,1596 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020142c:	0f900593          	li	a1,249
ffffffffc0201430:	00001517          	auipc	a0,0x1
ffffffffc0201434:	64850513          	addi	a0,a0,1608 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201438:	f9dfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020143c:	00002697          	auipc	a3,0x2
ffffffffc0201440:	93c68693          	addi	a3,a3,-1732 # ffffffffc0202d78 <etext+0xd68>
ffffffffc0201444:	00001617          	auipc	a2,0x1
ffffffffc0201448:	61c60613          	addi	a2,a2,1564 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020144c:	11700593          	li	a1,279
ffffffffc0201450:	00001517          	auipc	a0,0x1
ffffffffc0201454:	62850513          	addi	a0,a0,1576 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201458:	f7dfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(total == 0);
ffffffffc020145c:	00002697          	auipc	a3,0x2
ffffffffc0201460:	94c68693          	addi	a3,a3,-1716 # ffffffffc0202da8 <etext+0xd98>
ffffffffc0201464:	00001617          	auipc	a2,0x1
ffffffffc0201468:	5fc60613          	addi	a2,a2,1532 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020146c:	12600593          	li	a1,294
ffffffffc0201470:	00001517          	auipc	a0,0x1
ffffffffc0201474:	60850513          	addi	a0,a0,1544 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201478:	f5dfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(total == nr_free_pages());
ffffffffc020147c:	00001697          	auipc	a3,0x1
ffffffffc0201480:	61468693          	addi	a3,a3,1556 # ffffffffc0202a90 <etext+0xa80>
ffffffffc0201484:	00001617          	auipc	a2,0x1
ffffffffc0201488:	5dc60613          	addi	a2,a2,1500 # ffffffffc0202a60 <etext+0xa50>
ffffffffc020148c:	0f300593          	li	a1,243
ffffffffc0201490:	00001517          	auipc	a0,0x1
ffffffffc0201494:	5e850513          	addi	a0,a0,1512 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201498:	f3dfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020149c:	00001697          	auipc	a3,0x1
ffffffffc02014a0:	63468693          	addi	a3,a3,1588 # ffffffffc0202ad0 <etext+0xac0>
ffffffffc02014a4:	00001617          	auipc	a2,0x1
ffffffffc02014a8:	5bc60613          	addi	a2,a2,1468 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02014ac:	0ba00593          	li	a1,186
ffffffffc02014b0:	00001517          	auipc	a0,0x1
ffffffffc02014b4:	5c850513          	addi	a0,a0,1480 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02014b8:	f1dfe0ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc02014bc <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02014bc:	1141                	addi	sp,sp,-16
ffffffffc02014be:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014c0:	14058c63          	beqz	a1,ffffffffc0201618 <default_free_pages+0x15c>
    for (; p != base + n; p ++) {
ffffffffc02014c4:	00259713          	slli	a4,a1,0x2
ffffffffc02014c8:	972e                	add	a4,a4,a1
ffffffffc02014ca:	070e                	slli	a4,a4,0x3
ffffffffc02014cc:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc02014d0:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc02014d2:	c30d                	beqz	a4,ffffffffc02014f4 <default_free_pages+0x38>
ffffffffc02014d4:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02014d6:	8b05                	andi	a4,a4,1
ffffffffc02014d8:	12071063          	bnez	a4,ffffffffc02015f8 <default_free_pages+0x13c>
ffffffffc02014dc:	6798                	ld	a4,8(a5)
ffffffffc02014de:	8b09                	andi	a4,a4,2
ffffffffc02014e0:	10071c63          	bnez	a4,ffffffffc02015f8 <default_free_pages+0x13c>
        p->flags = 0;
ffffffffc02014e4:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02014e8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02014ec:	02878793          	addi	a5,a5,40
ffffffffc02014f0:	fed792e3          	bne	a5,a3,ffffffffc02014d4 <default_free_pages+0x18>
    base->property = n;
ffffffffc02014f4:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02014f6:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02014fa:	4789                	li	a5,2
ffffffffc02014fc:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201500:	00006717          	auipc	a4,0x6
ffffffffc0201504:	b3872703          	lw	a4,-1224(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201508:	00006697          	auipc	a3,0x6
ffffffffc020150c:	b2068693          	addi	a3,a3,-1248 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc0201510:	669c                	ld	a5,8(a3)
ffffffffc0201512:	9f2d                	addw	a4,a4,a1
ffffffffc0201514:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201516:	0ad78563          	beq	a5,a3,ffffffffc02015c0 <default_free_pages+0x104>
            struct Page* page = le2page(le, page_link);
ffffffffc020151a:	fe878713          	addi	a4,a5,-24
ffffffffc020151e:	4581                	li	a1,0
ffffffffc0201520:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201524:	00e56a63          	bltu	a0,a4,ffffffffc0201538 <default_free_pages+0x7c>
    return listelm->next;
ffffffffc0201528:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020152a:	06d70263          	beq	a4,a3,ffffffffc020158e <default_free_pages+0xd2>
    struct Page *p = base;
ffffffffc020152e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201530:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201534:	fee57ae3          	bgeu	a0,a4,ffffffffc0201528 <default_free_pages+0x6c>
ffffffffc0201538:	c199                	beqz	a1,ffffffffc020153e <default_free_pages+0x82>
ffffffffc020153a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020153e:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201540:	e390                	sd	a2,0(a5)
ffffffffc0201542:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc0201544:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201546:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0201548:	02d70063          	beq	a4,a3,ffffffffc0201568 <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc020154c:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201550:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc0201554:	02081613          	slli	a2,a6,0x20
ffffffffc0201558:	9201                	srli	a2,a2,0x20
ffffffffc020155a:	00261793          	slli	a5,a2,0x2
ffffffffc020155e:	97b2                	add	a5,a5,a2
ffffffffc0201560:	078e                	slli	a5,a5,0x3
ffffffffc0201562:	97ae                	add	a5,a5,a1
ffffffffc0201564:	02f50f63          	beq	a0,a5,ffffffffc02015a2 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc0201568:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc020156a:	00d70f63          	beq	a4,a3,ffffffffc0201588 <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc020156e:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0201570:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0201574:	02059613          	slli	a2,a1,0x20
ffffffffc0201578:	9201                	srli	a2,a2,0x20
ffffffffc020157a:	00261793          	slli	a5,a2,0x2
ffffffffc020157e:	97b2                	add	a5,a5,a2
ffffffffc0201580:	078e                	slli	a5,a5,0x3
ffffffffc0201582:	97aa                	add	a5,a5,a0
ffffffffc0201584:	04f68a63          	beq	a3,a5,ffffffffc02015d8 <default_free_pages+0x11c>
}
ffffffffc0201588:	60a2                	ld	ra,8(sp)
ffffffffc020158a:	0141                	addi	sp,sp,16
ffffffffc020158c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020158e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201590:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201592:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201594:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201596:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201598:	02d70d63          	beq	a4,a3,ffffffffc02015d2 <default_free_pages+0x116>
ffffffffc020159c:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020159e:	87ba                	mv	a5,a4
ffffffffc02015a0:	bf41                	j	ffffffffc0201530 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02015a2:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02015a4:	5675                	li	a2,-3
ffffffffc02015a6:	010787bb          	addw	a5,a5,a6
ffffffffc02015aa:	fef72c23          	sw	a5,-8(a4)
ffffffffc02015ae:	60c8b02f          	amoand.d	zero,a2,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015b2:	6d10                	ld	a2,24(a0)
ffffffffc02015b4:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc02015b6:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02015b8:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc02015ba:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02015bc:	e390                	sd	a2,0(a5)
ffffffffc02015be:	b775                	j	ffffffffc020156a <default_free_pages+0xae>
}
ffffffffc02015c0:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02015c2:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02015c6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02015c8:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02015ca:	e398                	sd	a4,0(a5)
ffffffffc02015cc:	e798                	sd	a4,8(a5)
}
ffffffffc02015ce:	0141                	addi	sp,sp,16
ffffffffc02015d0:	8082                	ret
ffffffffc02015d2:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02015d4:	873e                	mv	a4,a5
ffffffffc02015d6:	bf8d                	j	ffffffffc0201548 <default_free_pages+0x8c>
            base->property += p->property;
ffffffffc02015d8:	ff872783          	lw	a5,-8(a4)
ffffffffc02015dc:	56f5                	li	a3,-3
ffffffffc02015de:	9fad                	addw	a5,a5,a1
ffffffffc02015e0:	c91c                	sw	a5,16(a0)
ffffffffc02015e2:	ff070793          	addi	a5,a4,-16
ffffffffc02015e6:	60d7b02f          	amoand.d	zero,a3,(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015ea:	6314                	ld	a3,0(a4)
ffffffffc02015ec:	671c                	ld	a5,8(a4)
}
ffffffffc02015ee:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02015f0:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02015f2:	e394                	sd	a3,0(a5)
ffffffffc02015f4:	0141                	addi	sp,sp,16
ffffffffc02015f6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015f8:	00001697          	auipc	a3,0x1
ffffffffc02015fc:	7c868693          	addi	a3,a3,1992 # ffffffffc0202dc0 <etext+0xdb0>
ffffffffc0201600:	00001617          	auipc	a2,0x1
ffffffffc0201604:	46060613          	addi	a2,a2,1120 # ffffffffc0202a60 <etext+0xa50>
ffffffffc0201608:	08300593          	li	a1,131
ffffffffc020160c:	00001517          	auipc	a0,0x1
ffffffffc0201610:	46c50513          	addi	a0,a0,1132 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201614:	dc1fe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(n > 0);
ffffffffc0201618:	00001697          	auipc	a3,0x1
ffffffffc020161c:	7a068693          	addi	a3,a3,1952 # ffffffffc0202db8 <etext+0xda8>
ffffffffc0201620:	00001617          	auipc	a2,0x1
ffffffffc0201624:	44060613          	addi	a2,a2,1088 # ffffffffc0202a60 <etext+0xa50>
ffffffffc0201628:	08000593          	li	a1,128
ffffffffc020162c:	00001517          	auipc	a0,0x1
ffffffffc0201630:	44c50513          	addi	a0,a0,1100 # ffffffffc0202a78 <etext+0xa68>
ffffffffc0201634:	da1fe0ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc0201638 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201638:	cd41                	beqz	a0,ffffffffc02016d0 <default_alloc_pages+0x98>
    if (n > nr_free) {
ffffffffc020163a:	00006597          	auipc	a1,0x6
ffffffffc020163e:	9fe5a583          	lw	a1,-1538(a1) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201642:	86aa                	mv	a3,a0
ffffffffc0201644:	02059793          	slli	a5,a1,0x20
ffffffffc0201648:	9381                	srli	a5,a5,0x20
ffffffffc020164a:	00a7ef63          	bltu	a5,a0,ffffffffc0201668 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc020164e:	00006617          	auipc	a2,0x6
ffffffffc0201652:	9da60613          	addi	a2,a2,-1574 # ffffffffc0207028 <free_area>
ffffffffc0201656:	87b2                	mv	a5,a2
ffffffffc0201658:	a029                	j	ffffffffc0201662 <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc020165a:	ff87e703          	lwu	a4,-8(a5)
ffffffffc020165e:	00d77763          	bgeu	a4,a3,ffffffffc020166c <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc0201662:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201664:	fec79be3          	bne	a5,a2,ffffffffc020165a <default_alloc_pages+0x22>
        return NULL;
ffffffffc0201668:	4501                	li	a0,0
}
ffffffffc020166a:	8082                	ret
        if (page->property > n) {
ffffffffc020166c:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc0201670:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201674:	6798                	ld	a4,8(a5)
ffffffffc0201676:	02089313          	slli	t1,a7,0x20
ffffffffc020167a:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc020167e:	00e83423          	sd	a4,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    next->prev = prev;
ffffffffc0201682:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc0201686:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc020168a:	0266fc63          	bgeu	a3,t1,ffffffffc02016c2 <default_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc020168e:	00269713          	slli	a4,a3,0x2
ffffffffc0201692:	9736                	add	a4,a4,a3
ffffffffc0201694:	070e                	slli	a4,a4,0x3
            p->property = page->property - n;
ffffffffc0201696:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc020169a:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020169c:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016a0:	00870313          	addi	t1,a4,8
ffffffffc02016a4:	4889                	li	a7,2
ffffffffc02016a6:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02016aa:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc02016ae:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc02016b2:	0068b023          	sd	t1,0(a7)
ffffffffc02016b6:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc02016ba:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc02016be:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc02016c2:	9d95                	subw	a1,a1,a3
ffffffffc02016c4:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02016c6:	5775                	li	a4,-3
ffffffffc02016c8:	17c1                	addi	a5,a5,-16
ffffffffc02016ca:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02016ce:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02016d0:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02016d2:	00001697          	auipc	a3,0x1
ffffffffc02016d6:	6e668693          	addi	a3,a3,1766 # ffffffffc0202db8 <etext+0xda8>
ffffffffc02016da:	00001617          	auipc	a2,0x1
ffffffffc02016de:	38660613          	addi	a2,a2,902 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02016e2:	06200593          	li	a1,98
ffffffffc02016e6:	00001517          	auipc	a0,0x1
ffffffffc02016ea:	39250513          	addi	a0,a0,914 # ffffffffc0202a78 <etext+0xa68>
default_alloc_pages(size_t n) {
ffffffffc02016ee:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016f0:	ce5fe0ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc02016f4 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02016f4:	1141                	addi	sp,sp,-16
ffffffffc02016f6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016f8:	c9f1                	beqz	a1,ffffffffc02017cc <default_init_memmap+0xd8>
    for (; p != base + n; p ++) {
ffffffffc02016fa:	00259713          	slli	a4,a1,0x2
ffffffffc02016fe:	972e                	add	a4,a4,a1
ffffffffc0201700:	070e                	slli	a4,a4,0x3
ffffffffc0201702:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201706:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201708:	cf11                	beqz	a4,ffffffffc0201724 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020170a:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020170c:	8b05                	andi	a4,a4,1
ffffffffc020170e:	cf59                	beqz	a4,ffffffffc02017ac <default_init_memmap+0xb8>
        p->flags = p->property = 0;
ffffffffc0201710:	0007a823          	sw	zero,16(a5)
ffffffffc0201714:	0007b423          	sd	zero,8(a5)
ffffffffc0201718:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020171c:	02878793          	addi	a5,a5,40
ffffffffc0201720:	fed795e3          	bne	a5,a3,ffffffffc020170a <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201724:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201726:	4789                	li	a5,2
ffffffffc0201728:	00850713          	addi	a4,a0,8
ffffffffc020172c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201730:	00006717          	auipc	a4,0x6
ffffffffc0201734:	90872703          	lw	a4,-1784(a4) # ffffffffc0207038 <free_area+0x10>
ffffffffc0201738:	00006697          	auipc	a3,0x6
ffffffffc020173c:	8f068693          	addi	a3,a3,-1808 # ffffffffc0207028 <free_area>
    return list->next == list;
ffffffffc0201740:	669c                	ld	a5,8(a3)
ffffffffc0201742:	9f2d                	addw	a4,a4,a1
ffffffffc0201744:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201746:	04d78663          	beq	a5,a3,ffffffffc0201792 <default_init_memmap+0x9e>
            struct Page* page = le2page(le, page_link);
ffffffffc020174a:	fe878713          	addi	a4,a5,-24
ffffffffc020174e:	4581                	li	a1,0
ffffffffc0201750:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201754:	00e56a63          	bltu	a0,a4,ffffffffc0201768 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201758:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020175a:	02d70263          	beq	a4,a3,ffffffffc020177e <default_init_memmap+0x8a>
    struct Page *p = base;
ffffffffc020175e:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201760:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201764:	fee57ae3          	bgeu	a0,a4,ffffffffc0201758 <default_init_memmap+0x64>
ffffffffc0201768:	c199                	beqz	a1,ffffffffc020176e <default_init_memmap+0x7a>
ffffffffc020176a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020176e:	6398                	ld	a4,0(a5)
}
ffffffffc0201770:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201772:	e390                	sd	a2,0(a5)
ffffffffc0201774:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc0201776:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0201778:	f11c                	sd	a5,32(a0)
ffffffffc020177a:	0141                	addi	sp,sp,16
ffffffffc020177c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020177e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201780:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201782:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201784:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201786:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201788:	00d70e63          	beq	a4,a3,ffffffffc02017a4 <default_init_memmap+0xb0>
ffffffffc020178c:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc020178e:	87ba                	mv	a5,a4
ffffffffc0201790:	bfc1                	j	ffffffffc0201760 <default_init_memmap+0x6c>
}
ffffffffc0201792:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201794:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201798:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020179a:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc020179c:	e398                	sd	a4,0(a5)
ffffffffc020179e:	e798                	sd	a4,8(a5)
}
ffffffffc02017a0:	0141                	addi	sp,sp,16
ffffffffc02017a2:	8082                	ret
ffffffffc02017a4:	60a2                	ld	ra,8(sp)
ffffffffc02017a6:	e290                	sd	a2,0(a3)
ffffffffc02017a8:	0141                	addi	sp,sp,16
ffffffffc02017aa:	8082                	ret
        assert(PageReserved(p));
ffffffffc02017ac:	00001697          	auipc	a3,0x1
ffffffffc02017b0:	63c68693          	addi	a3,a3,1596 # ffffffffc0202de8 <etext+0xdd8>
ffffffffc02017b4:	00001617          	auipc	a2,0x1
ffffffffc02017b8:	2ac60613          	addi	a2,a2,684 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02017bc:	04900593          	li	a1,73
ffffffffc02017c0:	00001517          	auipc	a0,0x1
ffffffffc02017c4:	2b850513          	addi	a0,a0,696 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02017c8:	c0dfe0ef          	jal	ffffffffc02003d4 <__panic>
    assert(n > 0);
ffffffffc02017cc:	00001697          	auipc	a3,0x1
ffffffffc02017d0:	5ec68693          	addi	a3,a3,1516 # ffffffffc0202db8 <etext+0xda8>
ffffffffc02017d4:	00001617          	auipc	a2,0x1
ffffffffc02017d8:	28c60613          	addi	a2,a2,652 # ffffffffc0202a60 <etext+0xa50>
ffffffffc02017dc:	04600593          	li	a1,70
ffffffffc02017e0:	00001517          	auipc	a0,0x1
ffffffffc02017e4:	29850513          	addi	a0,a0,664 # ffffffffc0202a78 <etext+0xa68>
ffffffffc02017e8:	bedfe0ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc02017ec <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017ec:	100027f3          	csrr	a5,sstatus
ffffffffc02017f0:	8b89                	andi	a5,a5,2
ffffffffc02017f2:	e799                	bnez	a5,ffffffffc0201800 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02017f4:	00006797          	auipc	a5,0x6
ffffffffc02017f8:	c747b783          	ld	a5,-908(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc02017fc:	6f9c                	ld	a5,24(a5)
ffffffffc02017fe:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0201800:	1101                	addi	sp,sp,-32
ffffffffc0201802:	ec06                	sd	ra,24(sp)
ffffffffc0201804:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201806:	fc9fe0ef          	jal	ffffffffc02007ce <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020180a:	00006797          	auipc	a5,0x6
ffffffffc020180e:	c5e7b783          	ld	a5,-930(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201812:	6522                	ld	a0,8(sp)
ffffffffc0201814:	6f9c                	ld	a5,24(a5)
ffffffffc0201816:	9782                	jalr	a5
ffffffffc0201818:	e42a                	sd	a0,8(sp)
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc020181a:	faffe0ef          	jal	ffffffffc02007c8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc020181e:	60e2                	ld	ra,24(sp)
ffffffffc0201820:	6522                	ld	a0,8(sp)
ffffffffc0201822:	6105                	addi	sp,sp,32
ffffffffc0201824:	8082                	ret

ffffffffc0201826 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201826:	100027f3          	csrr	a5,sstatus
ffffffffc020182a:	8b89                	andi	a5,a5,2
ffffffffc020182c:	e799                	bnez	a5,ffffffffc020183a <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc020182e:	00006797          	auipc	a5,0x6
ffffffffc0201832:	c3a7b783          	ld	a5,-966(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201836:	739c                	ld	a5,32(a5)
ffffffffc0201838:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc020183a:	1101                	addi	sp,sp,-32
ffffffffc020183c:	ec06                	sd	ra,24(sp)
ffffffffc020183e:	e42e                	sd	a1,8(sp)
ffffffffc0201840:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201842:	f8dfe0ef          	jal	ffffffffc02007ce <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201846:	00006797          	auipc	a5,0x6
ffffffffc020184a:	c227b783          	ld	a5,-990(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc020184e:	65a2                	ld	a1,8(sp)
ffffffffc0201850:	6502                	ld	a0,0(sp)
ffffffffc0201852:	739c                	ld	a5,32(a5)
ffffffffc0201854:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201856:	60e2                	ld	ra,24(sp)
ffffffffc0201858:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020185a:	f6ffe06f          	j	ffffffffc02007c8 <intr_enable>

ffffffffc020185e <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020185e:	100027f3          	csrr	a5,sstatus
ffffffffc0201862:	8b89                	andi	a5,a5,2
ffffffffc0201864:	e799                	bnez	a5,ffffffffc0201872 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201866:	00006797          	auipc	a5,0x6
ffffffffc020186a:	c027b783          	ld	a5,-1022(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc020186e:	779c                	ld	a5,40(a5)
ffffffffc0201870:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201872:	1101                	addi	sp,sp,-32
ffffffffc0201874:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201876:	f59fe0ef          	jal	ffffffffc02007ce <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020187a:	00006797          	auipc	a5,0x6
ffffffffc020187e:	bee7b783          	ld	a5,-1042(a5) # ffffffffc0207468 <pmm_manager>
ffffffffc0201882:	779c                	ld	a5,40(a5)
ffffffffc0201884:	9782                	jalr	a5
ffffffffc0201886:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201888:	f41fe0ef          	jal	ffffffffc02007c8 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc020188c:	60e2                	ld	ra,24(sp)
ffffffffc020188e:	6522                	ld	a0,8(sp)
ffffffffc0201890:	6105                	addi	sp,sp,32
ffffffffc0201892:	8082                	ret

ffffffffc0201894 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201894:	00002797          	auipc	a5,0x2
ffffffffc0201898:	81478793          	addi	a5,a5,-2028 # ffffffffc02030a8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020189c:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020189e:	7139                	addi	sp,sp,-64
ffffffffc02018a0:	fc06                	sd	ra,56(sp)
ffffffffc02018a2:	f822                	sd	s0,48(sp)
ffffffffc02018a4:	f426                	sd	s1,40(sp)
ffffffffc02018a6:	ec4e                	sd	s3,24(sp)
ffffffffc02018a8:	f04a                	sd	s2,32(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02018aa:	00006417          	auipc	s0,0x6
ffffffffc02018ae:	bbe40413          	addi	s0,s0,-1090 # ffffffffc0207468 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02018b2:	00001517          	auipc	a0,0x1
ffffffffc02018b6:	55e50513          	addi	a0,a0,1374 # ffffffffc0202e10 <etext+0xe00>
    pmm_manager = &default_pmm_manager;
ffffffffc02018ba:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02018bc:	867fe0ef          	jal	ffffffffc0200122 <cprintf>
    pmm_manager->init();
ffffffffc02018c0:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02018c2:	00006497          	auipc	s1,0x6
ffffffffc02018c6:	bbe48493          	addi	s1,s1,-1090 # ffffffffc0207480 <va_pa_offset>
    pmm_manager->init();
ffffffffc02018ca:	679c                	ld	a5,8(a5)
ffffffffc02018cc:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02018ce:	57f5                	li	a5,-3
ffffffffc02018d0:	07fa                	slli	a5,a5,0x1e
ffffffffc02018d2:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc02018d4:	ee1fe0ef          	jal	ffffffffc02007b4 <get_memory_base>
ffffffffc02018d8:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02018da:	ee5fe0ef          	jal	ffffffffc02007be <get_memory_size>
    if (mem_size == 0) {
ffffffffc02018de:	16050063          	beqz	a0,ffffffffc0201a3e <pmm_init+0x1aa>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02018e2:	00a98933          	add	s2,s3,a0
ffffffffc02018e6:	e42a                	sd	a0,8(sp)
    cprintf("physcial memory map:\n");
ffffffffc02018e8:	00001517          	auipc	a0,0x1
ffffffffc02018ec:	57050513          	addi	a0,a0,1392 # ffffffffc0202e58 <etext+0xe48>
ffffffffc02018f0:	833fe0ef          	jal	ffffffffc0200122 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02018f4:	65a2                	ld	a1,8(sp)
ffffffffc02018f6:	864e                	mv	a2,s3
ffffffffc02018f8:	fff90693          	addi	a3,s2,-1
ffffffffc02018fc:	00001517          	auipc	a0,0x1
ffffffffc0201900:	57450513          	addi	a0,a0,1396 # ffffffffc0202e70 <etext+0xe60>
ffffffffc0201904:	81ffe0ef          	jal	ffffffffc0200122 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc0201908:	c80007b7          	lui	a5,0xc8000
ffffffffc020190c:	864a                	mv	a2,s2
ffffffffc020190e:	0d27e563          	bltu	a5,s2,ffffffffc02019d8 <pmm_init+0x144>
ffffffffc0201912:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201914:	00007697          	auipc	a3,0x7
ffffffffc0201918:	b8b68693          	addi	a3,a3,-1141 # ffffffffc020849f <end+0xfff>
ffffffffc020191c:	8efd                	and	a3,a3,a5
    npage = maxpa / PGSIZE;
ffffffffc020191e:	8231                	srli	a2,a2,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201920:	00006817          	auipc	a6,0x6
ffffffffc0201924:	b7080813          	addi	a6,a6,-1168 # ffffffffc0207490 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201928:	00006517          	auipc	a0,0x6
ffffffffc020192c:	b6050513          	addi	a0,a0,-1184 # ffffffffc0207488 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201930:	00d83023          	sd	a3,0(a6)
    npage = maxpa / PGSIZE;
ffffffffc0201934:	e110                	sd	a2,0(a0)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201936:	00080737          	lui	a4,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020193a:	87b6                	mv	a5,a3
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020193c:	02e60a63          	beq	a2,a4,ffffffffc0201970 <pmm_init+0xdc>
ffffffffc0201940:	4701                	li	a4,0
ffffffffc0201942:	4781                	li	a5,0
ffffffffc0201944:	4305                	li	t1,1
ffffffffc0201946:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc020194a:	96ba                	add	a3,a3,a4
ffffffffc020194c:	06a1                	addi	a3,a3,8
ffffffffc020194e:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201952:	6110                	ld	a2,0(a0)
ffffffffc0201954:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fdf7b61>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201956:	00083683          	ld	a3,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020195a:	011605b3          	add	a1,a2,a7
ffffffffc020195e:	02870713          	addi	a4,a4,40 # 80028 <kern_entry-0xffffffffc017ffd8>
ffffffffc0201962:	feb7e4e3          	bltu	a5,a1,ffffffffc020194a <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201966:	00259793          	slli	a5,a1,0x2
ffffffffc020196a:	97ae                	add	a5,a5,a1
ffffffffc020196c:	078e                	slli	a5,a5,0x3
ffffffffc020196e:	97b6                	add	a5,a5,a3
ffffffffc0201970:	c0200737          	lui	a4,0xc0200
ffffffffc0201974:	0ae7e863          	bltu	a5,a4,ffffffffc0201a24 <pmm_init+0x190>
ffffffffc0201978:	608c                	ld	a1,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020197a:	777d                	lui	a4,0xfffff
ffffffffc020197c:	00e97933          	and	s2,s2,a4
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201980:	8f8d                	sub	a5,a5,a1
    if (freemem < mem_end) {
ffffffffc0201982:	0527ed63          	bltu	a5,s2,ffffffffc02019dc <pmm_init+0x148>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201986:	601c                	ld	a5,0(s0)
ffffffffc0201988:	7b9c                	ld	a5,48(a5)
ffffffffc020198a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020198c:	00001517          	auipc	a0,0x1
ffffffffc0201990:	56c50513          	addi	a0,a0,1388 # ffffffffc0202ef8 <etext+0xee8>
ffffffffc0201994:	f8efe0ef          	jal	ffffffffc0200122 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201998:	00004597          	auipc	a1,0x4
ffffffffc020199c:	66858593          	addi	a1,a1,1640 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc02019a0:	00006797          	auipc	a5,0x6
ffffffffc02019a4:	acb7bc23          	sd	a1,-1320(a5) # ffffffffc0207478 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02019a8:	c02007b7          	lui	a5,0xc0200
ffffffffc02019ac:	0af5e563          	bltu	a1,a5,ffffffffc0201a56 <pmm_init+0x1c2>
ffffffffc02019b0:	609c                	ld	a5,0(s1)
}
ffffffffc02019b2:	7442                	ld	s0,48(sp)
ffffffffc02019b4:	70e2                	ld	ra,56(sp)
ffffffffc02019b6:	74a2                	ld	s1,40(sp)
ffffffffc02019b8:	7902                	ld	s2,32(sp)
ffffffffc02019ba:	69e2                	ld	s3,24(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02019bc:	40f586b3          	sub	a3,a1,a5
ffffffffc02019c0:	00006797          	auipc	a5,0x6
ffffffffc02019c4:	aad7b823          	sd	a3,-1360(a5) # ffffffffc0207470 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02019c8:	00001517          	auipc	a0,0x1
ffffffffc02019cc:	55050513          	addi	a0,a0,1360 # ffffffffc0202f18 <etext+0xf08>
ffffffffc02019d0:	8636                	mv	a2,a3
}
ffffffffc02019d2:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02019d4:	f4efe06f          	j	ffffffffc0200122 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc02019d8:	863e                	mv	a2,a5
ffffffffc02019da:	bf25                	j	ffffffffc0201912 <pmm_init+0x7e>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02019dc:	6585                	lui	a1,0x1
ffffffffc02019de:	15fd                	addi	a1,a1,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc02019e0:	97ae                	add	a5,a5,a1
ffffffffc02019e2:	8ff9                	and	a5,a5,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02019e4:	00c7d713          	srli	a4,a5,0xc
ffffffffc02019e8:	02c77263          	bgeu	a4,a2,ffffffffc0201a0c <pmm_init+0x178>
    pmm_manager->init_memmap(base, n);
ffffffffc02019ec:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02019ee:	fff805b7          	lui	a1,0xfff80
ffffffffc02019f2:	972e                	add	a4,a4,a1
ffffffffc02019f4:	00271513          	slli	a0,a4,0x2
ffffffffc02019f8:	953a                	add	a0,a0,a4
ffffffffc02019fa:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02019fc:	40f90933          	sub	s2,s2,a5
ffffffffc0201a00:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201a02:	00c95593          	srli	a1,s2,0xc
ffffffffc0201a06:	9536                	add	a0,a0,a3
ffffffffc0201a08:	9702                	jalr	a4
}
ffffffffc0201a0a:	bfb5                	j	ffffffffc0201986 <pmm_init+0xf2>
        panic("pa2page called with invalid pa");
ffffffffc0201a0c:	00001617          	auipc	a2,0x1
ffffffffc0201a10:	4bc60613          	addi	a2,a2,1212 # ffffffffc0202ec8 <etext+0xeb8>
ffffffffc0201a14:	06b00593          	li	a1,107
ffffffffc0201a18:	00001517          	auipc	a0,0x1
ffffffffc0201a1c:	4d050513          	addi	a0,a0,1232 # ffffffffc0202ee8 <etext+0xed8>
ffffffffc0201a20:	9b5fe0ef          	jal	ffffffffc02003d4 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201a24:	86be                	mv	a3,a5
ffffffffc0201a26:	00001617          	auipc	a2,0x1
ffffffffc0201a2a:	47a60613          	addi	a2,a2,1146 # ffffffffc0202ea0 <etext+0xe90>
ffffffffc0201a2e:	07100593          	li	a1,113
ffffffffc0201a32:	00001517          	auipc	a0,0x1
ffffffffc0201a36:	41650513          	addi	a0,a0,1046 # ffffffffc0202e48 <etext+0xe38>
ffffffffc0201a3a:	99bfe0ef          	jal	ffffffffc02003d4 <__panic>
        panic("DTB memory info not available");
ffffffffc0201a3e:	00001617          	auipc	a2,0x1
ffffffffc0201a42:	3ea60613          	addi	a2,a2,1002 # ffffffffc0202e28 <etext+0xe18>
ffffffffc0201a46:	05a00593          	li	a1,90
ffffffffc0201a4a:	00001517          	auipc	a0,0x1
ffffffffc0201a4e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0202e48 <etext+0xe38>
ffffffffc0201a52:	983fe0ef          	jal	ffffffffc02003d4 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201a56:	86ae                	mv	a3,a1
ffffffffc0201a58:	00001617          	auipc	a2,0x1
ffffffffc0201a5c:	44860613          	addi	a2,a2,1096 # ffffffffc0202ea0 <etext+0xe90>
ffffffffc0201a60:	08c00593          	li	a1,140
ffffffffc0201a64:	00001517          	auipc	a0,0x1
ffffffffc0201a68:	3e450513          	addi	a0,a0,996 # ffffffffc0202e48 <etext+0xe38>
ffffffffc0201a6c:	969fe0ef          	jal	ffffffffc02003d4 <__panic>

ffffffffc0201a70 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a70:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201a72:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a76:	f022                	sd	s0,32(sp)
ffffffffc0201a78:	ec26                	sd	s1,24(sp)
ffffffffc0201a7a:	e84a                	sd	s2,16(sp)
ffffffffc0201a7c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201a7e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a82:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201a84:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201a88:	fff7041b          	addiw	s0,a4,-1 # ffffffffffffefff <end+0x3fdf7b5f>
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201a8c:	84aa                	mv	s1,a0
ffffffffc0201a8e:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0201a90:	03067d63          	bgeu	a2,a6,ffffffffc0201aca <printnum+0x5a>
ffffffffc0201a94:	e44e                	sd	s3,8(sp)
ffffffffc0201a96:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201a98:	4785                	li	a5,1
ffffffffc0201a9a:	00e7d763          	bge	a5,a4,ffffffffc0201aa8 <printnum+0x38>
            putch(padc, putdat);
ffffffffc0201a9e:	85ca                	mv	a1,s2
ffffffffc0201aa0:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0201aa2:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201aa4:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201aa6:	fc65                	bnez	s0,ffffffffc0201a9e <printnum+0x2e>
ffffffffc0201aa8:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201aaa:	00001797          	auipc	a5,0x1
ffffffffc0201aae:	4ae78793          	addi	a5,a5,1198 # ffffffffc0202f58 <etext+0xf48>
ffffffffc0201ab2:	97d2                	add	a5,a5,s4
}
ffffffffc0201ab4:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201ab6:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201aba:	70a2                	ld	ra,40(sp)
ffffffffc0201abc:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201abe:	85ca                	mv	a1,s2
ffffffffc0201ac0:	87a6                	mv	a5,s1
}
ffffffffc0201ac2:	6942                	ld	s2,16(sp)
ffffffffc0201ac4:	64e2                	ld	s1,24(sp)
ffffffffc0201ac6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201ac8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201aca:	03065633          	divu	a2,a2,a6
ffffffffc0201ace:	8722                	mv	a4,s0
ffffffffc0201ad0:	fa1ff0ef          	jal	ffffffffc0201a70 <printnum>
ffffffffc0201ad4:	bfd9                	j	ffffffffc0201aaa <printnum+0x3a>

ffffffffc0201ad6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201ad6:	7119                	addi	sp,sp,-128
ffffffffc0201ad8:	f4a6                	sd	s1,104(sp)
ffffffffc0201ada:	f0ca                	sd	s2,96(sp)
ffffffffc0201adc:	ecce                	sd	s3,88(sp)
ffffffffc0201ade:	e8d2                	sd	s4,80(sp)
ffffffffc0201ae0:	e4d6                	sd	s5,72(sp)
ffffffffc0201ae2:	e0da                	sd	s6,64(sp)
ffffffffc0201ae4:	f862                	sd	s8,48(sp)
ffffffffc0201ae6:	fc86                	sd	ra,120(sp)
ffffffffc0201ae8:	f8a2                	sd	s0,112(sp)
ffffffffc0201aea:	fc5e                	sd	s7,56(sp)
ffffffffc0201aec:	f466                	sd	s9,40(sp)
ffffffffc0201aee:	f06a                	sd	s10,32(sp)
ffffffffc0201af0:	ec6e                	sd	s11,24(sp)
ffffffffc0201af2:	84aa                	mv	s1,a0
ffffffffc0201af4:	8c32                	mv	s8,a2
ffffffffc0201af6:	8a36                	mv	s4,a3
ffffffffc0201af8:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201afa:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201afe:	05500b13          	li	s6,85
ffffffffc0201b02:	00001a97          	auipc	s5,0x1
ffffffffc0201b06:	5dea8a93          	addi	s5,s5,1502 # ffffffffc02030e0 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b0a:	000c4503          	lbu	a0,0(s8)
ffffffffc0201b0e:	001c0413          	addi	s0,s8,1
ffffffffc0201b12:	01350a63          	beq	a0,s3,ffffffffc0201b26 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0201b16:	cd0d                	beqz	a0,ffffffffc0201b50 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0201b18:	85ca                	mv	a1,s2
ffffffffc0201b1a:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b1c:	00044503          	lbu	a0,0(s0)
ffffffffc0201b20:	0405                	addi	s0,s0,1
ffffffffc0201b22:	ff351ae3          	bne	a0,s3,ffffffffc0201b16 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0201b26:	5cfd                	li	s9,-1
ffffffffc0201b28:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0201b2a:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0201b2e:	4b81                	li	s7,0
ffffffffc0201b30:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b32:	00044683          	lbu	a3,0(s0)
ffffffffc0201b36:	00140c13          	addi	s8,s0,1
ffffffffc0201b3a:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0201b3e:	0ff5f593          	zext.b	a1,a1
ffffffffc0201b42:	02bb6663          	bltu	s6,a1,ffffffffc0201b6e <vprintfmt+0x98>
ffffffffc0201b46:	058a                	slli	a1,a1,0x2
ffffffffc0201b48:	95d6                	add	a1,a1,s5
ffffffffc0201b4a:	4198                	lw	a4,0(a1)
ffffffffc0201b4c:	9756                	add	a4,a4,s5
ffffffffc0201b4e:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201b50:	70e6                	ld	ra,120(sp)
ffffffffc0201b52:	7446                	ld	s0,112(sp)
ffffffffc0201b54:	74a6                	ld	s1,104(sp)
ffffffffc0201b56:	7906                	ld	s2,96(sp)
ffffffffc0201b58:	69e6                	ld	s3,88(sp)
ffffffffc0201b5a:	6a46                	ld	s4,80(sp)
ffffffffc0201b5c:	6aa6                	ld	s5,72(sp)
ffffffffc0201b5e:	6b06                	ld	s6,64(sp)
ffffffffc0201b60:	7be2                	ld	s7,56(sp)
ffffffffc0201b62:	7c42                	ld	s8,48(sp)
ffffffffc0201b64:	7ca2                	ld	s9,40(sp)
ffffffffc0201b66:	7d02                	ld	s10,32(sp)
ffffffffc0201b68:	6de2                	ld	s11,24(sp)
ffffffffc0201b6a:	6109                	addi	sp,sp,128
ffffffffc0201b6c:	8082                	ret
            putch('%', putdat);
ffffffffc0201b6e:	85ca                	mv	a1,s2
ffffffffc0201b70:	02500513          	li	a0,37
ffffffffc0201b74:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201b76:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201b7a:	02500713          	li	a4,37
ffffffffc0201b7e:	8c22                	mv	s8,s0
ffffffffc0201b80:	f8e785e3          	beq	a5,a4,ffffffffc0201b0a <vprintfmt+0x34>
ffffffffc0201b84:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0201b88:	1c7d                	addi	s8,s8,-1
ffffffffc0201b8a:	fee79de3          	bne	a5,a4,ffffffffc0201b84 <vprintfmt+0xae>
ffffffffc0201b8e:	bfb5                	j	ffffffffc0201b0a <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0201b90:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0201b94:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0201b96:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0201b9a:	fd06071b          	addiw	a4,a2,-48
ffffffffc0201b9e:	24e56a63          	bltu	a0,a4,ffffffffc0201df2 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0201ba2:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ba4:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0201ba6:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0201baa:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201bae:	0197073b          	addw	a4,a4,s9
ffffffffc0201bb2:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201bb6:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201bb8:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201bbc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201bbe:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201bc2:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0201bc6:	feb570e3          	bgeu	a0,a1,ffffffffc0201ba6 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0201bca:	f60d54e3          	bgez	s10,ffffffffc0201b32 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0201bce:	8d66                	mv	s10,s9
ffffffffc0201bd0:	5cfd                	li	s9,-1
ffffffffc0201bd2:	b785                	j	ffffffffc0201b32 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bd4:	8db6                	mv	s11,a3
ffffffffc0201bd6:	8462                	mv	s0,s8
ffffffffc0201bd8:	bfa9                	j	ffffffffc0201b32 <vprintfmt+0x5c>
ffffffffc0201bda:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0201bdc:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0201bde:	bf91                	j	ffffffffc0201b32 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0201be0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201be2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201be6:	00f74463          	blt	a4,a5,ffffffffc0201bee <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0201bea:	1a078763          	beqz	a5,ffffffffc0201d98 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0201bee:	000a3603          	ld	a2,0(s4)
ffffffffc0201bf2:	46c1                	li	a3,16
ffffffffc0201bf4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201bf6:	000d879b          	sext.w	a5,s11
ffffffffc0201bfa:	876a                	mv	a4,s10
ffffffffc0201bfc:	85ca                	mv	a1,s2
ffffffffc0201bfe:	8526                	mv	a0,s1
ffffffffc0201c00:	e71ff0ef          	jal	ffffffffc0201a70 <printnum>
            break;
ffffffffc0201c04:	b719                	j	ffffffffc0201b0a <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0201c06:	000a2503          	lw	a0,0(s4)
ffffffffc0201c0a:	85ca                	mv	a1,s2
ffffffffc0201c0c:	0a21                	addi	s4,s4,8
ffffffffc0201c0e:	9482                	jalr	s1
            break;
ffffffffc0201c10:	bded                	j	ffffffffc0201b0a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201c12:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c14:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201c18:	00f74463          	blt	a4,a5,ffffffffc0201c20 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0201c1c:	16078963          	beqz	a5,ffffffffc0201d8e <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0201c20:	000a3603          	ld	a2,0(s4)
ffffffffc0201c24:	46a9                	li	a3,10
ffffffffc0201c26:	8a2e                	mv	s4,a1
ffffffffc0201c28:	b7f9                	j	ffffffffc0201bf6 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0201c2a:	85ca                	mv	a1,s2
ffffffffc0201c2c:	03000513          	li	a0,48
ffffffffc0201c30:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0201c32:	85ca                	mv	a1,s2
ffffffffc0201c34:	07800513          	li	a0,120
ffffffffc0201c38:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201c3a:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0201c3e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201c40:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201c42:	bf55                	j	ffffffffc0201bf6 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0201c44:	85ca                	mv	a1,s2
ffffffffc0201c46:	02500513          	li	a0,37
ffffffffc0201c4a:	9482                	jalr	s1
            break;
ffffffffc0201c4c:	bd7d                	j	ffffffffc0201b0a <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0201c4e:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c52:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0201c54:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0201c56:	bf95                	j	ffffffffc0201bca <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0201c58:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c5a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201c5e:	00f74463          	blt	a4,a5,ffffffffc0201c66 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0201c62:	12078163          	beqz	a5,ffffffffc0201d84 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0201c66:	000a3603          	ld	a2,0(s4)
ffffffffc0201c6a:	46a1                	li	a3,8
ffffffffc0201c6c:	8a2e                	mv	s4,a1
ffffffffc0201c6e:	b761                	j	ffffffffc0201bf6 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0201c70:	876a                	mv	a4,s10
ffffffffc0201c72:	000d5363          	bgez	s10,ffffffffc0201c78 <vprintfmt+0x1a2>
ffffffffc0201c76:	4701                	li	a4,0
ffffffffc0201c78:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c7c:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201c7e:	bd55                	j	ffffffffc0201b32 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0201c80:	000d841b          	sext.w	s0,s11
ffffffffc0201c84:	fd340793          	addi	a5,s0,-45
ffffffffc0201c88:	00f037b3          	snez	a5,a5
ffffffffc0201c8c:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c90:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0201c94:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201c96:	008a0793          	addi	a5,s4,8
ffffffffc0201c9a:	e43e                	sd	a5,8(sp)
ffffffffc0201c9c:	100d8c63          	beqz	s11,ffffffffc0201db4 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0201ca0:	12071363          	bnez	a4,ffffffffc0201dc6 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201ca4:	000dc783          	lbu	a5,0(s11)
ffffffffc0201ca8:	0007851b          	sext.w	a0,a5
ffffffffc0201cac:	c78d                	beqz	a5,ffffffffc0201cd6 <vprintfmt+0x200>
ffffffffc0201cae:	0d85                	addi	s11,s11,1
ffffffffc0201cb0:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201cb2:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cb6:	000cc563          	bltz	s9,ffffffffc0201cc0 <vprintfmt+0x1ea>
ffffffffc0201cba:	3cfd                	addiw	s9,s9,-1
ffffffffc0201cbc:	008c8d63          	beq	s9,s0,ffffffffc0201cd6 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201cc0:	020b9663          	bnez	s7,ffffffffc0201cec <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0201cc4:	85ca                	mv	a1,s2
ffffffffc0201cc6:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cc8:	000dc783          	lbu	a5,0(s11)
ffffffffc0201ccc:	0d85                	addi	s11,s11,1
ffffffffc0201cce:	3d7d                	addiw	s10,s10,-1
ffffffffc0201cd0:	0007851b          	sext.w	a0,a5
ffffffffc0201cd4:	f3ed                	bnez	a5,ffffffffc0201cb6 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0201cd6:	01a05963          	blez	s10,ffffffffc0201ce8 <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0201cda:	85ca                	mv	a1,s2
ffffffffc0201cdc:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0201ce0:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0201ce2:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0201ce4:	fe0d1be3          	bnez	s10,ffffffffc0201cda <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201ce8:	6a22                	ld	s4,8(sp)
ffffffffc0201cea:	b505                	j	ffffffffc0201b0a <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201cec:	3781                	addiw	a5,a5,-32
ffffffffc0201cee:	fcfa7be3          	bgeu	s4,a5,ffffffffc0201cc4 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0201cf2:	03f00513          	li	a0,63
ffffffffc0201cf6:	85ca                	mv	a1,s2
ffffffffc0201cf8:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cfa:	000dc783          	lbu	a5,0(s11)
ffffffffc0201cfe:	0d85                	addi	s11,s11,1
ffffffffc0201d00:	3d7d                	addiw	s10,s10,-1
ffffffffc0201d02:	0007851b          	sext.w	a0,a5
ffffffffc0201d06:	dbe1                	beqz	a5,ffffffffc0201cd6 <vprintfmt+0x200>
ffffffffc0201d08:	fa0cd9e3          	bgez	s9,ffffffffc0201cba <vprintfmt+0x1e4>
ffffffffc0201d0c:	b7c5                	j	ffffffffc0201cec <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0201d0e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201d12:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0201d14:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201d16:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0201d1a:	8fb9                	xor	a5,a5,a4
ffffffffc0201d1c:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201d20:	02d64563          	blt	a2,a3,ffffffffc0201d4a <vprintfmt+0x274>
ffffffffc0201d24:	00001797          	auipc	a5,0x1
ffffffffc0201d28:	51478793          	addi	a5,a5,1300 # ffffffffc0203238 <error_string>
ffffffffc0201d2c:	00369713          	slli	a4,a3,0x3
ffffffffc0201d30:	97ba                	add	a5,a5,a4
ffffffffc0201d32:	639c                	ld	a5,0(a5)
ffffffffc0201d34:	cb99                	beqz	a5,ffffffffc0201d4a <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201d36:	86be                	mv	a3,a5
ffffffffc0201d38:	00001617          	auipc	a2,0x1
ffffffffc0201d3c:	25060613          	addi	a2,a2,592 # ffffffffc0202f88 <etext+0xf78>
ffffffffc0201d40:	85ca                	mv	a1,s2
ffffffffc0201d42:	8526                	mv	a0,s1
ffffffffc0201d44:	0d8000ef          	jal	ffffffffc0201e1c <printfmt>
ffffffffc0201d48:	b3c9                	j	ffffffffc0201b0a <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201d4a:	00001617          	auipc	a2,0x1
ffffffffc0201d4e:	22e60613          	addi	a2,a2,558 # ffffffffc0202f78 <etext+0xf68>
ffffffffc0201d52:	85ca                	mv	a1,s2
ffffffffc0201d54:	8526                	mv	a0,s1
ffffffffc0201d56:	0c6000ef          	jal	ffffffffc0201e1c <printfmt>
ffffffffc0201d5a:	bb45                	j	ffffffffc0201b0a <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0201d5c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201d5e:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0201d62:	00f74363          	blt	a4,a5,ffffffffc0201d68 <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0201d66:	cf81                	beqz	a5,ffffffffc0201d7e <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0201d68:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201d6c:	02044b63          	bltz	s0,ffffffffc0201da2 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0201d70:	8622                	mv	a2,s0
ffffffffc0201d72:	8a5e                	mv	s4,s7
ffffffffc0201d74:	46a9                	li	a3,10
ffffffffc0201d76:	b541                	j	ffffffffc0201bf6 <vprintfmt+0x120>
            lflag ++;
ffffffffc0201d78:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201d7a:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0201d7c:	bb5d                	j	ffffffffc0201b32 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0201d7e:	000a2403          	lw	s0,0(s4)
ffffffffc0201d82:	b7ed                	j	ffffffffc0201d6c <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0201d84:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d88:	46a1                	li	a3,8
ffffffffc0201d8a:	8a2e                	mv	s4,a1
ffffffffc0201d8c:	b5ad                	j	ffffffffc0201bf6 <vprintfmt+0x120>
ffffffffc0201d8e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d92:	46a9                	li	a3,10
ffffffffc0201d94:	8a2e                	mv	s4,a1
ffffffffc0201d96:	b585                	j	ffffffffc0201bf6 <vprintfmt+0x120>
ffffffffc0201d98:	000a6603          	lwu	a2,0(s4)
ffffffffc0201d9c:	46c1                	li	a3,16
ffffffffc0201d9e:	8a2e                	mv	s4,a1
ffffffffc0201da0:	bd99                	j	ffffffffc0201bf6 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0201da2:	85ca                	mv	a1,s2
ffffffffc0201da4:	02d00513          	li	a0,45
ffffffffc0201da8:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0201daa:	40800633          	neg	a2,s0
ffffffffc0201dae:	8a5e                	mv	s4,s7
ffffffffc0201db0:	46a9                	li	a3,10
ffffffffc0201db2:	b591                	j	ffffffffc0201bf6 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0201db4:	e329                	bnez	a4,ffffffffc0201df6 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201db6:	02800793          	li	a5,40
ffffffffc0201dba:	853e                	mv	a0,a5
ffffffffc0201dbc:	00001d97          	auipc	s11,0x1
ffffffffc0201dc0:	1b5d8d93          	addi	s11,s11,437 # ffffffffc0202f71 <etext+0xf61>
ffffffffc0201dc4:	b5f5                	j	ffffffffc0201cb0 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dc6:	85e6                	mv	a1,s9
ffffffffc0201dc8:	856e                	mv	a0,s11
ffffffffc0201dca:	1aa000ef          	jal	ffffffffc0201f74 <strnlen>
ffffffffc0201dce:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0201dd2:	01a05863          	blez	s10,ffffffffc0201de2 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0201dd6:	85ca                	mv	a1,s2
ffffffffc0201dd8:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dda:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0201ddc:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dde:	fe0d1ce3          	bnez	s10,ffffffffc0201dd6 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201de2:	000dc783          	lbu	a5,0(s11)
ffffffffc0201de6:	0007851b          	sext.w	a0,a5
ffffffffc0201dea:	ec0792e3          	bnez	a5,ffffffffc0201cae <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201dee:	6a22                	ld	s4,8(sp)
ffffffffc0201df0:	bb29                	j	ffffffffc0201b0a <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201df2:	8462                	mv	s0,s8
ffffffffc0201df4:	bbd9                	j	ffffffffc0201bca <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201df6:	85e6                	mv	a1,s9
ffffffffc0201df8:	00001517          	auipc	a0,0x1
ffffffffc0201dfc:	17850513          	addi	a0,a0,376 # ffffffffc0202f70 <etext+0xf60>
ffffffffc0201e00:	174000ef          	jal	ffffffffc0201f74 <strnlen>
ffffffffc0201e04:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201e08:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0201e0c:	00001d97          	auipc	s11,0x1
ffffffffc0201e10:	164d8d93          	addi	s11,s11,356 # ffffffffc0202f70 <etext+0xf60>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201e14:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201e16:	fda040e3          	bgtz	s10,ffffffffc0201dd6 <vprintfmt+0x300>
ffffffffc0201e1a:	bd51                	j	ffffffffc0201cae <vprintfmt+0x1d8>

ffffffffc0201e1c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e1c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201e1e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e22:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201e24:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e26:	ec06                	sd	ra,24(sp)
ffffffffc0201e28:	f83a                	sd	a4,48(sp)
ffffffffc0201e2a:	fc3e                	sd	a5,56(sp)
ffffffffc0201e2c:	e0c2                	sd	a6,64(sp)
ffffffffc0201e2e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201e30:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201e32:	ca5ff0ef          	jal	ffffffffc0201ad6 <vprintfmt>
}
ffffffffc0201e36:	60e2                	ld	ra,24(sp)
ffffffffc0201e38:	6161                	addi	sp,sp,80
ffffffffc0201e3a:	8082                	ret

ffffffffc0201e3c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201e3c:	7179                	addi	sp,sp,-48
ffffffffc0201e3e:	f406                	sd	ra,40(sp)
ffffffffc0201e40:	f022                	sd	s0,32(sp)
ffffffffc0201e42:	ec26                	sd	s1,24(sp)
ffffffffc0201e44:	e84a                	sd	s2,16(sp)
ffffffffc0201e46:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc0201e48:	c901                	beqz	a0,ffffffffc0201e58 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc0201e4a:	85aa                	mv	a1,a0
ffffffffc0201e4c:	00001517          	auipc	a0,0x1
ffffffffc0201e50:	13c50513          	addi	a0,a0,316 # ffffffffc0202f88 <etext+0xf78>
ffffffffc0201e54:	acefe0ef          	jal	ffffffffc0200122 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc0201e58:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e5a:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc0201e5c:	00005997          	auipc	s3,0x5
ffffffffc0201e60:	1e498993          	addi	s3,s3,484 # ffffffffc0207040 <buf>
        c = getchar();
ffffffffc0201e64:	b40fe0ef          	jal	ffffffffc02001a4 <getchar>
ffffffffc0201e68:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201e6a:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e6e:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201e72:	ff650693          	addi	a3,a0,-10
ffffffffc0201e76:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201e7a:	02054963          	bltz	a0,ffffffffc0201eac <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e7e:	02a95f63          	bge	s2,a0,ffffffffc0201ebc <readline+0x80>
ffffffffc0201e82:	cf0d                	beqz	a4,ffffffffc0201ebc <readline+0x80>
            cputchar(c);
ffffffffc0201e84:	ad2fe0ef          	jal	ffffffffc0200156 <cputchar>
            buf[i ++] = c;
ffffffffc0201e88:	009987b3          	add	a5,s3,s1
ffffffffc0201e8c:	00878023          	sb	s0,0(a5)
ffffffffc0201e90:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc0201e92:	b12fe0ef          	jal	ffffffffc02001a4 <getchar>
ffffffffc0201e96:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0201e98:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201e9c:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc0201ea0:	ff650693          	addi	a3,a0,-10
ffffffffc0201ea4:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0201ea8:	fc055be3          	bgez	a0,ffffffffc0201e7e <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0201eac:	70a2                	ld	ra,40(sp)
ffffffffc0201eae:	7402                	ld	s0,32(sp)
ffffffffc0201eb0:	64e2                	ld	s1,24(sp)
ffffffffc0201eb2:	6942                	ld	s2,16(sp)
ffffffffc0201eb4:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0201eb6:	4501                	li	a0,0
}
ffffffffc0201eb8:	6145                	addi	sp,sp,48
ffffffffc0201eba:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0201ebc:	eb81                	bnez	a5,ffffffffc0201ecc <readline+0x90>
            cputchar(c);
ffffffffc0201ebe:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc0201ec0:	00905663          	blez	s1,ffffffffc0201ecc <readline+0x90>
            cputchar(c);
ffffffffc0201ec4:	a92fe0ef          	jal	ffffffffc0200156 <cputchar>
            i --;
ffffffffc0201ec8:	34fd                	addiw	s1,s1,-1
ffffffffc0201eca:	bf69                	j	ffffffffc0201e64 <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0201ecc:	c291                	beqz	a3,ffffffffc0201ed0 <readline+0x94>
ffffffffc0201ece:	fa59                	bnez	a2,ffffffffc0201e64 <readline+0x28>
            cputchar(c);
ffffffffc0201ed0:	8522                	mv	a0,s0
ffffffffc0201ed2:	a84fe0ef          	jal	ffffffffc0200156 <cputchar>
            buf[i] = '\0';
ffffffffc0201ed6:	00005517          	auipc	a0,0x5
ffffffffc0201eda:	16a50513          	addi	a0,a0,362 # ffffffffc0207040 <buf>
ffffffffc0201ede:	94aa                	add	s1,s1,a0
ffffffffc0201ee0:	00048023          	sb	zero,0(s1)
}
ffffffffc0201ee4:	70a2                	ld	ra,40(sp)
ffffffffc0201ee6:	7402                	ld	s0,32(sp)
ffffffffc0201ee8:	64e2                	ld	s1,24(sp)
ffffffffc0201eea:	6942                	ld	s2,16(sp)
ffffffffc0201eec:	69a2                	ld	s3,8(sp)
ffffffffc0201eee:	6145                	addi	sp,sp,48
ffffffffc0201ef0:	8082                	ret

ffffffffc0201ef2 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201ef2:	00005717          	auipc	a4,0x5
ffffffffc0201ef6:	12e73703          	ld	a4,302(a4) # ffffffffc0207020 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201efa:	4781                	li	a5,0
ffffffffc0201efc:	88ba                	mv	a7,a4
ffffffffc0201efe:	852a                	mv	a0,a0
ffffffffc0201f00:	85be                	mv	a1,a5
ffffffffc0201f02:	863e                	mv	a2,a5
ffffffffc0201f04:	00000073          	ecall
ffffffffc0201f08:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201f0a:	8082                	ret

ffffffffc0201f0c <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201f0c:	00005717          	auipc	a4,0x5
ffffffffc0201f10:	58c73703          	ld	a4,1420(a4) # ffffffffc0207498 <SBI_SET_TIMER>
ffffffffc0201f14:	4781                	li	a5,0
ffffffffc0201f16:	88ba                	mv	a7,a4
ffffffffc0201f18:	852a                	mv	a0,a0
ffffffffc0201f1a:	85be                	mv	a1,a5
ffffffffc0201f1c:	863e                	mv	a2,a5
ffffffffc0201f1e:	00000073          	ecall
ffffffffc0201f22:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201f24:	8082                	ret

ffffffffc0201f26 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201f26:	00005797          	auipc	a5,0x5
ffffffffc0201f2a:	0f27b783          	ld	a5,242(a5) # ffffffffc0207018 <SBI_CONSOLE_GETCHAR>
ffffffffc0201f2e:	4501                	li	a0,0
ffffffffc0201f30:	88be                	mv	a7,a5
ffffffffc0201f32:	852a                	mv	a0,a0
ffffffffc0201f34:	85aa                	mv	a1,a0
ffffffffc0201f36:	862a                	mv	a2,a0
ffffffffc0201f38:	00000073          	ecall
ffffffffc0201f3c:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201f3e:	2501                	sext.w	a0,a0
ffffffffc0201f40:	8082                	ret

ffffffffc0201f42 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201f42:	00005717          	auipc	a4,0x5
ffffffffc0201f46:	0ce73703          	ld	a4,206(a4) # ffffffffc0207010 <SBI_SHUTDOWN>
ffffffffc0201f4a:	4781                	li	a5,0
ffffffffc0201f4c:	88ba                	mv	a7,a4
ffffffffc0201f4e:	853e                	mv	a0,a5
ffffffffc0201f50:	85be                	mv	a1,a5
ffffffffc0201f52:	863e                	mv	a2,a5
ffffffffc0201f54:	00000073          	ecall
ffffffffc0201f58:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201f5a:	8082                	ret

ffffffffc0201f5c <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201f5c:	00054783          	lbu	a5,0(a0)
ffffffffc0201f60:	cb81                	beqz	a5,ffffffffc0201f70 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0201f62:	4781                	li	a5,0
        cnt ++;
ffffffffc0201f64:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0201f66:	00f50733          	add	a4,a0,a5
ffffffffc0201f6a:	00074703          	lbu	a4,0(a4)
ffffffffc0201f6e:	fb7d                	bnez	a4,ffffffffc0201f64 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0201f70:	853e                	mv	a0,a5
ffffffffc0201f72:	8082                	ret

ffffffffc0201f74 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201f74:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201f76:	e589                	bnez	a1,ffffffffc0201f80 <strnlen+0xc>
ffffffffc0201f78:	a811                	j	ffffffffc0201f8c <strnlen+0x18>
        cnt ++;
ffffffffc0201f7a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201f7c:	00f58863          	beq	a1,a5,ffffffffc0201f8c <strnlen+0x18>
ffffffffc0201f80:	00f50733          	add	a4,a0,a5
ffffffffc0201f84:	00074703          	lbu	a4,0(a4)
ffffffffc0201f88:	fb6d                	bnez	a4,ffffffffc0201f7a <strnlen+0x6>
ffffffffc0201f8a:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201f8c:	852e                	mv	a0,a1
ffffffffc0201f8e:	8082                	ret

ffffffffc0201f90 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201f90:	00054783          	lbu	a5,0(a0)
ffffffffc0201f94:	e791                	bnez	a5,ffffffffc0201fa0 <strcmp+0x10>
ffffffffc0201f96:	a01d                	j	ffffffffc0201fbc <strcmp+0x2c>
ffffffffc0201f98:	00054783          	lbu	a5,0(a0)
ffffffffc0201f9c:	cb99                	beqz	a5,ffffffffc0201fb2 <strcmp+0x22>
ffffffffc0201f9e:	0585                	addi	a1,a1,1 # fffffffffff80001 <end+0x3fd78b61>
ffffffffc0201fa0:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0201fa4:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201fa6:	fef709e3          	beq	a4,a5,ffffffffc0201f98 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201faa:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201fae:	9d19                	subw	a0,a0,a4
ffffffffc0201fb0:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201fb2:	0015c703          	lbu	a4,1(a1)
ffffffffc0201fb6:	4501                	li	a0,0
}
ffffffffc0201fb8:	9d19                	subw	a0,a0,a4
ffffffffc0201fba:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201fbc:	0005c703          	lbu	a4,0(a1)
ffffffffc0201fc0:	4501                	li	a0,0
ffffffffc0201fc2:	b7f5                	j	ffffffffc0201fae <strcmp+0x1e>

ffffffffc0201fc4 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201fc4:	ce01                	beqz	a2,ffffffffc0201fdc <strncmp+0x18>
ffffffffc0201fc6:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201fca:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201fcc:	cb91                	beqz	a5,ffffffffc0201fe0 <strncmp+0x1c>
ffffffffc0201fce:	0005c703          	lbu	a4,0(a1)
ffffffffc0201fd2:	00f71763          	bne	a4,a5,ffffffffc0201fe0 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0201fd6:	0505                	addi	a0,a0,1
ffffffffc0201fd8:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201fda:	f675                	bnez	a2,ffffffffc0201fc6 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201fdc:	4501                	li	a0,0
ffffffffc0201fde:	8082                	ret
ffffffffc0201fe0:	00054503          	lbu	a0,0(a0)
ffffffffc0201fe4:	0005c783          	lbu	a5,0(a1)
ffffffffc0201fe8:	9d1d                	subw	a0,a0,a5
}
ffffffffc0201fea:	8082                	ret

ffffffffc0201fec <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201fec:	a021                	j	ffffffffc0201ff4 <strchr+0x8>
        if (*s == c) {
ffffffffc0201fee:	00f58763          	beq	a1,a5,ffffffffc0201ffc <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0201ff2:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201ff4:	00054783          	lbu	a5,0(a0)
ffffffffc0201ff8:	fbfd                	bnez	a5,ffffffffc0201fee <strchr+0x2>
    }
    return NULL;
ffffffffc0201ffa:	4501                	li	a0,0
}
ffffffffc0201ffc:	8082                	ret

ffffffffc0201ffe <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201ffe:	ca01                	beqz	a2,ffffffffc020200e <memset+0x10>
ffffffffc0202000:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0202002:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0202004:	0785                	addi	a5,a5,1
ffffffffc0202006:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020200a:	fef61de3          	bne	a2,a5,ffffffffc0202004 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020200e:	8082                	ret
