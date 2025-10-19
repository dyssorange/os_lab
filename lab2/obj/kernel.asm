
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
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	0d628293          	addi	t0,t0,214 # ffffffffc02000d6 <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020004a:	1141                	addi	sp,sp,-16 # ffffffffc0205ff0 <bootstack+0x1ff0>
    extern char etext[], edata[], end[];
    cprintf("Special kernel symbols:\n");
ffffffffc020004c:	00002517          	auipc	a0,0x2
ffffffffc0200050:	3a450513          	addi	a0,a0,932 # ffffffffc02023f0 <etext+0x4>
void print_kerninfo(void) {
ffffffffc0200054:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200056:	0f2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", (uintptr_t)kern_init);
ffffffffc020005a:	00000597          	auipc	a1,0x0
ffffffffc020005e:	07c58593          	addi	a1,a1,124 # ffffffffc02000d6 <kern_init>
ffffffffc0200062:	00002517          	auipc	a0,0x2
ffffffffc0200066:	3ae50513          	addi	a0,a0,942 # ffffffffc0202410 <etext+0x24>
ffffffffc020006a:	0de000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc020006e:	00002597          	auipc	a1,0x2
ffffffffc0200072:	37e58593          	addi	a1,a1,894 # ffffffffc02023ec <etext>
ffffffffc0200076:	00002517          	auipc	a0,0x2
ffffffffc020007a:	3ba50513          	addi	a0,a0,954 # ffffffffc0202430 <etext+0x44>
ffffffffc020007e:	0ca000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200082:	00007597          	auipc	a1,0x7
ffffffffc0200086:	f9658593          	addi	a1,a1,-106 # ffffffffc0207018 <free_area>
ffffffffc020008a:	00002517          	auipc	a0,0x2
ffffffffc020008e:	3c650513          	addi	a0,a0,966 # ffffffffc0202450 <etext+0x64>
ffffffffc0200092:	0b6000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc0200096:	00007597          	auipc	a1,0x7
ffffffffc020009a:	0c258593          	addi	a1,a1,194 # ffffffffc0207158 <end>
ffffffffc020009e:	00002517          	auipc	a0,0x2
ffffffffc02000a2:	3d250513          	addi	a0,a0,978 # ffffffffc0202470 <etext+0x84>
ffffffffc02000a6:	0a2000ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - (char*)kern_init + 1023) / 1024);
ffffffffc02000aa:	00000717          	auipc	a4,0x0
ffffffffc02000ae:	02c70713          	addi	a4,a4,44 # ffffffffc02000d6 <kern_init>
ffffffffc02000b2:	00007797          	auipc	a5,0x7
ffffffffc02000b6:	4a578793          	addi	a5,a5,1189 # ffffffffc0207557 <end+0x3ff>
ffffffffc02000ba:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000bc:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02000c0:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000c2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02000c6:	95be                	add	a1,a1,a5
ffffffffc02000c8:	85a9                	srai	a1,a1,0xa
ffffffffc02000ca:	00002517          	auipc	a0,0x2
ffffffffc02000ce:	3c650513          	addi	a0,a0,966 # ffffffffc0202490 <etext+0xa4>
}
ffffffffc02000d2:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02000d4:	a895                	j	ffffffffc0200148 <cprintf>

ffffffffc02000d6 <kern_init>:

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc02000d6:	00007517          	auipc	a0,0x7
ffffffffc02000da:	f4250513          	addi	a0,a0,-190 # ffffffffc0207018 <free_area>
ffffffffc02000de:	00007617          	auipc	a2,0x7
ffffffffc02000e2:	07a60613          	addi	a2,a2,122 # ffffffffc0207158 <end>
int kern_init(void) {
ffffffffc02000e6:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc02000e8:	8e09                	sub	a2,a2,a0
ffffffffc02000ea:	4581                	li	a1,0
int kern_init(void) {
ffffffffc02000ec:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc02000ee:	2ec020ef          	jal	ffffffffc02023da <memset>
    dtb_init();
ffffffffc02000f2:	136000ef          	jal	ffffffffc0200228 <dtb_init>
    cons_init();  // init the console
ffffffffc02000f6:	128000ef          	jal	ffffffffc020021e <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc02000fa:	00003517          	auipc	a0,0x3
ffffffffc02000fe:	17650513          	addi	a0,a0,374 # ffffffffc0203270 <etext+0xe84>
ffffffffc0200102:	07a000ef          	jal	ffffffffc020017c <cputs>

    print_kerninfo();
ffffffffc0200106:	f45ff0ef          	jal	ffffffffc020004a <print_kerninfo>

    // grade_backtrace();
    pmm_init();  // init physical memory management
ffffffffc020010a:	6d3000ef          	jal	ffffffffc0200fdc <pmm_init>

    /* do nothing */
    while (1)
ffffffffc020010e:	a001                	j	ffffffffc020010e <kern_init+0x38>

ffffffffc0200110 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200110:	1101                	addi	sp,sp,-32
ffffffffc0200112:	ec06                	sd	ra,24(sp)
ffffffffc0200114:	e42e                	sd	a1,8(sp)
    cons_putc(c);
ffffffffc0200116:	10a000ef          	jal	ffffffffc0200220 <cons_putc>
    (*cnt) ++;
ffffffffc020011a:	65a2                	ld	a1,8(sp)
}
ffffffffc020011c:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
ffffffffc020011e:	419c                	lw	a5,0(a1)
ffffffffc0200120:	2785                	addiw	a5,a5,1
ffffffffc0200122:	c19c                	sw	a5,0(a1)
}
ffffffffc0200124:	6105                	addi	sp,sp,32
ffffffffc0200126:	8082                	ret

ffffffffc0200128 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200128:	1101                	addi	sp,sp,-32
ffffffffc020012a:	862a                	mv	a2,a0
ffffffffc020012c:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020012e:	00000517          	auipc	a0,0x0
ffffffffc0200132:	fe250513          	addi	a0,a0,-30 # ffffffffc0200110 <cputch>
ffffffffc0200136:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200138:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020013a:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020013c:	68f010ef          	jal	ffffffffc0201fca <vprintfmt>
    return cnt;
}
ffffffffc0200140:	60e2                	ld	ra,24(sp)
ffffffffc0200142:	4532                	lw	a0,12(sp)
ffffffffc0200144:	6105                	addi	sp,sp,32
ffffffffc0200146:	8082                	ret

ffffffffc0200148 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200148:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020014a:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc020014e:	f42e                	sd	a1,40(sp)
ffffffffc0200150:	f832                	sd	a2,48(sp)
ffffffffc0200152:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200154:	862a                	mv	a2,a0
ffffffffc0200156:	004c                	addi	a1,sp,4
ffffffffc0200158:	00000517          	auipc	a0,0x0
ffffffffc020015c:	fb850513          	addi	a0,a0,-72 # ffffffffc0200110 <cputch>
ffffffffc0200160:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc0200162:	ec06                	sd	ra,24(sp)
ffffffffc0200164:	e0ba                	sd	a4,64(sp)
ffffffffc0200166:	e4be                	sd	a5,72(sp)
ffffffffc0200168:	e8c2                	sd	a6,80(sp)
ffffffffc020016a:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
ffffffffc020016c:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
ffffffffc020016e:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200170:	65b010ef          	jal	ffffffffc0201fca <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	4512                	lw	a0,4(sp)
ffffffffc0200178:	6125                	addi	sp,sp,96
ffffffffc020017a:	8082                	ret

ffffffffc020017c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020017c:	1101                	addi	sp,sp,-32
ffffffffc020017e:	e822                	sd	s0,16(sp)
ffffffffc0200180:	ec06                	sd	ra,24(sp)
ffffffffc0200182:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200184:	00054503          	lbu	a0,0(a0)
ffffffffc0200188:	c51d                	beqz	a0,ffffffffc02001b6 <cputs+0x3a>
ffffffffc020018a:	e426                	sd	s1,8(sp)
ffffffffc020018c:	0405                	addi	s0,s0,1
    int cnt = 0;
ffffffffc020018e:	4481                	li	s1,0
    cons_putc(c);
ffffffffc0200190:	090000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200194:	00044503          	lbu	a0,0(s0)
ffffffffc0200198:	0405                	addi	s0,s0,1
ffffffffc020019a:	87a6                	mv	a5,s1
    (*cnt) ++;
ffffffffc020019c:	2485                	addiw	s1,s1,1
    while ((c = *str ++) != '\0') {
ffffffffc020019e:	f96d                	bnez	a0,ffffffffc0200190 <cputs+0x14>
    cons_putc(c);
ffffffffc02001a0:	4529                	li	a0,10
    (*cnt) ++;
ffffffffc02001a2:	0027841b          	addiw	s0,a5,2
ffffffffc02001a6:	64a2                	ld	s1,8(sp)
    cons_putc(c);
ffffffffc02001a8:	078000ef          	jal	ffffffffc0200220 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001ac:	60e2                	ld	ra,24(sp)
ffffffffc02001ae:	8522                	mv	a0,s0
ffffffffc02001b0:	6442                	ld	s0,16(sp)
ffffffffc02001b2:	6105                	addi	sp,sp,32
ffffffffc02001b4:	8082                	ret
    cons_putc(c);
ffffffffc02001b6:	4529                	li	a0,10
ffffffffc02001b8:	068000ef          	jal	ffffffffc0200220 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001bc:	4405                	li	s0,1
}
ffffffffc02001be:	60e2                	ld	ra,24(sp)
ffffffffc02001c0:	8522                	mv	a0,s0
ffffffffc02001c2:	6442                	ld	s0,16(sp)
ffffffffc02001c4:	6105                	addi	sp,sp,32
ffffffffc02001c6:	8082                	ret

