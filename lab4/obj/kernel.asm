
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49e60613          	addi	a2,a2,1182 # ffffffffc020d4f0 <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0207ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	6d1030ef          	jal	ffffffffc0203f32 <memset>
    dtb_init();
ffffffffc0200066:	4c2000ef          	jal	ffffffffc0200528 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	44c000ef          	jal	ffffffffc02004b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	f1258593          	addi	a1,a1,-238 # ffffffffc0203f80 <etext>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	f2a50513          	addi	a0,a0,-214 # ffffffffc0203fa0 <etext+0x20>
ffffffffc020007e:	116000ef          	jal	ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	158000ef          	jal	ffffffffc02001da <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	1e8020ef          	jal	ffffffffc020226e <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	7f0000ef          	jal	ffffffffc020087a <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	7ee000ef          	jal	ffffffffc020087c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	759020ef          	jal	ffffffffc0202fea <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	664030ef          	jal	ffffffffc02036fa <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	3ca000ef          	jal	ffffffffc0200464 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	7d0000ef          	jal	ffffffffc020086e <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	0b1030ef          	jal	ffffffffc0203952 <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	7179                	addi	sp,sp,-48
ffffffffc02000a8:	f406                	sd	ra,40(sp)
ffffffffc02000aa:	f022                	sd	s0,32(sp)
ffffffffc02000ac:	ec26                	sd	s1,24(sp)
ffffffffc02000ae:	e84a                	sd	s2,16(sp)
ffffffffc02000b0:	e44e                	sd	s3,8(sp)
    if (prompt != NULL) {
ffffffffc02000b2:	c901                	beqz	a0,ffffffffc02000c2 <readline+0x1c>
        cprintf("%s", prompt);
ffffffffc02000b4:	85aa                	mv	a1,a0
ffffffffc02000b6:	00004517          	auipc	a0,0x4
ffffffffc02000ba:	ef250513          	addi	a0,a0,-270 # ffffffffc0203fa8 <etext+0x28>
ffffffffc02000be:	0d6000ef          	jal	ffffffffc0200194 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000c2:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c4:	497d                	li	s2,31
            buf[i ++] = c;
ffffffffc02000c6:	00009997          	auipc	s3,0x9
ffffffffc02000ca:	f6a98993          	addi	s3,s3,-150 # ffffffffc0209030 <buf>
        c = getchar();
ffffffffc02000ce:	0fc000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc02000d2:	842a                	mv	s0,a0
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000d4:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000d8:	3ff4a713          	slti	a4,s1,1023
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000dc:	ff650693          	addi	a3,a0,-10
ffffffffc02000e0:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc02000e4:	02054963          	bltz	a0,ffffffffc0200116 <readline+0x70>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e8:	02a95f63          	bge	s2,a0,ffffffffc0200126 <readline+0x80>
ffffffffc02000ec:	cf0d                	beqz	a4,ffffffffc0200126 <readline+0x80>
            cputchar(c);
ffffffffc02000ee:	0da000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i ++] = c;
ffffffffc02000f2:	009987b3          	add	a5,s3,s1
ffffffffc02000f6:	00878023          	sb	s0,0(a5)
ffffffffc02000fa:	2485                	addiw	s1,s1,1
        c = getchar();
ffffffffc02000fc:	0ce000ef          	jal	ffffffffc02001ca <getchar>
ffffffffc0200100:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200102:	ff850793          	addi	a5,a0,-8
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200106:	3ff4a713          	slti	a4,s1,1023
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	ff650693          	addi	a3,a0,-10
ffffffffc020010e:	ff350613          	addi	a2,a0,-13
        if (c < 0) {
ffffffffc0200112:	fc055be3          	bgez	a0,ffffffffc02000e8 <readline+0x42>
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
}
ffffffffc0200116:	70a2                	ld	ra,40(sp)
ffffffffc0200118:	7402                	ld	s0,32(sp)
ffffffffc020011a:	64e2                	ld	s1,24(sp)
ffffffffc020011c:	6942                	ld	s2,16(sp)
ffffffffc020011e:	69a2                	ld	s3,8(sp)
            return NULL;
ffffffffc0200120:	4501                	li	a0,0
}
ffffffffc0200122:	6145                	addi	sp,sp,48
ffffffffc0200124:	8082                	ret
        else if (c == '\b' && i > 0) {
ffffffffc0200126:	eb81                	bnez	a5,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc0200128:	4521                	li	a0,8
        else if (c == '\b' && i > 0) {
ffffffffc020012a:	00905663          	blez	s1,ffffffffc0200136 <readline+0x90>
            cputchar(c);
ffffffffc020012e:	09a000ef          	jal	ffffffffc02001c8 <cputchar>
            i --;
ffffffffc0200132:	34fd                	addiw	s1,s1,-1
ffffffffc0200134:	bf69                	j	ffffffffc02000ce <readline+0x28>
        else if (c == '\n' || c == '\r') {
ffffffffc0200136:	c291                	beqz	a3,ffffffffc020013a <readline+0x94>
ffffffffc0200138:	fa59                	bnez	a2,ffffffffc02000ce <readline+0x28>
            cputchar(c);
ffffffffc020013a:	8522                	mv	a0,s0
ffffffffc020013c:	08c000ef          	jal	ffffffffc02001c8 <cputchar>
            buf[i] = '\0';
ffffffffc0200140:	00009517          	auipc	a0,0x9
ffffffffc0200144:	ef050513          	addi	a0,a0,-272 # ffffffffc0209030 <buf>
ffffffffc0200148:	94aa                	add	s1,s1,a0
ffffffffc020014a:	00048023          	sb	zero,0(s1)
}
ffffffffc020014e:	70a2                	ld	ra,40(sp)
ffffffffc0200150:	7402                	ld	s0,32(sp)
ffffffffc0200152:	64e2                	ld	s1,24(sp)
ffffffffc0200154:	6942                	ld	s2,16(sp)
ffffffffc0200156:	69a2                	ld	s3,8(sp)
ffffffffc0200158:	6145                	addi	sp,sp,48
ffffffffc020015a:	8082                	ret

ffffffffc020015c <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	ec06                	sd	ra,24(sp)
ffffffffc0200160:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200162:	356000ef          	jal	ffffffffc02004b8 <cons_putc>
    (*cnt)++;
ffffffffc0200166:	65a2                	ld	a1,8(sp)
}
ffffffffc0200168:	60e2                	ld	ra,24(sp)
    (*cnt)++;
ffffffffc020016a:	419c                	lw	a5,0(a1)
ffffffffc020016c:	2785                	addiw	a5,a5,1
ffffffffc020016e:	c19c                	sw	a5,0(a1)
}
ffffffffc0200170:	6105                	addi	sp,sp,32
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
ffffffffc020017e:	fe250513          	addi	a0,a0,-30 # ffffffffc020015c <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	191030ef          	jal	ffffffffc0203b18 <vprintfmt>
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
ffffffffc0200196:	02810313          	addi	t1,sp,40
{
ffffffffc020019a:	f42e                	sd	a1,40(sp)
ffffffffc020019c:	f832                	sd	a2,48(sp)
ffffffffc020019e:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a0:	862a                	mv	a2,a0
ffffffffc02001a2:	004c                	addi	a1,sp,4
ffffffffc02001a4:	00000517          	auipc	a0,0x0
ffffffffc02001a8:	fb850513          	addi	a0,a0,-72 # ffffffffc020015c <cputch>
ffffffffc02001ac:	869a                	mv	a3,t1
{
ffffffffc02001ae:	ec06                	sd	ra,24(sp)
ffffffffc02001b0:	e0ba                	sd	a4,64(sp)
ffffffffc02001b2:	e4be                	sd	a5,72(sp)
ffffffffc02001b4:	e8c2                	sd	a6,80(sp)
ffffffffc02001b6:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc02001b8:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001bc:	15d030ef          	jal	ffffffffc0203b18 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c0:	60e2                	ld	ra,24(sp)
ffffffffc02001c2:	4512                	lw	a0,4(sp)
ffffffffc02001c4:	6125                	addi	sp,sp,96
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001c8:	acc5                	j	ffffffffc02004b8 <cons_putc>

ffffffffc02001ca <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc02001ca:	1141                	addi	sp,sp,-16
ffffffffc02001cc:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001ce:	31e000ef          	jal	ffffffffc02004ec <cons_getc>
ffffffffc02001d2:	dd75                	beqz	a0,ffffffffc02001ce <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001d4:	60a2                	ld	ra,8(sp)
ffffffffc02001d6:	0141                	addi	sp,sp,16
ffffffffc02001d8:	8082                	ret

ffffffffc02001da <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02001da:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001dc:	00004517          	auipc	a0,0x4
ffffffffc02001e0:	dd450513          	addi	a0,a0,-556 # ffffffffc0203fb0 <etext+0x30>
{
ffffffffc02001e4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001e6:	fafff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001ea:	00000597          	auipc	a1,0x0
ffffffffc02001ee:	e6058593          	addi	a1,a1,-416 # ffffffffc020004a <kern_init>
ffffffffc02001f2:	00004517          	auipc	a0,0x4
ffffffffc02001f6:	dde50513          	addi	a0,a0,-546 # ffffffffc0203fd0 <etext+0x50>
ffffffffc02001fa:	f9bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02001fe:	00004597          	auipc	a1,0x4
ffffffffc0200202:	d8258593          	addi	a1,a1,-638 # ffffffffc0203f80 <etext>
ffffffffc0200206:	00004517          	auipc	a0,0x4
ffffffffc020020a:	dea50513          	addi	a0,a0,-534 # ffffffffc0203ff0 <etext+0x70>
ffffffffc020020e:	f87ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200212:	00009597          	auipc	a1,0x9
ffffffffc0200216:	e1e58593          	addi	a1,a1,-482 # ffffffffc0209030 <buf>
ffffffffc020021a:	00004517          	auipc	a0,0x4
ffffffffc020021e:	df650513          	addi	a0,a0,-522 # ffffffffc0204010 <etext+0x90>
ffffffffc0200222:	f73ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200226:	0000d597          	auipc	a1,0xd
ffffffffc020022a:	2ca58593          	addi	a1,a1,714 # ffffffffc020d4f0 <end>
ffffffffc020022e:	00004517          	auipc	a0,0x4
ffffffffc0200232:	e0250513          	addi	a0,a0,-510 # ffffffffc0204030 <etext+0xb0>
ffffffffc0200236:	f5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020023a:	00000717          	auipc	a4,0x0
ffffffffc020023e:	e1070713          	addi	a4,a4,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000d797          	auipc	a5,0xd
ffffffffc0200246:	6ad78793          	addi	a5,a5,1709 # ffffffffc020d8ef <end+0x3ff>
ffffffffc020024a:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020024c:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200250:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200252:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200256:	95be                	add	a1,a1,a5
ffffffffc0200258:	85a9                	srai	a1,a1,0xa
ffffffffc020025a:	00004517          	auipc	a0,0x4
ffffffffc020025e:	df650513          	addi	a0,a0,-522 # ffffffffc0204050 <etext+0xd0>
}
ffffffffc0200262:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200264:	bf05                	j	ffffffffc0200194 <cprintf>

ffffffffc0200266 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc0200266:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200268:	00004617          	auipc	a2,0x4
ffffffffc020026c:	e1860613          	addi	a2,a2,-488 # ffffffffc0204080 <etext+0x100>
ffffffffc0200270:	04900593          	li	a1,73
ffffffffc0200274:	00004517          	auipc	a0,0x4
ffffffffc0200278:	e2450513          	addi	a0,a0,-476 # ffffffffc0204098 <etext+0x118>
{
ffffffffc020027c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020027e:	188000ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0200282 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200282:	1101                	addi	sp,sp,-32
ffffffffc0200284:	e822                	sd	s0,16(sp)
ffffffffc0200286:	e426                	sd	s1,8(sp)
ffffffffc0200288:	ec06                	sd	ra,24(sp)
ffffffffc020028a:	00005417          	auipc	s0,0x5
ffffffffc020028e:	6ce40413          	addi	s0,s0,1742 # ffffffffc0205958 <commands>
ffffffffc0200292:	00005497          	auipc	s1,0x5
ffffffffc0200296:	70e48493          	addi	s1,s1,1806 # ffffffffc02059a0 <commands+0x48>
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020029a:	6410                	ld	a2,8(s0)
ffffffffc020029c:	600c                	ld	a1,0(s0)
ffffffffc020029e:	00004517          	auipc	a0,0x4
ffffffffc02002a2:	e1250513          	addi	a0,a0,-494 # ffffffffc02040b0 <etext+0x130>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002a6:	0461                	addi	s0,s0,24
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002a8:	eedff0ef          	jal	ffffffffc0200194 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ac:	fe9417e3          	bne	s0,s1,ffffffffc020029a <mon_help+0x18>
    }
    return 0;
}
ffffffffc02002b0:	60e2                	ld	ra,24(sp)
ffffffffc02002b2:	6442                	ld	s0,16(sp)
ffffffffc02002b4:	64a2                	ld	s1,8(sp)
ffffffffc02002b6:	4501                	li	a0,0
ffffffffc02002b8:	6105                	addi	sp,sp,32
ffffffffc02002ba:	8082                	ret

ffffffffc02002bc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002bc:	1141                	addi	sp,sp,-16
ffffffffc02002be:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002c0:	f1bff0ef          	jal	ffffffffc02001da <print_kerninfo>
    return 0;
}
ffffffffc02002c4:	60a2                	ld	ra,8(sp)
ffffffffc02002c6:	4501                	li	a0,0
ffffffffc02002c8:	0141                	addi	sp,sp,16
ffffffffc02002ca:	8082                	ret

ffffffffc02002cc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	1141                	addi	sp,sp,-16
ffffffffc02002ce:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002d0:	f97ff0ef          	jal	ffffffffc0200266 <print_stackframe>
    return 0;
}
ffffffffc02002d4:	60a2                	ld	ra,8(sp)
ffffffffc02002d6:	4501                	li	a0,0
ffffffffc02002d8:	0141                	addi	sp,sp,16
ffffffffc02002da:	8082                	ret

ffffffffc02002dc <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002dc:	7131                	addi	sp,sp,-192
ffffffffc02002de:	e952                	sd	s4,144(sp)
ffffffffc02002e0:	8a2a                	mv	s4,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002e2:	00004517          	auipc	a0,0x4
ffffffffc02002e6:	dde50513          	addi	a0,a0,-546 # ffffffffc02040c0 <etext+0x140>
kmonitor(struct trapframe *tf) {
ffffffffc02002ea:	fd06                	sd	ra,184(sp)
ffffffffc02002ec:	f922                	sd	s0,176(sp)
ffffffffc02002ee:	f526                	sd	s1,168(sp)
ffffffffc02002f0:	f14a                	sd	s2,160(sp)
ffffffffc02002f2:	e556                	sd	s5,136(sp)
ffffffffc02002f4:	e15a                	sd	s6,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f6:	e9fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002fa:	00004517          	auipc	a0,0x4
ffffffffc02002fe:	dee50513          	addi	a0,a0,-530 # ffffffffc02040e8 <etext+0x168>
ffffffffc0200302:	e93ff0ef          	jal	ffffffffc0200194 <cprintf>
    if (tf != NULL) {
ffffffffc0200306:	000a0563          	beqz	s4,ffffffffc0200310 <kmonitor+0x34>
        print_trapframe(tf);
ffffffffc020030a:	8552                	mv	a0,s4
ffffffffc020030c:	758000ef          	jal	ffffffffc0200a64 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200310:	4501                	li	a0,0
ffffffffc0200312:	4581                	li	a1,0
ffffffffc0200314:	4601                	li	a2,0
ffffffffc0200316:	48a1                	li	a7,8
ffffffffc0200318:	00000073          	ecall
ffffffffc020031c:	00005a97          	auipc	s5,0x5
ffffffffc0200320:	63ca8a93          	addi	s5,s5,1596 # ffffffffc0205958 <commands>
        if (argc == MAXARGS - 1) {
ffffffffc0200324:	493d                	li	s2,15
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200326:	00004517          	auipc	a0,0x4
ffffffffc020032a:	dea50513          	addi	a0,a0,-534 # ffffffffc0204110 <etext+0x190>
ffffffffc020032e:	d79ff0ef          	jal	ffffffffc02000a6 <readline>
ffffffffc0200332:	842a                	mv	s0,a0
ffffffffc0200334:	d96d                	beqz	a0,ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200336:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020033a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033c:	e99d                	bnez	a1,ffffffffc0200372 <kmonitor+0x96>
    int argc = 0;
ffffffffc020033e:	8b26                	mv	s6,s1
    if (argc == 0) {
ffffffffc0200340:	fe0b03e3          	beqz	s6,ffffffffc0200326 <kmonitor+0x4a>
ffffffffc0200344:	00005497          	auipc	s1,0x5
ffffffffc0200348:	61448493          	addi	s1,s1,1556 # ffffffffc0205958 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020034e:	6582                	ld	a1,0(sp)
ffffffffc0200350:	6088                	ld	a0,0(s1)
ffffffffc0200352:	373030ef          	jal	ffffffffc0203ec4 <strcmp>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200356:	478d                	li	a5,3
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200358:	c149                	beqz	a0,ffffffffc02003da <kmonitor+0xfe>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020035a:	2405                	addiw	s0,s0,1
ffffffffc020035c:	04e1                	addi	s1,s1,24
ffffffffc020035e:	fef418e3          	bne	s0,a5,ffffffffc020034e <kmonitor+0x72>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200362:	6582                	ld	a1,0(sp)
ffffffffc0200364:	00004517          	auipc	a0,0x4
ffffffffc0200368:	ddc50513          	addi	a0,a0,-548 # ffffffffc0204140 <etext+0x1c0>
ffffffffc020036c:	e29ff0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
ffffffffc0200370:	bf5d                	j	ffffffffc0200326 <kmonitor+0x4a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200372:	00004517          	auipc	a0,0x4
ffffffffc0200376:	da650513          	addi	a0,a0,-602 # ffffffffc0204118 <etext+0x198>
ffffffffc020037a:	3a7030ef          	jal	ffffffffc0203f20 <strchr>
ffffffffc020037e:	c901                	beqz	a0,ffffffffc020038e <kmonitor+0xb2>
ffffffffc0200380:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200384:	00040023          	sb	zero,0(s0)
ffffffffc0200388:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038a:	d9d5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc020038c:	b7dd                	j	ffffffffc0200372 <kmonitor+0x96>
        if (*buf == '\0') {
ffffffffc020038e:	00044783          	lbu	a5,0(s0)
ffffffffc0200392:	d7d5                	beqz	a5,ffffffffc020033e <kmonitor+0x62>
        if (argc == MAXARGS - 1) {
ffffffffc0200394:	03248b63          	beq	s1,s2,ffffffffc02003ca <kmonitor+0xee>
        argv[argc ++] = buf;
ffffffffc0200398:	00349793          	slli	a5,s1,0x3
ffffffffc020039c:	978a                	add	a5,a5,sp
ffffffffc020039e:	e380                	sd	s0,0(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a0:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003a4:	2485                	addiw	s1,s1,1
ffffffffc02003a6:	8b26                	mv	s6,s1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a8:	e591                	bnez	a1,ffffffffc02003b4 <kmonitor+0xd8>
ffffffffc02003aa:	bf59                	j	ffffffffc0200340 <kmonitor+0x64>
ffffffffc02003ac:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003b0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003b2:	d5d1                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003b4:	00004517          	auipc	a0,0x4
ffffffffc02003b8:	d6450513          	addi	a0,a0,-668 # ffffffffc0204118 <etext+0x198>
ffffffffc02003bc:	365030ef          	jal	ffffffffc0203f20 <strchr>
ffffffffc02003c0:	d575                	beqz	a0,ffffffffc02003ac <kmonitor+0xd0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003c2:	00044583          	lbu	a1,0(s0)
ffffffffc02003c6:	dda5                	beqz	a1,ffffffffc020033e <kmonitor+0x62>
ffffffffc02003c8:	b76d                	j	ffffffffc0200372 <kmonitor+0x96>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ca:	45c1                	li	a1,16
ffffffffc02003cc:	00004517          	auipc	a0,0x4
ffffffffc02003d0:	d5450513          	addi	a0,a0,-684 # ffffffffc0204120 <etext+0x1a0>
ffffffffc02003d4:	dc1ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc02003d8:	b7c1                	j	ffffffffc0200398 <kmonitor+0xbc>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003da:	00141793          	slli	a5,s0,0x1
ffffffffc02003de:	97a2                	add	a5,a5,s0
ffffffffc02003e0:	078e                	slli	a5,a5,0x3
ffffffffc02003e2:	97d6                	add	a5,a5,s5
ffffffffc02003e4:	6b9c                	ld	a5,16(a5)
ffffffffc02003e6:	fffb051b          	addiw	a0,s6,-1
ffffffffc02003ea:	8652                	mv	a2,s4
ffffffffc02003ec:	002c                	addi	a1,sp,8
ffffffffc02003ee:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003f0:	f2055be3          	bgez	a0,ffffffffc0200326 <kmonitor+0x4a>
}
ffffffffc02003f4:	70ea                	ld	ra,184(sp)
ffffffffc02003f6:	744a                	ld	s0,176(sp)
ffffffffc02003f8:	74aa                	ld	s1,168(sp)
ffffffffc02003fa:	790a                	ld	s2,160(sp)
ffffffffc02003fc:	6a4a                	ld	s4,144(sp)
ffffffffc02003fe:	6aaa                	ld	s5,136(sp)
ffffffffc0200400:	6b0a                	ld	s6,128(sp)
ffffffffc0200402:	6129                	addi	sp,sp,192
ffffffffc0200404:	8082                	ret

ffffffffc0200406 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200406:	0000d317          	auipc	t1,0xd
ffffffffc020040a:	06232303          	lw	t1,98(t1) # ffffffffc020d468 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc020040e:	715d                	addi	sp,sp,-80
ffffffffc0200410:	ec06                	sd	ra,24(sp)
ffffffffc0200412:	f436                	sd	a3,40(sp)
ffffffffc0200414:	f83a                	sd	a4,48(sp)
ffffffffc0200416:	fc3e                	sd	a5,56(sp)
ffffffffc0200418:	e0c2                	sd	a6,64(sp)
ffffffffc020041a:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc020041c:	02031e63          	bnez	t1,ffffffffc0200458 <__panic+0x52>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200420:	4705                	li	a4,1

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200422:	103c                	addi	a5,sp,40
ffffffffc0200424:	e822                	sd	s0,16(sp)
ffffffffc0200426:	8432                	mv	s0,a2
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200428:	862e                	mv	a2,a1
ffffffffc020042a:	85aa                	mv	a1,a0
ffffffffc020042c:	00004517          	auipc	a0,0x4
ffffffffc0200430:	dbc50513          	addi	a0,a0,-580 # ffffffffc02041e8 <etext+0x268>
    is_panic = 1;
ffffffffc0200434:	0000d697          	auipc	a3,0xd
ffffffffc0200438:	02e6aa23          	sw	a4,52(a3) # ffffffffc020d468 <is_panic>
    va_start(ap, fmt);
ffffffffc020043c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020043e:	d57ff0ef          	jal	ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200442:	65a2                	ld	a1,8(sp)
ffffffffc0200444:	8522                	mv	a0,s0
ffffffffc0200446:	d2fff0ef          	jal	ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020044a:	00004517          	auipc	a0,0x4
ffffffffc020044e:	dbe50513          	addi	a0,a0,-578 # ffffffffc0204208 <etext+0x288>
ffffffffc0200452:	d43ff0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0200456:	6442                	ld	s0,16(sp)
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200458:	41c000ef          	jal	ffffffffc0200874 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020045c:	4501                	li	a0,0
ffffffffc020045e:	e7fff0ef          	jal	ffffffffc02002dc <kmonitor>
    while (1) {
ffffffffc0200462:	bfed                	j	ffffffffc020045c <__panic+0x56>

ffffffffc0200464 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200464:	67e1                	lui	a5,0x18
ffffffffc0200466:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046a:	0000d717          	auipc	a4,0xd
ffffffffc020046e:	00f73323          	sd	a5,6(a4) # ffffffffc020d470 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200472:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200476:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200478:	953e                	add	a0,a0,a5
ffffffffc020047a:	4601                	li	a2,0
ffffffffc020047c:	4881                	li	a7,0
ffffffffc020047e:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200482:	02000793          	li	a5,32
ffffffffc0200486:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020048a:	00004517          	auipc	a0,0x4
ffffffffc020048e:	d8650513          	addi	a0,a0,-634 # ffffffffc0204210 <etext+0x290>
    ticks = 0;
ffffffffc0200492:	0000d797          	auipc	a5,0xd
ffffffffc0200496:	fe07b323          	sd	zero,-26(a5) # ffffffffc020d478 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020049a:	b9ed                	j	ffffffffc0200194 <cprintf>

ffffffffc020049c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020049c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004a0:	0000d797          	auipc	a5,0xd
ffffffffc02004a4:	fd07b783          	ld	a5,-48(a5) # ffffffffc020d470 <timebase>
ffffffffc02004a8:	4581                	li	a1,0
ffffffffc02004aa:	4601                	li	a2,0
ffffffffc02004ac:	953e                	add	a0,a0,a5
ffffffffc02004ae:	4881                	li	a7,0
ffffffffc02004b0:	00000073          	ecall
ffffffffc02004b4:	8082                	ret

ffffffffc02004b6 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004b8:	100027f3          	csrr	a5,sstatus
ffffffffc02004bc:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02004be:	0ff57513          	zext.b	a0,a0
ffffffffc02004c2:	e799                	bnez	a5,ffffffffc02004d0 <cons_putc+0x18>
ffffffffc02004c4:	4581                	li	a1,0
ffffffffc02004c6:	4601                	li	a2,0
ffffffffc02004c8:	4885                	li	a7,1
ffffffffc02004ca:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02004ce:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02004d0:	1101                	addi	sp,sp,-32
ffffffffc02004d2:	ec06                	sd	ra,24(sp)
ffffffffc02004d4:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02004d6:	39e000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02004da:	6522                	ld	a0,8(sp)
ffffffffc02004dc:	4581                	li	a1,0
ffffffffc02004de:	4601                	li	a2,0
ffffffffc02004e0:	4885                	li	a7,1
ffffffffc02004e2:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004e6:	60e2                	ld	ra,24(sp)
ffffffffc02004e8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004ea:	a651                	j	ffffffffc020086e <intr_enable>

ffffffffc02004ec <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004ec:	100027f3          	csrr	a5,sstatus
ffffffffc02004f0:	8b89                	andi	a5,a5,2
ffffffffc02004f2:	eb89                	bnez	a5,ffffffffc0200504 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004f4:	4501                	li	a0,0
ffffffffc02004f6:	4581                	li	a1,0
ffffffffc02004f8:	4601                	li	a2,0
ffffffffc02004fa:	4889                	li	a7,2
ffffffffc02004fc:	00000073          	ecall
ffffffffc0200500:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200502:	8082                	ret
int cons_getc(void) {
ffffffffc0200504:	1101                	addi	sp,sp,-32
ffffffffc0200506:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200508:	36c000ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020050c:	4501                	li	a0,0
ffffffffc020050e:	4581                	li	a1,0
ffffffffc0200510:	4601                	li	a2,0
ffffffffc0200512:	4889                	li	a7,2
ffffffffc0200514:	00000073          	ecall
ffffffffc0200518:	2501                	sext.w	a0,a0
ffffffffc020051a:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020051c:	352000ef          	jal	ffffffffc020086e <intr_enable>
}
ffffffffc0200520:	60e2                	ld	ra,24(sp)
ffffffffc0200522:	6522                	ld	a0,8(sp)
ffffffffc0200524:	6105                	addi	sp,sp,32
ffffffffc0200526:	8082                	ret

ffffffffc0200528 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200528:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020052a:	00004517          	auipc	a0,0x4
ffffffffc020052e:	d0650513          	addi	a0,a0,-762 # ffffffffc0204230 <etext+0x2b0>
void dtb_init(void) {
ffffffffc0200532:	f406                	sd	ra,40(sp)
ffffffffc0200534:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200536:	c5fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020053a:	00009597          	auipc	a1,0x9
ffffffffc020053e:	ac65b583          	ld	a1,-1338(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc0200542:	00004517          	auipc	a0,0x4
ffffffffc0200546:	cfe50513          	addi	a0,a0,-770 # ffffffffc0204240 <etext+0x2c0>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020054a:	00009417          	auipc	s0,0x9
ffffffffc020054e:	abe40413          	addi	s0,s0,-1346 # ffffffffc0209008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200552:	c43ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200556:	600c                	ld	a1,0(s0)
ffffffffc0200558:	00004517          	auipc	a0,0x4
ffffffffc020055c:	cf850513          	addi	a0,a0,-776 # ffffffffc0204250 <etext+0x2d0>
ffffffffc0200560:	c35ff0ef          	jal	ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200564:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200566:	00004517          	auipc	a0,0x4
ffffffffc020056a:	d0250513          	addi	a0,a0,-766 # ffffffffc0204268 <etext+0x2e8>
    if (boot_dtb == 0) {
ffffffffc020056e:	10070163          	beqz	a4,ffffffffc0200670 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200572:	57f5                	li	a5,-3
ffffffffc0200574:	07fa                	slli	a5,a5,0x1e
ffffffffc0200576:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200578:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020057a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020057e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed29fd>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200582:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200586:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020058a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200592:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200596:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200598:	8e49                	or	a2,a2,a0
ffffffffc020059a:	0ff7f793          	zext.b	a5,a5
ffffffffc020059e:	8dd1                	or	a1,a1,a2
ffffffffc02005a0:	07a2                	slli	a5,a5,0x8
ffffffffc02005a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02005a8:	0cd59863          	bne	a1,a3,ffffffffc0200678 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005ac:	4710                	lw	a2,8(a4)
ffffffffc02005ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02005b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02005be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02005c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02005ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02005da:	01c56533          	or	a0,a0,t3
ffffffffc02005de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02005f2:	8c49                	or	s0,s0,a0
ffffffffc02005f4:	0622                	slli	a2,a2,0x8
ffffffffc02005f6:	8fcd                	or	a5,a5,a1
ffffffffc02005f8:	06a2                	slli	a3,a3,0x8
ffffffffc02005fa:	8c51                	or	s0,s0,a2
ffffffffc02005fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200600:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200602:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200604:	9381                	srli	a5,a5,0x20
ffffffffc0200606:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200608:	4301                	li	t1,0
        switch (token) {
ffffffffc020060a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020060c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020060e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200612:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200614:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200616:	0087579b          	srliw	a5,a4,0x8
ffffffffc020061a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020061e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200622:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200626:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020062e:	8ed1                	or	a3,a3,a2
ffffffffc0200630:	0ff77713          	zext.b	a4,a4
ffffffffc0200634:	8fd5                	or	a5,a5,a3
ffffffffc0200636:	0722                	slli	a4,a4,0x8
ffffffffc0200638:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020063a:	05178763          	beq	a5,a7,ffffffffc0200688 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020063e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200640:	00f8e963          	bltu	a7,a5,ffffffffc0200652 <dtb_init+0x12a>
ffffffffc0200644:	07c78d63          	beq	a5,t3,ffffffffc02006be <dtb_init+0x196>
ffffffffc0200648:	4709                	li	a4,2
ffffffffc020064a:	00e79763          	bne	a5,a4,ffffffffc0200658 <dtb_init+0x130>
ffffffffc020064e:	4301                	li	t1,0
ffffffffc0200650:	b7d1                	j	ffffffffc0200614 <dtb_init+0xec>
ffffffffc0200652:	4711                	li	a4,4
ffffffffc0200654:	fce780e3          	beq	a5,a4,ffffffffc0200614 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200658:	00004517          	auipc	a0,0x4
ffffffffc020065c:	cd850513          	addi	a0,a0,-808 # ffffffffc0204330 <etext+0x3b0>
ffffffffc0200660:	b35ff0ef          	jal	ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200664:	64e2                	ld	s1,24(sp)
ffffffffc0200666:	6942                	ld	s2,16(sp)
ffffffffc0200668:	00004517          	auipc	a0,0x4
ffffffffc020066c:	d0050513          	addi	a0,a0,-768 # ffffffffc0204368 <etext+0x3e8>
}
ffffffffc0200670:	7402                	ld	s0,32(sp)
ffffffffc0200672:	70a2                	ld	ra,40(sp)
ffffffffc0200674:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200676:	be39                	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200678:	7402                	ld	s0,32(sp)
ffffffffc020067a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020067c:	00004517          	auipc	a0,0x4
ffffffffc0200680:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0204288 <etext+0x308>
}
ffffffffc0200684:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200686:	b639                	j	ffffffffc0200194 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200688:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020068e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200696:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020069e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006a2:	8ed1                	or	a3,a3,a2
ffffffffc02006a4:	0ff77713          	zext.b	a4,a4
ffffffffc02006a8:	8fd5                	or	a5,a5,a3
ffffffffc02006aa:	0722                	slli	a4,a4,0x8
ffffffffc02006ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006ae:	04031463          	bnez	t1,ffffffffc02006f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006b2:	1782                	slli	a5,a5,0x20
ffffffffc02006b4:	9381                	srli	a5,a5,0x20
ffffffffc02006b6:	043d                	addi	s0,s0,15
ffffffffc02006b8:	943e                	add	s0,s0,a5
ffffffffc02006ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02006bc:	bfa1                	j	ffffffffc0200614 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02006be:	8522                	mv	a0,s0
ffffffffc02006c0:	e01a                	sd	t1,0(sp)
ffffffffc02006c2:	7bc030ef          	jal	ffffffffc0203e7e <strlen>
ffffffffc02006c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006c8:	4619                	li	a2,6
ffffffffc02006ca:	8522                	mv	a0,s0
ffffffffc02006cc:	00004597          	auipc	a1,0x4
ffffffffc02006d0:	be458593          	addi	a1,a1,-1052 # ffffffffc02042b0 <etext+0x330>
ffffffffc02006d4:	025030ef          	jal	ffffffffc0203ef8 <strncmp>
ffffffffc02006d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006da:	0411                	addi	s0,s0,4
ffffffffc02006dc:	0004879b          	sext.w	a5,s1
ffffffffc02006e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02006e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02006e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02006ec:	00ff0837          	lui	a6,0xff0
ffffffffc02006f0:	488d                	li	a7,3
ffffffffc02006f2:	4e05                	li	t3,1
ffffffffc02006f4:	b705                	j	ffffffffc0200614 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f8:	00004597          	auipc	a1,0x4
ffffffffc02006fc:	bc058593          	addi	a1,a1,-1088 # ffffffffc02042b8 <etext+0x338>
ffffffffc0200700:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200702:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200706:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020070a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020070e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200712:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200716:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071a:	8ed1                	or	a3,a3,a2
ffffffffc020071c:	0ff77713          	zext.b	a4,a4
ffffffffc0200720:	0722                	slli	a4,a4,0x8
ffffffffc0200722:	8d55                	or	a0,a0,a3
ffffffffc0200724:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200726:	1502                	slli	a0,a0,0x20
ffffffffc0200728:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020072a:	954a                	add	a0,a0,s2
ffffffffc020072c:	e01a                	sd	t1,0(sp)
ffffffffc020072e:	796030ef          	jal	ffffffffc0203ec4 <strcmp>
ffffffffc0200732:	67a2                	ld	a5,8(sp)
ffffffffc0200734:	473d                	li	a4,15
ffffffffc0200736:	6302                	ld	t1,0(sp)
ffffffffc0200738:	00ff0837          	lui	a6,0xff0
ffffffffc020073c:	488d                	li	a7,3
ffffffffc020073e:	4e05                	li	t3,1
ffffffffc0200740:	f6f779e3          	bgeu	a4,a5,ffffffffc02006b2 <dtb_init+0x18a>
ffffffffc0200744:	f53d                	bnez	a0,ffffffffc02006b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200746:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020074a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020074e:	00004517          	auipc	a0,0x4
ffffffffc0200752:	b7250513          	addi	a0,a0,-1166 # ffffffffc02042c0 <etext+0x340>
           fdt32_to_cpu(x >> 32);
ffffffffc0200756:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020075e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200762:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200766:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020076a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020076e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200772:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200776:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020077a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077e:	01037333          	and	t1,t1,a6
ffffffffc0200782:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200786:	01e5e5b3          	or	a1,a1,t5
ffffffffc020078a:	0ff7f793          	zext.b	a5,a5
ffffffffc020078e:	01de6e33          	or	t3,t3,t4
ffffffffc0200792:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200796:	01067633          	and	a2,a2,a6
ffffffffc020079a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020079e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	07a2                	slli	a5,a5,0x8
ffffffffc02007a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02007a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02007ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02007b0:	8ddd                	or	a1,a1,a5
ffffffffc02007b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02007ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d6:	08a2                	slli	a7,a7,0x8
ffffffffc02007d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02007e4:	01de6833          	or	a6,t3,t4
ffffffffc02007e8:	0ff77713          	zext.b	a4,a4
ffffffffc02007ec:	01166633          	or	a2,a2,a7
ffffffffc02007f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02007f4:	06a2                	slli	a3,a3,0x8
ffffffffc02007f6:	01046433          	or	s0,s0,a6
ffffffffc02007fa:	0722                	slli	a4,a4,0x8
ffffffffc02007fc:	8fd5                	or	a5,a5,a3
ffffffffc02007fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200800:	1582                	slli	a1,a1,0x20
ffffffffc0200802:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200804:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200806:	9201                	srli	a2,a2,0x20
ffffffffc0200808:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020080a:	1402                	slli	s0,s0,0x20
ffffffffc020080c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200810:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200812:	983ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200816:	85a6                	mv	a1,s1
ffffffffc0200818:	00004517          	auipc	a0,0x4
ffffffffc020081c:	ac850513          	addi	a0,a0,-1336 # ffffffffc02042e0 <etext+0x360>
ffffffffc0200820:	975ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200824:	01445613          	srli	a2,s0,0x14
ffffffffc0200828:	85a2                	mv	a1,s0
ffffffffc020082a:	00004517          	auipc	a0,0x4
ffffffffc020082e:	ace50513          	addi	a0,a0,-1330 # ffffffffc02042f8 <etext+0x378>
ffffffffc0200832:	963ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200836:	009405b3          	add	a1,s0,s1
ffffffffc020083a:	15fd                	addi	a1,a1,-1
ffffffffc020083c:	00004517          	auipc	a0,0x4
ffffffffc0200840:	adc50513          	addi	a0,a0,-1316 # ffffffffc0204318 <etext+0x398>
ffffffffc0200844:	951ff0ef          	jal	ffffffffc0200194 <cprintf>
        memory_base = mem_base;
ffffffffc0200848:	0000d797          	auipc	a5,0xd
ffffffffc020084c:	c497b023          	sd	s1,-960(a5) # ffffffffc020d488 <memory_base>
        memory_size = mem_size;
ffffffffc0200850:	0000d797          	auipc	a5,0xd
ffffffffc0200854:	c287b823          	sd	s0,-976(a5) # ffffffffc020d480 <memory_size>
ffffffffc0200858:	b531                	j	ffffffffc0200664 <dtb_init+0x13c>

ffffffffc020085a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020085a:	0000d517          	auipc	a0,0xd
ffffffffc020085e:	c2e53503          	ld	a0,-978(a0) # ffffffffc020d488 <memory_base>
ffffffffc0200862:	8082                	ret

ffffffffc0200864 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200864:	0000d517          	auipc	a0,0xd
ffffffffc0200868:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d480 <memory_size>
ffffffffc020086c:	8082                	ret

ffffffffc020086e <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020086e:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200872:	8082                	ret

ffffffffc0200874 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200874:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200878:	8082                	ret

ffffffffc020087a <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020087a:	8082                	ret

ffffffffc020087c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020087c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200880:	00000797          	auipc	a5,0x0
ffffffffc0200884:	51478793          	addi	a5,a5,1300 # ffffffffc0200d94 <__alltraps>
ffffffffc0200888:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020088c:	000407b7          	lui	a5,0x40
ffffffffc0200890:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200894:	8082                	ret

ffffffffc0200896 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200896:	610c                	ld	a1,0(a0)
{
ffffffffc0200898:	1141                	addi	sp,sp,-16
ffffffffc020089a:	e022                	sd	s0,0(sp)
ffffffffc020089c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020089e:	00004517          	auipc	a0,0x4
ffffffffc02008a2:	ae250513          	addi	a0,a0,-1310 # ffffffffc0204380 <etext+0x400>
{
ffffffffc02008a6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02008a8:	8edff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02008ac:	640c                	ld	a1,8(s0)
ffffffffc02008ae:	00004517          	auipc	a0,0x4
ffffffffc02008b2:	aea50513          	addi	a0,a0,-1302 # ffffffffc0204398 <etext+0x418>
ffffffffc02008b6:	8dfff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02008ba:	680c                	ld	a1,16(s0)
ffffffffc02008bc:	00004517          	auipc	a0,0x4
ffffffffc02008c0:	af450513          	addi	a0,a0,-1292 # ffffffffc02043b0 <etext+0x430>
ffffffffc02008c4:	8d1ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02008c8:	6c0c                	ld	a1,24(s0)
ffffffffc02008ca:	00004517          	auipc	a0,0x4
ffffffffc02008ce:	afe50513          	addi	a0,a0,-1282 # ffffffffc02043c8 <etext+0x448>
ffffffffc02008d2:	8c3ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02008d6:	700c                	ld	a1,32(s0)
ffffffffc02008d8:	00004517          	auipc	a0,0x4
ffffffffc02008dc:	b0850513          	addi	a0,a0,-1272 # ffffffffc02043e0 <etext+0x460>
ffffffffc02008e0:	8b5ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02008e4:	740c                	ld	a1,40(s0)
ffffffffc02008e6:	00004517          	auipc	a0,0x4
ffffffffc02008ea:	b1250513          	addi	a0,a0,-1262 # ffffffffc02043f8 <etext+0x478>
ffffffffc02008ee:	8a7ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02008f2:	780c                	ld	a1,48(s0)
ffffffffc02008f4:	00004517          	auipc	a0,0x4
ffffffffc02008f8:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0204410 <etext+0x490>
ffffffffc02008fc:	899ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200900:	7c0c                	ld	a1,56(s0)
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	b2650513          	addi	a0,a0,-1242 # ffffffffc0204428 <etext+0x4a8>
ffffffffc020090a:	88bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc020090e:	602c                	ld	a1,64(s0)
ffffffffc0200910:	00004517          	auipc	a0,0x4
ffffffffc0200914:	b3050513          	addi	a0,a0,-1232 # ffffffffc0204440 <etext+0x4c0>
ffffffffc0200918:	87dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc020091c:	642c                	ld	a1,72(s0)
ffffffffc020091e:	00004517          	auipc	a0,0x4
ffffffffc0200922:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0204458 <etext+0x4d8>
ffffffffc0200926:	86fff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020092a:	682c                	ld	a1,80(s0)
ffffffffc020092c:	00004517          	auipc	a0,0x4
ffffffffc0200930:	b4450513          	addi	a0,a0,-1212 # ffffffffc0204470 <etext+0x4f0>
ffffffffc0200934:	861ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200938:	6c2c                	ld	a1,88(s0)
ffffffffc020093a:	00004517          	auipc	a0,0x4
ffffffffc020093e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0204488 <etext+0x508>
ffffffffc0200942:	853ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200946:	702c                	ld	a1,96(s0)
ffffffffc0200948:	00004517          	auipc	a0,0x4
ffffffffc020094c:	b5850513          	addi	a0,a0,-1192 # ffffffffc02044a0 <etext+0x520>
ffffffffc0200950:	845ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200954:	742c                	ld	a1,104(s0)
ffffffffc0200956:	00004517          	auipc	a0,0x4
ffffffffc020095a:	b6250513          	addi	a0,a0,-1182 # ffffffffc02044b8 <etext+0x538>
ffffffffc020095e:	837ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200962:	782c                	ld	a1,112(s0)
ffffffffc0200964:	00004517          	auipc	a0,0x4
ffffffffc0200968:	b6c50513          	addi	a0,a0,-1172 # ffffffffc02044d0 <etext+0x550>
ffffffffc020096c:	829ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200970:	7c2c                	ld	a1,120(s0)
ffffffffc0200972:	00004517          	auipc	a0,0x4
ffffffffc0200976:	b7650513          	addi	a0,a0,-1162 # ffffffffc02044e8 <etext+0x568>
ffffffffc020097a:	81bff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020097e:	604c                	ld	a1,128(s0)
ffffffffc0200980:	00004517          	auipc	a0,0x4
ffffffffc0200984:	b8050513          	addi	a0,a0,-1152 # ffffffffc0204500 <etext+0x580>
ffffffffc0200988:	80dff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020098c:	644c                	ld	a1,136(s0)
ffffffffc020098e:	00004517          	auipc	a0,0x4
ffffffffc0200992:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0204518 <etext+0x598>
ffffffffc0200996:	ffeff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020099a:	684c                	ld	a1,144(s0)
ffffffffc020099c:	00004517          	auipc	a0,0x4
ffffffffc02009a0:	b9450513          	addi	a0,a0,-1132 # ffffffffc0204530 <etext+0x5b0>
ffffffffc02009a4:	ff0ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02009a8:	6c4c                	ld	a1,152(s0)
ffffffffc02009aa:	00004517          	auipc	a0,0x4
ffffffffc02009ae:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0204548 <etext+0x5c8>
ffffffffc02009b2:	fe2ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02009b6:	704c                	ld	a1,160(s0)
ffffffffc02009b8:	00004517          	auipc	a0,0x4
ffffffffc02009bc:	ba850513          	addi	a0,a0,-1112 # ffffffffc0204560 <etext+0x5e0>
ffffffffc02009c0:	fd4ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02009c4:	744c                	ld	a1,168(s0)
ffffffffc02009c6:	00004517          	auipc	a0,0x4
ffffffffc02009ca:	bb250513          	addi	a0,a0,-1102 # ffffffffc0204578 <etext+0x5f8>
ffffffffc02009ce:	fc6ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02009d2:	784c                	ld	a1,176(s0)
ffffffffc02009d4:	00004517          	auipc	a0,0x4
ffffffffc02009d8:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0204590 <etext+0x610>
ffffffffc02009dc:	fb8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02009e0:	7c4c                	ld	a1,184(s0)
ffffffffc02009e2:	00004517          	auipc	a0,0x4
ffffffffc02009e6:	bc650513          	addi	a0,a0,-1082 # ffffffffc02045a8 <etext+0x628>
ffffffffc02009ea:	faaff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009ee:	606c                	ld	a1,192(s0)
ffffffffc02009f0:	00004517          	auipc	a0,0x4
ffffffffc02009f4:	bd050513          	addi	a0,a0,-1072 # ffffffffc02045c0 <etext+0x640>
ffffffffc02009f8:	f9cff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02009fc:	646c                	ld	a1,200(s0)
ffffffffc02009fe:	00004517          	auipc	a0,0x4
ffffffffc0200a02:	bda50513          	addi	a0,a0,-1062 # ffffffffc02045d8 <etext+0x658>
ffffffffc0200a06:	f8eff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200a0a:	686c                	ld	a1,208(s0)
ffffffffc0200a0c:	00004517          	auipc	a0,0x4
ffffffffc0200a10:	be450513          	addi	a0,a0,-1052 # ffffffffc02045f0 <etext+0x670>
ffffffffc0200a14:	f80ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200a18:	6c6c                	ld	a1,216(s0)
ffffffffc0200a1a:	00004517          	auipc	a0,0x4
ffffffffc0200a1e:	bee50513          	addi	a0,a0,-1042 # ffffffffc0204608 <etext+0x688>
ffffffffc0200a22:	f72ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200a26:	706c                	ld	a1,224(s0)
ffffffffc0200a28:	00004517          	auipc	a0,0x4
ffffffffc0200a2c:	bf850513          	addi	a0,a0,-1032 # ffffffffc0204620 <etext+0x6a0>
ffffffffc0200a30:	f64ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200a34:	746c                	ld	a1,232(s0)
ffffffffc0200a36:	00004517          	auipc	a0,0x4
ffffffffc0200a3a:	c0250513          	addi	a0,a0,-1022 # ffffffffc0204638 <etext+0x6b8>
ffffffffc0200a3e:	f56ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200a42:	786c                	ld	a1,240(s0)
ffffffffc0200a44:	00004517          	auipc	a0,0x4
ffffffffc0200a48:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0204650 <etext+0x6d0>
ffffffffc0200a4c:	f48ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a50:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a52:	6402                	ld	s0,0(sp)
ffffffffc0200a54:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a56:	00004517          	auipc	a0,0x4
ffffffffc0200a5a:	c1250513          	addi	a0,a0,-1006 # ffffffffc0204668 <etext+0x6e8>
}
ffffffffc0200a5e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a60:	f34ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200a64 <print_trapframe>:
{
ffffffffc0200a64:	1141                	addi	sp,sp,-16
ffffffffc0200a66:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a68:	85aa                	mv	a1,a0
{
ffffffffc0200a6a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a6c:	00004517          	auipc	a0,0x4
ffffffffc0200a70:	c1450513          	addi	a0,a0,-1004 # ffffffffc0204680 <etext+0x700>
{
ffffffffc0200a74:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a76:	f1eff0ef          	jal	ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a7a:	8522                	mv	a0,s0
ffffffffc0200a7c:	e1bff0ef          	jal	ffffffffc0200896 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a80:	10043583          	ld	a1,256(s0)
ffffffffc0200a84:	00004517          	auipc	a0,0x4
ffffffffc0200a88:	c1450513          	addi	a0,a0,-1004 # ffffffffc0204698 <etext+0x718>
ffffffffc0200a8c:	f08ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a90:	10843583          	ld	a1,264(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	c1c50513          	addi	a0,a0,-996 # ffffffffc02046b0 <etext+0x730>
ffffffffc0200a9c:	ef8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200aa0:	11043583          	ld	a1,272(s0)
ffffffffc0200aa4:	00004517          	auipc	a0,0x4
ffffffffc0200aa8:	c2450513          	addi	a0,a0,-988 # ffffffffc02046c8 <etext+0x748>
ffffffffc0200aac:	ee8ff0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ab0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200ab4:	6402                	ld	s0,0(sp)
ffffffffc0200ab6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ab8:	00004517          	auipc	a0,0x4
ffffffffc0200abc:	c2850513          	addi	a0,a0,-984 # ffffffffc02046e0 <etext+0x760>
}
ffffffffc0200ac0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200ac2:	ed2ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ac6 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause)
ffffffffc0200ac6:	11853783          	ld	a5,280(a0)
ffffffffc0200aca:	472d                	li	a4,11
ffffffffc0200acc:	0786                	slli	a5,a5,0x1
ffffffffc0200ace:	8385                	srli	a5,a5,0x1
ffffffffc0200ad0:	0af76a63          	bltu	a4,a5,ffffffffc0200b84 <interrupt_handler+0xbe>
ffffffffc0200ad4:	00005717          	auipc	a4,0x5
ffffffffc0200ad8:	ecc70713          	addi	a4,a4,-308 # ffffffffc02059a0 <commands+0x48>
ffffffffc0200adc:	078a                	slli	a5,a5,0x2
ffffffffc0200ade:	97ba                	add	a5,a5,a4
ffffffffc0200ae0:	439c                	lw	a5,0(a5)
ffffffffc0200ae2:	97ba                	add	a5,a5,a4
ffffffffc0200ae4:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ae6:	00004517          	auipc	a0,0x4
ffffffffc0200aea:	c7250513          	addi	a0,a0,-910 # ffffffffc0204758 <etext+0x7d8>
ffffffffc0200aee:	ea6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	c4650513          	addi	a0,a0,-954 # ffffffffc0204738 <etext+0x7b8>
ffffffffc0200afa:	e9aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200afe:	00004517          	auipc	a0,0x4
ffffffffc0200b02:	bfa50513          	addi	a0,a0,-1030 # ffffffffc02046f8 <etext+0x778>
ffffffffc0200b06:	e8eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200b0a:	00004517          	auipc	a0,0x4
ffffffffc0200b0e:	c0e50513          	addi	a0,a0,-1010 # ffffffffc0204718 <etext+0x798>
ffffffffc0200b12:	e82ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200b16:	1141                	addi	sp,sp,-16
ffffffffc0200b18:	e406                	sd	ra,8(sp)
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);

        /*LAB3 请补充你在lab3中的代码 */ 
        clock_set_next_event();
ffffffffc0200b1a:	983ff0ef          	jal	ffffffffc020049c <clock_set_next_event>
        ticks++;
ffffffffc0200b1e:	0000d797          	auipc	a5,0xd
ffffffffc0200b22:	95a78793          	addi	a5,a5,-1702 # ffffffffc020d478 <ticks>
ffffffffc0200b26:	6394                	ld	a3,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200b28:	28f5c737          	lui	a4,0x28f5c
ffffffffc0200b2c:	28f70713          	addi	a4,a4,655 # 28f5c28f <kern_entry-0xffffffff972a3d71>
        ticks++;
ffffffffc0200b30:	0685                	addi	a3,a3,1
ffffffffc0200b32:	e394                	sd	a3,0(a5)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200b34:	6390                	ld	a2,0(a5)
ffffffffc0200b36:	5c28f6b7          	lui	a3,0x5c28f
ffffffffc0200b3a:	1702                	slli	a4,a4,0x20
ffffffffc0200b3c:	5c368693          	addi	a3,a3,1475 # 5c28f5c3 <kern_entry-0xffffffff63f70a3d>
ffffffffc0200b40:	00265793          	srli	a5,a2,0x2
ffffffffc0200b44:	9736                	add	a4,a4,a3
ffffffffc0200b46:	02e7b7b3          	mulhu	a5,a5,a4
ffffffffc0200b4a:	06400593          	li	a1,100
ffffffffc0200b4e:	8389                	srli	a5,a5,0x2
ffffffffc0200b50:	02b787b3          	mul	a5,a5,a1
ffffffffc0200b54:	02f60963          	beq	a2,a5,ffffffffc0200b86 <interrupt_handler+0xc0>
                print_ticks();
                num++;
            }
        if (num == 10) {
ffffffffc0200b58:	0000d797          	auipc	a5,0xd
ffffffffc0200b5c:	9387a783          	lw	a5,-1736(a5) # ffffffffc020d490 <num>
ffffffffc0200b60:	4729                	li	a4,10
ffffffffc0200b62:	00e79863          	bne	a5,a4,ffffffffc0200b72 <interrupt_handler+0xac>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200b66:	4501                	li	a0,0
ffffffffc0200b68:	4581                	li	a1,0
ffffffffc0200b6a:	4601                	li	a2,0
ffffffffc0200b6c:	48a1                	li	a7,8
ffffffffc0200b6e:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
ffffffffc0200b74:	0141                	addi	sp,sp,16
ffffffffc0200b76:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200b78:	00004517          	auipc	a0,0x4
ffffffffc0200b7c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0204788 <etext+0x808>
ffffffffc0200b80:	e14ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200b84:	b5c5                	j	ffffffffc0200a64 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b86:	00004517          	auipc	a0,0x4
ffffffffc0200b8a:	bf250513          	addi	a0,a0,-1038 # ffffffffc0204778 <etext+0x7f8>
ffffffffc0200b8e:	e06ff0ef          	jal	ffffffffc0200194 <cprintf>
                num++;
ffffffffc0200b92:	0000d797          	auipc	a5,0xd
ffffffffc0200b96:	8fe7a783          	lw	a5,-1794(a5) # ffffffffc020d490 <num>
ffffffffc0200b9a:	2785                	addiw	a5,a5,1
ffffffffc0200b9c:	0000d717          	auipc	a4,0xd
ffffffffc0200ba0:	8ef72a23          	sw	a5,-1804(a4) # ffffffffc020d490 <num>
ffffffffc0200ba4:	bf75                	j	ffffffffc0200b60 <interrupt_handler+0x9a>

ffffffffc0200ba6 <exception_handler>:

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200ba6:	11853783          	ld	a5,280(a0)
ffffffffc0200baa:	473d                	li	a4,15
ffffffffc0200bac:	1cf76c63          	bltu	a4,a5,ffffffffc0200d84 <exception_handler+0x1de>
ffffffffc0200bb0:	00005717          	auipc	a4,0x5
ffffffffc0200bb4:	e2070713          	addi	a4,a4,-480 # ffffffffc02059d0 <commands+0x78>
ffffffffc0200bb8:	078a                	slli	a5,a5,0x2
ffffffffc0200bba:	97ba                	add	a5,a5,a4
ffffffffc0200bbc:	439c                	lw	a5,0(a5)
{
ffffffffc0200bbe:	1101                	addi	sp,sp,-32
ffffffffc0200bc0:	ec06                	sd	ra,24(sp)
    switch (tf->cause)
ffffffffc0200bc2:	97ba                	add	a5,a5,a4
ffffffffc0200bc4:	8782                	jr	a5
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bc6:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO page fault\n");
ffffffffc0200bc8:	00004517          	auipc	a0,0x4
ffffffffc0200bcc:	e6850513          	addi	a0,a0,-408 # ffffffffc0204a30 <etext+0xab0>
}
ffffffffc0200bd0:	6105                	addi	sp,sp,32
        cprintf("Store/AMO page fault\n");
ffffffffc0200bd2:	dc2ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200bd6:	60e2                	ld	ra,24(sp)
        cprintf("Instruction address misaligned\n");
ffffffffc0200bd8:	00004517          	auipc	a0,0x4
ffffffffc0200bdc:	bd050513          	addi	a0,a0,-1072 # ffffffffc02047a8 <etext+0x828>
}
ffffffffc0200be0:	6105                	addi	sp,sp,32
        cprintf("Instruction address misaligned\n");
ffffffffc0200be2:	db2ff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200be6:	60e2                	ld	ra,24(sp)
        cprintf("Instruction access fault\n");
ffffffffc0200be8:	00004517          	auipc	a0,0x4
ffffffffc0200bec:	be050513          	addi	a0,a0,-1056 # ffffffffc02047c8 <etext+0x848>
}
ffffffffc0200bf0:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200bf2:	da2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Illegal instruction\n");
ffffffffc0200bf6:	e42a                	sd	a0,8(sp)
ffffffffc0200bf8:	00004517          	auipc	a0,0x4
ffffffffc0200bfc:	c2850513          	addi	a0,a0,-984 # ffffffffc0204820 <etext+0x8a0>
ffffffffc0200c00:	d94ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200c04:	66a2                	ld	a3,8(sp)
ffffffffc0200c06:	00004517          	auipc	a0,0x4
ffffffffc0200c0a:	be250513          	addi	a0,a0,-1054 # ffffffffc02047e8 <etext+0x868>
ffffffffc0200c0e:	1086b583          	ld	a1,264(a3)
ffffffffc0200c12:	d82ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Exception type: Illegal instruction\n");
ffffffffc0200c16:	00004517          	auipc	a0,0x4
ffffffffc0200c1a:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0204810 <etext+0x890>
ffffffffc0200c1e:	d76ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Before update: epc = 0x%08x\n", tf->epc);
ffffffffc0200c22:	66a2                	ld	a3,8(sp)
ffffffffc0200c24:	00004517          	auipc	a0,0x4
ffffffffc0200c28:	c1450513          	addi	a0,a0,-1004 # ffffffffc0204838 <etext+0x8b8>
ffffffffc0200c2c:	1086b583          	ld	a1,264(a3)
ffffffffc0200c30:	d64ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200c34:	66a2                	ld	a3,8(sp)
}
ffffffffc0200c36:	60e2                	ld	ra,24(sp)
        cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200c38:	00004517          	auipc	a0,0x4
ffffffffc0200c3c:	c2050513          	addi	a0,a0,-992 # ffffffffc0204858 <etext+0x8d8>
        tf->epc += 4;
ffffffffc0200c40:	1086b583          	ld	a1,264(a3)
ffffffffc0200c44:	0591                	addi	a1,a1,4
ffffffffc0200c46:	10b6b423          	sd	a1,264(a3)
}
ffffffffc0200c4a:	6105                	addi	sp,sp,32
        cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200c4c:	d48ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Breakpoint\n");
ffffffffc0200c50:	e42a                	sd	a0,8(sp)
ffffffffc0200c52:	00004517          	auipc	a0,0x4
ffffffffc0200c56:	c2650513          	addi	a0,a0,-986 # ffffffffc0204878 <etext+0x8f8>
ffffffffc0200c5a:	d3aff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200c5e:	66a2                	ld	a3,8(sp)
ffffffffc0200c60:	00004517          	auipc	a0,0x4
ffffffffc0200c64:	c2850513          	addi	a0,a0,-984 # ffffffffc0204888 <etext+0x908>
ffffffffc0200c68:	1086b583          	ld	a1,264(a3)
ffffffffc0200c6c:	d28ff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Exception type: breakpoint\n");
ffffffffc0200c70:	00004517          	auipc	a0,0x4
ffffffffc0200c74:	c3850513          	addi	a0,a0,-968 # ffffffffc02048a8 <etext+0x928>
ffffffffc0200c78:	d1cff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Before update: epc = 0x%08x\n", tf->epc);
ffffffffc0200c7c:	66a2                	ld	a3,8(sp)
ffffffffc0200c7e:	00004517          	auipc	a0,0x4
ffffffffc0200c82:	bba50513          	addi	a0,a0,-1094 # ffffffffc0204838 <etext+0x8b8>
ffffffffc0200c86:	1086b583          	ld	a1,264(a3)
ffffffffc0200c8a:	d0aff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Instruction at epc: 0x%08x\n", *instr_ptr);
ffffffffc0200c8e:	66a2                	ld	a3,8(sp)
ffffffffc0200c90:	00004517          	auipc	a0,0x4
ffffffffc0200c94:	c3850513          	addi	a0,a0,-968 # ffffffffc02048c8 <etext+0x948>
ffffffffc0200c98:	1086b783          	ld	a5,264(a3)
ffffffffc0200c9c:	438c                	lw	a1,0(a5)
ffffffffc0200c9e:	cf6ff0ef          	jal	ffffffffc0200194 <cprintf>
        tf->epc += 2;
ffffffffc0200ca2:	66a2                	ld	a3,8(sp)
        cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200ca4:	00004517          	auipc	a0,0x4
ffffffffc0200ca8:	bb450513          	addi	a0,a0,-1100 # ffffffffc0204858 <etext+0x8d8>
        tf->epc += 2;
ffffffffc0200cac:	1086b583          	ld	a1,264(a3)
ffffffffc0200cb0:	0589                	addi	a1,a1,2
ffffffffc0200cb2:	10b6b423          	sd	a1,264(a3)
        cprintf("After update: epc = 0x%08x\n", tf->epc);
ffffffffc0200cb6:	cdeff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Stack pointer: 0x%08x\n", tf->gpr.sp);
ffffffffc0200cba:	66a2                	ld	a3,8(sp)
ffffffffc0200cbc:	00004517          	auipc	a0,0x4
ffffffffc0200cc0:	c2c50513          	addi	a0,a0,-980 # ffffffffc02048e8 <etext+0x968>
ffffffffc0200cc4:	6a8c                	ld	a1,16(a3)
ffffffffc0200cc6:	cceff0ef          	jal	ffffffffc0200194 <cprintf>
        cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200cca:	66a2                	ld	a3,8(sp)
}
ffffffffc0200ccc:	60e2                	ld	ra,24(sp)
        cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200cce:	00004517          	auipc	a0,0x4
ffffffffc0200cd2:	c3250513          	addi	a0,a0,-974 # ffffffffc0204900 <etext+0x980>
ffffffffc0200cd6:	668c                	ld	a1,8(a3)
}
ffffffffc0200cd8:	6105                	addi	sp,sp,32
        cprintf("Return address: 0x%08x\n", tf->gpr.ra);
ffffffffc0200cda:	cbaff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cde:	60e2                	ld	ra,24(sp)
        cprintf("Load address misaligned\n");
ffffffffc0200ce0:	00004517          	auipc	a0,0x4
ffffffffc0200ce4:	c3850513          	addi	a0,a0,-968 # ffffffffc0204918 <etext+0x998>
}
ffffffffc0200ce8:	6105                	addi	sp,sp,32
        cprintf("Load address misaligned\n");
ffffffffc0200cea:	caaff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cee:	60e2                	ld	ra,24(sp)
        cprintf("Load access fault\n");
ffffffffc0200cf0:	00004517          	auipc	a0,0x4
ffffffffc0200cf4:	c4850513          	addi	a0,a0,-952 # ffffffffc0204938 <etext+0x9b8>
}
ffffffffc0200cf8:	6105                	addi	sp,sp,32
        cprintf("Load access fault\n");
ffffffffc0200cfa:	c9aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200cfe:	60e2                	ld	ra,24(sp)
        cprintf("AMO address misaligned\n");
ffffffffc0200d00:	00004517          	auipc	a0,0x4
ffffffffc0200d04:	c5050513          	addi	a0,a0,-944 # ffffffffc0204950 <etext+0x9d0>
}
ffffffffc0200d08:	6105                	addi	sp,sp,32
        cprintf("AMO address misaligned\n");
ffffffffc0200d0a:	c8aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d0e:	60e2                	ld	ra,24(sp)
        cprintf("Store/AMO access fault\n");
ffffffffc0200d10:	00004517          	auipc	a0,0x4
ffffffffc0200d14:	c5850513          	addi	a0,a0,-936 # ffffffffc0204968 <etext+0x9e8>
}
ffffffffc0200d18:	6105                	addi	sp,sp,32
        cprintf("Store/AMO access fault\n");
ffffffffc0200d1a:	c7aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d1e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from U-mode\n");
ffffffffc0200d20:	00004517          	auipc	a0,0x4
ffffffffc0200d24:	c6050513          	addi	a0,a0,-928 # ffffffffc0204980 <etext+0xa00>
}
ffffffffc0200d28:	6105                	addi	sp,sp,32
        cprintf("Environment call from U-mode\n");
ffffffffc0200d2a:	c6aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d2e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from S-mode\n");
ffffffffc0200d30:	00004517          	auipc	a0,0x4
ffffffffc0200d34:	c7050513          	addi	a0,a0,-912 # ffffffffc02049a0 <etext+0xa20>
}
ffffffffc0200d38:	6105                	addi	sp,sp,32
        cprintf("Environment call from S-mode\n");
ffffffffc0200d3a:	c5aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d3e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from H-mode\n");
ffffffffc0200d40:	00004517          	auipc	a0,0x4
ffffffffc0200d44:	c8050513          	addi	a0,a0,-896 # ffffffffc02049c0 <etext+0xa40>
}
ffffffffc0200d48:	6105                	addi	sp,sp,32
        cprintf("Environment call from H-mode\n");
ffffffffc0200d4a:	c4aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d4e:	60e2                	ld	ra,24(sp)
        cprintf("Environment call from M-mode\n");
ffffffffc0200d50:	00004517          	auipc	a0,0x4
ffffffffc0200d54:	c9050513          	addi	a0,a0,-880 # ffffffffc02049e0 <etext+0xa60>
}
ffffffffc0200d58:	6105                	addi	sp,sp,32
        cprintf("Environment call from M-mode\n");
ffffffffc0200d5a:	c3aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d5e:	60e2                	ld	ra,24(sp)
        cprintf("Instruction page fault\n");
ffffffffc0200d60:	00004517          	auipc	a0,0x4
ffffffffc0200d64:	ca050513          	addi	a0,a0,-864 # ffffffffc0204a00 <etext+0xa80>
}
ffffffffc0200d68:	6105                	addi	sp,sp,32
        cprintf("Instruction page fault\n");
ffffffffc0200d6a:	c2aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d6e:	60e2                	ld	ra,24(sp)
        cprintf("Load page fault\n");
ffffffffc0200d70:	00004517          	auipc	a0,0x4
ffffffffc0200d74:	ca850513          	addi	a0,a0,-856 # ffffffffc0204a18 <etext+0xa98>
}
ffffffffc0200d78:	6105                	addi	sp,sp,32
        cprintf("Load page fault\n");
ffffffffc0200d7a:	c1aff06f          	j	ffffffffc0200194 <cprintf>
}
ffffffffc0200d7e:	60e2                	ld	ra,24(sp)
ffffffffc0200d80:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200d82:	b1cd                	j	ffffffffc0200a64 <print_trapframe>
ffffffffc0200d84:	b1c5                	j	ffffffffc0200a64 <print_trapframe>

ffffffffc0200d86 <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d86:	11853783          	ld	a5,280(a0)
ffffffffc0200d8a:	0007c363          	bltz	a5,ffffffffc0200d90 <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d8e:	bd21                	j	ffffffffc0200ba6 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d90:	bb1d                	j	ffffffffc0200ac6 <interrupt_handler>
	...

ffffffffc0200d94 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d94:	14011073          	csrw	sscratch,sp
ffffffffc0200d98:	712d                	addi	sp,sp,-288
ffffffffc0200d9a:	e406                	sd	ra,8(sp)
ffffffffc0200d9c:	ec0e                	sd	gp,24(sp)
ffffffffc0200d9e:	f012                	sd	tp,32(sp)
ffffffffc0200da0:	f416                	sd	t0,40(sp)
ffffffffc0200da2:	f81a                	sd	t1,48(sp)
ffffffffc0200da4:	fc1e                	sd	t2,56(sp)
ffffffffc0200da6:	e0a2                	sd	s0,64(sp)
ffffffffc0200da8:	e4a6                	sd	s1,72(sp)
ffffffffc0200daa:	e8aa                	sd	a0,80(sp)
ffffffffc0200dac:	ecae                	sd	a1,88(sp)
ffffffffc0200dae:	f0b2                	sd	a2,96(sp)
ffffffffc0200db0:	f4b6                	sd	a3,104(sp)
ffffffffc0200db2:	f8ba                	sd	a4,112(sp)
ffffffffc0200db4:	fcbe                	sd	a5,120(sp)
ffffffffc0200db6:	e142                	sd	a6,128(sp)
ffffffffc0200db8:	e546                	sd	a7,136(sp)
ffffffffc0200dba:	e94a                	sd	s2,144(sp)
ffffffffc0200dbc:	ed4e                	sd	s3,152(sp)
ffffffffc0200dbe:	f152                	sd	s4,160(sp)
ffffffffc0200dc0:	f556                	sd	s5,168(sp)
ffffffffc0200dc2:	f95a                	sd	s6,176(sp)
ffffffffc0200dc4:	fd5e                	sd	s7,184(sp)
ffffffffc0200dc6:	e1e2                	sd	s8,192(sp)
ffffffffc0200dc8:	e5e6                	sd	s9,200(sp)
ffffffffc0200dca:	e9ea                	sd	s10,208(sp)
ffffffffc0200dcc:	edee                	sd	s11,216(sp)
ffffffffc0200dce:	f1f2                	sd	t3,224(sp)
ffffffffc0200dd0:	f5f6                	sd	t4,232(sp)
ffffffffc0200dd2:	f9fa                	sd	t5,240(sp)
ffffffffc0200dd4:	fdfe                	sd	t6,248(sp)
ffffffffc0200dd6:	14002473          	csrr	s0,sscratch
ffffffffc0200dda:	100024f3          	csrr	s1,sstatus
ffffffffc0200dde:	14102973          	csrr	s2,sepc
ffffffffc0200de2:	143029f3          	csrr	s3,stval
ffffffffc0200de6:	14202a73          	csrr	s4,scause
ffffffffc0200dea:	e822                	sd	s0,16(sp)
ffffffffc0200dec:	e226                	sd	s1,256(sp)
ffffffffc0200dee:	e64a                	sd	s2,264(sp)
ffffffffc0200df0:	ea4e                	sd	s3,272(sp)
ffffffffc0200df2:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200df4:	850a                	mv	a0,sp
    jal trap
ffffffffc0200df6:	f91ff0ef          	jal	ffffffffc0200d86 <trap>

ffffffffc0200dfa <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200dfa:	6492                	ld	s1,256(sp)
ffffffffc0200dfc:	6932                	ld	s2,264(sp)
ffffffffc0200dfe:	10049073          	csrw	sstatus,s1
ffffffffc0200e02:	14191073          	csrw	sepc,s2
ffffffffc0200e06:	60a2                	ld	ra,8(sp)
ffffffffc0200e08:	61e2                	ld	gp,24(sp)
ffffffffc0200e0a:	7202                	ld	tp,32(sp)
ffffffffc0200e0c:	72a2                	ld	t0,40(sp)
ffffffffc0200e0e:	7342                	ld	t1,48(sp)
ffffffffc0200e10:	73e2                	ld	t2,56(sp)
ffffffffc0200e12:	6406                	ld	s0,64(sp)
ffffffffc0200e14:	64a6                	ld	s1,72(sp)
ffffffffc0200e16:	6546                	ld	a0,80(sp)
ffffffffc0200e18:	65e6                	ld	a1,88(sp)
ffffffffc0200e1a:	7606                	ld	a2,96(sp)
ffffffffc0200e1c:	76a6                	ld	a3,104(sp)
ffffffffc0200e1e:	7746                	ld	a4,112(sp)
ffffffffc0200e20:	77e6                	ld	a5,120(sp)
ffffffffc0200e22:	680a                	ld	a6,128(sp)
ffffffffc0200e24:	68aa                	ld	a7,136(sp)
ffffffffc0200e26:	694a                	ld	s2,144(sp)
ffffffffc0200e28:	69ea                	ld	s3,152(sp)
ffffffffc0200e2a:	7a0a                	ld	s4,160(sp)
ffffffffc0200e2c:	7aaa                	ld	s5,168(sp)
ffffffffc0200e2e:	7b4a                	ld	s6,176(sp)
ffffffffc0200e30:	7bea                	ld	s7,184(sp)
ffffffffc0200e32:	6c0e                	ld	s8,192(sp)
ffffffffc0200e34:	6cae                	ld	s9,200(sp)
ffffffffc0200e36:	6d4e                	ld	s10,208(sp)
ffffffffc0200e38:	6dee                	ld	s11,216(sp)
ffffffffc0200e3a:	7e0e                	ld	t3,224(sp)
ffffffffc0200e3c:	7eae                	ld	t4,232(sp)
ffffffffc0200e3e:	7f4e                	ld	t5,240(sp)
ffffffffc0200e40:	7fee                	ld	t6,248(sp)
ffffffffc0200e42:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200e44:	10200073          	sret

ffffffffc0200e48 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200e48:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200e4a:	bf45                	j	ffffffffc0200dfa <__trapret>
ffffffffc0200e4c:	0001                	nop

ffffffffc0200e4e <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200e4e:	00008797          	auipc	a5,0x8
ffffffffc0200e52:	5e278793          	addi	a5,a5,1506 # ffffffffc0209430 <free_area>
ffffffffc0200e56:	e79c                	sd	a5,8(a5)
ffffffffc0200e58:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200e5a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200e5e:	8082                	ret

ffffffffc0200e60 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200e60:	00008517          	auipc	a0,0x8
ffffffffc0200e64:	5e056503          	lwu	a0,1504(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200e68:	8082                	ret

ffffffffc0200e6a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200e6a:	711d                	addi	sp,sp,-96
ffffffffc0200e6c:	e0ca                	sd	s2,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200e6e:	00008917          	auipc	s2,0x8
ffffffffc0200e72:	5c290913          	addi	s2,s2,1474 # ffffffffc0209430 <free_area>
ffffffffc0200e76:	00893783          	ld	a5,8(s2)
ffffffffc0200e7a:	ec86                	sd	ra,88(sp)
ffffffffc0200e7c:	e8a2                	sd	s0,80(sp)
ffffffffc0200e7e:	e4a6                	sd	s1,72(sp)
ffffffffc0200e80:	fc4e                	sd	s3,56(sp)
ffffffffc0200e82:	f852                	sd	s4,48(sp)
ffffffffc0200e84:	f456                	sd	s5,40(sp)
ffffffffc0200e86:	f05a                	sd	s6,32(sp)
ffffffffc0200e88:	ec5e                	sd	s7,24(sp)
ffffffffc0200e8a:	e862                	sd	s8,16(sp)
ffffffffc0200e8c:	e466                	sd	s9,8(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e8e:	2f278763          	beq	a5,s2,ffffffffc020117c <default_check+0x312>
    int count = 0, total = 0;
ffffffffc0200e92:	4401                	li	s0,0
ffffffffc0200e94:	4481                	li	s1,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e96:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e9a:	8b09                	andi	a4,a4,2
ffffffffc0200e9c:	2e070463          	beqz	a4,ffffffffc0201184 <default_check+0x31a>
        count ++, total += p->property;
ffffffffc0200ea0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ea4:	679c                	ld	a5,8(a5)
ffffffffc0200ea6:	2485                	addiw	s1,s1,1
ffffffffc0200ea8:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200eaa:	ff2796e3          	bne	a5,s2,ffffffffc0200e96 <default_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200eae:	89a2                	mv	s3,s0
ffffffffc0200eb0:	745000ef          	jal	ffffffffc0201df4 <nr_free_pages>
ffffffffc0200eb4:	73351863          	bne	a0,s3,ffffffffc02015e4 <default_check+0x77a>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200eb8:	4505                	li	a0,1
ffffffffc0200eba:	6c9000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200ebe:	8a2a                	mv	s4,a0
ffffffffc0200ec0:	46050263          	beqz	a0,ffffffffc0201324 <default_check+0x4ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ec4:	4505                	li	a0,1
ffffffffc0200ec6:	6bd000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200eca:	89aa                	mv	s3,a0
ffffffffc0200ecc:	72050c63          	beqz	a0,ffffffffc0201604 <default_check+0x79a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200ed0:	4505                	li	a0,1
ffffffffc0200ed2:	6b1000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200ed6:	8aaa                	mv	s5,a0
ffffffffc0200ed8:	4c050663          	beqz	a0,ffffffffc02013a4 <default_check+0x53a>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200edc:	40aa07b3          	sub	a5,s4,a0
ffffffffc0200ee0:	40a98733          	sub	a4,s3,a0
ffffffffc0200ee4:	0017b793          	seqz	a5,a5
ffffffffc0200ee8:	00173713          	seqz	a4,a4
ffffffffc0200eec:	8fd9                	or	a5,a5,a4
ffffffffc0200eee:	30079b63          	bnez	a5,ffffffffc0201204 <default_check+0x39a>
ffffffffc0200ef2:	313a0963          	beq	s4,s3,ffffffffc0201204 <default_check+0x39a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200ef6:	000a2783          	lw	a5,0(s4)
ffffffffc0200efa:	2a079563          	bnez	a5,ffffffffc02011a4 <default_check+0x33a>
ffffffffc0200efe:	0009a783          	lw	a5,0(s3)
ffffffffc0200f02:	2a079163          	bnez	a5,ffffffffc02011a4 <default_check+0x33a>
ffffffffc0200f06:	411c                	lw	a5,0(a0)
ffffffffc0200f08:	28079e63          	bnez	a5,ffffffffc02011a4 <default_check+0x33a>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200f0c:	0000c797          	auipc	a5,0xc
ffffffffc0200f10:	5bc7b783          	ld	a5,1468(a5) # ffffffffc020d4c8 <pages>
ffffffffc0200f14:	00005617          	auipc	a2,0x5
ffffffffc0200f18:	cc463603          	ld	a2,-828(a2) # ffffffffc0205bd8 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200f1c:	0000c697          	auipc	a3,0xc
ffffffffc0200f20:	5a46b683          	ld	a3,1444(a3) # ffffffffc020d4c0 <npage>
ffffffffc0200f24:	40fa0733          	sub	a4,s4,a5
ffffffffc0200f28:	8719                	srai	a4,a4,0x6
ffffffffc0200f2a:	9732                	add	a4,a4,a2
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f2c:	0732                	slli	a4,a4,0xc
ffffffffc0200f2e:	06b2                	slli	a3,a3,0xc
ffffffffc0200f30:	2ad77a63          	bgeu	a4,a3,ffffffffc02011e4 <default_check+0x37a>
    return page - pages + nbase;
ffffffffc0200f34:	40f98733          	sub	a4,s3,a5
ffffffffc0200f38:	8719                	srai	a4,a4,0x6
ffffffffc0200f3a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f3c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200f3e:	4ed77363          	bgeu	a4,a3,ffffffffc0201424 <default_check+0x5ba>
    return page - pages + nbase;
ffffffffc0200f42:	40f507b3          	sub	a5,a0,a5
ffffffffc0200f46:	8799                	srai	a5,a5,0x6
ffffffffc0200f48:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f4a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f4c:	32d7fc63          	bgeu	a5,a3,ffffffffc0201284 <default_check+0x41a>
    assert(alloc_page() == NULL);
ffffffffc0200f50:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f52:	00093c03          	ld	s8,0(s2)
ffffffffc0200f56:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200f5a:	00008b17          	auipc	s6,0x8
ffffffffc0200f5e:	4e6b2b03          	lw	s6,1254(s6) # ffffffffc0209440 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc0200f62:	01293023          	sd	s2,0(s2)
ffffffffc0200f66:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200f6a:	00008797          	auipc	a5,0x8
ffffffffc0200f6e:	4c07ab23          	sw	zero,1238(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200f72:	611000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200f76:	2e051763          	bnez	a0,ffffffffc0201264 <default_check+0x3fa>
    free_page(p0);
ffffffffc0200f7a:	8552                	mv	a0,s4
ffffffffc0200f7c:	4585                	li	a1,1
ffffffffc0200f7e:	63f000ef          	jal	ffffffffc0201dbc <free_pages>
    free_page(p1);
ffffffffc0200f82:	854e                	mv	a0,s3
ffffffffc0200f84:	4585                	li	a1,1
ffffffffc0200f86:	637000ef          	jal	ffffffffc0201dbc <free_pages>
    free_page(p2);
ffffffffc0200f8a:	8556                	mv	a0,s5
ffffffffc0200f8c:	4585                	li	a1,1
ffffffffc0200f8e:	62f000ef          	jal	ffffffffc0201dbc <free_pages>
    assert(nr_free == 3);
ffffffffc0200f92:	00008717          	auipc	a4,0x8
ffffffffc0200f96:	4ae72703          	lw	a4,1198(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200f9a:	478d                	li	a5,3
ffffffffc0200f9c:	2af71463          	bne	a4,a5,ffffffffc0201244 <default_check+0x3da>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200fa0:	4505                	li	a0,1
ffffffffc0200fa2:	5e1000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200fa6:	89aa                	mv	s3,a0
ffffffffc0200fa8:	26050e63          	beqz	a0,ffffffffc0201224 <default_check+0x3ba>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200fac:	4505                	li	a0,1
ffffffffc0200fae:	5d5000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200fb2:	8aaa                	mv	s5,a0
ffffffffc0200fb4:	3c050863          	beqz	a0,ffffffffc0201384 <default_check+0x51a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200fb8:	4505                	li	a0,1
ffffffffc0200fba:	5c9000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200fbe:	8a2a                	mv	s4,a0
ffffffffc0200fc0:	3a050263          	beqz	a0,ffffffffc0201364 <default_check+0x4fa>
    assert(alloc_page() == NULL);
ffffffffc0200fc4:	4505                	li	a0,1
ffffffffc0200fc6:	5bd000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200fca:	36051d63          	bnez	a0,ffffffffc0201344 <default_check+0x4da>
    free_page(p0);
ffffffffc0200fce:	4585                	li	a1,1
ffffffffc0200fd0:	854e                	mv	a0,s3
ffffffffc0200fd2:	5eb000ef          	jal	ffffffffc0201dbc <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200fd6:	00893783          	ld	a5,8(s2)
ffffffffc0200fda:	1f278563          	beq	a5,s2,ffffffffc02011c4 <default_check+0x35a>
    assert((p = alloc_page()) == p0);
ffffffffc0200fde:	4505                	li	a0,1
ffffffffc0200fe0:	5a3000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200fe4:	8caa                	mv	s9,a0
ffffffffc0200fe6:	30a99f63          	bne	s3,a0,ffffffffc0201304 <default_check+0x49a>
    assert(alloc_page() == NULL);
ffffffffc0200fea:	4505                	li	a0,1
ffffffffc0200fec:	597000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0200ff0:	2e051a63          	bnez	a0,ffffffffc02012e4 <default_check+0x47a>
    assert(nr_free == 0);
ffffffffc0200ff4:	00008797          	auipc	a5,0x8
ffffffffc0200ff8:	44c7a783          	lw	a5,1100(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200ffc:	2c079463          	bnez	a5,ffffffffc02012c4 <default_check+0x45a>
    free_page(p);
ffffffffc0201000:	8566                	mv	a0,s9
ffffffffc0201002:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201004:	01893023          	sd	s8,0(s2)
ffffffffc0201008:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc020100c:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc0201010:	5ad000ef          	jal	ffffffffc0201dbc <free_pages>
    free_page(p1);
ffffffffc0201014:	8556                	mv	a0,s5
ffffffffc0201016:	4585                	li	a1,1
ffffffffc0201018:	5a5000ef          	jal	ffffffffc0201dbc <free_pages>
    free_page(p2);
ffffffffc020101c:	8552                	mv	a0,s4
ffffffffc020101e:	4585                	li	a1,1
ffffffffc0201020:	59d000ef          	jal	ffffffffc0201dbc <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201024:	4515                	li	a0,5
ffffffffc0201026:	55d000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc020102a:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020102c:	26050c63          	beqz	a0,ffffffffc02012a4 <default_check+0x43a>
ffffffffc0201030:	651c                	ld	a5,8(a0)
ffffffffc0201032:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0201034:	8b85                	andi	a5,a5,1
ffffffffc0201036:	54079763          	bnez	a5,ffffffffc0201584 <default_check+0x71a>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020103a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020103c:	00093b83          	ld	s7,0(s2)
ffffffffc0201040:	00893b03          	ld	s6,8(s2)
ffffffffc0201044:	01293023          	sd	s2,0(s2)
ffffffffc0201048:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc020104c:	537000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0201050:	50051a63          	bnez	a0,ffffffffc0201564 <default_check+0x6fa>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201054:	08098a13          	addi	s4,s3,128
ffffffffc0201058:	8552                	mv	a0,s4
ffffffffc020105a:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020105c:	00008c17          	auipc	s8,0x8
ffffffffc0201060:	3e4c2c03          	lw	s8,996(s8) # ffffffffc0209440 <free_area+0x10>
    nr_free = 0;
ffffffffc0201064:	00008797          	auipc	a5,0x8
ffffffffc0201068:	3c07ae23          	sw	zero,988(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020106c:	551000ef          	jal	ffffffffc0201dbc <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201070:	4511                	li	a0,4
ffffffffc0201072:	511000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0201076:	4c051763          	bnez	a0,ffffffffc0201544 <default_check+0x6da>
ffffffffc020107a:	0889b783          	ld	a5,136(s3)
ffffffffc020107e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201080:	8b85                	andi	a5,a5,1
ffffffffc0201082:	4a078163          	beqz	a5,ffffffffc0201524 <default_check+0x6ba>
ffffffffc0201086:	0909a503          	lw	a0,144(s3)
ffffffffc020108a:	478d                	li	a5,3
ffffffffc020108c:	48f51c63          	bne	a0,a5,ffffffffc0201524 <default_check+0x6ba>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201090:	4f3000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0201094:	8aaa                	mv	s5,a0
ffffffffc0201096:	46050763          	beqz	a0,ffffffffc0201504 <default_check+0x69a>
    assert(alloc_page() == NULL);
ffffffffc020109a:	4505                	li	a0,1
ffffffffc020109c:	4e7000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc02010a0:	44051263          	bnez	a0,ffffffffc02014e4 <default_check+0x67a>
    assert(p0 + 2 == p1);
ffffffffc02010a4:	435a1063          	bne	s4,s5,ffffffffc02014c4 <default_check+0x65a>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02010a8:	4585                	li	a1,1
ffffffffc02010aa:	854e                	mv	a0,s3
ffffffffc02010ac:	511000ef          	jal	ffffffffc0201dbc <free_pages>
    free_pages(p1, 3);
ffffffffc02010b0:	8552                	mv	a0,s4
ffffffffc02010b2:	458d                	li	a1,3
ffffffffc02010b4:	509000ef          	jal	ffffffffc0201dbc <free_pages>
ffffffffc02010b8:	0089b783          	ld	a5,8(s3)
ffffffffc02010bc:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02010be:	8b85                	andi	a5,a5,1
ffffffffc02010c0:	3e078263          	beqz	a5,ffffffffc02014a4 <default_check+0x63a>
ffffffffc02010c4:	0109aa83          	lw	s5,16(s3)
ffffffffc02010c8:	4785                	li	a5,1
ffffffffc02010ca:	3cfa9d63          	bne	s5,a5,ffffffffc02014a4 <default_check+0x63a>
ffffffffc02010ce:	008a3783          	ld	a5,8(s4)
ffffffffc02010d2:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02010d4:	8b85                	andi	a5,a5,1
ffffffffc02010d6:	3a078763          	beqz	a5,ffffffffc0201484 <default_check+0x61a>
ffffffffc02010da:	010a2703          	lw	a4,16(s4)
ffffffffc02010de:	478d                	li	a5,3
ffffffffc02010e0:	3af71263          	bne	a4,a5,ffffffffc0201484 <default_check+0x61a>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02010e4:	8556                	mv	a0,s5
ffffffffc02010e6:	49d000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc02010ea:	36a99d63          	bne	s3,a0,ffffffffc0201464 <default_check+0x5fa>
    free_page(p0);
ffffffffc02010ee:	85d6                	mv	a1,s5
ffffffffc02010f0:	4cd000ef          	jal	ffffffffc0201dbc <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02010f4:	4509                	li	a0,2
ffffffffc02010f6:	48d000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc02010fa:	34aa1563          	bne	s4,a0,ffffffffc0201444 <default_check+0x5da>

    free_pages(p0, 2);
ffffffffc02010fe:	4589                	li	a1,2
ffffffffc0201100:	4bd000ef          	jal	ffffffffc0201dbc <free_pages>
    free_page(p2);
ffffffffc0201104:	04098513          	addi	a0,s3,64
ffffffffc0201108:	85d6                	mv	a1,s5
ffffffffc020110a:	4b3000ef          	jal	ffffffffc0201dbc <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020110e:	4515                	li	a0,5
ffffffffc0201110:	473000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0201114:	89aa                	mv	s3,a0
ffffffffc0201116:	48050763          	beqz	a0,ffffffffc02015a4 <default_check+0x73a>
    assert(alloc_page() == NULL);
ffffffffc020111a:	8556                	mv	a0,s5
ffffffffc020111c:	467000ef          	jal	ffffffffc0201d82 <alloc_pages>
ffffffffc0201120:	2e051263          	bnez	a0,ffffffffc0201404 <default_check+0x59a>

    assert(nr_free == 0);
ffffffffc0201124:	00008797          	auipc	a5,0x8
ffffffffc0201128:	31c7a783          	lw	a5,796(a5) # ffffffffc0209440 <free_area+0x10>
ffffffffc020112c:	2a079c63          	bnez	a5,ffffffffc02013e4 <default_check+0x57a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201130:	854e                	mv	a0,s3
ffffffffc0201132:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc0201134:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc0201138:	01793023          	sd	s7,0(s2)
ffffffffc020113c:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc0201140:	47d000ef          	jal	ffffffffc0201dbc <free_pages>
    return listelm->next;
ffffffffc0201144:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201148:	01278963          	beq	a5,s2,ffffffffc020115a <default_check+0x2f0>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc020114c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201150:	679c                	ld	a5,8(a5)
ffffffffc0201152:	34fd                	addiw	s1,s1,-1
ffffffffc0201154:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201156:	ff279be3          	bne	a5,s2,ffffffffc020114c <default_check+0x2e2>
    }
    assert(count == 0);
ffffffffc020115a:	26049563          	bnez	s1,ffffffffc02013c4 <default_check+0x55a>
    assert(total == 0);
ffffffffc020115e:	46041363          	bnez	s0,ffffffffc02015c4 <default_check+0x75a>
}
ffffffffc0201162:	60e6                	ld	ra,88(sp)
ffffffffc0201164:	6446                	ld	s0,80(sp)
ffffffffc0201166:	64a6                	ld	s1,72(sp)
ffffffffc0201168:	6906                	ld	s2,64(sp)
ffffffffc020116a:	79e2                	ld	s3,56(sp)
ffffffffc020116c:	7a42                	ld	s4,48(sp)
ffffffffc020116e:	7aa2                	ld	s5,40(sp)
ffffffffc0201170:	7b02                	ld	s6,32(sp)
ffffffffc0201172:	6be2                	ld	s7,24(sp)
ffffffffc0201174:	6c42                	ld	s8,16(sp)
ffffffffc0201176:	6ca2                	ld	s9,8(sp)
ffffffffc0201178:	6125                	addi	sp,sp,96
ffffffffc020117a:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc020117c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020117e:	4401                	li	s0,0
ffffffffc0201180:	4481                	li	s1,0
ffffffffc0201182:	b33d                	j	ffffffffc0200eb0 <default_check+0x46>
        assert(PageProperty(p));
ffffffffc0201184:	00004697          	auipc	a3,0x4
ffffffffc0201188:	8c468693          	addi	a3,a3,-1852 # ffffffffc0204a48 <etext+0xac8>
ffffffffc020118c:	00004617          	auipc	a2,0x4
ffffffffc0201190:	8cc60613          	addi	a2,a2,-1844 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201194:	0f000593          	li	a1,240
ffffffffc0201198:	00004517          	auipc	a0,0x4
ffffffffc020119c:	8d850513          	addi	a0,a0,-1832 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02011a0:	a66ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02011a4:	00004697          	auipc	a3,0x4
ffffffffc02011a8:	98c68693          	addi	a3,a3,-1652 # ffffffffc0204b30 <etext+0xbb0>
ffffffffc02011ac:	00004617          	auipc	a2,0x4
ffffffffc02011b0:	8ac60613          	addi	a2,a2,-1876 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02011b4:	0be00593          	li	a1,190
ffffffffc02011b8:	00004517          	auipc	a0,0x4
ffffffffc02011bc:	8b850513          	addi	a0,a0,-1864 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02011c0:	a46ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02011c4:	00004697          	auipc	a3,0x4
ffffffffc02011c8:	a3468693          	addi	a3,a3,-1484 # ffffffffc0204bf8 <etext+0xc78>
ffffffffc02011cc:	00004617          	auipc	a2,0x4
ffffffffc02011d0:	88c60613          	addi	a2,a2,-1908 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02011d4:	0d900593          	li	a1,217
ffffffffc02011d8:	00004517          	auipc	a0,0x4
ffffffffc02011dc:	89850513          	addi	a0,a0,-1896 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02011e0:	a26ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02011e4:	00004697          	auipc	a3,0x4
ffffffffc02011e8:	98c68693          	addi	a3,a3,-1652 # ffffffffc0204b70 <etext+0xbf0>
ffffffffc02011ec:	00004617          	auipc	a2,0x4
ffffffffc02011f0:	86c60613          	addi	a2,a2,-1940 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02011f4:	0c000593          	li	a1,192
ffffffffc02011f8:	00004517          	auipc	a0,0x4
ffffffffc02011fc:	87850513          	addi	a0,a0,-1928 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201200:	a06ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201204:	00004697          	auipc	a3,0x4
ffffffffc0201208:	90468693          	addi	a3,a3,-1788 # ffffffffc0204b08 <etext+0xb88>
ffffffffc020120c:	00004617          	auipc	a2,0x4
ffffffffc0201210:	84c60613          	addi	a2,a2,-1972 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201214:	0bd00593          	li	a1,189
ffffffffc0201218:	00004517          	auipc	a0,0x4
ffffffffc020121c:	85850513          	addi	a0,a0,-1960 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201220:	9e6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201224:	00004697          	auipc	a3,0x4
ffffffffc0201228:	88468693          	addi	a3,a3,-1916 # ffffffffc0204aa8 <etext+0xb28>
ffffffffc020122c:	00004617          	auipc	a2,0x4
ffffffffc0201230:	82c60613          	addi	a2,a2,-2004 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201234:	0d200593          	li	a1,210
ffffffffc0201238:	00004517          	auipc	a0,0x4
ffffffffc020123c:	83850513          	addi	a0,a0,-1992 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201240:	9c6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 3);
ffffffffc0201244:	00004697          	auipc	a3,0x4
ffffffffc0201248:	9a468693          	addi	a3,a3,-1628 # ffffffffc0204be8 <etext+0xc68>
ffffffffc020124c:	00004617          	auipc	a2,0x4
ffffffffc0201250:	80c60613          	addi	a2,a2,-2036 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201254:	0d000593          	li	a1,208
ffffffffc0201258:	00004517          	auipc	a0,0x4
ffffffffc020125c:	81850513          	addi	a0,a0,-2024 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201260:	9a6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201264:	00004697          	auipc	a3,0x4
ffffffffc0201268:	96c68693          	addi	a3,a3,-1684 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc020126c:	00003617          	auipc	a2,0x3
ffffffffc0201270:	7ec60613          	addi	a2,a2,2028 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201274:	0cb00593          	li	a1,203
ffffffffc0201278:	00003517          	auipc	a0,0x3
ffffffffc020127c:	7f850513          	addi	a0,a0,2040 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201280:	986ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201284:	00004697          	auipc	a3,0x4
ffffffffc0201288:	92c68693          	addi	a3,a3,-1748 # ffffffffc0204bb0 <etext+0xc30>
ffffffffc020128c:	00003617          	auipc	a2,0x3
ffffffffc0201290:	7cc60613          	addi	a2,a2,1996 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201294:	0c200593          	li	a1,194
ffffffffc0201298:	00003517          	auipc	a0,0x3
ffffffffc020129c:	7d850513          	addi	a0,a0,2008 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02012a0:	966ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 != NULL);
ffffffffc02012a4:	00004697          	auipc	a3,0x4
ffffffffc02012a8:	99c68693          	addi	a3,a3,-1636 # ffffffffc0204c40 <etext+0xcc0>
ffffffffc02012ac:	00003617          	auipc	a2,0x3
ffffffffc02012b0:	7ac60613          	addi	a2,a2,1964 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02012b4:	0f800593          	li	a1,248
ffffffffc02012b8:	00003517          	auipc	a0,0x3
ffffffffc02012bc:	7b850513          	addi	a0,a0,1976 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02012c0:	946ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc02012c4:	00004697          	auipc	a3,0x4
ffffffffc02012c8:	96c68693          	addi	a3,a3,-1684 # ffffffffc0204c30 <etext+0xcb0>
ffffffffc02012cc:	00003617          	auipc	a2,0x3
ffffffffc02012d0:	78c60613          	addi	a2,a2,1932 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02012d4:	0df00593          	li	a1,223
ffffffffc02012d8:	00003517          	auipc	a0,0x3
ffffffffc02012dc:	79850513          	addi	a0,a0,1944 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02012e0:	926ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012e4:	00004697          	auipc	a3,0x4
ffffffffc02012e8:	8ec68693          	addi	a3,a3,-1812 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc02012ec:	00003617          	auipc	a2,0x3
ffffffffc02012f0:	76c60613          	addi	a2,a2,1900 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02012f4:	0dd00593          	li	a1,221
ffffffffc02012f8:	00003517          	auipc	a0,0x3
ffffffffc02012fc:	77850513          	addi	a0,a0,1912 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201300:	906ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201304:	00004697          	auipc	a3,0x4
ffffffffc0201308:	90c68693          	addi	a3,a3,-1780 # ffffffffc0204c10 <etext+0xc90>
ffffffffc020130c:	00003617          	auipc	a2,0x3
ffffffffc0201310:	74c60613          	addi	a2,a2,1868 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201314:	0dc00593          	li	a1,220
ffffffffc0201318:	00003517          	auipc	a0,0x3
ffffffffc020131c:	75850513          	addi	a0,a0,1880 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201320:	8e6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201324:	00003697          	auipc	a3,0x3
ffffffffc0201328:	78468693          	addi	a3,a3,1924 # ffffffffc0204aa8 <etext+0xb28>
ffffffffc020132c:	00003617          	auipc	a2,0x3
ffffffffc0201330:	72c60613          	addi	a2,a2,1836 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201334:	0b900593          	li	a1,185
ffffffffc0201338:	00003517          	auipc	a0,0x3
ffffffffc020133c:	73850513          	addi	a0,a0,1848 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201340:	8c6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201344:	00004697          	auipc	a3,0x4
ffffffffc0201348:	88c68693          	addi	a3,a3,-1908 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc020134c:	00003617          	auipc	a2,0x3
ffffffffc0201350:	70c60613          	addi	a2,a2,1804 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201354:	0d600593          	li	a1,214
ffffffffc0201358:	00003517          	auipc	a0,0x3
ffffffffc020135c:	71850513          	addi	a0,a0,1816 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201360:	8a6ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201364:	00003697          	auipc	a3,0x3
ffffffffc0201368:	78468693          	addi	a3,a3,1924 # ffffffffc0204ae8 <etext+0xb68>
ffffffffc020136c:	00003617          	auipc	a2,0x3
ffffffffc0201370:	6ec60613          	addi	a2,a2,1772 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201374:	0d400593          	li	a1,212
ffffffffc0201378:	00003517          	auipc	a0,0x3
ffffffffc020137c:	6f850513          	addi	a0,a0,1784 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201380:	886ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201384:	00003697          	auipc	a3,0x3
ffffffffc0201388:	74468693          	addi	a3,a3,1860 # ffffffffc0204ac8 <etext+0xb48>
ffffffffc020138c:	00003617          	auipc	a2,0x3
ffffffffc0201390:	6cc60613          	addi	a2,a2,1740 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201394:	0d300593          	li	a1,211
ffffffffc0201398:	00003517          	auipc	a0,0x3
ffffffffc020139c:	6d850513          	addi	a0,a0,1752 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02013a0:	866ff0ef          	jal	ffffffffc0200406 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02013a4:	00003697          	auipc	a3,0x3
ffffffffc02013a8:	74468693          	addi	a3,a3,1860 # ffffffffc0204ae8 <etext+0xb68>
ffffffffc02013ac:	00003617          	auipc	a2,0x3
ffffffffc02013b0:	6ac60613          	addi	a2,a2,1708 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02013b4:	0bb00593          	li	a1,187
ffffffffc02013b8:	00003517          	auipc	a0,0x3
ffffffffc02013bc:	6b850513          	addi	a0,a0,1720 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02013c0:	846ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(count == 0);
ffffffffc02013c4:	00004697          	auipc	a3,0x4
ffffffffc02013c8:	9cc68693          	addi	a3,a3,-1588 # ffffffffc0204d90 <etext+0xe10>
ffffffffc02013cc:	00003617          	auipc	a2,0x3
ffffffffc02013d0:	68c60613          	addi	a2,a2,1676 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02013d4:	12500593          	li	a1,293
ffffffffc02013d8:	00003517          	auipc	a0,0x3
ffffffffc02013dc:	69850513          	addi	a0,a0,1688 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02013e0:	826ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free == 0);
ffffffffc02013e4:	00004697          	auipc	a3,0x4
ffffffffc02013e8:	84c68693          	addi	a3,a3,-1972 # ffffffffc0204c30 <etext+0xcb0>
ffffffffc02013ec:	00003617          	auipc	a2,0x3
ffffffffc02013f0:	66c60613          	addi	a2,a2,1644 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02013f4:	11a00593          	li	a1,282
ffffffffc02013f8:	00003517          	auipc	a0,0x3
ffffffffc02013fc:	67850513          	addi	a0,a0,1656 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201400:	806ff0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201404:	00003697          	auipc	a3,0x3
ffffffffc0201408:	7cc68693          	addi	a3,a3,1996 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc020140c:	00003617          	auipc	a2,0x3
ffffffffc0201410:	64c60613          	addi	a2,a2,1612 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201414:	11800593          	li	a1,280
ffffffffc0201418:	00003517          	auipc	a0,0x3
ffffffffc020141c:	65850513          	addi	a0,a0,1624 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201420:	fe7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201424:	00003697          	auipc	a3,0x3
ffffffffc0201428:	76c68693          	addi	a3,a3,1900 # ffffffffc0204b90 <etext+0xc10>
ffffffffc020142c:	00003617          	auipc	a2,0x3
ffffffffc0201430:	62c60613          	addi	a2,a2,1580 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201434:	0c100593          	li	a1,193
ffffffffc0201438:	00003517          	auipc	a0,0x3
ffffffffc020143c:	63850513          	addi	a0,a0,1592 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201440:	fc7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201444:	00004697          	auipc	a3,0x4
ffffffffc0201448:	90c68693          	addi	a3,a3,-1780 # ffffffffc0204d50 <etext+0xdd0>
ffffffffc020144c:	00003617          	auipc	a2,0x3
ffffffffc0201450:	60c60613          	addi	a2,a2,1548 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201454:	11200593          	li	a1,274
ffffffffc0201458:	00003517          	auipc	a0,0x3
ffffffffc020145c:	61850513          	addi	a0,a0,1560 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201460:	fa7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201464:	00004697          	auipc	a3,0x4
ffffffffc0201468:	8cc68693          	addi	a3,a3,-1844 # ffffffffc0204d30 <etext+0xdb0>
ffffffffc020146c:	00003617          	auipc	a2,0x3
ffffffffc0201470:	5ec60613          	addi	a2,a2,1516 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201474:	11000593          	li	a1,272
ffffffffc0201478:	00003517          	auipc	a0,0x3
ffffffffc020147c:	5f850513          	addi	a0,a0,1528 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201480:	f87fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201484:	00004697          	auipc	a3,0x4
ffffffffc0201488:	88468693          	addi	a3,a3,-1916 # ffffffffc0204d08 <etext+0xd88>
ffffffffc020148c:	00003617          	auipc	a2,0x3
ffffffffc0201490:	5cc60613          	addi	a2,a2,1484 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201494:	10e00593          	li	a1,270
ffffffffc0201498:	00003517          	auipc	a0,0x3
ffffffffc020149c:	5d850513          	addi	a0,a0,1496 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02014a0:	f67fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02014a4:	00004697          	auipc	a3,0x4
ffffffffc02014a8:	83c68693          	addi	a3,a3,-1988 # ffffffffc0204ce0 <etext+0xd60>
ffffffffc02014ac:	00003617          	auipc	a2,0x3
ffffffffc02014b0:	5ac60613          	addi	a2,a2,1452 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02014b4:	10d00593          	li	a1,269
ffffffffc02014b8:	00003517          	auipc	a0,0x3
ffffffffc02014bc:	5b850513          	addi	a0,a0,1464 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02014c0:	f47fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02014c4:	00004697          	auipc	a3,0x4
ffffffffc02014c8:	80c68693          	addi	a3,a3,-2036 # ffffffffc0204cd0 <etext+0xd50>
ffffffffc02014cc:	00003617          	auipc	a2,0x3
ffffffffc02014d0:	58c60613          	addi	a2,a2,1420 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02014d4:	10800593          	li	a1,264
ffffffffc02014d8:	00003517          	auipc	a0,0x3
ffffffffc02014dc:	59850513          	addi	a0,a0,1432 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02014e0:	f27fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014e4:	00003697          	auipc	a3,0x3
ffffffffc02014e8:	6ec68693          	addi	a3,a3,1772 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc02014ec:	00003617          	auipc	a2,0x3
ffffffffc02014f0:	56c60613          	addi	a2,a2,1388 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02014f4:	10700593          	li	a1,263
ffffffffc02014f8:	00003517          	auipc	a0,0x3
ffffffffc02014fc:	57850513          	addi	a0,a0,1400 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201500:	f07fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201504:	00003697          	auipc	a3,0x3
ffffffffc0201508:	7ac68693          	addi	a3,a3,1964 # ffffffffc0204cb0 <etext+0xd30>
ffffffffc020150c:	00003617          	auipc	a2,0x3
ffffffffc0201510:	54c60613          	addi	a2,a2,1356 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201514:	10600593          	li	a1,262
ffffffffc0201518:	00003517          	auipc	a0,0x3
ffffffffc020151c:	55850513          	addi	a0,a0,1368 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201520:	ee7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201524:	00003697          	auipc	a3,0x3
ffffffffc0201528:	75c68693          	addi	a3,a3,1884 # ffffffffc0204c80 <etext+0xd00>
ffffffffc020152c:	00003617          	auipc	a2,0x3
ffffffffc0201530:	52c60613          	addi	a2,a2,1324 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201534:	10500593          	li	a1,261
ffffffffc0201538:	00003517          	auipc	a0,0x3
ffffffffc020153c:	53850513          	addi	a0,a0,1336 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201540:	ec7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201544:	00003697          	auipc	a3,0x3
ffffffffc0201548:	72468693          	addi	a3,a3,1828 # ffffffffc0204c68 <etext+0xce8>
ffffffffc020154c:	00003617          	auipc	a2,0x3
ffffffffc0201550:	50c60613          	addi	a2,a2,1292 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201554:	10400593          	li	a1,260
ffffffffc0201558:	00003517          	auipc	a0,0x3
ffffffffc020155c:	51850513          	addi	a0,a0,1304 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201560:	ea7fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201564:	00003697          	auipc	a3,0x3
ffffffffc0201568:	66c68693          	addi	a3,a3,1644 # ffffffffc0204bd0 <etext+0xc50>
ffffffffc020156c:	00003617          	auipc	a2,0x3
ffffffffc0201570:	4ec60613          	addi	a2,a2,1260 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201574:	0fe00593          	li	a1,254
ffffffffc0201578:	00003517          	auipc	a0,0x3
ffffffffc020157c:	4f850513          	addi	a0,a0,1272 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201580:	e87fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201584:	00003697          	auipc	a3,0x3
ffffffffc0201588:	6cc68693          	addi	a3,a3,1740 # ffffffffc0204c50 <etext+0xcd0>
ffffffffc020158c:	00003617          	auipc	a2,0x3
ffffffffc0201590:	4cc60613          	addi	a2,a2,1228 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201594:	0f900593          	li	a1,249
ffffffffc0201598:	00003517          	auipc	a0,0x3
ffffffffc020159c:	4d850513          	addi	a0,a0,1240 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02015a0:	e67fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02015a4:	00003697          	auipc	a3,0x3
ffffffffc02015a8:	7cc68693          	addi	a3,a3,1996 # ffffffffc0204d70 <etext+0xdf0>
ffffffffc02015ac:	00003617          	auipc	a2,0x3
ffffffffc02015b0:	4ac60613          	addi	a2,a2,1196 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02015b4:	11700593          	li	a1,279
ffffffffc02015b8:	00003517          	auipc	a0,0x3
ffffffffc02015bc:	4b850513          	addi	a0,a0,1208 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02015c0:	e47fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == 0);
ffffffffc02015c4:	00003697          	auipc	a3,0x3
ffffffffc02015c8:	7dc68693          	addi	a3,a3,2012 # ffffffffc0204da0 <etext+0xe20>
ffffffffc02015cc:	00003617          	auipc	a2,0x3
ffffffffc02015d0:	48c60613          	addi	a2,a2,1164 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02015d4:	12600593          	li	a1,294
ffffffffc02015d8:	00003517          	auipc	a0,0x3
ffffffffc02015dc:	49850513          	addi	a0,a0,1176 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc02015e0:	e27fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(total == nr_free_pages());
ffffffffc02015e4:	00003697          	auipc	a3,0x3
ffffffffc02015e8:	4a468693          	addi	a3,a3,1188 # ffffffffc0204a88 <etext+0xb08>
ffffffffc02015ec:	00003617          	auipc	a2,0x3
ffffffffc02015f0:	46c60613          	addi	a2,a2,1132 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02015f4:	0f300593          	li	a1,243
ffffffffc02015f8:	00003517          	auipc	a0,0x3
ffffffffc02015fc:	47850513          	addi	a0,a0,1144 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201600:	e07fe0ef          	jal	ffffffffc0200406 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201604:	00003697          	auipc	a3,0x3
ffffffffc0201608:	4c468693          	addi	a3,a3,1220 # ffffffffc0204ac8 <etext+0xb48>
ffffffffc020160c:	00003617          	auipc	a2,0x3
ffffffffc0201610:	44c60613          	addi	a2,a2,1100 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201614:	0ba00593          	li	a1,186
ffffffffc0201618:	00003517          	auipc	a0,0x3
ffffffffc020161c:	45850513          	addi	a0,a0,1112 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201620:	de7fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201624 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201624:	1141                	addi	sp,sp,-16
ffffffffc0201626:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201628:	14058663          	beqz	a1,ffffffffc0201774 <default_free_pages+0x150>
    for (; p != base + n; p ++) {
ffffffffc020162c:	00659713          	slli	a4,a1,0x6
ffffffffc0201630:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0201634:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0201636:	c30d                	beqz	a4,ffffffffc0201658 <default_free_pages+0x34>
ffffffffc0201638:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020163a:	8b05                	andi	a4,a4,1
ffffffffc020163c:	10071c63          	bnez	a4,ffffffffc0201754 <default_free_pages+0x130>
ffffffffc0201640:	6798                	ld	a4,8(a5)
ffffffffc0201642:	8b09                	andi	a4,a4,2
ffffffffc0201644:	10071863          	bnez	a4,ffffffffc0201754 <default_free_pages+0x130>
        p->flags = 0;
ffffffffc0201648:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc020164c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201650:	04078793          	addi	a5,a5,64
ffffffffc0201654:	fed792e3          	bne	a5,a3,ffffffffc0201638 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201658:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020165a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020165e:	4789                	li	a5,2
ffffffffc0201660:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201664:	00008717          	auipc	a4,0x8
ffffffffc0201668:	ddc72703          	lw	a4,-548(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc020166c:	00008697          	auipc	a3,0x8
ffffffffc0201670:	dc468693          	addi	a3,a3,-572 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc0201674:	669c                	ld	a5,8(a3)
ffffffffc0201676:	9f2d                	addw	a4,a4,a1
ffffffffc0201678:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020167a:	0ad78163          	beq	a5,a3,ffffffffc020171c <default_free_pages+0xf8>
            struct Page* page = le2page(le, page_link);
ffffffffc020167e:	fe878713          	addi	a4,a5,-24
ffffffffc0201682:	4581                	li	a1,0
ffffffffc0201684:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0201688:	00e56a63          	bltu	a0,a4,ffffffffc020169c <default_free_pages+0x78>
    return listelm->next;
ffffffffc020168c:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020168e:	04d70c63          	beq	a4,a3,ffffffffc02016e6 <default_free_pages+0xc2>
    struct Page *p = base;
ffffffffc0201692:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201694:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201698:	fee57ae3          	bgeu	a0,a4,ffffffffc020168c <default_free_pages+0x68>
ffffffffc020169c:	c199                	beqz	a1,ffffffffc02016a2 <default_free_pages+0x7e>
ffffffffc020169e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02016a2:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02016a4:	e390                	sd	a2,0(a5)
ffffffffc02016a6:	e710                	sd	a2,8(a4)
    elm->next = next;
    elm->prev = prev;
ffffffffc02016a8:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02016aa:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc02016ac:	00d70d63          	beq	a4,a3,ffffffffc02016c6 <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc02016b0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02016b4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc02016b8:	02059813          	slli	a6,a1,0x20
ffffffffc02016bc:	01a85793          	srli	a5,a6,0x1a
ffffffffc02016c0:	97b2                	add	a5,a5,a2
ffffffffc02016c2:	02f50c63          	beq	a0,a5,ffffffffc02016fa <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02016c6:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc02016c8:	00d78c63          	beq	a5,a3,ffffffffc02016e0 <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc02016cc:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02016ce:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc02016d2:	02061593          	slli	a1,a2,0x20
ffffffffc02016d6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02016da:	972a                	add	a4,a4,a0
ffffffffc02016dc:	04e68c63          	beq	a3,a4,ffffffffc0201734 <default_free_pages+0x110>
}
ffffffffc02016e0:	60a2                	ld	ra,8(sp)
ffffffffc02016e2:	0141                	addi	sp,sp,16
ffffffffc02016e4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02016e6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02016e8:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02016ea:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02016ec:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02016ee:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02016f0:	02d70f63          	beq	a4,a3,ffffffffc020172e <default_free_pages+0x10a>
ffffffffc02016f4:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02016f6:	87ba                	mv	a5,a4
ffffffffc02016f8:	bf71                	j	ffffffffc0201694 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02016fa:	491c                	lw	a5,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02016fc:	5875                	li	a6,-3
ffffffffc02016fe:	9fad                	addw	a5,a5,a1
ffffffffc0201700:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201704:	6108b02f          	amoand.d	zero,a6,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201708:	01853803          	ld	a6,24(a0)
ffffffffc020170c:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc020170e:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201710:	00b83423          	sd	a1,8(a6) # ff0008 <kern_entry-0xffffffffbf20fff8>
    return listelm->next;
ffffffffc0201714:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201716:	0105b023          	sd	a6,0(a1)
ffffffffc020171a:	b77d                	j	ffffffffc02016c8 <default_free_pages+0xa4>
}
ffffffffc020171c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020171e:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc0201722:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201724:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0201726:	e398                	sd	a4,0(a5)
ffffffffc0201728:	e798                	sd	a4,8(a5)
}
ffffffffc020172a:	0141                	addi	sp,sp,16
ffffffffc020172c:	8082                	ret
ffffffffc020172e:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201730:	873e                	mv	a4,a5
ffffffffc0201732:	bfad                	j	ffffffffc02016ac <default_free_pages+0x88>
            base->property += p->property;
ffffffffc0201734:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201738:	56f5                	li	a3,-3
ffffffffc020173a:	9f31                	addw	a4,a4,a2
ffffffffc020173c:	c918                	sw	a4,16(a0)
ffffffffc020173e:	ff078713          	addi	a4,a5,-16
ffffffffc0201742:	60d7302f          	amoand.d	zero,a3,(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201746:	6398                	ld	a4,0(a5)
ffffffffc0201748:	679c                	ld	a5,8(a5)
}
ffffffffc020174a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020174c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020174e:	e398                	sd	a4,0(a5)
ffffffffc0201750:	0141                	addi	sp,sp,16
ffffffffc0201752:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201754:	00003697          	auipc	a3,0x3
ffffffffc0201758:	66468693          	addi	a3,a3,1636 # ffffffffc0204db8 <etext+0xe38>
ffffffffc020175c:	00003617          	auipc	a2,0x3
ffffffffc0201760:	2fc60613          	addi	a2,a2,764 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201764:	08300593          	li	a1,131
ffffffffc0201768:	00003517          	auipc	a0,0x3
ffffffffc020176c:	30850513          	addi	a0,a0,776 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201770:	c97fe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc0201774:	00003697          	auipc	a3,0x3
ffffffffc0201778:	63c68693          	addi	a3,a3,1596 # ffffffffc0204db0 <etext+0xe30>
ffffffffc020177c:	00003617          	auipc	a2,0x3
ffffffffc0201780:	2dc60613          	addi	a2,a2,732 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201784:	08000593          	li	a1,128
ffffffffc0201788:	00003517          	auipc	a0,0x3
ffffffffc020178c:	2e850513          	addi	a0,a0,744 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc0201790:	c77fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201794 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201794:	c951                	beqz	a0,ffffffffc0201828 <default_alloc_pages+0x94>
    if (n > nr_free) {
ffffffffc0201796:	00008597          	auipc	a1,0x8
ffffffffc020179a:	caa5a583          	lw	a1,-854(a1) # ffffffffc0209440 <free_area+0x10>
ffffffffc020179e:	86aa                	mv	a3,a0
ffffffffc02017a0:	02059793          	slli	a5,a1,0x20
ffffffffc02017a4:	9381                	srli	a5,a5,0x20
ffffffffc02017a6:	00a7ef63          	bltu	a5,a0,ffffffffc02017c4 <default_alloc_pages+0x30>
    list_entry_t *le = &free_list;
ffffffffc02017aa:	00008617          	auipc	a2,0x8
ffffffffc02017ae:	c8660613          	addi	a2,a2,-890 # ffffffffc0209430 <free_area>
ffffffffc02017b2:	87b2                	mv	a5,a2
ffffffffc02017b4:	a029                	j	ffffffffc02017be <default_alloc_pages+0x2a>
        if (p->property >= n) {
ffffffffc02017b6:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02017ba:	00d77763          	bgeu	a4,a3,ffffffffc02017c8 <default_alloc_pages+0x34>
    return listelm->next;
ffffffffc02017be:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02017c0:	fec79be3          	bne	a5,a2,ffffffffc02017b6 <default_alloc_pages+0x22>
        return NULL;
ffffffffc02017c4:	4501                	li	a0,0
}
ffffffffc02017c6:	8082                	ret
        if (page->property > n) {
ffffffffc02017c8:	ff87a883          	lw	a7,-8(a5)
    return listelm->prev;
ffffffffc02017cc:	0007b803          	ld	a6,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02017d0:	6798                	ld	a4,8(a5)
ffffffffc02017d2:	02089313          	slli	t1,a7,0x20
ffffffffc02017d6:	02035313          	srli	t1,t1,0x20
    prev->next = next;
ffffffffc02017da:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc02017de:	01073023          	sd	a6,0(a4)
        struct Page *p = le2page(le, page_link);
ffffffffc02017e2:	fe878513          	addi	a0,a5,-24
        if (page->property > n) {
ffffffffc02017e6:	0266fa63          	bgeu	a3,t1,ffffffffc020181a <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc02017ea:	00669713          	slli	a4,a3,0x6
            p->property = page->property - n;
ffffffffc02017ee:	40d888bb          	subw	a7,a7,a3
            struct Page *p = page + n;
ffffffffc02017f2:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02017f4:	01172823          	sw	a7,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017f8:	00870313          	addi	t1,a4,8
ffffffffc02017fc:	4889                	li	a7,2
ffffffffc02017fe:	4113302f          	amoor.d	zero,a7,(t1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201802:	00883883          	ld	a7,8(a6)
            list_add(prev, &(p->page_link));
ffffffffc0201806:	01870313          	addi	t1,a4,24
    prev->next = next->prev = elm;
ffffffffc020180a:	0068b023          	sd	t1,0(a7)
ffffffffc020180e:	00683423          	sd	t1,8(a6)
    elm->next = next;
ffffffffc0201812:	03173023          	sd	a7,32(a4)
    elm->prev = prev;
ffffffffc0201816:	01073c23          	sd	a6,24(a4)
        nr_free -= n;
ffffffffc020181a:	9d95                	subw	a1,a1,a3
ffffffffc020181c:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020181e:	5775                	li	a4,-3
ffffffffc0201820:	17c1                	addi	a5,a5,-16
ffffffffc0201822:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201826:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0201828:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020182a:	00003697          	auipc	a3,0x3
ffffffffc020182e:	58668693          	addi	a3,a3,1414 # ffffffffc0204db0 <etext+0xe30>
ffffffffc0201832:	00003617          	auipc	a2,0x3
ffffffffc0201836:	22660613          	addi	a2,a2,550 # ffffffffc0204a58 <etext+0xad8>
ffffffffc020183a:	06200593          	li	a1,98
ffffffffc020183e:	00003517          	auipc	a0,0x3
ffffffffc0201842:	23250513          	addi	a0,a0,562 # ffffffffc0204a70 <etext+0xaf0>
default_alloc_pages(size_t n) {
ffffffffc0201846:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201848:	bbffe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020184c <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc020184c:	1141                	addi	sp,sp,-16
ffffffffc020184e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201850:	c9e1                	beqz	a1,ffffffffc0201920 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201852:	00659713          	slli	a4,a1,0x6
ffffffffc0201856:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc020185a:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc020185c:	cf11                	beqz	a4,ffffffffc0201878 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020185e:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201860:	8b05                	andi	a4,a4,1
ffffffffc0201862:	cf59                	beqz	a4,ffffffffc0201900 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc0201864:	0007a823          	sw	zero,16(a5)
ffffffffc0201868:	0007b423          	sd	zero,8(a5)
ffffffffc020186c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201870:	04078793          	addi	a5,a5,64
ffffffffc0201874:	fed795e3          	bne	a5,a3,ffffffffc020185e <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201878:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020187a:	4789                	li	a5,2
ffffffffc020187c:	00850713          	addi	a4,a0,8
ffffffffc0201880:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201884:	00008717          	auipc	a4,0x8
ffffffffc0201888:	bbc72703          	lw	a4,-1092(a4) # ffffffffc0209440 <free_area+0x10>
ffffffffc020188c:	00008697          	auipc	a3,0x8
ffffffffc0201890:	ba468693          	addi	a3,a3,-1116 # ffffffffc0209430 <free_area>
    return list->next == list;
ffffffffc0201894:	669c                	ld	a5,8(a3)
ffffffffc0201896:	9f2d                	addw	a4,a4,a1
ffffffffc0201898:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020189a:	04d78663          	beq	a5,a3,ffffffffc02018e6 <default_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
ffffffffc020189e:	fe878713          	addi	a4,a5,-24
ffffffffc02018a2:	4581                	li	a1,0
ffffffffc02018a4:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02018a8:	00e56a63          	bltu	a0,a4,ffffffffc02018bc <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02018ac:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02018ae:	02d70263          	beq	a4,a3,ffffffffc02018d2 <default_init_memmap+0x86>
    struct Page *p = base;
ffffffffc02018b2:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02018b4:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02018b8:	fee57ae3          	bgeu	a0,a4,ffffffffc02018ac <default_init_memmap+0x60>
ffffffffc02018bc:	c199                	beqz	a1,ffffffffc02018c2 <default_init_memmap+0x76>
ffffffffc02018be:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02018c2:	6398                	ld	a4,0(a5)
}
ffffffffc02018c4:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02018c6:	e390                	sd	a2,0(a5)
ffffffffc02018c8:	e710                	sd	a2,8(a4)
    elm->prev = prev;
ffffffffc02018ca:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc02018cc:	f11c                	sd	a5,32(a0)
ffffffffc02018ce:	0141                	addi	sp,sp,16
ffffffffc02018d0:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02018d2:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018d4:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02018d6:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02018d8:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02018da:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02018dc:	00d70e63          	beq	a4,a3,ffffffffc02018f8 <default_init_memmap+0xac>
ffffffffc02018e0:	4585                	li	a1,1
    struct Page *p = base;
ffffffffc02018e2:	87ba                	mv	a5,a4
ffffffffc02018e4:	bfc1                	j	ffffffffc02018b4 <default_init_memmap+0x68>
}
ffffffffc02018e6:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc02018e8:	01850713          	addi	a4,a0,24
    elm->next = next;
ffffffffc02018ec:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02018ee:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc02018f0:	e398                	sd	a4,0(a5)
ffffffffc02018f2:	e798                	sd	a4,8(a5)
}
ffffffffc02018f4:	0141                	addi	sp,sp,16
ffffffffc02018f6:	8082                	ret
ffffffffc02018f8:	60a2                	ld	ra,8(sp)
ffffffffc02018fa:	e290                	sd	a2,0(a3)
ffffffffc02018fc:	0141                	addi	sp,sp,16
ffffffffc02018fe:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201900:	00003697          	auipc	a3,0x3
ffffffffc0201904:	4e068693          	addi	a3,a3,1248 # ffffffffc0204de0 <etext+0xe60>
ffffffffc0201908:	00003617          	auipc	a2,0x3
ffffffffc020190c:	15060613          	addi	a2,a2,336 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201910:	04900593          	li	a1,73
ffffffffc0201914:	00003517          	auipc	a0,0x3
ffffffffc0201918:	15c50513          	addi	a0,a0,348 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc020191c:	aebfe0ef          	jal	ffffffffc0200406 <__panic>
    assert(n > 0);
ffffffffc0201920:	00003697          	auipc	a3,0x3
ffffffffc0201924:	49068693          	addi	a3,a3,1168 # ffffffffc0204db0 <etext+0xe30>
ffffffffc0201928:	00003617          	auipc	a2,0x3
ffffffffc020192c:	13060613          	addi	a2,a2,304 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201930:	04600593          	li	a1,70
ffffffffc0201934:	00003517          	auipc	a0,0x3
ffffffffc0201938:	13c50513          	addi	a0,a0,316 # ffffffffc0204a70 <etext+0xaf0>
ffffffffc020193c:	acbfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201940 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201940:	c531                	beqz	a0,ffffffffc020198c <slob_free+0x4c>
		return;

	if (size)
ffffffffc0201942:	e9b9                	bnez	a1,ffffffffc0201998 <slob_free+0x58>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201944:	100027f3          	csrr	a5,sstatus
ffffffffc0201948:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020194a:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020194c:	efb1                	bnez	a5,ffffffffc02019a8 <slob_free+0x68>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020194e:	00007797          	auipc	a5,0x7
ffffffffc0201952:	6d27b783          	ld	a5,1746(a5) # ffffffffc0209020 <slobfree>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201956:	873e                	mv	a4,a5
ffffffffc0201958:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020195a:	02a77a63          	bgeu	a4,a0,ffffffffc020198e <slob_free+0x4e>
ffffffffc020195e:	00f56463          	bltu	a0,a5,ffffffffc0201966 <slob_free+0x26>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201962:	fef76ae3          	bltu	a4,a5,ffffffffc0201956 <slob_free+0x16>
			break;

	if (b + b->units == cur->next)
ffffffffc0201966:	4110                	lw	a2,0(a0)
ffffffffc0201968:	00461693          	slli	a3,a2,0x4
ffffffffc020196c:	96aa                	add	a3,a3,a0
ffffffffc020196e:	0ad78463          	beq	a5,a3,ffffffffc0201a16 <slob_free+0xd6>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201972:	4310                	lw	a2,0(a4)
ffffffffc0201974:	e51c                	sd	a5,8(a0)
ffffffffc0201976:	00461693          	slli	a3,a2,0x4
ffffffffc020197a:	96ba                	add	a3,a3,a4
ffffffffc020197c:	08d50163          	beq	a0,a3,ffffffffc02019fe <slob_free+0xbe>
ffffffffc0201980:	e708                	sd	a0,8(a4)
		cur->next = b->next;
	}
	else
		cur->next = b;

	slobfree = cur;
ffffffffc0201982:	00007797          	auipc	a5,0x7
ffffffffc0201986:	68e7bf23          	sd	a4,1694(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc020198a:	e9a5                	bnez	a1,ffffffffc02019fa <slob_free+0xba>
ffffffffc020198c:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020198e:	fcf574e3          	bgeu	a0,a5,ffffffffc0201956 <slob_free+0x16>
ffffffffc0201992:	fcf762e3          	bltu	a4,a5,ffffffffc0201956 <slob_free+0x16>
ffffffffc0201996:	bfc1                	j	ffffffffc0201966 <slob_free+0x26>
		b->units = SLOB_UNITS(size);
ffffffffc0201998:	25bd                	addiw	a1,a1,15
ffffffffc020199a:	8191                	srli	a1,a1,0x4
ffffffffc020199c:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020199e:	100027f3          	csrr	a5,sstatus
ffffffffc02019a2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02019a4:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019a6:	d7c5                	beqz	a5,ffffffffc020194e <slob_free+0xe>
{
ffffffffc02019a8:	1101                	addi	sp,sp,-32
ffffffffc02019aa:	e42a                	sd	a0,8(sp)
ffffffffc02019ac:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02019ae:	ec7fe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc02019b2:	6522                	ld	a0,8(sp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019b4:	00007797          	auipc	a5,0x7
ffffffffc02019b8:	66c7b783          	ld	a5,1644(a5) # ffffffffc0209020 <slobfree>
ffffffffc02019bc:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019be:	873e                	mv	a4,a5
ffffffffc02019c0:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02019c2:	06a77663          	bgeu	a4,a0,ffffffffc0201a2e <slob_free+0xee>
ffffffffc02019c6:	00f56463          	bltu	a0,a5,ffffffffc02019ce <slob_free+0x8e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02019ca:	fef76ae3          	bltu	a4,a5,ffffffffc02019be <slob_free+0x7e>
	if (b + b->units == cur->next)
ffffffffc02019ce:	4110                	lw	a2,0(a0)
ffffffffc02019d0:	00461693          	slli	a3,a2,0x4
ffffffffc02019d4:	96aa                	add	a3,a3,a0
ffffffffc02019d6:	06d78363          	beq	a5,a3,ffffffffc0201a3c <slob_free+0xfc>
	if (cur + cur->units == b)
ffffffffc02019da:	4310                	lw	a2,0(a4)
ffffffffc02019dc:	e51c                	sd	a5,8(a0)
ffffffffc02019de:	00461693          	slli	a3,a2,0x4
ffffffffc02019e2:	96ba                	add	a3,a3,a4
ffffffffc02019e4:	06d50163          	beq	a0,a3,ffffffffc0201a46 <slob_free+0x106>
ffffffffc02019e8:	e708                	sd	a0,8(a4)
	slobfree = cur;
ffffffffc02019ea:	00007797          	auipc	a5,0x7
ffffffffc02019ee:	62e7bb23          	sd	a4,1590(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc02019f2:	e1a9                	bnez	a1,ffffffffc0201a34 <slob_free+0xf4>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02019f4:	60e2                	ld	ra,24(sp)
ffffffffc02019f6:	6105                	addi	sp,sp,32
ffffffffc02019f8:	8082                	ret
        intr_enable();
ffffffffc02019fa:	e75fe06f          	j	ffffffffc020086e <intr_enable>
		cur->units += b->units;
ffffffffc02019fe:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201a00:	853e                	mv	a0,a5
ffffffffc0201a02:	e708                	sd	a0,8(a4)
		cur->units += b->units;
ffffffffc0201a04:	00c687bb          	addw	a5,a3,a2
ffffffffc0201a08:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc0201a0a:	00007797          	auipc	a5,0x7
ffffffffc0201a0e:	60e7bb23          	sd	a4,1558(a5) # ffffffffc0209020 <slobfree>
    if (flag) {
ffffffffc0201a12:	ddad                	beqz	a1,ffffffffc020198c <slob_free+0x4c>
ffffffffc0201a14:	b7dd                	j	ffffffffc02019fa <slob_free+0xba>
		b->units += cur->next->units;
ffffffffc0201a16:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a18:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a1a:	9eb1                	addw	a3,a3,a2
ffffffffc0201a1c:	c114                	sw	a3,0(a0)
	if (cur + cur->units == b)
ffffffffc0201a1e:	4310                	lw	a2,0(a4)
ffffffffc0201a20:	e51c                	sd	a5,8(a0)
ffffffffc0201a22:	00461693          	slli	a3,a2,0x4
ffffffffc0201a26:	96ba                	add	a3,a3,a4
ffffffffc0201a28:	f4d51ce3          	bne	a0,a3,ffffffffc0201980 <slob_free+0x40>
ffffffffc0201a2c:	bfc9                	j	ffffffffc02019fe <slob_free+0xbe>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201a2e:	f8f56ee3          	bltu	a0,a5,ffffffffc02019ca <slob_free+0x8a>
ffffffffc0201a32:	b771                	j	ffffffffc02019be <slob_free+0x7e>
}
ffffffffc0201a34:	60e2                	ld	ra,24(sp)
ffffffffc0201a36:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201a38:	e37fe06f          	j	ffffffffc020086e <intr_enable>
		b->units += cur->next->units;
ffffffffc0201a3c:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201a3e:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201a40:	9eb1                	addw	a3,a3,a2
ffffffffc0201a42:	c114                	sw	a3,0(a0)
		b->next = cur->next->next;
ffffffffc0201a44:	bf59                	j	ffffffffc02019da <slob_free+0x9a>
		cur->units += b->units;
ffffffffc0201a46:	4114                	lw	a3,0(a0)
		cur->next = b->next;
ffffffffc0201a48:	853e                	mv	a0,a5
		cur->units += b->units;
ffffffffc0201a4a:	00c687bb          	addw	a5,a3,a2
ffffffffc0201a4e:	c31c                	sw	a5,0(a4)
		cur->next = b->next;
ffffffffc0201a50:	bf61                	j	ffffffffc02019e8 <slob_free+0xa8>

ffffffffc0201a52 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a52:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a54:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a56:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201a5a:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201a5c:	326000ef          	jal	ffffffffc0201d82 <alloc_pages>
	if (!page)
ffffffffc0201a60:	c91d                	beqz	a0,ffffffffc0201a96 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201a62:	0000c697          	auipc	a3,0xc
ffffffffc0201a66:	a666b683          	ld	a3,-1434(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201a6a:	00004797          	auipc	a5,0x4
ffffffffc0201a6e:	16e7b783          	ld	a5,366(a5) # ffffffffc0205bd8 <nbase>
    return KADDR(page2pa(page));
ffffffffc0201a72:	0000c717          	auipc	a4,0xc
ffffffffc0201a76:	a4e73703          	ld	a4,-1458(a4) # ffffffffc020d4c0 <npage>
    return page - pages + nbase;
ffffffffc0201a7a:	8d15                	sub	a0,a0,a3
ffffffffc0201a7c:	8519                	srai	a0,a0,0x6
ffffffffc0201a7e:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc0201a80:	00c51793          	slli	a5,a0,0xc
ffffffffc0201a84:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201a86:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201a88:	00e7fa63          	bgeu	a5,a4,ffffffffc0201a9c <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201a8c:	0000c797          	auipc	a5,0xc
ffffffffc0201a90:	a2c7b783          	ld	a5,-1492(a5) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201a94:	953e                	add	a0,a0,a5
}
ffffffffc0201a96:	60a2                	ld	ra,8(sp)
ffffffffc0201a98:	0141                	addi	sp,sp,16
ffffffffc0201a9a:	8082                	ret
ffffffffc0201a9c:	86aa                	mv	a3,a0
ffffffffc0201a9e:	00003617          	auipc	a2,0x3
ffffffffc0201aa2:	36a60613          	addi	a2,a2,874 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0201aa6:	07100593          	li	a1,113
ffffffffc0201aaa:	00003517          	auipc	a0,0x3
ffffffffc0201aae:	38650513          	addi	a0,a0,902 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc0201ab2:	955fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201ab6 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201ab6:	7179                	addi	sp,sp,-48
ffffffffc0201ab8:	f406                	sd	ra,40(sp)
ffffffffc0201aba:	f022                	sd	s0,32(sp)
ffffffffc0201abc:	ec26                	sd	s1,24(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201abe:	01050713          	addi	a4,a0,16
ffffffffc0201ac2:	6785                	lui	a5,0x1
ffffffffc0201ac4:	0af77e63          	bgeu	a4,a5,ffffffffc0201b80 <slob_alloc.constprop.0+0xca>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201ac8:	00f50413          	addi	s0,a0,15
ffffffffc0201acc:	8011                	srli	s0,s0,0x4
ffffffffc0201ace:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ad0:	100025f3          	csrr	a1,sstatus
ffffffffc0201ad4:	8989                	andi	a1,a1,2
ffffffffc0201ad6:	edd1                	bnez	a1,ffffffffc0201b72 <slob_alloc.constprop.0+0xbc>
	prev = slobfree;
ffffffffc0201ad8:	00007497          	auipc	s1,0x7
ffffffffc0201adc:	54848493          	addi	s1,s1,1352 # ffffffffc0209020 <slobfree>
ffffffffc0201ae0:	6090                	ld	a2,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ae2:	6618                	ld	a4,8(a2)
		if (cur->units >= units + delta)
ffffffffc0201ae4:	4314                	lw	a3,0(a4)
ffffffffc0201ae6:	0886da63          	bge	a3,s0,ffffffffc0201b7a <slob_alloc.constprop.0+0xc4>
		if (cur == slobfree)
ffffffffc0201aea:	00e60a63          	beq	a2,a4,ffffffffc0201afe <slob_alloc.constprop.0+0x48>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201aee:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201af0:	4394                	lw	a3,0(a5)
ffffffffc0201af2:	0286d863          	bge	a3,s0,ffffffffc0201b22 <slob_alloc.constprop.0+0x6c>
		if (cur == slobfree)
ffffffffc0201af6:	6090                	ld	a2,0(s1)
ffffffffc0201af8:	873e                	mv	a4,a5
ffffffffc0201afa:	fee61ae3          	bne	a2,a4,ffffffffc0201aee <slob_alloc.constprop.0+0x38>
    if (flag) {
ffffffffc0201afe:	e9b1                	bnez	a1,ffffffffc0201b52 <slob_alloc.constprop.0+0x9c>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201b00:	4501                	li	a0,0
ffffffffc0201b02:	f51ff0ef          	jal	ffffffffc0201a52 <__slob_get_free_pages.constprop.0>
ffffffffc0201b06:	87aa                	mv	a5,a0
			if (!cur)
ffffffffc0201b08:	c915                	beqz	a0,ffffffffc0201b3c <slob_alloc.constprop.0+0x86>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201b0a:	6585                	lui	a1,0x1
ffffffffc0201b0c:	e35ff0ef          	jal	ffffffffc0201940 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b10:	100025f3          	csrr	a1,sstatus
ffffffffc0201b14:	8989                	andi	a1,a1,2
ffffffffc0201b16:	e98d                	bnez	a1,ffffffffc0201b48 <slob_alloc.constprop.0+0x92>
			cur = slobfree;
ffffffffc0201b18:	6098                	ld	a4,0(s1)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b1a:	671c                	ld	a5,8(a4)
		if (cur->units >= units + delta)
ffffffffc0201b1c:	4394                	lw	a3,0(a5)
ffffffffc0201b1e:	fc86cce3          	blt	a3,s0,ffffffffc0201af6 <slob_alloc.constprop.0+0x40>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201b22:	04d40563          	beq	s0,a3,ffffffffc0201b6c <slob_alloc.constprop.0+0xb6>
				prev->next = cur + units;
ffffffffc0201b26:	00441613          	slli	a2,s0,0x4
ffffffffc0201b2a:	963e                	add	a2,a2,a5
ffffffffc0201b2c:	e710                	sd	a2,8(a4)
				prev->next->next = cur->next;
ffffffffc0201b2e:	6788                	ld	a0,8(a5)
				prev->next->units = cur->units - units;
ffffffffc0201b30:	9e81                	subw	a3,a3,s0
ffffffffc0201b32:	c214                	sw	a3,0(a2)
				prev->next->next = cur->next;
ffffffffc0201b34:	e608                	sd	a0,8(a2)
				cur->units = units;
ffffffffc0201b36:	c380                	sw	s0,0(a5)
			slobfree = prev;
ffffffffc0201b38:	e098                	sd	a4,0(s1)
    if (flag) {
ffffffffc0201b3a:	ed99                	bnez	a1,ffffffffc0201b58 <slob_alloc.constprop.0+0xa2>
}
ffffffffc0201b3c:	70a2                	ld	ra,40(sp)
ffffffffc0201b3e:	7402                	ld	s0,32(sp)
ffffffffc0201b40:	64e2                	ld	s1,24(sp)
ffffffffc0201b42:	853e                	mv	a0,a5
ffffffffc0201b44:	6145                	addi	sp,sp,48
ffffffffc0201b46:	8082                	ret
        intr_disable();
ffffffffc0201b48:	d2dfe0ef          	jal	ffffffffc0200874 <intr_disable>
			cur = slobfree;
ffffffffc0201b4c:	6098                	ld	a4,0(s1)
        return 1;
ffffffffc0201b4e:	4585                	li	a1,1
ffffffffc0201b50:	b7e9                	j	ffffffffc0201b1a <slob_alloc.constprop.0+0x64>
        intr_enable();
ffffffffc0201b52:	d1dfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201b56:	b76d                	j	ffffffffc0201b00 <slob_alloc.constprop.0+0x4a>
ffffffffc0201b58:	e43e                	sd	a5,8(sp)
ffffffffc0201b5a:	d15fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201b5e:	67a2                	ld	a5,8(sp)
}
ffffffffc0201b60:	70a2                	ld	ra,40(sp)
ffffffffc0201b62:	7402                	ld	s0,32(sp)
ffffffffc0201b64:	64e2                	ld	s1,24(sp)
ffffffffc0201b66:	853e                	mv	a0,a5
ffffffffc0201b68:	6145                	addi	sp,sp,48
ffffffffc0201b6a:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201b6c:	6794                	ld	a3,8(a5)
ffffffffc0201b6e:	e714                	sd	a3,8(a4)
ffffffffc0201b70:	b7e1                	j	ffffffffc0201b38 <slob_alloc.constprop.0+0x82>
        intr_disable();
ffffffffc0201b72:	d03fe0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0201b76:	4585                	li	a1,1
ffffffffc0201b78:	b785                	j	ffffffffc0201ad8 <slob_alloc.constprop.0+0x22>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201b7a:	87ba                	mv	a5,a4
	prev = slobfree;
ffffffffc0201b7c:	8732                	mv	a4,a2
ffffffffc0201b7e:	b755                	j	ffffffffc0201b22 <slob_alloc.constprop.0+0x6c>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201b80:	00003697          	auipc	a3,0x3
ffffffffc0201b84:	2c068693          	addi	a3,a3,704 # ffffffffc0204e40 <etext+0xec0>
ffffffffc0201b88:	00003617          	auipc	a2,0x3
ffffffffc0201b8c:	ed060613          	addi	a2,a2,-304 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0201b90:	06300593          	li	a1,99
ffffffffc0201b94:	00003517          	auipc	a0,0x3
ffffffffc0201b98:	2cc50513          	addi	a0,a0,716 # ffffffffc0204e60 <etext+0xee0>
ffffffffc0201b9c:	86bfe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201ba0 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201ba0:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201ba2:	00003517          	auipc	a0,0x3
ffffffffc0201ba6:	2d650513          	addi	a0,a0,726 # ffffffffc0204e78 <etext+0xef8>
{
ffffffffc0201baa:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201bac:	de8fe0ef          	jal	ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201bb0:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bb2:	00003517          	auipc	a0,0x3
ffffffffc0201bb6:	2de50513          	addi	a0,a0,734 # ffffffffc0204e90 <etext+0xf10>
}
ffffffffc0201bba:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201bbc:	dd8fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201bc0 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201bc0:	1101                	addi	sp,sp,-32
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bc2:	6685                	lui	a3,0x1
{
ffffffffc0201bc4:	ec06                	sd	ra,24(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201bc6:	16bd                	addi	a3,a3,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc0201bc8:	04a6f963          	bgeu	a3,a0,ffffffffc0201c1a <kmalloc+0x5a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201bcc:	e42a                	sd	a0,8(sp)
ffffffffc0201bce:	4561                	li	a0,24
ffffffffc0201bd0:	e822                	sd	s0,16(sp)
ffffffffc0201bd2:	ee5ff0ef          	jal	ffffffffc0201ab6 <slob_alloc.constprop.0>
ffffffffc0201bd6:	842a                	mv	s0,a0
	if (!bb)
ffffffffc0201bd8:	c541                	beqz	a0,ffffffffc0201c60 <kmalloc+0xa0>
	bb->order = find_order(size);
ffffffffc0201bda:	47a2                	lw	a5,8(sp)
	for (; size > 4096; size >>= 1)
ffffffffc0201bdc:	6705                	lui	a4,0x1
	int order = 0;
ffffffffc0201bde:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201be0:	00f75763          	bge	a4,a5,ffffffffc0201bee <kmalloc+0x2e>
ffffffffc0201be4:	4017d79b          	sraiw	a5,a5,0x1
		order++;
ffffffffc0201be8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201bea:	fef74de3          	blt	a4,a5,ffffffffc0201be4 <kmalloc+0x24>
	bb->order = find_order(size);
ffffffffc0201bee:	c008                	sw	a0,0(s0)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201bf0:	e63ff0ef          	jal	ffffffffc0201a52 <__slob_get_free_pages.constprop.0>
ffffffffc0201bf4:	e408                	sd	a0,8(s0)
	if (bb->pages)
ffffffffc0201bf6:	cd31                	beqz	a0,ffffffffc0201c52 <kmalloc+0x92>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201bf8:	100027f3          	csrr	a5,sstatus
ffffffffc0201bfc:	8b89                	andi	a5,a5,2
ffffffffc0201bfe:	eb85                	bnez	a5,ffffffffc0201c2e <kmalloc+0x6e>
		bb->next = bigblocks;
ffffffffc0201c00:	0000c797          	auipc	a5,0xc
ffffffffc0201c04:	8987b783          	ld	a5,-1896(a5) # ffffffffc020d498 <bigblocks>
		bigblocks = bb;
ffffffffc0201c08:	0000c717          	auipc	a4,0xc
ffffffffc0201c0c:	88873823          	sd	s0,-1904(a4) # ffffffffc020d498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201c10:	e81c                	sd	a5,16(s0)
    if (flag) {
ffffffffc0201c12:	6442                	ld	s0,16(sp)
	return __kmalloc(size, 0);
}
ffffffffc0201c14:	60e2                	ld	ra,24(sp)
ffffffffc0201c16:	6105                	addi	sp,sp,32
ffffffffc0201c18:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201c1a:	0541                	addi	a0,a0,16
ffffffffc0201c1c:	e9bff0ef          	jal	ffffffffc0201ab6 <slob_alloc.constprop.0>
ffffffffc0201c20:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201c22:	0541                	addi	a0,a0,16
ffffffffc0201c24:	fbe5                	bnez	a5,ffffffffc0201c14 <kmalloc+0x54>
		return 0;
ffffffffc0201c26:	4501                	li	a0,0
}
ffffffffc0201c28:	60e2                	ld	ra,24(sp)
ffffffffc0201c2a:	6105                	addi	sp,sp,32
ffffffffc0201c2c:	8082                	ret
        intr_disable();
ffffffffc0201c2e:	c47fe0ef          	jal	ffffffffc0200874 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201c32:	0000c797          	auipc	a5,0xc
ffffffffc0201c36:	8667b783          	ld	a5,-1946(a5) # ffffffffc020d498 <bigblocks>
		bigblocks = bb;
ffffffffc0201c3a:	0000c717          	auipc	a4,0xc
ffffffffc0201c3e:	84873f23          	sd	s0,-1954(a4) # ffffffffc020d498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0201c42:	e81c                	sd	a5,16(s0)
        intr_enable();
ffffffffc0201c44:	c2bfe0ef          	jal	ffffffffc020086e <intr_enable>
		return bb->pages;
ffffffffc0201c48:	6408                	ld	a0,8(s0)
}
ffffffffc0201c4a:	60e2                	ld	ra,24(sp)
		return bb->pages;
ffffffffc0201c4c:	6442                	ld	s0,16(sp)
}
ffffffffc0201c4e:	6105                	addi	sp,sp,32
ffffffffc0201c50:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c52:	8522                	mv	a0,s0
ffffffffc0201c54:	45e1                	li	a1,24
ffffffffc0201c56:	cebff0ef          	jal	ffffffffc0201940 <slob_free>
		return 0;
ffffffffc0201c5a:	4501                	li	a0,0
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201c5c:	6442                	ld	s0,16(sp)
ffffffffc0201c5e:	b7e9                	j	ffffffffc0201c28 <kmalloc+0x68>
ffffffffc0201c60:	6442                	ld	s0,16(sp)
		return 0;
ffffffffc0201c62:	4501                	li	a0,0
ffffffffc0201c64:	b7d1                	j	ffffffffc0201c28 <kmalloc+0x68>

ffffffffc0201c66 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201c66:	c571                	beqz	a0,ffffffffc0201d32 <kfree+0xcc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201c68:	03451793          	slli	a5,a0,0x34
ffffffffc0201c6c:	e3e1                	bnez	a5,ffffffffc0201d2c <kfree+0xc6>
{
ffffffffc0201c6e:	1101                	addi	sp,sp,-32
ffffffffc0201c70:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c72:	100027f3          	csrr	a5,sstatus
ffffffffc0201c76:	8b89                	andi	a5,a5,2
ffffffffc0201c78:	e7c1                	bnez	a5,ffffffffc0201d00 <kfree+0x9a>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c7a:	0000c797          	auipc	a5,0xc
ffffffffc0201c7e:	81e7b783          	ld	a5,-2018(a5) # ffffffffc020d498 <bigblocks>
    return 0;
ffffffffc0201c82:	4581                	li	a1,0
ffffffffc0201c84:	cbad                	beqz	a5,ffffffffc0201cf6 <kfree+0x90>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201c86:	0000c617          	auipc	a2,0xc
ffffffffc0201c8a:	81260613          	addi	a2,a2,-2030 # ffffffffc020d498 <bigblocks>
ffffffffc0201c8e:	a021                	j	ffffffffc0201c96 <kfree+0x30>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c90:	01070613          	addi	a2,a4,16
ffffffffc0201c94:	c3a5                	beqz	a5,ffffffffc0201cf4 <kfree+0x8e>
		{
			if (bb->pages == block)
ffffffffc0201c96:	6794                	ld	a3,8(a5)
ffffffffc0201c98:	873e                	mv	a4,a5
			{
				*last = bb->next;
ffffffffc0201c9a:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201c9c:	fea69ae3          	bne	a3,a0,ffffffffc0201c90 <kfree+0x2a>
				*last = bb->next;
ffffffffc0201ca0:	e21c                	sd	a5,0(a2)
    if (flag) {
ffffffffc0201ca2:	edb5                	bnez	a1,ffffffffc0201d1e <kfree+0xb8>
    return pa2page(PADDR(kva));
ffffffffc0201ca4:	c02007b7          	lui	a5,0xc0200
ffffffffc0201ca8:	0af56263          	bltu	a0,a5,ffffffffc0201d4c <kfree+0xe6>
ffffffffc0201cac:	0000c797          	auipc	a5,0xc
ffffffffc0201cb0:	80c7b783          	ld	a5,-2036(a5) # ffffffffc020d4b8 <va_pa_offset>
    if (PPN(pa) >= npage)
ffffffffc0201cb4:	0000c697          	auipc	a3,0xc
ffffffffc0201cb8:	80c6b683          	ld	a3,-2036(a3) # ffffffffc020d4c0 <npage>
    return pa2page(PADDR(kva));
ffffffffc0201cbc:	8d1d                	sub	a0,a0,a5
    if (PPN(pa) >= npage)
ffffffffc0201cbe:	00c55793          	srli	a5,a0,0xc
ffffffffc0201cc2:	06d7f963          	bgeu	a5,a3,ffffffffc0201d34 <kfree+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0201cc6:	00004617          	auipc	a2,0x4
ffffffffc0201cca:	f1263603          	ld	a2,-238(a2) # ffffffffc0205bd8 <nbase>
ffffffffc0201cce:	0000b517          	auipc	a0,0xb
ffffffffc0201cd2:	7fa53503          	ld	a0,2042(a0) # ffffffffc020d4c8 <pages>
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201cd6:	4314                	lw	a3,0(a4)
ffffffffc0201cd8:	8f91                	sub	a5,a5,a2
ffffffffc0201cda:	079a                	slli	a5,a5,0x6
ffffffffc0201cdc:	4585                	li	a1,1
ffffffffc0201cde:	953e                	add	a0,a0,a5
ffffffffc0201ce0:	00d595bb          	sllw	a1,a1,a3
ffffffffc0201ce4:	e03a                	sd	a4,0(sp)
ffffffffc0201ce6:	0d6000ef          	jal	ffffffffc0201dbc <free_pages>
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201cea:	6502                	ld	a0,0(sp)
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201cec:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201cee:	45e1                	li	a1,24
}
ffffffffc0201cf0:	6105                	addi	sp,sp,32
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201cf2:	b1b9                	j	ffffffffc0201940 <slob_free>
ffffffffc0201cf4:	e185                	bnez	a1,ffffffffc0201d14 <kfree+0xae>
}
ffffffffc0201cf6:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cf8:	1541                	addi	a0,a0,-16
ffffffffc0201cfa:	4581                	li	a1,0
}
ffffffffc0201cfc:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201cfe:	b189                	j	ffffffffc0201940 <slob_free>
        intr_disable();
ffffffffc0201d00:	e02a                	sd	a0,0(sp)
ffffffffc0201d02:	b73fe0ef          	jal	ffffffffc0200874 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d06:	0000b797          	auipc	a5,0xb
ffffffffc0201d0a:	7927b783          	ld	a5,1938(a5) # ffffffffc020d498 <bigblocks>
ffffffffc0201d0e:	6502                	ld	a0,0(sp)
        return 1;
ffffffffc0201d10:	4585                	li	a1,1
ffffffffc0201d12:	fbb5                	bnez	a5,ffffffffc0201c86 <kfree+0x20>
ffffffffc0201d14:	e02a                	sd	a0,0(sp)
        intr_enable();
ffffffffc0201d16:	b59fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201d1a:	6502                	ld	a0,0(sp)
ffffffffc0201d1c:	bfe9                	j	ffffffffc0201cf6 <kfree+0x90>
ffffffffc0201d1e:	e42a                	sd	a0,8(sp)
ffffffffc0201d20:	e03a                	sd	a4,0(sp)
ffffffffc0201d22:	b4dfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201d26:	6522                	ld	a0,8(sp)
ffffffffc0201d28:	6702                	ld	a4,0(sp)
ffffffffc0201d2a:	bfad                	j	ffffffffc0201ca4 <kfree+0x3e>
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201d2c:	1541                	addi	a0,a0,-16
ffffffffc0201d2e:	4581                	li	a1,0
ffffffffc0201d30:	b901                	j	ffffffffc0201940 <slob_free>
ffffffffc0201d32:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201d34:	00003617          	auipc	a2,0x3
ffffffffc0201d38:	1a460613          	addi	a2,a2,420 # ffffffffc0204ed8 <etext+0xf58>
ffffffffc0201d3c:	06900593          	li	a1,105
ffffffffc0201d40:	00003517          	auipc	a0,0x3
ffffffffc0201d44:	0f050513          	addi	a0,a0,240 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc0201d48:	ebefe0ef          	jal	ffffffffc0200406 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201d4c:	86aa                	mv	a3,a0
ffffffffc0201d4e:	00003617          	auipc	a2,0x3
ffffffffc0201d52:	16260613          	addi	a2,a2,354 # ffffffffc0204eb0 <etext+0xf30>
ffffffffc0201d56:	07700593          	li	a1,119
ffffffffc0201d5a:	00003517          	auipc	a0,0x3
ffffffffc0201d5e:	0d650513          	addi	a0,a0,214 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc0201d62:	ea4fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201d66 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201d66:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201d68:	00003617          	auipc	a2,0x3
ffffffffc0201d6c:	17060613          	addi	a2,a2,368 # ffffffffc0204ed8 <etext+0xf58>
ffffffffc0201d70:	06900593          	li	a1,105
ffffffffc0201d74:	00003517          	auipc	a0,0x3
ffffffffc0201d78:	0bc50513          	addi	a0,a0,188 # ffffffffc0204e30 <etext+0xeb0>
pa2page(uintptr_t pa)
ffffffffc0201d7c:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201d7e:	e88fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0201d82 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d82:	100027f3          	csrr	a5,sstatus
ffffffffc0201d86:	8b89                	andi	a5,a5,2
ffffffffc0201d88:	e799                	bnez	a5,ffffffffc0201d96 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d8a:	0000b797          	auipc	a5,0xb
ffffffffc0201d8e:	7167b783          	ld	a5,1814(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201d92:	6f9c                	ld	a5,24(a5)
ffffffffc0201d94:	8782                	jr	a5
{
ffffffffc0201d96:	1101                	addi	sp,sp,-32
ffffffffc0201d98:	ec06                	sd	ra,24(sp)
ffffffffc0201d9a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201d9c:	ad9fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201da0:	0000b797          	auipc	a5,0xb
ffffffffc0201da4:	7007b783          	ld	a5,1792(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201da8:	6522                	ld	a0,8(sp)
ffffffffc0201daa:	6f9c                	ld	a5,24(a5)
ffffffffc0201dac:	9782                	jalr	a5
ffffffffc0201dae:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201db0:	abffe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201db4:	60e2                	ld	ra,24(sp)
ffffffffc0201db6:	6522                	ld	a0,8(sp)
ffffffffc0201db8:	6105                	addi	sp,sp,32
ffffffffc0201dba:	8082                	ret

ffffffffc0201dbc <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201dbc:	100027f3          	csrr	a5,sstatus
ffffffffc0201dc0:	8b89                	andi	a5,a5,2
ffffffffc0201dc2:	e799                	bnez	a5,ffffffffc0201dd0 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201dc4:	0000b797          	auipc	a5,0xb
ffffffffc0201dc8:	6dc7b783          	ld	a5,1756(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201dcc:	739c                	ld	a5,32(a5)
ffffffffc0201dce:	8782                	jr	a5
{
ffffffffc0201dd0:	1101                	addi	sp,sp,-32
ffffffffc0201dd2:	ec06                	sd	ra,24(sp)
ffffffffc0201dd4:	e42e                	sd	a1,8(sp)
ffffffffc0201dd6:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201dd8:	a9dfe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201ddc:	0000b797          	auipc	a5,0xb
ffffffffc0201de0:	6c47b783          	ld	a5,1732(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201de4:	65a2                	ld	a1,8(sp)
ffffffffc0201de6:	6502                	ld	a0,0(sp)
ffffffffc0201de8:	739c                	ld	a5,32(a5)
ffffffffc0201dea:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201dec:	60e2                	ld	ra,24(sp)
ffffffffc0201dee:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201df0:	a7ffe06f          	j	ffffffffc020086e <intr_enable>

ffffffffc0201df4 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201df4:	100027f3          	csrr	a5,sstatus
ffffffffc0201df8:	8b89                	andi	a5,a5,2
ffffffffc0201dfa:	e799                	bnez	a5,ffffffffc0201e08 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201dfc:	0000b797          	auipc	a5,0xb
ffffffffc0201e00:	6a47b783          	ld	a5,1700(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201e04:	779c                	ld	a5,40(a5)
ffffffffc0201e06:	8782                	jr	a5
{
ffffffffc0201e08:	1101                	addi	sp,sp,-32
ffffffffc0201e0a:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0201e0c:	a69fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e10:	0000b797          	auipc	a5,0xb
ffffffffc0201e14:	6907b783          	ld	a5,1680(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201e18:	779c                	ld	a5,40(a5)
ffffffffc0201e1a:	9782                	jalr	a5
ffffffffc0201e1c:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201e1e:	a51fe0ef          	jal	ffffffffc020086e <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201e22:	60e2                	ld	ra,24(sp)
ffffffffc0201e24:	6522                	ld	a0,8(sp)
ffffffffc0201e26:	6105                	addi	sp,sp,32
ffffffffc0201e28:	8082                	ret

ffffffffc0201e2a <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e2a:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e2e:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e32:	078e                	slli	a5,a5,0x3
ffffffffc0201e34:	00f50733          	add	a4,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201e38:	6314                	ld	a3,0(a4)
{
ffffffffc0201e3a:	7139                	addi	sp,sp,-64
ffffffffc0201e3c:	f822                	sd	s0,48(sp)
ffffffffc0201e3e:	f426                	sd	s1,40(sp)
ffffffffc0201e40:	fc06                	sd	ra,56(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201e42:	0016f793          	andi	a5,a3,1
{
ffffffffc0201e46:	842e                	mv	s0,a1
ffffffffc0201e48:	8832                	mv	a6,a2
ffffffffc0201e4a:	0000b497          	auipc	s1,0xb
ffffffffc0201e4e:	67648493          	addi	s1,s1,1654 # ffffffffc020d4c0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201e52:	ebd1                	bnez	a5,ffffffffc0201ee6 <get_pte+0xbc>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e54:	16060d63          	beqz	a2,ffffffffc0201fce <get_pte+0x1a4>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201e58:	100027f3          	csrr	a5,sstatus
ffffffffc0201e5c:	8b89                	andi	a5,a5,2
ffffffffc0201e5e:	16079e63          	bnez	a5,ffffffffc0201fda <get_pte+0x1b0>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e62:	0000b797          	auipc	a5,0xb
ffffffffc0201e66:	63e7b783          	ld	a5,1598(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201e6a:	4505                	li	a0,1
ffffffffc0201e6c:	e43a                	sd	a4,8(sp)
ffffffffc0201e6e:	6f9c                	ld	a5,24(a5)
ffffffffc0201e70:	e832                	sd	a2,16(sp)
ffffffffc0201e72:	9782                	jalr	a5
ffffffffc0201e74:	6722                	ld	a4,8(sp)
ffffffffc0201e76:	6842                	ld	a6,16(sp)
ffffffffc0201e78:	87aa                	mv	a5,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e7a:	14078a63          	beqz	a5,ffffffffc0201fce <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201e7e:	0000b517          	auipc	a0,0xb
ffffffffc0201e82:	64a53503          	ld	a0,1610(a0) # ffffffffc020d4c8 <pages>
ffffffffc0201e86:	000808b7          	lui	a7,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e8a:	0000b497          	auipc	s1,0xb
ffffffffc0201e8e:	63648493          	addi	s1,s1,1590 # ffffffffc020d4c0 <npage>
ffffffffc0201e92:	40a78533          	sub	a0,a5,a0
ffffffffc0201e96:	8519                	srai	a0,a0,0x6
ffffffffc0201e98:	9546                	add	a0,a0,a7
ffffffffc0201e9a:	6090                	ld	a2,0(s1)
ffffffffc0201e9c:	00c51693          	slli	a3,a0,0xc
    page->ref = val;
ffffffffc0201ea0:	4585                	li	a1,1
ffffffffc0201ea2:	82b1                	srli	a3,a3,0xc
ffffffffc0201ea4:	c38c                	sw	a1,0(a5)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ea6:	0532                	slli	a0,a0,0xc
ffffffffc0201ea8:	1ac6f763          	bgeu	a3,a2,ffffffffc0202056 <get_pte+0x22c>
ffffffffc0201eac:	0000b697          	auipc	a3,0xb
ffffffffc0201eb0:	60c6b683          	ld	a3,1548(a3) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201eb4:	6605                	lui	a2,0x1
ffffffffc0201eb6:	4581                	li	a1,0
ffffffffc0201eb8:	9536                	add	a0,a0,a3
ffffffffc0201eba:	ec42                	sd	a6,24(sp)
ffffffffc0201ebc:	e83e                	sd	a5,16(sp)
ffffffffc0201ebe:	e43a                	sd	a4,8(sp)
ffffffffc0201ec0:	072020ef          	jal	ffffffffc0203f32 <memset>
    return page - pages + nbase;
ffffffffc0201ec4:	0000b697          	auipc	a3,0xb
ffffffffc0201ec8:	6046b683          	ld	a3,1540(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201ecc:	67c2                	ld	a5,16(sp)
ffffffffc0201ece:	000808b7          	lui	a7,0x80
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201ed2:	6722                	ld	a4,8(sp)
ffffffffc0201ed4:	40d786b3          	sub	a3,a5,a3
ffffffffc0201ed8:	8699                	srai	a3,a3,0x6
ffffffffc0201eda:	96c6                	add	a3,a3,a7
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201edc:	06aa                	slli	a3,a3,0xa
ffffffffc0201ede:	6862                	ld	a6,24(sp)
ffffffffc0201ee0:	0116e693          	ori	a3,a3,17
ffffffffc0201ee4:	e314                	sd	a3,0(a4)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201ee6:	c006f693          	andi	a3,a3,-1024
ffffffffc0201eea:	6098                	ld	a4,0(s1)
ffffffffc0201eec:	068a                	slli	a3,a3,0x2
ffffffffc0201eee:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ef2:	14e7f663          	bgeu	a5,a4,ffffffffc020203e <get_pte+0x214>
ffffffffc0201ef6:	0000b897          	auipc	a7,0xb
ffffffffc0201efa:	5c288893          	addi	a7,a7,1474 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201efe:	0008b603          	ld	a2,0(a7)
ffffffffc0201f02:	01545793          	srli	a5,s0,0x15
ffffffffc0201f06:	1ff7f793          	andi	a5,a5,511
ffffffffc0201f0a:	96b2                	add	a3,a3,a2
ffffffffc0201f0c:	078e                	slli	a5,a5,0x3
ffffffffc0201f0e:	97b6                	add	a5,a5,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201f10:	6394                	ld	a3,0(a5)
ffffffffc0201f12:	0016f613          	andi	a2,a3,1
ffffffffc0201f16:	e659                	bnez	a2,ffffffffc0201fa4 <get_pte+0x17a>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f18:	0a080b63          	beqz	a6,ffffffffc0201fce <get_pte+0x1a4>
ffffffffc0201f1c:	10002773          	csrr	a4,sstatus
ffffffffc0201f20:	8b09                	andi	a4,a4,2
ffffffffc0201f22:	ef71                	bnez	a4,ffffffffc0201ffe <get_pte+0x1d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f24:	0000b717          	auipc	a4,0xb
ffffffffc0201f28:	57c73703          	ld	a4,1404(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201f2c:	4505                	li	a0,1
ffffffffc0201f2e:	e43e                	sd	a5,8(sp)
ffffffffc0201f30:	6f18                	ld	a4,24(a4)
ffffffffc0201f32:	9702                	jalr	a4
ffffffffc0201f34:	67a2                	ld	a5,8(sp)
ffffffffc0201f36:	872a                	mv	a4,a0
ffffffffc0201f38:	0000b897          	auipc	a7,0xb
ffffffffc0201f3c:	58088893          	addi	a7,a7,1408 # ffffffffc020d4b8 <va_pa_offset>
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f40:	c759                	beqz	a4,ffffffffc0201fce <get_pte+0x1a4>
    return page - pages + nbase;
ffffffffc0201f42:	0000b697          	auipc	a3,0xb
ffffffffc0201f46:	5866b683          	ld	a3,1414(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201f4a:	00080837          	lui	a6,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f4e:	608c                	ld	a1,0(s1)
ffffffffc0201f50:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f54:	8699                	srai	a3,a3,0x6
ffffffffc0201f56:	96c2                	add	a3,a3,a6
ffffffffc0201f58:	00c69613          	slli	a2,a3,0xc
    page->ref = val;
ffffffffc0201f5c:	4505                	li	a0,1
ffffffffc0201f5e:	8231                	srli	a2,a2,0xc
ffffffffc0201f60:	c308                	sw	a0,0(a4)
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f62:	06b2                	slli	a3,a3,0xc
ffffffffc0201f64:	10b67663          	bgeu	a2,a1,ffffffffc0202070 <get_pte+0x246>
ffffffffc0201f68:	0008b503          	ld	a0,0(a7)
ffffffffc0201f6c:	6605                	lui	a2,0x1
ffffffffc0201f6e:	4581                	li	a1,0
ffffffffc0201f70:	9536                	add	a0,a0,a3
ffffffffc0201f72:	e83a                	sd	a4,16(sp)
ffffffffc0201f74:	e43e                	sd	a5,8(sp)
ffffffffc0201f76:	7bd010ef          	jal	ffffffffc0203f32 <memset>
    return page - pages + nbase;
ffffffffc0201f7a:	0000b697          	auipc	a3,0xb
ffffffffc0201f7e:	54e6b683          	ld	a3,1358(a3) # ffffffffc020d4c8 <pages>
ffffffffc0201f82:	6742                	ld	a4,16(sp)
ffffffffc0201f84:	00080837          	lui	a6,0x80
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f88:	67a2                	ld	a5,8(sp)
ffffffffc0201f8a:	40d706b3          	sub	a3,a4,a3
ffffffffc0201f8e:	8699                	srai	a3,a3,0x6
ffffffffc0201f90:	96c2                	add	a3,a3,a6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f92:	06aa                	slli	a3,a3,0xa
ffffffffc0201f94:	0116e693          	ori	a3,a3,17
ffffffffc0201f98:	e394                	sd	a3,0(a5)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f9a:	6098                	ld	a4,0(s1)
ffffffffc0201f9c:	0000b897          	auipc	a7,0xb
ffffffffc0201fa0:	51c88893          	addi	a7,a7,1308 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0201fa4:	c006f693          	andi	a3,a3,-1024
ffffffffc0201fa8:	068a                	slli	a3,a3,0x2
ffffffffc0201faa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201fae:	06e7fc63          	bgeu	a5,a4,ffffffffc0202026 <get_pte+0x1fc>
ffffffffc0201fb2:	0008b783          	ld	a5,0(a7)
ffffffffc0201fb6:	8031                	srli	s0,s0,0xc
ffffffffc0201fb8:	1ff47413          	andi	s0,s0,511
ffffffffc0201fbc:	040e                	slli	s0,s0,0x3
ffffffffc0201fbe:	96be                	add	a3,a3,a5
}
ffffffffc0201fc0:	70e2                	ld	ra,56(sp)
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201fc2:	00868533          	add	a0,a3,s0
}
ffffffffc0201fc6:	7442                	ld	s0,48(sp)
ffffffffc0201fc8:	74a2                	ld	s1,40(sp)
ffffffffc0201fca:	6121                	addi	sp,sp,64
ffffffffc0201fcc:	8082                	ret
ffffffffc0201fce:	70e2                	ld	ra,56(sp)
ffffffffc0201fd0:	7442                	ld	s0,48(sp)
ffffffffc0201fd2:	74a2                	ld	s1,40(sp)
            return NULL;
ffffffffc0201fd4:	4501                	li	a0,0
}
ffffffffc0201fd6:	6121                	addi	sp,sp,64
ffffffffc0201fd8:	8082                	ret
        intr_disable();
ffffffffc0201fda:	e83a                	sd	a4,16(sp)
ffffffffc0201fdc:	ec32                	sd	a2,24(sp)
ffffffffc0201fde:	897fe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201fe2:	0000b797          	auipc	a5,0xb
ffffffffc0201fe6:	4be7b783          	ld	a5,1214(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0201fea:	4505                	li	a0,1
ffffffffc0201fec:	6f9c                	ld	a5,24(a5)
ffffffffc0201fee:	9782                	jalr	a5
ffffffffc0201ff0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0201ff2:	87dfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0201ff6:	6862                	ld	a6,24(sp)
ffffffffc0201ff8:	6742                	ld	a4,16(sp)
ffffffffc0201ffa:	67a2                	ld	a5,8(sp)
ffffffffc0201ffc:	bdbd                	j	ffffffffc0201e7a <get_pte+0x50>
        intr_disable();
ffffffffc0201ffe:	e83e                	sd	a5,16(sp)
ffffffffc0202000:	875fe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202004:	0000b717          	auipc	a4,0xb
ffffffffc0202008:	49c73703          	ld	a4,1180(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc020200c:	4505                	li	a0,1
ffffffffc020200e:	6f18                	ld	a4,24(a4)
ffffffffc0202010:	9702                	jalr	a4
ffffffffc0202012:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0202014:	85bfe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202018:	6722                	ld	a4,8(sp)
ffffffffc020201a:	67c2                	ld	a5,16(sp)
ffffffffc020201c:	0000b897          	auipc	a7,0xb
ffffffffc0202020:	49c88893          	addi	a7,a7,1180 # ffffffffc020d4b8 <va_pa_offset>
ffffffffc0202024:	bf31                	j	ffffffffc0201f40 <get_pte+0x116>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202026:	00003617          	auipc	a2,0x3
ffffffffc020202a:	de260613          	addi	a2,a2,-542 # ffffffffc0204e08 <etext+0xe88>
ffffffffc020202e:	0fb00593          	li	a1,251
ffffffffc0202032:	00003517          	auipc	a0,0x3
ffffffffc0202036:	ec650513          	addi	a0,a0,-314 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc020203a:	bccfe0ef          	jal	ffffffffc0200406 <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020203e:	00003617          	auipc	a2,0x3
ffffffffc0202042:	dca60613          	addi	a2,a2,-566 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202046:	0ee00593          	li	a1,238
ffffffffc020204a:	00003517          	auipc	a0,0x3
ffffffffc020204e:	eae50513          	addi	a0,a0,-338 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202052:	bb4fe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202056:	86aa                	mv	a3,a0
ffffffffc0202058:	00003617          	auipc	a2,0x3
ffffffffc020205c:	db060613          	addi	a2,a2,-592 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202060:	0eb00593          	li	a1,235
ffffffffc0202064:	00003517          	auipc	a0,0x3
ffffffffc0202068:	e9450513          	addi	a0,a0,-364 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc020206c:	b9afe0ef          	jal	ffffffffc0200406 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202070:	00003617          	auipc	a2,0x3
ffffffffc0202074:	d9860613          	addi	a2,a2,-616 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202078:	0f800593          	li	a1,248
ffffffffc020207c:	00003517          	auipc	a0,0x3
ffffffffc0202080:	e7c50513          	addi	a0,a0,-388 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202084:	b82fe0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202088 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202088:	1141                	addi	sp,sp,-16
ffffffffc020208a:	e022                	sd	s0,0(sp)
ffffffffc020208c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020208e:	4601                	li	a2,0
{
ffffffffc0202090:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202092:	d99ff0ef          	jal	ffffffffc0201e2a <get_pte>
    if (ptep_store != NULL)
ffffffffc0202096:	c011                	beqz	s0,ffffffffc020209a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202098:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020209a:	c511                	beqz	a0,ffffffffc02020a6 <get_page+0x1e>
ffffffffc020209c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020209e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02020a0:	0017f713          	andi	a4,a5,1
ffffffffc02020a4:	e709                	bnez	a4,ffffffffc02020ae <get_page+0x26>
}
ffffffffc02020a6:	60a2                	ld	ra,8(sp)
ffffffffc02020a8:	6402                	ld	s0,0(sp)
ffffffffc02020aa:	0141                	addi	sp,sp,16
ffffffffc02020ac:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02020ae:	0000b717          	auipc	a4,0xb
ffffffffc02020b2:	41273703          	ld	a4,1042(a4) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02020b6:	078a                	slli	a5,a5,0x2
ffffffffc02020b8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020ba:	00e7ff63          	bgeu	a5,a4,ffffffffc02020d8 <get_page+0x50>
    return &pages[PPN(pa) - nbase];
ffffffffc02020be:	0000b517          	auipc	a0,0xb
ffffffffc02020c2:	40a53503          	ld	a0,1034(a0) # ffffffffc020d4c8 <pages>
ffffffffc02020c6:	60a2                	ld	ra,8(sp)
ffffffffc02020c8:	6402                	ld	s0,0(sp)
ffffffffc02020ca:	079a                	slli	a5,a5,0x6
ffffffffc02020cc:	fe000737          	lui	a4,0xfe000
ffffffffc02020d0:	97ba                	add	a5,a5,a4
ffffffffc02020d2:	953e                	add	a0,a0,a5
ffffffffc02020d4:	0141                	addi	sp,sp,16
ffffffffc02020d6:	8082                	ret
ffffffffc02020d8:	c8fff0ef          	jal	ffffffffc0201d66 <pa2page.part.0>

ffffffffc02020dc <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc02020dc:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020de:	4601                	li	a2,0
{
ffffffffc02020e0:	e822                	sd	s0,16(sp)
ffffffffc02020e2:	ec06                	sd	ra,24(sp)
ffffffffc02020e4:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02020e6:	d45ff0ef          	jal	ffffffffc0201e2a <get_pte>
    if (ptep != NULL)
ffffffffc02020ea:	c511                	beqz	a0,ffffffffc02020f6 <page_remove+0x1a>
    if (*ptep & PTE_V)
ffffffffc02020ec:	6118                	ld	a4,0(a0)
ffffffffc02020ee:	87aa                	mv	a5,a0
ffffffffc02020f0:	00177693          	andi	a3,a4,1
ffffffffc02020f4:	e689                	bnez	a3,ffffffffc02020fe <page_remove+0x22>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc02020f6:	60e2                	ld	ra,24(sp)
ffffffffc02020f8:	6442                	ld	s0,16(sp)
ffffffffc02020fa:	6105                	addi	sp,sp,32
ffffffffc02020fc:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02020fe:	0000b697          	auipc	a3,0xb
ffffffffc0202102:	3c26b683          	ld	a3,962(a3) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc0202106:	070a                	slli	a4,a4,0x2
ffffffffc0202108:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc020210a:	06d77563          	bgeu	a4,a3,ffffffffc0202174 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020210e:	0000b517          	auipc	a0,0xb
ffffffffc0202112:	3ba53503          	ld	a0,954(a0) # ffffffffc020d4c8 <pages>
ffffffffc0202116:	071a                	slli	a4,a4,0x6
ffffffffc0202118:	fe0006b7          	lui	a3,0xfe000
ffffffffc020211c:	9736                	add	a4,a4,a3
ffffffffc020211e:	953a                	add	a0,a0,a4
    page->ref -= 1;
ffffffffc0202120:	4118                	lw	a4,0(a0)
ffffffffc0202122:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3ddf2b0f>
ffffffffc0202124:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202126:	cb09                	beqz	a4,ffffffffc0202138 <page_remove+0x5c>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc0202128:	0007b023          	sd	zero,0(a5)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020212c:	12040073          	sfence.vma	s0
}
ffffffffc0202130:	60e2                	ld	ra,24(sp)
ffffffffc0202132:	6442                	ld	s0,16(sp)
ffffffffc0202134:	6105                	addi	sp,sp,32
ffffffffc0202136:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202138:	10002773          	csrr	a4,sstatus
ffffffffc020213c:	8b09                	andi	a4,a4,2
ffffffffc020213e:	eb19                	bnez	a4,ffffffffc0202154 <page_remove+0x78>
        pmm_manager->free_pages(base, n);
ffffffffc0202140:	0000b717          	auipc	a4,0xb
ffffffffc0202144:	36073703          	ld	a4,864(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202148:	4585                	li	a1,1
ffffffffc020214a:	e03e                	sd	a5,0(sp)
ffffffffc020214c:	7318                	ld	a4,32(a4)
ffffffffc020214e:	9702                	jalr	a4
    if (flag) {
ffffffffc0202150:	6782                	ld	a5,0(sp)
ffffffffc0202152:	bfd9                	j	ffffffffc0202128 <page_remove+0x4c>
        intr_disable();
ffffffffc0202154:	e43e                	sd	a5,8(sp)
ffffffffc0202156:	e02a                	sd	a0,0(sp)
ffffffffc0202158:	f1cfe0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020215c:	0000b717          	auipc	a4,0xb
ffffffffc0202160:	34473703          	ld	a4,836(a4) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202164:	6502                	ld	a0,0(sp)
ffffffffc0202166:	4585                	li	a1,1
ffffffffc0202168:	7318                	ld	a4,32(a4)
ffffffffc020216a:	9702                	jalr	a4
        intr_enable();
ffffffffc020216c:	f02fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202170:	67a2                	ld	a5,8(sp)
ffffffffc0202172:	bf5d                	j	ffffffffc0202128 <page_remove+0x4c>
ffffffffc0202174:	bf3ff0ef          	jal	ffffffffc0201d66 <pa2page.part.0>

ffffffffc0202178 <page_insert>:
{
ffffffffc0202178:	7139                	addi	sp,sp,-64
ffffffffc020217a:	f426                	sd	s1,40(sp)
ffffffffc020217c:	84b2                	mv	s1,a2
ffffffffc020217e:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202180:	4605                	li	a2,1
{
ffffffffc0202182:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202184:	85a6                	mv	a1,s1
{
ffffffffc0202186:	fc06                	sd	ra,56(sp)
ffffffffc0202188:	e436                	sd	a3,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020218a:	ca1ff0ef          	jal	ffffffffc0201e2a <get_pte>
    if (ptep == NULL)
ffffffffc020218e:	cd61                	beqz	a0,ffffffffc0202266 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202190:	400c                	lw	a1,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202192:	611c                	ld	a5,0(a0)
ffffffffc0202194:	66a2                	ld	a3,8(sp)
ffffffffc0202196:	0015861b          	addiw	a2,a1,1 # 1001 <kern_entry-0xffffffffc01fefff>
ffffffffc020219a:	c010                	sw	a2,0(s0)
ffffffffc020219c:	0017f613          	andi	a2,a5,1
ffffffffc02021a0:	872a                	mv	a4,a0
ffffffffc02021a2:	e61d                	bnez	a2,ffffffffc02021d0 <page_insert+0x58>
    return &pages[PPN(pa) - nbase];
ffffffffc02021a4:	0000b617          	auipc	a2,0xb
ffffffffc02021a8:	32463603          	ld	a2,804(a2) # ffffffffc020d4c8 <pages>
    return page - pages + nbase;
ffffffffc02021ac:	8c11                	sub	s0,s0,a2
ffffffffc02021ae:	8419                	srai	s0,s0,0x6
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02021b0:	200007b7          	lui	a5,0x20000
ffffffffc02021b4:	042a                	slli	s0,s0,0xa
ffffffffc02021b6:	943e                	add	s0,s0,a5
ffffffffc02021b8:	8ec1                	or	a3,a3,s0
ffffffffc02021ba:	0016e693          	ori	a3,a3,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02021be:	e314                	sd	a3,0(a4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02021c0:	12048073          	sfence.vma	s1
    return 0;
ffffffffc02021c4:	4501                	li	a0,0
}
ffffffffc02021c6:	70e2                	ld	ra,56(sp)
ffffffffc02021c8:	7442                	ld	s0,48(sp)
ffffffffc02021ca:	74a2                	ld	s1,40(sp)
ffffffffc02021cc:	6121                	addi	sp,sp,64
ffffffffc02021ce:	8082                	ret
    if (PPN(pa) >= npage)
ffffffffc02021d0:	0000b617          	auipc	a2,0xb
ffffffffc02021d4:	2f063603          	ld	a2,752(a2) # ffffffffc020d4c0 <npage>
    return pa2page(PTE_ADDR(pte));
ffffffffc02021d8:	078a                	slli	a5,a5,0x2
ffffffffc02021da:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021dc:	08c7f763          	bgeu	a5,a2,ffffffffc020226a <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02021e0:	0000b617          	auipc	a2,0xb
ffffffffc02021e4:	2e863603          	ld	a2,744(a2) # ffffffffc020d4c8 <pages>
ffffffffc02021e8:	fe000537          	lui	a0,0xfe000
ffffffffc02021ec:	079a                	slli	a5,a5,0x6
ffffffffc02021ee:	97aa                	add	a5,a5,a0
ffffffffc02021f0:	00f60533          	add	a0,a2,a5
        if (p == page)
ffffffffc02021f4:	00a40963          	beq	s0,a0,ffffffffc0202206 <page_insert+0x8e>
    page->ref -= 1;
ffffffffc02021f8:	411c                	lw	a5,0(a0)
ffffffffc02021fa:	37fd                	addiw	a5,a5,-1 # 1fffffff <kern_entry-0xffffffffa0200001>
ffffffffc02021fc:	c11c                	sw	a5,0(a0)
        if (page_ref(page) ==
ffffffffc02021fe:	c791                	beqz	a5,ffffffffc020220a <page_insert+0x92>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202200:	12048073          	sfence.vma	s1
}
ffffffffc0202204:	b765                	j	ffffffffc02021ac <page_insert+0x34>
ffffffffc0202206:	c00c                	sw	a1,0(s0)
    return page->ref;
ffffffffc0202208:	b755                	j	ffffffffc02021ac <page_insert+0x34>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020220a:	100027f3          	csrr	a5,sstatus
ffffffffc020220e:	8b89                	andi	a5,a5,2
ffffffffc0202210:	e39d                	bnez	a5,ffffffffc0202236 <page_insert+0xbe>
        pmm_manager->free_pages(base, n);
ffffffffc0202212:	0000b797          	auipc	a5,0xb
ffffffffc0202216:	28e7b783          	ld	a5,654(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc020221a:	4585                	li	a1,1
ffffffffc020221c:	e83a                	sd	a4,16(sp)
ffffffffc020221e:	739c                	ld	a5,32(a5)
ffffffffc0202220:	e436                	sd	a3,8(sp)
ffffffffc0202222:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202224:	0000b617          	auipc	a2,0xb
ffffffffc0202228:	2a463603          	ld	a2,676(a2) # ffffffffc020d4c8 <pages>
ffffffffc020222c:	66a2                	ld	a3,8(sp)
ffffffffc020222e:	6742                	ld	a4,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202230:	12048073          	sfence.vma	s1
ffffffffc0202234:	bfa5                	j	ffffffffc02021ac <page_insert+0x34>
        intr_disable();
ffffffffc0202236:	ec3a                	sd	a4,24(sp)
ffffffffc0202238:	e836                	sd	a3,16(sp)
ffffffffc020223a:	e42a                	sd	a0,8(sp)
ffffffffc020223c:	e38fe0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202240:	0000b797          	auipc	a5,0xb
ffffffffc0202244:	2607b783          	ld	a5,608(a5) # ffffffffc020d4a0 <pmm_manager>
ffffffffc0202248:	6522                	ld	a0,8(sp)
ffffffffc020224a:	4585                	li	a1,1
ffffffffc020224c:	739c                	ld	a5,32(a5)
ffffffffc020224e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202250:	e1efe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202254:	0000b617          	auipc	a2,0xb
ffffffffc0202258:	27463603          	ld	a2,628(a2) # ffffffffc020d4c8 <pages>
ffffffffc020225c:	6762                	ld	a4,24(sp)
ffffffffc020225e:	66c2                	ld	a3,16(sp)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202260:	12048073          	sfence.vma	s1
ffffffffc0202264:	b7a1                	j	ffffffffc02021ac <page_insert+0x34>
        return -E_NO_MEM;
ffffffffc0202266:	5571                	li	a0,-4
ffffffffc0202268:	bfb9                	j	ffffffffc02021c6 <page_insert+0x4e>
ffffffffc020226a:	afdff0ef          	jal	ffffffffc0201d66 <pa2page.part.0>

ffffffffc020226e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020226e:	00003797          	auipc	a5,0x3
ffffffffc0202272:	7a278793          	addi	a5,a5,1954 # ffffffffc0205a10 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202276:	638c                	ld	a1,0(a5)
{
ffffffffc0202278:	7159                	addi	sp,sp,-112
ffffffffc020227a:	f486                	sd	ra,104(sp)
ffffffffc020227c:	e8ca                	sd	s2,80(sp)
ffffffffc020227e:	e4ce                	sd	s3,72(sp)
ffffffffc0202280:	f85a                	sd	s6,48(sp)
ffffffffc0202282:	f0a2                	sd	s0,96(sp)
ffffffffc0202284:	eca6                	sd	s1,88(sp)
ffffffffc0202286:	e0d2                	sd	s4,64(sp)
ffffffffc0202288:	fc56                	sd	s5,56(sp)
ffffffffc020228a:	f45e                	sd	s7,40(sp)
ffffffffc020228c:	f062                	sd	s8,32(sp)
ffffffffc020228e:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202290:	0000bb17          	auipc	s6,0xb
ffffffffc0202294:	210b0b13          	addi	s6,s6,528 # ffffffffc020d4a0 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202298:	00003517          	auipc	a0,0x3
ffffffffc020229c:	c7050513          	addi	a0,a0,-912 # ffffffffc0204f08 <etext+0xf88>
    pmm_manager = &default_pmm_manager;
ffffffffc02022a0:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02022a4:	ef1fd0ef          	jal	ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc02022a8:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02022ac:	0000b997          	auipc	s3,0xb
ffffffffc02022b0:	20c98993          	addi	s3,s3,524 # ffffffffc020d4b8 <va_pa_offset>
    pmm_manager->init();
ffffffffc02022b4:	679c                	ld	a5,8(a5)
ffffffffc02022b6:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02022b8:	57f5                	li	a5,-3
ffffffffc02022ba:	07fa                	slli	a5,a5,0x1e
ffffffffc02022bc:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02022c0:	d9afe0ef          	jal	ffffffffc020085a <get_memory_base>
ffffffffc02022c4:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02022c6:	d9efe0ef          	jal	ffffffffc0200864 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02022ca:	70050e63          	beqz	a0,ffffffffc02029e6 <pmm_init+0x778>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02022ce:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02022d0:	00003517          	auipc	a0,0x3
ffffffffc02022d4:	c7050513          	addi	a0,a0,-912 # ffffffffc0204f40 <etext+0xfc0>
ffffffffc02022d8:	ebdfd0ef          	jal	ffffffffc0200194 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02022dc:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02022e0:	864a                	mv	a2,s2
ffffffffc02022e2:	85a6                	mv	a1,s1
ffffffffc02022e4:	fff40693          	addi	a3,s0,-1
ffffffffc02022e8:	00003517          	auipc	a0,0x3
ffffffffc02022ec:	c7050513          	addi	a0,a0,-912 # ffffffffc0204f58 <etext+0xfd8>
ffffffffc02022f0:	ea5fd0ef          	jal	ffffffffc0200194 <cprintf>
    if (maxpa > KERNTOP)
ffffffffc02022f4:	c80007b7          	lui	a5,0xc8000
ffffffffc02022f8:	8522                	mv	a0,s0
ffffffffc02022fa:	5287ed63          	bltu	a5,s0,ffffffffc0202834 <pmm_init+0x5c6>
ffffffffc02022fe:	77fd                	lui	a5,0xfffff
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202300:	0000c617          	auipc	a2,0xc
ffffffffc0202304:	1ef60613          	addi	a2,a2,495 # ffffffffc020e4ef <end+0xfff>
ffffffffc0202308:	8e7d                	and	a2,a2,a5
    npage = maxpa / PGSIZE;
ffffffffc020230a:	8131                	srli	a0,a0,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020230c:	0000bb97          	auipc	s7,0xb
ffffffffc0202310:	1bcb8b93          	addi	s7,s7,444 # ffffffffc020d4c8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202314:	0000b497          	auipc	s1,0xb
ffffffffc0202318:	1ac48493          	addi	s1,s1,428 # ffffffffc020d4c0 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020231c:	00cbb023          	sd	a2,0(s7)
    npage = maxpa / PGSIZE;
ffffffffc0202320:	e088                	sd	a0,0(s1)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202322:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202326:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202328:	02f50763          	beq	a0,a5,ffffffffc0202356 <pmm_init+0xe8>
ffffffffc020232c:	4701                	li	a4,0
ffffffffc020232e:	4585                	li	a1,1
ffffffffc0202330:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202334:	00671793          	slli	a5,a4,0x6
ffffffffc0202338:	97b2                	add	a5,a5,a2
ffffffffc020233a:	07a1                	addi	a5,a5,8 # 80008 <kern_entry-0xffffffffc017fff8>
ffffffffc020233c:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202340:	6088                	ld	a0,0(s1)
ffffffffc0202342:	0705                	addi	a4,a4,1
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202344:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202348:	00d507b3          	add	a5,a0,a3
ffffffffc020234c:	fef764e3          	bltu	a4,a5,ffffffffc0202334 <pmm_init+0xc6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202350:	079a                	slli	a5,a5,0x6
ffffffffc0202352:	00f606b3          	add	a3,a2,a5
ffffffffc0202356:	c02007b7          	lui	a5,0xc0200
ffffffffc020235a:	16f6eee3          	bltu	a3,a5,ffffffffc0202cd6 <pmm_init+0xa68>
ffffffffc020235e:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202362:	77fd                	lui	a5,0xfffff
ffffffffc0202364:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202366:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202368:	4e86ed63          	bltu	a3,s0,ffffffffc0202862 <pmm_init+0x5f4>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020236c:	00003517          	auipc	a0,0x3
ffffffffc0202370:	c1450513          	addi	a0,a0,-1004 # ffffffffc0204f80 <etext+0x1000>
ffffffffc0202374:	e21fd0ef          	jal	ffffffffc0200194 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202378:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020237c:	0000b917          	auipc	s2,0xb
ffffffffc0202380:	13490913          	addi	s2,s2,308 # ffffffffc020d4b0 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202384:	7b9c                	ld	a5,48(a5)
ffffffffc0202386:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202388:	00003517          	auipc	a0,0x3
ffffffffc020238c:	c1050513          	addi	a0,a0,-1008 # ffffffffc0204f98 <etext+0x1018>
ffffffffc0202390:	e05fd0ef          	jal	ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202394:	00006697          	auipc	a3,0x6
ffffffffc0202398:	c6c68693          	addi	a3,a3,-916 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc020239c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02023a0:	c02007b7          	lui	a5,0xc0200
ffffffffc02023a4:	2af6eee3          	bltu	a3,a5,ffffffffc0202e60 <pmm_init+0xbf2>
ffffffffc02023a8:	0009b783          	ld	a5,0(s3)
ffffffffc02023ac:	8e9d                	sub	a3,a3,a5
ffffffffc02023ae:	0000b797          	auipc	a5,0xb
ffffffffc02023b2:	0ed7bd23          	sd	a3,250(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02023b6:	100027f3          	csrr	a5,sstatus
ffffffffc02023ba:	8b89                	andi	a5,a5,2
ffffffffc02023bc:	48079963          	bnez	a5,ffffffffc020284e <pmm_init+0x5e0>
        ret = pmm_manager->nr_free_pages();
ffffffffc02023c0:	000b3783          	ld	a5,0(s6)
ffffffffc02023c4:	779c                	ld	a5,40(a5)
ffffffffc02023c6:	9782                	jalr	a5
ffffffffc02023c8:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02023ca:	6098                	ld	a4,0(s1)
ffffffffc02023cc:	c80007b7          	lui	a5,0xc8000
ffffffffc02023d0:	83b1                	srli	a5,a5,0xc
ffffffffc02023d2:	66e7e663          	bltu	a5,a4,ffffffffc0202a3e <pmm_init+0x7d0>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02023d6:	00093503          	ld	a0,0(s2)
ffffffffc02023da:	64050263          	beqz	a0,ffffffffc0202a1e <pmm_init+0x7b0>
ffffffffc02023de:	03451793          	slli	a5,a0,0x34
ffffffffc02023e2:	62079e63          	bnez	a5,ffffffffc0202a1e <pmm_init+0x7b0>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02023e6:	4601                	li	a2,0
ffffffffc02023e8:	4581                	li	a1,0
ffffffffc02023ea:	c9fff0ef          	jal	ffffffffc0202088 <get_page>
ffffffffc02023ee:	240519e3          	bnez	a0,ffffffffc0202e40 <pmm_init+0xbd2>
ffffffffc02023f2:	100027f3          	csrr	a5,sstatus
ffffffffc02023f6:	8b89                	andi	a5,a5,2
ffffffffc02023f8:	44079063          	bnez	a5,ffffffffc0202838 <pmm_init+0x5ca>
        page = pmm_manager->alloc_pages(n);
ffffffffc02023fc:	000b3783          	ld	a5,0(s6)
ffffffffc0202400:	4505                	li	a0,1
ffffffffc0202402:	6f9c                	ld	a5,24(a5)
ffffffffc0202404:	9782                	jalr	a5
ffffffffc0202406:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202408:	00093503          	ld	a0,0(s2)
ffffffffc020240c:	4681                	li	a3,0
ffffffffc020240e:	4601                	li	a2,0
ffffffffc0202410:	85d2                	mv	a1,s4
ffffffffc0202412:	d67ff0ef          	jal	ffffffffc0202178 <page_insert>
ffffffffc0202416:	280511e3          	bnez	a0,ffffffffc0202e98 <pmm_init+0xc2a>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020241a:	00093503          	ld	a0,0(s2)
ffffffffc020241e:	4601                	li	a2,0
ffffffffc0202420:	4581                	li	a1,0
ffffffffc0202422:	a09ff0ef          	jal	ffffffffc0201e2a <get_pte>
ffffffffc0202426:	240509e3          	beqz	a0,ffffffffc0202e78 <pmm_init+0xc0a>
    assert(pte2page(*ptep) == p1);
ffffffffc020242a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020242c:	0017f713          	andi	a4,a5,1
ffffffffc0202430:	58070f63          	beqz	a4,ffffffffc02029ce <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc0202434:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202436:	078a                	slli	a5,a5,0x2
ffffffffc0202438:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020243a:	58e7f863          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020243e:	000bb683          	ld	a3,0(s7)
ffffffffc0202442:	079a                	slli	a5,a5,0x6
ffffffffc0202444:	fe000637          	lui	a2,0xfe000
ffffffffc0202448:	97b2                	add	a5,a5,a2
ffffffffc020244a:	97b6                	add	a5,a5,a3
ffffffffc020244c:	14fa1ae3          	bne	s4,a5,ffffffffc0202da0 <pmm_init+0xb32>
    assert(page_ref(p1) == 1);
ffffffffc0202450:	000a2683          	lw	a3,0(s4)
ffffffffc0202454:	4785                	li	a5,1
ffffffffc0202456:	12f695e3          	bne	a3,a5,ffffffffc0202d80 <pmm_init+0xb12>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020245a:	00093503          	ld	a0,0(s2)
ffffffffc020245e:	77fd                	lui	a5,0xfffff
ffffffffc0202460:	6114                	ld	a3,0(a0)
ffffffffc0202462:	068a                	slli	a3,a3,0x2
ffffffffc0202464:	8efd                	and	a3,a3,a5
ffffffffc0202466:	00c6d613          	srli	a2,a3,0xc
ffffffffc020246a:	0ee67fe3          	bgeu	a2,a4,ffffffffc0202d68 <pmm_init+0xafa>
ffffffffc020246e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202472:	96e2                	add	a3,a3,s8
ffffffffc0202474:	0006ba83          	ld	s5,0(a3)
ffffffffc0202478:	0a8a                	slli	s5,s5,0x2
ffffffffc020247a:	00fafab3          	and	s5,s5,a5
ffffffffc020247e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202482:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0202d4e <pmm_init+0xae0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202486:	4601                	li	a2,0
ffffffffc0202488:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020248a:	9c56                	add	s8,s8,s5
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020248c:	99fff0ef          	jal	ffffffffc0201e2a <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202490:	0c21                	addi	s8,s8,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202492:	05851ee3          	bne	a0,s8,ffffffffc0202cee <pmm_init+0xa80>
ffffffffc0202496:	100027f3          	csrr	a5,sstatus
ffffffffc020249a:	8b89                	andi	a5,a5,2
ffffffffc020249c:	3e079b63          	bnez	a5,ffffffffc0202892 <pmm_init+0x624>
        page = pmm_manager->alloc_pages(n);
ffffffffc02024a0:	000b3783          	ld	a5,0(s6)
ffffffffc02024a4:	4505                	li	a0,1
ffffffffc02024a6:	6f9c                	ld	a5,24(a5)
ffffffffc02024a8:	9782                	jalr	a5
ffffffffc02024aa:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02024ac:	00093503          	ld	a0,0(s2)
ffffffffc02024b0:	46d1                	li	a3,20
ffffffffc02024b2:	6605                	lui	a2,0x1
ffffffffc02024b4:	85e2                	mv	a1,s8
ffffffffc02024b6:	cc3ff0ef          	jal	ffffffffc0202178 <page_insert>
ffffffffc02024ba:	06051ae3          	bnez	a0,ffffffffc0202d2e <pmm_init+0xac0>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02024be:	00093503          	ld	a0,0(s2)
ffffffffc02024c2:	4601                	li	a2,0
ffffffffc02024c4:	6585                	lui	a1,0x1
ffffffffc02024c6:	965ff0ef          	jal	ffffffffc0201e2a <get_pte>
ffffffffc02024ca:	040502e3          	beqz	a0,ffffffffc0202d0e <pmm_init+0xaa0>
    assert(*ptep & PTE_U);
ffffffffc02024ce:	611c                	ld	a5,0(a0)
ffffffffc02024d0:	0107f713          	andi	a4,a5,16
ffffffffc02024d4:	7e070163          	beqz	a4,ffffffffc0202cb6 <pmm_init+0xa48>
    assert(*ptep & PTE_W);
ffffffffc02024d8:	8b91                	andi	a5,a5,4
ffffffffc02024da:	7a078e63          	beqz	a5,ffffffffc0202c96 <pmm_init+0xa28>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02024de:	00093503          	ld	a0,0(s2)
ffffffffc02024e2:	611c                	ld	a5,0(a0)
ffffffffc02024e4:	8bc1                	andi	a5,a5,16
ffffffffc02024e6:	78078863          	beqz	a5,ffffffffc0202c76 <pmm_init+0xa08>
    assert(page_ref(p2) == 1);
ffffffffc02024ea:	000c2703          	lw	a4,0(s8)
ffffffffc02024ee:	4785                	li	a5,1
ffffffffc02024f0:	76f71363          	bne	a4,a5,ffffffffc0202c56 <pmm_init+0x9e8>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02024f4:	4681                	li	a3,0
ffffffffc02024f6:	6605                	lui	a2,0x1
ffffffffc02024f8:	85d2                	mv	a1,s4
ffffffffc02024fa:	c7fff0ef          	jal	ffffffffc0202178 <page_insert>
ffffffffc02024fe:	72051c63          	bnez	a0,ffffffffc0202c36 <pmm_init+0x9c8>
    assert(page_ref(p1) == 2);
ffffffffc0202502:	000a2703          	lw	a4,0(s4)
ffffffffc0202506:	4789                	li	a5,2
ffffffffc0202508:	70f71763          	bne	a4,a5,ffffffffc0202c16 <pmm_init+0x9a8>
    assert(page_ref(p2) == 0);
ffffffffc020250c:	000c2783          	lw	a5,0(s8)
ffffffffc0202510:	6e079363          	bnez	a5,ffffffffc0202bf6 <pmm_init+0x988>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202514:	00093503          	ld	a0,0(s2)
ffffffffc0202518:	4601                	li	a2,0
ffffffffc020251a:	6585                	lui	a1,0x1
ffffffffc020251c:	90fff0ef          	jal	ffffffffc0201e2a <get_pte>
ffffffffc0202520:	6a050b63          	beqz	a0,ffffffffc0202bd6 <pmm_init+0x968>
    assert(pte2page(*ptep) == p1);
ffffffffc0202524:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202526:	00177793          	andi	a5,a4,1
ffffffffc020252a:	4a078263          	beqz	a5,ffffffffc02029ce <pmm_init+0x760>
    if (PPN(pa) >= npage)
ffffffffc020252e:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202530:	00271793          	slli	a5,a4,0x2
ffffffffc0202534:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202536:	48d7fa63          	bgeu	a5,a3,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020253a:	000bb683          	ld	a3,0(s7)
ffffffffc020253e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202542:	97d6                	add	a5,a5,s5
ffffffffc0202544:	079a                	slli	a5,a5,0x6
ffffffffc0202546:	97b6                	add	a5,a5,a3
ffffffffc0202548:	66fa1763          	bne	s4,a5,ffffffffc0202bb6 <pmm_init+0x948>
    assert((*ptep & PTE_U) == 0);
ffffffffc020254c:	8b41                	andi	a4,a4,16
ffffffffc020254e:	64071463          	bnez	a4,ffffffffc0202b96 <pmm_init+0x928>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202552:	00093503          	ld	a0,0(s2)
ffffffffc0202556:	4581                	li	a1,0
ffffffffc0202558:	b85ff0ef          	jal	ffffffffc02020dc <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020255c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202560:	4785                	li	a5,1
ffffffffc0202562:	60fc9a63          	bne	s9,a5,ffffffffc0202b76 <pmm_init+0x908>
    assert(page_ref(p2) == 0);
ffffffffc0202566:	000c2783          	lw	a5,0(s8)
ffffffffc020256a:	5e079663          	bnez	a5,ffffffffc0202b56 <pmm_init+0x8e8>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020256e:	00093503          	ld	a0,0(s2)
ffffffffc0202572:	6585                	lui	a1,0x1
ffffffffc0202574:	b69ff0ef          	jal	ffffffffc02020dc <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202578:	000a2783          	lw	a5,0(s4)
ffffffffc020257c:	52079d63          	bnez	a5,ffffffffc0202ab6 <pmm_init+0x848>
    assert(page_ref(p2) == 0);
ffffffffc0202580:	000c2783          	lw	a5,0(s8)
ffffffffc0202584:	50079963          	bnez	a5,ffffffffc0202a96 <pmm_init+0x828>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202588:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020258c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020258e:	000a3783          	ld	a5,0(s4)
ffffffffc0202592:	078a                	slli	a5,a5,0x2
ffffffffc0202594:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202596:	42e7fa63          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc020259a:	000bb503          	ld	a0,0(s7)
ffffffffc020259e:	97d6                	add	a5,a5,s5
ffffffffc02025a0:	079a                	slli	a5,a5,0x6
    return page->ref;
ffffffffc02025a2:	00f506b3          	add	a3,a0,a5
ffffffffc02025a6:	4294                	lw	a3,0(a3)
ffffffffc02025a8:	4d969763          	bne	a3,s9,ffffffffc0202a76 <pmm_init+0x808>
    return page - pages + nbase;
ffffffffc02025ac:	8799                	srai	a5,a5,0x6
ffffffffc02025ae:	00080637          	lui	a2,0x80
ffffffffc02025b2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02025b4:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02025b8:	4ae7f363          	bgeu	a5,a4,ffffffffc0202a5e <pmm_init+0x7f0>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02025bc:	0009b783          	ld	a5,0(s3)
ffffffffc02025c0:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc02025c2:	639c                	ld	a5,0(a5)
ffffffffc02025c4:	078a                	slli	a5,a5,0x2
ffffffffc02025c6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025c8:	40e7f163          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02025cc:	8f91                	sub	a5,a5,a2
ffffffffc02025ce:	079a                	slli	a5,a5,0x6
ffffffffc02025d0:	953e                	add	a0,a0,a5
ffffffffc02025d2:	100027f3          	csrr	a5,sstatus
ffffffffc02025d6:	8b89                	andi	a5,a5,2
ffffffffc02025d8:	30079863          	bnez	a5,ffffffffc02028e8 <pmm_init+0x67a>
        pmm_manager->free_pages(base, n);
ffffffffc02025dc:	000b3783          	ld	a5,0(s6)
ffffffffc02025e0:	4585                	li	a1,1
ffffffffc02025e2:	739c                	ld	a5,32(a5)
ffffffffc02025e4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02025e6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02025ea:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02025ec:	078a                	slli	a5,a5,0x2
ffffffffc02025ee:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025f0:	3ce7fd63          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02025f4:	000bb503          	ld	a0,0(s7)
ffffffffc02025f8:	fe000737          	lui	a4,0xfe000
ffffffffc02025fc:	079a                	slli	a5,a5,0x6
ffffffffc02025fe:	97ba                	add	a5,a5,a4
ffffffffc0202600:	953e                	add	a0,a0,a5
ffffffffc0202602:	100027f3          	csrr	a5,sstatus
ffffffffc0202606:	8b89                	andi	a5,a5,2
ffffffffc0202608:	2c079463          	bnez	a5,ffffffffc02028d0 <pmm_init+0x662>
ffffffffc020260c:	000b3783          	ld	a5,0(s6)
ffffffffc0202610:	4585                	li	a1,1
ffffffffc0202612:	739c                	ld	a5,32(a5)
ffffffffc0202614:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202616:	00093783          	ld	a5,0(s2)
ffffffffc020261a:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b10>
    asm volatile("sfence.vma");
ffffffffc020261e:	12000073          	sfence.vma
ffffffffc0202622:	100027f3          	csrr	a5,sstatus
ffffffffc0202626:	8b89                	andi	a5,a5,2
ffffffffc0202628:	28079a63          	bnez	a5,ffffffffc02028bc <pmm_init+0x64e>
        ret = pmm_manager->nr_free_pages();
ffffffffc020262c:	000b3783          	ld	a5,0(s6)
ffffffffc0202630:	779c                	ld	a5,40(a5)
ffffffffc0202632:	9782                	jalr	a5
ffffffffc0202634:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202636:	4d441063          	bne	s0,s4,ffffffffc0202af6 <pmm_init+0x888>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020263a:	00003517          	auipc	a0,0x3
ffffffffc020263e:	cae50513          	addi	a0,a0,-850 # ffffffffc02052e8 <etext+0x1368>
ffffffffc0202642:	b53fd0ef          	jal	ffffffffc0200194 <cprintf>
ffffffffc0202646:	100027f3          	csrr	a5,sstatus
ffffffffc020264a:	8b89                	andi	a5,a5,2
ffffffffc020264c:	24079e63          	bnez	a5,ffffffffc02028a8 <pmm_init+0x63a>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202650:	000b3783          	ld	a5,0(s6)
ffffffffc0202654:	779c                	ld	a5,40(a5)
ffffffffc0202656:	9782                	jalr	a5
ffffffffc0202658:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020265a:	609c                	ld	a5,0(s1)
ffffffffc020265c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202660:	7a7d                	lui	s4,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202662:	00c79713          	slli	a4,a5,0xc
ffffffffc0202666:	6a85                	lui	s5,0x1
ffffffffc0202668:	02e47c63          	bgeu	s0,a4,ffffffffc02026a0 <pmm_init+0x432>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020266c:	00c45713          	srli	a4,s0,0xc
ffffffffc0202670:	30f77063          	bgeu	a4,a5,ffffffffc0202970 <pmm_init+0x702>
ffffffffc0202674:	0009b583          	ld	a1,0(s3)
ffffffffc0202678:	00093503          	ld	a0,0(s2)
ffffffffc020267c:	4601                	li	a2,0
ffffffffc020267e:	95a2                	add	a1,a1,s0
ffffffffc0202680:	faaff0ef          	jal	ffffffffc0201e2a <get_pte>
ffffffffc0202684:	32050363          	beqz	a0,ffffffffc02029aa <pmm_init+0x73c>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202688:	611c                	ld	a5,0(a0)
ffffffffc020268a:	078a                	slli	a5,a5,0x2
ffffffffc020268c:	0147f7b3          	and	a5,a5,s4
ffffffffc0202690:	2e879d63          	bne	a5,s0,ffffffffc020298a <pmm_init+0x71c>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202694:	609c                	ld	a5,0(s1)
ffffffffc0202696:	9456                	add	s0,s0,s5
ffffffffc0202698:	00c79713          	slli	a4,a5,0xc
ffffffffc020269c:	fce468e3          	bltu	s0,a4,ffffffffc020266c <pmm_init+0x3fe>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc02026a0:	00093783          	ld	a5,0(s2)
ffffffffc02026a4:	639c                	ld	a5,0(a5)
ffffffffc02026a6:	42079863          	bnez	a5,ffffffffc0202ad6 <pmm_init+0x868>
ffffffffc02026aa:	100027f3          	csrr	a5,sstatus
ffffffffc02026ae:	8b89                	andi	a5,a5,2
ffffffffc02026b0:	24079863          	bnez	a5,ffffffffc0202900 <pmm_init+0x692>
        page = pmm_manager->alloc_pages(n);
ffffffffc02026b4:	000b3783          	ld	a5,0(s6)
ffffffffc02026b8:	4505                	li	a0,1
ffffffffc02026ba:	6f9c                	ld	a5,24(a5)
ffffffffc02026bc:	9782                	jalr	a5
ffffffffc02026be:	842a                	mv	s0,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02026c0:	00093503          	ld	a0,0(s2)
ffffffffc02026c4:	4699                	li	a3,6
ffffffffc02026c6:	10000613          	li	a2,256
ffffffffc02026ca:	85a2                	mv	a1,s0
ffffffffc02026cc:	aadff0ef          	jal	ffffffffc0202178 <page_insert>
ffffffffc02026d0:	46051363          	bnez	a0,ffffffffc0202b36 <pmm_init+0x8c8>
    assert(page_ref(p) == 1);
ffffffffc02026d4:	4018                	lw	a4,0(s0)
ffffffffc02026d6:	4785                	li	a5,1
ffffffffc02026d8:	42f71f63          	bne	a4,a5,ffffffffc0202b16 <pmm_init+0x8a8>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02026dc:	00093503          	ld	a0,0(s2)
ffffffffc02026e0:	6605                	lui	a2,0x1
ffffffffc02026e2:	10060613          	addi	a2,a2,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02026e6:	4699                	li	a3,6
ffffffffc02026e8:	85a2                	mv	a1,s0
ffffffffc02026ea:	a8fff0ef          	jal	ffffffffc0202178 <page_insert>
ffffffffc02026ee:	72051963          	bnez	a0,ffffffffc0202e20 <pmm_init+0xbb2>
    assert(page_ref(p) == 2);
ffffffffc02026f2:	4018                	lw	a4,0(s0)
ffffffffc02026f4:	4789                	li	a5,2
ffffffffc02026f6:	70f71563          	bne	a4,a5,ffffffffc0202e00 <pmm_init+0xb92>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02026fa:	00003597          	auipc	a1,0x3
ffffffffc02026fe:	d3658593          	addi	a1,a1,-714 # ffffffffc0205430 <etext+0x14b0>
ffffffffc0202702:	10000513          	li	a0,256
ffffffffc0202706:	7ac010ef          	jal	ffffffffc0203eb2 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020270a:	6585                	lui	a1,0x1
ffffffffc020270c:	10058593          	addi	a1,a1,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc0202710:	10000513          	li	a0,256
ffffffffc0202714:	7b0010ef          	jal	ffffffffc0203ec4 <strcmp>
ffffffffc0202718:	6c051463          	bnez	a0,ffffffffc0202de0 <pmm_init+0xb72>
    return page - pages + nbase;
ffffffffc020271c:	000bb683          	ld	a3,0(s7)
ffffffffc0202720:	000807b7          	lui	a5,0x80
    return KADDR(page2pa(page));
ffffffffc0202724:	6098                	ld	a4,0(s1)
    return page - pages + nbase;
ffffffffc0202726:	40d406b3          	sub	a3,s0,a3
ffffffffc020272a:	8699                	srai	a3,a3,0x6
ffffffffc020272c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020272e:	00c69793          	slli	a5,a3,0xc
ffffffffc0202732:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202734:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202736:	32e7f463          	bgeu	a5,a4,ffffffffc0202a5e <pmm_init+0x7f0>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020273a:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020273e:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202742:	97b6                	add	a5,a5,a3
ffffffffc0202744:	10078023          	sb	zero,256(a5) # 80100 <kern_entry-0xffffffffc017ff00>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202748:	736010ef          	jal	ffffffffc0203e7e <strlen>
ffffffffc020274c:	66051a63          	bnez	a0,ffffffffc0202dc0 <pmm_init+0xb52>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202750:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202754:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202756:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fdf1b10>
ffffffffc020275a:	078a                	slli	a5,a5,0x2
ffffffffc020275c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020275e:	26e7f663          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return page2ppn(page) << PGSHIFT;
ffffffffc0202762:	00c79693          	slli	a3,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202766:	2ee7fc63          	bgeu	a5,a4,ffffffffc0202a5e <pmm_init+0x7f0>
ffffffffc020276a:	0009b783          	ld	a5,0(s3)
ffffffffc020276e:	00f689b3          	add	s3,a3,a5
ffffffffc0202772:	100027f3          	csrr	a5,sstatus
ffffffffc0202776:	8b89                	andi	a5,a5,2
ffffffffc0202778:	1e079163          	bnez	a5,ffffffffc020295a <pmm_init+0x6ec>
        pmm_manager->free_pages(base, n);
ffffffffc020277c:	000b3783          	ld	a5,0(s6)
ffffffffc0202780:	8522                	mv	a0,s0
ffffffffc0202782:	4585                	li	a1,1
ffffffffc0202784:	739c                	ld	a5,32(a5)
ffffffffc0202786:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202788:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage)
ffffffffc020278c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020278e:	078a                	slli	a5,a5,0x2
ffffffffc0202790:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202792:	22e7fc63          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202796:	000bb503          	ld	a0,0(s7)
ffffffffc020279a:	fe000737          	lui	a4,0xfe000
ffffffffc020279e:	079a                	slli	a5,a5,0x6
ffffffffc02027a0:	97ba                	add	a5,a5,a4
ffffffffc02027a2:	953e                	add	a0,a0,a5
ffffffffc02027a4:	100027f3          	csrr	a5,sstatus
ffffffffc02027a8:	8b89                	andi	a5,a5,2
ffffffffc02027aa:	18079c63          	bnez	a5,ffffffffc0202942 <pmm_init+0x6d4>
ffffffffc02027ae:	000b3783          	ld	a5,0(s6)
ffffffffc02027b2:	4585                	li	a1,1
ffffffffc02027b4:	739c                	ld	a5,32(a5)
ffffffffc02027b6:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02027b8:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02027bc:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02027be:	078a                	slli	a5,a5,0x2
ffffffffc02027c0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02027c2:	20e7f463          	bgeu	a5,a4,ffffffffc02029ca <pmm_init+0x75c>
    return &pages[PPN(pa) - nbase];
ffffffffc02027c6:	000bb503          	ld	a0,0(s7)
ffffffffc02027ca:	fe000737          	lui	a4,0xfe000
ffffffffc02027ce:	079a                	slli	a5,a5,0x6
ffffffffc02027d0:	97ba                	add	a5,a5,a4
ffffffffc02027d2:	953e                	add	a0,a0,a5
ffffffffc02027d4:	100027f3          	csrr	a5,sstatus
ffffffffc02027d8:	8b89                	andi	a5,a5,2
ffffffffc02027da:	14079863          	bnez	a5,ffffffffc020292a <pmm_init+0x6bc>
ffffffffc02027de:	000b3783          	ld	a5,0(s6)
ffffffffc02027e2:	4585                	li	a1,1
ffffffffc02027e4:	739c                	ld	a5,32(a5)
ffffffffc02027e6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02027e8:	00093783          	ld	a5,0(s2)
ffffffffc02027ec:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02027f0:	12000073          	sfence.vma
ffffffffc02027f4:	100027f3          	csrr	a5,sstatus
ffffffffc02027f8:	8b89                	andi	a5,a5,2
ffffffffc02027fa:	10079e63          	bnez	a5,ffffffffc0202916 <pmm_init+0x6a8>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027fe:	000b3783          	ld	a5,0(s6)
ffffffffc0202802:	779c                	ld	a5,40(a5)
ffffffffc0202804:	9782                	jalr	a5
ffffffffc0202806:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202808:	1e8c1b63          	bne	s8,s0,ffffffffc02029fe <pmm_init+0x790>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc020280c:	00003517          	auipc	a0,0x3
ffffffffc0202810:	c9c50513          	addi	a0,a0,-868 # ffffffffc02054a8 <etext+0x1528>
ffffffffc0202814:	981fd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc0202818:	7406                	ld	s0,96(sp)
ffffffffc020281a:	70a6                	ld	ra,104(sp)
ffffffffc020281c:	64e6                	ld	s1,88(sp)
ffffffffc020281e:	6946                	ld	s2,80(sp)
ffffffffc0202820:	69a6                	ld	s3,72(sp)
ffffffffc0202822:	6a06                	ld	s4,64(sp)
ffffffffc0202824:	7ae2                	ld	s5,56(sp)
ffffffffc0202826:	7b42                	ld	s6,48(sp)
ffffffffc0202828:	7ba2                	ld	s7,40(sp)
ffffffffc020282a:	7c02                	ld	s8,32(sp)
ffffffffc020282c:	6ce2                	ld	s9,24(sp)
ffffffffc020282e:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202830:	b70ff06f          	j	ffffffffc0201ba0 <kmalloc_init>
    if (maxpa > KERNTOP)
ffffffffc0202834:	853e                	mv	a0,a5
ffffffffc0202836:	b4e1                	j	ffffffffc02022fe <pmm_init+0x90>
        intr_disable();
ffffffffc0202838:	83cfe0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020283c:	000b3783          	ld	a5,0(s6)
ffffffffc0202840:	4505                	li	a0,1
ffffffffc0202842:	6f9c                	ld	a5,24(a5)
ffffffffc0202844:	9782                	jalr	a5
ffffffffc0202846:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202848:	826fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020284c:	be75                	j	ffffffffc0202408 <pmm_init+0x19a>
        intr_disable();
ffffffffc020284e:	826fe0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202852:	000b3783          	ld	a5,0(s6)
ffffffffc0202856:	779c                	ld	a5,40(a5)
ffffffffc0202858:	9782                	jalr	a5
ffffffffc020285a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020285c:	812fe0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202860:	b6ad                	j	ffffffffc02023ca <pmm_init+0x15c>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202862:	6705                	lui	a4,0x1
ffffffffc0202864:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0202866:	96ba                	add	a3,a3,a4
ffffffffc0202868:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc020286a:	00c7d713          	srli	a4,a5,0xc
ffffffffc020286e:	14a77e63          	bgeu	a4,a0,ffffffffc02029ca <pmm_init+0x75c>
    pmm_manager->init_memmap(base, n);
ffffffffc0202872:	000b3683          	ld	a3,0(s6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202876:	8c1d                	sub	s0,s0,a5
    return &pages[PPN(pa) - nbase];
ffffffffc0202878:	071a                	slli	a4,a4,0x6
ffffffffc020287a:	fe0007b7          	lui	a5,0xfe000
ffffffffc020287e:	973e                	add	a4,a4,a5
    pmm_manager->init_memmap(base, n);
ffffffffc0202880:	6a9c                	ld	a5,16(a3)
ffffffffc0202882:	00c45593          	srli	a1,s0,0xc
ffffffffc0202886:	00e60533          	add	a0,a2,a4
ffffffffc020288a:	9782                	jalr	a5
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020288c:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202890:	bcf1                	j	ffffffffc020236c <pmm_init+0xfe>
        intr_disable();
ffffffffc0202892:	fe3fd0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202896:	000b3783          	ld	a5,0(s6)
ffffffffc020289a:	4505                	li	a0,1
ffffffffc020289c:	6f9c                	ld	a5,24(a5)
ffffffffc020289e:	9782                	jalr	a5
ffffffffc02028a0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02028a2:	fcdfd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028a6:	b119                	j	ffffffffc02024ac <pmm_init+0x23e>
        intr_disable();
ffffffffc02028a8:	fcdfd0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02028ac:	000b3783          	ld	a5,0(s6)
ffffffffc02028b0:	779c                	ld	a5,40(a5)
ffffffffc02028b2:	9782                	jalr	a5
ffffffffc02028b4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02028b6:	fb9fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028ba:	b345                	j	ffffffffc020265a <pmm_init+0x3ec>
        intr_disable();
ffffffffc02028bc:	fb9fd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02028c0:	000b3783          	ld	a5,0(s6)
ffffffffc02028c4:	779c                	ld	a5,40(a5)
ffffffffc02028c6:	9782                	jalr	a5
ffffffffc02028c8:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02028ca:	fa5fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028ce:	b3a5                	j	ffffffffc0202636 <pmm_init+0x3c8>
ffffffffc02028d0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02028d2:	fa3fd0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02028d6:	000b3783          	ld	a5,0(s6)
ffffffffc02028da:	6522                	ld	a0,8(sp)
ffffffffc02028dc:	4585                	li	a1,1
ffffffffc02028de:	739c                	ld	a5,32(a5)
ffffffffc02028e0:	9782                	jalr	a5
        intr_enable();
ffffffffc02028e2:	f8dfd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028e6:	bb05                	j	ffffffffc0202616 <pmm_init+0x3a8>
ffffffffc02028e8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02028ea:	f8bfd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc02028ee:	000b3783          	ld	a5,0(s6)
ffffffffc02028f2:	6522                	ld	a0,8(sp)
ffffffffc02028f4:	4585                	li	a1,1
ffffffffc02028f6:	739c                	ld	a5,32(a5)
ffffffffc02028f8:	9782                	jalr	a5
        intr_enable();
ffffffffc02028fa:	f75fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc02028fe:	b1e5                	j	ffffffffc02025e6 <pmm_init+0x378>
        intr_disable();
ffffffffc0202900:	f75fd0ef          	jal	ffffffffc0200874 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202904:	000b3783          	ld	a5,0(s6)
ffffffffc0202908:	4505                	li	a0,1
ffffffffc020290a:	6f9c                	ld	a5,24(a5)
ffffffffc020290c:	9782                	jalr	a5
ffffffffc020290e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202910:	f5ffd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202914:	b375                	j	ffffffffc02026c0 <pmm_init+0x452>
        intr_disable();
ffffffffc0202916:	f5ffd0ef          	jal	ffffffffc0200874 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020291a:	000b3783          	ld	a5,0(s6)
ffffffffc020291e:	779c                	ld	a5,40(a5)
ffffffffc0202920:	9782                	jalr	a5
ffffffffc0202922:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202924:	f4bfd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202928:	b5c5                	j	ffffffffc0202808 <pmm_init+0x59a>
ffffffffc020292a:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020292c:	f49fd0ef          	jal	ffffffffc0200874 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202930:	000b3783          	ld	a5,0(s6)
ffffffffc0202934:	6522                	ld	a0,8(sp)
ffffffffc0202936:	4585                	li	a1,1
ffffffffc0202938:	739c                	ld	a5,32(a5)
ffffffffc020293a:	9782                	jalr	a5
        intr_enable();
ffffffffc020293c:	f33fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202940:	b565                	j	ffffffffc02027e8 <pmm_init+0x57a>
ffffffffc0202942:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202944:	f31fd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc0202948:	000b3783          	ld	a5,0(s6)
ffffffffc020294c:	6522                	ld	a0,8(sp)
ffffffffc020294e:	4585                	li	a1,1
ffffffffc0202950:	739c                	ld	a5,32(a5)
ffffffffc0202952:	9782                	jalr	a5
        intr_enable();
ffffffffc0202954:	f1bfd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc0202958:	b585                	j	ffffffffc02027b8 <pmm_init+0x54a>
        intr_disable();
ffffffffc020295a:	f1bfd0ef          	jal	ffffffffc0200874 <intr_disable>
ffffffffc020295e:	000b3783          	ld	a5,0(s6)
ffffffffc0202962:	8522                	mv	a0,s0
ffffffffc0202964:	4585                	li	a1,1
ffffffffc0202966:	739c                	ld	a5,32(a5)
ffffffffc0202968:	9782                	jalr	a5
        intr_enable();
ffffffffc020296a:	f05fd0ef          	jal	ffffffffc020086e <intr_enable>
ffffffffc020296e:	bd29                	j	ffffffffc0202788 <pmm_init+0x51a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202970:	86a2                	mv	a3,s0
ffffffffc0202972:	00002617          	auipc	a2,0x2
ffffffffc0202976:	49660613          	addi	a2,a2,1174 # ffffffffc0204e08 <etext+0xe88>
ffffffffc020297a:	1a400593          	li	a1,420
ffffffffc020297e:	00002517          	auipc	a0,0x2
ffffffffc0202982:	57a50513          	addi	a0,a0,1402 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202986:	a81fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020298a:	00003697          	auipc	a3,0x3
ffffffffc020298e:	9be68693          	addi	a3,a3,-1602 # ffffffffc0205348 <etext+0x13c8>
ffffffffc0202992:	00002617          	auipc	a2,0x2
ffffffffc0202996:	0c660613          	addi	a2,a2,198 # ffffffffc0204a58 <etext+0xad8>
ffffffffc020299a:	1a500593          	li	a1,421
ffffffffc020299e:	00002517          	auipc	a0,0x2
ffffffffc02029a2:	55a50513          	addi	a0,a0,1370 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc02029a6:	a61fd0ef          	jal	ffffffffc0200406 <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02029aa:	00003697          	auipc	a3,0x3
ffffffffc02029ae:	95e68693          	addi	a3,a3,-1698 # ffffffffc0205308 <etext+0x1388>
ffffffffc02029b2:	00002617          	auipc	a2,0x2
ffffffffc02029b6:	0a660613          	addi	a2,a2,166 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02029ba:	1a400593          	li	a1,420
ffffffffc02029be:	00002517          	auipc	a0,0x2
ffffffffc02029c2:	53a50513          	addi	a0,a0,1338 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc02029c6:	a41fd0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc02029ca:	b9cff0ef          	jal	ffffffffc0201d66 <pa2page.part.0>
        panic("pte2page called with invalid pte");
ffffffffc02029ce:	00002617          	auipc	a2,0x2
ffffffffc02029d2:	6da60613          	addi	a2,a2,1754 # ffffffffc02050a8 <etext+0x1128>
ffffffffc02029d6:	07f00593          	li	a1,127
ffffffffc02029da:	00002517          	auipc	a0,0x2
ffffffffc02029de:	45650513          	addi	a0,a0,1110 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc02029e2:	a25fd0ef          	jal	ffffffffc0200406 <__panic>
        panic("DTB memory info not available");
ffffffffc02029e6:	00002617          	auipc	a2,0x2
ffffffffc02029ea:	53a60613          	addi	a2,a2,1338 # ffffffffc0204f20 <etext+0xfa0>
ffffffffc02029ee:	06400593          	li	a1,100
ffffffffc02029f2:	00002517          	auipc	a0,0x2
ffffffffc02029f6:	50650513          	addi	a0,a0,1286 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc02029fa:	a0dfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02029fe:	00003697          	auipc	a3,0x3
ffffffffc0202a02:	8c268693          	addi	a3,a3,-1854 # ffffffffc02052c0 <etext+0x1340>
ffffffffc0202a06:	00002617          	auipc	a2,0x2
ffffffffc0202a0a:	05260613          	addi	a2,a2,82 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202a0e:	1bf00593          	li	a1,447
ffffffffc0202a12:	00002517          	auipc	a0,0x2
ffffffffc0202a16:	4e650513          	addi	a0,a0,1254 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202a1a:	9edfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202a1e:	00002697          	auipc	a3,0x2
ffffffffc0202a22:	5ba68693          	addi	a3,a3,1466 # ffffffffc0204fd8 <etext+0x1058>
ffffffffc0202a26:	00002617          	auipc	a2,0x2
ffffffffc0202a2a:	03260613          	addi	a2,a2,50 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202a2e:	16600593          	li	a1,358
ffffffffc0202a32:	00002517          	auipc	a0,0x2
ffffffffc0202a36:	4c650513          	addi	a0,a0,1222 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202a3a:	9cdfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202a3e:	00002697          	auipc	a3,0x2
ffffffffc0202a42:	57a68693          	addi	a3,a3,1402 # ffffffffc0204fb8 <etext+0x1038>
ffffffffc0202a46:	00002617          	auipc	a2,0x2
ffffffffc0202a4a:	01260613          	addi	a2,a2,18 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202a4e:	16500593          	li	a1,357
ffffffffc0202a52:	00002517          	auipc	a0,0x2
ffffffffc0202a56:	4a650513          	addi	a0,a0,1190 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202a5a:	9adfd0ef          	jal	ffffffffc0200406 <__panic>
    return KADDR(page2pa(page));
ffffffffc0202a5e:	00002617          	auipc	a2,0x2
ffffffffc0202a62:	3aa60613          	addi	a2,a2,938 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202a66:	07100593          	li	a1,113
ffffffffc0202a6a:	00002517          	auipc	a0,0x2
ffffffffc0202a6e:	3c650513          	addi	a0,a0,966 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc0202a72:	995fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a76:	00003697          	auipc	a3,0x3
ffffffffc0202a7a:	81a68693          	addi	a3,a3,-2022 # ffffffffc0205290 <etext+0x1310>
ffffffffc0202a7e:	00002617          	auipc	a2,0x2
ffffffffc0202a82:	fda60613          	addi	a2,a2,-38 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202a86:	18d00593          	li	a1,397
ffffffffc0202a8a:	00002517          	auipc	a0,0x2
ffffffffc0202a8e:	46e50513          	addi	a0,a0,1134 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202a92:	975fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202a96:	00002697          	auipc	a3,0x2
ffffffffc0202a9a:	7b268693          	addi	a3,a3,1970 # ffffffffc0205248 <etext+0x12c8>
ffffffffc0202a9e:	00002617          	auipc	a2,0x2
ffffffffc0202aa2:	fba60613          	addi	a2,a2,-70 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202aa6:	18b00593          	li	a1,395
ffffffffc0202aaa:	00002517          	auipc	a0,0x2
ffffffffc0202aae:	44e50513          	addi	a0,a0,1102 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202ab2:	955fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202ab6:	00002697          	auipc	a3,0x2
ffffffffc0202aba:	7c268693          	addi	a3,a3,1986 # ffffffffc0205278 <etext+0x12f8>
ffffffffc0202abe:	00002617          	auipc	a2,0x2
ffffffffc0202ac2:	f9a60613          	addi	a2,a2,-102 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202ac6:	18a00593          	li	a1,394
ffffffffc0202aca:	00002517          	auipc	a0,0x2
ffffffffc0202ace:	42e50513          	addi	a0,a0,1070 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202ad2:	935fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202ad6:	00003697          	auipc	a3,0x3
ffffffffc0202ada:	88a68693          	addi	a3,a3,-1910 # ffffffffc0205360 <etext+0x13e0>
ffffffffc0202ade:	00002617          	auipc	a2,0x2
ffffffffc0202ae2:	f7a60613          	addi	a2,a2,-134 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202ae6:	1a800593          	li	a1,424
ffffffffc0202aea:	00002517          	auipc	a0,0x2
ffffffffc0202aee:	40e50513          	addi	a0,a0,1038 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202af2:	915fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202af6:	00002697          	auipc	a3,0x2
ffffffffc0202afa:	7ca68693          	addi	a3,a3,1994 # ffffffffc02052c0 <etext+0x1340>
ffffffffc0202afe:	00002617          	auipc	a2,0x2
ffffffffc0202b02:	f5a60613          	addi	a2,a2,-166 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202b06:	19500593          	li	a1,405
ffffffffc0202b0a:	00002517          	auipc	a0,0x2
ffffffffc0202b0e:	3ee50513          	addi	a0,a0,1006 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202b12:	8f5fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202b16:	00003697          	auipc	a3,0x3
ffffffffc0202b1a:	8a268693          	addi	a3,a3,-1886 # ffffffffc02053b8 <etext+0x1438>
ffffffffc0202b1e:	00002617          	auipc	a2,0x2
ffffffffc0202b22:	f3a60613          	addi	a2,a2,-198 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202b26:	1ad00593          	li	a1,429
ffffffffc0202b2a:	00002517          	auipc	a0,0x2
ffffffffc0202b2e:	3ce50513          	addi	a0,a0,974 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202b32:	8d5fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202b36:	00003697          	auipc	a3,0x3
ffffffffc0202b3a:	84268693          	addi	a3,a3,-1982 # ffffffffc0205378 <etext+0x13f8>
ffffffffc0202b3e:	00002617          	auipc	a2,0x2
ffffffffc0202b42:	f1a60613          	addi	a2,a2,-230 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202b46:	1ac00593          	li	a1,428
ffffffffc0202b4a:	00002517          	auipc	a0,0x2
ffffffffc0202b4e:	3ae50513          	addi	a0,a0,942 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202b52:	8b5fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202b56:	00002697          	auipc	a3,0x2
ffffffffc0202b5a:	6f268693          	addi	a3,a3,1778 # ffffffffc0205248 <etext+0x12c8>
ffffffffc0202b5e:	00002617          	auipc	a2,0x2
ffffffffc0202b62:	efa60613          	addi	a2,a2,-262 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202b66:	18700593          	li	a1,391
ffffffffc0202b6a:	00002517          	auipc	a0,0x2
ffffffffc0202b6e:	38e50513          	addi	a0,a0,910 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202b72:	895fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202b76:	00002697          	auipc	a3,0x2
ffffffffc0202b7a:	57268693          	addi	a3,a3,1394 # ffffffffc02050e8 <etext+0x1168>
ffffffffc0202b7e:	00002617          	auipc	a2,0x2
ffffffffc0202b82:	eda60613          	addi	a2,a2,-294 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202b86:	18600593          	li	a1,390
ffffffffc0202b8a:	00002517          	auipc	a0,0x2
ffffffffc0202b8e:	36e50513          	addi	a0,a0,878 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202b92:	875fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202b96:	00002697          	auipc	a3,0x2
ffffffffc0202b9a:	6ca68693          	addi	a3,a3,1738 # ffffffffc0205260 <etext+0x12e0>
ffffffffc0202b9e:	00002617          	auipc	a2,0x2
ffffffffc0202ba2:	eba60613          	addi	a2,a2,-326 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202ba6:	18300593          	li	a1,387
ffffffffc0202baa:	00002517          	auipc	a0,0x2
ffffffffc0202bae:	34e50513          	addi	a0,a0,846 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202bb2:	855fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202bb6:	00002697          	auipc	a3,0x2
ffffffffc0202bba:	51a68693          	addi	a3,a3,1306 # ffffffffc02050d0 <etext+0x1150>
ffffffffc0202bbe:	00002617          	auipc	a2,0x2
ffffffffc0202bc2:	e9a60613          	addi	a2,a2,-358 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202bc6:	18200593          	li	a1,386
ffffffffc0202bca:	00002517          	auipc	a0,0x2
ffffffffc0202bce:	32e50513          	addi	a0,a0,814 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202bd2:	835fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bd6:	00002697          	auipc	a3,0x2
ffffffffc0202bda:	59a68693          	addi	a3,a3,1434 # ffffffffc0205170 <etext+0x11f0>
ffffffffc0202bde:	00002617          	auipc	a2,0x2
ffffffffc0202be2:	e7a60613          	addi	a2,a2,-390 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202be6:	18100593          	li	a1,385
ffffffffc0202bea:	00002517          	auipc	a0,0x2
ffffffffc0202bee:	30e50513          	addi	a0,a0,782 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202bf2:	815fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202bf6:	00002697          	auipc	a3,0x2
ffffffffc0202bfa:	65268693          	addi	a3,a3,1618 # ffffffffc0205248 <etext+0x12c8>
ffffffffc0202bfe:	00002617          	auipc	a2,0x2
ffffffffc0202c02:	e5a60613          	addi	a2,a2,-422 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202c06:	18000593          	li	a1,384
ffffffffc0202c0a:	00002517          	auipc	a0,0x2
ffffffffc0202c0e:	2ee50513          	addi	a0,a0,750 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202c12:	ff4fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202c16:	00002697          	auipc	a3,0x2
ffffffffc0202c1a:	61a68693          	addi	a3,a3,1562 # ffffffffc0205230 <etext+0x12b0>
ffffffffc0202c1e:	00002617          	auipc	a2,0x2
ffffffffc0202c22:	e3a60613          	addi	a2,a2,-454 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202c26:	17f00593          	li	a1,383
ffffffffc0202c2a:	00002517          	auipc	a0,0x2
ffffffffc0202c2e:	2ce50513          	addi	a0,a0,718 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202c32:	fd4fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202c36:	00002697          	auipc	a3,0x2
ffffffffc0202c3a:	5ca68693          	addi	a3,a3,1482 # ffffffffc0205200 <etext+0x1280>
ffffffffc0202c3e:	00002617          	auipc	a2,0x2
ffffffffc0202c42:	e1a60613          	addi	a2,a2,-486 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202c46:	17e00593          	li	a1,382
ffffffffc0202c4a:	00002517          	auipc	a0,0x2
ffffffffc0202c4e:	2ae50513          	addi	a0,a0,686 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202c52:	fb4fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202c56:	00002697          	auipc	a3,0x2
ffffffffc0202c5a:	59268693          	addi	a3,a3,1426 # ffffffffc02051e8 <etext+0x1268>
ffffffffc0202c5e:	00002617          	auipc	a2,0x2
ffffffffc0202c62:	dfa60613          	addi	a2,a2,-518 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202c66:	17c00593          	li	a1,380
ffffffffc0202c6a:	00002517          	auipc	a0,0x2
ffffffffc0202c6e:	28e50513          	addi	a0,a0,654 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202c72:	f94fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202c76:	00002697          	auipc	a3,0x2
ffffffffc0202c7a:	55268693          	addi	a3,a3,1362 # ffffffffc02051c8 <etext+0x1248>
ffffffffc0202c7e:	00002617          	auipc	a2,0x2
ffffffffc0202c82:	dda60613          	addi	a2,a2,-550 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202c86:	17b00593          	li	a1,379
ffffffffc0202c8a:	00002517          	auipc	a0,0x2
ffffffffc0202c8e:	26e50513          	addi	a0,a0,622 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202c92:	f74fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202c96:	00002697          	auipc	a3,0x2
ffffffffc0202c9a:	52268693          	addi	a3,a3,1314 # ffffffffc02051b8 <etext+0x1238>
ffffffffc0202c9e:	00002617          	auipc	a2,0x2
ffffffffc0202ca2:	dba60613          	addi	a2,a2,-582 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202ca6:	17a00593          	li	a1,378
ffffffffc0202caa:	00002517          	auipc	a0,0x2
ffffffffc0202cae:	24e50513          	addi	a0,a0,590 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202cb2:	f54fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202cb6:	00002697          	auipc	a3,0x2
ffffffffc0202cba:	4f268693          	addi	a3,a3,1266 # ffffffffc02051a8 <etext+0x1228>
ffffffffc0202cbe:	00002617          	auipc	a2,0x2
ffffffffc0202cc2:	d9a60613          	addi	a2,a2,-614 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202cc6:	17900593          	li	a1,377
ffffffffc0202cca:	00002517          	auipc	a0,0x2
ffffffffc0202cce:	22e50513          	addi	a0,a0,558 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202cd2:	f34fd0ef          	jal	ffffffffc0200406 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202cd6:	00002617          	auipc	a2,0x2
ffffffffc0202cda:	1da60613          	addi	a2,a2,474 # ffffffffc0204eb0 <etext+0xf30>
ffffffffc0202cde:	08000593          	li	a1,128
ffffffffc0202ce2:	00002517          	auipc	a0,0x2
ffffffffc0202ce6:	21650513          	addi	a0,a0,534 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202cea:	f1cfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202cee:	00002697          	auipc	a3,0x2
ffffffffc0202cf2:	41268693          	addi	a3,a3,1042 # ffffffffc0205100 <etext+0x1180>
ffffffffc0202cf6:	00002617          	auipc	a2,0x2
ffffffffc0202cfa:	d6260613          	addi	a2,a2,-670 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202cfe:	17400593          	li	a1,372
ffffffffc0202d02:	00002517          	auipc	a0,0x2
ffffffffc0202d06:	1f650513          	addi	a0,a0,502 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d0a:	efcfd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202d0e:	00002697          	auipc	a3,0x2
ffffffffc0202d12:	46268693          	addi	a3,a3,1122 # ffffffffc0205170 <etext+0x11f0>
ffffffffc0202d16:	00002617          	auipc	a2,0x2
ffffffffc0202d1a:	d4260613          	addi	a2,a2,-702 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202d1e:	17800593          	li	a1,376
ffffffffc0202d22:	00002517          	auipc	a0,0x2
ffffffffc0202d26:	1d650513          	addi	a0,a0,470 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d2a:	edcfd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202d2e:	00002697          	auipc	a3,0x2
ffffffffc0202d32:	40268693          	addi	a3,a3,1026 # ffffffffc0205130 <etext+0x11b0>
ffffffffc0202d36:	00002617          	auipc	a2,0x2
ffffffffc0202d3a:	d2260613          	addi	a2,a2,-734 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202d3e:	17700593          	li	a1,375
ffffffffc0202d42:	00002517          	auipc	a0,0x2
ffffffffc0202d46:	1b650513          	addi	a0,a0,438 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d4a:	ebcfd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202d4e:	86d6                	mv	a3,s5
ffffffffc0202d50:	00002617          	auipc	a2,0x2
ffffffffc0202d54:	0b860613          	addi	a2,a2,184 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202d58:	17300593          	li	a1,371
ffffffffc0202d5c:	00002517          	auipc	a0,0x2
ffffffffc0202d60:	19c50513          	addi	a0,a0,412 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d64:	ea2fd0ef          	jal	ffffffffc0200406 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202d68:	00002617          	auipc	a2,0x2
ffffffffc0202d6c:	0a060613          	addi	a2,a2,160 # ffffffffc0204e08 <etext+0xe88>
ffffffffc0202d70:	17200593          	li	a1,370
ffffffffc0202d74:	00002517          	auipc	a0,0x2
ffffffffc0202d78:	18450513          	addi	a0,a0,388 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d7c:	e8afd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202d80:	00002697          	auipc	a3,0x2
ffffffffc0202d84:	36868693          	addi	a3,a3,872 # ffffffffc02050e8 <etext+0x1168>
ffffffffc0202d88:	00002617          	auipc	a2,0x2
ffffffffc0202d8c:	cd060613          	addi	a2,a2,-816 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202d90:	17000593          	li	a1,368
ffffffffc0202d94:	00002517          	auipc	a0,0x2
ffffffffc0202d98:	16450513          	addi	a0,a0,356 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202d9c:	e6afd0ef          	jal	ffffffffc0200406 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202da0:	00002697          	auipc	a3,0x2
ffffffffc0202da4:	33068693          	addi	a3,a3,816 # ffffffffc02050d0 <etext+0x1150>
ffffffffc0202da8:	00002617          	auipc	a2,0x2
ffffffffc0202dac:	cb060613          	addi	a2,a2,-848 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202db0:	16f00593          	li	a1,367
ffffffffc0202db4:	00002517          	auipc	a0,0x2
ffffffffc0202db8:	14450513          	addi	a0,a0,324 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202dbc:	e4afd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202dc0:	00002697          	auipc	a3,0x2
ffffffffc0202dc4:	6c068693          	addi	a3,a3,1728 # ffffffffc0205480 <etext+0x1500>
ffffffffc0202dc8:	00002617          	auipc	a2,0x2
ffffffffc0202dcc:	c9060613          	addi	a2,a2,-880 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202dd0:	1b600593          	li	a1,438
ffffffffc0202dd4:	00002517          	auipc	a0,0x2
ffffffffc0202dd8:	12450513          	addi	a0,a0,292 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202ddc:	e2afd0ef          	jal	ffffffffc0200406 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202de0:	00002697          	auipc	a3,0x2
ffffffffc0202de4:	66868693          	addi	a3,a3,1640 # ffffffffc0205448 <etext+0x14c8>
ffffffffc0202de8:	00002617          	auipc	a2,0x2
ffffffffc0202dec:	c7060613          	addi	a2,a2,-912 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202df0:	1b300593          	li	a1,435
ffffffffc0202df4:	00002517          	auipc	a0,0x2
ffffffffc0202df8:	10450513          	addi	a0,a0,260 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202dfc:	e0afd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202e00:	00002697          	auipc	a3,0x2
ffffffffc0202e04:	61868693          	addi	a3,a3,1560 # ffffffffc0205418 <etext+0x1498>
ffffffffc0202e08:	00002617          	auipc	a2,0x2
ffffffffc0202e0c:	c5060613          	addi	a2,a2,-944 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202e10:	1af00593          	li	a1,431
ffffffffc0202e14:	00002517          	auipc	a0,0x2
ffffffffc0202e18:	0e450513          	addi	a0,a0,228 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202e1c:	deafd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202e20:	00002697          	auipc	a3,0x2
ffffffffc0202e24:	5b068693          	addi	a3,a3,1456 # ffffffffc02053d0 <etext+0x1450>
ffffffffc0202e28:	00002617          	auipc	a2,0x2
ffffffffc0202e2c:	c3060613          	addi	a2,a2,-976 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202e30:	1ae00593          	li	a1,430
ffffffffc0202e34:	00002517          	auipc	a0,0x2
ffffffffc0202e38:	0c450513          	addi	a0,a0,196 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202e3c:	dcafd0ef          	jal	ffffffffc0200406 <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202e40:	00002697          	auipc	a3,0x2
ffffffffc0202e44:	1d868693          	addi	a3,a3,472 # ffffffffc0205018 <etext+0x1098>
ffffffffc0202e48:	00002617          	auipc	a2,0x2
ffffffffc0202e4c:	c1060613          	addi	a2,a2,-1008 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202e50:	16700593          	li	a1,359
ffffffffc0202e54:	00002517          	auipc	a0,0x2
ffffffffc0202e58:	0a450513          	addi	a0,a0,164 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202e5c:	daafd0ef          	jal	ffffffffc0200406 <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202e60:	00002617          	auipc	a2,0x2
ffffffffc0202e64:	05060613          	addi	a2,a2,80 # ffffffffc0204eb0 <etext+0xf30>
ffffffffc0202e68:	0cb00593          	li	a1,203
ffffffffc0202e6c:	00002517          	auipc	a0,0x2
ffffffffc0202e70:	08c50513          	addi	a0,a0,140 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202e74:	d92fd0ef          	jal	ffffffffc0200406 <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202e78:	00002697          	auipc	a3,0x2
ffffffffc0202e7c:	20068693          	addi	a3,a3,512 # ffffffffc0205078 <etext+0x10f8>
ffffffffc0202e80:	00002617          	auipc	a2,0x2
ffffffffc0202e84:	bd860613          	addi	a2,a2,-1064 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202e88:	16e00593          	li	a1,366
ffffffffc0202e8c:	00002517          	auipc	a0,0x2
ffffffffc0202e90:	06c50513          	addi	a0,a0,108 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202e94:	d72fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202e98:	00002697          	auipc	a3,0x2
ffffffffc0202e9c:	1b068693          	addi	a3,a3,432 # ffffffffc0205048 <etext+0x10c8>
ffffffffc0202ea0:	00002617          	auipc	a2,0x2
ffffffffc0202ea4:	bb860613          	addi	a2,a2,-1096 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202ea8:	16b00593          	li	a1,363
ffffffffc0202eac:	00002517          	auipc	a0,0x2
ffffffffc0202eb0:	04c50513          	addi	a0,a0,76 # ffffffffc0204ef8 <etext+0xf78>
ffffffffc0202eb4:	d52fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202eb8 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202eb8:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202eba:	00002697          	auipc	a3,0x2
ffffffffc0202ebe:	60e68693          	addi	a3,a3,1550 # ffffffffc02054c8 <etext+0x1548>
ffffffffc0202ec2:	00002617          	auipc	a2,0x2
ffffffffc0202ec6:	b9660613          	addi	a2,a2,-1130 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202eca:	08800593          	li	a1,136
ffffffffc0202ece:	00002517          	auipc	a0,0x2
ffffffffc0202ed2:	61a50513          	addi	a0,a0,1562 # ffffffffc02054e8 <etext+0x1568>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202ed6:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202ed8:	d2efd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202edc <find_vma>:
    if (mm != NULL)
ffffffffc0202edc:	c505                	beqz	a0,ffffffffc0202f04 <find_vma+0x28>
        vma = mm->mmap_cache;
ffffffffc0202ede:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202ee0:	c781                	beqz	a5,ffffffffc0202ee8 <find_vma+0xc>
ffffffffc0202ee2:	6798                	ld	a4,8(a5)
ffffffffc0202ee4:	02e5f363          	bgeu	a1,a4,ffffffffc0202f0a <find_vma+0x2e>
    return listelm->next;
ffffffffc0202ee8:	651c                	ld	a5,8(a0)
            while ((le = list_next(le)) != list)
ffffffffc0202eea:	00f50d63          	beq	a0,a5,ffffffffc0202f04 <find_vma+0x28>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0202eee:	fe87b703          	ld	a4,-24(a5) # fffffffffdffffe8 <end+0x3ddf2af8>
ffffffffc0202ef2:	00e5e663          	bltu	a1,a4,ffffffffc0202efe <find_vma+0x22>
ffffffffc0202ef6:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202efa:	00e5ee63          	bltu	a1,a4,ffffffffc0202f16 <find_vma+0x3a>
ffffffffc0202efe:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0202f00:	fef517e3          	bne	a0,a5,ffffffffc0202eee <find_vma+0x12>
    struct vma_struct *vma = NULL;
ffffffffc0202f04:	4781                	li	a5,0
}
ffffffffc0202f06:	853e                	mv	a0,a5
ffffffffc0202f08:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202f0a:	6b98                	ld	a4,16(a5)
ffffffffc0202f0c:	fce5fee3          	bgeu	a1,a4,ffffffffc0202ee8 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0202f10:	e91c                	sd	a5,16(a0)
}
ffffffffc0202f12:	853e                	mv	a0,a5
ffffffffc0202f14:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0202f16:	1781                	addi	a5,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202f18:	e91c                	sd	a5,16(a0)
ffffffffc0202f1a:	bfe5                	j	ffffffffc0202f12 <find_vma+0x36>

ffffffffc0202f1c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202f1c:	6590                	ld	a2,8(a1)
ffffffffc0202f1e:	0105b803          	ld	a6,16(a1)
{
ffffffffc0202f22:	1141                	addi	sp,sp,-16
ffffffffc0202f24:	e406                	sd	ra,8(sp)
ffffffffc0202f26:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202f28:	01066763          	bltu	a2,a6,ffffffffc0202f36 <insert_vma_struct+0x1a>
ffffffffc0202f2c:	a8b9                	j	ffffffffc0202f8a <insert_vma_struct+0x6e>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202f2e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202f32:	04e66763          	bltu	a2,a4,ffffffffc0202f80 <insert_vma_struct+0x64>
ffffffffc0202f36:	86be                	mv	a3,a5
ffffffffc0202f38:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0202f3a:	fef51ae3          	bne	a0,a5,ffffffffc0202f2e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0202f3e:	02a68463          	beq	a3,a0,ffffffffc0202f66 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202f42:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202f46:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202f4a:	08e8f063          	bgeu	a7,a4,ffffffffc0202fca <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202f4e:	04e66e63          	bltu	a2,a4,ffffffffc0202faa <insert_vma_struct+0x8e>
    }
    if (le_next != list)
ffffffffc0202f52:	00f50a63          	beq	a0,a5,ffffffffc0202f66 <insert_vma_struct+0x4a>
ffffffffc0202f56:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202f5a:	05076863          	bltu	a4,a6,ffffffffc0202faa <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0202f5e:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202f62:	02c77263          	bgeu	a4,a2,ffffffffc0202f86 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0202f66:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202f68:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202f6a:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202f6e:	e390                	sd	a2,0(a5)
ffffffffc0202f70:	e690                	sd	a2,8(a3)
}
ffffffffc0202f72:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202f74:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202f76:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0202f78:	2705                	addiw	a4,a4,1
ffffffffc0202f7a:	d118                	sw	a4,32(a0)
}
ffffffffc0202f7c:	0141                	addi	sp,sp,16
ffffffffc0202f7e:	8082                	ret
    if (le_prev != list)
ffffffffc0202f80:	fca691e3          	bne	a3,a0,ffffffffc0202f42 <insert_vma_struct+0x26>
ffffffffc0202f84:	bfd9                	j	ffffffffc0202f5a <insert_vma_struct+0x3e>
ffffffffc0202f86:	f33ff0ef          	jal	ffffffffc0202eb8 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202f8a:	00002697          	auipc	a3,0x2
ffffffffc0202f8e:	56e68693          	addi	a3,a3,1390 # ffffffffc02054f8 <etext+0x1578>
ffffffffc0202f92:	00002617          	auipc	a2,0x2
ffffffffc0202f96:	ac660613          	addi	a2,a2,-1338 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202f9a:	08e00593          	li	a1,142
ffffffffc0202f9e:	00002517          	auipc	a0,0x2
ffffffffc0202fa2:	54a50513          	addi	a0,a0,1354 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0202fa6:	c60fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202faa:	00002697          	auipc	a3,0x2
ffffffffc0202fae:	58e68693          	addi	a3,a3,1422 # ffffffffc0205538 <etext+0x15b8>
ffffffffc0202fb2:	00002617          	auipc	a2,0x2
ffffffffc0202fb6:	aa660613          	addi	a2,a2,-1370 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202fba:	08700593          	li	a1,135
ffffffffc0202fbe:	00002517          	auipc	a0,0x2
ffffffffc0202fc2:	52a50513          	addi	a0,a0,1322 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0202fc6:	c40fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202fca:	00002697          	auipc	a3,0x2
ffffffffc0202fce:	54e68693          	addi	a3,a3,1358 # ffffffffc0205518 <etext+0x1598>
ffffffffc0202fd2:	00002617          	auipc	a2,0x2
ffffffffc0202fd6:	a8660613          	addi	a2,a2,-1402 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0202fda:	08600593          	li	a1,134
ffffffffc0202fde:	00002517          	auipc	a0,0x2
ffffffffc0202fe2:	50a50513          	addi	a0,a0,1290 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0202fe6:	c20fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0202fea <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202fea:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202fec:	03000513          	li	a0,48
{
ffffffffc0202ff0:	fc06                	sd	ra,56(sp)
ffffffffc0202ff2:	f822                	sd	s0,48(sp)
ffffffffc0202ff4:	f426                	sd	s1,40(sp)
ffffffffc0202ff6:	f04a                	sd	s2,32(sp)
ffffffffc0202ff8:	ec4e                	sd	s3,24(sp)
ffffffffc0202ffa:	e852                	sd	s4,16(sp)
ffffffffc0202ffc:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202ffe:	bc3fe0ef          	jal	ffffffffc0201bc0 <kmalloc>
    if (mm != NULL)
ffffffffc0203002:	18050a63          	beqz	a0,ffffffffc0203196 <vmm_init+0x1ac>
ffffffffc0203006:	842a                	mv	s0,a0
    elm->prev = elm->next = elm;
ffffffffc0203008:	e508                	sd	a0,8(a0)
ffffffffc020300a:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020300c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203010:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203014:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203018:	02053423          	sd	zero,40(a0)
ffffffffc020301c:	03200493          	li	s1,50
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203020:	03000513          	li	a0,48
ffffffffc0203024:	b9dfe0ef          	jal	ffffffffc0201bc0 <kmalloc>
    if (vma != NULL)
ffffffffc0203028:	14050763          	beqz	a0,ffffffffc0203176 <vmm_init+0x18c>
        vma->vm_end = vm_end;
ffffffffc020302c:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc0203030:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203032:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203036:	e91c                	sd	a5,16(a0)
    int i;
    for (i = step1; i >= 1; i--)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203038:	85aa                	mv	a1,a0
    for (i = step1; i >= 1; i--)
ffffffffc020303a:	14ed                	addi	s1,s1,-5
        insert_vma_struct(mm, vma);
ffffffffc020303c:	8522                	mv	a0,s0
ffffffffc020303e:	edfff0ef          	jal	ffffffffc0202f1c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203042:	fcf9                	bnez	s1,ffffffffc0203020 <vmm_init+0x36>
ffffffffc0203044:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203048:	1f900913          	li	s2,505
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020304c:	03000513          	li	a0,48
ffffffffc0203050:	b71fe0ef          	jal	ffffffffc0201bc0 <kmalloc>
    if (vma != NULL)
ffffffffc0203054:	16050163          	beqz	a0,ffffffffc02031b6 <vmm_init+0x1cc>
        vma->vm_end = vm_end;
ffffffffc0203058:	00248793          	addi	a5,s1,2
        vma->vm_start = vm_start;
ffffffffc020305c:	e504                	sd	s1,8(a0)
        vma->vm_flags = vm_flags;
ffffffffc020305e:	00052c23          	sw	zero,24(a0)
        vma->vm_end = vm_end;
ffffffffc0203062:	e91c                	sd	a5,16(a0)
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203064:	85aa                	mv	a1,a0
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203066:	0495                	addi	s1,s1,5
        insert_vma_struct(mm, vma);
ffffffffc0203068:	8522                	mv	a0,s0
ffffffffc020306a:	eb3ff0ef          	jal	ffffffffc0202f1c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc020306e:	fd249fe3          	bne	s1,s2,ffffffffc020304c <vmm_init+0x62>
    return listelm->next;
ffffffffc0203072:	641c                	ld	a5,8(s0)
ffffffffc0203074:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203076:	1fb00593          	li	a1,507
ffffffffc020307a:	8abe                	mv	s5,a5
    {
        assert(le != &(mm->mmap_list));
ffffffffc020307c:	20f40d63          	beq	s0,a5,ffffffffc0203296 <vmm_init+0x2ac>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203080:	fe87b603          	ld	a2,-24(a5)
ffffffffc0203084:	ffe70693          	addi	a3,a4,-2
ffffffffc0203088:	14d61763          	bne	a2,a3,ffffffffc02031d6 <vmm_init+0x1ec>
ffffffffc020308c:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203090:	14e69363          	bne	a3,a4,ffffffffc02031d6 <vmm_init+0x1ec>
    for (i = 1; i <= step2; i++)
ffffffffc0203094:	0715                	addi	a4,a4,5
ffffffffc0203096:	679c                	ld	a5,8(a5)
ffffffffc0203098:	feb712e3          	bne	a4,a1,ffffffffc020307c <vmm_init+0x92>
ffffffffc020309c:	491d                	li	s2,7
ffffffffc020309e:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02030a0:	85a6                	mv	a1,s1
ffffffffc02030a2:	8522                	mv	a0,s0
ffffffffc02030a4:	e39ff0ef          	jal	ffffffffc0202edc <find_vma>
ffffffffc02030a8:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc02030aa:	22050663          	beqz	a0,ffffffffc02032d6 <vmm_init+0x2ec>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc02030ae:	00148593          	addi	a1,s1,1
ffffffffc02030b2:	8522                	mv	a0,s0
ffffffffc02030b4:	e29ff0ef          	jal	ffffffffc0202edc <find_vma>
ffffffffc02030b8:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc02030ba:	1e050e63          	beqz	a0,ffffffffc02032b6 <vmm_init+0x2cc>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc02030be:	85ca                	mv	a1,s2
ffffffffc02030c0:	8522                	mv	a0,s0
ffffffffc02030c2:	e1bff0ef          	jal	ffffffffc0202edc <find_vma>
        assert(vma3 == NULL);
ffffffffc02030c6:	1a051863          	bnez	a0,ffffffffc0203276 <vmm_init+0x28c>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc02030ca:	00348593          	addi	a1,s1,3
ffffffffc02030ce:	8522                	mv	a0,s0
ffffffffc02030d0:	e0dff0ef          	jal	ffffffffc0202edc <find_vma>
        assert(vma4 == NULL);
ffffffffc02030d4:	18051163          	bnez	a0,ffffffffc0203256 <vmm_init+0x26c>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc02030d8:	00448593          	addi	a1,s1,4
ffffffffc02030dc:	8522                	mv	a0,s0
ffffffffc02030de:	dffff0ef          	jal	ffffffffc0202edc <find_vma>
        assert(vma5 == NULL);
ffffffffc02030e2:	14051a63          	bnez	a0,ffffffffc0203236 <vmm_init+0x24c>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02030e6:	008a3783          	ld	a5,8(s4)
ffffffffc02030ea:	12979663          	bne	a5,s1,ffffffffc0203216 <vmm_init+0x22c>
ffffffffc02030ee:	010a3783          	ld	a5,16(s4)
ffffffffc02030f2:	13279263          	bne	a5,s2,ffffffffc0203216 <vmm_init+0x22c>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc02030f6:	0089b783          	ld	a5,8(s3)
ffffffffc02030fa:	0e979e63          	bne	a5,s1,ffffffffc02031f6 <vmm_init+0x20c>
ffffffffc02030fe:	0109b783          	ld	a5,16(s3)
ffffffffc0203102:	0f279a63          	bne	a5,s2,ffffffffc02031f6 <vmm_init+0x20c>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203106:	0495                	addi	s1,s1,5
ffffffffc0203108:	1f900793          	li	a5,505
ffffffffc020310c:	0915                	addi	s2,s2,5
ffffffffc020310e:	f8f499e3          	bne	s1,a5,ffffffffc02030a0 <vmm_init+0xb6>
ffffffffc0203112:	4491                	li	s1,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203114:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203116:	85a6                	mv	a1,s1
ffffffffc0203118:	8522                	mv	a0,s0
ffffffffc020311a:	dc3ff0ef          	jal	ffffffffc0202edc <find_vma>
        if (vma_below_5 != NULL)
ffffffffc020311e:	1c051c63          	bnez	a0,ffffffffc02032f6 <vmm_init+0x30c>
    for (i = 4; i >= 0; i--)
ffffffffc0203122:	14fd                	addi	s1,s1,-1
ffffffffc0203124:	ff2499e3          	bne	s1,s2,ffffffffc0203116 <vmm_init+0x12c>
    while ((le = list_next(list)) != list)
ffffffffc0203128:	028a8063          	beq	s5,s0,ffffffffc0203148 <vmm_init+0x15e>
    __list_del(listelm->prev, listelm->next);
ffffffffc020312c:	008ab783          	ld	a5,8(s5) # 1008 <kern_entry-0xffffffffc01feff8>
ffffffffc0203130:	000ab703          	ld	a4,0(s5)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203134:	fe0a8513          	addi	a0,s5,-32
    prev->next = next;
ffffffffc0203138:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020313a:	e398                	sd	a4,0(a5)
ffffffffc020313c:	b2bfe0ef          	jal	ffffffffc0201c66 <kfree>
    return listelm->next;
ffffffffc0203140:	641c                	ld	a5,8(s0)
ffffffffc0203142:	8abe                	mv	s5,a5
    while ((le = list_next(list)) != list)
ffffffffc0203144:	fef414e3          	bne	s0,a5,ffffffffc020312c <vmm_init+0x142>
    kfree(mm); // kfree mm
ffffffffc0203148:	8522                	mv	a0,s0
ffffffffc020314a:	b1dfe0ef          	jal	ffffffffc0201c66 <kfree>
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020314e:	00002517          	auipc	a0,0x2
ffffffffc0203152:	56a50513          	addi	a0,a0,1386 # ffffffffc02056b8 <etext+0x1738>
ffffffffc0203156:	83efd0ef          	jal	ffffffffc0200194 <cprintf>
}
ffffffffc020315a:	7442                	ld	s0,48(sp)
ffffffffc020315c:	70e2                	ld	ra,56(sp)
ffffffffc020315e:	74a2                	ld	s1,40(sp)
ffffffffc0203160:	7902                	ld	s2,32(sp)
ffffffffc0203162:	69e2                	ld	s3,24(sp)
ffffffffc0203164:	6a42                	ld	s4,16(sp)
ffffffffc0203166:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203168:	00002517          	auipc	a0,0x2
ffffffffc020316c:	57050513          	addi	a0,a0,1392 # ffffffffc02056d8 <etext+0x1758>
}
ffffffffc0203170:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203172:	822fd06f          	j	ffffffffc0200194 <cprintf>
        assert(vma != NULL);
ffffffffc0203176:	00002697          	auipc	a3,0x2
ffffffffc020317a:	3f268693          	addi	a3,a3,1010 # ffffffffc0205568 <etext+0x15e8>
ffffffffc020317e:	00002617          	auipc	a2,0x2
ffffffffc0203182:	8da60613          	addi	a2,a2,-1830 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203186:	0da00593          	li	a1,218
ffffffffc020318a:	00002517          	auipc	a0,0x2
ffffffffc020318e:	35e50513          	addi	a0,a0,862 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203192:	a74fd0ef          	jal	ffffffffc0200406 <__panic>
    assert(mm != NULL);
ffffffffc0203196:	00002697          	auipc	a3,0x2
ffffffffc020319a:	3c268693          	addi	a3,a3,962 # ffffffffc0205558 <etext+0x15d8>
ffffffffc020319e:	00002617          	auipc	a2,0x2
ffffffffc02031a2:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02031a6:	0d200593          	li	a1,210
ffffffffc02031aa:	00002517          	auipc	a0,0x2
ffffffffc02031ae:	33e50513          	addi	a0,a0,830 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02031b2:	a54fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma != NULL);
ffffffffc02031b6:	00002697          	auipc	a3,0x2
ffffffffc02031ba:	3b268693          	addi	a3,a3,946 # ffffffffc0205568 <etext+0x15e8>
ffffffffc02031be:	00002617          	auipc	a2,0x2
ffffffffc02031c2:	89a60613          	addi	a2,a2,-1894 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02031c6:	0e100593          	li	a1,225
ffffffffc02031ca:	00002517          	auipc	a0,0x2
ffffffffc02031ce:	31e50513          	addi	a0,a0,798 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02031d2:	a34fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02031d6:	00002697          	auipc	a3,0x2
ffffffffc02031da:	3ba68693          	addi	a3,a3,954 # ffffffffc0205590 <etext+0x1610>
ffffffffc02031de:	00002617          	auipc	a2,0x2
ffffffffc02031e2:	87a60613          	addi	a2,a2,-1926 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02031e6:	0eb00593          	li	a1,235
ffffffffc02031ea:	00002517          	auipc	a0,0x2
ffffffffc02031ee:	2fe50513          	addi	a0,a0,766 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02031f2:	a14fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc02031f6:	00002697          	auipc	a3,0x2
ffffffffc02031fa:	45268693          	addi	a3,a3,1106 # ffffffffc0205648 <etext+0x16c8>
ffffffffc02031fe:	00002617          	auipc	a2,0x2
ffffffffc0203202:	85a60613          	addi	a2,a2,-1958 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203206:	0fd00593          	li	a1,253
ffffffffc020320a:	00002517          	auipc	a0,0x2
ffffffffc020320e:	2de50513          	addi	a0,a0,734 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203212:	9f4fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203216:	00002697          	auipc	a3,0x2
ffffffffc020321a:	40268693          	addi	a3,a3,1026 # ffffffffc0205618 <etext+0x1698>
ffffffffc020321e:	00002617          	auipc	a2,0x2
ffffffffc0203222:	83a60613          	addi	a2,a2,-1990 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203226:	0fc00593          	li	a1,252
ffffffffc020322a:	00002517          	auipc	a0,0x2
ffffffffc020322e:	2be50513          	addi	a0,a0,702 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203232:	9d4fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma5 == NULL);
ffffffffc0203236:	00002697          	auipc	a3,0x2
ffffffffc020323a:	3d268693          	addi	a3,a3,978 # ffffffffc0205608 <etext+0x1688>
ffffffffc020323e:	00002617          	auipc	a2,0x2
ffffffffc0203242:	81a60613          	addi	a2,a2,-2022 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203246:	0fa00593          	li	a1,250
ffffffffc020324a:	00002517          	auipc	a0,0x2
ffffffffc020324e:	29e50513          	addi	a0,a0,670 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203252:	9b4fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma4 == NULL);
ffffffffc0203256:	00002697          	auipc	a3,0x2
ffffffffc020325a:	3a268693          	addi	a3,a3,930 # ffffffffc02055f8 <etext+0x1678>
ffffffffc020325e:	00001617          	auipc	a2,0x1
ffffffffc0203262:	7fa60613          	addi	a2,a2,2042 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203266:	0f800593          	li	a1,248
ffffffffc020326a:	00002517          	auipc	a0,0x2
ffffffffc020326e:	27e50513          	addi	a0,a0,638 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203272:	994fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma3 == NULL);
ffffffffc0203276:	00002697          	auipc	a3,0x2
ffffffffc020327a:	37268693          	addi	a3,a3,882 # ffffffffc02055e8 <etext+0x1668>
ffffffffc020327e:	00001617          	auipc	a2,0x1
ffffffffc0203282:	7da60613          	addi	a2,a2,2010 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203286:	0f600593          	li	a1,246
ffffffffc020328a:	00002517          	auipc	a0,0x2
ffffffffc020328e:	25e50513          	addi	a0,a0,606 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203292:	974fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203296:	00002697          	auipc	a3,0x2
ffffffffc020329a:	2e268693          	addi	a3,a3,738 # ffffffffc0205578 <etext+0x15f8>
ffffffffc020329e:	00001617          	auipc	a2,0x1
ffffffffc02032a2:	7ba60613          	addi	a2,a2,1978 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02032a6:	0e900593          	li	a1,233
ffffffffc02032aa:	00002517          	auipc	a0,0x2
ffffffffc02032ae:	23e50513          	addi	a0,a0,574 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02032b2:	954fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma2 != NULL);
ffffffffc02032b6:	00002697          	auipc	a3,0x2
ffffffffc02032ba:	32268693          	addi	a3,a3,802 # ffffffffc02055d8 <etext+0x1658>
ffffffffc02032be:	00001617          	auipc	a2,0x1
ffffffffc02032c2:	79a60613          	addi	a2,a2,1946 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02032c6:	0f400593          	li	a1,244
ffffffffc02032ca:	00002517          	auipc	a0,0x2
ffffffffc02032ce:	21e50513          	addi	a0,a0,542 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02032d2:	934fd0ef          	jal	ffffffffc0200406 <__panic>
        assert(vma1 != NULL);
ffffffffc02032d6:	00002697          	auipc	a3,0x2
ffffffffc02032da:	2f268693          	addi	a3,a3,754 # ffffffffc02055c8 <etext+0x1648>
ffffffffc02032de:	00001617          	auipc	a2,0x1
ffffffffc02032e2:	77a60613          	addi	a2,a2,1914 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02032e6:	0f200593          	li	a1,242
ffffffffc02032ea:	00002517          	auipc	a0,0x2
ffffffffc02032ee:	1fe50513          	addi	a0,a0,510 # ffffffffc02054e8 <etext+0x1568>
ffffffffc02032f2:	914fd0ef          	jal	ffffffffc0200406 <__panic>
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02032f6:	6914                	ld	a3,16(a0)
ffffffffc02032f8:	6510                	ld	a2,8(a0)
ffffffffc02032fa:	0004859b          	sext.w	a1,s1
ffffffffc02032fe:	00002517          	auipc	a0,0x2
ffffffffc0203302:	37a50513          	addi	a0,a0,890 # ffffffffc0205678 <etext+0x16f8>
ffffffffc0203306:	e8ffc0ef          	jal	ffffffffc0200194 <cprintf>
        assert(vma_below_5 == NULL);
ffffffffc020330a:	00002697          	auipc	a3,0x2
ffffffffc020330e:	39668693          	addi	a3,a3,918 # ffffffffc02056a0 <etext+0x1720>
ffffffffc0203312:	00001617          	auipc	a2,0x1
ffffffffc0203316:	74660613          	addi	a2,a2,1862 # ffffffffc0204a58 <etext+0xad8>
ffffffffc020331a:	10700593          	li	a1,263
ffffffffc020331e:	00002517          	auipc	a0,0x2
ffffffffc0203322:	1ca50513          	addi	a0,a0,458 # ffffffffc02054e8 <etext+0x1568>
ffffffffc0203326:	8e0fd0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020332a <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020332a:	8526                	mv	a0,s1
	jalr s0
ffffffffc020332c:	9402                	jalr	s0

	jal do_exit
ffffffffc020332e:	3b0000ef          	jal	ffffffffc02036de <do_exit>

ffffffffc0203332 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203332:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203334:	0e800513          	li	a0,232
{
ffffffffc0203338:	e022                	sd	s0,0(sp)
ffffffffc020333a:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020333c:	885fe0ef          	jal	ffffffffc0201bc0 <kmalloc>
ffffffffc0203340:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203342:	c521                	beqz	a0,ffffffffc020338a <alloc_proc+0x58>
         * struct trapframe *tf;                       // Trap frame for current interrupt
         * uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         * uint32_t flags;                             // Process flag
         * char name[PROC_NAME_LEN + 1];               // Process name
         */
        proc->state = PROC_UNINIT;     
ffffffffc0203344:	57fd                	li	a5,-1
ffffffffc0203346:	1782                	slli	a5,a5,0x20
ffffffffc0203348:	e11c                	sd	a5,0(a0)
        proc->pid = -1;                 
        proc->runs = 0;                 
ffffffffc020334a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;              
ffffffffc020334e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;         
ffffffffc0203352:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;           
ffffffffc0203356:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;             
ffffffffc020335a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context)); 
ffffffffc020335e:	07000613          	li	a2,112
ffffffffc0203362:	4581                	li	a1,0
ffffffffc0203364:	03050513          	addi	a0,a0,48
ffffffffc0203368:	3cb000ef          	jal	ffffffffc0203f32 <memset>
        proc->tf = NULL;               
        
        proc->pgdir = boot_pgdir_pa;    
ffffffffc020336c:	0000a797          	auipc	a5,0xa
ffffffffc0203370:	13c7b783          	ld	a5,316(a5) # ffffffffc020d4a8 <boot_pgdir_pa>
        proc->tf = NULL;               
ffffffffc0203374:	0a043023          	sd	zero,160(s0) # ffffffffc02000a0 <kern_init+0x56>
        
        proc->flags = 0;             
ffffffffc0203378:	0a042823          	sw	zero,176(s0)
        proc->pgdir = boot_pgdir_pa;    
ffffffffc020337c:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1); 
ffffffffc020337e:	0b440513          	addi	a0,s0,180
ffffffffc0203382:	4641                	li	a2,16
ffffffffc0203384:	4581                	li	a1,0
ffffffffc0203386:	3ad000ef          	jal	ffffffffc0203f32 <memset>
        
    }
    return proc;
}
ffffffffc020338a:	60a2                	ld	ra,8(sp)
ffffffffc020338c:	8522                	mv	a0,s0
ffffffffc020338e:	6402                	ld	s0,0(sp)
ffffffffc0203390:	0141                	addi	sp,sp,16
ffffffffc0203392:	8082                	ret

ffffffffc0203394 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203394:	0000a797          	auipc	a5,0xa
ffffffffc0203398:	1447b783          	ld	a5,324(a5) # ffffffffc020d4d8 <current>
ffffffffc020339c:	73c8                	ld	a0,160(a5)
ffffffffc020339e:	aabfd06f          	j	ffffffffc0200e48 <forkrets>

ffffffffc02033a2 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02033a2:	1101                	addi	sp,sp,-32
ffffffffc02033a4:	e822                	sd	s0,16(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02033a6:	0000a417          	auipc	s0,0xa
ffffffffc02033aa:	13243403          	ld	s0,306(s0) # ffffffffc020d4d8 <current>
{
ffffffffc02033ae:	e04a                	sd	s2,0(sp)
    memset(name, 0, sizeof(name));
ffffffffc02033b0:	4641                	li	a2,16
{
ffffffffc02033b2:	892a                	mv	s2,a0
    memset(name, 0, sizeof(name));
ffffffffc02033b4:	4581                	li	a1,0
ffffffffc02033b6:	00006517          	auipc	a0,0x6
ffffffffc02033ba:	09250513          	addi	a0,a0,146 # ffffffffc0209448 <name.2>
{
ffffffffc02033be:	ec06                	sd	ra,24(sp)
ffffffffc02033c0:	e426                	sd	s1,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02033c2:	4044                	lw	s1,4(s0)
    memset(name, 0, sizeof(name));
ffffffffc02033c4:	36f000ef          	jal	ffffffffc0203f32 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02033c8:	0b440593          	addi	a1,s0,180
ffffffffc02033cc:	463d                	li	a2,15
ffffffffc02033ce:	00006517          	auipc	a0,0x6
ffffffffc02033d2:	07a50513          	addi	a0,a0,122 # ffffffffc0209448 <name.2>
ffffffffc02033d6:	36f000ef          	jal	ffffffffc0203f44 <memcpy>
ffffffffc02033da:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02033dc:	85a6                	mv	a1,s1
ffffffffc02033de:	00002517          	auipc	a0,0x2
ffffffffc02033e2:	31250513          	addi	a0,a0,786 # ffffffffc02056f0 <etext+0x1770>
ffffffffc02033e6:	daffc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc02033ea:	85ca                	mv	a1,s2
ffffffffc02033ec:	00002517          	auipc	a0,0x2
ffffffffc02033f0:	32c50513          	addi	a0,a0,812 # ffffffffc0205718 <etext+0x1798>
ffffffffc02033f4:	da1fc0ef          	jal	ffffffffc0200194 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc02033f8:	00002517          	auipc	a0,0x2
ffffffffc02033fc:	33050513          	addi	a0,a0,816 # ffffffffc0205728 <etext+0x17a8>
ffffffffc0203400:	d95fc0ef          	jal	ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0203404:	60e2                	ld	ra,24(sp)
ffffffffc0203406:	6442                	ld	s0,16(sp)
ffffffffc0203408:	64a2                	ld	s1,8(sp)
ffffffffc020340a:	6902                	ld	s2,0(sp)
ffffffffc020340c:	4501                	li	a0,0
ffffffffc020340e:	6105                	addi	sp,sp,32
ffffffffc0203410:	8082                	ret

ffffffffc0203412 <proc_run>:
    if (proc != current)
ffffffffc0203412:	0000a717          	auipc	a4,0xa
ffffffffc0203416:	0c673703          	ld	a4,198(a4) # ffffffffc020d4d8 <current>
ffffffffc020341a:	04a70563          	beq	a4,a0,ffffffffc0203464 <proc_run+0x52>
{
ffffffffc020341e:	1101                	addi	sp,sp,-32
ffffffffc0203420:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203422:	100027f3          	csrr	a5,sstatus
ffffffffc0203426:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203428:	4681                	li	a3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020342a:	ef95                	bnez	a5,ffffffffc0203466 <proc_run+0x54>
            lsatp(current->pgdir); 
ffffffffc020342c:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc020342e:	80000637          	lui	a2,0x80000
ffffffffc0203432:	e036                	sd	a3,0(sp)
ffffffffc0203434:	00c7d79b          	srliw	a5,a5,0xc
            current = proc;
ffffffffc0203438:	0000a597          	auipc	a1,0xa
ffffffffc020343c:	0aa5b023          	sd	a0,160(a1) # ffffffffc020d4d8 <current>
ffffffffc0203440:	8fd1                	or	a5,a5,a2
ffffffffc0203442:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(current->context));
ffffffffc0203446:	03050593          	addi	a1,a0,48
ffffffffc020344a:	03070513          	addi	a0,a4,48
ffffffffc020344e:	51e000ef          	jal	ffffffffc020396c <switch_to>
    if (flag) {
ffffffffc0203452:	6682                	ld	a3,0(sp)
ffffffffc0203454:	e681                	bnez	a3,ffffffffc020345c <proc_run+0x4a>
}
ffffffffc0203456:	60e2                	ld	ra,24(sp)
ffffffffc0203458:	6105                	addi	sp,sp,32
ffffffffc020345a:	8082                	ret
ffffffffc020345c:	60e2                	ld	ra,24(sp)
ffffffffc020345e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203460:	c0efd06f          	j	ffffffffc020086e <intr_enable>
ffffffffc0203464:	8082                	ret
ffffffffc0203466:	e42a                	sd	a0,8(sp)
ffffffffc0203468:	e03a                	sd	a4,0(sp)
        intr_disable();
ffffffffc020346a:	c0afd0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc020346e:	6522                	ld	a0,8(sp)
ffffffffc0203470:	6702                	ld	a4,0(sp)
ffffffffc0203472:	4685                	li	a3,1
ffffffffc0203474:	bf65                	j	ffffffffc020342c <proc_run+0x1a>

ffffffffc0203476 <do_fork>:
    if (nr_process >= MAX_PROCESS)
ffffffffc0203476:	0000a717          	auipc	a4,0xa
ffffffffc020347a:	05a72703          	lw	a4,90(a4) # ffffffffc020d4d0 <nr_process>
ffffffffc020347e:	6785                	lui	a5,0x1
ffffffffc0203480:	1cf75963          	bge	a4,a5,ffffffffc0203652 <do_fork+0x1dc>
{
ffffffffc0203484:	1101                	addi	sp,sp,-32
ffffffffc0203486:	e822                	sd	s0,16(sp)
ffffffffc0203488:	e426                	sd	s1,8(sp)
ffffffffc020348a:	e04a                	sd	s2,0(sp)
ffffffffc020348c:	ec06                	sd	ra,24(sp)
ffffffffc020348e:	892e                	mv	s2,a1
ffffffffc0203490:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0203492:	ea1ff0ef          	jal	ffffffffc0203332 <alloc_proc>
ffffffffc0203496:	84aa                	mv	s1,a0
ffffffffc0203498:	1a050b63          	beqz	a0,ffffffffc020364e <do_fork+0x1d8>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020349c:	4509                	li	a0,2
ffffffffc020349e:	8e5fe0ef          	jal	ffffffffc0201d82 <alloc_pages>
    if (page != NULL)
ffffffffc02034a2:	1a050363          	beqz	a0,ffffffffc0203648 <do_fork+0x1d2>
    return page - pages + nbase;
ffffffffc02034a6:	0000a697          	auipc	a3,0xa
ffffffffc02034aa:	0226b683          	ld	a3,34(a3) # ffffffffc020d4c8 <pages>
ffffffffc02034ae:	00002797          	auipc	a5,0x2
ffffffffc02034b2:	72a7b783          	ld	a5,1834(a5) # ffffffffc0205bd8 <nbase>
    return KADDR(page2pa(page));
ffffffffc02034b6:	0000a717          	auipc	a4,0xa
ffffffffc02034ba:	00a73703          	ld	a4,10(a4) # ffffffffc020d4c0 <npage>
    return page - pages + nbase;
ffffffffc02034be:	40d506b3          	sub	a3,a0,a3
ffffffffc02034c2:	8699                	srai	a3,a3,0x6
ffffffffc02034c4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02034c6:	00c69793          	slli	a5,a3,0xc
ffffffffc02034ca:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02034cc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02034ce:	1ae7f463          	bgeu	a5,a4,ffffffffc0203676 <do_fork+0x200>
    assert(current->mm == NULL);
ffffffffc02034d2:	0000a717          	auipc	a4,0xa
ffffffffc02034d6:	00673703          	ld	a4,6(a4) # ffffffffc020d4d8 <current>
ffffffffc02034da:	0000a617          	auipc	a2,0xa
ffffffffc02034de:	fde63603          	ld	a2,-34(a2) # ffffffffc020d4b8 <va_pa_offset>
ffffffffc02034e2:	771c                	ld	a5,40(a4)
ffffffffc02034e4:	96b2                	add	a3,a3,a2
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02034e6:	e894                	sd	a3,16(s1)
    assert(current->mm == NULL);
ffffffffc02034e8:	16079763          	bnez	a5,ffffffffc0203656 <do_fork+0x1e0>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02034ec:	6789                	lui	a5,0x2
ffffffffc02034ee:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02034f2:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02034f4:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02034f6:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc02034f8:	87b6                	mv	a5,a3
ffffffffc02034fa:	12040593          	addi	a1,s0,288
ffffffffc02034fe:	6a08                	ld	a0,16(a2)
ffffffffc0203500:	00063883          	ld	a7,0(a2)
ffffffffc0203504:	00863803          	ld	a6,8(a2)
ffffffffc0203508:	eb88                	sd	a0,16(a5)
ffffffffc020350a:	0117b023          	sd	a7,0(a5)
ffffffffc020350e:	0107b423          	sd	a6,8(a5)
ffffffffc0203512:	6e08                	ld	a0,24(a2)
ffffffffc0203514:	02060613          	addi	a2,a2,32
ffffffffc0203518:	02078793          	addi	a5,a5,32
ffffffffc020351c:	fea7bc23          	sd	a0,-8(a5)
ffffffffc0203520:	fcb61fe3          	bne	a2,a1,ffffffffc02034fe <do_fork+0x88>
    proc->tf->gpr.a0 = 0;
ffffffffc0203524:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203528:	10090263          	beqz	s2,ffffffffc020362c <do_fork+0x1b6>
    if (++last_pid >= MAX_PID)
ffffffffc020352c:	00006517          	auipc	a0,0x6
ffffffffc0203530:	b0052503          	lw	a0,-1280(a0) # ffffffffc020902c <last_pid.1>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203534:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203538:	00000797          	auipc	a5,0x0
ffffffffc020353c:	e5c78793          	addi	a5,a5,-420 # ffffffffc0203394 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc0203540:	2505                	addiw	a0,a0,1
    proc->parent = current; 
ffffffffc0203542:	f098                	sd	a4,32(s1)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203544:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0203546:	fc94                	sd	a3,56(s1)
    if (++last_pid >= MAX_PID)
ffffffffc0203548:	00006717          	auipc	a4,0x6
ffffffffc020354c:	aea72223          	sw	a0,-1308(a4) # ffffffffc020902c <last_pid.1>
ffffffffc0203550:	6789                	lui	a5,0x2
ffffffffc0203552:	0cf55f63          	bge	a0,a5,ffffffffc0203630 <do_fork+0x1ba>
    if (last_pid >= next_safe)
ffffffffc0203556:	00006797          	auipc	a5,0x6
ffffffffc020355a:	ad27a783          	lw	a5,-1326(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc020355e:	0000a417          	auipc	s0,0xa
ffffffffc0203562:	efa40413          	addi	s0,s0,-262 # ffffffffc020d458 <proc_list>
ffffffffc0203566:	06f54563          	blt	a0,a5,ffffffffc02035d0 <do_fork+0x15a>
ffffffffc020356a:	0000a417          	auipc	s0,0xa
ffffffffc020356e:	eee40413          	addi	s0,s0,-274 # ffffffffc020d458 <proc_list>
ffffffffc0203572:	00843883          	ld	a7,8(s0)
        next_safe = MAX_PID;
ffffffffc0203576:	6789                	lui	a5,0x2
ffffffffc0203578:	00006717          	auipc	a4,0x6
ffffffffc020357c:	aaf72823          	sw	a5,-1360(a4) # ffffffffc0209028 <next_safe.0>
ffffffffc0203580:	86aa                	mv	a3,a0
ffffffffc0203582:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0203584:	04888063          	beq	a7,s0,ffffffffc02035c4 <do_fork+0x14e>
ffffffffc0203588:	882e                	mv	a6,a1
ffffffffc020358a:	87c6                	mv	a5,a7
ffffffffc020358c:	6609                	lui	a2,0x2
ffffffffc020358e:	a811                	j	ffffffffc02035a2 <do_fork+0x12c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0203590:	00e6d663          	bge	a3,a4,ffffffffc020359c <do_fork+0x126>
ffffffffc0203594:	00c75463          	bge	a4,a2,ffffffffc020359c <do_fork+0x126>
                next_safe = proc->pid;
ffffffffc0203598:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020359a:	4805                	li	a6,1
ffffffffc020359c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020359e:	00878d63          	beq	a5,s0,ffffffffc02035b8 <do_fork+0x142>
            if (proc->pid == last_pid)
ffffffffc02035a2:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc02035a6:	fed715e3          	bne	a4,a3,ffffffffc0203590 <do_fork+0x11a>
                if (++last_pid >= next_safe)
ffffffffc02035aa:	2685                	addiw	a3,a3,1
ffffffffc02035ac:	08c6d863          	bge	a3,a2,ffffffffc020363c <do_fork+0x1c6>
ffffffffc02035b0:	679c                	ld	a5,8(a5)
ffffffffc02035b2:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc02035b4:	fe8797e3          	bne	a5,s0,ffffffffc02035a2 <do_fork+0x12c>
ffffffffc02035b8:	00080663          	beqz	a6,ffffffffc02035c4 <do_fork+0x14e>
ffffffffc02035bc:	00006797          	auipc	a5,0x6
ffffffffc02035c0:	a6c7a623          	sw	a2,-1428(a5) # ffffffffc0209028 <next_safe.0>
ffffffffc02035c4:	c591                	beqz	a1,ffffffffc02035d0 <do_fork+0x15a>
ffffffffc02035c6:	00006797          	auipc	a5,0x6
ffffffffc02035ca:	a6d7a323          	sw	a3,-1434(a5) # ffffffffc020902c <last_pid.1>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02035ce:	8536                	mv	a0,a3
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02035d0:	45a9                	li	a1,10
    proc->pid = get_pid();  
ffffffffc02035d2:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02035d4:	4c8000ef          	jal	ffffffffc0203a9c <hash32>
ffffffffc02035d8:	02051793          	slli	a5,a0,0x20
ffffffffc02035dc:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02035e0:	00006797          	auipc	a5,0x6
ffffffffc02035e4:	e7878793          	addi	a5,a5,-392 # ffffffffc0209458 <hash_list>
ffffffffc02035e8:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02035ea:	6518                	ld	a4,8(a0)
ffffffffc02035ec:	0d848793          	addi	a5,s1,216
ffffffffc02035f0:	6414                	ld	a3,8(s0)
    prev->next = next->prev = elm;
ffffffffc02035f2:	e31c                	sd	a5,0(a4)
ffffffffc02035f4:	e51c                	sd	a5,8(a0)
    nr_process++;           
ffffffffc02035f6:	0000a797          	auipc	a5,0xa
ffffffffc02035fa:	eda7a783          	lw	a5,-294(a5) # ffffffffc020d4d0 <nr_process>
    elm->next = next;
ffffffffc02035fe:	f0f8                	sd	a4,224(s1)
    elm->prev = prev;
ffffffffc0203600:	ece8                	sd	a0,216(s1)
    list_add(&proc_list, &(proc->list_link)); 
ffffffffc0203602:	0c848713          	addi	a4,s1,200
    prev->next = next->prev = elm;
ffffffffc0203606:	e298                	sd	a4,0(a3)
    wakeup_proc(proc); 
ffffffffc0203608:	8526                	mv	a0,s1
    nr_process++;           
ffffffffc020360a:	2785                	addiw	a5,a5,1
    elm->next = next;
ffffffffc020360c:	e8f4                	sd	a3,208(s1)
    elm->prev = prev;
ffffffffc020360e:	e4e0                	sd	s0,200(s1)
    prev->next = next->prev = elm;
ffffffffc0203610:	e418                	sd	a4,8(s0)
ffffffffc0203612:	0000a717          	auipc	a4,0xa
ffffffffc0203616:	eaf72f23          	sw	a5,-322(a4) # ffffffffc020d4d0 <nr_process>
    wakeup_proc(proc); 
ffffffffc020361a:	3bc000ef          	jal	ffffffffc02039d6 <wakeup_proc>
    ret = proc->pid; // 返回子进程的PID
ffffffffc020361e:	40c8                	lw	a0,4(s1)
}
ffffffffc0203620:	60e2                	ld	ra,24(sp)
ffffffffc0203622:	6442                	ld	s0,16(sp)
ffffffffc0203624:	64a2                	ld	s1,8(sp)
ffffffffc0203626:	6902                	ld	s2,0(sp)
ffffffffc0203628:	6105                	addi	sp,sp,32
ffffffffc020362a:	8082                	ret
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020362c:	8936                	mv	s2,a3
ffffffffc020362e:	bdfd                	j	ffffffffc020352c <do_fork+0xb6>
        last_pid = 1;
ffffffffc0203630:	4505                	li	a0,1
ffffffffc0203632:	00006797          	auipc	a5,0x6
ffffffffc0203636:	9ea7ad23          	sw	a0,-1542(a5) # ffffffffc020902c <last_pid.1>
        goto inside;
ffffffffc020363a:	bf05                	j	ffffffffc020356a <do_fork+0xf4>
                    if (last_pid >= MAX_PID)
ffffffffc020363c:	6789                	lui	a5,0x2
ffffffffc020363e:	00f6c363          	blt	a3,a5,ffffffffc0203644 <do_fork+0x1ce>
                        last_pid = 1;
ffffffffc0203642:	4685                	li	a3,1
                    goto repeat;
ffffffffc0203644:	4585                	li	a1,1
ffffffffc0203646:	bf3d                	j	ffffffffc0203584 <do_fork+0x10e>
    kfree(proc);
ffffffffc0203648:	8526                	mv	a0,s1
ffffffffc020364a:	e1cfe0ef          	jal	ffffffffc0201c66 <kfree>
    ret = -E_NO_MEM;
ffffffffc020364e:	5571                	li	a0,-4
ffffffffc0203650:	bfc1                	j	ffffffffc0203620 <do_fork+0x1aa>
    int ret = -E_NO_FREE_PROC;
ffffffffc0203652:	556d                	li	a0,-5
}
ffffffffc0203654:	8082                	ret
    assert(current->mm == NULL);
ffffffffc0203656:	00002697          	auipc	a3,0x2
ffffffffc020365a:	0f268693          	addi	a3,a3,242 # ffffffffc0205748 <etext+0x17c8>
ffffffffc020365e:	00001617          	auipc	a2,0x1
ffffffffc0203662:	3fa60613          	addi	a2,a2,1018 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203666:	12300593          	li	a1,291
ffffffffc020366a:	00002517          	auipc	a0,0x2
ffffffffc020366e:	0f650513          	addi	a0,a0,246 # ffffffffc0205760 <etext+0x17e0>
ffffffffc0203672:	d95fc0ef          	jal	ffffffffc0200406 <__panic>
ffffffffc0203676:	00001617          	auipc	a2,0x1
ffffffffc020367a:	79260613          	addi	a2,a2,1938 # ffffffffc0204e08 <etext+0xe88>
ffffffffc020367e:	07100593          	li	a1,113
ffffffffc0203682:	00001517          	auipc	a0,0x1
ffffffffc0203686:	7ae50513          	addi	a0,a0,1966 # ffffffffc0204e30 <etext+0xeb0>
ffffffffc020368a:	d7dfc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc020368e <kernel_thread>:
{
ffffffffc020368e:	7129                	addi	sp,sp,-320
ffffffffc0203690:	fa22                	sd	s0,304(sp)
ffffffffc0203692:	f626                	sd	s1,296(sp)
ffffffffc0203694:	f24a                	sd	s2,288(sp)
ffffffffc0203696:	842a                	mv	s0,a0
ffffffffc0203698:	84ae                	mv	s1,a1
ffffffffc020369a:	8932                	mv	s2,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020369c:	850a                	mv	a0,sp
ffffffffc020369e:	12000613          	li	a2,288
ffffffffc02036a2:	4581                	li	a1,0
{
ffffffffc02036a4:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02036a6:	08d000ef          	jal	ffffffffc0203f32 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02036aa:	e0a2                	sd	s0,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02036ac:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02036ae:	100027f3          	csrr	a5,sstatus
ffffffffc02036b2:	edd7f793          	andi	a5,a5,-291
ffffffffc02036b6:	1207e793          	ori	a5,a5,288
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02036ba:	860a                	mv	a2,sp
ffffffffc02036bc:	10096513          	ori	a0,s2,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02036c0:	00000717          	auipc	a4,0x0
ffffffffc02036c4:	c6a70713          	addi	a4,a4,-918 # ffffffffc020332a <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02036c8:	4581                	li	a1,0
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02036ca:	e23e                	sd	a5,256(sp)
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02036cc:	e63a                	sd	a4,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02036ce:	da9ff0ef          	jal	ffffffffc0203476 <do_fork>
}
ffffffffc02036d2:	70f2                	ld	ra,312(sp)
ffffffffc02036d4:	7452                	ld	s0,304(sp)
ffffffffc02036d6:	74b2                	ld	s1,296(sp)
ffffffffc02036d8:	7912                	ld	s2,288(sp)
ffffffffc02036da:	6131                	addi	sp,sp,320
ffffffffc02036dc:	8082                	ret

ffffffffc02036de <do_exit>:
{
ffffffffc02036de:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02036e0:	00002617          	auipc	a2,0x2
ffffffffc02036e4:	09860613          	addi	a2,a2,152 # ffffffffc0205778 <etext+0x17f8>
ffffffffc02036e8:	18700593          	li	a1,391
ffffffffc02036ec:	00002517          	auipc	a0,0x2
ffffffffc02036f0:	07450513          	addi	a0,a0,116 # ffffffffc0205760 <etext+0x17e0>
{
ffffffffc02036f4:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc02036f6:	d11fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc02036fa <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc02036fa:	7179                	addi	sp,sp,-48
ffffffffc02036fc:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc02036fe:	0000a797          	auipc	a5,0xa
ffffffffc0203702:	d5a78793          	addi	a5,a5,-678 # ffffffffc020d458 <proc_list>
ffffffffc0203706:	f406                	sd	ra,40(sp)
ffffffffc0203708:	f022                	sd	s0,32(sp)
ffffffffc020370a:	e84a                	sd	s2,16(sp)
ffffffffc020370c:	e44e                	sd	s3,8(sp)
ffffffffc020370e:	00006497          	auipc	s1,0x6
ffffffffc0203712:	d4a48493          	addi	s1,s1,-694 # ffffffffc0209458 <hash_list>
ffffffffc0203716:	e79c                	sd	a5,8(a5)
ffffffffc0203718:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020371a:	0000a717          	auipc	a4,0xa
ffffffffc020371e:	d3e70713          	addi	a4,a4,-706 # ffffffffc020d458 <proc_list>
ffffffffc0203722:	87a6                	mv	a5,s1
ffffffffc0203724:	e79c                	sd	a5,8(a5)
ffffffffc0203726:	e39c                	sd	a5,0(a5)
ffffffffc0203728:	07c1                	addi	a5,a5,16
ffffffffc020372a:	fee79de3          	bne	a5,a4,ffffffffc0203724 <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc020372e:	c05ff0ef          	jal	ffffffffc0203332 <alloc_proc>
ffffffffc0203732:	0000a917          	auipc	s2,0xa
ffffffffc0203736:	db690913          	addi	s2,s2,-586 # ffffffffc020d4e8 <idleproc>
ffffffffc020373a:	00a93023          	sd	a0,0(s2)
ffffffffc020373e:	1a050263          	beqz	a0,ffffffffc02038e2 <proc_init+0x1e8>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc0203742:	07000513          	li	a0,112
ffffffffc0203746:	c7afe0ef          	jal	ffffffffc0201bc0 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020374a:	07000613          	li	a2,112
ffffffffc020374e:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc0203750:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0203752:	7e0000ef          	jal	ffffffffc0203f32 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc0203756:	00093503          	ld	a0,0(s2)
ffffffffc020375a:	85a2                	mv	a1,s0
ffffffffc020375c:	07000613          	li	a2,112
ffffffffc0203760:	03050513          	addi	a0,a0,48
ffffffffc0203764:	7f8000ef          	jal	ffffffffc0203f5c <memcmp>
ffffffffc0203768:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc020376a:	453d                	li	a0,15
ffffffffc020376c:	c54fe0ef          	jal	ffffffffc0201bc0 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203770:	463d                	li	a2,15
ffffffffc0203772:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc0203774:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203776:	7bc000ef          	jal	ffffffffc0203f32 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc020377a:	00093503          	ld	a0,0(s2)
ffffffffc020377e:	85a2                	mv	a1,s0
ffffffffc0203780:	463d                	li	a2,15
ffffffffc0203782:	0b450513          	addi	a0,a0,180
ffffffffc0203786:	7d6000ef          	jal	ffffffffc0203f5c <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc020378a:	00093783          	ld	a5,0(s2)
ffffffffc020378e:	0000a717          	auipc	a4,0xa
ffffffffc0203792:	d1a73703          	ld	a4,-742(a4) # ffffffffc020d4a8 <boot_pgdir_pa>
ffffffffc0203796:	77d4                	ld	a3,168(a5)
ffffffffc0203798:	0ee68863          	beq	a3,a4,ffffffffc0203888 <proc_init+0x18e>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020379c:	4709                	li	a4,2
ffffffffc020379e:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02037a0:	00003717          	auipc	a4,0x3
ffffffffc02037a4:	86070713          	addi	a4,a4,-1952 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037a8:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02037ac:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02037ae:	4705                	li	a4,1
ffffffffc02037b0:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037b2:	8522                	mv	a0,s0
ffffffffc02037b4:	4641                	li	a2,16
ffffffffc02037b6:	4581                	li	a1,0
ffffffffc02037b8:	77a000ef          	jal	ffffffffc0203f32 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02037bc:	8522                	mv	a0,s0
ffffffffc02037be:	463d                	li	a2,15
ffffffffc02037c0:	00002597          	auipc	a1,0x2
ffffffffc02037c4:	00058593          	mv	a1,a1
ffffffffc02037c8:	77c000ef          	jal	ffffffffc0203f44 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02037cc:	0000a797          	auipc	a5,0xa
ffffffffc02037d0:	d047a783          	lw	a5,-764(a5) # ffffffffc020d4d0 <nr_process>

    current = idleproc;
ffffffffc02037d4:	00093703          	ld	a4,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02037d8:	4601                	li	a2,0
    nr_process++;
ffffffffc02037da:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02037dc:	00002597          	auipc	a1,0x2
ffffffffc02037e0:	fec58593          	addi	a1,a1,-20 # ffffffffc02057c8 <etext+0x1848>
ffffffffc02037e4:	00000517          	auipc	a0,0x0
ffffffffc02037e8:	bbe50513          	addi	a0,a0,-1090 # ffffffffc02033a2 <init_main>
    current = idleproc;
ffffffffc02037ec:	0000a697          	auipc	a3,0xa
ffffffffc02037f0:	cee6b623          	sd	a4,-788(a3) # ffffffffc020d4d8 <current>
    nr_process++;
ffffffffc02037f4:	0000a717          	auipc	a4,0xa
ffffffffc02037f8:	ccf72e23          	sw	a5,-804(a4) # ffffffffc020d4d0 <nr_process>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02037fc:	e93ff0ef          	jal	ffffffffc020368e <kernel_thread>
ffffffffc0203800:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0203802:	0ea05c63          	blez	a0,ffffffffc02038fa <proc_init+0x200>
    if (0 < pid && pid < MAX_PID)
ffffffffc0203806:	6789                	lui	a5,0x2
ffffffffc0203808:	17f9                	addi	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc020380a:	fff5071b          	addiw	a4,a0,-1
ffffffffc020380e:	02e7e463          	bltu	a5,a4,ffffffffc0203836 <proc_init+0x13c>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203812:	45a9                	li	a1,10
ffffffffc0203814:	288000ef          	jal	ffffffffc0203a9c <hash32>
ffffffffc0203818:	02051713          	slli	a4,a0,0x20
ffffffffc020381c:	01c75793          	srli	a5,a4,0x1c
ffffffffc0203820:	00f486b3          	add	a3,s1,a5
ffffffffc0203824:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0203826:	a029                	j	ffffffffc0203830 <proc_init+0x136>
            if (proc->pid == pid)
ffffffffc0203828:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020382c:	0a870863          	beq	a4,s0,ffffffffc02038dc <proc_init+0x1e2>
    return listelm->next;
ffffffffc0203830:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0203832:	fef69be3          	bne	a3,a5,ffffffffc0203828 <proc_init+0x12e>
    return NULL;
ffffffffc0203836:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203838:	0b478413          	addi	s0,a5,180
ffffffffc020383c:	4641                	li	a2,16
ffffffffc020383e:	4581                	li	a1,0
ffffffffc0203840:	8522                	mv	a0,s0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0203842:	0000a717          	auipc	a4,0xa
ffffffffc0203846:	c8f73f23          	sd	a5,-866(a4) # ffffffffc020d4e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020384a:	6e8000ef          	jal	ffffffffc0203f32 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020384e:	8522                	mv	a0,s0
ffffffffc0203850:	463d                	li	a2,15
ffffffffc0203852:	00002597          	auipc	a1,0x2
ffffffffc0203856:	fa658593          	addi	a1,a1,-90 # ffffffffc02057f8 <etext+0x1878>
ffffffffc020385a:	6ea000ef          	jal	ffffffffc0203f44 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020385e:	00093783          	ld	a5,0(s2)
ffffffffc0203862:	cbe1                	beqz	a5,ffffffffc0203932 <proc_init+0x238>
ffffffffc0203864:	43dc                	lw	a5,4(a5)
ffffffffc0203866:	e7f1                	bnez	a5,ffffffffc0203932 <proc_init+0x238>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203868:	0000a797          	auipc	a5,0xa
ffffffffc020386c:	c787b783          	ld	a5,-904(a5) # ffffffffc020d4e0 <initproc>
ffffffffc0203870:	c3cd                	beqz	a5,ffffffffc0203912 <proc_init+0x218>
ffffffffc0203872:	43d8                	lw	a4,4(a5)
ffffffffc0203874:	4785                	li	a5,1
ffffffffc0203876:	08f71e63          	bne	a4,a5,ffffffffc0203912 <proc_init+0x218>
}
ffffffffc020387a:	70a2                	ld	ra,40(sp)
ffffffffc020387c:	7402                	ld	s0,32(sp)
ffffffffc020387e:	64e2                	ld	s1,24(sp)
ffffffffc0203880:	6942                	ld	s2,16(sp)
ffffffffc0203882:	69a2                	ld	s3,8(sp)
ffffffffc0203884:	6145                	addi	sp,sp,48
ffffffffc0203886:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203888:	73d8                	ld	a4,160(a5)
ffffffffc020388a:	f00719e3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc020388e:	f00997e3          	bnez	s3,ffffffffc020379c <proc_init+0xa2>
ffffffffc0203892:	4398                	lw	a4,0(a5)
ffffffffc0203894:	f00714e3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc0203898:	43d4                	lw	a3,4(a5)
ffffffffc020389a:	577d                	li	a4,-1
ffffffffc020389c:	f0e690e3          	bne	a3,a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038a0:	4798                	lw	a4,8(a5)
ffffffffc02038a2:	ee071de3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038a6:	6b98                	ld	a4,16(a5)
ffffffffc02038a8:	ee071ae3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038ac:	4f98                	lw	a4,24(a5)
ffffffffc02038ae:	ee0717e3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038b2:	7398                	ld	a4,32(a5)
ffffffffc02038b4:	ee0714e3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038b8:	7798                	ld	a4,40(a5)
ffffffffc02038ba:	ee0711e3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
ffffffffc02038be:	0b07a703          	lw	a4,176(a5)
ffffffffc02038c2:	8f49                	or	a4,a4,a0
ffffffffc02038c4:	2701                	sext.w	a4,a4
ffffffffc02038c6:	ec071be3          	bnez	a4,ffffffffc020379c <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc02038ca:	00002517          	auipc	a0,0x2
ffffffffc02038ce:	ede50513          	addi	a0,a0,-290 # ffffffffc02057a8 <etext+0x1828>
ffffffffc02038d2:	8c3fc0ef          	jal	ffffffffc0200194 <cprintf>
    idleproc->pid = 0;
ffffffffc02038d6:	00093783          	ld	a5,0(s2)
ffffffffc02038da:	b5c9                	j	ffffffffc020379c <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02038dc:	f2878793          	addi	a5,a5,-216
ffffffffc02038e0:	bfa1                	j	ffffffffc0203838 <proc_init+0x13e>
        panic("cannot alloc idleproc.\n");
ffffffffc02038e2:	00002617          	auipc	a2,0x2
ffffffffc02038e6:	eae60613          	addi	a2,a2,-338 # ffffffffc0205790 <etext+0x1810>
ffffffffc02038ea:	1a200593          	li	a1,418
ffffffffc02038ee:	00002517          	auipc	a0,0x2
ffffffffc02038f2:	e7250513          	addi	a0,a0,-398 # ffffffffc0205760 <etext+0x17e0>
ffffffffc02038f6:	b11fc0ef          	jal	ffffffffc0200406 <__panic>
        panic("create init_main failed.\n");
ffffffffc02038fa:	00002617          	auipc	a2,0x2
ffffffffc02038fe:	ede60613          	addi	a2,a2,-290 # ffffffffc02057d8 <etext+0x1858>
ffffffffc0203902:	1bf00593          	li	a1,447
ffffffffc0203906:	00002517          	auipc	a0,0x2
ffffffffc020390a:	e5a50513          	addi	a0,a0,-422 # ffffffffc0205760 <etext+0x17e0>
ffffffffc020390e:	af9fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203912:	00002697          	auipc	a3,0x2
ffffffffc0203916:	f1668693          	addi	a3,a3,-234 # ffffffffc0205828 <etext+0x18a8>
ffffffffc020391a:	00001617          	auipc	a2,0x1
ffffffffc020391e:	13e60613          	addi	a2,a2,318 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203922:	1c600593          	li	a1,454
ffffffffc0203926:	00002517          	auipc	a0,0x2
ffffffffc020392a:	e3a50513          	addi	a0,a0,-454 # ffffffffc0205760 <etext+0x17e0>
ffffffffc020392e:	ad9fc0ef          	jal	ffffffffc0200406 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0203932:	00002697          	auipc	a3,0x2
ffffffffc0203936:	ece68693          	addi	a3,a3,-306 # ffffffffc0205800 <etext+0x1880>
ffffffffc020393a:	00001617          	auipc	a2,0x1
ffffffffc020393e:	11e60613          	addi	a2,a2,286 # ffffffffc0204a58 <etext+0xad8>
ffffffffc0203942:	1c500593          	li	a1,453
ffffffffc0203946:	00002517          	auipc	a0,0x2
ffffffffc020394a:	e1a50513          	addi	a0,a0,-486 # ffffffffc0205760 <etext+0x17e0>
ffffffffc020394e:	ab9fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203952 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0203952:	1141                	addi	sp,sp,-16
ffffffffc0203954:	e022                	sd	s0,0(sp)
ffffffffc0203956:	e406                	sd	ra,8(sp)
ffffffffc0203958:	0000a417          	auipc	s0,0xa
ffffffffc020395c:	b8040413          	addi	s0,s0,-1152 # ffffffffc020d4d8 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0203960:	6018                	ld	a4,0(s0)
ffffffffc0203962:	4f1c                	lw	a5,24(a4)
ffffffffc0203964:	dffd                	beqz	a5,ffffffffc0203962 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0203966:	0a2000ef          	jal	ffffffffc0203a08 <schedule>
ffffffffc020396a:	bfdd                	j	ffffffffc0203960 <cpu_idle+0xe>

ffffffffc020396c <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc020396c:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203970:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203974:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203976:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203978:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc020397c:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203980:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203984:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203988:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc020398c:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203990:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203994:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203998:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020399c:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02039a0:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02039a4:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02039a8:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02039aa:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02039ac:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02039b0:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02039b4:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02039b8:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02039bc:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02039c0:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02039c4:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02039c8:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02039cc:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02039d0:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02039d4:	8082                	ret

ffffffffc02039d6 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02039d6:	411c                	lw	a5,0(a0)
ffffffffc02039d8:	4705                	li	a4,1
ffffffffc02039da:	37f9                	addiw	a5,a5,-2
ffffffffc02039dc:	00f77563          	bgeu	a4,a5,ffffffffc02039e6 <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02039e0:	4789                	li	a5,2
ffffffffc02039e2:	c11c                	sw	a5,0(a0)
ffffffffc02039e4:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02039e6:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02039e8:	00002697          	auipc	a3,0x2
ffffffffc02039ec:	e6868693          	addi	a3,a3,-408 # ffffffffc0205850 <etext+0x18d0>
ffffffffc02039f0:	00001617          	auipc	a2,0x1
ffffffffc02039f4:	06860613          	addi	a2,a2,104 # ffffffffc0204a58 <etext+0xad8>
ffffffffc02039f8:	45a5                	li	a1,9
ffffffffc02039fa:	00002517          	auipc	a0,0x2
ffffffffc02039fe:	e9650513          	addi	a0,a0,-362 # ffffffffc0205890 <etext+0x1910>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0203a02:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0203a04:	a03fc0ef          	jal	ffffffffc0200406 <__panic>

ffffffffc0203a08 <schedule>:
}

void
schedule(void) {
ffffffffc0203a08:	1101                	addi	sp,sp,-32
ffffffffc0203a0a:	ec06                	sd	ra,24(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203a0c:	100027f3          	csrr	a5,sstatus
ffffffffc0203a10:	8b89                	andi	a5,a5,2
ffffffffc0203a12:	4301                	li	t1,0
ffffffffc0203a14:	e3c1                	bnez	a5,ffffffffc0203a94 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0203a16:	0000a897          	auipc	a7,0xa
ffffffffc0203a1a:	ac28b883          	ld	a7,-1342(a7) # ffffffffc020d4d8 <current>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203a1e:	0000a517          	auipc	a0,0xa
ffffffffc0203a22:	aca53503          	ld	a0,-1334(a0) # ffffffffc020d4e8 <idleproc>
        current->need_resched = 0;
ffffffffc0203a26:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203a2a:	04a88f63          	beq	a7,a0,ffffffffc0203a88 <schedule+0x80>
ffffffffc0203a2e:	0c888693          	addi	a3,a7,200
ffffffffc0203a32:	0000a617          	auipc	a2,0xa
ffffffffc0203a36:	a2660613          	addi	a2,a2,-1498 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc0203a3a:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0203a3c:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203a3e:	4809                	li	a6,2
ffffffffc0203a40:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc0203a42:	00c78863          	beq	a5,a2,ffffffffc0203a52 <schedule+0x4a>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203a46:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0203a4a:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203a4e:	03070363          	beq	a4,a6,ffffffffc0203a74 <schedule+0x6c>
                    break;
                }
            }
        } while (le != last);
ffffffffc0203a52:	fef697e3          	bne	a3,a5,ffffffffc0203a40 <schedule+0x38>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203a56:	ed99                	bnez	a1,ffffffffc0203a74 <schedule+0x6c>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0203a58:	451c                	lw	a5,8(a0)
ffffffffc0203a5a:	2785                	addiw	a5,a5,1
ffffffffc0203a5c:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0203a5e:	00a88663          	beq	a7,a0,ffffffffc0203a6a <schedule+0x62>
ffffffffc0203a62:	e41a                	sd	t1,8(sp)
            proc_run(next);
ffffffffc0203a64:	9afff0ef          	jal	ffffffffc0203412 <proc_run>
ffffffffc0203a68:	6322                	ld	t1,8(sp)
    if (flag) {
ffffffffc0203a6a:	00031b63          	bnez	t1,ffffffffc0203a80 <schedule+0x78>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0203a6e:	60e2                	ld	ra,24(sp)
ffffffffc0203a70:	6105                	addi	sp,sp,32
ffffffffc0203a72:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203a74:	4198                	lw	a4,0(a1)
ffffffffc0203a76:	4789                	li	a5,2
ffffffffc0203a78:	fef710e3          	bne	a4,a5,ffffffffc0203a58 <schedule+0x50>
ffffffffc0203a7c:	852e                	mv	a0,a1
ffffffffc0203a7e:	bfe9                	j	ffffffffc0203a58 <schedule+0x50>
}
ffffffffc0203a80:	60e2                	ld	ra,24(sp)
ffffffffc0203a82:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203a84:	debfc06f          	j	ffffffffc020086e <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203a88:	0000a617          	auipc	a2,0xa
ffffffffc0203a8c:	9d060613          	addi	a2,a2,-1584 # ffffffffc020d458 <proc_list>
ffffffffc0203a90:	86b2                	mv	a3,a2
ffffffffc0203a92:	b765                	j	ffffffffc0203a3a <schedule+0x32>
        intr_disable();
ffffffffc0203a94:	de1fc0ef          	jal	ffffffffc0200874 <intr_disable>
        return 1;
ffffffffc0203a98:	4305                	li	t1,1
ffffffffc0203a9a:	bfb5                	j	ffffffffc0203a16 <schedule+0xe>

ffffffffc0203a9c <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203a9c:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203aa0:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc0203aa2:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0203aa6:	02000513          	li	a0,32
ffffffffc0203aaa:	9d0d                	subw	a0,a0,a1
}
ffffffffc0203aac:	00a7d53b          	srlw	a0,a5,a0
ffffffffc0203ab0:	8082                	ret

ffffffffc0203ab2 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ab2:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203ab4:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ab8:	f022                	sd	s0,32(sp)
ffffffffc0203aba:	ec26                	sd	s1,24(sp)
ffffffffc0203abc:	e84a                	sd	s2,16(sp)
ffffffffc0203abe:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203ac0:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ac4:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203ac6:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203aca:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203ace:	84aa                	mv	s1,a0
ffffffffc0203ad0:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0203ad2:	03067d63          	bgeu	a2,a6,ffffffffc0203b0c <printnum+0x5a>
ffffffffc0203ad6:	e44e                	sd	s3,8(sp)
ffffffffc0203ad8:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203ada:	4785                	li	a5,1
ffffffffc0203adc:	00e7d763          	bge	a5,a4,ffffffffc0203aea <printnum+0x38>
            putch(padc, putdat);
ffffffffc0203ae0:	85ca                	mv	a1,s2
ffffffffc0203ae2:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0203ae4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203ae6:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203ae8:	fc65                	bnez	s0,ffffffffc0203ae0 <printnum+0x2e>
ffffffffc0203aea:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203aec:	00002797          	auipc	a5,0x2
ffffffffc0203af0:	dbc78793          	addi	a5,a5,-580 # ffffffffc02058a8 <etext+0x1928>
ffffffffc0203af4:	97d2                	add	a5,a5,s4
}
ffffffffc0203af6:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203af8:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0203afc:	70a2                	ld	ra,40(sp)
ffffffffc0203afe:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203b00:	85ca                	mv	a1,s2
ffffffffc0203b02:	87a6                	mv	a5,s1
}
ffffffffc0203b04:	6942                	ld	s2,16(sp)
ffffffffc0203b06:	64e2                	ld	s1,24(sp)
ffffffffc0203b08:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203b0a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203b0c:	03065633          	divu	a2,a2,a6
ffffffffc0203b10:	8722                	mv	a4,s0
ffffffffc0203b12:	fa1ff0ef          	jal	ffffffffc0203ab2 <printnum>
ffffffffc0203b16:	bfd9                	j	ffffffffc0203aec <printnum+0x3a>

ffffffffc0203b18 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203b18:	7119                	addi	sp,sp,-128
ffffffffc0203b1a:	f4a6                	sd	s1,104(sp)
ffffffffc0203b1c:	f0ca                	sd	s2,96(sp)
ffffffffc0203b1e:	ecce                	sd	s3,88(sp)
ffffffffc0203b20:	e8d2                	sd	s4,80(sp)
ffffffffc0203b22:	e4d6                	sd	s5,72(sp)
ffffffffc0203b24:	e0da                	sd	s6,64(sp)
ffffffffc0203b26:	f862                	sd	s8,48(sp)
ffffffffc0203b28:	fc86                	sd	ra,120(sp)
ffffffffc0203b2a:	f8a2                	sd	s0,112(sp)
ffffffffc0203b2c:	fc5e                	sd	s7,56(sp)
ffffffffc0203b2e:	f466                	sd	s9,40(sp)
ffffffffc0203b30:	f06a                	sd	s10,32(sp)
ffffffffc0203b32:	ec6e                	sd	s11,24(sp)
ffffffffc0203b34:	84aa                	mv	s1,a0
ffffffffc0203b36:	8c32                	mv	s8,a2
ffffffffc0203b38:	8a36                	mv	s4,a3
ffffffffc0203b3a:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b3c:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b40:	05500b13          	li	s6,85
ffffffffc0203b44:	00002a97          	auipc	s5,0x2
ffffffffc0203b48:	f04a8a93          	addi	s5,s5,-252 # ffffffffc0205a48 <default_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b4c:	000c4503          	lbu	a0,0(s8)
ffffffffc0203b50:	001c0413          	addi	s0,s8,1
ffffffffc0203b54:	01350a63          	beq	a0,s3,ffffffffc0203b68 <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0203b58:	cd0d                	beqz	a0,ffffffffc0203b92 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0203b5a:	85ca                	mv	a1,s2
ffffffffc0203b5c:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b5e:	00044503          	lbu	a0,0(s0)
ffffffffc0203b62:	0405                	addi	s0,s0,1
ffffffffc0203b64:	ff351ae3          	bne	a0,s3,ffffffffc0203b58 <vprintfmt+0x40>
        width = precision = -1;
ffffffffc0203b68:	5cfd                	li	s9,-1
ffffffffc0203b6a:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc0203b6c:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0203b70:	4b81                	li	s7,0
ffffffffc0203b72:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b74:	00044683          	lbu	a3,0(s0)
ffffffffc0203b78:	00140c13          	addi	s8,s0,1
ffffffffc0203b7c:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0203b80:	0ff5f593          	zext.b	a1,a1
ffffffffc0203b84:	02bb6663          	bltu	s6,a1,ffffffffc0203bb0 <vprintfmt+0x98>
ffffffffc0203b88:	058a                	slli	a1,a1,0x2
ffffffffc0203b8a:	95d6                	add	a1,a1,s5
ffffffffc0203b8c:	4198                	lw	a4,0(a1)
ffffffffc0203b8e:	9756                	add	a4,a4,s5
ffffffffc0203b90:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203b92:	70e6                	ld	ra,120(sp)
ffffffffc0203b94:	7446                	ld	s0,112(sp)
ffffffffc0203b96:	74a6                	ld	s1,104(sp)
ffffffffc0203b98:	7906                	ld	s2,96(sp)
ffffffffc0203b9a:	69e6                	ld	s3,88(sp)
ffffffffc0203b9c:	6a46                	ld	s4,80(sp)
ffffffffc0203b9e:	6aa6                	ld	s5,72(sp)
ffffffffc0203ba0:	6b06                	ld	s6,64(sp)
ffffffffc0203ba2:	7be2                	ld	s7,56(sp)
ffffffffc0203ba4:	7c42                	ld	s8,48(sp)
ffffffffc0203ba6:	7ca2                	ld	s9,40(sp)
ffffffffc0203ba8:	7d02                	ld	s10,32(sp)
ffffffffc0203baa:	6de2                	ld	s11,24(sp)
ffffffffc0203bac:	6109                	addi	sp,sp,128
ffffffffc0203bae:	8082                	ret
            putch('%', putdat);
ffffffffc0203bb0:	85ca                	mv	a1,s2
ffffffffc0203bb2:	02500513          	li	a0,37
ffffffffc0203bb6:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203bb8:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203bbc:	02500713          	li	a4,37
ffffffffc0203bc0:	8c22                	mv	s8,s0
ffffffffc0203bc2:	f8e785e3          	beq	a5,a4,ffffffffc0203b4c <vprintfmt+0x34>
ffffffffc0203bc6:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0203bca:	1c7d                	addi	s8,s8,-1
ffffffffc0203bcc:	fee79de3          	bne	a5,a4,ffffffffc0203bc6 <vprintfmt+0xae>
ffffffffc0203bd0:	bfb5                	j	ffffffffc0203b4c <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0203bd2:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0203bd6:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc0203bd8:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0203bdc:	fd06071b          	addiw	a4,a2,-48
ffffffffc0203be0:	24e56a63          	bltu	a0,a4,ffffffffc0203e34 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0203be4:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203be6:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc0203be8:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc0203bec:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203bf0:	0197073b          	addw	a4,a4,s9
ffffffffc0203bf4:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203bf8:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203bfa:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203bfe:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203c00:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0203c04:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc0203c08:	feb570e3          	bgeu	a0,a1,ffffffffc0203be8 <vprintfmt+0xd0>
            if (width < 0)
ffffffffc0203c0c:	f60d54e3          	bgez	s10,ffffffffc0203b74 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0203c10:	8d66                	mv	s10,s9
ffffffffc0203c12:	5cfd                	li	s9,-1
ffffffffc0203c14:	b785                	j	ffffffffc0203b74 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c16:	8db6                	mv	s11,a3
ffffffffc0203c18:	8462                	mv	s0,s8
ffffffffc0203c1a:	bfa9                	j	ffffffffc0203b74 <vprintfmt+0x5c>
ffffffffc0203c1c:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0203c1e:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0203c20:	bf91                	j	ffffffffc0203b74 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0203c22:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c24:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c28:	00f74463          	blt	a4,a5,ffffffffc0203c30 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc0203c2c:	1a078763          	beqz	a5,ffffffffc0203dda <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc0203c30:	000a3603          	ld	a2,0(s4)
ffffffffc0203c34:	46c1                	li	a3,16
ffffffffc0203c36:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203c38:	000d879b          	sext.w	a5,s11
ffffffffc0203c3c:	876a                	mv	a4,s10
ffffffffc0203c3e:	85ca                	mv	a1,s2
ffffffffc0203c40:	8526                	mv	a0,s1
ffffffffc0203c42:	e71ff0ef          	jal	ffffffffc0203ab2 <printnum>
            break;
ffffffffc0203c46:	b719                	j	ffffffffc0203b4c <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0203c48:	000a2503          	lw	a0,0(s4)
ffffffffc0203c4c:	85ca                	mv	a1,s2
ffffffffc0203c4e:	0a21                	addi	s4,s4,8
ffffffffc0203c50:	9482                	jalr	s1
            break;
ffffffffc0203c52:	bded                	j	ffffffffc0203b4c <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203c54:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c56:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c5a:	00f74463          	blt	a4,a5,ffffffffc0203c62 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0203c5e:	16078963          	beqz	a5,ffffffffc0203dd0 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0203c62:	000a3603          	ld	a2,0(s4)
ffffffffc0203c66:	46a9                	li	a3,10
ffffffffc0203c68:	8a2e                	mv	s4,a1
ffffffffc0203c6a:	b7f9                	j	ffffffffc0203c38 <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc0203c6c:	85ca                	mv	a1,s2
ffffffffc0203c6e:	03000513          	li	a0,48
ffffffffc0203c72:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0203c74:	85ca                	mv	a1,s2
ffffffffc0203c76:	07800513          	li	a0,120
ffffffffc0203c7a:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203c7c:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0203c80:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203c82:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203c84:	bf55                	j	ffffffffc0203c38 <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0203c86:	85ca                	mv	a1,s2
ffffffffc0203c88:	02500513          	li	a0,37
ffffffffc0203c8c:	9482                	jalr	s1
            break;
ffffffffc0203c8e:	bd7d                	j	ffffffffc0203b4c <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0203c90:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c94:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0203c96:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc0203c98:	bf95                	j	ffffffffc0203c0c <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc0203c9a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c9c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203ca0:	00f74463          	blt	a4,a5,ffffffffc0203ca8 <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0203ca4:	12078163          	beqz	a5,ffffffffc0203dc6 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc0203ca8:	000a3603          	ld	a2,0(s4)
ffffffffc0203cac:	46a1                	li	a3,8
ffffffffc0203cae:	8a2e                	mv	s4,a1
ffffffffc0203cb0:	b761                	j	ffffffffc0203c38 <vprintfmt+0x120>
            if (width < 0)
ffffffffc0203cb2:	876a                	mv	a4,s10
ffffffffc0203cb4:	000d5363          	bgez	s10,ffffffffc0203cba <vprintfmt+0x1a2>
ffffffffc0203cb8:	4701                	li	a4,0
ffffffffc0203cba:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203cbe:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203cc0:	bd55                	j	ffffffffc0203b74 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0203cc2:	000d841b          	sext.w	s0,s11
ffffffffc0203cc6:	fd340793          	addi	a5,s0,-45
ffffffffc0203cca:	00f037b3          	snez	a5,a5
ffffffffc0203cce:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203cd2:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0203cd6:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203cd8:	008a0793          	addi	a5,s4,8
ffffffffc0203cdc:	e43e                	sd	a5,8(sp)
ffffffffc0203cde:	100d8c63          	beqz	s11,ffffffffc0203df6 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0203ce2:	12071363          	bnez	a4,ffffffffc0203e08 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203ce6:	000dc783          	lbu	a5,0(s11)
ffffffffc0203cea:	0007851b          	sext.w	a0,a5
ffffffffc0203cee:	c78d                	beqz	a5,ffffffffc0203d18 <vprintfmt+0x200>
ffffffffc0203cf0:	0d85                	addi	s11,s11,1
ffffffffc0203cf2:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203cf4:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cf8:	000cc563          	bltz	s9,ffffffffc0203d02 <vprintfmt+0x1ea>
ffffffffc0203cfc:	3cfd                	addiw	s9,s9,-1
ffffffffc0203cfe:	008c8d63          	beq	s9,s0,ffffffffc0203d18 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d02:	020b9663          	bnez	s7,ffffffffc0203d2e <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc0203d06:	85ca                	mv	a1,s2
ffffffffc0203d08:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d0a:	000dc783          	lbu	a5,0(s11)
ffffffffc0203d0e:	0d85                	addi	s11,s11,1
ffffffffc0203d10:	3d7d                	addiw	s10,s10,-1
ffffffffc0203d12:	0007851b          	sext.w	a0,a5
ffffffffc0203d16:	f3ed                	bnez	a5,ffffffffc0203cf8 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc0203d18:	01a05963          	blez	s10,ffffffffc0203d2a <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc0203d1c:	85ca                	mv	a1,s2
ffffffffc0203d1e:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc0203d22:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc0203d24:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc0203d26:	fe0d1be3          	bnez	s10,ffffffffc0203d1c <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203d2a:	6a22                	ld	s4,8(sp)
ffffffffc0203d2c:	b505                	j	ffffffffc0203b4c <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d2e:	3781                	addiw	a5,a5,-32
ffffffffc0203d30:	fcfa7be3          	bgeu	s4,a5,ffffffffc0203d06 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc0203d34:	03f00513          	li	a0,63
ffffffffc0203d38:	85ca                	mv	a1,s2
ffffffffc0203d3a:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d3c:	000dc783          	lbu	a5,0(s11)
ffffffffc0203d40:	0d85                	addi	s11,s11,1
ffffffffc0203d42:	3d7d                	addiw	s10,s10,-1
ffffffffc0203d44:	0007851b          	sext.w	a0,a5
ffffffffc0203d48:	dbe1                	beqz	a5,ffffffffc0203d18 <vprintfmt+0x200>
ffffffffc0203d4a:	fa0cd9e3          	bgez	s9,ffffffffc0203cfc <vprintfmt+0x1e4>
ffffffffc0203d4e:	b7c5                	j	ffffffffc0203d2e <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0203d50:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d54:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0203d56:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203d58:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc0203d5c:	8fb9                	xor	a5,a5,a4
ffffffffc0203d5e:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d62:	02d64563          	blt	a2,a3,ffffffffc0203d8c <vprintfmt+0x274>
ffffffffc0203d66:	00002797          	auipc	a5,0x2
ffffffffc0203d6a:	e3a78793          	addi	a5,a5,-454 # ffffffffc0205ba0 <error_string>
ffffffffc0203d6e:	00369713          	slli	a4,a3,0x3
ffffffffc0203d72:	97ba                	add	a5,a5,a4
ffffffffc0203d74:	639c                	ld	a5,0(a5)
ffffffffc0203d76:	cb99                	beqz	a5,ffffffffc0203d8c <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203d78:	86be                	mv	a3,a5
ffffffffc0203d7a:	00000617          	auipc	a2,0x0
ffffffffc0203d7e:	22e60613          	addi	a2,a2,558 # ffffffffc0203fa8 <etext+0x28>
ffffffffc0203d82:	85ca                	mv	a1,s2
ffffffffc0203d84:	8526                	mv	a0,s1
ffffffffc0203d86:	0d8000ef          	jal	ffffffffc0203e5e <printfmt>
ffffffffc0203d8a:	b3c9                	j	ffffffffc0203b4c <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203d8c:	00002617          	auipc	a2,0x2
ffffffffc0203d90:	b3c60613          	addi	a2,a2,-1220 # ffffffffc02058c8 <etext+0x1948>
ffffffffc0203d94:	85ca                	mv	a1,s2
ffffffffc0203d96:	8526                	mv	a0,s1
ffffffffc0203d98:	0c6000ef          	jal	ffffffffc0203e5e <printfmt>
ffffffffc0203d9c:	bb45                	j	ffffffffc0203b4c <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0203d9e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203da0:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0203da4:	00f74363          	blt	a4,a5,ffffffffc0203daa <vprintfmt+0x292>
    else if (lflag) {
ffffffffc0203da8:	cf81                	beqz	a5,ffffffffc0203dc0 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc0203daa:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203dae:	02044b63          	bltz	s0,ffffffffc0203de4 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0203db2:	8622                	mv	a2,s0
ffffffffc0203db4:	8a5e                	mv	s4,s7
ffffffffc0203db6:	46a9                	li	a3,10
ffffffffc0203db8:	b541                	j	ffffffffc0203c38 <vprintfmt+0x120>
            lflag ++;
ffffffffc0203dba:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203dbc:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0203dbe:	bb5d                	j	ffffffffc0203b74 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0203dc0:	000a2403          	lw	s0,0(s4)
ffffffffc0203dc4:	b7ed                	j	ffffffffc0203dae <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0203dc6:	000a6603          	lwu	a2,0(s4)
ffffffffc0203dca:	46a1                	li	a3,8
ffffffffc0203dcc:	8a2e                	mv	s4,a1
ffffffffc0203dce:	b5ad                	j	ffffffffc0203c38 <vprintfmt+0x120>
ffffffffc0203dd0:	000a6603          	lwu	a2,0(s4)
ffffffffc0203dd4:	46a9                	li	a3,10
ffffffffc0203dd6:	8a2e                	mv	s4,a1
ffffffffc0203dd8:	b585                	j	ffffffffc0203c38 <vprintfmt+0x120>
ffffffffc0203dda:	000a6603          	lwu	a2,0(s4)
ffffffffc0203dde:	46c1                	li	a3,16
ffffffffc0203de0:	8a2e                	mv	s4,a1
ffffffffc0203de2:	bd99                	j	ffffffffc0203c38 <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0203de4:	85ca                	mv	a1,s2
ffffffffc0203de6:	02d00513          	li	a0,45
ffffffffc0203dea:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc0203dec:	40800633          	neg	a2,s0
ffffffffc0203df0:	8a5e                	mv	s4,s7
ffffffffc0203df2:	46a9                	li	a3,10
ffffffffc0203df4:	b591                	j	ffffffffc0203c38 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc0203df6:	e329                	bnez	a4,ffffffffc0203e38 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203df8:	02800793          	li	a5,40
ffffffffc0203dfc:	853e                	mv	a0,a5
ffffffffc0203dfe:	00002d97          	auipc	s11,0x2
ffffffffc0203e02:	ac3d8d93          	addi	s11,s11,-1341 # ffffffffc02058c1 <etext+0x1941>
ffffffffc0203e06:	b5f5                	j	ffffffffc0203cf2 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203e08:	85e6                	mv	a1,s9
ffffffffc0203e0a:	856e                	mv	a0,s11
ffffffffc0203e0c:	08a000ef          	jal	ffffffffc0203e96 <strnlen>
ffffffffc0203e10:	40ad0d3b          	subw	s10,s10,a0
ffffffffc0203e14:	01a05863          	blez	s10,ffffffffc0203e24 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc0203e18:	85ca                	mv	a1,s2
ffffffffc0203e1a:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203e1c:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc0203e1e:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203e20:	fe0d1ce3          	bnez	s10,ffffffffc0203e18 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203e24:	000dc783          	lbu	a5,0(s11)
ffffffffc0203e28:	0007851b          	sext.w	a0,a5
ffffffffc0203e2c:	ec0792e3          	bnez	a5,ffffffffc0203cf0 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203e30:	6a22                	ld	s4,8(sp)
ffffffffc0203e32:	bb29                	j	ffffffffc0203b4c <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203e34:	8462                	mv	s0,s8
ffffffffc0203e36:	bbd9                	j	ffffffffc0203c0c <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203e38:	85e6                	mv	a1,s9
ffffffffc0203e3a:	00002517          	auipc	a0,0x2
ffffffffc0203e3e:	a8650513          	addi	a0,a0,-1402 # ffffffffc02058c0 <etext+0x1940>
ffffffffc0203e42:	054000ef          	jal	ffffffffc0203e96 <strnlen>
ffffffffc0203e46:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203e4a:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0203e4e:	00002d97          	auipc	s11,0x2
ffffffffc0203e52:	a72d8d93          	addi	s11,s11,-1422 # ffffffffc02058c0 <etext+0x1940>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203e56:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203e58:	fda040e3          	bgtz	s10,ffffffffc0203e18 <vprintfmt+0x300>
ffffffffc0203e5c:	bd51                	j	ffffffffc0203cf0 <vprintfmt+0x1d8>

ffffffffc0203e5e <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e5e:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203e60:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e64:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e66:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e68:	ec06                	sd	ra,24(sp)
ffffffffc0203e6a:	f83a                	sd	a4,48(sp)
ffffffffc0203e6c:	fc3e                	sd	a5,56(sp)
ffffffffc0203e6e:	e0c2                	sd	a6,64(sp)
ffffffffc0203e70:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203e72:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e74:	ca5ff0ef          	jal	ffffffffc0203b18 <vprintfmt>
}
ffffffffc0203e78:	60e2                	ld	ra,24(sp)
ffffffffc0203e7a:	6161                	addi	sp,sp,80
ffffffffc0203e7c:	8082                	ret

ffffffffc0203e7e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203e7e:	00054783          	lbu	a5,0(a0)
ffffffffc0203e82:	cb81                	beqz	a5,ffffffffc0203e92 <strlen+0x14>
    size_t cnt = 0;
ffffffffc0203e84:	4781                	li	a5,0
        cnt ++;
ffffffffc0203e86:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0203e88:	00f50733          	add	a4,a0,a5
ffffffffc0203e8c:	00074703          	lbu	a4,0(a4)
ffffffffc0203e90:	fb7d                	bnez	a4,ffffffffc0203e86 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0203e92:	853e                	mv	a0,a5
ffffffffc0203e94:	8082                	ret

ffffffffc0203e96 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203e96:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203e98:	e589                	bnez	a1,ffffffffc0203ea2 <strnlen+0xc>
ffffffffc0203e9a:	a811                	j	ffffffffc0203eae <strnlen+0x18>
        cnt ++;
ffffffffc0203e9c:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203e9e:	00f58863          	beq	a1,a5,ffffffffc0203eae <strnlen+0x18>
ffffffffc0203ea2:	00f50733          	add	a4,a0,a5
ffffffffc0203ea6:	00074703          	lbu	a4,0(a4)
ffffffffc0203eaa:	fb6d                	bnez	a4,ffffffffc0203e9c <strnlen+0x6>
ffffffffc0203eac:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203eae:	852e                	mv	a0,a1
ffffffffc0203eb0:	8082                	ret

ffffffffc0203eb2 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203eb2:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203eb4:	0005c703          	lbu	a4,0(a1)
ffffffffc0203eb8:	0585                	addi	a1,a1,1
ffffffffc0203eba:	0785                	addi	a5,a5,1
ffffffffc0203ebc:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203ec0:	fb75                	bnez	a4,ffffffffc0203eb4 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203ec2:	8082                	ret

ffffffffc0203ec4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203ec4:	00054783          	lbu	a5,0(a0)
ffffffffc0203ec8:	e791                	bnez	a5,ffffffffc0203ed4 <strcmp+0x10>
ffffffffc0203eca:	a01d                	j	ffffffffc0203ef0 <strcmp+0x2c>
ffffffffc0203ecc:	00054783          	lbu	a5,0(a0)
ffffffffc0203ed0:	cb99                	beqz	a5,ffffffffc0203ee6 <strcmp+0x22>
ffffffffc0203ed2:	0585                	addi	a1,a1,1
ffffffffc0203ed4:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0203ed8:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203eda:	fef709e3          	beq	a4,a5,ffffffffc0203ecc <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203ede:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203ee2:	9d19                	subw	a0,a0,a4
ffffffffc0203ee4:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203ee6:	0015c703          	lbu	a4,1(a1)
ffffffffc0203eea:	4501                	li	a0,0
}
ffffffffc0203eec:	9d19                	subw	a0,a0,a4
ffffffffc0203eee:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203ef0:	0005c703          	lbu	a4,0(a1)
ffffffffc0203ef4:	4501                	li	a0,0
ffffffffc0203ef6:	b7f5                	j	ffffffffc0203ee2 <strcmp+0x1e>

ffffffffc0203ef8 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203ef8:	ce01                	beqz	a2,ffffffffc0203f10 <strncmp+0x18>
ffffffffc0203efa:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203efe:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203f00:	cb91                	beqz	a5,ffffffffc0203f14 <strncmp+0x1c>
ffffffffc0203f02:	0005c703          	lbu	a4,0(a1)
ffffffffc0203f06:	00f71763          	bne	a4,a5,ffffffffc0203f14 <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc0203f0a:	0505                	addi	a0,a0,1
ffffffffc0203f0c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203f0e:	f675                	bnez	a2,ffffffffc0203efa <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f10:	4501                	li	a0,0
ffffffffc0203f12:	8082                	ret
ffffffffc0203f14:	00054503          	lbu	a0,0(a0)
ffffffffc0203f18:	0005c783          	lbu	a5,0(a1)
ffffffffc0203f1c:	9d1d                	subw	a0,a0,a5
}
ffffffffc0203f1e:	8082                	ret

ffffffffc0203f20 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203f20:	a021                	j	ffffffffc0203f28 <strchr+0x8>
        if (*s == c) {
ffffffffc0203f22:	00f58763          	beq	a1,a5,ffffffffc0203f30 <strchr+0x10>
            return (char *)s;
        }
        s ++;
ffffffffc0203f26:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203f28:	00054783          	lbu	a5,0(a0)
ffffffffc0203f2c:	fbfd                	bnez	a5,ffffffffc0203f22 <strchr+0x2>
    }
    return NULL;
ffffffffc0203f2e:	4501                	li	a0,0
}
ffffffffc0203f30:	8082                	ret

ffffffffc0203f32 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203f32:	ca01                	beqz	a2,ffffffffc0203f42 <memset+0x10>
ffffffffc0203f34:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203f36:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203f38:	0785                	addi	a5,a5,1
ffffffffc0203f3a:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203f3e:	fef61de3          	bne	a2,a5,ffffffffc0203f38 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203f42:	8082                	ret

ffffffffc0203f44 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203f44:	ca19                	beqz	a2,ffffffffc0203f5a <memcpy+0x16>
ffffffffc0203f46:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203f48:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203f4a:	0005c703          	lbu	a4,0(a1)
ffffffffc0203f4e:	0585                	addi	a1,a1,1
ffffffffc0203f50:	0785                	addi	a5,a5,1
ffffffffc0203f52:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203f56:	feb61ae3          	bne	a2,a1,ffffffffc0203f4a <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203f5a:	8082                	ret

ffffffffc0203f5c <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203f5c:	c205                	beqz	a2,ffffffffc0203f7c <memcmp+0x20>
ffffffffc0203f5e:	962a                	add	a2,a2,a0
ffffffffc0203f60:	a019                	j	ffffffffc0203f66 <memcmp+0xa>
ffffffffc0203f62:	00c50d63          	beq	a0,a2,ffffffffc0203f7c <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203f66:	00054783          	lbu	a5,0(a0)
ffffffffc0203f6a:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203f6e:	0505                	addi	a0,a0,1
ffffffffc0203f70:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203f72:	fee788e3          	beq	a5,a4,ffffffffc0203f62 <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203f76:	40e7853b          	subw	a0,a5,a4
ffffffffc0203f7a:	8082                	ret
    }
    return 0;
ffffffffc0203f7c:	4501                	li	a0,0
}
ffffffffc0203f7e:	8082                	ret
