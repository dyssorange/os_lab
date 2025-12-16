
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000bc517          	auipc	a0,0xbc
ffffffffc020004e:	67e50513          	addi	a0,a0,1662 # ffffffffc02bc6c8 <buf>
ffffffffc0200052:	000c1617          	auipc	a2,0xc1
ffffffffc0200056:	b2260613          	addi	a2,a2,-1246 # ffffffffc02c0b74 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	0eb050ef          	jal	ra,ffffffffc020594c <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	90a58593          	addi	a1,a1,-1782 # ffffffffc0205978 <etext+0x2>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	92250513          	addi	a0,a0,-1758 # ffffffffc0205998 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6fc020ef          	jal	ra,ffffffffc0202782 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	459030ef          	jal	ra,ffffffffc0203cea <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	008050ef          	jal	ra,ffffffffc020509e <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	194050ef          	jal	ra,ffffffffc0205236 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	8e450513          	addi	a0,a0,-1820 # ffffffffc02059a0 <etext+0x2a>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000bcb97          	auipc	s7,0xbc
ffffffffc02000d6:	5f6b8b93          	addi	s7,s7,1526 # ffffffffc02bc6c8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000bc517          	auipc	a0,0xbc
ffffffffc0200132:	59a50513          	addi	a0,a0,1434 # ffffffffc02bc6c8 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	3a0050ef          	jal	ra,ffffffffc0205528 <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	36a050ef          	jal	ra,ffffffffc0205528 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	78a50513          	addi	a0,a0,1930 # ffffffffc02059a8 <etext+0x32>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	79450513          	addi	a0,a0,1940 # ffffffffc02059c8 <etext+0x52>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	73658593          	addi	a1,a1,1846 # ffffffffc0205976 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	7a050513          	addi	a0,a0,1952 # ffffffffc02059e8 <etext+0x72>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000bc597          	auipc	a1,0xbc
ffffffffc0200258:	47458593          	addi	a1,a1,1140 # ffffffffc02bc6c8 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	7ac50513          	addi	a0,a0,1964 # ffffffffc0205a08 <etext+0x92>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000c1597          	auipc	a1,0xc1
ffffffffc020026c:	90c58593          	addi	a1,a1,-1780 # ffffffffc02c0b74 <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	7b850513          	addi	a0,a0,1976 # ffffffffc0205a28 <etext+0xb2>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000c1597          	auipc	a1,0xc1
ffffffffc0200280:	cf758593          	addi	a1,a1,-777 # ffffffffc02c0f73 <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	7aa50513          	addi	a0,a0,1962 # ffffffffc0205a48 <etext+0xd2>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	7cc60613          	addi	a2,a2,1996 # ffffffffc0205a78 <etext+0x102>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	7d850513          	addi	a0,a0,2008 # ffffffffc0205a90 <etext+0x11a>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	7e060613          	addi	a2,a2,2016 # ffffffffc0205aa8 <etext+0x132>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	7f858593          	addi	a1,a1,2040 # ffffffffc0205ac8 <etext+0x152>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	7f850513          	addi	a0,a0,2040 # ffffffffc0205ad0 <etext+0x15a>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	7fa60613          	addi	a2,a2,2042 # ffffffffc0205ae0 <etext+0x16a>
ffffffffc02002ee:	00006597          	auipc	a1,0x6
ffffffffc02002f2:	81a58593          	addi	a1,a1,-2022 # ffffffffc0205b08 <etext+0x192>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	7da50513          	addi	a0,a0,2010 # ffffffffc0205ad0 <etext+0x15a>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00006617          	auipc	a2,0x6
ffffffffc0200306:	81660613          	addi	a2,a2,-2026 # ffffffffc0205b18 <etext+0x1a2>
ffffffffc020030a:	00006597          	auipc	a1,0x6
ffffffffc020030e:	82e58593          	addi	a1,a1,-2002 # ffffffffc0205b38 <etext+0x1c2>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	7be50513          	addi	a0,a0,1982 # ffffffffc0205ad0 <etext+0x15a>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	7fc50513          	addi	a0,a0,2044 # ffffffffc0205b48 <etext+0x1d2>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00006517          	auipc	a0,0x6
ffffffffc0200372:	80250513          	addi	a0,a0,-2046 # ffffffffc0205b70 <etext+0x1fa>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00006c17          	auipc	s8,0x6
ffffffffc0200388:	85cc0c13          	addi	s8,s8,-1956 # ffffffffc0205be0 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00006917          	auipc	s2,0x6
ffffffffc0200390:	80c90913          	addi	s2,s2,-2036 # ffffffffc0205b98 <etext+0x222>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00006497          	auipc	s1,0x6
ffffffffc0200398:	80c48493          	addi	s1,s1,-2036 # ffffffffc0205ba0 <etext+0x22a>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00006b17          	auipc	s6,0x6
ffffffffc02003a2:	80ab0b13          	addi	s6,s6,-2038 # ffffffffc0205ba8 <etext+0x232>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	722a0a13          	addi	s4,s4,1826 # ffffffffc0205ac8 <etext+0x152>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00006d17          	auipc	s10,0x6
ffffffffc02003cc:	818d0d13          	addi	s10,s10,-2024 # ffffffffc0205be0 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	51c050ef          	jal	ra,ffffffffc02058f2 <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	508050ef          	jal	ra,ffffffffc02058f2 <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	50e050ef          	jal	ra,ffffffffc0205936 <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	4d0050ef          	jal	ra,ffffffffc0205936 <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	74850513          	addi	a0,a0,1864 # ffffffffc0205bc8 <etext+0x252>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000c0317          	auipc	t1,0xc0
ffffffffc0200492:	66230313          	addi	t1,t1,1634 # ffffffffc02c0af0 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	76c50513          	addi	a0,a0,1900 # ffffffffc0205c28 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00007517          	auipc	a0,0x7
ffffffffc02004d6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0206d30 <default_pmm_manager+0x578>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	74250513          	addi	a0,a0,1858 # ffffffffc0205c48 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00007517          	auipc	a0,0x7
ffffffffc020052a:	80a50513          	addi	a0,a0,-2038 # ffffffffc0206d30 <default_pmm_manager+0x578>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_proc_suite_out_size+0xcd28>
ffffffffc0200540:	000c0717          	auipc	a4,0xc0
ffffffffc0200544:	5cf73023          	sd	a5,1472(a4) # ffffffffc02c0b00 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	70850513          	addi	a0,a0,1800 # ffffffffc0205c68 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000c0797          	auipc	a5,0xc0
ffffffffc020056c:	5807b823          	sd	zero,1424(a5) # ffffffffc02c0af8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000c0797          	auipc	a5,0xc0
ffffffffc020057a:	58a7b783          	ld	a5,1418(a5) # ffffffffc02c0b00 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	andi	a0,a0,255
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	68850513          	addi	a0,a0,1672 # ffffffffc0205c88 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	66a50513          	addi	a0,a0,1642 # ffffffffc0205c98 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	66450513          	addi	a0,a0,1636 # ffffffffc0205ca8 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	66c50513          	addi	a0,a0,1644 # ffffffffc0205cc0 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe1f379>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	60290913          	addi	s2,s2,1538 # ffffffffc0205d10 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	5ec48493          	addi	s1,s1,1516 # ffffffffc0205d08 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	61850513          	addi	a0,a0,1560 # ffffffffc0205d88 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	64450513          	addi	a0,a0,1604 # ffffffffc0205dc0 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	52450513          	addi	a0,a0,1316 # ffffffffc0205ce0 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	0e0050ef          	jal	ra,ffffffffc02058aa <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	138050ef          	jal	ra,ffffffffc0205910 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	084050ef          	jal	ra,ffffffffc02058f2 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	49650513          	addi	a0,a0,1174 # ffffffffc0205d18 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	3e850513          	addi	a0,a0,1000 # ffffffffc0205d38 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	3ee50513          	addi	a0,a0,1006 # ffffffffc0205d50 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	3fc50513          	addi	a0,a0,1020 # ffffffffc0205d70 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	44050513          	addi	a0,a0,1088 # ffffffffc0205dc0 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000c0797          	auipc	a5,0xc0
ffffffffc020098c:	1887b023          	sd	s0,384(a5) # ffffffffc02c0b08 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000c0797          	auipc	a5,0xc0
ffffffffc0200994:	1967b023          	sd	s6,384(a5) # ffffffffc02c0b10 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000c0517          	auipc	a0,0xc0
ffffffffc020099e:	16e53503          	ld	a0,366(a0) # ffffffffc02c0b08 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000c0517          	auipc	a0,0xc0
ffffffffc02009a8:	16c53503          	ld	a0,364(a0) # ffffffffc02c0b10 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	4f078793          	addi	a5,a5,1264 # ffffffffc0200eb0 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205dd8 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	40250513          	addi	a0,a0,1026 # ffffffffc0205df0 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	40c50513          	addi	a0,a0,1036 # ffffffffc0205e08 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	41650513          	addi	a0,a0,1046 # ffffffffc0205e20 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	42050513          	addi	a0,a0,1056 # ffffffffc0205e38 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	42a50513          	addi	a0,a0,1066 # ffffffffc0205e50 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	43450513          	addi	a0,a0,1076 # ffffffffc0205e68 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	43e50513          	addi	a0,a0,1086 # ffffffffc0205e80 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	44850513          	addi	a0,a0,1096 # ffffffffc0205e98 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	45250513          	addi	a0,a0,1106 # ffffffffc0205eb0 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	45c50513          	addi	a0,a0,1116 # ffffffffc0205ec8 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	46650513          	addi	a0,a0,1126 # ffffffffc0205ee0 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	47050513          	addi	a0,a0,1136 # ffffffffc0205ef8 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	47a50513          	addi	a0,a0,1146 # ffffffffc0205f10 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	48450513          	addi	a0,a0,1156 # ffffffffc0205f28 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	48e50513          	addi	a0,a0,1166 # ffffffffc0205f40 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	49850513          	addi	a0,a0,1176 # ffffffffc0205f58 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	4a250513          	addi	a0,a0,1186 # ffffffffc0205f70 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205f88 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	4b650513          	addi	a0,a0,1206 # ffffffffc0205fa0 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	4c050513          	addi	a0,a0,1216 # ffffffffc0205fb8 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	4ca50513          	addi	a0,a0,1226 # ffffffffc0205fd0 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	4d450513          	addi	a0,a0,1236 # ffffffffc0205fe8 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	4de50513          	addi	a0,a0,1246 # ffffffffc0206000 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	4e850513          	addi	a0,a0,1256 # ffffffffc0206018 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	4f250513          	addi	a0,a0,1266 # ffffffffc0206030 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	4fc50513          	addi	a0,a0,1276 # ffffffffc0206048 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	50650513          	addi	a0,a0,1286 # ffffffffc0206060 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	51050513          	addi	a0,a0,1296 # ffffffffc0206078 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	51a50513          	addi	a0,a0,1306 # ffffffffc0206090 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	52450513          	addi	a0,a0,1316 # ffffffffc02060a8 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	52a50513          	addi	a0,a0,1322 # ffffffffc02060c0 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	52c50513          	addi	a0,a0,1324 # ffffffffc02060d8 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	52c50513          	addi	a0,a0,1324 # ffffffffc02060f0 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	53450513          	addi	a0,a0,1332 # ffffffffc0206108 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	53c50513          	addi	a0,a0,1340 # ffffffffc0206120 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	53850513          	addi	a0,a0,1336 # ffffffffc0206130 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	06f76d63          	bltu	a4,a5,ffffffffc0200c8a <interrupt_handler+0x84>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	5e470713          	addi	a4,a4,1508 # ffffffffc02061f8 <commands+0x618>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	58250513          	addi	a0,a0,1410 # ffffffffc02061a8 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	55650513          	addi	a0,a0,1366 # ffffffffc0206188 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	50a50513          	addi	a0,a0,1290 # ffffffffc0206148 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	51e50513          	addi	a0,a0,1310 # ffffffffc0206168 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
/* 时间片轮转： 
*(1) 设置下一次时钟中断（clock_set_next_event）
*(2) ticks 计数器自增
*(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）
*/
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        ticks++;
ffffffffc0200c5e:	000c0797          	auipc	a5,0xc0
ffffffffc0200c62:	e9a78793          	addi	a5,a5,-358 # ffffffffc02c0af8 <ticks>
ffffffffc0200c66:	6398                	ld	a4,0(a5)
ffffffffc0200c68:	0705                	addi	a4,a4,1
ffffffffc0200c6a:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200c6c:	639c                	ld	a5,0(a5)
ffffffffc0200c6e:	06400713          	li	a4,100
ffffffffc0200c72:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c76:	cb99                	beqz	a5,ffffffffc0200c8c <interrupt_handler+0x86>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c78:	60a2                	ld	ra,8(sp)
ffffffffc0200c7a:	0141                	addi	sp,sp,16
ffffffffc0200c7c:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c7e:	00005517          	auipc	a0,0x5
ffffffffc0200c82:	55a50513          	addi	a0,a0,1370 # ffffffffc02061d8 <commands+0x5f8>
ffffffffc0200c86:	d0eff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c8a:	bf29                	j	ffffffffc0200ba4 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c8c:	06400593          	li	a1,100
ffffffffc0200c90:	00005517          	auipc	a0,0x5
ffffffffc0200c94:	53850513          	addi	a0,a0,1336 # ffffffffc02061c8 <commands+0x5e8>
ffffffffc0200c98:	cfcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
                if (current != NULL && current != idleproc) {
ffffffffc0200c9c:	000c0797          	auipc	a5,0xc0
ffffffffc0200ca0:	ebc7b783          	ld	a5,-324(a5) # ffffffffc02c0b58 <current>
ffffffffc0200ca4:	dbf1                	beqz	a5,ffffffffc0200c78 <interrupt_handler+0x72>
ffffffffc0200ca6:	000c0717          	auipc	a4,0xc0
ffffffffc0200caa:	eba73703          	ld	a4,-326(a4) # ffffffffc02c0b60 <idleproc>
ffffffffc0200cae:	fce785e3          	beq	a5,a4,ffffffffc0200c78 <interrupt_handler+0x72>
                        current->need_resched = 1;
ffffffffc0200cb2:	4705                	li	a4,1
ffffffffc0200cb4:	ef98                	sd	a4,24(a5)
ffffffffc0200cb6:	b7c9                	j	ffffffffc0200c78 <interrupt_handler+0x72>

ffffffffc0200cb8 <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cb8:	11853583          	ld	a1,280(a0)
{
ffffffffc0200cbc:	1101                	addi	sp,sp,-32
ffffffffc0200cbe:	e822                	sd	s0,16(sp)
ffffffffc0200cc0:	ec06                	sd	ra,24(sp)
ffffffffc0200cc2:	e426                	sd	s1,8(sp)
ffffffffc0200cc4:	47bd                	li	a5,15
ffffffffc0200cc6:	842a                	mv	s0,a0
ffffffffc0200cc8:	0eb7e963          	bltu	a5,a1,ffffffffc0200dba <exception_handler+0x102>
ffffffffc0200ccc:	00005697          	auipc	a3,0x5
ffffffffc0200cd0:	6ec68693          	addi	a3,a3,1772 # ffffffffc02063b8 <commands+0x7d8>
ffffffffc0200cd4:	00259713          	slli	a4,a1,0x2
ffffffffc0200cd8:	9736                	add	a4,a4,a3
ffffffffc0200cda:	431c                	lw	a5,0(a4)
ffffffffc0200cdc:	97b6                	add	a5,a5,a3
ffffffffc0200cde:	8782                	jr	a5
        cprintf("Environment call from M-mode\n");
        break;
    case CAUSE_FETCH_PAGE_FAULT:
    case CAUSE_LOAD_PAGE_FAULT:
    case CAUSE_STORE_PAGE_FAULT:
        ret = do_pgfault(current->mm, tf->cause, tf->tval);
ffffffffc0200ce0:	000c0797          	auipc	a5,0xc0
ffffffffc0200ce4:	e787b783          	ld	a5,-392(a5) # ffffffffc02c0b58 <current>
ffffffffc0200ce8:	11053603          	ld	a2,272(a0)
ffffffffc0200cec:	7788                	ld	a0,40(a5)
ffffffffc0200cee:	2c1020ef          	jal	ra,ffffffffc02037ae <do_pgfault>
ffffffffc0200cf2:	84aa                	mv	s1,a0
        if (ret != 0)
ffffffffc0200cf4:	0e051563          	bnez	a0,ffffffffc0200dde <exception_handler+0x126>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cf8:	60e2                	ld	ra,24(sp)
ffffffffc0200cfa:	6442                	ld	s0,16(sp)
ffffffffc0200cfc:	64a2                	ld	s1,8(sp)
ffffffffc0200cfe:	6105                	addi	sp,sp,32
ffffffffc0200d00:	8082                	ret
        cprintf("Environment call from S-mode\n");
ffffffffc0200d02:	00005517          	auipc	a0,0x5
ffffffffc0200d06:	60e50513          	addi	a0,a0,1550 # ffffffffc0206310 <commands+0x730>
ffffffffc0200d0a:	c8aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200d0e:	10843783          	ld	a5,264(s0)
}
ffffffffc0200d12:	60e2                	ld	ra,24(sp)
ffffffffc0200d14:	64a2                	ld	s1,8(sp)
        tf->epc += 4;
ffffffffc0200d16:	0791                	addi	a5,a5,4
ffffffffc0200d18:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200d1c:	6442                	ld	s0,16(sp)
ffffffffc0200d1e:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200d20:	7060406f          	j	ffffffffc0205426 <syscall>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d24:	00005517          	auipc	a0,0x5
ffffffffc0200d28:	50450513          	addi	a0,a0,1284 # ffffffffc0206228 <commands+0x648>
}
ffffffffc0200d2c:	6442                	ld	s0,16(sp)
ffffffffc0200d2e:	60e2                	ld	ra,24(sp)
ffffffffc0200d30:	64a2                	ld	s1,8(sp)
ffffffffc0200d32:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200d34:	c60ff06f          	j	ffffffffc0200194 <cprintf>
ffffffffc0200d38:	00005517          	auipc	a0,0x5
ffffffffc0200d3c:	51050513          	addi	a0,a0,1296 # ffffffffc0206248 <commands+0x668>
ffffffffc0200d40:	b7f5                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Illegal instruction\n");
ffffffffc0200d42:	00005517          	auipc	a0,0x5
ffffffffc0200d46:	52650513          	addi	a0,a0,1318 # ffffffffc0206268 <commands+0x688>
ffffffffc0200d4a:	b7cd                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d4c:	00005517          	auipc	a0,0x5
ffffffffc0200d50:	60450513          	addi	a0,a0,1540 # ffffffffc0206350 <commands+0x770>
ffffffffc0200d54:	bfe1                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d56:	00005517          	auipc	a0,0x5
ffffffffc0200d5a:	5da50513          	addi	a0,a0,1498 # ffffffffc0206330 <commands+0x750>
ffffffffc0200d5e:	b7f9                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d60:	00005517          	auipc	a0,0x5
ffffffffc0200d64:	59850513          	addi	a0,a0,1432 # ffffffffc02062f8 <commands+0x718>
ffffffffc0200d68:	b7d1                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Breakpoint\n");
ffffffffc0200d6a:	00005517          	auipc	a0,0x5
ffffffffc0200d6e:	51650513          	addi	a0,a0,1302 # ffffffffc0206280 <commands+0x6a0>
ffffffffc0200d72:	c22ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d76:	6458                	ld	a4,136(s0)
ffffffffc0200d78:	47a9                	li	a5,10
ffffffffc0200d7a:	f6f71fe3          	bne	a4,a5,ffffffffc0200cf8 <exception_handler+0x40>
            tf->epc += 4;
ffffffffc0200d7e:	10843783          	ld	a5,264(s0)
ffffffffc0200d82:	0791                	addi	a5,a5,4
ffffffffc0200d84:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200d88:	69e040ef          	jal	ra,ffffffffc0205426 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d8c:	000c0797          	auipc	a5,0xc0
ffffffffc0200d90:	dcc7b783          	ld	a5,-564(a5) # ffffffffc02c0b58 <current>
ffffffffc0200d94:	6b9c                	ld	a5,16(a5)
ffffffffc0200d96:	8522                	mv	a0,s0
}
ffffffffc0200d98:	6442                	ld	s0,16(sp)
ffffffffc0200d9a:	60e2                	ld	ra,24(sp)
ffffffffc0200d9c:	64a2                	ld	s1,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200d9e:	6589                	lui	a1,0x2
ffffffffc0200da0:	95be                	add	a1,a1,a5
}
ffffffffc0200da2:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200da4:	aae9                	j	ffffffffc0200f7e <kernel_execve_ret>
        cprintf("Load address misaligned\n");
ffffffffc0200da6:	00005517          	auipc	a0,0x5
ffffffffc0200daa:	4ea50513          	addi	a0,a0,1258 # ffffffffc0206290 <commands+0x6b0>
ffffffffc0200dae:	bfbd                	j	ffffffffc0200d2c <exception_handler+0x74>
        cprintf("Load access fault\n");
ffffffffc0200db0:	00005517          	auipc	a0,0x5
ffffffffc0200db4:	50050513          	addi	a0,a0,1280 # ffffffffc02062b0 <commands+0x6d0>
ffffffffc0200db8:	bf95                	j	ffffffffc0200d2c <exception_handler+0x74>
        print_trapframe(tf);
ffffffffc0200dba:	8522                	mv	a0,s0
}
ffffffffc0200dbc:	6442                	ld	s0,16(sp)
ffffffffc0200dbe:	60e2                	ld	ra,24(sp)
ffffffffc0200dc0:	64a2                	ld	s1,8(sp)
ffffffffc0200dc2:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200dc4:	b3c5                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200dc6:	00005617          	auipc	a2,0x5
ffffffffc0200dca:	50260613          	addi	a2,a2,1282 # ffffffffc02062c8 <commands+0x6e8>
ffffffffc0200dce:	0be00593          	li	a1,190
ffffffffc0200dd2:	00005517          	auipc	a0,0x5
ffffffffc0200dd6:	50e50513          	addi	a0,a0,1294 # ffffffffc02062e0 <commands+0x700>
ffffffffc0200dda:	eb4ff0ef          	jal	ra,ffffffffc020048e <__panic>
            cprintf("do_pgfault failed: ret %d, va 0x%lx, epc 0x%lx\n", ret, tf->tval, tf->epc);
ffffffffc0200dde:	10843683          	ld	a3,264(s0)
ffffffffc0200de2:	11043603          	ld	a2,272(s0)
ffffffffc0200de6:	85aa                	mv	a1,a0
ffffffffc0200de8:	00005517          	auipc	a0,0x5
ffffffffc0200dec:	58850513          	addi	a0,a0,1416 # ffffffffc0206370 <commands+0x790>
ffffffffc0200df0:	ba4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200df4:	10043783          	ld	a5,256(s0)
ffffffffc0200df8:	1007f793          	andi	a5,a5,256
            if (trap_in_kernel(tf))
ffffffffc0200dfc:	eb81                	bnez	a5,ffffffffc0200e0c <exception_handler+0x154>
}
ffffffffc0200dfe:	6442                	ld	s0,16(sp)
ffffffffc0200e00:	60e2                	ld	ra,24(sp)
            do_exit(ret);
ffffffffc0200e02:	8526                	mv	a0,s1
}
ffffffffc0200e04:	64a2                	ld	s1,8(sp)
ffffffffc0200e06:	6105                	addi	sp,sp,32
            do_exit(ret);
ffffffffc0200e08:	0790306f          	j	ffffffffc0204680 <do_exit>
                panic("page fault in kernel\n");
ffffffffc0200e0c:	00005617          	auipc	a2,0x5
ffffffffc0200e10:	59460613          	addi	a2,a2,1428 # ffffffffc02063a0 <commands+0x7c0>
ffffffffc0200e14:	0dc00593          	li	a1,220
ffffffffc0200e18:	00005517          	auipc	a0,0x5
ffffffffc0200e1c:	4c850513          	addi	a0,a0,1224 # ffffffffc02062e0 <commands+0x700>
ffffffffc0200e20:	e6eff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0200e24 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e24:	1101                	addi	sp,sp,-32
ffffffffc0200e26:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e28:	000c0417          	auipc	s0,0xc0
ffffffffc0200e2c:	d3040413          	addi	s0,s0,-720 # ffffffffc02c0b58 <current>
ffffffffc0200e30:	6018                	ld	a4,0(s0)
{
ffffffffc0200e32:	ec06                	sd	ra,24(sp)
ffffffffc0200e34:	e426                	sd	s1,8(sp)
ffffffffc0200e36:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e38:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e3c:	cf1d                	beqz	a4,ffffffffc0200e7a <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e3e:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e42:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e46:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e48:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e4c:	0206c463          	bltz	a3,ffffffffc0200e74 <trap+0x50>
        exception_handler(tf);
ffffffffc0200e50:	e69ff0ef          	jal	ra,ffffffffc0200cb8 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e54:	601c                	ld	a5,0(s0)
ffffffffc0200e56:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e5a:	e499                	bnez	s1,ffffffffc0200e68 <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e5c:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e60:	8b05                	andi	a4,a4,1
ffffffffc0200e62:	e329                	bnez	a4,ffffffffc0200ea4 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e64:	6f9c                	ld	a5,24(a5)
ffffffffc0200e66:	eb85                	bnez	a5,ffffffffc0200e96 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e68:	60e2                	ld	ra,24(sp)
ffffffffc0200e6a:	6442                	ld	s0,16(sp)
ffffffffc0200e6c:	64a2                	ld	s1,8(sp)
ffffffffc0200e6e:	6902                	ld	s2,0(sp)
ffffffffc0200e70:	6105                	addi	sp,sp,32
ffffffffc0200e72:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e74:	d93ff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e78:	bff1                	j	ffffffffc0200e54 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e7a:	0006c863          	bltz	a3,ffffffffc0200e8a <trap+0x66>
}
ffffffffc0200e7e:	6442                	ld	s0,16(sp)
ffffffffc0200e80:	60e2                	ld	ra,24(sp)
ffffffffc0200e82:	64a2                	ld	s1,8(sp)
ffffffffc0200e84:	6902                	ld	s2,0(sp)
ffffffffc0200e86:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e88:	bd05                	j	ffffffffc0200cb8 <exception_handler>
}
ffffffffc0200e8a:	6442                	ld	s0,16(sp)
ffffffffc0200e8c:	60e2                	ld	ra,24(sp)
ffffffffc0200e8e:	64a2                	ld	s1,8(sp)
ffffffffc0200e90:	6902                	ld	s2,0(sp)
ffffffffc0200e92:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e94:	bb8d                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e96:	6442                	ld	s0,16(sp)
ffffffffc0200e98:	60e2                	ld	ra,24(sp)
ffffffffc0200e9a:	64a2                	ld	s1,8(sp)
ffffffffc0200e9c:	6902                	ld	s2,0(sp)
ffffffffc0200e9e:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ea0:	49a0406f          	j	ffffffffc020533a <schedule>
                do_exit(-E_KILLED);
ffffffffc0200ea4:	555d                	li	a0,-9
ffffffffc0200ea6:	7da030ef          	jal	ra,ffffffffc0204680 <do_exit>
            if (current->need_resched)
ffffffffc0200eaa:	601c                	ld	a5,0(s0)
ffffffffc0200eac:	bf65                	j	ffffffffc0200e64 <trap+0x40>
	...

ffffffffc0200eb0 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200eb0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200eb4:	00011463          	bnez	sp,ffffffffc0200ebc <__alltraps+0xc>
ffffffffc0200eb8:	14002173          	csrr	sp,sscratch
ffffffffc0200ebc:	712d                	addi	sp,sp,-288
ffffffffc0200ebe:	e002                	sd	zero,0(sp)
ffffffffc0200ec0:	e406                	sd	ra,8(sp)
ffffffffc0200ec2:	ec0e                	sd	gp,24(sp)
ffffffffc0200ec4:	f012                	sd	tp,32(sp)
ffffffffc0200ec6:	f416                	sd	t0,40(sp)
ffffffffc0200ec8:	f81a                	sd	t1,48(sp)
ffffffffc0200eca:	fc1e                	sd	t2,56(sp)
ffffffffc0200ecc:	e0a2                	sd	s0,64(sp)
ffffffffc0200ece:	e4a6                	sd	s1,72(sp)
ffffffffc0200ed0:	e8aa                	sd	a0,80(sp)
ffffffffc0200ed2:	ecae                	sd	a1,88(sp)
ffffffffc0200ed4:	f0b2                	sd	a2,96(sp)
ffffffffc0200ed6:	f4b6                	sd	a3,104(sp)
ffffffffc0200ed8:	f8ba                	sd	a4,112(sp)
ffffffffc0200eda:	fcbe                	sd	a5,120(sp)
ffffffffc0200edc:	e142                	sd	a6,128(sp)
ffffffffc0200ede:	e546                	sd	a7,136(sp)
ffffffffc0200ee0:	e94a                	sd	s2,144(sp)
ffffffffc0200ee2:	ed4e                	sd	s3,152(sp)
ffffffffc0200ee4:	f152                	sd	s4,160(sp)
ffffffffc0200ee6:	f556                	sd	s5,168(sp)
ffffffffc0200ee8:	f95a                	sd	s6,176(sp)
ffffffffc0200eea:	fd5e                	sd	s7,184(sp)
ffffffffc0200eec:	e1e2                	sd	s8,192(sp)
ffffffffc0200eee:	e5e6                	sd	s9,200(sp)
ffffffffc0200ef0:	e9ea                	sd	s10,208(sp)
ffffffffc0200ef2:	edee                	sd	s11,216(sp)
ffffffffc0200ef4:	f1f2                	sd	t3,224(sp)
ffffffffc0200ef6:	f5f6                	sd	t4,232(sp)
ffffffffc0200ef8:	f9fa                	sd	t5,240(sp)
ffffffffc0200efa:	fdfe                	sd	t6,248(sp)
ffffffffc0200efc:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f00:	100024f3          	csrr	s1,sstatus
ffffffffc0200f04:	14102973          	csrr	s2,sepc
ffffffffc0200f08:	143029f3          	csrr	s3,stval
ffffffffc0200f0c:	14202a73          	csrr	s4,scause
ffffffffc0200f10:	e822                	sd	s0,16(sp)
ffffffffc0200f12:	e226                	sd	s1,256(sp)
ffffffffc0200f14:	e64a                	sd	s2,264(sp)
ffffffffc0200f16:	ea4e                	sd	s3,272(sp)
ffffffffc0200f18:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f1a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f1c:	f09ff0ef          	jal	ra,ffffffffc0200e24 <trap>

ffffffffc0200f20 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f20:	6492                	ld	s1,256(sp)
ffffffffc0200f22:	6932                	ld	s2,264(sp)
ffffffffc0200f24:	1004f413          	andi	s0,s1,256
ffffffffc0200f28:	e401                	bnez	s0,ffffffffc0200f30 <__trapret+0x10>
ffffffffc0200f2a:	1200                	addi	s0,sp,288
ffffffffc0200f2c:	14041073          	csrw	sscratch,s0
ffffffffc0200f30:	10049073          	csrw	sstatus,s1
ffffffffc0200f34:	14191073          	csrw	sepc,s2
ffffffffc0200f38:	60a2                	ld	ra,8(sp)
ffffffffc0200f3a:	61e2                	ld	gp,24(sp)
ffffffffc0200f3c:	7202                	ld	tp,32(sp)
ffffffffc0200f3e:	72a2                	ld	t0,40(sp)
ffffffffc0200f40:	7342                	ld	t1,48(sp)
ffffffffc0200f42:	73e2                	ld	t2,56(sp)
ffffffffc0200f44:	6406                	ld	s0,64(sp)
ffffffffc0200f46:	64a6                	ld	s1,72(sp)
ffffffffc0200f48:	6546                	ld	a0,80(sp)
ffffffffc0200f4a:	65e6                	ld	a1,88(sp)
ffffffffc0200f4c:	7606                	ld	a2,96(sp)
ffffffffc0200f4e:	76a6                	ld	a3,104(sp)
ffffffffc0200f50:	7746                	ld	a4,112(sp)
ffffffffc0200f52:	77e6                	ld	a5,120(sp)
ffffffffc0200f54:	680a                	ld	a6,128(sp)
ffffffffc0200f56:	68aa                	ld	a7,136(sp)
ffffffffc0200f58:	694a                	ld	s2,144(sp)
ffffffffc0200f5a:	69ea                	ld	s3,152(sp)
ffffffffc0200f5c:	7a0a                	ld	s4,160(sp)
ffffffffc0200f5e:	7aaa                	ld	s5,168(sp)
ffffffffc0200f60:	7b4a                	ld	s6,176(sp)
ffffffffc0200f62:	7bea                	ld	s7,184(sp)
ffffffffc0200f64:	6c0e                	ld	s8,192(sp)
ffffffffc0200f66:	6cae                	ld	s9,200(sp)
ffffffffc0200f68:	6d4e                	ld	s10,208(sp)
ffffffffc0200f6a:	6dee                	ld	s11,216(sp)
ffffffffc0200f6c:	7e0e                	ld	t3,224(sp)
ffffffffc0200f6e:	7eae                	ld	t4,232(sp)
ffffffffc0200f70:	7f4e                	ld	t5,240(sp)
ffffffffc0200f72:	7fee                	ld	t6,248(sp)
ffffffffc0200f74:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f76:	10200073          	sret

ffffffffc0200f7a <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f7a:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f7c:	b755                	j	ffffffffc0200f20 <__trapret>

ffffffffc0200f7e <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f7e:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f82:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f86:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f8a:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f8e:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f92:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f96:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f9a:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f9e:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200fa2:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200fa4:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200fa6:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200fa8:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200faa:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200fac:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200fae:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200fb0:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200fb2:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200fb4:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200fb6:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200fb8:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200fba:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200fbc:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200fbe:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200fc0:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200fc2:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200fc4:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200fc6:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200fc8:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200fca:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200fcc:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200fce:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200fd0:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200fd2:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200fd4:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200fd6:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200fd8:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200fda:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200fdc:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200fde:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200fe0:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200fe2:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200fe4:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200fe6:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200fe8:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200fea:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fec:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fee:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200ff0:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200ff2:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200ff4:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200ff6:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200ff8:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200ffa:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200ffc:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200ffe:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201000:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201002:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201004:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0201006:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201008:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020100a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc020100c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc020100e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201010:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0201012:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201014:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0201016:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201018:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc020101a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc020101c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc020101e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201020:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0201022:	812e                	mv	sp,a1
ffffffffc0201024:	bdf5                	j	ffffffffc0200f20 <__trapret>

ffffffffc0201026 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201026:	000bc797          	auipc	a5,0xbc
ffffffffc020102a:	aa278793          	addi	a5,a5,-1374 # ffffffffc02bcac8 <free_area>
ffffffffc020102e:	e79c                	sd	a5,8(a5)
ffffffffc0201030:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201032:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201036:	8082                	ret

ffffffffc0201038 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201038:	000bc517          	auipc	a0,0xbc
ffffffffc020103c:	aa056503          	lwu	a0,-1376(a0) # ffffffffc02bcad8 <free_area+0x10>
ffffffffc0201040:	8082                	ret

ffffffffc0201042 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201042:	715d                	addi	sp,sp,-80
ffffffffc0201044:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201046:	000bc417          	auipc	s0,0xbc
ffffffffc020104a:	a8240413          	addi	s0,s0,-1406 # ffffffffc02bcac8 <free_area>
ffffffffc020104e:	641c                	ld	a5,8(s0)
ffffffffc0201050:	e486                	sd	ra,72(sp)
ffffffffc0201052:	fc26                	sd	s1,56(sp)
ffffffffc0201054:	f84a                	sd	s2,48(sp)
ffffffffc0201056:	f44e                	sd	s3,40(sp)
ffffffffc0201058:	f052                	sd	s4,32(sp)
ffffffffc020105a:	ec56                	sd	s5,24(sp)
ffffffffc020105c:	e85a                	sd	s6,16(sp)
ffffffffc020105e:	e45e                	sd	s7,8(sp)
ffffffffc0201060:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201062:	2a878d63          	beq	a5,s0,ffffffffc020131c <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0201066:	4481                	li	s1,0
ffffffffc0201068:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020106a:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020106e:	8b09                	andi	a4,a4,2
ffffffffc0201070:	2a070a63          	beqz	a4,ffffffffc0201324 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201074:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201078:	679c                	ld	a5,8(a5)
ffffffffc020107a:	2905                	addiw	s2,s2,1
ffffffffc020107c:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc020107e:	fe8796e3          	bne	a5,s0,ffffffffc020106a <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201082:	89a6                	mv	s3,s1
ffffffffc0201084:	6df000ef          	jal	ra,ffffffffc0201f62 <nr_free_pages>
ffffffffc0201088:	6f351e63          	bne	a0,s3,ffffffffc0201784 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020108c:	4505                	li	a0,1
ffffffffc020108e:	657000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201092:	8aaa                	mv	s5,a0
ffffffffc0201094:	42050863          	beqz	a0,ffffffffc02014c4 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201098:	4505                	li	a0,1
ffffffffc020109a:	64b000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020109e:	89aa                	mv	s3,a0
ffffffffc02010a0:	70050263          	beqz	a0,ffffffffc02017a4 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010a4:	4505                	li	a0,1
ffffffffc02010a6:	63f000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02010aa:	8a2a                	mv	s4,a0
ffffffffc02010ac:	48050c63          	beqz	a0,ffffffffc0201544 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010b0:	293a8a63          	beq	s5,s3,ffffffffc0201344 <default_check+0x302>
ffffffffc02010b4:	28aa8863          	beq	s5,a0,ffffffffc0201344 <default_check+0x302>
ffffffffc02010b8:	28a98663          	beq	s3,a0,ffffffffc0201344 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02010bc:	000aa783          	lw	a5,0(s5)
ffffffffc02010c0:	2a079263          	bnez	a5,ffffffffc0201364 <default_check+0x322>
ffffffffc02010c4:	0009a783          	lw	a5,0(s3)
ffffffffc02010c8:	28079e63          	bnez	a5,ffffffffc0201364 <default_check+0x322>
ffffffffc02010cc:	411c                	lw	a5,0(a0)
ffffffffc02010ce:	28079b63          	bnez	a5,ffffffffc0201364 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc02010d2:	000c0797          	auipc	a5,0xc0
ffffffffc02010d6:	a667b783          	ld	a5,-1434(a5) # ffffffffc02c0b38 <pages>
ffffffffc02010da:	40fa8733          	sub	a4,s5,a5
ffffffffc02010de:	00007617          	auipc	a2,0x7
ffffffffc02010e2:	9e263603          	ld	a2,-1566(a2) # ffffffffc0207ac0 <nbase>
ffffffffc02010e6:	8719                	srai	a4,a4,0x6
ffffffffc02010e8:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02010ea:	000c0697          	auipc	a3,0xc0
ffffffffc02010ee:	a466b683          	ld	a3,-1466(a3) # ffffffffc02c0b30 <npage>
ffffffffc02010f2:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010f4:	0732                	slli	a4,a4,0xc
ffffffffc02010f6:	28d77763          	bgeu	a4,a3,ffffffffc0201384 <default_check+0x342>
    return page - pages + nbase;
ffffffffc02010fa:	40f98733          	sub	a4,s3,a5
ffffffffc02010fe:	8719                	srai	a4,a4,0x6
ffffffffc0201100:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201102:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201104:	4cd77063          	bgeu	a4,a3,ffffffffc02015c4 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201108:	40f507b3          	sub	a5,a0,a5
ffffffffc020110c:	8799                	srai	a5,a5,0x6
ffffffffc020110e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201110:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201112:	30d7f963          	bgeu	a5,a3,ffffffffc0201424 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201116:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201118:	00043c03          	ld	s8,0(s0)
ffffffffc020111c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201120:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201124:	e400                	sd	s0,8(s0)
ffffffffc0201126:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201128:	000bc797          	auipc	a5,0xbc
ffffffffc020112c:	9a07a823          	sw	zero,-1616(a5) # ffffffffc02bcad8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201130:	5b5000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201134:	2c051863          	bnez	a0,ffffffffc0201404 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201138:	4585                	li	a1,1
ffffffffc020113a:	8556                	mv	a0,s5
ffffffffc020113c:	5e7000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_page(p1);
ffffffffc0201140:	4585                	li	a1,1
ffffffffc0201142:	854e                	mv	a0,s3
ffffffffc0201144:	5df000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_page(p2);
ffffffffc0201148:	4585                	li	a1,1
ffffffffc020114a:	8552                	mv	a0,s4
ffffffffc020114c:	5d7000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    assert(nr_free == 3);
ffffffffc0201150:	4818                	lw	a4,16(s0)
ffffffffc0201152:	478d                	li	a5,3
ffffffffc0201154:	28f71863          	bne	a4,a5,ffffffffc02013e4 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201158:	4505                	li	a0,1
ffffffffc020115a:	58b000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020115e:	89aa                	mv	s3,a0
ffffffffc0201160:	26050263          	beqz	a0,ffffffffc02013c4 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201164:	4505                	li	a0,1
ffffffffc0201166:	57f000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020116a:	8aaa                	mv	s5,a0
ffffffffc020116c:	3a050c63          	beqz	a0,ffffffffc0201524 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201170:	4505                	li	a0,1
ffffffffc0201172:	573000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201176:	8a2a                	mv	s4,a0
ffffffffc0201178:	38050663          	beqz	a0,ffffffffc0201504 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc020117c:	4505                	li	a0,1
ffffffffc020117e:	567000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201182:	36051163          	bnez	a0,ffffffffc02014e4 <default_check+0x4a2>
    free_page(p0);
ffffffffc0201186:	4585                	li	a1,1
ffffffffc0201188:	854e                	mv	a0,s3
ffffffffc020118a:	599000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020118e:	641c                	ld	a5,8(s0)
ffffffffc0201190:	20878a63          	beq	a5,s0,ffffffffc02013a4 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201194:	4505                	li	a0,1
ffffffffc0201196:	54f000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020119a:	30a99563          	bne	s3,a0,ffffffffc02014a4 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc020119e:	4505                	li	a0,1
ffffffffc02011a0:	545000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02011a4:	2e051063          	bnez	a0,ffffffffc0201484 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc02011a8:	481c                	lw	a5,16(s0)
ffffffffc02011aa:	2a079d63          	bnez	a5,ffffffffc0201464 <default_check+0x422>
    free_page(p);
ffffffffc02011ae:	854e                	mv	a0,s3
ffffffffc02011b0:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02011b2:	01843023          	sd	s8,0(s0)
ffffffffc02011b6:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02011ba:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02011be:	565000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_page(p1);
ffffffffc02011c2:	4585                	li	a1,1
ffffffffc02011c4:	8556                	mv	a0,s5
ffffffffc02011c6:	55d000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_page(p2);
ffffffffc02011ca:	4585                	li	a1,1
ffffffffc02011cc:	8552                	mv	a0,s4
ffffffffc02011ce:	555000ef          	jal	ra,ffffffffc0201f22 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02011d2:	4515                	li	a0,5
ffffffffc02011d4:	511000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02011d8:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02011da:	26050563          	beqz	a0,ffffffffc0201444 <default_check+0x402>
ffffffffc02011de:	651c                	ld	a5,8(a0)
ffffffffc02011e0:	8385                	srli	a5,a5,0x1
ffffffffc02011e2:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02011e4:	54079063          	bnez	a5,ffffffffc0201724 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02011e8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02011ea:	00043b03          	ld	s6,0(s0)
ffffffffc02011ee:	00843a83          	ld	s5,8(s0)
ffffffffc02011f2:	e000                	sd	s0,0(s0)
ffffffffc02011f4:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02011f6:	4ef000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02011fa:	50051563          	bnez	a0,ffffffffc0201704 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011fe:	08098a13          	addi	s4,s3,128
ffffffffc0201202:	8552                	mv	a0,s4
ffffffffc0201204:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201206:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020120a:	000bc797          	auipc	a5,0xbc
ffffffffc020120e:	8c07a723          	sw	zero,-1842(a5) # ffffffffc02bcad8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201212:	511000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201216:	4511                	li	a0,4
ffffffffc0201218:	4cd000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020121c:	4c051463          	bnez	a0,ffffffffc02016e4 <default_check+0x6a2>
ffffffffc0201220:	0889b783          	ld	a5,136(s3)
ffffffffc0201224:	8385                	srli	a5,a5,0x1
ffffffffc0201226:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201228:	48078e63          	beqz	a5,ffffffffc02016c4 <default_check+0x682>
ffffffffc020122c:	0909a703          	lw	a4,144(s3)
ffffffffc0201230:	478d                	li	a5,3
ffffffffc0201232:	48f71963          	bne	a4,a5,ffffffffc02016c4 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201236:	450d                	li	a0,3
ffffffffc0201238:	4ad000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020123c:	8c2a                	mv	s8,a0
ffffffffc020123e:	46050363          	beqz	a0,ffffffffc02016a4 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201242:	4505                	li	a0,1
ffffffffc0201244:	4a1000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201248:	42051e63          	bnez	a0,ffffffffc0201684 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc020124c:	418a1c63          	bne	s4,s8,ffffffffc0201664 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201250:	4585                	li	a1,1
ffffffffc0201252:	854e                	mv	a0,s3
ffffffffc0201254:	4cf000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_pages(p1, 3);
ffffffffc0201258:	458d                	li	a1,3
ffffffffc020125a:	8552                	mv	a0,s4
ffffffffc020125c:	4c7000ef          	jal	ra,ffffffffc0201f22 <free_pages>
ffffffffc0201260:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201264:	04098c13          	addi	s8,s3,64
ffffffffc0201268:	8385                	srli	a5,a5,0x1
ffffffffc020126a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020126c:	3c078c63          	beqz	a5,ffffffffc0201644 <default_check+0x602>
ffffffffc0201270:	0109a703          	lw	a4,16(s3)
ffffffffc0201274:	4785                	li	a5,1
ffffffffc0201276:	3cf71763          	bne	a4,a5,ffffffffc0201644 <default_check+0x602>
ffffffffc020127a:	008a3783          	ld	a5,8(s4)
ffffffffc020127e:	8385                	srli	a5,a5,0x1
ffffffffc0201280:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201282:	3a078163          	beqz	a5,ffffffffc0201624 <default_check+0x5e2>
ffffffffc0201286:	010a2703          	lw	a4,16(s4)
ffffffffc020128a:	478d                	li	a5,3
ffffffffc020128c:	38f71c63          	bne	a4,a5,ffffffffc0201624 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201290:	4505                	li	a0,1
ffffffffc0201292:	453000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0201296:	36a99763          	bne	s3,a0,ffffffffc0201604 <default_check+0x5c2>
    free_page(p0);
ffffffffc020129a:	4585                	li	a1,1
ffffffffc020129c:	487000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012a0:	4509                	li	a0,2
ffffffffc02012a2:	443000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02012a6:	32aa1f63          	bne	s4,a0,ffffffffc02015e4 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc02012aa:	4589                	li	a1,2
ffffffffc02012ac:	477000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    free_page(p2);
ffffffffc02012b0:	4585                	li	a1,1
ffffffffc02012b2:	8562                	mv	a0,s8
ffffffffc02012b4:	46f000ef          	jal	ra,ffffffffc0201f22 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012b8:	4515                	li	a0,5
ffffffffc02012ba:	42b000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02012be:	89aa                	mv	s3,a0
ffffffffc02012c0:	48050263          	beqz	a0,ffffffffc0201744 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc02012c4:	4505                	li	a0,1
ffffffffc02012c6:	41f000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02012ca:	2c051d63          	bnez	a0,ffffffffc02015a4 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc02012ce:	481c                	lw	a5,16(s0)
ffffffffc02012d0:	2a079a63          	bnez	a5,ffffffffc0201584 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02012d4:	4595                	li	a1,5
ffffffffc02012d6:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02012d8:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02012dc:	01643023          	sd	s6,0(s0)
ffffffffc02012e0:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02012e4:	43f000ef          	jal	ra,ffffffffc0201f22 <free_pages>
    return listelm->next;
ffffffffc02012e8:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02012ea:	00878963          	beq	a5,s0,ffffffffc02012fc <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012ee:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012f2:	679c                	ld	a5,8(a5)
ffffffffc02012f4:	397d                	addiw	s2,s2,-1
ffffffffc02012f6:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012f8:	fe879be3          	bne	a5,s0,ffffffffc02012ee <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012fc:	26091463          	bnez	s2,ffffffffc0201564 <default_check+0x522>
    assert(total == 0);
ffffffffc0201300:	46049263          	bnez	s1,ffffffffc0201764 <default_check+0x722>
}
ffffffffc0201304:	60a6                	ld	ra,72(sp)
ffffffffc0201306:	6406                	ld	s0,64(sp)
ffffffffc0201308:	74e2                	ld	s1,56(sp)
ffffffffc020130a:	7942                	ld	s2,48(sp)
ffffffffc020130c:	79a2                	ld	s3,40(sp)
ffffffffc020130e:	7a02                	ld	s4,32(sp)
ffffffffc0201310:	6ae2                	ld	s5,24(sp)
ffffffffc0201312:	6b42                	ld	s6,16(sp)
ffffffffc0201314:	6ba2                	ld	s7,8(sp)
ffffffffc0201316:	6c02                	ld	s8,0(sp)
ffffffffc0201318:	6161                	addi	sp,sp,80
ffffffffc020131a:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc020131c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020131e:	4481                	li	s1,0
ffffffffc0201320:	4901                	li	s2,0
ffffffffc0201322:	b38d                	j	ffffffffc0201084 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201324:	00005697          	auipc	a3,0x5
ffffffffc0201328:	0d468693          	addi	a3,a3,212 # ffffffffc02063f8 <commands+0x818>
ffffffffc020132c:	00005617          	auipc	a2,0x5
ffffffffc0201330:	0dc60613          	addi	a2,a2,220 # ffffffffc0206408 <commands+0x828>
ffffffffc0201334:	11000593          	li	a1,272
ffffffffc0201338:	00005517          	auipc	a0,0x5
ffffffffc020133c:	0e850513          	addi	a0,a0,232 # ffffffffc0206420 <commands+0x840>
ffffffffc0201340:	94eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201344:	00005697          	auipc	a3,0x5
ffffffffc0201348:	17468693          	addi	a3,a3,372 # ffffffffc02064b8 <commands+0x8d8>
ffffffffc020134c:	00005617          	auipc	a2,0x5
ffffffffc0201350:	0bc60613          	addi	a2,a2,188 # ffffffffc0206408 <commands+0x828>
ffffffffc0201354:	0db00593          	li	a1,219
ffffffffc0201358:	00005517          	auipc	a0,0x5
ffffffffc020135c:	0c850513          	addi	a0,a0,200 # ffffffffc0206420 <commands+0x840>
ffffffffc0201360:	92eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201364:	00005697          	auipc	a3,0x5
ffffffffc0201368:	17c68693          	addi	a3,a3,380 # ffffffffc02064e0 <commands+0x900>
ffffffffc020136c:	00005617          	auipc	a2,0x5
ffffffffc0201370:	09c60613          	addi	a2,a2,156 # ffffffffc0206408 <commands+0x828>
ffffffffc0201374:	0dc00593          	li	a1,220
ffffffffc0201378:	00005517          	auipc	a0,0x5
ffffffffc020137c:	0a850513          	addi	a0,a0,168 # ffffffffc0206420 <commands+0x840>
ffffffffc0201380:	90eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201384:	00005697          	auipc	a3,0x5
ffffffffc0201388:	19c68693          	addi	a3,a3,412 # ffffffffc0206520 <commands+0x940>
ffffffffc020138c:	00005617          	auipc	a2,0x5
ffffffffc0201390:	07c60613          	addi	a2,a2,124 # ffffffffc0206408 <commands+0x828>
ffffffffc0201394:	0de00593          	li	a1,222
ffffffffc0201398:	00005517          	auipc	a0,0x5
ffffffffc020139c:	08850513          	addi	a0,a0,136 # ffffffffc0206420 <commands+0x840>
ffffffffc02013a0:	8eeff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc02013a4:	00005697          	auipc	a3,0x5
ffffffffc02013a8:	20468693          	addi	a3,a3,516 # ffffffffc02065a8 <commands+0x9c8>
ffffffffc02013ac:	00005617          	auipc	a2,0x5
ffffffffc02013b0:	05c60613          	addi	a2,a2,92 # ffffffffc0206408 <commands+0x828>
ffffffffc02013b4:	0f700593          	li	a1,247
ffffffffc02013b8:	00005517          	auipc	a0,0x5
ffffffffc02013bc:	06850513          	addi	a0,a0,104 # ffffffffc0206420 <commands+0x840>
ffffffffc02013c0:	8ceff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013c4:	00005697          	auipc	a3,0x5
ffffffffc02013c8:	09468693          	addi	a3,a3,148 # ffffffffc0206458 <commands+0x878>
ffffffffc02013cc:	00005617          	auipc	a2,0x5
ffffffffc02013d0:	03c60613          	addi	a2,a2,60 # ffffffffc0206408 <commands+0x828>
ffffffffc02013d4:	0f000593          	li	a1,240
ffffffffc02013d8:	00005517          	auipc	a0,0x5
ffffffffc02013dc:	04850513          	addi	a0,a0,72 # ffffffffc0206420 <commands+0x840>
ffffffffc02013e0:	8aeff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc02013e4:	00005697          	auipc	a3,0x5
ffffffffc02013e8:	1b468693          	addi	a3,a3,436 # ffffffffc0206598 <commands+0x9b8>
ffffffffc02013ec:	00005617          	auipc	a2,0x5
ffffffffc02013f0:	01c60613          	addi	a2,a2,28 # ffffffffc0206408 <commands+0x828>
ffffffffc02013f4:	0ee00593          	li	a1,238
ffffffffc02013f8:	00005517          	auipc	a0,0x5
ffffffffc02013fc:	02850513          	addi	a0,a0,40 # ffffffffc0206420 <commands+0x840>
ffffffffc0201400:	88eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	17c68693          	addi	a3,a3,380 # ffffffffc0206580 <commands+0x9a0>
ffffffffc020140c:	00005617          	auipc	a2,0x5
ffffffffc0201410:	ffc60613          	addi	a2,a2,-4 # ffffffffc0206408 <commands+0x828>
ffffffffc0201414:	0e900593          	li	a1,233
ffffffffc0201418:	00005517          	auipc	a0,0x5
ffffffffc020141c:	00850513          	addi	a0,a0,8 # ffffffffc0206420 <commands+0x840>
ffffffffc0201420:	86eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201424:	00005697          	auipc	a3,0x5
ffffffffc0201428:	13c68693          	addi	a3,a3,316 # ffffffffc0206560 <commands+0x980>
ffffffffc020142c:	00005617          	auipc	a2,0x5
ffffffffc0201430:	fdc60613          	addi	a2,a2,-36 # ffffffffc0206408 <commands+0x828>
ffffffffc0201434:	0e000593          	li	a1,224
ffffffffc0201438:	00005517          	auipc	a0,0x5
ffffffffc020143c:	fe850513          	addi	a0,a0,-24 # ffffffffc0206420 <commands+0x840>
ffffffffc0201440:	84eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc0201444:	00005697          	auipc	a3,0x5
ffffffffc0201448:	1ac68693          	addi	a3,a3,428 # ffffffffc02065f0 <commands+0xa10>
ffffffffc020144c:	00005617          	auipc	a2,0x5
ffffffffc0201450:	fbc60613          	addi	a2,a2,-68 # ffffffffc0206408 <commands+0x828>
ffffffffc0201454:	11800593          	li	a1,280
ffffffffc0201458:	00005517          	auipc	a0,0x5
ffffffffc020145c:	fc850513          	addi	a0,a0,-56 # ffffffffc0206420 <commands+0x840>
ffffffffc0201460:	82eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201464:	00005697          	auipc	a3,0x5
ffffffffc0201468:	17c68693          	addi	a3,a3,380 # ffffffffc02065e0 <commands+0xa00>
ffffffffc020146c:	00005617          	auipc	a2,0x5
ffffffffc0201470:	f9c60613          	addi	a2,a2,-100 # ffffffffc0206408 <commands+0x828>
ffffffffc0201474:	0fd00593          	li	a1,253
ffffffffc0201478:	00005517          	auipc	a0,0x5
ffffffffc020147c:	fa850513          	addi	a0,a0,-88 # ffffffffc0206420 <commands+0x840>
ffffffffc0201480:	80eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201484:	00005697          	auipc	a3,0x5
ffffffffc0201488:	0fc68693          	addi	a3,a3,252 # ffffffffc0206580 <commands+0x9a0>
ffffffffc020148c:	00005617          	auipc	a2,0x5
ffffffffc0201490:	f7c60613          	addi	a2,a2,-132 # ffffffffc0206408 <commands+0x828>
ffffffffc0201494:	0fb00593          	li	a1,251
ffffffffc0201498:	00005517          	auipc	a0,0x5
ffffffffc020149c:	f8850513          	addi	a0,a0,-120 # ffffffffc0206420 <commands+0x840>
ffffffffc02014a0:	feffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02014a4:	00005697          	auipc	a3,0x5
ffffffffc02014a8:	11c68693          	addi	a3,a3,284 # ffffffffc02065c0 <commands+0x9e0>
ffffffffc02014ac:	00005617          	auipc	a2,0x5
ffffffffc02014b0:	f5c60613          	addi	a2,a2,-164 # ffffffffc0206408 <commands+0x828>
ffffffffc02014b4:	0fa00593          	li	a1,250
ffffffffc02014b8:	00005517          	auipc	a0,0x5
ffffffffc02014bc:	f6850513          	addi	a0,a0,-152 # ffffffffc0206420 <commands+0x840>
ffffffffc02014c0:	fcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02014c4:	00005697          	auipc	a3,0x5
ffffffffc02014c8:	f9468693          	addi	a3,a3,-108 # ffffffffc0206458 <commands+0x878>
ffffffffc02014cc:	00005617          	auipc	a2,0x5
ffffffffc02014d0:	f3c60613          	addi	a2,a2,-196 # ffffffffc0206408 <commands+0x828>
ffffffffc02014d4:	0d700593          	li	a1,215
ffffffffc02014d8:	00005517          	auipc	a0,0x5
ffffffffc02014dc:	f4850513          	addi	a0,a0,-184 # ffffffffc0206420 <commands+0x840>
ffffffffc02014e0:	faffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014e4:	00005697          	auipc	a3,0x5
ffffffffc02014e8:	09c68693          	addi	a3,a3,156 # ffffffffc0206580 <commands+0x9a0>
ffffffffc02014ec:	00005617          	auipc	a2,0x5
ffffffffc02014f0:	f1c60613          	addi	a2,a2,-228 # ffffffffc0206408 <commands+0x828>
ffffffffc02014f4:	0f400593          	li	a1,244
ffffffffc02014f8:	00005517          	auipc	a0,0x5
ffffffffc02014fc:	f2850513          	addi	a0,a0,-216 # ffffffffc0206420 <commands+0x840>
ffffffffc0201500:	f8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201504:	00005697          	auipc	a3,0x5
ffffffffc0201508:	f9468693          	addi	a3,a3,-108 # ffffffffc0206498 <commands+0x8b8>
ffffffffc020150c:	00005617          	auipc	a2,0x5
ffffffffc0201510:	efc60613          	addi	a2,a2,-260 # ffffffffc0206408 <commands+0x828>
ffffffffc0201514:	0f200593          	li	a1,242
ffffffffc0201518:	00005517          	auipc	a0,0x5
ffffffffc020151c:	f0850513          	addi	a0,a0,-248 # ffffffffc0206420 <commands+0x840>
ffffffffc0201520:	f6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201524:	00005697          	auipc	a3,0x5
ffffffffc0201528:	f5468693          	addi	a3,a3,-172 # ffffffffc0206478 <commands+0x898>
ffffffffc020152c:	00005617          	auipc	a2,0x5
ffffffffc0201530:	edc60613          	addi	a2,a2,-292 # ffffffffc0206408 <commands+0x828>
ffffffffc0201534:	0f100593          	li	a1,241
ffffffffc0201538:	00005517          	auipc	a0,0x5
ffffffffc020153c:	ee850513          	addi	a0,a0,-280 # ffffffffc0206420 <commands+0x840>
ffffffffc0201540:	f4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201544:	00005697          	auipc	a3,0x5
ffffffffc0201548:	f5468693          	addi	a3,a3,-172 # ffffffffc0206498 <commands+0x8b8>
ffffffffc020154c:	00005617          	auipc	a2,0x5
ffffffffc0201550:	ebc60613          	addi	a2,a2,-324 # ffffffffc0206408 <commands+0x828>
ffffffffc0201554:	0d900593          	li	a1,217
ffffffffc0201558:	00005517          	auipc	a0,0x5
ffffffffc020155c:	ec850513          	addi	a0,a0,-312 # ffffffffc0206420 <commands+0x840>
ffffffffc0201560:	f2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc0201564:	00005697          	auipc	a3,0x5
ffffffffc0201568:	1dc68693          	addi	a3,a3,476 # ffffffffc0206740 <commands+0xb60>
ffffffffc020156c:	00005617          	auipc	a2,0x5
ffffffffc0201570:	e9c60613          	addi	a2,a2,-356 # ffffffffc0206408 <commands+0x828>
ffffffffc0201574:	14600593          	li	a1,326
ffffffffc0201578:	00005517          	auipc	a0,0x5
ffffffffc020157c:	ea850513          	addi	a0,a0,-344 # ffffffffc0206420 <commands+0x840>
ffffffffc0201580:	f0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201584:	00005697          	auipc	a3,0x5
ffffffffc0201588:	05c68693          	addi	a3,a3,92 # ffffffffc02065e0 <commands+0xa00>
ffffffffc020158c:	00005617          	auipc	a2,0x5
ffffffffc0201590:	e7c60613          	addi	a2,a2,-388 # ffffffffc0206408 <commands+0x828>
ffffffffc0201594:	13a00593          	li	a1,314
ffffffffc0201598:	00005517          	auipc	a0,0x5
ffffffffc020159c:	e8850513          	addi	a0,a0,-376 # ffffffffc0206420 <commands+0x840>
ffffffffc02015a0:	eeffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015a4:	00005697          	auipc	a3,0x5
ffffffffc02015a8:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206580 <commands+0x9a0>
ffffffffc02015ac:	00005617          	auipc	a2,0x5
ffffffffc02015b0:	e5c60613          	addi	a2,a2,-420 # ffffffffc0206408 <commands+0x828>
ffffffffc02015b4:	13800593          	li	a1,312
ffffffffc02015b8:	00005517          	auipc	a0,0x5
ffffffffc02015bc:	e6850513          	addi	a0,a0,-408 # ffffffffc0206420 <commands+0x840>
ffffffffc02015c0:	ecffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02015c4:	00005697          	auipc	a3,0x5
ffffffffc02015c8:	f7c68693          	addi	a3,a3,-132 # ffffffffc0206540 <commands+0x960>
ffffffffc02015cc:	00005617          	auipc	a2,0x5
ffffffffc02015d0:	e3c60613          	addi	a2,a2,-452 # ffffffffc0206408 <commands+0x828>
ffffffffc02015d4:	0df00593          	li	a1,223
ffffffffc02015d8:	00005517          	auipc	a0,0x5
ffffffffc02015dc:	e4850513          	addi	a0,a0,-440 # ffffffffc0206420 <commands+0x840>
ffffffffc02015e0:	eaffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	11c68693          	addi	a3,a3,284 # ffffffffc0206700 <commands+0xb20>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	e1c60613          	addi	a2,a2,-484 # ffffffffc0206408 <commands+0x828>
ffffffffc02015f4:	13200593          	li	a1,306
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	e2850513          	addi	a0,a0,-472 # ffffffffc0206420 <commands+0x840>
ffffffffc0201600:	e8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	0dc68693          	addi	a3,a3,220 # ffffffffc02066e0 <commands+0xb00>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	dfc60613          	addi	a2,a2,-516 # ffffffffc0206408 <commands+0x828>
ffffffffc0201614:	13000593          	li	a1,304
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	e0850513          	addi	a0,a0,-504 # ffffffffc0206420 <commands+0x840>
ffffffffc0201620:	e6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201624:	00005697          	auipc	a3,0x5
ffffffffc0201628:	09468693          	addi	a3,a3,148 # ffffffffc02066b8 <commands+0xad8>
ffffffffc020162c:	00005617          	auipc	a2,0x5
ffffffffc0201630:	ddc60613          	addi	a2,a2,-548 # ffffffffc0206408 <commands+0x828>
ffffffffc0201634:	12e00593          	li	a1,302
ffffffffc0201638:	00005517          	auipc	a0,0x5
ffffffffc020163c:	de850513          	addi	a0,a0,-536 # ffffffffc0206420 <commands+0x840>
ffffffffc0201640:	e4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201644:	00005697          	auipc	a3,0x5
ffffffffc0201648:	04c68693          	addi	a3,a3,76 # ffffffffc0206690 <commands+0xab0>
ffffffffc020164c:	00005617          	auipc	a2,0x5
ffffffffc0201650:	dbc60613          	addi	a2,a2,-580 # ffffffffc0206408 <commands+0x828>
ffffffffc0201654:	12d00593          	li	a1,301
ffffffffc0201658:	00005517          	auipc	a0,0x5
ffffffffc020165c:	dc850513          	addi	a0,a0,-568 # ffffffffc0206420 <commands+0x840>
ffffffffc0201660:	e2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201664:	00005697          	auipc	a3,0x5
ffffffffc0201668:	01c68693          	addi	a3,a3,28 # ffffffffc0206680 <commands+0xaa0>
ffffffffc020166c:	00005617          	auipc	a2,0x5
ffffffffc0201670:	d9c60613          	addi	a2,a2,-612 # ffffffffc0206408 <commands+0x828>
ffffffffc0201674:	12800593          	li	a1,296
ffffffffc0201678:	00005517          	auipc	a0,0x5
ffffffffc020167c:	da850513          	addi	a0,a0,-600 # ffffffffc0206420 <commands+0x840>
ffffffffc0201680:	e0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201684:	00005697          	auipc	a3,0x5
ffffffffc0201688:	efc68693          	addi	a3,a3,-260 # ffffffffc0206580 <commands+0x9a0>
ffffffffc020168c:	00005617          	auipc	a2,0x5
ffffffffc0201690:	d7c60613          	addi	a2,a2,-644 # ffffffffc0206408 <commands+0x828>
ffffffffc0201694:	12700593          	li	a1,295
ffffffffc0201698:	00005517          	auipc	a0,0x5
ffffffffc020169c:	d8850513          	addi	a0,a0,-632 # ffffffffc0206420 <commands+0x840>
ffffffffc02016a0:	deffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02016a4:	00005697          	auipc	a3,0x5
ffffffffc02016a8:	fbc68693          	addi	a3,a3,-68 # ffffffffc0206660 <commands+0xa80>
ffffffffc02016ac:	00005617          	auipc	a2,0x5
ffffffffc02016b0:	d5c60613          	addi	a2,a2,-676 # ffffffffc0206408 <commands+0x828>
ffffffffc02016b4:	12600593          	li	a1,294
ffffffffc02016b8:	00005517          	auipc	a0,0x5
ffffffffc02016bc:	d6850513          	addi	a0,a0,-664 # ffffffffc0206420 <commands+0x840>
ffffffffc02016c0:	dcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02016c4:	00005697          	auipc	a3,0x5
ffffffffc02016c8:	f6c68693          	addi	a3,a3,-148 # ffffffffc0206630 <commands+0xa50>
ffffffffc02016cc:	00005617          	auipc	a2,0x5
ffffffffc02016d0:	d3c60613          	addi	a2,a2,-708 # ffffffffc0206408 <commands+0x828>
ffffffffc02016d4:	12500593          	li	a1,293
ffffffffc02016d8:	00005517          	auipc	a0,0x5
ffffffffc02016dc:	d4850513          	addi	a0,a0,-696 # ffffffffc0206420 <commands+0x840>
ffffffffc02016e0:	daffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02016e4:	00005697          	auipc	a3,0x5
ffffffffc02016e8:	f3468693          	addi	a3,a3,-204 # ffffffffc0206618 <commands+0xa38>
ffffffffc02016ec:	00005617          	auipc	a2,0x5
ffffffffc02016f0:	d1c60613          	addi	a2,a2,-740 # ffffffffc0206408 <commands+0x828>
ffffffffc02016f4:	12400593          	li	a1,292
ffffffffc02016f8:	00005517          	auipc	a0,0x5
ffffffffc02016fc:	d2850513          	addi	a0,a0,-728 # ffffffffc0206420 <commands+0x840>
ffffffffc0201700:	d8ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201704:	00005697          	auipc	a3,0x5
ffffffffc0201708:	e7c68693          	addi	a3,a3,-388 # ffffffffc0206580 <commands+0x9a0>
ffffffffc020170c:	00005617          	auipc	a2,0x5
ffffffffc0201710:	cfc60613          	addi	a2,a2,-772 # ffffffffc0206408 <commands+0x828>
ffffffffc0201714:	11e00593          	li	a1,286
ffffffffc0201718:	00005517          	auipc	a0,0x5
ffffffffc020171c:	d0850513          	addi	a0,a0,-760 # ffffffffc0206420 <commands+0x840>
ffffffffc0201720:	d6ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc0201724:	00005697          	auipc	a3,0x5
ffffffffc0201728:	edc68693          	addi	a3,a3,-292 # ffffffffc0206600 <commands+0xa20>
ffffffffc020172c:	00005617          	auipc	a2,0x5
ffffffffc0201730:	cdc60613          	addi	a2,a2,-804 # ffffffffc0206408 <commands+0x828>
ffffffffc0201734:	11900593          	li	a1,281
ffffffffc0201738:	00005517          	auipc	a0,0x5
ffffffffc020173c:	ce850513          	addi	a0,a0,-792 # ffffffffc0206420 <commands+0x840>
ffffffffc0201740:	d4ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201744:	00005697          	auipc	a3,0x5
ffffffffc0201748:	fdc68693          	addi	a3,a3,-36 # ffffffffc0206720 <commands+0xb40>
ffffffffc020174c:	00005617          	auipc	a2,0x5
ffffffffc0201750:	cbc60613          	addi	a2,a2,-836 # ffffffffc0206408 <commands+0x828>
ffffffffc0201754:	13700593          	li	a1,311
ffffffffc0201758:	00005517          	auipc	a0,0x5
ffffffffc020175c:	cc850513          	addi	a0,a0,-824 # ffffffffc0206420 <commands+0x840>
ffffffffc0201760:	d2ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201764:	00005697          	auipc	a3,0x5
ffffffffc0201768:	fec68693          	addi	a3,a3,-20 # ffffffffc0206750 <commands+0xb70>
ffffffffc020176c:	00005617          	auipc	a2,0x5
ffffffffc0201770:	c9c60613          	addi	a2,a2,-868 # ffffffffc0206408 <commands+0x828>
ffffffffc0201774:	14700593          	li	a1,327
ffffffffc0201778:	00005517          	auipc	a0,0x5
ffffffffc020177c:	ca850513          	addi	a0,a0,-856 # ffffffffc0206420 <commands+0x840>
ffffffffc0201780:	d0ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201784:	00005697          	auipc	a3,0x5
ffffffffc0201788:	cb468693          	addi	a3,a3,-844 # ffffffffc0206438 <commands+0x858>
ffffffffc020178c:	00005617          	auipc	a2,0x5
ffffffffc0201790:	c7c60613          	addi	a2,a2,-900 # ffffffffc0206408 <commands+0x828>
ffffffffc0201794:	11300593          	li	a1,275
ffffffffc0201798:	00005517          	auipc	a0,0x5
ffffffffc020179c:	c8850513          	addi	a0,a0,-888 # ffffffffc0206420 <commands+0x840>
ffffffffc02017a0:	ceffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02017a4:	00005697          	auipc	a3,0x5
ffffffffc02017a8:	cd468693          	addi	a3,a3,-812 # ffffffffc0206478 <commands+0x898>
ffffffffc02017ac:	00005617          	auipc	a2,0x5
ffffffffc02017b0:	c5c60613          	addi	a2,a2,-932 # ffffffffc0206408 <commands+0x828>
ffffffffc02017b4:	0d800593          	li	a1,216
ffffffffc02017b8:	00005517          	auipc	a0,0x5
ffffffffc02017bc:	c6850513          	addi	a0,a0,-920 # ffffffffc0206420 <commands+0x840>
ffffffffc02017c0:	ccffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02017c4 <default_free_pages>:
{
ffffffffc02017c4:	1141                	addi	sp,sp,-16
ffffffffc02017c6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02017c8:	14058463          	beqz	a1,ffffffffc0201910 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc02017cc:	00659693          	slli	a3,a1,0x6
ffffffffc02017d0:	96aa                	add	a3,a3,a0
ffffffffc02017d2:	87aa                	mv	a5,a0
ffffffffc02017d4:	02d50263          	beq	a0,a3,ffffffffc02017f8 <default_free_pages+0x34>
ffffffffc02017d8:	6798                	ld	a4,8(a5)
ffffffffc02017da:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02017dc:	10071a63          	bnez	a4,ffffffffc02018f0 <default_free_pages+0x12c>
ffffffffc02017e0:	6798                	ld	a4,8(a5)
ffffffffc02017e2:	8b09                	andi	a4,a4,2
ffffffffc02017e4:	10071663          	bnez	a4,ffffffffc02018f0 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02017e8:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017ec:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017f0:	04078793          	addi	a5,a5,64
ffffffffc02017f4:	fed792e3          	bne	a5,a3,ffffffffc02017d8 <default_free_pages+0x14>
    base->property = n;
ffffffffc02017f8:	2581                	sext.w	a1,a1
ffffffffc02017fa:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017fc:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201800:	4789                	li	a5,2
ffffffffc0201802:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201806:	000bb697          	auipc	a3,0xbb
ffffffffc020180a:	2c268693          	addi	a3,a3,706 # ffffffffc02bcac8 <free_area>
ffffffffc020180e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201810:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201812:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201816:	9db9                	addw	a1,a1,a4
ffffffffc0201818:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc020181a:	0ad78463          	beq	a5,a3,ffffffffc02018c2 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc020181e:	fe878713          	addi	a4,a5,-24
ffffffffc0201822:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201826:	4581                	li	a1,0
            if (base < page)
ffffffffc0201828:	00e56a63          	bltu	a0,a4,ffffffffc020183c <default_free_pages+0x78>
    return listelm->next;
ffffffffc020182c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020182e:	04d70c63          	beq	a4,a3,ffffffffc0201886 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0201832:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201834:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201838:	fee57ae3          	bgeu	a0,a4,ffffffffc020182c <default_free_pages+0x68>
ffffffffc020183c:	c199                	beqz	a1,ffffffffc0201842 <default_free_pages+0x7e>
ffffffffc020183e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201842:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201844:	e390                	sd	a2,0(a5)
ffffffffc0201846:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201848:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020184a:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc020184c:	00d70d63          	beq	a4,a3,ffffffffc0201866 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201850:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201854:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0201858:	02059813          	slli	a6,a1,0x20
ffffffffc020185c:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201860:	97b2                	add	a5,a5,a2
ffffffffc0201862:	02f50c63          	beq	a0,a5,ffffffffc020189a <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0201866:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0201868:	00d78c63          	beq	a5,a3,ffffffffc0201880 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc020186c:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc020186e:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201872:	02061593          	slli	a1,a2,0x20
ffffffffc0201876:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020187a:	972a                	add	a4,a4,a0
ffffffffc020187c:	04e68a63          	beq	a3,a4,ffffffffc02018d0 <default_free_pages+0x10c>
}
ffffffffc0201880:	60a2                	ld	ra,8(sp)
ffffffffc0201882:	0141                	addi	sp,sp,16
ffffffffc0201884:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201886:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201888:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020188a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020188c:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc020188e:	02d70763          	beq	a4,a3,ffffffffc02018bc <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201892:	8832                	mv	a6,a2
ffffffffc0201894:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201896:	87ba                	mv	a5,a4
ffffffffc0201898:	bf71                	j	ffffffffc0201834 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020189a:	491c                	lw	a5,16(a0)
ffffffffc020189c:	9dbd                	addw	a1,a1,a5
ffffffffc020189e:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018a2:	57f5                	li	a5,-3
ffffffffc02018a4:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018a8:	01853803          	ld	a6,24(a0)
ffffffffc02018ac:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02018ae:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02018b0:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc02018b4:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc02018b6:	0105b023          	sd	a6,0(a1)
ffffffffc02018ba:	b77d                	j	ffffffffc0201868 <default_free_pages+0xa4>
ffffffffc02018bc:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc02018be:	873e                	mv	a4,a5
ffffffffc02018c0:	bf41                	j	ffffffffc0201850 <default_free_pages+0x8c>
}
ffffffffc02018c2:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02018c4:	e390                	sd	a2,0(a5)
ffffffffc02018c6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018c8:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02018ca:	ed1c                	sd	a5,24(a0)
ffffffffc02018cc:	0141                	addi	sp,sp,16
ffffffffc02018ce:	8082                	ret
            base->property += p->property;
ffffffffc02018d0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02018d4:	ff078693          	addi	a3,a5,-16
ffffffffc02018d8:	9e39                	addw	a2,a2,a4
ffffffffc02018da:	c910                	sw	a2,16(a0)
ffffffffc02018dc:	5775                	li	a4,-3
ffffffffc02018de:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018e2:	6398                	ld	a4,0(a5)
ffffffffc02018e4:	679c                	ld	a5,8(a5)
}
ffffffffc02018e6:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02018e8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02018ea:	e398                	sd	a4,0(a5)
ffffffffc02018ec:	0141                	addi	sp,sp,16
ffffffffc02018ee:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018f0:	00005697          	auipc	a3,0x5
ffffffffc02018f4:	e7868693          	addi	a3,a3,-392 # ffffffffc0206768 <commands+0xb88>
ffffffffc02018f8:	00005617          	auipc	a2,0x5
ffffffffc02018fc:	b1060613          	addi	a2,a2,-1264 # ffffffffc0206408 <commands+0x828>
ffffffffc0201900:	09400593          	li	a1,148
ffffffffc0201904:	00005517          	auipc	a0,0x5
ffffffffc0201908:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0206420 <commands+0x840>
ffffffffc020190c:	b83fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201910:	00005697          	auipc	a3,0x5
ffffffffc0201914:	e5068693          	addi	a3,a3,-432 # ffffffffc0206760 <commands+0xb80>
ffffffffc0201918:	00005617          	auipc	a2,0x5
ffffffffc020191c:	af060613          	addi	a2,a2,-1296 # ffffffffc0206408 <commands+0x828>
ffffffffc0201920:	09000593          	li	a1,144
ffffffffc0201924:	00005517          	auipc	a0,0x5
ffffffffc0201928:	afc50513          	addi	a0,a0,-1284 # ffffffffc0206420 <commands+0x840>
ffffffffc020192c:	b63fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201930 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201930:	c941                	beqz	a0,ffffffffc02019c0 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201932:	000bb597          	auipc	a1,0xbb
ffffffffc0201936:	19658593          	addi	a1,a1,406 # ffffffffc02bcac8 <free_area>
ffffffffc020193a:	0105a803          	lw	a6,16(a1)
ffffffffc020193e:	872a                	mv	a4,a0
ffffffffc0201940:	02081793          	slli	a5,a6,0x20
ffffffffc0201944:	9381                	srli	a5,a5,0x20
ffffffffc0201946:	00a7ee63          	bltu	a5,a0,ffffffffc0201962 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020194a:	87ae                	mv	a5,a1
ffffffffc020194c:	a801                	j	ffffffffc020195c <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc020194e:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201952:	02069613          	slli	a2,a3,0x20
ffffffffc0201956:	9201                	srli	a2,a2,0x20
ffffffffc0201958:	00e67763          	bgeu	a2,a4,ffffffffc0201966 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc020195c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc020195e:	feb798e3          	bne	a5,a1,ffffffffc020194e <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201962:	4501                	li	a0,0
}
ffffffffc0201964:	8082                	ret
    return listelm->prev;
ffffffffc0201966:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020196a:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc020196e:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201972:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201976:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020197a:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc020197e:	02c77863          	bgeu	a4,a2,ffffffffc02019ae <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201982:	071a                	slli	a4,a4,0x6
ffffffffc0201984:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201986:	41c686bb          	subw	a3,a3,t3
ffffffffc020198a:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020198c:	00870613          	addi	a2,a4,8
ffffffffc0201990:	4689                	li	a3,2
ffffffffc0201992:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201996:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020199a:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc020199e:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02019a2:	e290                	sd	a2,0(a3)
ffffffffc02019a4:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02019a8:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc02019aa:	01173c23          	sd	a7,24(a4)
ffffffffc02019ae:	41c8083b          	subw	a6,a6,t3
ffffffffc02019b2:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02019b6:	5775                	li	a4,-3
ffffffffc02019b8:	17c1                	addi	a5,a5,-16
ffffffffc02019ba:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02019be:	8082                	ret
{
ffffffffc02019c0:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02019c2:	00005697          	auipc	a3,0x5
ffffffffc02019c6:	d9e68693          	addi	a3,a3,-610 # ffffffffc0206760 <commands+0xb80>
ffffffffc02019ca:	00005617          	auipc	a2,0x5
ffffffffc02019ce:	a3e60613          	addi	a2,a2,-1474 # ffffffffc0206408 <commands+0x828>
ffffffffc02019d2:	06c00593          	li	a1,108
ffffffffc02019d6:	00005517          	auipc	a0,0x5
ffffffffc02019da:	a4a50513          	addi	a0,a0,-1462 # ffffffffc0206420 <commands+0x840>
{
ffffffffc02019de:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019e0:	aaffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02019e4 <default_init_memmap>:
{
ffffffffc02019e4:	1141                	addi	sp,sp,-16
ffffffffc02019e6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02019e8:	c5f1                	beqz	a1,ffffffffc0201ab4 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc02019ea:	00659693          	slli	a3,a1,0x6
ffffffffc02019ee:	96aa                	add	a3,a3,a0
ffffffffc02019f0:	87aa                	mv	a5,a0
ffffffffc02019f2:	00d50f63          	beq	a0,a3,ffffffffc0201a10 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019f6:	6798                	ld	a4,8(a5)
ffffffffc02019f8:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02019fa:	cf49                	beqz	a4,ffffffffc0201a94 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019fc:	0007a823          	sw	zero,16(a5)
ffffffffc0201a00:	0007b423          	sd	zero,8(a5)
ffffffffc0201a04:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a08:	04078793          	addi	a5,a5,64
ffffffffc0201a0c:	fed795e3          	bne	a5,a3,ffffffffc02019f6 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a10:	2581                	sext.w	a1,a1
ffffffffc0201a12:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a14:	4789                	li	a5,2
ffffffffc0201a16:	00850713          	addi	a4,a0,8
ffffffffc0201a1a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a1e:	000bb697          	auipc	a3,0xbb
ffffffffc0201a22:	0aa68693          	addi	a3,a3,170 # ffffffffc02bcac8 <free_area>
ffffffffc0201a26:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201a28:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a2a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201a2e:	9db9                	addw	a1,a1,a4
ffffffffc0201a30:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a32:	04d78a63          	beq	a5,a3,ffffffffc0201a86 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a36:	fe878713          	addi	a4,a5,-24
ffffffffc0201a3a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201a3e:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a40:	00e56a63          	bltu	a0,a4,ffffffffc0201a54 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a44:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a46:	02d70263          	beq	a4,a3,ffffffffc0201a6a <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201a4a:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a4c:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a50:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a44 <default_init_memmap+0x60>
ffffffffc0201a54:	c199                	beqz	a1,ffffffffc0201a5a <default_init_memmap+0x76>
ffffffffc0201a56:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a5a:	6398                	ld	a4,0(a5)
}
ffffffffc0201a5c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a5e:	e390                	sd	a2,0(a5)
ffffffffc0201a60:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a62:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a64:	ed18                	sd	a4,24(a0)
ffffffffc0201a66:	0141                	addi	sp,sp,16
ffffffffc0201a68:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a6a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a6c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a6e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a70:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a72:	00d70663          	beq	a4,a3,ffffffffc0201a7e <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a76:	8832                	mv	a6,a2
ffffffffc0201a78:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a7a:	87ba                	mv	a5,a4
ffffffffc0201a7c:	bfc1                	j	ffffffffc0201a4c <default_init_memmap+0x68>
}
ffffffffc0201a7e:	60a2                	ld	ra,8(sp)
ffffffffc0201a80:	e290                	sd	a2,0(a3)
ffffffffc0201a82:	0141                	addi	sp,sp,16
ffffffffc0201a84:	8082                	ret
ffffffffc0201a86:	60a2                	ld	ra,8(sp)
ffffffffc0201a88:	e390                	sd	a2,0(a5)
ffffffffc0201a8a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a8c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a8e:	ed1c                	sd	a5,24(a0)
ffffffffc0201a90:	0141                	addi	sp,sp,16
ffffffffc0201a92:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a94:	00005697          	auipc	a3,0x5
ffffffffc0201a98:	cfc68693          	addi	a3,a3,-772 # ffffffffc0206790 <commands+0xbb0>
ffffffffc0201a9c:	00005617          	auipc	a2,0x5
ffffffffc0201aa0:	96c60613          	addi	a2,a2,-1684 # ffffffffc0206408 <commands+0x828>
ffffffffc0201aa4:	04b00593          	li	a1,75
ffffffffc0201aa8:	00005517          	auipc	a0,0x5
ffffffffc0201aac:	97850513          	addi	a0,a0,-1672 # ffffffffc0206420 <commands+0x840>
ffffffffc0201ab0:	9dffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201ab4:	00005697          	auipc	a3,0x5
ffffffffc0201ab8:	cac68693          	addi	a3,a3,-852 # ffffffffc0206760 <commands+0xb80>
ffffffffc0201abc:	00005617          	auipc	a2,0x5
ffffffffc0201ac0:	94c60613          	addi	a2,a2,-1716 # ffffffffc0206408 <commands+0x828>
ffffffffc0201ac4:	04700593          	li	a1,71
ffffffffc0201ac8:	00005517          	auipc	a0,0x5
ffffffffc0201acc:	95850513          	addi	a0,a0,-1704 # ffffffffc0206420 <commands+0x840>
ffffffffc0201ad0:	9bffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ad4 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201ad4:	c94d                	beqz	a0,ffffffffc0201b86 <slob_free+0xb2>
{
ffffffffc0201ad6:	1141                	addi	sp,sp,-16
ffffffffc0201ad8:	e022                	sd	s0,0(sp)
ffffffffc0201ada:	e406                	sd	ra,8(sp)
ffffffffc0201adc:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201ade:	e9c1                	bnez	a1,ffffffffc0201b6e <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae0:	100027f3          	csrr	a5,sstatus
ffffffffc0201ae4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201ae6:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ae8:	ebd9                	bnez	a5,ffffffffc0201b7e <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aea:	000bb617          	auipc	a2,0xbb
ffffffffc0201aee:	bce60613          	addi	a2,a2,-1074 # ffffffffc02bc6b8 <slobfree>
ffffffffc0201af2:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201af4:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201af6:	679c                	ld	a5,8(a5)
ffffffffc0201af8:	02877a63          	bgeu	a4,s0,ffffffffc0201b2c <slob_free+0x58>
ffffffffc0201afc:	00f46463          	bltu	s0,a5,ffffffffc0201b04 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b00:	fef76ae3          	bltu	a4,a5,ffffffffc0201af4 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b04:	400c                	lw	a1,0(s0)
ffffffffc0201b06:	00459693          	slli	a3,a1,0x4
ffffffffc0201b0a:	96a2                	add	a3,a3,s0
ffffffffc0201b0c:	02d78a63          	beq	a5,a3,ffffffffc0201b40 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b10:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201b12:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b14:	00469793          	slli	a5,a3,0x4
ffffffffc0201b18:	97ba                	add	a5,a5,a4
ffffffffc0201b1a:	02f40e63          	beq	s0,a5,ffffffffc0201b56 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201b1e:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201b20:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201b22:	e129                	bnez	a0,ffffffffc0201b64 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b24:	60a2                	ld	ra,8(sp)
ffffffffc0201b26:	6402                	ld	s0,0(sp)
ffffffffc0201b28:	0141                	addi	sp,sp,16
ffffffffc0201b2a:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b2c:	fcf764e3          	bltu	a4,a5,ffffffffc0201af4 <slob_free+0x20>
ffffffffc0201b30:	fcf472e3          	bgeu	s0,a5,ffffffffc0201af4 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201b34:	400c                	lw	a1,0(s0)
ffffffffc0201b36:	00459693          	slli	a3,a1,0x4
ffffffffc0201b3a:	96a2                	add	a3,a3,s0
ffffffffc0201b3c:	fcd79ae3          	bne	a5,a3,ffffffffc0201b10 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201b40:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b42:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b44:	9db5                	addw	a1,a1,a3
ffffffffc0201b46:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201b48:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201b4a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b4c:	00469793          	slli	a5,a3,0x4
ffffffffc0201b50:	97ba                	add	a5,a5,a4
ffffffffc0201b52:	fcf416e3          	bne	s0,a5,ffffffffc0201b1e <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201b56:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201b58:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201b5a:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b5c:	9ebd                	addw	a3,a3,a5
ffffffffc0201b5e:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b60:	e70c                	sd	a1,8(a4)
ffffffffc0201b62:	d169                	beqz	a0,ffffffffc0201b24 <slob_free+0x50>
}
ffffffffc0201b64:	6402                	ld	s0,0(sp)
ffffffffc0201b66:	60a2                	ld	ra,8(sp)
ffffffffc0201b68:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b6a:	e45fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b6e:	25bd                	addiw	a1,a1,15
ffffffffc0201b70:	8191                	srli	a1,a1,0x4
ffffffffc0201b72:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b74:	100027f3          	csrr	a5,sstatus
ffffffffc0201b78:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b7a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b7c:	d7bd                	beqz	a5,ffffffffc0201aea <slob_free+0x16>
        intr_disable();
ffffffffc0201b7e:	e37fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b82:	4505                	li	a0,1
ffffffffc0201b84:	b79d                	j	ffffffffc0201aea <slob_free+0x16>
ffffffffc0201b86:	8082                	ret

ffffffffc0201b88 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b88:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b8a:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b8c:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b90:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b92:	352000ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
	if (!page)
ffffffffc0201b96:	c91d                	beqz	a0,ffffffffc0201bcc <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b98:	000bf697          	auipc	a3,0xbf
ffffffffc0201b9c:	fa06b683          	ld	a3,-96(a3) # ffffffffc02c0b38 <pages>
ffffffffc0201ba0:	8d15                	sub	a0,a0,a3
ffffffffc0201ba2:	8519                	srai	a0,a0,0x6
ffffffffc0201ba4:	00006697          	auipc	a3,0x6
ffffffffc0201ba8:	f1c6b683          	ld	a3,-228(a3) # ffffffffc0207ac0 <nbase>
ffffffffc0201bac:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201bae:	00c51793          	slli	a5,a0,0xc
ffffffffc0201bb2:	83b1                	srli	a5,a5,0xc
ffffffffc0201bb4:	000bf717          	auipc	a4,0xbf
ffffffffc0201bb8:	f7c73703          	ld	a4,-132(a4) # ffffffffc02c0b30 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201bbc:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201bbe:	00e7fa63          	bgeu	a5,a4,ffffffffc0201bd2 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201bc2:	000bf697          	auipc	a3,0xbf
ffffffffc0201bc6:	f866b683          	ld	a3,-122(a3) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc0201bca:	9536                	add	a0,a0,a3
}
ffffffffc0201bcc:	60a2                	ld	ra,8(sp)
ffffffffc0201bce:	0141                	addi	sp,sp,16
ffffffffc0201bd0:	8082                	ret
ffffffffc0201bd2:	86aa                	mv	a3,a0
ffffffffc0201bd4:	00005617          	auipc	a2,0x5
ffffffffc0201bd8:	c1c60613          	addi	a2,a2,-996 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0201bdc:	07100593          	li	a1,113
ffffffffc0201be0:	00005517          	auipc	a0,0x5
ffffffffc0201be4:	c3850513          	addi	a0,a0,-968 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0201be8:	8a7fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201bec <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201bec:	1101                	addi	sp,sp,-32
ffffffffc0201bee:	ec06                	sd	ra,24(sp)
ffffffffc0201bf0:	e822                	sd	s0,16(sp)
ffffffffc0201bf2:	e426                	sd	s1,8(sp)
ffffffffc0201bf4:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201bf6:	01050713          	addi	a4,a0,16
ffffffffc0201bfa:	6785                	lui	a5,0x1
ffffffffc0201bfc:	0cf77363          	bgeu	a4,a5,ffffffffc0201cc2 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c00:	00f50493          	addi	s1,a0,15
ffffffffc0201c04:	8091                	srli	s1,s1,0x4
ffffffffc0201c06:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c08:	10002673          	csrr	a2,sstatus
ffffffffc0201c0c:	8a09                	andi	a2,a2,2
ffffffffc0201c0e:	e25d                	bnez	a2,ffffffffc0201cb4 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201c10:	000bb917          	auipc	s2,0xbb
ffffffffc0201c14:	aa890913          	addi	s2,s2,-1368 # ffffffffc02bc6b8 <slobfree>
ffffffffc0201c18:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c1c:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201c1e:	4398                	lw	a4,0(a5)
ffffffffc0201c20:	08975e63          	bge	a4,s1,ffffffffc0201cbc <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201c24:	00f68b63          	beq	a3,a5,ffffffffc0201c3a <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c28:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c2a:	4018                	lw	a4,0(s0)
ffffffffc0201c2c:	02975a63          	bge	a4,s1,ffffffffc0201c60 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201c30:	00093683          	ld	a3,0(s2)
ffffffffc0201c34:	87a2                	mv	a5,s0
ffffffffc0201c36:	fef699e3          	bne	a3,a5,ffffffffc0201c28 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201c3a:	ee31                	bnez	a2,ffffffffc0201c96 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c3c:	4501                	li	a0,0
ffffffffc0201c3e:	f4bff0ef          	jal	ra,ffffffffc0201b88 <__slob_get_free_pages.constprop.0>
ffffffffc0201c42:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c44:	cd05                	beqz	a0,ffffffffc0201c7c <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c46:	6585                	lui	a1,0x1
ffffffffc0201c48:	e8dff0ef          	jal	ra,ffffffffc0201ad4 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c4c:	10002673          	csrr	a2,sstatus
ffffffffc0201c50:	8a09                	andi	a2,a2,2
ffffffffc0201c52:	ee05                	bnez	a2,ffffffffc0201c8a <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c54:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c58:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c5a:	4018                	lw	a4,0(s0)
ffffffffc0201c5c:	fc974ae3          	blt	a4,s1,ffffffffc0201c30 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c60:	04e48763          	beq	s1,a4,ffffffffc0201cae <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c64:	00449693          	slli	a3,s1,0x4
ffffffffc0201c68:	96a2                	add	a3,a3,s0
ffffffffc0201c6a:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c6c:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c6e:	9f05                	subw	a4,a4,s1
ffffffffc0201c70:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c72:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c74:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c76:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c7a:	e20d                	bnez	a2,ffffffffc0201c9c <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c7c:	60e2                	ld	ra,24(sp)
ffffffffc0201c7e:	8522                	mv	a0,s0
ffffffffc0201c80:	6442                	ld	s0,16(sp)
ffffffffc0201c82:	64a2                	ld	s1,8(sp)
ffffffffc0201c84:	6902                	ld	s2,0(sp)
ffffffffc0201c86:	6105                	addi	sp,sp,32
ffffffffc0201c88:	8082                	ret
        intr_disable();
ffffffffc0201c8a:	d2bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c8e:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c92:	4605                	li	a2,1
ffffffffc0201c94:	b7d1                	j	ffffffffc0201c58 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c96:	d19fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c9a:	b74d                	j	ffffffffc0201c3c <slob_alloc.constprop.0+0x50>
ffffffffc0201c9c:	d13fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201ca0:	60e2                	ld	ra,24(sp)
ffffffffc0201ca2:	8522                	mv	a0,s0
ffffffffc0201ca4:	6442                	ld	s0,16(sp)
ffffffffc0201ca6:	64a2                	ld	s1,8(sp)
ffffffffc0201ca8:	6902                	ld	s2,0(sp)
ffffffffc0201caa:	6105                	addi	sp,sp,32
ffffffffc0201cac:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cae:	6418                	ld	a4,8(s0)
ffffffffc0201cb0:	e798                	sd	a4,8(a5)
ffffffffc0201cb2:	b7d1                	j	ffffffffc0201c76 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201cb4:	d01fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201cb8:	4605                	li	a2,1
ffffffffc0201cba:	bf99                	j	ffffffffc0201c10 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201cbc:	843e                	mv	s0,a5
ffffffffc0201cbe:	87b6                	mv	a5,a3
ffffffffc0201cc0:	b745                	j	ffffffffc0201c60 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201cc2:	00005697          	auipc	a3,0x5
ffffffffc0201cc6:	b6668693          	addi	a3,a3,-1178 # ffffffffc0206828 <default_pmm_manager+0x70>
ffffffffc0201cca:	00004617          	auipc	a2,0x4
ffffffffc0201cce:	73e60613          	addi	a2,a2,1854 # ffffffffc0206408 <commands+0x828>
ffffffffc0201cd2:	06400593          	li	a1,100
ffffffffc0201cd6:	00005517          	auipc	a0,0x5
ffffffffc0201cda:	b7250513          	addi	a0,a0,-1166 # ffffffffc0206848 <default_pmm_manager+0x90>
ffffffffc0201cde:	fb0fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ce2 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ce2:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201ce4:	00005517          	auipc	a0,0x5
ffffffffc0201ce8:	b7c50513          	addi	a0,a0,-1156 # ffffffffc0206860 <default_pmm_manager+0xa8>
{
ffffffffc0201cec:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201cee:	ca6fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201cf2:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cf4:	00005517          	auipc	a0,0x5
ffffffffc0201cf8:	b8450513          	addi	a0,a0,-1148 # ffffffffc0206878 <default_pmm_manager+0xc0>
}
ffffffffc0201cfc:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cfe:	c96fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d02 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d02:	4501                	li	a0,0
ffffffffc0201d04:	8082                	ret

ffffffffc0201d06 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d06:	1101                	addi	sp,sp,-32
ffffffffc0201d08:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d0a:	6905                	lui	s2,0x1
{
ffffffffc0201d0c:	e822                	sd	s0,16(sp)
ffffffffc0201d0e:	ec06                	sd	ra,24(sp)
ffffffffc0201d10:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d12:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc1>
{
ffffffffc0201d16:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d18:	04a7f963          	bgeu	a5,a0,ffffffffc0201d6a <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d1c:	4561                	li	a0,24
ffffffffc0201d1e:	ecfff0ef          	jal	ra,ffffffffc0201bec <slob_alloc.constprop.0>
ffffffffc0201d22:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201d24:	c929                	beqz	a0,ffffffffc0201d76 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201d26:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201d2a:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d2c:	00f95763          	bge	s2,a5,ffffffffc0201d3a <kmalloc+0x34>
ffffffffc0201d30:	6705                	lui	a4,0x1
ffffffffc0201d32:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201d34:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d36:	fef74ee3          	blt	a4,a5,ffffffffc0201d32 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201d3a:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d3c:	e4dff0ef          	jal	ra,ffffffffc0201b88 <__slob_get_free_pages.constprop.0>
ffffffffc0201d40:	e488                	sd	a0,8(s1)
ffffffffc0201d42:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201d44:	c525                	beqz	a0,ffffffffc0201dac <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d46:	100027f3          	csrr	a5,sstatus
ffffffffc0201d4a:	8b89                	andi	a5,a5,2
ffffffffc0201d4c:	ef8d                	bnez	a5,ffffffffc0201d86 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d4e:	000bf797          	auipc	a5,0xbf
ffffffffc0201d52:	dca78793          	addi	a5,a5,-566 # ffffffffc02c0b18 <bigblocks>
ffffffffc0201d56:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d58:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d5a:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d5c:	60e2                	ld	ra,24(sp)
ffffffffc0201d5e:	8522                	mv	a0,s0
ffffffffc0201d60:	6442                	ld	s0,16(sp)
ffffffffc0201d62:	64a2                	ld	s1,8(sp)
ffffffffc0201d64:	6902                	ld	s2,0(sp)
ffffffffc0201d66:	6105                	addi	sp,sp,32
ffffffffc0201d68:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d6a:	0541                	addi	a0,a0,16
ffffffffc0201d6c:	e81ff0ef          	jal	ra,ffffffffc0201bec <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d70:	01050413          	addi	s0,a0,16
ffffffffc0201d74:	f565                	bnez	a0,ffffffffc0201d5c <kmalloc+0x56>
ffffffffc0201d76:	4401                	li	s0,0
}
ffffffffc0201d78:	60e2                	ld	ra,24(sp)
ffffffffc0201d7a:	8522                	mv	a0,s0
ffffffffc0201d7c:	6442                	ld	s0,16(sp)
ffffffffc0201d7e:	64a2                	ld	s1,8(sp)
ffffffffc0201d80:	6902                	ld	s2,0(sp)
ffffffffc0201d82:	6105                	addi	sp,sp,32
ffffffffc0201d84:	8082                	ret
        intr_disable();
ffffffffc0201d86:	c2ffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d8a:	000bf797          	auipc	a5,0xbf
ffffffffc0201d8e:	d8e78793          	addi	a5,a5,-626 # ffffffffc02c0b18 <bigblocks>
ffffffffc0201d92:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d94:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d96:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d98:	c17fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d9c:	6480                	ld	s0,8(s1)
}
ffffffffc0201d9e:	60e2                	ld	ra,24(sp)
ffffffffc0201da0:	64a2                	ld	s1,8(sp)
ffffffffc0201da2:	8522                	mv	a0,s0
ffffffffc0201da4:	6442                	ld	s0,16(sp)
ffffffffc0201da6:	6902                	ld	s2,0(sp)
ffffffffc0201da8:	6105                	addi	sp,sp,32
ffffffffc0201daa:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dac:	45e1                	li	a1,24
ffffffffc0201dae:	8526                	mv	a0,s1
ffffffffc0201db0:	d25ff0ef          	jal	ra,ffffffffc0201ad4 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201db4:	b765                	j	ffffffffc0201d5c <kmalloc+0x56>

ffffffffc0201db6 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201db6:	c169                	beqz	a0,ffffffffc0201e78 <kfree+0xc2>
{
ffffffffc0201db8:	1101                	addi	sp,sp,-32
ffffffffc0201dba:	e822                	sd	s0,16(sp)
ffffffffc0201dbc:	ec06                	sd	ra,24(sp)
ffffffffc0201dbe:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201dc0:	03451793          	slli	a5,a0,0x34
ffffffffc0201dc4:	842a                	mv	s0,a0
ffffffffc0201dc6:	e3d9                	bnez	a5,ffffffffc0201e4c <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201dc8:	100027f3          	csrr	a5,sstatus
ffffffffc0201dcc:	8b89                	andi	a5,a5,2
ffffffffc0201dce:	e7d9                	bnez	a5,ffffffffc0201e5c <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201dd0:	000bf797          	auipc	a5,0xbf
ffffffffc0201dd4:	d487b783          	ld	a5,-696(a5) # ffffffffc02c0b18 <bigblocks>
    return 0;
ffffffffc0201dd8:	4601                	li	a2,0
ffffffffc0201dda:	cbad                	beqz	a5,ffffffffc0201e4c <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201ddc:	000bf697          	auipc	a3,0xbf
ffffffffc0201de0:	d3c68693          	addi	a3,a3,-708 # ffffffffc02c0b18 <bigblocks>
ffffffffc0201de4:	a021                	j	ffffffffc0201dec <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201de6:	01048693          	addi	a3,s1,16
ffffffffc0201dea:	c3a5                	beqz	a5,ffffffffc0201e4a <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201dec:	6798                	ld	a4,8(a5)
ffffffffc0201dee:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201df0:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201df2:	fe871ae3          	bne	a4,s0,ffffffffc0201de6 <kfree+0x30>
				*last = bb->next;
ffffffffc0201df6:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201df8:	ee2d                	bnez	a2,ffffffffc0201e72 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201dfa:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201dfe:	4098                	lw	a4,0(s1)
ffffffffc0201e00:	08f46963          	bltu	s0,a5,ffffffffc0201e92 <kfree+0xdc>
ffffffffc0201e04:	000bf697          	auipc	a3,0xbf
ffffffffc0201e08:	d446b683          	ld	a3,-700(a3) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc0201e0c:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201e0e:	8031                	srli	s0,s0,0xc
ffffffffc0201e10:	000bf797          	auipc	a5,0xbf
ffffffffc0201e14:	d207b783          	ld	a5,-736(a5) # ffffffffc02c0b30 <npage>
ffffffffc0201e18:	06f47163          	bgeu	s0,a5,ffffffffc0201e7a <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e1c:	00006517          	auipc	a0,0x6
ffffffffc0201e20:	ca453503          	ld	a0,-860(a0) # ffffffffc0207ac0 <nbase>
ffffffffc0201e24:	8c09                	sub	s0,s0,a0
ffffffffc0201e26:	041a                	slli	s0,s0,0x6
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201e28:	000bf517          	auipc	a0,0xbf
ffffffffc0201e2c:	d1053503          	ld	a0,-752(a0) # ffffffffc02c0b38 <pages>
ffffffffc0201e30:	4585                	li	a1,1
ffffffffc0201e32:	9522                	add	a0,a0,s0
ffffffffc0201e34:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201e38:	0ea000ef          	jal	ra,ffffffffc0201f22 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e3c:	6442                	ld	s0,16(sp)
ffffffffc0201e3e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e40:	8526                	mv	a0,s1
}
ffffffffc0201e42:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e44:	45e1                	li	a1,24
}
ffffffffc0201e46:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e48:	b171                	j	ffffffffc0201ad4 <slob_free>
ffffffffc0201e4a:	e20d                	bnez	a2,ffffffffc0201e6c <kfree+0xb6>
ffffffffc0201e4c:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e50:	6442                	ld	s0,16(sp)
ffffffffc0201e52:	60e2                	ld	ra,24(sp)
ffffffffc0201e54:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e56:	4581                	li	a1,0
}
ffffffffc0201e58:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e5a:	b9ad                	j	ffffffffc0201ad4 <slob_free>
        intr_disable();
ffffffffc0201e5c:	b59fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e60:	000bf797          	auipc	a5,0xbf
ffffffffc0201e64:	cb87b783          	ld	a5,-840(a5) # ffffffffc02c0b18 <bigblocks>
        return 1;
ffffffffc0201e68:	4605                	li	a2,1
ffffffffc0201e6a:	fbad                	bnez	a5,ffffffffc0201ddc <kfree+0x26>
        intr_enable();
ffffffffc0201e6c:	b43fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e70:	bff1                	j	ffffffffc0201e4c <kfree+0x96>
ffffffffc0201e72:	b3dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e76:	b751                	j	ffffffffc0201dfa <kfree+0x44>
ffffffffc0201e78:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e7a:	00005617          	auipc	a2,0x5
ffffffffc0201e7e:	a4660613          	addi	a2,a2,-1466 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc0201e82:	06900593          	li	a1,105
ffffffffc0201e86:	00005517          	auipc	a0,0x5
ffffffffc0201e8a:	99250513          	addi	a0,a0,-1646 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0201e8e:	e00fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e92:	86a2                	mv	a3,s0
ffffffffc0201e94:	00005617          	auipc	a2,0x5
ffffffffc0201e98:	a0460613          	addi	a2,a2,-1532 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc0201e9c:	07700593          	li	a1,119
ffffffffc0201ea0:	00005517          	auipc	a0,0x5
ffffffffc0201ea4:	97850513          	addi	a0,a0,-1672 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0201ea8:	de6fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201eac <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201eac:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201eae:	00005617          	auipc	a2,0x5
ffffffffc0201eb2:	a1260613          	addi	a2,a2,-1518 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc0201eb6:	06900593          	li	a1,105
ffffffffc0201eba:	00005517          	auipc	a0,0x5
ffffffffc0201ebe:	95e50513          	addi	a0,a0,-1698 # ffffffffc0206818 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201ec2:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201ec4:	dcafe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ec8 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201ec8:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201eca:	00005617          	auipc	a2,0x5
ffffffffc0201ece:	a1660613          	addi	a2,a2,-1514 # ffffffffc02068e0 <default_pmm_manager+0x128>
ffffffffc0201ed2:	07f00593          	li	a1,127
ffffffffc0201ed6:	00005517          	auipc	a0,0x5
ffffffffc0201eda:	94250513          	addi	a0,a0,-1726 # ffffffffc0206818 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201ede:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201ee0:	daefe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ee4 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ee4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ee8:	8b89                	andi	a5,a5,2
ffffffffc0201eea:	e799                	bnez	a5,ffffffffc0201ef8 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eec:	000bf797          	auipc	a5,0xbf
ffffffffc0201ef0:	c547b783          	ld	a5,-940(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201ef4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ef6:	8782                	jr	a5
{
ffffffffc0201ef8:	1141                	addi	sp,sp,-16
ffffffffc0201efa:	e406                	sd	ra,8(sp)
ffffffffc0201efc:	e022                	sd	s0,0(sp)
ffffffffc0201efe:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201f00:	ab5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f04:	000bf797          	auipc	a5,0xbf
ffffffffc0201f08:	c3c7b783          	ld	a5,-964(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201f0c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f0e:	8522                	mv	a0,s0
ffffffffc0201f10:	9782                	jalr	a5
ffffffffc0201f12:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f14:	a9bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f18:	60a2                	ld	ra,8(sp)
ffffffffc0201f1a:	8522                	mv	a0,s0
ffffffffc0201f1c:	6402                	ld	s0,0(sp)
ffffffffc0201f1e:	0141                	addi	sp,sp,16
ffffffffc0201f20:	8082                	ret

ffffffffc0201f22 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f22:	100027f3          	csrr	a5,sstatus
ffffffffc0201f26:	8b89                	andi	a5,a5,2
ffffffffc0201f28:	e799                	bnez	a5,ffffffffc0201f36 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f2a:	000bf797          	auipc	a5,0xbf
ffffffffc0201f2e:	c167b783          	ld	a5,-1002(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201f32:	739c                	ld	a5,32(a5)
ffffffffc0201f34:	8782                	jr	a5
{
ffffffffc0201f36:	1101                	addi	sp,sp,-32
ffffffffc0201f38:	ec06                	sd	ra,24(sp)
ffffffffc0201f3a:	e822                	sd	s0,16(sp)
ffffffffc0201f3c:	e426                	sd	s1,8(sp)
ffffffffc0201f3e:	842a                	mv	s0,a0
ffffffffc0201f40:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f42:	a73fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f46:	000bf797          	auipc	a5,0xbf
ffffffffc0201f4a:	bfa7b783          	ld	a5,-1030(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201f4e:	739c                	ld	a5,32(a5)
ffffffffc0201f50:	85a6                	mv	a1,s1
ffffffffc0201f52:	8522                	mv	a0,s0
ffffffffc0201f54:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f56:	6442                	ld	s0,16(sp)
ffffffffc0201f58:	60e2                	ld	ra,24(sp)
ffffffffc0201f5a:	64a2                	ld	s1,8(sp)
ffffffffc0201f5c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f5e:	a51fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f62 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f62:	100027f3          	csrr	a5,sstatus
ffffffffc0201f66:	8b89                	andi	a5,a5,2
ffffffffc0201f68:	e799                	bnez	a5,ffffffffc0201f76 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f6a:	000bf797          	auipc	a5,0xbf
ffffffffc0201f6e:	bd67b783          	ld	a5,-1066(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201f72:	779c                	ld	a5,40(a5)
ffffffffc0201f74:	8782                	jr	a5
{
ffffffffc0201f76:	1141                	addi	sp,sp,-16
ffffffffc0201f78:	e406                	sd	ra,8(sp)
ffffffffc0201f7a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f7c:	a39fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f80:	000bf797          	auipc	a5,0xbf
ffffffffc0201f84:	bc07b783          	ld	a5,-1088(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201f88:	779c                	ld	a5,40(a5)
ffffffffc0201f8a:	9782                	jalr	a5
ffffffffc0201f8c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f8e:	a21fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f92:	60a2                	ld	ra,8(sp)
ffffffffc0201f94:	8522                	mv	a0,s0
ffffffffc0201f96:	6402                	ld	s0,0(sp)
ffffffffc0201f98:	0141                	addi	sp,sp,16
ffffffffc0201f9a:	8082                	ret

ffffffffc0201f9c <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f9c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201fa0:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201fa4:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fa6:	078e                	slli	a5,a5,0x3
{
ffffffffc0201fa8:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201faa:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201fae:	6094                	ld	a3,0(s1)
{
ffffffffc0201fb0:	f04a                	sd	s2,32(sp)
ffffffffc0201fb2:	ec4e                	sd	s3,24(sp)
ffffffffc0201fb4:	e852                	sd	s4,16(sp)
ffffffffc0201fb6:	fc06                	sd	ra,56(sp)
ffffffffc0201fb8:	f822                	sd	s0,48(sp)
ffffffffc0201fba:	e456                	sd	s5,8(sp)
ffffffffc0201fbc:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201fbe:	0016f793          	andi	a5,a3,1
{
ffffffffc0201fc2:	892e                	mv	s2,a1
ffffffffc0201fc4:	8a32                	mv	s4,a2
ffffffffc0201fc6:	000bf997          	auipc	s3,0xbf
ffffffffc0201fca:	b6a98993          	addi	s3,s3,-1174 # ffffffffc02c0b30 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201fce:	efbd                	bnez	a5,ffffffffc020204c <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fd0:	14060c63          	beqz	a2,ffffffffc0202128 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fd4:	100027f3          	csrr	a5,sstatus
ffffffffc0201fd8:	8b89                	andi	a5,a5,2
ffffffffc0201fda:	14079963          	bnez	a5,ffffffffc020212c <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fde:	000bf797          	auipc	a5,0xbf
ffffffffc0201fe2:	b627b783          	ld	a5,-1182(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0201fe6:	6f9c                	ld	a5,24(a5)
ffffffffc0201fe8:	4505                	li	a0,1
ffffffffc0201fea:	9782                	jalr	a5
ffffffffc0201fec:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fee:	12040d63          	beqz	s0,ffffffffc0202128 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201ff2:	000bfb17          	auipc	s6,0xbf
ffffffffc0201ff6:	b46b0b13          	addi	s6,s6,-1210 # ffffffffc02c0b38 <pages>
ffffffffc0201ffa:	000b3503          	ld	a0,0(s6)
ffffffffc0201ffe:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202002:	000bf997          	auipc	s3,0xbf
ffffffffc0202006:	b2e98993          	addi	s3,s3,-1234 # ffffffffc02c0b30 <npage>
ffffffffc020200a:	40a40533          	sub	a0,s0,a0
ffffffffc020200e:	8519                	srai	a0,a0,0x6
ffffffffc0202010:	9556                	add	a0,a0,s5
ffffffffc0202012:	0009b703          	ld	a4,0(s3)
ffffffffc0202016:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020201a:	4685                	li	a3,1
ffffffffc020201c:	c014                	sw	a3,0(s0)
ffffffffc020201e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202020:	0532                	slli	a0,a0,0xc
ffffffffc0202022:	16e7f763          	bgeu	a5,a4,ffffffffc0202190 <get_pte+0x1f4>
ffffffffc0202026:	000bf797          	auipc	a5,0xbf
ffffffffc020202a:	b227b783          	ld	a5,-1246(a5) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc020202e:	6605                	lui	a2,0x1
ffffffffc0202030:	4581                	li	a1,0
ffffffffc0202032:	953e                	add	a0,a0,a5
ffffffffc0202034:	119030ef          	jal	ra,ffffffffc020594c <memset>
    return page - pages + nbase;
ffffffffc0202038:	000b3683          	ld	a3,0(s6)
ffffffffc020203c:	40d406b3          	sub	a3,s0,a3
ffffffffc0202040:	8699                	srai	a3,a3,0x6
ffffffffc0202042:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202044:	06aa                	slli	a3,a3,0xa
ffffffffc0202046:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020204a:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020204c:	77fd                	lui	a5,0xfffff
ffffffffc020204e:	068a                	slli	a3,a3,0x2
ffffffffc0202050:	0009b703          	ld	a4,0(s3)
ffffffffc0202054:	8efd                	and	a3,a3,a5
ffffffffc0202056:	00c6d793          	srli	a5,a3,0xc
ffffffffc020205a:	10e7ff63          	bgeu	a5,a4,ffffffffc0202178 <get_pte+0x1dc>
ffffffffc020205e:	000bfa97          	auipc	s5,0xbf
ffffffffc0202062:	aeaa8a93          	addi	s5,s5,-1302 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc0202066:	000ab403          	ld	s0,0(s5)
ffffffffc020206a:	01595793          	srli	a5,s2,0x15
ffffffffc020206e:	1ff7f793          	andi	a5,a5,511
ffffffffc0202072:	96a2                	add	a3,a3,s0
ffffffffc0202074:	00379413          	slli	s0,a5,0x3
ffffffffc0202078:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020207a:	6014                	ld	a3,0(s0)
ffffffffc020207c:	0016f793          	andi	a5,a3,1
ffffffffc0202080:	ebad                	bnez	a5,ffffffffc02020f2 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202082:	0a0a0363          	beqz	s4,ffffffffc0202128 <get_pte+0x18c>
ffffffffc0202086:	100027f3          	csrr	a5,sstatus
ffffffffc020208a:	8b89                	andi	a5,a5,2
ffffffffc020208c:	efcd                	bnez	a5,ffffffffc0202146 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc020208e:	000bf797          	auipc	a5,0xbf
ffffffffc0202092:	ab27b783          	ld	a5,-1358(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202096:	6f9c                	ld	a5,24(a5)
ffffffffc0202098:	4505                	li	a0,1
ffffffffc020209a:	9782                	jalr	a5
ffffffffc020209c:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020209e:	c4c9                	beqz	s1,ffffffffc0202128 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02020a0:	000bfb17          	auipc	s6,0xbf
ffffffffc02020a4:	a98b0b13          	addi	s6,s6,-1384 # ffffffffc02c0b38 <pages>
ffffffffc02020a8:	000b3503          	ld	a0,0(s6)
ffffffffc02020ac:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02020b0:	0009b703          	ld	a4,0(s3)
ffffffffc02020b4:	40a48533          	sub	a0,s1,a0
ffffffffc02020b8:	8519                	srai	a0,a0,0x6
ffffffffc02020ba:	9552                	add	a0,a0,s4
ffffffffc02020bc:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02020c0:	4685                	li	a3,1
ffffffffc02020c2:	c094                	sw	a3,0(s1)
ffffffffc02020c4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02020c6:	0532                	slli	a0,a0,0xc
ffffffffc02020c8:	0ee7f163          	bgeu	a5,a4,ffffffffc02021aa <get_pte+0x20e>
ffffffffc02020cc:	000ab783          	ld	a5,0(s5)
ffffffffc02020d0:	6605                	lui	a2,0x1
ffffffffc02020d2:	4581                	li	a1,0
ffffffffc02020d4:	953e                	add	a0,a0,a5
ffffffffc02020d6:	077030ef          	jal	ra,ffffffffc020594c <memset>
    return page - pages + nbase;
ffffffffc02020da:	000b3683          	ld	a3,0(s6)
ffffffffc02020de:	40d486b3          	sub	a3,s1,a3
ffffffffc02020e2:	8699                	srai	a3,a3,0x6
ffffffffc02020e4:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020e6:	06aa                	slli	a3,a3,0xa
ffffffffc02020e8:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020ec:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020ee:	0009b703          	ld	a4,0(s3)
ffffffffc02020f2:	068a                	slli	a3,a3,0x2
ffffffffc02020f4:	757d                	lui	a0,0xfffff
ffffffffc02020f6:	8ee9                	and	a3,a3,a0
ffffffffc02020f8:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020fc:	06e7f263          	bgeu	a5,a4,ffffffffc0202160 <get_pte+0x1c4>
ffffffffc0202100:	000ab503          	ld	a0,0(s5)
ffffffffc0202104:	00c95913          	srli	s2,s2,0xc
ffffffffc0202108:	1ff97913          	andi	s2,s2,511
ffffffffc020210c:	96aa                	add	a3,a3,a0
ffffffffc020210e:	00391513          	slli	a0,s2,0x3
ffffffffc0202112:	9536                	add	a0,a0,a3
}
ffffffffc0202114:	70e2                	ld	ra,56(sp)
ffffffffc0202116:	7442                	ld	s0,48(sp)
ffffffffc0202118:	74a2                	ld	s1,40(sp)
ffffffffc020211a:	7902                	ld	s2,32(sp)
ffffffffc020211c:	69e2                	ld	s3,24(sp)
ffffffffc020211e:	6a42                	ld	s4,16(sp)
ffffffffc0202120:	6aa2                	ld	s5,8(sp)
ffffffffc0202122:	6b02                	ld	s6,0(sp)
ffffffffc0202124:	6121                	addi	sp,sp,64
ffffffffc0202126:	8082                	ret
            return NULL;
ffffffffc0202128:	4501                	li	a0,0
ffffffffc020212a:	b7ed                	j	ffffffffc0202114 <get_pte+0x178>
        intr_disable();
ffffffffc020212c:	889fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202130:	000bf797          	auipc	a5,0xbf
ffffffffc0202134:	a107b783          	ld	a5,-1520(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202138:	6f9c                	ld	a5,24(a5)
ffffffffc020213a:	4505                	li	a0,1
ffffffffc020213c:	9782                	jalr	a5
ffffffffc020213e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202140:	86ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202144:	b56d                	j	ffffffffc0201fee <get_pte+0x52>
        intr_disable();
ffffffffc0202146:	86ffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020214a:	000bf797          	auipc	a5,0xbf
ffffffffc020214e:	9f67b783          	ld	a5,-1546(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202152:	6f9c                	ld	a5,24(a5)
ffffffffc0202154:	4505                	li	a0,1
ffffffffc0202156:	9782                	jalr	a5
ffffffffc0202158:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020215a:	855fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020215e:	b781                	j	ffffffffc020209e <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202160:	00004617          	auipc	a2,0x4
ffffffffc0202164:	69060613          	addi	a2,a2,1680 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0202168:	0fb00593          	li	a1,251
ffffffffc020216c:	00004517          	auipc	a0,0x4
ffffffffc0202170:	79c50513          	addi	a0,a0,1948 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202174:	b1afe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202178:	00004617          	auipc	a2,0x4
ffffffffc020217c:	67860613          	addi	a2,a2,1656 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0202180:	0ee00593          	li	a1,238
ffffffffc0202184:	00004517          	auipc	a0,0x4
ffffffffc0202188:	78450513          	addi	a0,a0,1924 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020218c:	b02fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202190:	86aa                	mv	a3,a0
ffffffffc0202192:	00004617          	auipc	a2,0x4
ffffffffc0202196:	65e60613          	addi	a2,a2,1630 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc020219a:	0ea00593          	li	a1,234
ffffffffc020219e:	00004517          	auipc	a0,0x4
ffffffffc02021a2:	76a50513          	addi	a0,a0,1898 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02021a6:	ae8fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021aa:	86aa                	mv	a3,a0
ffffffffc02021ac:	00004617          	auipc	a2,0x4
ffffffffc02021b0:	64460613          	addi	a2,a2,1604 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc02021b4:	0f800593          	li	a1,248
ffffffffc02021b8:	00004517          	auipc	a0,0x4
ffffffffc02021bc:	75050513          	addi	a0,a0,1872 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02021c0:	acefe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02021c4 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02021c4:	1141                	addi	sp,sp,-16
ffffffffc02021c6:	e022                	sd	s0,0(sp)
ffffffffc02021c8:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021ca:	4601                	li	a2,0
{
ffffffffc02021cc:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02021ce:	dcfff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
    if (ptep_store != NULL)
ffffffffc02021d2:	c011                	beqz	s0,ffffffffc02021d6 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02021d4:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021d6:	c511                	beqz	a0,ffffffffc02021e2 <get_page+0x1e>
ffffffffc02021d8:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02021da:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02021dc:	0017f713          	andi	a4,a5,1
ffffffffc02021e0:	e709                	bnez	a4,ffffffffc02021ea <get_page+0x26>
}
ffffffffc02021e2:	60a2                	ld	ra,8(sp)
ffffffffc02021e4:	6402                	ld	s0,0(sp)
ffffffffc02021e6:	0141                	addi	sp,sp,16
ffffffffc02021e8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02021ea:	078a                	slli	a5,a5,0x2
ffffffffc02021ec:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021ee:	000bf717          	auipc	a4,0xbf
ffffffffc02021f2:	94273703          	ld	a4,-1726(a4) # ffffffffc02c0b30 <npage>
ffffffffc02021f6:	00e7ff63          	bgeu	a5,a4,ffffffffc0202214 <get_page+0x50>
ffffffffc02021fa:	60a2                	ld	ra,8(sp)
ffffffffc02021fc:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021fe:	fff80537          	lui	a0,0xfff80
ffffffffc0202202:	97aa                	add	a5,a5,a0
ffffffffc0202204:	079a                	slli	a5,a5,0x6
ffffffffc0202206:	000bf517          	auipc	a0,0xbf
ffffffffc020220a:	93253503          	ld	a0,-1742(a0) # ffffffffc02c0b38 <pages>
ffffffffc020220e:	953e                	add	a0,a0,a5
ffffffffc0202210:	0141                	addi	sp,sp,16
ffffffffc0202212:	8082                	ret
ffffffffc0202214:	c99ff0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>

ffffffffc0202218 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202218:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020221a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020221e:	f486                	sd	ra,104(sp)
ffffffffc0202220:	f0a2                	sd	s0,96(sp)
ffffffffc0202222:	eca6                	sd	s1,88(sp)
ffffffffc0202224:	e8ca                	sd	s2,80(sp)
ffffffffc0202226:	e4ce                	sd	s3,72(sp)
ffffffffc0202228:	e0d2                	sd	s4,64(sp)
ffffffffc020222a:	fc56                	sd	s5,56(sp)
ffffffffc020222c:	f85a                	sd	s6,48(sp)
ffffffffc020222e:	f45e                	sd	s7,40(sp)
ffffffffc0202230:	f062                	sd	s8,32(sp)
ffffffffc0202232:	ec66                	sd	s9,24(sp)
ffffffffc0202234:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202236:	17d2                	slli	a5,a5,0x34
ffffffffc0202238:	e3ed                	bnez	a5,ffffffffc020231a <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020223a:	002007b7          	lui	a5,0x200
ffffffffc020223e:	842e                	mv	s0,a1
ffffffffc0202240:	0ef5ed63          	bltu	a1,a5,ffffffffc020233a <unmap_range+0x122>
ffffffffc0202244:	8932                	mv	s2,a2
ffffffffc0202246:	0ec5fa63          	bgeu	a1,a2,ffffffffc020233a <unmap_range+0x122>
ffffffffc020224a:	4785                	li	a5,1
ffffffffc020224c:	07fe                	slli	a5,a5,0x1f
ffffffffc020224e:	0ec7e663          	bltu	a5,a2,ffffffffc020233a <unmap_range+0x122>
ffffffffc0202252:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202254:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202256:	000bfc97          	auipc	s9,0xbf
ffffffffc020225a:	8dac8c93          	addi	s9,s9,-1830 # ffffffffc02c0b30 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020225e:	000bfc17          	auipc	s8,0xbf
ffffffffc0202262:	8dac0c13          	addi	s8,s8,-1830 # ffffffffc02c0b38 <pages>
ffffffffc0202266:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020226a:	000bfd17          	auipc	s10,0xbf
ffffffffc020226e:	8d6d0d13          	addi	s10,s10,-1834 # ffffffffc02c0b40 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202272:	00200b37          	lui	s6,0x200
ffffffffc0202276:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020227a:	4601                	li	a2,0
ffffffffc020227c:	85a2                	mv	a1,s0
ffffffffc020227e:	854e                	mv	a0,s3
ffffffffc0202280:	d1dff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc0202284:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0202286:	cd29                	beqz	a0,ffffffffc02022e0 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0202288:	611c                	ld	a5,0(a0)
ffffffffc020228a:	e395                	bnez	a5,ffffffffc02022ae <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020228c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020228e:	ff2466e3          	bltu	s0,s2,ffffffffc020227a <unmap_range+0x62>
}
ffffffffc0202292:	70a6                	ld	ra,104(sp)
ffffffffc0202294:	7406                	ld	s0,96(sp)
ffffffffc0202296:	64e6                	ld	s1,88(sp)
ffffffffc0202298:	6946                	ld	s2,80(sp)
ffffffffc020229a:	69a6                	ld	s3,72(sp)
ffffffffc020229c:	6a06                	ld	s4,64(sp)
ffffffffc020229e:	7ae2                	ld	s5,56(sp)
ffffffffc02022a0:	7b42                	ld	s6,48(sp)
ffffffffc02022a2:	7ba2                	ld	s7,40(sp)
ffffffffc02022a4:	7c02                	ld	s8,32(sp)
ffffffffc02022a6:	6ce2                	ld	s9,24(sp)
ffffffffc02022a8:	6d42                	ld	s10,16(sp)
ffffffffc02022aa:	6165                	addi	sp,sp,112
ffffffffc02022ac:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02022ae:	0017f713          	andi	a4,a5,1
ffffffffc02022b2:	df69                	beqz	a4,ffffffffc020228c <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc02022b4:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02022b8:	078a                	slli	a5,a5,0x2
ffffffffc02022ba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02022bc:	08e7ff63          	bgeu	a5,a4,ffffffffc020235a <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc02022c0:	000c3503          	ld	a0,0(s8)
ffffffffc02022c4:	97de                	add	a5,a5,s7
ffffffffc02022c6:	079a                	slli	a5,a5,0x6
ffffffffc02022c8:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02022ca:	411c                	lw	a5,0(a0)
ffffffffc02022cc:	fff7871b          	addiw	a4,a5,-1
ffffffffc02022d0:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02022d2:	cf11                	beqz	a4,ffffffffc02022ee <unmap_range+0xd6>
        *ptep = 0;
ffffffffc02022d4:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022d8:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02022dc:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02022de:	bf45                	j	ffffffffc020228e <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022e0:	945a                	add	s0,s0,s6
ffffffffc02022e2:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02022e6:	d455                	beqz	s0,ffffffffc0202292 <unmap_range+0x7a>
ffffffffc02022e8:	f92469e3          	bltu	s0,s2,ffffffffc020227a <unmap_range+0x62>
ffffffffc02022ec:	b75d                	j	ffffffffc0202292 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022ee:	100027f3          	csrr	a5,sstatus
ffffffffc02022f2:	8b89                	andi	a5,a5,2
ffffffffc02022f4:	e799                	bnez	a5,ffffffffc0202302 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02022f6:	000d3783          	ld	a5,0(s10)
ffffffffc02022fa:	4585                	li	a1,1
ffffffffc02022fc:	739c                	ld	a5,32(a5)
ffffffffc02022fe:	9782                	jalr	a5
    if (flag)
ffffffffc0202300:	bfd1                	j	ffffffffc02022d4 <unmap_range+0xbc>
ffffffffc0202302:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202304:	eb0fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202308:	000d3783          	ld	a5,0(s10)
ffffffffc020230c:	6522                	ld	a0,8(sp)
ffffffffc020230e:	4585                	li	a1,1
ffffffffc0202310:	739c                	ld	a5,32(a5)
ffffffffc0202312:	9782                	jalr	a5
        intr_enable();
ffffffffc0202314:	e9afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202318:	bf75                	j	ffffffffc02022d4 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020231a:	00004697          	auipc	a3,0x4
ffffffffc020231e:	5fe68693          	addi	a3,a3,1534 # ffffffffc0206918 <default_pmm_manager+0x160>
ffffffffc0202322:	00004617          	auipc	a2,0x4
ffffffffc0202326:	0e660613          	addi	a2,a2,230 # ffffffffc0206408 <commands+0x828>
ffffffffc020232a:	12100593          	li	a1,289
ffffffffc020232e:	00004517          	auipc	a0,0x4
ffffffffc0202332:	5da50513          	addi	a0,a0,1498 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202336:	958fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020233a:	00004697          	auipc	a3,0x4
ffffffffc020233e:	60e68693          	addi	a3,a3,1550 # ffffffffc0206948 <default_pmm_manager+0x190>
ffffffffc0202342:	00004617          	auipc	a2,0x4
ffffffffc0202346:	0c660613          	addi	a2,a2,198 # ffffffffc0206408 <commands+0x828>
ffffffffc020234a:	12200593          	li	a1,290
ffffffffc020234e:	00004517          	auipc	a0,0x4
ffffffffc0202352:	5ba50513          	addi	a0,a0,1466 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202356:	938fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020235a:	b53ff0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>

ffffffffc020235e <exit_range>:
{
ffffffffc020235e:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202360:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202364:	fc86                	sd	ra,120(sp)
ffffffffc0202366:	f8a2                	sd	s0,112(sp)
ffffffffc0202368:	f4a6                	sd	s1,104(sp)
ffffffffc020236a:	f0ca                	sd	s2,96(sp)
ffffffffc020236c:	ecce                	sd	s3,88(sp)
ffffffffc020236e:	e8d2                	sd	s4,80(sp)
ffffffffc0202370:	e4d6                	sd	s5,72(sp)
ffffffffc0202372:	e0da                	sd	s6,64(sp)
ffffffffc0202374:	fc5e                	sd	s7,56(sp)
ffffffffc0202376:	f862                	sd	s8,48(sp)
ffffffffc0202378:	f466                	sd	s9,40(sp)
ffffffffc020237a:	f06a                	sd	s10,32(sp)
ffffffffc020237c:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020237e:	17d2                	slli	a5,a5,0x34
ffffffffc0202380:	20079a63          	bnez	a5,ffffffffc0202594 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202384:	002007b7          	lui	a5,0x200
ffffffffc0202388:	24f5e463          	bltu	a1,a5,ffffffffc02025d0 <exit_range+0x272>
ffffffffc020238c:	8ab2                	mv	s5,a2
ffffffffc020238e:	24c5f163          	bgeu	a1,a2,ffffffffc02025d0 <exit_range+0x272>
ffffffffc0202392:	4785                	li	a5,1
ffffffffc0202394:	07fe                	slli	a5,a5,0x1f
ffffffffc0202396:	22c7ed63          	bltu	a5,a2,ffffffffc02025d0 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020239a:	c00009b7          	lui	s3,0xc0000
ffffffffc020239e:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023a2:	ffe00937          	lui	s2,0xffe00
ffffffffc02023a6:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc02023aa:	5cfd                	li	s9,-1
ffffffffc02023ac:	8c2a                	mv	s8,a0
ffffffffc02023ae:	0125f933          	and	s2,a1,s2
ffffffffc02023b2:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc02023b4:	000bed17          	auipc	s10,0xbe
ffffffffc02023b8:	77cd0d13          	addi	s10,s10,1916 # ffffffffc02c0b30 <npage>
    return KADDR(page2pa(page));
ffffffffc02023bc:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02023c0:	000be717          	auipc	a4,0xbe
ffffffffc02023c4:	77870713          	addi	a4,a4,1912 # ffffffffc02c0b38 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc02023c8:	000bed97          	auipc	s11,0xbe
ffffffffc02023cc:	778d8d93          	addi	s11,s11,1912 # ffffffffc02c0b40 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02023d0:	c0000437          	lui	s0,0xc0000
ffffffffc02023d4:	944e                	add	s0,s0,s3
ffffffffc02023d6:	8079                	srli	s0,s0,0x1e
ffffffffc02023d8:	1ff47413          	andi	s0,s0,511
ffffffffc02023dc:	040e                	slli	s0,s0,0x3
ffffffffc02023de:	9462                	add	s0,s0,s8
ffffffffc02023e0:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_proc_suite_out_size+0xffffffffbfff4688>
        if (pde1 & PTE_V)
ffffffffc02023e4:	001a7793          	andi	a5,s4,1
ffffffffc02023e8:	eb99                	bnez	a5,ffffffffc02023fe <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02023ea:	12098463          	beqz	s3,ffffffffc0202512 <exit_range+0x1b4>
ffffffffc02023ee:	400007b7          	lui	a5,0x40000
ffffffffc02023f2:	97ce                	add	a5,a5,s3
ffffffffc02023f4:	894e                	mv	s2,s3
ffffffffc02023f6:	1159fe63          	bgeu	s3,s5,ffffffffc0202512 <exit_range+0x1b4>
ffffffffc02023fa:	89be                	mv	s3,a5
ffffffffc02023fc:	bfd1                	j	ffffffffc02023d0 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023fe:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202402:	0a0a                	slli	s4,s4,0x2
ffffffffc0202404:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202408:	1cfa7263          	bgeu	s4,a5,ffffffffc02025cc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020240c:	fff80637          	lui	a2,0xfff80
ffffffffc0202410:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202412:	000806b7          	lui	a3,0x80
ffffffffc0202416:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202418:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020241c:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020241e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202420:	18f5fa63          	bgeu	a1,a5,ffffffffc02025b4 <exit_range+0x256>
ffffffffc0202424:	000be817          	auipc	a6,0xbe
ffffffffc0202428:	72480813          	addi	a6,a6,1828 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc020242c:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202430:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202432:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202436:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202438:	00080337          	lui	t1,0x80
ffffffffc020243c:	6885                	lui	a7,0x1
ffffffffc020243e:	a819                	j	ffffffffc0202454 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202440:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202442:	002007b7          	lui	a5,0x200
ffffffffc0202446:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202448:	08090c63          	beqz	s2,ffffffffc02024e0 <exit_range+0x182>
ffffffffc020244c:	09397a63          	bgeu	s2,s3,ffffffffc02024e0 <exit_range+0x182>
ffffffffc0202450:	0f597063          	bgeu	s2,s5,ffffffffc0202530 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202454:	01595493          	srli	s1,s2,0x15
ffffffffc0202458:	1ff4f493          	andi	s1,s1,511
ffffffffc020245c:	048e                	slli	s1,s1,0x3
ffffffffc020245e:	94da                	add	s1,s1,s6
ffffffffc0202460:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202462:	0017f693          	andi	a3,a5,1
ffffffffc0202466:	dee9                	beqz	a3,ffffffffc0202440 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0202468:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020246c:	078a                	slli	a5,a5,0x2
ffffffffc020246e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202470:	14b7fe63          	bgeu	a5,a1,ffffffffc02025cc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202474:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0202476:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020247a:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020247e:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202482:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202484:	12bef863          	bgeu	t4,a1,ffffffffc02025b4 <exit_range+0x256>
ffffffffc0202488:	00083783          	ld	a5,0(a6)
ffffffffc020248c:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020248e:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202492:	629c                	ld	a5,0(a3)
ffffffffc0202494:	8b85                	andi	a5,a5,1
ffffffffc0202496:	f7d5                	bnez	a5,ffffffffc0202442 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202498:	06a1                	addi	a3,a3,8
ffffffffc020249a:	fed59ce3          	bne	a1,a3,ffffffffc0202492 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc020249e:	631c                	ld	a5,0(a4)
ffffffffc02024a0:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024a2:	100027f3          	csrr	a5,sstatus
ffffffffc02024a6:	8b89                	andi	a5,a5,2
ffffffffc02024a8:	e7d9                	bnez	a5,ffffffffc0202536 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc02024aa:	000db783          	ld	a5,0(s11)
ffffffffc02024ae:	4585                	li	a1,1
ffffffffc02024b0:	e032                	sd	a2,0(sp)
ffffffffc02024b2:	739c                	ld	a5,32(a5)
ffffffffc02024b4:	9782                	jalr	a5
    if (flag)
ffffffffc02024b6:	6602                	ld	a2,0(sp)
ffffffffc02024b8:	000be817          	auipc	a6,0xbe
ffffffffc02024bc:	69080813          	addi	a6,a6,1680 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc02024c0:	fff80e37          	lui	t3,0xfff80
ffffffffc02024c4:	00080337          	lui	t1,0x80
ffffffffc02024c8:	6885                	lui	a7,0x1
ffffffffc02024ca:	000be717          	auipc	a4,0xbe
ffffffffc02024ce:	66e70713          	addi	a4,a4,1646 # ffffffffc02c0b38 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02024d2:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc02024d6:	002007b7          	lui	a5,0x200
ffffffffc02024da:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02024dc:	f60918e3          	bnez	s2,ffffffffc020244c <exit_range+0xee>
            if (free_pd0)
ffffffffc02024e0:	f00b85e3          	beqz	s7,ffffffffc02023ea <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02024e4:	000d3783          	ld	a5,0(s10)
ffffffffc02024e8:	0efa7263          	bgeu	s4,a5,ffffffffc02025cc <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ec:	6308                	ld	a0,0(a4)
ffffffffc02024ee:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024f0:	100027f3          	csrr	a5,sstatus
ffffffffc02024f4:	8b89                	andi	a5,a5,2
ffffffffc02024f6:	efad                	bnez	a5,ffffffffc0202570 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02024f8:	000db783          	ld	a5,0(s11)
ffffffffc02024fc:	4585                	li	a1,1
ffffffffc02024fe:	739c                	ld	a5,32(a5)
ffffffffc0202500:	9782                	jalr	a5
ffffffffc0202502:	000be717          	auipc	a4,0xbe
ffffffffc0202506:	63670713          	addi	a4,a4,1590 # ffffffffc02c0b38 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020250a:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc020250e:	ee0990e3          	bnez	s3,ffffffffc02023ee <exit_range+0x90>
}
ffffffffc0202512:	70e6                	ld	ra,120(sp)
ffffffffc0202514:	7446                	ld	s0,112(sp)
ffffffffc0202516:	74a6                	ld	s1,104(sp)
ffffffffc0202518:	7906                	ld	s2,96(sp)
ffffffffc020251a:	69e6                	ld	s3,88(sp)
ffffffffc020251c:	6a46                	ld	s4,80(sp)
ffffffffc020251e:	6aa6                	ld	s5,72(sp)
ffffffffc0202520:	6b06                	ld	s6,64(sp)
ffffffffc0202522:	7be2                	ld	s7,56(sp)
ffffffffc0202524:	7c42                	ld	s8,48(sp)
ffffffffc0202526:	7ca2                	ld	s9,40(sp)
ffffffffc0202528:	7d02                	ld	s10,32(sp)
ffffffffc020252a:	6de2                	ld	s11,24(sp)
ffffffffc020252c:	6109                	addi	sp,sp,128
ffffffffc020252e:	8082                	ret
            if (free_pd0)
ffffffffc0202530:	ea0b8fe3          	beqz	s7,ffffffffc02023ee <exit_range+0x90>
ffffffffc0202534:	bf45                	j	ffffffffc02024e4 <exit_range+0x186>
ffffffffc0202536:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202538:	e42a                	sd	a0,8(sp)
ffffffffc020253a:	c7afe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020253e:	000db783          	ld	a5,0(s11)
ffffffffc0202542:	6522                	ld	a0,8(sp)
ffffffffc0202544:	4585                	li	a1,1
ffffffffc0202546:	739c                	ld	a5,32(a5)
ffffffffc0202548:	9782                	jalr	a5
        intr_enable();
ffffffffc020254a:	c64fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020254e:	6602                	ld	a2,0(sp)
ffffffffc0202550:	000be717          	auipc	a4,0xbe
ffffffffc0202554:	5e870713          	addi	a4,a4,1512 # ffffffffc02c0b38 <pages>
ffffffffc0202558:	6885                	lui	a7,0x1
ffffffffc020255a:	00080337          	lui	t1,0x80
ffffffffc020255e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202562:	000be817          	auipc	a6,0xbe
ffffffffc0202566:	5e680813          	addi	a6,a6,1510 # ffffffffc02c0b48 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020256a:	0004b023          	sd	zero,0(s1)
ffffffffc020256e:	b7a5                	j	ffffffffc02024d6 <exit_range+0x178>
ffffffffc0202570:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202572:	c42fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202576:	000db783          	ld	a5,0(s11)
ffffffffc020257a:	6502                	ld	a0,0(sp)
ffffffffc020257c:	4585                	li	a1,1
ffffffffc020257e:	739c                	ld	a5,32(a5)
ffffffffc0202580:	9782                	jalr	a5
        intr_enable();
ffffffffc0202582:	c2cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202586:	000be717          	auipc	a4,0xbe
ffffffffc020258a:	5b270713          	addi	a4,a4,1458 # ffffffffc02c0b38 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020258e:	00043023          	sd	zero,0(s0)
ffffffffc0202592:	bfb5                	j	ffffffffc020250e <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202594:	00004697          	auipc	a3,0x4
ffffffffc0202598:	38468693          	addi	a3,a3,900 # ffffffffc0206918 <default_pmm_manager+0x160>
ffffffffc020259c:	00004617          	auipc	a2,0x4
ffffffffc02025a0:	e6c60613          	addi	a2,a2,-404 # ffffffffc0206408 <commands+0x828>
ffffffffc02025a4:	13600593          	li	a1,310
ffffffffc02025a8:	00004517          	auipc	a0,0x4
ffffffffc02025ac:	36050513          	addi	a0,a0,864 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02025b0:	edffd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02025b4:	00004617          	auipc	a2,0x4
ffffffffc02025b8:	23c60613          	addi	a2,a2,572 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc02025bc:	07100593          	li	a1,113
ffffffffc02025c0:	00004517          	auipc	a0,0x4
ffffffffc02025c4:	25850513          	addi	a0,a0,600 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02025c8:	ec7fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02025cc:	8e1ff0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02025d0:	00004697          	auipc	a3,0x4
ffffffffc02025d4:	37868693          	addi	a3,a3,888 # ffffffffc0206948 <default_pmm_manager+0x190>
ffffffffc02025d8:	00004617          	auipc	a2,0x4
ffffffffc02025dc:	e3060613          	addi	a2,a2,-464 # ffffffffc0206408 <commands+0x828>
ffffffffc02025e0:	13700593          	li	a1,311
ffffffffc02025e4:	00004517          	auipc	a0,0x4
ffffffffc02025e8:	32450513          	addi	a0,a0,804 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02025ec:	ea3fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02025f0 <page_remove>:
{
ffffffffc02025f0:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025f2:	4601                	li	a2,0
{
ffffffffc02025f4:	ec26                	sd	s1,24(sp)
ffffffffc02025f6:	f406                	sd	ra,40(sp)
ffffffffc02025f8:	f022                	sd	s0,32(sp)
ffffffffc02025fa:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025fc:	9a1ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
    if (ptep != NULL)
ffffffffc0202600:	c511                	beqz	a0,ffffffffc020260c <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202602:	611c                	ld	a5,0(a0)
ffffffffc0202604:	842a                	mv	s0,a0
ffffffffc0202606:	0017f713          	andi	a4,a5,1
ffffffffc020260a:	e711                	bnez	a4,ffffffffc0202616 <page_remove+0x26>
}
ffffffffc020260c:	70a2                	ld	ra,40(sp)
ffffffffc020260e:	7402                	ld	s0,32(sp)
ffffffffc0202610:	64e2                	ld	s1,24(sp)
ffffffffc0202612:	6145                	addi	sp,sp,48
ffffffffc0202614:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202616:	078a                	slli	a5,a5,0x2
ffffffffc0202618:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020261a:	000be717          	auipc	a4,0xbe
ffffffffc020261e:	51673703          	ld	a4,1302(a4) # ffffffffc02c0b30 <npage>
ffffffffc0202622:	06e7f363          	bgeu	a5,a4,ffffffffc0202688 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202626:	fff80537          	lui	a0,0xfff80
ffffffffc020262a:	97aa                	add	a5,a5,a0
ffffffffc020262c:	079a                	slli	a5,a5,0x6
ffffffffc020262e:	000be517          	auipc	a0,0xbe
ffffffffc0202632:	50a53503          	ld	a0,1290(a0) # ffffffffc02c0b38 <pages>
ffffffffc0202636:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202638:	411c                	lw	a5,0(a0)
ffffffffc020263a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020263e:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202640:	cb11                	beqz	a4,ffffffffc0202654 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202642:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202646:	12048073          	sfence.vma	s1
}
ffffffffc020264a:	70a2                	ld	ra,40(sp)
ffffffffc020264c:	7402                	ld	s0,32(sp)
ffffffffc020264e:	64e2                	ld	s1,24(sp)
ffffffffc0202650:	6145                	addi	sp,sp,48
ffffffffc0202652:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202654:	100027f3          	csrr	a5,sstatus
ffffffffc0202658:	8b89                	andi	a5,a5,2
ffffffffc020265a:	eb89                	bnez	a5,ffffffffc020266c <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020265c:	000be797          	auipc	a5,0xbe
ffffffffc0202660:	4e47b783          	ld	a5,1252(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202664:	739c                	ld	a5,32(a5)
ffffffffc0202666:	4585                	li	a1,1
ffffffffc0202668:	9782                	jalr	a5
    if (flag)
ffffffffc020266a:	bfe1                	j	ffffffffc0202642 <page_remove+0x52>
        intr_disable();
ffffffffc020266c:	e42a                	sd	a0,8(sp)
ffffffffc020266e:	b46fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202672:	000be797          	auipc	a5,0xbe
ffffffffc0202676:	4ce7b783          	ld	a5,1230(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc020267a:	739c                	ld	a5,32(a5)
ffffffffc020267c:	6522                	ld	a0,8(sp)
ffffffffc020267e:	4585                	li	a1,1
ffffffffc0202680:	9782                	jalr	a5
        intr_enable();
ffffffffc0202682:	b2cfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202686:	bf75                	j	ffffffffc0202642 <page_remove+0x52>
ffffffffc0202688:	825ff0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>

ffffffffc020268c <page_insert>:
{
ffffffffc020268c:	7139                	addi	sp,sp,-64
ffffffffc020268e:	e852                	sd	s4,16(sp)
ffffffffc0202690:	8a32                	mv	s4,a2
ffffffffc0202692:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202694:	4605                	li	a2,1
{
ffffffffc0202696:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202698:	85d2                	mv	a1,s4
{
ffffffffc020269a:	f426                	sd	s1,40(sp)
ffffffffc020269c:	fc06                	sd	ra,56(sp)
ffffffffc020269e:	f04a                	sd	s2,32(sp)
ffffffffc02026a0:	ec4e                	sd	s3,24(sp)
ffffffffc02026a2:	e456                	sd	s5,8(sp)
ffffffffc02026a4:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026a6:	8f7ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
    if (ptep == NULL)
ffffffffc02026aa:	c961                	beqz	a0,ffffffffc020277a <page_insert+0xee>
    page->ref += 1;
ffffffffc02026ac:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02026ae:	611c                	ld	a5,0(a0)
ffffffffc02026b0:	89aa                	mv	s3,a0
ffffffffc02026b2:	0016871b          	addiw	a4,a3,1
ffffffffc02026b6:	c018                	sw	a4,0(s0)
ffffffffc02026b8:	0017f713          	andi	a4,a5,1
ffffffffc02026bc:	ef05                	bnez	a4,ffffffffc02026f4 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc02026be:	000be717          	auipc	a4,0xbe
ffffffffc02026c2:	47a73703          	ld	a4,1146(a4) # ffffffffc02c0b38 <pages>
ffffffffc02026c6:	8c19                	sub	s0,s0,a4
ffffffffc02026c8:	000807b7          	lui	a5,0x80
ffffffffc02026cc:	8419                	srai	s0,s0,0x6
ffffffffc02026ce:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02026d0:	042a                	slli	s0,s0,0xa
ffffffffc02026d2:	8cc1                	or	s1,s1,s0
ffffffffc02026d4:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02026d8:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_proc_suite_out_size+0xffffffffbfff4688>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026dc:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02026e0:	4501                	li	a0,0
}
ffffffffc02026e2:	70e2                	ld	ra,56(sp)
ffffffffc02026e4:	7442                	ld	s0,48(sp)
ffffffffc02026e6:	74a2                	ld	s1,40(sp)
ffffffffc02026e8:	7902                	ld	s2,32(sp)
ffffffffc02026ea:	69e2                	ld	s3,24(sp)
ffffffffc02026ec:	6a42                	ld	s4,16(sp)
ffffffffc02026ee:	6aa2                	ld	s5,8(sp)
ffffffffc02026f0:	6121                	addi	sp,sp,64
ffffffffc02026f2:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02026f4:	078a                	slli	a5,a5,0x2
ffffffffc02026f6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026f8:	000be717          	auipc	a4,0xbe
ffffffffc02026fc:	43873703          	ld	a4,1080(a4) # ffffffffc02c0b30 <npage>
ffffffffc0202700:	06e7ff63          	bgeu	a5,a4,ffffffffc020277e <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202704:	000bea97          	auipc	s5,0xbe
ffffffffc0202708:	434a8a93          	addi	s5,s5,1076 # ffffffffc02c0b38 <pages>
ffffffffc020270c:	000ab703          	ld	a4,0(s5)
ffffffffc0202710:	fff80937          	lui	s2,0xfff80
ffffffffc0202714:	993e                	add	s2,s2,a5
ffffffffc0202716:	091a                	slli	s2,s2,0x6
ffffffffc0202718:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020271a:	01240c63          	beq	s0,s2,ffffffffc0202732 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020271e:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcbf48c>
ffffffffc0202722:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202726:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020272a:	c691                	beqz	a3,ffffffffc0202736 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020272c:	120a0073          	sfence.vma	s4
}
ffffffffc0202730:	bf59                	j	ffffffffc02026c6 <page_insert+0x3a>
ffffffffc0202732:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202734:	bf49                	j	ffffffffc02026c6 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202736:	100027f3          	csrr	a5,sstatus
ffffffffc020273a:	8b89                	andi	a5,a5,2
ffffffffc020273c:	ef91                	bnez	a5,ffffffffc0202758 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020273e:	000be797          	auipc	a5,0xbe
ffffffffc0202742:	4027b783          	ld	a5,1026(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202746:	739c                	ld	a5,32(a5)
ffffffffc0202748:	4585                	li	a1,1
ffffffffc020274a:	854a                	mv	a0,s2
ffffffffc020274c:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020274e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202752:	120a0073          	sfence.vma	s4
ffffffffc0202756:	bf85                	j	ffffffffc02026c6 <page_insert+0x3a>
        intr_disable();
ffffffffc0202758:	a5cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020275c:	000be797          	auipc	a5,0xbe
ffffffffc0202760:	3e47b783          	ld	a5,996(a5) # ffffffffc02c0b40 <pmm_manager>
ffffffffc0202764:	739c                	ld	a5,32(a5)
ffffffffc0202766:	4585                	li	a1,1
ffffffffc0202768:	854a                	mv	a0,s2
ffffffffc020276a:	9782                	jalr	a5
        intr_enable();
ffffffffc020276c:	a42fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202770:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202774:	120a0073          	sfence.vma	s4
ffffffffc0202778:	b7b9                	j	ffffffffc02026c6 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020277a:	5571                	li	a0,-4
ffffffffc020277c:	b79d                	j	ffffffffc02026e2 <page_insert+0x56>
ffffffffc020277e:	f2eff0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>

ffffffffc0202782 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202782:	00004797          	auipc	a5,0x4
ffffffffc0202786:	03678793          	addi	a5,a5,54 # ffffffffc02067b8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020278a:	638c                	ld	a1,0(a5)
{
ffffffffc020278c:	7159                	addi	sp,sp,-112
ffffffffc020278e:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202790:	00004517          	auipc	a0,0x4
ffffffffc0202794:	1d050513          	addi	a0,a0,464 # ffffffffc0206960 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc0202798:	000beb17          	auipc	s6,0xbe
ffffffffc020279c:	3a8b0b13          	addi	s6,s6,936 # ffffffffc02c0b40 <pmm_manager>
{
ffffffffc02027a0:	f486                	sd	ra,104(sp)
ffffffffc02027a2:	e8ca                	sd	s2,80(sp)
ffffffffc02027a4:	e4ce                	sd	s3,72(sp)
ffffffffc02027a6:	f0a2                	sd	s0,96(sp)
ffffffffc02027a8:	eca6                	sd	s1,88(sp)
ffffffffc02027aa:	e0d2                	sd	s4,64(sp)
ffffffffc02027ac:	fc56                	sd	s5,56(sp)
ffffffffc02027ae:	f45e                	sd	s7,40(sp)
ffffffffc02027b0:	f062                	sd	s8,32(sp)
ffffffffc02027b2:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02027b4:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027b8:	9ddfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02027bc:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027c0:	000be997          	auipc	s3,0xbe
ffffffffc02027c4:	38898993          	addi	s3,s3,904 # ffffffffc02c0b48 <va_pa_offset>
    pmm_manager->init();
ffffffffc02027c8:	679c                	ld	a5,8(a5)
ffffffffc02027ca:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02027cc:	57f5                	li	a5,-3
ffffffffc02027ce:	07fa                	slli	a5,a5,0x1e
ffffffffc02027d0:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02027d4:	9c6fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc02027d8:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02027da:	9cafe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc02027de:	200505e3          	beqz	a0,ffffffffc02031e8 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027e2:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02027e4:	00004517          	auipc	a0,0x4
ffffffffc02027e8:	1b450513          	addi	a0,a0,436 # ffffffffc0206998 <default_pmm_manager+0x1e0>
ffffffffc02027ec:	9a9fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027f0:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02027f4:	fff40693          	addi	a3,s0,-1
ffffffffc02027f8:	864a                	mv	a2,s2
ffffffffc02027fa:	85a6                	mv	a1,s1
ffffffffc02027fc:	00004517          	auipc	a0,0x4
ffffffffc0202800:	1b450513          	addi	a0,a0,436 # ffffffffc02069b0 <default_pmm_manager+0x1f8>
ffffffffc0202804:	991fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202808:	c8000737          	lui	a4,0xc8000
ffffffffc020280c:	87a2                	mv	a5,s0
ffffffffc020280e:	54876163          	bltu	a4,s0,ffffffffc0202d50 <pmm_init+0x5ce>
ffffffffc0202812:	757d                	lui	a0,0xfffff
ffffffffc0202814:	000bf617          	auipc	a2,0xbf
ffffffffc0202818:	35f60613          	addi	a2,a2,863 # ffffffffc02c1b73 <end+0xfff>
ffffffffc020281c:	8e69                	and	a2,a2,a0
ffffffffc020281e:	000be497          	auipc	s1,0xbe
ffffffffc0202822:	31248493          	addi	s1,s1,786 # ffffffffc02c0b30 <npage>
ffffffffc0202826:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020282a:	000beb97          	auipc	s7,0xbe
ffffffffc020282e:	30eb8b93          	addi	s7,s7,782 # ffffffffc02c0b38 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202832:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202834:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202838:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020283c:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020283e:	02f50863          	beq	a0,a5,ffffffffc020286e <pmm_init+0xec>
ffffffffc0202842:	4781                	li	a5,0
ffffffffc0202844:	4585                	li	a1,1
ffffffffc0202846:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020284a:	00679513          	slli	a0,a5,0x6
ffffffffc020284e:	9532                	add	a0,a0,a2
ffffffffc0202850:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd3e494>
ffffffffc0202854:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202858:	6088                	ld	a0,0(s1)
ffffffffc020285a:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc020285c:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202860:	00d50733          	add	a4,a0,a3
ffffffffc0202864:	fee7e3e3          	bltu	a5,a4,ffffffffc020284a <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202868:	071a                	slli	a4,a4,0x6
ffffffffc020286a:	00e606b3          	add	a3,a2,a4
ffffffffc020286e:	c02007b7          	lui	a5,0xc0200
ffffffffc0202872:	2ef6ece3          	bltu	a3,a5,ffffffffc020336a <pmm_init+0xbe8>
ffffffffc0202876:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020287a:	77fd                	lui	a5,0xfffff
ffffffffc020287c:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020287e:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202880:	5086eb63          	bltu	a3,s0,ffffffffc0202d96 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202884:	00004517          	auipc	a0,0x4
ffffffffc0202888:	15450513          	addi	a0,a0,340 # ffffffffc02069d8 <default_pmm_manager+0x220>
ffffffffc020288c:	909fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202890:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202894:	000be917          	auipc	s2,0xbe
ffffffffc0202898:	29490913          	addi	s2,s2,660 # ffffffffc02c0b28 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc020289c:	7b9c                	ld	a5,48(a5)
ffffffffc020289e:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02028a0:	00004517          	auipc	a0,0x4
ffffffffc02028a4:	15050513          	addi	a0,a0,336 # ffffffffc02069f0 <default_pmm_manager+0x238>
ffffffffc02028a8:	8edfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028ac:	00007697          	auipc	a3,0x7
ffffffffc02028b0:	75468693          	addi	a3,a3,1876 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc02028b4:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02028b8:	c02007b7          	lui	a5,0xc0200
ffffffffc02028bc:	28f6ebe3          	bltu	a3,a5,ffffffffc0203352 <pmm_init+0xbd0>
ffffffffc02028c0:	0009b783          	ld	a5,0(s3)
ffffffffc02028c4:	8e9d                	sub	a3,a3,a5
ffffffffc02028c6:	000be797          	auipc	a5,0xbe
ffffffffc02028ca:	24d7bd23          	sd	a3,602(a5) # ffffffffc02c0b20 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02028ce:	100027f3          	csrr	a5,sstatus
ffffffffc02028d2:	8b89                	andi	a5,a5,2
ffffffffc02028d4:	4a079763          	bnez	a5,ffffffffc0202d82 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02028d8:	000b3783          	ld	a5,0(s6)
ffffffffc02028dc:	779c                	ld	a5,40(a5)
ffffffffc02028de:	9782                	jalr	a5
ffffffffc02028e0:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02028e2:	6098                	ld	a4,0(s1)
ffffffffc02028e4:	c80007b7          	lui	a5,0xc8000
ffffffffc02028e8:	83b1                	srli	a5,a5,0xc
ffffffffc02028ea:	66e7e363          	bltu	a5,a4,ffffffffc0202f50 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028ee:	00093503          	ld	a0,0(s2)
ffffffffc02028f2:	62050f63          	beqz	a0,ffffffffc0202f30 <pmm_init+0x7ae>
ffffffffc02028f6:	03451793          	slli	a5,a0,0x34
ffffffffc02028fa:	62079b63          	bnez	a5,ffffffffc0202f30 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028fe:	4601                	li	a2,0
ffffffffc0202900:	4581                	li	a1,0
ffffffffc0202902:	8c3ff0ef          	jal	ra,ffffffffc02021c4 <get_page>
ffffffffc0202906:	60051563          	bnez	a0,ffffffffc0202f10 <pmm_init+0x78e>
ffffffffc020290a:	100027f3          	csrr	a5,sstatus
ffffffffc020290e:	8b89                	andi	a5,a5,2
ffffffffc0202910:	44079e63          	bnez	a5,ffffffffc0202d6c <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202914:	000b3783          	ld	a5,0(s6)
ffffffffc0202918:	4505                	li	a0,1
ffffffffc020291a:	6f9c                	ld	a5,24(a5)
ffffffffc020291c:	9782                	jalr	a5
ffffffffc020291e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202920:	00093503          	ld	a0,0(s2)
ffffffffc0202924:	4681                	li	a3,0
ffffffffc0202926:	4601                	li	a2,0
ffffffffc0202928:	85d2                	mv	a1,s4
ffffffffc020292a:	d63ff0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc020292e:	26051ae3          	bnez	a0,ffffffffc02033a2 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202932:	00093503          	ld	a0,0(s2)
ffffffffc0202936:	4601                	li	a2,0
ffffffffc0202938:	4581                	li	a1,0
ffffffffc020293a:	e62ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc020293e:	240502e3          	beqz	a0,ffffffffc0203382 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202942:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202944:	0017f713          	andi	a4,a5,1
ffffffffc0202948:	5a070263          	beqz	a4,ffffffffc0202eec <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020294c:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020294e:	078a                	slli	a5,a5,0x2
ffffffffc0202950:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202952:	58e7fb63          	bgeu	a5,a4,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202956:	000bb683          	ld	a3,0(s7)
ffffffffc020295a:	fff80637          	lui	a2,0xfff80
ffffffffc020295e:	97b2                	add	a5,a5,a2
ffffffffc0202960:	079a                	slli	a5,a5,0x6
ffffffffc0202962:	97b6                	add	a5,a5,a3
ffffffffc0202964:	14fa17e3          	bne	s4,a5,ffffffffc02032b2 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202968:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc020296c:	4785                	li	a5,1
ffffffffc020296e:	12f692e3          	bne	a3,a5,ffffffffc0203292 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202972:	00093503          	ld	a0,0(s2)
ffffffffc0202976:	77fd                	lui	a5,0xfffff
ffffffffc0202978:	6114                	ld	a3,0(a0)
ffffffffc020297a:	068a                	slli	a3,a3,0x2
ffffffffc020297c:	8efd                	and	a3,a3,a5
ffffffffc020297e:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202982:	0ee67ce3          	bgeu	a2,a4,ffffffffc020327a <pmm_init+0xaf8>
ffffffffc0202986:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020298a:	96e2                	add	a3,a3,s8
ffffffffc020298c:	0006ba83          	ld	s5,0(a3)
ffffffffc0202990:	0a8a                	slli	s5,s5,0x2
ffffffffc0202992:	00fafab3          	and	s5,s5,a5
ffffffffc0202996:	00cad793          	srli	a5,s5,0xc
ffffffffc020299a:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203260 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020299e:	4601                	li	a2,0
ffffffffc02029a0:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029a2:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029a4:	df8ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029a8:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029aa:	55551363          	bne	a0,s5,ffffffffc0202ef0 <pmm_init+0x76e>
ffffffffc02029ae:	100027f3          	csrr	a5,sstatus
ffffffffc02029b2:	8b89                	andi	a5,a5,2
ffffffffc02029b4:	3a079163          	bnez	a5,ffffffffc0202d56 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc02029b8:	000b3783          	ld	a5,0(s6)
ffffffffc02029bc:	4505                	li	a0,1
ffffffffc02029be:	6f9c                	ld	a5,24(a5)
ffffffffc02029c0:	9782                	jalr	a5
ffffffffc02029c2:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02029c4:	00093503          	ld	a0,0(s2)
ffffffffc02029c8:	46d1                	li	a3,20
ffffffffc02029ca:	6605                	lui	a2,0x1
ffffffffc02029cc:	85e2                	mv	a1,s8
ffffffffc02029ce:	cbfff0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc02029d2:	060517e3          	bnez	a0,ffffffffc0203240 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029d6:	00093503          	ld	a0,0(s2)
ffffffffc02029da:	4601                	li	a2,0
ffffffffc02029dc:	6585                	lui	a1,0x1
ffffffffc02029de:	dbeff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc02029e2:	02050fe3          	beqz	a0,ffffffffc0203220 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02029e6:	611c                	ld	a5,0(a0)
ffffffffc02029e8:	0107f713          	andi	a4,a5,16
ffffffffc02029ec:	7c070e63          	beqz	a4,ffffffffc02031c8 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02029f0:	8b91                	andi	a5,a5,4
ffffffffc02029f2:	7a078b63          	beqz	a5,ffffffffc02031a8 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02029f6:	00093503          	ld	a0,0(s2)
ffffffffc02029fa:	611c                	ld	a5,0(a0)
ffffffffc02029fc:	8bc1                	andi	a5,a5,16
ffffffffc02029fe:	78078563          	beqz	a5,ffffffffc0203188 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202a02:	000c2703          	lw	a4,0(s8)
ffffffffc0202a06:	4785                	li	a5,1
ffffffffc0202a08:	76f71063          	bne	a4,a5,ffffffffc0203168 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a0c:	4681                	li	a3,0
ffffffffc0202a0e:	6605                	lui	a2,0x1
ffffffffc0202a10:	85d2                	mv	a1,s4
ffffffffc0202a12:	c7bff0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc0202a16:	72051963          	bnez	a0,ffffffffc0203148 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202a1a:	000a2703          	lw	a4,0(s4)
ffffffffc0202a1e:	4789                	li	a5,2
ffffffffc0202a20:	70f71463          	bne	a4,a5,ffffffffc0203128 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202a24:	000c2783          	lw	a5,0(s8)
ffffffffc0202a28:	6e079063          	bnez	a5,ffffffffc0203108 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a2c:	00093503          	ld	a0,0(s2)
ffffffffc0202a30:	4601                	li	a2,0
ffffffffc0202a32:	6585                	lui	a1,0x1
ffffffffc0202a34:	d68ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc0202a38:	6a050863          	beqz	a0,ffffffffc02030e8 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a3c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a3e:	00177793          	andi	a5,a4,1
ffffffffc0202a42:	4a078563          	beqz	a5,ffffffffc0202eec <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202a46:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a48:	00271793          	slli	a5,a4,0x2
ffffffffc0202a4c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a4e:	48d7fd63          	bgeu	a5,a3,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a52:	000bb683          	ld	a3,0(s7)
ffffffffc0202a56:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a5a:	97d6                	add	a5,a5,s5
ffffffffc0202a5c:	079a                	slli	a5,a5,0x6
ffffffffc0202a5e:	97b6                	add	a5,a5,a3
ffffffffc0202a60:	66fa1463          	bne	s4,a5,ffffffffc02030c8 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a64:	8b41                	andi	a4,a4,16
ffffffffc0202a66:	64071163          	bnez	a4,ffffffffc02030a8 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a6a:	00093503          	ld	a0,0(s2)
ffffffffc0202a6e:	4581                	li	a1,0
ffffffffc0202a70:	b81ff0ef          	jal	ra,ffffffffc02025f0 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a74:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a78:	4785                	li	a5,1
ffffffffc0202a7a:	60fc9763          	bne	s9,a5,ffffffffc0203088 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a7e:	000c2783          	lw	a5,0(s8)
ffffffffc0202a82:	5e079363          	bnez	a5,ffffffffc0203068 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a86:	00093503          	ld	a0,0(s2)
ffffffffc0202a8a:	6585                	lui	a1,0x1
ffffffffc0202a8c:	b65ff0ef          	jal	ra,ffffffffc02025f0 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a90:	000a2783          	lw	a5,0(s4)
ffffffffc0202a94:	52079a63          	bnez	a5,ffffffffc0202fc8 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a98:	000c2783          	lw	a5,0(s8)
ffffffffc0202a9c:	50079663          	bnez	a5,ffffffffc0202fa8 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202aa0:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202aa4:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202aa6:	000a3683          	ld	a3,0(s4)
ffffffffc0202aaa:	068a                	slli	a3,a3,0x2
ffffffffc0202aac:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202aae:	42b6fd63          	bgeu	a3,a1,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ab2:	000bb503          	ld	a0,0(s7)
ffffffffc0202ab6:	96d6                	add	a3,a3,s5
ffffffffc0202ab8:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202aba:	00d507b3          	add	a5,a0,a3
ffffffffc0202abe:	439c                	lw	a5,0(a5)
ffffffffc0202ac0:	4d979463          	bne	a5,s9,ffffffffc0202f88 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202ac4:	8699                	srai	a3,a3,0x6
ffffffffc0202ac6:	00080637          	lui	a2,0x80
ffffffffc0202aca:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202acc:	00c69713          	slli	a4,a3,0xc
ffffffffc0202ad0:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ad2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ad4:	48b77e63          	bgeu	a4,a1,ffffffffc0202f70 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202ad8:	0009b703          	ld	a4,0(s3)
ffffffffc0202adc:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ade:	629c                	ld	a5,0(a3)
ffffffffc0202ae0:	078a                	slli	a5,a5,0x2
ffffffffc0202ae2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ae4:	40b7f263          	bgeu	a5,a1,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ae8:	8f91                	sub	a5,a5,a2
ffffffffc0202aea:	079a                	slli	a5,a5,0x6
ffffffffc0202aec:	953e                	add	a0,a0,a5
ffffffffc0202aee:	100027f3          	csrr	a5,sstatus
ffffffffc0202af2:	8b89                	andi	a5,a5,2
ffffffffc0202af4:	30079963          	bnez	a5,ffffffffc0202e06 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202af8:	000b3783          	ld	a5,0(s6)
ffffffffc0202afc:	4585                	li	a1,1
ffffffffc0202afe:	739c                	ld	a5,32(a5)
ffffffffc0202b00:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b02:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b06:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b08:	078a                	slli	a5,a5,0x2
ffffffffc0202b0a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b0c:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b10:	000bb503          	ld	a0,0(s7)
ffffffffc0202b14:	fff80737          	lui	a4,0xfff80
ffffffffc0202b18:	97ba                	add	a5,a5,a4
ffffffffc0202b1a:	079a                	slli	a5,a5,0x6
ffffffffc0202b1c:	953e                	add	a0,a0,a5
ffffffffc0202b1e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b22:	8b89                	andi	a5,a5,2
ffffffffc0202b24:	2c079563          	bnez	a5,ffffffffc0202dee <pmm_init+0x66c>
ffffffffc0202b28:	000b3783          	ld	a5,0(s6)
ffffffffc0202b2c:	4585                	li	a1,1
ffffffffc0202b2e:	739c                	ld	a5,32(a5)
ffffffffc0202b30:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b32:	00093783          	ld	a5,0(s2)
ffffffffc0202b36:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd3e48c>
    asm volatile("sfence.vma");
ffffffffc0202b3a:	12000073          	sfence.vma
ffffffffc0202b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b42:	8b89                	andi	a5,a5,2
ffffffffc0202b44:	28079b63          	bnez	a5,ffffffffc0202dda <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b48:	000b3783          	ld	a5,0(s6)
ffffffffc0202b4c:	779c                	ld	a5,40(a5)
ffffffffc0202b4e:	9782                	jalr	a5
ffffffffc0202b50:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b52:	4b441b63          	bne	s0,s4,ffffffffc0203008 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b56:	00004517          	auipc	a0,0x4
ffffffffc0202b5a:	1c250513          	addi	a0,a0,450 # ffffffffc0206d18 <default_pmm_manager+0x560>
ffffffffc0202b5e:	e36fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b62:	100027f3          	csrr	a5,sstatus
ffffffffc0202b66:	8b89                	andi	a5,a5,2
ffffffffc0202b68:	24079f63          	bnez	a5,ffffffffc0202dc6 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b6c:	000b3783          	ld	a5,0(s6)
ffffffffc0202b70:	779c                	ld	a5,40(a5)
ffffffffc0202b72:	9782                	jalr	a5
ffffffffc0202b74:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b76:	6098                	ld	a4,0(s1)
ffffffffc0202b78:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b7c:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b7e:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b82:	6a05                	lui	s4,0x1
ffffffffc0202b84:	02f47c63          	bgeu	s0,a5,ffffffffc0202bbc <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b88:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b8c:	00093503          	ld	a0,0(s2)
ffffffffc0202b90:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e8e <pmm_init+0x70c>
ffffffffc0202b94:	0009b583          	ld	a1,0(s3)
ffffffffc0202b98:	4601                	li	a2,0
ffffffffc0202b9a:	95a2                	add	a1,a1,s0
ffffffffc0202b9c:	c00ff0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc0202ba0:	32050463          	beqz	a0,ffffffffc0202ec8 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ba4:	611c                	ld	a5,0(a0)
ffffffffc0202ba6:	078a                	slli	a5,a5,0x2
ffffffffc0202ba8:	0157f7b3          	and	a5,a5,s5
ffffffffc0202bac:	2e879e63          	bne	a5,s0,ffffffffc0202ea8 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bb0:	6098                	ld	a4,0(s1)
ffffffffc0202bb2:	9452                	add	s0,s0,s4
ffffffffc0202bb4:	00c71793          	slli	a5,a4,0xc
ffffffffc0202bb8:	fcf468e3          	bltu	s0,a5,ffffffffc0202b88 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202bbc:	00093783          	ld	a5,0(s2)
ffffffffc0202bc0:	639c                	ld	a5,0(a5)
ffffffffc0202bc2:	42079363          	bnez	a5,ffffffffc0202fe8 <pmm_init+0x866>
ffffffffc0202bc6:	100027f3          	csrr	a5,sstatus
ffffffffc0202bca:	8b89                	andi	a5,a5,2
ffffffffc0202bcc:	24079963          	bnez	a5,ffffffffc0202e1e <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202bd0:	000b3783          	ld	a5,0(s6)
ffffffffc0202bd4:	4505                	li	a0,1
ffffffffc0202bd6:	6f9c                	ld	a5,24(a5)
ffffffffc0202bd8:	9782                	jalr	a5
ffffffffc0202bda:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202bdc:	00093503          	ld	a0,0(s2)
ffffffffc0202be0:	4699                	li	a3,6
ffffffffc0202be2:	10000613          	li	a2,256
ffffffffc0202be6:	85d2                	mv	a1,s4
ffffffffc0202be8:	aa5ff0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc0202bec:	44051e63          	bnez	a0,ffffffffc0203048 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202bf0:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0202bf4:	4785                	li	a5,1
ffffffffc0202bf6:	42f71963          	bne	a4,a5,ffffffffc0203028 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202bfa:	00093503          	ld	a0,0(s2)
ffffffffc0202bfe:	6405                	lui	s0,0x1
ffffffffc0202c00:	4699                	li	a3,6
ffffffffc0202c02:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab0>
ffffffffc0202c06:	85d2                	mv	a1,s4
ffffffffc0202c08:	a85ff0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc0202c0c:	72051363          	bnez	a0,ffffffffc0203332 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202c10:	000a2703          	lw	a4,0(s4)
ffffffffc0202c14:	4789                	li	a5,2
ffffffffc0202c16:	6ef71e63          	bne	a4,a5,ffffffffc0203312 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c1a:	00004597          	auipc	a1,0x4
ffffffffc0202c1e:	24658593          	addi	a1,a1,582 # ffffffffc0206e60 <default_pmm_manager+0x6a8>
ffffffffc0202c22:	10000513          	li	a0,256
ffffffffc0202c26:	4bb020ef          	jal	ra,ffffffffc02058e0 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c2a:	10040593          	addi	a1,s0,256
ffffffffc0202c2e:	10000513          	li	a0,256
ffffffffc0202c32:	4c1020ef          	jal	ra,ffffffffc02058f2 <strcmp>
ffffffffc0202c36:	6a051e63          	bnez	a0,ffffffffc02032f2 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202c3a:	000bb683          	ld	a3,0(s7)
ffffffffc0202c3e:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202c42:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202c44:	40da06b3          	sub	a3,s4,a3
ffffffffc0202c48:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202c4a:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c4c:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c4e:	8031                	srli	s0,s0,0xc
ffffffffc0202c50:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c54:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c56:	30f77d63          	bgeu	a4,a5,ffffffffc0202f70 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c5a:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c5e:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c62:	96be                	add	a3,a3,a5
ffffffffc0202c64:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c68:	443020ef          	jal	ra,ffffffffc02058aa <strlen>
ffffffffc0202c6c:	66051363          	bnez	a0,ffffffffc02032d2 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c70:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c74:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c76:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd3e48c>
ffffffffc0202c7a:	068a                	slli	a3,a3,0x2
ffffffffc0202c7c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c7e:	26f6f563          	bgeu	a3,a5,ffffffffc0202ee8 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c82:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c84:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c86:	2ef47563          	bgeu	s0,a5,ffffffffc0202f70 <pmm_init+0x7ee>
ffffffffc0202c8a:	0009b403          	ld	s0,0(s3)
ffffffffc0202c8e:	9436                	add	s0,s0,a3
ffffffffc0202c90:	100027f3          	csrr	a5,sstatus
ffffffffc0202c94:	8b89                	andi	a5,a5,2
ffffffffc0202c96:	1e079163          	bnez	a5,ffffffffc0202e78 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c9a:	000b3783          	ld	a5,0(s6)
ffffffffc0202c9e:	4585                	li	a1,1
ffffffffc0202ca0:	8552                	mv	a0,s4
ffffffffc0202ca2:	739c                	ld	a5,32(a5)
ffffffffc0202ca4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ca6:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202ca8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202caa:	078a                	slli	a5,a5,0x2
ffffffffc0202cac:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cae:	22e7fd63          	bgeu	a5,a4,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202cb2:	000bb503          	ld	a0,0(s7)
ffffffffc0202cb6:	fff80737          	lui	a4,0xfff80
ffffffffc0202cba:	97ba                	add	a5,a5,a4
ffffffffc0202cbc:	079a                	slli	a5,a5,0x6
ffffffffc0202cbe:	953e                	add	a0,a0,a5
ffffffffc0202cc0:	100027f3          	csrr	a5,sstatus
ffffffffc0202cc4:	8b89                	andi	a5,a5,2
ffffffffc0202cc6:	18079d63          	bnez	a5,ffffffffc0202e60 <pmm_init+0x6de>
ffffffffc0202cca:	000b3783          	ld	a5,0(s6)
ffffffffc0202cce:	4585                	li	a1,1
ffffffffc0202cd0:	739c                	ld	a5,32(a5)
ffffffffc0202cd2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cd4:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202cd8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cda:	078a                	slli	a5,a5,0x2
ffffffffc0202cdc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cde:	20e7f563          	bgeu	a5,a4,ffffffffc0202ee8 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ce2:	000bb503          	ld	a0,0(s7)
ffffffffc0202ce6:	fff80737          	lui	a4,0xfff80
ffffffffc0202cea:	97ba                	add	a5,a5,a4
ffffffffc0202cec:	079a                	slli	a5,a5,0x6
ffffffffc0202cee:	953e                	add	a0,a0,a5
ffffffffc0202cf0:	100027f3          	csrr	a5,sstatus
ffffffffc0202cf4:	8b89                	andi	a5,a5,2
ffffffffc0202cf6:	14079963          	bnez	a5,ffffffffc0202e48 <pmm_init+0x6c6>
ffffffffc0202cfa:	000b3783          	ld	a5,0(s6)
ffffffffc0202cfe:	4585                	li	a1,1
ffffffffc0202d00:	739c                	ld	a5,32(a5)
ffffffffc0202d02:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d04:	00093783          	ld	a5,0(s2)
ffffffffc0202d08:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d0c:	12000073          	sfence.vma
ffffffffc0202d10:	100027f3          	csrr	a5,sstatus
ffffffffc0202d14:	8b89                	andi	a5,a5,2
ffffffffc0202d16:	10079f63          	bnez	a5,ffffffffc0202e34 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1e:	779c                	ld	a5,40(a5)
ffffffffc0202d20:	9782                	jalr	a5
ffffffffc0202d22:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d24:	4c8c1e63          	bne	s8,s0,ffffffffc0203200 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d28:	00004517          	auipc	a0,0x4
ffffffffc0202d2c:	1b050513          	addi	a0,a0,432 # ffffffffc0206ed8 <default_pmm_manager+0x720>
ffffffffc0202d30:	c64fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202d34:	7406                	ld	s0,96(sp)
ffffffffc0202d36:	70a6                	ld	ra,104(sp)
ffffffffc0202d38:	64e6                	ld	s1,88(sp)
ffffffffc0202d3a:	6946                	ld	s2,80(sp)
ffffffffc0202d3c:	69a6                	ld	s3,72(sp)
ffffffffc0202d3e:	6a06                	ld	s4,64(sp)
ffffffffc0202d40:	7ae2                	ld	s5,56(sp)
ffffffffc0202d42:	7b42                	ld	s6,48(sp)
ffffffffc0202d44:	7ba2                	ld	s7,40(sp)
ffffffffc0202d46:	7c02                	ld	s8,32(sp)
ffffffffc0202d48:	6ce2                	ld	s9,24(sp)
ffffffffc0202d4a:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d4c:	f97fe06f          	j	ffffffffc0201ce2 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202d50:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d54:	bc7d                	j	ffffffffc0202812 <pmm_init+0x90>
        intr_disable();
ffffffffc0202d56:	c5ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d5a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d5e:	4505                	li	a0,1
ffffffffc0202d60:	6f9c                	ld	a5,24(a5)
ffffffffc0202d62:	9782                	jalr	a5
ffffffffc0202d64:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d66:	c49fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d6a:	b9a9                	j	ffffffffc02029c4 <pmm_init+0x242>
        intr_disable();
ffffffffc0202d6c:	c49fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d70:	000b3783          	ld	a5,0(s6)
ffffffffc0202d74:	4505                	li	a0,1
ffffffffc0202d76:	6f9c                	ld	a5,24(a5)
ffffffffc0202d78:	9782                	jalr	a5
ffffffffc0202d7a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d7c:	c33fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d80:	b645                	j	ffffffffc0202920 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d82:	c33fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d86:	000b3783          	ld	a5,0(s6)
ffffffffc0202d8a:	779c                	ld	a5,40(a5)
ffffffffc0202d8c:	9782                	jalr	a5
ffffffffc0202d8e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d90:	c1ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d94:	b6b9                	j	ffffffffc02028e2 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d96:	6705                	lui	a4,0x1
ffffffffc0202d98:	177d                	addi	a4,a4,-1
ffffffffc0202d9a:	96ba                	add	a3,a3,a4
ffffffffc0202d9c:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d9e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202da2:	14a77363          	bgeu	a4,a0,ffffffffc0202ee8 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202da6:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202daa:	fff80537          	lui	a0,0xfff80
ffffffffc0202dae:	972a                	add	a4,a4,a0
ffffffffc0202db0:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202db2:	8c1d                	sub	s0,s0,a5
ffffffffc0202db4:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202db8:	00c45593          	srli	a1,s0,0xc
ffffffffc0202dbc:	9532                	add	a0,a0,a2
ffffffffc0202dbe:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202dc0:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202dc4:	b4c1                	j	ffffffffc0202884 <pmm_init+0x102>
        intr_disable();
ffffffffc0202dc6:	beffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dca:	000b3783          	ld	a5,0(s6)
ffffffffc0202dce:	779c                	ld	a5,40(a5)
ffffffffc0202dd0:	9782                	jalr	a5
ffffffffc0202dd2:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202dd4:	bdbfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dd8:	bb79                	j	ffffffffc0202b76 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202dda:	bdbfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dde:	000b3783          	ld	a5,0(s6)
ffffffffc0202de2:	779c                	ld	a5,40(a5)
ffffffffc0202de4:	9782                	jalr	a5
ffffffffc0202de6:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202de8:	bc7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dec:	b39d                	j	ffffffffc0202b52 <pmm_init+0x3d0>
ffffffffc0202dee:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202df0:	bc5fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202df4:	000b3783          	ld	a5,0(s6)
ffffffffc0202df8:	6522                	ld	a0,8(sp)
ffffffffc0202dfa:	4585                	li	a1,1
ffffffffc0202dfc:	739c                	ld	a5,32(a5)
ffffffffc0202dfe:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e00:	baffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e04:	b33d                	j	ffffffffc0202b32 <pmm_init+0x3b0>
ffffffffc0202e06:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e08:	badfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e0c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e10:	6522                	ld	a0,8(sp)
ffffffffc0202e12:	4585                	li	a1,1
ffffffffc0202e14:	739c                	ld	a5,32(a5)
ffffffffc0202e16:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e18:	b97fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e1c:	b1dd                	j	ffffffffc0202b02 <pmm_init+0x380>
        intr_disable();
ffffffffc0202e1e:	b97fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e22:	000b3783          	ld	a5,0(s6)
ffffffffc0202e26:	4505                	li	a0,1
ffffffffc0202e28:	6f9c                	ld	a5,24(a5)
ffffffffc0202e2a:	9782                	jalr	a5
ffffffffc0202e2c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e2e:	b81fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e32:	b36d                	j	ffffffffc0202bdc <pmm_init+0x45a>
        intr_disable();
ffffffffc0202e34:	b81fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e38:	000b3783          	ld	a5,0(s6)
ffffffffc0202e3c:	779c                	ld	a5,40(a5)
ffffffffc0202e3e:	9782                	jalr	a5
ffffffffc0202e40:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e42:	b6dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e46:	bdf9                	j	ffffffffc0202d24 <pmm_init+0x5a2>
ffffffffc0202e48:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e4a:	b6bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e52:	6522                	ld	a0,8(sp)
ffffffffc0202e54:	4585                	li	a1,1
ffffffffc0202e56:	739c                	ld	a5,32(a5)
ffffffffc0202e58:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e5a:	b55fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e5e:	b55d                	j	ffffffffc0202d04 <pmm_init+0x582>
ffffffffc0202e60:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e62:	b53fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e66:	000b3783          	ld	a5,0(s6)
ffffffffc0202e6a:	6522                	ld	a0,8(sp)
ffffffffc0202e6c:	4585                	li	a1,1
ffffffffc0202e6e:	739c                	ld	a5,32(a5)
ffffffffc0202e70:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e72:	b3dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e76:	bdb9                	j	ffffffffc0202cd4 <pmm_init+0x552>
        intr_disable();
ffffffffc0202e78:	b3dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e7c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e80:	4585                	li	a1,1
ffffffffc0202e82:	8552                	mv	a0,s4
ffffffffc0202e84:	739c                	ld	a5,32(a5)
ffffffffc0202e86:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e88:	b27fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e8c:	bd29                	j	ffffffffc0202ca6 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e8e:	86a2                	mv	a3,s0
ffffffffc0202e90:	00004617          	auipc	a2,0x4
ffffffffc0202e94:	96060613          	addi	a2,a2,-1696 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0202e98:	25700593          	li	a1,599
ffffffffc0202e9c:	00004517          	auipc	a0,0x4
ffffffffc0202ea0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202ea4:	deafd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ea8:	00004697          	auipc	a3,0x4
ffffffffc0202eac:	ed068693          	addi	a3,a3,-304 # ffffffffc0206d78 <default_pmm_manager+0x5c0>
ffffffffc0202eb0:	00003617          	auipc	a2,0x3
ffffffffc0202eb4:	55860613          	addi	a2,a2,1368 # ffffffffc0206408 <commands+0x828>
ffffffffc0202eb8:	25800593          	li	a1,600
ffffffffc0202ebc:	00004517          	auipc	a0,0x4
ffffffffc0202ec0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202ec4:	dcafd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ec8:	00004697          	auipc	a3,0x4
ffffffffc0202ecc:	e7068693          	addi	a3,a3,-400 # ffffffffc0206d38 <default_pmm_manager+0x580>
ffffffffc0202ed0:	00003617          	auipc	a2,0x3
ffffffffc0202ed4:	53860613          	addi	a2,a2,1336 # ffffffffc0206408 <commands+0x828>
ffffffffc0202ed8:	25700593          	li	a1,599
ffffffffc0202edc:	00004517          	auipc	a0,0x4
ffffffffc0202ee0:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202ee4:	daafd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202ee8:	fc5fe0ef          	jal	ra,ffffffffc0201eac <pa2page.part.0>
ffffffffc0202eec:	fddfe0ef          	jal	ra,ffffffffc0201ec8 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202ef0:	00004697          	auipc	a3,0x4
ffffffffc0202ef4:	c4068693          	addi	a3,a3,-960 # ffffffffc0206b30 <default_pmm_manager+0x378>
ffffffffc0202ef8:	00003617          	auipc	a2,0x3
ffffffffc0202efc:	51060613          	addi	a2,a2,1296 # ffffffffc0206408 <commands+0x828>
ffffffffc0202f00:	22700593          	li	a1,551
ffffffffc0202f04:	00004517          	auipc	a0,0x4
ffffffffc0202f08:	a0450513          	addi	a0,a0,-1532 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202f0c:	d82fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202f10:	00004697          	auipc	a3,0x4
ffffffffc0202f14:	b6068693          	addi	a3,a3,-1184 # ffffffffc0206a70 <default_pmm_manager+0x2b8>
ffffffffc0202f18:	00003617          	auipc	a2,0x3
ffffffffc0202f1c:	4f060613          	addi	a2,a2,1264 # ffffffffc0206408 <commands+0x828>
ffffffffc0202f20:	21a00593          	li	a1,538
ffffffffc0202f24:	00004517          	auipc	a0,0x4
ffffffffc0202f28:	9e450513          	addi	a0,a0,-1564 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202f2c:	d62fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202f30:	00004697          	auipc	a3,0x4
ffffffffc0202f34:	b0068693          	addi	a3,a3,-1280 # ffffffffc0206a30 <default_pmm_manager+0x278>
ffffffffc0202f38:	00003617          	auipc	a2,0x3
ffffffffc0202f3c:	4d060613          	addi	a2,a2,1232 # ffffffffc0206408 <commands+0x828>
ffffffffc0202f40:	21900593          	li	a1,537
ffffffffc0202f44:	00004517          	auipc	a0,0x4
ffffffffc0202f48:	9c450513          	addi	a0,a0,-1596 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202f4c:	d42fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f50:	00004697          	auipc	a3,0x4
ffffffffc0202f54:	ac068693          	addi	a3,a3,-1344 # ffffffffc0206a10 <default_pmm_manager+0x258>
ffffffffc0202f58:	00003617          	auipc	a2,0x3
ffffffffc0202f5c:	4b060613          	addi	a2,a2,1200 # ffffffffc0206408 <commands+0x828>
ffffffffc0202f60:	21800593          	li	a1,536
ffffffffc0202f64:	00004517          	auipc	a0,0x4
ffffffffc0202f68:	9a450513          	addi	a0,a0,-1628 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202f6c:	d22fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f70:	00004617          	auipc	a2,0x4
ffffffffc0202f74:	88060613          	addi	a2,a2,-1920 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0202f78:	07100593          	li	a1,113
ffffffffc0202f7c:	00004517          	auipc	a0,0x4
ffffffffc0202f80:	89c50513          	addi	a0,a0,-1892 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0202f84:	d0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f88:	00004697          	auipc	a3,0x4
ffffffffc0202f8c:	d3868693          	addi	a3,a3,-712 # ffffffffc0206cc0 <default_pmm_manager+0x508>
ffffffffc0202f90:	00003617          	auipc	a2,0x3
ffffffffc0202f94:	47860613          	addi	a2,a2,1144 # ffffffffc0206408 <commands+0x828>
ffffffffc0202f98:	24000593          	li	a1,576
ffffffffc0202f9c:	00004517          	auipc	a0,0x4
ffffffffc0202fa0:	96c50513          	addi	a0,a0,-1684 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202fa4:	ceafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202fa8:	00004697          	auipc	a3,0x4
ffffffffc0202fac:	cd068693          	addi	a3,a3,-816 # ffffffffc0206c78 <default_pmm_manager+0x4c0>
ffffffffc0202fb0:	00003617          	auipc	a2,0x3
ffffffffc0202fb4:	45860613          	addi	a2,a2,1112 # ffffffffc0206408 <commands+0x828>
ffffffffc0202fb8:	23e00593          	li	a1,574
ffffffffc0202fbc:	00004517          	auipc	a0,0x4
ffffffffc0202fc0:	94c50513          	addi	a0,a0,-1716 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202fc4:	ccafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202fc8:	00004697          	auipc	a3,0x4
ffffffffc0202fcc:	ce068693          	addi	a3,a3,-800 # ffffffffc0206ca8 <default_pmm_manager+0x4f0>
ffffffffc0202fd0:	00003617          	auipc	a2,0x3
ffffffffc0202fd4:	43860613          	addi	a2,a2,1080 # ffffffffc0206408 <commands+0x828>
ffffffffc0202fd8:	23d00593          	li	a1,573
ffffffffc0202fdc:	00004517          	auipc	a0,0x4
ffffffffc0202fe0:	92c50513          	addi	a0,a0,-1748 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0202fe4:	caafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202fe8:	00004697          	auipc	a3,0x4
ffffffffc0202fec:	da868693          	addi	a3,a3,-600 # ffffffffc0206d90 <default_pmm_manager+0x5d8>
ffffffffc0202ff0:	00003617          	auipc	a2,0x3
ffffffffc0202ff4:	41860613          	addi	a2,a2,1048 # ffffffffc0206408 <commands+0x828>
ffffffffc0202ff8:	25b00593          	li	a1,603
ffffffffc0202ffc:	00004517          	auipc	a0,0x4
ffffffffc0203000:	90c50513          	addi	a0,a0,-1780 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203004:	c8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203008:	00004697          	auipc	a3,0x4
ffffffffc020300c:	ce868693          	addi	a3,a3,-792 # ffffffffc0206cf0 <default_pmm_manager+0x538>
ffffffffc0203010:	00003617          	auipc	a2,0x3
ffffffffc0203014:	3f860613          	addi	a2,a2,1016 # ffffffffc0206408 <commands+0x828>
ffffffffc0203018:	24800593          	li	a1,584
ffffffffc020301c:	00004517          	auipc	a0,0x4
ffffffffc0203020:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203024:	c6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203028:	00004697          	auipc	a3,0x4
ffffffffc020302c:	dc068693          	addi	a3,a3,-576 # ffffffffc0206de8 <default_pmm_manager+0x630>
ffffffffc0203030:	00003617          	auipc	a2,0x3
ffffffffc0203034:	3d860613          	addi	a2,a2,984 # ffffffffc0206408 <commands+0x828>
ffffffffc0203038:	26000593          	li	a1,608
ffffffffc020303c:	00004517          	auipc	a0,0x4
ffffffffc0203040:	8cc50513          	addi	a0,a0,-1844 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203044:	c4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203048:	00004697          	auipc	a3,0x4
ffffffffc020304c:	d6068693          	addi	a3,a3,-672 # ffffffffc0206da8 <default_pmm_manager+0x5f0>
ffffffffc0203050:	00003617          	auipc	a2,0x3
ffffffffc0203054:	3b860613          	addi	a2,a2,952 # ffffffffc0206408 <commands+0x828>
ffffffffc0203058:	25f00593          	li	a1,607
ffffffffc020305c:	00004517          	auipc	a0,0x4
ffffffffc0203060:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203064:	c2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203068:	00004697          	auipc	a3,0x4
ffffffffc020306c:	c1068693          	addi	a3,a3,-1008 # ffffffffc0206c78 <default_pmm_manager+0x4c0>
ffffffffc0203070:	00003617          	auipc	a2,0x3
ffffffffc0203074:	39860613          	addi	a2,a2,920 # ffffffffc0206408 <commands+0x828>
ffffffffc0203078:	23a00593          	li	a1,570
ffffffffc020307c:	00004517          	auipc	a0,0x4
ffffffffc0203080:	88c50513          	addi	a0,a0,-1908 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203084:	c0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203088:	00004697          	auipc	a3,0x4
ffffffffc020308c:	a9068693          	addi	a3,a3,-1392 # ffffffffc0206b18 <default_pmm_manager+0x360>
ffffffffc0203090:	00003617          	auipc	a2,0x3
ffffffffc0203094:	37860613          	addi	a2,a2,888 # ffffffffc0206408 <commands+0x828>
ffffffffc0203098:	23900593          	li	a1,569
ffffffffc020309c:	00004517          	auipc	a0,0x4
ffffffffc02030a0:	86c50513          	addi	a0,a0,-1940 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02030a4:	beafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02030a8:	00004697          	auipc	a3,0x4
ffffffffc02030ac:	be868693          	addi	a3,a3,-1048 # ffffffffc0206c90 <default_pmm_manager+0x4d8>
ffffffffc02030b0:	00003617          	auipc	a2,0x3
ffffffffc02030b4:	35860613          	addi	a2,a2,856 # ffffffffc0206408 <commands+0x828>
ffffffffc02030b8:	23600593          	li	a1,566
ffffffffc02030bc:	00004517          	auipc	a0,0x4
ffffffffc02030c0:	84c50513          	addi	a0,a0,-1972 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02030c4:	bcafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02030c8:	00004697          	auipc	a3,0x4
ffffffffc02030cc:	a3868693          	addi	a3,a3,-1480 # ffffffffc0206b00 <default_pmm_manager+0x348>
ffffffffc02030d0:	00003617          	auipc	a2,0x3
ffffffffc02030d4:	33860613          	addi	a2,a2,824 # ffffffffc0206408 <commands+0x828>
ffffffffc02030d8:	23500593          	li	a1,565
ffffffffc02030dc:	00004517          	auipc	a0,0x4
ffffffffc02030e0:	82c50513          	addi	a0,a0,-2004 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02030e4:	baafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02030e8:	00004697          	auipc	a3,0x4
ffffffffc02030ec:	ab868693          	addi	a3,a3,-1352 # ffffffffc0206ba0 <default_pmm_manager+0x3e8>
ffffffffc02030f0:	00003617          	auipc	a2,0x3
ffffffffc02030f4:	31860613          	addi	a2,a2,792 # ffffffffc0206408 <commands+0x828>
ffffffffc02030f8:	23400593          	li	a1,564
ffffffffc02030fc:	00004517          	auipc	a0,0x4
ffffffffc0203100:	80c50513          	addi	a0,a0,-2036 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203104:	b8afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203108:	00004697          	auipc	a3,0x4
ffffffffc020310c:	b7068693          	addi	a3,a3,-1168 # ffffffffc0206c78 <default_pmm_manager+0x4c0>
ffffffffc0203110:	00003617          	auipc	a2,0x3
ffffffffc0203114:	2f860613          	addi	a2,a2,760 # ffffffffc0206408 <commands+0x828>
ffffffffc0203118:	23300593          	li	a1,563
ffffffffc020311c:	00003517          	auipc	a0,0x3
ffffffffc0203120:	7ec50513          	addi	a0,a0,2028 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203124:	b6afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203128:	00004697          	auipc	a3,0x4
ffffffffc020312c:	b3868693          	addi	a3,a3,-1224 # ffffffffc0206c60 <default_pmm_manager+0x4a8>
ffffffffc0203130:	00003617          	auipc	a2,0x3
ffffffffc0203134:	2d860613          	addi	a2,a2,728 # ffffffffc0206408 <commands+0x828>
ffffffffc0203138:	23200593          	li	a1,562
ffffffffc020313c:	00003517          	auipc	a0,0x3
ffffffffc0203140:	7cc50513          	addi	a0,a0,1996 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203144:	b4afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203148:	00004697          	auipc	a3,0x4
ffffffffc020314c:	ae868693          	addi	a3,a3,-1304 # ffffffffc0206c30 <default_pmm_manager+0x478>
ffffffffc0203150:	00003617          	auipc	a2,0x3
ffffffffc0203154:	2b860613          	addi	a2,a2,696 # ffffffffc0206408 <commands+0x828>
ffffffffc0203158:	23100593          	li	a1,561
ffffffffc020315c:	00003517          	auipc	a0,0x3
ffffffffc0203160:	7ac50513          	addi	a0,a0,1964 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203164:	b2afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0203168:	00004697          	auipc	a3,0x4
ffffffffc020316c:	ab068693          	addi	a3,a3,-1360 # ffffffffc0206c18 <default_pmm_manager+0x460>
ffffffffc0203170:	00003617          	auipc	a2,0x3
ffffffffc0203174:	29860613          	addi	a2,a2,664 # ffffffffc0206408 <commands+0x828>
ffffffffc0203178:	22f00593          	li	a1,559
ffffffffc020317c:	00003517          	auipc	a0,0x3
ffffffffc0203180:	78c50513          	addi	a0,a0,1932 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203184:	b0afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0203188:	00004697          	auipc	a3,0x4
ffffffffc020318c:	a7068693          	addi	a3,a3,-1424 # ffffffffc0206bf8 <default_pmm_manager+0x440>
ffffffffc0203190:	00003617          	auipc	a2,0x3
ffffffffc0203194:	27860613          	addi	a2,a2,632 # ffffffffc0206408 <commands+0x828>
ffffffffc0203198:	22e00593          	li	a1,558
ffffffffc020319c:	00003517          	auipc	a0,0x3
ffffffffc02031a0:	76c50513          	addi	a0,a0,1900 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02031a4:	aeafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc02031a8:	00004697          	auipc	a3,0x4
ffffffffc02031ac:	a4068693          	addi	a3,a3,-1472 # ffffffffc0206be8 <default_pmm_manager+0x430>
ffffffffc02031b0:	00003617          	auipc	a2,0x3
ffffffffc02031b4:	25860613          	addi	a2,a2,600 # ffffffffc0206408 <commands+0x828>
ffffffffc02031b8:	22d00593          	li	a1,557
ffffffffc02031bc:	00003517          	auipc	a0,0x3
ffffffffc02031c0:	74c50513          	addi	a0,a0,1868 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02031c4:	acafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc02031c8:	00004697          	auipc	a3,0x4
ffffffffc02031cc:	a1068693          	addi	a3,a3,-1520 # ffffffffc0206bd8 <default_pmm_manager+0x420>
ffffffffc02031d0:	00003617          	auipc	a2,0x3
ffffffffc02031d4:	23860613          	addi	a2,a2,568 # ffffffffc0206408 <commands+0x828>
ffffffffc02031d8:	22c00593          	li	a1,556
ffffffffc02031dc:	00003517          	auipc	a0,0x3
ffffffffc02031e0:	72c50513          	addi	a0,a0,1836 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02031e4:	aaafd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc02031e8:	00003617          	auipc	a2,0x3
ffffffffc02031ec:	79060613          	addi	a2,a2,1936 # ffffffffc0206978 <default_pmm_manager+0x1c0>
ffffffffc02031f0:	06600593          	li	a1,102
ffffffffc02031f4:	00003517          	auipc	a0,0x3
ffffffffc02031f8:	71450513          	addi	a0,a0,1812 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02031fc:	a92fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203200:	00004697          	auipc	a3,0x4
ffffffffc0203204:	af068693          	addi	a3,a3,-1296 # ffffffffc0206cf0 <default_pmm_manager+0x538>
ffffffffc0203208:	00003617          	auipc	a2,0x3
ffffffffc020320c:	20060613          	addi	a2,a2,512 # ffffffffc0206408 <commands+0x828>
ffffffffc0203210:	27200593          	li	a1,626
ffffffffc0203214:	00003517          	auipc	a0,0x3
ffffffffc0203218:	6f450513          	addi	a0,a0,1780 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020321c:	a72fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203220:	00004697          	auipc	a3,0x4
ffffffffc0203224:	98068693          	addi	a3,a3,-1664 # ffffffffc0206ba0 <default_pmm_manager+0x3e8>
ffffffffc0203228:	00003617          	auipc	a2,0x3
ffffffffc020322c:	1e060613          	addi	a2,a2,480 # ffffffffc0206408 <commands+0x828>
ffffffffc0203230:	22b00593          	li	a1,555
ffffffffc0203234:	00003517          	auipc	a0,0x3
ffffffffc0203238:	6d450513          	addi	a0,a0,1748 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020323c:	a52fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203240:	00004697          	auipc	a3,0x4
ffffffffc0203244:	92068693          	addi	a3,a3,-1760 # ffffffffc0206b60 <default_pmm_manager+0x3a8>
ffffffffc0203248:	00003617          	auipc	a2,0x3
ffffffffc020324c:	1c060613          	addi	a2,a2,448 # ffffffffc0206408 <commands+0x828>
ffffffffc0203250:	22a00593          	li	a1,554
ffffffffc0203254:	00003517          	auipc	a0,0x3
ffffffffc0203258:	6b450513          	addi	a0,a0,1716 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020325c:	a32fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203260:	86d6                	mv	a3,s5
ffffffffc0203262:	00003617          	auipc	a2,0x3
ffffffffc0203266:	58e60613          	addi	a2,a2,1422 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc020326a:	22600593          	li	a1,550
ffffffffc020326e:	00003517          	auipc	a0,0x3
ffffffffc0203272:	69a50513          	addi	a0,a0,1690 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203276:	a18fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020327a:	00003617          	auipc	a2,0x3
ffffffffc020327e:	57660613          	addi	a2,a2,1398 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0203282:	22500593          	li	a1,549
ffffffffc0203286:	00003517          	auipc	a0,0x3
ffffffffc020328a:	68250513          	addi	a0,a0,1666 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020328e:	a00fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203292:	00004697          	auipc	a3,0x4
ffffffffc0203296:	88668693          	addi	a3,a3,-1914 # ffffffffc0206b18 <default_pmm_manager+0x360>
ffffffffc020329a:	00003617          	auipc	a2,0x3
ffffffffc020329e:	16e60613          	addi	a2,a2,366 # ffffffffc0206408 <commands+0x828>
ffffffffc02032a2:	22300593          	li	a1,547
ffffffffc02032a6:	00003517          	auipc	a0,0x3
ffffffffc02032aa:	66250513          	addi	a0,a0,1634 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02032ae:	9e0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02032b2:	00004697          	auipc	a3,0x4
ffffffffc02032b6:	84e68693          	addi	a3,a3,-1970 # ffffffffc0206b00 <default_pmm_manager+0x348>
ffffffffc02032ba:	00003617          	auipc	a2,0x3
ffffffffc02032be:	14e60613          	addi	a2,a2,334 # ffffffffc0206408 <commands+0x828>
ffffffffc02032c2:	22200593          	li	a1,546
ffffffffc02032c6:	00003517          	auipc	a0,0x3
ffffffffc02032ca:	64250513          	addi	a0,a0,1602 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02032ce:	9c0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02032d2:	00004697          	auipc	a3,0x4
ffffffffc02032d6:	bde68693          	addi	a3,a3,-1058 # ffffffffc0206eb0 <default_pmm_manager+0x6f8>
ffffffffc02032da:	00003617          	auipc	a2,0x3
ffffffffc02032de:	12e60613          	addi	a2,a2,302 # ffffffffc0206408 <commands+0x828>
ffffffffc02032e2:	26900593          	li	a1,617
ffffffffc02032e6:	00003517          	auipc	a0,0x3
ffffffffc02032ea:	62250513          	addi	a0,a0,1570 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02032ee:	9a0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032f2:	00004697          	auipc	a3,0x4
ffffffffc02032f6:	b8668693          	addi	a3,a3,-1146 # ffffffffc0206e78 <default_pmm_manager+0x6c0>
ffffffffc02032fa:	00003617          	auipc	a2,0x3
ffffffffc02032fe:	10e60613          	addi	a2,a2,270 # ffffffffc0206408 <commands+0x828>
ffffffffc0203302:	26600593          	li	a1,614
ffffffffc0203306:	00003517          	auipc	a0,0x3
ffffffffc020330a:	60250513          	addi	a0,a0,1538 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020330e:	980fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203312:	00004697          	auipc	a3,0x4
ffffffffc0203316:	b3668693          	addi	a3,a3,-1226 # ffffffffc0206e48 <default_pmm_manager+0x690>
ffffffffc020331a:	00003617          	auipc	a2,0x3
ffffffffc020331e:	0ee60613          	addi	a2,a2,238 # ffffffffc0206408 <commands+0x828>
ffffffffc0203322:	26200593          	li	a1,610
ffffffffc0203326:	00003517          	auipc	a0,0x3
ffffffffc020332a:	5e250513          	addi	a0,a0,1506 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020332e:	960fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203332:	00004697          	auipc	a3,0x4
ffffffffc0203336:	ace68693          	addi	a3,a3,-1330 # ffffffffc0206e00 <default_pmm_manager+0x648>
ffffffffc020333a:	00003617          	auipc	a2,0x3
ffffffffc020333e:	0ce60613          	addi	a2,a2,206 # ffffffffc0206408 <commands+0x828>
ffffffffc0203342:	26100593          	li	a1,609
ffffffffc0203346:	00003517          	auipc	a0,0x3
ffffffffc020334a:	5c250513          	addi	a0,a0,1474 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020334e:	940fd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203352:	00003617          	auipc	a2,0x3
ffffffffc0203356:	54660613          	addi	a2,a2,1350 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc020335a:	0ca00593          	li	a1,202
ffffffffc020335e:	00003517          	auipc	a0,0x3
ffffffffc0203362:	5aa50513          	addi	a0,a0,1450 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203366:	928fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020336a:	00003617          	auipc	a2,0x3
ffffffffc020336e:	52e60613          	addi	a2,a2,1326 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc0203372:	08200593          	li	a1,130
ffffffffc0203376:	00003517          	auipc	a0,0x3
ffffffffc020337a:	59250513          	addi	a0,a0,1426 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020337e:	910fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203382:	00003697          	auipc	a3,0x3
ffffffffc0203386:	74e68693          	addi	a3,a3,1870 # ffffffffc0206ad0 <default_pmm_manager+0x318>
ffffffffc020338a:	00003617          	auipc	a2,0x3
ffffffffc020338e:	07e60613          	addi	a2,a2,126 # ffffffffc0206408 <commands+0x828>
ffffffffc0203392:	22100593          	li	a1,545
ffffffffc0203396:	00003517          	auipc	a0,0x3
ffffffffc020339a:	57250513          	addi	a0,a0,1394 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020339e:	8f0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02033a2:	00003697          	auipc	a3,0x3
ffffffffc02033a6:	6fe68693          	addi	a3,a3,1790 # ffffffffc0206aa0 <default_pmm_manager+0x2e8>
ffffffffc02033aa:	00003617          	auipc	a2,0x3
ffffffffc02033ae:	05e60613          	addi	a2,a2,94 # ffffffffc0206408 <commands+0x828>
ffffffffc02033b2:	21e00593          	li	a1,542
ffffffffc02033b6:	00003517          	auipc	a0,0x3
ffffffffc02033ba:	55250513          	addi	a0,a0,1362 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02033be:	8d0fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02033c2 <copy_range>:
{
ffffffffc02033c2:	7119                	addi	sp,sp,-128
ffffffffc02033c4:	f4a6                	sd	s1,104(sp)
ffffffffc02033c6:	84b6                	mv	s1,a3
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033c8:	8ed1                	or	a3,a3,a2
{
ffffffffc02033ca:	fc86                	sd	ra,120(sp)
ffffffffc02033cc:	f8a2                	sd	s0,112(sp)
ffffffffc02033ce:	f0ca                	sd	s2,96(sp)
ffffffffc02033d0:	ecce                	sd	s3,88(sp)
ffffffffc02033d2:	e8d2                	sd	s4,80(sp)
ffffffffc02033d4:	e4d6                	sd	s5,72(sp)
ffffffffc02033d6:	e0da                	sd	s6,64(sp)
ffffffffc02033d8:	fc5e                	sd	s7,56(sp)
ffffffffc02033da:	f862                	sd	s8,48(sp)
ffffffffc02033dc:	f466                	sd	s9,40(sp)
ffffffffc02033de:	f06a                	sd	s10,32(sp)
ffffffffc02033e0:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033e2:	16d2                	slli	a3,a3,0x34
{
ffffffffc02033e4:	e43a                	sd	a4,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02033e6:	24069663          	bnez	a3,ffffffffc0203632 <copy_range+0x270>
    assert(USER_ACCESS(start, end));
ffffffffc02033ea:	00200737          	lui	a4,0x200
ffffffffc02033ee:	8db2                	mv	s11,a2
ffffffffc02033f0:	1ae66863          	bltu	a2,a4,ffffffffc02035a0 <copy_range+0x1de>
ffffffffc02033f4:	1a967663          	bgeu	a2,s1,ffffffffc02035a0 <copy_range+0x1de>
ffffffffc02033f8:	4705                	li	a4,1
ffffffffc02033fa:	077e                	slli	a4,a4,0x1f
ffffffffc02033fc:	1a976263          	bltu	a4,s1,ffffffffc02035a0 <copy_range+0x1de>
ffffffffc0203400:	5bfd                	li	s7,-1
ffffffffc0203402:	8a2a                	mv	s4,a0
ffffffffc0203404:	842e                	mv	s0,a1
        start += PGSIZE;
ffffffffc0203406:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage)
ffffffffc0203408:	000bdb17          	auipc	s6,0xbd
ffffffffc020340c:	728b0b13          	addi	s6,s6,1832 # ffffffffc02c0b30 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203410:	000bda97          	auipc	s5,0xbd
ffffffffc0203414:	728a8a93          	addi	s5,s5,1832 # ffffffffc02c0b38 <pages>
    return KADDR(page2pa(page));
ffffffffc0203418:	00cbdb93          	srli	s7,s7,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc020341c:	000bdc97          	auipc	s9,0xbd
ffffffffc0203420:	724c8c93          	addi	s9,s9,1828 # ffffffffc02c0b40 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203424:	4601                	li	a2,0
ffffffffc0203426:	85ee                	mv	a1,s11
ffffffffc0203428:	8522                	mv	a0,s0
ffffffffc020342a:	b73fe0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc020342e:	892a                	mv	s2,a0
        if (ptep == NULL)
ffffffffc0203430:	c569                	beqz	a0,ffffffffc02034fa <copy_range+0x138>
        if (*ptep & PTE_V)
ffffffffc0203432:	6118                	ld	a4,0(a0)
ffffffffc0203434:	8b05                	andi	a4,a4,1
ffffffffc0203436:	e705                	bnez	a4,ffffffffc020345e <copy_range+0x9c>
        start += PGSIZE;
ffffffffc0203438:	9dce                	add	s11,s11,s3
    } while (start != 0 && start < end);
ffffffffc020343a:	fe9de5e3          	bltu	s11,s1,ffffffffc0203424 <copy_range+0x62>
    return 0;
ffffffffc020343e:	4501                	li	a0,0
}
ffffffffc0203440:	70e6                	ld	ra,120(sp)
ffffffffc0203442:	7446                	ld	s0,112(sp)
ffffffffc0203444:	74a6                	ld	s1,104(sp)
ffffffffc0203446:	7906                	ld	s2,96(sp)
ffffffffc0203448:	69e6                	ld	s3,88(sp)
ffffffffc020344a:	6a46                	ld	s4,80(sp)
ffffffffc020344c:	6aa6                	ld	s5,72(sp)
ffffffffc020344e:	6b06                	ld	s6,64(sp)
ffffffffc0203450:	7be2                	ld	s7,56(sp)
ffffffffc0203452:	7c42                	ld	s8,48(sp)
ffffffffc0203454:	7ca2                	ld	s9,40(sp)
ffffffffc0203456:	7d02                	ld	s10,32(sp)
ffffffffc0203458:	6de2                	ld	s11,24(sp)
ffffffffc020345a:	6109                	addi	sp,sp,128
ffffffffc020345c:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020345e:	4605                	li	a2,1
ffffffffc0203460:	85ee                	mv	a1,s11
ffffffffc0203462:	8552                	mv	a0,s4
ffffffffc0203464:	b39fe0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc0203468:	10050e63          	beqz	a0,ffffffffc0203584 <copy_range+0x1c2>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020346c:	00093703          	ld	a4,0(s2)
    if (!(pte & PTE_V))
ffffffffc0203470:	00177693          	andi	a3,a4,1
ffffffffc0203474:	0007091b          	sext.w	s2,a4
ffffffffc0203478:	16068163          	beqz	a3,ffffffffc02035da <copy_range+0x218>
    if (PPN(pa) >= npage)
ffffffffc020347c:	000b3683          	ld	a3,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203480:	070a                	slli	a4,a4,0x2
ffffffffc0203482:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0203484:	10d77263          	bgeu	a4,a3,ffffffffc0203588 <copy_range+0x1c6>
    return &pages[PPN(pa) - nbase];
ffffffffc0203488:	000ab583          	ld	a1,0(s5)
ffffffffc020348c:	fff807b7          	lui	a5,0xfff80
ffffffffc0203490:	973e                	add	a4,a4,a5
ffffffffc0203492:	071a                	slli	a4,a4,0x6
ffffffffc0203494:	00e58d33          	add	s10,a1,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203498:	10002773          	csrr	a4,sstatus
ffffffffc020349c:	8b09                	andi	a4,a4,2
ffffffffc020349e:	eb61                	bnez	a4,ffffffffc020356e <copy_range+0x1ac>
        page = pmm_manager->alloc_pages(n);
ffffffffc02034a0:	000cb703          	ld	a4,0(s9)
ffffffffc02034a4:	4505                	li	a0,1
ffffffffc02034a6:	6f18                	ld	a4,24(a4)
ffffffffc02034a8:	9702                	jalr	a4
ffffffffc02034aa:	8c2a                	mv	s8,a0
            assert(page != NULL);
ffffffffc02034ac:	140d0363          	beqz	s10,ffffffffc02035f2 <copy_range+0x230>
            assert(npage != NULL);
ffffffffc02034b0:	160c0163          	beqz	s8,ffffffffc0203612 <copy_range+0x250>
            if(share){
ffffffffc02034b4:	67a2                	ld	a5,8(sp)
ffffffffc02034b6:	cfb9                	beqz	a5,ffffffffc0203514 <copy_range+0x152>
                perm = (perm | PTE_COW) & ~PTE_W;
ffffffffc02034b8:	01b97913          	andi	s2,s2,27
ffffffffc02034bc:	10096913          	ori	s2,s2,256
                page_insert(from, page, start, perm);
ffffffffc02034c0:	86ca                	mv	a3,s2
ffffffffc02034c2:	866e                	mv	a2,s11
ffffffffc02034c4:	85ea                	mv	a1,s10
ffffffffc02034c6:	8522                	mv	a0,s0
ffffffffc02034c8:	9c4ff0ef          	jal	ra,ffffffffc020268c <page_insert>
                ret = page_insert(to, page, start, perm);
ffffffffc02034cc:	86ca                	mv	a3,s2
ffffffffc02034ce:	866e                	mv	a2,s11
ffffffffc02034d0:	85ea                	mv	a1,s10
ffffffffc02034d2:	8552                	mv	a0,s4
ffffffffc02034d4:	9b8ff0ef          	jal	ra,ffffffffc020268c <page_insert>
            assert(ret == 0);
ffffffffc02034d8:	d125                	beqz	a0,ffffffffc0203438 <copy_range+0x76>
ffffffffc02034da:	00004697          	auipc	a3,0x4
ffffffffc02034de:	a3e68693          	addi	a3,a3,-1474 # ffffffffc0206f18 <default_pmm_manager+0x760>
ffffffffc02034e2:	00003617          	auipc	a2,0x3
ffffffffc02034e6:	f2660613          	addi	a2,a2,-218 # ffffffffc0206408 <commands+0x828>
ffffffffc02034ea:	1b600593          	li	a1,438
ffffffffc02034ee:	00003517          	auipc	a0,0x3
ffffffffc02034f2:	41a50513          	addi	a0,a0,1050 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02034f6:	f99fc0ef          	jal	ra,ffffffffc020048e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02034fa:	00200637          	lui	a2,0x200
ffffffffc02034fe:	00cd87b3          	add	a5,s11,a2
ffffffffc0203502:	ffe00637          	lui	a2,0xffe00
ffffffffc0203506:	00c7fdb3          	and	s11,a5,a2
    } while (start != 0 && start < end);
ffffffffc020350a:	f20d8ae3          	beqz	s11,ffffffffc020343e <copy_range+0x7c>
ffffffffc020350e:	f09debe3          	bltu	s11,s1,ffffffffc0203424 <copy_range+0x62>
ffffffffc0203512:	b735                	j	ffffffffc020343e <copy_range+0x7c>
    return page - pages + nbase;
ffffffffc0203514:	000ab703          	ld	a4,0(s5)
ffffffffc0203518:	000808b7          	lui	a7,0x80
    return KADDR(page2pa(page));
ffffffffc020351c:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc0203520:	40ed06b3          	sub	a3,s10,a4
ffffffffc0203524:	8699                	srai	a3,a3,0x6
ffffffffc0203526:	96c6                	add	a3,a3,a7
    return KADDR(page2pa(page));
ffffffffc0203528:	0176f5b3          	and	a1,a3,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc020352c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020352e:	08c5fa63          	bgeu	a1,a2,ffffffffc02035c2 <copy_range+0x200>
    return page - pages + nbase;
ffffffffc0203532:	40ec0733          	sub	a4,s8,a4
    return KADDR(page2pa(page));
ffffffffc0203536:	000bd797          	auipc	a5,0xbd
ffffffffc020353a:	61278793          	addi	a5,a5,1554 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc020353e:	6388                	ld	a0,0(a5)
    return page - pages + nbase;
ffffffffc0203540:	8719                	srai	a4,a4,0x6
ffffffffc0203542:	9746                	add	a4,a4,a7
    return KADDR(page2pa(page));
ffffffffc0203544:	017778b3          	and	a7,a4,s7
ffffffffc0203548:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020354c:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc020354e:	06c8f963          	bgeu	a7,a2,ffffffffc02035c0 <copy_range+0x1fe>
                memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0203552:	6605                	lui	a2,0x1
ffffffffc0203554:	953a                	add	a0,a0,a4
ffffffffc0203556:	408020ef          	jal	ra,ffffffffc020595e <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc020355a:	01f97693          	andi	a3,s2,31
ffffffffc020355e:	866e                	mv	a2,s11
ffffffffc0203560:	85e2                	mv	a1,s8
ffffffffc0203562:	8552                	mv	a0,s4
ffffffffc0203564:	928ff0ef          	jal	ra,ffffffffc020268c <page_insert>
            assert(ret == 0);
ffffffffc0203568:	ec0508e3          	beqz	a0,ffffffffc0203438 <copy_range+0x76>
ffffffffc020356c:	b7bd                	j	ffffffffc02034da <copy_range+0x118>
        intr_disable();
ffffffffc020356e:	c46fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203572:	000cb703          	ld	a4,0(s9)
ffffffffc0203576:	4505                	li	a0,1
ffffffffc0203578:	6f18                	ld	a4,24(a4)
ffffffffc020357a:	9702                	jalr	a4
ffffffffc020357c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020357e:	c30fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203582:	b72d                	j	ffffffffc02034ac <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0203584:	5571                	li	a0,-4
ffffffffc0203586:	bd6d                	j	ffffffffc0203440 <copy_range+0x7e>
        panic("pa2page called with invalid pa");
ffffffffc0203588:	00003617          	auipc	a2,0x3
ffffffffc020358c:	33860613          	addi	a2,a2,824 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc0203590:	06900593          	li	a1,105
ffffffffc0203594:	00003517          	auipc	a0,0x3
ffffffffc0203598:	28450513          	addi	a0,a0,644 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc020359c:	ef3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02035a0:	00003697          	auipc	a3,0x3
ffffffffc02035a4:	3a868693          	addi	a3,a3,936 # ffffffffc0206948 <default_pmm_manager+0x190>
ffffffffc02035a8:	00003617          	auipc	a2,0x3
ffffffffc02035ac:	e6060613          	addi	a2,a2,-416 # ffffffffc0206408 <commands+0x828>
ffffffffc02035b0:	17d00593          	li	a1,381
ffffffffc02035b4:	00003517          	auipc	a0,0x3
ffffffffc02035b8:	35450513          	addi	a0,a0,852 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc02035bc:	ed3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02035c0:	86ba                	mv	a3,a4
ffffffffc02035c2:	00003617          	auipc	a2,0x3
ffffffffc02035c6:	22e60613          	addi	a2,a2,558 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc02035ca:	07100593          	li	a1,113
ffffffffc02035ce:	00003517          	auipc	a0,0x3
ffffffffc02035d2:	24a50513          	addi	a0,a0,586 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02035d6:	eb9fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035da:	00003617          	auipc	a2,0x3
ffffffffc02035de:	30660613          	addi	a2,a2,774 # ffffffffc02068e0 <default_pmm_manager+0x128>
ffffffffc02035e2:	07f00593          	li	a1,127
ffffffffc02035e6:	00003517          	auipc	a0,0x3
ffffffffc02035ea:	23250513          	addi	a0,a0,562 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02035ee:	ea1fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc02035f2:	00004697          	auipc	a3,0x4
ffffffffc02035f6:	90668693          	addi	a3,a3,-1786 # ffffffffc0206ef8 <default_pmm_manager+0x740>
ffffffffc02035fa:	00003617          	auipc	a2,0x3
ffffffffc02035fe:	e0e60613          	addi	a2,a2,-498 # ffffffffc0206408 <commands+0x828>
ffffffffc0203602:	19500593          	li	a1,405
ffffffffc0203606:	00003517          	auipc	a0,0x3
ffffffffc020360a:	30250513          	addi	a0,a0,770 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020360e:	e81fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(npage != NULL);
ffffffffc0203612:	00004697          	auipc	a3,0x4
ffffffffc0203616:	8f668693          	addi	a3,a3,-1802 # ffffffffc0206f08 <default_pmm_manager+0x750>
ffffffffc020361a:	00003617          	auipc	a2,0x3
ffffffffc020361e:	dee60613          	addi	a2,a2,-530 # ffffffffc0206408 <commands+0x828>
ffffffffc0203622:	19600593          	li	a1,406
ffffffffc0203626:	00003517          	auipc	a0,0x3
ffffffffc020362a:	2e250513          	addi	a0,a0,738 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020362e:	e61fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203632:	00003697          	auipc	a3,0x3
ffffffffc0203636:	2e668693          	addi	a3,a3,742 # ffffffffc0206918 <default_pmm_manager+0x160>
ffffffffc020363a:	00003617          	auipc	a2,0x3
ffffffffc020363e:	dce60613          	addi	a2,a2,-562 # ffffffffc0206408 <commands+0x828>
ffffffffc0203642:	17c00593          	li	a1,380
ffffffffc0203646:	00003517          	auipc	a0,0x3
ffffffffc020364a:	2c250513          	addi	a0,a0,706 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc020364e:	e41fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203652 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0203652:	12058073          	sfence.vma	a1
}
ffffffffc0203656:	8082                	ret

ffffffffc0203658 <pgdir_alloc_page>:
{
ffffffffc0203658:	7179                	addi	sp,sp,-48
ffffffffc020365a:	ec26                	sd	s1,24(sp)
ffffffffc020365c:	e84a                	sd	s2,16(sp)
ffffffffc020365e:	e052                	sd	s4,0(sp)
ffffffffc0203660:	f406                	sd	ra,40(sp)
ffffffffc0203662:	f022                	sd	s0,32(sp)
ffffffffc0203664:	e44e                	sd	s3,8(sp)
ffffffffc0203666:	8a2a                	mv	s4,a0
ffffffffc0203668:	84ae                	mv	s1,a1
ffffffffc020366a:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020366c:	100027f3          	csrr	a5,sstatus
ffffffffc0203670:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203672:	000bd997          	auipc	s3,0xbd
ffffffffc0203676:	4ce98993          	addi	s3,s3,1230 # ffffffffc02c0b40 <pmm_manager>
ffffffffc020367a:	ef8d                	bnez	a5,ffffffffc02036b4 <pgdir_alloc_page+0x5c>
ffffffffc020367c:	0009b783          	ld	a5,0(s3)
ffffffffc0203680:	4505                	li	a0,1
ffffffffc0203682:	6f9c                	ld	a5,24(a5)
ffffffffc0203684:	9782                	jalr	a5
ffffffffc0203686:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203688:	cc09                	beqz	s0,ffffffffc02036a2 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc020368a:	86ca                	mv	a3,s2
ffffffffc020368c:	8626                	mv	a2,s1
ffffffffc020368e:	85a2                	mv	a1,s0
ffffffffc0203690:	8552                	mv	a0,s4
ffffffffc0203692:	ffbfe0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc0203696:	e915                	bnez	a0,ffffffffc02036ca <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203698:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc020369a:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020369c:	4785                	li	a5,1
ffffffffc020369e:	04f71e63          	bne	a4,a5,ffffffffc02036fa <pgdir_alloc_page+0xa2>
}
ffffffffc02036a2:	70a2                	ld	ra,40(sp)
ffffffffc02036a4:	8522                	mv	a0,s0
ffffffffc02036a6:	7402                	ld	s0,32(sp)
ffffffffc02036a8:	64e2                	ld	s1,24(sp)
ffffffffc02036aa:	6942                	ld	s2,16(sp)
ffffffffc02036ac:	69a2                	ld	s3,8(sp)
ffffffffc02036ae:	6a02                	ld	s4,0(sp)
ffffffffc02036b0:	6145                	addi	sp,sp,48
ffffffffc02036b2:	8082                	ret
        intr_disable();
ffffffffc02036b4:	b00fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02036b8:	0009b783          	ld	a5,0(s3)
ffffffffc02036bc:	4505                	li	a0,1
ffffffffc02036be:	6f9c                	ld	a5,24(a5)
ffffffffc02036c0:	9782                	jalr	a5
ffffffffc02036c2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02036c4:	aeafd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02036c8:	b7c1                	j	ffffffffc0203688 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02036ca:	100027f3          	csrr	a5,sstatus
ffffffffc02036ce:	8b89                	andi	a5,a5,2
ffffffffc02036d0:	eb89                	bnez	a5,ffffffffc02036e2 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc02036d2:	0009b783          	ld	a5,0(s3)
ffffffffc02036d6:	8522                	mv	a0,s0
ffffffffc02036d8:	4585                	li	a1,1
ffffffffc02036da:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02036dc:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02036de:	9782                	jalr	a5
    if (flag)
ffffffffc02036e0:	b7c9                	j	ffffffffc02036a2 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc02036e2:	ad2fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02036e6:	0009b783          	ld	a5,0(s3)
ffffffffc02036ea:	8522                	mv	a0,s0
ffffffffc02036ec:	4585                	li	a1,1
ffffffffc02036ee:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02036f0:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02036f2:	9782                	jalr	a5
        intr_enable();
ffffffffc02036f4:	abafd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02036f8:	b76d                	j	ffffffffc02036a2 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02036fa:	00004697          	auipc	a3,0x4
ffffffffc02036fe:	82e68693          	addi	a3,a3,-2002 # ffffffffc0206f28 <default_pmm_manager+0x770>
ffffffffc0203702:	00003617          	auipc	a2,0x3
ffffffffc0203706:	d0660613          	addi	a2,a2,-762 # ffffffffc0206408 <commands+0x828>
ffffffffc020370a:	1ff00593          	li	a1,511
ffffffffc020370e:	00003517          	auipc	a0,0x3
ffffffffc0203712:	1fa50513          	addi	a0,a0,506 # ffffffffc0206908 <default_pmm_manager+0x150>
ffffffffc0203716:	d79fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020371a <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc020371a:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc020371c:	00004697          	auipc	a3,0x4
ffffffffc0203720:	82468693          	addi	a3,a3,-2012 # ffffffffc0206f40 <default_pmm_manager+0x788>
ffffffffc0203724:	00003617          	auipc	a2,0x3
ffffffffc0203728:	ce460613          	addi	a2,a2,-796 # ffffffffc0206408 <commands+0x828>
ffffffffc020372c:	0d800593          	li	a1,216
ffffffffc0203730:	00004517          	auipc	a0,0x4
ffffffffc0203734:	83050513          	addi	a0,a0,-2000 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203738:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc020373a:	d55fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020373e <mm_create>:
{
ffffffffc020373e:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203740:	04000513          	li	a0,64
{
ffffffffc0203744:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203746:	dc0fe0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
    if (mm != NULL)
ffffffffc020374a:	cd19                	beqz	a0,ffffffffc0203768 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc020374c:	e508                	sd	a0,8(a0)
ffffffffc020374e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203750:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203754:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203758:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020375c:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0203760:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203764:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203768:	60a2                	ld	ra,8(sp)
ffffffffc020376a:	0141                	addi	sp,sp,16
ffffffffc020376c:	8082                	ret

ffffffffc020376e <find_vma>:
{
ffffffffc020376e:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0203770:	c505                	beqz	a0,ffffffffc0203798 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203772:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203774:	c501                	beqz	a0,ffffffffc020377c <find_vma+0xe>
ffffffffc0203776:	651c                	ld	a5,8(a0)
ffffffffc0203778:	02f5f263          	bgeu	a1,a5,ffffffffc020379c <find_vma+0x2e>
    return listelm->next;
ffffffffc020377c:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc020377e:	00f68d63          	beq	a3,a5,ffffffffc0203798 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203782:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203786:	00e5e663          	bltu	a1,a4,ffffffffc0203792 <find_vma+0x24>
ffffffffc020378a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020378e:	00e5ec63          	bltu	a1,a4,ffffffffc02037a6 <find_vma+0x38>
ffffffffc0203792:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203794:	fef697e3          	bne	a3,a5,ffffffffc0203782 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203798:	4501                	li	a0,0
}
ffffffffc020379a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020379c:	691c                	ld	a5,16(a0)
ffffffffc020379e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020377c <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc02037a2:	ea88                	sd	a0,16(a3)
ffffffffc02037a4:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02037a6:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc02037aa:	ea88                	sd	a0,16(a3)
ffffffffc02037ac:	8082                	ret

ffffffffc02037ae <do_pgfault>:
{
ffffffffc02037ae:	715d                	addi	sp,sp,-80
    uintptr_t fault_addr = ROUNDDOWN(addr, PGSIZE);// 页对齐的缺页地址
ffffffffc02037b0:	777d                	lui	a4,0xfffff
{
ffffffffc02037b2:	e0a2                	sd	s0,64(sp)
    pgfault_num++;
ffffffffc02037b4:	000bd797          	auipc	a5,0xbd
ffffffffc02037b8:	39c7a783          	lw	a5,924(a5) # ffffffffc02c0b50 <pgfault_num>
    uintptr_t fault_addr = ROUNDDOWN(addr, PGSIZE);// 页对齐的缺页地址
ffffffffc02037bc:	00e67433          	and	s0,a2,a4
{
ffffffffc02037c0:	fc26                	sd	s1,56(sp)
    pgfault_num++;
ffffffffc02037c2:	2785                	addiw	a5,a5,1
{
ffffffffc02037c4:	84ae                	mv	s1,a1
    struct vma_struct *vma = find_vma(mm, fault_addr);// 找到对应的 VMA
ffffffffc02037c6:	85a2                	mv	a1,s0
{
ffffffffc02037c8:	f44e                	sd	s3,40(sp)
ffffffffc02037ca:	e486                	sd	ra,72(sp)
ffffffffc02037cc:	f84a                	sd	s2,48(sp)
ffffffffc02037ce:	f052                	sd	s4,32(sp)
ffffffffc02037d0:	ec56                	sd	s5,24(sp)
ffffffffc02037d2:	e85a                	sd	s6,16(sp)
ffffffffc02037d4:	e45e                	sd	s7,8(sp)
ffffffffc02037d6:	89aa                	mv	s3,a0
    pgfault_num++;
ffffffffc02037d8:	000bd717          	auipc	a4,0xbd
ffffffffc02037dc:	36f72c23          	sw	a5,888(a4) # ffffffffc02c0b50 <pgfault_num>
    struct vma_struct *vma = find_vma(mm, fault_addr);// 找到对应的 VMA
ffffffffc02037e0:	f8fff0ef          	jal	ra,ffffffffc020376e <find_vma>
    if (vma == NULL || fault_addr < vma->vm_start)
ffffffffc02037e4:	12050263          	beqz	a0,ffffffffc0203908 <do_pgfault+0x15a>
ffffffffc02037e8:	651c                	ld	a5,8(a0)
ffffffffc02037ea:	10f46f63          	bltu	s0,a5,ffffffffc0203908 <do_pgfault+0x15a>
    if (is_store && !(vma->vm_flags & VM_WRITE))
ffffffffc02037ee:	473d                	li	a4,15
ffffffffc02037f0:	4d1c                	lw	a5,24(a0)
ffffffffc02037f2:	06e48c63          	beq	s1,a4,ffffffffc020386a <do_pgfault+0xbc>
    if (!is_store && !is_exec && !(vma->vm_flags & VM_READ))
ffffffffc02037f6:	4731                	li	a4,12
ffffffffc02037f8:	08e48463          	beq	s1,a4,ffffffffc0203880 <do_pgfault+0xd2>
ffffffffc02037fc:	0017f713          	andi	a4,a5,1
ffffffffc0203800:	10070463          	beqz	a4,ffffffffc0203908 <do_pgfault+0x15a>
    if (is_store && !(vma->vm_flags & VM_WRITE))
ffffffffc0203804:	0027f693          	andi	a3,a5,2
    if (is_exec && !(vma->vm_flags & VM_EXEC))
ffffffffc0203808:	0047f713          	andi	a4,a5,4
ffffffffc020380c:	4a01                	li	s4,0
        perm |= PTE_R;
ffffffffc020380e:	494d                	li	s2,19
    if (vm_flags & VM_WRITE)
ffffffffc0203810:	e6b5                	bnez	a3,ffffffffc020387c <do_pgfault+0xce>
    if (vm_flags & VM_EXEC)
ffffffffc0203812:	c319                	beqz	a4,ffffffffc0203818 <do_pgfault+0x6a>
        perm |= PTE_X;
ffffffffc0203814:	00896913          	ori	s2,s2,8
    pte_t *ptep = get_pte(mm->pgdir, fault_addr, 1);// 获取缺页地址对应的 PTE
ffffffffc0203818:	0189b503          	ld	a0,24(s3)
ffffffffc020381c:	4605                	li	a2,1
ffffffffc020381e:	85a2                	mv	a1,s0
ffffffffc0203820:	f7cfe0ef          	jal	ra,ffffffffc0201f9c <get_pte>
ffffffffc0203824:	87aa                	mv	a5,a0
    if (ptep == NULL)// 获取 PTE 失败
ffffffffc0203826:	1a050263          	beqz	a0,ffffffffc02039ca <do_pgfault+0x21c>
    if (*ptep & PTE_V)// 已映射
ffffffffc020382a:	6118                	ld	a4,0(a0)
ffffffffc020382c:	00177693          	andi	a3,a4,1
ffffffffc0203830:	c6a5                	beqz	a3,ffffffffc0203898 <do_pgfault+0xea>
        if (is_store && (*ptep & PTE_COW))// COW 写操作
ffffffffc0203832:	46bd                	li	a3,15
ffffffffc0203834:	0cd48263          	beq	s1,a3,ffffffffc02038f8 <do_pgfault+0x14a>
        if ((is_store && !(perm & PTE_W)) || (is_exec && !(perm & PTE_X)) || (!is_store && !is_exec && !(perm & PTE_R)))
ffffffffc0203838:	47b1                	li	a5,12
ffffffffc020383a:	00f49563          	bne	s1,a5,ffffffffc0203844 <do_pgfault+0x96>
ffffffffc020383e:	00897793          	andi	a5,s2,8
ffffffffc0203842:	c3f9                	beqz	a5,ffffffffc0203908 <do_pgfault+0x15a>
ffffffffc0203844:	000a1663          	bnez	s4,ffffffffc0203850 <do_pgfault+0xa2>
ffffffffc0203848:	00297913          	andi	s2,s2,2
ffffffffc020384c:	0a090e63          	beqz	s2,ffffffffc0203908 <do_pgfault+0x15a>
        return 0;
ffffffffc0203850:	4401                	li	s0,0
}
ffffffffc0203852:	60a6                	ld	ra,72(sp)
ffffffffc0203854:	8522                	mv	a0,s0
ffffffffc0203856:	6406                	ld	s0,64(sp)
ffffffffc0203858:	74e2                	ld	s1,56(sp)
ffffffffc020385a:	7942                	ld	s2,48(sp)
ffffffffc020385c:	79a2                	ld	s3,40(sp)
ffffffffc020385e:	7a02                	ld	s4,32(sp)
ffffffffc0203860:	6ae2                	ld	s5,24(sp)
ffffffffc0203862:	6b42                	ld	s6,16(sp)
ffffffffc0203864:	6ba2                	ld	s7,8(sp)
ffffffffc0203866:	6161                	addi	sp,sp,80
ffffffffc0203868:	8082                	ret
    if (is_store && !(vma->vm_flags & VM_WRITE))
ffffffffc020386a:	0027f693          	andi	a3,a5,2
ffffffffc020386e:	cec9                	beqz	a3,ffffffffc0203908 <do_pgfault+0x15a>
    if (vm_flags & VM_READ)
ffffffffc0203870:	0017f613          	andi	a2,a5,1
    if (is_exec && !(vma->vm_flags & VM_EXEC))
ffffffffc0203874:	0047f713          	andi	a4,a5,4
    if (vm_flags & VM_READ)
ffffffffc0203878:	4a05                	li	s4,1
ffffffffc020387a:	fa51                	bnez	a2,ffffffffc020380e <do_pgfault+0x60>
        perm |= (PTE_W | PTE_R);
ffffffffc020387c:	495d                	li	s2,23
ffffffffc020387e:	bf51                	j	ffffffffc0203812 <do_pgfault+0x64>
    if (is_exec && !(vma->vm_flags & VM_EXEC))
ffffffffc0203880:	0047f713          	andi	a4,a5,4
ffffffffc0203884:	c351                	beqz	a4,ffffffffc0203908 <do_pgfault+0x15a>
    if (vm_flags & VM_READ)
ffffffffc0203886:	0017f613          	andi	a2,a5,1
    if (is_store && !(vma->vm_flags & VM_WRITE))
ffffffffc020388a:	0027f693          	andi	a3,a5,2
    if (vm_flags & VM_READ)
ffffffffc020388e:	4a05                	li	s4,1
    uint32_t perm = PTE_U | PTE_V;
ffffffffc0203890:	4945                	li	s2,17
    if (vm_flags & VM_READ)
ffffffffc0203892:	fe35                	bnez	a2,ffffffffc020380e <do_pgfault+0x60>
    if (vm_flags & VM_WRITE)
ffffffffc0203894:	debd                	beqz	a3,ffffffffc0203812 <do_pgfault+0x64>
ffffffffc0203896:	b7dd                	j	ffffffffc020387c <do_pgfault+0xce>
    struct Page *page = alloc_page();
ffffffffc0203898:	4505                	li	a0,1
ffffffffc020389a:	e4afe0ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020389e:	84aa                	mv	s1,a0
    if (page == NULL)
ffffffffc02038a0:	12050563          	beqz	a0,ffffffffc02039ca <do_pgfault+0x21c>
    if (page_insert(mm->pgdir, page, fault_addr, perm) != 0)// 插入新页表项
ffffffffc02038a4:	0189b503          	ld	a0,24(s3)
ffffffffc02038a8:	8622                	mv	a2,s0
ffffffffc02038aa:	86ca                	mv	a3,s2
ffffffffc02038ac:	85a6                	mv	a1,s1
ffffffffc02038ae:	ddffe0ef          	jal	ra,ffffffffc020268c <page_insert>
ffffffffc02038b2:	842a                	mv	s0,a0
ffffffffc02038b4:	10051763          	bnez	a0,ffffffffc02039c2 <do_pgfault+0x214>
    return page - pages + nbase;
ffffffffc02038b8:	000bd697          	auipc	a3,0xbd
ffffffffc02038bc:	2806b683          	ld	a3,640(a3) # ffffffffc02c0b38 <pages>
ffffffffc02038c0:	40d486b3          	sub	a3,s1,a3
ffffffffc02038c4:	8699                	srai	a3,a3,0x6
ffffffffc02038c6:	00004517          	auipc	a0,0x4
ffffffffc02038ca:	1fa53503          	ld	a0,506(a0) # ffffffffc0207ac0 <nbase>
ffffffffc02038ce:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc02038d0:	00c69793          	slli	a5,a3,0xc
ffffffffc02038d4:	83b1                	srli	a5,a5,0xc
ffffffffc02038d6:	000bd717          	auipc	a4,0xbd
ffffffffc02038da:	25a73703          	ld	a4,602(a4) # ffffffffc02c0b30 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02038de:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02038e0:	0ee7f863          	bgeu	a5,a4,ffffffffc02039d0 <do_pgfault+0x222>
    memset(page2kva(page), 0, PGSIZE);// 新页清零
ffffffffc02038e4:	000bd517          	auipc	a0,0xbd
ffffffffc02038e8:	26453503          	ld	a0,612(a0) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc02038ec:	6605                	lui	a2,0x1
ffffffffc02038ee:	4581                	li	a1,0
ffffffffc02038f0:	9536                	add	a0,a0,a3
ffffffffc02038f2:	05a020ef          	jal	ra,ffffffffc020594c <memset>
    return 0;
ffffffffc02038f6:	bfb1                	j	ffffffffc0203852 <do_pgfault+0xa4>
        if (is_store && (*ptep & PTE_COW))// COW 写操作
ffffffffc02038f8:	10077693          	andi	a3,a4,256
ffffffffc02038fc:	ea81                	bnez	a3,ffffffffc020390c <do_pgfault+0x15e>
        if ((is_store && !(perm & PTE_W)) || (is_exec && !(perm & PTE_X)) || (!is_store && !is_exec && !(perm & PTE_R)))
ffffffffc02038fe:	00497913          	andi	s2,s2,4
        return 0;
ffffffffc0203902:	4401                	li	s0,0
        if ((is_store && !(perm & PTE_W)) || (is_exec && !(perm & PTE_X)) || (!is_store && !is_exec && !(perm & PTE_R)))
ffffffffc0203904:	f40917e3          	bnez	s2,ffffffffc0203852 <do_pgfault+0xa4>
            return -E_KILLED;
ffffffffc0203908:	545d                	li	s0,-9
ffffffffc020390a:	b7a1                	j	ffffffffc0203852 <do_pgfault+0xa4>
    if (PPN(pa) >= npage)
ffffffffc020390c:	000bdb17          	auipc	s6,0xbd
ffffffffc0203910:	224b0b13          	addi	s6,s6,548 # ffffffffc02c0b30 <npage>
ffffffffc0203914:	000b3603          	ld	a2,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203918:	00271693          	slli	a3,a4,0x2
ffffffffc020391c:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc020391e:	0cc6f563          	bgeu	a3,a2,ffffffffc02039e8 <do_pgfault+0x23a>
    return &pages[PPN(pa) - nbase];
ffffffffc0203922:	000bdb97          	auipc	s7,0xbd
ffffffffc0203926:	216b8b93          	addi	s7,s7,534 # ffffffffc02c0b38 <pages>
ffffffffc020392a:	000bb483          	ld	s1,0(s7)
ffffffffc020392e:	00004a97          	auipc	s5,0x4
ffffffffc0203932:	192aba83          	ld	s5,402(s5) # ffffffffc0207ac0 <nbase>
ffffffffc0203936:	415686b3          	sub	a3,a3,s5
ffffffffc020393a:	069a                	slli	a3,a3,0x6
ffffffffc020393c:	94b6                	add	s1,s1,a3
            if (page_ref(page) > 1)// 共享的物理页
ffffffffc020393e:	4090                	lw	a2,0(s1)
ffffffffc0203940:	4685                	li	a3,1
ffffffffc0203942:	06c6d463          	bge	a3,a2,ffffffffc02039aa <do_pgfault+0x1fc>
                struct Page *npage = alloc_page();
ffffffffc0203946:	4505                	li	a0,1
ffffffffc0203948:	d9cfe0ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc020394c:	8a2a                	mv	s4,a0
                if (npage == NULL)// 分配新物理页失败
ffffffffc020394e:	cd35                	beqz	a0,ffffffffc02039ca <do_pgfault+0x21c>
    return page - pages + nbase;
ffffffffc0203950:	000bb783          	ld	a5,0(s7)
    return KADDR(page2pa(page));
ffffffffc0203954:	577d                	li	a4,-1
ffffffffc0203956:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc020395a:	40f506b3          	sub	a3,a0,a5
ffffffffc020395e:	8699                	srai	a3,a3,0x6
ffffffffc0203960:	96d6                	add	a3,a3,s5
    return KADDR(page2pa(page));
ffffffffc0203962:	8331                	srli	a4,a4,0xc
ffffffffc0203964:	00e6f5b3          	and	a1,a3,a4
    return page2ppn(page) << PGSHIFT;
ffffffffc0203968:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020396a:	06c5f363          	bgeu	a1,a2,ffffffffc02039d0 <do_pgfault+0x222>
    return page - pages + nbase;
ffffffffc020396e:	40f487b3          	sub	a5,s1,a5
ffffffffc0203972:	8799                	srai	a5,a5,0x6
ffffffffc0203974:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0203976:	000bd597          	auipc	a1,0xbd
ffffffffc020397a:	1d25b583          	ld	a1,466(a1) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc020397e:	8f7d                	and	a4,a4,a5
ffffffffc0203980:	00b68533          	add	a0,a3,a1
    return page2ppn(page) << PGSHIFT;
ffffffffc0203984:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203986:	04c77463          	bgeu	a4,a2,ffffffffc02039ce <do_pgfault+0x220>
                memcpy(page2kva(npage), page2kva(page), PGSIZE);//把原来共享的物理页内容，复制到新分配的物理页
ffffffffc020398a:	95be                	add	a1,a1,a5
ffffffffc020398c:	6605                	lui	a2,0x1
ffffffffc020398e:	7d1010ef          	jal	ra,ffffffffc020595e <memcpy>
                page_insert(mm->pgdir, npage, fault_addr, (perm | PTE_W) & ~PTE_COW);//将新的物理页（npage）插入当前进程的页表中，并设置正确权限。
ffffffffc0203992:	0189b503          	ld	a0,24(s3)
ffffffffc0203996:	efb97693          	andi	a3,s2,-261
ffffffffc020399a:	8622                	mv	a2,s0
ffffffffc020399c:	0046e693          	ori	a3,a3,4
ffffffffc02039a0:	85d2                	mv	a1,s4
ffffffffc02039a2:	cebfe0ef          	jal	ra,ffffffffc020268c <page_insert>
            return 0;
ffffffffc02039a6:	4401                	li	s0,0
ffffffffc02039a8:	b56d                	j	ffffffffc0203852 <do_pgfault+0xa4>
                tlb_invalidate(mm->pgdir, fault_addr);//刷新 TLB
ffffffffc02039aa:	0189b503          	ld	a0,24(s3)
                *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc02039ae:	efb77713          	andi	a4,a4,-261
ffffffffc02039b2:	00476713          	ori	a4,a4,4
                tlb_invalidate(mm->pgdir, fault_addr);//刷新 TLB
ffffffffc02039b6:	85a2                	mv	a1,s0
                *ptep = (*ptep | PTE_W) & ~PTE_COW;
ffffffffc02039b8:	e398                	sd	a4,0(a5)
                tlb_invalidate(mm->pgdir, fault_addr);//刷新 TLB
ffffffffc02039ba:	c99ff0ef          	jal	ra,ffffffffc0203652 <tlb_invalidate>
            return 0;
ffffffffc02039be:	4401                	li	s0,0
ffffffffc02039c0:	bd49                	j	ffffffffc0203852 <do_pgfault+0xa4>
        free_page(page);
ffffffffc02039c2:	4585                	li	a1,1
ffffffffc02039c4:	8526                	mv	a0,s1
ffffffffc02039c6:	d5cfe0ef          	jal	ra,ffffffffc0201f22 <free_pages>
        return -E_NO_MEM;
ffffffffc02039ca:	5471                	li	s0,-4
ffffffffc02039cc:	b559                	j	ffffffffc0203852 <do_pgfault+0xa4>
ffffffffc02039ce:	86be                	mv	a3,a5
ffffffffc02039d0:	00003617          	auipc	a2,0x3
ffffffffc02039d4:	e2060613          	addi	a2,a2,-480 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc02039d8:	07100593          	li	a1,113
ffffffffc02039dc:	00003517          	auipc	a0,0x3
ffffffffc02039e0:	e3c50513          	addi	a0,a0,-452 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02039e4:	aabfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02039e8:	00003617          	auipc	a2,0x3
ffffffffc02039ec:	ed860613          	addi	a2,a2,-296 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc02039f0:	06900593          	li	a1,105
ffffffffc02039f4:	00003517          	auipc	a0,0x3
ffffffffc02039f8:	e2450513          	addi	a0,a0,-476 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02039fc:	a93fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a00 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203a00:	6590                	ld	a2,8(a1)
ffffffffc0203a02:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203a06:	1141                	addi	sp,sp,-16
ffffffffc0203a08:	e406                	sd	ra,8(sp)
ffffffffc0203a0a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203a0c:	01066763          	bltu	a2,a6,ffffffffc0203a1a <insert_vma_struct+0x1a>
ffffffffc0203a10:	a085                	j	ffffffffc0203a70 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203a12:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203a16:	04e66863          	bltu	a2,a4,ffffffffc0203a66 <insert_vma_struct+0x66>
ffffffffc0203a1a:	86be                	mv	a3,a5
ffffffffc0203a1c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203a1e:	fef51ae3          	bne	a0,a5,ffffffffc0203a12 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0203a22:	02a68463          	beq	a3,a0,ffffffffc0203a4a <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203a26:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203a2a:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203a2e:	08e8f163          	bgeu	a7,a4,ffffffffc0203ab0 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203a32:	04e66f63          	bltu	a2,a4,ffffffffc0203a90 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203a36:	00f50a63          	beq	a0,a5,ffffffffc0203a4a <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203a3a:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203a3e:	05076963          	bltu	a4,a6,ffffffffc0203a90 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0203a42:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203a46:	02c77363          	bgeu	a4,a2,ffffffffc0203a6c <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203a4a:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203a4c:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203a4e:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0203a52:	e390                	sd	a2,0(a5)
ffffffffc0203a54:	e690                	sd	a2,8(a3)
}
ffffffffc0203a56:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203a58:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203a5a:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203a5c:	0017079b          	addiw	a5,a4,1
ffffffffc0203a60:	d11c                	sw	a5,32(a0)
}
ffffffffc0203a62:	0141                	addi	sp,sp,16
ffffffffc0203a64:	8082                	ret
    if (le_prev != list)
ffffffffc0203a66:	fca690e3          	bne	a3,a0,ffffffffc0203a26 <insert_vma_struct+0x26>
ffffffffc0203a6a:	bfd1                	j	ffffffffc0203a3e <insert_vma_struct+0x3e>
ffffffffc0203a6c:	cafff0ef          	jal	ra,ffffffffc020371a <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203a70:	00003697          	auipc	a3,0x3
ffffffffc0203a74:	50068693          	addi	a3,a3,1280 # ffffffffc0206f70 <default_pmm_manager+0x7b8>
ffffffffc0203a78:	00003617          	auipc	a2,0x3
ffffffffc0203a7c:	99060613          	addi	a2,a2,-1648 # ffffffffc0206408 <commands+0x828>
ffffffffc0203a80:	0de00593          	li	a1,222
ffffffffc0203a84:	00003517          	auipc	a0,0x3
ffffffffc0203a88:	4dc50513          	addi	a0,a0,1244 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203a8c:	a03fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203a90:	00003697          	auipc	a3,0x3
ffffffffc0203a94:	52068693          	addi	a3,a3,1312 # ffffffffc0206fb0 <default_pmm_manager+0x7f8>
ffffffffc0203a98:	00003617          	auipc	a2,0x3
ffffffffc0203a9c:	97060613          	addi	a2,a2,-1680 # ffffffffc0206408 <commands+0x828>
ffffffffc0203aa0:	0d700593          	li	a1,215
ffffffffc0203aa4:	00003517          	auipc	a0,0x3
ffffffffc0203aa8:	4bc50513          	addi	a0,a0,1212 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203aac:	9e3fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203ab0:	00003697          	auipc	a3,0x3
ffffffffc0203ab4:	4e068693          	addi	a3,a3,1248 # ffffffffc0206f90 <default_pmm_manager+0x7d8>
ffffffffc0203ab8:	00003617          	auipc	a2,0x3
ffffffffc0203abc:	95060613          	addi	a2,a2,-1712 # ffffffffc0206408 <commands+0x828>
ffffffffc0203ac0:	0d600593          	li	a1,214
ffffffffc0203ac4:	00003517          	auipc	a0,0x3
ffffffffc0203ac8:	49c50513          	addi	a0,a0,1180 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203acc:	9c3fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203ad0 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0203ad0:	591c                	lw	a5,48(a0)
{
ffffffffc0203ad2:	1141                	addi	sp,sp,-16
ffffffffc0203ad4:	e406                	sd	ra,8(sp)
ffffffffc0203ad6:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203ad8:	e78d                	bnez	a5,ffffffffc0203b02 <mm_destroy+0x32>
ffffffffc0203ada:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203adc:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0203ade:	00a40c63          	beq	s0,a0,ffffffffc0203af6 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203ae2:	6118                	ld	a4,0(a0)
ffffffffc0203ae4:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203ae6:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203ae8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203aea:	e398                	sd	a4,0(a5)
ffffffffc0203aec:	acafe0ef          	jal	ra,ffffffffc0201db6 <kfree>
    return listelm->next;
ffffffffc0203af0:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0203af2:	fea418e3          	bne	s0,a0,ffffffffc0203ae2 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203af6:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203af8:	6402                	ld	s0,0(sp)
ffffffffc0203afa:	60a2                	ld	ra,8(sp)
ffffffffc0203afc:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0203afe:	ab8fe06f          	j	ffffffffc0201db6 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0203b02:	00003697          	auipc	a3,0x3
ffffffffc0203b06:	4ce68693          	addi	a3,a3,1230 # ffffffffc0206fd0 <default_pmm_manager+0x818>
ffffffffc0203b0a:	00003617          	auipc	a2,0x3
ffffffffc0203b0e:	8fe60613          	addi	a2,a2,-1794 # ffffffffc0206408 <commands+0x828>
ffffffffc0203b12:	10200593          	li	a1,258
ffffffffc0203b16:	00003517          	auipc	a0,0x3
ffffffffc0203b1a:	44a50513          	addi	a0,a0,1098 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203b1e:	971fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203b22 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc0203b22:	7139                	addi	sp,sp,-64
ffffffffc0203b24:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203b26:	6405                	lui	s0,0x1
ffffffffc0203b28:	147d                	addi	s0,s0,-1
ffffffffc0203b2a:	77fd                	lui	a5,0xfffff
ffffffffc0203b2c:	9622                	add	a2,a2,s0
ffffffffc0203b2e:	962e                	add	a2,a2,a1
{
ffffffffc0203b30:	f426                	sd	s1,40(sp)
ffffffffc0203b32:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203b34:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203b38:	f04a                	sd	s2,32(sp)
ffffffffc0203b3a:	ec4e                	sd	s3,24(sp)
ffffffffc0203b3c:	e852                	sd	s4,16(sp)
ffffffffc0203b3e:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203b40:	002005b7          	lui	a1,0x200
ffffffffc0203b44:	00f67433          	and	s0,a2,a5
ffffffffc0203b48:	06b4e363          	bltu	s1,a1,ffffffffc0203bae <mm_map+0x8c>
ffffffffc0203b4c:	0684f163          	bgeu	s1,s0,ffffffffc0203bae <mm_map+0x8c>
ffffffffc0203b50:	4785                	li	a5,1
ffffffffc0203b52:	07fe                	slli	a5,a5,0x1f
ffffffffc0203b54:	0487ed63          	bltu	a5,s0,ffffffffc0203bae <mm_map+0x8c>
ffffffffc0203b58:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203b5a:	cd21                	beqz	a0,ffffffffc0203bb2 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203b5c:	85a6                	mv	a1,s1
ffffffffc0203b5e:	8ab6                	mv	s5,a3
ffffffffc0203b60:	8a3a                	mv	s4,a4
ffffffffc0203b62:	c0dff0ef          	jal	ra,ffffffffc020376e <find_vma>
ffffffffc0203b66:	c501                	beqz	a0,ffffffffc0203b6e <mm_map+0x4c>
ffffffffc0203b68:	651c                	ld	a5,8(a0)
ffffffffc0203b6a:	0487e263          	bltu	a5,s0,ffffffffc0203bae <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b6e:	03000513          	li	a0,48
ffffffffc0203b72:	994fe0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
ffffffffc0203b76:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203b78:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203b7a:	02090163          	beqz	s2,ffffffffc0203b9c <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203b7e:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203b80:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0203b84:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203b88:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203b8c:	85ca                	mv	a1,s2
ffffffffc0203b8e:	e73ff0ef          	jal	ra,ffffffffc0203a00 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0203b92:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0203b94:	000a0463          	beqz	s4,ffffffffc0203b9c <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203b98:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0203b9c:	70e2                	ld	ra,56(sp)
ffffffffc0203b9e:	7442                	ld	s0,48(sp)
ffffffffc0203ba0:	74a2                	ld	s1,40(sp)
ffffffffc0203ba2:	7902                	ld	s2,32(sp)
ffffffffc0203ba4:	69e2                	ld	s3,24(sp)
ffffffffc0203ba6:	6a42                	ld	s4,16(sp)
ffffffffc0203ba8:	6aa2                	ld	s5,8(sp)
ffffffffc0203baa:	6121                	addi	sp,sp,64
ffffffffc0203bac:	8082                	ret
        return -E_INVAL;
ffffffffc0203bae:	5575                	li	a0,-3
ffffffffc0203bb0:	b7f5                	j	ffffffffc0203b9c <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0203bb2:	00003697          	auipc	a3,0x3
ffffffffc0203bb6:	43668693          	addi	a3,a3,1078 # ffffffffc0206fe8 <default_pmm_manager+0x830>
ffffffffc0203bba:	00003617          	auipc	a2,0x3
ffffffffc0203bbe:	84e60613          	addi	a2,a2,-1970 # ffffffffc0206408 <commands+0x828>
ffffffffc0203bc2:	11700593          	li	a1,279
ffffffffc0203bc6:	00003517          	auipc	a0,0x3
ffffffffc0203bca:	39a50513          	addi	a0,a0,922 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203bce:	8c1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203bd2 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0203bd2:	7139                	addi	sp,sp,-64
ffffffffc0203bd4:	fc06                	sd	ra,56(sp)
ffffffffc0203bd6:	f822                	sd	s0,48(sp)
ffffffffc0203bd8:	f426                	sd	s1,40(sp)
ffffffffc0203bda:	f04a                	sd	s2,32(sp)
ffffffffc0203bdc:	ec4e                	sd	s3,24(sp)
ffffffffc0203bde:	e852                	sd	s4,16(sp)
ffffffffc0203be0:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0203be2:	c92d                	beqz	a0,ffffffffc0203c54 <dup_mmap+0x82>
ffffffffc0203be4:	892a                	mv	s2,a0
ffffffffc0203be6:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203be8:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203bea:	e995                	bnez	a1,ffffffffc0203c1e <dup_mmap+0x4c>
ffffffffc0203bec:	a0a5                	j	ffffffffc0203c54 <dup_mmap+0x82>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0203bee:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0203bf0:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_proc_suite_out_size+0x1f4690>
        vma->vm_end = vm_end;
ffffffffc0203bf4:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203bf8:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203bfc:	e05ff0ef          	jal	ra,ffffffffc0203a00 <insert_vma_struct>

        bool share = (vma->vm_flags & VM_WRITE) != 0; // writable regions use COW
ffffffffc0203c00:	ff842703          	lw	a4,-8(s0) # ff8 <_binary_obj___user_faultread_out_size-0x8bb8>
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203c04:	ff043683          	ld	a3,-16(s0)
ffffffffc0203c08:	fe843603          	ld	a2,-24(s0)
ffffffffc0203c0c:	6c8c                	ld	a1,24(s1)
ffffffffc0203c0e:	01893503          	ld	a0,24(s2)
        bool share = (vma->vm_flags & VM_WRITE) != 0; // writable regions use COW
ffffffffc0203c12:	4017571b          	sraiw	a4,a4,0x1
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0203c16:	8b05                	andi	a4,a4,1
ffffffffc0203c18:	faaff0ef          	jal	ra,ffffffffc02033c2 <copy_range>
ffffffffc0203c1c:	e105                	bnez	a0,ffffffffc0203c3c <dup_mmap+0x6a>
    return listelm->prev;
ffffffffc0203c1e:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203c20:	02848863          	beq	s1,s0,ffffffffc0203c50 <dup_mmap+0x7e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c24:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203c28:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203c2c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203c30:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203c34:	8d2fe0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
ffffffffc0203c38:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203c3a:	f955                	bnez	a0,ffffffffc0203bee <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203c3c:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203c3e:	70e2                	ld	ra,56(sp)
ffffffffc0203c40:	7442                	ld	s0,48(sp)
ffffffffc0203c42:	74a2                	ld	s1,40(sp)
ffffffffc0203c44:	7902                	ld	s2,32(sp)
ffffffffc0203c46:	69e2                	ld	s3,24(sp)
ffffffffc0203c48:	6a42                	ld	s4,16(sp)
ffffffffc0203c4a:	6aa2                	ld	s5,8(sp)
ffffffffc0203c4c:	6121                	addi	sp,sp,64
ffffffffc0203c4e:	8082                	ret
    return 0;
ffffffffc0203c50:	4501                	li	a0,0
ffffffffc0203c52:	b7f5                	j	ffffffffc0203c3e <dup_mmap+0x6c>
    assert(to != NULL && from != NULL);
ffffffffc0203c54:	00003697          	auipc	a3,0x3
ffffffffc0203c58:	3a468693          	addi	a3,a3,932 # ffffffffc0206ff8 <default_pmm_manager+0x840>
ffffffffc0203c5c:	00002617          	auipc	a2,0x2
ffffffffc0203c60:	7ac60613          	addi	a2,a2,1964 # ffffffffc0206408 <commands+0x828>
ffffffffc0203c64:	13300593          	li	a1,307
ffffffffc0203c68:	00003517          	auipc	a0,0x3
ffffffffc0203c6c:	2f850513          	addi	a0,a0,760 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203c70:	81ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203c74 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203c74:	1101                	addi	sp,sp,-32
ffffffffc0203c76:	ec06                	sd	ra,24(sp)
ffffffffc0203c78:	e822                	sd	s0,16(sp)
ffffffffc0203c7a:	e426                	sd	s1,8(sp)
ffffffffc0203c7c:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203c7e:	c531                	beqz	a0,ffffffffc0203cca <exit_mmap+0x56>
ffffffffc0203c80:	591c                	lw	a5,48(a0)
ffffffffc0203c82:	84aa                	mv	s1,a0
ffffffffc0203c84:	e3b9                	bnez	a5,ffffffffc0203cca <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203c86:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203c88:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203c8c:	02850663          	beq	a0,s0,ffffffffc0203cb8 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203c90:	ff043603          	ld	a2,-16(s0)
ffffffffc0203c94:	fe843583          	ld	a1,-24(s0)
ffffffffc0203c98:	854a                	mv	a0,s2
ffffffffc0203c9a:	d7efe0ef          	jal	ra,ffffffffc0202218 <unmap_range>
ffffffffc0203c9e:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203ca0:	fe8498e3          	bne	s1,s0,ffffffffc0203c90 <exit_mmap+0x1c>
ffffffffc0203ca4:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203ca6:	00848c63          	beq	s1,s0,ffffffffc0203cbe <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203caa:	ff043603          	ld	a2,-16(s0)
ffffffffc0203cae:	fe843583          	ld	a1,-24(s0)
ffffffffc0203cb2:	854a                	mv	a0,s2
ffffffffc0203cb4:	eaafe0ef          	jal	ra,ffffffffc020235e <exit_range>
ffffffffc0203cb8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203cba:	fe8498e3          	bne	s1,s0,ffffffffc0203caa <exit_mmap+0x36>
    }
}
ffffffffc0203cbe:	60e2                	ld	ra,24(sp)
ffffffffc0203cc0:	6442                	ld	s0,16(sp)
ffffffffc0203cc2:	64a2                	ld	s1,8(sp)
ffffffffc0203cc4:	6902                	ld	s2,0(sp)
ffffffffc0203cc6:	6105                	addi	sp,sp,32
ffffffffc0203cc8:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203cca:	00003697          	auipc	a3,0x3
ffffffffc0203cce:	34e68693          	addi	a3,a3,846 # ffffffffc0207018 <default_pmm_manager+0x860>
ffffffffc0203cd2:	00002617          	auipc	a2,0x2
ffffffffc0203cd6:	73660613          	addi	a2,a2,1846 # ffffffffc0206408 <commands+0x828>
ffffffffc0203cda:	14c00593          	li	a1,332
ffffffffc0203cde:	00003517          	auipc	a0,0x3
ffffffffc0203ce2:	28250513          	addi	a0,a0,642 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203ce6:	fa8fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203cea <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203cea:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203cec:	04000513          	li	a0,64
{
ffffffffc0203cf0:	fc06                	sd	ra,56(sp)
ffffffffc0203cf2:	f822                	sd	s0,48(sp)
ffffffffc0203cf4:	f426                	sd	s1,40(sp)
ffffffffc0203cf6:	f04a                	sd	s2,32(sp)
ffffffffc0203cf8:	ec4e                	sd	s3,24(sp)
ffffffffc0203cfa:	e852                	sd	s4,16(sp)
ffffffffc0203cfc:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203cfe:	808fe0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
    if (mm != NULL)
ffffffffc0203d02:	2e050663          	beqz	a0,ffffffffc0203fee <vmm_init+0x304>
ffffffffc0203d06:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203d08:	e508                	sd	a0,8(a0)
ffffffffc0203d0a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203d0c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203d10:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203d14:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203d18:	02053423          	sd	zero,40(a0)
ffffffffc0203d1c:	02052823          	sw	zero,48(a0)
ffffffffc0203d20:	02053c23          	sd	zero,56(a0)
ffffffffc0203d24:	03200413          	li	s0,50
ffffffffc0203d28:	a811                	j	ffffffffc0203d3c <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203d2a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203d2c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203d2e:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203d32:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203d34:	8526                	mv	a0,s1
ffffffffc0203d36:	ccbff0ef          	jal	ra,ffffffffc0203a00 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203d3a:	c80d                	beqz	s0,ffffffffc0203d6c <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203d3c:	03000513          	li	a0,48
ffffffffc0203d40:	fc7fd0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
ffffffffc0203d44:	85aa                	mv	a1,a0
ffffffffc0203d46:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203d4a:	f165                	bnez	a0,ffffffffc0203d2a <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203d4c:	00003697          	auipc	a3,0x3
ffffffffc0203d50:	46468693          	addi	a3,a3,1124 # ffffffffc02071b0 <default_pmm_manager+0x9f8>
ffffffffc0203d54:	00002617          	auipc	a2,0x2
ffffffffc0203d58:	6b460613          	addi	a2,a2,1716 # ffffffffc0206408 <commands+0x828>
ffffffffc0203d5c:	19000593          	li	a1,400
ffffffffc0203d60:	00003517          	auipc	a0,0x3
ffffffffc0203d64:	20050513          	addi	a0,a0,512 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203d68:	f26fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203d6c:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d70:	1f900913          	li	s2,505
ffffffffc0203d74:	a819                	j	ffffffffc0203d8a <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203d76:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203d78:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203d7a:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d7e:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203d80:	8526                	mv	a0,s1
ffffffffc0203d82:	c7fff0ef          	jal	ra,ffffffffc0203a00 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203d86:	03240a63          	beq	s0,s2,ffffffffc0203dba <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203d8a:	03000513          	li	a0,48
ffffffffc0203d8e:	f79fd0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
ffffffffc0203d92:	85aa                	mv	a1,a0
ffffffffc0203d94:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203d98:	fd79                	bnez	a0,ffffffffc0203d76 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203d9a:	00003697          	auipc	a3,0x3
ffffffffc0203d9e:	41668693          	addi	a3,a3,1046 # ffffffffc02071b0 <default_pmm_manager+0x9f8>
ffffffffc0203da2:	00002617          	auipc	a2,0x2
ffffffffc0203da6:	66660613          	addi	a2,a2,1638 # ffffffffc0206408 <commands+0x828>
ffffffffc0203daa:	19700593          	li	a1,407
ffffffffc0203dae:	00003517          	auipc	a0,0x3
ffffffffc0203db2:	1b250513          	addi	a0,a0,434 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203db6:	ed8fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203dba:	649c                	ld	a5,8(s1)
ffffffffc0203dbc:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203dbe:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203dc2:	16f48663          	beq	s1,a5,ffffffffc0203f2e <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203dc6:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd3e474>
ffffffffc0203dca:	ffe70693          	addi	a3,a4,-2
ffffffffc0203dce:	10d61063          	bne	a2,a3,ffffffffc0203ece <vmm_init+0x1e4>
ffffffffc0203dd2:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203dd6:	0ed71c63          	bne	a4,a3,ffffffffc0203ece <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203dda:	0715                	addi	a4,a4,5
ffffffffc0203ddc:	679c                	ld	a5,8(a5)
ffffffffc0203dde:	feb712e3          	bne	a4,a1,ffffffffc0203dc2 <vmm_init+0xd8>
ffffffffc0203de2:	4a1d                	li	s4,7
ffffffffc0203de4:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203de6:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203dea:	85a2                	mv	a1,s0
ffffffffc0203dec:	8526                	mv	a0,s1
ffffffffc0203dee:	981ff0ef          	jal	ra,ffffffffc020376e <find_vma>
ffffffffc0203df2:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203df4:	16050d63          	beqz	a0,ffffffffc0203f6e <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203df8:	00140593          	addi	a1,s0,1
ffffffffc0203dfc:	8526                	mv	a0,s1
ffffffffc0203dfe:	971ff0ef          	jal	ra,ffffffffc020376e <find_vma>
ffffffffc0203e02:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203e04:	14050563          	beqz	a0,ffffffffc0203f4e <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203e08:	85d2                	mv	a1,s4
ffffffffc0203e0a:	8526                	mv	a0,s1
ffffffffc0203e0c:	963ff0ef          	jal	ra,ffffffffc020376e <find_vma>
        assert(vma3 == NULL);
ffffffffc0203e10:	16051f63          	bnez	a0,ffffffffc0203f8e <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203e14:	00340593          	addi	a1,s0,3
ffffffffc0203e18:	8526                	mv	a0,s1
ffffffffc0203e1a:	955ff0ef          	jal	ra,ffffffffc020376e <find_vma>
        assert(vma4 == NULL);
ffffffffc0203e1e:	1a051863          	bnez	a0,ffffffffc0203fce <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203e22:	00440593          	addi	a1,s0,4
ffffffffc0203e26:	8526                	mv	a0,s1
ffffffffc0203e28:	947ff0ef          	jal	ra,ffffffffc020376e <find_vma>
        assert(vma5 == NULL);
ffffffffc0203e2c:	18051163          	bnez	a0,ffffffffc0203fae <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203e30:	00893783          	ld	a5,8(s2)
ffffffffc0203e34:	0a879d63          	bne	a5,s0,ffffffffc0203eee <vmm_init+0x204>
ffffffffc0203e38:	01093783          	ld	a5,16(s2)
ffffffffc0203e3c:	0b479963          	bne	a5,s4,ffffffffc0203eee <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203e40:	0089b783          	ld	a5,8(s3)
ffffffffc0203e44:	0c879563          	bne	a5,s0,ffffffffc0203f0e <vmm_init+0x224>
ffffffffc0203e48:	0109b783          	ld	a5,16(s3)
ffffffffc0203e4c:	0d479163          	bne	a5,s4,ffffffffc0203f0e <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203e50:	0415                	addi	s0,s0,5
ffffffffc0203e52:	0a15                	addi	s4,s4,5
ffffffffc0203e54:	f9541be3          	bne	s0,s5,ffffffffc0203dea <vmm_init+0x100>
ffffffffc0203e58:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203e5a:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203e5c:	85a2                	mv	a1,s0
ffffffffc0203e5e:	8526                	mv	a0,s1
ffffffffc0203e60:	90fff0ef          	jal	ra,ffffffffc020376e <find_vma>
ffffffffc0203e64:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203e68:	c90d                	beqz	a0,ffffffffc0203e9a <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203e6a:	6914                	ld	a3,16(a0)
ffffffffc0203e6c:	6510                	ld	a2,8(a0)
ffffffffc0203e6e:	00003517          	auipc	a0,0x3
ffffffffc0203e72:	2ca50513          	addi	a0,a0,714 # ffffffffc0207138 <default_pmm_manager+0x980>
ffffffffc0203e76:	b1efc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203e7a:	00003697          	auipc	a3,0x3
ffffffffc0203e7e:	2e668693          	addi	a3,a3,742 # ffffffffc0207160 <default_pmm_manager+0x9a8>
ffffffffc0203e82:	00002617          	auipc	a2,0x2
ffffffffc0203e86:	58660613          	addi	a2,a2,1414 # ffffffffc0206408 <commands+0x828>
ffffffffc0203e8a:	1bd00593          	li	a1,445
ffffffffc0203e8e:	00003517          	auipc	a0,0x3
ffffffffc0203e92:	0d250513          	addi	a0,a0,210 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203e96:	df8fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203e9a:	147d                	addi	s0,s0,-1
ffffffffc0203e9c:	fd2410e3          	bne	s0,s2,ffffffffc0203e5c <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203ea0:	8526                	mv	a0,s1
ffffffffc0203ea2:	c2fff0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203ea6:	00003517          	auipc	a0,0x3
ffffffffc0203eaa:	2d250513          	addi	a0,a0,722 # ffffffffc0207178 <default_pmm_manager+0x9c0>
ffffffffc0203eae:	ae6fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203eb2:	7442                	ld	s0,48(sp)
ffffffffc0203eb4:	70e2                	ld	ra,56(sp)
ffffffffc0203eb6:	74a2                	ld	s1,40(sp)
ffffffffc0203eb8:	7902                	ld	s2,32(sp)
ffffffffc0203eba:	69e2                	ld	s3,24(sp)
ffffffffc0203ebc:	6a42                	ld	s4,16(sp)
ffffffffc0203ebe:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203ec0:	00003517          	auipc	a0,0x3
ffffffffc0203ec4:	2d850513          	addi	a0,a0,728 # ffffffffc0207198 <default_pmm_manager+0x9e0>
}
ffffffffc0203ec8:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203eca:	acafc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203ece:	00003697          	auipc	a3,0x3
ffffffffc0203ed2:	18268693          	addi	a3,a3,386 # ffffffffc0207050 <default_pmm_manager+0x898>
ffffffffc0203ed6:	00002617          	auipc	a2,0x2
ffffffffc0203eda:	53260613          	addi	a2,a2,1330 # ffffffffc0206408 <commands+0x828>
ffffffffc0203ede:	1a100593          	li	a1,417
ffffffffc0203ee2:	00003517          	auipc	a0,0x3
ffffffffc0203ee6:	07e50513          	addi	a0,a0,126 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203eea:	da4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203eee:	00003697          	auipc	a3,0x3
ffffffffc0203ef2:	1ea68693          	addi	a3,a3,490 # ffffffffc02070d8 <default_pmm_manager+0x920>
ffffffffc0203ef6:	00002617          	auipc	a2,0x2
ffffffffc0203efa:	51260613          	addi	a2,a2,1298 # ffffffffc0206408 <commands+0x828>
ffffffffc0203efe:	1b200593          	li	a1,434
ffffffffc0203f02:	00003517          	auipc	a0,0x3
ffffffffc0203f06:	05e50513          	addi	a0,a0,94 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203f0a:	d84fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203f0e:	00003697          	auipc	a3,0x3
ffffffffc0203f12:	1fa68693          	addi	a3,a3,506 # ffffffffc0207108 <default_pmm_manager+0x950>
ffffffffc0203f16:	00002617          	auipc	a2,0x2
ffffffffc0203f1a:	4f260613          	addi	a2,a2,1266 # ffffffffc0206408 <commands+0x828>
ffffffffc0203f1e:	1b300593          	li	a1,435
ffffffffc0203f22:	00003517          	auipc	a0,0x3
ffffffffc0203f26:	03e50513          	addi	a0,a0,62 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203f2a:	d64fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203f2e:	00003697          	auipc	a3,0x3
ffffffffc0203f32:	10a68693          	addi	a3,a3,266 # ffffffffc0207038 <default_pmm_manager+0x880>
ffffffffc0203f36:	00002617          	auipc	a2,0x2
ffffffffc0203f3a:	4d260613          	addi	a2,a2,1234 # ffffffffc0206408 <commands+0x828>
ffffffffc0203f3e:	19f00593          	li	a1,415
ffffffffc0203f42:	00003517          	auipc	a0,0x3
ffffffffc0203f46:	01e50513          	addi	a0,a0,30 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203f4a:	d44fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203f4e:	00003697          	auipc	a3,0x3
ffffffffc0203f52:	14a68693          	addi	a3,a3,330 # ffffffffc0207098 <default_pmm_manager+0x8e0>
ffffffffc0203f56:	00002617          	auipc	a2,0x2
ffffffffc0203f5a:	4b260613          	addi	a2,a2,1202 # ffffffffc0206408 <commands+0x828>
ffffffffc0203f5e:	1aa00593          	li	a1,426
ffffffffc0203f62:	00003517          	auipc	a0,0x3
ffffffffc0203f66:	ffe50513          	addi	a0,a0,-2 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203f6a:	d24fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203f6e:	00003697          	auipc	a3,0x3
ffffffffc0203f72:	11a68693          	addi	a3,a3,282 # ffffffffc0207088 <default_pmm_manager+0x8d0>
ffffffffc0203f76:	00002617          	auipc	a2,0x2
ffffffffc0203f7a:	49260613          	addi	a2,a2,1170 # ffffffffc0206408 <commands+0x828>
ffffffffc0203f7e:	1a800593          	li	a1,424
ffffffffc0203f82:	00003517          	auipc	a0,0x3
ffffffffc0203f86:	fde50513          	addi	a0,a0,-34 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203f8a:	d04fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203f8e:	00003697          	auipc	a3,0x3
ffffffffc0203f92:	11a68693          	addi	a3,a3,282 # ffffffffc02070a8 <default_pmm_manager+0x8f0>
ffffffffc0203f96:	00002617          	auipc	a2,0x2
ffffffffc0203f9a:	47260613          	addi	a2,a2,1138 # ffffffffc0206408 <commands+0x828>
ffffffffc0203f9e:	1ac00593          	li	a1,428
ffffffffc0203fa2:	00003517          	auipc	a0,0x3
ffffffffc0203fa6:	fbe50513          	addi	a0,a0,-66 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203faa:	ce4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203fae:	00003697          	auipc	a3,0x3
ffffffffc0203fb2:	11a68693          	addi	a3,a3,282 # ffffffffc02070c8 <default_pmm_manager+0x910>
ffffffffc0203fb6:	00002617          	auipc	a2,0x2
ffffffffc0203fba:	45260613          	addi	a2,a2,1106 # ffffffffc0206408 <commands+0x828>
ffffffffc0203fbe:	1b000593          	li	a1,432
ffffffffc0203fc2:	00003517          	auipc	a0,0x3
ffffffffc0203fc6:	f9e50513          	addi	a0,a0,-98 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203fca:	cc4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203fce:	00003697          	auipc	a3,0x3
ffffffffc0203fd2:	0ea68693          	addi	a3,a3,234 # ffffffffc02070b8 <default_pmm_manager+0x900>
ffffffffc0203fd6:	00002617          	auipc	a2,0x2
ffffffffc0203fda:	43260613          	addi	a2,a2,1074 # ffffffffc0206408 <commands+0x828>
ffffffffc0203fde:	1ae00593          	li	a1,430
ffffffffc0203fe2:	00003517          	auipc	a0,0x3
ffffffffc0203fe6:	f7e50513          	addi	a0,a0,-130 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc0203fea:	ca4fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203fee:	00003697          	auipc	a3,0x3
ffffffffc0203ff2:	ffa68693          	addi	a3,a3,-6 # ffffffffc0206fe8 <default_pmm_manager+0x830>
ffffffffc0203ff6:	00002617          	auipc	a2,0x2
ffffffffc0203ffa:	41260613          	addi	a2,a2,1042 # ffffffffc0206408 <commands+0x828>
ffffffffc0203ffe:	18800593          	li	a1,392
ffffffffc0204002:	00003517          	auipc	a0,0x3
ffffffffc0204006:	f5e50513          	addi	a0,a0,-162 # ffffffffc0206f60 <default_pmm_manager+0x7a8>
ffffffffc020400a:	c84fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020400e <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc020400e:	7179                	addi	sp,sp,-48
ffffffffc0204010:	f022                	sd	s0,32(sp)
ffffffffc0204012:	f406                	sd	ra,40(sp)
ffffffffc0204014:	ec26                	sd	s1,24(sp)
ffffffffc0204016:	e84a                	sd	s2,16(sp)
ffffffffc0204018:	e44e                	sd	s3,8(sp)
ffffffffc020401a:	e052                	sd	s4,0(sp)
ffffffffc020401c:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc020401e:	c135                	beqz	a0,ffffffffc0204082 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0204020:	002007b7          	lui	a5,0x200
ffffffffc0204024:	04f5e663          	bltu	a1,a5,ffffffffc0204070 <user_mem_check+0x62>
ffffffffc0204028:	00c584b3          	add	s1,a1,a2
ffffffffc020402c:	0495f263          	bgeu	a1,s1,ffffffffc0204070 <user_mem_check+0x62>
ffffffffc0204030:	4785                	li	a5,1
ffffffffc0204032:	07fe                	slli	a5,a5,0x1f
ffffffffc0204034:	0297ee63          	bltu	a5,s1,ffffffffc0204070 <user_mem_check+0x62>
ffffffffc0204038:	892a                	mv	s2,a0
ffffffffc020403a:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc020403c:	6a05                	lui	s4,0x1
ffffffffc020403e:	a821                	j	ffffffffc0204056 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0204040:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0204044:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0204046:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0204048:	c685                	beqz	a3,ffffffffc0204070 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc020404a:	c399                	beqz	a5,ffffffffc0204050 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc020404c:	02e46263          	bltu	s0,a4,ffffffffc0204070 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0204050:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0204052:	04947663          	bgeu	s0,s1,ffffffffc020409e <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0204056:	85a2                	mv	a1,s0
ffffffffc0204058:	854a                	mv	a0,s2
ffffffffc020405a:	f14ff0ef          	jal	ra,ffffffffc020376e <find_vma>
ffffffffc020405e:	c909                	beqz	a0,ffffffffc0204070 <user_mem_check+0x62>
ffffffffc0204060:	6518                	ld	a4,8(a0)
ffffffffc0204062:	00e46763          	bltu	s0,a4,ffffffffc0204070 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0204066:	4d1c                	lw	a5,24(a0)
ffffffffc0204068:	fc099ce3          	bnez	s3,ffffffffc0204040 <user_mem_check+0x32>
ffffffffc020406c:	8b85                	andi	a5,a5,1
ffffffffc020406e:	f3ed                	bnez	a5,ffffffffc0204050 <user_mem_check+0x42>
            return 0;
ffffffffc0204070:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0204072:	70a2                	ld	ra,40(sp)
ffffffffc0204074:	7402                	ld	s0,32(sp)
ffffffffc0204076:	64e2                	ld	s1,24(sp)
ffffffffc0204078:	6942                	ld	s2,16(sp)
ffffffffc020407a:	69a2                	ld	s3,8(sp)
ffffffffc020407c:	6a02                	ld	s4,0(sp)
ffffffffc020407e:	6145                	addi	sp,sp,48
ffffffffc0204080:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0204082:	c02007b7          	lui	a5,0xc0200
ffffffffc0204086:	4501                	li	a0,0
ffffffffc0204088:	fef5e5e3          	bltu	a1,a5,ffffffffc0204072 <user_mem_check+0x64>
ffffffffc020408c:	962e                	add	a2,a2,a1
ffffffffc020408e:	fec5f2e3          	bgeu	a1,a2,ffffffffc0204072 <user_mem_check+0x64>
ffffffffc0204092:	c8000537          	lui	a0,0xc8000
ffffffffc0204096:	0505                	addi	a0,a0,1
ffffffffc0204098:	00a63533          	sltu	a0,a2,a0
ffffffffc020409c:	bfd9                	j	ffffffffc0204072 <user_mem_check+0x64>
        return 1;
ffffffffc020409e:	4505                	li	a0,1
ffffffffc02040a0:	bfc9                	j	ffffffffc0204072 <user_mem_check+0x64>

ffffffffc02040a2 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02040a2:	8526                	mv	a0,s1
	jalr s0
ffffffffc02040a4:	9402                	jalr	s0

	jal do_exit
ffffffffc02040a6:	5da000ef          	jal	ra,ffffffffc0204680 <do_exit>

ffffffffc02040aa <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc02040aa:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040ac:	10800513          	li	a0,264
{
ffffffffc02040b0:	e022                	sd	s0,0(sp)
ffffffffc02040b2:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040b4:	c53fd0ef          	jal	ra,ffffffffc0201d06 <kmalloc>
ffffffffc02040b8:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02040ba:	cd21                	beqz	a0,ffffffffc0204112 <alloc_proc+0x68>
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */

        proc->state = PROC_UNINIT;     
ffffffffc02040bc:	57fd                	li	a5,-1
ffffffffc02040be:	1782                	slli	a5,a5,0x20
ffffffffc02040c0:	e11c                	sd	a5,0(a0)
        proc->runs = 0;                 
        proc->kstack = 0;              
        proc->need_resched = 0;         
        proc->parent = NULL;           
        proc->mm = NULL;             
        memset(&(proc->context), 0, sizeof(struct context)); 
ffffffffc02040c2:	07000613          	li	a2,112
ffffffffc02040c6:	4581                	li	a1,0
        proc->runs = 0;                 
ffffffffc02040c8:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d3f494>
        proc->kstack = 0;              
ffffffffc02040cc:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;         
ffffffffc02040d0:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;           
ffffffffc02040d4:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;             
ffffffffc02040d8:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context)); 
ffffffffc02040dc:	03050513          	addi	a0,a0,48
ffffffffc02040e0:	06d010ef          	jal	ra,ffffffffc020594c <memset>
        proc->tf = NULL;               
        
        proc->pgdir = boot_pgdir_pa;    
ffffffffc02040e4:	000bd797          	auipc	a5,0xbd
ffffffffc02040e8:	a3c7b783          	ld	a5,-1476(a5) # ffffffffc02c0b20 <boot_pgdir_pa>
        proc->tf = NULL;               
ffffffffc02040ec:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;    
ffffffffc02040f0:	f45c                	sd	a5,168(s0)
        
        proc->flags = 0;             
ffffffffc02040f2:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1); 
ffffffffc02040f6:	4641                	li	a2,16
ffffffffc02040f8:	4581                	li	a1,0
ffffffffc02040fa:	0b440513          	addi	a0,s0,180
ffffffffc02040fe:	04f010ef          	jal	ra,ffffffffc020594c <memset>
        proc->wait_state = 0;
ffffffffc0204102:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->yptr = proc->optr = NULL;
ffffffffc0204106:	10043023          	sd	zero,256(s0)
ffffffffc020410a:	0e043c23          	sd	zero,248(s0)
ffffffffc020410e:	0e043823          	sd	zero,240(s0)

    }
    return proc;
}
ffffffffc0204112:	60a2                	ld	ra,8(sp)
ffffffffc0204114:	8522                	mv	a0,s0
ffffffffc0204116:	6402                	ld	s0,0(sp)
ffffffffc0204118:	0141                	addi	sp,sp,16
ffffffffc020411a:	8082                	ret

ffffffffc020411c <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc020411c:	000bd797          	auipc	a5,0xbd
ffffffffc0204120:	a3c7b783          	ld	a5,-1476(a5) # ffffffffc02c0b58 <current>
ffffffffc0204124:	73c8                	ld	a0,160(a5)
ffffffffc0204126:	e55fc06f          	j	ffffffffc0200f7a <forkrets>

ffffffffc020412a <user_main>:
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc020412a:	000bd797          	auipc	a5,0xbd
ffffffffc020412e:	a2e7b783          	ld	a5,-1490(a5) # ffffffffc02c0b58 <current>
ffffffffc0204132:	43cc                	lw	a1,4(a5)
{
ffffffffc0204134:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204136:	00003617          	auipc	a2,0x3
ffffffffc020413a:	08a60613          	addi	a2,a2,138 # ffffffffc02071c0 <default_pmm_manager+0xa08>
ffffffffc020413e:	00003517          	auipc	a0,0x3
ffffffffc0204142:	09250513          	addi	a0,a0,146 # ffffffffc02071d0 <default_pmm_manager+0xa18>
{
ffffffffc0204146:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204148:	84cfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020414c:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0204150:	81c78793          	addi	a5,a5,-2020 # a968 <_binary_obj___user_forktest_out_size>
ffffffffc0204154:	e43e                	sd	a5,8(sp)
ffffffffc0204156:	00003517          	auipc	a0,0x3
ffffffffc020415a:	06a50513          	addi	a0,a0,106 # ffffffffc02071c0 <default_pmm_manager+0xa08>
ffffffffc020415e:	00050797          	auipc	a5,0x50
ffffffffc0204162:	03278793          	addi	a5,a5,50 # ffffffffc0254190 <_binary_obj___user_forktest_out_start>
ffffffffc0204166:	f03e                	sd	a5,32(sp)
ffffffffc0204168:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc020416a:	e802                	sd	zero,16(sp)
ffffffffc020416c:	73e010ef          	jal	ra,ffffffffc02058aa <strlen>
ffffffffc0204170:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204172:	4511                	li	a0,4
ffffffffc0204174:	55a2                	lw	a1,40(sp)
ffffffffc0204176:	4662                	lw	a2,24(sp)
ffffffffc0204178:	5682                	lw	a3,32(sp)
ffffffffc020417a:	4722                	lw	a4,8(sp)
ffffffffc020417c:	48a9                	li	a7,10
ffffffffc020417e:	9002                	ebreak
ffffffffc0204180:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204182:	65c2                	ld	a1,16(sp)
ffffffffc0204184:	00003517          	auipc	a0,0x3
ffffffffc0204188:	07450513          	addi	a0,a0,116 # ffffffffc02071f8 <default_pmm_manager+0xa40>
ffffffffc020418c:	808fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#else
 
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204190:	00003617          	auipc	a2,0x3
ffffffffc0204194:	07860613          	addi	a2,a2,120 # ffffffffc0207208 <default_pmm_manager+0xa50>
ffffffffc0204198:	3ad00593          	li	a1,941
ffffffffc020419c:	00003517          	auipc	a0,0x3
ffffffffc02041a0:	08c50513          	addi	a0,a0,140 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc02041a4:	aeafc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02041a8 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02041a8:	6d14                	ld	a3,24(a0)
{
ffffffffc02041aa:	1141                	addi	sp,sp,-16
ffffffffc02041ac:	e406                	sd	ra,8(sp)
ffffffffc02041ae:	c02007b7          	lui	a5,0xc0200
ffffffffc02041b2:	02f6ee63          	bltu	a3,a5,ffffffffc02041ee <put_pgdir+0x46>
ffffffffc02041b6:	000bd517          	auipc	a0,0xbd
ffffffffc02041ba:	99253503          	ld	a0,-1646(a0) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc02041be:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc02041c0:	82b1                	srli	a3,a3,0xc
ffffffffc02041c2:	000bd797          	auipc	a5,0xbd
ffffffffc02041c6:	96e7b783          	ld	a5,-1682(a5) # ffffffffc02c0b30 <npage>
ffffffffc02041ca:	02f6fe63          	bgeu	a3,a5,ffffffffc0204206 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02041ce:	00004517          	auipc	a0,0x4
ffffffffc02041d2:	8f253503          	ld	a0,-1806(a0) # ffffffffc0207ac0 <nbase>
}
ffffffffc02041d6:	60a2                	ld	ra,8(sp)
ffffffffc02041d8:	8e89                	sub	a3,a3,a0
ffffffffc02041da:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc02041dc:	000bd517          	auipc	a0,0xbd
ffffffffc02041e0:	95c53503          	ld	a0,-1700(a0) # ffffffffc02c0b38 <pages>
ffffffffc02041e4:	4585                	li	a1,1
ffffffffc02041e6:	9536                	add	a0,a0,a3
}
ffffffffc02041e8:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc02041ea:	d39fd06f          	j	ffffffffc0201f22 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc02041ee:	00002617          	auipc	a2,0x2
ffffffffc02041f2:	6aa60613          	addi	a2,a2,1706 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc02041f6:	07700593          	li	a1,119
ffffffffc02041fa:	00002517          	auipc	a0,0x2
ffffffffc02041fe:	61e50513          	addi	a0,a0,1566 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0204202:	a8cfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204206:	00002617          	auipc	a2,0x2
ffffffffc020420a:	6ba60613          	addi	a2,a2,1722 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc020420e:	06900593          	li	a1,105
ffffffffc0204212:	00002517          	auipc	a0,0x2
ffffffffc0204216:	60650513          	addi	a0,a0,1542 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc020421a:	a74fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020421e <proc_run>:
{
ffffffffc020421e:	7179                	addi	sp,sp,-48
ffffffffc0204220:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204222:	000bd917          	auipc	s2,0xbd
ffffffffc0204226:	93690913          	addi	s2,s2,-1738 # ffffffffc02c0b58 <current>
{
ffffffffc020422a:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc020422c:	00093483          	ld	s1,0(s2)
{
ffffffffc0204230:	f406                	sd	ra,40(sp)
ffffffffc0204232:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0204234:	02a48863          	beq	s1,a0,ffffffffc0204264 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204238:	100027f3          	csrr	a5,sstatus
ffffffffc020423c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020423e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204240:	ef9d                	bnez	a5,ffffffffc020427e <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204242:	755c                	ld	a5,168(a0)
ffffffffc0204244:	577d                	li	a4,-1
ffffffffc0204246:	177e                	slli	a4,a4,0x3f
ffffffffc0204248:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc020424a:	00a93023          	sd	a0,0(s2)
ffffffffc020424e:	8fd9                	or	a5,a5,a4
ffffffffc0204250:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(current->context));
ffffffffc0204254:	03050593          	addi	a1,a0,48
ffffffffc0204258:	03048513          	addi	a0,s1,48
ffffffffc020425c:	7f5000ef          	jal	ra,ffffffffc0205250 <switch_to>
    if (flag)
ffffffffc0204260:	00099863          	bnez	s3,ffffffffc0204270 <proc_run+0x52>
}
ffffffffc0204264:	70a2                	ld	ra,40(sp)
ffffffffc0204266:	7482                	ld	s1,32(sp)
ffffffffc0204268:	6962                	ld	s2,24(sp)
ffffffffc020426a:	69c2                	ld	s3,16(sp)
ffffffffc020426c:	6145                	addi	sp,sp,48
ffffffffc020426e:	8082                	ret
ffffffffc0204270:	70a2                	ld	ra,40(sp)
ffffffffc0204272:	7482                	ld	s1,32(sp)
ffffffffc0204274:	6962                	ld	s2,24(sp)
ffffffffc0204276:	69c2                	ld	s3,16(sp)
ffffffffc0204278:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc020427a:	f34fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc020427e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0204280:	f34fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204284:	6522                	ld	a0,8(sp)
ffffffffc0204286:	4985                	li	s3,1
ffffffffc0204288:	bf6d                	j	ffffffffc0204242 <proc_run+0x24>

ffffffffc020428a <do_fork>:
{
ffffffffc020428a:	7119                	addi	sp,sp,-128
ffffffffc020428c:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc020428e:	000bd917          	auipc	s2,0xbd
ffffffffc0204292:	8e290913          	addi	s2,s2,-1822 # ffffffffc02c0b70 <nr_process>
ffffffffc0204296:	00092703          	lw	a4,0(s2)
{
ffffffffc020429a:	fc86                	sd	ra,120(sp)
ffffffffc020429c:	f8a2                	sd	s0,112(sp)
ffffffffc020429e:	f4a6                	sd	s1,104(sp)
ffffffffc02042a0:	ecce                	sd	s3,88(sp)
ffffffffc02042a2:	e8d2                	sd	s4,80(sp)
ffffffffc02042a4:	e4d6                	sd	s5,72(sp)
ffffffffc02042a6:	e0da                	sd	s6,64(sp)
ffffffffc02042a8:	fc5e                	sd	s7,56(sp)
ffffffffc02042aa:	f862                	sd	s8,48(sp)
ffffffffc02042ac:	f466                	sd	s9,40(sp)
ffffffffc02042ae:	f06a                	sd	s10,32(sp)
ffffffffc02042b0:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02042b2:	6785                	lui	a5,0x1
ffffffffc02042b4:	2ef75c63          	bge	a4,a5,ffffffffc02045ac <do_fork+0x322>
ffffffffc02042b8:	8a2a                	mv	s4,a0
ffffffffc02042ba:	89ae                	mv	s3,a1
ffffffffc02042bc:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02042be:	dedff0ef          	jal	ra,ffffffffc02040aa <alloc_proc>
ffffffffc02042c2:	84aa                	mv	s1,a0
ffffffffc02042c4:	2c050863          	beqz	a0,ffffffffc0204594 <do_fork+0x30a>
    proc->parent = current;
ffffffffc02042c8:	000bdc17          	auipc	s8,0xbd
ffffffffc02042cc:	890c0c13          	addi	s8,s8,-1904 # ffffffffc02c0b58 <current>
ffffffffc02042d0:	000c3783          	ld	a5,0(s8)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042d4:	4509                	li	a0,2
    proc->parent = current;
ffffffffc02042d6:	f09c                	sd	a5,32(s1)
    current->wait_state = 0;
ffffffffc02042d8:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x8ac4>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02042dc:	c09fd0ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
    if (page != NULL)
ffffffffc02042e0:	2a050763          	beqz	a0,ffffffffc020458e <do_fork+0x304>
    return page - pages + nbase;
ffffffffc02042e4:	000bda97          	auipc	s5,0xbd
ffffffffc02042e8:	854a8a93          	addi	s5,s5,-1964 # ffffffffc02c0b38 <pages>
ffffffffc02042ec:	000ab683          	ld	a3,0(s5)
ffffffffc02042f0:	00003b17          	auipc	s6,0x3
ffffffffc02042f4:	7d0b0b13          	addi	s6,s6,2000 # ffffffffc0207ac0 <nbase>
ffffffffc02042f8:	000b3783          	ld	a5,0(s6)
ffffffffc02042fc:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204300:	000bdb97          	auipc	s7,0xbd
ffffffffc0204304:	830b8b93          	addi	s7,s7,-2000 # ffffffffc02c0b30 <npage>
    return page - pages + nbase;
ffffffffc0204308:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020430a:	5dfd                	li	s11,-1
ffffffffc020430c:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204310:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204312:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204316:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020431a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020431c:	2ce67563          	bgeu	a2,a4,ffffffffc02045e6 <do_fork+0x35c>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204320:	000c3603          	ld	a2,0(s8)
ffffffffc0204324:	000bdc17          	auipc	s8,0xbd
ffffffffc0204328:	824c0c13          	addi	s8,s8,-2012 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc020432c:	000c3703          	ld	a4,0(s8)
ffffffffc0204330:	02863d03          	ld	s10,40(a2)
ffffffffc0204334:	e43e                	sd	a5,8(sp)
ffffffffc0204336:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204338:	e894                	sd	a3,16(s1)
    if (oldmm == NULL)
ffffffffc020433a:	020d0863          	beqz	s10,ffffffffc020436a <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc020433e:	100a7a13          	andi	s4,s4,256
ffffffffc0204342:	180a0863          	beqz	s4,ffffffffc02044d2 <do_fork+0x248>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204346:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020434a:	018d3783          	ld	a5,24(s10)
ffffffffc020434e:	c02006b7          	lui	a3,0xc0200
ffffffffc0204352:	2705                	addiw	a4,a4,1
ffffffffc0204354:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc0204358:	03a4b423          	sd	s10,40(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020435c:	2ad7e163          	bltu	a5,a3,ffffffffc02045fe <do_fork+0x374>
ffffffffc0204360:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204364:	6894                	ld	a3,16(s1)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204366:	8f99                	sub	a5,a5,a4
ffffffffc0204368:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020436a:	6789                	lui	a5,0x2
ffffffffc020436c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>
ffffffffc0204370:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc0204372:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204374:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0204376:	87b6                	mv	a5,a3
ffffffffc0204378:	12040893          	addi	a7,s0,288
ffffffffc020437c:	00063803          	ld	a6,0(a2)
ffffffffc0204380:	6608                	ld	a0,8(a2)
ffffffffc0204382:	6a0c                	ld	a1,16(a2)
ffffffffc0204384:	6e18                	ld	a4,24(a2)
ffffffffc0204386:	0107b023          	sd	a6,0(a5)
ffffffffc020438a:	e788                	sd	a0,8(a5)
ffffffffc020438c:	eb8c                	sd	a1,16(a5)
ffffffffc020438e:	ef98                	sd	a4,24(a5)
ffffffffc0204390:	02060613          	addi	a2,a2,32
ffffffffc0204394:	02078793          	addi	a5,a5,32
ffffffffc0204398:	ff1612e3          	bne	a2,a7,ffffffffc020437c <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc020439c:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02043a0:	12098763          	beqz	s3,ffffffffc02044ce <do_fork+0x244>
    if (++last_pid >= MAX_PID)
ffffffffc02043a4:	000b8817          	auipc	a6,0xb8
ffffffffc02043a8:	31c80813          	addi	a6,a6,796 # ffffffffc02bc6c0 <last_pid.1>
ffffffffc02043ac:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02043b0:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043b4:	00000717          	auipc	a4,0x0
ffffffffc02043b8:	d6870713          	addi	a4,a4,-664 # ffffffffc020411c <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02043bc:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02043c0:	f898                	sd	a4,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02043c2:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc02043c4:	00a82023          	sw	a0,0(a6)
ffffffffc02043c8:	6789                	lui	a5,0x2
ffffffffc02043ca:	08f55b63          	bge	a0,a5,ffffffffc0204460 <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc02043ce:	000b8317          	auipc	t1,0xb8
ffffffffc02043d2:	2f630313          	addi	t1,t1,758 # ffffffffc02bc6c4 <next_safe.0>
ffffffffc02043d6:	00032783          	lw	a5,0(t1)
ffffffffc02043da:	000bc417          	auipc	s0,0xbc
ffffffffc02043de:	70640413          	addi	s0,s0,1798 # ffffffffc02c0ae0 <proc_list>
ffffffffc02043e2:	08f55763          	bge	a0,a5,ffffffffc0204470 <do_fork+0x1e6>
    proc->pid = get_pid();      // 先分配唯一 pid
ffffffffc02043e6:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02043e8:	45a9                	li	a1,10
ffffffffc02043ea:	2501                	sext.w	a0,a0
ffffffffc02043ec:	0ba010ef          	jal	ra,ffffffffc02054a6 <hash32>
ffffffffc02043f0:	02051793          	slli	a5,a0,0x20
ffffffffc02043f4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02043f8:	000b8797          	auipc	a5,0xb8
ffffffffc02043fc:	6e878793          	addi	a5,a5,1768 # ffffffffc02bcae0 <hash_list>
ffffffffc0204400:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204402:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204404:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204406:	0d848793          	addi	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc020440a:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020440c:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc020440e:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204410:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204412:	0c848793          	addi	a5,s1,200
    elm->next = next;
ffffffffc0204416:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc0204418:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020441a:	e21c                	sd	a5,0(a2)
ffffffffc020441c:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc020441e:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0204420:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0204422:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204426:	10e4b023          	sd	a4,256(s1)
ffffffffc020442a:	c311                	beqz	a4,ffffffffc020442e <do_fork+0x1a4>
        proc->optr->yptr = proc;
ffffffffc020442c:	ff64                	sd	s1,248(a4)
    nr_process++;
ffffffffc020442e:	00092783          	lw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc0204432:	8526                	mv	a0,s1
    proc->parent->cptr = proc;
ffffffffc0204434:	fae4                	sd	s1,240(a3)
    nr_process++;
ffffffffc0204436:	2785                	addiw	a5,a5,1
ffffffffc0204438:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc020443c:	67f000ef          	jal	ra,ffffffffc02052ba <wakeup_proc>
    ret = proc->pid;
ffffffffc0204440:	40c8                	lw	a0,4(s1)
}
ffffffffc0204442:	70e6                	ld	ra,120(sp)
ffffffffc0204444:	7446                	ld	s0,112(sp)
ffffffffc0204446:	74a6                	ld	s1,104(sp)
ffffffffc0204448:	7906                	ld	s2,96(sp)
ffffffffc020444a:	69e6                	ld	s3,88(sp)
ffffffffc020444c:	6a46                	ld	s4,80(sp)
ffffffffc020444e:	6aa6                	ld	s5,72(sp)
ffffffffc0204450:	6b06                	ld	s6,64(sp)
ffffffffc0204452:	7be2                	ld	s7,56(sp)
ffffffffc0204454:	7c42                	ld	s8,48(sp)
ffffffffc0204456:	7ca2                	ld	s9,40(sp)
ffffffffc0204458:	7d02                	ld	s10,32(sp)
ffffffffc020445a:	6de2                	ld	s11,24(sp)
ffffffffc020445c:	6109                	addi	sp,sp,128
ffffffffc020445e:	8082                	ret
        last_pid = 1;
ffffffffc0204460:	4785                	li	a5,1
ffffffffc0204462:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0204466:	4505                	li	a0,1
ffffffffc0204468:	000b8317          	auipc	t1,0xb8
ffffffffc020446c:	25c30313          	addi	t1,t1,604 # ffffffffc02bc6c4 <next_safe.0>
    return listelm->next;
ffffffffc0204470:	000bc417          	auipc	s0,0xbc
ffffffffc0204474:	67040413          	addi	s0,s0,1648 # ffffffffc02c0ae0 <proc_list>
ffffffffc0204478:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc020447c:	6789                	lui	a5,0x2
ffffffffc020447e:	00f32023          	sw	a5,0(t1)
ffffffffc0204482:	86aa                	mv	a3,a0
ffffffffc0204484:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204486:	6e89                	lui	t4,0x2
ffffffffc0204488:	108e0d63          	beq	t3,s0,ffffffffc02045a2 <do_fork+0x318>
ffffffffc020448c:	88ae                	mv	a7,a1
ffffffffc020448e:	87f2                	mv	a5,t3
ffffffffc0204490:	6609                	lui	a2,0x2
ffffffffc0204492:	a811                	j	ffffffffc02044a6 <do_fork+0x21c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204494:	00e6d663          	bge	a3,a4,ffffffffc02044a0 <do_fork+0x216>
ffffffffc0204498:	00c75463          	bge	a4,a2,ffffffffc02044a0 <do_fork+0x216>
ffffffffc020449c:	863a                	mv	a2,a4
ffffffffc020449e:	4885                	li	a7,1
ffffffffc02044a0:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02044a2:	00878d63          	beq	a5,s0,ffffffffc02044bc <do_fork+0x232>
            if (proc->pid == last_pid)
ffffffffc02044a6:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc02044aa:	fed715e3          	bne	a4,a3,ffffffffc0204494 <do_fork+0x20a>
                if (++last_pid >= next_safe)
ffffffffc02044ae:	2685                	addiw	a3,a3,1
ffffffffc02044b0:	0ec6d463          	bge	a3,a2,ffffffffc0204598 <do_fork+0x30e>
ffffffffc02044b4:	679c                	ld	a5,8(a5)
ffffffffc02044b6:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02044b8:	fe8797e3          	bne	a5,s0,ffffffffc02044a6 <do_fork+0x21c>
ffffffffc02044bc:	c581                	beqz	a1,ffffffffc02044c4 <do_fork+0x23a>
ffffffffc02044be:	00d82023          	sw	a3,0(a6)
ffffffffc02044c2:	8536                	mv	a0,a3
ffffffffc02044c4:	f20881e3          	beqz	a7,ffffffffc02043e6 <do_fork+0x15c>
ffffffffc02044c8:	00c32023          	sw	a2,0(t1)
ffffffffc02044cc:	bf29                	j	ffffffffc02043e6 <do_fork+0x15c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02044ce:	89b6                	mv	s3,a3
ffffffffc02044d0:	bdd1                	j	ffffffffc02043a4 <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc02044d2:	a6cff0ef          	jal	ra,ffffffffc020373e <mm_create>
ffffffffc02044d6:	8caa                	mv	s9,a0
ffffffffc02044d8:	c159                	beqz	a0,ffffffffc020455e <do_fork+0x2d4>
    if ((page = alloc_page()) == NULL)
ffffffffc02044da:	4505                	li	a0,1
ffffffffc02044dc:	a09fd0ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc02044e0:	cd25                	beqz	a0,ffffffffc0204558 <do_fork+0x2ce>
    return page - pages + nbase;
ffffffffc02044e2:	000ab683          	ld	a3,0(s5)
ffffffffc02044e6:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc02044e8:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02044ec:	40d506b3          	sub	a3,a0,a3
ffffffffc02044f0:	8699                	srai	a3,a3,0x6
ffffffffc02044f2:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02044f4:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc02044f8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02044fa:	0eedf663          	bgeu	s11,a4,ffffffffc02045e6 <do_fork+0x35c>
ffffffffc02044fe:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204502:	6605                	lui	a2,0x1
ffffffffc0204504:	000bc597          	auipc	a1,0xbc
ffffffffc0204508:	6245b583          	ld	a1,1572(a1) # ffffffffc02c0b28 <boot_pgdir_va>
ffffffffc020450c:	9a36                	add	s4,s4,a3
ffffffffc020450e:	8552                	mv	a0,s4
ffffffffc0204510:	44e010ef          	jal	ra,ffffffffc020595e <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204514:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc0204518:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020451c:	4785                	li	a5,1
ffffffffc020451e:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204522:	8b85                	andi	a5,a5,1
ffffffffc0204524:	4a05                	li	s4,1
ffffffffc0204526:	c799                	beqz	a5,ffffffffc0204534 <do_fork+0x2aa>
    {
        schedule();
ffffffffc0204528:	613000ef          	jal	ra,ffffffffc020533a <schedule>
ffffffffc020452c:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc0204530:	8b85                	andi	a5,a5,1
ffffffffc0204532:	fbfd                	bnez	a5,ffffffffc0204528 <do_fork+0x29e>
        ret = dup_mmap(mm, oldmm);
ffffffffc0204534:	85ea                	mv	a1,s10
ffffffffc0204536:	8566                	mv	a0,s9
ffffffffc0204538:	e9aff0ef          	jal	ra,ffffffffc0203bd2 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020453c:	57f9                	li	a5,-2
ffffffffc020453e:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0204542:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc0204544:	cbad                	beqz	a5,ffffffffc02045b6 <do_fork+0x32c>
good_mm:
ffffffffc0204546:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc0204548:	de050fe3          	beqz	a0,ffffffffc0204346 <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc020454c:	8566                	mv	a0,s9
ffffffffc020454e:	f26ff0ef          	jal	ra,ffffffffc0203c74 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204552:	8566                	mv	a0,s9
ffffffffc0204554:	c55ff0ef          	jal	ra,ffffffffc02041a8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204558:	8566                	mv	a0,s9
ffffffffc020455a:	d76ff0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020455e:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0204560:	c02007b7          	lui	a5,0xc0200
ffffffffc0204564:	0af6ea63          	bltu	a3,a5,ffffffffc0204618 <do_fork+0x38e>
ffffffffc0204568:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc020456c:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0204570:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204574:	83b1                	srli	a5,a5,0xc
ffffffffc0204576:	04e7fc63          	bgeu	a5,a4,ffffffffc02045ce <do_fork+0x344>
    return &pages[PPN(pa) - nbase];
ffffffffc020457a:	000b3703          	ld	a4,0(s6)
ffffffffc020457e:	000ab503          	ld	a0,0(s5)
ffffffffc0204582:	4589                	li	a1,2
ffffffffc0204584:	8f99                	sub	a5,a5,a4
ffffffffc0204586:	079a                	slli	a5,a5,0x6
ffffffffc0204588:	953e                	add	a0,a0,a5
ffffffffc020458a:	999fd0ef          	jal	ra,ffffffffc0201f22 <free_pages>
    kfree(proc);
ffffffffc020458e:	8526                	mv	a0,s1
ffffffffc0204590:	827fd0ef          	jal	ra,ffffffffc0201db6 <kfree>
    ret = -E_NO_MEM;
ffffffffc0204594:	5571                	li	a0,-4
    return ret;
ffffffffc0204596:	b575                	j	ffffffffc0204442 <do_fork+0x1b8>
                    if (last_pid >= MAX_PID)
ffffffffc0204598:	01d6c363          	blt	a3,t4,ffffffffc020459e <do_fork+0x314>
                        last_pid = 1;
ffffffffc020459c:	4685                	li	a3,1
                    goto repeat;
ffffffffc020459e:	4585                	li	a1,1
ffffffffc02045a0:	b5e5                	j	ffffffffc0204488 <do_fork+0x1fe>
ffffffffc02045a2:	c599                	beqz	a1,ffffffffc02045b0 <do_fork+0x326>
ffffffffc02045a4:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02045a8:	8536                	mv	a0,a3
ffffffffc02045aa:	bd35                	j	ffffffffc02043e6 <do_fork+0x15c>
    int ret = -E_NO_FREE_PROC;
ffffffffc02045ac:	556d                	li	a0,-5
ffffffffc02045ae:	bd51                	j	ffffffffc0204442 <do_fork+0x1b8>
    return last_pid;
ffffffffc02045b0:	00082503          	lw	a0,0(a6)
ffffffffc02045b4:	bd0d                	j	ffffffffc02043e6 <do_fork+0x15c>
    {
        panic("Unlock failed.\n");
ffffffffc02045b6:	00003617          	auipc	a2,0x3
ffffffffc02045ba:	c8a60613          	addi	a2,a2,-886 # ffffffffc0207240 <default_pmm_manager+0xa88>
ffffffffc02045be:	03f00593          	li	a1,63
ffffffffc02045c2:	00003517          	auipc	a0,0x3
ffffffffc02045c6:	c8e50513          	addi	a0,a0,-882 # ffffffffc0207250 <default_pmm_manager+0xa98>
ffffffffc02045ca:	ec5fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02045ce:	00002617          	auipc	a2,0x2
ffffffffc02045d2:	2f260613          	addi	a2,a2,754 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc02045d6:	06900593          	li	a1,105
ffffffffc02045da:	00002517          	auipc	a0,0x2
ffffffffc02045de:	23e50513          	addi	a0,a0,574 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02045e2:	eadfb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02045e6:	00002617          	auipc	a2,0x2
ffffffffc02045ea:	20a60613          	addi	a2,a2,522 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc02045ee:	07100593          	li	a1,113
ffffffffc02045f2:	00002517          	auipc	a0,0x2
ffffffffc02045f6:	22650513          	addi	a0,a0,550 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc02045fa:	e95fb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02045fe:	86be                	mv	a3,a5
ffffffffc0204600:	00002617          	auipc	a2,0x2
ffffffffc0204604:	29860613          	addi	a2,a2,664 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc0204608:	19200593          	li	a1,402
ffffffffc020460c:	00003517          	auipc	a0,0x3
ffffffffc0204610:	c1c50513          	addi	a0,a0,-996 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204614:	e7bfb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204618:	00002617          	auipc	a2,0x2
ffffffffc020461c:	28060613          	addi	a2,a2,640 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc0204620:	07700593          	li	a1,119
ffffffffc0204624:	00002517          	auipc	a0,0x2
ffffffffc0204628:	1f450513          	addi	a0,a0,500 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc020462c:	e63fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204630 <kernel_thread>:
{
ffffffffc0204630:	7129                	addi	sp,sp,-320
ffffffffc0204632:	fa22                	sd	s0,304(sp)
ffffffffc0204634:	f626                	sd	s1,296(sp)
ffffffffc0204636:	f24a                	sd	s2,288(sp)
ffffffffc0204638:	84ae                	mv	s1,a1
ffffffffc020463a:	892a                	mv	s2,a0
ffffffffc020463c:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020463e:	4581                	li	a1,0
ffffffffc0204640:	12000613          	li	a2,288
ffffffffc0204644:	850a                	mv	a0,sp
{
ffffffffc0204646:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0204648:	304010ef          	jal	ra,ffffffffc020594c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020464c:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020464e:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0204650:	100027f3          	csrr	a5,sstatus
ffffffffc0204654:	edd7f793          	andi	a5,a5,-291
ffffffffc0204658:	1207e793          	ori	a5,a5,288
ffffffffc020465c:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020465e:	860a                	mv	a2,sp
ffffffffc0204660:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0204664:	00000797          	auipc	a5,0x0
ffffffffc0204668:	a3e78793          	addi	a5,a5,-1474 # ffffffffc02040a2 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020466c:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020466e:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0204670:	c1bff0ef          	jal	ra,ffffffffc020428a <do_fork>
}
ffffffffc0204674:	70f2                	ld	ra,312(sp)
ffffffffc0204676:	7452                	ld	s0,304(sp)
ffffffffc0204678:	74b2                	ld	s1,296(sp)
ffffffffc020467a:	7912                	ld	s2,288(sp)
ffffffffc020467c:	6131                	addi	sp,sp,320
ffffffffc020467e:	8082                	ret

ffffffffc0204680 <do_exit>:
{
ffffffffc0204680:	7179                	addi	sp,sp,-48
ffffffffc0204682:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204684:	000bc417          	auipc	s0,0xbc
ffffffffc0204688:	4d440413          	addi	s0,s0,1236 # ffffffffc02c0b58 <current>
ffffffffc020468c:	601c                	ld	a5,0(s0)
{
ffffffffc020468e:	f406                	sd	ra,40(sp)
ffffffffc0204690:	ec26                	sd	s1,24(sp)
ffffffffc0204692:	e84a                	sd	s2,16(sp)
ffffffffc0204694:	e44e                	sd	s3,8(sp)
ffffffffc0204696:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204698:	000bc717          	auipc	a4,0xbc
ffffffffc020469c:	4c873703          	ld	a4,1224(a4) # ffffffffc02c0b60 <idleproc>
ffffffffc02046a0:	0ce78c63          	beq	a5,a4,ffffffffc0204778 <do_exit+0xf8>
    if (current == initproc)
ffffffffc02046a4:	000bc497          	auipc	s1,0xbc
ffffffffc02046a8:	4c448493          	addi	s1,s1,1220 # ffffffffc02c0b68 <initproc>
ffffffffc02046ac:	6098                	ld	a4,0(s1)
ffffffffc02046ae:	0ee78b63          	beq	a5,a4,ffffffffc02047a4 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc02046b2:	0287b983          	ld	s3,40(a5)
ffffffffc02046b6:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc02046b8:	02098663          	beqz	s3,ffffffffc02046e4 <do_exit+0x64>
ffffffffc02046bc:	000bc797          	auipc	a5,0xbc
ffffffffc02046c0:	4647b783          	ld	a5,1124(a5) # ffffffffc02c0b20 <boot_pgdir_pa>
ffffffffc02046c4:	577d                	li	a4,-1
ffffffffc02046c6:	177e                	slli	a4,a4,0x3f
ffffffffc02046c8:	83b1                	srli	a5,a5,0xc
ffffffffc02046ca:	8fd9                	or	a5,a5,a4
ffffffffc02046cc:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02046d0:	0309a783          	lw	a5,48(s3)
ffffffffc02046d4:	fff7871b          	addiw	a4,a5,-1
ffffffffc02046d8:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02046dc:	cb55                	beqz	a4,ffffffffc0204790 <do_exit+0x110>
        current->mm = NULL;
ffffffffc02046de:	601c                	ld	a5,0(s0)
ffffffffc02046e0:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02046e4:	601c                	ld	a5,0(s0)
ffffffffc02046e6:	470d                	li	a4,3
ffffffffc02046e8:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02046ea:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046ee:	100027f3          	csrr	a5,sstatus
ffffffffc02046f2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046f4:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02046f6:	e3f9                	bnez	a5,ffffffffc02047bc <do_exit+0x13c>
        proc = current->parent;
ffffffffc02046f8:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc02046fa:	800007b7          	lui	a5,0x80000
ffffffffc02046fe:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204700:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204702:	0ec52703          	lw	a4,236(a0)
ffffffffc0204706:	0af70f63          	beq	a4,a5,ffffffffc02047c4 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020470a:	6018                	ld	a4,0(s0)
ffffffffc020470c:	7b7c                	ld	a5,240(a4)
ffffffffc020470e:	c3a1                	beqz	a5,ffffffffc020474e <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204710:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204714:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204716:	0985                	addi	s3,s3,1
ffffffffc0204718:	a021                	j	ffffffffc0204720 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020471a:	6018                	ld	a4,0(s0)
ffffffffc020471c:	7b7c                	ld	a5,240(a4)
ffffffffc020471e:	cb85                	beqz	a5,ffffffffc020474e <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204720:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_proc_suite_out_size+0xffffffff7fff4788>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204724:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc0204726:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc0204728:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc020472a:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020472e:	10e7b023          	sd	a4,256(a5)
ffffffffc0204732:	c311                	beqz	a4,ffffffffc0204736 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc0204734:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204736:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0204738:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc020473a:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc020473c:	fd271fe3          	bne	a4,s2,ffffffffc020471a <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204740:	0ec52783          	lw	a5,236(a0)
ffffffffc0204744:	fd379be3          	bne	a5,s3,ffffffffc020471a <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc0204748:	373000ef          	jal	ra,ffffffffc02052ba <wakeup_proc>
ffffffffc020474c:	b7f9                	j	ffffffffc020471a <do_exit+0x9a>
    if (flag)
ffffffffc020474e:	020a1263          	bnez	s4,ffffffffc0204772 <do_exit+0xf2>
    schedule();
ffffffffc0204752:	3e9000ef          	jal	ra,ffffffffc020533a <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0204756:	601c                	ld	a5,0(s0)
ffffffffc0204758:	00003617          	auipc	a2,0x3
ffffffffc020475c:	b3060613          	addi	a2,a2,-1232 # ffffffffc0207288 <default_pmm_manager+0xad0>
ffffffffc0204760:	22400593          	li	a1,548
ffffffffc0204764:	43d4                	lw	a3,4(a5)
ffffffffc0204766:	00003517          	auipc	a0,0x3
ffffffffc020476a:	ac250513          	addi	a0,a0,-1342 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc020476e:	d21fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204772:	a3cfc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204776:	bff1                	j	ffffffffc0204752 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204778:	00003617          	auipc	a2,0x3
ffffffffc020477c:	af060613          	addi	a2,a2,-1296 # ffffffffc0207268 <default_pmm_manager+0xab0>
ffffffffc0204780:	1f000593          	li	a1,496
ffffffffc0204784:	00003517          	auipc	a0,0x3
ffffffffc0204788:	aa450513          	addi	a0,a0,-1372 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc020478c:	d03fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204790:	854e                	mv	a0,s3
ffffffffc0204792:	ce2ff0ef          	jal	ra,ffffffffc0203c74 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204796:	854e                	mv	a0,s3
ffffffffc0204798:	a11ff0ef          	jal	ra,ffffffffc02041a8 <put_pgdir>
            mm_destroy(mm);
ffffffffc020479c:	854e                	mv	a0,s3
ffffffffc020479e:	b32ff0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>
ffffffffc02047a2:	bf35                	j	ffffffffc02046de <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc02047a4:	00003617          	auipc	a2,0x3
ffffffffc02047a8:	ad460613          	addi	a2,a2,-1324 # ffffffffc0207278 <default_pmm_manager+0xac0>
ffffffffc02047ac:	1f400593          	li	a1,500
ffffffffc02047b0:	00003517          	auipc	a0,0x3
ffffffffc02047b4:	a7850513          	addi	a0,a0,-1416 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc02047b8:	cd7fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc02047bc:	9f8fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02047c0:	4a05                	li	s4,1
ffffffffc02047c2:	bf1d                	j	ffffffffc02046f8 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc02047c4:	2f7000ef          	jal	ra,ffffffffc02052ba <wakeup_proc>
ffffffffc02047c8:	b789                	j	ffffffffc020470a <do_exit+0x8a>

ffffffffc02047ca <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc02047ca:	715d                	addi	sp,sp,-80
ffffffffc02047cc:	f84a                	sd	s2,48(sp)
ffffffffc02047ce:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc02047d0:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc02047d4:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc02047d6:	fc26                	sd	s1,56(sp)
ffffffffc02047d8:	f052                	sd	s4,32(sp)
ffffffffc02047da:	ec56                	sd	s5,24(sp)
ffffffffc02047dc:	e85a                	sd	s6,16(sp)
ffffffffc02047de:	e45e                	sd	s7,8(sp)
ffffffffc02047e0:	e486                	sd	ra,72(sp)
ffffffffc02047e2:	e0a2                	sd	s0,64(sp)
ffffffffc02047e4:	84aa                	mv	s1,a0
ffffffffc02047e6:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc02047e8:	000bcb97          	auipc	s7,0xbc
ffffffffc02047ec:	370b8b93          	addi	s7,s7,880 # ffffffffc02c0b58 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc02047f0:	00050b1b          	sext.w	s6,a0
ffffffffc02047f4:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02047f8:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc02047fa:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc02047fc:	ccbd                	beqz	s1,ffffffffc020487a <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc02047fe:	0359e863          	bltu	s3,s5,ffffffffc020482e <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204802:	45a9                	li	a1,10
ffffffffc0204804:	855a                	mv	a0,s6
ffffffffc0204806:	4a1000ef          	jal	ra,ffffffffc02054a6 <hash32>
ffffffffc020480a:	02051793          	slli	a5,a0,0x20
ffffffffc020480e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204812:	000b8797          	auipc	a5,0xb8
ffffffffc0204816:	2ce78793          	addi	a5,a5,718 # ffffffffc02bcae0 <hash_list>
ffffffffc020481a:	953e                	add	a0,a0,a5
ffffffffc020481c:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc020481e:	a029                	j	ffffffffc0204828 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204820:	f2c42783          	lw	a5,-212(s0)
ffffffffc0204824:	02978163          	beq	a5,s1,ffffffffc0204846 <do_wait.part.0+0x7c>
ffffffffc0204828:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc020482a:	fe851be3          	bne	a0,s0,ffffffffc0204820 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc020482e:	5579                	li	a0,-2
}
ffffffffc0204830:	60a6                	ld	ra,72(sp)
ffffffffc0204832:	6406                	ld	s0,64(sp)
ffffffffc0204834:	74e2                	ld	s1,56(sp)
ffffffffc0204836:	7942                	ld	s2,48(sp)
ffffffffc0204838:	79a2                	ld	s3,40(sp)
ffffffffc020483a:	7a02                	ld	s4,32(sp)
ffffffffc020483c:	6ae2                	ld	s5,24(sp)
ffffffffc020483e:	6b42                	ld	s6,16(sp)
ffffffffc0204840:	6ba2                	ld	s7,8(sp)
ffffffffc0204842:	6161                	addi	sp,sp,80
ffffffffc0204844:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc0204846:	000bb683          	ld	a3,0(s7)
ffffffffc020484a:	f4843783          	ld	a5,-184(s0)
ffffffffc020484e:	fed790e3          	bne	a5,a3,ffffffffc020482e <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204852:	f2842703          	lw	a4,-216(s0)
ffffffffc0204856:	478d                	li	a5,3
ffffffffc0204858:	0ef70b63          	beq	a4,a5,ffffffffc020494e <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc020485c:	4785                	li	a5,1
ffffffffc020485e:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0204860:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0204864:	2d7000ef          	jal	ra,ffffffffc020533a <schedule>
        if (current->flags & PF_EXITING)
ffffffffc0204868:	000bb783          	ld	a5,0(s7)
ffffffffc020486c:	0b07a783          	lw	a5,176(a5)
ffffffffc0204870:	8b85                	andi	a5,a5,1
ffffffffc0204872:	d7c9                	beqz	a5,ffffffffc02047fc <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204874:	555d                	li	a0,-9
ffffffffc0204876:	e0bff0ef          	jal	ra,ffffffffc0204680 <do_exit>
        proc = current->cptr;
ffffffffc020487a:	000bb683          	ld	a3,0(s7)
ffffffffc020487e:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204880:	d45d                	beqz	s0,ffffffffc020482e <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204882:	470d                	li	a4,3
ffffffffc0204884:	a021                	j	ffffffffc020488c <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204886:	10043403          	ld	s0,256(s0)
ffffffffc020488a:	d869                	beqz	s0,ffffffffc020485c <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020488c:	401c                	lw	a5,0(s0)
ffffffffc020488e:	fee79ce3          	bne	a5,a4,ffffffffc0204886 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204892:	000bc797          	auipc	a5,0xbc
ffffffffc0204896:	2ce7b783          	ld	a5,718(a5) # ffffffffc02c0b60 <idleproc>
ffffffffc020489a:	0c878963          	beq	a5,s0,ffffffffc020496c <do_wait.part.0+0x1a2>
ffffffffc020489e:	000bc797          	auipc	a5,0xbc
ffffffffc02048a2:	2ca7b783          	ld	a5,714(a5) # ffffffffc02c0b68 <initproc>
ffffffffc02048a6:	0cf40363          	beq	s0,a5,ffffffffc020496c <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc02048aa:	000a0663          	beqz	s4,ffffffffc02048b6 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc02048ae:	0e842783          	lw	a5,232(s0)
ffffffffc02048b2:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02048b6:	100027f3          	csrr	a5,sstatus
ffffffffc02048ba:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02048bc:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02048be:	e7c1                	bnez	a5,ffffffffc0204946 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc02048c0:	6c70                	ld	a2,216(s0)
ffffffffc02048c2:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc02048c4:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc02048c8:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc02048ca:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02048cc:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02048ce:	6470                	ld	a2,200(s0)
ffffffffc02048d0:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc02048d2:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc02048d4:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc02048d6:	c319                	beqz	a4,ffffffffc02048dc <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc02048d8:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc02048da:	7c7c                	ld	a5,248(s0)
ffffffffc02048dc:	c3b5                	beqz	a5,ffffffffc0204940 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc02048de:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc02048e2:	000bc717          	auipc	a4,0xbc
ffffffffc02048e6:	28e70713          	addi	a4,a4,654 # ffffffffc02c0b70 <nr_process>
ffffffffc02048ea:	431c                	lw	a5,0(a4)
ffffffffc02048ec:	37fd                	addiw	a5,a5,-1
ffffffffc02048ee:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc02048f0:	e5a9                	bnez	a1,ffffffffc020493a <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02048f2:	6814                	ld	a3,16(s0)
ffffffffc02048f4:	c02007b7          	lui	a5,0xc0200
ffffffffc02048f8:	04f6ee63          	bltu	a3,a5,ffffffffc0204954 <do_wait.part.0+0x18a>
ffffffffc02048fc:	000bc797          	auipc	a5,0xbc
ffffffffc0204900:	24c7b783          	ld	a5,588(a5) # ffffffffc02c0b48 <va_pa_offset>
ffffffffc0204904:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204906:	82b1                	srli	a3,a3,0xc
ffffffffc0204908:	000bc797          	auipc	a5,0xbc
ffffffffc020490c:	2287b783          	ld	a5,552(a5) # ffffffffc02c0b30 <npage>
ffffffffc0204910:	06f6fa63          	bgeu	a3,a5,ffffffffc0204984 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204914:	00003517          	auipc	a0,0x3
ffffffffc0204918:	1ac53503          	ld	a0,428(a0) # ffffffffc0207ac0 <nbase>
ffffffffc020491c:	8e89                	sub	a3,a3,a0
ffffffffc020491e:	069a                	slli	a3,a3,0x6
ffffffffc0204920:	000bc517          	auipc	a0,0xbc
ffffffffc0204924:	21853503          	ld	a0,536(a0) # ffffffffc02c0b38 <pages>
ffffffffc0204928:	9536                	add	a0,a0,a3
ffffffffc020492a:	4589                	li	a1,2
ffffffffc020492c:	df6fd0ef          	jal	ra,ffffffffc0201f22 <free_pages>
    kfree(proc);
ffffffffc0204930:	8522                	mv	a0,s0
ffffffffc0204932:	c84fd0ef          	jal	ra,ffffffffc0201db6 <kfree>
    return 0;
ffffffffc0204936:	4501                	li	a0,0
ffffffffc0204938:	bde5                	j	ffffffffc0204830 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc020493a:	874fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020493e:	bf55                	j	ffffffffc02048f2 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc0204940:	701c                	ld	a5,32(s0)
ffffffffc0204942:	fbf8                	sd	a4,240(a5)
ffffffffc0204944:	bf79                	j	ffffffffc02048e2 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0204946:	86efc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020494a:	4585                	li	a1,1
ffffffffc020494c:	bf95                	j	ffffffffc02048c0 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020494e:	f2840413          	addi	s0,s0,-216
ffffffffc0204952:	b781                	j	ffffffffc0204892 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0204954:	00002617          	auipc	a2,0x2
ffffffffc0204958:	f4460613          	addi	a2,a2,-188 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc020495c:	07700593          	li	a1,119
ffffffffc0204960:	00002517          	auipc	a0,0x2
ffffffffc0204964:	eb850513          	addi	a0,a0,-328 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0204968:	b27fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc020496c:	00003617          	auipc	a2,0x3
ffffffffc0204970:	93c60613          	addi	a2,a2,-1732 # ffffffffc02072a8 <default_pmm_manager+0xaf0>
ffffffffc0204974:	34a00593          	li	a1,842
ffffffffc0204978:	00003517          	auipc	a0,0x3
ffffffffc020497c:	8b050513          	addi	a0,a0,-1872 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204980:	b0ffb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204984:	00002617          	auipc	a2,0x2
ffffffffc0204988:	f3c60613          	addi	a2,a2,-196 # ffffffffc02068c0 <default_pmm_manager+0x108>
ffffffffc020498c:	06900593          	li	a1,105
ffffffffc0204990:	00002517          	auipc	a0,0x2
ffffffffc0204994:	e8850513          	addi	a0,a0,-376 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0204998:	af7fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020499c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020499c:	1141                	addi	sp,sp,-16
ffffffffc020499e:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02049a0:	dc2fd0ef          	jal	ra,ffffffffc0201f62 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc02049a4:	b5efd0ef          	jal	ra,ffffffffc0201d02 <kallocated>

int pid = kernel_thread(user_main , NULL, 0);
ffffffffc02049a8:	4601                	li	a2,0
ffffffffc02049aa:	4581                	li	a1,0
ffffffffc02049ac:	fffff517          	auipc	a0,0xfffff
ffffffffc02049b0:	77e50513          	addi	a0,a0,1918 # ffffffffc020412a <user_main>
ffffffffc02049b4:	c7dff0ef          	jal	ra,ffffffffc0204630 <kernel_thread>
    if (pid <= 0)
ffffffffc02049b8:	00a04563          	bgtz	a0,ffffffffc02049c2 <init_main+0x26>
ffffffffc02049bc:	a071                	j	ffffffffc0204a48 <init_main+0xac>
    }


    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc02049be:	17d000ef          	jal	ra,ffffffffc020533a <schedule>
    if (code_store != NULL)
ffffffffc02049c2:	4581                	li	a1,0
ffffffffc02049c4:	4501                	li	a0,0
ffffffffc02049c6:	e05ff0ef          	jal	ra,ffffffffc02047ca <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc02049ca:	d975                	beqz	a0,ffffffffc02049be <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc02049cc:	00003517          	auipc	a0,0x3
ffffffffc02049d0:	91c50513          	addi	a0,a0,-1764 # ffffffffc02072e8 <default_pmm_manager+0xb30>
ffffffffc02049d4:	fc0fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02049d8:	000bc797          	auipc	a5,0xbc
ffffffffc02049dc:	1907b783          	ld	a5,400(a5) # ffffffffc02c0b68 <initproc>
ffffffffc02049e0:	7bf8                	ld	a4,240(a5)
ffffffffc02049e2:	e339                	bnez	a4,ffffffffc0204a28 <init_main+0x8c>
ffffffffc02049e4:	7ff8                	ld	a4,248(a5)
ffffffffc02049e6:	e329                	bnez	a4,ffffffffc0204a28 <init_main+0x8c>
ffffffffc02049e8:	1007b703          	ld	a4,256(a5)
ffffffffc02049ec:	ef15                	bnez	a4,ffffffffc0204a28 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc02049ee:	000bc697          	auipc	a3,0xbc
ffffffffc02049f2:	1826a683          	lw	a3,386(a3) # ffffffffc02c0b70 <nr_process>
ffffffffc02049f6:	4709                	li	a4,2
ffffffffc02049f8:	0ae69463          	bne	a3,a4,ffffffffc0204aa0 <init_main+0x104>
    return listelm->next;
ffffffffc02049fc:	000bc697          	auipc	a3,0xbc
ffffffffc0204a00:	0e468693          	addi	a3,a3,228 # ffffffffc02c0ae0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a04:	6698                	ld	a4,8(a3)
ffffffffc0204a06:	0c878793          	addi	a5,a5,200
ffffffffc0204a0a:	06f71b63          	bne	a4,a5,ffffffffc0204a80 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a0e:	629c                	ld	a5,0(a3)
ffffffffc0204a10:	04f71863          	bne	a4,a5,ffffffffc0204a60 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204a14:	00003517          	auipc	a0,0x3
ffffffffc0204a18:	9bc50513          	addi	a0,a0,-1604 # ffffffffc02073d0 <default_pmm_manager+0xc18>
ffffffffc0204a1c:	f78fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204a20:	60a2                	ld	ra,8(sp)
ffffffffc0204a22:	4501                	li	a0,0
ffffffffc0204a24:	0141                	addi	sp,sp,16
ffffffffc0204a26:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a28:	00003697          	auipc	a3,0x3
ffffffffc0204a2c:	8e868693          	addi	a3,a3,-1816 # ffffffffc0207310 <default_pmm_manager+0xb58>
ffffffffc0204a30:	00002617          	auipc	a2,0x2
ffffffffc0204a34:	9d860613          	addi	a2,a2,-1576 # ffffffffc0206408 <commands+0x828>
ffffffffc0204a38:	3c400593          	li	a1,964
ffffffffc0204a3c:	00002517          	auipc	a0,0x2
ffffffffc0204a40:	7ec50513          	addi	a0,a0,2028 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204a44:	a4bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc0204a48:	00003617          	auipc	a2,0x3
ffffffffc0204a4c:	88060613          	addi	a2,a2,-1920 # ffffffffc02072c8 <default_pmm_manager+0xb10>
ffffffffc0204a50:	3ba00593          	li	a1,954
ffffffffc0204a54:	00002517          	auipc	a0,0x2
ffffffffc0204a58:	7d450513          	addi	a0,a0,2004 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204a5c:	a33fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a60:	00003697          	auipc	a3,0x3
ffffffffc0204a64:	94068693          	addi	a3,a3,-1728 # ffffffffc02073a0 <default_pmm_manager+0xbe8>
ffffffffc0204a68:	00002617          	auipc	a2,0x2
ffffffffc0204a6c:	9a060613          	addi	a2,a2,-1632 # ffffffffc0206408 <commands+0x828>
ffffffffc0204a70:	3c700593          	li	a1,967
ffffffffc0204a74:	00002517          	auipc	a0,0x2
ffffffffc0204a78:	7b450513          	addi	a0,a0,1972 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204a7c:	a13fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a80:	00003697          	auipc	a3,0x3
ffffffffc0204a84:	8f068693          	addi	a3,a3,-1808 # ffffffffc0207370 <default_pmm_manager+0xbb8>
ffffffffc0204a88:	00002617          	auipc	a2,0x2
ffffffffc0204a8c:	98060613          	addi	a2,a2,-1664 # ffffffffc0206408 <commands+0x828>
ffffffffc0204a90:	3c600593          	li	a1,966
ffffffffc0204a94:	00002517          	auipc	a0,0x2
ffffffffc0204a98:	79450513          	addi	a0,a0,1940 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204a9c:	9f3fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204aa0:	00003697          	auipc	a3,0x3
ffffffffc0204aa4:	8c068693          	addi	a3,a3,-1856 # ffffffffc0207360 <default_pmm_manager+0xba8>
ffffffffc0204aa8:	00002617          	auipc	a2,0x2
ffffffffc0204aac:	96060613          	addi	a2,a2,-1696 # ffffffffc0206408 <commands+0x828>
ffffffffc0204ab0:	3c500593          	li	a1,965
ffffffffc0204ab4:	00002517          	auipc	a0,0x2
ffffffffc0204ab8:	77450513          	addi	a0,a0,1908 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204abc:	9d3fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204ac0 <do_execve>:
{
ffffffffc0204ac0:	7171                	addi	sp,sp,-176
ffffffffc0204ac2:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204ac4:	000bcd97          	auipc	s11,0xbc
ffffffffc0204ac8:	094d8d93          	addi	s11,s11,148 # ffffffffc02c0b58 <current>
ffffffffc0204acc:	000db783          	ld	a5,0(s11)
{
ffffffffc0204ad0:	e54e                	sd	s3,136(sp)
ffffffffc0204ad2:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204ad4:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204ad8:	e94a                	sd	s2,144(sp)
ffffffffc0204ada:	f4de                	sd	s7,104(sp)
ffffffffc0204adc:	892a                	mv	s2,a0
ffffffffc0204ade:	8bb2                	mv	s7,a2
ffffffffc0204ae0:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204ae2:	862e                	mv	a2,a1
ffffffffc0204ae4:	4681                	li	a3,0
ffffffffc0204ae6:	85aa                	mv	a1,a0
ffffffffc0204ae8:	854e                	mv	a0,s3
{
ffffffffc0204aea:	f506                	sd	ra,168(sp)
ffffffffc0204aec:	f122                	sd	s0,160(sp)
ffffffffc0204aee:	e152                	sd	s4,128(sp)
ffffffffc0204af0:	fcd6                	sd	s5,120(sp)
ffffffffc0204af2:	f8da                	sd	s6,112(sp)
ffffffffc0204af4:	f0e2                	sd	s8,96(sp)
ffffffffc0204af6:	ece6                	sd	s9,88(sp)
ffffffffc0204af8:	e8ea                	sd	s10,80(sp)
ffffffffc0204afa:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204afc:	d12ff0ef          	jal	ra,ffffffffc020400e <user_mem_check>
ffffffffc0204b00:	40050a63          	beqz	a0,ffffffffc0204f14 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b04:	4641                	li	a2,16
ffffffffc0204b06:	4581                	li	a1,0
ffffffffc0204b08:	1808                	addi	a0,sp,48
ffffffffc0204b0a:	643000ef          	jal	ra,ffffffffc020594c <memset>
    memcpy(local_name, name, len);
ffffffffc0204b0e:	47bd                	li	a5,15
ffffffffc0204b10:	8626                	mv	a2,s1
ffffffffc0204b12:	1e97e263          	bltu	a5,s1,ffffffffc0204cf6 <do_execve+0x236>
ffffffffc0204b16:	85ca                	mv	a1,s2
ffffffffc0204b18:	1808                	addi	a0,sp,48
ffffffffc0204b1a:	645000ef          	jal	ra,ffffffffc020595e <memcpy>
    if (mm != NULL)
ffffffffc0204b1e:	1e098363          	beqz	s3,ffffffffc0204d04 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204b22:	00002517          	auipc	a0,0x2
ffffffffc0204b26:	4c650513          	addi	a0,a0,1222 # ffffffffc0206fe8 <default_pmm_manager+0x830>
ffffffffc0204b2a:	ea2fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204b2e:	000bc797          	auipc	a5,0xbc
ffffffffc0204b32:	ff27b783          	ld	a5,-14(a5) # ffffffffc02c0b20 <boot_pgdir_pa>
ffffffffc0204b36:	577d                	li	a4,-1
ffffffffc0204b38:	177e                	slli	a4,a4,0x3f
ffffffffc0204b3a:	83b1                	srli	a5,a5,0xc
ffffffffc0204b3c:	8fd9                	or	a5,a5,a4
ffffffffc0204b3e:	18079073          	csrw	satp,a5
ffffffffc0204b42:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b80>
ffffffffc0204b46:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204b4a:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204b4e:	2c070463          	beqz	a4,ffffffffc0204e16 <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204b52:	000db783          	ld	a5,0(s11)
ffffffffc0204b56:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204b5a:	be5fe0ef          	jal	ra,ffffffffc020373e <mm_create>
ffffffffc0204b5e:	84aa                	mv	s1,a0
ffffffffc0204b60:	1c050d63          	beqz	a0,ffffffffc0204d3a <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204b64:	4505                	li	a0,1
ffffffffc0204b66:	b7efd0ef          	jal	ra,ffffffffc0201ee4 <alloc_pages>
ffffffffc0204b6a:	3a050963          	beqz	a0,ffffffffc0204f1c <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204b6e:	000bcc97          	auipc	s9,0xbc
ffffffffc0204b72:	fcac8c93          	addi	s9,s9,-54 # ffffffffc02c0b38 <pages>
ffffffffc0204b76:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204b7a:	000bcc17          	auipc	s8,0xbc
ffffffffc0204b7e:	fb6c0c13          	addi	s8,s8,-74 # ffffffffc02c0b30 <npage>
    return page - pages + nbase;
ffffffffc0204b82:	00003717          	auipc	a4,0x3
ffffffffc0204b86:	f3e73703          	ld	a4,-194(a4) # ffffffffc0207ac0 <nbase>
ffffffffc0204b8a:	40d506b3          	sub	a3,a0,a3
ffffffffc0204b8e:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204b90:	5afd                	li	s5,-1
ffffffffc0204b92:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204b96:	96ba                	add	a3,a3,a4
ffffffffc0204b98:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b9a:	00cad713          	srli	a4,s5,0xc
ffffffffc0204b9e:	ec3a                	sd	a4,24(sp)
ffffffffc0204ba0:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ba2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ba4:	38f77063          	bgeu	a4,a5,ffffffffc0204f24 <do_execve+0x464>
ffffffffc0204ba8:	000bcb17          	auipc	s6,0xbc
ffffffffc0204bac:	fa0b0b13          	addi	s6,s6,-96 # ffffffffc02c0b48 <va_pa_offset>
ffffffffc0204bb0:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204bb4:	6605                	lui	a2,0x1
ffffffffc0204bb6:	000bc597          	auipc	a1,0xbc
ffffffffc0204bba:	f725b583          	ld	a1,-142(a1) # ffffffffc02c0b28 <boot_pgdir_va>
ffffffffc0204bbe:	9936                	add	s2,s2,a3
ffffffffc0204bc0:	854a                	mv	a0,s2
ffffffffc0204bc2:	59d000ef          	jal	ra,ffffffffc020595e <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204bc6:	7782                	ld	a5,32(sp)
ffffffffc0204bc8:	4398                	lw	a4,0(a5)
ffffffffc0204bca:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204bce:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204bd2:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_proc_suite_out_size+0x464b8c07>
ffffffffc0204bd6:	14f71863          	bne	a4,a5,ffffffffc0204d26 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204bda:	7682                	ld	a3,32(sp)
ffffffffc0204bdc:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204be0:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204be4:	00371793          	slli	a5,a4,0x3
ffffffffc0204be8:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204bea:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204bec:	078e                	slli	a5,a5,0x3
ffffffffc0204bee:	97ce                	add	a5,a5,s3
ffffffffc0204bf0:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204bf2:	00f9fc63          	bgeu	s3,a5,ffffffffc0204c0a <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204bf6:	0009a783          	lw	a5,0(s3)
ffffffffc0204bfa:	4705                	li	a4,1
ffffffffc0204bfc:	14e78163          	beq	a5,a4,ffffffffc0204d3e <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204c00:	77a2                	ld	a5,40(sp)
ffffffffc0204c02:	03898993          	addi	s3,s3,56
ffffffffc0204c06:	fef9e8e3          	bltu	s3,a5,ffffffffc0204bf6 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204c0a:	4701                	li	a4,0
ffffffffc0204c0c:	46ad                	li	a3,11
ffffffffc0204c0e:	00100637          	lui	a2,0x100
ffffffffc0204c12:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204c16:	8526                	mv	a0,s1
ffffffffc0204c18:	f0bfe0ef          	jal	ra,ffffffffc0203b22 <mm_map>
ffffffffc0204c1c:	8a2a                	mv	s4,a0
ffffffffc0204c1e:	1e051263          	bnez	a0,ffffffffc0204e02 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204c22:	6c88                	ld	a0,24(s1)
ffffffffc0204c24:	467d                	li	a2,31
ffffffffc0204c26:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204c2a:	a2ffe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204c2e:	38050363          	beqz	a0,ffffffffc0204fb4 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c32:	6c88                	ld	a0,24(s1)
ffffffffc0204c34:	467d                	li	a2,31
ffffffffc0204c36:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204c3a:	a1ffe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204c3e:	34050b63          	beqz	a0,ffffffffc0204f94 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c42:	6c88                	ld	a0,24(s1)
ffffffffc0204c44:	467d                	li	a2,31
ffffffffc0204c46:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204c4a:	a0ffe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204c4e:	32050363          	beqz	a0,ffffffffc0204f74 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204c52:	6c88                	ld	a0,24(s1)
ffffffffc0204c54:	467d                	li	a2,31
ffffffffc0204c56:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204c5a:	9fffe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204c5e:	2e050b63          	beqz	a0,ffffffffc0204f54 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204c62:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204c64:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c68:	6c94                	ld	a3,24(s1)
ffffffffc0204c6a:	2785                	addiw	a5,a5,1
ffffffffc0204c6c:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204c6e:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204c70:	c02007b7          	lui	a5,0xc0200
ffffffffc0204c74:	2cf6e463          	bltu	a3,a5,ffffffffc0204f3c <do_execve+0x47c>
ffffffffc0204c78:	000b3783          	ld	a5,0(s6)
ffffffffc0204c7c:	577d                	li	a4,-1
ffffffffc0204c7e:	177e                	slli	a4,a4,0x3f
ffffffffc0204c80:	8e9d                	sub	a3,a3,a5
ffffffffc0204c82:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204c86:	f654                	sd	a3,168(a2)
ffffffffc0204c88:	8fd9                	or	a5,a5,a4
ffffffffc0204c8a:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204c8e:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c90:	4581                	li	a1,0
ffffffffc0204c92:	12000613          	li	a2,288
ffffffffc0204c96:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204c98:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204c9c:	4b1000ef          	jal	ra,ffffffffc020594c <memset>
    tf->epc = elf->e_entry;
ffffffffc0204ca0:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204ca2:	000db903          	ld	s2,0(s11)
    tf->status = (sstatus & ~(SSTATUS_SPP | SSTATUS_SIE)) | SSTATUS_SPIE;
ffffffffc0204ca6:	edd4f493          	andi	s1,s1,-291
    tf->epc = elf->e_entry;
ffffffffc0204caa:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204cac:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204cae:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_proc_suite_out_size+0xffffffff7fff473c>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204cb2:	07fe                	slli	a5,a5,0x1f
    tf->status = (sstatus & ~(SSTATUS_SPP | SSTATUS_SIE)) | SSTATUS_SPIE;
ffffffffc0204cb4:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204cb8:	4641                	li	a2,16
ffffffffc0204cba:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204cbc:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204cbe:	10e43423          	sd	a4,264(s0)
    tf->status = (sstatus & ~(SSTATUS_SPP | SSTATUS_SIE)) | SSTATUS_SPIE;
ffffffffc0204cc2:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204cc6:	854a                	mv	a0,s2
ffffffffc0204cc8:	485000ef          	jal	ra,ffffffffc020594c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204ccc:	463d                	li	a2,15
ffffffffc0204cce:	180c                	addi	a1,sp,48
ffffffffc0204cd0:	854a                	mv	a0,s2
ffffffffc0204cd2:	48d000ef          	jal	ra,ffffffffc020595e <memcpy>
}
ffffffffc0204cd6:	70aa                	ld	ra,168(sp)
ffffffffc0204cd8:	740a                	ld	s0,160(sp)
ffffffffc0204cda:	64ea                	ld	s1,152(sp)
ffffffffc0204cdc:	694a                	ld	s2,144(sp)
ffffffffc0204cde:	69aa                	ld	s3,136(sp)
ffffffffc0204ce0:	7ae6                	ld	s5,120(sp)
ffffffffc0204ce2:	7b46                	ld	s6,112(sp)
ffffffffc0204ce4:	7ba6                	ld	s7,104(sp)
ffffffffc0204ce6:	7c06                	ld	s8,96(sp)
ffffffffc0204ce8:	6ce6                	ld	s9,88(sp)
ffffffffc0204cea:	6d46                	ld	s10,80(sp)
ffffffffc0204cec:	6da6                	ld	s11,72(sp)
ffffffffc0204cee:	8552                	mv	a0,s4
ffffffffc0204cf0:	6a0a                	ld	s4,128(sp)
ffffffffc0204cf2:	614d                	addi	sp,sp,176
ffffffffc0204cf4:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204cf6:	463d                	li	a2,15
ffffffffc0204cf8:	85ca                	mv	a1,s2
ffffffffc0204cfa:	1808                	addi	a0,sp,48
ffffffffc0204cfc:	463000ef          	jal	ra,ffffffffc020595e <memcpy>
    if (mm != NULL)
ffffffffc0204d00:	e20991e3          	bnez	s3,ffffffffc0204b22 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204d04:	000db783          	ld	a5,0(s11)
ffffffffc0204d08:	779c                	ld	a5,40(a5)
ffffffffc0204d0a:	e40788e3          	beqz	a5,ffffffffc0204b5a <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204d0e:	00002617          	auipc	a2,0x2
ffffffffc0204d12:	6e260613          	addi	a2,a2,1762 # ffffffffc02073f0 <default_pmm_manager+0xc38>
ffffffffc0204d16:	23000593          	li	a1,560
ffffffffc0204d1a:	00002517          	auipc	a0,0x2
ffffffffc0204d1e:	50e50513          	addi	a0,a0,1294 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204d22:	f6cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204d26:	8526                	mv	a0,s1
ffffffffc0204d28:	c80ff0ef          	jal	ra,ffffffffc02041a8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204d2c:	8526                	mv	a0,s1
ffffffffc0204d2e:	da3fe0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204d32:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204d34:	8552                	mv	a0,s4
ffffffffc0204d36:	94bff0ef          	jal	ra,ffffffffc0204680 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204d3a:	5a71                	li	s4,-4
ffffffffc0204d3c:	bfe5                	j	ffffffffc0204d34 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204d3e:	0289b603          	ld	a2,40(s3)
ffffffffc0204d42:	0209b783          	ld	a5,32(s3)
ffffffffc0204d46:	1cf66d63          	bltu	a2,a5,ffffffffc0204f20 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204d4a:	0049a783          	lw	a5,4(s3)
ffffffffc0204d4e:	0017f693          	andi	a3,a5,1
ffffffffc0204d52:	c291                	beqz	a3,ffffffffc0204d56 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204d54:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204d56:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d5a:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204d5c:	e779                	bnez	a4,ffffffffc0204e2a <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204d5e:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204d60:	c781                	beqz	a5,ffffffffc0204d68 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204d62:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204d66:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204d68:	0026f793          	andi	a5,a3,2
ffffffffc0204d6c:	e3f1                	bnez	a5,ffffffffc0204e30 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204d6e:	0046f793          	andi	a5,a3,4
ffffffffc0204d72:	c399                	beqz	a5,ffffffffc0204d78 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204d74:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204d78:	0109b583          	ld	a1,16(s3)
ffffffffc0204d7c:	4701                	li	a4,0
ffffffffc0204d7e:	8526                	mv	a0,s1
ffffffffc0204d80:	da3fe0ef          	jal	ra,ffffffffc0203b22 <mm_map>
ffffffffc0204d84:	8a2a                	mv	s4,a0
ffffffffc0204d86:	ed35                	bnez	a0,ffffffffc0204e02 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d88:	0109bb83          	ld	s7,16(s3)
ffffffffc0204d8c:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d8e:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d92:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204d96:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d9a:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204d9c:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204d9e:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204da0:	054be963          	bltu	s7,s4,ffffffffc0204df2 <do_execve+0x332>
ffffffffc0204da4:	aa95                	j	ffffffffc0204f18 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204da6:	6785                	lui	a5,0x1
ffffffffc0204da8:	415b8533          	sub	a0,s7,s5
ffffffffc0204dac:	9abe                	add	s5,s5,a5
ffffffffc0204dae:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204db2:	015a7463          	bgeu	s4,s5,ffffffffc0204dba <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204db6:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204dba:	000cb683          	ld	a3,0(s9)
ffffffffc0204dbe:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204dc0:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204dc4:	40d406b3          	sub	a3,s0,a3
ffffffffc0204dc8:	8699                	srai	a3,a3,0x6
ffffffffc0204dca:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204dcc:	67e2                	ld	a5,24(sp)
ffffffffc0204dce:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204dd2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204dd4:	14b87863          	bgeu	a6,a1,ffffffffc0204f24 <do_execve+0x464>
ffffffffc0204dd8:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204ddc:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204dde:	9bb2                	add	s7,s7,a2
ffffffffc0204de0:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204de2:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204de4:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204de6:	379000ef          	jal	ra,ffffffffc020595e <memcpy>
            start += size, from += size;
ffffffffc0204dea:	6622                	ld	a2,8(sp)
ffffffffc0204dec:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204dee:	054bf363          	bgeu	s7,s4,ffffffffc0204e34 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204df2:	6c88                	ld	a0,24(s1)
ffffffffc0204df4:	866a                	mv	a2,s10
ffffffffc0204df6:	85d6                	mv	a1,s5
ffffffffc0204df8:	861fe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204dfc:	842a                	mv	s0,a0
ffffffffc0204dfe:	f545                	bnez	a0,ffffffffc0204da6 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204e00:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204e02:	8526                	mv	a0,s1
ffffffffc0204e04:	e71fe0ef          	jal	ra,ffffffffc0203c74 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204e08:	8526                	mv	a0,s1
ffffffffc0204e0a:	b9eff0ef          	jal	ra,ffffffffc02041a8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204e0e:	8526                	mv	a0,s1
ffffffffc0204e10:	cc1fe0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>
    return ret;
ffffffffc0204e14:	b705                	j	ffffffffc0204d34 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204e16:	854e                	mv	a0,s3
ffffffffc0204e18:	e5dfe0ef          	jal	ra,ffffffffc0203c74 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e1c:	854e                	mv	a0,s3
ffffffffc0204e1e:	b8aff0ef          	jal	ra,ffffffffc02041a8 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204e22:	854e                	mv	a0,s3
ffffffffc0204e24:	cadfe0ef          	jal	ra,ffffffffc0203ad0 <mm_destroy>
ffffffffc0204e28:	b32d                	j	ffffffffc0204b52 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204e2a:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204e2e:	fb95                	bnez	a5,ffffffffc0204d62 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204e30:	4d5d                	li	s10,23
ffffffffc0204e32:	bf35                	j	ffffffffc0204d6e <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204e34:	0109b683          	ld	a3,16(s3)
ffffffffc0204e38:	0289b903          	ld	s2,40(s3)
ffffffffc0204e3c:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204e3e:	075bfd63          	bgeu	s7,s5,ffffffffc0204eb8 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204e42:	db790fe3          	beq	s2,s7,ffffffffc0204c00 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204e46:	6785                	lui	a5,0x1
ffffffffc0204e48:	00fb8533          	add	a0,s7,a5
ffffffffc0204e4c:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204e50:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204e54:	0b597d63          	bgeu	s2,s5,ffffffffc0204f0e <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204e58:	000cb683          	ld	a3,0(s9)
ffffffffc0204e5c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e5e:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204e62:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e66:	8699                	srai	a3,a3,0x6
ffffffffc0204e68:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e6a:	67e2                	ld	a5,24(sp)
ffffffffc0204e6c:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e70:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e72:	0ac5f963          	bgeu	a1,a2,ffffffffc0204f24 <do_execve+0x464>
ffffffffc0204e76:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204e7a:	8652                	mv	a2,s4
ffffffffc0204e7c:	4581                	li	a1,0
ffffffffc0204e7e:	96c2                	add	a3,a3,a6
ffffffffc0204e80:	9536                	add	a0,a0,a3
ffffffffc0204e82:	2cb000ef          	jal	ra,ffffffffc020594c <memset>
            start += size;
ffffffffc0204e86:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204e8a:	03597463          	bgeu	s2,s5,ffffffffc0204eb2 <do_execve+0x3f2>
ffffffffc0204e8e:	d6e909e3          	beq	s2,a4,ffffffffc0204c00 <do_execve+0x140>
ffffffffc0204e92:	00002697          	auipc	a3,0x2
ffffffffc0204e96:	58668693          	addi	a3,a3,1414 # ffffffffc0207418 <default_pmm_manager+0xc60>
ffffffffc0204e9a:	00001617          	auipc	a2,0x1
ffffffffc0204e9e:	56e60613          	addi	a2,a2,1390 # ffffffffc0206408 <commands+0x828>
ffffffffc0204ea2:	29e00593          	li	a1,670
ffffffffc0204ea6:	00002517          	auipc	a0,0x2
ffffffffc0204eaa:	38250513          	addi	a0,a0,898 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204eae:	de0fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204eb2:	ff5710e3          	bne	a4,s5,ffffffffc0204e92 <do_execve+0x3d2>
ffffffffc0204eb6:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204eb8:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204c00 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204ebc:	6c88                	ld	a0,24(s1)
ffffffffc0204ebe:	866a                	mv	a2,s10
ffffffffc0204ec0:	85d6                	mv	a1,s5
ffffffffc0204ec2:	f96fe0ef          	jal	ra,ffffffffc0203658 <pgdir_alloc_page>
ffffffffc0204ec6:	842a                	mv	s0,a0
ffffffffc0204ec8:	dd05                	beqz	a0,ffffffffc0204e00 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204eca:	6785                	lui	a5,0x1
ffffffffc0204ecc:	415b8533          	sub	a0,s7,s5
ffffffffc0204ed0:	9abe                	add	s5,s5,a5
ffffffffc0204ed2:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204ed6:	01597463          	bgeu	s2,s5,ffffffffc0204ede <do_execve+0x41e>
                size -= la - end;
ffffffffc0204eda:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204ede:	000cb683          	ld	a3,0(s9)
ffffffffc0204ee2:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ee4:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204ee8:	40d406b3          	sub	a3,s0,a3
ffffffffc0204eec:	8699                	srai	a3,a3,0x6
ffffffffc0204eee:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ef0:	67e2                	ld	a5,24(sp)
ffffffffc0204ef2:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ef6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ef8:	02b87663          	bgeu	a6,a1,ffffffffc0204f24 <do_execve+0x464>
ffffffffc0204efc:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f00:	4581                	li	a1,0
            start += size;
ffffffffc0204f02:	9bb2                	add	s7,s7,a2
ffffffffc0204f04:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f06:	9536                	add	a0,a0,a3
ffffffffc0204f08:	245000ef          	jal	ra,ffffffffc020594c <memset>
ffffffffc0204f0c:	b775                	j	ffffffffc0204eb8 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204f0e:	417a8a33          	sub	s4,s5,s7
ffffffffc0204f12:	b799                	j	ffffffffc0204e58 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204f14:	5a75                	li	s4,-3
ffffffffc0204f16:	b3c1                	j	ffffffffc0204cd6 <do_execve+0x216>
        while (start < end)
ffffffffc0204f18:	86de                	mv	a3,s7
ffffffffc0204f1a:	bf39                	j	ffffffffc0204e38 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204f1c:	5a71                	li	s4,-4
ffffffffc0204f1e:	bdc5                	j	ffffffffc0204e0e <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204f20:	5a61                	li	s4,-8
ffffffffc0204f22:	b5c5                	j	ffffffffc0204e02 <do_execve+0x342>
ffffffffc0204f24:	00002617          	auipc	a2,0x2
ffffffffc0204f28:	8cc60613          	addi	a2,a2,-1844 # ffffffffc02067f0 <default_pmm_manager+0x38>
ffffffffc0204f2c:	07100593          	li	a1,113
ffffffffc0204f30:	00002517          	auipc	a0,0x2
ffffffffc0204f34:	8e850513          	addi	a0,a0,-1816 # ffffffffc0206818 <default_pmm_manager+0x60>
ffffffffc0204f38:	d56fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204f3c:	00002617          	auipc	a2,0x2
ffffffffc0204f40:	95c60613          	addi	a2,a2,-1700 # ffffffffc0206898 <default_pmm_manager+0xe0>
ffffffffc0204f44:	2bd00593          	li	a1,701
ffffffffc0204f48:	00002517          	auipc	a0,0x2
ffffffffc0204f4c:	2e050513          	addi	a0,a0,736 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204f50:	d3efb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f54:	00002697          	auipc	a3,0x2
ffffffffc0204f58:	5dc68693          	addi	a3,a3,1500 # ffffffffc0207530 <default_pmm_manager+0xd78>
ffffffffc0204f5c:	00001617          	auipc	a2,0x1
ffffffffc0204f60:	4ac60613          	addi	a2,a2,1196 # ffffffffc0206408 <commands+0x828>
ffffffffc0204f64:	2b800593          	li	a1,696
ffffffffc0204f68:	00002517          	auipc	a0,0x2
ffffffffc0204f6c:	2c050513          	addi	a0,a0,704 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204f70:	d1efb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f74:	00002697          	auipc	a3,0x2
ffffffffc0204f78:	57468693          	addi	a3,a3,1396 # ffffffffc02074e8 <default_pmm_manager+0xd30>
ffffffffc0204f7c:	00001617          	auipc	a2,0x1
ffffffffc0204f80:	48c60613          	addi	a2,a2,1164 # ffffffffc0206408 <commands+0x828>
ffffffffc0204f84:	2b700593          	li	a1,695
ffffffffc0204f88:	00002517          	auipc	a0,0x2
ffffffffc0204f8c:	2a050513          	addi	a0,a0,672 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204f90:	cfefb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204f94:	00002697          	auipc	a3,0x2
ffffffffc0204f98:	50c68693          	addi	a3,a3,1292 # ffffffffc02074a0 <default_pmm_manager+0xce8>
ffffffffc0204f9c:	00001617          	auipc	a2,0x1
ffffffffc0204fa0:	46c60613          	addi	a2,a2,1132 # ffffffffc0206408 <commands+0x828>
ffffffffc0204fa4:	2b600593          	li	a1,694
ffffffffc0204fa8:	00002517          	auipc	a0,0x2
ffffffffc0204fac:	28050513          	addi	a0,a0,640 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204fb0:	cdefb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204fb4:	00002697          	auipc	a3,0x2
ffffffffc0204fb8:	4a468693          	addi	a3,a3,1188 # ffffffffc0207458 <default_pmm_manager+0xca0>
ffffffffc0204fbc:	00001617          	auipc	a2,0x1
ffffffffc0204fc0:	44c60613          	addi	a2,a2,1100 # ffffffffc0206408 <commands+0x828>
ffffffffc0204fc4:	2b500593          	li	a1,693
ffffffffc0204fc8:	00002517          	auipc	a0,0x2
ffffffffc0204fcc:	26050513          	addi	a0,a0,608 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0204fd0:	cbefb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204fd4 <do_yield>:
    current->need_resched = 1;
ffffffffc0204fd4:	000bc797          	auipc	a5,0xbc
ffffffffc0204fd8:	b847b783          	ld	a5,-1148(a5) # ffffffffc02c0b58 <current>
ffffffffc0204fdc:	4705                	li	a4,1
ffffffffc0204fde:	ef98                	sd	a4,24(a5)
}
ffffffffc0204fe0:	4501                	li	a0,0
ffffffffc0204fe2:	8082                	ret

ffffffffc0204fe4 <do_wait>:
{
ffffffffc0204fe4:	1101                	addi	sp,sp,-32
ffffffffc0204fe6:	e822                	sd	s0,16(sp)
ffffffffc0204fe8:	e426                	sd	s1,8(sp)
ffffffffc0204fea:	ec06                	sd	ra,24(sp)
ffffffffc0204fec:	842e                	mv	s0,a1
ffffffffc0204fee:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204ff0:	c999                	beqz	a1,ffffffffc0205006 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204ff2:	000bc797          	auipc	a5,0xbc
ffffffffc0204ff6:	b667b783          	ld	a5,-1178(a5) # ffffffffc02c0b58 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204ffa:	7788                	ld	a0,40(a5)
ffffffffc0204ffc:	4685                	li	a3,1
ffffffffc0204ffe:	4611                	li	a2,4
ffffffffc0205000:	80eff0ef          	jal	ra,ffffffffc020400e <user_mem_check>
ffffffffc0205004:	c909                	beqz	a0,ffffffffc0205016 <do_wait+0x32>
ffffffffc0205006:	85a2                	mv	a1,s0
}
ffffffffc0205008:	6442                	ld	s0,16(sp)
ffffffffc020500a:	60e2                	ld	ra,24(sp)
ffffffffc020500c:	8526                	mv	a0,s1
ffffffffc020500e:	64a2                	ld	s1,8(sp)
ffffffffc0205010:	6105                	addi	sp,sp,32
ffffffffc0205012:	fb8ff06f          	j	ffffffffc02047ca <do_wait.part.0>
ffffffffc0205016:	60e2                	ld	ra,24(sp)
ffffffffc0205018:	6442                	ld	s0,16(sp)
ffffffffc020501a:	64a2                	ld	s1,8(sp)
ffffffffc020501c:	5575                	li	a0,-3
ffffffffc020501e:	6105                	addi	sp,sp,32
ffffffffc0205020:	8082                	ret

ffffffffc0205022 <do_kill>:
{
ffffffffc0205022:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0205024:	6789                	lui	a5,0x2
{
ffffffffc0205026:	e406                	sd	ra,8(sp)
ffffffffc0205028:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc020502a:	fff5071b          	addiw	a4,a0,-1
ffffffffc020502e:	17f9                	addi	a5,a5,-2
ffffffffc0205030:	02e7e963          	bltu	a5,a4,ffffffffc0205062 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205034:	842a                	mv	s0,a0
ffffffffc0205036:	45a9                	li	a1,10
ffffffffc0205038:	2501                	sext.w	a0,a0
ffffffffc020503a:	46c000ef          	jal	ra,ffffffffc02054a6 <hash32>
ffffffffc020503e:	02051793          	slli	a5,a0,0x20
ffffffffc0205042:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205046:	000b8797          	auipc	a5,0xb8
ffffffffc020504a:	a9a78793          	addi	a5,a5,-1382 # ffffffffc02bcae0 <hash_list>
ffffffffc020504e:	953e                	add	a0,a0,a5
ffffffffc0205050:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0205052:	a029                	j	ffffffffc020505c <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0205054:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0205058:	00870b63          	beq	a4,s0,ffffffffc020506e <do_kill+0x4c>
ffffffffc020505c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020505e:	fef51be3          	bne	a0,a5,ffffffffc0205054 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0205062:	5475                	li	s0,-3
}
ffffffffc0205064:	60a2                	ld	ra,8(sp)
ffffffffc0205066:	8522                	mv	a0,s0
ffffffffc0205068:	6402                	ld	s0,0(sp)
ffffffffc020506a:	0141                	addi	sp,sp,16
ffffffffc020506c:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc020506e:	fd87a703          	lw	a4,-40(a5)
ffffffffc0205072:	00177693          	andi	a3,a4,1
ffffffffc0205076:	e295                	bnez	a3,ffffffffc020509a <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205078:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc020507a:	00176713          	ori	a4,a4,1
ffffffffc020507e:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0205082:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0205084:	fe06d0e3          	bgez	a3,ffffffffc0205064 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0205088:	f2878513          	addi	a0,a5,-216
ffffffffc020508c:	22e000ef          	jal	ra,ffffffffc02052ba <wakeup_proc>
}
ffffffffc0205090:	60a2                	ld	ra,8(sp)
ffffffffc0205092:	8522                	mv	a0,s0
ffffffffc0205094:	6402                	ld	s0,0(sp)
ffffffffc0205096:	0141                	addi	sp,sp,16
ffffffffc0205098:	8082                	ret
        return -E_KILLED;
ffffffffc020509a:	545d                	li	s0,-9
ffffffffc020509c:	b7e1                	j	ffffffffc0205064 <do_kill+0x42>

ffffffffc020509e <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc020509e:	1101                	addi	sp,sp,-32
ffffffffc02050a0:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc02050a2:	000bc797          	auipc	a5,0xbc
ffffffffc02050a6:	a3e78793          	addi	a5,a5,-1474 # ffffffffc02c0ae0 <proc_list>
ffffffffc02050aa:	ec06                	sd	ra,24(sp)
ffffffffc02050ac:	e822                	sd	s0,16(sp)
ffffffffc02050ae:	e04a                	sd	s2,0(sp)
ffffffffc02050b0:	000b8497          	auipc	s1,0xb8
ffffffffc02050b4:	a3048493          	addi	s1,s1,-1488 # ffffffffc02bcae0 <hash_list>
ffffffffc02050b8:	e79c                	sd	a5,8(a5)
ffffffffc02050ba:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc02050bc:	000bc717          	auipc	a4,0xbc
ffffffffc02050c0:	a2470713          	addi	a4,a4,-1500 # ffffffffc02c0ae0 <proc_list>
ffffffffc02050c4:	87a6                	mv	a5,s1
ffffffffc02050c6:	e79c                	sd	a5,8(a5)
ffffffffc02050c8:	e39c                	sd	a5,0(a5)
ffffffffc02050ca:	07c1                	addi	a5,a5,16
ffffffffc02050cc:	fef71de3          	bne	a4,a5,ffffffffc02050c6 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc02050d0:	fdbfe0ef          	jal	ra,ffffffffc02040aa <alloc_proc>
ffffffffc02050d4:	000bc917          	auipc	s2,0xbc
ffffffffc02050d8:	a8c90913          	addi	s2,s2,-1396 # ffffffffc02c0b60 <idleproc>
ffffffffc02050dc:	00a93023          	sd	a0,0(s2)
ffffffffc02050e0:	0e050f63          	beqz	a0,ffffffffc02051de <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02050e4:	4789                	li	a5,2
ffffffffc02050e6:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02050e8:	00003797          	auipc	a5,0x3
ffffffffc02050ec:	f1878793          	addi	a5,a5,-232 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050f0:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02050f4:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc02050f6:	4785                	li	a5,1
ffffffffc02050f8:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02050fa:	4641                	li	a2,16
ffffffffc02050fc:	4581                	li	a1,0
ffffffffc02050fe:	8522                	mv	a0,s0
ffffffffc0205100:	04d000ef          	jal	ra,ffffffffc020594c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205104:	463d                	li	a2,15
ffffffffc0205106:	00002597          	auipc	a1,0x2
ffffffffc020510a:	48a58593          	addi	a1,a1,1162 # ffffffffc0207590 <default_pmm_manager+0xdd8>
ffffffffc020510e:	8522                	mv	a0,s0
ffffffffc0205110:	04f000ef          	jal	ra,ffffffffc020595e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0205114:	000bc717          	auipc	a4,0xbc
ffffffffc0205118:	a5c70713          	addi	a4,a4,-1444 # ffffffffc02c0b70 <nr_process>
ffffffffc020511c:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc020511e:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205122:	4601                	li	a2,0
    nr_process++;
ffffffffc0205124:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205126:	4581                	li	a1,0
ffffffffc0205128:	00000517          	auipc	a0,0x0
ffffffffc020512c:	87450513          	addi	a0,a0,-1932 # ffffffffc020499c <init_main>
    nr_process++;
ffffffffc0205130:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0205132:	000bc797          	auipc	a5,0xbc
ffffffffc0205136:	a2d7b323          	sd	a3,-1498(a5) # ffffffffc02c0b58 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020513a:	cf6ff0ef          	jal	ra,ffffffffc0204630 <kernel_thread>
ffffffffc020513e:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0205140:	08a05363          	blez	a0,ffffffffc02051c6 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0205144:	6789                	lui	a5,0x2
ffffffffc0205146:	fff5071b          	addiw	a4,a0,-1
ffffffffc020514a:	17f9                	addi	a5,a5,-2
ffffffffc020514c:	2501                	sext.w	a0,a0
ffffffffc020514e:	02e7e363          	bltu	a5,a4,ffffffffc0205174 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0205152:	45a9                	li	a1,10
ffffffffc0205154:	352000ef          	jal	ra,ffffffffc02054a6 <hash32>
ffffffffc0205158:	02051793          	slli	a5,a0,0x20
ffffffffc020515c:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0205160:	96a6                	add	a3,a3,s1
ffffffffc0205162:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0205164:	a029                	j	ffffffffc020516e <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0205166:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc020516a:	04870b63          	beq	a4,s0,ffffffffc02051c0 <proc_init+0x122>
    return listelm->next;
ffffffffc020516e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0205170:	fef69be3          	bne	a3,a5,ffffffffc0205166 <proc_init+0xc8>
    return NULL;
ffffffffc0205174:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205176:	0b478493          	addi	s1,a5,180
ffffffffc020517a:	4641                	li	a2,16
ffffffffc020517c:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020517e:	000bc417          	auipc	s0,0xbc
ffffffffc0205182:	9ea40413          	addi	s0,s0,-1558 # ffffffffc02c0b68 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205186:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205188:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020518a:	7c2000ef          	jal	ra,ffffffffc020594c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020518e:	463d                	li	a2,15
ffffffffc0205190:	00002597          	auipc	a1,0x2
ffffffffc0205194:	42858593          	addi	a1,a1,1064 # ffffffffc02075b8 <default_pmm_manager+0xe00>
ffffffffc0205198:	8526                	mv	a0,s1
ffffffffc020519a:	7c4000ef          	jal	ra,ffffffffc020595e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020519e:	00093783          	ld	a5,0(s2)
ffffffffc02051a2:	cbb5                	beqz	a5,ffffffffc0205216 <proc_init+0x178>
ffffffffc02051a4:	43dc                	lw	a5,4(a5)
ffffffffc02051a6:	eba5                	bnez	a5,ffffffffc0205216 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02051a8:	601c                	ld	a5,0(s0)
ffffffffc02051aa:	c7b1                	beqz	a5,ffffffffc02051f6 <proc_init+0x158>
ffffffffc02051ac:	43d8                	lw	a4,4(a5)
ffffffffc02051ae:	4785                	li	a5,1
ffffffffc02051b0:	04f71363          	bne	a4,a5,ffffffffc02051f6 <proc_init+0x158>
}
ffffffffc02051b4:	60e2                	ld	ra,24(sp)
ffffffffc02051b6:	6442                	ld	s0,16(sp)
ffffffffc02051b8:	64a2                	ld	s1,8(sp)
ffffffffc02051ba:	6902                	ld	s2,0(sp)
ffffffffc02051bc:	6105                	addi	sp,sp,32
ffffffffc02051be:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02051c0:	f2878793          	addi	a5,a5,-216
ffffffffc02051c4:	bf4d                	j	ffffffffc0205176 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc02051c6:	00002617          	auipc	a2,0x2
ffffffffc02051ca:	3d260613          	addi	a2,a2,978 # ffffffffc0207598 <default_pmm_manager+0xde0>
ffffffffc02051ce:	3ea00593          	li	a1,1002
ffffffffc02051d2:	00002517          	auipc	a0,0x2
ffffffffc02051d6:	05650513          	addi	a0,a0,86 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc02051da:	ab4fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc02051de:	00002617          	auipc	a2,0x2
ffffffffc02051e2:	39a60613          	addi	a2,a2,922 # ffffffffc0207578 <default_pmm_manager+0xdc0>
ffffffffc02051e6:	3db00593          	li	a1,987
ffffffffc02051ea:	00002517          	auipc	a0,0x2
ffffffffc02051ee:	03e50513          	addi	a0,a0,62 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc02051f2:	a9cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02051f6:	00002697          	auipc	a3,0x2
ffffffffc02051fa:	3f268693          	addi	a3,a3,1010 # ffffffffc02075e8 <default_pmm_manager+0xe30>
ffffffffc02051fe:	00001617          	auipc	a2,0x1
ffffffffc0205202:	20a60613          	addi	a2,a2,522 # ffffffffc0206408 <commands+0x828>
ffffffffc0205206:	3f100593          	li	a1,1009
ffffffffc020520a:	00002517          	auipc	a0,0x2
ffffffffc020520e:	01e50513          	addi	a0,a0,30 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0205212:	a7cfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205216:	00002697          	auipc	a3,0x2
ffffffffc020521a:	3aa68693          	addi	a3,a3,938 # ffffffffc02075c0 <default_pmm_manager+0xe08>
ffffffffc020521e:	00001617          	auipc	a2,0x1
ffffffffc0205222:	1ea60613          	addi	a2,a2,490 # ffffffffc0206408 <commands+0x828>
ffffffffc0205226:	3f000593          	li	a1,1008
ffffffffc020522a:	00002517          	auipc	a0,0x2
ffffffffc020522e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0207228 <default_pmm_manager+0xa70>
ffffffffc0205232:	a5cfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205236 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0205236:	1141                	addi	sp,sp,-16
ffffffffc0205238:	e022                	sd	s0,0(sp)
ffffffffc020523a:	e406                	sd	ra,8(sp)
ffffffffc020523c:	000bc417          	auipc	s0,0xbc
ffffffffc0205240:	91c40413          	addi	s0,s0,-1764 # ffffffffc02c0b58 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0205244:	6018                	ld	a4,0(s0)
ffffffffc0205246:	6f1c                	ld	a5,24(a4)
ffffffffc0205248:	dffd                	beqz	a5,ffffffffc0205246 <cpu_idle+0x10>
        {
            schedule();
ffffffffc020524a:	0f0000ef          	jal	ra,ffffffffc020533a <schedule>
ffffffffc020524e:	bfdd                	j	ffffffffc0205244 <cpu_idle+0xe>

ffffffffc0205250 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0205250:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0205254:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0205258:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020525a:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020525c:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0205260:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0205264:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0205268:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020526c:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0205270:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205274:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205278:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020527c:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0205280:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205284:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205288:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020528c:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020528e:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205290:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205294:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205298:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020529c:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02052a0:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02052a4:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02052a8:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02052ac:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02052b0:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02052b4:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02052b8:	8082                	ret

ffffffffc02052ba <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02052ba:	4118                	lw	a4,0(a0)
{
ffffffffc02052bc:	1101                	addi	sp,sp,-32
ffffffffc02052be:	ec06                	sd	ra,24(sp)
ffffffffc02052c0:	e822                	sd	s0,16(sp)
ffffffffc02052c2:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02052c4:	478d                	li	a5,3
ffffffffc02052c6:	04f70b63          	beq	a4,a5,ffffffffc020531c <wakeup_proc+0x62>
ffffffffc02052ca:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02052cc:	100027f3          	csrr	a5,sstatus
ffffffffc02052d0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02052d2:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02052d4:	ef9d                	bnez	a5,ffffffffc0205312 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc02052d6:	4789                	li	a5,2
ffffffffc02052d8:	02f70163          	beq	a4,a5,ffffffffc02052fa <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc02052dc:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02052de:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc02052e2:	e491                	bnez	s1,ffffffffc02052ee <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02052e4:	60e2                	ld	ra,24(sp)
ffffffffc02052e6:	6442                	ld	s0,16(sp)
ffffffffc02052e8:	64a2                	ld	s1,8(sp)
ffffffffc02052ea:	6105                	addi	sp,sp,32
ffffffffc02052ec:	8082                	ret
ffffffffc02052ee:	6442                	ld	s0,16(sp)
ffffffffc02052f0:	60e2                	ld	ra,24(sp)
ffffffffc02052f2:	64a2                	ld	s1,8(sp)
ffffffffc02052f4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02052f6:	eb8fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc02052fa:	00002617          	auipc	a2,0x2
ffffffffc02052fe:	34e60613          	addi	a2,a2,846 # ffffffffc0207648 <default_pmm_manager+0xe90>
ffffffffc0205302:	45d1                	li	a1,20
ffffffffc0205304:	00002517          	auipc	a0,0x2
ffffffffc0205308:	32c50513          	addi	a0,a0,812 # ffffffffc0207630 <default_pmm_manager+0xe78>
ffffffffc020530c:	9eafb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205310:	bfc9                	j	ffffffffc02052e2 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205312:	ea2fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205316:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205318:	4485                	li	s1,1
ffffffffc020531a:	bf75                	j	ffffffffc02052d6 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020531c:	00002697          	auipc	a3,0x2
ffffffffc0205320:	2f468693          	addi	a3,a3,756 # ffffffffc0207610 <default_pmm_manager+0xe58>
ffffffffc0205324:	00001617          	auipc	a2,0x1
ffffffffc0205328:	0e460613          	addi	a2,a2,228 # ffffffffc0206408 <commands+0x828>
ffffffffc020532c:	45a5                	li	a1,9
ffffffffc020532e:	00002517          	auipc	a0,0x2
ffffffffc0205332:	30250513          	addi	a0,a0,770 # ffffffffc0207630 <default_pmm_manager+0xe78>
ffffffffc0205336:	958fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020533a <schedule>:

void schedule(void)
{
ffffffffc020533a:	1141                	addi	sp,sp,-16
ffffffffc020533c:	e406                	sd	ra,8(sp)
ffffffffc020533e:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205340:	100027f3          	csrr	a5,sstatus
ffffffffc0205344:	8b89                	andi	a5,a5,2
ffffffffc0205346:	4401                	li	s0,0
ffffffffc0205348:	efbd                	bnez	a5,ffffffffc02053c6 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020534a:	000bc897          	auipc	a7,0xbc
ffffffffc020534e:	80e8b883          	ld	a7,-2034(a7) # ffffffffc02c0b58 <current>
ffffffffc0205352:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205356:	000bc517          	auipc	a0,0xbc
ffffffffc020535a:	80a53503          	ld	a0,-2038(a0) # ffffffffc02c0b60 <idleproc>
ffffffffc020535e:	04a88e63          	beq	a7,a0,ffffffffc02053ba <schedule+0x80>
ffffffffc0205362:	0c888693          	addi	a3,a7,200
ffffffffc0205366:	000bb617          	auipc	a2,0xbb
ffffffffc020536a:	77a60613          	addi	a2,a2,1914 # ffffffffc02c0ae0 <proc_list>
        le = last;
ffffffffc020536e:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205370:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205372:	4809                	li	a6,2
ffffffffc0205374:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205376:	00c78863          	beq	a5,a2,ffffffffc0205386 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc020537a:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020537e:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205382:	03070163          	beq	a4,a6,ffffffffc02053a4 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205386:	fef697e3          	bne	a3,a5,ffffffffc0205374 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020538a:	ed89                	bnez	a1,ffffffffc02053a4 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020538c:	451c                	lw	a5,8(a0)
ffffffffc020538e:	2785                	addiw	a5,a5,1
ffffffffc0205390:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205392:	00a88463          	beq	a7,a0,ffffffffc020539a <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205396:	e89fe0ef          	jal	ra,ffffffffc020421e <proc_run>
    if (flag)
ffffffffc020539a:	e819                	bnez	s0,ffffffffc02053b0 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020539c:	60a2                	ld	ra,8(sp)
ffffffffc020539e:	6402                	ld	s0,0(sp)
ffffffffc02053a0:	0141                	addi	sp,sp,16
ffffffffc02053a2:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02053a4:	4198                	lw	a4,0(a1)
ffffffffc02053a6:	4789                	li	a5,2
ffffffffc02053a8:	fef712e3          	bne	a4,a5,ffffffffc020538c <schedule+0x52>
ffffffffc02053ac:	852e                	mv	a0,a1
ffffffffc02053ae:	bff9                	j	ffffffffc020538c <schedule+0x52>
}
ffffffffc02053b0:	6402                	ld	s0,0(sp)
ffffffffc02053b2:	60a2                	ld	ra,8(sp)
ffffffffc02053b4:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02053b6:	df8fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02053ba:	000bb617          	auipc	a2,0xbb
ffffffffc02053be:	72660613          	addi	a2,a2,1830 # ffffffffc02c0ae0 <proc_list>
ffffffffc02053c2:	86b2                	mv	a3,a2
ffffffffc02053c4:	b76d                	j	ffffffffc020536e <schedule+0x34>
        intr_disable();
ffffffffc02053c6:	deefb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02053ca:	4405                	li	s0,1
ffffffffc02053cc:	bfbd                	j	ffffffffc020534a <schedule+0x10>

ffffffffc02053ce <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02053ce:	000bb797          	auipc	a5,0xbb
ffffffffc02053d2:	78a7b783          	ld	a5,1930(a5) # ffffffffc02c0b58 <current>
}
ffffffffc02053d6:	43c8                	lw	a0,4(a5)
ffffffffc02053d8:	8082                	ret

ffffffffc02053da <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02053da:	4501                	li	a0,0
ffffffffc02053dc:	8082                	ret

ffffffffc02053de <sys_putc>:
    cputchar(c);
ffffffffc02053de:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02053e0:	1141                	addi	sp,sp,-16
ffffffffc02053e2:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02053e4:	de7fa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc02053e8:	60a2                	ld	ra,8(sp)
ffffffffc02053ea:	4501                	li	a0,0
ffffffffc02053ec:	0141                	addi	sp,sp,16
ffffffffc02053ee:	8082                	ret

ffffffffc02053f0 <sys_kill>:
    return do_kill(pid);
ffffffffc02053f0:	4108                	lw	a0,0(a0)
ffffffffc02053f2:	c31ff06f          	j	ffffffffc0205022 <do_kill>

ffffffffc02053f6 <sys_yield>:
    return do_yield();
ffffffffc02053f6:	bdfff06f          	j	ffffffffc0204fd4 <do_yield>

ffffffffc02053fa <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02053fa:	6d14                	ld	a3,24(a0)
ffffffffc02053fc:	6910                	ld	a2,16(a0)
ffffffffc02053fe:	650c                	ld	a1,8(a0)
ffffffffc0205400:	6108                	ld	a0,0(a0)
ffffffffc0205402:	ebeff06f          	j	ffffffffc0204ac0 <do_execve>

ffffffffc0205406 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205406:	650c                	ld	a1,8(a0)
ffffffffc0205408:	4108                	lw	a0,0(a0)
ffffffffc020540a:	bdbff06f          	j	ffffffffc0204fe4 <do_wait>

ffffffffc020540e <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020540e:	000bb797          	auipc	a5,0xbb
ffffffffc0205412:	74a7b783          	ld	a5,1866(a5) # ffffffffc02c0b58 <current>
ffffffffc0205416:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205418:	4501                	li	a0,0
ffffffffc020541a:	6a0c                	ld	a1,16(a2)
ffffffffc020541c:	e6ffe06f          	j	ffffffffc020428a <do_fork>

ffffffffc0205420 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205420:	4108                	lw	a0,0(a0)
ffffffffc0205422:	a5eff06f          	j	ffffffffc0204680 <do_exit>

ffffffffc0205426 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0205426:	715d                	addi	sp,sp,-80
ffffffffc0205428:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020542a:	000bb497          	auipc	s1,0xbb
ffffffffc020542e:	72e48493          	addi	s1,s1,1838 # ffffffffc02c0b58 <current>
ffffffffc0205432:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205434:	e0a2                	sd	s0,64(sp)
ffffffffc0205436:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0205438:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020543a:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020543c:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc020543e:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205442:	0327ee63          	bltu	a5,s2,ffffffffc020547e <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc0205446:	00391713          	slli	a4,s2,0x3
ffffffffc020544a:	00002797          	auipc	a5,0x2
ffffffffc020544e:	26678793          	addi	a5,a5,614 # ffffffffc02076b0 <syscalls>
ffffffffc0205452:	97ba                	add	a5,a5,a4
ffffffffc0205454:	639c                	ld	a5,0(a5)
ffffffffc0205456:	c785                	beqz	a5,ffffffffc020547e <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc0205458:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc020545a:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc020545c:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc020545e:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc0205460:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205462:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc0205464:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc0205466:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc0205468:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc020546a:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020546c:	0028                	addi	a0,sp,8
ffffffffc020546e:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205470:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205472:	e828                	sd	a0,80(s0)
}
ffffffffc0205474:	6406                	ld	s0,64(sp)
ffffffffc0205476:	74e2                	ld	s1,56(sp)
ffffffffc0205478:	7942                	ld	s2,48(sp)
ffffffffc020547a:	6161                	addi	sp,sp,80
ffffffffc020547c:	8082                	ret
    print_trapframe(tf);
ffffffffc020547e:	8522                	mv	a0,s0
ffffffffc0205480:	f24fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205484:	609c                	ld	a5,0(s1)
ffffffffc0205486:	86ca                	mv	a3,s2
ffffffffc0205488:	00002617          	auipc	a2,0x2
ffffffffc020548c:	1e060613          	addi	a2,a2,480 # ffffffffc0207668 <default_pmm_manager+0xeb0>
ffffffffc0205490:	43d8                	lw	a4,4(a5)
ffffffffc0205492:	06200593          	li	a1,98
ffffffffc0205496:	0b478793          	addi	a5,a5,180
ffffffffc020549a:	00002517          	auipc	a0,0x2
ffffffffc020549e:	1fe50513          	addi	a0,a0,510 # ffffffffc0207698 <default_pmm_manager+0xee0>
ffffffffc02054a2:	fedfa0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02054a6 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02054a6:	9e3707b7          	lui	a5,0x9e370
ffffffffc02054aa:	2785                	addiw	a5,a5,1
ffffffffc02054ac:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02054b0:	02000793          	li	a5,32
ffffffffc02054b4:	9f8d                	subw	a5,a5,a1
}
ffffffffc02054b6:	00f5553b          	srlw	a0,a0,a5
ffffffffc02054ba:	8082                	ret

ffffffffc02054bc <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02054bc:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02054c0:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02054c2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02054c6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02054c8:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02054cc:	f022                	sd	s0,32(sp)
ffffffffc02054ce:	ec26                	sd	s1,24(sp)
ffffffffc02054d0:	e84a                	sd	s2,16(sp)
ffffffffc02054d2:	f406                	sd	ra,40(sp)
ffffffffc02054d4:	e44e                	sd	s3,8(sp)
ffffffffc02054d6:	84aa                	mv	s1,a0
ffffffffc02054d8:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02054da:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02054de:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02054e0:	03067e63          	bgeu	a2,a6,ffffffffc020551c <printnum+0x60>
ffffffffc02054e4:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02054e6:	00805763          	blez	s0,ffffffffc02054f4 <printnum+0x38>
ffffffffc02054ea:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02054ec:	85ca                	mv	a1,s2
ffffffffc02054ee:	854e                	mv	a0,s3
ffffffffc02054f0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02054f2:	fc65                	bnez	s0,ffffffffc02054ea <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02054f4:	1a02                	slli	s4,s4,0x20
ffffffffc02054f6:	00002797          	auipc	a5,0x2
ffffffffc02054fa:	2ba78793          	addi	a5,a5,698 # ffffffffc02077b0 <syscalls+0x100>
ffffffffc02054fe:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205502:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205504:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205506:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020550a:	70a2                	ld	ra,40(sp)
ffffffffc020550c:	69a2                	ld	s3,8(sp)
ffffffffc020550e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205510:	85ca                	mv	a1,s2
ffffffffc0205512:	87a6                	mv	a5,s1
}
ffffffffc0205514:	6942                	ld	s2,16(sp)
ffffffffc0205516:	64e2                	ld	s1,24(sp)
ffffffffc0205518:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020551a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020551c:	03065633          	divu	a2,a2,a6
ffffffffc0205520:	8722                	mv	a4,s0
ffffffffc0205522:	f9bff0ef          	jal	ra,ffffffffc02054bc <printnum>
ffffffffc0205526:	b7f9                	j	ffffffffc02054f4 <printnum+0x38>

ffffffffc0205528 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0205528:	7119                	addi	sp,sp,-128
ffffffffc020552a:	f4a6                	sd	s1,104(sp)
ffffffffc020552c:	f0ca                	sd	s2,96(sp)
ffffffffc020552e:	ecce                	sd	s3,88(sp)
ffffffffc0205530:	e8d2                	sd	s4,80(sp)
ffffffffc0205532:	e4d6                	sd	s5,72(sp)
ffffffffc0205534:	e0da                	sd	s6,64(sp)
ffffffffc0205536:	fc5e                	sd	s7,56(sp)
ffffffffc0205538:	f06a                	sd	s10,32(sp)
ffffffffc020553a:	fc86                	sd	ra,120(sp)
ffffffffc020553c:	f8a2                	sd	s0,112(sp)
ffffffffc020553e:	f862                	sd	s8,48(sp)
ffffffffc0205540:	f466                	sd	s9,40(sp)
ffffffffc0205542:	ec6e                	sd	s11,24(sp)
ffffffffc0205544:	892a                	mv	s2,a0
ffffffffc0205546:	84ae                	mv	s1,a1
ffffffffc0205548:	8d32                	mv	s10,a2
ffffffffc020554a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020554c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0205550:	5b7d                	li	s6,-1
ffffffffc0205552:	00002a97          	auipc	s5,0x2
ffffffffc0205556:	28aa8a93          	addi	s5,s5,650 # ffffffffc02077dc <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020555a:	00002b97          	auipc	s7,0x2
ffffffffc020555e:	49eb8b93          	addi	s7,s7,1182 # ffffffffc02079f8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205562:	000d4503          	lbu	a0,0(s10)
ffffffffc0205566:	001d0413          	addi	s0,s10,1
ffffffffc020556a:	01350a63          	beq	a0,s3,ffffffffc020557e <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc020556e:	c121                	beqz	a0,ffffffffc02055ae <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0205570:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205572:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205574:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205576:	fff44503          	lbu	a0,-1(s0)
ffffffffc020557a:	ff351ae3          	bne	a0,s3,ffffffffc020556e <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020557e:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205582:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205586:	4c81                	li	s9,0
ffffffffc0205588:	4881                	li	a7,0
        width = precision = -1;
ffffffffc020558a:	5c7d                	li	s8,-1
ffffffffc020558c:	5dfd                	li	s11,-1
ffffffffc020558e:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205592:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205594:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205598:	0ff5f593          	andi	a1,a1,255
ffffffffc020559c:	00140d13          	addi	s10,s0,1
ffffffffc02055a0:	04b56263          	bltu	a0,a1,ffffffffc02055e4 <vprintfmt+0xbc>
ffffffffc02055a4:	058a                	slli	a1,a1,0x2
ffffffffc02055a6:	95d6                	add	a1,a1,s5
ffffffffc02055a8:	4194                	lw	a3,0(a1)
ffffffffc02055aa:	96d6                	add	a3,a3,s5
ffffffffc02055ac:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc02055ae:	70e6                	ld	ra,120(sp)
ffffffffc02055b0:	7446                	ld	s0,112(sp)
ffffffffc02055b2:	74a6                	ld	s1,104(sp)
ffffffffc02055b4:	7906                	ld	s2,96(sp)
ffffffffc02055b6:	69e6                	ld	s3,88(sp)
ffffffffc02055b8:	6a46                	ld	s4,80(sp)
ffffffffc02055ba:	6aa6                	ld	s5,72(sp)
ffffffffc02055bc:	6b06                	ld	s6,64(sp)
ffffffffc02055be:	7be2                	ld	s7,56(sp)
ffffffffc02055c0:	7c42                	ld	s8,48(sp)
ffffffffc02055c2:	7ca2                	ld	s9,40(sp)
ffffffffc02055c4:	7d02                	ld	s10,32(sp)
ffffffffc02055c6:	6de2                	ld	s11,24(sp)
ffffffffc02055c8:	6109                	addi	sp,sp,128
ffffffffc02055ca:	8082                	ret
            padc = '0';
ffffffffc02055cc:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc02055ce:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055d2:	846a                	mv	s0,s10
ffffffffc02055d4:	00140d13          	addi	s10,s0,1
ffffffffc02055d8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02055dc:	0ff5f593          	andi	a1,a1,255
ffffffffc02055e0:	fcb572e3          	bgeu	a0,a1,ffffffffc02055a4 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02055e4:	85a6                	mv	a1,s1
ffffffffc02055e6:	02500513          	li	a0,37
ffffffffc02055ea:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02055ec:	fff44783          	lbu	a5,-1(s0)
ffffffffc02055f0:	8d22                	mv	s10,s0
ffffffffc02055f2:	f73788e3          	beq	a5,s3,ffffffffc0205562 <vprintfmt+0x3a>
ffffffffc02055f6:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02055fa:	1d7d                	addi	s10,s10,-1
ffffffffc02055fc:	ff379de3          	bne	a5,s3,ffffffffc02055f6 <vprintfmt+0xce>
ffffffffc0205600:	b78d                	j	ffffffffc0205562 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205602:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205606:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020560a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020560c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205610:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205614:	02d86463          	bltu	a6,a3,ffffffffc020563c <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0205618:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020561c:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205620:	0186873b          	addw	a4,a3,s8
ffffffffc0205624:	0017171b          	slliw	a4,a4,0x1
ffffffffc0205628:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020562a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020562e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0205630:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0205634:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205638:	fed870e3          	bgeu	a6,a3,ffffffffc0205618 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc020563c:	f40ddce3          	bgez	s11,ffffffffc0205594 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0205640:	8de2                	mv	s11,s8
ffffffffc0205642:	5c7d                	li	s8,-1
ffffffffc0205644:	bf81                	j	ffffffffc0205594 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0205646:	fffdc693          	not	a3,s11
ffffffffc020564a:	96fd                	srai	a3,a3,0x3f
ffffffffc020564c:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205650:	00144603          	lbu	a2,1(s0)
ffffffffc0205654:	2d81                	sext.w	s11,s11
ffffffffc0205656:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205658:	bf35                	j	ffffffffc0205594 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc020565a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020565e:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0205662:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205664:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0205666:	bfd9                	j	ffffffffc020563c <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0205668:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020566a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020566e:	01174463          	blt	a4,a7,ffffffffc0205676 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205672:	1a088e63          	beqz	a7,ffffffffc020582e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205676:	000a3603          	ld	a2,0(s4)
ffffffffc020567a:	46c1                	li	a3,16
ffffffffc020567c:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020567e:	2781                	sext.w	a5,a5
ffffffffc0205680:	876e                	mv	a4,s11
ffffffffc0205682:	85a6                	mv	a1,s1
ffffffffc0205684:	854a                	mv	a0,s2
ffffffffc0205686:	e37ff0ef          	jal	ra,ffffffffc02054bc <printnum>
            break;
ffffffffc020568a:	bde1                	j	ffffffffc0205562 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020568c:	000a2503          	lw	a0,0(s4)
ffffffffc0205690:	85a6                	mv	a1,s1
ffffffffc0205692:	0a21                	addi	s4,s4,8
ffffffffc0205694:	9902                	jalr	s2
            break;
ffffffffc0205696:	b5f1                	j	ffffffffc0205562 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205698:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020569a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020569e:	01174463          	blt	a4,a7,ffffffffc02056a6 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc02056a2:	18088163          	beqz	a7,ffffffffc0205824 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc02056a6:	000a3603          	ld	a2,0(s4)
ffffffffc02056aa:	46a9                	li	a3,10
ffffffffc02056ac:	8a2e                	mv	s4,a1
ffffffffc02056ae:	bfc1                	j	ffffffffc020567e <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056b0:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02056b4:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056b6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02056b8:	bdf1                	j	ffffffffc0205594 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc02056ba:	85a6                	mv	a1,s1
ffffffffc02056bc:	02500513          	li	a0,37
ffffffffc02056c0:	9902                	jalr	s2
            break;
ffffffffc02056c2:	b545                	j	ffffffffc0205562 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056c4:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc02056c8:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056ca:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02056cc:	b5e1                	j	ffffffffc0205594 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc02056ce:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056d0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056d4:	01174463          	blt	a4,a7,ffffffffc02056dc <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02056d8:	14088163          	beqz	a7,ffffffffc020581a <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02056dc:	000a3603          	ld	a2,0(s4)
ffffffffc02056e0:	46a1                	li	a3,8
ffffffffc02056e2:	8a2e                	mv	s4,a1
ffffffffc02056e4:	bf69                	j	ffffffffc020567e <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02056e6:	03000513          	li	a0,48
ffffffffc02056ea:	85a6                	mv	a1,s1
ffffffffc02056ec:	e03e                	sd	a5,0(sp)
ffffffffc02056ee:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02056f0:	85a6                	mv	a1,s1
ffffffffc02056f2:	07800513          	li	a0,120
ffffffffc02056f6:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056f8:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02056fa:	6782                	ld	a5,0(sp)
ffffffffc02056fc:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02056fe:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205702:	bfb5                	j	ffffffffc020567e <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205704:	000a3403          	ld	s0,0(s4)
ffffffffc0205708:	008a0713          	addi	a4,s4,8
ffffffffc020570c:	e03a                	sd	a4,0(sp)
ffffffffc020570e:	14040263          	beqz	s0,ffffffffc0205852 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0205712:	0fb05763          	blez	s11,ffffffffc0205800 <vprintfmt+0x2d8>
ffffffffc0205716:	02d00693          	li	a3,45
ffffffffc020571a:	0cd79163          	bne	a5,a3,ffffffffc02057dc <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020571e:	00044783          	lbu	a5,0(s0)
ffffffffc0205722:	0007851b          	sext.w	a0,a5
ffffffffc0205726:	cf85                	beqz	a5,ffffffffc020575e <vprintfmt+0x236>
ffffffffc0205728:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020572c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205730:	000c4563          	bltz	s8,ffffffffc020573a <vprintfmt+0x212>
ffffffffc0205734:	3c7d                	addiw	s8,s8,-1
ffffffffc0205736:	036c0263          	beq	s8,s6,ffffffffc020575a <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc020573a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020573c:	0e0c8e63          	beqz	s9,ffffffffc0205838 <vprintfmt+0x310>
ffffffffc0205740:	3781                	addiw	a5,a5,-32
ffffffffc0205742:	0ef47b63          	bgeu	s0,a5,ffffffffc0205838 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0205746:	03f00513          	li	a0,63
ffffffffc020574a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020574c:	000a4783          	lbu	a5,0(s4)
ffffffffc0205750:	3dfd                	addiw	s11,s11,-1
ffffffffc0205752:	0a05                	addi	s4,s4,1
ffffffffc0205754:	0007851b          	sext.w	a0,a5
ffffffffc0205758:	ffe1                	bnez	a5,ffffffffc0205730 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc020575a:	01b05963          	blez	s11,ffffffffc020576c <vprintfmt+0x244>
ffffffffc020575e:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0205760:	85a6                	mv	a1,s1
ffffffffc0205762:	02000513          	li	a0,32
ffffffffc0205766:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0205768:	fe0d9be3          	bnez	s11,ffffffffc020575e <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020576c:	6a02                	ld	s4,0(sp)
ffffffffc020576e:	bbd5                	j	ffffffffc0205562 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205770:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205772:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205776:	01174463          	blt	a4,a7,ffffffffc020577e <vprintfmt+0x256>
    else if (lflag) {
ffffffffc020577a:	08088d63          	beqz	a7,ffffffffc0205814 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020577e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205782:	0a044d63          	bltz	s0,ffffffffc020583c <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205786:	8622                	mv	a2,s0
ffffffffc0205788:	8a66                	mv	s4,s9
ffffffffc020578a:	46a9                	li	a3,10
ffffffffc020578c:	bdcd                	j	ffffffffc020567e <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020578e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205792:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205794:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205796:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020579a:	8fb5                	xor	a5,a5,a3
ffffffffc020579c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02057a0:	02d74163          	blt	a4,a3,ffffffffc02057c2 <vprintfmt+0x29a>
ffffffffc02057a4:	00369793          	slli	a5,a3,0x3
ffffffffc02057a8:	97de                	add	a5,a5,s7
ffffffffc02057aa:	639c                	ld	a5,0(a5)
ffffffffc02057ac:	cb99                	beqz	a5,ffffffffc02057c2 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc02057ae:	86be                	mv	a3,a5
ffffffffc02057b0:	00000617          	auipc	a2,0x0
ffffffffc02057b4:	1f060613          	addi	a2,a2,496 # ffffffffc02059a0 <etext+0x2a>
ffffffffc02057b8:	85a6                	mv	a1,s1
ffffffffc02057ba:	854a                	mv	a0,s2
ffffffffc02057bc:	0ce000ef          	jal	ra,ffffffffc020588a <printfmt>
ffffffffc02057c0:	b34d                	j	ffffffffc0205562 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc02057c2:	00002617          	auipc	a2,0x2
ffffffffc02057c6:	00e60613          	addi	a2,a2,14 # ffffffffc02077d0 <syscalls+0x120>
ffffffffc02057ca:	85a6                	mv	a1,s1
ffffffffc02057cc:	854a                	mv	a0,s2
ffffffffc02057ce:	0bc000ef          	jal	ra,ffffffffc020588a <printfmt>
ffffffffc02057d2:	bb41                	j	ffffffffc0205562 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc02057d4:	00002417          	auipc	s0,0x2
ffffffffc02057d8:	ff440413          	addi	s0,s0,-12 # ffffffffc02077c8 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057dc:	85e2                	mv	a1,s8
ffffffffc02057de:	8522                	mv	a0,s0
ffffffffc02057e0:	e43e                	sd	a5,8(sp)
ffffffffc02057e2:	0e2000ef          	jal	ra,ffffffffc02058c4 <strnlen>
ffffffffc02057e6:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02057ea:	01b05b63          	blez	s11,ffffffffc0205800 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02057ee:	67a2                	ld	a5,8(sp)
ffffffffc02057f0:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057f4:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02057f6:	85a6                	mv	a1,s1
ffffffffc02057f8:	8552                	mv	a0,s4
ffffffffc02057fa:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02057fc:	fe0d9ce3          	bnez	s11,ffffffffc02057f4 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205800:	00044783          	lbu	a5,0(s0)
ffffffffc0205804:	00140a13          	addi	s4,s0,1
ffffffffc0205808:	0007851b          	sext.w	a0,a5
ffffffffc020580c:	d3a5                	beqz	a5,ffffffffc020576c <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020580e:	05e00413          	li	s0,94
ffffffffc0205812:	bf39                	j	ffffffffc0205730 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0205814:	000a2403          	lw	s0,0(s4)
ffffffffc0205818:	b7ad                	j	ffffffffc0205782 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020581a:	000a6603          	lwu	a2,0(s4)
ffffffffc020581e:	46a1                	li	a3,8
ffffffffc0205820:	8a2e                	mv	s4,a1
ffffffffc0205822:	bdb1                	j	ffffffffc020567e <vprintfmt+0x156>
ffffffffc0205824:	000a6603          	lwu	a2,0(s4)
ffffffffc0205828:	46a9                	li	a3,10
ffffffffc020582a:	8a2e                	mv	s4,a1
ffffffffc020582c:	bd89                	j	ffffffffc020567e <vprintfmt+0x156>
ffffffffc020582e:	000a6603          	lwu	a2,0(s4)
ffffffffc0205832:	46c1                	li	a3,16
ffffffffc0205834:	8a2e                	mv	s4,a1
ffffffffc0205836:	b5a1                	j	ffffffffc020567e <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0205838:	9902                	jalr	s2
ffffffffc020583a:	bf09                	j	ffffffffc020574c <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc020583c:	85a6                	mv	a1,s1
ffffffffc020583e:	02d00513          	li	a0,45
ffffffffc0205842:	e03e                	sd	a5,0(sp)
ffffffffc0205844:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0205846:	6782                	ld	a5,0(sp)
ffffffffc0205848:	8a66                	mv	s4,s9
ffffffffc020584a:	40800633          	neg	a2,s0
ffffffffc020584e:	46a9                	li	a3,10
ffffffffc0205850:	b53d                	j	ffffffffc020567e <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0205852:	03b05163          	blez	s11,ffffffffc0205874 <vprintfmt+0x34c>
ffffffffc0205856:	02d00693          	li	a3,45
ffffffffc020585a:	f6d79de3          	bne	a5,a3,ffffffffc02057d4 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc020585e:	00002417          	auipc	s0,0x2
ffffffffc0205862:	f6a40413          	addi	s0,s0,-150 # ffffffffc02077c8 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205866:	02800793          	li	a5,40
ffffffffc020586a:	02800513          	li	a0,40
ffffffffc020586e:	00140a13          	addi	s4,s0,1
ffffffffc0205872:	bd6d                	j	ffffffffc020572c <vprintfmt+0x204>
ffffffffc0205874:	00002a17          	auipc	s4,0x2
ffffffffc0205878:	f55a0a13          	addi	s4,s4,-171 # ffffffffc02077c9 <syscalls+0x119>
ffffffffc020587c:	02800513          	li	a0,40
ffffffffc0205880:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205884:	05e00413          	li	s0,94
ffffffffc0205888:	b565                	j	ffffffffc0205730 <vprintfmt+0x208>

ffffffffc020588a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020588a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020588c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205890:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205892:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205894:	ec06                	sd	ra,24(sp)
ffffffffc0205896:	f83a                	sd	a4,48(sp)
ffffffffc0205898:	fc3e                	sd	a5,56(sp)
ffffffffc020589a:	e0c2                	sd	a6,64(sp)
ffffffffc020589c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020589e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02058a0:	c89ff0ef          	jal	ra,ffffffffc0205528 <vprintfmt>
}
ffffffffc02058a4:	60e2                	ld	ra,24(sp)
ffffffffc02058a6:	6161                	addi	sp,sp,80
ffffffffc02058a8:	8082                	ret

ffffffffc02058aa <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02058aa:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02058ae:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02058b0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02058b2:	cb81                	beqz	a5,ffffffffc02058c2 <strlen+0x18>
        cnt ++;
ffffffffc02058b4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02058b6:	00a707b3          	add	a5,a4,a0
ffffffffc02058ba:	0007c783          	lbu	a5,0(a5)
ffffffffc02058be:	fbfd                	bnez	a5,ffffffffc02058b4 <strlen+0xa>
ffffffffc02058c0:	8082                	ret
    }
    return cnt;
}
ffffffffc02058c2:	8082                	ret

ffffffffc02058c4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02058c4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02058c6:	e589                	bnez	a1,ffffffffc02058d0 <strnlen+0xc>
ffffffffc02058c8:	a811                	j	ffffffffc02058dc <strnlen+0x18>
        cnt ++;
ffffffffc02058ca:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02058cc:	00f58863          	beq	a1,a5,ffffffffc02058dc <strnlen+0x18>
ffffffffc02058d0:	00f50733          	add	a4,a0,a5
ffffffffc02058d4:	00074703          	lbu	a4,0(a4)
ffffffffc02058d8:	fb6d                	bnez	a4,ffffffffc02058ca <strnlen+0x6>
ffffffffc02058da:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02058dc:	852e                	mv	a0,a1
ffffffffc02058de:	8082                	ret

ffffffffc02058e0 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02058e0:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02058e2:	0005c703          	lbu	a4,0(a1)
ffffffffc02058e6:	0785                	addi	a5,a5,1
ffffffffc02058e8:	0585                	addi	a1,a1,1
ffffffffc02058ea:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02058ee:	fb75                	bnez	a4,ffffffffc02058e2 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02058f0:	8082                	ret

ffffffffc02058f2 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02058f2:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02058f6:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02058fa:	cb89                	beqz	a5,ffffffffc020590c <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02058fc:	0505                	addi	a0,a0,1
ffffffffc02058fe:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205900:	fee789e3          	beq	a5,a4,ffffffffc02058f2 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205904:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205908:	9d19                	subw	a0,a0,a4
ffffffffc020590a:	8082                	ret
ffffffffc020590c:	4501                	li	a0,0
ffffffffc020590e:	bfed                	j	ffffffffc0205908 <strcmp+0x16>

ffffffffc0205910 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205910:	c20d                	beqz	a2,ffffffffc0205932 <strncmp+0x22>
ffffffffc0205912:	962e                	add	a2,a2,a1
ffffffffc0205914:	a031                	j	ffffffffc0205920 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205916:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205918:	00e79a63          	bne	a5,a4,ffffffffc020592c <strncmp+0x1c>
ffffffffc020591c:	00b60b63          	beq	a2,a1,ffffffffc0205932 <strncmp+0x22>
ffffffffc0205920:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205924:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205926:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020592a:	f7f5                	bnez	a5,ffffffffc0205916 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020592c:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0205930:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205932:	4501                	li	a0,0
ffffffffc0205934:	8082                	ret

ffffffffc0205936 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205936:	00054783          	lbu	a5,0(a0)
ffffffffc020593a:	c799                	beqz	a5,ffffffffc0205948 <strchr+0x12>
        if (*s == c) {
ffffffffc020593c:	00f58763          	beq	a1,a5,ffffffffc020594a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0205940:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205944:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205946:	fbfd                	bnez	a5,ffffffffc020593c <strchr+0x6>
    }
    return NULL;
ffffffffc0205948:	4501                	li	a0,0
}
ffffffffc020594a:	8082                	ret

ffffffffc020594c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020594c:	ca01                	beqz	a2,ffffffffc020595c <memset+0x10>
ffffffffc020594e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205950:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205952:	0785                	addi	a5,a5,1
ffffffffc0205954:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205958:	fec79de3          	bne	a5,a2,ffffffffc0205952 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020595c:	8082                	ret

ffffffffc020595e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc020595e:	ca19                	beqz	a2,ffffffffc0205974 <memcpy+0x16>
ffffffffc0205960:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205962:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205964:	0005c703          	lbu	a4,0(a1)
ffffffffc0205968:	0585                	addi	a1,a1,1
ffffffffc020596a:	0785                	addi	a5,a5,1
ffffffffc020596c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205970:	fec59ae3          	bne	a1,a2,ffffffffc0205964 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205974:	8082                	ret