ffffffffc02001c8 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001c8:	00007317          	auipc	t1,0x7
ffffffffc02001cc:	f4032303          	lw	t1,-192(t1) # ffffffffc0207108 <is_panic>
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001d0:	715d                	addi	sp,sp,-80
ffffffffc02001d2:	ec06                	sd	ra,24(sp)
ffffffffc02001d4:	f436                	sd	a3,40(sp)
ffffffffc02001d6:	f83a                	sd	a4,48(sp)
ffffffffc02001d8:	fc3e                	sd	a5,56(sp)
ffffffffc02001da:	e0c2                	sd	a6,64(sp)
ffffffffc02001dc:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001de:	00030363          	beqz	t1,ffffffffc02001e4 <__panic+0x1c>
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    while (1) {
ffffffffc02001e2:	a001                	j	ffffffffc02001e2 <__panic+0x1a>
    is_panic = 1;
ffffffffc02001e4:	4705                	li	a4,1
    va_start(ap, fmt);
ffffffffc02001e6:	103c                	addi	a5,sp,40
ffffffffc02001e8:	e822                	sd	s0,16(sp)
ffffffffc02001ea:	8432                	mv	s0,a2
ffffffffc02001ec:	862e                	mv	a2,a1
ffffffffc02001ee:	85aa                	mv	a1,a0
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02001f0:	00002517          	auipc	a0,0x2
ffffffffc02001f4:	2d050513          	addi	a0,a0,720 # ffffffffc02024c0 <etext+0xd4>
    is_panic = 1;
ffffffffc02001f8:	00007697          	auipc	a3,0x7
ffffffffc02001fc:	f0e6a823          	sw	a4,-240(a3) # ffffffffc0207108 <is_panic>
    va_start(ap, fmt);
ffffffffc0200200:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200202:	f47ff0ef          	jal	ffffffffc0200148 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200206:	65a2                	ld	a1,8(sp)
ffffffffc0200208:	8522                	mv	a0,s0
ffffffffc020020a:	f1fff0ef          	jal	ffffffffc0200128 <vcprintf>
    cprintf("\n");
ffffffffc020020e:	00002517          	auipc	a0,0x2
ffffffffc0200212:	2d250513          	addi	a0,a0,722 # ffffffffc02024e0 <etext+0xf4>
ffffffffc0200216:	f33ff0ef          	jal	ffffffffc0200148 <cprintf>
ffffffffc020021a:	6442                	ld	s0,16(sp)
ffffffffc020021c:	b7d9                	j	ffffffffc02001e2 <__panic+0x1a>

ffffffffc020021e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020021e:	8082                	ret

ffffffffc0200220 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200220:	0ff57513          	zext.b	a0,a0
ffffffffc0200224:	10c0206f          	j	ffffffffc0202330 <sbi_console_putchar>

ffffffffc0200228 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200228:	7179                	addi	sp,sp,-48
    cprintf("DTB Init\n");
ffffffffc020022a:	00002517          	auipc	a0,0x2
ffffffffc020022e:	2be50513          	addi	a0,a0,702 # ffffffffc02024e8 <etext+0xfc>
void dtb_init(void) {
ffffffffc0200232:	f406                	sd	ra,40(sp)
ffffffffc0200234:	f022                	sd	s0,32(sp)
    cprintf("DTB Init\n");
ffffffffc0200236:	f13ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020023a:	00007597          	auipc	a1,0x7
ffffffffc020023e:	dc65b583          	ld	a1,-570(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc0200242:	00002517          	auipc	a0,0x2
ffffffffc0200246:	2b650513          	addi	a0,a0,694 # ffffffffc02024f8 <etext+0x10c>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020024a:	00007417          	auipc	s0,0x7
ffffffffc020024e:	dbe40413          	addi	s0,s0,-578 # ffffffffc0207008 <boot_dtb>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200252:	ef7ff0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200256:	600c                	ld	a1,0(s0)
ffffffffc0200258:	00002517          	auipc	a0,0x2
ffffffffc020025c:	2b050513          	addi	a0,a0,688 # ffffffffc0202508 <etext+0x11c>
ffffffffc0200260:	ee9ff0ef          	jal	ffffffffc0200148 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200264:	6018                	ld	a4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200266:	00002517          	auipc	a0,0x2
ffffffffc020026a:	2ba50513          	addi	a0,a0,698 # ffffffffc0202520 <etext+0x134>
    if (boot_dtb == 0) {
ffffffffc020026e:	10070163          	beqz	a4,ffffffffc0200370 <dtb_init+0x148>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200272:	57f5                	li	a5,-3
ffffffffc0200274:	07fa                	slli	a5,a5,0x1e
ffffffffc0200276:	973e                	add	a4,a4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200278:	431c                	lw	a5,0(a4)
    if (magic != 0xd00dfeed) {
ffffffffc020027a:	d00e06b7          	lui	a3,0xd00e0
ffffffffc020027e:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfed8d95>
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200282:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200286:	0187961b          	slliw	a2,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020028a:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020028e:	0ff5f593          	zext.b	a1,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200292:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200296:	05c2                	slli	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200298:	8e49                	or	a2,a2,a0
ffffffffc020029a:	0ff7f793          	zext.b	a5,a5
ffffffffc020029e:	8dd1                	or	a1,a1,a2
ffffffffc02002a0:	07a2                	slli	a5,a5,0x8
ffffffffc02002a2:	8ddd                	or	a1,a1,a5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002a4:	00ff0837          	lui	a6,0xff0
    if (magic != 0xd00dfeed) {
ffffffffc02002a8:	0cd59863          	bne	a1,a3,ffffffffc0200378 <dtb_init+0x150>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02002ac:	4710                	lw	a2,8(a4)
ffffffffc02002ae:	4754                	lw	a3,12(a4)
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02002b0:	e84a                	sd	s2,16(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002b2:	0086541b          	srliw	s0,a2,0x8
ffffffffc02002b6:	0086d79b          	srliw	a5,a3,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ba:	01865e1b          	srliw	t3,a2,0x18
ffffffffc02002be:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002c2:	0186151b          	slliw	a0,a2,0x18
ffffffffc02002c6:	0186959b          	slliw	a1,a3,0x18
ffffffffc02002ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ce:	0106561b          	srliw	a2,a2,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002d2:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002d6:	0106d69b          	srliw	a3,a3,0x10
ffffffffc02002da:	01c56533          	or	a0,a0,t3
ffffffffc02002de:	0115e5b3          	or	a1,a1,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002e2:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002e6:	0ff67613          	zext.b	a2,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02002ea:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02002ee:	0ff6f693          	zext.b	a3,a3
ffffffffc02002f2:	8c49                	or	s0,s0,a0
ffffffffc02002f4:	0622                	slli	a2,a2,0x8
ffffffffc02002f6:	8fcd                	or	a5,a5,a1
ffffffffc02002f8:	06a2                	slli	a3,a3,0x8
ffffffffc02002fa:	8c51                	or	s0,s0,a2
ffffffffc02002fc:	8fd5                	or	a5,a5,a3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02002fe:	1402                	slli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200300:	1782                	slli	a5,a5,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200302:	9001                	srli	s0,s0,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200304:	9381                	srli	a5,a5,0x20
ffffffffc0200306:	ec26                	sd	s1,24(sp)
    int in_memory_node = 0;
ffffffffc0200308:	4301                	li	t1,0
        switch (token) {
ffffffffc020030a:	488d                	li	a7,3
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020030c:	943a                	add	s0,s0,a4
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020030e:	00e78933          	add	s2,a5,a4
        switch (token) {
ffffffffc0200312:	4e05                	li	t3,1
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200314:	4018                	lw	a4,0(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200316:	0087579b          	srliw	a5,a4,0x8
ffffffffc020031a:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020031e:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200322:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200326:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020032a:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020032e:	8ed1                	or	a3,a3,a2
ffffffffc0200330:	0ff77713          	zext.b	a4,a4
ffffffffc0200334:	8fd5                	or	a5,a5,a3
ffffffffc0200336:	0722                	slli	a4,a4,0x8
ffffffffc0200338:	8fd9                	or	a5,a5,a4
        switch (token) {
ffffffffc020033a:	05178763          	beq	a5,a7,ffffffffc0200388 <dtb_init+0x160>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020033e:	0411                	addi	s0,s0,4
        switch (token) {
ffffffffc0200340:	00f8e963          	bltu	a7,a5,ffffffffc0200352 <dtb_init+0x12a>
ffffffffc0200344:	07c78d63          	beq	a5,t3,ffffffffc02003be <dtb_init+0x196>
ffffffffc0200348:	4709                	li	a4,2
ffffffffc020034a:	00e79763          	bne	a5,a4,ffffffffc0200358 <dtb_init+0x130>
ffffffffc020034e:	4301                	li	t1,0
ffffffffc0200350:	b7d1                	j	ffffffffc0200314 <dtb_init+0xec>
ffffffffc0200352:	4711                	li	a4,4
ffffffffc0200354:	fce780e3          	beq	a5,a4,ffffffffc0200314 <dtb_init+0xec>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200358:	00002517          	auipc	a0,0x2
ffffffffc020035c:	29050513          	addi	a0,a0,656 # ffffffffc02025e8 <etext+0x1fc>
ffffffffc0200360:	de9ff0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200364:	64e2                	ld	s1,24(sp)
ffffffffc0200366:	6942                	ld	s2,16(sp)
ffffffffc0200368:	00002517          	auipc	a0,0x2
ffffffffc020036c:	2b850513          	addi	a0,a0,696 # ffffffffc0202620 <etext+0x234>
}
ffffffffc0200370:	7402                	ld	s0,32(sp)
ffffffffc0200372:	70a2                	ld	ra,40(sp)
ffffffffc0200374:	6145                	addi	sp,sp,48
    cprintf("DTB init completed\n");
ffffffffc0200376:	bbc9                	j	ffffffffc0200148 <cprintf>
}
ffffffffc0200378:	7402                	ld	s0,32(sp)
ffffffffc020037a:	70a2                	ld	ra,40(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020037c:	00002517          	auipc	a0,0x2
ffffffffc0200380:	1c450513          	addi	a0,a0,452 # ffffffffc0202540 <etext+0x154>
}
ffffffffc0200384:	6145                	addi	sp,sp,48
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200386:	b3c9                	j	ffffffffc0200148 <cprintf>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200388:	4058                	lw	a4,4(s0)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020038a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020038e:	0187169b          	slliw	a3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200392:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200396:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020039a:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020039e:	0107f7b3          	and	a5,a5,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02003a2:	8ed1                	or	a3,a3,a2
ffffffffc02003a4:	0ff77713          	zext.b	a4,a4
ffffffffc02003a8:	8fd5                	or	a5,a5,a3
ffffffffc02003aa:	0722                	slli	a4,a4,0x8
ffffffffc02003ac:	8fd9                	or	a5,a5,a4
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003ae:	04031463          	bnez	t1,ffffffffc02003f6 <dtb_init+0x1ce>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02003b2:	1782                	slli	a5,a5,0x20
ffffffffc02003b4:	9381                	srli	a5,a5,0x20
ffffffffc02003b6:	043d                	addi	s0,s0,15
ffffffffc02003b8:	943e                	add	s0,s0,a5
ffffffffc02003ba:	9871                	andi	s0,s0,-4
                break;
ffffffffc02003bc:	bfa1                	j	ffffffffc0200314 <dtb_init+0xec>
                int name_len = strlen(name);
ffffffffc02003be:	8522                	mv	a0,s0
ffffffffc02003c0:	e01a                	sd	t1,0(sp)
ffffffffc02003c2:	789010ef          	jal	ffffffffc020234a <strlen>
ffffffffc02003c6:	84aa                	mv	s1,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003c8:	4619                	li	a2,6
ffffffffc02003ca:	8522                	mv	a0,s0
ffffffffc02003cc:	00002597          	auipc	a1,0x2
ffffffffc02003d0:	19c58593          	addi	a1,a1,412 # ffffffffc0202568 <etext+0x17c>
ffffffffc02003d4:	7df010ef          	jal	ffffffffc02023b2 <strncmp>
ffffffffc02003d8:	6302                	ld	t1,0(sp)
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003da:	0411                	addi	s0,s0,4
ffffffffc02003dc:	0004879b          	sext.w	a5,s1
ffffffffc02003e0:	943e                	add	s0,s0,a5
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e2:	00153513          	seqz	a0,a0
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02003e6:	9871                	andi	s0,s0,-4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02003e8:	00a36333          	or	t1,t1,a0
                break;
ffffffffc02003ec:	00ff0837          	lui	a6,0xff0
ffffffffc02003f0:	488d                	li	a7,3
ffffffffc02003f2:	4e05                	li	t3,1
ffffffffc02003f4:	b705                	j	ffffffffc0200314 <dtb_init+0xec>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02003f6:	4418                	lw	a4,8(s0)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02003f8:	00002597          	auipc	a1,0x2
ffffffffc02003fc:	17858593          	addi	a1,a1,376 # ffffffffc0202570 <etext+0x184>
ffffffffc0200400:	e43e                	sd	a5,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200402:	0087551b          	srliw	a0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200406:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020040a:	0187169b          	slliw	a3,a4,0x18
ffffffffc020040e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200412:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200416:	01057533          	and	a0,a0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020041a:	8ed1                	or	a3,a3,a2
ffffffffc020041c:	0ff77713          	zext.b	a4,a4
ffffffffc0200420:	0722                	slli	a4,a4,0x8
ffffffffc0200422:	8d55                	or	a0,a0,a3
ffffffffc0200424:	8d59                	or	a0,a0,a4
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200426:	1502                	slli	a0,a0,0x20
ffffffffc0200428:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020042a:	954a                	add	a0,a0,s2
ffffffffc020042c:	e01a                	sd	t1,0(sp)
ffffffffc020042e:	751010ef          	jal	ffffffffc020237e <strcmp>
ffffffffc0200432:	67a2                	ld	a5,8(sp)
ffffffffc0200434:	473d                	li	a4,15
ffffffffc0200436:	6302                	ld	t1,0(sp)
ffffffffc0200438:	00ff0837          	lui	a6,0xff0
ffffffffc020043c:	488d                	li	a7,3
ffffffffc020043e:	4e05                	li	t3,1
ffffffffc0200440:	f6f779e3          	bgeu	a4,a5,ffffffffc02003b2 <dtb_init+0x18a>
ffffffffc0200444:	f53d                	bnez	a0,ffffffffc02003b2 <dtb_init+0x18a>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200446:	00c43683          	ld	a3,12(s0)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020044a:	01443703          	ld	a4,20(s0)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020044e:	00002517          	auipc	a0,0x2
ffffffffc0200452:	12a50513          	addi	a0,a0,298 # ffffffffc0202578 <etext+0x18c>
           fdt32_to_cpu(x >> 32);
ffffffffc0200456:	4206d793          	srai	a5,a3,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020045a:	0087d31b          	srliw	t1,a5,0x8
ffffffffc020045e:	00871f93          	slli	t6,a4,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200462:	42075893          	srai	a7,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200466:	0187df1b          	srliw	t5,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020046a:	0187959b          	slliw	a1,a5,0x18
ffffffffc020046e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200472:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200476:	420fd613          	srai	a2,t6,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020047a:	0188de9b          	srliw	t4,a7,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020047e:	01037333          	and	t1,t1,a6
ffffffffc0200482:	01889e1b          	slliw	t3,a7,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200486:	01e5e5b3          	or	a1,a1,t5
ffffffffc020048a:	0ff7f793          	zext.b	a5,a5
ffffffffc020048e:	01de6e33          	or	t3,t3,t4
ffffffffc0200492:	0065e5b3          	or	a1,a1,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200496:	01067633          	and	a2,a2,a6
ffffffffc020049a:	0086d31b          	srliw	t1,a3,0x8
ffffffffc020049e:	0087541b          	srliw	s0,a4,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a2:	07a2                	slli	a5,a5,0x8
ffffffffc02004a4:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02004a8:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02004ac:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02004b0:	8ddd                	or	a1,a1,a5
ffffffffc02004b2:	01c66633          	or	a2,a2,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b6:	0186979b          	slliw	a5,a3,0x18
ffffffffc02004ba:	01871e1b          	slliw	t3,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004be:	0ff8f893          	zext.b	a7,a7
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004c2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ca:	0104141b          	slliw	s0,s0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ce:	0107571b          	srliw	a4,a4,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004d2:	01037333          	and	t1,t1,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d6:	08a2                	slli	a7,a7,0x8
ffffffffc02004d8:	01e7e7b3          	or	a5,a5,t5
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004dc:	01047433          	and	s0,s0,a6
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004e0:	0ff6f693          	zext.b	a3,a3
ffffffffc02004e4:	01de6833          	or	a6,t3,t4
ffffffffc02004e8:	0ff77713          	zext.b	a4,a4
ffffffffc02004ec:	01166633          	or	a2,a2,a7
ffffffffc02004f0:	0067e7b3          	or	a5,a5,t1
ffffffffc02004f4:	06a2                	slli	a3,a3,0x8
ffffffffc02004f6:	01046433          	or	s0,s0,a6
ffffffffc02004fa:	0722                	slli	a4,a4,0x8
ffffffffc02004fc:	8fd5                	or	a5,a5,a3
ffffffffc02004fe:	8c59                	or	s0,s0,a4
           fdt32_to_cpu(x >> 32);
ffffffffc0200500:	1582                	slli	a1,a1,0x20
ffffffffc0200502:	1602                	slli	a2,a2,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200504:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200506:	9201                	srli	a2,a2,0x20
ffffffffc0200508:	9181                	srli	a1,a1,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020050a:	1402                	slli	s0,s0,0x20
ffffffffc020050c:	00b7e4b3          	or	s1,a5,a1
ffffffffc0200510:	8c51                	or	s0,s0,a2
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200512:	c37ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200516:	85a6                	mv	a1,s1
ffffffffc0200518:	00002517          	auipc	a0,0x2
ffffffffc020051c:	08050513          	addi	a0,a0,128 # ffffffffc0202598 <etext+0x1ac>
ffffffffc0200520:	c29ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200524:	01445613          	srli	a2,s0,0x14
ffffffffc0200528:	85a2                	mv	a1,s0
ffffffffc020052a:	00002517          	auipc	a0,0x2
ffffffffc020052e:	08650513          	addi	a0,a0,134 # ffffffffc02025b0 <etext+0x1c4>
ffffffffc0200532:	c17ff0ef          	jal	ffffffffc0200148 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200536:	009405b3          	add	a1,s0,s1
ffffffffc020053a:	15fd                	addi	a1,a1,-1
ffffffffc020053c:	00002517          	auipc	a0,0x2
ffffffffc0200540:	09450513          	addi	a0,a0,148 # ffffffffc02025d0 <etext+0x1e4>
ffffffffc0200544:	c05ff0ef          	jal	ffffffffc0200148 <cprintf>
        memory_base = mem_base;
ffffffffc0200548:	00007797          	auipc	a5,0x7
ffffffffc020054c:	bc97b823          	sd	s1,-1072(a5) # ffffffffc0207118 <memory_base>
        memory_size = mem_size;
ffffffffc0200550:	00007797          	auipc	a5,0x7
ffffffffc0200554:	bc87b023          	sd	s0,-1088(a5) # ffffffffc0207110 <memory_size>
ffffffffc0200558:	b531                	j	ffffffffc0200364 <dtb_init+0x13c>

ffffffffc020055a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020055a:	00007517          	auipc	a0,0x7
ffffffffc020055e:	bbe53503          	ld	a0,-1090(a0) # ffffffffc0207118 <memory_base>
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200564:	00007517          	auipc	a0,0x7
ffffffffc0200568:	bac53503          	ld	a0,-1108(a0) # ffffffffc0207110 <memory_size>
ffffffffc020056c:	8082                	ret

ffffffffc020056e <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc020056e:	00007797          	auipc	a5,0x7
ffffffffc0200572:	aaa78793          	addi	a5,a5,-1366 # ffffffffc0207018 <free_area>
ffffffffc0200576:	e79c                	sd	a5,8(a5)
ffffffffc0200578:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc020057a:	0007a823          	sw	zero,16(a5)
}
ffffffffc020057e:	8082                	ret

ffffffffc0200580 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200580:	00007517          	auipc	a0,0x7
ffffffffc0200584:	aa856503          	lwu	a0,-1368(a0) # ffffffffc0207028 <free_area+0x10>
ffffffffc0200588:	8082                	ret

ffffffffc020058a <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc020058a:	c145                	beqz	a0,ffffffffc020062a <best_fit_alloc_pages+0xa0>
    if (n > nr_free) {
ffffffffc020058c:	00007817          	auipc	a6,0x7
ffffffffc0200590:	a9c82803          	lw	a6,-1380(a6) # ffffffffc0207028 <free_area+0x10>
ffffffffc0200594:	86aa                	mv	a3,a0
ffffffffc0200596:	00007617          	auipc	a2,0x7
ffffffffc020059a:	a8260613          	addi	a2,a2,-1406 # ffffffffc0207018 <free_area>
ffffffffc020059e:	02081793          	slli	a5,a6,0x20
ffffffffc02005a2:	9381                	srli	a5,a5,0x20
ffffffffc02005a4:	08a7e163          	bltu	a5,a0,ffffffffc0200626 <best_fit_alloc_pages+0x9c>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc02005a8:	661c                	ld	a5,8(a2)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02005aa:	06c78e63          	beq	a5,a2,ffffffffc0200626 <best_fit_alloc_pages+0x9c>
    size_t min_size = nr_free + 1;
ffffffffc02005ae:	0018059b          	addiw	a1,a6,1
ffffffffc02005b2:	1582                	slli	a1,a1,0x20
ffffffffc02005b4:	9181                	srli	a1,a1,0x20
    struct Page *page = NULL;
ffffffffc02005b6:	4501                	li	a0,0
        if (p->property >= n && p->property < min_size) {
ffffffffc02005b8:	ff87e703          	lwu	a4,-8(a5)
ffffffffc02005bc:	00d76763          	bltu	a4,a3,ffffffffc02005ca <best_fit_alloc_pages+0x40>
ffffffffc02005c0:	00b77563          	bgeu	a4,a1,ffffffffc02005ca <best_fit_alloc_pages+0x40>
            min_size = p->property;
ffffffffc02005c4:	85ba                	mv	a1,a4
        struct Page *p = le2page(le, page_link);
ffffffffc02005c6:	fe878513          	addi	a0,a5,-24
ffffffffc02005ca:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02005cc:	fec796e3          	bne	a5,a2,ffffffffc02005b8 <best_fit_alloc_pages+0x2e>
    if (page != NULL) {
ffffffffc02005d0:	cd21                	beqz	a0,ffffffffc0200628 <best_fit_alloc_pages+0x9e>
        if (page->property > n) {
ffffffffc02005d2:	01052883          	lw	a7,16(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc02005d6:	6d18                	ld	a4,24(a0)
    __list_del(listelm->prev, listelm->next);
ffffffffc02005d8:	710c                	ld	a1,32(a0)
ffffffffc02005da:	02089793          	slli	a5,a7,0x20
ffffffffc02005de:	9381                	srli	a5,a5,0x20
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02005e0:	e70c                	sd	a1,8(a4)
    next->prev = prev;
ffffffffc02005e2:	e198                	sd	a4,0(a1)
ffffffffc02005e4:	02f6f963          	bgeu	a3,a5,ffffffffc0200616 <best_fit_alloc_pages+0x8c>
            struct Page *p = page + n;
ffffffffc02005e8:	00269793          	slli	a5,a3,0x2
ffffffffc02005ec:	97b6                	add	a5,a5,a3
ffffffffc02005ee:	078e                	slli	a5,a5,0x3
ffffffffc02005f0:	97aa                	add	a5,a5,a0
            SetPageProperty(p);
ffffffffc02005f2:	0087b303          	ld	t1,8(a5)
            p->property = page->property - n;
ffffffffc02005f6:	40d888bb          	subw	a7,a7,a3
ffffffffc02005fa:	0117a823          	sw	a7,16(a5)
            SetPageProperty(p);
ffffffffc02005fe:	00236893          	ori	a7,t1,2
ffffffffc0200602:	0117b423          	sd	a7,8(a5)
            list_add(prev, &(p->page_link));
ffffffffc0200606:	01878893          	addi	a7,a5,24
    prev->next = next->prev = elm;
ffffffffc020060a:	0115b023          	sd	a7,0(a1)
ffffffffc020060e:	01173423          	sd	a7,8(a4)
    elm->next = next;
ffffffffc0200612:	f38c                	sd	a1,32(a5)
    elm->prev = prev;
ffffffffc0200614:	ef98                	sd	a4,24(a5)
        ClearPageProperty(page);
ffffffffc0200616:	651c                	ld	a5,8(a0)
        nr_free -= n;
ffffffffc0200618:	40d8083b          	subw	a6,a6,a3
ffffffffc020061c:	01062823          	sw	a6,16(a2)
        ClearPageProperty(page);
ffffffffc0200620:	9bf5                	andi	a5,a5,-3
ffffffffc0200622:	e51c                	sd	a5,8(a0)
ffffffffc0200624:	8082                	ret
        return NULL;
ffffffffc0200626:	4501                	li	a0,0
}
ffffffffc0200628:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc020062a:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020062c:	00002697          	auipc	a3,0x2
ffffffffc0200630:	00c68693          	addi	a3,a3,12 # ffffffffc0202638 <etext+0x24c>
ffffffffc0200634:	00002617          	auipc	a2,0x2
ffffffffc0200638:	00c60613          	addi	a2,a2,12 # ffffffffc0202640 <etext+0x254>
ffffffffc020063c:	07200593          	li	a1,114
ffffffffc0200640:	00002517          	auipc	a0,0x2
ffffffffc0200644:	01850513          	addi	a0,a0,24 # ffffffffc0202658 <etext+0x26c>
best_fit_alloc_pages(size_t n) {
ffffffffc0200648:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020064a:	b7fff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc020064e <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc020064e:	711d                	addi	sp,sp,-96
ffffffffc0200650:	e0ca                	sd	s2,64(sp)
    return listelm->next;
ffffffffc0200652:	00007917          	auipc	s2,0x7
ffffffffc0200656:	9c690913          	addi	s2,s2,-1594 # ffffffffc0207018 <free_area>
ffffffffc020065a:	00893783          	ld	a5,8(s2)
ffffffffc020065e:	ec86                	sd	ra,88(sp)
ffffffffc0200660:	e8a2                	sd	s0,80(sp)
ffffffffc0200662:	e4a6                	sd	s1,72(sp)
ffffffffc0200664:	fc4e                	sd	s3,56(sp)
ffffffffc0200666:	f852                	sd	s4,48(sp)
ffffffffc0200668:	f456                	sd	s5,40(sp)
ffffffffc020066a:	f05a                	sd	s6,32(sp)
ffffffffc020066c:	ec5e                	sd	s7,24(sp)
ffffffffc020066e:	e862                	sd	s8,16(sp)
ffffffffc0200670:	e466                	sd	s9,8(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200672:	2b278f63          	beq	a5,s2,ffffffffc0200930 <best_fit_check+0x2e2>
    int count = 0, total = 0;
ffffffffc0200676:	4401                	li	s0,0
ffffffffc0200678:	4481                	li	s1,0
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc020067a:	ff07b703          	ld	a4,-16(a5)
ffffffffc020067e:	8b09                	andi	a4,a4,2
ffffffffc0200680:	2a070c63          	beqz	a4,ffffffffc0200938 <best_fit_check+0x2ea>
        count ++, total += p->property;
ffffffffc0200684:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200688:	679c                	ld	a5,8(a5)
ffffffffc020068a:	2485                	addiw	s1,s1,1
ffffffffc020068c:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020068e:	ff2796e3          	bne	a5,s2,ffffffffc020067a <best_fit_check+0x2c>
    }
    assert(total == nr_free_pages());
ffffffffc0200692:	89a2                	mv	s3,s0
ffffffffc0200694:	13d000ef          	jal	ffffffffc0200fd0 <nr_free_pages>
ffffffffc0200698:	39351063          	bne	a0,s3,ffffffffc0200a18 <best_fit_check+0x3ca>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020069c:	4505                	li	a0,1
ffffffffc020069e:	11b000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02006a2:	8aaa                	mv	s5,a0
ffffffffc02006a4:	3a050a63          	beqz	a0,ffffffffc0200a58 <best_fit_check+0x40a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02006a8:	4505                	li	a0,1
ffffffffc02006aa:	10f000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02006ae:	89aa                	mv	s3,a0
ffffffffc02006b0:	38050463          	beqz	a0,ffffffffc0200a38 <best_fit_check+0x3ea>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02006b4:	4505                	li	a0,1
ffffffffc02006b6:	103000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02006ba:	8a2a                	mv	s4,a0
ffffffffc02006bc:	30050e63          	beqz	a0,ffffffffc02009d8 <best_fit_check+0x38a>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02006c0:	40aa87b3          	sub	a5,s5,a0
ffffffffc02006c4:	40a98733          	sub	a4,s3,a0
ffffffffc02006c8:	0017b793          	seqz	a5,a5
ffffffffc02006cc:	00173713          	seqz	a4,a4
ffffffffc02006d0:	8fd9                	or	a5,a5,a4
ffffffffc02006d2:	2e079363          	bnez	a5,ffffffffc02009b8 <best_fit_check+0x36a>
ffffffffc02006d6:	2f3a8163          	beq	s5,s3,ffffffffc02009b8 <best_fit_check+0x36a>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02006da:	000aa783          	lw	a5,0(s5)
ffffffffc02006de:	26079d63          	bnez	a5,ffffffffc0200958 <best_fit_check+0x30a>
ffffffffc02006e2:	0009a783          	lw	a5,0(s3)
ffffffffc02006e6:	26079963          	bnez	a5,ffffffffc0200958 <best_fit_check+0x30a>
ffffffffc02006ea:	411c                	lw	a5,0(a0)
ffffffffc02006ec:	26079663          	bnez	a5,ffffffffc0200958 <best_fit_check+0x30a>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02006f0:	00007797          	auipc	a5,0x7
ffffffffc02006f4:	a587b783          	ld	a5,-1448(a5) # ffffffffc0207148 <pages>
ffffffffc02006f8:	ccccd737          	lui	a4,0xccccd
ffffffffc02006fc:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac5b75>
ffffffffc0200700:	02071693          	slli	a3,a4,0x20
ffffffffc0200704:	96ba                	add	a3,a3,a4
ffffffffc0200706:	40fa8733          	sub	a4,s5,a5
ffffffffc020070a:	870d                	srai	a4,a4,0x3
ffffffffc020070c:	02d70733          	mul	a4,a4,a3
ffffffffc0200710:	00003517          	auipc	a0,0x3
ffffffffc0200714:	d8053503          	ld	a0,-640(a0) # ffffffffc0203490 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200718:	00007697          	auipc	a3,0x7
ffffffffc020071c:	a286b683          	ld	a3,-1496(a3) # ffffffffc0207140 <npage>
ffffffffc0200720:	06b2                	slli	a3,a3,0xc
ffffffffc0200722:	972a                	add	a4,a4,a0

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200724:	0732                	slli	a4,a4,0xc
ffffffffc0200726:	26d77963          	bgeu	a4,a3,ffffffffc0200998 <best_fit_check+0x34a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020072a:	ccccd5b7          	lui	a1,0xccccd
ffffffffc020072e:	ccd58593          	addi	a1,a1,-819 # ffffffffcccccccd <end+0xcac5b75>
ffffffffc0200732:	02059613          	slli	a2,a1,0x20
ffffffffc0200736:	40f98733          	sub	a4,s3,a5
ffffffffc020073a:	962e                	add	a2,a2,a1
ffffffffc020073c:	870d                	srai	a4,a4,0x3
ffffffffc020073e:	02c70733          	mul	a4,a4,a2
ffffffffc0200742:	972a                	add	a4,a4,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200744:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200746:	40d77963          	bgeu	a4,a3,ffffffffc0200b58 <best_fit_check+0x50a>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020074a:	40fa07b3          	sub	a5,s4,a5
ffffffffc020074e:	878d                	srai	a5,a5,0x3
ffffffffc0200750:	02c787b3          	mul	a5,a5,a2
ffffffffc0200754:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200756:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200758:	3ed7f063          	bgeu	a5,a3,ffffffffc0200b38 <best_fit_check+0x4ea>
    assert(alloc_page() == NULL);
ffffffffc020075c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020075e:	00093c03          	ld	s8,0(s2)
ffffffffc0200762:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200766:	00007b17          	auipc	s6,0x7
ffffffffc020076a:	8c2b2b03          	lw	s6,-1854(s6) # ffffffffc0207028 <free_area+0x10>
    elm->prev = elm->next = elm;
ffffffffc020076e:	01293023          	sd	s2,0(s2)
ffffffffc0200772:	01293423          	sd	s2,8(s2)
    nr_free = 0;
ffffffffc0200776:	00007797          	auipc	a5,0x7
ffffffffc020077a:	8a07a923          	sw	zero,-1870(a5) # ffffffffc0207028 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc020077e:	03b000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc0200782:	38051b63          	bnez	a0,ffffffffc0200b18 <best_fit_check+0x4ca>
    free_page(p0);
ffffffffc0200786:	8556                	mv	a0,s5
ffffffffc0200788:	4585                	li	a1,1
ffffffffc020078a:	03b000ef          	jal	ffffffffc0200fc4 <free_pages>
    free_page(p1);
ffffffffc020078e:	854e                	mv	a0,s3
ffffffffc0200790:	4585                	li	a1,1
ffffffffc0200792:	033000ef          	jal	ffffffffc0200fc4 <free_pages>
    free_page(p2);
ffffffffc0200796:	8552                	mv	a0,s4
ffffffffc0200798:	4585                	li	a1,1
ffffffffc020079a:	02b000ef          	jal	ffffffffc0200fc4 <free_pages>
    assert(nr_free == 3);
ffffffffc020079e:	00007717          	auipc	a4,0x7
ffffffffc02007a2:	88a72703          	lw	a4,-1910(a4) # ffffffffc0207028 <free_area+0x10>
ffffffffc02007a6:	478d                	li	a5,3
ffffffffc02007a8:	34f71863          	bne	a4,a5,ffffffffc0200af8 <best_fit_check+0x4aa>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02007ac:	4505                	li	a0,1
ffffffffc02007ae:	00b000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007b2:	89aa                	mv	s3,a0
ffffffffc02007b4:	32050263          	beqz	a0,ffffffffc0200ad8 <best_fit_check+0x48a>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02007b8:	4505                	li	a0,1
ffffffffc02007ba:	7fe000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007be:	8aaa                	mv	s5,a0
ffffffffc02007c0:	2e050c63          	beqz	a0,ffffffffc0200ab8 <best_fit_check+0x46a>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02007c4:	4505                	li	a0,1
ffffffffc02007c6:	7f2000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007ca:	8a2a                	mv	s4,a0
ffffffffc02007cc:	2c050663          	beqz	a0,ffffffffc0200a98 <best_fit_check+0x44a>
    assert(alloc_page() == NULL);
ffffffffc02007d0:	4505                	li	a0,1
ffffffffc02007d2:	7e6000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007d6:	2a051163          	bnez	a0,ffffffffc0200a78 <best_fit_check+0x42a>
    free_page(p0);
ffffffffc02007da:	4585                	li	a1,1
ffffffffc02007dc:	854e                	mv	a0,s3
ffffffffc02007de:	7e6000ef          	jal	ffffffffc0200fc4 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02007e2:	00893783          	ld	a5,8(s2)
ffffffffc02007e6:	19278963          	beq	a5,s2,ffffffffc0200978 <best_fit_check+0x32a>
    assert((p = alloc_page()) == p0);
ffffffffc02007ea:	4505                	li	a0,1
ffffffffc02007ec:	7cc000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007f0:	8caa                	mv	s9,a0
ffffffffc02007f2:	54a99363          	bne	s3,a0,ffffffffc0200d38 <best_fit_check+0x6ea>
    assert(alloc_page() == NULL);
ffffffffc02007f6:	4505                	li	a0,1
ffffffffc02007f8:	7c0000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02007fc:	50051e63          	bnez	a0,ffffffffc0200d18 <best_fit_check+0x6ca>
    assert(nr_free == 0);
ffffffffc0200800:	00007797          	auipc	a5,0x7
ffffffffc0200804:	8287a783          	lw	a5,-2008(a5) # ffffffffc0207028 <free_area+0x10>
ffffffffc0200808:	4e079863          	bnez	a5,ffffffffc0200cf8 <best_fit_check+0x6aa>
    free_page(p);
ffffffffc020080c:	8566                	mv	a0,s9
ffffffffc020080e:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200810:	01893023          	sd	s8,0(s2)
ffffffffc0200814:	01793423          	sd	s7,8(s2)
    nr_free = nr_free_store;
ffffffffc0200818:	01692823          	sw	s6,16(s2)
    free_page(p);
ffffffffc020081c:	7a8000ef          	jal	ffffffffc0200fc4 <free_pages>
    free_page(p1);
ffffffffc0200820:	8556                	mv	a0,s5
ffffffffc0200822:	4585                	li	a1,1
ffffffffc0200824:	7a0000ef          	jal	ffffffffc0200fc4 <free_pages>
    free_page(p2);
ffffffffc0200828:	8552                	mv	a0,s4
ffffffffc020082a:	4585                	li	a1,1
ffffffffc020082c:	798000ef          	jal	ffffffffc0200fc4 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200830:	4515                	li	a0,5
ffffffffc0200832:	786000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc0200836:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200838:	4a050063          	beqz	a0,ffffffffc0200cd8 <best_fit_check+0x68a>
    assert(!PageProperty(p0));
ffffffffc020083c:	651c                	ld	a5,8(a0)
ffffffffc020083e:	8b89                	andi	a5,a5,2
ffffffffc0200840:	46079c63          	bnez	a5,ffffffffc0200cb8 <best_fit_check+0x66a>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200844:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200846:	00093b83          	ld	s7,0(s2)
ffffffffc020084a:	00893b03          	ld	s6,8(s2)
ffffffffc020084e:	01293023          	sd	s2,0(s2)
ffffffffc0200852:	01293423          	sd	s2,8(s2)
    assert(alloc_page() == NULL);
ffffffffc0200856:	762000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc020085a:	42051f63          	bnez	a0,ffffffffc0200c98 <best_fit_check+0x64a>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc020085e:	4589                	li	a1,2
ffffffffc0200860:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200864:	00006c17          	auipc	s8,0x6
ffffffffc0200868:	7c4c2c03          	lw	s8,1988(s8) # ffffffffc0207028 <free_area+0x10>
    free_pages(p0 + 4, 1);
ffffffffc020086c:	0a098a93          	addi	s5,s3,160
    nr_free = 0;
ffffffffc0200870:	00006797          	auipc	a5,0x6
ffffffffc0200874:	7a07ac23          	sw	zero,1976(a5) # ffffffffc0207028 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200878:	74c000ef          	jal	ffffffffc0200fc4 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc020087c:	8556                	mv	a0,s5
ffffffffc020087e:	4585                	li	a1,1
ffffffffc0200880:	744000ef          	jal	ffffffffc0200fc4 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200884:	4511                	li	a0,4
ffffffffc0200886:	732000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc020088a:	3e051763          	bnez	a0,ffffffffc0200c78 <best_fit_check+0x62a>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc020088e:	0309b783          	ld	a5,48(s3)
ffffffffc0200892:	8b89                	andi	a5,a5,2
ffffffffc0200894:	3c078263          	beqz	a5,ffffffffc0200c58 <best_fit_check+0x60a>
ffffffffc0200898:	0389ac83          	lw	s9,56(s3)
ffffffffc020089c:	4789                	li	a5,2
ffffffffc020089e:	3afc9d63          	bne	s9,a5,ffffffffc0200c58 <best_fit_check+0x60a>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc02008a2:	4505                	li	a0,1
ffffffffc02008a4:	714000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02008a8:	8a2a                	mv	s4,a0
ffffffffc02008aa:	38050763          	beqz	a0,ffffffffc0200c38 <best_fit_check+0x5ea>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc02008ae:	8566                	mv	a0,s9
ffffffffc02008b0:	708000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02008b4:	36050263          	beqz	a0,ffffffffc0200c18 <best_fit_check+0x5ca>
    assert(p0 + 4 == p1);
ffffffffc02008b8:	354a9063          	bne	s5,s4,ffffffffc0200bf8 <best_fit_check+0x5aa>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc02008bc:	854e                	mv	a0,s3
ffffffffc02008be:	4595                	li	a1,5
ffffffffc02008c0:	704000ef          	jal	ffffffffc0200fc4 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02008c4:	4515                	li	a0,5
ffffffffc02008c6:	6f2000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02008ca:	89aa                	mv	s3,a0
ffffffffc02008cc:	30050663          	beqz	a0,ffffffffc0200bd8 <best_fit_check+0x58a>
    assert(alloc_page() == NULL);
ffffffffc02008d0:	4505                	li	a0,1
ffffffffc02008d2:	6e6000ef          	jal	ffffffffc0200fb8 <alloc_pages>
ffffffffc02008d6:	2e051163          	bnez	a0,ffffffffc0200bb8 <best_fit_check+0x56a>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc02008da:	00006797          	auipc	a5,0x6
ffffffffc02008de:	74e7a783          	lw	a5,1870(a5) # ffffffffc0207028 <free_area+0x10>
ffffffffc02008e2:	2a079b63          	bnez	a5,ffffffffc0200b98 <best_fit_check+0x54a>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02008e6:	854e                	mv	a0,s3
ffffffffc02008e8:	4595                	li	a1,5
    nr_free = nr_free_store;
ffffffffc02008ea:	01892823          	sw	s8,16(s2)
    free_list = free_list_store;
ffffffffc02008ee:	01793023          	sd	s7,0(s2)
ffffffffc02008f2:	01693423          	sd	s6,8(s2)
    free_pages(p0, 5);
ffffffffc02008f6:	6ce000ef          	jal	ffffffffc0200fc4 <free_pages>
    return listelm->next;
ffffffffc02008fa:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc02008fe:	01278963          	beq	a5,s2,ffffffffc0200910 <best_fit_check+0x2c2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200902:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200906:	679c                	ld	a5,8(a5)
ffffffffc0200908:	34fd                	addiw	s1,s1,-1
ffffffffc020090a:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020090c:	ff279be3          	bne	a5,s2,ffffffffc0200902 <best_fit_check+0x2b4>
    }
    assert(count == 0);
ffffffffc0200910:	26049463          	bnez	s1,ffffffffc0200b78 <best_fit_check+0x52a>
    assert(total == 0);
ffffffffc0200914:	e075                	bnez	s0,ffffffffc02009f8 <best_fit_check+0x3aa>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200916:	60e6                	ld	ra,88(sp)
ffffffffc0200918:	6446                	ld	s0,80(sp)
ffffffffc020091a:	64a6                	ld	s1,72(sp)
ffffffffc020091c:	6906                	ld	s2,64(sp)
ffffffffc020091e:	79e2                	ld	s3,56(sp)
ffffffffc0200920:	7a42                	ld	s4,48(sp)
ffffffffc0200922:	7aa2                	ld	s5,40(sp)
ffffffffc0200924:	7b02                	ld	s6,32(sp)
ffffffffc0200926:	6be2                	ld	s7,24(sp)
ffffffffc0200928:	6c42                	ld	s8,16(sp)
ffffffffc020092a:	6ca2                	ld	s9,8(sp)
ffffffffc020092c:	6125                	addi	sp,sp,96
ffffffffc020092e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200930:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200932:	4401                	li	s0,0
ffffffffc0200934:	4481                	li	s1,0
ffffffffc0200936:	bbb9                	j	ffffffffc0200694 <best_fit_check+0x46>
        assert(PageProperty(p));
ffffffffc0200938:	00002697          	auipc	a3,0x2
ffffffffc020093c:	d3868693          	addi	a3,a3,-712 # ffffffffc0202670 <etext+0x284>
ffffffffc0200940:	00002617          	auipc	a2,0x2
ffffffffc0200944:	d0060613          	addi	a2,a2,-768 # ffffffffc0202640 <etext+0x254>
ffffffffc0200948:	11400593          	li	a1,276
ffffffffc020094c:	00002517          	auipc	a0,0x2
ffffffffc0200950:	d0c50513          	addi	a0,a0,-756 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200954:	875ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200958:	00002697          	auipc	a3,0x2
ffffffffc020095c:	dd068693          	addi	a3,a3,-560 # ffffffffc0202728 <etext+0x33c>
ffffffffc0200960:	00002617          	auipc	a2,0x2
ffffffffc0200964:	ce060613          	addi	a2,a2,-800 # ffffffffc0202640 <etext+0x254>
ffffffffc0200968:	0e100593          	li	a1,225
ffffffffc020096c:	00002517          	auipc	a0,0x2
ffffffffc0200970:	cec50513          	addi	a0,a0,-788 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200974:	855ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200978:	00002697          	auipc	a3,0x2
ffffffffc020097c:	e7868693          	addi	a3,a3,-392 # ffffffffc02027f0 <etext+0x404>
ffffffffc0200980:	00002617          	auipc	a2,0x2
ffffffffc0200984:	cc060613          	addi	a2,a2,-832 # ffffffffc0202640 <etext+0x254>
ffffffffc0200988:	0fc00593          	li	a1,252
ffffffffc020098c:	00002517          	auipc	a0,0x2
ffffffffc0200990:	ccc50513          	addi	a0,a0,-820 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200994:	835ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200998:	00002697          	auipc	a3,0x2
ffffffffc020099c:	dd068693          	addi	a3,a3,-560 # ffffffffc0202768 <etext+0x37c>
ffffffffc02009a0:	00002617          	auipc	a2,0x2
ffffffffc02009a4:	ca060613          	addi	a2,a2,-864 # ffffffffc0202640 <etext+0x254>
ffffffffc02009a8:	0e300593          	li	a1,227
ffffffffc02009ac:	00002517          	auipc	a0,0x2
ffffffffc02009b0:	cac50513          	addi	a0,a0,-852 # ffffffffc0202658 <etext+0x26c>
ffffffffc02009b4:	815ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02009b8:	00002697          	auipc	a3,0x2
ffffffffc02009bc:	d4868693          	addi	a3,a3,-696 # ffffffffc0202700 <etext+0x314>
ffffffffc02009c0:	00002617          	auipc	a2,0x2
ffffffffc02009c4:	c8060613          	addi	a2,a2,-896 # ffffffffc0202640 <etext+0x254>
ffffffffc02009c8:	0e000593          	li	a1,224
ffffffffc02009cc:	00002517          	auipc	a0,0x2
ffffffffc02009d0:	c8c50513          	addi	a0,a0,-884 # ffffffffc0202658 <etext+0x26c>
ffffffffc02009d4:	ff4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02009d8:	00002697          	auipc	a3,0x2
ffffffffc02009dc:	d0868693          	addi	a3,a3,-760 # ffffffffc02026e0 <etext+0x2f4>
ffffffffc02009e0:	00002617          	auipc	a2,0x2
ffffffffc02009e4:	c6060613          	addi	a2,a2,-928 # ffffffffc0202640 <etext+0x254>
ffffffffc02009e8:	0de00593          	li	a1,222
ffffffffc02009ec:	00002517          	auipc	a0,0x2
ffffffffc02009f0:	c6c50513          	addi	a0,a0,-916 # ffffffffc0202658 <etext+0x26c>
ffffffffc02009f4:	fd4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(total == 0);
ffffffffc02009f8:	00002697          	auipc	a3,0x2
ffffffffc02009fc:	f2868693          	addi	a3,a3,-216 # ffffffffc0202920 <etext+0x534>
ffffffffc0200a00:	00002617          	auipc	a2,0x2
ffffffffc0200a04:	c4060613          	addi	a2,a2,-960 # ffffffffc0202640 <etext+0x254>
ffffffffc0200a08:	15600593          	li	a1,342
ffffffffc0200a0c:	00002517          	auipc	a0,0x2
ffffffffc0200a10:	c4c50513          	addi	a0,a0,-948 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200a14:	fb4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(total == nr_free_pages());
ffffffffc0200a18:	00002697          	auipc	a3,0x2
ffffffffc0200a1c:	c6868693          	addi	a3,a3,-920 # ffffffffc0202680 <etext+0x294>
ffffffffc0200a20:	00002617          	auipc	a2,0x2
ffffffffc0200a24:	c2060613          	addi	a2,a2,-992 # ffffffffc0202640 <etext+0x254>
ffffffffc0200a28:	11700593          	li	a1,279
ffffffffc0200a2c:	00002517          	auipc	a0,0x2
ffffffffc0200a30:	c2c50513          	addi	a0,a0,-980 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200a34:	f94ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200a38:	00002697          	auipc	a3,0x2
ffffffffc0200a3c:	c8868693          	addi	a3,a3,-888 # ffffffffc02026c0 <etext+0x2d4>
ffffffffc0200a40:	00002617          	auipc	a2,0x2
ffffffffc0200a44:	c0060613          	addi	a2,a2,-1024 # ffffffffc0202640 <etext+0x254>
ffffffffc0200a48:	0dd00593          	li	a1,221
ffffffffc0200a4c:	00002517          	auipc	a0,0x2
ffffffffc0200a50:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200a54:	f74ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200a58:	00002697          	auipc	a3,0x2
ffffffffc0200a5c:	c4868693          	addi	a3,a3,-952 # ffffffffc02026a0 <etext+0x2b4>
ffffffffc0200a60:	00002617          	auipc	a2,0x2
ffffffffc0200a64:	be060613          	addi	a2,a2,-1056 # ffffffffc0202640 <etext+0x254>
ffffffffc0200a68:	0dc00593          	li	a1,220
ffffffffc0200a6c:	00002517          	auipc	a0,0x2
ffffffffc0200a70:	bec50513          	addi	a0,a0,-1044 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200a74:	f54ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200a78:	00002697          	auipc	a3,0x2
ffffffffc0200a7c:	d5068693          	addi	a3,a3,-688 # ffffffffc02027c8 <etext+0x3dc>
ffffffffc0200a80:	00002617          	auipc	a2,0x2
ffffffffc0200a84:	bc060613          	addi	a2,a2,-1088 # ffffffffc0202640 <etext+0x254>
ffffffffc0200a88:	0f900593          	li	a1,249
ffffffffc0200a8c:	00002517          	auipc	a0,0x2
ffffffffc0200a90:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200a94:	f34ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200a98:	00002697          	auipc	a3,0x2
ffffffffc0200a9c:	c4868693          	addi	a3,a3,-952 # ffffffffc02026e0 <etext+0x2f4>
ffffffffc0200aa0:	00002617          	auipc	a2,0x2
ffffffffc0200aa4:	ba060613          	addi	a2,a2,-1120 # ffffffffc0202640 <etext+0x254>
ffffffffc0200aa8:	0f700593          	li	a1,247
ffffffffc0200aac:	00002517          	auipc	a0,0x2
ffffffffc0200ab0:	bac50513          	addi	a0,a0,-1108 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200ab4:	f14ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ab8:	00002697          	auipc	a3,0x2
ffffffffc0200abc:	c0868693          	addi	a3,a3,-1016 # ffffffffc02026c0 <etext+0x2d4>
ffffffffc0200ac0:	00002617          	auipc	a2,0x2
ffffffffc0200ac4:	b8060613          	addi	a2,a2,-1152 # ffffffffc0202640 <etext+0x254>
ffffffffc0200ac8:	0f600593          	li	a1,246
ffffffffc0200acc:	00002517          	auipc	a0,0x2
ffffffffc0200ad0:	b8c50513          	addi	a0,a0,-1140 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200ad4:	ef4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ad8:	00002697          	auipc	a3,0x2
ffffffffc0200adc:	bc868693          	addi	a3,a3,-1080 # ffffffffc02026a0 <etext+0x2b4>
ffffffffc0200ae0:	00002617          	auipc	a2,0x2
ffffffffc0200ae4:	b6060613          	addi	a2,a2,-1184 # ffffffffc0202640 <etext+0x254>
ffffffffc0200ae8:	0f500593          	li	a1,245
ffffffffc0200aec:	00002517          	auipc	a0,0x2
ffffffffc0200af0:	b6c50513          	addi	a0,a0,-1172 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200af4:	ed4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 3);
ffffffffc0200af8:	00002697          	auipc	a3,0x2
ffffffffc0200afc:	ce868693          	addi	a3,a3,-792 # ffffffffc02027e0 <etext+0x3f4>
ffffffffc0200b00:	00002617          	auipc	a2,0x2
ffffffffc0200b04:	b4060613          	addi	a2,a2,-1216 # ffffffffc0202640 <etext+0x254>
ffffffffc0200b08:	0f300593          	li	a1,243
ffffffffc0200b0c:	00002517          	auipc	a0,0x2
ffffffffc0200b10:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200b14:	eb4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200b18:	00002697          	auipc	a3,0x2
ffffffffc0200b1c:	cb068693          	addi	a3,a3,-848 # ffffffffc02027c8 <etext+0x3dc>
ffffffffc0200b20:	00002617          	auipc	a2,0x2
ffffffffc0200b24:	b2060613          	addi	a2,a2,-1248 # ffffffffc0202640 <etext+0x254>
ffffffffc0200b28:	0ee00593          	li	a1,238
ffffffffc0200b2c:	00002517          	auipc	a0,0x2
ffffffffc0200b30:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200b34:	e94ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200b38:	00002697          	auipc	a3,0x2
ffffffffc0200b3c:	c7068693          	addi	a3,a3,-912 # ffffffffc02027a8 <etext+0x3bc>
ffffffffc0200b40:	00002617          	auipc	a2,0x2
ffffffffc0200b44:	b0060613          	addi	a2,a2,-1280 # ffffffffc0202640 <etext+0x254>
ffffffffc0200b48:	0e500593          	li	a1,229
ffffffffc0200b4c:	00002517          	auipc	a0,0x2
ffffffffc0200b50:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200b54:	e74ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200b58:	00002697          	auipc	a3,0x2
ffffffffc0200b5c:	c3068693          	addi	a3,a3,-976 # ffffffffc0202788 <etext+0x39c>
ffffffffc0200b60:	00002617          	auipc	a2,0x2
ffffffffc0200b64:	ae060613          	addi	a2,a2,-1312 # ffffffffc0202640 <etext+0x254>
ffffffffc0200b68:	0e400593          	li	a1,228
ffffffffc0200b6c:	00002517          	auipc	a0,0x2
ffffffffc0200b70:	aec50513          	addi	a0,a0,-1300 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200b74:	e54ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(count == 0);
ffffffffc0200b78:	00002697          	auipc	a3,0x2
ffffffffc0200b7c:	d9868693          	addi	a3,a3,-616 # ffffffffc0202910 <etext+0x524>
ffffffffc0200b80:	00002617          	auipc	a2,0x2
ffffffffc0200b84:	ac060613          	addi	a2,a2,-1344 # ffffffffc0202640 <etext+0x254>
ffffffffc0200b88:	15500593          	li	a1,341
ffffffffc0200b8c:	00002517          	auipc	a0,0x2
ffffffffc0200b90:	acc50513          	addi	a0,a0,-1332 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200b94:	e34ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 0);
ffffffffc0200b98:	00002697          	auipc	a3,0x2
ffffffffc0200b9c:	c9068693          	addi	a3,a3,-880 # ffffffffc0202828 <etext+0x43c>
ffffffffc0200ba0:	00002617          	auipc	a2,0x2
ffffffffc0200ba4:	aa060613          	addi	a2,a2,-1376 # ffffffffc0202640 <etext+0x254>
ffffffffc0200ba8:	14a00593          	li	a1,330
ffffffffc0200bac:	00002517          	auipc	a0,0x2
ffffffffc0200bb0:	aac50513          	addi	a0,a0,-1364 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200bb4:	e14ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200bb8:	00002697          	auipc	a3,0x2
ffffffffc0200bbc:	c1068693          	addi	a3,a3,-1008 # ffffffffc02027c8 <etext+0x3dc>
ffffffffc0200bc0:	00002617          	auipc	a2,0x2
ffffffffc0200bc4:	a8060613          	addi	a2,a2,-1408 # ffffffffc0202640 <etext+0x254>
ffffffffc0200bc8:	14400593          	li	a1,324
ffffffffc0200bcc:	00002517          	auipc	a0,0x2
ffffffffc0200bd0:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200bd4:	df4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200bd8:	00002697          	auipc	a3,0x2
ffffffffc0200bdc:	d1868693          	addi	a3,a3,-744 # ffffffffc02028f0 <etext+0x504>
ffffffffc0200be0:	00002617          	auipc	a2,0x2
ffffffffc0200be4:	a6060613          	addi	a2,a2,-1440 # ffffffffc0202640 <etext+0x254>
ffffffffc0200be8:	14300593          	li	a1,323
ffffffffc0200bec:	00002517          	auipc	a0,0x2
ffffffffc0200bf0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200bf4:	dd4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 + 4 == p1);
ffffffffc0200bf8:	00002697          	auipc	a3,0x2
ffffffffc0200bfc:	ce868693          	addi	a3,a3,-792 # ffffffffc02028e0 <etext+0x4f4>
ffffffffc0200c00:	00002617          	auipc	a2,0x2
ffffffffc0200c04:	a4060613          	addi	a2,a2,-1472 # ffffffffc0202640 <etext+0x254>
ffffffffc0200c08:	13b00593          	li	a1,315
ffffffffc0200c0c:	00002517          	auipc	a0,0x2
ffffffffc0200c10:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200c14:	db4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200c18:	00002697          	auipc	a3,0x2
ffffffffc0200c1c:	cb068693          	addi	a3,a3,-848 # ffffffffc02028c8 <etext+0x4dc>
ffffffffc0200c20:	00002617          	auipc	a2,0x2
ffffffffc0200c24:	a2060613          	addi	a2,a2,-1504 # ffffffffc0202640 <etext+0x254>
ffffffffc0200c28:	13a00593          	li	a1,314
ffffffffc0200c2c:	00002517          	auipc	a0,0x2
ffffffffc0200c30:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200c34:	d94ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200c38:	00002697          	auipc	a3,0x2
ffffffffc0200c3c:	c7068693          	addi	a3,a3,-912 # ffffffffc02028a8 <etext+0x4bc>
ffffffffc0200c40:	00002617          	auipc	a2,0x2
ffffffffc0200c44:	a0060613          	addi	a2,a2,-1536 # ffffffffc0202640 <etext+0x254>
ffffffffc0200c48:	13900593          	li	a1,313
ffffffffc0200c4c:	00002517          	auipc	a0,0x2
ffffffffc0200c50:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200c54:	d74ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200c58:	00002697          	auipc	a3,0x2
ffffffffc0200c5c:	c2068693          	addi	a3,a3,-992 # ffffffffc0202878 <etext+0x48c>
ffffffffc0200c60:	00002617          	auipc	a2,0x2
ffffffffc0200c64:	9e060613          	addi	a2,a2,-1568 # ffffffffc0202640 <etext+0x254>
ffffffffc0200c68:	13700593          	li	a1,311
ffffffffc0200c6c:	00002517          	auipc	a0,0x2
ffffffffc0200c70:	9ec50513          	addi	a0,a0,-1556 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200c74:	d54ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0200c78:	00002697          	auipc	a3,0x2
ffffffffc0200c7c:	be868693          	addi	a3,a3,-1048 # ffffffffc0202860 <etext+0x474>
ffffffffc0200c80:	00002617          	auipc	a2,0x2
ffffffffc0200c84:	9c060613          	addi	a2,a2,-1600 # ffffffffc0202640 <etext+0x254>
ffffffffc0200c88:	13600593          	li	a1,310
ffffffffc0200c8c:	00002517          	auipc	a0,0x2
ffffffffc0200c90:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200c94:	d34ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200c98:	00002697          	auipc	a3,0x2
ffffffffc0200c9c:	b3068693          	addi	a3,a3,-1232 # ffffffffc02027c8 <etext+0x3dc>
ffffffffc0200ca0:	00002617          	auipc	a2,0x2
ffffffffc0200ca4:	9a060613          	addi	a2,a2,-1632 # ffffffffc0202640 <etext+0x254>
ffffffffc0200ca8:	12a00593          	li	a1,298
ffffffffc0200cac:	00002517          	auipc	a0,0x2
ffffffffc0200cb0:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200cb4:	d14ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(!PageProperty(p0));
ffffffffc0200cb8:	00002697          	auipc	a3,0x2
ffffffffc0200cbc:	b9068693          	addi	a3,a3,-1136 # ffffffffc0202848 <etext+0x45c>
ffffffffc0200cc0:	00002617          	auipc	a2,0x2
ffffffffc0200cc4:	98060613          	addi	a2,a2,-1664 # ffffffffc0202640 <etext+0x254>
ffffffffc0200cc8:	12100593          	li	a1,289
ffffffffc0200ccc:	00002517          	auipc	a0,0x2
ffffffffc0200cd0:	98c50513          	addi	a0,a0,-1652 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200cd4:	cf4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(p0 != NULL);
ffffffffc0200cd8:	00002697          	auipc	a3,0x2
ffffffffc0200cdc:	b6068693          	addi	a3,a3,-1184 # ffffffffc0202838 <etext+0x44c>
ffffffffc0200ce0:	00002617          	auipc	a2,0x2
ffffffffc0200ce4:	96060613          	addi	a2,a2,-1696 # ffffffffc0202640 <etext+0x254>
ffffffffc0200ce8:	12000593          	li	a1,288
ffffffffc0200cec:	00002517          	auipc	a0,0x2
ffffffffc0200cf0:	96c50513          	addi	a0,a0,-1684 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200cf4:	cd4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(nr_free == 0);
ffffffffc0200cf8:	00002697          	auipc	a3,0x2
ffffffffc0200cfc:	b3068693          	addi	a3,a3,-1232 # ffffffffc0202828 <etext+0x43c>
ffffffffc0200d00:	00002617          	auipc	a2,0x2
ffffffffc0200d04:	94060613          	addi	a2,a2,-1728 # ffffffffc0202640 <etext+0x254>
ffffffffc0200d08:	10200593          	li	a1,258
ffffffffc0200d0c:	00002517          	auipc	a0,0x2
ffffffffc0200d10:	94c50513          	addi	a0,a0,-1716 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200d14:	cb4ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200d18:	00002697          	auipc	a3,0x2
ffffffffc0200d1c:	ab068693          	addi	a3,a3,-1360 # ffffffffc02027c8 <etext+0x3dc>
ffffffffc0200d20:	00002617          	auipc	a2,0x2
ffffffffc0200d24:	92060613          	addi	a2,a2,-1760 # ffffffffc0202640 <etext+0x254>
ffffffffc0200d28:	10000593          	li	a1,256
ffffffffc0200d2c:	00002517          	auipc	a0,0x2
ffffffffc0200d30:	92c50513          	addi	a0,a0,-1748 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200d34:	c94ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0200d38:	00002697          	auipc	a3,0x2
ffffffffc0200d3c:	ad068693          	addi	a3,a3,-1328 # ffffffffc0202808 <etext+0x41c>
ffffffffc0200d40:	00002617          	auipc	a2,0x2
ffffffffc0200d44:	90060613          	addi	a2,a2,-1792 # ffffffffc0202640 <etext+0x254>
ffffffffc0200d48:	0ff00593          	li	a1,255
ffffffffc0200d4c:	00002517          	auipc	a0,0x2
ffffffffc0200d50:	90c50513          	addi	a0,a0,-1780 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200d54:	c74ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200d58 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0200d58:	1141                	addi	sp,sp,-16
ffffffffc0200d5a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200d5c:	14058f63          	beqz	a1,ffffffffc0200eba <best_fit_free_pages+0x162>
    for (; p != base + n; p ++) {
ffffffffc0200d60:	00259713          	slli	a4,a1,0x2
ffffffffc0200d64:	972e                	add	a4,a4,a1
ffffffffc0200d66:	070e                	slli	a4,a4,0x3
ffffffffc0200d68:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200d6c:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200d6e:	cf09                	beqz	a4,ffffffffc0200d88 <best_fit_free_pages+0x30>
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200d70:	6798                	ld	a4,8(a5)
ffffffffc0200d72:	8b0d                	andi	a4,a4,3
ffffffffc0200d74:	12071363          	bnez	a4,ffffffffc0200e9a <best_fit_free_pages+0x142>
        p->flags = 0;
ffffffffc0200d78:	0007b423          	sd	zero,8(a5)
    return pa2page(PADDR(kva));
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200d7c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200d80:	02878793          	addi	a5,a5,40
ffffffffc0200d84:	fed796e3          	bne	a5,a3,ffffffffc0200d70 <best_fit_free_pages+0x18>
    SetPageProperty(base);
ffffffffc0200d88:	00853883          	ld	a7,8(a0)
    nr_free = nr_free + n;
ffffffffc0200d8c:	00006717          	auipc	a4,0x6
ffffffffc0200d90:	29c72703          	lw	a4,668(a4) # ffffffffc0207028 <free_area+0x10>
ffffffffc0200d94:	00006617          	auipc	a2,0x6
ffffffffc0200d98:	28460613          	addi	a2,a2,644 # ffffffffc0207018 <free_area>
    return list->next == list;
ffffffffc0200d9c:	661c                	ld	a5,8(a2)
    SetPageProperty(base);
ffffffffc0200d9e:	0028e693          	ori	a3,a7,2
    base->property = n;
ffffffffc0200da2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200da4:	e514                	sd	a3,8(a0)
    nr_free = nr_free + n;
ffffffffc0200da6:	9f2d                	addw	a4,a4,a1
ffffffffc0200da8:	ca18                	sw	a4,16(a2)
    if (list_empty(&free_list)) {
ffffffffc0200daa:	00c79763          	bne	a5,a2,ffffffffc0200db8 <best_fit_free_pages+0x60>
ffffffffc0200dae:	a0bd                	j	ffffffffc0200e1c <best_fit_free_pages+0xc4>
    return listelm->next;
ffffffffc0200db0:	6794                	ld	a3,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0200db2:	06c68e63          	beq	a3,a2,ffffffffc0200e2e <best_fit_free_pages+0xd6>
ffffffffc0200db6:	87b6                	mv	a5,a3
            struct Page* page = le2page(le, page_link);
ffffffffc0200db8:	fe878713          	addi	a4,a5,-24
ffffffffc0200dbc:	86ba                	mv	a3,a4
            if (base < page) {
ffffffffc0200dbe:	fee579e3          	bgeu	a0,a4,ffffffffc0200db0 <best_fit_free_pages+0x58>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200dc2:	0007b803          	ld	a6,0(a5)
                list_add_before(le, &(base->page_link));
ffffffffc0200dc6:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0200dca:	e398                	sd	a4,0(a5)
ffffffffc0200dcc:	00e83423          	sd	a4,8(a6)
    elm->prev = prev;
ffffffffc0200dd0:	01053c23          	sd	a6,24(a0)
    elm->next = next;
ffffffffc0200dd4:	f11c                	sd	a5,32(a0)
    if (le != &free_list) {
ffffffffc0200dd6:	02c80563          	beq	a6,a2,ffffffffc0200e00 <best_fit_free_pages+0xa8>
        if(p + p->property == base){
ffffffffc0200dda:	ff882e03          	lw	t3,-8(a6)
        p = le2page(le, page_link);
ffffffffc0200dde:	fe880713          	addi	a4,a6,-24
        if(p + p->property == base){
ffffffffc0200de2:	020e1313          	slli	t1,t3,0x20
ffffffffc0200de6:	02035313          	srli	t1,t1,0x20
ffffffffc0200dea:	00231693          	slli	a3,t1,0x2
ffffffffc0200dee:	969a                	add	a3,a3,t1
ffffffffc0200df0:	068e                	slli	a3,a3,0x3
ffffffffc0200df2:	96ba                	add	a3,a3,a4
ffffffffc0200df4:	06d50263          	beq	a0,a3,ffffffffc0200e58 <best_fit_free_pages+0x100>
    if (le != &free_list) {
ffffffffc0200df8:	fe878693          	addi	a3,a5,-24
ffffffffc0200dfc:	00c78d63          	beq	a5,a2,ffffffffc0200e16 <best_fit_free_pages+0xbe>
        if (base + base->property == p) {
ffffffffc0200e00:	490c                	lw	a1,16(a0)
ffffffffc0200e02:	02059613          	slli	a2,a1,0x20
ffffffffc0200e06:	9201                	srli	a2,a2,0x20
ffffffffc0200e08:	00261713          	slli	a4,a2,0x2
ffffffffc0200e0c:	9732                	add	a4,a4,a2
ffffffffc0200e0e:	070e                	slli	a4,a4,0x3
ffffffffc0200e10:	972a                	add	a4,a4,a0
ffffffffc0200e12:	06e68163          	beq	a3,a4,ffffffffc0200e74 <best_fit_free_pages+0x11c>
}
ffffffffc0200e16:	60a2                	ld	ra,8(sp)
ffffffffc0200e18:	0141                	addi	sp,sp,16
ffffffffc0200e1a:	8082                	ret
ffffffffc0200e1c:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200e1e:	01850713          	addi	a4,a0,24
ffffffffc0200e22:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200e24:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200e26:	e398                	sd	a4,0(a5)
ffffffffc0200e28:	e798                	sd	a4,8(a5)
}
ffffffffc0200e2a:	0141                	addi	sp,sp,16
ffffffffc0200e2c:	8082                	ret
    return listelm->prev;
ffffffffc0200e2e:	883e                	mv	a6,a5
        if(p + p->property == base){
ffffffffc0200e30:	ff882e03          	lw	t3,-8(a6)
                list_add(le, &(base->page_link));
ffffffffc0200e34:	01850693          	addi	a3,a0,24
    prev->next = next->prev = elm;
ffffffffc0200e38:	e794                	sd	a3,8(a5)
        if(p + p->property == base){
ffffffffc0200e3a:	020e1313          	slli	t1,t3,0x20
ffffffffc0200e3e:	02035313          	srli	t1,t1,0x20
ffffffffc0200e42:	e214                	sd	a3,0(a2)
ffffffffc0200e44:	00231693          	slli	a3,t1,0x2
ffffffffc0200e48:	969a                	add	a3,a3,t1
ffffffffc0200e4a:	068e                	slli	a3,a3,0x3
    elm->prev = prev;
ffffffffc0200e4c:	ed1c                	sd	a5,24(a0)
    elm->next = next;
ffffffffc0200e4e:	f110                	sd	a2,32(a0)
ffffffffc0200e50:	96ba                	add	a3,a3,a4
    elm->prev = prev;
ffffffffc0200e52:	87b2                	mv	a5,a2
ffffffffc0200e54:	fad512e3          	bne	a0,a3,ffffffffc0200df8 <best_fit_free_pages+0xa0>
            p->property = p->property + base->property;
ffffffffc0200e58:	01c585bb          	addw	a1,a1,t3
ffffffffc0200e5c:	feb82c23          	sw	a1,-8(a6)
            ClearPageProperty(base);
ffffffffc0200e60:	ffd8f893          	andi	a7,a7,-3
ffffffffc0200e64:	01153423          	sd	a7,8(a0)
    prev->next = next;
ffffffffc0200e68:	00f83423          	sd	a5,8(a6)
    next->prev = prev;
ffffffffc0200e6c:	0107b023          	sd	a6,0(a5)
            base = p;
ffffffffc0200e70:	853a                	mv	a0,a4
ffffffffc0200e72:	b759                	j	ffffffffc0200df8 <best_fit_free_pages+0xa0>
            base->property += p->property;
ffffffffc0200e74:	ff87a683          	lw	a3,-8(a5)
            ClearPageProperty(p);
ffffffffc0200e78:	ff07b703          	ld	a4,-16(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0200e7c:	0007b803          	ld	a6,0(a5)
ffffffffc0200e80:	6790                	ld	a2,8(a5)
            base->property += p->property;
ffffffffc0200e82:	9ead                	addw	a3,a3,a1
ffffffffc0200e84:	c914                	sw	a3,16(a0)
            ClearPageProperty(p);
ffffffffc0200e86:	9b75                	andi	a4,a4,-3
ffffffffc0200e88:	fee7b823          	sd	a4,-16(a5)
}
ffffffffc0200e8c:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0200e8e:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0200e92:	01063023          	sd	a6,0(a2)
ffffffffc0200e96:	0141                	addi	sp,sp,16
ffffffffc0200e98:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0200e9a:	00002697          	auipc	a3,0x2
ffffffffc0200e9e:	a9668693          	addi	a3,a3,-1386 # ffffffffc0202930 <etext+0x544>
ffffffffc0200ea2:	00001617          	auipc	a2,0x1
ffffffffc0200ea6:	79e60613          	addi	a2,a2,1950 # ffffffffc0202640 <etext+0x254>
ffffffffc0200eaa:	09900593          	li	a1,153
ffffffffc0200eae:	00001517          	auipc	a0,0x1
ffffffffc0200eb2:	7aa50513          	addi	a0,a0,1962 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200eb6:	b12ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc0200eba:	00001697          	auipc	a3,0x1
ffffffffc0200ebe:	77e68693          	addi	a3,a3,1918 # ffffffffc0202638 <etext+0x24c>
ffffffffc0200ec2:	00001617          	auipc	a2,0x1
ffffffffc0200ec6:	77e60613          	addi	a2,a2,1918 # ffffffffc0202640 <etext+0x254>
ffffffffc0200eca:	09600593          	li	a1,150
ffffffffc0200ece:	00001517          	auipc	a0,0x1
ffffffffc0200ed2:	78a50513          	addi	a0,a0,1930 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200ed6:	af2ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200eda <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc0200eda:	1141                	addi	sp,sp,-16
ffffffffc0200edc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200ede:	cdcd                	beqz	a1,ffffffffc0200f98 <best_fit_init_memmap+0xbe>
    for (; p != base + n; p ++) {
ffffffffc0200ee0:	00259713          	slli	a4,a1,0x2
ffffffffc0200ee4:	972e                	add	a4,a4,a1
ffffffffc0200ee6:	070e                	slli	a4,a4,0x3
ffffffffc0200ee8:	00e506b3          	add	a3,a0,a4
    struct Page *p = base;
ffffffffc0200eec:	87aa                	mv	a5,a0
    for (; p != base + n; p ++) {
ffffffffc0200eee:	cf11                	beqz	a4,ffffffffc0200f0a <best_fit_init_memmap+0x30>
        assert(PageReserved(p));
ffffffffc0200ef0:	6798                	ld	a4,8(a5)
ffffffffc0200ef2:	8b05                	andi	a4,a4,1
ffffffffc0200ef4:	c351                	beqz	a4,ffffffffc0200f78 <best_fit_init_memmap+0x9e>
        p->flags = 0;
ffffffffc0200ef6:	0007b423          	sd	zero,8(a5)
        p->property = 0;
ffffffffc0200efa:	0007a823          	sw	zero,16(a5)
ffffffffc0200efe:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0200f02:	02878793          	addi	a5,a5,40
ffffffffc0200f06:	fef695e3          	bne	a3,a5,ffffffffc0200ef0 <best_fit_init_memmap+0x16>
    SetPageProperty(base);
ffffffffc0200f0a:	6510                	ld	a2,8(a0)
    nr_free += n;
ffffffffc0200f0c:	00006717          	auipc	a4,0x6
ffffffffc0200f10:	11c72703          	lw	a4,284(a4) # ffffffffc0207028 <free_area+0x10>
ffffffffc0200f14:	00006697          	auipc	a3,0x6
ffffffffc0200f18:	10468693          	addi	a3,a3,260 # ffffffffc0207018 <free_area>
    return list->next == list;
ffffffffc0200f1c:	669c                	ld	a5,8(a3)
    SetPageProperty(base);
ffffffffc0200f1e:	00266613          	ori	a2,a2,2
    base->property = n;
ffffffffc0200f22:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0200f24:	e510                	sd	a2,8(a0)
    nr_free += n;
ffffffffc0200f26:	9f2d                	addw	a4,a4,a1
ffffffffc0200f28:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0200f2a:	00d79763          	bne	a5,a3,ffffffffc0200f38 <best_fit_init_memmap+0x5e>
ffffffffc0200f2e:	a01d                	j	ffffffffc0200f54 <best_fit_init_memmap+0x7a>
    return listelm->next;
ffffffffc0200f30:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list){
ffffffffc0200f32:	02d70a63          	beq	a4,a3,ffffffffc0200f66 <best_fit_init_memmap+0x8c>
ffffffffc0200f36:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0200f38:	fe878713          	addi	a4,a5,-24
            if(base < page){
ffffffffc0200f3c:	fee57ae3          	bgeu	a0,a4,ffffffffc0200f30 <best_fit_init_memmap+0x56>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0200f40:	6398                	ld	a4,0(a5)
                list_add_before(le, &(base->page_link));
ffffffffc0200f42:	01850693          	addi	a3,a0,24
    prev->next = next->prev = elm;
ffffffffc0200f46:	e394                	sd	a3,0(a5)
}
ffffffffc0200f48:	60a2                	ld	ra,8(sp)
ffffffffc0200f4a:	e714                	sd	a3,8(a4)
    elm->prev = prev;
ffffffffc0200f4c:	ed18                	sd	a4,24(a0)
    elm->next = next;
ffffffffc0200f4e:	f11c                	sd	a5,32(a0)
ffffffffc0200f50:	0141                	addi	sp,sp,16
ffffffffc0200f52:	8082                	ret
ffffffffc0200f54:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0200f56:	01850713          	addi	a4,a0,24
ffffffffc0200f5a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0200f5c:	ed1c                	sd	a5,24(a0)
    prev->next = next->prev = elm;
ffffffffc0200f5e:	e398                	sd	a4,0(a5)
ffffffffc0200f60:	e798                	sd	a4,8(a5)
}
ffffffffc0200f62:	0141                	addi	sp,sp,16
ffffffffc0200f64:	8082                	ret
ffffffffc0200f66:	60a2                	ld	ra,8(sp)
                list_add(le, &(base->page_link));
ffffffffc0200f68:	01850713          	addi	a4,a0,24
ffffffffc0200f6c:	e798                	sd	a4,8(a5)
ffffffffc0200f6e:	e298                	sd	a4,0(a3)
    elm->next = next;
ffffffffc0200f70:	f114                	sd	a3,32(a0)
    elm->prev = prev;
ffffffffc0200f72:	ed1c                	sd	a5,24(a0)
}
ffffffffc0200f74:	0141                	addi	sp,sp,16
ffffffffc0200f76:	8082                	ret
        assert(PageReserved(p));
ffffffffc0200f78:	00002697          	auipc	a3,0x2
ffffffffc0200f7c:	9e068693          	addi	a3,a3,-1568 # ffffffffc0202958 <etext+0x56c>
ffffffffc0200f80:	00001617          	auipc	a2,0x1
ffffffffc0200f84:	6c060613          	addi	a2,a2,1728 # ffffffffc0202640 <etext+0x254>
ffffffffc0200f88:	04e00593          	li	a1,78
ffffffffc0200f8c:	00001517          	auipc	a0,0x1
ffffffffc0200f90:	6cc50513          	addi	a0,a0,1740 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200f94:	a34ff0ef          	jal	ffffffffc02001c8 <__panic>
    assert(n > 0);
ffffffffc0200f98:	00001697          	auipc	a3,0x1
ffffffffc0200f9c:	6a068693          	addi	a3,a3,1696 # ffffffffc0202638 <etext+0x24c>
ffffffffc0200fa0:	00001617          	auipc	a2,0x1
ffffffffc0200fa4:	6a060613          	addi	a2,a2,1696 # ffffffffc0202640 <etext+0x254>
ffffffffc0200fa8:	04b00593          	li	a1,75
ffffffffc0200fac:	00001517          	auipc	a0,0x1
ffffffffc0200fb0:	6ac50513          	addi	a0,a0,1708 # ffffffffc0202658 <etext+0x26c>
ffffffffc0200fb4:	a14ff0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0200fb8 <alloc_pages>:
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    return pmm_manager->alloc_pages(n);
ffffffffc0200fb8:	00006797          	auipc	a5,0x6
ffffffffc0200fbc:	1687b783          	ld	a5,360(a5) # ffffffffc0207120 <pmm_manager>
ffffffffc0200fc0:	6f9c                	ld	a5,24(a5)
ffffffffc0200fc2:	8782                	jr	a5

ffffffffc0200fc4 <free_pages>:
}

// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    pmm_manager->free_pages(base, n);
ffffffffc0200fc4:	00006797          	auipc	a5,0x6
ffffffffc0200fc8:	15c7b783          	ld	a5,348(a5) # ffffffffc0207120 <pmm_manager>
ffffffffc0200fcc:	739c                	ld	a5,32(a5)
ffffffffc0200fce:	8782                	jr	a5

ffffffffc0200fd0 <nr_free_pages>:
}

// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    return pmm_manager->nr_free_pages();
ffffffffc0200fd0:	00006797          	auipc	a5,0x6
ffffffffc0200fd4:	1507b783          	ld	a5,336(a5) # ffffffffc0207120 <pmm_manager>
ffffffffc0200fd8:	779c                	ld	a5,40(a5)
ffffffffc0200fda:	8782                	jr	a5

ffffffffc0200fdc <pmm_init>:
    pmm_manager = &slub_pmm_manager;
ffffffffc0200fdc:	00002797          	auipc	a5,0x2
ffffffffc0200fe0:	2ec78793          	addi	a5,a5,748 # ffffffffc02032c8 <slub_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200fe4:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200fe6:	7139                	addi	sp,sp,-64
ffffffffc0200fe8:	fc06                	sd	ra,56(sp)
ffffffffc0200fea:	f426                	sd	s1,40(sp)
ffffffffc0200fec:	f04a                	sd	s2,32(sp)
ffffffffc0200fee:	ec4e                	sd	s3,24(sp)
ffffffffc0200ff0:	e852                	sd	s4,16(sp)
ffffffffc0200ff2:	f822                	sd	s0,48(sp)
ffffffffc0200ff4:	e456                	sd	s5,8(sp)
    pmm_manager = &slub_pmm_manager;
ffffffffc0200ff6:	00006917          	auipc	s2,0x6
ffffffffc0200ffa:	12a90913          	addi	s2,s2,298 # ffffffffc0207120 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200ffe:	00002517          	auipc	a0,0x2
ffffffffc0201002:	98250513          	addi	a0,a0,-1662 # ffffffffc0202980 <etext+0x594>
    pmm_manager = &slub_pmm_manager;
ffffffffc0201006:	00f93023          	sd	a5,0(s2)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020100a:	93eff0ef          	jal	ffffffffc0200148 <cprintf>
    pmm_manager->init();
ffffffffc020100e:	00093783          	ld	a5,0(s2)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201012:	00006997          	auipc	s3,0x6
ffffffffc0201016:	12698993          	addi	s3,s3,294 # ffffffffc0207138 <va_pa_offset>
    pmm_manager->init();
ffffffffc020101a:	679c                	ld	a5,8(a5)
ffffffffc020101c:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020101e:	57f5                	li	a5,-3
ffffffffc0201020:	07fa                	slli	a5,a5,0x1e
ffffffffc0201022:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201026:	d34ff0ef          	jal	ffffffffc020055a <get_memory_base>
ffffffffc020102a:	84aa                	mv	s1,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc020102c:	d38ff0ef          	jal	ffffffffc0200564 <get_memory_size>
ffffffffc0201030:	8a2a                	mv	s4,a0
    cprintf("Memory Base: 0x%lx, Memory Size: 0x%lx\n", mem_begin, mem_size);
ffffffffc0201032:	862a                	mv	a2,a0
ffffffffc0201034:	85a6                	mv	a1,s1
ffffffffc0201036:	00002517          	auipc	a0,0x2
ffffffffc020103a:	96250513          	addi	a0,a0,-1694 # ffffffffc0202998 <etext+0x5ac>
ffffffffc020103e:	90aff0ef          	jal	ffffffffc0200148 <cprintf>
    if (mem_size == 0) {
ffffffffc0201042:	1a0a0b63          	beqz	s4,ffffffffc02011f8 <pmm_init+0x21c>
    cprintf("physcial memory map:\n");
ffffffffc0201046:	00002517          	auipc	a0,0x2
ffffffffc020104a:	9aa50513          	addi	a0,a0,-1622 # ffffffffc02029f0 <etext+0x604>
ffffffffc020104e:	8faff0ef          	jal	ffffffffc0200148 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0201052:	01448433          	add	s0,s1,s4
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0201056:	85d2                	mv	a1,s4
ffffffffc0201058:	fff40693          	addi	a3,s0,-1
ffffffffc020105c:	8626                	mv	a2,s1
ffffffffc020105e:	00002517          	auipc	a0,0x2
ffffffffc0201062:	9aa50513          	addi	a0,a0,-1622 # ffffffffc0202a08 <etext+0x61c>
ffffffffc0201066:	8e2ff0ef          	jal	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc020106a:	c8000737          	lui	a4,0xc8000
ffffffffc020106e:	87a2                	mv	a5,s0
    npage = maxpa / PGSIZE;
ffffffffc0201070:	00006a97          	auipc	s5,0x6
ffffffffc0201074:	0d0a8a93          	addi	s5,s5,208 # ffffffffc0207140 <npage>
    if (maxpa > KERNTOP) {
ffffffffc0201078:	10876963          	bltu	a4,s0,ffffffffc020118a <pmm_init+0x1ae>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020107c:	777d                	lui	a4,0xfffff
ffffffffc020107e:	00007597          	auipc	a1,0x7
ffffffffc0201082:	0d958593          	addi	a1,a1,217 # ffffffffc0208157 <end+0xfff>
ffffffffc0201086:	8df9                	and	a1,a1,a4
    npage = maxpa / PGSIZE;
ffffffffc0201088:	83b1                	srli	a5,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020108a:	00006a17          	auipc	s4,0x6
ffffffffc020108e:	0bea0a13          	addi	s4,s4,190 # ffffffffc0207148 <pages>
    cprintf("Pages start at: %p\n", pages);
ffffffffc0201092:	00002517          	auipc	a0,0x2
ffffffffc0201096:	9a650513          	addi	a0,a0,-1626 # ffffffffc0202a38 <etext+0x64c>
    npage = maxpa / PGSIZE;
ffffffffc020109a:	00fab023          	sd	a5,0(s5)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020109e:	00ba3023          	sd	a1,0(s4)
    cprintf("Pages start at: %p\n", pages);
ffffffffc02010a2:	8a6ff0ef          	jal	ffffffffc0200148 <cprintf>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010a6:	000ab783          	ld	a5,0(s5)
ffffffffc02010aa:	fff80637          	lui	a2,0xfff80
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010ae:	000a3583          	ld	a1,0(s4)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010b2:	963e                	add	a2,a2,a5
ffffffffc02010b4:	ca0d                	beqz	a2,ffffffffc02010e6 <pmm_init+0x10a>
ffffffffc02010b6:	00279693          	slli	a3,a5,0x2
ffffffffc02010ba:	96be                	add	a3,a3,a5
ffffffffc02010bc:	068e                	slli	a3,a3,0x3
ffffffffc02010be:	fec007b7          	lui	a5,0xfec00
ffffffffc02010c2:	07a1                	addi	a5,a5,8 # fffffffffec00008 <end+0x3e9f8eb0>
ffffffffc02010c4:	96ae                	add	a3,a3,a1
ffffffffc02010c6:	96be                	add	a3,a3,a5
ffffffffc02010c8:	00858793          	addi	a5,a1,8
        SetPageReserved(pages + i);
ffffffffc02010cc:	6398                	ld	a4,0(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010ce:	02878793          	addi	a5,a5,40
        SetPageReserved(pages + i);
ffffffffc02010d2:	00176713          	ori	a4,a4,1
ffffffffc02010d6:	fce7bc23          	sd	a4,-40(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010da:	fed799e3          	bne	a5,a3,ffffffffc02010cc <pmm_init+0xf0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010de:	00261793          	slli	a5,a2,0x2
ffffffffc02010e2:	963e                	add	a2,a2,a5
ffffffffc02010e4:	060e                	slli	a2,a2,0x3
ffffffffc02010e6:	95b2                	add	a1,a1,a2
ffffffffc02010e8:	c02007b7          	lui	a5,0xc0200
ffffffffc02010ec:	0ef5e963          	bltu	a1,a5,ffffffffc02011de <pmm_init+0x202>
ffffffffc02010f0:	0009b783          	ld	a5,0(s3)
    cprintf("freemem: 0x%lx, rounded memory range: 0x%lx to 0x%lx\n", freemem, mem_begin, mem_end);
ffffffffc02010f4:	8626                	mv	a2,s1
ffffffffc02010f6:	86a2                	mv	a3,s0
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010f8:	40f584b3          	sub	s1,a1,a5
    cprintf("freemem: 0x%lx, rounded memory range: 0x%lx to 0x%lx\n", freemem, mem_begin, mem_end);
ffffffffc02010fc:	85a6                	mv	a1,s1
ffffffffc02010fe:	00002517          	auipc	a0,0x2
ffffffffc0201102:	97a50513          	addi	a0,a0,-1670 # ffffffffc0202a78 <etext+0x68c>
ffffffffc0201106:	842ff0ef          	jal	ffffffffc0200148 <cprintf>
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020110a:	77fd                	lui	a5,0xfffff
ffffffffc020110c:	8c7d                	and	s0,s0,a5
    if (freemem < mem_end) {
ffffffffc020110e:	0884e063          	bltu	s1,s0,ffffffffc020118e <pmm_init+0x1b2>

    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    cprintf("Checking memory allocation...\n");
ffffffffc0201112:	00002517          	auipc	a0,0x2
ffffffffc0201116:	9ce50513          	addi	a0,a0,-1586 # ffffffffc0202ae0 <etext+0x6f4>
ffffffffc020111a:	82eff0ef          	jal	ffffffffc0200148 <cprintf>
    pmm_manager->check();
ffffffffc020111e:	00093783          	ld	a5,0(s2)
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0201122:	00006417          	auipc	s0,0x6
ffffffffc0201126:	00e40413          	addi	s0,s0,14 # ffffffffc0207130 <satp_virtual>
    pmm_manager->check();
ffffffffc020112a:	7b9c                	ld	a5,48(a5)
ffffffffc020112c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020112e:	00002517          	auipc	a0,0x2
ffffffffc0201132:	9d250513          	addi	a0,a0,-1582 # ffffffffc0202b00 <etext+0x714>
ffffffffc0201136:	812ff0ef          	jal	ffffffffc0200148 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020113a:	00005597          	auipc	a1,0x5
ffffffffc020113e:	ec658593          	addi	a1,a1,-314 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc0201142:	e00c                	sd	a1,0(s0)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201144:	c02007b7          	lui	a5,0xc0200
ffffffffc0201148:	0cf5e463          	bltu	a1,a5,ffffffffc0201210 <pmm_init+0x234>
ffffffffc020114c:	0009b783          	ld	a5,0(s3)
ffffffffc0201150:	00006497          	auipc	s1,0x6
ffffffffc0201154:	fd848493          	addi	s1,s1,-40 # ffffffffc0207128 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201158:	00002517          	auipc	a0,0x2
ffffffffc020115c:	9c850513          	addi	a0,a0,-1592 # ffffffffc0202b20 <etext+0x734>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201160:	40f58633          	sub	a2,a1,a5
ffffffffc0201164:	e090                	sd	a2,0(s1)
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201166:	fe3fe0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020116a:	600c                	ld	a1,0(s0)
}
ffffffffc020116c:	7442                	ld	s0,48(sp)
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020116e:	6090                	ld	a2,0(s1)
}
ffffffffc0201170:	70e2                	ld	ra,56(sp)
ffffffffc0201172:	74a2                	ld	s1,40(sp)
ffffffffc0201174:	7902                	ld	s2,32(sp)
ffffffffc0201176:	69e2                	ld	s3,24(sp)
ffffffffc0201178:	6a42                	ld	s4,16(sp)
ffffffffc020117a:	6aa2                	ld	s5,8(sp)
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020117c:	00002517          	auipc	a0,0x2
ffffffffc0201180:	9a450513          	addi	a0,a0,-1628 # ffffffffc0202b20 <etext+0x734>
}
ffffffffc0201184:	6121                	addi	sp,sp,64
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201186:	fc3fe06f          	j	ffffffffc0200148 <cprintf>
    if (maxpa > KERNTOP) {
ffffffffc020118a:	87ba                	mv	a5,a4
ffffffffc020118c:	bdc5                	j	ffffffffc020107c <pmm_init+0xa0>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020118e:	6705                	lui	a4,0x1
ffffffffc0201190:	177d                	addi	a4,a4,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0201192:	94ba                	add	s1,s1,a4
    if (PPN(pa) >= npage) {
ffffffffc0201194:	000ab683          	ld	a3,0(s5)
ffffffffc0201198:	8cfd                	and	s1,s1,a5
ffffffffc020119a:	00c4d713          	srli	a4,s1,0xc
ffffffffc020119e:	02d77463          	bgeu	a4,a3,ffffffffc02011c6 <pmm_init+0x1ea>
    pmm_manager->init_memmap(base, n);
ffffffffc02011a2:	00093683          	ld	a3,0(s2)
    return &pages[PPN(pa) - nbase];
ffffffffc02011a6:	fff807b7          	lui	a5,0xfff80
ffffffffc02011aa:	973e                	add	a4,a4,a5
ffffffffc02011ac:	000a3503          	ld	a0,0(s4)
ffffffffc02011b0:	00271793          	slli	a5,a4,0x2
ffffffffc02011b4:	97ba                	add	a5,a5,a4
ffffffffc02011b6:	6a98                	ld	a4,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02011b8:	8c05                	sub	s0,s0,s1
ffffffffc02011ba:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02011bc:	00c45593          	srli	a1,s0,0xc
ffffffffc02011c0:	953e                	add	a0,a0,a5
ffffffffc02011c2:	9702                	jalr	a4
}
ffffffffc02011c4:	b7b9                	j	ffffffffc0201112 <pmm_init+0x136>
        panic("pa2page called with invalid pa");
ffffffffc02011c6:	00002617          	auipc	a2,0x2
ffffffffc02011ca:	8ea60613          	addi	a2,a2,-1814 # ffffffffc0202ab0 <etext+0x6c4>
ffffffffc02011ce:	05b00593          	li	a1,91
ffffffffc02011d2:	00002517          	auipc	a0,0x2
ffffffffc02011d6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0202ad0 <etext+0x6e4>
ffffffffc02011da:	feffe0ef          	jal	ffffffffc02001c8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02011de:	86ae                	mv	a3,a1
ffffffffc02011e0:	00002617          	auipc	a2,0x2
ffffffffc02011e4:	87060613          	addi	a2,a2,-1936 # ffffffffc0202a50 <etext+0x664>
ffffffffc02011e8:	06500593          	li	a1,101
ffffffffc02011ec:	00001517          	auipc	a0,0x1
ffffffffc02011f0:	7f450513          	addi	a0,a0,2036 # ffffffffc02029e0 <etext+0x5f4>
ffffffffc02011f4:	fd5fe0ef          	jal	ffffffffc02001c8 <__panic>
        panic("DTB memory info not available");
ffffffffc02011f8:	00001617          	auipc	a2,0x1
ffffffffc02011fc:	7c860613          	addi	a2,a2,1992 # ffffffffc02029c0 <etext+0x5d4>
ffffffffc0201200:	04b00593          	li	a1,75
ffffffffc0201204:	00001517          	auipc	a0,0x1
ffffffffc0201208:	7dc50513          	addi	a0,a0,2012 # ffffffffc02029e0 <etext+0x5f4>
ffffffffc020120c:	fbdfe0ef          	jal	ffffffffc02001c8 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201210:	86ae                	mv	a3,a1
ffffffffc0201212:	00002617          	auipc	a2,0x2
ffffffffc0201216:	83e60613          	addi	a2,a2,-1986 # ffffffffc0202a50 <etext+0x664>
ffffffffc020121a:	08100593          	li	a1,129
ffffffffc020121e:	00001517          	auipc	a0,0x1
ffffffffc0201222:	7c250513          	addi	a0,a0,1986 # ffffffffc02029e0 <etext+0x5f4>
ffffffffc0201226:	fa3fe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc020122a <slub_init>:
}


static void
slub_init(void) {
    base_pmm->init();       // 初始化底层 PMM
ffffffffc020122a:	00002797          	auipc	a5,0x2
ffffffffc020122e:	06e7b783          	ld	a5,110(a5) # ffffffffc0203298 <best_fit_pmm_manager+0x8>
slub_init(void) {
ffffffffc0201232:	7179                	addi	sp,sp,-48
ffffffffc0201234:	f406                	sd	ra,40(sp)
    base_pmm->init();       // 初始化底层 PMM
ffffffffc0201236:	9782                	jalr	a5
    cache_n=3;
ffffffffc0201238:	00002797          	auipc	a5,0x2
ffffffffc020123c:	2607b687          	fld	fa3,608(a5) # ffffffffc0203498 <nbase+0x8>
ffffffffc0201240:	00002797          	auipc	a5,0x2
ffffffffc0201244:	2607b707          	fld	fa4,608(a5) # ffffffffc02034a0 <nbase+0x10>
ffffffffc0201248:	0034                	addi	a3,sp,8
    size_t sizes[3]={32,64,128};
ffffffffc020124a:	02000793          	li	a5,32
ffffffffc020124e:	e43e                	sd	a5,8(sp)
ffffffffc0201250:	04000793          	li	a5,64
ffffffffc0201254:	e83e                	sd	a5,16(sp)
ffffffffc0201256:	08000793          	li	a5,128
ffffffffc020125a:	ec3e                	sd	a5,24(sp)
    cache_n=3;
ffffffffc020125c:	478d                	li	a5,3
ffffffffc020125e:	00006717          	auipc	a4,0x6
ffffffffc0201262:	eef73923          	sd	a5,-270(a4) # ffffffffc0207150 <cache_n>
    for(int i=0;i<cache_n;i++){
ffffffffc0201266:	00006617          	auipc	a2,0x6
ffffffffc020126a:	eca60613          	addi	a2,a2,-310 # ffffffffc0207130 <satp_virtual>
ffffffffc020126e:	00006797          	auipc	a5,0x6
ffffffffc0201272:	dea78793          	addi	a5,a5,-534 # ffffffffc0207058 <caches+0x28>
        caches[i].obj_size=sizes[i];
ffffffffc0201276:	6298                	ld	a4,0(a3)
    for(int i=0;i<cache_n;i++){
ffffffffc0201278:	06a1                	addi	a3,a3,8
    size_t objects_per_slab = ((PGSIZE - slab_struct_size) / (obj_size + 1.0 / 8.0));
ffffffffc020127a:	d23777d3          	fcvt.d.lu	fa5,a4
        caches[i].obj_size=sizes[i];
ffffffffc020127e:	fee7b823          	sd	a4,-16(a5)
    size_t objects_per_slab = ((PGSIZE - slab_struct_size) / (obj_size + 1.0 / 8.0));
ffffffffc0201282:	02d7f7d3          	fadd.d	fa5,fa5,fa3
ffffffffc0201286:	1af777d3          	fdiv.d	fa5,fa4,fa5
ffffffffc020128a:	c2379753          	fcvt.lu.d	a4,fa5,rtz
ffffffffc020128e:	fee7bc23          	sd	a4,-8(a5)
    if (objects_per_slab == 0) {
ffffffffc0201292:	e311                	bnez	a4,ffffffffc0201296 <slub_init+0x6c>
ffffffffc0201294:	4705                	li	a4,1
        caches[i].objs_num=calculate_objs_num(sizes[i]);
ffffffffc0201296:	fee7bc23          	sd	a4,-8(a5)
    elm->prev = elm->next = elm;
ffffffffc020129a:	e79c                	sd	a5,8(a5)
ffffffffc020129c:	e39c                	sd	a5,0(a5)
    for(int i=0;i<cache_n;i++){
ffffffffc020129e:	04878793          	addi	a5,a5,72
ffffffffc02012a2:	fcc79ae3          	bne	a5,a2,ffffffffc0201276 <slub_init+0x4c>
    cache_init();           // 初始化第二层：SLUB 缓存
}
ffffffffc02012a6:	70a2                	ld	ra,40(sp)
ffffffffc02012a8:	6145                	addi	sp,sp,48
ffffffffc02012aa:	8082                	ret

ffffffffc02012ac <slub_init_memmap>:


static void
slub_init_memmap(struct Page *base,size_t n){
    base_pmm->init_memmap(base,n); // 调用底层 PMM 的 init_memmap
ffffffffc02012ac:	00002797          	auipc	a5,0x2
ffffffffc02012b0:	ff47b783          	ld	a5,-12(a5) # ffffffffc02032a0 <best_fit_pmm_manager+0x10>
ffffffffc02012b4:	8782                	jr	a5

ffffffffc02012b6 <slub_alloc_pages>:


// SLUB PMM 的页分配封装函数
static struct Page *
slub_alloc_pages(size_t n) {
    return base_pmm->alloc_pages(n);
ffffffffc02012b6:	00002797          	auipc	a5,0x2
ffffffffc02012ba:	ff27b783          	ld	a5,-14(a5) # ffffffffc02032a8 <best_fit_pmm_manager+0x18>
ffffffffc02012be:	8782                	jr	a5

ffffffffc02012c0 <slub_free_pages>:
}

static void
slub_free_pages(struct Page *base, size_t n) {
    base_pmm->free_pages(base, n);
ffffffffc02012c0:	00002797          	auipc	a5,0x2
ffffffffc02012c4:	ff07b783          	ld	a5,-16(a5) # ffffffffc02032b0 <best_fit_pmm_manager+0x20>
ffffffffc02012c8:	8782                	jr	a5

ffffffffc02012ca <slub_nr_free_pages>:
}


static size_t
slub_nr_free_pages(void) {
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02012ca:	00002797          	auipc	a5,0x2
ffffffffc02012ce:	fee7b783          	ld	a5,-18(a5) # ffffffffc02032b8 <best_fit_pmm_manager+0x28>
ffffffffc02012d2:	8782                	jr	a5

ffffffffc02012d4 <slub_alloc_obj>:
    for(int i=0;i<cache_n;i++){
ffffffffc02012d4:	00006697          	auipc	a3,0x6
ffffffffc02012d8:	e7c6b683          	ld	a3,-388(a3) # ffffffffc0207150 <cache_n>
ffffffffc02012dc:	00006f97          	auipc	t6,0x6
ffffffffc02012e0:	d54f8f93          	addi	t6,t6,-684 # ffffffffc0207030 <caches>
ffffffffc02012e4:	877e                	mv	a4,t6
ffffffffc02012e6:	4781                	li	a5,0
ffffffffc02012e8:	e689                	bnez	a3,ffffffffc02012f2 <slub_alloc_obj+0x1e>
ffffffffc02012ea:	a869                	j	ffffffffc0201384 <slub_alloc_obj+0xb0>
ffffffffc02012ec:	0785                	addi	a5,a5,1
ffffffffc02012ee:	08f68b63          	beq	a3,a5,ffffffffc0201384 <slub_alloc_obj+0xb0>
        if(caches[i].obj_size>=size){
ffffffffc02012f2:	01873803          	ld	a6,24(a4)
    for(int i=0;i<cache_n;i++){
ffffffffc02012f6:	04870713          	addi	a4,a4,72
        if(caches[i].obj_size>=size){
ffffffffc02012fa:	fea869e3          	bltu	a6,a0,ffffffffc02012ec <slub_alloc_obj+0x18>
ffffffffc02012fe:	0007871b          	sext.w	a4,a5
            cache =&caches[i];
ffffffffc0201302:	00371e93          	slli	t4,a4,0x3
ffffffffc0201306:	00ee82b3          	add	t0,t4,a4
ffffffffc020130a:	028e                	slli	t0,t0,0x3
    return listelm->next;
ffffffffc020130c:	005f83b3          	add	t2,t6,t0
ffffffffc0201310:	0303b883          	ld	a7,48(t2)
    list_entry_t *le=&cache->slabs;
ffffffffc0201314:	02828f13          	addi	t5,t0,40
ffffffffc0201318:	9f7e                	add	t5,t5,t6
    while ((le = list_next(le)) != &cache->slabs) {
ffffffffc020131a:	011f1763          	bne	t5,a7,ffffffffc0201328 <slub_alloc_obj+0x54>
ffffffffc020131e:	a0ad                	j	ffffffffc0201388 <slub_alloc_obj+0xb4>
ffffffffc0201320:	0088b883          	ld	a7,8(a7)
ffffffffc0201324:	071f0263          	beq	t5,a7,ffffffffc0201388 <slub_alloc_obj+0xb4>
        if (slab->free_cnt > 0) {
ffffffffc0201328:	0108b783          	ld	a5,16(a7)
ffffffffc020132c:	dbf5                	beqz	a5,ffffffffc0201320 <slub_alloc_obj+0x4c>
            for (size_t i = 0; i < cache->objs_num; i++) {
ffffffffc020132e:	0203b303          	ld	t1,32(t2)
ffffffffc0201332:	fe0307e3          	beqz	t1,ffffffffc0201320 <slub_alloc_obj+0x4c>
                if (!(slab->bitmap[byte] & (1 << bit))) {
ffffffffc0201336:	0208be03          	ld	t3,32(a7)
            for (size_t i = 0; i < cache->objs_num; i++) {
ffffffffc020133a:	4781                	li	a5,0
ffffffffc020133c:	a021                	j	ffffffffc0201344 <slub_alloc_obj+0x70>
ffffffffc020133e:	0785                	addi	a5,a5,1
ffffffffc0201340:	fef300e3          	beq	t1,a5,ffffffffc0201320 <slub_alloc_obj+0x4c>
                size_t byte = i / 8;
ffffffffc0201344:	0037d693          	srli	a3,a5,0x3
                if (!(slab->bitmap[byte] & (1 << bit))) {
ffffffffc0201348:	96f2                	add	a3,a3,t3
ffffffffc020134a:	0006c583          	lbu	a1,0(a3)
ffffffffc020134e:	0077f513          	andi	a0,a5,7
ffffffffc0201352:	40a5d63b          	sraw	a2,a1,a0
ffffffffc0201356:	8a05                	andi	a2,a2,1
ffffffffc0201358:	f27d                	bnez	a2,ffffffffc020133e <slub_alloc_obj+0x6a>
                    slab->bitmap[byte] |= (1 << bit); // 标记为已分配
ffffffffc020135a:	4605                	li	a2,1
ffffffffc020135c:	00a6163b          	sllw	a2,a2,a0
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
ffffffffc0201360:	9776                	add	a4,a4,t4
                    slab->bitmap[byte] |= (1 << bit); // 标记为已分配
ffffffffc0201362:	8dd1                	or	a1,a1,a2
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
ffffffffc0201364:	070e                	slli	a4,a4,0x3
                    slab->bitmap[byte] |= (1 << bit); // 标记为已分配
ffffffffc0201366:	00b68023          	sb	a1,0(a3)
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
ffffffffc020136a:	977e                	add	a4,a4,t6
ffffffffc020136c:	6f14                	ld	a3,24(a4)
                    slab->free_cnt--;
ffffffffc020136e:	0108b703          	ld	a4,16(a7)
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
ffffffffc0201372:	0188b503          	ld	a0,24(a7)
ffffffffc0201376:	02d787b3          	mul	a5,a5,a3
                    slab->free_cnt--;
ffffffffc020137a:	177d                	addi	a4,a4,-1
ffffffffc020137c:	00e8b823          	sd	a4,16(a7)
                    return (void*)slab->objs + i * cache->obj_size;//返回地址指针
ffffffffc0201380:	953e                	add	a0,a0,a5
ffffffffc0201382:	8082                	ret
    if(size<=0) return NULL;
ffffffffc0201384:	4501                	li	a0,0
}
ffffffffc0201386:	8082                	ret
    slab_t *new_slab=create_slab(cache->obj_size,cache->objs_num);
ffffffffc0201388:	00ee87b3          	add	a5,t4,a4
ffffffffc020138c:	078e                	slli	a5,a5,0x3
ffffffffc020138e:	97fe                	add	a5,a5,t6
ffffffffc0201390:	7394                	ld	a3,32(a5)
    struct Page* page=base_pmm->alloc_pages(1);
ffffffffc0201392:	00002717          	auipc	a4,0x2
ffffffffc0201396:	f1673703          	ld	a4,-234(a4) # ffffffffc02032a8 <best_fit_pmm_manager+0x18>
static void* slub_alloc_obj(size_t size){
ffffffffc020139a:	7179                	addi	sp,sp,-48
ffffffffc020139c:	f406                	sd	ra,40(sp)
    struct Page* page=base_pmm->alloc_pages(1);
ffffffffc020139e:	4505                	li	a0,1
ffffffffc02013a0:	ec16                	sd	t0,24(sp)
ffffffffc02013a2:	e87a                	sd	t5,16(sp)
ffffffffc02013a4:	e442                	sd	a6,8(sp)
    slab_t *new_slab=create_slab(cache->obj_size,cache->objs_num);
ffffffffc02013a6:	e036                	sd	a3,0(sp)
    struct Page* page=base_pmm->alloc_pages(1);
ffffffffc02013a8:	9702                	jalr	a4
    if(!page)return NULL;
ffffffffc02013aa:	cd51                	beqz	a0,ffffffffc0201446 <slub_alloc_obj+0x172>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02013ac:	00006797          	auipc	a5,0x6
ffffffffc02013b0:	d9c7b783          	ld	a5,-612(a5) # ffffffffc0207148 <pages>
ffffffffc02013b4:	ccccd737          	lui	a4,0xccccd
ffffffffc02013b8:	ccd70713          	addi	a4,a4,-819 # ffffffffcccccccd <end+0xcac5b75>
ffffffffc02013bc:	02071613          	slli	a2,a4,0x20
ffffffffc02013c0:	40f507b3          	sub	a5,a0,a5
ffffffffc02013c4:	963a                	add	a2,a2,a4
ffffffffc02013c6:	878d                	srai	a5,a5,0x3
ffffffffc02013c8:	02c787b3          	mul	a5,a5,a2
    memset(slab->bitmap,0,(objs_num+7)/8);
ffffffffc02013cc:	6682                	ld	a3,0(sp)
    slab->bitmap=(unsigned char*)((void*)slab->objs+obj_size*objs_num);//指向位图区域
ffffffffc02013ce:	6822                	ld	a6,8(sp)
ffffffffc02013d0:	00002517          	auipc	a0,0x2
ffffffffc02013d4:	0c053503          	ld	a0,192(a0) # ffffffffc0203490 <nbase>
    void* kva=KADDR(page2pa(page));
ffffffffc02013d8:	00006717          	auipc	a4,0x6
ffffffffc02013dc:	d6073703          	ld	a4,-672(a4) # ffffffffc0207138 <va_pa_offset>
            cache =&caches[i];
ffffffffc02013e0:	62e2                	ld	t0,24(sp)
    memset(slab->bitmap,0,(objs_num+7)/8);
ffffffffc02013e2:	00768613          	addi	a2,a3,7
            cache =&caches[i];
ffffffffc02013e6:	00006f97          	auipc	t6,0x6
ffffffffc02013ea:	c4af8f93          	addi	t6,t6,-950 # ffffffffc0207030 <caches>
ffffffffc02013ee:	9f96                	add	t6,t6,t0
    memset(slab->bitmap,0,(objs_num+7)/8);
ffffffffc02013f0:	820d                	srli	a2,a2,0x3
    slab->bitmap=(unsigned char*)((void*)slab->objs+obj_size*objs_num);//指向位图区域
ffffffffc02013f2:	02d80833          	mul	a6,a6,a3
ffffffffc02013f6:	97aa                	add	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02013f8:	07b2                	slli	a5,a5,0xc
    void* kva=KADDR(page2pa(page));
ffffffffc02013fa:	97ba                	add	a5,a5,a4
    slab->objs=(void*)slab+sizeof(slab_t);//指向对象存储区域
ffffffffc02013fc:	03078513          	addi	a0,a5,48
ffffffffc0201400:	ef88                	sd	a0,24(a5)
    slab->free_cnt=objs_num;
ffffffffc0201402:	eb94                	sd	a3,16(a5)
    memset(slab->bitmap,0,(objs_num+7)/8);
ffffffffc0201404:	4581                	li	a1,0
            cache =&caches[i];
ffffffffc0201406:	ec7e                	sd	t6,24(sp)
    slab->bitmap=(unsigned char*)((void*)slab->objs+obj_size*objs_num);//指向位图区域
ffffffffc0201408:	e03e                	sd	a5,0(sp)
ffffffffc020140a:	9542                	add	a0,a0,a6
ffffffffc020140c:	f388                	sd	a0,32(a5)
    memset(slab->bitmap,0,(objs_num+7)/8);
ffffffffc020140e:	7cd000ef          	jal	ffffffffc02023da <memset>
    elm->prev = elm->next = elm;
ffffffffc0201412:	6782                	ld	a5,0(sp)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201414:	6fe2                	ld	t6,24(sp)
    elm->prev = prev;
ffffffffc0201416:	6f42                	ld	t5,16(sp)
    elm->prev = elm->next = elm;
ffffffffc0201418:	e79c                	sd	a5,8(a5)
    __list_add(elm, listelm, listelm->next);
ffffffffc020141a:	030fb703          	ld	a4,48(t6)
    new_slab->bitmap[0] |= 1;
ffffffffc020141e:	7394                	ld	a3,32(a5)
    prev->next = next->prev = elm;
ffffffffc0201420:	e31c                	sd	a5,0(a4)
ffffffffc0201422:	02ffb823          	sd	a5,48(t6)
    elm->prev = prev;
ffffffffc0201426:	01e7b023          	sd	t5,0(a5)
    elm->next = next;
ffffffffc020142a:	e798                	sd	a4,8(a5)
ffffffffc020142c:	0006c703          	lbu	a4,0(a3)
ffffffffc0201430:	00176713          	ori	a4,a4,1
ffffffffc0201434:	00e68023          	sb	a4,0(a3)
    new_slab->free_cnt--;
ffffffffc0201438:	6b98                	ld	a4,16(a5)
    return new_slab->objs;
ffffffffc020143a:	6f88                	ld	a0,24(a5)
    new_slab->free_cnt--;
ffffffffc020143c:	177d                	addi	a4,a4,-1
ffffffffc020143e:	eb98                	sd	a4,16(a5)
}
ffffffffc0201440:	70a2                	ld	ra,40(sp)
ffffffffc0201442:	6145                	addi	sp,sp,48
ffffffffc0201444:	8082                	ret
    if(size<=0) return NULL;
ffffffffc0201446:	4501                	li	a0,0
ffffffffc0201448:	bfe5                	j	ffffffffc0201440 <slub_alloc_obj+0x16c>

ffffffffc020144a <slub_free_obj>:
    for (size_t i = 0; i < cache_n; i++) {
ffffffffc020144a:	00006897          	auipc	a7,0x6
ffffffffc020144e:	d068b883          	ld	a7,-762(a7) # ffffffffc0207150 <cache_n>
ffffffffc0201452:	04088e63          	beqz	a7,ffffffffc02014ae <slub_free_obj+0x64>
ffffffffc0201456:	00006617          	auipc	a2,0x6
ffffffffc020145a:	c0260613          	addi	a2,a2,-1022 # ffffffffc0207058 <caches+0x28>
ffffffffc020145e:	4801                	li	a6,0
    return listelm->next;
ffffffffc0201460:	6614                	ld	a3,8(a2)
        while ((le = list_next(le)) != &cache->slabs) {
ffffffffc0201462:	02c68163          	beq	a3,a2,ffffffffc0201484 <slub_free_obj+0x3a>
            if (obj >= slab->objs && obj < (slab->objs + cache->obj_size * cache->objs_num)) {
ffffffffc0201466:	6e98                	ld	a4,24(a3)
ffffffffc0201468:	00e56b63          	bltu	a0,a4,ffffffffc020147e <slub_free_obj+0x34>
ffffffffc020146c:	ff063583          	ld	a1,-16(a2)
ffffffffc0201470:	ff863783          	ld	a5,-8(a2)
ffffffffc0201474:	02f587b3          	mul	a5,a1,a5
ffffffffc0201478:	97ba                	add	a5,a5,a4
ffffffffc020147a:	00f56b63          	bltu	a0,a5,ffffffffc0201490 <slub_free_obj+0x46>
ffffffffc020147e:	6694                	ld	a3,8(a3)
        while ((le = list_next(le)) != &cache->slabs) {
ffffffffc0201480:	fec693e3          	bne	a3,a2,ffffffffc0201466 <slub_free_obj+0x1c>
    for (size_t i = 0; i < cache_n; i++) {
ffffffffc0201484:	0805                	addi	a6,a6,1
ffffffffc0201486:	04860613          	addi	a2,a2,72
ffffffffc020148a:	fd089be3          	bne	a7,a6,ffffffffc0201460 <slub_free_obj+0x16>
ffffffffc020148e:	8082                	ret
                size_t offset = (char*)obj - (char*)slab->objs;
ffffffffc0201490:	40e50733          	sub	a4,a0,a4
                size_t index = offset / cache->obj_size;
ffffffffc0201494:	02b75733          	divu	a4,a4,a1
                if (slab->bitmap[byte] & (1 << bit)) {
ffffffffc0201498:	729c                	ld	a5,32(a3)
                size_t byte = index / 8;
ffffffffc020149a:	00375613          	srli	a2,a4,0x3
                if (slab->bitmap[byte] & (1 << bit)) {
ffffffffc020149e:	97b2                	add	a5,a5,a2
ffffffffc02014a0:	0007c583          	lbu	a1,0(a5)
ffffffffc02014a4:	8b1d                	andi	a4,a4,7
ffffffffc02014a6:	40e5d63b          	sraw	a2,a1,a4
ffffffffc02014aa:	8a05                	andi	a2,a2,1
ffffffffc02014ac:	e211                	bnez	a2,ffffffffc02014b0 <slub_free_obj+0x66>
ffffffffc02014ae:	8082                	ret
                    slab->bitmap[byte] &= ~(1 << bit); // 标记为未分配
ffffffffc02014b0:	4605                	li	a2,1
ffffffffc02014b2:	00e6173b          	sllw	a4,a2,a4
slub_free_obj(void* obj){
ffffffffc02014b6:	1101                	addi	sp,sp,-32
                    slab->bitmap[byte] &= ~(1 << bit); // 标记为未分配
ffffffffc02014b8:	fff74713          	not	a4,a4
slub_free_obj(void* obj){
ffffffffc02014bc:	ec06                	sd	ra,24(sp)
                    slab->bitmap[byte] &= ~(1 << bit); // 标记为未分配
ffffffffc02014be:	8df9                	and	a1,a1,a4
                    memset(obj, 0, cache->obj_size);//释放清零
ffffffffc02014c0:	00381713          	slli	a4,a6,0x3
                    slab->bitmap[byte] &= ~(1 << bit); // 标记为未分配
ffffffffc02014c4:	00b78023          	sb	a1,0(a5)
                    memset(obj, 0, cache->obj_size);//释放清零
ffffffffc02014c8:	010707b3          	add	a5,a4,a6
                    slab->free_cnt++;
ffffffffc02014cc:	6a8c                	ld	a1,16(a3)
                    memset(obj, 0, cache->obj_size);//释放清零
ffffffffc02014ce:	00006717          	auipc	a4,0x6
ffffffffc02014d2:	b6270713          	addi	a4,a4,-1182 # ffffffffc0207030 <caches>
ffffffffc02014d6:	078e                	slli	a5,a5,0x3
ffffffffc02014d8:	97ba                	add	a5,a5,a4
ffffffffc02014da:	6f90                	ld	a2,24(a5)
                    slab->free_cnt++;
ffffffffc02014dc:	00158713          	addi	a4,a1,1
ffffffffc02014e0:	ea98                	sd	a4,16(a3)
                    memset(obj, 0, cache->obj_size);//释放清零
ffffffffc02014e2:	4581                	li	a1,0
ffffffffc02014e4:	e43e                	sd	a5,8(sp)
                    slab->free_cnt++;
ffffffffc02014e6:	e036                	sd	a3,0(sp)
                    memset(obj, 0, cache->obj_size);//释放清零
ffffffffc02014e8:	6f3000ef          	jal	ffffffffc02023da <memset>
                    if (slab->free_cnt == cache->objs_num) {
ffffffffc02014ec:	67a2                	ld	a5,8(sp)
ffffffffc02014ee:	6682                	ld	a3,0(sp)
ffffffffc02014f0:	739c                	ld	a5,32(a5)
ffffffffc02014f2:	6a98                	ld	a4,16(a3)
ffffffffc02014f4:	04f71d63          	bne	a4,a5,ffffffffc020154e <slub_free_obj+0x104>
    __list_del(listelm->prev, listelm->next);
ffffffffc02014f8:	6298                	ld	a4,0(a3)
ffffffffc02014fa:	669c                	ld	a5,8(a3)
                        base_pmm->free_pages(pa2page(PADDR(slab)), 1); // 修正：使用 base_pmm
ffffffffc02014fc:	c0200637          	lui	a2,0xc0200
    prev->next = next;
ffffffffc0201500:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201502:	e398                	sd	a4,0(a5)
ffffffffc0201504:	06c6e463          	bltu	a3,a2,ffffffffc020156c <slub_free_obj+0x122>
ffffffffc0201508:	00006797          	auipc	a5,0x6
ffffffffc020150c:	c307b783          	ld	a5,-976(a5) # ffffffffc0207138 <va_pa_offset>
    if (PPN(pa) >= npage) {
ffffffffc0201510:	00006717          	auipc	a4,0x6
ffffffffc0201514:	c3073703          	ld	a4,-976(a4) # ffffffffc0207140 <npage>
ffffffffc0201518:	40f687b3          	sub	a5,a3,a5
ffffffffc020151c:	83b1                	srli	a5,a5,0xc
ffffffffc020151e:	02e7fb63          	bgeu	a5,a4,ffffffffc0201554 <slub_free_obj+0x10a>
    return &pages[PPN(pa) - nbase];
ffffffffc0201522:	00002717          	auipc	a4,0x2
ffffffffc0201526:	f6e73703          	ld	a4,-146(a4) # ffffffffc0203490 <nbase>
ffffffffc020152a:	00006517          	auipc	a0,0x6
ffffffffc020152e:	c1e53503          	ld	a0,-994(a0) # ffffffffc0207148 <pages>
}
ffffffffc0201532:	60e2                	ld	ra,24(sp)
ffffffffc0201534:	8f99                	sub	a5,a5,a4
ffffffffc0201536:	00279713          	slli	a4,a5,0x2
                        base_pmm->free_pages(pa2page(PADDR(slab)), 1); // 修正：使用 base_pmm
ffffffffc020153a:	00002697          	auipc	a3,0x2
ffffffffc020153e:	d766b683          	ld	a3,-650(a3) # ffffffffc02032b0 <best_fit_pmm_manager+0x20>
ffffffffc0201542:	97ba                	add	a5,a5,a4
ffffffffc0201544:	078e                	slli	a5,a5,0x3
ffffffffc0201546:	953e                	add	a0,a0,a5
ffffffffc0201548:	4585                	li	a1,1
}
ffffffffc020154a:	6105                	addi	sp,sp,32
                        base_pmm->free_pages(pa2page(PADDR(slab)), 1); // 修正：使用 base_pmm
ffffffffc020154c:	8682                	jr	a3
}
ffffffffc020154e:	60e2                	ld	ra,24(sp)
ffffffffc0201550:	6105                	addi	sp,sp,32
ffffffffc0201552:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201554:	00001617          	auipc	a2,0x1
ffffffffc0201558:	55c60613          	addi	a2,a2,1372 # ffffffffc0202ab0 <etext+0x6c4>
ffffffffc020155c:	05b00593          	li	a1,91
ffffffffc0201560:	00001517          	auipc	a0,0x1
ffffffffc0201564:	57050513          	addi	a0,a0,1392 # ffffffffc0202ad0 <etext+0x6e4>
ffffffffc0201568:	c61fe0ef          	jal	ffffffffc02001c8 <__panic>
                        base_pmm->free_pages(pa2page(PADDR(slab)), 1); // 修正：使用 base_pmm
ffffffffc020156c:	00001617          	auipc	a2,0x1
ffffffffc0201570:	4e460613          	addi	a2,a2,1252 # ffffffffc0202a50 <etext+0x664>
ffffffffc0201574:	0a300593          	li	a1,163
ffffffffc0201578:	00001517          	auipc	a0,0x1
ffffffffc020157c:	5e850513          	addi	a0,a0,1512 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201580:	c49fe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0201584 <slub_check>:
}


static void
slub_check(void) {
ffffffffc0201584:	7159                	addi	sp,sp,-112
ffffffffc0201586:	fff9e2b7          	lui	t0,0xfff9e
ffffffffc020158a:	f486                	sd	ra,104(sp)
ffffffffc020158c:	f0a2                	sd	s0,96(sp)
ffffffffc020158e:	eca6                	sd	s1,88(sp)
ffffffffc0201590:	1880                	addi	s0,sp,112
ffffffffc0201592:	e8ca                	sd	s2,80(sp)
ffffffffc0201594:	e4ce                	sd	s3,72(sp)
ffffffffc0201596:	e0d2                	sd	s4,64(sp)
ffffffffc0201598:	fc56                	sd	s5,56(sp)
ffffffffc020159a:	f85a                	sd	s6,48(sp)
ffffffffc020159c:	f45e                	sd	s7,40(sp)
ffffffffc020159e:	f062                	sd	s8,32(sp)
ffffffffc02015a0:	ec66                	sd	s9,24(sp)
ffffffffc02015a2:	e86a                	sd	s10,16(sp)
ffffffffc02015a4:	e46e                	sd	s11,8(sp)
ffffffffc02015a6:	54028293          	addi	t0,t0,1344 # fffffffffff9e540 <end+0x3fd973e8>
    // ... (slub_check 函数体保持不变)
    cprintf("Starting SLUB allocator tests...\n\n");
ffffffffc02015aa:	00001517          	auipc	a0,0x1
ffffffffc02015ae:	5ce50513          	addi	a0,a0,1486 # ffffffffc0202b78 <etext+0x78c>
slub_check(void) {
ffffffffc02015b2:	9116                	add	sp,sp,t0
    cprintf("Starting SLUB allocator tests...\n\n");
ffffffffc02015b4:	b95fe0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("The slab struct size is %d\n",sizeof(slab_t));
ffffffffc02015b8:	03000593          	li	a1,48
ffffffffc02015bc:	00001517          	auipc	a0,0x1
ffffffffc02015c0:	5e450513          	addi	a0,a0,1508 # ffffffffc0202ba0 <etext+0x7b4>
ffffffffc02015c4:	b85fe0ef          	jal	ffffffffc0200148 <cprintf>
    cprintf("----------------------START-------------------------\n");
ffffffffc02015c8:	00001517          	auipc	a0,0x1
ffffffffc02015cc:	5f850513          	addi	a0,a0,1528 # ffffffffc0202bc0 <etext+0x7d4>
ffffffffc02015d0:	b79fe0ef          	jal	ffffffffc0200148 <cprintf>
    //检查初始化后的大小
    //对于32字节的slab，应该有126obj/slab
    //64字节：63obj/slab
    //128字节，31obj/slab
    size_t nums[3]={126,63,31};
ffffffffc02015d4:	fff9e5b7          	lui	a1,0xfff9e
ffffffffc02015d8:	4f058593          	addi	a1,a1,1264 # fffffffffff9e4f0 <end+0x3fd97398>
ffffffffc02015dc:	07e00693          	li	a3,126
ffffffffc02015e0:	95a2                	add	a1,a1,s0
ffffffffc02015e2:	e194                	sd	a3,0(a1)
ffffffffc02015e4:	fff9e637          	lui	a2,0xfff9e
ffffffffc02015e8:	fff9e6b7          	lui	a3,0xfff9e
ffffffffc02015ec:	4f860613          	addi	a2,a2,1272 # fffffffffff9e4f8 <end+0x3fd973a0>
ffffffffc02015f0:	50068693          	addi	a3,a3,1280 # fffffffffff9e500 <end+0x3fd973a8>
    for(int i=0;i<cache_n;i++){
ffffffffc02015f4:	00006517          	auipc	a0,0x6
ffffffffc02015f8:	b5c53503          	ld	a0,-1188(a0) # ffffffffc0207150 <cache_n>
    size_t nums[3]={126,63,31};
ffffffffc02015fc:	03f00713          	li	a4,63
ffffffffc0201600:	47fd                	li	a5,31
ffffffffc0201602:	9622                	add	a2,a2,s0
ffffffffc0201604:	96a2                	add	a3,a3,s0
ffffffffc0201606:	e218                	sd	a4,0(a2)
ffffffffc0201608:	e29c                	sd	a5,0(a3)
    for(int i=0;i<cache_n;i++){
ffffffffc020160a:	c10d                	beqz	a0,ffffffffc020162c <slub_check+0xa8>
ffffffffc020160c:	87ae                	mv	a5,a1
ffffffffc020160e:	00006697          	auipc	a3,0x6
ffffffffc0201612:	a2268693          	addi	a3,a3,-1502 # ffffffffc0207030 <caches>
ffffffffc0201616:	4701                	li	a4,0
        assert(caches[i].objs_num==nums[i]);
ffffffffc0201618:	728c                	ld	a1,32(a3)
ffffffffc020161a:	6390                	ld	a2,0(a5)
ffffffffc020161c:	60c59463          	bne	a1,a2,ffffffffc0201c24 <slub_check+0x6a0>
    for(int i=0;i<cache_n;i++){
ffffffffc0201620:	0705                	addi	a4,a4,1
ffffffffc0201622:	04868693          	addi	a3,a3,72
ffffffffc0201626:	07a1                	addi	a5,a5,8
ffffffffc0201628:	fee518e3          	bne	a0,a4,ffffffffc0201618 <slub_check+0x94>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc020162c:	00002497          	auipc	s1,0x2
ffffffffc0201630:	c8c4b483          	ld	s1,-884(s1) # ffffffffc02032b8 <best_fit_pmm_manager+0x28>
ffffffffc0201634:	9482                	jalr	s1
ffffffffc0201636:	892a                	mv	s2,a0
    size_t nr_1=slub_nr_free_pages(); // 使用 slub_nr_free_pages
    //——————————边界检查
    {
        void* obj=slub_alloc_obj(0);
        assert(obj==NULL);
        obj=slub_alloc_obj(256);
ffffffffc0201638:	10000513          	li	a0,256
ffffffffc020163c:	c99ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
        assert(obj==NULL);
ffffffffc0201640:	5c051263          	bnez	a0,ffffffffc0201c04 <slub_check+0x680>
        cprintf("Boundary check passed. \n");
ffffffffc0201644:	00001517          	auipc	a0,0x1
ffffffffc0201648:	5e450513          	addi	a0,a0,1508 # ffffffffc0202c28 <etext+0x83c>
ffffffffc020164c:	afdfe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    //——————————分配释放功能检查
    {
        void* obj1=slub_alloc_obj(32);
ffffffffc0201650:	02000513          	li	a0,32
ffffffffc0201654:	c81ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201658:	89aa                	mv	s3,a0
        assert(obj1!=NULL);
ffffffffc020165a:	58050563          	beqz	a0,ffffffffc0201be4 <slub_check+0x660>
        cprintf("Allocated 32-byte object at %p\n", obj1);
ffffffffc020165e:	85aa                	mv	a1,a0
ffffffffc0201660:	00001517          	auipc	a0,0x1
ffffffffc0201664:	5f850513          	addi	a0,a0,1528 # ffffffffc0202c58 <etext+0x86c>
ffffffffc0201668:	ae1fe0ef          	jal	ffffffffc0200148 <cprintf>
        memset(obj1,0x66,32);
ffffffffc020166c:	02000613          	li	a2,32
ffffffffc0201670:	854e                	mv	a0,s3
ffffffffc0201672:	06600593          	li	a1,102
ffffffffc0201676:	565000ef          	jal	ffffffffc02023da <memset>
        for(int i=0;i<32;i++){
ffffffffc020167a:	87ce                	mv	a5,s3
ffffffffc020167c:	02098613          	addi	a2,s3,32
            assert(((unsigned char*)obj1)[i]==0x66);
ffffffffc0201680:	06600693          	li	a3,102
ffffffffc0201684:	0007c703          	lbu	a4,0(a5)
ffffffffc0201688:	52d71e63          	bne	a4,a3,ffffffffc0201bc4 <slub_check+0x640>
        for(int i=0;i<32;i++){
ffffffffc020168c:	0785                	addi	a5,a5,1
ffffffffc020168e:	fec79be3          	bne	a5,a2,ffffffffc0201684 <slub_check+0x100>
        }
        cprintf("Memory alloc verification passed. \n");
ffffffffc0201692:	00001517          	auipc	a0,0x1
ffffffffc0201696:	60650513          	addi	a0,a0,1542 # ffffffffc0202c98 <etext+0x8ac>
ffffffffc020169a:	aaffe0ef          	jal	ffffffffc0200148 <cprintf>
        slub_free_obj(obj1);
ffffffffc020169e:	854e                	mv	a0,s3
ffffffffc02016a0:	dabff0ef          	jal	ffffffffc020144a <slub_free_obj>

        void* obj2=slub_alloc_obj(32);
ffffffffc02016a4:	02000513          	li	a0,32
ffffffffc02016a8:	c2dff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc02016ac:	89aa                	mv	s3,a0
        cprintf("Allocated 32-byte object at %p\n", obj2);
ffffffffc02016ae:	85aa                	mv	a1,a0
ffffffffc02016b0:	00001517          	auipc	a0,0x1
ffffffffc02016b4:	5a850513          	addi	a0,a0,1448 # ffffffffc0202c58 <etext+0x86c>
ffffffffc02016b8:	a91fe0ef          	jal	ffffffffc0200148 <cprintf>
        for(int i = 0; i < 32; i++) {
ffffffffc02016bc:	87ce                	mv	a5,s3
ffffffffc02016be:	02098693          	addi	a3,s3,32
            assert(((unsigned char*)obj2)[i] == 0x00);
ffffffffc02016c2:	0007c703          	lbu	a4,0(a5)
ffffffffc02016c6:	4c071f63          	bnez	a4,ffffffffc0201ba4 <slub_check+0x620>
        for(int i = 0; i < 32; i++) {
ffffffffc02016ca:	0785                	addi	a5,a5,1
ffffffffc02016cc:	fed79be3          	bne	a5,a3,ffffffffc02016c2 <slub_check+0x13e>
        }
        slub_free_obj(obj2);
ffffffffc02016d0:	854e                	mv	a0,s3
ffffffffc02016d2:	d79ff0ef          	jal	ffffffffc020144a <slub_free_obj>
        cprintf("Memory free verification passed. \n");
ffffffffc02016d6:	00001517          	auipc	a0,0x1
ffffffffc02016da:	61250513          	addi	a0,a0,1554 # ffffffffc0202ce8 <etext+0x8fc>
ffffffffc02016de:	a6bfe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    //——————————多个分配释放功能检查
    {
ffffffffc02016e2:	8a8a                	mv	s5,sp
        const int NUM_TEST_OBJS = 10;
        void* test_objs[NUM_TEST_OBJS];
        cprintf("Allocating %d objects of size 64 bytes.\n", NUM_TEST_OBJS);
ffffffffc02016e4:	45a9                	li	a1,10
        void* test_objs[NUM_TEST_OBJS];
ffffffffc02016e6:	715d                	addi	sp,sp,-80
        cprintf("Allocating %d objects of size 64 bytes.\n", NUM_TEST_OBJS);
ffffffffc02016e8:	00001517          	auipc	a0,0x1
ffffffffc02016ec:	62850513          	addi	a0,a0,1576 # ffffffffc0202d10 <etext+0x924>
        void* test_objs[NUM_TEST_OBJS];
ffffffffc02016f0:	8b0a                	mv	s6,sp
        cprintf("Allocating %d objects of size 64 bytes.\n", NUM_TEST_OBJS);
ffffffffc02016f2:	a57fe0ef          	jal	ffffffffc0200148 <cprintf>
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc02016f6:	8a0a                	mv	s4,sp
        cprintf("Allocating %d objects of size 64 bytes.\n", NUM_TEST_OBJS);
ffffffffc02016f8:	8b8a                	mv	s7,sp
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc02016fa:	4981                	li	s3,0
ffffffffc02016fc:	4c29                	li	s8,10
            test_objs[i] = slub_alloc_obj(64);
ffffffffc02016fe:	04000513          	li	a0,64
ffffffffc0201702:	bd3ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201706:	00abb023          	sd	a0,0(s7)
            assert(test_objs[i] != NULL);
ffffffffc020170a:	02050de3          	beqz	a0,ffffffffc0201f44 <slub_check+0x9c0>
            // 赋值
            memset(test_objs[i], i, 64);
ffffffffc020170e:	0ff9f593          	zext.b	a1,s3
ffffffffc0201712:	04000613          	li	a2,64
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc0201716:	2985                	addiw	s3,s3,1
            memset(test_objs[i], i, 64);
ffffffffc0201718:	4c3000ef          	jal	ffffffffc02023da <memset>
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc020171c:	0ba1                	addi	s7,s7,8
ffffffffc020171e:	ff8990e3          	bne	s3,s8,ffffffffc02016fe <slub_check+0x17a>
ffffffffc0201722:	855a                	mv	a0,s6
        }
    
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc0201724:	4581                	li	a1,0
ffffffffc0201726:	4829                	li	a6,10
            for(int j = 0; j < 64; j++) {
ffffffffc0201728:	611c                	ld	a5,0(a0)
ffffffffc020172a:	0ff5f613          	zext.b	a2,a1
ffffffffc020172e:	04078693          	addi	a3,a5,64
                assert(((unsigned char*)test_objs[i])[j] == (unsigned char)i);
ffffffffc0201732:	0007c703          	lbu	a4,0(a5)
ffffffffc0201736:	3ec71763          	bne	a4,a2,ffffffffc0201b24 <slub_check+0x5a0>
            for(int j = 0; j < 64; j++) {
ffffffffc020173a:	0785                	addi	a5,a5,1
ffffffffc020173c:	fed79be3          	bne	a5,a3,ffffffffc0201732 <slub_check+0x1ae>
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc0201740:	2585                	addiw	a1,a1,1
ffffffffc0201742:	0521                	addi	a0,a0,8
ffffffffc0201744:	ff0592e3          	bne	a1,a6,ffffffffc0201728 <slub_check+0x1a4>
            }
        }
        cprintf("Memory verification for 64-byte objects passed.\n");
ffffffffc0201748:	00001517          	auipc	a0,0x1
ffffffffc020174c:	64850513          	addi	a0,a0,1608 # ffffffffc0202d90 <etext+0x9a4>
ffffffffc0201750:	9f9fe0ef          	jal	ffffffffc0200148 <cprintf>
        // 释放对象
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc0201754:	050b0b13          	addi	s6,s6,80
            slub_free_obj(test_objs[i]);
ffffffffc0201758:	000a3983          	ld	s3,0(s4)
ffffffffc020175c:	854e                	mv	a0,s3
ffffffffc020175e:	cedff0ef          	jal	ffffffffc020144a <slub_free_obj>
            cprintf("Freed 64-byte object at %p\n", test_objs[i]);
ffffffffc0201762:	85ce                	mv	a1,s3
ffffffffc0201764:	00001517          	auipc	a0,0x1
ffffffffc0201768:	66450513          	addi	a0,a0,1636 # ffffffffc0202dc8 <etext+0x9dc>
ffffffffc020176c:	9ddfe0ef          	jal	ffffffffc0200148 <cprintf>
            // 验证内存是否被清零
            for(int j = 0; j < 64; j++) {
ffffffffc0201770:	85ce                	mv	a1,s3
ffffffffc0201772:	04098713          	addi	a4,s3,64
                assert(((unsigned char*)test_objs[i])[j] == 0x00);
ffffffffc0201776:	0005c783          	lbu	a5,0(a1)
ffffffffc020177a:	3c079563          	bnez	a5,ffffffffc0201b44 <slub_check+0x5c0>
            for(int j = 0; j < 64; j++) {
ffffffffc020177e:	0585                	addi	a1,a1,1
ffffffffc0201780:	fee59be3          	bne	a1,a4,ffffffffc0201776 <slub_check+0x1f2>
        for(int i = 0; i < NUM_TEST_OBJS; i++) {
ffffffffc0201784:	0a21                	addi	s4,s4,8
ffffffffc0201786:	fd6a19e3          	bne	s4,s6,ffffffffc0201758 <slub_check+0x1d4>
            }
        }
        cprintf("Memory free verification for 64-byte objects passed.\n");
ffffffffc020178a:	00001517          	auipc	a0,0x1
ffffffffc020178e:	68e50513          	addi	a0,a0,1678 # ffffffffc0202e18 <etext+0xa2c>
ffffffffc0201792:	9b7fe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    //——————————大量分配释放检查
    {
        size_t nr_2,nr_3,nr_4;
        cprintf("Bulk allocation release check start.\n");
ffffffffc0201796:	00001517          	auipc	a0,0x1
ffffffffc020179a:	6ba50513          	addi	a0,a0,1722 # ffffffffc0202e50 <etext+0xa64>
ffffffffc020179e:	8156                	mv	sp,s5
ffffffffc02017a0:	9a9fe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02017a4:	9482                	jalr	s1
        assert(nr_1==slub_nr_free_pages());
ffffffffc02017a6:	74a91f63          	bne	s2,a0,ffffffffc0201f04 <slub_check+0x980>
ffffffffc02017aa:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02017ae:	51078793          	addi	a5,a5,1296 # fffffffffff9e510 <end+0x3fd973b8>
ffffffffc02017b2:	69d1                	lui	s3,0x14

        void *objs_bulk[50000];
        for(int i=1;i<=10000;i++){
            objs_bulk[i-1]=slub_alloc_obj(25);
            assert(slub_nr_free_pages()==nr_1-(i+125)/126);
ffffffffc02017b4:	41041bb7          	lui	s7,0x41041
ffffffffc02017b8:	00f40ab3          	add	s5,s0,a5
ffffffffc02017bc:	88098993          	addi	s3,s3,-1920 # 13880 <kern_entry-0xffffffffc01ec780>
ffffffffc02017c0:	0b86                	slli	s7,s7,0x1
ffffffffc02017c2:	99d6                	add	s3,s3,s5
        assert(nr_1==slub_nr_free_pages());
ffffffffc02017c4:	8a56                	mv	s4,s5
            assert(slub_nr_free_pages()==nr_1-(i+125)/126);
ffffffffc02017c6:	083b8b93          	addi	s7,s7,131 # 41041083 <kern_entry-0xffffffff7f1bef7d>
        assert(nr_1==slub_nr_free_pages());
ffffffffc02017ca:	07e00b13          	li	s6,126
            objs_bulk[i-1]=slub_alloc_obj(25);
ffffffffc02017ce:	4565                	li	a0,25
ffffffffc02017d0:	b05ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc02017d4:	00aa3023          	sd	a0,0(s4)
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02017d8:	9482                	jalr	s1
            assert(slub_nr_free_pages()==nr_1-(i+125)/126);
ffffffffc02017da:	001b579b          	srliw	a5,s6,0x1
ffffffffc02017de:	037787b3          	mul	a5,a5,s7
ffffffffc02017e2:	9395                	srli	a5,a5,0x25
ffffffffc02017e4:	40f907b3          	sub	a5,s2,a5
ffffffffc02017e8:	68a79e63          	bne	a5,a0,ffffffffc0201e84 <slub_check+0x900>
        for(int i=1;i<=10000;i++){
ffffffffc02017ec:	0a21                	addi	s4,s4,8
ffffffffc02017ee:	2b05                	addiw	s6,s6,1
ffffffffc02017f0:	fd3a1fe3          	bne	s4,s3,ffffffffc02017ce <slub_check+0x24a>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02017f4:	00027a37          	lui	s4,0x27
ffffffffc02017f8:	9482                	jalr	s1
ffffffffc02017fa:	100a0a13          	addi	s4,s4,256 # 27100 <kern_entry-0xffffffffc01d8f00>
        }
        nr_2=slub_nr_free_pages();
        
        for(int i=1;i<=10000;i++){
            objs_bulk[i+9999]=slub_alloc_obj(62);
            assert(slub_nr_free_pages()==nr_2-(i+62)/63);
ffffffffc02017fe:	82082b37          	lui	s6,0x82082
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201802:	8baa                	mv	s7,a0
        for(int i=1;i<=10000;i++){
ffffffffc0201804:	9a56                	add	s4,s4,s5
            assert(slub_nr_free_pages()==nr_2-(i+62)/63);
ffffffffc0201806:	083b0b13          	addi	s6,s6,131 # ffffffff82082083 <kern_entry-0x3e17df7d>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc020180a:	03f00c13          	li	s8,63
            objs_bulk[i+9999]=slub_alloc_obj(62);
ffffffffc020180e:	03e00513          	li	a0,62
ffffffffc0201812:	ac3ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201816:	00a9b023          	sd	a0,0(s3)
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc020181a:	9482                	jalr	s1
            assert(slub_nr_free_pages()==nr_2-(i+62)/63);
ffffffffc020181c:	036c07b3          	mul	a5,s8,s6
ffffffffc0201820:	41fc571b          	sraiw	a4,s8,0x1f
ffffffffc0201824:	9381                	srli	a5,a5,0x20
ffffffffc0201826:	00fc07bb          	addw	a5,s8,a5
ffffffffc020182a:	4057d79b          	sraiw	a5,a5,0x5
ffffffffc020182e:	9f99                	subw	a5,a5,a4
ffffffffc0201830:	40fb87b3          	sub	a5,s7,a5
ffffffffc0201834:	6ea79863          	bne	a5,a0,ffffffffc0201f24 <slub_check+0x9a0>
        for(int i=1;i<=10000;i++){
ffffffffc0201838:	09a1                	addi	s3,s3,8
ffffffffc020183a:	2c05                	addiw	s8,s8,1
ffffffffc020183c:	fd4999e3          	bne	s3,s4,ffffffffc020180e <slub_check+0x28a>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201840:	0003b9b7          	lui	s3,0x3b
ffffffffc0201844:	9482                	jalr	s1
ffffffffc0201846:	98098993          	addi	s3,s3,-1664 # 3a980 <kern_entry-0xffffffffc01c5680>
        }
        nr_3=slub_nr_free_pages();
    
        for(int i=1;i<=10000;i++){
            objs_bulk[i+19999]=slub_alloc_obj(124);
            assert(slub_nr_free_pages()==nr_3-(i+30)/31);
ffffffffc020184a:	84211b37          	lui	s6,0x84211
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc020184e:	8baa                	mv	s7,a0
        for(int i=1;i<=10000;i++){
ffffffffc0201850:	99d6                	add	s3,s3,s5
            assert(slub_nr_free_pages()==nr_3-(i+30)/31);
ffffffffc0201852:	843b0b13          	addi	s6,s6,-1981 # ffffffff84210843 <kern_entry-0x3bfef7bd>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201856:	4c7d                	li	s8,31
            objs_bulk[i+19999]=slub_alloc_obj(124);
ffffffffc0201858:	07c00513          	li	a0,124
ffffffffc020185c:	a79ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201860:	00aa3023          	sd	a0,0(s4)
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201864:	9482                	jalr	s1
            assert(slub_nr_free_pages()==nr_3-(i+30)/31);
ffffffffc0201866:	036c07b3          	mul	a5,s8,s6
ffffffffc020186a:	41fc571b          	sraiw	a4,s8,0x1f
ffffffffc020186e:	9381                	srli	a5,a5,0x20
ffffffffc0201870:	00fc07bb          	addw	a5,s8,a5
ffffffffc0201874:	4047d79b          	sraiw	a5,a5,0x4
ffffffffc0201878:	9f99                	subw	a5,a5,a4
ffffffffc020187a:	40fb87b3          	sub	a5,s7,a5
ffffffffc020187e:	50a79363          	bne	a5,a0,ffffffffc0201d84 <slub_check+0x800>
        for(int i=1;i<=10000;i++){
ffffffffc0201882:	0a21                	addi	s4,s4,8
ffffffffc0201884:	2c05                	addiw	s8,s8,1
ffffffffc0201886:	fd3a19e3          	bne	s4,s3,ffffffffc0201858 <slub_check+0x2d4>
        }
        nr_4=slub_nr_free_pages();

        for(int i=1;i<=10000;i++){
            objs_bulk[i+29999]=slub_alloc_obj(129+i%666);
ffffffffc020188a:	06267a37          	lui	s4,0x6267
ffffffffc020188e:	0a16                	slli	s4,s4,0x5
        for(int i=1;i<=10000;i++){
ffffffffc0201890:	6b09                	lui	s6,0x2
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201892:	9482                	jalr	s1
            objs_bulk[i+29999]=slub_alloc_obj(129+i%666);
ffffffffc0201894:	7b1a0a13          	addi	s4,s4,1969 # 62677b1 <kern_entry-0xffffffffb9f9884f>
        for(int i=1;i<=10000;i++){
ffffffffc0201898:	711b0b13          	addi	s6,s6,1809 # 2711 <kern_entry-0xffffffffc01fd8ef>
ffffffffc020189c:	4c05                	li	s8,1
            objs_bulk[i+29999]=slub_alloc_obj(129+i%666);
ffffffffc020189e:	29a00b93          	li	s7,666
ffffffffc02018a2:	001c551b          	srliw	a0,s8,0x1
ffffffffc02018a6:	03450533          	mul	a0,a0,s4
ffffffffc02018aa:	9121                	srli	a0,a0,0x28
ffffffffc02018ac:	02ab853b          	mulw	a0,s7,a0
ffffffffc02018b0:	40ac053b          	subw	a0,s8,a0
ffffffffc02018b4:	0815051b          	addiw	a0,a0,129
ffffffffc02018b8:	a1dff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc02018bc:	00a9b023          	sd	a0,0(s3)
            assert(objs_bulk[i+29999]==NULL); 
ffffffffc02018c0:	62051263          	bnez	a0,ffffffffc0201ee4 <slub_check+0x960>
        for(int i=1;i<=10000;i++){
ffffffffc02018c4:	2c05                	addiw	s8,s8,1
ffffffffc02018c6:	09a1                	addi	s3,s3,8
ffffffffc02018c8:	fd6c1de3          	bne	s8,s6,ffffffffc02018a2 <slub_check+0x31e>
        }

        for(int i=0;i<40000;i++){
            if(i<30000){
ffffffffc02018cc:	6a1d                	lui	s4,0x7
        for(int i=0;i<40000;i++){
ffffffffc02018ce:	6b29                	lui	s6,0xa
            if(i<30000){
ffffffffc02018d0:	52fa0a13          	addi	s4,s4,1327 # 752f <kern_entry-0xffffffffc01f8ad1>
        for(int i=0;i<40000;i++){
ffffffffc02018d4:	c40b0b13          	addi	s6,s6,-960 # 9c40 <kern_entry-0xffffffffc01f63c0>
ffffffffc02018d8:	4981                	li	s3,0
            if(i<30000){
ffffffffc02018da:	013a4c63          	blt	s4,s3,ffffffffc02018f2 <slub_check+0x36e>
                assert(objs_bulk[i]!=NULL);
ffffffffc02018de:	000ab503          	ld	a0,0(s5)
ffffffffc02018e2:	5e050163          	beqz	a0,ffffffffc0201ec4 <slub_check+0x940>
        for(int i=0;i<40000;i++){
ffffffffc02018e6:	2985                	addiw	s3,s3,1
                slub_free_obj(objs_bulk[i]);
ffffffffc02018e8:	b63ff0ef          	jal	ffffffffc020144a <slub_free_obj>
        for(int i=0;i<40000;i++){
ffffffffc02018ec:	0aa1                	addi	s5,s5,8
            if(i<30000){
ffffffffc02018ee:	ff3a58e3          	bge	s4,s3,ffffffffc02018de <slub_check+0x35a>
        for(int i=0;i<40000;i++){
ffffffffc02018f2:	2985                	addiw	s3,s3,1
ffffffffc02018f4:	01698463          	beq	s3,s6,ffffffffc02018fc <slub_check+0x378>
ffffffffc02018f8:	0aa1                	addi	s5,s5,8
ffffffffc02018fa:	b7c5                	j	ffffffffc02018da <slub_check+0x356>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02018fc:	9482                	jalr	s1
            }
        }
        assert(slub_nr_free_pages()==nr_1);
ffffffffc02018fe:	5aa91363          	bne	s2,a0,ffffffffc0201ea4 <slub_check+0x920>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201902:	9482                	jalr	s1
ffffffffc0201904:	85aa                	mv	a1,a0
        cprintf("Bulk allocation release check passed. (nr_free: %lu)\n", slub_nr_free_pages());
ffffffffc0201906:	00001517          	auipc	a0,0x1
ffffffffc020190a:	66250513          	addi	a0,a0,1634 # ffffffffc0202f68 <etext+0xb7c>
ffffffffc020190e:	83bfe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    //——————————复杂流程检查
    {
        cprintf("Mixed check start.\n");
ffffffffc0201912:	00001517          	auipc	a0,0x1
ffffffffc0201916:	68e50513          	addi	a0,a0,1678 # ffffffffc0202fa0 <etext+0xbb4>
ffffffffc020191a:	82ffe0ef          	jal	ffffffffc0200148 <cprintf>

        void* obj1=slub_alloc_obj(32);
ffffffffc020191e:	02000513          	li	a0,32
ffffffffc0201922:	9b3ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201926:	8daa                	mv	s11,a0
        assert(obj1!=NULL);
ffffffffc0201928:	24050e63          	beqz	a0,ffffffffc0201b84 <slub_check+0x600>
        cprintf("Allocated 32-byte object at %p\n", obj1);
ffffffffc020192c:	85aa                	mv	a1,a0
ffffffffc020192e:	00001517          	auipc	a0,0x1
ffffffffc0201932:	32a50513          	addi	a0,a0,810 # ffffffffc0202c58 <etext+0x86c>
ffffffffc0201936:	813fe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc020193a:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-1);
ffffffffc020193c:	fff90b93          	addi	s7,s2,-1
ffffffffc0201940:	52ab9263          	bne	s7,a0,ffffffffc0201e64 <slub_check+0x8e0>

        void* obj2=slub_alloc_obj(64);
ffffffffc0201944:	04000513          	li	a0,64
ffffffffc0201948:	98dff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc020194c:	8d2a                	mv	s10,a0
        assert(obj2!=NULL);
ffffffffc020194e:	4e050b63          	beqz	a0,ffffffffc0201e44 <slub_check+0x8c0>
        cprintf("Allocated 64-byte object at %p\n", obj2);
ffffffffc0201952:	85aa                	mv	a1,a0
ffffffffc0201954:	00001517          	auipc	a0,0x1
ffffffffc0201958:	69450513          	addi	a0,a0,1684 # ffffffffc0202fe8 <etext+0xbfc>
ffffffffc020195c:	fecfe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201960:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-2);
ffffffffc0201962:	ffe90c13          	addi	s8,s2,-2
ffffffffc0201966:	4aac1f63          	bne	s8,a0,ffffffffc0201e24 <slub_check+0x8a0>


        void* obj3=slub_alloc_obj(128);
ffffffffc020196a:	08000513          	li	a0,128
ffffffffc020196e:	967ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201972:	8caa                	mv	s9,a0
        assert(obj3!=NULL);
ffffffffc0201974:	48050863          	beqz	a0,ffffffffc0201e04 <slub_check+0x880>
        cprintf("Allocated 128-byte object at %p\n", obj3);
ffffffffc0201978:	85aa                	mv	a1,a0
ffffffffc020197a:	00001517          	auipc	a0,0x1
ffffffffc020197e:	6be50513          	addi	a0,a0,1726 # ffffffffc0203038 <etext+0xc4c>
ffffffffc0201982:	fc6fe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201986:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201988:	ffd90a93          	addi	s5,s2,-3
ffffffffc020198c:	44aa9c63          	bne	s5,a0,ffffffffc0201de4 <slub_check+0x860>


        void* obj4=slub_alloc_obj(32);
ffffffffc0201990:	02000513          	li	a0,32
ffffffffc0201994:	941ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201998:	fff9e737          	lui	a4,0xfff9e
ffffffffc020199c:	4e870713          	addi	a4,a4,1256 # fffffffffff9e4e8 <end+0x3fd97390>
ffffffffc02019a0:	9722                	add	a4,a4,s0
ffffffffc02019a2:	e308                	sd	a0,0(a4)
        assert(obj4!=NULL);
ffffffffc02019a4:	42050063          	beqz	a0,ffffffffc0201dc4 <slub_check+0x840>
        cprintf("Allocated second 32-byte object at %p\n", obj4);
ffffffffc02019a8:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02019ac:	4e878793          	addi	a5,a5,1256 # fffffffffff9e4e8 <end+0x3fd97390>
ffffffffc02019b0:	97a2                	add	a5,a5,s0
ffffffffc02019b2:	638c                	ld	a1,0(a5)
ffffffffc02019b4:	00001517          	auipc	a0,0x1
ffffffffc02019b8:	6dc50513          	addi	a0,a0,1756 # ffffffffc0203090 <etext+0xca4>
ffffffffc02019bc:	f8cfe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc02019c0:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc02019c2:	3eaa9163          	bne	s5,a0,ffffffffc0201da4 <slub_check+0x820>
ffffffffc02019c6:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc02019ca:	51078793          	addi	a5,a5,1296 # fffffffffff9e510 <end+0x3fd973b8>
ffffffffc02019ce:	00f40a33          	add	s4,s0,a5
ffffffffc02019d2:	008a0993          	addi	s3,s4,8
ffffffffc02019d6:	8b4e                	mv	s6,s3
ffffffffc02019d8:	0f0a0a13          	addi	s4,s4,240


        void* objs[100];
        for(int i=1;i<=29;i++){
            objs[i]=slub_alloc_obj(128);
ffffffffc02019dc:	08000513          	li	a0,128
ffffffffc02019e0:	8f5ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc02019e4:	00ab3023          	sd	a0,0(s6)
        for(int i=1;i<=29;i++){
ffffffffc02019e8:	0b21                	addi	s6,s6,8
ffffffffc02019ea:	ff6a19e3          	bne	s4,s6,ffffffffc02019dc <slub_check+0x458>
        }

        void* obj5=slub_alloc_obj(128);
ffffffffc02019ee:	08000513          	li	a0,128
ffffffffc02019f2:	8e3ff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc02019f6:	fff9e737          	lui	a4,0xfff9e
ffffffffc02019fa:	4e070713          	addi	a4,a4,1248 # fffffffffff9e4e0 <end+0x3fd97388>
ffffffffc02019fe:	9722                	add	a4,a4,s0
ffffffffc0201a00:	e308                	sd	a0,0(a4)
        assert(obj5!=NULL);
ffffffffc0201a02:	16050163          	beqz	a0,ffffffffc0201b64 <slub_check+0x5e0>
        cprintf("Allocated 31th 128-byte object at %p\n", obj5);
ffffffffc0201a06:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0201a0a:	4e078793          	addi	a5,a5,1248 # fffffffffff9e4e0 <end+0x3fd97388>
ffffffffc0201a0e:	97a2                	add	a5,a5,s0
ffffffffc0201a10:	638c                	ld	a1,0(a5)
ffffffffc0201a12:	00001517          	auipc	a0,0x1
ffffffffc0201a16:	6b650513          	addi	a0,a0,1718 # ffffffffc02030c8 <etext+0xcdc>
ffffffffc0201a1a:	f2efe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a1e:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201a20:	34aa9263          	bne	s5,a0,ffffffffc0201d64 <slub_check+0x7e0>

        void* obj6=slub_alloc_obj(128);
ffffffffc0201a24:	08000513          	li	a0,128
ffffffffc0201a28:	8adff0ef          	jal	ffffffffc02012d4 <slub_alloc_obj>
ffffffffc0201a2c:	fff9e737          	lui	a4,0xfff9e
ffffffffc0201a30:	4d870713          	addi	a4,a4,1240 # fffffffffff9e4d8 <end+0x3fd97380>
ffffffffc0201a34:	9722                	add	a4,a4,s0
ffffffffc0201a36:	e308                	sd	a0,0(a4)
        assert(obj6!=NULL);
ffffffffc0201a38:	30050663          	beqz	a0,ffffffffc0201d44 <slub_check+0x7c0>
        cprintf("Allocated 32th(new slam) 128-byte object at %p\n", obj6);
ffffffffc0201a3c:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0201a40:	4d878793          	addi	a5,a5,1240 # fffffffffff9e4d8 <end+0x3fd97380>
ffffffffc0201a44:	97a2                	add	a5,a5,s0
ffffffffc0201a46:	638c                	ld	a1,0(a5)
ffffffffc0201a48:	00001517          	auipc	a0,0x1
ffffffffc0201a4c:	6b850513          	addi	a0,a0,1720 # ffffffffc0203100 <etext+0xd14>
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201a50:	ffc90b13          	addi	s6,s2,-4
        cprintf("Allocated 32th(new slam) 128-byte object at %p\n", obj6);
ffffffffc0201a54:	ef4fe0ef          	jal	ffffffffc0200148 <cprintf>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a58:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201a5a:	2cab1563          	bne	s6,a0,ffffffffc0201d24 <slub_check+0x7a0>

        for(int i=1;i<=29;i++){
            slub_free_obj(objs[i]);
ffffffffc0201a5e:	0009b503          	ld	a0,0(s3)
        for(int i=1;i<=29;i++){
ffffffffc0201a62:	09a1                	addi	s3,s3,8
            slub_free_obj(objs[i]);
ffffffffc0201a64:	9e7ff0ef          	jal	ffffffffc020144a <slub_free_obj>
        for(int i=1;i<=29;i++){
ffffffffc0201a68:	ff499be3          	bne	s3,s4,ffffffffc0201a5e <slub_check+0x4da>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a6c:	9482                	jalr	s1
        }
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201a6e:	28ab1b63          	bne	s6,a0,ffffffffc0201d04 <slub_check+0x780>

        slub_free_obj(obj1);
ffffffffc0201a72:	856e                	mv	a0,s11
ffffffffc0201a74:	9d7ff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a78:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201a7a:	26ab1563          	bne	s6,a0,ffffffffc0201ce4 <slub_check+0x760>

        slub_free_obj(obj2);
ffffffffc0201a7e:	856a                	mv	a0,s10
ffffffffc0201a80:	9cbff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a84:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201a86:	22aa9f63          	bne	s5,a0,ffffffffc0201cc4 <slub_check+0x740>

        slub_free_obj(obj3);
ffffffffc0201a8a:	8566                	mv	a0,s9
ffffffffc0201a8c:	9bfff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201a90:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201a92:	20aa9963          	bne	s5,a0,ffffffffc0201ca4 <slub_check+0x720>

        slub_free_obj(obj4);
ffffffffc0201a96:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0201a9a:	4e878793          	addi	a5,a5,1256 # fffffffffff9e4e8 <end+0x3fd97390>
ffffffffc0201a9e:	97a2                	add	a5,a5,s0
ffffffffc0201aa0:	6388                	ld	a0,0(a5)
ffffffffc0201aa2:	9a9ff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201aa6:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-2);
ffffffffc0201aa8:	1cac1e63          	bne	s8,a0,ffffffffc0201c84 <slub_check+0x700>

        slub_free_obj(obj5);
ffffffffc0201aac:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0201ab0:	4e078793          	addi	a5,a5,1248 # fffffffffff9e4e0 <end+0x3fd97388>
ffffffffc0201ab4:	97a2                	add	a5,a5,s0
ffffffffc0201ab6:	6388                	ld	a0,0(a5)
ffffffffc0201ab8:	993ff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201abc:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1-1);
ffffffffc0201abe:	1aab9363          	bne	s7,a0,ffffffffc0201c64 <slub_check+0x6e0>

        slub_free_obj(obj6);
ffffffffc0201ac2:	fff9e7b7          	lui	a5,0xfff9e
ffffffffc0201ac6:	4d878793          	addi	a5,a5,1240 # fffffffffff9e4d8 <end+0x3fd97380>
ffffffffc0201aca:	97a2                	add	a5,a5,s0
ffffffffc0201acc:	6388                	ld	a0,0(a5)
ffffffffc0201ace:	97dff0ef          	jal	ffffffffc020144a <slub_free_obj>
    return base_pmm->nr_free_pages(); // 使用 base_pmm 的空闲页数
ffffffffc0201ad2:	9482                	jalr	s1
        assert(slub_nr_free_pages()==nr_1);
ffffffffc0201ad4:	16a91863          	bne	s2,a0,ffffffffc0201c44 <slub_check+0x6c0>
    
        cprintf("Mixed check passed.\n");
ffffffffc0201ad8:	00001517          	auipc	a0,0x1
ffffffffc0201adc:	67850513          	addi	a0,a0,1656 # ffffffffc0203150 <etext+0xd64>
ffffffffc0201ae0:	e68fe0ef          	jal	ffffffffc0200148 <cprintf>
    }
    cprintf("----------------------END-------------------------\n");
ffffffffc0201ae4:	00001517          	auipc	a0,0x1
ffffffffc0201ae8:	68450513          	addi	a0,a0,1668 # ffffffffc0203168 <etext+0xd7c>
ffffffffc0201aec:	e5cfe0ef          	jal	ffffffffc0200148 <cprintf>
}
ffffffffc0201af0:	fff9e2b7          	lui	t0,0xfff9e
ffffffffc0201af4:	4d028293          	addi	t0,t0,1232 # fffffffffff9e4d0 <end+0x3fd97378>
ffffffffc0201af8:	00540133          	add	sp,s0,t0
ffffffffc0201afc:	000622b7          	lui	t0,0x62
ffffffffc0201b00:	ac028293          	addi	t0,t0,-1344 # 61ac0 <kern_entry-0xffffffffc019e540>
ffffffffc0201b04:	9116                	add	sp,sp,t0
ffffffffc0201b06:	70a6                	ld	ra,104(sp)
ffffffffc0201b08:	7406                	ld	s0,96(sp)
ffffffffc0201b0a:	64e6                	ld	s1,88(sp)
ffffffffc0201b0c:	6946                	ld	s2,80(sp)
ffffffffc0201b0e:	69a6                	ld	s3,72(sp)
ffffffffc0201b10:	6a06                	ld	s4,64(sp)
ffffffffc0201b12:	7ae2                	ld	s5,56(sp)
ffffffffc0201b14:	7b42                	ld	s6,48(sp)
ffffffffc0201b16:	7ba2                	ld	s7,40(sp)
ffffffffc0201b18:	7c02                	ld	s8,32(sp)
ffffffffc0201b1a:	6ce2                	ld	s9,24(sp)
ffffffffc0201b1c:	6d42                	ld	s10,16(sp)
ffffffffc0201b1e:	6da2                	ld	s11,8(sp)
ffffffffc0201b20:	6165                	addi	sp,sp,112
ffffffffc0201b22:	8082                	ret
                assert(((unsigned char*)test_objs[i])[j] == (unsigned char)i);
ffffffffc0201b24:	00001697          	auipc	a3,0x1
ffffffffc0201b28:	23468693          	addi	a3,a3,564 # ffffffffc0202d58 <etext+0x96c>
ffffffffc0201b2c:	00001617          	auipc	a2,0x1
ffffffffc0201b30:	b1460613          	addi	a2,a2,-1260 # ffffffffc0202640 <etext+0x254>
ffffffffc0201b34:	0ec00593          	li	a1,236
ffffffffc0201b38:	00001517          	auipc	a0,0x1
ffffffffc0201b3c:	02850513          	addi	a0,a0,40 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201b40:	e88fe0ef          	jal	ffffffffc02001c8 <__panic>
                assert(((unsigned char*)test_objs[i])[j] == 0x00);
ffffffffc0201b44:	00001697          	auipc	a3,0x1
ffffffffc0201b48:	2a468693          	addi	a3,a3,676 # ffffffffc0202de8 <etext+0x9fc>
ffffffffc0201b4c:	00001617          	auipc	a2,0x1
ffffffffc0201b50:	af460613          	addi	a2,a2,-1292 # ffffffffc0202640 <etext+0x254>
ffffffffc0201b54:	0f600593          	li	a1,246
ffffffffc0201b58:	00001517          	auipc	a0,0x1
ffffffffc0201b5c:	00850513          	addi	a0,a0,8 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201b60:	e68fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj5!=NULL);
ffffffffc0201b64:	00001697          	auipc	a3,0x1
ffffffffc0201b68:	55468693          	addi	a3,a3,1364 # ffffffffc02030b8 <etext+0xccc>
ffffffffc0201b6c:	00001617          	auipc	a2,0x1
ffffffffc0201b70:	ad460613          	addi	a2,a2,-1324 # ffffffffc0202640 <etext+0x254>
ffffffffc0201b74:	14300593          	li	a1,323
ffffffffc0201b78:	00001517          	auipc	a0,0x1
ffffffffc0201b7c:	fe850513          	addi	a0,a0,-24 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201b80:	e48fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj1!=NULL);
ffffffffc0201b84:	00001697          	auipc	a3,0x1
ffffffffc0201b88:	0c468693          	addi	a3,a3,196 # ffffffffc0202c48 <etext+0x85c>
ffffffffc0201b8c:	00001617          	auipc	a2,0x1
ffffffffc0201b90:	ab460613          	addi	a2,a2,-1356 # ffffffffc0202640 <etext+0x254>
ffffffffc0201b94:	12700593          	li	a1,295
ffffffffc0201b98:	00001517          	auipc	a0,0x1
ffffffffc0201b9c:	fc850513          	addi	a0,a0,-56 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ba0:	e28fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(((unsigned char*)obj2)[i] == 0x00);
ffffffffc0201ba4:	00001697          	auipc	a3,0x1
ffffffffc0201ba8:	11c68693          	addi	a3,a3,284 # ffffffffc0202cc0 <etext+0x8d4>
ffffffffc0201bac:	00001617          	auipc	a2,0x1
ffffffffc0201bb0:	a9460613          	addi	a2,a2,-1388 # ffffffffc0202640 <etext+0x254>
ffffffffc0201bb4:	0d900593          	li	a1,217
ffffffffc0201bb8:	00001517          	auipc	a0,0x1
ffffffffc0201bbc:	fa850513          	addi	a0,a0,-88 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201bc0:	e08fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(((unsigned char*)obj1)[i]==0x66);
ffffffffc0201bc4:	00001697          	auipc	a3,0x1
ffffffffc0201bc8:	0b468693          	addi	a3,a3,180 # ffffffffc0202c78 <etext+0x88c>
ffffffffc0201bcc:	00001617          	auipc	a2,0x1
ffffffffc0201bd0:	a7460613          	addi	a2,a2,-1420 # ffffffffc0202640 <etext+0x254>
ffffffffc0201bd4:	0d100593          	li	a1,209
ffffffffc0201bd8:	00001517          	auipc	a0,0x1
ffffffffc0201bdc:	f8850513          	addi	a0,a0,-120 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201be0:	de8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj1!=NULL);
ffffffffc0201be4:	00001697          	auipc	a3,0x1
ffffffffc0201be8:	06468693          	addi	a3,a3,100 # ffffffffc0202c48 <etext+0x85c>
ffffffffc0201bec:	00001617          	auipc	a2,0x1
ffffffffc0201bf0:	a5460613          	addi	a2,a2,-1452 # ffffffffc0202640 <etext+0x254>
ffffffffc0201bf4:	0cd00593          	li	a1,205
ffffffffc0201bf8:	00001517          	auipc	a0,0x1
ffffffffc0201bfc:	f6850513          	addi	a0,a0,-152 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201c00:	dc8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj==NULL);
ffffffffc0201c04:	00001697          	auipc	a3,0x1
ffffffffc0201c08:	01468693          	addi	a3,a3,20 # ffffffffc0202c18 <etext+0x82c>
ffffffffc0201c0c:	00001617          	auipc	a2,0x1
ffffffffc0201c10:	a3460613          	addi	a2,a2,-1484 # ffffffffc0202640 <etext+0x254>
ffffffffc0201c14:	0c700593          	li	a1,199
ffffffffc0201c18:	00001517          	auipc	a0,0x1
ffffffffc0201c1c:	f4850513          	addi	a0,a0,-184 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201c20:	da8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(caches[i].objs_num==nums[i]);
ffffffffc0201c24:	00001697          	auipc	a3,0x1
ffffffffc0201c28:	fd468693          	addi	a3,a3,-44 # ffffffffc0202bf8 <etext+0x80c>
ffffffffc0201c2c:	00001617          	auipc	a2,0x1
ffffffffc0201c30:	a1460613          	addi	a2,a2,-1516 # ffffffffc0202640 <etext+0x254>
ffffffffc0201c34:	0bf00593          	li	a1,191
ffffffffc0201c38:	00001517          	auipc	a0,0x1
ffffffffc0201c3c:	f2850513          	addi	a0,a0,-216 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201c40:	d88fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1);
ffffffffc0201c44:	00001697          	auipc	a3,0x1
ffffffffc0201c48:	30468693          	addi	a3,a3,772 # ffffffffc0202f48 <etext+0xb5c>
ffffffffc0201c4c:	00001617          	auipc	a2,0x1
ffffffffc0201c50:	9f460613          	addi	a2,a2,-1548 # ffffffffc0202640 <etext+0x254>
ffffffffc0201c54:	16100593          	li	a1,353
ffffffffc0201c58:	00001517          	auipc	a0,0x1
ffffffffc0201c5c:	f0850513          	addi	a0,a0,-248 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201c60:	d68fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-1);
ffffffffc0201c64:	00001697          	auipc	a3,0x1
ffffffffc0201c68:	35468693          	addi	a3,a3,852 # ffffffffc0202fb8 <etext+0xbcc>
ffffffffc0201c6c:	00001617          	auipc	a2,0x1
ffffffffc0201c70:	9d460613          	addi	a2,a2,-1580 # ffffffffc0202640 <etext+0x254>
ffffffffc0201c74:	15e00593          	li	a1,350
ffffffffc0201c78:	00001517          	auipc	a0,0x1
ffffffffc0201c7c:	ee850513          	addi	a0,a0,-280 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201c80:	d48fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-2);
ffffffffc0201c84:	00001697          	auipc	a3,0x1
ffffffffc0201c88:	38468693          	addi	a3,a3,900 # ffffffffc0203008 <etext+0xc1c>
ffffffffc0201c8c:	00001617          	auipc	a2,0x1
ffffffffc0201c90:	9b460613          	addi	a2,a2,-1612 # ffffffffc0202640 <etext+0x254>
ffffffffc0201c94:	15b00593          	li	a1,347
ffffffffc0201c98:	00001517          	auipc	a0,0x1
ffffffffc0201c9c:	ec850513          	addi	a0,a0,-312 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ca0:	d28fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201ca4:	00001697          	auipc	a3,0x1
ffffffffc0201ca8:	3bc68693          	addi	a3,a3,956 # ffffffffc0203060 <etext+0xc74>
ffffffffc0201cac:	00001617          	auipc	a2,0x1
ffffffffc0201cb0:	99460613          	addi	a2,a2,-1644 # ffffffffc0202640 <etext+0x254>
ffffffffc0201cb4:	15800593          	li	a1,344
ffffffffc0201cb8:	00001517          	auipc	a0,0x1
ffffffffc0201cbc:	ea850513          	addi	a0,a0,-344 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201cc0:	d08fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201cc4:	00001697          	auipc	a3,0x1
ffffffffc0201cc8:	39c68693          	addi	a3,a3,924 # ffffffffc0203060 <etext+0xc74>
ffffffffc0201ccc:	00001617          	auipc	a2,0x1
ffffffffc0201cd0:	97460613          	addi	a2,a2,-1676 # ffffffffc0202640 <etext+0x254>
ffffffffc0201cd4:	15500593          	li	a1,341
ffffffffc0201cd8:	00001517          	auipc	a0,0x1
ffffffffc0201cdc:	e8850513          	addi	a0,a0,-376 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ce0:	ce8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201ce4:	00001697          	auipc	a3,0x1
ffffffffc0201ce8:	44c68693          	addi	a3,a3,1100 # ffffffffc0203130 <etext+0xd44>
ffffffffc0201cec:	00001617          	auipc	a2,0x1
ffffffffc0201cf0:	95460613          	addi	a2,a2,-1708 # ffffffffc0202640 <etext+0x254>
ffffffffc0201cf4:	15200593          	li	a1,338
ffffffffc0201cf8:	00001517          	auipc	a0,0x1
ffffffffc0201cfc:	e6850513          	addi	a0,a0,-408 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201d00:	cc8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201d04:	00001697          	auipc	a3,0x1
ffffffffc0201d08:	42c68693          	addi	a3,a3,1068 # ffffffffc0203130 <etext+0xd44>
ffffffffc0201d0c:	00001617          	auipc	a2,0x1
ffffffffc0201d10:	93460613          	addi	a2,a2,-1740 # ffffffffc0202640 <etext+0x254>
ffffffffc0201d14:	14f00593          	li	a1,335
ffffffffc0201d18:	00001517          	auipc	a0,0x1
ffffffffc0201d1c:	e4850513          	addi	a0,a0,-440 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201d20:	ca8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-4);
ffffffffc0201d24:	00001697          	auipc	a3,0x1
ffffffffc0201d28:	40c68693          	addi	a3,a3,1036 # ffffffffc0203130 <etext+0xd44>
ffffffffc0201d2c:	00001617          	auipc	a2,0x1
ffffffffc0201d30:	91460613          	addi	a2,a2,-1772 # ffffffffc0202640 <etext+0x254>
ffffffffc0201d34:	14a00593          	li	a1,330
ffffffffc0201d38:	00001517          	auipc	a0,0x1
ffffffffc0201d3c:	e2850513          	addi	a0,a0,-472 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201d40:	c88fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj6!=NULL);
ffffffffc0201d44:	00001697          	auipc	a3,0x1
ffffffffc0201d48:	3ac68693          	addi	a3,a3,940 # ffffffffc02030f0 <etext+0xd04>
ffffffffc0201d4c:	00001617          	auipc	a2,0x1
ffffffffc0201d50:	8f460613          	addi	a2,a2,-1804 # ffffffffc0202640 <etext+0x254>
ffffffffc0201d54:	14800593          	li	a1,328
ffffffffc0201d58:	00001517          	auipc	a0,0x1
ffffffffc0201d5c:	e0850513          	addi	a0,a0,-504 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201d60:	c68fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201d64:	00001697          	auipc	a3,0x1
ffffffffc0201d68:	2fc68693          	addi	a3,a3,764 # ffffffffc0203060 <etext+0xc74>
ffffffffc0201d6c:	00001617          	auipc	a2,0x1
ffffffffc0201d70:	8d460613          	addi	a2,a2,-1836 # ffffffffc0202640 <etext+0x254>
ffffffffc0201d74:	14500593          	li	a1,325
ffffffffc0201d78:	00001517          	auipc	a0,0x1
ffffffffc0201d7c:	de850513          	addi	a0,a0,-536 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201d80:	c48fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(slub_nr_free_pages()==nr_3-(i+30)/31);
ffffffffc0201d84:	00001697          	auipc	a3,0x1
ffffffffc0201d88:	16468693          	addi	a3,a3,356 # ffffffffc0202ee8 <etext+0xafc>
ffffffffc0201d8c:	00001617          	auipc	a2,0x1
ffffffffc0201d90:	8b460613          	addi	a2,a2,-1868 # ffffffffc0202640 <etext+0x254>
ffffffffc0201d94:	11000593          	li	a1,272
ffffffffc0201d98:	00001517          	auipc	a0,0x1
ffffffffc0201d9c:	dc850513          	addi	a0,a0,-568 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201da0:	c28fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201da4:	00001697          	auipc	a3,0x1
ffffffffc0201da8:	2bc68693          	addi	a3,a3,700 # ffffffffc0203060 <etext+0xc74>
ffffffffc0201dac:	00001617          	auipc	a2,0x1
ffffffffc0201db0:	89460613          	addi	a2,a2,-1900 # ffffffffc0202640 <etext+0x254>
ffffffffc0201db4:	13a00593          	li	a1,314
ffffffffc0201db8:	00001517          	auipc	a0,0x1
ffffffffc0201dbc:	da850513          	addi	a0,a0,-600 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201dc0:	c08fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj4!=NULL);
ffffffffc0201dc4:	00001697          	auipc	a3,0x1
ffffffffc0201dc8:	2bc68693          	addi	a3,a3,700 # ffffffffc0203080 <etext+0xc94>
ffffffffc0201dcc:	00001617          	auipc	a2,0x1
ffffffffc0201dd0:	87460613          	addi	a2,a2,-1932 # ffffffffc0202640 <etext+0x254>
ffffffffc0201dd4:	13800593          	li	a1,312
ffffffffc0201dd8:	00001517          	auipc	a0,0x1
ffffffffc0201ddc:	d8850513          	addi	a0,a0,-632 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201de0:	be8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-3);
ffffffffc0201de4:	00001697          	auipc	a3,0x1
ffffffffc0201de8:	27c68693          	addi	a3,a3,636 # ffffffffc0203060 <etext+0xc74>
ffffffffc0201dec:	00001617          	auipc	a2,0x1
ffffffffc0201df0:	85460613          	addi	a2,a2,-1964 # ffffffffc0202640 <etext+0x254>
ffffffffc0201df4:	13400593          	li	a1,308
ffffffffc0201df8:	00001517          	auipc	a0,0x1
ffffffffc0201dfc:	d6850513          	addi	a0,a0,-664 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201e00:	bc8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj3!=NULL);
ffffffffc0201e04:	00001697          	auipc	a3,0x1
ffffffffc0201e08:	22468693          	addi	a3,a3,548 # ffffffffc0203028 <etext+0xc3c>
ffffffffc0201e0c:	00001617          	auipc	a2,0x1
ffffffffc0201e10:	83460613          	addi	a2,a2,-1996 # ffffffffc0202640 <etext+0x254>
ffffffffc0201e14:	13200593          	li	a1,306
ffffffffc0201e18:	00001517          	auipc	a0,0x1
ffffffffc0201e1c:	d4850513          	addi	a0,a0,-696 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201e20:	ba8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-2);
ffffffffc0201e24:	00001697          	auipc	a3,0x1
ffffffffc0201e28:	1e468693          	addi	a3,a3,484 # ffffffffc0203008 <etext+0xc1c>
ffffffffc0201e2c:	00001617          	auipc	a2,0x1
ffffffffc0201e30:	81460613          	addi	a2,a2,-2028 # ffffffffc0202640 <etext+0x254>
ffffffffc0201e34:	12e00593          	li	a1,302
ffffffffc0201e38:	00001517          	auipc	a0,0x1
ffffffffc0201e3c:	d2850513          	addi	a0,a0,-728 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201e40:	b88fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(obj2!=NULL);
ffffffffc0201e44:	00001697          	auipc	a3,0x1
ffffffffc0201e48:	19468693          	addi	a3,a3,404 # ffffffffc0202fd8 <etext+0xbec>
ffffffffc0201e4c:	00000617          	auipc	a2,0x0
ffffffffc0201e50:	7f460613          	addi	a2,a2,2036 # ffffffffc0202640 <etext+0x254>
ffffffffc0201e54:	12c00593          	li	a1,300
ffffffffc0201e58:	00001517          	auipc	a0,0x1
ffffffffc0201e5c:	d0850513          	addi	a0,a0,-760 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201e60:	b68fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1-1);
ffffffffc0201e64:	00001697          	auipc	a3,0x1
ffffffffc0201e68:	15468693          	addi	a3,a3,340 # ffffffffc0202fb8 <etext+0xbcc>
ffffffffc0201e6c:	00000617          	auipc	a2,0x0
ffffffffc0201e70:	7d460613          	addi	a2,a2,2004 # ffffffffc0202640 <etext+0x254>
ffffffffc0201e74:	12900593          	li	a1,297
ffffffffc0201e78:	00001517          	auipc	a0,0x1
ffffffffc0201e7c:	ce850513          	addi	a0,a0,-792 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201e80:	b48fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(slub_nr_free_pages()==nr_1-(i+125)/126);
ffffffffc0201e84:	00001697          	auipc	a3,0x1
ffffffffc0201e88:	01468693          	addi	a3,a3,20 # ffffffffc0202e98 <etext+0xaac>
ffffffffc0201e8c:	00000617          	auipc	a2,0x0
ffffffffc0201e90:	7b460613          	addi	a2,a2,1972 # ffffffffc0202640 <etext+0x254>
ffffffffc0201e94:	10400593          	li	a1,260
ffffffffc0201e98:	00001517          	auipc	a0,0x1
ffffffffc0201e9c:	cc850513          	addi	a0,a0,-824 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ea0:	b28fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(slub_nr_free_pages()==nr_1);
ffffffffc0201ea4:	00001697          	auipc	a3,0x1
ffffffffc0201ea8:	0a468693          	addi	a3,a3,164 # ffffffffc0202f48 <etext+0xb5c>
ffffffffc0201eac:	00000617          	auipc	a2,0x0
ffffffffc0201eb0:	79460613          	addi	a2,a2,1940 # ffffffffc0202640 <etext+0x254>
ffffffffc0201eb4:	11f00593          	li	a1,287
ffffffffc0201eb8:	00001517          	auipc	a0,0x1
ffffffffc0201ebc:	ca850513          	addi	a0,a0,-856 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ec0:	b08fe0ef          	jal	ffffffffc02001c8 <__panic>
                assert(objs_bulk[i]!=NULL);
ffffffffc0201ec4:	00001697          	auipc	a3,0x1
ffffffffc0201ec8:	06c68693          	addi	a3,a3,108 # ffffffffc0202f30 <etext+0xb44>
ffffffffc0201ecc:	00000617          	auipc	a2,0x0
ffffffffc0201ed0:	77460613          	addi	a2,a2,1908 # ffffffffc0202640 <etext+0x254>
ffffffffc0201ed4:	11b00593          	li	a1,283
ffffffffc0201ed8:	00001517          	auipc	a0,0x1
ffffffffc0201edc:	c8850513          	addi	a0,a0,-888 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201ee0:	ae8fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(objs_bulk[i+29999]==NULL); 
ffffffffc0201ee4:	00001697          	auipc	a3,0x1
ffffffffc0201ee8:	02c68693          	addi	a3,a3,44 # ffffffffc0202f10 <etext+0xb24>
ffffffffc0201eec:	00000617          	auipc	a2,0x0
ffffffffc0201ef0:	75460613          	addi	a2,a2,1876 # ffffffffc0202640 <etext+0x254>
ffffffffc0201ef4:	11600593          	li	a1,278
ffffffffc0201ef8:	00001517          	auipc	a0,0x1
ffffffffc0201efc:	c6850513          	addi	a0,a0,-920 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201f00:	ac8fe0ef          	jal	ffffffffc02001c8 <__panic>
        assert(nr_1==slub_nr_free_pages());
ffffffffc0201f04:	00001697          	auipc	a3,0x1
ffffffffc0201f08:	f7468693          	addi	a3,a3,-140 # ffffffffc0202e78 <etext+0xa8c>
ffffffffc0201f0c:	00000617          	auipc	a2,0x0
ffffffffc0201f10:	73460613          	addi	a2,a2,1844 # ffffffffc0202640 <etext+0x254>
ffffffffc0201f14:	0ff00593          	li	a1,255
ffffffffc0201f18:	00001517          	auipc	a0,0x1
ffffffffc0201f1c:	c4850513          	addi	a0,a0,-952 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201f20:	aa8fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(slub_nr_free_pages()==nr_2-(i+62)/63);
ffffffffc0201f24:	00001697          	auipc	a3,0x1
ffffffffc0201f28:	f9c68693          	addi	a3,a3,-100 # ffffffffc0202ec0 <etext+0xad4>
ffffffffc0201f2c:	00000617          	auipc	a2,0x0
ffffffffc0201f30:	71460613          	addi	a2,a2,1812 # ffffffffc0202640 <etext+0x254>
ffffffffc0201f34:	10a00593          	li	a1,266
ffffffffc0201f38:	00001517          	auipc	a0,0x1
ffffffffc0201f3c:	c2850513          	addi	a0,a0,-984 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201f40:	a88fe0ef          	jal	ffffffffc02001c8 <__panic>
            assert(test_objs[i] != NULL);
ffffffffc0201f44:	00001697          	auipc	a3,0x1
ffffffffc0201f48:	dfc68693          	addi	a3,a3,-516 # ffffffffc0202d40 <etext+0x954>
ffffffffc0201f4c:	00000617          	auipc	a2,0x0
ffffffffc0201f50:	6f460613          	addi	a2,a2,1780 # ffffffffc0202640 <etext+0x254>
ffffffffc0201f54:	0e500593          	li	a1,229
ffffffffc0201f58:	00001517          	auipc	a0,0x1
ffffffffc0201f5c:	c0850513          	addi	a0,a0,-1016 # ffffffffc0202b60 <etext+0x774>
ffffffffc0201f60:	a68fe0ef          	jal	ffffffffc02001c8 <__panic>

ffffffffc0201f64 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201f64:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201f66:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201f6a:	f022                	sd	s0,32(sp)
ffffffffc0201f6c:	ec26                	sd	s1,24(sp)
ffffffffc0201f6e:	e84a                	sd	s2,16(sp)
ffffffffc0201f70:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201f72:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201f76:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201f78:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201f7c:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201f80:	84aa                	mv	s1,a0
ffffffffc0201f82:	892e                	mv	s2,a1
    if (num >= base) {
ffffffffc0201f84:	03067d63          	bgeu	a2,a6,ffffffffc0201fbe <printnum+0x5a>
ffffffffc0201f88:	e44e                	sd	s3,8(sp)
ffffffffc0201f8a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201f8c:	4785                	li	a5,1
ffffffffc0201f8e:	00e7d763          	bge	a5,a4,ffffffffc0201f9c <printnum+0x38>
            putch(padc, putdat);
ffffffffc0201f92:	85ca                	mv	a1,s2
ffffffffc0201f94:	854e                	mv	a0,s3
        while (-- width > 0)
ffffffffc0201f96:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201f98:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201f9a:	fc65                	bnez	s0,ffffffffc0201f92 <printnum+0x2e>
ffffffffc0201f9c:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201f9e:	00001797          	auipc	a5,0x1
ffffffffc0201fa2:	21a78793          	addi	a5,a5,538 # ffffffffc02031b8 <etext+0xdcc>
ffffffffc0201fa6:	97d2                	add	a5,a5,s4
}
ffffffffc0201fa8:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201faa:	0007c503          	lbu	a0,0(a5)
}
ffffffffc0201fae:	70a2                	ld	ra,40(sp)
ffffffffc0201fb0:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201fb2:	85ca                	mv	a1,s2
ffffffffc0201fb4:	87a6                	mv	a5,s1
}
ffffffffc0201fb6:	6942                	ld	s2,16(sp)
ffffffffc0201fb8:	64e2                	ld	s1,24(sp)
ffffffffc0201fba:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201fbc:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201fbe:	03065633          	divu	a2,a2,a6
ffffffffc0201fc2:	8722                	mv	a4,s0
ffffffffc0201fc4:	fa1ff0ef          	jal	ffffffffc0201f64 <printnum>
ffffffffc0201fc8:	bfd9                	j	ffffffffc0201f9e <printnum+0x3a>

ffffffffc0201fca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201fca:	7119                	addi	sp,sp,-128
ffffffffc0201fcc:	f4a6                	sd	s1,104(sp)
ffffffffc0201fce:	f0ca                	sd	s2,96(sp)
ffffffffc0201fd0:	ecce                	sd	s3,88(sp)
ffffffffc0201fd2:	e8d2                	sd	s4,80(sp)
ffffffffc0201fd4:	e4d6                	sd	s5,72(sp)
ffffffffc0201fd6:	e0da                	sd	s6,64(sp)
ffffffffc0201fd8:	f862                	sd	s8,48(sp)
ffffffffc0201fda:	fc86                	sd	ra,120(sp)
ffffffffc0201fdc:	f8a2                	sd	s0,112(sp)
ffffffffc0201fde:	fc5e                	sd	s7,56(sp)
ffffffffc0201fe0:	f466                	sd	s9,40(sp)
ffffffffc0201fe2:	f06a                	sd	s10,32(sp)
ffffffffc0201fe4:	ec6e                	sd	s11,24(sp)
ffffffffc0201fe6:	84aa                	mv	s1,a0
ffffffffc0201fe8:	8c32                	mv	s8,a2
ffffffffc0201fea:	8a36                	mv	s4,a3
ffffffffc0201fec:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201fee:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ff2:	05500b13          	li	s6,85
ffffffffc0201ff6:	00001a97          	auipc	s5,0x1
ffffffffc0201ffa:	30aa8a93          	addi	s5,s5,778 # ffffffffc0203300 <slub_pmm_manager+0x38>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201ffe:	000c4503          	lbu	a0,0(s8)
ffffffffc0202002:	001c0413          	addi	s0,s8,1
ffffffffc0202006:	01350a63          	beq	a0,s3,ffffffffc020201a <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc020200a:	cd0d                	beqz	a0,ffffffffc0202044 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc020200c:	85ca                	mv	a1,s2
ffffffffc020200e:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0202010:	00044503          	lbu	a0,0(s0)
ffffffffc0202014:	0405                	addi	s0,s0,1
ffffffffc0202016:	ff351ae3          	bne	a0,s3,ffffffffc020200a <vprintfmt+0x40>
        width = precision = -1;
ffffffffc020201a:	5cfd                	li	s9,-1
ffffffffc020201c:	8d66                	mv	s10,s9
        char padc = ' ';
ffffffffc020201e:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0202022:	4b81                	li	s7,0
ffffffffc0202024:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0202026:	00044683          	lbu	a3,0(s0)
ffffffffc020202a:	00140c13          	addi	s8,s0,1
ffffffffc020202e:	fdd6859b          	addiw	a1,a3,-35
ffffffffc0202032:	0ff5f593          	zext.b	a1,a1
ffffffffc0202036:	02bb6663          	bltu	s6,a1,ffffffffc0202062 <vprintfmt+0x98>
ffffffffc020203a:	058a                	slli	a1,a1,0x2
ffffffffc020203c:	95d6                	add	a1,a1,s5
ffffffffc020203e:	4198                	lw	a4,0(a1)
ffffffffc0202040:	9756                	add	a4,a4,s5
ffffffffc0202042:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0202044:	70e6                	ld	ra,120(sp)
ffffffffc0202046:	7446                	ld	s0,112(sp)
ffffffffc0202048:	74a6                	ld	s1,104(sp)
ffffffffc020204a:	7906                	ld	s2,96(sp)
ffffffffc020204c:	69e6                	ld	s3,88(sp)
ffffffffc020204e:	6a46                	ld	s4,80(sp)
ffffffffc0202050:	6aa6                	ld	s5,72(sp)
ffffffffc0202052:	6b06                	ld	s6,64(sp)
ffffffffc0202054:	7be2                	ld	s7,56(sp)
ffffffffc0202056:	7c42                	ld	s8,48(sp)
ffffffffc0202058:	7ca2                	ld	s9,40(sp)
ffffffffc020205a:	7d02                	ld	s10,32(sp)
ffffffffc020205c:	6de2                	ld	s11,24(sp)
ffffffffc020205e:	6109                	addi	sp,sp,128
ffffffffc0202060:	8082                	ret
            putch('%', putdat);
ffffffffc0202062:	85ca                	mv	a1,s2
ffffffffc0202064:	02500513          	li	a0,37
ffffffffc0202068:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020206a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020206e:	02500713          	li	a4,37
ffffffffc0202072:	8c22                	mv	s8,s0
ffffffffc0202074:	f8e785e3          	beq	a5,a4,ffffffffc0201ffe <vprintfmt+0x34>
ffffffffc0202078:	ffec4783          	lbu	a5,-2(s8)
ffffffffc020207c:	1c7d                	addi	s8,s8,-1
ffffffffc020207e:	fee79de3          	bne	a5,a4,ffffffffc0202078 <vprintfmt+0xae>
ffffffffc0202082:	bfb5                	j	ffffffffc0201ffe <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0202084:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0202088:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
ffffffffc020208a:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc020208e:	fd06071b          	addiw	a4,a2,-48
ffffffffc0202092:	24e56a63          	bltu	a0,a4,ffffffffc02022e6 <vprintfmt+0x31c>
                ch = *fmt;
ffffffffc0202096:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0202098:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
ffffffffc020209a:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
ffffffffc020209e:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02020a2:	0197073b          	addw	a4,a4,s9
ffffffffc02020a6:	0017171b          	slliw	a4,a4,0x1
ffffffffc02020aa:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
ffffffffc02020ac:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02020b0:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02020b2:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc02020b6:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
ffffffffc02020ba:	feb570e3          	bgeu	a0,a1,ffffffffc020209a <vprintfmt+0xd0>
            if (width < 0)
ffffffffc02020be:	f60d54e3          	bgez	s10,ffffffffc0202026 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc02020c2:	8d66                	mv	s10,s9
ffffffffc02020c4:	5cfd                	li	s9,-1
ffffffffc02020c6:	b785                	j	ffffffffc0202026 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02020c8:	8db6                	mv	s11,a3
ffffffffc02020ca:	8462                	mv	s0,s8
ffffffffc02020cc:	bfa9                	j	ffffffffc0202026 <vprintfmt+0x5c>
ffffffffc02020ce:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc02020d0:	4b85                	li	s7,1
            goto reswitch;
ffffffffc02020d2:	bf91                	j	ffffffffc0202026 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc02020d4:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02020d6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02020da:	00f74463          	blt	a4,a5,ffffffffc02020e2 <vprintfmt+0x118>
    else if (lflag) {
ffffffffc02020de:	1a078763          	beqz	a5,ffffffffc020228c <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
ffffffffc02020e2:	000a3603          	ld	a2,0(s4)
ffffffffc02020e6:	46c1                	li	a3,16
ffffffffc02020e8:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02020ea:	000d879b          	sext.w	a5,s11
ffffffffc02020ee:	876a                	mv	a4,s10
ffffffffc02020f0:	85ca                	mv	a1,s2
ffffffffc02020f2:	8526                	mv	a0,s1
ffffffffc02020f4:	e71ff0ef          	jal	ffffffffc0201f64 <printnum>
            break;
ffffffffc02020f8:	b719                	j	ffffffffc0201ffe <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc02020fa:	000a2503          	lw	a0,0(s4)
ffffffffc02020fe:	85ca                	mv	a1,s2
ffffffffc0202100:	0a21                	addi	s4,s4,8
ffffffffc0202102:	9482                	jalr	s1
            break;
ffffffffc0202104:	bded                	j	ffffffffc0201ffe <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0202106:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0202108:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020210c:	00f74463          	blt	a4,a5,ffffffffc0202114 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0202110:	16078963          	beqz	a5,ffffffffc0202282 <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
ffffffffc0202114:	000a3603          	ld	a2,0(s4)
ffffffffc0202118:	46a9                	li	a3,10
ffffffffc020211a:	8a2e                	mv	s4,a1
ffffffffc020211c:	b7f9                	j	ffffffffc02020ea <vprintfmt+0x120>
            putch('0', putdat);
ffffffffc020211e:	85ca                	mv	a1,s2
ffffffffc0202120:	03000513          	li	a0,48
ffffffffc0202124:	9482                	jalr	s1
            putch('x', putdat);
ffffffffc0202126:	85ca                	mv	a1,s2
ffffffffc0202128:	07800513          	li	a0,120
ffffffffc020212c:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020212e:	000a3603          	ld	a2,0(s4)
            goto number;
ffffffffc0202132:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0202134:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0202136:	bf55                	j	ffffffffc02020ea <vprintfmt+0x120>
            putch(ch, putdat);
ffffffffc0202138:	85ca                	mv	a1,s2
ffffffffc020213a:	02500513          	li	a0,37
ffffffffc020213e:	9482                	jalr	s1
            break;
ffffffffc0202140:	bd7d                	j	ffffffffc0201ffe <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0202142:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0202146:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0202148:	0a21                	addi	s4,s4,8
            goto process_precision;
ffffffffc020214a:	bf95                	j	ffffffffc02020be <vprintfmt+0xf4>
    if (lflag >= 2) {
ffffffffc020214c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020214e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0202152:	00f74463          	blt	a4,a5,ffffffffc020215a <vprintfmt+0x190>
    else if (lflag) {
ffffffffc0202156:	12078163          	beqz	a5,ffffffffc0202278 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
ffffffffc020215a:	000a3603          	ld	a2,0(s4)
ffffffffc020215e:	46a1                	li	a3,8
ffffffffc0202160:	8a2e                	mv	s4,a1
ffffffffc0202162:	b761                	j	ffffffffc02020ea <vprintfmt+0x120>
            if (width < 0)
ffffffffc0202164:	876a                	mv	a4,s10
ffffffffc0202166:	000d5363          	bgez	s10,ffffffffc020216c <vprintfmt+0x1a2>
ffffffffc020216a:	4701                	li	a4,0
ffffffffc020216c:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0202170:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0202172:	bd55                	j	ffffffffc0202026 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
ffffffffc0202174:	000d841b          	sext.w	s0,s11
ffffffffc0202178:	fd340793          	addi	a5,s0,-45
ffffffffc020217c:	00f037b3          	snez	a5,a5
ffffffffc0202180:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0202184:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
ffffffffc0202188:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020218a:	008a0793          	addi	a5,s4,8
ffffffffc020218e:	e43e                	sd	a5,8(sp)
ffffffffc0202190:	100d8c63          	beqz	s11,ffffffffc02022a8 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
ffffffffc0202194:	12071363          	bnez	a4,ffffffffc02022ba <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0202198:	000dc783          	lbu	a5,0(s11)
ffffffffc020219c:	0007851b          	sext.w	a0,a5
ffffffffc02021a0:	c78d                	beqz	a5,ffffffffc02021ca <vprintfmt+0x200>
ffffffffc02021a2:	0d85                	addi	s11,s11,1
ffffffffc02021a4:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02021a6:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02021aa:	000cc563          	bltz	s9,ffffffffc02021b4 <vprintfmt+0x1ea>
ffffffffc02021ae:	3cfd                	addiw	s9,s9,-1
ffffffffc02021b0:	008c8d63          	beq	s9,s0,ffffffffc02021ca <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02021b4:	020b9663          	bnez	s7,ffffffffc02021e0 <vprintfmt+0x216>
                    putch(ch, putdat);
ffffffffc02021b8:	85ca                	mv	a1,s2
ffffffffc02021ba:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02021bc:	000dc783          	lbu	a5,0(s11)
ffffffffc02021c0:	0d85                	addi	s11,s11,1
ffffffffc02021c2:	3d7d                	addiw	s10,s10,-1
ffffffffc02021c4:	0007851b          	sext.w	a0,a5
ffffffffc02021c8:	f3ed                	bnez	a5,ffffffffc02021aa <vprintfmt+0x1e0>
            for (; width > 0; width --) {
ffffffffc02021ca:	01a05963          	blez	s10,ffffffffc02021dc <vprintfmt+0x212>
                putch(' ', putdat);
ffffffffc02021ce:	85ca                	mv	a1,s2
ffffffffc02021d0:	02000513          	li	a0,32
            for (; width > 0; width --) {
ffffffffc02021d4:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
ffffffffc02021d6:	9482                	jalr	s1
            for (; width > 0; width --) {
ffffffffc02021d8:	fe0d1be3          	bnez	s10,ffffffffc02021ce <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02021dc:	6a22                	ld	s4,8(sp)
ffffffffc02021de:	b505                	j	ffffffffc0201ffe <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02021e0:	3781                	addiw	a5,a5,-32
ffffffffc02021e2:	fcfa7be3          	bgeu	s4,a5,ffffffffc02021b8 <vprintfmt+0x1ee>
                    putch('?', putdat);
ffffffffc02021e6:	03f00513          	li	a0,63
ffffffffc02021ea:	85ca                	mv	a1,s2
ffffffffc02021ec:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02021ee:	000dc783          	lbu	a5,0(s11)
ffffffffc02021f2:	0d85                	addi	s11,s11,1
ffffffffc02021f4:	3d7d                	addiw	s10,s10,-1
ffffffffc02021f6:	0007851b          	sext.w	a0,a5
ffffffffc02021fa:	dbe1                	beqz	a5,ffffffffc02021ca <vprintfmt+0x200>
ffffffffc02021fc:	fa0cd9e3          	bgez	s9,ffffffffc02021ae <vprintfmt+0x1e4>
ffffffffc0202200:	b7c5                	j	ffffffffc02021e0 <vprintfmt+0x216>
            if (err < 0) {
ffffffffc0202202:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0202206:	4619                	li	a2,6
            err = va_arg(ap, int);
ffffffffc0202208:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020220a:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020220e:	8fb9                	xor	a5,a5,a4
ffffffffc0202210:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0202214:	02d64563          	blt	a2,a3,ffffffffc020223e <vprintfmt+0x274>
ffffffffc0202218:	00001797          	auipc	a5,0x1
ffffffffc020221c:	24078793          	addi	a5,a5,576 # ffffffffc0203458 <error_string>
ffffffffc0202220:	00369713          	slli	a4,a3,0x3
ffffffffc0202224:	97ba                	add	a5,a5,a4
ffffffffc0202226:	639c                	ld	a5,0(a5)
ffffffffc0202228:	cb99                	beqz	a5,ffffffffc020223e <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
ffffffffc020222a:	86be                	mv	a3,a5
ffffffffc020222c:	00001617          	auipc	a2,0x1
ffffffffc0202230:	fbc60613          	addi	a2,a2,-68 # ffffffffc02031e8 <etext+0xdfc>
ffffffffc0202234:	85ca                	mv	a1,s2
ffffffffc0202236:	8526                	mv	a0,s1
ffffffffc0202238:	0d8000ef          	jal	ffffffffc0202310 <printfmt>
ffffffffc020223c:	b3c9                	j	ffffffffc0201ffe <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020223e:	00001617          	auipc	a2,0x1
ffffffffc0202242:	f9a60613          	addi	a2,a2,-102 # ffffffffc02031d8 <etext+0xdec>
ffffffffc0202246:	85ca                	mv	a1,s2
ffffffffc0202248:	8526                	mv	a0,s1
ffffffffc020224a:	0c6000ef          	jal	ffffffffc0202310 <printfmt>
ffffffffc020224e:	bb45                	j	ffffffffc0201ffe <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0202250:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0202252:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
ffffffffc0202256:	00f74363          	blt	a4,a5,ffffffffc020225c <vprintfmt+0x292>
    else if (lflag) {
ffffffffc020225a:	cf81                	beqz	a5,ffffffffc0202272 <vprintfmt+0x2a8>
        return va_arg(*ap, long);
ffffffffc020225c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0202260:	02044b63          	bltz	s0,ffffffffc0202296 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
ffffffffc0202264:	8622                	mv	a2,s0
ffffffffc0202266:	8a5e                	mv	s4,s7
ffffffffc0202268:	46a9                	li	a3,10
ffffffffc020226a:	b541                	j	ffffffffc02020ea <vprintfmt+0x120>
            lflag ++;
ffffffffc020226c:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020226e:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0202270:	bb5d                	j	ffffffffc0202026 <vprintfmt+0x5c>
        return va_arg(*ap, int);
ffffffffc0202272:	000a2403          	lw	s0,0(s4)
ffffffffc0202276:	b7ed                	j	ffffffffc0202260 <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
ffffffffc0202278:	000a6603          	lwu	a2,0(s4)
ffffffffc020227c:	46a1                	li	a3,8
ffffffffc020227e:	8a2e                	mv	s4,a1
ffffffffc0202280:	b5ad                	j	ffffffffc02020ea <vprintfmt+0x120>
ffffffffc0202282:	000a6603          	lwu	a2,0(s4)
ffffffffc0202286:	46a9                	li	a3,10
ffffffffc0202288:	8a2e                	mv	s4,a1
ffffffffc020228a:	b585                	j	ffffffffc02020ea <vprintfmt+0x120>
ffffffffc020228c:	000a6603          	lwu	a2,0(s4)
ffffffffc0202290:	46c1                	li	a3,16
ffffffffc0202292:	8a2e                	mv	s4,a1
ffffffffc0202294:	bd99                	j	ffffffffc02020ea <vprintfmt+0x120>
                putch('-', putdat);
ffffffffc0202296:	85ca                	mv	a1,s2
ffffffffc0202298:	02d00513          	li	a0,45
ffffffffc020229c:	9482                	jalr	s1
                num = -(long long)num;
ffffffffc020229e:	40800633          	neg	a2,s0
ffffffffc02022a2:	8a5e                	mv	s4,s7
ffffffffc02022a4:	46a9                	li	a3,10
ffffffffc02022a6:	b591                	j	ffffffffc02020ea <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
ffffffffc02022a8:	e329                	bnez	a4,ffffffffc02022ea <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02022aa:	02800793          	li	a5,40
ffffffffc02022ae:	853e                	mv	a0,a5
ffffffffc02022b0:	00001d97          	auipc	s11,0x1
ffffffffc02022b4:	f21d8d93          	addi	s11,s11,-223 # ffffffffc02031d1 <etext+0xde5>
ffffffffc02022b8:	b5f5                	j	ffffffffc02021a4 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02022ba:	85e6                	mv	a1,s9
ffffffffc02022bc:	856e                	mv	a0,s11
ffffffffc02022be:	0a4000ef          	jal	ffffffffc0202362 <strnlen>
ffffffffc02022c2:	40ad0d3b          	subw	s10,s10,a0
ffffffffc02022c6:	01a05863          	blez	s10,ffffffffc02022d6 <vprintfmt+0x30c>
                    putch(padc, putdat);
ffffffffc02022ca:	85ca                	mv	a1,s2
ffffffffc02022cc:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02022ce:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
ffffffffc02022d0:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02022d2:	fe0d1ce3          	bnez	s10,ffffffffc02022ca <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02022d6:	000dc783          	lbu	a5,0(s11)
ffffffffc02022da:	0007851b          	sext.w	a0,a5
ffffffffc02022de:	ec0792e3          	bnez	a5,ffffffffc02021a2 <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02022e2:	6a22                	ld	s4,8(sp)
ffffffffc02022e4:	bb29                	j	ffffffffc0201ffe <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02022e6:	8462                	mv	s0,s8
ffffffffc02022e8:	bbd9                	j	ffffffffc02020be <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02022ea:	85e6                	mv	a1,s9
ffffffffc02022ec:	00001517          	auipc	a0,0x1
ffffffffc02022f0:	ee450513          	addi	a0,a0,-284 # ffffffffc02031d0 <etext+0xde4>
ffffffffc02022f4:	06e000ef          	jal	ffffffffc0202362 <strnlen>
ffffffffc02022f8:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02022fc:	02800793          	li	a5,40
                p = "(null)";
ffffffffc0202300:	00001d97          	auipc	s11,0x1
ffffffffc0202304:	ed0d8d93          	addi	s11,s11,-304 # ffffffffc02031d0 <etext+0xde4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0202308:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020230a:	fda040e3          	bgtz	s10,ffffffffc02022ca <vprintfmt+0x300>
ffffffffc020230e:	bd51                	j	ffffffffc02021a2 <vprintfmt+0x1d8>

ffffffffc0202310 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0202310:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0202312:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0202316:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0202318:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020231a:	ec06                	sd	ra,24(sp)
ffffffffc020231c:	f83a                	sd	a4,48(sp)
ffffffffc020231e:	fc3e                	sd	a5,56(sp)
ffffffffc0202320:	e0c2                	sd	a6,64(sp)
ffffffffc0202322:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0202324:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0202326:	ca5ff0ef          	jal	ffffffffc0201fca <vprintfmt>
}
ffffffffc020232a:	60e2                	ld	ra,24(sp)
ffffffffc020232c:	6161                	addi	sp,sp,80
ffffffffc020232e:	8082                	ret

ffffffffc0202330 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0202330:	00005717          	auipc	a4,0x5
ffffffffc0202334:	ce073703          	ld	a4,-800(a4) # ffffffffc0207010 <SBI_CONSOLE_PUTCHAR>
ffffffffc0202338:	4781                	li	a5,0
ffffffffc020233a:	88ba                	mv	a7,a4
ffffffffc020233c:	852a                	mv	a0,a0
ffffffffc020233e:	85be                	mv	a1,a5
ffffffffc0202340:	863e                	mv	a2,a5
ffffffffc0202342:	00000073          	ecall
ffffffffc0202346:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0202348:	8082                	ret

ffffffffc020234a <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc020234a:	00054783          	lbu	a5,0(a0)
ffffffffc020234e:	cb81                	beqz	a5,ffffffffc020235e <strlen+0x14>
    size_t cnt = 0;
ffffffffc0202350:	4781                	li	a5,0
        cnt ++;
ffffffffc0202352:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0202354:	00f50733          	add	a4,a0,a5
ffffffffc0202358:	00074703          	lbu	a4,0(a4)
ffffffffc020235c:	fb7d                	bnez	a4,ffffffffc0202352 <strlen+0x8>
    }
    return cnt;
}
ffffffffc020235e:	853e                	mv	a0,a5
ffffffffc0202360:	8082                	ret

ffffffffc0202362 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0202362:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0202364:	e589                	bnez	a1,ffffffffc020236e <strnlen+0xc>
ffffffffc0202366:	a811                	j	ffffffffc020237a <strnlen+0x18>
        cnt ++;
ffffffffc0202368:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020236a:	00f58863          	beq	a1,a5,ffffffffc020237a <strnlen+0x18>
ffffffffc020236e:	00f50733          	add	a4,a0,a5
ffffffffc0202372:	00074703          	lbu	a4,0(a4)
ffffffffc0202376:	fb6d                	bnez	a4,ffffffffc0202368 <strnlen+0x6>
ffffffffc0202378:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020237a:	852e                	mv	a0,a1
ffffffffc020237c:	8082                	ret

ffffffffc020237e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020237e:	00054783          	lbu	a5,0(a0)
ffffffffc0202382:	e791                	bnez	a5,ffffffffc020238e <strcmp+0x10>
ffffffffc0202384:	a01d                	j	ffffffffc02023aa <strcmp+0x2c>
ffffffffc0202386:	00054783          	lbu	a5,0(a0)
ffffffffc020238a:	cb99                	beqz	a5,ffffffffc02023a0 <strcmp+0x22>
ffffffffc020238c:	0585                	addi	a1,a1,1
ffffffffc020238e:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0202392:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0202394:	fef709e3          	beq	a4,a5,ffffffffc0202386 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0202398:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020239c:	9d19                	subw	a0,a0,a4
ffffffffc020239e:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02023a0:	0015c703          	lbu	a4,1(a1)
ffffffffc02023a4:	4501                	li	a0,0
}
ffffffffc02023a6:	9d19                	subw	a0,a0,a4
ffffffffc02023a8:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02023aa:	0005c703          	lbu	a4,0(a1)
ffffffffc02023ae:	4501                	li	a0,0
ffffffffc02023b0:	b7f5                	j	ffffffffc020239c <strcmp+0x1e>

ffffffffc02023b2 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02023b2:	ce01                	beqz	a2,ffffffffc02023ca <strncmp+0x18>
ffffffffc02023b4:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02023b8:	167d                	addi	a2,a2,-1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02023ba:	cb91                	beqz	a5,ffffffffc02023ce <strncmp+0x1c>
ffffffffc02023bc:	0005c703          	lbu	a4,0(a1)
ffffffffc02023c0:	00f71763          	bne	a4,a5,ffffffffc02023ce <strncmp+0x1c>
        n --, s1 ++, s2 ++;
ffffffffc02023c4:	0505                	addi	a0,a0,1
ffffffffc02023c6:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02023c8:	f675                	bnez	a2,ffffffffc02023b4 <strncmp+0x2>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02023ca:	4501                	li	a0,0
ffffffffc02023cc:	8082                	ret
ffffffffc02023ce:	00054503          	lbu	a0,0(a0)
ffffffffc02023d2:	0005c783          	lbu	a5,0(a1)
ffffffffc02023d6:	9d1d                	subw	a0,a0,a5
}
ffffffffc02023d8:	8082                	ret

ffffffffc02023da <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02023da:	ca01                	beqz	a2,ffffffffc02023ea <memset+0x10>
ffffffffc02023dc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02023de:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02023e0:	0785                	addi	a5,a5,1
ffffffffc02023e2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02023e6:	fef61de3          	bne	a2,a5,ffffffffc02023e0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02023ea:	8082                	ret
