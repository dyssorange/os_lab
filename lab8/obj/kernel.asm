
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0212ff0 <bootstack+0x1ff0>
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	54b0b0ef          	jal	ffffffffc020bdac <memset>
ffffffffc0200066:	4da000ef          	jal	ffffffffc0200540 <cons_init>
ffffffffc020006a:	0000c597          	auipc	a1,0xc
ffffffffc020006e:	dae58593          	addi	a1,a1,-594 # ffffffffc020be18 <etext+0x4>
ffffffffc0200072:	0000c517          	auipc	a0,0xc
ffffffffc0200076:	dc650513          	addi	a0,a0,-570 # ffffffffc020be38 <etext+0x24>
ffffffffc020007a:	12c000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200082:	5f4000ef          	jal	ffffffffc0200676 <dtb_init>
ffffffffc0200086:	2d7020ef          	jal	ffffffffc0202b5c <pmm_init>
ffffffffc020008a:	355000ef          	jal	ffffffffc0200bde <pic_init>
ffffffffc020008e:	477000ef          	jal	ffffffffc0200d04 <idt_init>
ffffffffc0200092:	7e1030ef          	jal	ffffffffc0204072 <vmm_init>
ffffffffc0200096:	105070ef          	jal	ffffffffc020799a <sched_init>
ffffffffc020009a:	7db060ef          	jal	ffffffffc0207074 <proc_init>
ffffffffc020009e:	11f000ef          	jal	ffffffffc02009bc <ide_init>
ffffffffc02000a2:	236050ef          	jal	ffffffffc02052d8 <fs_init>
ffffffffc02000a6:	452000ef          	jal	ffffffffc02004f8 <clock_init>
ffffffffc02000aa:	329000ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02000ae:	19a070ef          	jal	ffffffffc0207248 <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	7179                	addi	sp,sp,-48
ffffffffc02000b4:	f406                	sd	ra,40(sp)
ffffffffc02000b6:	f022                	sd	s0,32(sp)
ffffffffc02000b8:	ec26                	sd	s1,24(sp)
ffffffffc02000ba:	e84a                	sd	s2,16(sp)
ffffffffc02000bc:	e44e                	sd	s3,8(sp)
ffffffffc02000be:	c901                	beqz	a0,ffffffffc02000ce <readline+0x1c>
ffffffffc02000c0:	85aa                	mv	a1,a0
ffffffffc02000c2:	0000c517          	auipc	a0,0xc
ffffffffc02000c6:	d7e50513          	addi	a0,a0,-642 # ffffffffc020be40 <etext+0x2c>
ffffffffc02000ca:	0dc000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02000ce:	4481                	li	s1,0
ffffffffc02000d0:	497d                	li	s2,31
ffffffffc02000d2:	00091997          	auipc	s3,0x91
ffffffffc02000d6:	f8e98993          	addi	s3,s3,-114 # ffffffffc0291060 <buf>
ffffffffc02000da:	108000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc02000de:	842a                	mv	s0,a0
ffffffffc02000e0:	ff850793          	addi	a5,a0,-8
ffffffffc02000e4:	3ff4a713          	slti	a4,s1,1023
ffffffffc02000e8:	ff650693          	addi	a3,a0,-10
ffffffffc02000ec:	ff350613          	addi	a2,a0,-13
ffffffffc02000f0:	02054963          	bltz	a0,ffffffffc0200122 <readline+0x70>
ffffffffc02000f4:	02a95f63          	bge	s2,a0,ffffffffc0200132 <readline+0x80>
ffffffffc02000f8:	cf0d                	beqz	a4,ffffffffc0200132 <readline+0x80>
ffffffffc02000fa:	0e6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02000fe:	009987b3          	add	a5,s3,s1
ffffffffc0200102:	00878023          	sb	s0,0(a5)
ffffffffc0200106:	2485                	addiw	s1,s1,1
ffffffffc0200108:	0da000ef          	jal	ffffffffc02001e2 <getchar>
ffffffffc020010c:	842a                	mv	s0,a0
ffffffffc020010e:	ff850793          	addi	a5,a0,-8
ffffffffc0200112:	3ff4a713          	slti	a4,s1,1023
ffffffffc0200116:	ff650693          	addi	a3,a0,-10
ffffffffc020011a:	ff350613          	addi	a2,a0,-13
ffffffffc020011e:	fc055be3          	bgez	a0,ffffffffc02000f4 <readline+0x42>
ffffffffc0200122:	70a2                	ld	ra,40(sp)
ffffffffc0200124:	7402                	ld	s0,32(sp)
ffffffffc0200126:	64e2                	ld	s1,24(sp)
ffffffffc0200128:	6942                	ld	s2,16(sp)
ffffffffc020012a:	69a2                	ld	s3,8(sp)
ffffffffc020012c:	4501                	li	a0,0
ffffffffc020012e:	6145                	addi	sp,sp,48
ffffffffc0200130:	8082                	ret
ffffffffc0200132:	eb81                	bnez	a5,ffffffffc0200142 <readline+0x90>
ffffffffc0200134:	4521                	li	a0,8
ffffffffc0200136:	00905663          	blez	s1,ffffffffc0200142 <readline+0x90>
ffffffffc020013a:	0a6000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020013e:	34fd                	addiw	s1,s1,-1
ffffffffc0200140:	bf69                	j	ffffffffc02000da <readline+0x28>
ffffffffc0200142:	c291                	beqz	a3,ffffffffc0200146 <readline+0x94>
ffffffffc0200144:	fa59                	bnez	a2,ffffffffc02000da <readline+0x28>
ffffffffc0200146:	8522                	mv	a0,s0
ffffffffc0200148:	098000ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc020014c:	00091517          	auipc	a0,0x91
ffffffffc0200150:	f1450513          	addi	a0,a0,-236 # ffffffffc0291060 <buf>
ffffffffc0200154:	94aa                	add	s1,s1,a0
ffffffffc0200156:	00048023          	sb	zero,0(s1)
ffffffffc020015a:	70a2                	ld	ra,40(sp)
ffffffffc020015c:	7402                	ld	s0,32(sp)
ffffffffc020015e:	64e2                	ld	s1,24(sp)
ffffffffc0200160:	6942                	ld	s2,16(sp)
ffffffffc0200162:	69a2                	ld	s3,8(sp)
ffffffffc0200164:	6145                	addi	sp,sp,48
ffffffffc0200166:	8082                	ret

ffffffffc0200168 <cputch>:
ffffffffc0200168:	1101                	addi	sp,sp,-32
ffffffffc020016a:	ec06                	sd	ra,24(sp)
ffffffffc020016c:	e42e                	sd	a1,8(sp)
ffffffffc020016e:	3e0000ef          	jal	ffffffffc020054e <cons_putc>
ffffffffc0200172:	65a2                	ld	a1,8(sp)
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	419c                	lw	a5,0(a1)
ffffffffc0200178:	2785                	addiw	a5,a5,1
ffffffffc020017a:	c19c                	sw	a5,0(a1)
ffffffffc020017c:	6105                	addi	sp,sp,32
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fde50513          	addi	a0,a0,-34 # ffffffffc0200168 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	7760b0ef          	jal	ffffffffc020b910 <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40
ffffffffc02001ac:	f42e                	sd	a1,40(sp)
ffffffffc02001ae:	75dd                	lui	a1,0xffff7
ffffffffc02001b0:	f832                	sd	a2,48(sp)
ffffffffc02001b2:	fc36                	sd	a3,56(sp)
ffffffffc02001b4:	e0ba                	sd	a4,64(sp)
ffffffffc02001b6:	86aa                	mv	a3,a0
ffffffffc02001b8:	0050                	addi	a2,sp,4
ffffffffc02001ba:	00000517          	auipc	a0,0x0
ffffffffc02001be:	fae50513          	addi	a0,a0,-82 # ffffffffc0200168 <cputch>
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001c8:	ec06                	sd	ra,24(sp)
ffffffffc02001ca:	e4be                	sd	a5,72(sp)
ffffffffc02001cc:	e8c2                	sd	a6,80(sp)
ffffffffc02001ce:	ecc6                	sd	a7,88(sp)
ffffffffc02001d0:	c202                	sw	zero,4(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	73c0b0ef          	jal	ffffffffc020b910 <vprintfmt>
ffffffffc02001d8:	60e2                	ld	ra,24(sp)
ffffffffc02001da:	4512                	lw	a0,4(sp)
ffffffffc02001dc:	6125                	addi	sp,sp,96
ffffffffc02001de:	8082                	ret

ffffffffc02001e0 <cputchar>:
ffffffffc02001e0:	a6bd                	j	ffffffffc020054e <cons_putc>

ffffffffc02001e2 <getchar>:
ffffffffc02001e2:	1141                	addi	sp,sp,-16
ffffffffc02001e4:	e406                	sd	ra,8(sp)
ffffffffc02001e6:	3d0000ef          	jal	ffffffffc02005b6 <cons_getc>
ffffffffc02001ea:	dd75                	beqz	a0,ffffffffc02001e6 <getchar+0x4>
ffffffffc02001ec:	60a2                	ld	ra,8(sp)
ffffffffc02001ee:	0141                	addi	sp,sp,16
ffffffffc02001f0:	8082                	ret

ffffffffc02001f2 <strdup>:
ffffffffc02001f2:	7179                	addi	sp,sp,-48
ffffffffc02001f4:	f406                	sd	ra,40(sp)
ffffffffc02001f6:	f022                	sd	s0,32(sp)
ffffffffc02001f8:	ec26                	sd	s1,24(sp)
ffffffffc02001fa:	84aa                	mv	s1,a0
ffffffffc02001fc:	2fd0b0ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc0200200:	842a                	mv	s0,a0
ffffffffc0200202:	0505                	addi	a0,a0,1
ffffffffc0200204:	5f9010ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0200208:	87aa                	mv	a5,a0
ffffffffc020020a:	c911                	beqz	a0,ffffffffc020021e <strdup+0x2c>
ffffffffc020020c:	8622                	mv	a2,s0
ffffffffc020020e:	85a6                	mv	a1,s1
ffffffffc0200210:	e42a                	sd	a0,8(sp)
ffffffffc0200212:	3eb0b0ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0200216:	67a2                	ld	a5,8(sp)
ffffffffc0200218:	943e                	add	s0,s0,a5
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	70a2                	ld	ra,40(sp)
ffffffffc0200220:	7402                	ld	s0,32(sp)
ffffffffc0200222:	64e2                	ld	s1,24(sp)
ffffffffc0200224:	853e                	mv	a0,a5
ffffffffc0200226:	6145                	addi	sp,sp,48
ffffffffc0200228:	8082                	ret

ffffffffc020022a <print_kerninfo>:
ffffffffc020022a:	1141                	addi	sp,sp,-16
ffffffffc020022c:	0000c517          	auipc	a0,0xc
ffffffffc0200230:	c1c50513          	addi	a0,a0,-996 # ffffffffc020be48 <etext+0x34>
ffffffffc0200234:	e406                	sd	ra,8(sp)
ffffffffc0200236:	f71ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000c517          	auipc	a0,0xc
ffffffffc0200246:	c2650513          	addi	a0,a0,-986 # ffffffffc020be68 <etext+0x54>
ffffffffc020024a:	f5dff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020024e:	0000c597          	auipc	a1,0xc
ffffffffc0200252:	bc658593          	addi	a1,a1,-1082 # ffffffffc020be14 <etext>
ffffffffc0200256:	0000c517          	auipc	a0,0xc
ffffffffc020025a:	c3250513          	addi	a0,a0,-974 # ffffffffc020be88 <etext+0x74>
ffffffffc020025e:	f49ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200262:	00091597          	auipc	a1,0x91
ffffffffc0200266:	dfe58593          	addi	a1,a1,-514 # ffffffffc0291060 <buf>
ffffffffc020026a:	0000c517          	auipc	a0,0xc
ffffffffc020026e:	c3e50513          	addi	a0,a0,-962 # ffffffffc020bea8 <etext+0x94>
ffffffffc0200272:	f35ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200276:	00096597          	auipc	a1,0x96
ffffffffc020027a:	69a58593          	addi	a1,a1,1690 # ffffffffc0296910 <end>
ffffffffc020027e:	0000c517          	auipc	a0,0xc
ffffffffc0200282:	c4a50513          	addi	a0,a0,-950 # ffffffffc020bec8 <etext+0xb4>
ffffffffc0200286:	f21ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	00097797          	auipc	a5,0x97
ffffffffc0200296:	a7d78793          	addi	a5,a5,-1411 # ffffffffc0296d0f <end+0x3ff>
ffffffffc020029a:	8f99                	sub	a5,a5,a4
ffffffffc020029c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a6:	95be                	add	a1,a1,a5
ffffffffc02002a8:	85a9                	srai	a1,a1,0xa
ffffffffc02002aa:	0000c517          	auipc	a0,0xc
ffffffffc02002ae:	c3e50513          	addi	a0,a0,-962 # ffffffffc020bee8 <etext+0xd4>
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	bdcd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002b6 <print_stackframe>:
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	0000c617          	auipc	a2,0xc
ffffffffc02002bc:	c6060613          	addi	a2,a2,-928 # ffffffffc020bf18 <etext+0x104>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	0000c517          	auipc	a0,0xc
ffffffffc02002c8:	c6c50513          	addi	a0,a0,-916 # ffffffffc020bf30 <etext+0x11c>
ffffffffc02002cc:	e406                	sd	ra,8(sp)
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	0000f417          	auipc	s0,0xf
ffffffffc02002de:	ffe40413          	addi	s0,s0,-2 # ffffffffc020f2d8 <commands>
ffffffffc02002e2:	0000f497          	auipc	s1,0xf
ffffffffc02002e6:	03e48493          	addi	s1,s1,62 # ffffffffc020f320 <commands+0x48>
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	0000c517          	auipc	a0,0xc
ffffffffc02002f2:	c5a50513          	addi	a0,a0,-934 # ffffffffc020bf48 <etext+0x134>
ffffffffc02002f6:	0461                	addi	s0,s0,24
ffffffffc02002f8:	eafff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02002fc:	fe9417e3          	bne	s0,s1,ffffffffc02002ea <mon_help+0x18>
ffffffffc0200300:	60e2                	ld	ra,24(sp)
ffffffffc0200302:	6442                	ld	s0,16(sp)
ffffffffc0200304:	64a2                	ld	s1,8(sp)
ffffffffc0200306:	4501                	li	a0,0
ffffffffc0200308:	6105                	addi	sp,sp,32
ffffffffc020030a:	8082                	ret

ffffffffc020030c <mon_kerninfo>:
ffffffffc020030c:	1141                	addi	sp,sp,-16
ffffffffc020030e:	e406                	sd	ra,8(sp)
ffffffffc0200310:	f1bff0ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200314:	60a2                	ld	ra,8(sp)
ffffffffc0200316:	4501                	li	a0,0
ffffffffc0200318:	0141                	addi	sp,sp,16
ffffffffc020031a:	8082                	ret

ffffffffc020031c <mon_backtrace>:
ffffffffc020031c:	1141                	addi	sp,sp,-16
ffffffffc020031e:	e406                	sd	ra,8(sp)
ffffffffc0200320:	f97ff0ef          	jal	ffffffffc02002b6 <print_stackframe>
ffffffffc0200324:	60a2                	ld	ra,8(sp)
ffffffffc0200326:	4501                	li	a0,0
ffffffffc0200328:	0141                	addi	sp,sp,16
ffffffffc020032a:	8082                	ret

ffffffffc020032c <kmonitor>:
ffffffffc020032c:	7131                	addi	sp,sp,-192
ffffffffc020032e:	e952                	sd	s4,144(sp)
ffffffffc0200330:	8a2a                	mv	s4,a0
ffffffffc0200332:	0000c517          	auipc	a0,0xc
ffffffffc0200336:	c2650513          	addi	a0,a0,-986 # ffffffffc020bf58 <etext+0x144>
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
ffffffffc0200346:	e61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020034a:	0000c517          	auipc	a0,0xc
ffffffffc020034e:	c3650513          	addi	a0,a0,-970 # ffffffffc020bf80 <etext+0x16c>
ffffffffc0200352:	e55ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	391000ef          	jal	ffffffffc0200eec <print_trapframe>
ffffffffc0200360:	0000fa97          	auipc	s5,0xf
ffffffffc0200364:	f78a8a93          	addi	s5,s5,-136 # ffffffffc020f2d8 <commands>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	0000c517          	auipc	a0,0xc
ffffffffc020036e:	c3e50513          	addi	a0,a0,-962 # ffffffffc020bfa8 <etext+0x194>
ffffffffc0200372:	d41ff0ef          	jal	ffffffffc02000b2 <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
ffffffffc020037e:	4481                	li	s1,0
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc0200382:	8b26                	mv	s6,s1
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	0000f497          	auipc	s1,0xf
ffffffffc020038c:	f5048493          	addi	s1,s1,-176 # ffffffffc020f2d8 <commands>
ffffffffc0200390:	4401                	li	s0,0
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	1a90b0ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc020039a:	478d                	li	a5,3
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	0000c517          	auipc	a0,0xc
ffffffffc02003ac:	c3050513          	addi	a0,a0,-976 # ffffffffc020bfd8 <etext+0x1c4>
ffffffffc02003b0:	df7ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
ffffffffc02003b6:	0000c517          	auipc	a0,0xc
ffffffffc02003ba:	bfa50513          	addi	a0,a0,-1030 # ffffffffc020bfb0 <etext+0x19c>
ffffffffc02003be:	1dd0b0ef          	jal	ffffffffc020bd9a <strchr>
ffffffffc02003c2:	c901                	beqz	a0,ffffffffc02003d2 <kmonitor+0xa6>
ffffffffc02003c4:	00144583          	lbu	a1,1(s0)
ffffffffc02003c8:	00040023          	sb	zero,0(s0)
ffffffffc02003cc:	0405                	addi	s0,s0,1
ffffffffc02003ce:	d9d5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d0:	b7dd                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc02003d2:	00044783          	lbu	a5,0(s0)
ffffffffc02003d6:	d7d5                	beqz	a5,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003d8:	03348b63          	beq	s1,s3,ffffffffc020040e <kmonitor+0xe2>
ffffffffc02003dc:	00349793          	slli	a5,s1,0x3
ffffffffc02003e0:	978a                	add	a5,a5,sp
ffffffffc02003e2:	e380                	sd	s0,0(a5)
ffffffffc02003e4:	00044583          	lbu	a1,0(s0)
ffffffffc02003e8:	2485                	addiw	s1,s1,1
ffffffffc02003ea:	8b26                	mv	s6,s1
ffffffffc02003ec:	e591                	bnez	a1,ffffffffc02003f8 <kmonitor+0xcc>
ffffffffc02003ee:	bf59                	j	ffffffffc0200384 <kmonitor+0x58>
ffffffffc02003f0:	00144583          	lbu	a1,1(s0)
ffffffffc02003f4:	0405                	addi	s0,s0,1
ffffffffc02003f6:	d5d1                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc02003f8:	0000c517          	auipc	a0,0xc
ffffffffc02003fc:	bb850513          	addi	a0,a0,-1096 # ffffffffc020bfb0 <etext+0x19c>
ffffffffc0200400:	19b0b0ef          	jal	ffffffffc020bd9a <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	0000c517          	auipc	a0,0xc
ffffffffc0200414:	ba850513          	addi	a0,a0,-1112 # ffffffffc020bfb8 <etext+0x1a4>
ffffffffc0200418:	d8fff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020041c:	b7c1                	j	ffffffffc02003dc <kmonitor+0xb0>
ffffffffc020041e:	00141793          	slli	a5,s0,0x1
ffffffffc0200422:	97a2                	add	a5,a5,s0
ffffffffc0200424:	078e                	slli	a5,a5,0x3
ffffffffc0200426:	97d6                	add	a5,a5,s5
ffffffffc0200428:	6b9c                	ld	a5,16(a5)
ffffffffc020042a:	fffb051b          	addiw	a0,s6,-1
ffffffffc020042e:	8652                	mv	a2,s4
ffffffffc0200430:	002c                	addi	a1,sp,8
ffffffffc0200432:	9782                	jalr	a5
ffffffffc0200434:	f2055be3          	bgez	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200438:	70ea                	ld	ra,184(sp)
ffffffffc020043a:	744a                	ld	s0,176(sp)
ffffffffc020043c:	74aa                	ld	s1,168(sp)
ffffffffc020043e:	69ea                	ld	s3,152(sp)
ffffffffc0200440:	6a4a                	ld	s4,144(sp)
ffffffffc0200442:	6aaa                	ld	s5,136(sp)
ffffffffc0200444:	6b0a                	ld	s6,128(sp)
ffffffffc0200446:	6129                	addi	sp,sp,192
ffffffffc0200448:	8082                	ret

ffffffffc020044a <__panic>:
ffffffffc020044a:	00096317          	auipc	t1,0x96
ffffffffc020044e:	41e33303          	ld	t1,1054(t1) # ffffffffc0296868 <is_panic>
ffffffffc0200452:	715d                	addi	sp,sp,-80
ffffffffc0200454:	ec06                	sd	ra,24(sp)
ffffffffc0200456:	f436                	sd	a3,40(sp)
ffffffffc0200458:	f83a                	sd	a4,48(sp)
ffffffffc020045a:	fc3e                	sd	a5,56(sp)
ffffffffc020045c:	e0c2                	sd	a6,64(sp)
ffffffffc020045e:	e4c6                	sd	a7,72(sp)
ffffffffc0200460:	02031e63          	bnez	t1,ffffffffc020049c <__panic+0x52>
ffffffffc0200464:	4705                	li	a4,1
ffffffffc0200466:	103c                	addi	a5,sp,40
ffffffffc0200468:	e822                	sd	s0,16(sp)
ffffffffc020046a:	8432                	mv	s0,a2
ffffffffc020046c:	862e                	mv	a2,a1
ffffffffc020046e:	85aa                	mv	a1,a0
ffffffffc0200470:	0000c517          	auipc	a0,0xc
ffffffffc0200474:	c1050513          	addi	a0,a0,-1008 # ffffffffc020c080 <etext+0x26c>
ffffffffc0200478:	00096697          	auipc	a3,0x96
ffffffffc020047c:	3ee6b823          	sd	a4,1008(a3) # ffffffffc0296868 <is_panic>
ffffffffc0200480:	e43e                	sd	a5,8(sp)
ffffffffc0200482:	d25ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cf7ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc020048e:	0000c517          	auipc	a0,0xc
ffffffffc0200492:	c1250513          	addi	a0,a0,-1006 # ffffffffc020c0a0 <etext+0x28c>
ffffffffc0200496:	d11ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020049a:	6442                	ld	s0,16(sp)
ffffffffc020049c:	4501                	li	a0,0
ffffffffc020049e:	4581                	li	a1,0
ffffffffc02004a0:	4601                	li	a2,0
ffffffffc02004a2:	48a1                	li	a7,8
ffffffffc02004a4:	00000073          	ecall
ffffffffc02004a8:	730000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02004ac:	4501                	li	a0,0
ffffffffc02004ae:	e7fff0ef          	jal	ffffffffc020032c <kmonitor>
ffffffffc02004b2:	bfed                	j	ffffffffc02004ac <__panic+0x62>

ffffffffc02004b4 <__warn>:
ffffffffc02004b4:	715d                	addi	sp,sp,-80
ffffffffc02004b6:	e822                	sd	s0,16(sp)
ffffffffc02004b8:	02810313          	addi	t1,sp,40
ffffffffc02004bc:	8432                	mv	s0,a2
ffffffffc02004be:	862e                	mv	a2,a1
ffffffffc02004c0:	85aa                	mv	a1,a0
ffffffffc02004c2:	0000c517          	auipc	a0,0xc
ffffffffc02004c6:	be650513          	addi	a0,a0,-1050 # ffffffffc020c0a8 <etext+0x294>
ffffffffc02004ca:	ec06                	sd	ra,24(sp)
ffffffffc02004cc:	f436                	sd	a3,40(sp)
ffffffffc02004ce:	f83a                	sd	a4,48(sp)
ffffffffc02004d0:	fc3e                	sd	a5,56(sp)
ffffffffc02004d2:	e0c2                	sd	a6,64(sp)
ffffffffc02004d4:	e4c6                	sd	a7,72(sp)
ffffffffc02004d6:	e41a                	sd	t1,8(sp)
ffffffffc02004d8:	ccfff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004dc:	65a2                	ld	a1,8(sp)
ffffffffc02004de:	8522                	mv	a0,s0
ffffffffc02004e0:	ca1ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc02004e4:	0000c517          	auipc	a0,0xc
ffffffffc02004e8:	bbc50513          	addi	a0,a0,-1092 # ffffffffc020c0a0 <etext+0x28c>
ffffffffc02004ec:	cbbff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02004f0:	60e2                	ld	ra,24(sp)
ffffffffc02004f2:	6442                	ld	s0,16(sp)
ffffffffc02004f4:	6161                	addi	sp,sp,80
ffffffffc02004f6:	8082                	ret

ffffffffc02004f8 <clock_init>:
ffffffffc02004f8:	02000793          	li	a5,32
ffffffffc02004fc:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200500:	c0102573          	rdtime	a0
ffffffffc0200504:	67e1                	lui	a5,0x18
ffffffffc0200506:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020050a:	953e                	add	a0,a0,a5
ffffffffc020050c:	4581                	li	a1,0
ffffffffc020050e:	4601                	li	a2,0
ffffffffc0200510:	4881                	li	a7,0
ffffffffc0200512:	00000073          	ecall
ffffffffc0200516:	0000c517          	auipc	a0,0xc
ffffffffc020051a:	bb250513          	addi	a0,a0,-1102 # ffffffffc020c0c8 <etext+0x2b4>
ffffffffc020051e:	00096797          	auipc	a5,0x96
ffffffffc0200522:	3407b923          	sd	zero,850(a5) # ffffffffc0296870 <ticks>
ffffffffc0200526:	b141                	j	ffffffffc02001a6 <cprintf>

ffffffffc0200528 <clock_set_next_event>:
ffffffffc0200528:	c0102573          	rdtime	a0
ffffffffc020052c:	67e1                	lui	a5,0x18
ffffffffc020052e:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200532:	953e                	add	a0,a0,a5
ffffffffc0200534:	4581                	li	a1,0
ffffffffc0200536:	4601                	li	a2,0
ffffffffc0200538:	4881                	li	a7,0
ffffffffc020053a:	00000073          	ecall
ffffffffc020053e:	8082                	ret

ffffffffc0200540 <cons_init>:
ffffffffc0200540:	4501                	li	a0,0
ffffffffc0200542:	4581                	li	a1,0
ffffffffc0200544:	4601                	li	a2,0
ffffffffc0200546:	4889                	li	a7,2
ffffffffc0200548:	00000073          	ecall
ffffffffc020054c:	8082                	ret

ffffffffc020054e <cons_putc>:
ffffffffc020054e:	1101                	addi	sp,sp,-32
ffffffffc0200550:	ec06                	sd	ra,24(sp)
ffffffffc0200552:	100027f3          	csrr	a5,sstatus
ffffffffc0200556:	8b89                	andi	a5,a5,2
ffffffffc0200558:	ef95                	bnez	a5,ffffffffc0200594 <cons_putc+0x46>
ffffffffc020055a:	47a1                	li	a5,8
ffffffffc020055c:	00f50a63          	beq	a0,a5,ffffffffc0200570 <cons_putc+0x22>
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4885                	li	a7,1
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	60e2                	ld	ra,24(sp)
ffffffffc020056c:	6105                	addi	sp,sp,32
ffffffffc020056e:	8082                	ret
ffffffffc0200570:	4781                	li	a5,0
ffffffffc0200572:	4521                	li	a0,8
ffffffffc0200574:	4581                	li	a1,0
ffffffffc0200576:	4601                	li	a2,0
ffffffffc0200578:	4885                	li	a7,1
ffffffffc020057a:	00000073          	ecall
ffffffffc020057e:	02000513          	li	a0,32
ffffffffc0200582:	00000073          	ecall
ffffffffc0200586:	4521                	li	a0,8
ffffffffc0200588:	00000073          	ecall
ffffffffc020058c:	dff9                	beqz	a5,ffffffffc020056a <cons_putc+0x1c>
ffffffffc020058e:	60e2                	ld	ra,24(sp)
ffffffffc0200590:	6105                	addi	sp,sp,32
ffffffffc0200592:	a581                	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0200594:	e42a                	sd	a0,8(sp)
ffffffffc0200596:	642000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020059a:	6522                	ld	a0,8(sp)
ffffffffc020059c:	47a1                	li	a5,8
ffffffffc020059e:	00f50a63          	beq	a0,a5,ffffffffc02005b2 <cons_putc+0x64>
ffffffffc02005a2:	4581                	li	a1,0
ffffffffc02005a4:	4601                	li	a2,0
ffffffffc02005a6:	4885                	li	a7,1
ffffffffc02005a8:	00000073          	ecall
ffffffffc02005ac:	60e2                	ld	ra,24(sp)
ffffffffc02005ae:	6105                	addi	sp,sp,32
ffffffffc02005b0:	a50d                	j	ffffffffc0200bd2 <intr_enable>
ffffffffc02005b2:	4785                	li	a5,1
ffffffffc02005b4:	bf7d                	j	ffffffffc0200572 <cons_putc+0x24>

ffffffffc02005b6 <cons_getc>:
ffffffffc02005b6:	1101                	addi	sp,sp,-32
ffffffffc02005b8:	ec06                	sd	ra,24(sp)
ffffffffc02005ba:	100027f3          	csrr	a5,sstatus
ffffffffc02005be:	8b89                	andi	a5,a5,2
ffffffffc02005c0:	4801                	li	a6,0
ffffffffc02005c2:	e7d5                	bnez	a5,ffffffffc020066e <cons_getc+0xb8>
ffffffffc02005c4:	00091697          	auipc	a3,0x91
ffffffffc02005c8:	e9c68693          	addi	a3,a3,-356 # ffffffffc0291460 <cons>
ffffffffc02005cc:	07f00713          	li	a4,127
ffffffffc02005d0:	4501                	li	a0,0
ffffffffc02005d2:	4581                	li	a1,0
ffffffffc02005d4:	4601                	li	a2,0
ffffffffc02005d6:	4889                	li	a7,2
ffffffffc02005d8:	00000073          	ecall
ffffffffc02005dc:	0005079b          	sext.w	a5,a0
ffffffffc02005e0:	0207cd63          	bltz	a5,ffffffffc020061a <cons_getc+0x64>
ffffffffc02005e4:	02e78963          	beq	a5,a4,ffffffffc0200616 <cons_getc+0x60>
ffffffffc02005e8:	d7e5                	beqz	a5,ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc02005ea:	00091797          	auipc	a5,0x91
ffffffffc02005ee:	07a7a783          	lw	a5,122(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc02005f2:	20000593          	li	a1,512
ffffffffc02005f6:	02079613          	slli	a2,a5,0x20
ffffffffc02005fa:	9201                	srli	a2,a2,0x20
ffffffffc02005fc:	2785                	addiw	a5,a5,1
ffffffffc02005fe:	9636                	add	a2,a2,a3
ffffffffc0200600:	20f6a223          	sw	a5,516(a3)
ffffffffc0200604:	00a60023          	sb	a0,0(a2)
ffffffffc0200608:	fcb794e3          	bne	a5,a1,ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc020060c:	00091797          	auipc	a5,0x91
ffffffffc0200610:	0407ac23          	sw	zero,88(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200614:	bf75                	j	ffffffffc02005d0 <cons_getc+0x1a>
ffffffffc0200616:	4521                	li	a0,8
ffffffffc0200618:	bfc9                	j	ffffffffc02005ea <cons_getc+0x34>
ffffffffc020061a:	00091797          	auipc	a5,0x91
ffffffffc020061e:	0467a783          	lw	a5,70(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200622:	00091717          	auipc	a4,0x91
ffffffffc0200626:	04272703          	lw	a4,66(a4) # ffffffffc0291664 <cons+0x204>
ffffffffc020062a:	4501                	li	a0,0
ffffffffc020062c:	00f70f63          	beq	a4,a5,ffffffffc020064a <cons_getc+0x94>
ffffffffc0200630:	02079713          	slli	a4,a5,0x20
ffffffffc0200634:	9301                	srli	a4,a4,0x20
ffffffffc0200636:	2785                	addiw	a5,a5,1
ffffffffc0200638:	20f6a023          	sw	a5,512(a3)
ffffffffc020063c:	96ba                	add	a3,a3,a4
ffffffffc020063e:	20000713          	li	a4,512
ffffffffc0200642:	0006c503          	lbu	a0,0(a3)
ffffffffc0200646:	00e78763          	beq	a5,a4,ffffffffc0200654 <cons_getc+0x9e>
ffffffffc020064a:	00081b63          	bnez	a6,ffffffffc0200660 <cons_getc+0xaa>
ffffffffc020064e:	60e2                	ld	ra,24(sp)
ffffffffc0200650:	6105                	addi	sp,sp,32
ffffffffc0200652:	8082                	ret
ffffffffc0200654:	00091797          	auipc	a5,0x91
ffffffffc0200658:	0007a623          	sw	zero,12(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc020065c:	fe0809e3          	beqz	a6,ffffffffc020064e <cons_getc+0x98>
ffffffffc0200660:	e42a                	sd	a0,8(sp)
ffffffffc0200662:	570000ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0200666:	60e2                	ld	ra,24(sp)
ffffffffc0200668:	6522                	ld	a0,8(sp)
ffffffffc020066a:	6105                	addi	sp,sp,32
ffffffffc020066c:	8082                	ret
ffffffffc020066e:	56a000ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0200672:	4805                	li	a6,1
ffffffffc0200674:	bf81                	j	ffffffffc02005c4 <cons_getc+0xe>

ffffffffc0200676 <dtb_init>:
ffffffffc0200676:	7179                	addi	sp,sp,-48
ffffffffc0200678:	0000c517          	auipc	a0,0xc
ffffffffc020067c:	a7050513          	addi	a0,a0,-1424 # ffffffffc020c0e8 <etext+0x2d4>
ffffffffc0200680:	f406                	sd	ra,40(sp)
ffffffffc0200682:	f022                	sd	s0,32(sp)
ffffffffc0200684:	b23ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200688:	00014597          	auipc	a1,0x14
ffffffffc020068c:	9785b583          	ld	a1,-1672(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc0200690:	0000c517          	auipc	a0,0xc
ffffffffc0200694:	a6850513          	addi	a0,a0,-1432 # ffffffffc020c0f8 <etext+0x2e4>
ffffffffc0200698:	00014417          	auipc	s0,0x14
ffffffffc020069c:	97040413          	addi	s0,s0,-1680 # ffffffffc0214008 <boot_dtb>
ffffffffc02006a0:	b07ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006a4:	600c                	ld	a1,0(s0)
ffffffffc02006a6:	0000c517          	auipc	a0,0xc
ffffffffc02006aa:	a6250513          	addi	a0,a0,-1438 # ffffffffc020c108 <etext+0x2f4>
ffffffffc02006ae:	af9ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02006b2:	6018                	ld	a4,0(s0)
ffffffffc02006b4:	0000c517          	auipc	a0,0xc
ffffffffc02006b8:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020c120 <etext+0x30c>
ffffffffc02006bc:	10070163          	beqz	a4,ffffffffc02007be <dtb_init+0x148>
ffffffffc02006c0:	57f5                	li	a5,-3
ffffffffc02006c2:	07fa                	slli	a5,a5,0x1e
ffffffffc02006c4:	973e                	add	a4,a4,a5
ffffffffc02006c6:	431c                	lw	a5,0(a4)
ffffffffc02006c8:	d00e06b7          	lui	a3,0xd00e0
ffffffffc02006cc:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc02006d0:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006d4:	0187961b          	slliw	a2,a5,0x18
ffffffffc02006d8:	0187d51b          	srliw	a0,a5,0x18
ffffffffc02006dc:	0ff5f593          	zext.b	a1,a1
ffffffffc02006e0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006e4:	05c2                	slli	a1,a1,0x10
ffffffffc02006e6:	8e49                	or	a2,a2,a0
ffffffffc02006e8:	0ff7f793          	zext.b	a5,a5
ffffffffc02006ec:	8dd1                	or	a1,a1,a2
ffffffffc02006ee:	07a2                	slli	a5,a5,0x8
ffffffffc02006f0:	8ddd                	or	a1,a1,a5
ffffffffc02006f2:	00ff0837          	lui	a6,0xff0
ffffffffc02006f6:	0cd59863          	bne	a1,a3,ffffffffc02007c6 <dtb_init+0x150>
ffffffffc02006fa:	4710                	lw	a2,8(a4)
ffffffffc02006fc:	4754                	lw	a3,12(a4)
ffffffffc02006fe:	e84a                	sd	s2,16(sp)
ffffffffc0200700:	0086541b          	srliw	s0,a2,0x8
ffffffffc0200704:	0086d79b          	srliw	a5,a3,0x8
ffffffffc0200708:	01865e1b          	srliw	t3,a2,0x18
ffffffffc020070c:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200710:	0186151b          	slliw	a0,a2,0x18
ffffffffc0200714:	0186959b          	slliw	a1,a3,0x18
ffffffffc0200718:	0104141b          	slliw	s0,s0,0x10
ffffffffc020071c:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200720:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200724:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200728:	01c56533          	or	a0,a0,t3
ffffffffc020072c:	0115e5b3          	or	a1,a1,a7
ffffffffc0200730:	01047433          	and	s0,s0,a6
ffffffffc0200734:	0ff67613          	zext.b	a2,a2
ffffffffc0200738:	0107f7b3          	and	a5,a5,a6
ffffffffc020073c:	0ff6f693          	zext.b	a3,a3
ffffffffc0200740:	8c49                	or	s0,s0,a0
ffffffffc0200742:	0622                	slli	a2,a2,0x8
ffffffffc0200744:	8fcd                	or	a5,a5,a1
ffffffffc0200746:	06a2                	slli	a3,a3,0x8
ffffffffc0200748:	8c51                	or	s0,s0,a2
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	1402                	slli	s0,s0,0x20
ffffffffc020074e:	1782                	slli	a5,a5,0x20
ffffffffc0200750:	9001                	srli	s0,s0,0x20
ffffffffc0200752:	9381                	srli	a5,a5,0x20
ffffffffc0200754:	ec26                	sd	s1,24(sp)
ffffffffc0200756:	4301                	li	t1,0
ffffffffc0200758:	488d                	li	a7,3
ffffffffc020075a:	943a                	add	s0,s0,a4
ffffffffc020075c:	00e78933          	add	s2,a5,a4
ffffffffc0200760:	4e05                	li	t3,1
ffffffffc0200762:	4018                	lw	a4,0(s0)
ffffffffc0200764:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200768:	0187169b          	slliw	a3,a4,0x18
ffffffffc020076c:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200770:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200774:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200778:	0107f7b3          	and	a5,a5,a6
ffffffffc020077c:	8ed1                	or	a3,a3,a2
ffffffffc020077e:	0ff77713          	zext.b	a4,a4
ffffffffc0200782:	8fd5                	or	a5,a5,a3
ffffffffc0200784:	0722                	slli	a4,a4,0x8
ffffffffc0200786:	8fd9                	or	a5,a5,a4
ffffffffc0200788:	05178763          	beq	a5,a7,ffffffffc02007d6 <dtb_init+0x160>
ffffffffc020078c:	0411                	addi	s0,s0,4
ffffffffc020078e:	00f8e963          	bltu	a7,a5,ffffffffc02007a0 <dtb_init+0x12a>
ffffffffc0200792:	07c78d63          	beq	a5,t3,ffffffffc020080c <dtb_init+0x196>
ffffffffc0200796:	4709                	li	a4,2
ffffffffc0200798:	00e79763          	bne	a5,a4,ffffffffc02007a6 <dtb_init+0x130>
ffffffffc020079c:	4301                	li	t1,0
ffffffffc020079e:	b7d1                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc02007a0:	4711                	li	a4,4
ffffffffc02007a2:	fce780e3          	beq	a5,a4,ffffffffc0200762 <dtb_init+0xec>
ffffffffc02007a6:	0000c517          	auipc	a0,0xc
ffffffffc02007aa:	a4250513          	addi	a0,a0,-1470 # ffffffffc020c1e8 <etext+0x3d4>
ffffffffc02007ae:	9f9ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02007b2:	64e2                	ld	s1,24(sp)
ffffffffc02007b4:	6942                	ld	s2,16(sp)
ffffffffc02007b6:	0000c517          	auipc	a0,0xc
ffffffffc02007ba:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020c220 <etext+0x40c>
ffffffffc02007be:	7402                	ld	s0,32(sp)
ffffffffc02007c0:	70a2                	ld	ra,40(sp)
ffffffffc02007c2:	6145                	addi	sp,sp,48
ffffffffc02007c4:	b2cd                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007c6:	7402                	ld	s0,32(sp)
ffffffffc02007c8:	70a2                	ld	ra,40(sp)
ffffffffc02007ca:	0000c517          	auipc	a0,0xc
ffffffffc02007ce:	97650513          	addi	a0,a0,-1674 # ffffffffc020c140 <etext+0x32c>
ffffffffc02007d2:	6145                	addi	sp,sp,48
ffffffffc02007d4:	bac9                	j	ffffffffc02001a6 <cprintf>
ffffffffc02007d6:	4058                	lw	a4,4(s0)
ffffffffc02007d8:	0087579b          	srliw	a5,a4,0x8
ffffffffc02007dc:	0187169b          	slliw	a3,a4,0x18
ffffffffc02007e0:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e4:	0107979b          	slliw	a5,a5,0x10
ffffffffc02007e8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ec:	0107f7b3          	and	a5,a5,a6
ffffffffc02007f0:	8ed1                	or	a3,a3,a2
ffffffffc02007f2:	0ff77713          	zext.b	a4,a4
ffffffffc02007f6:	8fd5                	or	a5,a5,a3
ffffffffc02007f8:	0722                	slli	a4,a4,0x8
ffffffffc02007fa:	8fd9                	or	a5,a5,a4
ffffffffc02007fc:	04031463          	bnez	t1,ffffffffc0200844 <dtb_init+0x1ce>
ffffffffc0200800:	1782                	slli	a5,a5,0x20
ffffffffc0200802:	9381                	srli	a5,a5,0x20
ffffffffc0200804:	043d                	addi	s0,s0,15
ffffffffc0200806:	943e                	add	s0,s0,a5
ffffffffc0200808:	9871                	andi	s0,s0,-4
ffffffffc020080a:	bfa1                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc020080c:	8522                	mv	a0,s0
ffffffffc020080e:	e01a                	sd	t1,0(sp)
ffffffffc0200810:	4e80b0ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc0200814:	84aa                	mv	s1,a0
ffffffffc0200816:	4619                	li	a2,6
ffffffffc0200818:	8522                	mv	a0,s0
ffffffffc020081a:	0000c597          	auipc	a1,0xc
ffffffffc020081e:	94e58593          	addi	a1,a1,-1714 # ffffffffc020c168 <etext+0x354>
ffffffffc0200822:	5500b0ef          	jal	ffffffffc020bd72 <strncmp>
ffffffffc0200826:	6302                	ld	t1,0(sp)
ffffffffc0200828:	0411                	addi	s0,s0,4
ffffffffc020082a:	0004879b          	sext.w	a5,s1
ffffffffc020082e:	943e                	add	s0,s0,a5
ffffffffc0200830:	00153513          	seqz	a0,a0
ffffffffc0200834:	9871                	andi	s0,s0,-4
ffffffffc0200836:	00a36333          	or	t1,t1,a0
ffffffffc020083a:	00ff0837          	lui	a6,0xff0
ffffffffc020083e:	488d                	li	a7,3
ffffffffc0200840:	4e05                	li	t3,1
ffffffffc0200842:	b705                	j	ffffffffc0200762 <dtb_init+0xec>
ffffffffc0200844:	4418                	lw	a4,8(s0)
ffffffffc0200846:	0000c597          	auipc	a1,0xc
ffffffffc020084a:	92a58593          	addi	a1,a1,-1750 # ffffffffc020c170 <etext+0x35c>
ffffffffc020084e:	e43e                	sd	a5,8(sp)
ffffffffc0200850:	0087551b          	srliw	a0,a4,0x8
ffffffffc0200854:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200858:	0187169b          	slliw	a3,a4,0x18
ffffffffc020085c:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200860:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200864:	01057533          	and	a0,a0,a6
ffffffffc0200868:	8ed1                	or	a3,a3,a2
ffffffffc020086a:	0ff77713          	zext.b	a4,a4
ffffffffc020086e:	0722                	slli	a4,a4,0x8
ffffffffc0200870:	8d55                	or	a0,a0,a3
ffffffffc0200872:	8d59                	or	a0,a0,a4
ffffffffc0200874:	1502                	slli	a0,a0,0x20
ffffffffc0200876:	9101                	srli	a0,a0,0x20
ffffffffc0200878:	954a                	add	a0,a0,s2
ffffffffc020087a:	e01a                	sd	t1,0(sp)
ffffffffc020087c:	4c20b0ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc0200880:	67a2                	ld	a5,8(sp)
ffffffffc0200882:	473d                	li	a4,15
ffffffffc0200884:	6302                	ld	t1,0(sp)
ffffffffc0200886:	00ff0837          	lui	a6,0xff0
ffffffffc020088a:	488d                	li	a7,3
ffffffffc020088c:	4e05                	li	t3,1
ffffffffc020088e:	f6f779e3          	bgeu	a4,a5,ffffffffc0200800 <dtb_init+0x18a>
ffffffffc0200892:	f53d                	bnez	a0,ffffffffc0200800 <dtb_init+0x18a>
ffffffffc0200894:	00c43683          	ld	a3,12(s0)
ffffffffc0200898:	01443703          	ld	a4,20(s0)
ffffffffc020089c:	0000c517          	auipc	a0,0xc
ffffffffc02008a0:	8dc50513          	addi	a0,a0,-1828 # ffffffffc020c178 <etext+0x364>
ffffffffc02008a4:	4206d793          	srai	a5,a3,0x20
ffffffffc02008a8:	0087d31b          	srliw	t1,a5,0x8
ffffffffc02008ac:	00871f93          	slli	t6,a4,0x8
ffffffffc02008b0:	42075893          	srai	a7,a4,0x20
ffffffffc02008b4:	0187df1b          	srliw	t5,a5,0x18
ffffffffc02008b8:	0187959b          	slliw	a1,a5,0x18
ffffffffc02008bc:	0103131b          	slliw	t1,t1,0x10
ffffffffc02008c0:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008c4:	420fd613          	srai	a2,t6,0x20
ffffffffc02008c8:	0188de9b          	srliw	t4,a7,0x18
ffffffffc02008cc:	01037333          	and	t1,t1,a6
ffffffffc02008d0:	01889e1b          	slliw	t3,a7,0x18
ffffffffc02008d4:	01e5e5b3          	or	a1,a1,t5
ffffffffc02008d8:	0ff7f793          	zext.b	a5,a5
ffffffffc02008dc:	01de6e33          	or	t3,t3,t4
ffffffffc02008e0:	0065e5b3          	or	a1,a1,t1
ffffffffc02008e4:	01067633          	and	a2,a2,a6
ffffffffc02008e8:	0086d31b          	srliw	t1,a3,0x8
ffffffffc02008ec:	0087541b          	srliw	s0,a4,0x8
ffffffffc02008f0:	07a2                	slli	a5,a5,0x8
ffffffffc02008f2:	0108d89b          	srliw	a7,a7,0x10
ffffffffc02008f6:	0186df1b          	srliw	t5,a3,0x18
ffffffffc02008fa:	01875e9b          	srliw	t4,a4,0x18
ffffffffc02008fe:	8ddd                	or	a1,a1,a5
ffffffffc0200900:	01c66633          	or	a2,a2,t3
ffffffffc0200904:	0186979b          	slliw	a5,a3,0x18
ffffffffc0200908:	01871e1b          	slliw	t3,a4,0x18
ffffffffc020090c:	0ff8f893          	zext.b	a7,a7
ffffffffc0200910:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200914:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200918:	0104141b          	slliw	s0,s0,0x10
ffffffffc020091c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200920:	01037333          	and	t1,t1,a6
ffffffffc0200924:	08a2                	slli	a7,a7,0x8
ffffffffc0200926:	01e7e7b3          	or	a5,a5,t5
ffffffffc020092a:	01047433          	and	s0,s0,a6
ffffffffc020092e:	0ff6f693          	zext.b	a3,a3
ffffffffc0200932:	01de6833          	or	a6,t3,t4
ffffffffc0200936:	0ff77713          	zext.b	a4,a4
ffffffffc020093a:	01166633          	or	a2,a2,a7
ffffffffc020093e:	0067e7b3          	or	a5,a5,t1
ffffffffc0200942:	06a2                	slli	a3,a3,0x8
ffffffffc0200944:	01046433          	or	s0,s0,a6
ffffffffc0200948:	0722                	slli	a4,a4,0x8
ffffffffc020094a:	8fd5                	or	a5,a5,a3
ffffffffc020094c:	8c59                	or	s0,s0,a4
ffffffffc020094e:	1582                	slli	a1,a1,0x20
ffffffffc0200950:	1602                	slli	a2,a2,0x20
ffffffffc0200952:	1782                	slli	a5,a5,0x20
ffffffffc0200954:	9201                	srli	a2,a2,0x20
ffffffffc0200956:	9181                	srli	a1,a1,0x20
ffffffffc0200958:	1402                	slli	s0,s0,0x20
ffffffffc020095a:	00b7e4b3          	or	s1,a5,a1
ffffffffc020095e:	8c51                	or	s0,s0,a2
ffffffffc0200960:	847ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200964:	85a6                	mv	a1,s1
ffffffffc0200966:	0000c517          	auipc	a0,0xc
ffffffffc020096a:	83250513          	addi	a0,a0,-1998 # ffffffffc020c198 <etext+0x384>
ffffffffc020096e:	839ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200972:	01445613          	srli	a2,s0,0x14
ffffffffc0200976:	85a2                	mv	a1,s0
ffffffffc0200978:	0000c517          	auipc	a0,0xc
ffffffffc020097c:	83850513          	addi	a0,a0,-1992 # ffffffffc020c1b0 <etext+0x39c>
ffffffffc0200980:	827ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200984:	009405b3          	add	a1,s0,s1
ffffffffc0200988:	15fd                	addi	a1,a1,-1
ffffffffc020098a:	0000c517          	auipc	a0,0xc
ffffffffc020098e:	84650513          	addi	a0,a0,-1978 # ffffffffc020c1d0 <etext+0x3bc>
ffffffffc0200992:	815ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200996:	00096797          	auipc	a5,0x96
ffffffffc020099a:	ee97b523          	sd	s1,-278(a5) # ffffffffc0296880 <memory_base>
ffffffffc020099e:	00096797          	auipc	a5,0x96
ffffffffc02009a2:	ec87bd23          	sd	s0,-294(a5) # ffffffffc0296878 <memory_size>
ffffffffc02009a6:	b531                	j	ffffffffc02007b2 <dtb_init+0x13c>

ffffffffc02009a8 <get_memory_base>:
ffffffffc02009a8:	00096517          	auipc	a0,0x96
ffffffffc02009ac:	ed853503          	ld	a0,-296(a0) # ffffffffc0296880 <memory_base>
ffffffffc02009b0:	8082                	ret

ffffffffc02009b2 <get_memory_size>:
ffffffffc02009b2:	00096517          	auipc	a0,0x96
ffffffffc02009b6:	ec653503          	ld	a0,-314(a0) # ffffffffc0296878 <memory_size>
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <ide_init>:
ffffffffc02009bc:	1141                	addi	sp,sp,-16
ffffffffc02009be:	00091597          	auipc	a1,0x91
ffffffffc02009c2:	cfa58593          	addi	a1,a1,-774 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009c6:	4505                	li	a0,1
ffffffffc02009c8:	00091797          	auipc	a5,0x91
ffffffffc02009cc:	ca07a023          	sw	zero,-864(a5) # ffffffffc0291668 <ide_devices>
ffffffffc02009d0:	00091797          	auipc	a5,0x91
ffffffffc02009d4:	ce07a423          	sw	zero,-792(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009d8:	00091797          	auipc	a5,0x91
ffffffffc02009dc:	d207a823          	sw	zero,-720(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc02009e0:	00091797          	auipc	a5,0x91
ffffffffc02009e4:	d607ac23          	sw	zero,-648(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc02009e8:	e406                	sd	ra,8(sp)
ffffffffc02009ea:	24c000ef          	jal	ffffffffc0200c36 <ramdisk_init>
ffffffffc02009ee:	00091797          	auipc	a5,0x91
ffffffffc02009f2:	cca7a783          	lw	a5,-822(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc02009f6:	c385                	beqz	a5,ffffffffc0200a16 <ide_init+0x5a>
ffffffffc02009f8:	00091597          	auipc	a1,0x91
ffffffffc02009fc:	d1058593          	addi	a1,a1,-752 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a00:	4509                	li	a0,2
ffffffffc0200a02:	234000ef          	jal	ffffffffc0200c36 <ramdisk_init>
ffffffffc0200a06:	00091797          	auipc	a5,0x91
ffffffffc0200a0a:	d027a783          	lw	a5,-766(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a0e:	c39d                	beqz	a5,ffffffffc0200a34 <ide_init+0x78>
ffffffffc0200a10:	60a2                	ld	ra,8(sp)
ffffffffc0200a12:	0141                	addi	sp,sp,16
ffffffffc0200a14:	8082                	ret
ffffffffc0200a16:	0000c697          	auipc	a3,0xc
ffffffffc0200a1a:	82268693          	addi	a3,a3,-2014 # ffffffffc020c238 <etext+0x424>
ffffffffc0200a1e:	0000c617          	auipc	a2,0xc
ffffffffc0200a22:	83260613          	addi	a2,a2,-1998 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200a26:	45c5                	li	a1,17
ffffffffc0200a28:	0000c517          	auipc	a0,0xc
ffffffffc0200a2c:	84050513          	addi	a0,a0,-1984 # ffffffffc020c268 <etext+0x454>
ffffffffc0200a30:	a1bff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200a34:	0000c697          	auipc	a3,0xc
ffffffffc0200a38:	84c68693          	addi	a3,a3,-1972 # ffffffffc020c280 <etext+0x46c>
ffffffffc0200a3c:	0000c617          	auipc	a2,0xc
ffffffffc0200a40:	81460613          	addi	a2,a2,-2028 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200a44:	45d1                	li	a1,20
ffffffffc0200a46:	0000c517          	auipc	a0,0xc
ffffffffc0200a4a:	82250513          	addi	a0,a0,-2014 # ffffffffc020c268 <etext+0x454>
ffffffffc0200a4e:	9fdff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200a52 <ide_device_valid>:
ffffffffc0200a52:	478d                	li	a5,3
ffffffffc0200a54:	00a7ef63          	bltu	a5,a0,ffffffffc0200a72 <ide_device_valid+0x20>
ffffffffc0200a58:	00251793          	slli	a5,a0,0x2
ffffffffc0200a5c:	97aa                	add	a5,a5,a0
ffffffffc0200a5e:	00091717          	auipc	a4,0x91
ffffffffc0200a62:	c0a70713          	addi	a4,a4,-1014 # ffffffffc0291668 <ide_devices>
ffffffffc0200a66:	0792                	slli	a5,a5,0x4
ffffffffc0200a68:	97ba                	add	a5,a5,a4
ffffffffc0200a6a:	4388                	lw	a0,0(a5)
ffffffffc0200a6c:	00a03533          	snez	a0,a0
ffffffffc0200a70:	8082                	ret
ffffffffc0200a72:	4501                	li	a0,0
ffffffffc0200a74:	8082                	ret

ffffffffc0200a76 <ide_device_size>:
ffffffffc0200a76:	478d                	li	a5,3
ffffffffc0200a78:	02a7e163          	bltu	a5,a0,ffffffffc0200a9a <ide_device_size+0x24>
ffffffffc0200a7c:	00251793          	slli	a5,a0,0x2
ffffffffc0200a80:	97aa                	add	a5,a5,a0
ffffffffc0200a82:	00091717          	auipc	a4,0x91
ffffffffc0200a86:	be670713          	addi	a4,a4,-1050 # ffffffffc0291668 <ide_devices>
ffffffffc0200a8a:	0792                	slli	a5,a5,0x4
ffffffffc0200a8c:	97ba                	add	a5,a5,a4
ffffffffc0200a8e:	4398                	lw	a4,0(a5)
ffffffffc0200a90:	4501                	li	a0,0
ffffffffc0200a92:	c709                	beqz	a4,ffffffffc0200a9c <ide_device_size+0x26>
ffffffffc0200a94:	0087e503          	lwu	a0,8(a5)
ffffffffc0200a98:	8082                	ret
ffffffffc0200a9a:	4501                	li	a0,0
ffffffffc0200a9c:	8082                	ret

ffffffffc0200a9e <ide_read_secs>:
ffffffffc0200a9e:	1141                	addi	sp,sp,-16
ffffffffc0200aa0:	e406                	sd	ra,8(sp)
ffffffffc0200aa2:	0816b793          	sltiu	a5,a3,129
ffffffffc0200aa6:	cba9                	beqz	a5,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200aa8:	478d                	li	a5,3
ffffffffc0200aaa:	0005081b          	sext.w	a6,a0
ffffffffc0200aae:	04a7e563          	bltu	a5,a0,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200ab2:	00281793          	slli	a5,a6,0x2
ffffffffc0200ab6:	97c2                	add	a5,a5,a6
ffffffffc0200ab8:	0792                	slli	a5,a5,0x4
ffffffffc0200aba:	00091817          	auipc	a6,0x91
ffffffffc0200abe:	bae80813          	addi	a6,a6,-1106 # ffffffffc0291668 <ide_devices>
ffffffffc0200ac2:	97c2                	add	a5,a5,a6
ffffffffc0200ac4:	0007a883          	lw	a7,0(a5)
ffffffffc0200ac8:	02088863          	beqz	a7,ffffffffc0200af8 <ide_read_secs+0x5a>
ffffffffc0200acc:	100008b7          	lui	a7,0x10000
ffffffffc0200ad0:	0515f463          	bgeu	a1,a7,ffffffffc0200b18 <ide_read_secs+0x7a>
ffffffffc0200ad4:	1582                	slli	a1,a1,0x20
ffffffffc0200ad6:	9181                	srli	a1,a1,0x20
ffffffffc0200ad8:	00d58733          	add	a4,a1,a3
ffffffffc0200adc:	02e8ee63          	bltu	a7,a4,ffffffffc0200b18 <ide_read_secs+0x7a>
ffffffffc0200ae0:	00251713          	slli	a4,a0,0x2
ffffffffc0200ae4:	0407b883          	ld	a7,64(a5)
ffffffffc0200ae8:	60a2                	ld	ra,8(sp)
ffffffffc0200aea:	00a707b3          	add	a5,a4,a0
ffffffffc0200aee:	0792                	slli	a5,a5,0x4
ffffffffc0200af0:	00f80533          	add	a0,a6,a5
ffffffffc0200af4:	0141                	addi	sp,sp,16
ffffffffc0200af6:	8882                	jr	a7
ffffffffc0200af8:	0000b697          	auipc	a3,0xb
ffffffffc0200afc:	7a068693          	addi	a3,a3,1952 # ffffffffc020c298 <etext+0x484>
ffffffffc0200b00:	0000b617          	auipc	a2,0xb
ffffffffc0200b04:	75060613          	addi	a2,a2,1872 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200b08:	02200593          	li	a1,34
ffffffffc0200b0c:	0000b517          	auipc	a0,0xb
ffffffffc0200b10:	75c50513          	addi	a0,a0,1884 # ffffffffc020c268 <etext+0x454>
ffffffffc0200b14:	937ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200b18:	0000b697          	auipc	a3,0xb
ffffffffc0200b1c:	7a868693          	addi	a3,a3,1960 # ffffffffc020c2c0 <etext+0x4ac>
ffffffffc0200b20:	0000b617          	auipc	a2,0xb
ffffffffc0200b24:	73060613          	addi	a2,a2,1840 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200b28:	02300593          	li	a1,35
ffffffffc0200b2c:	0000b517          	auipc	a0,0xb
ffffffffc0200b30:	73c50513          	addi	a0,a0,1852 # ffffffffc020c268 <etext+0x454>
ffffffffc0200b34:	917ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200b38 <ide_write_secs>:
ffffffffc0200b38:	1141                	addi	sp,sp,-16
ffffffffc0200b3a:	e406                	sd	ra,8(sp)
ffffffffc0200b3c:	0816b793          	sltiu	a5,a3,129
ffffffffc0200b40:	cba9                	beqz	a5,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b42:	478d                	li	a5,3
ffffffffc0200b44:	0005081b          	sext.w	a6,a0
ffffffffc0200b48:	04a7e563          	bltu	a5,a0,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b4c:	00281793          	slli	a5,a6,0x2
ffffffffc0200b50:	97c2                	add	a5,a5,a6
ffffffffc0200b52:	0792                	slli	a5,a5,0x4
ffffffffc0200b54:	00091817          	auipc	a6,0x91
ffffffffc0200b58:	b1480813          	addi	a6,a6,-1260 # ffffffffc0291668 <ide_devices>
ffffffffc0200b5c:	97c2                	add	a5,a5,a6
ffffffffc0200b5e:	0007a883          	lw	a7,0(a5)
ffffffffc0200b62:	02088863          	beqz	a7,ffffffffc0200b92 <ide_write_secs+0x5a>
ffffffffc0200b66:	100008b7          	lui	a7,0x10000
ffffffffc0200b6a:	0515f463          	bgeu	a1,a7,ffffffffc0200bb2 <ide_write_secs+0x7a>
ffffffffc0200b6e:	1582                	slli	a1,a1,0x20
ffffffffc0200b70:	9181                	srli	a1,a1,0x20
ffffffffc0200b72:	00d58733          	add	a4,a1,a3
ffffffffc0200b76:	02e8ee63          	bltu	a7,a4,ffffffffc0200bb2 <ide_write_secs+0x7a>
ffffffffc0200b7a:	00251713          	slli	a4,a0,0x2
ffffffffc0200b7e:	0487b883          	ld	a7,72(a5)
ffffffffc0200b82:	60a2                	ld	ra,8(sp)
ffffffffc0200b84:	00a707b3          	add	a5,a4,a0
ffffffffc0200b88:	0792                	slli	a5,a5,0x4
ffffffffc0200b8a:	00f80533          	add	a0,a6,a5
ffffffffc0200b8e:	0141                	addi	sp,sp,16
ffffffffc0200b90:	8882                	jr	a7
ffffffffc0200b92:	0000b697          	auipc	a3,0xb
ffffffffc0200b96:	70668693          	addi	a3,a3,1798 # ffffffffc020c298 <etext+0x484>
ffffffffc0200b9a:	0000b617          	auipc	a2,0xb
ffffffffc0200b9e:	6b660613          	addi	a2,a2,1718 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200ba2:	02900593          	li	a1,41
ffffffffc0200ba6:	0000b517          	auipc	a0,0xb
ffffffffc0200baa:	6c250513          	addi	a0,a0,1730 # ffffffffc020c268 <etext+0x454>
ffffffffc0200bae:	89dff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200bb2:	0000b697          	auipc	a3,0xb
ffffffffc0200bb6:	70e68693          	addi	a3,a3,1806 # ffffffffc020c2c0 <etext+0x4ac>
ffffffffc0200bba:	0000b617          	auipc	a2,0xb
ffffffffc0200bbe:	69660613          	addi	a2,a2,1686 # ffffffffc020c250 <etext+0x43c>
ffffffffc0200bc2:	02a00593          	li	a1,42
ffffffffc0200bc6:	0000b517          	auipc	a0,0xb
ffffffffc0200bca:	6a250513          	addi	a0,a0,1698 # ffffffffc020c268 <etext+0x454>
ffffffffc0200bce:	87dff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200bd2 <intr_enable>:
ffffffffc0200bd2:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200bd6:	8082                	ret

ffffffffc0200bd8 <intr_disable>:
ffffffffc0200bd8:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200bdc:	8082                	ret

ffffffffc0200bde <pic_init>:
ffffffffc0200bde:	8082                	ret

ffffffffc0200be0 <ramdisk_write>:
ffffffffc0200be0:	00856783          	lwu	a5,8(a0)
ffffffffc0200be4:	1141                	addi	sp,sp,-16
ffffffffc0200be6:	e406                	sd	ra,8(sp)
ffffffffc0200be8:	8f8d                	sub	a5,a5,a1
ffffffffc0200bea:	8732                	mv	a4,a2
ffffffffc0200bec:	00f6f363          	bgeu	a3,a5,ffffffffc0200bf2 <ramdisk_write+0x12>
ffffffffc0200bf0:	87b6                	mv	a5,a3
ffffffffc0200bf2:	6914                	ld	a3,16(a0)
ffffffffc0200bf4:	00959513          	slli	a0,a1,0x9
ffffffffc0200bf8:	00979613          	slli	a2,a5,0x9
ffffffffc0200bfc:	9536                	add	a0,a0,a3
ffffffffc0200bfe:	85ba                	mv	a1,a4
ffffffffc0200c00:	1fc0b0ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0200c04:	60a2                	ld	ra,8(sp)
ffffffffc0200c06:	4501                	li	a0,0
ffffffffc0200c08:	0141                	addi	sp,sp,16
ffffffffc0200c0a:	8082                	ret

ffffffffc0200c0c <ramdisk_read>:
ffffffffc0200c0c:	00856783          	lwu	a5,8(a0)
ffffffffc0200c10:	1141                	addi	sp,sp,-16
ffffffffc0200c12:	e406                	sd	ra,8(sp)
ffffffffc0200c14:	8f8d                	sub	a5,a5,a1
ffffffffc0200c16:	872a                	mv	a4,a0
ffffffffc0200c18:	8532                	mv	a0,a2
ffffffffc0200c1a:	00f6f363          	bgeu	a3,a5,ffffffffc0200c20 <ramdisk_read+0x14>
ffffffffc0200c1e:	87b6                	mv	a5,a3
ffffffffc0200c20:	6b18                	ld	a4,16(a4)
ffffffffc0200c22:	05a6                	slli	a1,a1,0x9
ffffffffc0200c24:	00979613          	slli	a2,a5,0x9
ffffffffc0200c28:	95ba                	add	a1,a1,a4
ffffffffc0200c2a:	1d20b0ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0200c2e:	60a2                	ld	ra,8(sp)
ffffffffc0200c30:	4501                	li	a0,0
ffffffffc0200c32:	0141                	addi	sp,sp,16
ffffffffc0200c34:	8082                	ret

ffffffffc0200c36 <ramdisk_init>:
ffffffffc0200c36:	7179                	addi	sp,sp,-48
ffffffffc0200c38:	f022                	sd	s0,32(sp)
ffffffffc0200c3a:	ec26                	sd	s1,24(sp)
ffffffffc0200c3c:	842e                	mv	s0,a1
ffffffffc0200c3e:	84aa                	mv	s1,a0
ffffffffc0200c40:	05000613          	li	a2,80
ffffffffc0200c44:	852e                	mv	a0,a1
ffffffffc0200c46:	4581                	li	a1,0
ffffffffc0200c48:	f406                	sd	ra,40(sp)
ffffffffc0200c4a:	1620b0ef          	jal	ffffffffc020bdac <memset>
ffffffffc0200c4e:	4785                	li	a5,1
ffffffffc0200c50:	06f48a63          	beq	s1,a5,ffffffffc0200cc4 <ramdisk_init+0x8e>
ffffffffc0200c54:	4789                	li	a5,2
ffffffffc0200c56:	00090617          	auipc	a2,0x90
ffffffffc0200c5a:	3ba60613          	addi	a2,a2,954 # ffffffffc0291010 <arena>
ffffffffc0200c5e:	0001b597          	auipc	a1,0x1b
ffffffffc0200c62:	0b258593          	addi	a1,a1,178 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200c66:	08f49363          	bne	s1,a5,ffffffffc0200cec <ramdisk_init+0xb6>
ffffffffc0200c6a:	06c58763          	beq	a1,a2,ffffffffc0200cd8 <ramdisk_init+0xa2>
ffffffffc0200c6e:	40b604b3          	sub	s1,a2,a1
ffffffffc0200c72:	86a6                	mv	a3,s1
ffffffffc0200c74:	167d                	addi	a2,a2,-1
ffffffffc0200c76:	0000b517          	auipc	a0,0xb
ffffffffc0200c7a:	6a250513          	addi	a0,a0,1698 # ffffffffc020c318 <etext+0x504>
ffffffffc0200c7e:	e42e                	sd	a1,8(sp)
ffffffffc0200c80:	d26ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200c84:	65a2                	ld	a1,8(sp)
ffffffffc0200c86:	57fd                	li	a5,-1
ffffffffc0200c88:	1782                	slli	a5,a5,0x20
ffffffffc0200c8a:	0094d69b          	srliw	a3,s1,0x9
ffffffffc0200c8e:	0785                	addi	a5,a5,1
ffffffffc0200c90:	e80c                	sd	a1,16(s0)
ffffffffc0200c92:	e01c                	sd	a5,0(s0)
ffffffffc0200c94:	c414                	sw	a3,8(s0)
ffffffffc0200c96:	02040513          	addi	a0,s0,32
ffffffffc0200c9a:	0000b597          	auipc	a1,0xb
ffffffffc0200c9e:	6d658593          	addi	a1,a1,1750 # ffffffffc020c370 <etext+0x55c>
ffffffffc0200ca2:	08a0b0ef          	jal	ffffffffc020bd2c <strcpy>
ffffffffc0200ca6:	00000717          	auipc	a4,0x0
ffffffffc0200caa:	f6670713          	addi	a4,a4,-154 # ffffffffc0200c0c <ramdisk_read>
ffffffffc0200cae:	00000797          	auipc	a5,0x0
ffffffffc0200cb2:	f3278793          	addi	a5,a5,-206 # ffffffffc0200be0 <ramdisk_write>
ffffffffc0200cb6:	70a2                	ld	ra,40(sp)
ffffffffc0200cb8:	e038                	sd	a4,64(s0)
ffffffffc0200cba:	e43c                	sd	a5,72(s0)
ffffffffc0200cbc:	7402                	ld	s0,32(sp)
ffffffffc0200cbe:	64e2                	ld	s1,24(sp)
ffffffffc0200cc0:	6145                	addi	sp,sp,48
ffffffffc0200cc2:	8082                	ret
ffffffffc0200cc4:	0001b617          	auipc	a2,0x1b
ffffffffc0200cc8:	04c60613          	addi	a2,a2,76 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200ccc:	00013597          	auipc	a1,0x13
ffffffffc0200cd0:	34458593          	addi	a1,a1,836 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200cd4:	f8c59de3          	bne	a1,a2,ffffffffc0200c6e <ramdisk_init+0x38>
ffffffffc0200cd8:	7402                	ld	s0,32(sp)
ffffffffc0200cda:	70a2                	ld	ra,40(sp)
ffffffffc0200cdc:	64e2                	ld	s1,24(sp)
ffffffffc0200cde:	0000b517          	auipc	a0,0xb
ffffffffc0200ce2:	62250513          	addi	a0,a0,1570 # ffffffffc020c300 <etext+0x4ec>
ffffffffc0200ce6:	6145                	addi	sp,sp,48
ffffffffc0200ce8:	cbeff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200cec:	0000b617          	auipc	a2,0xb
ffffffffc0200cf0:	65460613          	addi	a2,a2,1620 # ffffffffc020c340 <etext+0x52c>
ffffffffc0200cf4:	03200593          	li	a1,50
ffffffffc0200cf8:	0000b517          	auipc	a0,0xb
ffffffffc0200cfc:	66050513          	addi	a0,a0,1632 # ffffffffc020c358 <etext+0x544>
ffffffffc0200d00:	f4aff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200d04 <idt_init>:
ffffffffc0200d04:	14005073          	csrwi	sscratch,0
ffffffffc0200d08:	00000797          	auipc	a5,0x0
ffffffffc0200d0c:	4b878793          	addi	a5,a5,1208 # ffffffffc02011c0 <__alltraps>
ffffffffc0200d10:	10579073          	csrw	stvec,a5
ffffffffc0200d14:	000407b7          	lui	a5,0x40
ffffffffc0200d18:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200d1c:	8082                	ret

ffffffffc0200d1e <print_regs>:
ffffffffc0200d1e:	610c                	ld	a1,0(a0)
ffffffffc0200d20:	1141                	addi	sp,sp,-16
ffffffffc0200d22:	e022                	sd	s0,0(sp)
ffffffffc0200d24:	842a                	mv	s0,a0
ffffffffc0200d26:	0000b517          	auipc	a0,0xb
ffffffffc0200d2a:	65a50513          	addi	a0,a0,1626 # ffffffffc020c380 <etext+0x56c>
ffffffffc0200d2e:	e406                	sd	ra,8(sp)
ffffffffc0200d30:	c76ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d34:	640c                	ld	a1,8(s0)
ffffffffc0200d36:	0000b517          	auipc	a0,0xb
ffffffffc0200d3a:	66250513          	addi	a0,a0,1634 # ffffffffc020c398 <etext+0x584>
ffffffffc0200d3e:	c68ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d42:	680c                	ld	a1,16(s0)
ffffffffc0200d44:	0000b517          	auipc	a0,0xb
ffffffffc0200d48:	66c50513          	addi	a0,a0,1644 # ffffffffc020c3b0 <etext+0x59c>
ffffffffc0200d4c:	c5aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d50:	6c0c                	ld	a1,24(s0)
ffffffffc0200d52:	0000b517          	auipc	a0,0xb
ffffffffc0200d56:	67650513          	addi	a0,a0,1654 # ffffffffc020c3c8 <etext+0x5b4>
ffffffffc0200d5a:	c4cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d5e:	700c                	ld	a1,32(s0)
ffffffffc0200d60:	0000b517          	auipc	a0,0xb
ffffffffc0200d64:	68050513          	addi	a0,a0,1664 # ffffffffc020c3e0 <etext+0x5cc>
ffffffffc0200d68:	c3eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d6c:	740c                	ld	a1,40(s0)
ffffffffc0200d6e:	0000b517          	auipc	a0,0xb
ffffffffc0200d72:	68a50513          	addi	a0,a0,1674 # ffffffffc020c3f8 <etext+0x5e4>
ffffffffc0200d76:	c30ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d7a:	780c                	ld	a1,48(s0)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	69450513          	addi	a0,a0,1684 # ffffffffc020c410 <etext+0x5fc>
ffffffffc0200d84:	c22ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d88:	7c0c                	ld	a1,56(s0)
ffffffffc0200d8a:	0000b517          	auipc	a0,0xb
ffffffffc0200d8e:	69e50513          	addi	a0,a0,1694 # ffffffffc020c428 <etext+0x614>
ffffffffc0200d92:	c14ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200d96:	602c                	ld	a1,64(s0)
ffffffffc0200d98:	0000b517          	auipc	a0,0xb
ffffffffc0200d9c:	6a850513          	addi	a0,a0,1704 # ffffffffc020c440 <etext+0x62c>
ffffffffc0200da0:	c06ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200da4:	642c                	ld	a1,72(s0)
ffffffffc0200da6:	0000b517          	auipc	a0,0xb
ffffffffc0200daa:	6b250513          	addi	a0,a0,1714 # ffffffffc020c458 <etext+0x644>
ffffffffc0200dae:	bf8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200db2:	682c                	ld	a1,80(s0)
ffffffffc0200db4:	0000b517          	auipc	a0,0xb
ffffffffc0200db8:	6bc50513          	addi	a0,a0,1724 # ffffffffc020c470 <etext+0x65c>
ffffffffc0200dbc:	beaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dc0:	6c2c                	ld	a1,88(s0)
ffffffffc0200dc2:	0000b517          	auipc	a0,0xb
ffffffffc0200dc6:	6c650513          	addi	a0,a0,1734 # ffffffffc020c488 <etext+0x674>
ffffffffc0200dca:	bdcff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dce:	702c                	ld	a1,96(s0)
ffffffffc0200dd0:	0000b517          	auipc	a0,0xb
ffffffffc0200dd4:	6d050513          	addi	a0,a0,1744 # ffffffffc020c4a0 <etext+0x68c>
ffffffffc0200dd8:	bceff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ddc:	742c                	ld	a1,104(s0)
ffffffffc0200dde:	0000b517          	auipc	a0,0xb
ffffffffc0200de2:	6da50513          	addi	a0,a0,1754 # ffffffffc020c4b8 <etext+0x6a4>
ffffffffc0200de6:	bc0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dea:	782c                	ld	a1,112(s0)
ffffffffc0200dec:	0000b517          	auipc	a0,0xb
ffffffffc0200df0:	6e450513          	addi	a0,a0,1764 # ffffffffc020c4d0 <etext+0x6bc>
ffffffffc0200df4:	bb2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200df8:	7c2c                	ld	a1,120(s0)
ffffffffc0200dfa:	0000b517          	auipc	a0,0xb
ffffffffc0200dfe:	6ee50513          	addi	a0,a0,1774 # ffffffffc020c4e8 <etext+0x6d4>
ffffffffc0200e02:	ba4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e06:	604c                	ld	a1,128(s0)
ffffffffc0200e08:	0000b517          	auipc	a0,0xb
ffffffffc0200e0c:	6f850513          	addi	a0,a0,1784 # ffffffffc020c500 <etext+0x6ec>
ffffffffc0200e10:	b96ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e14:	644c                	ld	a1,136(s0)
ffffffffc0200e16:	0000b517          	auipc	a0,0xb
ffffffffc0200e1a:	70250513          	addi	a0,a0,1794 # ffffffffc020c518 <etext+0x704>
ffffffffc0200e1e:	b88ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e22:	684c                	ld	a1,144(s0)
ffffffffc0200e24:	0000b517          	auipc	a0,0xb
ffffffffc0200e28:	70c50513          	addi	a0,a0,1804 # ffffffffc020c530 <etext+0x71c>
ffffffffc0200e2c:	b7aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e30:	6c4c                	ld	a1,152(s0)
ffffffffc0200e32:	0000b517          	auipc	a0,0xb
ffffffffc0200e36:	71650513          	addi	a0,a0,1814 # ffffffffc020c548 <etext+0x734>
ffffffffc0200e3a:	b6cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e3e:	704c                	ld	a1,160(s0)
ffffffffc0200e40:	0000b517          	auipc	a0,0xb
ffffffffc0200e44:	72050513          	addi	a0,a0,1824 # ffffffffc020c560 <etext+0x74c>
ffffffffc0200e48:	b5eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e4c:	744c                	ld	a1,168(s0)
ffffffffc0200e4e:	0000b517          	auipc	a0,0xb
ffffffffc0200e52:	72a50513          	addi	a0,a0,1834 # ffffffffc020c578 <etext+0x764>
ffffffffc0200e56:	b50ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e5a:	784c                	ld	a1,176(s0)
ffffffffc0200e5c:	0000b517          	auipc	a0,0xb
ffffffffc0200e60:	73450513          	addi	a0,a0,1844 # ffffffffc020c590 <etext+0x77c>
ffffffffc0200e64:	b42ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e68:	7c4c                	ld	a1,184(s0)
ffffffffc0200e6a:	0000b517          	auipc	a0,0xb
ffffffffc0200e6e:	73e50513          	addi	a0,a0,1854 # ffffffffc020c5a8 <etext+0x794>
ffffffffc0200e72:	b34ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e76:	606c                	ld	a1,192(s0)
ffffffffc0200e78:	0000b517          	auipc	a0,0xb
ffffffffc0200e7c:	74850513          	addi	a0,a0,1864 # ffffffffc020c5c0 <etext+0x7ac>
ffffffffc0200e80:	b26ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e84:	646c                	ld	a1,200(s0)
ffffffffc0200e86:	0000b517          	auipc	a0,0xb
ffffffffc0200e8a:	75250513          	addi	a0,a0,1874 # ffffffffc020c5d8 <etext+0x7c4>
ffffffffc0200e8e:	b18ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e92:	686c                	ld	a1,208(s0)
ffffffffc0200e94:	0000b517          	auipc	a0,0xb
ffffffffc0200e98:	75c50513          	addi	a0,a0,1884 # ffffffffc020c5f0 <etext+0x7dc>
ffffffffc0200e9c:	b0aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ea0:	6c6c                	ld	a1,216(s0)
ffffffffc0200ea2:	0000b517          	auipc	a0,0xb
ffffffffc0200ea6:	76650513          	addi	a0,a0,1894 # ffffffffc020c608 <etext+0x7f4>
ffffffffc0200eaa:	afcff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eae:	706c                	ld	a1,224(s0)
ffffffffc0200eb0:	0000b517          	auipc	a0,0xb
ffffffffc0200eb4:	77050513          	addi	a0,a0,1904 # ffffffffc020c620 <etext+0x80c>
ffffffffc0200eb8:	aeeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ebc:	746c                	ld	a1,232(s0)
ffffffffc0200ebe:	0000b517          	auipc	a0,0xb
ffffffffc0200ec2:	77a50513          	addi	a0,a0,1914 # ffffffffc020c638 <etext+0x824>
ffffffffc0200ec6:	ae0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eca:	786c                	ld	a1,240(s0)
ffffffffc0200ecc:	0000b517          	auipc	a0,0xb
ffffffffc0200ed0:	78450513          	addi	a0,a0,1924 # ffffffffc020c650 <etext+0x83c>
ffffffffc0200ed4:	ad2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ed8:	7c6c                	ld	a1,248(s0)
ffffffffc0200eda:	6402                	ld	s0,0(sp)
ffffffffc0200edc:	60a2                	ld	ra,8(sp)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	78a50513          	addi	a0,a0,1930 # ffffffffc020c668 <etext+0x854>
ffffffffc0200ee6:	0141                	addi	sp,sp,16
ffffffffc0200ee8:	abeff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200eec <print_trapframe>:
ffffffffc0200eec:	1141                	addi	sp,sp,-16
ffffffffc0200eee:	e022                	sd	s0,0(sp)
ffffffffc0200ef0:	85aa                	mv	a1,a0
ffffffffc0200ef2:	842a                	mv	s0,a0
ffffffffc0200ef4:	0000b517          	auipc	a0,0xb
ffffffffc0200ef8:	78c50513          	addi	a0,a0,1932 # ffffffffc020c680 <etext+0x86c>
ffffffffc0200efc:	e406                	sd	ra,8(sp)
ffffffffc0200efe:	aa8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f02:	8522                	mv	a0,s0
ffffffffc0200f04:	e1bff0ef          	jal	ffffffffc0200d1e <print_regs>
ffffffffc0200f08:	10043583          	ld	a1,256(s0)
ffffffffc0200f0c:	0000b517          	auipc	a0,0xb
ffffffffc0200f10:	78c50513          	addi	a0,a0,1932 # ffffffffc020c698 <etext+0x884>
ffffffffc0200f14:	a92ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f18:	10843583          	ld	a1,264(s0)
ffffffffc0200f1c:	0000b517          	auipc	a0,0xb
ffffffffc0200f20:	79450513          	addi	a0,a0,1940 # ffffffffc020c6b0 <etext+0x89c>
ffffffffc0200f24:	a82ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f28:	11043583          	ld	a1,272(s0)
ffffffffc0200f2c:	0000b517          	auipc	a0,0xb
ffffffffc0200f30:	79c50513          	addi	a0,a0,1948 # ffffffffc020c6c8 <etext+0x8b4>
ffffffffc0200f34:	a72ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f38:	11843583          	ld	a1,280(s0)
ffffffffc0200f3c:	6402                	ld	s0,0(sp)
ffffffffc0200f3e:	60a2                	ld	ra,8(sp)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	79850513          	addi	a0,a0,1944 # ffffffffc020c6d8 <etext+0x8c4>
ffffffffc0200f48:	0141                	addi	sp,sp,16
ffffffffc0200f4a:	a5cff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f4e <interrupt_handler>:
ffffffffc0200f4e:	11853783          	ld	a5,280(a0)
ffffffffc0200f52:	472d                	li	a4,11
ffffffffc0200f54:	0786                	slli	a5,a5,0x1
ffffffffc0200f56:	8385                	srli	a5,a5,0x1
ffffffffc0200f58:	08f76063          	bltu	a4,a5,ffffffffc0200fd8 <interrupt_handler+0x8a>
ffffffffc0200f5c:	0000e717          	auipc	a4,0xe
ffffffffc0200f60:	3c470713          	addi	a4,a4,964 # ffffffffc020f320 <commands+0x48>
ffffffffc0200f64:	078a                	slli	a5,a5,0x2
ffffffffc0200f66:	97ba                	add	a5,a5,a4
ffffffffc0200f68:	439c                	lw	a5,0(a5)
ffffffffc0200f6a:	97ba                	add	a5,a5,a4
ffffffffc0200f6c:	8782                	jr	a5
ffffffffc0200f6e:	0000b517          	auipc	a0,0xb
ffffffffc0200f72:	7e250513          	addi	a0,a0,2018 # ffffffffc020c750 <etext+0x93c>
ffffffffc0200f76:	a30ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f7a:	0000b517          	auipc	a0,0xb
ffffffffc0200f7e:	7b650513          	addi	a0,a0,1974 # ffffffffc020c730 <etext+0x91c>
ffffffffc0200f82:	a24ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f86:	0000b517          	auipc	a0,0xb
ffffffffc0200f8a:	76a50513          	addi	a0,a0,1898 # ffffffffc020c6f0 <etext+0x8dc>
ffffffffc0200f8e:	a18ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	77e50513          	addi	a0,a0,1918 # ffffffffc020c710 <etext+0x8fc>
ffffffffc0200f9a:	a0cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200f9e:	1141                	addi	sp,sp,-16
ffffffffc0200fa0:	e406                	sd	ra,8(sp)
ffffffffc0200fa2:	d86ff0ef          	jal	ffffffffc0200528 <clock_set_next_event>
ffffffffc0200fa6:	00096797          	auipc	a5,0x96
ffffffffc0200faa:	8ca7b783          	ld	a5,-1846(a5) # ffffffffc0296870 <ticks>
ffffffffc0200fae:	0785                	addi	a5,a5,1
ffffffffc0200fb0:	00096717          	auipc	a4,0x96
ffffffffc0200fb4:	8cf73023          	sd	a5,-1856(a4) # ffffffffc0296870 <ticks>
ffffffffc0200fb8:	539060ef          	jal	ffffffffc0207cf0 <run_timer_list>
ffffffffc0200fbc:	dfaff0ef          	jal	ffffffffc02005b6 <cons_getc>
ffffffffc0200fc0:	60a2                	ld	ra,8(sp)
ffffffffc0200fc2:	0ff57513          	zext.b	a0,a0
ffffffffc0200fc6:	0141                	addi	sp,sp,16
ffffffffc0200fc8:	44e0806f          	j	ffffffffc0209416 <dev_stdin_write>
ffffffffc0200fcc:	0000b517          	auipc	a0,0xb
ffffffffc0200fd0:	7a450513          	addi	a0,a0,1956 # ffffffffc020c770 <etext+0x95c>
ffffffffc0200fd4:	9d2ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200fd8:	bf11                	j	ffffffffc0200eec <print_trapframe>

ffffffffc0200fda <exception_handler>:
ffffffffc0200fda:	11853783          	ld	a5,280(a0)
ffffffffc0200fde:	473d                	li	a4,15
ffffffffc0200fe0:	14f76d63          	bltu	a4,a5,ffffffffc020113a <exception_handler+0x160>
ffffffffc0200fe4:	0000e717          	auipc	a4,0xe
ffffffffc0200fe8:	36c70713          	addi	a4,a4,876 # ffffffffc020f350 <commands+0x78>
ffffffffc0200fec:	078a                	slli	a5,a5,0x2
ffffffffc0200fee:	97ba                	add	a5,a5,a4
ffffffffc0200ff0:	439c                	lw	a5,0(a5)
ffffffffc0200ff2:	1101                	addi	sp,sp,-32
ffffffffc0200ff4:	ec06                	sd	ra,24(sp)
ffffffffc0200ff6:	97ba                	add	a5,a5,a4
ffffffffc0200ff8:	86aa                	mv	a3,a0
ffffffffc0200ffa:	8782                	jr	a5
ffffffffc0200ffc:	e42a                	sd	a0,8(sp)
ffffffffc0200ffe:	0000c517          	auipc	a0,0xc
ffffffffc0201002:	87a50513          	addi	a0,a0,-1926 # ffffffffc020c878 <etext+0xa64>
ffffffffc0201006:	9a0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020100a:	66a2                	ld	a3,8(sp)
ffffffffc020100c:	1086b783          	ld	a5,264(a3)
ffffffffc0201010:	60e2                	ld	ra,24(sp)
ffffffffc0201012:	0791                	addi	a5,a5,4
ffffffffc0201014:	10f6b423          	sd	a5,264(a3)
ffffffffc0201018:	6105                	addi	sp,sp,32
ffffffffc020101a:	7270606f          	j	ffffffffc0207f40 <syscall>
ffffffffc020101e:	60e2                	ld	ra,24(sp)
ffffffffc0201020:	0000c517          	auipc	a0,0xc
ffffffffc0201024:	87850513          	addi	a0,a0,-1928 # ffffffffc020c898 <etext+0xa84>
ffffffffc0201028:	6105                	addi	sp,sp,32
ffffffffc020102a:	97cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020102e:	60e2                	ld	ra,24(sp)
ffffffffc0201030:	0000c517          	auipc	a0,0xc
ffffffffc0201034:	88850513          	addi	a0,a0,-1912 # ffffffffc020c8b8 <etext+0xaa4>
ffffffffc0201038:	6105                	addi	sp,sp,32
ffffffffc020103a:	96cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103e:	11053603          	ld	a2,272(a0)
ffffffffc0201042:	10853583          	ld	a1,264(a0)
ffffffffc0201046:	e42a                	sd	a0,8(sp)
ffffffffc0201048:	0000c517          	auipc	a0,0xc
ffffffffc020104c:	89050513          	addi	a0,a0,-1904 # ffffffffc020c8d8 <etext+0xac4>
ffffffffc0201050:	956ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201054:	66a2                	ld	a3,8(sp)
ffffffffc0201056:	1006b783          	ld	a5,256(a3)
ffffffffc020105a:	1007f793          	andi	a5,a5,256
ffffffffc020105e:	cfcd                	beqz	a5,ffffffffc0201118 <exception_handler+0x13e>
ffffffffc0201060:	60e2                	ld	ra,24(sp)
ffffffffc0201062:	6105                	addi	sp,sp,32
ffffffffc0201064:	8082                	ret
ffffffffc0201066:	11053603          	ld	a2,272(a0)
ffffffffc020106a:	10853583          	ld	a1,264(a0)
ffffffffc020106e:	e42a                	sd	a0,8(sp)
ffffffffc0201070:	0000c517          	auipc	a0,0xc
ffffffffc0201074:	8a050513          	addi	a0,a0,-1888 # ffffffffc020c910 <etext+0xafc>
ffffffffc0201078:	bfe1                	j	ffffffffc0201050 <exception_handler+0x76>
ffffffffc020107a:	11053603          	ld	a2,272(a0)
ffffffffc020107e:	10853583          	ld	a1,264(a0)
ffffffffc0201082:	e42a                	sd	a0,8(sp)
ffffffffc0201084:	0000c517          	auipc	a0,0xc
ffffffffc0201088:	8bc50513          	addi	a0,a0,-1860 # ffffffffc020c940 <etext+0xb2c>
ffffffffc020108c:	b7d1                	j	ffffffffc0201050 <exception_handler+0x76>
ffffffffc020108e:	60e2                	ld	ra,24(sp)
ffffffffc0201090:	0000b517          	auipc	a0,0xb
ffffffffc0201094:	70050513          	addi	a0,a0,1792 # ffffffffc020c790 <etext+0x97c>
ffffffffc0201098:	6105                	addi	sp,sp,32
ffffffffc020109a:	90cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020109e:	60e2                	ld	ra,24(sp)
ffffffffc02010a0:	0000b517          	auipc	a0,0xb
ffffffffc02010a4:	71050513          	addi	a0,a0,1808 # ffffffffc020c7b0 <etext+0x99c>
ffffffffc02010a8:	6105                	addi	sp,sp,32
ffffffffc02010aa:	8fcff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010ae:	e42a                	sd	a0,8(sp)
ffffffffc02010b0:	0000b517          	auipc	a0,0xb
ffffffffc02010b4:	72050513          	addi	a0,a0,1824 # ffffffffc020c7d0 <etext+0x9bc>
ffffffffc02010b8:	8eeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02010bc:	66a2                	ld	a3,8(sp)
ffffffffc02010be:	1006b783          	ld	a5,256(a3)
ffffffffc02010c2:	1007f793          	andi	a5,a5,256
ffffffffc02010c6:	ffc9                	bnez	a5,ffffffffc0201060 <exception_handler+0x86>
ffffffffc02010c8:	60e2                	ld	ra,24(sp)
ffffffffc02010ca:	555d                	li	a0,-9
ffffffffc02010cc:	6105                	addi	sp,sp,32
ffffffffc02010ce:	1940506f          	j	ffffffffc0206262 <do_exit>
ffffffffc02010d2:	60e2                	ld	ra,24(sp)
ffffffffc02010d4:	0000b517          	auipc	a0,0xb
ffffffffc02010d8:	71450513          	addi	a0,a0,1812 # ffffffffc020c7e8 <etext+0x9d4>
ffffffffc02010dc:	6105                	addi	sp,sp,32
ffffffffc02010de:	8c8ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010e2:	60e2                	ld	ra,24(sp)
ffffffffc02010e4:	0000b517          	auipc	a0,0xb
ffffffffc02010e8:	71450513          	addi	a0,a0,1812 # ffffffffc020c7f8 <etext+0x9e4>
ffffffffc02010ec:	6105                	addi	sp,sp,32
ffffffffc02010ee:	8b8ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010f2:	60e2                	ld	ra,24(sp)
ffffffffc02010f4:	0000b517          	auipc	a0,0xb
ffffffffc02010f8:	72450513          	addi	a0,a0,1828 # ffffffffc020c818 <etext+0xa04>
ffffffffc02010fc:	6105                	addi	sp,sp,32
ffffffffc02010fe:	8a8ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201102:	60e2                	ld	ra,24(sp)
ffffffffc0201104:	0000b517          	auipc	a0,0xb
ffffffffc0201108:	75c50513          	addi	a0,a0,1884 # ffffffffc020c860 <etext+0xa4c>
ffffffffc020110c:	6105                	addi	sp,sp,32
ffffffffc020110e:	898ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201112:	60e2                	ld	ra,24(sp)
ffffffffc0201114:	6105                	addi	sp,sp,32
ffffffffc0201116:	bbd9                	j	ffffffffc0200eec <print_trapframe>
ffffffffc0201118:	60e2                	ld	ra,24(sp)
ffffffffc020111a:	5569                	li	a0,-6
ffffffffc020111c:	6105                	addi	sp,sp,32
ffffffffc020111e:	1440506f          	j	ffffffffc0206262 <do_exit>
ffffffffc0201122:	0000b617          	auipc	a2,0xb
ffffffffc0201126:	70e60613          	addi	a2,a2,1806 # ffffffffc020c830 <etext+0xa1c>
ffffffffc020112a:	0b600593          	li	a1,182
ffffffffc020112e:	0000b517          	auipc	a0,0xb
ffffffffc0201132:	71a50513          	addi	a0,a0,1818 # ffffffffc020c848 <etext+0xa34>
ffffffffc0201136:	b14ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020113a:	bb4d                	j	ffffffffc0200eec <print_trapframe>

ffffffffc020113c <trap>:
ffffffffc020113c:	00095717          	auipc	a4,0x95
ffffffffc0201140:	78c73703          	ld	a4,1932(a4) # ffffffffc02968c8 <current>
ffffffffc0201144:	11853583          	ld	a1,280(a0)
ffffffffc0201148:	cf21                	beqz	a4,ffffffffc02011a0 <trap+0x64>
ffffffffc020114a:	10053603          	ld	a2,256(a0)
ffffffffc020114e:	0a073803          	ld	a6,160(a4)
ffffffffc0201152:	1101                	addi	sp,sp,-32
ffffffffc0201154:	ec06                	sd	ra,24(sp)
ffffffffc0201156:	10067613          	andi	a2,a2,256
ffffffffc020115a:	f348                	sd	a0,160(a4)
ffffffffc020115c:	e432                	sd	a2,8(sp)
ffffffffc020115e:	e042                	sd	a6,0(sp)
ffffffffc0201160:	0205c763          	bltz	a1,ffffffffc020118e <trap+0x52>
ffffffffc0201164:	e77ff0ef          	jal	ffffffffc0200fda <exception_handler>
ffffffffc0201168:	6622                	ld	a2,8(sp)
ffffffffc020116a:	6802                	ld	a6,0(sp)
ffffffffc020116c:	00095697          	auipc	a3,0x95
ffffffffc0201170:	75c68693          	addi	a3,a3,1884 # ffffffffc02968c8 <current>
ffffffffc0201174:	6298                	ld	a4,0(a3)
ffffffffc0201176:	0b073023          	sd	a6,160(a4)
ffffffffc020117a:	e619                	bnez	a2,ffffffffc0201188 <trap+0x4c>
ffffffffc020117c:	0b072783          	lw	a5,176(a4)
ffffffffc0201180:	8b85                	andi	a5,a5,1
ffffffffc0201182:	e79d                	bnez	a5,ffffffffc02011b0 <trap+0x74>
ffffffffc0201184:	6f1c                	ld	a5,24(a4)
ffffffffc0201186:	e38d                	bnez	a5,ffffffffc02011a8 <trap+0x6c>
ffffffffc0201188:	60e2                	ld	ra,24(sp)
ffffffffc020118a:	6105                	addi	sp,sp,32
ffffffffc020118c:	8082                	ret
ffffffffc020118e:	dc1ff0ef          	jal	ffffffffc0200f4e <interrupt_handler>
ffffffffc0201192:	6802                	ld	a6,0(sp)
ffffffffc0201194:	6622                	ld	a2,8(sp)
ffffffffc0201196:	00095697          	auipc	a3,0x95
ffffffffc020119a:	73268693          	addi	a3,a3,1842 # ffffffffc02968c8 <current>
ffffffffc020119e:	bfd9                	j	ffffffffc0201174 <trap+0x38>
ffffffffc02011a0:	0005c363          	bltz	a1,ffffffffc02011a6 <trap+0x6a>
ffffffffc02011a4:	bd1d                	j	ffffffffc0200fda <exception_handler>
ffffffffc02011a6:	b365                	j	ffffffffc0200f4e <interrupt_handler>
ffffffffc02011a8:	60e2                	ld	ra,24(sp)
ffffffffc02011aa:	6105                	addi	sp,sp,32
ffffffffc02011ac:	13b0606f          	j	ffffffffc0207ae6 <schedule>
ffffffffc02011b0:	555d                	li	a0,-9
ffffffffc02011b2:	0b0050ef          	jal	ffffffffc0206262 <do_exit>
ffffffffc02011b6:	00095717          	auipc	a4,0x95
ffffffffc02011ba:	71273703          	ld	a4,1810(a4) # ffffffffc02968c8 <current>
ffffffffc02011be:	b7d9                	j	ffffffffc0201184 <trap+0x48>

ffffffffc02011c0 <__alltraps>:
ffffffffc02011c0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011c4:	00011463          	bnez	sp,ffffffffc02011cc <__alltraps+0xc>
ffffffffc02011c8:	14002173          	csrr	sp,sscratch
ffffffffc02011cc:	712d                	addi	sp,sp,-288
ffffffffc02011ce:	e002                	sd	zero,0(sp)
ffffffffc02011d0:	e406                	sd	ra,8(sp)
ffffffffc02011d2:	ec0e                	sd	gp,24(sp)
ffffffffc02011d4:	f012                	sd	tp,32(sp)
ffffffffc02011d6:	f416                	sd	t0,40(sp)
ffffffffc02011d8:	f81a                	sd	t1,48(sp)
ffffffffc02011da:	fc1e                	sd	t2,56(sp)
ffffffffc02011dc:	e0a2                	sd	s0,64(sp)
ffffffffc02011de:	e4a6                	sd	s1,72(sp)
ffffffffc02011e0:	e8aa                	sd	a0,80(sp)
ffffffffc02011e2:	ecae                	sd	a1,88(sp)
ffffffffc02011e4:	f0b2                	sd	a2,96(sp)
ffffffffc02011e6:	f4b6                	sd	a3,104(sp)
ffffffffc02011e8:	f8ba                	sd	a4,112(sp)
ffffffffc02011ea:	fcbe                	sd	a5,120(sp)
ffffffffc02011ec:	e142                	sd	a6,128(sp)
ffffffffc02011ee:	e546                	sd	a7,136(sp)
ffffffffc02011f0:	e94a                	sd	s2,144(sp)
ffffffffc02011f2:	ed4e                	sd	s3,152(sp)
ffffffffc02011f4:	f152                	sd	s4,160(sp)
ffffffffc02011f6:	f556                	sd	s5,168(sp)
ffffffffc02011f8:	f95a                	sd	s6,176(sp)
ffffffffc02011fa:	fd5e                	sd	s7,184(sp)
ffffffffc02011fc:	e1e2                	sd	s8,192(sp)
ffffffffc02011fe:	e5e6                	sd	s9,200(sp)
ffffffffc0201200:	e9ea                	sd	s10,208(sp)
ffffffffc0201202:	edee                	sd	s11,216(sp)
ffffffffc0201204:	f1f2                	sd	t3,224(sp)
ffffffffc0201206:	f5f6                	sd	t4,232(sp)
ffffffffc0201208:	f9fa                	sd	t5,240(sp)
ffffffffc020120a:	fdfe                	sd	t6,248(sp)
ffffffffc020120c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201210:	100024f3          	csrr	s1,sstatus
ffffffffc0201214:	14102973          	csrr	s2,sepc
ffffffffc0201218:	143029f3          	csrr	s3,stval
ffffffffc020121c:	14202a73          	csrr	s4,scause
ffffffffc0201220:	e822                	sd	s0,16(sp)
ffffffffc0201222:	e226                	sd	s1,256(sp)
ffffffffc0201224:	e64a                	sd	s2,264(sp)
ffffffffc0201226:	ea4e                	sd	s3,272(sp)
ffffffffc0201228:	ee52                	sd	s4,280(sp)
ffffffffc020122a:	850a                	mv	a0,sp
ffffffffc020122c:	f11ff0ef          	jal	ffffffffc020113c <trap>

ffffffffc0201230 <__trapret>:
ffffffffc0201230:	6492                	ld	s1,256(sp)
ffffffffc0201232:	6932                	ld	s2,264(sp)
ffffffffc0201234:	1004f413          	andi	s0,s1,256
ffffffffc0201238:	e401                	bnez	s0,ffffffffc0201240 <__trapret+0x10>
ffffffffc020123a:	1200                	addi	s0,sp,288
ffffffffc020123c:	14041073          	csrw	sscratch,s0
ffffffffc0201240:	10049073          	csrw	sstatus,s1
ffffffffc0201244:	14191073          	csrw	sepc,s2
ffffffffc0201248:	60a2                	ld	ra,8(sp)
ffffffffc020124a:	61e2                	ld	gp,24(sp)
ffffffffc020124c:	7202                	ld	tp,32(sp)
ffffffffc020124e:	72a2                	ld	t0,40(sp)
ffffffffc0201250:	7342                	ld	t1,48(sp)
ffffffffc0201252:	73e2                	ld	t2,56(sp)
ffffffffc0201254:	6406                	ld	s0,64(sp)
ffffffffc0201256:	64a6                	ld	s1,72(sp)
ffffffffc0201258:	6546                	ld	a0,80(sp)
ffffffffc020125a:	65e6                	ld	a1,88(sp)
ffffffffc020125c:	7606                	ld	a2,96(sp)
ffffffffc020125e:	76a6                	ld	a3,104(sp)
ffffffffc0201260:	7746                	ld	a4,112(sp)
ffffffffc0201262:	77e6                	ld	a5,120(sp)
ffffffffc0201264:	680a                	ld	a6,128(sp)
ffffffffc0201266:	68aa                	ld	a7,136(sp)
ffffffffc0201268:	694a                	ld	s2,144(sp)
ffffffffc020126a:	69ea                	ld	s3,152(sp)
ffffffffc020126c:	7a0a                	ld	s4,160(sp)
ffffffffc020126e:	7aaa                	ld	s5,168(sp)
ffffffffc0201270:	7b4a                	ld	s6,176(sp)
ffffffffc0201272:	7bea                	ld	s7,184(sp)
ffffffffc0201274:	6c0e                	ld	s8,192(sp)
ffffffffc0201276:	6cae                	ld	s9,200(sp)
ffffffffc0201278:	6d4e                	ld	s10,208(sp)
ffffffffc020127a:	6dee                	ld	s11,216(sp)
ffffffffc020127c:	7e0e                	ld	t3,224(sp)
ffffffffc020127e:	7eae                	ld	t4,232(sp)
ffffffffc0201280:	7f4e                	ld	t5,240(sp)
ffffffffc0201282:	7fee                	ld	t6,248(sp)
ffffffffc0201284:	6142                	ld	sp,16(sp)
ffffffffc0201286:	10200073          	sret

ffffffffc020128a <forkrets>:
ffffffffc020128a:	812a                	mv	sp,a0
ffffffffc020128c:	b755                	j	ffffffffc0201230 <__trapret>

ffffffffc020128e <default_init>:
ffffffffc020128e:	00090797          	auipc	a5,0x90
ffffffffc0201292:	51a78793          	addi	a5,a5,1306 # ffffffffc02917a8 <free_area>
ffffffffc0201296:	e79c                	sd	a5,8(a5)
ffffffffc0201298:	e39c                	sd	a5,0(a5)
ffffffffc020129a:	0007a823          	sw	zero,16(a5)
ffffffffc020129e:	8082                	ret

ffffffffc02012a0 <default_nr_free_pages>:
ffffffffc02012a0:	00090517          	auipc	a0,0x90
ffffffffc02012a4:	51856503          	lwu	a0,1304(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02012a8:	8082                	ret

ffffffffc02012aa <default_check>:
ffffffffc02012aa:	711d                	addi	sp,sp,-96
ffffffffc02012ac:	e0ca                	sd	s2,64(sp)
ffffffffc02012ae:	00090917          	auipc	s2,0x90
ffffffffc02012b2:	4fa90913          	addi	s2,s2,1274 # ffffffffc02917a8 <free_area>
ffffffffc02012b6:	00893783          	ld	a5,8(s2)
ffffffffc02012ba:	ec86                	sd	ra,88(sp)
ffffffffc02012bc:	e8a2                	sd	s0,80(sp)
ffffffffc02012be:	e4a6                	sd	s1,72(sp)
ffffffffc02012c0:	fc4e                	sd	s3,56(sp)
ffffffffc02012c2:	f852                	sd	s4,48(sp)
ffffffffc02012c4:	f456                	sd	s5,40(sp)
ffffffffc02012c6:	f05a                	sd	s6,32(sp)
ffffffffc02012c8:	ec5e                	sd	s7,24(sp)
ffffffffc02012ca:	e862                	sd	s8,16(sp)
ffffffffc02012cc:	e466                	sd	s9,8(sp)
ffffffffc02012ce:	2f278363          	beq	a5,s2,ffffffffc02015b4 <default_check+0x30a>
ffffffffc02012d2:	4401                	li	s0,0
ffffffffc02012d4:	4481                	li	s1,0
ffffffffc02012d6:	ff07b703          	ld	a4,-16(a5)
ffffffffc02012da:	8b09                	andi	a4,a4,2
ffffffffc02012dc:	2e070063          	beqz	a4,ffffffffc02015bc <default_check+0x312>
ffffffffc02012e0:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012e4:	679c                	ld	a5,8(a5)
ffffffffc02012e6:	2485                	addiw	s1,s1,1
ffffffffc02012e8:	9c39                	addw	s0,s0,a4
ffffffffc02012ea:	ff2796e3          	bne	a5,s2,ffffffffc02012d6 <default_check+0x2c>
ffffffffc02012ee:	89a2                	mv	s3,s0
ffffffffc02012f0:	743000ef          	jal	ffffffffc0202232 <nr_free_pages>
ffffffffc02012f4:	73351463          	bne	a0,s3,ffffffffc0201a1c <default_check+0x772>
ffffffffc02012f8:	4505                	li	a0,1
ffffffffc02012fa:	6c7000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02012fe:	8a2a                	mv	s4,a0
ffffffffc0201300:	44050e63          	beqz	a0,ffffffffc020175c <default_check+0x4b2>
ffffffffc0201304:	4505                	li	a0,1
ffffffffc0201306:	6bb000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc020130a:	89aa                	mv	s3,a0
ffffffffc020130c:	72050863          	beqz	a0,ffffffffc0201a3c <default_check+0x792>
ffffffffc0201310:	4505                	li	a0,1
ffffffffc0201312:	6af000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201316:	8aaa                	mv	s5,a0
ffffffffc0201318:	4c050263          	beqz	a0,ffffffffc02017dc <default_check+0x532>
ffffffffc020131c:	40a987b3          	sub	a5,s3,a0
ffffffffc0201320:	40aa0733          	sub	a4,s4,a0
ffffffffc0201324:	0017b793          	seqz	a5,a5
ffffffffc0201328:	00173713          	seqz	a4,a4
ffffffffc020132c:	8fd9                	or	a5,a5,a4
ffffffffc020132e:	30079763          	bnez	a5,ffffffffc020163c <default_check+0x392>
ffffffffc0201332:	313a0563          	beq	s4,s3,ffffffffc020163c <default_check+0x392>
ffffffffc0201336:	000a2783          	lw	a5,0(s4)
ffffffffc020133a:	2a079163          	bnez	a5,ffffffffc02015dc <default_check+0x332>
ffffffffc020133e:	0009a783          	lw	a5,0(s3)
ffffffffc0201342:	28079d63          	bnez	a5,ffffffffc02015dc <default_check+0x332>
ffffffffc0201346:	411c                	lw	a5,0(a0)
ffffffffc0201348:	28079a63          	bnez	a5,ffffffffc02015dc <default_check+0x332>
ffffffffc020134c:	00095797          	auipc	a5,0x95
ffffffffc0201350:	56c7b783          	ld	a5,1388(a5) # ffffffffc02968b8 <pages>
ffffffffc0201354:	0000f617          	auipc	a2,0xf
ffffffffc0201358:	c4463603          	ld	a2,-956(a2) # ffffffffc020ff98 <nbase>
ffffffffc020135c:	00095697          	auipc	a3,0x95
ffffffffc0201360:	5546b683          	ld	a3,1364(a3) # ffffffffc02968b0 <npage>
ffffffffc0201364:	40fa0733          	sub	a4,s4,a5
ffffffffc0201368:	8719                	srai	a4,a4,0x6
ffffffffc020136a:	9732                	add	a4,a4,a2
ffffffffc020136c:	0732                	slli	a4,a4,0xc
ffffffffc020136e:	06b2                	slli	a3,a3,0xc
ffffffffc0201370:	2ad77663          	bgeu	a4,a3,ffffffffc020161c <default_check+0x372>
ffffffffc0201374:	40f98733          	sub	a4,s3,a5
ffffffffc0201378:	8719                	srai	a4,a4,0x6
ffffffffc020137a:	9732                	add	a4,a4,a2
ffffffffc020137c:	0732                	slli	a4,a4,0xc
ffffffffc020137e:	4cd77f63          	bgeu	a4,a3,ffffffffc020185c <default_check+0x5b2>
ffffffffc0201382:	40f507b3          	sub	a5,a0,a5
ffffffffc0201386:	8799                	srai	a5,a5,0x6
ffffffffc0201388:	97b2                	add	a5,a5,a2
ffffffffc020138a:	07b2                	slli	a5,a5,0xc
ffffffffc020138c:	32d7f863          	bgeu	a5,a3,ffffffffc02016bc <default_check+0x412>
ffffffffc0201390:	4505                	li	a0,1
ffffffffc0201392:	00093c03          	ld	s8,0(s2)
ffffffffc0201396:	00893b83          	ld	s7,8(s2)
ffffffffc020139a:	00090b17          	auipc	s6,0x90
ffffffffc020139e:	41eb2b03          	lw	s6,1054(s6) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013a2:	01293023          	sd	s2,0(s2)
ffffffffc02013a6:	01293423          	sd	s2,8(s2)
ffffffffc02013aa:	00090797          	auipc	a5,0x90
ffffffffc02013ae:	4007a723          	sw	zero,1038(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013b2:	60f000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02013b6:	2e051363          	bnez	a0,ffffffffc020169c <default_check+0x3f2>
ffffffffc02013ba:	8552                	mv	a0,s4
ffffffffc02013bc:	4585                	li	a1,1
ffffffffc02013be:	63d000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02013c2:	854e                	mv	a0,s3
ffffffffc02013c4:	4585                	li	a1,1
ffffffffc02013c6:	635000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02013ca:	8556                	mv	a0,s5
ffffffffc02013cc:	4585                	li	a1,1
ffffffffc02013ce:	62d000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02013d2:	00090717          	auipc	a4,0x90
ffffffffc02013d6:	3e672703          	lw	a4,998(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013da:	478d                	li	a5,3
ffffffffc02013dc:	2af71063          	bne	a4,a5,ffffffffc020167c <default_check+0x3d2>
ffffffffc02013e0:	4505                	li	a0,1
ffffffffc02013e2:	5df000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02013e6:	89aa                	mv	s3,a0
ffffffffc02013e8:	26050a63          	beqz	a0,ffffffffc020165c <default_check+0x3b2>
ffffffffc02013ec:	4505                	li	a0,1
ffffffffc02013ee:	5d3000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02013f2:	8aaa                	mv	s5,a0
ffffffffc02013f4:	3c050463          	beqz	a0,ffffffffc02017bc <default_check+0x512>
ffffffffc02013f8:	4505                	li	a0,1
ffffffffc02013fa:	5c7000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02013fe:	8a2a                	mv	s4,a0
ffffffffc0201400:	38050e63          	beqz	a0,ffffffffc020179c <default_check+0x4f2>
ffffffffc0201404:	4505                	li	a0,1
ffffffffc0201406:	5bb000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc020140a:	36051963          	bnez	a0,ffffffffc020177c <default_check+0x4d2>
ffffffffc020140e:	4585                	li	a1,1
ffffffffc0201410:	854e                	mv	a0,s3
ffffffffc0201412:	5e9000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc0201416:	00893783          	ld	a5,8(s2)
ffffffffc020141a:	1f278163          	beq	a5,s2,ffffffffc02015fc <default_check+0x352>
ffffffffc020141e:	4505                	li	a0,1
ffffffffc0201420:	5a1000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201424:	8caa                	mv	s9,a0
ffffffffc0201426:	30a99b63          	bne	s3,a0,ffffffffc020173c <default_check+0x492>
ffffffffc020142a:	4505                	li	a0,1
ffffffffc020142c:	595000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201430:	2e051663          	bnez	a0,ffffffffc020171c <default_check+0x472>
ffffffffc0201434:	00090797          	auipc	a5,0x90
ffffffffc0201438:	3847a783          	lw	a5,900(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020143c:	2c079063          	bnez	a5,ffffffffc02016fc <default_check+0x452>
ffffffffc0201440:	8566                	mv	a0,s9
ffffffffc0201442:	4585                	li	a1,1
ffffffffc0201444:	01893023          	sd	s8,0(s2)
ffffffffc0201448:	01793423          	sd	s7,8(s2)
ffffffffc020144c:	01692823          	sw	s6,16(s2)
ffffffffc0201450:	5ab000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc0201454:	8556                	mv	a0,s5
ffffffffc0201456:	4585                	li	a1,1
ffffffffc0201458:	5a3000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc020145c:	8552                	mv	a0,s4
ffffffffc020145e:	4585                	li	a1,1
ffffffffc0201460:	59b000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc0201464:	4515                	li	a0,5
ffffffffc0201466:	55b000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc020146a:	89aa                	mv	s3,a0
ffffffffc020146c:	26050863          	beqz	a0,ffffffffc02016dc <default_check+0x432>
ffffffffc0201470:	651c                	ld	a5,8(a0)
ffffffffc0201472:	8b89                	andi	a5,a5,2
ffffffffc0201474:	54079463          	bnez	a5,ffffffffc02019bc <default_check+0x712>
ffffffffc0201478:	4505                	li	a0,1
ffffffffc020147a:	00093b83          	ld	s7,0(s2)
ffffffffc020147e:	00893b03          	ld	s6,8(s2)
ffffffffc0201482:	01293023          	sd	s2,0(s2)
ffffffffc0201486:	01293423          	sd	s2,8(s2)
ffffffffc020148a:	537000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc020148e:	50051763          	bnez	a0,ffffffffc020199c <default_check+0x6f2>
ffffffffc0201492:	08098a13          	addi	s4,s3,128
ffffffffc0201496:	8552                	mv	a0,s4
ffffffffc0201498:	458d                	li	a1,3
ffffffffc020149a:	00090c17          	auipc	s8,0x90
ffffffffc020149e:	31ec2c03          	lw	s8,798(s8) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02014a2:	00090797          	auipc	a5,0x90
ffffffffc02014a6:	3007ab23          	sw	zero,790(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02014aa:	551000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02014ae:	4511                	li	a0,4
ffffffffc02014b0:	511000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02014b4:	4c051463          	bnez	a0,ffffffffc020197c <default_check+0x6d2>
ffffffffc02014b8:	0889b783          	ld	a5,136(s3)
ffffffffc02014bc:	8b89                	andi	a5,a5,2
ffffffffc02014be:	48078f63          	beqz	a5,ffffffffc020195c <default_check+0x6b2>
ffffffffc02014c2:	0909a503          	lw	a0,144(s3)
ffffffffc02014c6:	478d                	li	a5,3
ffffffffc02014c8:	48f51a63          	bne	a0,a5,ffffffffc020195c <default_check+0x6b2>
ffffffffc02014cc:	4f5000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02014d0:	8aaa                	mv	s5,a0
ffffffffc02014d2:	46050563          	beqz	a0,ffffffffc020193c <default_check+0x692>
ffffffffc02014d6:	4505                	li	a0,1
ffffffffc02014d8:	4e9000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc02014dc:	44051063          	bnez	a0,ffffffffc020191c <default_check+0x672>
ffffffffc02014e0:	415a1e63          	bne	s4,s5,ffffffffc02018fc <default_check+0x652>
ffffffffc02014e4:	4585                	li	a1,1
ffffffffc02014e6:	854e                	mv	a0,s3
ffffffffc02014e8:	513000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02014ec:	8552                	mv	a0,s4
ffffffffc02014ee:	458d                	li	a1,3
ffffffffc02014f0:	50b000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02014f4:	0089b783          	ld	a5,8(s3)
ffffffffc02014f8:	8b89                	andi	a5,a5,2
ffffffffc02014fa:	3e078163          	beqz	a5,ffffffffc02018dc <default_check+0x632>
ffffffffc02014fe:	0109aa83          	lw	s5,16(s3)
ffffffffc0201502:	4785                	li	a5,1
ffffffffc0201504:	3cfa9c63          	bne	s5,a5,ffffffffc02018dc <default_check+0x632>
ffffffffc0201508:	008a3783          	ld	a5,8(s4)
ffffffffc020150c:	8b89                	andi	a5,a5,2
ffffffffc020150e:	3a078763          	beqz	a5,ffffffffc02018bc <default_check+0x612>
ffffffffc0201512:	010a2703          	lw	a4,16(s4)
ffffffffc0201516:	478d                	li	a5,3
ffffffffc0201518:	3af71263          	bne	a4,a5,ffffffffc02018bc <default_check+0x612>
ffffffffc020151c:	8556                	mv	a0,s5
ffffffffc020151e:	4a3000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201522:	36a99d63          	bne	s3,a0,ffffffffc020189c <default_check+0x5f2>
ffffffffc0201526:	85d6                	mv	a1,s5
ffffffffc0201528:	4d3000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc020152c:	4509                	li	a0,2
ffffffffc020152e:	493000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201532:	34aa1563          	bne	s4,a0,ffffffffc020187c <default_check+0x5d2>
ffffffffc0201536:	4589                	li	a1,2
ffffffffc0201538:	4c3000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc020153c:	04098513          	addi	a0,s3,64
ffffffffc0201540:	85d6                	mv	a1,s5
ffffffffc0201542:	4b9000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc0201546:	4515                	li	a0,5
ffffffffc0201548:	479000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc020154c:	89aa                	mv	s3,a0
ffffffffc020154e:	48050763          	beqz	a0,ffffffffc02019dc <default_check+0x732>
ffffffffc0201552:	8556                	mv	a0,s5
ffffffffc0201554:	46d000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201558:	2e051263          	bnez	a0,ffffffffc020183c <default_check+0x592>
ffffffffc020155c:	00090797          	auipc	a5,0x90
ffffffffc0201560:	25c7a783          	lw	a5,604(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201564:	2a079c63          	bnez	a5,ffffffffc020181c <default_check+0x572>
ffffffffc0201568:	854e                	mv	a0,s3
ffffffffc020156a:	4595                	li	a1,5
ffffffffc020156c:	01892823          	sw	s8,16(s2)
ffffffffc0201570:	01793023          	sd	s7,0(s2)
ffffffffc0201574:	01693423          	sd	s6,8(s2)
ffffffffc0201578:	483000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc020157c:	00893783          	ld	a5,8(s2)
ffffffffc0201580:	01278963          	beq	a5,s2,ffffffffc0201592 <default_check+0x2e8>
ffffffffc0201584:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201588:	679c                	ld	a5,8(a5)
ffffffffc020158a:	34fd                	addiw	s1,s1,-1
ffffffffc020158c:	9c19                	subw	s0,s0,a4
ffffffffc020158e:	ff279be3          	bne	a5,s2,ffffffffc0201584 <default_check+0x2da>
ffffffffc0201592:	26049563          	bnez	s1,ffffffffc02017fc <default_check+0x552>
ffffffffc0201596:	46041363          	bnez	s0,ffffffffc02019fc <default_check+0x752>
ffffffffc020159a:	60e6                	ld	ra,88(sp)
ffffffffc020159c:	6446                	ld	s0,80(sp)
ffffffffc020159e:	64a6                	ld	s1,72(sp)
ffffffffc02015a0:	6906                	ld	s2,64(sp)
ffffffffc02015a2:	79e2                	ld	s3,56(sp)
ffffffffc02015a4:	7a42                	ld	s4,48(sp)
ffffffffc02015a6:	7aa2                	ld	s5,40(sp)
ffffffffc02015a8:	7b02                	ld	s6,32(sp)
ffffffffc02015aa:	6be2                	ld	s7,24(sp)
ffffffffc02015ac:	6c42                	ld	s8,16(sp)
ffffffffc02015ae:	6ca2                	ld	s9,8(sp)
ffffffffc02015b0:	6125                	addi	sp,sp,96
ffffffffc02015b2:	8082                	ret
ffffffffc02015b4:	4981                	li	s3,0
ffffffffc02015b6:	4401                	li	s0,0
ffffffffc02015b8:	4481                	li	s1,0
ffffffffc02015ba:	bb1d                	j	ffffffffc02012f0 <default_check+0x46>
ffffffffc02015bc:	0000b697          	auipc	a3,0xb
ffffffffc02015c0:	3b468693          	addi	a3,a3,948 # ffffffffc020c970 <etext+0xb5c>
ffffffffc02015c4:	0000b617          	auipc	a2,0xb
ffffffffc02015c8:	c8c60613          	addi	a2,a2,-884 # ffffffffc020c250 <etext+0x43c>
ffffffffc02015cc:	0ef00593          	li	a1,239
ffffffffc02015d0:	0000b517          	auipc	a0,0xb
ffffffffc02015d4:	3b050513          	addi	a0,a0,944 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02015d8:	e73fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015dc:	0000b697          	auipc	a3,0xb
ffffffffc02015e0:	46468693          	addi	a3,a3,1124 # ffffffffc020ca40 <etext+0xc2c>
ffffffffc02015e4:	0000b617          	auipc	a2,0xb
ffffffffc02015e8:	c6c60613          	addi	a2,a2,-916 # ffffffffc020c250 <etext+0x43c>
ffffffffc02015ec:	0bd00593          	li	a1,189
ffffffffc02015f0:	0000b517          	auipc	a0,0xb
ffffffffc02015f4:	39050513          	addi	a0,a0,912 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02015f8:	e53fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02015fc:	0000b697          	auipc	a3,0xb
ffffffffc0201600:	50c68693          	addi	a3,a3,1292 # ffffffffc020cb08 <etext+0xcf4>
ffffffffc0201604:	0000b617          	auipc	a2,0xb
ffffffffc0201608:	c4c60613          	addi	a2,a2,-948 # ffffffffc020c250 <etext+0x43c>
ffffffffc020160c:	0d800593          	li	a1,216
ffffffffc0201610:	0000b517          	auipc	a0,0xb
ffffffffc0201614:	37050513          	addi	a0,a0,880 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201618:	e33fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020161c:	0000b697          	auipc	a3,0xb
ffffffffc0201620:	46468693          	addi	a3,a3,1124 # ffffffffc020ca80 <etext+0xc6c>
ffffffffc0201624:	0000b617          	auipc	a2,0xb
ffffffffc0201628:	c2c60613          	addi	a2,a2,-980 # ffffffffc020c250 <etext+0x43c>
ffffffffc020162c:	0bf00593          	li	a1,191
ffffffffc0201630:	0000b517          	auipc	a0,0xb
ffffffffc0201634:	35050513          	addi	a0,a0,848 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201638:	e13fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020163c:	0000b697          	auipc	a3,0xb
ffffffffc0201640:	3dc68693          	addi	a3,a3,988 # ffffffffc020ca18 <etext+0xc04>
ffffffffc0201644:	0000b617          	auipc	a2,0xb
ffffffffc0201648:	c0c60613          	addi	a2,a2,-1012 # ffffffffc020c250 <etext+0x43c>
ffffffffc020164c:	0bc00593          	li	a1,188
ffffffffc0201650:	0000b517          	auipc	a0,0xb
ffffffffc0201654:	33050513          	addi	a0,a0,816 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201658:	df3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020165c:	0000b697          	auipc	a3,0xb
ffffffffc0201660:	35c68693          	addi	a3,a3,860 # ffffffffc020c9b8 <etext+0xba4>
ffffffffc0201664:	0000b617          	auipc	a2,0xb
ffffffffc0201668:	bec60613          	addi	a2,a2,-1044 # ffffffffc020c250 <etext+0x43c>
ffffffffc020166c:	0d100593          	li	a1,209
ffffffffc0201670:	0000b517          	auipc	a0,0xb
ffffffffc0201674:	31050513          	addi	a0,a0,784 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201678:	dd3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020167c:	0000b697          	auipc	a3,0xb
ffffffffc0201680:	47c68693          	addi	a3,a3,1148 # ffffffffc020caf8 <etext+0xce4>
ffffffffc0201684:	0000b617          	auipc	a2,0xb
ffffffffc0201688:	bcc60613          	addi	a2,a2,-1076 # ffffffffc020c250 <etext+0x43c>
ffffffffc020168c:	0cf00593          	li	a1,207
ffffffffc0201690:	0000b517          	auipc	a0,0xb
ffffffffc0201694:	2f050513          	addi	a0,a0,752 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201698:	db3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020169c:	0000b697          	auipc	a3,0xb
ffffffffc02016a0:	44468693          	addi	a3,a3,1092 # ffffffffc020cae0 <etext+0xccc>
ffffffffc02016a4:	0000b617          	auipc	a2,0xb
ffffffffc02016a8:	bac60613          	addi	a2,a2,-1108 # ffffffffc020c250 <etext+0x43c>
ffffffffc02016ac:	0ca00593          	li	a1,202
ffffffffc02016b0:	0000b517          	auipc	a0,0xb
ffffffffc02016b4:	2d050513          	addi	a0,a0,720 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02016b8:	d93fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016bc:	0000b697          	auipc	a3,0xb
ffffffffc02016c0:	40468693          	addi	a3,a3,1028 # ffffffffc020cac0 <etext+0xcac>
ffffffffc02016c4:	0000b617          	auipc	a2,0xb
ffffffffc02016c8:	b8c60613          	addi	a2,a2,-1140 # ffffffffc020c250 <etext+0x43c>
ffffffffc02016cc:	0c100593          	li	a1,193
ffffffffc02016d0:	0000b517          	auipc	a0,0xb
ffffffffc02016d4:	2b050513          	addi	a0,a0,688 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02016d8:	d73fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016dc:	0000b697          	auipc	a3,0xb
ffffffffc02016e0:	47468693          	addi	a3,a3,1140 # ffffffffc020cb50 <etext+0xd3c>
ffffffffc02016e4:	0000b617          	auipc	a2,0xb
ffffffffc02016e8:	b6c60613          	addi	a2,a2,-1172 # ffffffffc020c250 <etext+0x43c>
ffffffffc02016ec:	0f700593          	li	a1,247
ffffffffc02016f0:	0000b517          	auipc	a0,0xb
ffffffffc02016f4:	29050513          	addi	a0,a0,656 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02016f8:	d53fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02016fc:	0000b697          	auipc	a3,0xb
ffffffffc0201700:	44468693          	addi	a3,a3,1092 # ffffffffc020cb40 <etext+0xd2c>
ffffffffc0201704:	0000b617          	auipc	a2,0xb
ffffffffc0201708:	b4c60613          	addi	a2,a2,-1204 # ffffffffc020c250 <etext+0x43c>
ffffffffc020170c:	0de00593          	li	a1,222
ffffffffc0201710:	0000b517          	auipc	a0,0xb
ffffffffc0201714:	27050513          	addi	a0,a0,624 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201718:	d33fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020171c:	0000b697          	auipc	a3,0xb
ffffffffc0201720:	3c468693          	addi	a3,a3,964 # ffffffffc020cae0 <etext+0xccc>
ffffffffc0201724:	0000b617          	auipc	a2,0xb
ffffffffc0201728:	b2c60613          	addi	a2,a2,-1236 # ffffffffc020c250 <etext+0x43c>
ffffffffc020172c:	0dc00593          	li	a1,220
ffffffffc0201730:	0000b517          	auipc	a0,0xb
ffffffffc0201734:	25050513          	addi	a0,a0,592 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201738:	d13fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020173c:	0000b697          	auipc	a3,0xb
ffffffffc0201740:	3e468693          	addi	a3,a3,996 # ffffffffc020cb20 <etext+0xd0c>
ffffffffc0201744:	0000b617          	auipc	a2,0xb
ffffffffc0201748:	b0c60613          	addi	a2,a2,-1268 # ffffffffc020c250 <etext+0x43c>
ffffffffc020174c:	0db00593          	li	a1,219
ffffffffc0201750:	0000b517          	auipc	a0,0xb
ffffffffc0201754:	23050513          	addi	a0,a0,560 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201758:	cf3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020175c:	0000b697          	auipc	a3,0xb
ffffffffc0201760:	25c68693          	addi	a3,a3,604 # ffffffffc020c9b8 <etext+0xba4>
ffffffffc0201764:	0000b617          	auipc	a2,0xb
ffffffffc0201768:	aec60613          	addi	a2,a2,-1300 # ffffffffc020c250 <etext+0x43c>
ffffffffc020176c:	0b800593          	li	a1,184
ffffffffc0201770:	0000b517          	auipc	a0,0xb
ffffffffc0201774:	21050513          	addi	a0,a0,528 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201778:	cd3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020177c:	0000b697          	auipc	a3,0xb
ffffffffc0201780:	36468693          	addi	a3,a3,868 # ffffffffc020cae0 <etext+0xccc>
ffffffffc0201784:	0000b617          	auipc	a2,0xb
ffffffffc0201788:	acc60613          	addi	a2,a2,-1332 # ffffffffc020c250 <etext+0x43c>
ffffffffc020178c:	0d500593          	li	a1,213
ffffffffc0201790:	0000b517          	auipc	a0,0xb
ffffffffc0201794:	1f050513          	addi	a0,a0,496 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201798:	cb3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020179c:	0000b697          	auipc	a3,0xb
ffffffffc02017a0:	25c68693          	addi	a3,a3,604 # ffffffffc020c9f8 <etext+0xbe4>
ffffffffc02017a4:	0000b617          	auipc	a2,0xb
ffffffffc02017a8:	aac60613          	addi	a2,a2,-1364 # ffffffffc020c250 <etext+0x43c>
ffffffffc02017ac:	0d300593          	li	a1,211
ffffffffc02017b0:	0000b517          	auipc	a0,0xb
ffffffffc02017b4:	1d050513          	addi	a0,a0,464 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02017b8:	c93fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017bc:	0000b697          	auipc	a3,0xb
ffffffffc02017c0:	21c68693          	addi	a3,a3,540 # ffffffffc020c9d8 <etext+0xbc4>
ffffffffc02017c4:	0000b617          	auipc	a2,0xb
ffffffffc02017c8:	a8c60613          	addi	a2,a2,-1396 # ffffffffc020c250 <etext+0x43c>
ffffffffc02017cc:	0d200593          	li	a1,210
ffffffffc02017d0:	0000b517          	auipc	a0,0xb
ffffffffc02017d4:	1b050513          	addi	a0,a0,432 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02017d8:	c73fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017dc:	0000b697          	auipc	a3,0xb
ffffffffc02017e0:	21c68693          	addi	a3,a3,540 # ffffffffc020c9f8 <etext+0xbe4>
ffffffffc02017e4:	0000b617          	auipc	a2,0xb
ffffffffc02017e8:	a6c60613          	addi	a2,a2,-1428 # ffffffffc020c250 <etext+0x43c>
ffffffffc02017ec:	0ba00593          	li	a1,186
ffffffffc02017f0:	0000b517          	auipc	a0,0xb
ffffffffc02017f4:	19050513          	addi	a0,a0,400 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02017f8:	c53fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017fc:	0000b697          	auipc	a3,0xb
ffffffffc0201800:	4a468693          	addi	a3,a3,1188 # ffffffffc020cca0 <etext+0xe8c>
ffffffffc0201804:	0000b617          	auipc	a2,0xb
ffffffffc0201808:	a4c60613          	addi	a2,a2,-1460 # ffffffffc020c250 <etext+0x43c>
ffffffffc020180c:	12400593          	li	a1,292
ffffffffc0201810:	0000b517          	auipc	a0,0xb
ffffffffc0201814:	17050513          	addi	a0,a0,368 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201818:	c33fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020181c:	0000b697          	auipc	a3,0xb
ffffffffc0201820:	32468693          	addi	a3,a3,804 # ffffffffc020cb40 <etext+0xd2c>
ffffffffc0201824:	0000b617          	auipc	a2,0xb
ffffffffc0201828:	a2c60613          	addi	a2,a2,-1492 # ffffffffc020c250 <etext+0x43c>
ffffffffc020182c:	11900593          	li	a1,281
ffffffffc0201830:	0000b517          	auipc	a0,0xb
ffffffffc0201834:	15050513          	addi	a0,a0,336 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201838:	c13fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020183c:	0000b697          	auipc	a3,0xb
ffffffffc0201840:	2a468693          	addi	a3,a3,676 # ffffffffc020cae0 <etext+0xccc>
ffffffffc0201844:	0000b617          	auipc	a2,0xb
ffffffffc0201848:	a0c60613          	addi	a2,a2,-1524 # ffffffffc020c250 <etext+0x43c>
ffffffffc020184c:	11700593          	li	a1,279
ffffffffc0201850:	0000b517          	auipc	a0,0xb
ffffffffc0201854:	13050513          	addi	a0,a0,304 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201858:	bf3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020185c:	0000b697          	auipc	a3,0xb
ffffffffc0201860:	24468693          	addi	a3,a3,580 # ffffffffc020caa0 <etext+0xc8c>
ffffffffc0201864:	0000b617          	auipc	a2,0xb
ffffffffc0201868:	9ec60613          	addi	a2,a2,-1556 # ffffffffc020c250 <etext+0x43c>
ffffffffc020186c:	0c000593          	li	a1,192
ffffffffc0201870:	0000b517          	auipc	a0,0xb
ffffffffc0201874:	11050513          	addi	a0,a0,272 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201878:	bd3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020187c:	0000b697          	auipc	a3,0xb
ffffffffc0201880:	3e468693          	addi	a3,a3,996 # ffffffffc020cc60 <etext+0xe4c>
ffffffffc0201884:	0000b617          	auipc	a2,0xb
ffffffffc0201888:	9cc60613          	addi	a2,a2,-1588 # ffffffffc020c250 <etext+0x43c>
ffffffffc020188c:	11100593          	li	a1,273
ffffffffc0201890:	0000b517          	auipc	a0,0xb
ffffffffc0201894:	0f050513          	addi	a0,a0,240 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201898:	bb3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020189c:	0000b697          	auipc	a3,0xb
ffffffffc02018a0:	3a468693          	addi	a3,a3,932 # ffffffffc020cc40 <etext+0xe2c>
ffffffffc02018a4:	0000b617          	auipc	a2,0xb
ffffffffc02018a8:	9ac60613          	addi	a2,a2,-1620 # ffffffffc020c250 <etext+0x43c>
ffffffffc02018ac:	10f00593          	li	a1,271
ffffffffc02018b0:	0000b517          	auipc	a0,0xb
ffffffffc02018b4:	0d050513          	addi	a0,a0,208 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02018b8:	b93fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018bc:	0000b697          	auipc	a3,0xb
ffffffffc02018c0:	35c68693          	addi	a3,a3,860 # ffffffffc020cc18 <etext+0xe04>
ffffffffc02018c4:	0000b617          	auipc	a2,0xb
ffffffffc02018c8:	98c60613          	addi	a2,a2,-1652 # ffffffffc020c250 <etext+0x43c>
ffffffffc02018cc:	10d00593          	li	a1,269
ffffffffc02018d0:	0000b517          	auipc	a0,0xb
ffffffffc02018d4:	0b050513          	addi	a0,a0,176 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02018d8:	b73fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018dc:	0000b697          	auipc	a3,0xb
ffffffffc02018e0:	31468693          	addi	a3,a3,788 # ffffffffc020cbf0 <etext+0xddc>
ffffffffc02018e4:	0000b617          	auipc	a2,0xb
ffffffffc02018e8:	96c60613          	addi	a2,a2,-1684 # ffffffffc020c250 <etext+0x43c>
ffffffffc02018ec:	10c00593          	li	a1,268
ffffffffc02018f0:	0000b517          	auipc	a0,0xb
ffffffffc02018f4:	09050513          	addi	a0,a0,144 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02018f8:	b53fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018fc:	0000b697          	auipc	a3,0xb
ffffffffc0201900:	2e468693          	addi	a3,a3,740 # ffffffffc020cbe0 <etext+0xdcc>
ffffffffc0201904:	0000b617          	auipc	a2,0xb
ffffffffc0201908:	94c60613          	addi	a2,a2,-1716 # ffffffffc020c250 <etext+0x43c>
ffffffffc020190c:	10700593          	li	a1,263
ffffffffc0201910:	0000b517          	auipc	a0,0xb
ffffffffc0201914:	07050513          	addi	a0,a0,112 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201918:	b33fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020191c:	0000b697          	auipc	a3,0xb
ffffffffc0201920:	1c468693          	addi	a3,a3,452 # ffffffffc020cae0 <etext+0xccc>
ffffffffc0201924:	0000b617          	auipc	a2,0xb
ffffffffc0201928:	92c60613          	addi	a2,a2,-1748 # ffffffffc020c250 <etext+0x43c>
ffffffffc020192c:	10600593          	li	a1,262
ffffffffc0201930:	0000b517          	auipc	a0,0xb
ffffffffc0201934:	05050513          	addi	a0,a0,80 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201938:	b13fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020193c:	0000b697          	auipc	a3,0xb
ffffffffc0201940:	28468693          	addi	a3,a3,644 # ffffffffc020cbc0 <etext+0xdac>
ffffffffc0201944:	0000b617          	auipc	a2,0xb
ffffffffc0201948:	90c60613          	addi	a2,a2,-1780 # ffffffffc020c250 <etext+0x43c>
ffffffffc020194c:	10500593          	li	a1,261
ffffffffc0201950:	0000b517          	auipc	a0,0xb
ffffffffc0201954:	03050513          	addi	a0,a0,48 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201958:	af3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020195c:	0000b697          	auipc	a3,0xb
ffffffffc0201960:	23468693          	addi	a3,a3,564 # ffffffffc020cb90 <etext+0xd7c>
ffffffffc0201964:	0000b617          	auipc	a2,0xb
ffffffffc0201968:	8ec60613          	addi	a2,a2,-1812 # ffffffffc020c250 <etext+0x43c>
ffffffffc020196c:	10400593          	li	a1,260
ffffffffc0201970:	0000b517          	auipc	a0,0xb
ffffffffc0201974:	01050513          	addi	a0,a0,16 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201978:	ad3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020197c:	0000b697          	auipc	a3,0xb
ffffffffc0201980:	1fc68693          	addi	a3,a3,508 # ffffffffc020cb78 <etext+0xd64>
ffffffffc0201984:	0000b617          	auipc	a2,0xb
ffffffffc0201988:	8cc60613          	addi	a2,a2,-1844 # ffffffffc020c250 <etext+0x43c>
ffffffffc020198c:	10300593          	li	a1,259
ffffffffc0201990:	0000b517          	auipc	a0,0xb
ffffffffc0201994:	ff050513          	addi	a0,a0,-16 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201998:	ab3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020199c:	0000b697          	auipc	a3,0xb
ffffffffc02019a0:	14468693          	addi	a3,a3,324 # ffffffffc020cae0 <etext+0xccc>
ffffffffc02019a4:	0000b617          	auipc	a2,0xb
ffffffffc02019a8:	8ac60613          	addi	a2,a2,-1876 # ffffffffc020c250 <etext+0x43c>
ffffffffc02019ac:	0fd00593          	li	a1,253
ffffffffc02019b0:	0000b517          	auipc	a0,0xb
ffffffffc02019b4:	fd050513          	addi	a0,a0,-48 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02019b8:	a93fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019bc:	0000b697          	auipc	a3,0xb
ffffffffc02019c0:	1a468693          	addi	a3,a3,420 # ffffffffc020cb60 <etext+0xd4c>
ffffffffc02019c4:	0000b617          	auipc	a2,0xb
ffffffffc02019c8:	88c60613          	addi	a2,a2,-1908 # ffffffffc020c250 <etext+0x43c>
ffffffffc02019cc:	0f800593          	li	a1,248
ffffffffc02019d0:	0000b517          	auipc	a0,0xb
ffffffffc02019d4:	fb050513          	addi	a0,a0,-80 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02019d8:	a73fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019dc:	0000b697          	auipc	a3,0xb
ffffffffc02019e0:	2a468693          	addi	a3,a3,676 # ffffffffc020cc80 <etext+0xe6c>
ffffffffc02019e4:	0000b617          	auipc	a2,0xb
ffffffffc02019e8:	86c60613          	addi	a2,a2,-1940 # ffffffffc020c250 <etext+0x43c>
ffffffffc02019ec:	11600593          	li	a1,278
ffffffffc02019f0:	0000b517          	auipc	a0,0xb
ffffffffc02019f4:	f9050513          	addi	a0,a0,-112 # ffffffffc020c980 <etext+0xb6c>
ffffffffc02019f8:	a53fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019fc:	0000b697          	auipc	a3,0xb
ffffffffc0201a00:	2b468693          	addi	a3,a3,692 # ffffffffc020ccb0 <etext+0xe9c>
ffffffffc0201a04:	0000b617          	auipc	a2,0xb
ffffffffc0201a08:	84c60613          	addi	a2,a2,-1972 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201a0c:	12500593          	li	a1,293
ffffffffc0201a10:	0000b517          	auipc	a0,0xb
ffffffffc0201a14:	f7050513          	addi	a0,a0,-144 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201a18:	a33fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a1c:	0000b697          	auipc	a3,0xb
ffffffffc0201a20:	f7c68693          	addi	a3,a3,-132 # ffffffffc020c998 <etext+0xb84>
ffffffffc0201a24:	0000b617          	auipc	a2,0xb
ffffffffc0201a28:	82c60613          	addi	a2,a2,-2004 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201a2c:	0f200593          	li	a1,242
ffffffffc0201a30:	0000b517          	auipc	a0,0xb
ffffffffc0201a34:	f5050513          	addi	a0,a0,-176 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201a38:	a13fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a3c:	0000b697          	auipc	a3,0xb
ffffffffc0201a40:	f9c68693          	addi	a3,a3,-100 # ffffffffc020c9d8 <etext+0xbc4>
ffffffffc0201a44:	0000b617          	auipc	a2,0xb
ffffffffc0201a48:	80c60613          	addi	a2,a2,-2036 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201a4c:	0b900593          	li	a1,185
ffffffffc0201a50:	0000b517          	auipc	a0,0xb
ffffffffc0201a54:	f3050513          	addi	a0,a0,-208 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201a58:	9f3fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201a5c <default_free_pages>:
ffffffffc0201a5c:	1141                	addi	sp,sp,-16
ffffffffc0201a5e:	e406                	sd	ra,8(sp)
ffffffffc0201a60:	14058663          	beqz	a1,ffffffffc0201bac <default_free_pages+0x150>
ffffffffc0201a64:	00659713          	slli	a4,a1,0x6
ffffffffc0201a68:	00e506b3          	add	a3,a0,a4
ffffffffc0201a6c:	87aa                	mv	a5,a0
ffffffffc0201a6e:	c30d                	beqz	a4,ffffffffc0201a90 <default_free_pages+0x34>
ffffffffc0201a70:	6798                	ld	a4,8(a5)
ffffffffc0201a72:	8b05                	andi	a4,a4,1
ffffffffc0201a74:	10071c63          	bnez	a4,ffffffffc0201b8c <default_free_pages+0x130>
ffffffffc0201a78:	6798                	ld	a4,8(a5)
ffffffffc0201a7a:	8b09                	andi	a4,a4,2
ffffffffc0201a7c:	10071863          	bnez	a4,ffffffffc0201b8c <default_free_pages+0x130>
ffffffffc0201a80:	0007b423          	sd	zero,8(a5)
ffffffffc0201a84:	0007a023          	sw	zero,0(a5)
ffffffffc0201a88:	04078793          	addi	a5,a5,64
ffffffffc0201a8c:	fed792e3          	bne	a5,a3,ffffffffc0201a70 <default_free_pages+0x14>
ffffffffc0201a90:	c90c                	sw	a1,16(a0)
ffffffffc0201a92:	00850893          	addi	a7,a0,8
ffffffffc0201a96:	4789                	li	a5,2
ffffffffc0201a98:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a9c:	00090717          	auipc	a4,0x90
ffffffffc0201aa0:	d1c72703          	lw	a4,-740(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201aa4:	00090697          	auipc	a3,0x90
ffffffffc0201aa8:	d0468693          	addi	a3,a3,-764 # ffffffffc02917a8 <free_area>
ffffffffc0201aac:	669c                	ld	a5,8(a3)
ffffffffc0201aae:	9f2d                	addw	a4,a4,a1
ffffffffc0201ab0:	ca98                	sw	a4,16(a3)
ffffffffc0201ab2:	0ad78163          	beq	a5,a3,ffffffffc0201b54 <default_free_pages+0xf8>
ffffffffc0201ab6:	fe878713          	addi	a4,a5,-24
ffffffffc0201aba:	4581                	li	a1,0
ffffffffc0201abc:	01850613          	addi	a2,a0,24
ffffffffc0201ac0:	00e56a63          	bltu	a0,a4,ffffffffc0201ad4 <default_free_pages+0x78>
ffffffffc0201ac4:	6798                	ld	a4,8(a5)
ffffffffc0201ac6:	04d70c63          	beq	a4,a3,ffffffffc0201b1e <default_free_pages+0xc2>
ffffffffc0201aca:	87ba                	mv	a5,a4
ffffffffc0201acc:	fe878713          	addi	a4,a5,-24
ffffffffc0201ad0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ac4 <default_free_pages+0x68>
ffffffffc0201ad4:	c199                	beqz	a1,ffffffffc0201ada <default_free_pages+0x7e>
ffffffffc0201ad6:	0106b023          	sd	a6,0(a3)
ffffffffc0201ada:	6398                	ld	a4,0(a5)
ffffffffc0201adc:	e390                	sd	a2,0(a5)
ffffffffc0201ade:	e710                	sd	a2,8(a4)
ffffffffc0201ae0:	ed18                	sd	a4,24(a0)
ffffffffc0201ae2:	f11c                	sd	a5,32(a0)
ffffffffc0201ae4:	00d70d63          	beq	a4,a3,ffffffffc0201afe <default_free_pages+0xa2>
ffffffffc0201ae8:	ff872583          	lw	a1,-8(a4)
ffffffffc0201aec:	fe870613          	addi	a2,a4,-24
ffffffffc0201af0:	02059813          	slli	a6,a1,0x20
ffffffffc0201af4:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201af8:	97b2                	add	a5,a5,a2
ffffffffc0201afa:	02f50c63          	beq	a0,a5,ffffffffc0201b32 <default_free_pages+0xd6>
ffffffffc0201afe:	711c                	ld	a5,32(a0)
ffffffffc0201b00:	00d78c63          	beq	a5,a3,ffffffffc0201b18 <default_free_pages+0xbc>
ffffffffc0201b04:	4910                	lw	a2,16(a0)
ffffffffc0201b06:	fe878693          	addi	a3,a5,-24
ffffffffc0201b0a:	02061593          	slli	a1,a2,0x20
ffffffffc0201b0e:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b12:	972a                	add	a4,a4,a0
ffffffffc0201b14:	04e68c63          	beq	a3,a4,ffffffffc0201b6c <default_free_pages+0x110>
ffffffffc0201b18:	60a2                	ld	ra,8(sp)
ffffffffc0201b1a:	0141                	addi	sp,sp,16
ffffffffc0201b1c:	8082                	ret
ffffffffc0201b1e:	e790                	sd	a2,8(a5)
ffffffffc0201b20:	f114                	sd	a3,32(a0)
ffffffffc0201b22:	6798                	ld	a4,8(a5)
ffffffffc0201b24:	ed1c                	sd	a5,24(a0)
ffffffffc0201b26:	8832                	mv	a6,a2
ffffffffc0201b28:	02d70f63          	beq	a4,a3,ffffffffc0201b66 <default_free_pages+0x10a>
ffffffffc0201b2c:	4585                	li	a1,1
ffffffffc0201b2e:	87ba                	mv	a5,a4
ffffffffc0201b30:	bf71                	j	ffffffffc0201acc <default_free_pages+0x70>
ffffffffc0201b32:	491c                	lw	a5,16(a0)
ffffffffc0201b34:	5875                	li	a6,-3
ffffffffc0201b36:	9fad                	addw	a5,a5,a1
ffffffffc0201b38:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201b3c:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201b40:	01853803          	ld	a6,24(a0)
ffffffffc0201b44:	710c                	ld	a1,32(a0)
ffffffffc0201b46:	8532                	mv	a0,a2
ffffffffc0201b48:	00b83423          	sd	a1,8(a6)
ffffffffc0201b4c:	671c                	ld	a5,8(a4)
ffffffffc0201b4e:	0105b023          	sd	a6,0(a1)
ffffffffc0201b52:	b77d                	j	ffffffffc0201b00 <default_free_pages+0xa4>
ffffffffc0201b54:	60a2                	ld	ra,8(sp)
ffffffffc0201b56:	01850713          	addi	a4,a0,24
ffffffffc0201b5a:	f11c                	sd	a5,32(a0)
ffffffffc0201b5c:	ed1c                	sd	a5,24(a0)
ffffffffc0201b5e:	e398                	sd	a4,0(a5)
ffffffffc0201b60:	e798                	sd	a4,8(a5)
ffffffffc0201b62:	0141                	addi	sp,sp,16
ffffffffc0201b64:	8082                	ret
ffffffffc0201b66:	e290                	sd	a2,0(a3)
ffffffffc0201b68:	873e                	mv	a4,a5
ffffffffc0201b6a:	bfad                	j	ffffffffc0201ae4 <default_free_pages+0x88>
ffffffffc0201b6c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b70:	56f5                	li	a3,-3
ffffffffc0201b72:	9f31                	addw	a4,a4,a2
ffffffffc0201b74:	c918                	sw	a4,16(a0)
ffffffffc0201b76:	ff078713          	addi	a4,a5,-16
ffffffffc0201b7a:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc0201b7e:	6398                	ld	a4,0(a5)
ffffffffc0201b80:	679c                	ld	a5,8(a5)
ffffffffc0201b82:	60a2                	ld	ra,8(sp)
ffffffffc0201b84:	e71c                	sd	a5,8(a4)
ffffffffc0201b86:	e398                	sd	a4,0(a5)
ffffffffc0201b88:	0141                	addi	sp,sp,16
ffffffffc0201b8a:	8082                	ret
ffffffffc0201b8c:	0000b697          	auipc	a3,0xb
ffffffffc0201b90:	13c68693          	addi	a3,a3,316 # ffffffffc020ccc8 <etext+0xeb4>
ffffffffc0201b94:	0000a617          	auipc	a2,0xa
ffffffffc0201b98:	6bc60613          	addi	a2,a2,1724 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201b9c:	08200593          	li	a1,130
ffffffffc0201ba0:	0000b517          	auipc	a0,0xb
ffffffffc0201ba4:	de050513          	addi	a0,a0,-544 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201ba8:	8a3fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201bac:	0000b697          	auipc	a3,0xb
ffffffffc0201bb0:	11468693          	addi	a3,a3,276 # ffffffffc020ccc0 <etext+0xeac>
ffffffffc0201bb4:	0000a617          	auipc	a2,0xa
ffffffffc0201bb8:	69c60613          	addi	a2,a2,1692 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201bbc:	07f00593          	li	a1,127
ffffffffc0201bc0:	0000b517          	auipc	a0,0xb
ffffffffc0201bc4:	dc050513          	addi	a0,a0,-576 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201bc8:	883fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201bcc <default_alloc_pages>:
ffffffffc0201bcc:	c951                	beqz	a0,ffffffffc0201c60 <default_alloc_pages+0x94>
ffffffffc0201bce:	00090597          	auipc	a1,0x90
ffffffffc0201bd2:	bea5a583          	lw	a1,-1046(a1) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201bd6:	86aa                	mv	a3,a0
ffffffffc0201bd8:	02059793          	slli	a5,a1,0x20
ffffffffc0201bdc:	9381                	srli	a5,a5,0x20
ffffffffc0201bde:	00a7ef63          	bltu	a5,a0,ffffffffc0201bfc <default_alloc_pages+0x30>
ffffffffc0201be2:	00090617          	auipc	a2,0x90
ffffffffc0201be6:	bc660613          	addi	a2,a2,-1082 # ffffffffc02917a8 <free_area>
ffffffffc0201bea:	87b2                	mv	a5,a2
ffffffffc0201bec:	a029                	j	ffffffffc0201bf6 <default_alloc_pages+0x2a>
ffffffffc0201bee:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201bf2:	00d77763          	bgeu	a4,a3,ffffffffc0201c00 <default_alloc_pages+0x34>
ffffffffc0201bf6:	679c                	ld	a5,8(a5)
ffffffffc0201bf8:	fec79be3          	bne	a5,a2,ffffffffc0201bee <default_alloc_pages+0x22>
ffffffffc0201bfc:	4501                	li	a0,0
ffffffffc0201bfe:	8082                	ret
ffffffffc0201c00:	ff87a883          	lw	a7,-8(a5)
ffffffffc0201c04:	0007b803          	ld	a6,0(a5)
ffffffffc0201c08:	6798                	ld	a4,8(a5)
ffffffffc0201c0a:	02089313          	slli	t1,a7,0x20
ffffffffc0201c0e:	02035313          	srli	t1,t1,0x20
ffffffffc0201c12:	00e83423          	sd	a4,8(a6)
ffffffffc0201c16:	01073023          	sd	a6,0(a4)
ffffffffc0201c1a:	fe878513          	addi	a0,a5,-24
ffffffffc0201c1e:	0266fa63          	bgeu	a3,t1,ffffffffc0201c52 <default_alloc_pages+0x86>
ffffffffc0201c22:	00669713          	slli	a4,a3,0x6
ffffffffc0201c26:	40d888bb          	subw	a7,a7,a3
ffffffffc0201c2a:	972a                	add	a4,a4,a0
ffffffffc0201c2c:	01172823          	sw	a7,16(a4)
ffffffffc0201c30:	00870313          	addi	t1,a4,8
ffffffffc0201c34:	4889                	li	a7,2
ffffffffc0201c36:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc0201c3a:	00883883          	ld	a7,8(a6)
ffffffffc0201c3e:	01870313          	addi	t1,a4,24
ffffffffc0201c42:	0068b023          	sd	t1,0(a7) # 10000000 <_binary_bin_sfs_img_size+0xff8ad00>
ffffffffc0201c46:	00683423          	sd	t1,8(a6)
ffffffffc0201c4a:	03173023          	sd	a7,32(a4)
ffffffffc0201c4e:	01073c23          	sd	a6,24(a4)
ffffffffc0201c52:	9d95                	subw	a1,a1,a3
ffffffffc0201c54:	ca0c                	sw	a1,16(a2)
ffffffffc0201c56:	5775                	li	a4,-3
ffffffffc0201c58:	17c1                	addi	a5,a5,-16
ffffffffc0201c5a:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c5e:	8082                	ret
ffffffffc0201c60:	1141                	addi	sp,sp,-16
ffffffffc0201c62:	0000b697          	auipc	a3,0xb
ffffffffc0201c66:	05e68693          	addi	a3,a3,94 # ffffffffc020ccc0 <etext+0xeac>
ffffffffc0201c6a:	0000a617          	auipc	a2,0xa
ffffffffc0201c6e:	5e660613          	addi	a2,a2,1510 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201c72:	06100593          	li	a1,97
ffffffffc0201c76:	0000b517          	auipc	a0,0xb
ffffffffc0201c7a:	d0a50513          	addi	a0,a0,-758 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201c7e:	e406                	sd	ra,8(sp)
ffffffffc0201c80:	fcafe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201c84 <default_init_memmap>:
ffffffffc0201c84:	1141                	addi	sp,sp,-16
ffffffffc0201c86:	e406                	sd	ra,8(sp)
ffffffffc0201c88:	c9e1                	beqz	a1,ffffffffc0201d58 <default_init_memmap+0xd4>
ffffffffc0201c8a:	00659713          	slli	a4,a1,0x6
ffffffffc0201c8e:	00e506b3          	add	a3,a0,a4
ffffffffc0201c92:	87aa                	mv	a5,a0
ffffffffc0201c94:	cf11                	beqz	a4,ffffffffc0201cb0 <default_init_memmap+0x2c>
ffffffffc0201c96:	6798                	ld	a4,8(a5)
ffffffffc0201c98:	8b05                	andi	a4,a4,1
ffffffffc0201c9a:	cf59                	beqz	a4,ffffffffc0201d38 <default_init_memmap+0xb4>
ffffffffc0201c9c:	0007a823          	sw	zero,16(a5)
ffffffffc0201ca0:	0007b423          	sd	zero,8(a5)
ffffffffc0201ca4:	0007a023          	sw	zero,0(a5)
ffffffffc0201ca8:	04078793          	addi	a5,a5,64
ffffffffc0201cac:	fed795e3          	bne	a5,a3,ffffffffc0201c96 <default_init_memmap+0x12>
ffffffffc0201cb0:	c90c                	sw	a1,16(a0)
ffffffffc0201cb2:	4789                	li	a5,2
ffffffffc0201cb4:	00850713          	addi	a4,a0,8
ffffffffc0201cb8:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201cbc:	00090717          	auipc	a4,0x90
ffffffffc0201cc0:	afc72703          	lw	a4,-1284(a4) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0201cc4:	00090697          	auipc	a3,0x90
ffffffffc0201cc8:	ae468693          	addi	a3,a3,-1308 # ffffffffc02917a8 <free_area>
ffffffffc0201ccc:	669c                	ld	a5,8(a3)
ffffffffc0201cce:	9f2d                	addw	a4,a4,a1
ffffffffc0201cd0:	ca98                	sw	a4,16(a3)
ffffffffc0201cd2:	04d78663          	beq	a5,a3,ffffffffc0201d1e <default_init_memmap+0x9a>
ffffffffc0201cd6:	fe878713          	addi	a4,a5,-24
ffffffffc0201cda:	4581                	li	a1,0
ffffffffc0201cdc:	01850613          	addi	a2,a0,24
ffffffffc0201ce0:	00e56a63          	bltu	a0,a4,ffffffffc0201cf4 <default_init_memmap+0x70>
ffffffffc0201ce4:	6798                	ld	a4,8(a5)
ffffffffc0201ce6:	02d70263          	beq	a4,a3,ffffffffc0201d0a <default_init_memmap+0x86>
ffffffffc0201cea:	87ba                	mv	a5,a4
ffffffffc0201cec:	fe878713          	addi	a4,a5,-24
ffffffffc0201cf0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ce4 <default_init_memmap+0x60>
ffffffffc0201cf4:	c199                	beqz	a1,ffffffffc0201cfa <default_init_memmap+0x76>
ffffffffc0201cf6:	0106b023          	sd	a6,0(a3)
ffffffffc0201cfa:	6398                	ld	a4,0(a5)
ffffffffc0201cfc:	60a2                	ld	ra,8(sp)
ffffffffc0201cfe:	e390                	sd	a2,0(a5)
ffffffffc0201d00:	e710                	sd	a2,8(a4)
ffffffffc0201d02:	ed18                	sd	a4,24(a0)
ffffffffc0201d04:	f11c                	sd	a5,32(a0)
ffffffffc0201d06:	0141                	addi	sp,sp,16
ffffffffc0201d08:	8082                	ret
ffffffffc0201d0a:	e790                	sd	a2,8(a5)
ffffffffc0201d0c:	f114                	sd	a3,32(a0)
ffffffffc0201d0e:	6798                	ld	a4,8(a5)
ffffffffc0201d10:	ed1c                	sd	a5,24(a0)
ffffffffc0201d12:	8832                	mv	a6,a2
ffffffffc0201d14:	00d70e63          	beq	a4,a3,ffffffffc0201d30 <default_init_memmap+0xac>
ffffffffc0201d18:	4585                	li	a1,1
ffffffffc0201d1a:	87ba                	mv	a5,a4
ffffffffc0201d1c:	bfc1                	j	ffffffffc0201cec <default_init_memmap+0x68>
ffffffffc0201d1e:	60a2                	ld	ra,8(sp)
ffffffffc0201d20:	01850713          	addi	a4,a0,24
ffffffffc0201d24:	f11c                	sd	a5,32(a0)
ffffffffc0201d26:	ed1c                	sd	a5,24(a0)
ffffffffc0201d28:	e398                	sd	a4,0(a5)
ffffffffc0201d2a:	e798                	sd	a4,8(a5)
ffffffffc0201d2c:	0141                	addi	sp,sp,16
ffffffffc0201d2e:	8082                	ret
ffffffffc0201d30:	60a2                	ld	ra,8(sp)
ffffffffc0201d32:	e290                	sd	a2,0(a3)
ffffffffc0201d34:	0141                	addi	sp,sp,16
ffffffffc0201d36:	8082                	ret
ffffffffc0201d38:	0000b697          	auipc	a3,0xb
ffffffffc0201d3c:	fb868693          	addi	a3,a3,-72 # ffffffffc020ccf0 <etext+0xedc>
ffffffffc0201d40:	0000a617          	auipc	a2,0xa
ffffffffc0201d44:	51060613          	addi	a2,a2,1296 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201d48:	04800593          	li	a1,72
ffffffffc0201d4c:	0000b517          	auipc	a0,0xb
ffffffffc0201d50:	c3450513          	addi	a0,a0,-972 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201d54:	ef6fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201d58:	0000b697          	auipc	a3,0xb
ffffffffc0201d5c:	f6868693          	addi	a3,a3,-152 # ffffffffc020ccc0 <etext+0xeac>
ffffffffc0201d60:	0000a617          	auipc	a2,0xa
ffffffffc0201d64:	4f060613          	addi	a2,a2,1264 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201d68:	04500593          	li	a1,69
ffffffffc0201d6c:	0000b517          	auipc	a0,0xb
ffffffffc0201d70:	c1450513          	addi	a0,a0,-1004 # ffffffffc020c980 <etext+0xb6c>
ffffffffc0201d74:	ed6fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d78 <slob_free>:
ffffffffc0201d78:	c531                	beqz	a0,ffffffffc0201dc4 <slob_free+0x4c>
ffffffffc0201d7a:	e9b9                	bnez	a1,ffffffffc0201dd0 <slob_free+0x58>
ffffffffc0201d7c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d80:	8b89                	andi	a5,a5,2
ffffffffc0201d82:	4581                	li	a1,0
ffffffffc0201d84:	efb1                	bnez	a5,ffffffffc0201de0 <slob_free+0x68>
ffffffffc0201d86:	0008f797          	auipc	a5,0x8f
ffffffffc0201d8a:	2ca7b783          	ld	a5,714(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201d8e:	873e                	mv	a4,a5
ffffffffc0201d90:	679c                	ld	a5,8(a5)
ffffffffc0201d92:	02a77a63          	bgeu	a4,a0,ffffffffc0201dc6 <slob_free+0x4e>
ffffffffc0201d96:	00f56463          	bltu	a0,a5,ffffffffc0201d9e <slob_free+0x26>
ffffffffc0201d9a:	fef76ae3          	bltu	a4,a5,ffffffffc0201d8e <slob_free+0x16>
ffffffffc0201d9e:	4110                	lw	a2,0(a0)
ffffffffc0201da0:	00461693          	slli	a3,a2,0x4
ffffffffc0201da4:	96aa                	add	a3,a3,a0
ffffffffc0201da6:	0ad78463          	beq	a5,a3,ffffffffc0201e4e <slob_free+0xd6>
ffffffffc0201daa:	4310                	lw	a2,0(a4)
ffffffffc0201dac:	e51c                	sd	a5,8(a0)
ffffffffc0201dae:	00461693          	slli	a3,a2,0x4
ffffffffc0201db2:	96ba                	add	a3,a3,a4
ffffffffc0201db4:	08d50163          	beq	a0,a3,ffffffffc0201e36 <slob_free+0xbe>
ffffffffc0201db8:	e708                	sd	a0,8(a4)
ffffffffc0201dba:	0008f797          	auipc	a5,0x8f
ffffffffc0201dbe:	28e7bb23          	sd	a4,662(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201dc2:	e9a5                	bnez	a1,ffffffffc0201e32 <slob_free+0xba>
ffffffffc0201dc4:	8082                	ret
ffffffffc0201dc6:	fcf574e3          	bgeu	a0,a5,ffffffffc0201d8e <slob_free+0x16>
ffffffffc0201dca:	fcf762e3          	bltu	a4,a5,ffffffffc0201d8e <slob_free+0x16>
ffffffffc0201dce:	bfc1                	j	ffffffffc0201d9e <slob_free+0x26>
ffffffffc0201dd0:	25bd                	addiw	a1,a1,15
ffffffffc0201dd2:	8191                	srli	a1,a1,0x4
ffffffffc0201dd4:	c10c                	sw	a1,0(a0)
ffffffffc0201dd6:	100027f3          	csrr	a5,sstatus
ffffffffc0201dda:	8b89                	andi	a5,a5,2
ffffffffc0201ddc:	4581                	li	a1,0
ffffffffc0201dde:	d7c5                	beqz	a5,ffffffffc0201d86 <slob_free+0xe>
ffffffffc0201de0:	1101                	addi	sp,sp,-32
ffffffffc0201de2:	e42a                	sd	a0,8(sp)
ffffffffc0201de4:	ec06                	sd	ra,24(sp)
ffffffffc0201de6:	df3fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201dea:	6522                	ld	a0,8(sp)
ffffffffc0201dec:	0008f797          	auipc	a5,0x8f
ffffffffc0201df0:	2647b783          	ld	a5,612(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201df4:	4585                	li	a1,1
ffffffffc0201df6:	873e                	mv	a4,a5
ffffffffc0201df8:	679c                	ld	a5,8(a5)
ffffffffc0201dfa:	06a77663          	bgeu	a4,a0,ffffffffc0201e66 <slob_free+0xee>
ffffffffc0201dfe:	00f56463          	bltu	a0,a5,ffffffffc0201e06 <slob_free+0x8e>
ffffffffc0201e02:	fef76ae3          	bltu	a4,a5,ffffffffc0201df6 <slob_free+0x7e>
ffffffffc0201e06:	4110                	lw	a2,0(a0)
ffffffffc0201e08:	00461693          	slli	a3,a2,0x4
ffffffffc0201e0c:	96aa                	add	a3,a3,a0
ffffffffc0201e0e:	06d78363          	beq	a5,a3,ffffffffc0201e74 <slob_free+0xfc>
ffffffffc0201e12:	4310                	lw	a2,0(a4)
ffffffffc0201e14:	e51c                	sd	a5,8(a0)
ffffffffc0201e16:	00461693          	slli	a3,a2,0x4
ffffffffc0201e1a:	96ba                	add	a3,a3,a4
ffffffffc0201e1c:	06d50163          	beq	a0,a3,ffffffffc0201e7e <slob_free+0x106>
ffffffffc0201e20:	e708                	sd	a0,8(a4)
ffffffffc0201e22:	0008f797          	auipc	a5,0x8f
ffffffffc0201e26:	22e7b723          	sd	a4,558(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e2a:	e1a9                	bnez	a1,ffffffffc0201e6c <slob_free+0xf4>
ffffffffc0201e2c:	60e2                	ld	ra,24(sp)
ffffffffc0201e2e:	6105                	addi	sp,sp,32
ffffffffc0201e30:	8082                	ret
ffffffffc0201e32:	da1fe06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0201e36:	4114                	lw	a3,0(a0)
ffffffffc0201e38:	853e                	mv	a0,a5
ffffffffc0201e3a:	e708                	sd	a0,8(a4)
ffffffffc0201e3c:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e40:	c31c                	sw	a5,0(a4)
ffffffffc0201e42:	0008f797          	auipc	a5,0x8f
ffffffffc0201e46:	20e7b723          	sd	a4,526(a5) # ffffffffc0291050 <slobfree>
ffffffffc0201e4a:	ddad                	beqz	a1,ffffffffc0201dc4 <slob_free+0x4c>
ffffffffc0201e4c:	b7dd                	j	ffffffffc0201e32 <slob_free+0xba>
ffffffffc0201e4e:	4394                	lw	a3,0(a5)
ffffffffc0201e50:	679c                	ld	a5,8(a5)
ffffffffc0201e52:	9eb1                	addw	a3,a3,a2
ffffffffc0201e54:	c114                	sw	a3,0(a0)
ffffffffc0201e56:	4310                	lw	a2,0(a4)
ffffffffc0201e58:	e51c                	sd	a5,8(a0)
ffffffffc0201e5a:	00461693          	slli	a3,a2,0x4
ffffffffc0201e5e:	96ba                	add	a3,a3,a4
ffffffffc0201e60:	f4d51ce3          	bne	a0,a3,ffffffffc0201db8 <slob_free+0x40>
ffffffffc0201e64:	bfc9                	j	ffffffffc0201e36 <slob_free+0xbe>
ffffffffc0201e66:	f8f56ee3          	bltu	a0,a5,ffffffffc0201e02 <slob_free+0x8a>
ffffffffc0201e6a:	b771                	j	ffffffffc0201df6 <slob_free+0x7e>
ffffffffc0201e6c:	60e2                	ld	ra,24(sp)
ffffffffc0201e6e:	6105                	addi	sp,sp,32
ffffffffc0201e70:	d63fe06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0201e74:	4394                	lw	a3,0(a5)
ffffffffc0201e76:	679c                	ld	a5,8(a5)
ffffffffc0201e78:	9eb1                	addw	a3,a3,a2
ffffffffc0201e7a:	c114                	sw	a3,0(a0)
ffffffffc0201e7c:	bf59                	j	ffffffffc0201e12 <slob_free+0x9a>
ffffffffc0201e7e:	4114                	lw	a3,0(a0)
ffffffffc0201e80:	853e                	mv	a0,a5
ffffffffc0201e82:	00c687bb          	addw	a5,a3,a2
ffffffffc0201e86:	c31c                	sw	a5,0(a4)
ffffffffc0201e88:	bf61                	j	ffffffffc0201e20 <slob_free+0xa8>

ffffffffc0201e8a <__slob_get_free_pages.constprop.0>:
ffffffffc0201e8a:	4785                	li	a5,1
ffffffffc0201e8c:	1141                	addi	sp,sp,-16
ffffffffc0201e8e:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e92:	e406                	sd	ra,8(sp)
ffffffffc0201e94:	32c000ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0201e98:	c91d                	beqz	a0,ffffffffc0201ece <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e9a:	00095697          	auipc	a3,0x95
ffffffffc0201e9e:	a1e6b683          	ld	a3,-1506(a3) # ffffffffc02968b8 <pages>
ffffffffc0201ea2:	0000e797          	auipc	a5,0xe
ffffffffc0201ea6:	0f67b783          	ld	a5,246(a5) # ffffffffc020ff98 <nbase>
ffffffffc0201eaa:	00095717          	auipc	a4,0x95
ffffffffc0201eae:	a0673703          	ld	a4,-1530(a4) # ffffffffc02968b0 <npage>
ffffffffc0201eb2:	8d15                	sub	a0,a0,a3
ffffffffc0201eb4:	8519                	srai	a0,a0,0x6
ffffffffc0201eb6:	953e                	add	a0,a0,a5
ffffffffc0201eb8:	00c51793          	slli	a5,a0,0xc
ffffffffc0201ebc:	83b1                	srli	a5,a5,0xc
ffffffffc0201ebe:	0532                	slli	a0,a0,0xc
ffffffffc0201ec0:	00e7fa63          	bgeu	a5,a4,ffffffffc0201ed4 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201ec4:	00095797          	auipc	a5,0x95
ffffffffc0201ec8:	9e47b783          	ld	a5,-1564(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0201ecc:	953e                	add	a0,a0,a5
ffffffffc0201ece:	60a2                	ld	ra,8(sp)
ffffffffc0201ed0:	0141                	addi	sp,sp,16
ffffffffc0201ed2:	8082                	ret
ffffffffc0201ed4:	86aa                	mv	a3,a0
ffffffffc0201ed6:	0000b617          	auipc	a2,0xb
ffffffffc0201eda:	e4260613          	addi	a2,a2,-446 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0201ede:	07100593          	li	a1,113
ffffffffc0201ee2:	0000b517          	auipc	a0,0xb
ffffffffc0201ee6:	e5e50513          	addi	a0,a0,-418 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0201eea:	d60fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201eee <slob_alloc.constprop.0>:
ffffffffc0201eee:	7179                	addi	sp,sp,-48
ffffffffc0201ef0:	f406                	sd	ra,40(sp)
ffffffffc0201ef2:	f022                	sd	s0,32(sp)
ffffffffc0201ef4:	ec26                	sd	s1,24(sp)
ffffffffc0201ef6:	01050713          	addi	a4,a0,16
ffffffffc0201efa:	6785                	lui	a5,0x1
ffffffffc0201efc:	0af77e63          	bgeu	a4,a5,ffffffffc0201fb8 <slob_alloc.constprop.0+0xca>
ffffffffc0201f00:	00f50413          	addi	s0,a0,15
ffffffffc0201f04:	8011                	srli	s0,s0,0x4
ffffffffc0201f06:	2401                	sext.w	s0,s0
ffffffffc0201f08:	100025f3          	csrr	a1,sstatus
ffffffffc0201f0c:	8989                	andi	a1,a1,2
ffffffffc0201f0e:	edd1                	bnez	a1,ffffffffc0201faa <slob_alloc.constprop.0+0xbc>
ffffffffc0201f10:	0008f497          	auipc	s1,0x8f
ffffffffc0201f14:	14048493          	addi	s1,s1,320 # ffffffffc0291050 <slobfree>
ffffffffc0201f18:	6090                	ld	a2,0(s1)
ffffffffc0201f1a:	6618                	ld	a4,8(a2)
ffffffffc0201f1c:	4314                	lw	a3,0(a4)
ffffffffc0201f1e:	0886da63          	bge	a3,s0,ffffffffc0201fb2 <slob_alloc.constprop.0+0xc4>
ffffffffc0201f22:	00e60a63          	beq	a2,a4,ffffffffc0201f36 <slob_alloc.constprop.0+0x48>
ffffffffc0201f26:	671c                	ld	a5,8(a4)
ffffffffc0201f28:	4394                	lw	a3,0(a5)
ffffffffc0201f2a:	0286d863          	bge	a3,s0,ffffffffc0201f5a <slob_alloc.constprop.0+0x6c>
ffffffffc0201f2e:	6090                	ld	a2,0(s1)
ffffffffc0201f30:	873e                	mv	a4,a5
ffffffffc0201f32:	fee61ae3          	bne	a2,a4,ffffffffc0201f26 <slob_alloc.constprop.0+0x38>
ffffffffc0201f36:	e9b1                	bnez	a1,ffffffffc0201f8a <slob_alloc.constprop.0+0x9c>
ffffffffc0201f38:	4501                	li	a0,0
ffffffffc0201f3a:	f51ff0ef          	jal	ffffffffc0201e8a <__slob_get_free_pages.constprop.0>
ffffffffc0201f3e:	87aa                	mv	a5,a0
ffffffffc0201f40:	c915                	beqz	a0,ffffffffc0201f74 <slob_alloc.constprop.0+0x86>
ffffffffc0201f42:	6585                	lui	a1,0x1
ffffffffc0201f44:	e35ff0ef          	jal	ffffffffc0201d78 <slob_free>
ffffffffc0201f48:	100025f3          	csrr	a1,sstatus
ffffffffc0201f4c:	8989                	andi	a1,a1,2
ffffffffc0201f4e:	e98d                	bnez	a1,ffffffffc0201f80 <slob_alloc.constprop.0+0x92>
ffffffffc0201f50:	6098                	ld	a4,0(s1)
ffffffffc0201f52:	671c                	ld	a5,8(a4)
ffffffffc0201f54:	4394                	lw	a3,0(a5)
ffffffffc0201f56:	fc86cce3          	blt	a3,s0,ffffffffc0201f2e <slob_alloc.constprop.0+0x40>
ffffffffc0201f5a:	04d40563          	beq	s0,a3,ffffffffc0201fa4 <slob_alloc.constprop.0+0xb6>
ffffffffc0201f5e:	00441613          	slli	a2,s0,0x4
ffffffffc0201f62:	963e                	add	a2,a2,a5
ffffffffc0201f64:	e710                	sd	a2,8(a4)
ffffffffc0201f66:	6788                	ld	a0,8(a5)
ffffffffc0201f68:	9e81                	subw	a3,a3,s0
ffffffffc0201f6a:	c214                	sw	a3,0(a2)
ffffffffc0201f6c:	e608                	sd	a0,8(a2)
ffffffffc0201f6e:	c380                	sw	s0,0(a5)
ffffffffc0201f70:	e098                	sd	a4,0(s1)
ffffffffc0201f72:	ed99                	bnez	a1,ffffffffc0201f90 <slob_alloc.constprop.0+0xa2>
ffffffffc0201f74:	70a2                	ld	ra,40(sp)
ffffffffc0201f76:	7402                	ld	s0,32(sp)
ffffffffc0201f78:	64e2                	ld	s1,24(sp)
ffffffffc0201f7a:	853e                	mv	a0,a5
ffffffffc0201f7c:	6145                	addi	sp,sp,48
ffffffffc0201f7e:	8082                	ret
ffffffffc0201f80:	c59fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201f84:	6098                	ld	a4,0(s1)
ffffffffc0201f86:	4585                	li	a1,1
ffffffffc0201f88:	b7e9                	j	ffffffffc0201f52 <slob_alloc.constprop.0+0x64>
ffffffffc0201f8a:	c49fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0201f8e:	b76d                	j	ffffffffc0201f38 <slob_alloc.constprop.0+0x4a>
ffffffffc0201f90:	e43e                	sd	a5,8(sp)
ffffffffc0201f92:	c41fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0201f96:	67a2                	ld	a5,8(sp)
ffffffffc0201f98:	70a2                	ld	ra,40(sp)
ffffffffc0201f9a:	7402                	ld	s0,32(sp)
ffffffffc0201f9c:	64e2                	ld	s1,24(sp)
ffffffffc0201f9e:	853e                	mv	a0,a5
ffffffffc0201fa0:	6145                	addi	sp,sp,48
ffffffffc0201fa2:	8082                	ret
ffffffffc0201fa4:	6794                	ld	a3,8(a5)
ffffffffc0201fa6:	e714                	sd	a3,8(a4)
ffffffffc0201fa8:	b7e1                	j	ffffffffc0201f70 <slob_alloc.constprop.0+0x82>
ffffffffc0201faa:	c2ffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0201fae:	4585                	li	a1,1
ffffffffc0201fb0:	b785                	j	ffffffffc0201f10 <slob_alloc.constprop.0+0x22>
ffffffffc0201fb2:	87ba                	mv	a5,a4
ffffffffc0201fb4:	8732                	mv	a4,a2
ffffffffc0201fb6:	b755                	j	ffffffffc0201f5a <slob_alloc.constprop.0+0x6c>
ffffffffc0201fb8:	0000b697          	auipc	a3,0xb
ffffffffc0201fbc:	d9868693          	addi	a3,a3,-616 # ffffffffc020cd50 <etext+0xf3c>
ffffffffc0201fc0:	0000a617          	auipc	a2,0xa
ffffffffc0201fc4:	29060613          	addi	a2,a2,656 # ffffffffc020c250 <etext+0x43c>
ffffffffc0201fc8:	06300593          	li	a1,99
ffffffffc0201fcc:	0000b517          	auipc	a0,0xb
ffffffffc0201fd0:	da450513          	addi	a0,a0,-604 # ffffffffc020cd70 <etext+0xf5c>
ffffffffc0201fd4:	c76fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201fd8 <kmalloc_init>:
ffffffffc0201fd8:	1141                	addi	sp,sp,-16
ffffffffc0201fda:	0000b517          	auipc	a0,0xb
ffffffffc0201fde:	dae50513          	addi	a0,a0,-594 # ffffffffc020cd88 <etext+0xf74>
ffffffffc0201fe2:	e406                	sd	ra,8(sp)
ffffffffc0201fe4:	9c2fe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201fe8:	60a2                	ld	ra,8(sp)
ffffffffc0201fea:	0000b517          	auipc	a0,0xb
ffffffffc0201fee:	db650513          	addi	a0,a0,-586 # ffffffffc020cda0 <etext+0xf8c>
ffffffffc0201ff2:	0141                	addi	sp,sp,16
ffffffffc0201ff4:	9b2fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201ff8 <kallocated>:
ffffffffc0201ff8:	4501                	li	a0,0
ffffffffc0201ffa:	8082                	ret

ffffffffc0201ffc <kmalloc>:
ffffffffc0201ffc:	1101                	addi	sp,sp,-32
ffffffffc0201ffe:	6685                	lui	a3,0x1
ffffffffc0202000:	ec06                	sd	ra,24(sp)
ffffffffc0202002:	16bd                	addi	a3,a3,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0202004:	04a6f963          	bgeu	a3,a0,ffffffffc0202056 <kmalloc+0x5a>
ffffffffc0202008:	e42a                	sd	a0,8(sp)
ffffffffc020200a:	4561                	li	a0,24
ffffffffc020200c:	e822                	sd	s0,16(sp)
ffffffffc020200e:	ee1ff0ef          	jal	ffffffffc0201eee <slob_alloc.constprop.0>
ffffffffc0202012:	842a                	mv	s0,a0
ffffffffc0202014:	c541                	beqz	a0,ffffffffc020209c <kmalloc+0xa0>
ffffffffc0202016:	47a2                	lw	a5,8(sp)
ffffffffc0202018:	6705                	lui	a4,0x1
ffffffffc020201a:	4501                	li	a0,0
ffffffffc020201c:	00f75763          	bge	a4,a5,ffffffffc020202a <kmalloc+0x2e>
ffffffffc0202020:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc0202024:	2505                	addiw	a0,a0,1
ffffffffc0202026:	fef74de3          	blt	a4,a5,ffffffffc0202020 <kmalloc+0x24>
ffffffffc020202a:	c008                	sw	a0,0(s0)
ffffffffc020202c:	e5fff0ef          	jal	ffffffffc0201e8a <__slob_get_free_pages.constprop.0>
ffffffffc0202030:	e408                	sd	a0,8(s0)
ffffffffc0202032:	cd31                	beqz	a0,ffffffffc020208e <kmalloc+0x92>
ffffffffc0202034:	100027f3          	csrr	a5,sstatus
ffffffffc0202038:	8b89                	andi	a5,a5,2
ffffffffc020203a:	eb85                	bnez	a5,ffffffffc020206a <kmalloc+0x6e>
ffffffffc020203c:	00095797          	auipc	a5,0x95
ffffffffc0202040:	84c7b783          	ld	a5,-1972(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202044:	00095717          	auipc	a4,0x95
ffffffffc0202048:	84873223          	sd	s0,-1980(a4) # ffffffffc0296888 <bigblocks>
ffffffffc020204c:	e81c                	sd	a5,16(s0)
ffffffffc020204e:	6442                	ld	s0,16(sp)
ffffffffc0202050:	60e2                	ld	ra,24(sp)
ffffffffc0202052:	6105                	addi	sp,sp,32
ffffffffc0202054:	8082                	ret
ffffffffc0202056:	0541                	addi	a0,a0,16
ffffffffc0202058:	e97ff0ef          	jal	ffffffffc0201eee <slob_alloc.constprop.0>
ffffffffc020205c:	87aa                	mv	a5,a0
ffffffffc020205e:	0541                	addi	a0,a0,16
ffffffffc0202060:	fbe5                	bnez	a5,ffffffffc0202050 <kmalloc+0x54>
ffffffffc0202062:	4501                	li	a0,0
ffffffffc0202064:	60e2                	ld	ra,24(sp)
ffffffffc0202066:	6105                	addi	sp,sp,32
ffffffffc0202068:	8082                	ret
ffffffffc020206a:	b6ffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020206e:	00095797          	auipc	a5,0x95
ffffffffc0202072:	81a7b783          	ld	a5,-2022(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202076:	00095717          	auipc	a4,0x95
ffffffffc020207a:	80873923          	sd	s0,-2030(a4) # ffffffffc0296888 <bigblocks>
ffffffffc020207e:	e81c                	sd	a5,16(s0)
ffffffffc0202080:	b53fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202084:	6408                	ld	a0,8(s0)
ffffffffc0202086:	60e2                	ld	ra,24(sp)
ffffffffc0202088:	6442                	ld	s0,16(sp)
ffffffffc020208a:	6105                	addi	sp,sp,32
ffffffffc020208c:	8082                	ret
ffffffffc020208e:	8522                	mv	a0,s0
ffffffffc0202090:	45e1                	li	a1,24
ffffffffc0202092:	ce7ff0ef          	jal	ffffffffc0201d78 <slob_free>
ffffffffc0202096:	4501                	li	a0,0
ffffffffc0202098:	6442                	ld	s0,16(sp)
ffffffffc020209a:	b7e9                	j	ffffffffc0202064 <kmalloc+0x68>
ffffffffc020209c:	6442                	ld	s0,16(sp)
ffffffffc020209e:	4501                	li	a0,0
ffffffffc02020a0:	b7d1                	j	ffffffffc0202064 <kmalloc+0x68>

ffffffffc02020a2 <kfree>:
ffffffffc02020a2:	c579                	beqz	a0,ffffffffc0202170 <kfree+0xce>
ffffffffc02020a4:	03451793          	slli	a5,a0,0x34
ffffffffc02020a8:	e3e1                	bnez	a5,ffffffffc0202168 <kfree+0xc6>
ffffffffc02020aa:	1101                	addi	sp,sp,-32
ffffffffc02020ac:	ec06                	sd	ra,24(sp)
ffffffffc02020ae:	100027f3          	csrr	a5,sstatus
ffffffffc02020b2:	8b89                	andi	a5,a5,2
ffffffffc02020b4:	e7c1                	bnez	a5,ffffffffc020213c <kfree+0x9a>
ffffffffc02020b6:	00094797          	auipc	a5,0x94
ffffffffc02020ba:	7d27b783          	ld	a5,2002(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020be:	4581                	li	a1,0
ffffffffc02020c0:	cbad                	beqz	a5,ffffffffc0202132 <kfree+0x90>
ffffffffc02020c2:	00094617          	auipc	a2,0x94
ffffffffc02020c6:	7c660613          	addi	a2,a2,1990 # ffffffffc0296888 <bigblocks>
ffffffffc02020ca:	a021                	j	ffffffffc02020d2 <kfree+0x30>
ffffffffc02020cc:	01070613          	addi	a2,a4,16
ffffffffc02020d0:	c3a5                	beqz	a5,ffffffffc0202130 <kfree+0x8e>
ffffffffc02020d2:	6794                	ld	a3,8(a5)
ffffffffc02020d4:	873e                	mv	a4,a5
ffffffffc02020d6:	6b9c                	ld	a5,16(a5)
ffffffffc02020d8:	fea69ae3          	bne	a3,a0,ffffffffc02020cc <kfree+0x2a>
ffffffffc02020dc:	e21c                	sd	a5,0(a2)
ffffffffc02020de:	edb5                	bnez	a1,ffffffffc020215a <kfree+0xb8>
ffffffffc02020e0:	c02007b7          	lui	a5,0xc0200
ffffffffc02020e4:	0af56363          	bltu	a0,a5,ffffffffc020218a <kfree+0xe8>
ffffffffc02020e8:	00094797          	auipc	a5,0x94
ffffffffc02020ec:	7c07b783          	ld	a5,1984(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02020f0:	00094697          	auipc	a3,0x94
ffffffffc02020f4:	7c06b683          	ld	a3,1984(a3) # ffffffffc02968b0 <npage>
ffffffffc02020f8:	8d1d                	sub	a0,a0,a5
ffffffffc02020fa:	00c55793          	srli	a5,a0,0xc
ffffffffc02020fe:	06d7fa63          	bgeu	a5,a3,ffffffffc0202172 <kfree+0xd0>
ffffffffc0202102:	0000e617          	auipc	a2,0xe
ffffffffc0202106:	e9663603          	ld	a2,-362(a2) # ffffffffc020ff98 <nbase>
ffffffffc020210a:	00094517          	auipc	a0,0x94
ffffffffc020210e:	7ae53503          	ld	a0,1966(a0) # ffffffffc02968b8 <pages>
ffffffffc0202112:	4314                	lw	a3,0(a4)
ffffffffc0202114:	8f91                	sub	a5,a5,a2
ffffffffc0202116:	079a                	slli	a5,a5,0x6
ffffffffc0202118:	4585                	li	a1,1
ffffffffc020211a:	953e                	add	a0,a0,a5
ffffffffc020211c:	00d595bb          	sllw	a1,a1,a3
ffffffffc0202120:	e03a                	sd	a4,0(sp)
ffffffffc0202122:	0d8000ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc0202126:	6502                	ld	a0,0(sp)
ffffffffc0202128:	60e2                	ld	ra,24(sp)
ffffffffc020212a:	45e1                	li	a1,24
ffffffffc020212c:	6105                	addi	sp,sp,32
ffffffffc020212e:	b1a9                	j	ffffffffc0201d78 <slob_free>
ffffffffc0202130:	e185                	bnez	a1,ffffffffc0202150 <kfree+0xae>
ffffffffc0202132:	60e2                	ld	ra,24(sp)
ffffffffc0202134:	1541                	addi	a0,a0,-16
ffffffffc0202136:	4581                	li	a1,0
ffffffffc0202138:	6105                	addi	sp,sp,32
ffffffffc020213a:	b93d                	j	ffffffffc0201d78 <slob_free>
ffffffffc020213c:	e02a                	sd	a0,0(sp)
ffffffffc020213e:	a9bfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202142:	00094797          	auipc	a5,0x94
ffffffffc0202146:	7467b783          	ld	a5,1862(a5) # ffffffffc0296888 <bigblocks>
ffffffffc020214a:	6502                	ld	a0,0(sp)
ffffffffc020214c:	4585                	li	a1,1
ffffffffc020214e:	fbb5                	bnez	a5,ffffffffc02020c2 <kfree+0x20>
ffffffffc0202150:	e02a                	sd	a0,0(sp)
ffffffffc0202152:	a81fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202156:	6502                	ld	a0,0(sp)
ffffffffc0202158:	bfe9                	j	ffffffffc0202132 <kfree+0x90>
ffffffffc020215a:	e42a                	sd	a0,8(sp)
ffffffffc020215c:	e03a                	sd	a4,0(sp)
ffffffffc020215e:	a75fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202162:	6522                	ld	a0,8(sp)
ffffffffc0202164:	6702                	ld	a4,0(sp)
ffffffffc0202166:	bfad                	j	ffffffffc02020e0 <kfree+0x3e>
ffffffffc0202168:	1541                	addi	a0,a0,-16
ffffffffc020216a:	4581                	li	a1,0
ffffffffc020216c:	c0dff06f          	j	ffffffffc0201d78 <slob_free>
ffffffffc0202170:	8082                	ret
ffffffffc0202172:	0000b617          	auipc	a2,0xb
ffffffffc0202176:	c7660613          	addi	a2,a2,-906 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc020217a:	06900593          	li	a1,105
ffffffffc020217e:	0000b517          	auipc	a0,0xb
ffffffffc0202182:	bc250513          	addi	a0,a0,-1086 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0202186:	ac4fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020218a:	86aa                	mv	a3,a0
ffffffffc020218c:	0000b617          	auipc	a2,0xb
ffffffffc0202190:	c3460613          	addi	a2,a2,-972 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc0202194:	07700593          	li	a1,119
ffffffffc0202198:	0000b517          	auipc	a0,0xb
ffffffffc020219c:	ba850513          	addi	a0,a0,-1112 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02021a0:	aaafe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02021a4 <pa2page.part.0>:
ffffffffc02021a4:	1141                	addi	sp,sp,-16
ffffffffc02021a6:	0000b617          	auipc	a2,0xb
ffffffffc02021aa:	c4260613          	addi	a2,a2,-958 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc02021ae:	06900593          	li	a1,105
ffffffffc02021b2:	0000b517          	auipc	a0,0xb
ffffffffc02021b6:	b8e50513          	addi	a0,a0,-1138 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02021ba:	e406                	sd	ra,8(sp)
ffffffffc02021bc:	a8efe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02021c0 <alloc_pages>:
ffffffffc02021c0:	100027f3          	csrr	a5,sstatus
ffffffffc02021c4:	8b89                	andi	a5,a5,2
ffffffffc02021c6:	e799                	bnez	a5,ffffffffc02021d4 <alloc_pages+0x14>
ffffffffc02021c8:	00094797          	auipc	a5,0x94
ffffffffc02021cc:	6c87b783          	ld	a5,1736(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021d0:	6f9c                	ld	a5,24(a5)
ffffffffc02021d2:	8782                	jr	a5
ffffffffc02021d4:	1101                	addi	sp,sp,-32
ffffffffc02021d6:	ec06                	sd	ra,24(sp)
ffffffffc02021d8:	e42a                	sd	a0,8(sp)
ffffffffc02021da:	9fffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02021de:	00094797          	auipc	a5,0x94
ffffffffc02021e2:	6b27b783          	ld	a5,1714(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02021e6:	6522                	ld	a0,8(sp)
ffffffffc02021e8:	6f9c                	ld	a5,24(a5)
ffffffffc02021ea:	9782                	jalr	a5
ffffffffc02021ec:	e42a                	sd	a0,8(sp)
ffffffffc02021ee:	9e5fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02021f2:	60e2                	ld	ra,24(sp)
ffffffffc02021f4:	6522                	ld	a0,8(sp)
ffffffffc02021f6:	6105                	addi	sp,sp,32
ffffffffc02021f8:	8082                	ret

ffffffffc02021fa <free_pages>:
ffffffffc02021fa:	100027f3          	csrr	a5,sstatus
ffffffffc02021fe:	8b89                	andi	a5,a5,2
ffffffffc0202200:	e799                	bnez	a5,ffffffffc020220e <free_pages+0x14>
ffffffffc0202202:	00094797          	auipc	a5,0x94
ffffffffc0202206:	68e7b783          	ld	a5,1678(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc020220a:	739c                	ld	a5,32(a5)
ffffffffc020220c:	8782                	jr	a5
ffffffffc020220e:	1101                	addi	sp,sp,-32
ffffffffc0202210:	ec06                	sd	ra,24(sp)
ffffffffc0202212:	e42e                	sd	a1,8(sp)
ffffffffc0202214:	e02a                	sd	a0,0(sp)
ffffffffc0202216:	9c3fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020221a:	00094797          	auipc	a5,0x94
ffffffffc020221e:	6767b783          	ld	a5,1654(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202222:	65a2                	ld	a1,8(sp)
ffffffffc0202224:	6502                	ld	a0,0(sp)
ffffffffc0202226:	739c                	ld	a5,32(a5)
ffffffffc0202228:	9782                	jalr	a5
ffffffffc020222a:	60e2                	ld	ra,24(sp)
ffffffffc020222c:	6105                	addi	sp,sp,32
ffffffffc020222e:	9a5fe06f          	j	ffffffffc0200bd2 <intr_enable>

ffffffffc0202232 <nr_free_pages>:
ffffffffc0202232:	100027f3          	csrr	a5,sstatus
ffffffffc0202236:	8b89                	andi	a5,a5,2
ffffffffc0202238:	e799                	bnez	a5,ffffffffc0202246 <nr_free_pages+0x14>
ffffffffc020223a:	00094797          	auipc	a5,0x94
ffffffffc020223e:	6567b783          	ld	a5,1622(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202242:	779c                	ld	a5,40(a5)
ffffffffc0202244:	8782                	jr	a5
ffffffffc0202246:	1101                	addi	sp,sp,-32
ffffffffc0202248:	ec06                	sd	ra,24(sp)
ffffffffc020224a:	98ffe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020224e:	00094797          	auipc	a5,0x94
ffffffffc0202252:	6427b783          	ld	a5,1602(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202256:	779c                	ld	a5,40(a5)
ffffffffc0202258:	9782                	jalr	a5
ffffffffc020225a:	e42a                	sd	a0,8(sp)
ffffffffc020225c:	977fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202260:	60e2                	ld	ra,24(sp)
ffffffffc0202262:	6522                	ld	a0,8(sp)
ffffffffc0202264:	6105                	addi	sp,sp,32
ffffffffc0202266:	8082                	ret

ffffffffc0202268 <get_pte>:
ffffffffc0202268:	01e5d793          	srli	a5,a1,0x1e
ffffffffc020226c:	1ff7f793          	andi	a5,a5,511
ffffffffc0202270:	078e                	slli	a5,a5,0x3
ffffffffc0202272:	00f50733          	add	a4,a0,a5
ffffffffc0202276:	6314                	ld	a3,0(a4)
ffffffffc0202278:	7139                	addi	sp,sp,-64
ffffffffc020227a:	f822                	sd	s0,48(sp)
ffffffffc020227c:	f426                	sd	s1,40(sp)
ffffffffc020227e:	fc06                	sd	ra,56(sp)
ffffffffc0202280:	0016f793          	andi	a5,a3,1
ffffffffc0202284:	842e                	mv	s0,a1
ffffffffc0202286:	8832                	mv	a6,a2
ffffffffc0202288:	00094497          	auipc	s1,0x94
ffffffffc020228c:	62848493          	addi	s1,s1,1576 # ffffffffc02968b0 <npage>
ffffffffc0202290:	ebd1                	bnez	a5,ffffffffc0202324 <get_pte+0xbc>
ffffffffc0202292:	16060d63          	beqz	a2,ffffffffc020240c <get_pte+0x1a4>
ffffffffc0202296:	100027f3          	csrr	a5,sstatus
ffffffffc020229a:	8b89                	andi	a5,a5,2
ffffffffc020229c:	16079e63          	bnez	a5,ffffffffc0202418 <get_pte+0x1b0>
ffffffffc02022a0:	00094797          	auipc	a5,0x94
ffffffffc02022a4:	5f07b783          	ld	a5,1520(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02022a8:	4505                	li	a0,1
ffffffffc02022aa:	e43a                	sd	a4,8(sp)
ffffffffc02022ac:	6f9c                	ld	a5,24(a5)
ffffffffc02022ae:	e832                	sd	a2,16(sp)
ffffffffc02022b0:	9782                	jalr	a5
ffffffffc02022b2:	6722                	ld	a4,8(sp)
ffffffffc02022b4:	6842                	ld	a6,16(sp)
ffffffffc02022b6:	87aa                	mv	a5,a0
ffffffffc02022b8:	14078a63          	beqz	a5,ffffffffc020240c <get_pte+0x1a4>
ffffffffc02022bc:	00094517          	auipc	a0,0x94
ffffffffc02022c0:	5fc53503          	ld	a0,1532(a0) # ffffffffc02968b8 <pages>
ffffffffc02022c4:	000808b7          	lui	a7,0x80
ffffffffc02022c8:	00094497          	auipc	s1,0x94
ffffffffc02022cc:	5e848493          	addi	s1,s1,1512 # ffffffffc02968b0 <npage>
ffffffffc02022d0:	40a78533          	sub	a0,a5,a0
ffffffffc02022d4:	8519                	srai	a0,a0,0x6
ffffffffc02022d6:	9546                	add	a0,a0,a7
ffffffffc02022d8:	6090                	ld	a2,0(s1)
ffffffffc02022da:	00c51693          	slli	a3,a0,0xc
ffffffffc02022de:	4585                	li	a1,1
ffffffffc02022e0:	82b1                	srli	a3,a3,0xc
ffffffffc02022e2:	c38c                	sw	a1,0(a5)
ffffffffc02022e4:	0532                	slli	a0,a0,0xc
ffffffffc02022e6:	1ac6f763          	bgeu	a3,a2,ffffffffc0202494 <get_pte+0x22c>
ffffffffc02022ea:	00094697          	auipc	a3,0x94
ffffffffc02022ee:	5be6b683          	ld	a3,1470(a3) # ffffffffc02968a8 <va_pa_offset>
ffffffffc02022f2:	6605                	lui	a2,0x1
ffffffffc02022f4:	4581                	li	a1,0
ffffffffc02022f6:	9536                	add	a0,a0,a3
ffffffffc02022f8:	ec42                	sd	a6,24(sp)
ffffffffc02022fa:	e83e                	sd	a5,16(sp)
ffffffffc02022fc:	e43a                	sd	a4,8(sp)
ffffffffc02022fe:	2af090ef          	jal	ffffffffc020bdac <memset>
ffffffffc0202302:	00094697          	auipc	a3,0x94
ffffffffc0202306:	5b66b683          	ld	a3,1462(a3) # ffffffffc02968b8 <pages>
ffffffffc020230a:	67c2                	ld	a5,16(sp)
ffffffffc020230c:	000808b7          	lui	a7,0x80
ffffffffc0202310:	6722                	ld	a4,8(sp)
ffffffffc0202312:	40d786b3          	sub	a3,a5,a3
ffffffffc0202316:	8699                	srai	a3,a3,0x6
ffffffffc0202318:	96c6                	add	a3,a3,a7
ffffffffc020231a:	06aa                	slli	a3,a3,0xa
ffffffffc020231c:	6862                	ld	a6,24(sp)
ffffffffc020231e:	0116e693          	ori	a3,a3,17
ffffffffc0202322:	e314                	sd	a3,0(a4)
ffffffffc0202324:	c006f693          	andi	a3,a3,-1024
ffffffffc0202328:	6098                	ld	a4,0(s1)
ffffffffc020232a:	068a                	slli	a3,a3,0x2
ffffffffc020232c:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202330:	14e7f663          	bgeu	a5,a4,ffffffffc020247c <get_pte+0x214>
ffffffffc0202334:	00094897          	auipc	a7,0x94
ffffffffc0202338:	57488893          	addi	a7,a7,1396 # ffffffffc02968a8 <va_pa_offset>
ffffffffc020233c:	0008b603          	ld	a2,0(a7)
ffffffffc0202340:	01545793          	srli	a5,s0,0x15
ffffffffc0202344:	1ff7f793          	andi	a5,a5,511
ffffffffc0202348:	96b2                	add	a3,a3,a2
ffffffffc020234a:	078e                	slli	a5,a5,0x3
ffffffffc020234c:	97b6                	add	a5,a5,a3
ffffffffc020234e:	6394                	ld	a3,0(a5)
ffffffffc0202350:	0016f613          	andi	a2,a3,1
ffffffffc0202354:	e659                	bnez	a2,ffffffffc02023e2 <get_pte+0x17a>
ffffffffc0202356:	0a080b63          	beqz	a6,ffffffffc020240c <get_pte+0x1a4>
ffffffffc020235a:	10002773          	csrr	a4,sstatus
ffffffffc020235e:	8b09                	andi	a4,a4,2
ffffffffc0202360:	ef71                	bnez	a4,ffffffffc020243c <get_pte+0x1d4>
ffffffffc0202362:	00094717          	auipc	a4,0x94
ffffffffc0202366:	52e73703          	ld	a4,1326(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020236a:	4505                	li	a0,1
ffffffffc020236c:	e43e                	sd	a5,8(sp)
ffffffffc020236e:	6f18                	ld	a4,24(a4)
ffffffffc0202370:	9702                	jalr	a4
ffffffffc0202372:	67a2                	ld	a5,8(sp)
ffffffffc0202374:	872a                	mv	a4,a0
ffffffffc0202376:	00094897          	auipc	a7,0x94
ffffffffc020237a:	53288893          	addi	a7,a7,1330 # ffffffffc02968a8 <va_pa_offset>
ffffffffc020237e:	c759                	beqz	a4,ffffffffc020240c <get_pte+0x1a4>
ffffffffc0202380:	00094697          	auipc	a3,0x94
ffffffffc0202384:	5386b683          	ld	a3,1336(a3) # ffffffffc02968b8 <pages>
ffffffffc0202388:	00080837          	lui	a6,0x80
ffffffffc020238c:	608c                	ld	a1,0(s1)
ffffffffc020238e:	40d706b3          	sub	a3,a4,a3
ffffffffc0202392:	8699                	srai	a3,a3,0x6
ffffffffc0202394:	96c2                	add	a3,a3,a6
ffffffffc0202396:	00c69613          	slli	a2,a3,0xc
ffffffffc020239a:	4505                	li	a0,1
ffffffffc020239c:	8231                	srli	a2,a2,0xc
ffffffffc020239e:	c308                	sw	a0,0(a4)
ffffffffc02023a0:	06b2                	slli	a3,a3,0xc
ffffffffc02023a2:	10b67663          	bgeu	a2,a1,ffffffffc02024ae <get_pte+0x246>
ffffffffc02023a6:	0008b503          	ld	a0,0(a7)
ffffffffc02023aa:	6605                	lui	a2,0x1
ffffffffc02023ac:	4581                	li	a1,0
ffffffffc02023ae:	9536                	add	a0,a0,a3
ffffffffc02023b0:	e83a                	sd	a4,16(sp)
ffffffffc02023b2:	e43e                	sd	a5,8(sp)
ffffffffc02023b4:	1f9090ef          	jal	ffffffffc020bdac <memset>
ffffffffc02023b8:	00094697          	auipc	a3,0x94
ffffffffc02023bc:	5006b683          	ld	a3,1280(a3) # ffffffffc02968b8 <pages>
ffffffffc02023c0:	6742                	ld	a4,16(sp)
ffffffffc02023c2:	00080837          	lui	a6,0x80
ffffffffc02023c6:	67a2                	ld	a5,8(sp)
ffffffffc02023c8:	40d706b3          	sub	a3,a4,a3
ffffffffc02023cc:	8699                	srai	a3,a3,0x6
ffffffffc02023ce:	96c2                	add	a3,a3,a6
ffffffffc02023d0:	06aa                	slli	a3,a3,0xa
ffffffffc02023d2:	0116e693          	ori	a3,a3,17
ffffffffc02023d6:	e394                	sd	a3,0(a5)
ffffffffc02023d8:	6098                	ld	a4,0(s1)
ffffffffc02023da:	00094897          	auipc	a7,0x94
ffffffffc02023de:	4ce88893          	addi	a7,a7,1230 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02023e2:	c006f693          	andi	a3,a3,-1024
ffffffffc02023e6:	068a                	slli	a3,a3,0x2
ffffffffc02023e8:	00c6d793          	srli	a5,a3,0xc
ffffffffc02023ec:	06e7fc63          	bgeu	a5,a4,ffffffffc0202464 <get_pte+0x1fc>
ffffffffc02023f0:	0008b783          	ld	a5,0(a7)
ffffffffc02023f4:	8031                	srli	s0,s0,0xc
ffffffffc02023f6:	1ff47413          	andi	s0,s0,511
ffffffffc02023fa:	040e                	slli	s0,s0,0x3
ffffffffc02023fc:	96be                	add	a3,a3,a5
ffffffffc02023fe:	70e2                	ld	ra,56(sp)
ffffffffc0202400:	00868533          	add	a0,a3,s0
ffffffffc0202404:	7442                	ld	s0,48(sp)
ffffffffc0202406:	74a2                	ld	s1,40(sp)
ffffffffc0202408:	6121                	addi	sp,sp,64
ffffffffc020240a:	8082                	ret
ffffffffc020240c:	70e2                	ld	ra,56(sp)
ffffffffc020240e:	7442                	ld	s0,48(sp)
ffffffffc0202410:	74a2                	ld	s1,40(sp)
ffffffffc0202412:	4501                	li	a0,0
ffffffffc0202414:	6121                	addi	sp,sp,64
ffffffffc0202416:	8082                	ret
ffffffffc0202418:	e83a                	sd	a4,16(sp)
ffffffffc020241a:	ec32                	sd	a2,24(sp)
ffffffffc020241c:	fbcfe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202420:	00094797          	auipc	a5,0x94
ffffffffc0202424:	4707b783          	ld	a5,1136(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202428:	4505                	li	a0,1
ffffffffc020242a:	6f9c                	ld	a5,24(a5)
ffffffffc020242c:	9782                	jalr	a5
ffffffffc020242e:	e42a                	sd	a0,8(sp)
ffffffffc0202430:	fa2fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202434:	6862                	ld	a6,24(sp)
ffffffffc0202436:	6742                	ld	a4,16(sp)
ffffffffc0202438:	67a2                	ld	a5,8(sp)
ffffffffc020243a:	bdbd                	j	ffffffffc02022b8 <get_pte+0x50>
ffffffffc020243c:	e83e                	sd	a5,16(sp)
ffffffffc020243e:	f9afe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202442:	00094717          	auipc	a4,0x94
ffffffffc0202446:	44e73703          	ld	a4,1102(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc020244a:	4505                	li	a0,1
ffffffffc020244c:	6f18                	ld	a4,24(a4)
ffffffffc020244e:	9702                	jalr	a4
ffffffffc0202450:	e42a                	sd	a0,8(sp)
ffffffffc0202452:	f80fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202456:	6722                	ld	a4,8(sp)
ffffffffc0202458:	67c2                	ld	a5,16(sp)
ffffffffc020245a:	00094897          	auipc	a7,0x94
ffffffffc020245e:	44e88893          	addi	a7,a7,1102 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202462:	bf31                	j	ffffffffc020237e <get_pte+0x116>
ffffffffc0202464:	0000b617          	auipc	a2,0xb
ffffffffc0202468:	8b460613          	addi	a2,a2,-1868 # ffffffffc020cd18 <etext+0xf04>
ffffffffc020246c:	13200593          	li	a1,306
ffffffffc0202470:	0000b517          	auipc	a0,0xb
ffffffffc0202474:	99850513          	addi	a0,a0,-1640 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0202478:	fd3fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020247c:	0000b617          	auipc	a2,0xb
ffffffffc0202480:	89c60613          	addi	a2,a2,-1892 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0202484:	12500593          	li	a1,293
ffffffffc0202488:	0000b517          	auipc	a0,0xb
ffffffffc020248c:	98050513          	addi	a0,a0,-1664 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0202490:	fbbfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202494:	86aa                	mv	a3,a0
ffffffffc0202496:	0000b617          	auipc	a2,0xb
ffffffffc020249a:	88260613          	addi	a2,a2,-1918 # ffffffffc020cd18 <etext+0xf04>
ffffffffc020249e:	12100593          	li	a1,289
ffffffffc02024a2:	0000b517          	auipc	a0,0xb
ffffffffc02024a6:	96650513          	addi	a0,a0,-1690 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02024aa:	fa1fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02024ae:	0000b617          	auipc	a2,0xb
ffffffffc02024b2:	86a60613          	addi	a2,a2,-1942 # ffffffffc020cd18 <etext+0xf04>
ffffffffc02024b6:	12f00593          	li	a1,303
ffffffffc02024ba:	0000b517          	auipc	a0,0xb
ffffffffc02024be:	94e50513          	addi	a0,a0,-1714 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02024c2:	f89fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02024c6 <boot_map_segment>:
ffffffffc02024c6:	7139                	addi	sp,sp,-64
ffffffffc02024c8:	f04a                	sd	s2,32(sp)
ffffffffc02024ca:	6905                	lui	s2,0x1
ffffffffc02024cc:	00d5c833          	xor	a6,a1,a3
ffffffffc02024d0:	fff90793          	addi	a5,s2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02024d4:	fc06                	sd	ra,56(sp)
ffffffffc02024d6:	00f87833          	and	a6,a6,a5
ffffffffc02024da:	08081563          	bnez	a6,ffffffffc0202564 <boot_map_segment+0x9e>
ffffffffc02024de:	f426                	sd	s1,40(sp)
ffffffffc02024e0:	963e                	add	a2,a2,a5
ffffffffc02024e2:	00f5f4b3          	and	s1,a1,a5
ffffffffc02024e6:	94b2                	add	s1,s1,a2
ffffffffc02024e8:	80b1                	srli	s1,s1,0xc
ffffffffc02024ea:	c8a1                	beqz	s1,ffffffffc020253a <boot_map_segment+0x74>
ffffffffc02024ec:	77fd                	lui	a5,0xfffff
ffffffffc02024ee:	00176713          	ori	a4,a4,1
ffffffffc02024f2:	f822                	sd	s0,48(sp)
ffffffffc02024f4:	e852                	sd	s4,16(sp)
ffffffffc02024f6:	8efd                	and	a3,a3,a5
ffffffffc02024f8:	02071a13          	slli	s4,a4,0x20
ffffffffc02024fc:	00f5f433          	and	s0,a1,a5
ffffffffc0202500:	ec4e                	sd	s3,24(sp)
ffffffffc0202502:	e456                	sd	s5,8(sp)
ffffffffc0202504:	89aa                	mv	s3,a0
ffffffffc0202506:	020a5a13          	srli	s4,s4,0x20
ffffffffc020250a:	40868ab3          	sub	s5,a3,s0
ffffffffc020250e:	4605                	li	a2,1
ffffffffc0202510:	85a2                	mv	a1,s0
ffffffffc0202512:	854e                	mv	a0,s3
ffffffffc0202514:	d55ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202518:	c515                	beqz	a0,ffffffffc0202544 <boot_map_segment+0x7e>
ffffffffc020251a:	008a87b3          	add	a5,s5,s0
ffffffffc020251e:	83b1                	srli	a5,a5,0xc
ffffffffc0202520:	07aa                	slli	a5,a5,0xa
ffffffffc0202522:	0147e7b3          	or	a5,a5,s4
ffffffffc0202526:	0017e793          	ori	a5,a5,1
ffffffffc020252a:	14fd                	addi	s1,s1,-1
ffffffffc020252c:	e11c                	sd	a5,0(a0)
ffffffffc020252e:	944a                	add	s0,s0,s2
ffffffffc0202530:	fcf9                	bnez	s1,ffffffffc020250e <boot_map_segment+0x48>
ffffffffc0202532:	7442                	ld	s0,48(sp)
ffffffffc0202534:	69e2                	ld	s3,24(sp)
ffffffffc0202536:	6a42                	ld	s4,16(sp)
ffffffffc0202538:	6aa2                	ld	s5,8(sp)
ffffffffc020253a:	70e2                	ld	ra,56(sp)
ffffffffc020253c:	74a2                	ld	s1,40(sp)
ffffffffc020253e:	7902                	ld	s2,32(sp)
ffffffffc0202540:	6121                	addi	sp,sp,64
ffffffffc0202542:	8082                	ret
ffffffffc0202544:	0000b697          	auipc	a3,0xb
ffffffffc0202548:	8ec68693          	addi	a3,a3,-1812 # ffffffffc020ce30 <etext+0x101c>
ffffffffc020254c:	0000a617          	auipc	a2,0xa
ffffffffc0202550:	d0460613          	addi	a2,a2,-764 # ffffffffc020c250 <etext+0x43c>
ffffffffc0202554:	09c00593          	li	a1,156
ffffffffc0202558:	0000b517          	auipc	a0,0xb
ffffffffc020255c:	8b050513          	addi	a0,a0,-1872 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0202560:	eebfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202564:	0000b697          	auipc	a3,0xb
ffffffffc0202568:	8b468693          	addi	a3,a3,-1868 # ffffffffc020ce18 <etext+0x1004>
ffffffffc020256c:	0000a617          	auipc	a2,0xa
ffffffffc0202570:	ce460613          	addi	a2,a2,-796 # ffffffffc020c250 <etext+0x43c>
ffffffffc0202574:	09500593          	li	a1,149
ffffffffc0202578:	0000b517          	auipc	a0,0xb
ffffffffc020257c:	89050513          	addi	a0,a0,-1904 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0202580:	f822                	sd	s0,48(sp)
ffffffffc0202582:	f426                	sd	s1,40(sp)
ffffffffc0202584:	ec4e                	sd	s3,24(sp)
ffffffffc0202586:	e852                	sd	s4,16(sp)
ffffffffc0202588:	e456                	sd	s5,8(sp)
ffffffffc020258a:	ec1fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020258e <get_page>:
ffffffffc020258e:	1141                	addi	sp,sp,-16
ffffffffc0202590:	e022                	sd	s0,0(sp)
ffffffffc0202592:	8432                	mv	s0,a2
ffffffffc0202594:	4601                	li	a2,0
ffffffffc0202596:	e406                	sd	ra,8(sp)
ffffffffc0202598:	cd1ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc020259c:	c011                	beqz	s0,ffffffffc02025a0 <get_page+0x12>
ffffffffc020259e:	e008                	sd	a0,0(s0)
ffffffffc02025a0:	c511                	beqz	a0,ffffffffc02025ac <get_page+0x1e>
ffffffffc02025a2:	611c                	ld	a5,0(a0)
ffffffffc02025a4:	4501                	li	a0,0
ffffffffc02025a6:	0017f713          	andi	a4,a5,1
ffffffffc02025aa:	e709                	bnez	a4,ffffffffc02025b4 <get_page+0x26>
ffffffffc02025ac:	60a2                	ld	ra,8(sp)
ffffffffc02025ae:	6402                	ld	s0,0(sp)
ffffffffc02025b0:	0141                	addi	sp,sp,16
ffffffffc02025b2:	8082                	ret
ffffffffc02025b4:	00094717          	auipc	a4,0x94
ffffffffc02025b8:	2fc73703          	ld	a4,764(a4) # ffffffffc02968b0 <npage>
ffffffffc02025bc:	078a                	slli	a5,a5,0x2
ffffffffc02025be:	83b1                	srli	a5,a5,0xc
ffffffffc02025c0:	00e7ff63          	bgeu	a5,a4,ffffffffc02025de <get_page+0x50>
ffffffffc02025c4:	00094517          	auipc	a0,0x94
ffffffffc02025c8:	2f453503          	ld	a0,756(a0) # ffffffffc02968b8 <pages>
ffffffffc02025cc:	60a2                	ld	ra,8(sp)
ffffffffc02025ce:	6402                	ld	s0,0(sp)
ffffffffc02025d0:	079a                	slli	a5,a5,0x6
ffffffffc02025d2:	fe000737          	lui	a4,0xfe000
ffffffffc02025d6:	97ba                	add	a5,a5,a4
ffffffffc02025d8:	953e                	add	a0,a0,a5
ffffffffc02025da:	0141                	addi	sp,sp,16
ffffffffc02025dc:	8082                	ret
ffffffffc02025de:	bc7ff0ef          	jal	ffffffffc02021a4 <pa2page.part.0>

ffffffffc02025e2 <unmap_range>:
ffffffffc02025e2:	715d                	addi	sp,sp,-80
ffffffffc02025e4:	00c5e7b3          	or	a5,a1,a2
ffffffffc02025e8:	e486                	sd	ra,72(sp)
ffffffffc02025ea:	e0a2                	sd	s0,64(sp)
ffffffffc02025ec:	fc26                	sd	s1,56(sp)
ffffffffc02025ee:	f84a                	sd	s2,48(sp)
ffffffffc02025f0:	f44e                	sd	s3,40(sp)
ffffffffc02025f2:	f052                	sd	s4,32(sp)
ffffffffc02025f4:	ec56                	sd	s5,24(sp)
ffffffffc02025f6:	03479713          	slli	a4,a5,0x34
ffffffffc02025fa:	ef61                	bnez	a4,ffffffffc02026d2 <unmap_range+0xf0>
ffffffffc02025fc:	00200a37          	lui	s4,0x200
ffffffffc0202600:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202604:	0145b733          	sltu	a4,a1,s4
ffffffffc0202608:	0017b793          	seqz	a5,a5
ffffffffc020260c:	8fd9                	or	a5,a5,a4
ffffffffc020260e:	842e                	mv	s0,a1
ffffffffc0202610:	84b2                	mv	s1,a2
ffffffffc0202612:	e3e5                	bnez	a5,ffffffffc02026f2 <unmap_range+0x110>
ffffffffc0202614:	4785                	li	a5,1
ffffffffc0202616:	07fe                	slli	a5,a5,0x1f
ffffffffc0202618:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc020261a:	892a                	mv	s2,a0
ffffffffc020261c:	6985                	lui	s3,0x1
ffffffffc020261e:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0202622:	0cf67863          	bgeu	a2,a5,ffffffffc02026f2 <unmap_range+0x110>
ffffffffc0202626:	4601                	li	a2,0
ffffffffc0202628:	85a2                	mv	a1,s0
ffffffffc020262a:	854a                	mv	a0,s2
ffffffffc020262c:	c3dff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202630:	87aa                	mv	a5,a0
ffffffffc0202632:	cd31                	beqz	a0,ffffffffc020268e <unmap_range+0xac>
ffffffffc0202634:	6118                	ld	a4,0(a0)
ffffffffc0202636:	ef11                	bnez	a4,ffffffffc0202652 <unmap_range+0x70>
ffffffffc0202638:	944e                	add	s0,s0,s3
ffffffffc020263a:	c019                	beqz	s0,ffffffffc0202640 <unmap_range+0x5e>
ffffffffc020263c:	fe9465e3          	bltu	s0,s1,ffffffffc0202626 <unmap_range+0x44>
ffffffffc0202640:	60a6                	ld	ra,72(sp)
ffffffffc0202642:	6406                	ld	s0,64(sp)
ffffffffc0202644:	74e2                	ld	s1,56(sp)
ffffffffc0202646:	7942                	ld	s2,48(sp)
ffffffffc0202648:	79a2                	ld	s3,40(sp)
ffffffffc020264a:	7a02                	ld	s4,32(sp)
ffffffffc020264c:	6ae2                	ld	s5,24(sp)
ffffffffc020264e:	6161                	addi	sp,sp,80
ffffffffc0202650:	8082                	ret
ffffffffc0202652:	00177693          	andi	a3,a4,1
ffffffffc0202656:	d2ed                	beqz	a3,ffffffffc0202638 <unmap_range+0x56>
ffffffffc0202658:	00094697          	auipc	a3,0x94
ffffffffc020265c:	2586b683          	ld	a3,600(a3) # ffffffffc02968b0 <npage>
ffffffffc0202660:	070a                	slli	a4,a4,0x2
ffffffffc0202662:	8331                	srli	a4,a4,0xc
ffffffffc0202664:	0ad77763          	bgeu	a4,a3,ffffffffc0202712 <unmap_range+0x130>
ffffffffc0202668:	00094517          	auipc	a0,0x94
ffffffffc020266c:	25053503          	ld	a0,592(a0) # ffffffffc02968b8 <pages>
ffffffffc0202670:	071a                	slli	a4,a4,0x6
ffffffffc0202672:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202676:	9736                	add	a4,a4,a3
ffffffffc0202678:	953a                	add	a0,a0,a4
ffffffffc020267a:	4118                	lw	a4,0(a0)
ffffffffc020267c:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd696ef>
ffffffffc020267e:	c118                	sw	a4,0(a0)
ffffffffc0202680:	cb19                	beqz	a4,ffffffffc0202696 <unmap_range+0xb4>
ffffffffc0202682:	0007b023          	sd	zero,0(a5)
ffffffffc0202686:	12040073          	sfence.vma	s0
ffffffffc020268a:	944e                	add	s0,s0,s3
ffffffffc020268c:	b77d                	j	ffffffffc020263a <unmap_range+0x58>
ffffffffc020268e:	9452                	add	s0,s0,s4
ffffffffc0202690:	01547433          	and	s0,s0,s5
ffffffffc0202694:	b75d                	j	ffffffffc020263a <unmap_range+0x58>
ffffffffc0202696:	10002773          	csrr	a4,sstatus
ffffffffc020269a:	8b09                	andi	a4,a4,2
ffffffffc020269c:	eb19                	bnez	a4,ffffffffc02026b2 <unmap_range+0xd0>
ffffffffc020269e:	00094717          	auipc	a4,0x94
ffffffffc02026a2:	1f273703          	ld	a4,498(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02026a6:	4585                	li	a1,1
ffffffffc02026a8:	e03e                	sd	a5,0(sp)
ffffffffc02026aa:	7318                	ld	a4,32(a4)
ffffffffc02026ac:	9702                	jalr	a4
ffffffffc02026ae:	6782                	ld	a5,0(sp)
ffffffffc02026b0:	bfc9                	j	ffffffffc0202682 <unmap_range+0xa0>
ffffffffc02026b2:	e43e                	sd	a5,8(sp)
ffffffffc02026b4:	e02a                	sd	a0,0(sp)
ffffffffc02026b6:	d22fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02026ba:	00094717          	auipc	a4,0x94
ffffffffc02026be:	1d673703          	ld	a4,470(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc02026c2:	6502                	ld	a0,0(sp)
ffffffffc02026c4:	4585                	li	a1,1
ffffffffc02026c6:	7318                	ld	a4,32(a4)
ffffffffc02026c8:	9702                	jalr	a4
ffffffffc02026ca:	d08fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02026ce:	67a2                	ld	a5,8(sp)
ffffffffc02026d0:	bf4d                	j	ffffffffc0202682 <unmap_range+0xa0>
ffffffffc02026d2:	0000a697          	auipc	a3,0xa
ffffffffc02026d6:	76e68693          	addi	a3,a3,1902 # ffffffffc020ce40 <etext+0x102c>
ffffffffc02026da:	0000a617          	auipc	a2,0xa
ffffffffc02026de:	b7660613          	addi	a2,a2,-1162 # ffffffffc020c250 <etext+0x43c>
ffffffffc02026e2:	15a00593          	li	a1,346
ffffffffc02026e6:	0000a517          	auipc	a0,0xa
ffffffffc02026ea:	72250513          	addi	a0,a0,1826 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02026ee:	d5dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02026f2:	0000a697          	auipc	a3,0xa
ffffffffc02026f6:	77e68693          	addi	a3,a3,1918 # ffffffffc020ce70 <etext+0x105c>
ffffffffc02026fa:	0000a617          	auipc	a2,0xa
ffffffffc02026fe:	b5660613          	addi	a2,a2,-1194 # ffffffffc020c250 <etext+0x43c>
ffffffffc0202702:	15b00593          	li	a1,347
ffffffffc0202706:	0000a517          	auipc	a0,0xa
ffffffffc020270a:	70250513          	addi	a0,a0,1794 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020270e:	d3dfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202712:	a93ff0ef          	jal	ffffffffc02021a4 <pa2page.part.0>

ffffffffc0202716 <exit_range>:
ffffffffc0202716:	7135                	addi	sp,sp,-160
ffffffffc0202718:	00c5e7b3          	or	a5,a1,a2
ffffffffc020271c:	ed06                	sd	ra,152(sp)
ffffffffc020271e:	e922                	sd	s0,144(sp)
ffffffffc0202720:	e526                	sd	s1,136(sp)
ffffffffc0202722:	e14a                	sd	s2,128(sp)
ffffffffc0202724:	fcce                	sd	s3,120(sp)
ffffffffc0202726:	f8d2                	sd	s4,112(sp)
ffffffffc0202728:	f4d6                	sd	s5,104(sp)
ffffffffc020272a:	f0da                	sd	s6,96(sp)
ffffffffc020272c:	ecde                	sd	s7,88(sp)
ffffffffc020272e:	17d2                	slli	a5,a5,0x34
ffffffffc0202730:	22079263          	bnez	a5,ffffffffc0202954 <exit_range+0x23e>
ffffffffc0202734:	00200937          	lui	s2,0x200
ffffffffc0202738:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc020273c:	0125b733          	sltu	a4,a1,s2
ffffffffc0202740:	0017b793          	seqz	a5,a5
ffffffffc0202744:	8fd9                	or	a5,a5,a4
ffffffffc0202746:	26079263          	bnez	a5,ffffffffc02029aa <exit_range+0x294>
ffffffffc020274a:	4785                	li	a5,1
ffffffffc020274c:	07fe                	slli	a5,a5,0x1f
ffffffffc020274e:	0785                	addi	a5,a5,1
ffffffffc0202750:	24f67d63          	bgeu	a2,a5,ffffffffc02029aa <exit_range+0x294>
ffffffffc0202754:	c00004b7          	lui	s1,0xc0000
ffffffffc0202758:	ffe007b7          	lui	a5,0xffe00
ffffffffc020275c:	8a2a                	mv	s4,a0
ffffffffc020275e:	8ced                	and	s1,s1,a1
ffffffffc0202760:	00f5f833          	and	a6,a1,a5
ffffffffc0202764:	00094a97          	auipc	s5,0x94
ffffffffc0202768:	14ca8a93          	addi	s5,s5,332 # ffffffffc02968b0 <npage>
ffffffffc020276c:	400009b7          	lui	s3,0x40000
ffffffffc0202770:	a809                	j	ffffffffc0202782 <exit_range+0x6c>
ffffffffc0202772:	013487b3          	add	a5,s1,s3
ffffffffc0202776:	400004b7          	lui	s1,0x40000
ffffffffc020277a:	8826                	mv	a6,s1
ffffffffc020277c:	c3f1                	beqz	a5,ffffffffc0202840 <exit_range+0x12a>
ffffffffc020277e:	0cc7f163          	bgeu	a5,a2,ffffffffc0202840 <exit_range+0x12a>
ffffffffc0202782:	01e4d413          	srli	s0,s1,0x1e
ffffffffc0202786:	1ff47413          	andi	s0,s0,511
ffffffffc020278a:	040e                	slli	s0,s0,0x3
ffffffffc020278c:	9452                	add	s0,s0,s4
ffffffffc020278e:	00043883          	ld	a7,0(s0)
ffffffffc0202792:	0018f793          	andi	a5,a7,1
ffffffffc0202796:	dff1                	beqz	a5,ffffffffc0202772 <exit_range+0x5c>
ffffffffc0202798:	000ab783          	ld	a5,0(s5)
ffffffffc020279c:	088a                	slli	a7,a7,0x2
ffffffffc020279e:	00c8d893          	srli	a7,a7,0xc
ffffffffc02027a2:	20f8f263          	bgeu	a7,a5,ffffffffc02029a6 <exit_range+0x290>
ffffffffc02027a6:	fff802b7          	lui	t0,0xfff80
ffffffffc02027aa:	00588f33          	add	t5,a7,t0
ffffffffc02027ae:	000803b7          	lui	t2,0x80
ffffffffc02027b2:	007f0733          	add	a4,t5,t2
ffffffffc02027b6:	00c71e13          	slli	t3,a4,0xc
ffffffffc02027ba:	0f1a                	slli	t5,t5,0x6
ffffffffc02027bc:	1cf77863          	bgeu	a4,a5,ffffffffc020298c <exit_range+0x276>
ffffffffc02027c0:	00094f97          	auipc	t6,0x94
ffffffffc02027c4:	0e8f8f93          	addi	t6,t6,232 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02027c8:	000fb783          	ld	a5,0(t6)
ffffffffc02027cc:	4e85                	li	t4,1
ffffffffc02027ce:	6b05                	lui	s6,0x1
ffffffffc02027d0:	9e3e                	add	t3,t3,a5
ffffffffc02027d2:	01348333          	add	t1,s1,s3
ffffffffc02027d6:	01585713          	srli	a4,a6,0x15
ffffffffc02027da:	1ff77713          	andi	a4,a4,511
ffffffffc02027de:	070e                	slli	a4,a4,0x3
ffffffffc02027e0:	9772                	add	a4,a4,t3
ffffffffc02027e2:	631c                	ld	a5,0(a4)
ffffffffc02027e4:	0017f693          	andi	a3,a5,1
ffffffffc02027e8:	e6bd                	bnez	a3,ffffffffc0202856 <exit_range+0x140>
ffffffffc02027ea:	4e81                	li	t4,0
ffffffffc02027ec:	984a                	add	a6,a6,s2
ffffffffc02027ee:	00080863          	beqz	a6,ffffffffc02027fe <exit_range+0xe8>
ffffffffc02027f2:	879a                	mv	a5,t1
ffffffffc02027f4:	00667363          	bgeu	a2,t1,ffffffffc02027fa <exit_range+0xe4>
ffffffffc02027f8:	87b2                	mv	a5,a2
ffffffffc02027fa:	fcf86ee3          	bltu	a6,a5,ffffffffc02027d6 <exit_range+0xc0>
ffffffffc02027fe:	f60e8ae3          	beqz	t4,ffffffffc0202772 <exit_range+0x5c>
ffffffffc0202802:	000ab783          	ld	a5,0(s5)
ffffffffc0202806:	1af8f063          	bgeu	a7,a5,ffffffffc02029a6 <exit_range+0x290>
ffffffffc020280a:	00094517          	auipc	a0,0x94
ffffffffc020280e:	0ae53503          	ld	a0,174(a0) # ffffffffc02968b8 <pages>
ffffffffc0202812:	957a                	add	a0,a0,t5
ffffffffc0202814:	100027f3          	csrr	a5,sstatus
ffffffffc0202818:	8b89                	andi	a5,a5,2
ffffffffc020281a:	10079b63          	bnez	a5,ffffffffc0202930 <exit_range+0x21a>
ffffffffc020281e:	00094797          	auipc	a5,0x94
ffffffffc0202822:	0727b783          	ld	a5,114(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202826:	4585                	li	a1,1
ffffffffc0202828:	e432                	sd	a2,8(sp)
ffffffffc020282a:	739c                	ld	a5,32(a5)
ffffffffc020282c:	9782                	jalr	a5
ffffffffc020282e:	6622                	ld	a2,8(sp)
ffffffffc0202830:	00043023          	sd	zero,0(s0)
ffffffffc0202834:	013487b3          	add	a5,s1,s3
ffffffffc0202838:	400004b7          	lui	s1,0x40000
ffffffffc020283c:	8826                	mv	a6,s1
ffffffffc020283e:	f3a1                	bnez	a5,ffffffffc020277e <exit_range+0x68>
ffffffffc0202840:	60ea                	ld	ra,152(sp)
ffffffffc0202842:	644a                	ld	s0,144(sp)
ffffffffc0202844:	64aa                	ld	s1,136(sp)
ffffffffc0202846:	690a                	ld	s2,128(sp)
ffffffffc0202848:	79e6                	ld	s3,120(sp)
ffffffffc020284a:	7a46                	ld	s4,112(sp)
ffffffffc020284c:	7aa6                	ld	s5,104(sp)
ffffffffc020284e:	7b06                	ld	s6,96(sp)
ffffffffc0202850:	6be6                	ld	s7,88(sp)
ffffffffc0202852:	610d                	addi	sp,sp,160
ffffffffc0202854:	8082                	ret
ffffffffc0202856:	000ab503          	ld	a0,0(s5)
ffffffffc020285a:	078a                	slli	a5,a5,0x2
ffffffffc020285c:	83b1                	srli	a5,a5,0xc
ffffffffc020285e:	14a7f463          	bgeu	a5,a0,ffffffffc02029a6 <exit_range+0x290>
ffffffffc0202862:	9796                	add	a5,a5,t0
ffffffffc0202864:	00778bb3          	add	s7,a5,t2
ffffffffc0202868:	00679593          	slli	a1,a5,0x6
ffffffffc020286c:	00cb9693          	slli	a3,s7,0xc
ffffffffc0202870:	10abf263          	bgeu	s7,a0,ffffffffc0202974 <exit_range+0x25e>
ffffffffc0202874:	000fb783          	ld	a5,0(t6)
ffffffffc0202878:	96be                	add	a3,a3,a5
ffffffffc020287a:	01668533          	add	a0,a3,s6
ffffffffc020287e:	629c                	ld	a5,0(a3)
ffffffffc0202880:	8b85                	andi	a5,a5,1
ffffffffc0202882:	f7ad                	bnez	a5,ffffffffc02027ec <exit_range+0xd6>
ffffffffc0202884:	06a1                	addi	a3,a3,8
ffffffffc0202886:	fea69ce3          	bne	a3,a0,ffffffffc020287e <exit_range+0x168>
ffffffffc020288a:	00094517          	auipc	a0,0x94
ffffffffc020288e:	02e53503          	ld	a0,46(a0) # ffffffffc02968b8 <pages>
ffffffffc0202892:	952e                	add	a0,a0,a1
ffffffffc0202894:	100027f3          	csrr	a5,sstatus
ffffffffc0202898:	8b89                	andi	a5,a5,2
ffffffffc020289a:	e3b9                	bnez	a5,ffffffffc02028e0 <exit_range+0x1ca>
ffffffffc020289c:	00094797          	auipc	a5,0x94
ffffffffc02028a0:	ff47b783          	ld	a5,-12(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02028a4:	4585                	li	a1,1
ffffffffc02028a6:	e0b2                	sd	a2,64(sp)
ffffffffc02028a8:	739c                	ld	a5,32(a5)
ffffffffc02028aa:	fc1a                	sd	t1,56(sp)
ffffffffc02028ac:	f846                	sd	a7,48(sp)
ffffffffc02028ae:	f47a                	sd	t5,40(sp)
ffffffffc02028b0:	f072                	sd	t3,32(sp)
ffffffffc02028b2:	ec76                	sd	t4,24(sp)
ffffffffc02028b4:	e842                	sd	a6,16(sp)
ffffffffc02028b6:	e43a                	sd	a4,8(sp)
ffffffffc02028b8:	9782                	jalr	a5
ffffffffc02028ba:	6722                	ld	a4,8(sp)
ffffffffc02028bc:	6842                	ld	a6,16(sp)
ffffffffc02028be:	6ee2                	ld	t4,24(sp)
ffffffffc02028c0:	7e02                	ld	t3,32(sp)
ffffffffc02028c2:	7f22                	ld	t5,40(sp)
ffffffffc02028c4:	78c2                	ld	a7,48(sp)
ffffffffc02028c6:	7362                	ld	t1,56(sp)
ffffffffc02028c8:	6606                	ld	a2,64(sp)
ffffffffc02028ca:	fff802b7          	lui	t0,0xfff80
ffffffffc02028ce:	000803b7          	lui	t2,0x80
ffffffffc02028d2:	00094f97          	auipc	t6,0x94
ffffffffc02028d6:	fd6f8f93          	addi	t6,t6,-42 # ffffffffc02968a8 <va_pa_offset>
ffffffffc02028da:	00073023          	sd	zero,0(a4)
ffffffffc02028de:	b739                	j	ffffffffc02027ec <exit_range+0xd6>
ffffffffc02028e0:	e4b2                	sd	a2,72(sp)
ffffffffc02028e2:	e09a                	sd	t1,64(sp)
ffffffffc02028e4:	fc46                	sd	a7,56(sp)
ffffffffc02028e6:	f47a                	sd	t5,40(sp)
ffffffffc02028e8:	f072                	sd	t3,32(sp)
ffffffffc02028ea:	ec76                	sd	t4,24(sp)
ffffffffc02028ec:	e842                	sd	a6,16(sp)
ffffffffc02028ee:	e43a                	sd	a4,8(sp)
ffffffffc02028f0:	f82a                	sd	a0,48(sp)
ffffffffc02028f2:	ae6fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02028f6:	00094797          	auipc	a5,0x94
ffffffffc02028fa:	f9a7b783          	ld	a5,-102(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc02028fe:	7542                	ld	a0,48(sp)
ffffffffc0202900:	4585                	li	a1,1
ffffffffc0202902:	739c                	ld	a5,32(a5)
ffffffffc0202904:	9782                	jalr	a5
ffffffffc0202906:	accfe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020290a:	6722                	ld	a4,8(sp)
ffffffffc020290c:	6626                	ld	a2,72(sp)
ffffffffc020290e:	6306                	ld	t1,64(sp)
ffffffffc0202910:	78e2                	ld	a7,56(sp)
ffffffffc0202912:	7f22                	ld	t5,40(sp)
ffffffffc0202914:	7e02                	ld	t3,32(sp)
ffffffffc0202916:	6ee2                	ld	t4,24(sp)
ffffffffc0202918:	6842                	ld	a6,16(sp)
ffffffffc020291a:	00094f97          	auipc	t6,0x94
ffffffffc020291e:	f8ef8f93          	addi	t6,t6,-114 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202922:	000803b7          	lui	t2,0x80
ffffffffc0202926:	fff802b7          	lui	t0,0xfff80
ffffffffc020292a:	00073023          	sd	zero,0(a4)
ffffffffc020292e:	bd7d                	j	ffffffffc02027ec <exit_range+0xd6>
ffffffffc0202930:	e832                	sd	a2,16(sp)
ffffffffc0202932:	e42a                	sd	a0,8(sp)
ffffffffc0202934:	aa4fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202938:	00094797          	auipc	a5,0x94
ffffffffc020293c:	f587b783          	ld	a5,-168(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202940:	6522                	ld	a0,8(sp)
ffffffffc0202942:	4585                	li	a1,1
ffffffffc0202944:	739c                	ld	a5,32(a5)
ffffffffc0202946:	9782                	jalr	a5
ffffffffc0202948:	a8afe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020294c:	6642                	ld	a2,16(sp)
ffffffffc020294e:	00043023          	sd	zero,0(s0)
ffffffffc0202952:	b5cd                	j	ffffffffc0202834 <exit_range+0x11e>
ffffffffc0202954:	0000a697          	auipc	a3,0xa
ffffffffc0202958:	4ec68693          	addi	a3,a3,1260 # ffffffffc020ce40 <etext+0x102c>
ffffffffc020295c:	0000a617          	auipc	a2,0xa
ffffffffc0202960:	8f460613          	addi	a2,a2,-1804 # ffffffffc020c250 <etext+0x43c>
ffffffffc0202964:	16f00593          	li	a1,367
ffffffffc0202968:	0000a517          	auipc	a0,0xa
ffffffffc020296c:	4a050513          	addi	a0,a0,1184 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0202970:	adbfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202974:	0000a617          	auipc	a2,0xa
ffffffffc0202978:	3a460613          	addi	a2,a2,932 # ffffffffc020cd18 <etext+0xf04>
ffffffffc020297c:	07100593          	li	a1,113
ffffffffc0202980:	0000a517          	auipc	a0,0xa
ffffffffc0202984:	3c050513          	addi	a0,a0,960 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0202988:	ac3fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020298c:	86f2                	mv	a3,t3
ffffffffc020298e:	0000a617          	auipc	a2,0xa
ffffffffc0202992:	38a60613          	addi	a2,a2,906 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0202996:	07100593          	li	a1,113
ffffffffc020299a:	0000a517          	auipc	a0,0xa
ffffffffc020299e:	3a650513          	addi	a0,a0,934 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02029a2:	aa9fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02029a6:	ffeff0ef          	jal	ffffffffc02021a4 <pa2page.part.0>
ffffffffc02029aa:	0000a697          	auipc	a3,0xa
ffffffffc02029ae:	4c668693          	addi	a3,a3,1222 # ffffffffc020ce70 <etext+0x105c>
ffffffffc02029b2:	0000a617          	auipc	a2,0xa
ffffffffc02029b6:	89e60613          	addi	a2,a2,-1890 # ffffffffc020c250 <etext+0x43c>
ffffffffc02029ba:	17000593          	li	a1,368
ffffffffc02029be:	0000a517          	auipc	a0,0xa
ffffffffc02029c2:	44a50513          	addi	a0,a0,1098 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02029c6:	a85fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02029ca <page_remove>:
ffffffffc02029ca:	1101                	addi	sp,sp,-32
ffffffffc02029cc:	4601                	li	a2,0
ffffffffc02029ce:	e822                	sd	s0,16(sp)
ffffffffc02029d0:	ec06                	sd	ra,24(sp)
ffffffffc02029d2:	842e                	mv	s0,a1
ffffffffc02029d4:	895ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc02029d8:	c511                	beqz	a0,ffffffffc02029e4 <page_remove+0x1a>
ffffffffc02029da:	6118                	ld	a4,0(a0)
ffffffffc02029dc:	87aa                	mv	a5,a0
ffffffffc02029de:	00177693          	andi	a3,a4,1
ffffffffc02029e2:	e689                	bnez	a3,ffffffffc02029ec <page_remove+0x22>
ffffffffc02029e4:	60e2                	ld	ra,24(sp)
ffffffffc02029e6:	6442                	ld	s0,16(sp)
ffffffffc02029e8:	6105                	addi	sp,sp,32
ffffffffc02029ea:	8082                	ret
ffffffffc02029ec:	00094697          	auipc	a3,0x94
ffffffffc02029f0:	ec46b683          	ld	a3,-316(a3) # ffffffffc02968b0 <npage>
ffffffffc02029f4:	070a                	slli	a4,a4,0x2
ffffffffc02029f6:	8331                	srli	a4,a4,0xc
ffffffffc02029f8:	06d77563          	bgeu	a4,a3,ffffffffc0202a62 <page_remove+0x98>
ffffffffc02029fc:	00094517          	auipc	a0,0x94
ffffffffc0202a00:	ebc53503          	ld	a0,-324(a0) # ffffffffc02968b8 <pages>
ffffffffc0202a04:	071a                	slli	a4,a4,0x6
ffffffffc0202a06:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202a0a:	9736                	add	a4,a4,a3
ffffffffc0202a0c:	953a                	add	a0,a0,a4
ffffffffc0202a0e:	4118                	lw	a4,0(a0)
ffffffffc0202a10:	377d                	addiw	a4,a4,-1
ffffffffc0202a12:	c118                	sw	a4,0(a0)
ffffffffc0202a14:	cb09                	beqz	a4,ffffffffc0202a26 <page_remove+0x5c>
ffffffffc0202a16:	0007b023          	sd	zero,0(a5)
ffffffffc0202a1a:	12040073          	sfence.vma	s0
ffffffffc0202a1e:	60e2                	ld	ra,24(sp)
ffffffffc0202a20:	6442                	ld	s0,16(sp)
ffffffffc0202a22:	6105                	addi	sp,sp,32
ffffffffc0202a24:	8082                	ret
ffffffffc0202a26:	10002773          	csrr	a4,sstatus
ffffffffc0202a2a:	8b09                	andi	a4,a4,2
ffffffffc0202a2c:	eb19                	bnez	a4,ffffffffc0202a42 <page_remove+0x78>
ffffffffc0202a2e:	00094717          	auipc	a4,0x94
ffffffffc0202a32:	e6273703          	ld	a4,-414(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a36:	4585                	li	a1,1
ffffffffc0202a38:	e03e                	sd	a5,0(sp)
ffffffffc0202a3a:	7318                	ld	a4,32(a4)
ffffffffc0202a3c:	9702                	jalr	a4
ffffffffc0202a3e:	6782                	ld	a5,0(sp)
ffffffffc0202a40:	bfd9                	j	ffffffffc0202a16 <page_remove+0x4c>
ffffffffc0202a42:	e43e                	sd	a5,8(sp)
ffffffffc0202a44:	e02a                	sd	a0,0(sp)
ffffffffc0202a46:	992fe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202a4a:	00094717          	auipc	a4,0x94
ffffffffc0202a4e:	e4673703          	ld	a4,-442(a4) # ffffffffc0296890 <pmm_manager>
ffffffffc0202a52:	6502                	ld	a0,0(sp)
ffffffffc0202a54:	4585                	li	a1,1
ffffffffc0202a56:	7318                	ld	a4,32(a4)
ffffffffc0202a58:	9702                	jalr	a4
ffffffffc0202a5a:	978fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202a5e:	67a2                	ld	a5,8(sp)
ffffffffc0202a60:	bf5d                	j	ffffffffc0202a16 <page_remove+0x4c>
ffffffffc0202a62:	f42ff0ef          	jal	ffffffffc02021a4 <pa2page.part.0>

ffffffffc0202a66 <page_insert>:
ffffffffc0202a66:	7139                	addi	sp,sp,-64
ffffffffc0202a68:	f426                	sd	s1,40(sp)
ffffffffc0202a6a:	84b2                	mv	s1,a2
ffffffffc0202a6c:	f822                	sd	s0,48(sp)
ffffffffc0202a6e:	4605                	li	a2,1
ffffffffc0202a70:	842e                	mv	s0,a1
ffffffffc0202a72:	85a6                	mv	a1,s1
ffffffffc0202a74:	fc06                	sd	ra,56(sp)
ffffffffc0202a76:	e436                	sd	a3,8(sp)
ffffffffc0202a78:	ff0ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202a7c:	cd61                	beqz	a0,ffffffffc0202b54 <page_insert+0xee>
ffffffffc0202a7e:	400c                	lw	a1,0(s0)
ffffffffc0202a80:	611c                	ld	a5,0(a0)
ffffffffc0202a82:	66a2                	ld	a3,8(sp)
ffffffffc0202a84:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0202a88:	c010                	sw	a2,0(s0)
ffffffffc0202a8a:	0017f613          	andi	a2,a5,1
ffffffffc0202a8e:	872a                	mv	a4,a0
ffffffffc0202a90:	e61d                	bnez	a2,ffffffffc0202abe <page_insert+0x58>
ffffffffc0202a92:	00094617          	auipc	a2,0x94
ffffffffc0202a96:	e2663603          	ld	a2,-474(a2) # ffffffffc02968b8 <pages>
ffffffffc0202a9a:	8c11                	sub	s0,s0,a2
ffffffffc0202a9c:	8419                	srai	s0,s0,0x6
ffffffffc0202a9e:	200007b7          	lui	a5,0x20000
ffffffffc0202aa2:	042a                	slli	s0,s0,0xa
ffffffffc0202aa4:	943e                	add	s0,s0,a5
ffffffffc0202aa6:	8ec1                	or	a3,a3,s0
ffffffffc0202aa8:	0016e693          	ori	a3,a3,1
ffffffffc0202aac:	e314                	sd	a3,0(a4)
ffffffffc0202aae:	12048073          	sfence.vma	s1
ffffffffc0202ab2:	4501                	li	a0,0
ffffffffc0202ab4:	70e2                	ld	ra,56(sp)
ffffffffc0202ab6:	7442                	ld	s0,48(sp)
ffffffffc0202ab8:	74a2                	ld	s1,40(sp)
ffffffffc0202aba:	6121                	addi	sp,sp,64
ffffffffc0202abc:	8082                	ret
ffffffffc0202abe:	00094617          	auipc	a2,0x94
ffffffffc0202ac2:	df263603          	ld	a2,-526(a2) # ffffffffc02968b0 <npage>
ffffffffc0202ac6:	078a                	slli	a5,a5,0x2
ffffffffc0202ac8:	83b1                	srli	a5,a5,0xc
ffffffffc0202aca:	08c7f763          	bgeu	a5,a2,ffffffffc0202b58 <page_insert+0xf2>
ffffffffc0202ace:	00094617          	auipc	a2,0x94
ffffffffc0202ad2:	dea63603          	ld	a2,-534(a2) # ffffffffc02968b8 <pages>
ffffffffc0202ad6:	fe000537          	lui	a0,0xfe000
ffffffffc0202ada:	079a                	slli	a5,a5,0x6
ffffffffc0202adc:	97aa                	add	a5,a5,a0
ffffffffc0202ade:	00f60533          	add	a0,a2,a5
ffffffffc0202ae2:	00a40963          	beq	s0,a0,ffffffffc0202af4 <page_insert+0x8e>
ffffffffc0202ae6:	411c                	lw	a5,0(a0)
ffffffffc0202ae8:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_bin_sfs_img_size+0x1ff8acff>
ffffffffc0202aea:	c11c                	sw	a5,0(a0)
ffffffffc0202aec:	c791                	beqz	a5,ffffffffc0202af8 <page_insert+0x92>
ffffffffc0202aee:	12048073          	sfence.vma	s1
ffffffffc0202af2:	b765                	j	ffffffffc0202a9a <page_insert+0x34>
ffffffffc0202af4:	c00c                	sw	a1,0(s0)
ffffffffc0202af6:	b755                	j	ffffffffc0202a9a <page_insert+0x34>
ffffffffc0202af8:	100027f3          	csrr	a5,sstatus
ffffffffc0202afc:	8b89                	andi	a5,a5,2
ffffffffc0202afe:	e39d                	bnez	a5,ffffffffc0202b24 <page_insert+0xbe>
ffffffffc0202b00:	00094797          	auipc	a5,0x94
ffffffffc0202b04:	d907b783          	ld	a5,-624(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202b08:	4585                	li	a1,1
ffffffffc0202b0a:	e83a                	sd	a4,16(sp)
ffffffffc0202b0c:	739c                	ld	a5,32(a5)
ffffffffc0202b0e:	e436                	sd	a3,8(sp)
ffffffffc0202b10:	9782                	jalr	a5
ffffffffc0202b12:	00094617          	auipc	a2,0x94
ffffffffc0202b16:	da663603          	ld	a2,-602(a2) # ffffffffc02968b8 <pages>
ffffffffc0202b1a:	66a2                	ld	a3,8(sp)
ffffffffc0202b1c:	6742                	ld	a4,16(sp)
ffffffffc0202b1e:	12048073          	sfence.vma	s1
ffffffffc0202b22:	bfa5                	j	ffffffffc0202a9a <page_insert+0x34>
ffffffffc0202b24:	ec3a                	sd	a4,24(sp)
ffffffffc0202b26:	e836                	sd	a3,16(sp)
ffffffffc0202b28:	e42a                	sd	a0,8(sp)
ffffffffc0202b2a:	8aefe0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0202b2e:	00094797          	auipc	a5,0x94
ffffffffc0202b32:	d627b783          	ld	a5,-670(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0202b36:	6522                	ld	a0,8(sp)
ffffffffc0202b38:	4585                	li	a1,1
ffffffffc0202b3a:	739c                	ld	a5,32(a5)
ffffffffc0202b3c:	9782                	jalr	a5
ffffffffc0202b3e:	894fe0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0202b42:	00094617          	auipc	a2,0x94
ffffffffc0202b46:	d7663603          	ld	a2,-650(a2) # ffffffffc02968b8 <pages>
ffffffffc0202b4a:	6762                	ld	a4,24(sp)
ffffffffc0202b4c:	66c2                	ld	a3,16(sp)
ffffffffc0202b4e:	12048073          	sfence.vma	s1
ffffffffc0202b52:	b7a1                	j	ffffffffc0202a9a <page_insert+0x34>
ffffffffc0202b54:	5571                	li	a0,-4
ffffffffc0202b56:	bfb9                	j	ffffffffc0202ab4 <page_insert+0x4e>
ffffffffc0202b58:	e4cff0ef          	jal	ffffffffc02021a4 <pa2page.part.0>

ffffffffc0202b5c <pmm_init>:
ffffffffc0202b5c:	0000d797          	auipc	a5,0xd
ffffffffc0202b60:	83478793          	addi	a5,a5,-1996 # ffffffffc020f390 <default_pmm_manager>
ffffffffc0202b64:	638c                	ld	a1,0(a5)
ffffffffc0202b66:	7159                	addi	sp,sp,-112
ffffffffc0202b68:	f486                	sd	ra,104(sp)
ffffffffc0202b6a:	e8ca                	sd	s2,80(sp)
ffffffffc0202b6c:	e4ce                	sd	s3,72(sp)
ffffffffc0202b6e:	f85a                	sd	s6,48(sp)
ffffffffc0202b70:	f0a2                	sd	s0,96(sp)
ffffffffc0202b72:	eca6                	sd	s1,88(sp)
ffffffffc0202b74:	e0d2                	sd	s4,64(sp)
ffffffffc0202b76:	fc56                	sd	s5,56(sp)
ffffffffc0202b78:	f45e                	sd	s7,40(sp)
ffffffffc0202b7a:	f062                	sd	s8,32(sp)
ffffffffc0202b7c:	ec66                	sd	s9,24(sp)
ffffffffc0202b7e:	00094b17          	auipc	s6,0x94
ffffffffc0202b82:	d12b0b13          	addi	s6,s6,-750 # ffffffffc0296890 <pmm_manager>
ffffffffc0202b86:	0000a517          	auipc	a0,0xa
ffffffffc0202b8a:	30250513          	addi	a0,a0,770 # ffffffffc020ce88 <etext+0x1074>
ffffffffc0202b8e:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b92:	e14fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202b96:	000b3783          	ld	a5,0(s6)
ffffffffc0202b9a:	00094997          	auipc	s3,0x94
ffffffffc0202b9e:	d0e98993          	addi	s3,s3,-754 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0202ba2:	679c                	ld	a5,8(a5)
ffffffffc0202ba4:	9782                	jalr	a5
ffffffffc0202ba6:	57f5                	li	a5,-3
ffffffffc0202ba8:	07fa                	slli	a5,a5,0x1e
ffffffffc0202baa:	00f9b023          	sd	a5,0(s3)
ffffffffc0202bae:	dfbfd0ef          	jal	ffffffffc02009a8 <get_memory_base>
ffffffffc0202bb2:	892a                	mv	s2,a0
ffffffffc0202bb4:	dfffd0ef          	jal	ffffffffc02009b2 <get_memory_size>
ffffffffc0202bb8:	460506e3          	beqz	a0,ffffffffc0203824 <pmm_init+0xcc8>
ffffffffc0202bbc:	84aa                	mv	s1,a0
ffffffffc0202bbe:	0000a517          	auipc	a0,0xa
ffffffffc0202bc2:	30250513          	addi	a0,a0,770 # ffffffffc020cec0 <etext+0x10ac>
ffffffffc0202bc6:	de0fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202bca:	00990433          	add	s0,s2,s1
ffffffffc0202bce:	864a                	mv	a2,s2
ffffffffc0202bd0:	85a6                	mv	a1,s1
ffffffffc0202bd2:	fff40693          	addi	a3,s0,-1
ffffffffc0202bd6:	0000a517          	auipc	a0,0xa
ffffffffc0202bda:	30250513          	addi	a0,a0,770 # ffffffffc020ced8 <etext+0x10c4>
ffffffffc0202bde:	dc8fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202be2:	c80007b7          	lui	a5,0xc8000
ffffffffc0202be6:	8522                	mv	a0,s0
ffffffffc0202be8:	6887e263          	bltu	a5,s0,ffffffffc020326c <pmm_init+0x710>
ffffffffc0202bec:	77fd                	lui	a5,0xfffff
ffffffffc0202bee:	00095617          	auipc	a2,0x95
ffffffffc0202bf2:	d2160613          	addi	a2,a2,-735 # ffffffffc029790f <end+0xfff>
ffffffffc0202bf6:	8e7d                	and	a2,a2,a5
ffffffffc0202bf8:	8131                	srli	a0,a0,0xc
ffffffffc0202bfa:	00094b97          	auipc	s7,0x94
ffffffffc0202bfe:	cbeb8b93          	addi	s7,s7,-834 # ffffffffc02968b8 <pages>
ffffffffc0202c02:	00094497          	auipc	s1,0x94
ffffffffc0202c06:	cae48493          	addi	s1,s1,-850 # ffffffffc02968b0 <npage>
ffffffffc0202c0a:	00cbb023          	sd	a2,0(s7)
ffffffffc0202c0e:	e088                	sd	a0,0(s1)
ffffffffc0202c10:	000807b7          	lui	a5,0x80
ffffffffc0202c14:	86b2                	mv	a3,a2
ffffffffc0202c16:	02f50763          	beq	a0,a5,ffffffffc0202c44 <pmm_init+0xe8>
ffffffffc0202c1a:	4701                	li	a4,0
ffffffffc0202c1c:	4585                	li	a1,1
ffffffffc0202c1e:	fff806b7          	lui	a3,0xfff80
ffffffffc0202c22:	00671793          	slli	a5,a4,0x6
ffffffffc0202c26:	97b2                	add	a5,a5,a2
ffffffffc0202c28:	07a1                	addi	a5,a5,8 # 80008 <_binary_bin_sfs_img_size+0xad08>
ffffffffc0202c2a:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202c2e:	6088                	ld	a0,0(s1)
ffffffffc0202c30:	0705                	addi	a4,a4,1
ffffffffc0202c32:	000bb603          	ld	a2,0(s7)
ffffffffc0202c36:	00d507b3          	add	a5,a0,a3
ffffffffc0202c3a:	fef764e3          	bltu	a4,a5,ffffffffc0202c22 <pmm_init+0xc6>
ffffffffc0202c3e:	079a                	slli	a5,a5,0x6
ffffffffc0202c40:	00f606b3          	add	a3,a2,a5
ffffffffc0202c44:	c02007b7          	lui	a5,0xc0200
ffffffffc0202c48:	36f6ede3          	bltu	a3,a5,ffffffffc02037c2 <pmm_init+0xc66>
ffffffffc0202c4c:	0009b583          	ld	a1,0(s3)
ffffffffc0202c50:	77fd                	lui	a5,0xfffff
ffffffffc0202c52:	8c7d                	and	s0,s0,a5
ffffffffc0202c54:	8e8d                	sub	a3,a3,a1
ffffffffc0202c56:	6486ed63          	bltu	a3,s0,ffffffffc02032b0 <pmm_init+0x754>
ffffffffc0202c5a:	0000a517          	auipc	a0,0xa
ffffffffc0202c5e:	2a650513          	addi	a0,a0,678 # ffffffffc020cf00 <etext+0x10ec>
ffffffffc0202c62:	d44fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c66:	000b3783          	ld	a5,0(s6)
ffffffffc0202c6a:	7b9c                	ld	a5,48(a5)
ffffffffc0202c6c:	9782                	jalr	a5
ffffffffc0202c6e:	0000a517          	auipc	a0,0xa
ffffffffc0202c72:	2aa50513          	addi	a0,a0,682 # ffffffffc020cf18 <etext+0x1104>
ffffffffc0202c76:	d30fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202c7e:	8b89                	andi	a5,a5,2
ffffffffc0202c80:	60079d63          	bnez	a5,ffffffffc020329a <pmm_init+0x73e>
ffffffffc0202c84:	000b3783          	ld	a5,0(s6)
ffffffffc0202c88:	4505                	li	a0,1
ffffffffc0202c8a:	6f9c                	ld	a5,24(a5)
ffffffffc0202c8c:	9782                	jalr	a5
ffffffffc0202c8e:	842a                	mv	s0,a0
ffffffffc0202c90:	36040ee3          	beqz	s0,ffffffffc020380c <pmm_init+0xcb0>
ffffffffc0202c94:	000bb703          	ld	a4,0(s7)
ffffffffc0202c98:	000807b7          	lui	a5,0x80
ffffffffc0202c9c:	5a7d                	li	s4,-1
ffffffffc0202c9e:	40e406b3          	sub	a3,s0,a4
ffffffffc0202ca2:	8699                	srai	a3,a3,0x6
ffffffffc0202ca4:	6098                	ld	a4,0(s1)
ffffffffc0202ca6:	96be                	add	a3,a3,a5
ffffffffc0202ca8:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202cac:	8ff5                	and	a5,a5,a3
ffffffffc0202cae:	06b2                	slli	a3,a3,0xc
ffffffffc0202cb0:	32e7f5e3          	bgeu	a5,a4,ffffffffc02037da <pmm_init+0xc7e>
ffffffffc0202cb4:	0009b783          	ld	a5,0(s3)
ffffffffc0202cb8:	6605                	lui	a2,0x1
ffffffffc0202cba:	4581                	li	a1,0
ffffffffc0202cbc:	00f68433          	add	s0,a3,a5
ffffffffc0202cc0:	8522                	mv	a0,s0
ffffffffc0202cc2:	0ea090ef          	jal	ffffffffc020bdac <memset>
ffffffffc0202cc6:	0009b683          	ld	a3,0(s3)
ffffffffc0202cca:	0000a917          	auipc	s2,0xa
ffffffffc0202cce:	14990913          	addi	s2,s2,329 # ffffffffc020ce13 <etext+0xfff>
ffffffffc0202cd2:	77fd                	lui	a5,0xfffff
ffffffffc0202cd4:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202cd8:	00f97933          	and	s2,s2,a5
ffffffffc0202cdc:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202ce0:	40da86b3          	sub	a3,s5,a3
ffffffffc0202ce4:	8522                	mv	a0,s0
ffffffffc0202ce6:	964a                	add	a2,a2,s2
ffffffffc0202ce8:	85d6                	mv	a1,s5
ffffffffc0202cea:	4729                	li	a4,10
ffffffffc0202cec:	fdaff0ef          	jal	ffffffffc02024c6 <boot_map_segment>
ffffffffc0202cf0:	435962e3          	bltu	s2,s5,ffffffffc0203914 <pmm_init+0xdb8>
ffffffffc0202cf4:	0009b683          	ld	a3,0(s3)
ffffffffc0202cf8:	c8000637          	lui	a2,0xc8000
ffffffffc0202cfc:	41260633          	sub	a2,a2,s2
ffffffffc0202d00:	40d906b3          	sub	a3,s2,a3
ffffffffc0202d04:	85ca                	mv	a1,s2
ffffffffc0202d06:	4719                	li	a4,6
ffffffffc0202d08:	8522                	mv	a0,s0
ffffffffc0202d0a:	00094917          	auipc	s2,0x94
ffffffffc0202d0e:	b9690913          	addi	s2,s2,-1130 # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0202d12:	fb4ff0ef          	jal	ffffffffc02024c6 <boot_map_segment>
ffffffffc0202d16:	00893023          	sd	s0,0(s2)
ffffffffc0202d1a:	2d546ce3          	bltu	s0,s5,ffffffffc02037f2 <pmm_init+0xc96>
ffffffffc0202d1e:	0009b783          	ld	a5,0(s3)
ffffffffc0202d22:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202d24:	8c1d                	sub	s0,s0,a5
ffffffffc0202d26:	00c45793          	srli	a5,s0,0xc
ffffffffc0202d2a:	00094717          	auipc	a4,0x94
ffffffffc0202d2e:	b6873723          	sd	s0,-1170(a4) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0202d32:	0147e7b3          	or	a5,a5,s4
ffffffffc0202d36:	18079073          	csrw	satp,a5
ffffffffc0202d3a:	12000073          	sfence.vma
ffffffffc0202d3e:	0000a517          	auipc	a0,0xa
ffffffffc0202d42:	21a50513          	addi	a0,a0,538 # ffffffffc020cf58 <etext+0x1144>
ffffffffc0202d46:	c60fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202d4a:	0000e717          	auipc	a4,0xe
ffffffffc0202d4e:	2b670713          	addi	a4,a4,694 # ffffffffc0211000 <bootstack>
ffffffffc0202d52:	0000e797          	auipc	a5,0xe
ffffffffc0202d56:	2ae78793          	addi	a5,a5,686 # ffffffffc0211000 <bootstack>
ffffffffc0202d5a:	48f70163          	beq	a4,a5,ffffffffc02031dc <pmm_init+0x680>
ffffffffc0202d5e:	100027f3          	csrr	a5,sstatus
ffffffffc0202d62:	8b89                	andi	a5,a5,2
ffffffffc0202d64:	52079163          	bnez	a5,ffffffffc0203286 <pmm_init+0x72a>
ffffffffc0202d68:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6c:	779c                	ld	a5,40(a5)
ffffffffc0202d6e:	9782                	jalr	a5
ffffffffc0202d70:	842a                	mv	s0,a0
ffffffffc0202d72:	6098                	ld	a4,0(s1)
ffffffffc0202d74:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d78:	83b1                	srli	a5,a5,0xc
ffffffffc0202d7a:	30e7e1e3          	bltu	a5,a4,ffffffffc020387c <pmm_init+0xd20>
ffffffffc0202d7e:	00093503          	ld	a0,0(s2)
ffffffffc0202d82:	2c050de3          	beqz	a0,ffffffffc020385c <pmm_init+0xd00>
ffffffffc0202d86:	03451793          	slli	a5,a0,0x34
ffffffffc0202d8a:	2c0799e3          	bnez	a5,ffffffffc020385c <pmm_init+0xd00>
ffffffffc0202d8e:	4601                	li	a2,0
ffffffffc0202d90:	4581                	li	a1,0
ffffffffc0202d92:	ffcff0ef          	jal	ffffffffc020258e <get_page>
ffffffffc0202d96:	2a0513e3          	bnez	a0,ffffffffc020383c <pmm_init+0xce0>
ffffffffc0202d9a:	100027f3          	csrr	a5,sstatus
ffffffffc0202d9e:	8b89                	andi	a5,a5,2
ffffffffc0202da0:	4c079863          	bnez	a5,ffffffffc0203270 <pmm_init+0x714>
ffffffffc0202da4:	000b3783          	ld	a5,0(s6)
ffffffffc0202da8:	4505                	li	a0,1
ffffffffc0202daa:	6f9c                	ld	a5,24(a5)
ffffffffc0202dac:	9782                	jalr	a5
ffffffffc0202dae:	8a2a                	mv	s4,a0
ffffffffc0202db0:	00093503          	ld	a0,0(s2)
ffffffffc0202db4:	4681                	li	a3,0
ffffffffc0202db6:	4601                	li	a2,0
ffffffffc0202db8:	85d2                	mv	a1,s4
ffffffffc0202dba:	cadff0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0202dbe:	32051be3          	bnez	a0,ffffffffc02038f4 <pmm_init+0xd98>
ffffffffc0202dc2:	00093503          	ld	a0,0(s2)
ffffffffc0202dc6:	4601                	li	a2,0
ffffffffc0202dc8:	4581                	li	a1,0
ffffffffc0202dca:	c9eff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202dce:	300503e3          	beqz	a0,ffffffffc02038d4 <pmm_init+0xd78>
ffffffffc0202dd2:	611c                	ld	a5,0(a0)
ffffffffc0202dd4:	0017f713          	andi	a4,a5,1
ffffffffc0202dd8:	2e0702e3          	beqz	a4,ffffffffc02038bc <pmm_init+0xd60>
ffffffffc0202ddc:	6090                	ld	a2,0(s1)
ffffffffc0202dde:	078a                	slli	a5,a5,0x2
ffffffffc0202de0:	83b1                	srli	a5,a5,0xc
ffffffffc0202de2:	62c7fb63          	bgeu	a5,a2,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc0202de6:	000bb703          	ld	a4,0(s7)
ffffffffc0202dea:	079a                	slli	a5,a5,0x6
ffffffffc0202dec:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202df0:	97b6                	add	a5,a5,a3
ffffffffc0202df2:	97ba                	add	a5,a5,a4
ffffffffc0202df4:	64fa1463          	bne	s4,a5,ffffffffc020343c <pmm_init+0x8e0>
ffffffffc0202df8:	000a2703          	lw	a4,0(s4) # 200000 <_binary_bin_sfs_img_size+0x18ad00>
ffffffffc0202dfc:	4785                	li	a5,1
ffffffffc0202dfe:	78f71863          	bne	a4,a5,ffffffffc020358e <pmm_init+0xa32>
ffffffffc0202e02:	00093503          	ld	a0,0(s2)
ffffffffc0202e06:	77fd                	lui	a5,0xfffff
ffffffffc0202e08:	6114                	ld	a3,0(a0)
ffffffffc0202e0a:	068a                	slli	a3,a3,0x2
ffffffffc0202e0c:	8efd                	and	a3,a3,a5
ffffffffc0202e0e:	00c6d713          	srli	a4,a3,0xc
ffffffffc0202e12:	76c77263          	bgeu	a4,a2,ffffffffc0203576 <pmm_init+0xa1a>
ffffffffc0202e16:	0009bc03          	ld	s8,0(s3)
ffffffffc0202e1a:	96e2                	add	a3,a3,s8
ffffffffc0202e1c:	0006ba83          	ld	s5,0(a3) # fffffffffe000000 <end+0x3dd696f0>
ffffffffc0202e20:	0a8a                	slli	s5,s5,0x2
ffffffffc0202e22:	00fafab3          	and	s5,s5,a5
ffffffffc0202e26:	00cad793          	srli	a5,s5,0xc
ffffffffc0202e2a:	72c7f963          	bgeu	a5,a2,ffffffffc020355c <pmm_init+0xa00>
ffffffffc0202e2e:	4601                	li	a2,0
ffffffffc0202e30:	6585                	lui	a1,0x1
ffffffffc0202e32:	9c56                	add	s8,s8,s5
ffffffffc0202e34:	c34ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202e38:	0c21                	addi	s8,s8,8
ffffffffc0202e3a:	6d851163          	bne	a0,s8,ffffffffc02034fc <pmm_init+0x9a0>
ffffffffc0202e3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202e42:	8b89                	andi	a5,a5,2
ffffffffc0202e44:	48079e63          	bnez	a5,ffffffffc02032e0 <pmm_init+0x784>
ffffffffc0202e48:	000b3783          	ld	a5,0(s6)
ffffffffc0202e4c:	4505                	li	a0,1
ffffffffc0202e4e:	6f9c                	ld	a5,24(a5)
ffffffffc0202e50:	9782                	jalr	a5
ffffffffc0202e52:	8c2a                	mv	s8,a0
ffffffffc0202e54:	00093503          	ld	a0,0(s2)
ffffffffc0202e58:	46d1                	li	a3,20
ffffffffc0202e5a:	6605                	lui	a2,0x1
ffffffffc0202e5c:	85e2                	mv	a1,s8
ffffffffc0202e5e:	c09ff0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0202e62:	6c051d63          	bnez	a0,ffffffffc020353c <pmm_init+0x9e0>
ffffffffc0202e66:	00093503          	ld	a0,0(s2)
ffffffffc0202e6a:	4601                	li	a2,0
ffffffffc0202e6c:	6585                	lui	a1,0x1
ffffffffc0202e6e:	bfaff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202e72:	6a050563          	beqz	a0,ffffffffc020351c <pmm_init+0x9c0>
ffffffffc0202e76:	611c                	ld	a5,0(a0)
ffffffffc0202e78:	0107f713          	andi	a4,a5,16
ffffffffc0202e7c:	5a070063          	beqz	a4,ffffffffc020341c <pmm_init+0x8c0>
ffffffffc0202e80:	8b91                	andi	a5,a5,4
ffffffffc0202e82:	60078d63          	beqz	a5,ffffffffc020349c <pmm_init+0x940>
ffffffffc0202e86:	00093503          	ld	a0,0(s2)
ffffffffc0202e8a:	611c                	ld	a5,0(a0)
ffffffffc0202e8c:	8bc1                	andi	a5,a5,16
ffffffffc0202e8e:	5e078763          	beqz	a5,ffffffffc020347c <pmm_init+0x920>
ffffffffc0202e92:	000c2703          	lw	a4,0(s8)
ffffffffc0202e96:	4785                	li	a5,1
ffffffffc0202e98:	64f71263          	bne	a4,a5,ffffffffc02034dc <pmm_init+0x980>
ffffffffc0202e9c:	4681                	li	a3,0
ffffffffc0202e9e:	6605                	lui	a2,0x1
ffffffffc0202ea0:	85d2                	mv	a1,s4
ffffffffc0202ea2:	bc5ff0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0202ea6:	60051b63          	bnez	a0,ffffffffc02034bc <pmm_init+0x960>
ffffffffc0202eaa:	000a2703          	lw	a4,0(s4)
ffffffffc0202eae:	4789                	li	a5,2
ffffffffc0202eb0:	28f71fe3          	bne	a4,a5,ffffffffc020394e <pmm_init+0xdf2>
ffffffffc0202eb4:	000c2783          	lw	a5,0(s8)
ffffffffc0202eb8:	26079be3          	bnez	a5,ffffffffc020392e <pmm_init+0xdd2>
ffffffffc0202ebc:	00093503          	ld	a0,0(s2)
ffffffffc0202ec0:	4601                	li	a2,0
ffffffffc0202ec2:	6585                	lui	a1,0x1
ffffffffc0202ec4:	ba4ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0202ec8:	58050a63          	beqz	a0,ffffffffc020345c <pmm_init+0x900>
ffffffffc0202ecc:	6118                	ld	a4,0(a0)
ffffffffc0202ece:	00177793          	andi	a5,a4,1
ffffffffc0202ed2:	1e0785e3          	beqz	a5,ffffffffc02038bc <pmm_init+0xd60>
ffffffffc0202ed6:	6094                	ld	a3,0(s1)
ffffffffc0202ed8:	00271793          	slli	a5,a4,0x2
ffffffffc0202edc:	83b1                	srli	a5,a5,0xc
ffffffffc0202ede:	52d7fd63          	bgeu	a5,a3,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc0202ee2:	000bb683          	ld	a3,0(s7)
ffffffffc0202ee6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202eea:	97d6                	add	a5,a5,s5
ffffffffc0202eec:	079a                	slli	a5,a5,0x6
ffffffffc0202eee:	97b6                	add	a5,a5,a3
ffffffffc0202ef0:	0afa19e3          	bne	s4,a5,ffffffffc02037a2 <pmm_init+0xc46>
ffffffffc0202ef4:	8b41                	andi	a4,a4,16
ffffffffc0202ef6:	080716e3          	bnez	a4,ffffffffc0203782 <pmm_init+0xc26>
ffffffffc0202efa:	00093503          	ld	a0,0(s2)
ffffffffc0202efe:	4581                	li	a1,0
ffffffffc0202f00:	acbff0ef          	jal	ffffffffc02029ca <page_remove>
ffffffffc0202f04:	000a2c83          	lw	s9,0(s4)
ffffffffc0202f08:	4785                	li	a5,1
ffffffffc0202f0a:	04fc9ce3          	bne	s9,a5,ffffffffc0203762 <pmm_init+0xc06>
ffffffffc0202f0e:	000c2783          	lw	a5,0(s8)
ffffffffc0202f12:	020798e3          	bnez	a5,ffffffffc0203742 <pmm_init+0xbe6>
ffffffffc0202f16:	00093503          	ld	a0,0(s2)
ffffffffc0202f1a:	6585                	lui	a1,0x1
ffffffffc0202f1c:	aafff0ef          	jal	ffffffffc02029ca <page_remove>
ffffffffc0202f20:	000a2783          	lw	a5,0(s4)
ffffffffc0202f24:	7e079f63          	bnez	a5,ffffffffc0203722 <pmm_init+0xbc6>
ffffffffc0202f28:	000c2783          	lw	a5,0(s8)
ffffffffc0202f2c:	7c079b63          	bnez	a5,ffffffffc0203702 <pmm_init+0xba6>
ffffffffc0202f30:	00093a03          	ld	s4,0(s2)
ffffffffc0202f34:	6098                	ld	a4,0(s1)
ffffffffc0202f36:	000a3783          	ld	a5,0(s4)
ffffffffc0202f3a:	078a                	slli	a5,a5,0x2
ffffffffc0202f3c:	83b1                	srli	a5,a5,0xc
ffffffffc0202f3e:	4ce7fd63          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc0202f42:	000bb503          	ld	a0,0(s7)
ffffffffc0202f46:	97d6                	add	a5,a5,s5
ffffffffc0202f48:	079a                	slli	a5,a5,0x6
ffffffffc0202f4a:	00f506b3          	add	a3,a0,a5
ffffffffc0202f4e:	4294                	lw	a3,0(a3)
ffffffffc0202f50:	79969963          	bne	a3,s9,ffffffffc02036e2 <pmm_init+0xb86>
ffffffffc0202f54:	8799                	srai	a5,a5,0x6
ffffffffc0202f56:	00080637          	lui	a2,0x80
ffffffffc0202f5a:	97b2                	add	a5,a5,a2
ffffffffc0202f5c:	00c79693          	slli	a3,a5,0xc
ffffffffc0202f60:	06e7fde3          	bgeu	a5,a4,ffffffffc02037da <pmm_init+0xc7e>
ffffffffc0202f64:	0009b783          	ld	a5,0(s3)
ffffffffc0202f68:	97b6                	add	a5,a5,a3
ffffffffc0202f6a:	639c                	ld	a5,0(a5)
ffffffffc0202f6c:	078a                	slli	a5,a5,0x2
ffffffffc0202f6e:	83b1                	srli	a5,a5,0xc
ffffffffc0202f70:	4ae7f463          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc0202f74:	8f91                	sub	a5,a5,a2
ffffffffc0202f76:	079a                	slli	a5,a5,0x6
ffffffffc0202f78:	953e                	add	a0,a0,a5
ffffffffc0202f7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202f7e:	8b89                	andi	a5,a5,2
ffffffffc0202f80:	3a079b63          	bnez	a5,ffffffffc0203336 <pmm_init+0x7da>
ffffffffc0202f84:	000b3783          	ld	a5,0(s6)
ffffffffc0202f88:	4585                	li	a1,1
ffffffffc0202f8a:	739c                	ld	a5,32(a5)
ffffffffc0202f8c:	9782                	jalr	a5
ffffffffc0202f8e:	000a3783          	ld	a5,0(s4)
ffffffffc0202f92:	6098                	ld	a4,0(s1)
ffffffffc0202f94:	078a                	slli	a5,a5,0x2
ffffffffc0202f96:	83b1                	srli	a5,a5,0xc
ffffffffc0202f98:	48e7f063          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc0202f9c:	000bb503          	ld	a0,0(s7)
ffffffffc0202fa0:	fe000737          	lui	a4,0xfe000
ffffffffc0202fa4:	079a                	slli	a5,a5,0x6
ffffffffc0202fa6:	97ba                	add	a5,a5,a4
ffffffffc0202fa8:	953e                	add	a0,a0,a5
ffffffffc0202faa:	100027f3          	csrr	a5,sstatus
ffffffffc0202fae:	8b89                	andi	a5,a5,2
ffffffffc0202fb0:	36079763          	bnez	a5,ffffffffc020331e <pmm_init+0x7c2>
ffffffffc0202fb4:	000b3783          	ld	a5,0(s6)
ffffffffc0202fb8:	4585                	li	a1,1
ffffffffc0202fba:	739c                	ld	a5,32(a5)
ffffffffc0202fbc:	9782                	jalr	a5
ffffffffc0202fbe:	00093783          	ld	a5,0(s2)
ffffffffc0202fc2:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202fc6:	12000073          	sfence.vma
ffffffffc0202fca:	100027f3          	csrr	a5,sstatus
ffffffffc0202fce:	8b89                	andi	a5,a5,2
ffffffffc0202fd0:	32079d63          	bnez	a5,ffffffffc020330a <pmm_init+0x7ae>
ffffffffc0202fd4:	000b3783          	ld	a5,0(s6)
ffffffffc0202fd8:	779c                	ld	a5,40(a5)
ffffffffc0202fda:	9782                	jalr	a5
ffffffffc0202fdc:	8a2a                	mv	s4,a0
ffffffffc0202fde:	6f441263          	bne	s0,s4,ffffffffc02036c2 <pmm_init+0xb66>
ffffffffc0202fe2:	0000a517          	auipc	a0,0xa
ffffffffc0202fe6:	2f650513          	addi	a0,a0,758 # ffffffffc020d2d8 <etext+0x14c4>
ffffffffc0202fea:	9bcfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202fee:	100027f3          	csrr	a5,sstatus
ffffffffc0202ff2:	8b89                	andi	a5,a5,2
ffffffffc0202ff4:	30079163          	bnez	a5,ffffffffc02032f6 <pmm_init+0x79a>
ffffffffc0202ff8:	000b3783          	ld	a5,0(s6)
ffffffffc0202ffc:	779c                	ld	a5,40(a5)
ffffffffc0202ffe:	9782                	jalr	a5
ffffffffc0203000:	8c2a                	mv	s8,a0
ffffffffc0203002:	609c                	ld	a5,0(s1)
ffffffffc0203004:	c0200437          	lui	s0,0xc0200
ffffffffc0203008:	7a7d                	lui	s4,0xfffff
ffffffffc020300a:	00c79713          	slli	a4,a5,0xc
ffffffffc020300e:	6a85                	lui	s5,0x1
ffffffffc0203010:	02e47c63          	bgeu	s0,a4,ffffffffc0203048 <pmm_init+0x4ec>
ffffffffc0203014:	00c45713          	srli	a4,s0,0xc
ffffffffc0203018:	3af77363          	bgeu	a4,a5,ffffffffc02033be <pmm_init+0x862>
ffffffffc020301c:	0009b583          	ld	a1,0(s3)
ffffffffc0203020:	00093503          	ld	a0,0(s2)
ffffffffc0203024:	4601                	li	a2,0
ffffffffc0203026:	95a2                	add	a1,a1,s0
ffffffffc0203028:	a40ff0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc020302c:	3c050663          	beqz	a0,ffffffffc02033f8 <pmm_init+0x89c>
ffffffffc0203030:	611c                	ld	a5,0(a0)
ffffffffc0203032:	078a                	slli	a5,a5,0x2
ffffffffc0203034:	0147f7b3          	and	a5,a5,s4
ffffffffc0203038:	3a879063          	bne	a5,s0,ffffffffc02033d8 <pmm_init+0x87c>
ffffffffc020303c:	609c                	ld	a5,0(s1)
ffffffffc020303e:	9456                	add	s0,s0,s5
ffffffffc0203040:	00c79713          	slli	a4,a5,0xc
ffffffffc0203044:	fce468e3          	bltu	s0,a4,ffffffffc0203014 <pmm_init+0x4b8>
ffffffffc0203048:	00093783          	ld	a5,0(s2)
ffffffffc020304c:	639c                	ld	a5,0(a5)
ffffffffc020304e:	5c079a63          	bnez	a5,ffffffffc0203622 <pmm_init+0xac6>
ffffffffc0203052:	100027f3          	csrr	a5,sstatus
ffffffffc0203056:	8b89                	andi	a5,a5,2
ffffffffc0203058:	30079663          	bnez	a5,ffffffffc0203364 <pmm_init+0x808>
ffffffffc020305c:	000b3783          	ld	a5,0(s6)
ffffffffc0203060:	4505                	li	a0,1
ffffffffc0203062:	6f9c                	ld	a5,24(a5)
ffffffffc0203064:	9782                	jalr	a5
ffffffffc0203066:	842a                	mv	s0,a0
ffffffffc0203068:	00093503          	ld	a0,0(s2)
ffffffffc020306c:	4699                	li	a3,6
ffffffffc020306e:	10000613          	li	a2,256
ffffffffc0203072:	85a2                	mv	a1,s0
ffffffffc0203074:	9f3ff0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203078:	5e051563          	bnez	a0,ffffffffc0203662 <pmm_init+0xb06>
ffffffffc020307c:	4018                	lw	a4,0(s0)
ffffffffc020307e:	4785                	li	a5,1
ffffffffc0203080:	62f71163          	bne	a4,a5,ffffffffc02036a2 <pmm_init+0xb46>
ffffffffc0203084:	00093503          	ld	a0,0(s2)
ffffffffc0203088:	6605                	lui	a2,0x1
ffffffffc020308a:	10060613          	addi	a2,a2,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020308e:	4699                	li	a3,6
ffffffffc0203090:	85a2                	mv	a1,s0
ffffffffc0203092:	9d5ff0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203096:	5e051663          	bnez	a0,ffffffffc0203682 <pmm_init+0xb26>
ffffffffc020309a:	4018                	lw	a4,0(s0)
ffffffffc020309c:	4789                	li	a5,2
ffffffffc020309e:	54f71263          	bne	a4,a5,ffffffffc02035e2 <pmm_init+0xa86>
ffffffffc02030a2:	0000a597          	auipc	a1,0xa
ffffffffc02030a6:	37e58593          	addi	a1,a1,894 # ffffffffc020d420 <etext+0x160c>
ffffffffc02030aa:	10000513          	li	a0,256
ffffffffc02030ae:	47f080ef          	jal	ffffffffc020bd2c <strcpy>
ffffffffc02030b2:	6585                	lui	a1,0x1
ffffffffc02030b4:	10058593          	addi	a1,a1,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc02030b8:	10000513          	li	a0,256
ffffffffc02030bc:	483080ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc02030c0:	7c051e63          	bnez	a0,ffffffffc020389c <pmm_init+0xd40>
ffffffffc02030c4:	000bb683          	ld	a3,0(s7)
ffffffffc02030c8:	000807b7          	lui	a5,0x80
ffffffffc02030cc:	6098                	ld	a4,0(s1)
ffffffffc02030ce:	40d406b3          	sub	a3,s0,a3
ffffffffc02030d2:	8699                	srai	a3,a3,0x6
ffffffffc02030d4:	96be                	add	a3,a3,a5
ffffffffc02030d6:	00c69793          	slli	a5,a3,0xc
ffffffffc02030da:	83b1                	srli	a5,a5,0xc
ffffffffc02030dc:	06b2                	slli	a3,a3,0xc
ffffffffc02030de:	6ee7fe63          	bgeu	a5,a4,ffffffffc02037da <pmm_init+0xc7e>
ffffffffc02030e2:	0009b783          	ld	a5,0(s3)
ffffffffc02030e6:	10000513          	li	a0,256
ffffffffc02030ea:	97b6                	add	a5,a5,a3
ffffffffc02030ec:	10078023          	sb	zero,256(a5) # 80100 <_binary_bin_sfs_img_size+0xae00>
ffffffffc02030f0:	409080ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc02030f4:	54051763          	bnez	a0,ffffffffc0203642 <pmm_init+0xae6>
ffffffffc02030f8:	00093a03          	ld	s4,0(s2)
ffffffffc02030fc:	6098                	ld	a4,0(s1)
ffffffffc02030fe:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203102:	078a                	slli	a5,a5,0x2
ffffffffc0203104:	83b1                	srli	a5,a5,0xc
ffffffffc0203106:	30e7f963          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc020310a:	00c79693          	slli	a3,a5,0xc
ffffffffc020310e:	6ce7f663          	bgeu	a5,a4,ffffffffc02037da <pmm_init+0xc7e>
ffffffffc0203112:	0009b783          	ld	a5,0(s3)
ffffffffc0203116:	00f689b3          	add	s3,a3,a5
ffffffffc020311a:	100027f3          	csrr	a5,sstatus
ffffffffc020311e:	8b89                	andi	a5,a5,2
ffffffffc0203120:	22079763          	bnez	a5,ffffffffc020334e <pmm_init+0x7f2>
ffffffffc0203124:	000b3783          	ld	a5,0(s6)
ffffffffc0203128:	8522                	mv	a0,s0
ffffffffc020312a:	4585                	li	a1,1
ffffffffc020312c:	739c                	ld	a5,32(a5)
ffffffffc020312e:	9782                	jalr	a5
ffffffffc0203130:	0009b783          	ld	a5,0(s3)
ffffffffc0203134:	6098                	ld	a4,0(s1)
ffffffffc0203136:	078a                	slli	a5,a5,0x2
ffffffffc0203138:	83b1                	srli	a5,a5,0xc
ffffffffc020313a:	2ce7ff63          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc020313e:	000bb503          	ld	a0,0(s7)
ffffffffc0203142:	fe000737          	lui	a4,0xfe000
ffffffffc0203146:	079a                	slli	a5,a5,0x6
ffffffffc0203148:	97ba                	add	a5,a5,a4
ffffffffc020314a:	953e                	add	a0,a0,a5
ffffffffc020314c:	100027f3          	csrr	a5,sstatus
ffffffffc0203150:	8b89                	andi	a5,a5,2
ffffffffc0203152:	24079a63          	bnez	a5,ffffffffc02033a6 <pmm_init+0x84a>
ffffffffc0203156:	000b3783          	ld	a5,0(s6)
ffffffffc020315a:	4585                	li	a1,1
ffffffffc020315c:	739c                	ld	a5,32(a5)
ffffffffc020315e:	9782                	jalr	a5
ffffffffc0203160:	000a3783          	ld	a5,0(s4)
ffffffffc0203164:	6098                	ld	a4,0(s1)
ffffffffc0203166:	078a                	slli	a5,a5,0x2
ffffffffc0203168:	83b1                	srli	a5,a5,0xc
ffffffffc020316a:	2ae7f763          	bgeu	a5,a4,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc020316e:	000bb503          	ld	a0,0(s7)
ffffffffc0203172:	fe000737          	lui	a4,0xfe000
ffffffffc0203176:	079a                	slli	a5,a5,0x6
ffffffffc0203178:	97ba                	add	a5,a5,a4
ffffffffc020317a:	953e                	add	a0,a0,a5
ffffffffc020317c:	100027f3          	csrr	a5,sstatus
ffffffffc0203180:	8b89                	andi	a5,a5,2
ffffffffc0203182:	20079663          	bnez	a5,ffffffffc020338e <pmm_init+0x832>
ffffffffc0203186:	000b3783          	ld	a5,0(s6)
ffffffffc020318a:	4585                	li	a1,1
ffffffffc020318c:	739c                	ld	a5,32(a5)
ffffffffc020318e:	9782                	jalr	a5
ffffffffc0203190:	00093783          	ld	a5,0(s2)
ffffffffc0203194:	0007b023          	sd	zero,0(a5)
ffffffffc0203198:	12000073          	sfence.vma
ffffffffc020319c:	100027f3          	csrr	a5,sstatus
ffffffffc02031a0:	8b89                	andi	a5,a5,2
ffffffffc02031a2:	1c079c63          	bnez	a5,ffffffffc020337a <pmm_init+0x81e>
ffffffffc02031a6:	000b3783          	ld	a5,0(s6)
ffffffffc02031aa:	779c                	ld	a5,40(a5)
ffffffffc02031ac:	9782                	jalr	a5
ffffffffc02031ae:	842a                	mv	s0,a0
ffffffffc02031b0:	448c1963          	bne	s8,s0,ffffffffc0203602 <pmm_init+0xaa6>
ffffffffc02031b4:	0000a517          	auipc	a0,0xa
ffffffffc02031b8:	2e450513          	addi	a0,a0,740 # ffffffffc020d498 <etext+0x1684>
ffffffffc02031bc:	febfc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02031c0:	7406                	ld	s0,96(sp)
ffffffffc02031c2:	70a6                	ld	ra,104(sp)
ffffffffc02031c4:	64e6                	ld	s1,88(sp)
ffffffffc02031c6:	6946                	ld	s2,80(sp)
ffffffffc02031c8:	69a6                	ld	s3,72(sp)
ffffffffc02031ca:	6a06                	ld	s4,64(sp)
ffffffffc02031cc:	7ae2                	ld	s5,56(sp)
ffffffffc02031ce:	7b42                	ld	s6,48(sp)
ffffffffc02031d0:	7ba2                	ld	s7,40(sp)
ffffffffc02031d2:	7c02                	ld	s8,32(sp)
ffffffffc02031d4:	6ce2                	ld	s9,24(sp)
ffffffffc02031d6:	6165                	addi	sp,sp,112
ffffffffc02031d8:	e01fe06f          	j	ffffffffc0201fd8 <kmalloc_init>
ffffffffc02031dc:	00010797          	auipc	a5,0x10
ffffffffc02031e0:	e2478793          	addi	a5,a5,-476 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02031e4:	00010717          	auipc	a4,0x10
ffffffffc02031e8:	e1c70713          	addi	a4,a4,-484 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02031ec:	b6f719e3          	bne	a4,a5,ffffffffc0202d5e <pmm_init+0x202>
ffffffffc02031f0:	6605                	lui	a2,0x1
ffffffffc02031f2:	4581                	li	a1,0
ffffffffc02031f4:	853a                	mv	a0,a4
ffffffffc02031f6:	3b7080ef          	jal	ffffffffc020bdac <memset>
ffffffffc02031fa:	0000e797          	auipc	a5,0xe
ffffffffc02031fe:	e00782a3          	sb	zero,-507(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc0203202:	0000d797          	auipc	a5,0xd
ffffffffc0203206:	de078f23          	sb	zero,-514(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc020320a:	0000d797          	auipc	a5,0xd
ffffffffc020320e:	df678793          	addi	a5,a5,-522 # ffffffffc0210000 <bootstackguard>
ffffffffc0203212:	3b57eb63          	bltu	a5,s5,ffffffffc02035c8 <pmm_init+0xa6c>
ffffffffc0203216:	0009b683          	ld	a3,0(s3)
ffffffffc020321a:	00093503          	ld	a0,0(s2)
ffffffffc020321e:	0000d597          	auipc	a1,0xd
ffffffffc0203222:	de258593          	addi	a1,a1,-542 # ffffffffc0210000 <bootstackguard>
ffffffffc0203226:	40d586b3          	sub	a3,a1,a3
ffffffffc020322a:	4701                	li	a4,0
ffffffffc020322c:	6605                	lui	a2,0x1
ffffffffc020322e:	a98ff0ef          	jal	ffffffffc02024c6 <boot_map_segment>
ffffffffc0203232:	00010797          	auipc	a5,0x10
ffffffffc0203236:	dce78793          	addi	a5,a5,-562 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc020323a:	3757ea63          	bltu	a5,s5,ffffffffc02035ae <pmm_init+0xa52>
ffffffffc020323e:	0009b683          	ld	a3,0(s3)
ffffffffc0203242:	00093503          	ld	a0,0(s2)
ffffffffc0203246:	00010597          	auipc	a1,0x10
ffffffffc020324a:	dba58593          	addi	a1,a1,-582 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc020324e:	40d586b3          	sub	a3,a1,a3
ffffffffc0203252:	4701                	li	a4,0
ffffffffc0203254:	6605                	lui	a2,0x1
ffffffffc0203256:	a70ff0ef          	jal	ffffffffc02024c6 <boot_map_segment>
ffffffffc020325a:	12000073          	sfence.vma
ffffffffc020325e:	0000a517          	auipc	a0,0xa
ffffffffc0203262:	d2250513          	addi	a0,a0,-734 # ffffffffc020cf80 <etext+0x116c>
ffffffffc0203266:	f41fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020326a:	bcd5                	j	ffffffffc0202d5e <pmm_init+0x202>
ffffffffc020326c:	853e                	mv	a0,a5
ffffffffc020326e:	babd                	j	ffffffffc0202bec <pmm_init+0x90>
ffffffffc0203270:	969fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203274:	000b3783          	ld	a5,0(s6)
ffffffffc0203278:	4505                	li	a0,1
ffffffffc020327a:	6f9c                	ld	a5,24(a5)
ffffffffc020327c:	9782                	jalr	a5
ffffffffc020327e:	8a2a                	mv	s4,a0
ffffffffc0203280:	953fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203284:	b635                	j	ffffffffc0202db0 <pmm_init+0x254>
ffffffffc0203286:	953fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020328a:	000b3783          	ld	a5,0(s6)
ffffffffc020328e:	779c                	ld	a5,40(a5)
ffffffffc0203290:	9782                	jalr	a5
ffffffffc0203292:	842a                	mv	s0,a0
ffffffffc0203294:	93ffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203298:	bce9                	j	ffffffffc0202d72 <pmm_init+0x216>
ffffffffc020329a:	93ffd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020329e:	000b3783          	ld	a5,0(s6)
ffffffffc02032a2:	4505                	li	a0,1
ffffffffc02032a4:	6f9c                	ld	a5,24(a5)
ffffffffc02032a6:	9782                	jalr	a5
ffffffffc02032a8:	842a                	mv	s0,a0
ffffffffc02032aa:	929fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032ae:	b2cd                	j	ffffffffc0202c90 <pmm_init+0x134>
ffffffffc02032b0:	6705                	lui	a4,0x1
ffffffffc02032b2:	177d                	addi	a4,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc02032b4:	96ba                	add	a3,a3,a4
ffffffffc02032b6:	8ff5                	and	a5,a5,a3
ffffffffc02032b8:	00c7d713          	srli	a4,a5,0xc
ffffffffc02032bc:	14a77e63          	bgeu	a4,a0,ffffffffc0203418 <pmm_init+0x8bc>
ffffffffc02032c0:	000b3683          	ld	a3,0(s6)
ffffffffc02032c4:	8c1d                	sub	s0,s0,a5
ffffffffc02032c6:	071a                	slli	a4,a4,0x6
ffffffffc02032c8:	fe0007b7          	lui	a5,0xfe000
ffffffffc02032cc:	973e                	add	a4,a4,a5
ffffffffc02032ce:	6a9c                	ld	a5,16(a3)
ffffffffc02032d0:	00c45593          	srli	a1,s0,0xc
ffffffffc02032d4:	00e60533          	add	a0,a2,a4
ffffffffc02032d8:	9782                	jalr	a5
ffffffffc02032da:	0009b583          	ld	a1,0(s3)
ffffffffc02032de:	bab5                	j	ffffffffc0202c5a <pmm_init+0xfe>
ffffffffc02032e0:	8f9fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032e4:	000b3783          	ld	a5,0(s6)
ffffffffc02032e8:	4505                	li	a0,1
ffffffffc02032ea:	6f9c                	ld	a5,24(a5)
ffffffffc02032ec:	9782                	jalr	a5
ffffffffc02032ee:	8c2a                	mv	s8,a0
ffffffffc02032f0:	8e3fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02032f4:	b685                	j	ffffffffc0202e54 <pmm_init+0x2f8>
ffffffffc02032f6:	8e3fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02032fa:	000b3783          	ld	a5,0(s6)
ffffffffc02032fe:	779c                	ld	a5,40(a5)
ffffffffc0203300:	9782                	jalr	a5
ffffffffc0203302:	8c2a                	mv	s8,a0
ffffffffc0203304:	8cffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203308:	b9ed                	j	ffffffffc0203002 <pmm_init+0x4a6>
ffffffffc020330a:	8cffd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020330e:	000b3783          	ld	a5,0(s6)
ffffffffc0203312:	779c                	ld	a5,40(a5)
ffffffffc0203314:	9782                	jalr	a5
ffffffffc0203316:	8a2a                	mv	s4,a0
ffffffffc0203318:	8bbfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020331c:	b1c9                	j	ffffffffc0202fde <pmm_init+0x482>
ffffffffc020331e:	e42a                	sd	a0,8(sp)
ffffffffc0203320:	8b9fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203324:	000b3783          	ld	a5,0(s6)
ffffffffc0203328:	6522                	ld	a0,8(sp)
ffffffffc020332a:	4585                	li	a1,1
ffffffffc020332c:	739c                	ld	a5,32(a5)
ffffffffc020332e:	9782                	jalr	a5
ffffffffc0203330:	8a3fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203334:	b169                	j	ffffffffc0202fbe <pmm_init+0x462>
ffffffffc0203336:	e42a                	sd	a0,8(sp)
ffffffffc0203338:	8a1fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020333c:	000b3783          	ld	a5,0(s6)
ffffffffc0203340:	6522                	ld	a0,8(sp)
ffffffffc0203342:	4585                	li	a1,1
ffffffffc0203344:	739c                	ld	a5,32(a5)
ffffffffc0203346:	9782                	jalr	a5
ffffffffc0203348:	88bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020334c:	b189                	j	ffffffffc0202f8e <pmm_init+0x432>
ffffffffc020334e:	88bfd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203352:	000b3783          	ld	a5,0(s6)
ffffffffc0203356:	8522                	mv	a0,s0
ffffffffc0203358:	4585                	li	a1,1
ffffffffc020335a:	739c                	ld	a5,32(a5)
ffffffffc020335c:	9782                	jalr	a5
ffffffffc020335e:	875fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203362:	b3f9                	j	ffffffffc0203130 <pmm_init+0x5d4>
ffffffffc0203364:	875fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203368:	000b3783          	ld	a5,0(s6)
ffffffffc020336c:	4505                	li	a0,1
ffffffffc020336e:	6f9c                	ld	a5,24(a5)
ffffffffc0203370:	9782                	jalr	a5
ffffffffc0203372:	842a                	mv	s0,a0
ffffffffc0203374:	85ffd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203378:	b9c5                	j	ffffffffc0203068 <pmm_init+0x50c>
ffffffffc020337a:	85ffd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020337e:	000b3783          	ld	a5,0(s6)
ffffffffc0203382:	779c                	ld	a5,40(a5)
ffffffffc0203384:	9782                	jalr	a5
ffffffffc0203386:	842a                	mv	s0,a0
ffffffffc0203388:	84bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020338c:	b515                	j	ffffffffc02031b0 <pmm_init+0x654>
ffffffffc020338e:	e42a                	sd	a0,8(sp)
ffffffffc0203390:	849fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203394:	000b3783          	ld	a5,0(s6)
ffffffffc0203398:	6522                	ld	a0,8(sp)
ffffffffc020339a:	4585                	li	a1,1
ffffffffc020339c:	739c                	ld	a5,32(a5)
ffffffffc020339e:	9782                	jalr	a5
ffffffffc02033a0:	833fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02033a4:	b3f5                	j	ffffffffc0203190 <pmm_init+0x634>
ffffffffc02033a6:	e42a                	sd	a0,8(sp)
ffffffffc02033a8:	831fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02033ac:	000b3783          	ld	a5,0(s6)
ffffffffc02033b0:	6522                	ld	a0,8(sp)
ffffffffc02033b2:	4585                	li	a1,1
ffffffffc02033b4:	739c                	ld	a5,32(a5)
ffffffffc02033b6:	9782                	jalr	a5
ffffffffc02033b8:	81bfd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02033bc:	b355                	j	ffffffffc0203160 <pmm_init+0x604>
ffffffffc02033be:	86a2                	mv	a3,s0
ffffffffc02033c0:	0000a617          	auipc	a2,0xa
ffffffffc02033c4:	95860613          	addi	a2,a2,-1704 # ffffffffc020cd18 <etext+0xf04>
ffffffffc02033c8:	29000593          	li	a1,656
ffffffffc02033cc:	0000a517          	auipc	a0,0xa
ffffffffc02033d0:	a3c50513          	addi	a0,a0,-1476 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02033d4:	876fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033d8:	0000a697          	auipc	a3,0xa
ffffffffc02033dc:	f6068693          	addi	a3,a3,-160 # ffffffffc020d338 <etext+0x1524>
ffffffffc02033e0:	00009617          	auipc	a2,0x9
ffffffffc02033e4:	e7060613          	addi	a2,a2,-400 # ffffffffc020c250 <etext+0x43c>
ffffffffc02033e8:	29100593          	li	a1,657
ffffffffc02033ec:	0000a517          	auipc	a0,0xa
ffffffffc02033f0:	a1c50513          	addi	a0,a0,-1508 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02033f4:	856fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033f8:	0000a697          	auipc	a3,0xa
ffffffffc02033fc:	f0068693          	addi	a3,a3,-256 # ffffffffc020d2f8 <etext+0x14e4>
ffffffffc0203400:	00009617          	auipc	a2,0x9
ffffffffc0203404:	e5060613          	addi	a2,a2,-432 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203408:	29000593          	li	a1,656
ffffffffc020340c:	0000a517          	auipc	a0,0xa
ffffffffc0203410:	9fc50513          	addi	a0,a0,-1540 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203414:	836fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203418:	d8dfe0ef          	jal	ffffffffc02021a4 <pa2page.part.0>
ffffffffc020341c:	0000a697          	auipc	a3,0xa
ffffffffc0203420:	d7c68693          	addi	a3,a3,-644 # ffffffffc020d198 <etext+0x1384>
ffffffffc0203424:	00009617          	auipc	a2,0x9
ffffffffc0203428:	e2c60613          	addi	a2,a2,-468 # ffffffffc020c250 <etext+0x43c>
ffffffffc020342c:	26500593          	li	a1,613
ffffffffc0203430:	0000a517          	auipc	a0,0xa
ffffffffc0203434:	9d850513          	addi	a0,a0,-1576 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203438:	812fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020343c:	0000a697          	auipc	a3,0xa
ffffffffc0203440:	c8468693          	addi	a3,a3,-892 # ffffffffc020d0c0 <etext+0x12ac>
ffffffffc0203444:	00009617          	auipc	a2,0x9
ffffffffc0203448:	e0c60613          	addi	a2,a2,-500 # ffffffffc020c250 <etext+0x43c>
ffffffffc020344c:	25b00593          	li	a1,603
ffffffffc0203450:	0000a517          	auipc	a0,0xa
ffffffffc0203454:	9b850513          	addi	a0,a0,-1608 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203458:	ff3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020345c:	0000a697          	auipc	a3,0xa
ffffffffc0203460:	d0468693          	addi	a3,a3,-764 # ffffffffc020d160 <etext+0x134c>
ffffffffc0203464:	00009617          	auipc	a2,0x9
ffffffffc0203468:	dec60613          	addi	a2,a2,-532 # ffffffffc020c250 <etext+0x43c>
ffffffffc020346c:	26d00593          	li	a1,621
ffffffffc0203470:	0000a517          	auipc	a0,0xa
ffffffffc0203474:	99850513          	addi	a0,a0,-1640 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203478:	fd3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020347c:	0000a697          	auipc	a3,0xa
ffffffffc0203480:	d3c68693          	addi	a3,a3,-708 # ffffffffc020d1b8 <etext+0x13a4>
ffffffffc0203484:	00009617          	auipc	a2,0x9
ffffffffc0203488:	dcc60613          	addi	a2,a2,-564 # ffffffffc020c250 <etext+0x43c>
ffffffffc020348c:	26700593          	li	a1,615
ffffffffc0203490:	0000a517          	auipc	a0,0xa
ffffffffc0203494:	97850513          	addi	a0,a0,-1672 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203498:	fb3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020349c:	0000a697          	auipc	a3,0xa
ffffffffc02034a0:	d0c68693          	addi	a3,a3,-756 # ffffffffc020d1a8 <etext+0x1394>
ffffffffc02034a4:	00009617          	auipc	a2,0x9
ffffffffc02034a8:	dac60613          	addi	a2,a2,-596 # ffffffffc020c250 <etext+0x43c>
ffffffffc02034ac:	26600593          	li	a1,614
ffffffffc02034b0:	0000a517          	auipc	a0,0xa
ffffffffc02034b4:	95850513          	addi	a0,a0,-1704 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02034b8:	f93fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034bc:	0000a697          	auipc	a3,0xa
ffffffffc02034c0:	d3468693          	addi	a3,a3,-716 # ffffffffc020d1f0 <etext+0x13dc>
ffffffffc02034c4:	00009617          	auipc	a2,0x9
ffffffffc02034c8:	d8c60613          	addi	a2,a2,-628 # ffffffffc020c250 <etext+0x43c>
ffffffffc02034cc:	26a00593          	li	a1,618
ffffffffc02034d0:	0000a517          	auipc	a0,0xa
ffffffffc02034d4:	93850513          	addi	a0,a0,-1736 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02034d8:	f73fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034dc:	0000a697          	auipc	a3,0xa
ffffffffc02034e0:	cfc68693          	addi	a3,a3,-772 # ffffffffc020d1d8 <etext+0x13c4>
ffffffffc02034e4:	00009617          	auipc	a2,0x9
ffffffffc02034e8:	d6c60613          	addi	a2,a2,-660 # ffffffffc020c250 <etext+0x43c>
ffffffffc02034ec:	26800593          	li	a1,616
ffffffffc02034f0:	0000a517          	auipc	a0,0xa
ffffffffc02034f4:	91850513          	addi	a0,a0,-1768 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02034f8:	f53fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034fc:	0000a697          	auipc	a3,0xa
ffffffffc0203500:	bf468693          	addi	a3,a3,-1036 # ffffffffc020d0f0 <etext+0x12dc>
ffffffffc0203504:	00009617          	auipc	a2,0x9
ffffffffc0203508:	d4c60613          	addi	a2,a2,-692 # ffffffffc020c250 <etext+0x43c>
ffffffffc020350c:	26000593          	li	a1,608
ffffffffc0203510:	0000a517          	auipc	a0,0xa
ffffffffc0203514:	8f850513          	addi	a0,a0,-1800 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203518:	f33fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020351c:	0000a697          	auipc	a3,0xa
ffffffffc0203520:	c4468693          	addi	a3,a3,-956 # ffffffffc020d160 <etext+0x134c>
ffffffffc0203524:	00009617          	auipc	a2,0x9
ffffffffc0203528:	d2c60613          	addi	a2,a2,-724 # ffffffffc020c250 <etext+0x43c>
ffffffffc020352c:	26400593          	li	a1,612
ffffffffc0203530:	0000a517          	auipc	a0,0xa
ffffffffc0203534:	8d850513          	addi	a0,a0,-1832 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203538:	f13fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020353c:	0000a697          	auipc	a3,0xa
ffffffffc0203540:	be468693          	addi	a3,a3,-1052 # ffffffffc020d120 <etext+0x130c>
ffffffffc0203544:	00009617          	auipc	a2,0x9
ffffffffc0203548:	d0c60613          	addi	a2,a2,-756 # ffffffffc020c250 <etext+0x43c>
ffffffffc020354c:	26300593          	li	a1,611
ffffffffc0203550:	0000a517          	auipc	a0,0xa
ffffffffc0203554:	8b850513          	addi	a0,a0,-1864 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203558:	ef3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020355c:	86d6                	mv	a3,s5
ffffffffc020355e:	00009617          	auipc	a2,0x9
ffffffffc0203562:	7ba60613          	addi	a2,a2,1978 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0203566:	25f00593          	li	a1,607
ffffffffc020356a:	0000a517          	auipc	a0,0xa
ffffffffc020356e:	89e50513          	addi	a0,a0,-1890 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203572:	ed9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203576:	00009617          	auipc	a2,0x9
ffffffffc020357a:	7a260613          	addi	a2,a2,1954 # ffffffffc020cd18 <etext+0xf04>
ffffffffc020357e:	25e00593          	li	a1,606
ffffffffc0203582:	0000a517          	auipc	a0,0xa
ffffffffc0203586:	88650513          	addi	a0,a0,-1914 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020358a:	ec1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020358e:	0000a697          	auipc	a3,0xa
ffffffffc0203592:	b4a68693          	addi	a3,a3,-1206 # ffffffffc020d0d8 <etext+0x12c4>
ffffffffc0203596:	00009617          	auipc	a2,0x9
ffffffffc020359a:	cba60613          	addi	a2,a2,-838 # ffffffffc020c250 <etext+0x43c>
ffffffffc020359e:	25c00593          	li	a1,604
ffffffffc02035a2:	0000a517          	auipc	a0,0xa
ffffffffc02035a6:	86650513          	addi	a0,a0,-1946 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02035aa:	ea1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035ae:	86be                	mv	a3,a5
ffffffffc02035b0:	0000a617          	auipc	a2,0xa
ffffffffc02035b4:	81060613          	addi	a2,a2,-2032 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02035b8:	0dc00593          	li	a1,220
ffffffffc02035bc:	0000a517          	auipc	a0,0xa
ffffffffc02035c0:	84c50513          	addi	a0,a0,-1972 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02035c4:	e87fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035c8:	86be                	mv	a3,a5
ffffffffc02035ca:	00009617          	auipc	a2,0x9
ffffffffc02035ce:	7f660613          	addi	a2,a2,2038 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02035d2:	0db00593          	li	a1,219
ffffffffc02035d6:	0000a517          	auipc	a0,0xa
ffffffffc02035da:	83250513          	addi	a0,a0,-1998 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02035de:	e6dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035e2:	0000a697          	auipc	a3,0xa
ffffffffc02035e6:	e2668693          	addi	a3,a3,-474 # ffffffffc020d408 <etext+0x15f4>
ffffffffc02035ea:	00009617          	auipc	a2,0x9
ffffffffc02035ee:	c6660613          	addi	a2,a2,-922 # ffffffffc020c250 <etext+0x43c>
ffffffffc02035f2:	29b00593          	li	a1,667
ffffffffc02035f6:	0000a517          	auipc	a0,0xa
ffffffffc02035fa:	81250513          	addi	a0,a0,-2030 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02035fe:	e4dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203602:	0000a697          	auipc	a3,0xa
ffffffffc0203606:	cae68693          	addi	a3,a3,-850 # ffffffffc020d2b0 <etext+0x149c>
ffffffffc020360a:	00009617          	auipc	a2,0x9
ffffffffc020360e:	c4660613          	addi	a2,a2,-954 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203612:	2ab00593          	li	a1,683
ffffffffc0203616:	00009517          	auipc	a0,0x9
ffffffffc020361a:	7f250513          	addi	a0,a0,2034 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020361e:	e2dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203622:	0000a697          	auipc	a3,0xa
ffffffffc0203626:	d2e68693          	addi	a3,a3,-722 # ffffffffc020d350 <etext+0x153c>
ffffffffc020362a:	00009617          	auipc	a2,0x9
ffffffffc020362e:	c2660613          	addi	a2,a2,-986 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203632:	29400593          	li	a1,660
ffffffffc0203636:	00009517          	auipc	a0,0x9
ffffffffc020363a:	7d250513          	addi	a0,a0,2002 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020363e:	e0dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203642:	0000a697          	auipc	a3,0xa
ffffffffc0203646:	e2e68693          	addi	a3,a3,-466 # ffffffffc020d470 <etext+0x165c>
ffffffffc020364a:	00009617          	auipc	a2,0x9
ffffffffc020364e:	c0660613          	addi	a2,a2,-1018 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203652:	2a200593          	li	a1,674
ffffffffc0203656:	00009517          	auipc	a0,0x9
ffffffffc020365a:	7b250513          	addi	a0,a0,1970 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020365e:	dedfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203662:	0000a697          	auipc	a3,0xa
ffffffffc0203666:	d0668693          	addi	a3,a3,-762 # ffffffffc020d368 <etext+0x1554>
ffffffffc020366a:	00009617          	auipc	a2,0x9
ffffffffc020366e:	be660613          	addi	a2,a2,-1050 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203672:	29800593          	li	a1,664
ffffffffc0203676:	00009517          	auipc	a0,0x9
ffffffffc020367a:	79250513          	addi	a0,a0,1938 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020367e:	dcdfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203682:	0000a697          	auipc	a3,0xa
ffffffffc0203686:	d3e68693          	addi	a3,a3,-706 # ffffffffc020d3c0 <etext+0x15ac>
ffffffffc020368a:	00009617          	auipc	a2,0x9
ffffffffc020368e:	bc660613          	addi	a2,a2,-1082 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203692:	29a00593          	li	a1,666
ffffffffc0203696:	00009517          	auipc	a0,0x9
ffffffffc020369a:	77250513          	addi	a0,a0,1906 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020369e:	dadfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036a2:	0000a697          	auipc	a3,0xa
ffffffffc02036a6:	d0668693          	addi	a3,a3,-762 # ffffffffc020d3a8 <etext+0x1594>
ffffffffc02036aa:	00009617          	auipc	a2,0x9
ffffffffc02036ae:	ba660613          	addi	a2,a2,-1114 # ffffffffc020c250 <etext+0x43c>
ffffffffc02036b2:	29900593          	li	a1,665
ffffffffc02036b6:	00009517          	auipc	a0,0x9
ffffffffc02036ba:	75250513          	addi	a0,a0,1874 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02036be:	d8dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036c2:	0000a697          	auipc	a3,0xa
ffffffffc02036c6:	bee68693          	addi	a3,a3,-1042 # ffffffffc020d2b0 <etext+0x149c>
ffffffffc02036ca:	00009617          	auipc	a2,0x9
ffffffffc02036ce:	b8660613          	addi	a2,a2,-1146 # ffffffffc020c250 <etext+0x43c>
ffffffffc02036d2:	28100593          	li	a1,641
ffffffffc02036d6:	00009517          	auipc	a0,0x9
ffffffffc02036da:	73250513          	addi	a0,a0,1842 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02036de:	d6dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036e2:	0000a697          	auipc	a3,0xa
ffffffffc02036e6:	b9e68693          	addi	a3,a3,-1122 # ffffffffc020d280 <etext+0x146c>
ffffffffc02036ea:	00009617          	auipc	a2,0x9
ffffffffc02036ee:	b6660613          	addi	a2,a2,-1178 # ffffffffc020c250 <etext+0x43c>
ffffffffc02036f2:	27900593          	li	a1,633
ffffffffc02036f6:	00009517          	auipc	a0,0x9
ffffffffc02036fa:	71250513          	addi	a0,a0,1810 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02036fe:	d4dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203702:	0000a697          	auipc	a3,0xa
ffffffffc0203706:	b3668693          	addi	a3,a3,-1226 # ffffffffc020d238 <etext+0x1424>
ffffffffc020370a:	00009617          	auipc	a2,0x9
ffffffffc020370e:	b4660613          	addi	a2,a2,-1210 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203712:	27700593          	li	a1,631
ffffffffc0203716:	00009517          	auipc	a0,0x9
ffffffffc020371a:	6f250513          	addi	a0,a0,1778 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020371e:	d2dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203722:	0000a697          	auipc	a3,0xa
ffffffffc0203726:	b4668693          	addi	a3,a3,-1210 # ffffffffc020d268 <etext+0x1454>
ffffffffc020372a:	00009617          	auipc	a2,0x9
ffffffffc020372e:	b2660613          	addi	a2,a2,-1242 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203732:	27600593          	li	a1,630
ffffffffc0203736:	00009517          	auipc	a0,0x9
ffffffffc020373a:	6d250513          	addi	a0,a0,1746 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020373e:	d0dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203742:	0000a697          	auipc	a3,0xa
ffffffffc0203746:	af668693          	addi	a3,a3,-1290 # ffffffffc020d238 <etext+0x1424>
ffffffffc020374a:	00009617          	auipc	a2,0x9
ffffffffc020374e:	b0660613          	addi	a2,a2,-1274 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203752:	27300593          	li	a1,627
ffffffffc0203756:	00009517          	auipc	a0,0x9
ffffffffc020375a:	6b250513          	addi	a0,a0,1714 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020375e:	cedfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203762:	0000a697          	auipc	a3,0xa
ffffffffc0203766:	97668693          	addi	a3,a3,-1674 # ffffffffc020d0d8 <etext+0x12c4>
ffffffffc020376a:	00009617          	auipc	a2,0x9
ffffffffc020376e:	ae660613          	addi	a2,a2,-1306 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203772:	27200593          	li	a1,626
ffffffffc0203776:	00009517          	auipc	a0,0x9
ffffffffc020377a:	69250513          	addi	a0,a0,1682 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020377e:	ccdfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203782:	0000a697          	auipc	a3,0xa
ffffffffc0203786:	ace68693          	addi	a3,a3,-1330 # ffffffffc020d250 <etext+0x143c>
ffffffffc020378a:	00009617          	auipc	a2,0x9
ffffffffc020378e:	ac660613          	addi	a2,a2,-1338 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203792:	26f00593          	li	a1,623
ffffffffc0203796:	00009517          	auipc	a0,0x9
ffffffffc020379a:	67250513          	addi	a0,a0,1650 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020379e:	cadfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037a2:	0000a697          	auipc	a3,0xa
ffffffffc02037a6:	91e68693          	addi	a3,a3,-1762 # ffffffffc020d0c0 <etext+0x12ac>
ffffffffc02037aa:	00009617          	auipc	a2,0x9
ffffffffc02037ae:	aa660613          	addi	a2,a2,-1370 # ffffffffc020c250 <etext+0x43c>
ffffffffc02037b2:	26e00593          	li	a1,622
ffffffffc02037b6:	00009517          	auipc	a0,0x9
ffffffffc02037ba:	65250513          	addi	a0,a0,1618 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02037be:	c8dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037c2:	00009617          	auipc	a2,0x9
ffffffffc02037c6:	5fe60613          	addi	a2,a2,1534 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02037ca:	08100593          	li	a1,129
ffffffffc02037ce:	00009517          	auipc	a0,0x9
ffffffffc02037d2:	63a50513          	addi	a0,a0,1594 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02037d6:	c75fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037da:	00009617          	auipc	a2,0x9
ffffffffc02037de:	53e60613          	addi	a2,a2,1342 # ffffffffc020cd18 <etext+0xf04>
ffffffffc02037e2:	07100593          	li	a1,113
ffffffffc02037e6:	00009517          	auipc	a0,0x9
ffffffffc02037ea:	55a50513          	addi	a0,a0,1370 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02037ee:	c5dfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037f2:	86a2                	mv	a3,s0
ffffffffc02037f4:	00009617          	auipc	a2,0x9
ffffffffc02037f8:	5cc60613          	addi	a2,a2,1484 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02037fc:	0ca00593          	li	a1,202
ffffffffc0203800:	00009517          	auipc	a0,0x9
ffffffffc0203804:	60850513          	addi	a0,a0,1544 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203808:	c43fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020380c:	00009617          	auipc	a2,0x9
ffffffffc0203810:	72c60613          	addi	a2,a2,1836 # ffffffffc020cf38 <etext+0x1124>
ffffffffc0203814:	0aa00593          	li	a1,170
ffffffffc0203818:	00009517          	auipc	a0,0x9
ffffffffc020381c:	5f050513          	addi	a0,a0,1520 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203820:	c2bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203824:	00009617          	auipc	a2,0x9
ffffffffc0203828:	67c60613          	addi	a2,a2,1660 # ffffffffc020cea0 <etext+0x108c>
ffffffffc020382c:	06500593          	li	a1,101
ffffffffc0203830:	00009517          	auipc	a0,0x9
ffffffffc0203834:	5d850513          	addi	a0,a0,1496 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203838:	c13fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020383c:	00009697          	auipc	a3,0x9
ffffffffc0203840:	7cc68693          	addi	a3,a3,1996 # ffffffffc020d008 <etext+0x11f4>
ffffffffc0203844:	00009617          	auipc	a2,0x9
ffffffffc0203848:	a0c60613          	addi	a2,a2,-1524 # ffffffffc020c250 <etext+0x43c>
ffffffffc020384c:	25300593          	li	a1,595
ffffffffc0203850:	00009517          	auipc	a0,0x9
ffffffffc0203854:	5b850513          	addi	a0,a0,1464 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203858:	bf3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020385c:	00009697          	auipc	a3,0x9
ffffffffc0203860:	76c68693          	addi	a3,a3,1900 # ffffffffc020cfc8 <etext+0x11b4>
ffffffffc0203864:	00009617          	auipc	a2,0x9
ffffffffc0203868:	9ec60613          	addi	a2,a2,-1556 # ffffffffc020c250 <etext+0x43c>
ffffffffc020386c:	25200593          	li	a1,594
ffffffffc0203870:	00009517          	auipc	a0,0x9
ffffffffc0203874:	59850513          	addi	a0,a0,1432 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203878:	bd3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020387c:	00009697          	auipc	a3,0x9
ffffffffc0203880:	72c68693          	addi	a3,a3,1836 # ffffffffc020cfa8 <etext+0x1194>
ffffffffc0203884:	00009617          	auipc	a2,0x9
ffffffffc0203888:	9cc60613          	addi	a2,a2,-1588 # ffffffffc020c250 <etext+0x43c>
ffffffffc020388c:	25100593          	li	a1,593
ffffffffc0203890:	00009517          	auipc	a0,0x9
ffffffffc0203894:	57850513          	addi	a0,a0,1400 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203898:	bb3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020389c:	0000a697          	auipc	a3,0xa
ffffffffc02038a0:	b9c68693          	addi	a3,a3,-1124 # ffffffffc020d438 <etext+0x1624>
ffffffffc02038a4:	00009617          	auipc	a2,0x9
ffffffffc02038a8:	9ac60613          	addi	a2,a2,-1620 # ffffffffc020c250 <etext+0x43c>
ffffffffc02038ac:	29f00593          	li	a1,671
ffffffffc02038b0:	00009517          	auipc	a0,0x9
ffffffffc02038b4:	55850513          	addi	a0,a0,1368 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02038b8:	b93fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038bc:	00009617          	auipc	a2,0x9
ffffffffc02038c0:	7dc60613          	addi	a2,a2,2012 # ffffffffc020d098 <etext+0x1284>
ffffffffc02038c4:	07f00593          	li	a1,127
ffffffffc02038c8:	00009517          	auipc	a0,0x9
ffffffffc02038cc:	47850513          	addi	a0,a0,1144 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02038d0:	b7bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038d4:	00009697          	auipc	a3,0x9
ffffffffc02038d8:	79468693          	addi	a3,a3,1940 # ffffffffc020d068 <etext+0x1254>
ffffffffc02038dc:	00009617          	auipc	a2,0x9
ffffffffc02038e0:	97460613          	addi	a2,a2,-1676 # ffffffffc020c250 <etext+0x43c>
ffffffffc02038e4:	25a00593          	li	a1,602
ffffffffc02038e8:	00009517          	auipc	a0,0x9
ffffffffc02038ec:	52050513          	addi	a0,a0,1312 # ffffffffc020ce08 <etext+0xff4>
ffffffffc02038f0:	b5bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02038f4:	00009697          	auipc	a3,0x9
ffffffffc02038f8:	74468693          	addi	a3,a3,1860 # ffffffffc020d038 <etext+0x1224>
ffffffffc02038fc:	00009617          	auipc	a2,0x9
ffffffffc0203900:	95460613          	addi	a2,a2,-1708 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203904:	25700593          	li	a1,599
ffffffffc0203908:	00009517          	auipc	a0,0x9
ffffffffc020390c:	50050513          	addi	a0,a0,1280 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203910:	b3bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203914:	86ca                	mv	a3,s2
ffffffffc0203916:	00009617          	auipc	a2,0x9
ffffffffc020391a:	4aa60613          	addi	a2,a2,1194 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc020391e:	0c600593          	li	a1,198
ffffffffc0203922:	00009517          	auipc	a0,0x9
ffffffffc0203926:	4e650513          	addi	a0,a0,1254 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020392a:	b21fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020392e:	0000a697          	auipc	a3,0xa
ffffffffc0203932:	90a68693          	addi	a3,a3,-1782 # ffffffffc020d238 <etext+0x1424>
ffffffffc0203936:	00009617          	auipc	a2,0x9
ffffffffc020393a:	91a60613          	addi	a2,a2,-1766 # ffffffffc020c250 <etext+0x43c>
ffffffffc020393e:	26c00593          	li	a1,620
ffffffffc0203942:	00009517          	auipc	a0,0x9
ffffffffc0203946:	4c650513          	addi	a0,a0,1222 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020394a:	b01fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020394e:	0000a697          	auipc	a3,0xa
ffffffffc0203952:	8d268693          	addi	a3,a3,-1838 # ffffffffc020d220 <etext+0x140c>
ffffffffc0203956:	00009617          	auipc	a2,0x9
ffffffffc020395a:	8fa60613          	addi	a2,a2,-1798 # ffffffffc020c250 <etext+0x43c>
ffffffffc020395e:	26b00593          	li	a1,619
ffffffffc0203962:	00009517          	auipc	a0,0x9
ffffffffc0203966:	4a650513          	addi	a0,a0,1190 # ffffffffc020ce08 <etext+0xff4>
ffffffffc020396a:	ae1fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020396e <copy_range>:
ffffffffc020396e:	7119                	addi	sp,sp,-128
ffffffffc0203970:	00d667b3          	or	a5,a2,a3
ffffffffc0203974:	e43a                	sd	a4,8(sp)
ffffffffc0203976:	fc86                	sd	ra,120(sp)
ffffffffc0203978:	f8a2                	sd	s0,112(sp)
ffffffffc020397a:	f4a6                	sd	s1,104(sp)
ffffffffc020397c:	f0ca                	sd	s2,96(sp)
ffffffffc020397e:	ecce                	sd	s3,88(sp)
ffffffffc0203980:	e8d2                	sd	s4,80(sp)
ffffffffc0203982:	e4d6                	sd	s5,72(sp)
ffffffffc0203984:	e0da                	sd	s6,64(sp)
ffffffffc0203986:	fc5e                	sd	s7,56(sp)
ffffffffc0203988:	f862                	sd	s8,48(sp)
ffffffffc020398a:	f466                	sd	s9,40(sp)
ffffffffc020398c:	f06a                	sd	s10,32(sp)
ffffffffc020398e:	ec6e                	sd	s11,24(sp)
ffffffffc0203990:	03479713          	slli	a4,a5,0x34
ffffffffc0203994:	26071263          	bnez	a4,ffffffffc0203bf8 <copy_range+0x28a>
ffffffffc0203998:	002007b7          	lui	a5,0x200
ffffffffc020399c:	00d63733          	sltu	a4,a2,a3
ffffffffc02039a0:	00f637b3          	sltu	a5,a2,a5
ffffffffc02039a4:	00173713          	seqz	a4,a4
ffffffffc02039a8:	8fd9                	or	a5,a5,a4
ffffffffc02039aa:	8432                	mv	s0,a2
ffffffffc02039ac:	8936                	mv	s2,a3
ffffffffc02039ae:	22079563          	bnez	a5,ffffffffc0203bd8 <copy_range+0x26a>
ffffffffc02039b2:	4785                	li	a5,1
ffffffffc02039b4:	07fe                	slli	a5,a5,0x1f
ffffffffc02039b6:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc02039b8:	22f6f063          	bgeu	a3,a5,ffffffffc0203bd8 <copy_range+0x26a>
ffffffffc02039bc:	5bfd                	li	s7,-1
ffffffffc02039be:	8a2a                	mv	s4,a0
ffffffffc02039c0:	84ae                	mv	s1,a1
ffffffffc02039c2:	6985                	lui	s3,0x1
ffffffffc02039c4:	00cbdb93          	srli	s7,s7,0xc
ffffffffc02039c8:	00093b17          	auipc	s6,0x93
ffffffffc02039cc:	ee8b0b13          	addi	s6,s6,-280 # ffffffffc02968b0 <npage>
ffffffffc02039d0:	00093a97          	auipc	s5,0x93
ffffffffc02039d4:	ee8a8a93          	addi	s5,s5,-280 # ffffffffc02968b8 <pages>
ffffffffc02039d8:	fff80c37          	lui	s8,0xfff80
ffffffffc02039dc:	4601                	li	a2,0
ffffffffc02039de:	85a2                	mv	a1,s0
ffffffffc02039e0:	8526                	mv	a0,s1
ffffffffc02039e2:	887fe0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc02039e6:	8d2a                	mv	s10,a0
ffffffffc02039e8:	c561                	beqz	a0,ffffffffc0203ab0 <copy_range+0x142>
ffffffffc02039ea:	611c                	ld	a5,0(a0)
ffffffffc02039ec:	8b85                	andi	a5,a5,1
ffffffffc02039ee:	e78d                	bnez	a5,ffffffffc0203a18 <copy_range+0xaa>
ffffffffc02039f0:	944e                	add	s0,s0,s3
ffffffffc02039f2:	c019                	beqz	s0,ffffffffc02039f8 <copy_range+0x8a>
ffffffffc02039f4:	ff2464e3          	bltu	s0,s2,ffffffffc02039dc <copy_range+0x6e>
ffffffffc02039f8:	4501                	li	a0,0
ffffffffc02039fa:	70e6                	ld	ra,120(sp)
ffffffffc02039fc:	7446                	ld	s0,112(sp)
ffffffffc02039fe:	74a6                	ld	s1,104(sp)
ffffffffc0203a00:	7906                	ld	s2,96(sp)
ffffffffc0203a02:	69e6                	ld	s3,88(sp)
ffffffffc0203a04:	6a46                	ld	s4,80(sp)
ffffffffc0203a06:	6aa6                	ld	s5,72(sp)
ffffffffc0203a08:	6b06                	ld	s6,64(sp)
ffffffffc0203a0a:	7be2                	ld	s7,56(sp)
ffffffffc0203a0c:	7c42                	ld	s8,48(sp)
ffffffffc0203a0e:	7ca2                	ld	s9,40(sp)
ffffffffc0203a10:	7d02                	ld	s10,32(sp)
ffffffffc0203a12:	6de2                	ld	s11,24(sp)
ffffffffc0203a14:	6109                	addi	sp,sp,128
ffffffffc0203a16:	8082                	ret
ffffffffc0203a18:	4605                	li	a2,1
ffffffffc0203a1a:	85a2                	mv	a1,s0
ffffffffc0203a1c:	8552                	mv	a0,s4
ffffffffc0203a1e:	84bfe0ef          	jal	ffffffffc0202268 <get_pte>
ffffffffc0203a22:	10050863          	beqz	a0,ffffffffc0203b32 <copy_range+0x1c4>
ffffffffc0203a26:	000d3d83          	ld	s11,0(s10)
ffffffffc0203a2a:	001df793          	andi	a5,s11,1
ffffffffc0203a2e:	12078463          	beqz	a5,ffffffffc0203b56 <copy_range+0x1e8>
ffffffffc0203a32:	000b3703          	ld	a4,0(s6)
ffffffffc0203a36:	002d9793          	slli	a5,s11,0x2
ffffffffc0203a3a:	83b1                	srli	a5,a5,0xc
ffffffffc0203a3c:	14e7f963          	bgeu	a5,a4,ffffffffc0203b8e <copy_range+0x220>
ffffffffc0203a40:	000abd03          	ld	s10,0(s5)
ffffffffc0203a44:	97e2                	add	a5,a5,s8
ffffffffc0203a46:	079a                	slli	a5,a5,0x6
ffffffffc0203a48:	9d3e                	add	s10,s10,a5
ffffffffc0203a4a:	100027f3          	csrr	a5,sstatus
ffffffffc0203a4e:	8b89                	andi	a5,a5,2
ffffffffc0203a50:	e7e1                	bnez	a5,ffffffffc0203b18 <copy_range+0x1aa>
ffffffffc0203a52:	00093797          	auipc	a5,0x93
ffffffffc0203a56:	e3e7b783          	ld	a5,-450(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0203a5a:	4505                	li	a0,1
ffffffffc0203a5c:	6f9c                	ld	a5,24(a5)
ffffffffc0203a5e:	9782                	jalr	a5
ffffffffc0203a60:	8caa                	mv	s9,a0
ffffffffc0203a62:	100d0663          	beqz	s10,ffffffffc0203b6e <copy_range+0x200>
ffffffffc0203a66:	0c0c8863          	beqz	s9,ffffffffc0203b36 <copy_range+0x1c8>
ffffffffc0203a6a:	67a2                	ld	a5,8(sp)
ffffffffc0203a6c:	cba9                	beqz	a5,ffffffffc0203abe <copy_range+0x150>
ffffffffc0203a6e:	01bdfd93          	andi	s11,s11,27
ffffffffc0203a72:	100de693          	ori	a3,s11,256
ffffffffc0203a76:	8622                	mv	a2,s0
ffffffffc0203a78:	85ea                	mv	a1,s10
ffffffffc0203a7a:	8526                	mv	a0,s1
ffffffffc0203a7c:	febfe0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203a80:	100de693          	ori	a3,s11,256
ffffffffc0203a84:	8622                	mv	a2,s0
ffffffffc0203a86:	85ea                	mv	a1,s10
ffffffffc0203a88:	8552                	mv	a0,s4
ffffffffc0203a8a:	fddfe0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203a8e:	d12d                	beqz	a0,ffffffffc02039f0 <copy_range+0x82>
ffffffffc0203a90:	0000a697          	auipc	a3,0xa
ffffffffc0203a94:	a4868693          	addi	a3,a3,-1464 # ffffffffc020d4d8 <etext+0x16c4>
ffffffffc0203a98:	00008617          	auipc	a2,0x8
ffffffffc0203a9c:	7b860613          	addi	a2,a2,1976 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203aa0:	1ef00593          	li	a1,495
ffffffffc0203aa4:	00009517          	auipc	a0,0x9
ffffffffc0203aa8:	36450513          	addi	a0,a0,868 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203aac:	99ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203ab0:	002007b7          	lui	a5,0x200
ffffffffc0203ab4:	97a2                	add	a5,a5,s0
ffffffffc0203ab6:	ffe00437          	lui	s0,0xffe00
ffffffffc0203aba:	8c7d                	and	s0,s0,a5
ffffffffc0203abc:	bf1d                	j	ffffffffc02039f2 <copy_range+0x84>
ffffffffc0203abe:	000ab783          	ld	a5,0(s5)
ffffffffc0203ac2:	000805b7          	lui	a1,0x80
ffffffffc0203ac6:	000b3603          	ld	a2,0(s6)
ffffffffc0203aca:	40fd0d33          	sub	s10,s10,a5
ffffffffc0203ace:	406d5d13          	srai	s10,s10,0x6
ffffffffc0203ad2:	9d2e                	add	s10,s10,a1
ffffffffc0203ad4:	017d76b3          	and	a3,s10,s7
ffffffffc0203ad8:	0d32                	slli	s10,s10,0xc
ffffffffc0203ada:	0ec6f263          	bgeu	a3,a2,ffffffffc0203bbe <copy_range+0x250>
ffffffffc0203ade:	40fc86b3          	sub	a3,s9,a5
ffffffffc0203ae2:	8699                	srai	a3,a3,0x6
ffffffffc0203ae4:	96ae                	add	a3,a3,a1
ffffffffc0203ae6:	0176f7b3          	and	a5,a3,s7
ffffffffc0203aea:	06b2                	slli	a3,a3,0xc
ffffffffc0203aec:	0ac7fd63          	bgeu	a5,a2,ffffffffc0203ba6 <copy_range+0x238>
ffffffffc0203af0:	00093517          	auipc	a0,0x93
ffffffffc0203af4:	db853503          	ld	a0,-584(a0) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0203af8:	6605                	lui	a2,0x1
ffffffffc0203afa:	00ad05b3          	add	a1,s10,a0
ffffffffc0203afe:	9536                	add	a0,a0,a3
ffffffffc0203b00:	2fc080ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0203b04:	01fdf693          	andi	a3,s11,31
ffffffffc0203b08:	85e6                	mv	a1,s9
ffffffffc0203b0a:	8622                	mv	a2,s0
ffffffffc0203b0c:	8552                	mv	a0,s4
ffffffffc0203b0e:	f59fe0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203b12:	ec050fe3          	beqz	a0,ffffffffc02039f0 <copy_range+0x82>
ffffffffc0203b16:	bfad                	j	ffffffffc0203a90 <copy_range+0x122>
ffffffffc0203b18:	8c0fd0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203b1c:	00093797          	auipc	a5,0x93
ffffffffc0203b20:	d747b783          	ld	a5,-652(a5) # ffffffffc0296890 <pmm_manager>
ffffffffc0203b24:	4505                	li	a0,1
ffffffffc0203b26:	6f9c                	ld	a5,24(a5)
ffffffffc0203b28:	9782                	jalr	a5
ffffffffc0203b2a:	8caa                	mv	s9,a0
ffffffffc0203b2c:	8a6fd0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203b30:	bf0d                	j	ffffffffc0203a62 <copy_range+0xf4>
ffffffffc0203b32:	5571                	li	a0,-4
ffffffffc0203b34:	b5d9                	j	ffffffffc02039fa <copy_range+0x8c>
ffffffffc0203b36:	0000a697          	auipc	a3,0xa
ffffffffc0203b3a:	99268693          	addi	a3,a3,-1646 # ffffffffc020d4c8 <etext+0x16b4>
ffffffffc0203b3e:	00008617          	auipc	a2,0x8
ffffffffc0203b42:	71260613          	addi	a2,a2,1810 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203b46:	1cf00593          	li	a1,463
ffffffffc0203b4a:	00009517          	auipc	a0,0x9
ffffffffc0203b4e:	2be50513          	addi	a0,a0,702 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203b52:	8f9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b56:	00009617          	auipc	a2,0x9
ffffffffc0203b5a:	54260613          	addi	a2,a2,1346 # ffffffffc020d098 <etext+0x1284>
ffffffffc0203b5e:	07f00593          	li	a1,127
ffffffffc0203b62:	00009517          	auipc	a0,0x9
ffffffffc0203b66:	1de50513          	addi	a0,a0,478 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0203b6a:	8e1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b6e:	0000a697          	auipc	a3,0xa
ffffffffc0203b72:	94a68693          	addi	a3,a3,-1718 # ffffffffc020d4b8 <etext+0x16a4>
ffffffffc0203b76:	00008617          	auipc	a2,0x8
ffffffffc0203b7a:	6da60613          	addi	a2,a2,1754 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203b7e:	1ce00593          	li	a1,462
ffffffffc0203b82:	00009517          	auipc	a0,0x9
ffffffffc0203b86:	28650513          	addi	a0,a0,646 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203b8a:	8c1fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b8e:	00009617          	auipc	a2,0x9
ffffffffc0203b92:	25a60613          	addi	a2,a2,602 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc0203b96:	06900593          	li	a1,105
ffffffffc0203b9a:	00009517          	auipc	a0,0x9
ffffffffc0203b9e:	1a650513          	addi	a0,a0,422 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0203ba2:	8a9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203ba6:	00009617          	auipc	a2,0x9
ffffffffc0203baa:	17260613          	addi	a2,a2,370 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0203bae:	07100593          	li	a1,113
ffffffffc0203bb2:	00009517          	auipc	a0,0x9
ffffffffc0203bb6:	18e50513          	addi	a0,a0,398 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0203bba:	891fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203bbe:	86ea                	mv	a3,s10
ffffffffc0203bc0:	00009617          	auipc	a2,0x9
ffffffffc0203bc4:	15860613          	addi	a2,a2,344 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0203bc8:	07100593          	li	a1,113
ffffffffc0203bcc:	00009517          	auipc	a0,0x9
ffffffffc0203bd0:	17450513          	addi	a0,a0,372 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0203bd4:	877fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203bd8:	00009697          	auipc	a3,0x9
ffffffffc0203bdc:	29868693          	addi	a3,a3,664 # ffffffffc020ce70 <etext+0x105c>
ffffffffc0203be0:	00008617          	auipc	a2,0x8
ffffffffc0203be4:	67060613          	addi	a2,a2,1648 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203be8:	1b600593          	li	a1,438
ffffffffc0203bec:	00009517          	auipc	a0,0x9
ffffffffc0203bf0:	21c50513          	addi	a0,a0,540 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203bf4:	857fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203bf8:	00009697          	auipc	a3,0x9
ffffffffc0203bfc:	24868693          	addi	a3,a3,584 # ffffffffc020ce40 <etext+0x102c>
ffffffffc0203c00:	00008617          	auipc	a2,0x8
ffffffffc0203c04:	65060613          	addi	a2,a2,1616 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203c08:	1b500593          	li	a1,437
ffffffffc0203c0c:	00009517          	auipc	a0,0x9
ffffffffc0203c10:	1fc50513          	addi	a0,a0,508 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203c14:	837fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203c18 <pgdir_alloc_page>:
ffffffffc0203c18:	7139                	addi	sp,sp,-64
ffffffffc0203c1a:	f426                	sd	s1,40(sp)
ffffffffc0203c1c:	f04a                	sd	s2,32(sp)
ffffffffc0203c1e:	ec4e                	sd	s3,24(sp)
ffffffffc0203c20:	fc06                	sd	ra,56(sp)
ffffffffc0203c22:	f822                	sd	s0,48(sp)
ffffffffc0203c24:	892a                	mv	s2,a0
ffffffffc0203c26:	84ae                	mv	s1,a1
ffffffffc0203c28:	89b2                	mv	s3,a2
ffffffffc0203c2a:	100027f3          	csrr	a5,sstatus
ffffffffc0203c2e:	8b89                	andi	a5,a5,2
ffffffffc0203c30:	ebb5                	bnez	a5,ffffffffc0203ca4 <pgdir_alloc_page+0x8c>
ffffffffc0203c32:	00093417          	auipc	s0,0x93
ffffffffc0203c36:	c5e40413          	addi	s0,s0,-930 # ffffffffc0296890 <pmm_manager>
ffffffffc0203c3a:	601c                	ld	a5,0(s0)
ffffffffc0203c3c:	4505                	li	a0,1
ffffffffc0203c3e:	6f9c                	ld	a5,24(a5)
ffffffffc0203c40:	9782                	jalr	a5
ffffffffc0203c42:	85aa                	mv	a1,a0
ffffffffc0203c44:	c5b9                	beqz	a1,ffffffffc0203c92 <pgdir_alloc_page+0x7a>
ffffffffc0203c46:	86ce                	mv	a3,s3
ffffffffc0203c48:	854a                	mv	a0,s2
ffffffffc0203c4a:	8626                	mv	a2,s1
ffffffffc0203c4c:	e42e                	sd	a1,8(sp)
ffffffffc0203c4e:	e19fe0ef          	jal	ffffffffc0202a66 <page_insert>
ffffffffc0203c52:	65a2                	ld	a1,8(sp)
ffffffffc0203c54:	e515                	bnez	a0,ffffffffc0203c80 <pgdir_alloc_page+0x68>
ffffffffc0203c56:	4198                	lw	a4,0(a1)
ffffffffc0203c58:	fd84                	sd	s1,56(a1)
ffffffffc0203c5a:	4785                	li	a5,1
ffffffffc0203c5c:	02f70c63          	beq	a4,a5,ffffffffc0203c94 <pgdir_alloc_page+0x7c>
ffffffffc0203c60:	0000a697          	auipc	a3,0xa
ffffffffc0203c64:	88868693          	addi	a3,a3,-1912 # ffffffffc020d4e8 <etext+0x16d4>
ffffffffc0203c68:	00008617          	auipc	a2,0x8
ffffffffc0203c6c:	5e860613          	addi	a2,a2,1512 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203c70:	23800593          	li	a1,568
ffffffffc0203c74:	00009517          	auipc	a0,0x9
ffffffffc0203c78:	19450513          	addi	a0,a0,404 # ffffffffc020ce08 <etext+0xff4>
ffffffffc0203c7c:	fcefc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203c80:	100027f3          	csrr	a5,sstatus
ffffffffc0203c84:	8b89                	andi	a5,a5,2
ffffffffc0203c86:	ef95                	bnez	a5,ffffffffc0203cc2 <pgdir_alloc_page+0xaa>
ffffffffc0203c88:	601c                	ld	a5,0(s0)
ffffffffc0203c8a:	852e                	mv	a0,a1
ffffffffc0203c8c:	4585                	li	a1,1
ffffffffc0203c8e:	739c                	ld	a5,32(a5)
ffffffffc0203c90:	9782                	jalr	a5
ffffffffc0203c92:	4581                	li	a1,0
ffffffffc0203c94:	70e2                	ld	ra,56(sp)
ffffffffc0203c96:	7442                	ld	s0,48(sp)
ffffffffc0203c98:	74a2                	ld	s1,40(sp)
ffffffffc0203c9a:	7902                	ld	s2,32(sp)
ffffffffc0203c9c:	69e2                	ld	s3,24(sp)
ffffffffc0203c9e:	852e                	mv	a0,a1
ffffffffc0203ca0:	6121                	addi	sp,sp,64
ffffffffc0203ca2:	8082                	ret
ffffffffc0203ca4:	f35fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203ca8:	00093417          	auipc	s0,0x93
ffffffffc0203cac:	be840413          	addi	s0,s0,-1048 # ffffffffc0296890 <pmm_manager>
ffffffffc0203cb0:	601c                	ld	a5,0(s0)
ffffffffc0203cb2:	4505                	li	a0,1
ffffffffc0203cb4:	6f9c                	ld	a5,24(a5)
ffffffffc0203cb6:	9782                	jalr	a5
ffffffffc0203cb8:	e42a                	sd	a0,8(sp)
ffffffffc0203cba:	f19fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203cbe:	65a2                	ld	a1,8(sp)
ffffffffc0203cc0:	b751                	j	ffffffffc0203c44 <pgdir_alloc_page+0x2c>
ffffffffc0203cc2:	f17fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0203cc6:	601c                	ld	a5,0(s0)
ffffffffc0203cc8:	6522                	ld	a0,8(sp)
ffffffffc0203cca:	4585                	li	a1,1
ffffffffc0203ccc:	739c                	ld	a5,32(a5)
ffffffffc0203cce:	9782                	jalr	a5
ffffffffc0203cd0:	f03fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0203cd4:	bf7d                	j	ffffffffc0203c92 <pgdir_alloc_page+0x7a>

ffffffffc0203cd6 <check_vma_overlap.part.0>:
ffffffffc0203cd6:	1141                	addi	sp,sp,-16
ffffffffc0203cd8:	0000a697          	auipc	a3,0xa
ffffffffc0203cdc:	82868693          	addi	a3,a3,-2008 # ffffffffc020d500 <etext+0x16ec>
ffffffffc0203ce0:	00008617          	auipc	a2,0x8
ffffffffc0203ce4:	57060613          	addi	a2,a2,1392 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203ce8:	07400593          	li	a1,116
ffffffffc0203cec:	0000a517          	auipc	a0,0xa
ffffffffc0203cf0:	83450513          	addi	a0,a0,-1996 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203cf4:	e406                	sd	ra,8(sp)
ffffffffc0203cf6:	f54fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203cfa <mm_create>:
ffffffffc0203cfa:	1101                	addi	sp,sp,-32
ffffffffc0203cfc:	05800513          	li	a0,88
ffffffffc0203d00:	ec06                	sd	ra,24(sp)
ffffffffc0203d02:	afafe0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0203d06:	87aa                	mv	a5,a0
ffffffffc0203d08:	c505                	beqz	a0,ffffffffc0203d30 <mm_create+0x36>
ffffffffc0203d0a:	e788                	sd	a0,8(a5)
ffffffffc0203d0c:	e388                	sd	a0,0(a5)
ffffffffc0203d0e:	00053823          	sd	zero,16(a0)
ffffffffc0203d12:	00053c23          	sd	zero,24(a0)
ffffffffc0203d16:	02052023          	sw	zero,32(a0)
ffffffffc0203d1a:	02053423          	sd	zero,40(a0)
ffffffffc0203d1e:	02052823          	sw	zero,48(a0)
ffffffffc0203d22:	4585                	li	a1,1
ffffffffc0203d24:	03850513          	addi	a0,a0,56
ffffffffc0203d28:	e43e                	sd	a5,8(sp)
ffffffffc0203d2a:	147000ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc0203d2e:	67a2                	ld	a5,8(sp)
ffffffffc0203d30:	60e2                	ld	ra,24(sp)
ffffffffc0203d32:	853e                	mv	a0,a5
ffffffffc0203d34:	6105                	addi	sp,sp,32
ffffffffc0203d36:	8082                	ret

ffffffffc0203d38 <find_vma>:
ffffffffc0203d38:	c505                	beqz	a0,ffffffffc0203d60 <find_vma+0x28>
ffffffffc0203d3a:	691c                	ld	a5,16(a0)
ffffffffc0203d3c:	c781                	beqz	a5,ffffffffc0203d44 <find_vma+0xc>
ffffffffc0203d3e:	6798                	ld	a4,8(a5)
ffffffffc0203d40:	02e5f363          	bgeu	a1,a4,ffffffffc0203d66 <find_vma+0x2e>
ffffffffc0203d44:	651c                	ld	a5,8(a0)
ffffffffc0203d46:	00f50d63          	beq	a0,a5,ffffffffc0203d60 <find_vma+0x28>
ffffffffc0203d4a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d4e:	00e5e663          	bltu	a1,a4,ffffffffc0203d5a <find_vma+0x22>
ffffffffc0203d52:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203d56:	00e5ee63          	bltu	a1,a4,ffffffffc0203d72 <find_vma+0x3a>
ffffffffc0203d5a:	679c                	ld	a5,8(a5)
ffffffffc0203d5c:	fef517e3          	bne	a0,a5,ffffffffc0203d4a <find_vma+0x12>
ffffffffc0203d60:	4781                	li	a5,0
ffffffffc0203d62:	853e                	mv	a0,a5
ffffffffc0203d64:	8082                	ret
ffffffffc0203d66:	6b98                	ld	a4,16(a5)
ffffffffc0203d68:	fce5fee3          	bgeu	a1,a4,ffffffffc0203d44 <find_vma+0xc>
ffffffffc0203d6c:	e91c                	sd	a5,16(a0)
ffffffffc0203d6e:	853e                	mv	a0,a5
ffffffffc0203d70:	8082                	ret
ffffffffc0203d72:	1781                	addi	a5,a5,-32
ffffffffc0203d74:	e91c                	sd	a5,16(a0)
ffffffffc0203d76:	bfe5                	j	ffffffffc0203d6e <find_vma+0x36>

ffffffffc0203d78 <insert_vma_struct>:
ffffffffc0203d78:	6590                	ld	a2,8(a1)
ffffffffc0203d7a:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0203d7e:	1141                	addi	sp,sp,-16
ffffffffc0203d80:	e406                	sd	ra,8(sp)
ffffffffc0203d82:	87aa                	mv	a5,a0
ffffffffc0203d84:	01066763          	bltu	a2,a6,ffffffffc0203d92 <insert_vma_struct+0x1a>
ffffffffc0203d88:	a8b9                	j	ffffffffc0203de6 <insert_vma_struct+0x6e>
ffffffffc0203d8a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d8e:	04e66763          	bltu	a2,a4,ffffffffc0203ddc <insert_vma_struct+0x64>
ffffffffc0203d92:	86be                	mv	a3,a5
ffffffffc0203d94:	679c                	ld	a5,8(a5)
ffffffffc0203d96:	fef51ae3          	bne	a0,a5,ffffffffc0203d8a <insert_vma_struct+0x12>
ffffffffc0203d9a:	02a68463          	beq	a3,a0,ffffffffc0203dc2 <insert_vma_struct+0x4a>
ffffffffc0203d9e:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203da2:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203da6:	08e8f063          	bgeu	a7,a4,ffffffffc0203e26 <insert_vma_struct+0xae>
ffffffffc0203daa:	04e66e63          	bltu	a2,a4,ffffffffc0203e06 <insert_vma_struct+0x8e>
ffffffffc0203dae:	00f50a63          	beq	a0,a5,ffffffffc0203dc2 <insert_vma_struct+0x4a>
ffffffffc0203db2:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203db6:	05076863          	bltu	a4,a6,ffffffffc0203e06 <insert_vma_struct+0x8e>
ffffffffc0203dba:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203dbe:	02c77263          	bgeu	a4,a2,ffffffffc0203de2 <insert_vma_struct+0x6a>
ffffffffc0203dc2:	5118                	lw	a4,32(a0)
ffffffffc0203dc4:	e188                	sd	a0,0(a1)
ffffffffc0203dc6:	02058613          	addi	a2,a1,32
ffffffffc0203dca:	e390                	sd	a2,0(a5)
ffffffffc0203dcc:	e690                	sd	a2,8(a3)
ffffffffc0203dce:	60a2                	ld	ra,8(sp)
ffffffffc0203dd0:	f59c                	sd	a5,40(a1)
ffffffffc0203dd2:	f194                	sd	a3,32(a1)
ffffffffc0203dd4:	2705                	addiw	a4,a4,1
ffffffffc0203dd6:	d118                	sw	a4,32(a0)
ffffffffc0203dd8:	0141                	addi	sp,sp,16
ffffffffc0203dda:	8082                	ret
ffffffffc0203ddc:	fca691e3          	bne	a3,a0,ffffffffc0203d9e <insert_vma_struct+0x26>
ffffffffc0203de0:	bfd9                	j	ffffffffc0203db6 <insert_vma_struct+0x3e>
ffffffffc0203de2:	ef5ff0ef          	jal	ffffffffc0203cd6 <check_vma_overlap.part.0>
ffffffffc0203de6:	00009697          	auipc	a3,0x9
ffffffffc0203dea:	74a68693          	addi	a3,a3,1866 # ffffffffc020d530 <etext+0x171c>
ffffffffc0203dee:	00008617          	auipc	a2,0x8
ffffffffc0203df2:	46260613          	addi	a2,a2,1122 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203df6:	07a00593          	li	a1,122
ffffffffc0203dfa:	00009517          	auipc	a0,0x9
ffffffffc0203dfe:	72650513          	addi	a0,a0,1830 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203e02:	e48fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203e06:	00009697          	auipc	a3,0x9
ffffffffc0203e0a:	76a68693          	addi	a3,a3,1898 # ffffffffc020d570 <etext+0x175c>
ffffffffc0203e0e:	00008617          	auipc	a2,0x8
ffffffffc0203e12:	44260613          	addi	a2,a2,1090 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203e16:	07300593          	li	a1,115
ffffffffc0203e1a:	00009517          	auipc	a0,0x9
ffffffffc0203e1e:	70650513          	addi	a0,a0,1798 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203e22:	e28fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203e26:	00009697          	auipc	a3,0x9
ffffffffc0203e2a:	72a68693          	addi	a3,a3,1834 # ffffffffc020d550 <etext+0x173c>
ffffffffc0203e2e:	00008617          	auipc	a2,0x8
ffffffffc0203e32:	42260613          	addi	a2,a2,1058 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203e36:	07200593          	li	a1,114
ffffffffc0203e3a:	00009517          	auipc	a0,0x9
ffffffffc0203e3e:	6e650513          	addi	a0,a0,1766 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203e42:	e08fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203e46 <mm_destroy>:
ffffffffc0203e46:	591c                	lw	a5,48(a0)
ffffffffc0203e48:	1141                	addi	sp,sp,-16
ffffffffc0203e4a:	e406                	sd	ra,8(sp)
ffffffffc0203e4c:	e022                	sd	s0,0(sp)
ffffffffc0203e4e:	e78d                	bnez	a5,ffffffffc0203e78 <mm_destroy+0x32>
ffffffffc0203e50:	842a                	mv	s0,a0
ffffffffc0203e52:	6508                	ld	a0,8(a0)
ffffffffc0203e54:	00a40c63          	beq	s0,a0,ffffffffc0203e6c <mm_destroy+0x26>
ffffffffc0203e58:	6118                	ld	a4,0(a0)
ffffffffc0203e5a:	651c                	ld	a5,8(a0)
ffffffffc0203e5c:	1501                	addi	a0,a0,-32
ffffffffc0203e5e:	e71c                	sd	a5,8(a4)
ffffffffc0203e60:	e398                	sd	a4,0(a5)
ffffffffc0203e62:	a40fe0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0203e66:	6408                	ld	a0,8(s0)
ffffffffc0203e68:	fea418e3          	bne	s0,a0,ffffffffc0203e58 <mm_destroy+0x12>
ffffffffc0203e6c:	8522                	mv	a0,s0
ffffffffc0203e6e:	6402                	ld	s0,0(sp)
ffffffffc0203e70:	60a2                	ld	ra,8(sp)
ffffffffc0203e72:	0141                	addi	sp,sp,16
ffffffffc0203e74:	a2efe06f          	j	ffffffffc02020a2 <kfree>
ffffffffc0203e78:	00009697          	auipc	a3,0x9
ffffffffc0203e7c:	71868693          	addi	a3,a3,1816 # ffffffffc020d590 <etext+0x177c>
ffffffffc0203e80:	00008617          	auipc	a2,0x8
ffffffffc0203e84:	3d060613          	addi	a2,a2,976 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203e88:	09e00593          	li	a1,158
ffffffffc0203e8c:	00009517          	auipc	a0,0x9
ffffffffc0203e90:	69450513          	addi	a0,a0,1684 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203e94:	db6fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203e98 <mm_map>:
ffffffffc0203e98:	6785                	lui	a5,0x1
ffffffffc0203e9a:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203e9c:	963e                	add	a2,a2,a5
ffffffffc0203e9e:	4785                	li	a5,1
ffffffffc0203ea0:	7139                	addi	sp,sp,-64
ffffffffc0203ea2:	962e                	add	a2,a2,a1
ffffffffc0203ea4:	787d                	lui	a6,0xfffff
ffffffffc0203ea6:	07fe                	slli	a5,a5,0x1f
ffffffffc0203ea8:	f822                	sd	s0,48(sp)
ffffffffc0203eaa:	f426                	sd	s1,40(sp)
ffffffffc0203eac:	01067433          	and	s0,a2,a6
ffffffffc0203eb0:	0105f4b3          	and	s1,a1,a6
ffffffffc0203eb4:	0785                	addi	a5,a5,1
ffffffffc0203eb6:	0084b633          	sltu	a2,s1,s0
ffffffffc0203eba:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203ebe:	00163613          	seqz	a2,a2
ffffffffc0203ec2:	0017b793          	seqz	a5,a5
ffffffffc0203ec6:	fc06                	sd	ra,56(sp)
ffffffffc0203ec8:	8fd1                	or	a5,a5,a2
ffffffffc0203eca:	ebbd                	bnez	a5,ffffffffc0203f40 <mm_map+0xa8>
ffffffffc0203ecc:	002007b7          	lui	a5,0x200
ffffffffc0203ed0:	06f4e863          	bltu	s1,a5,ffffffffc0203f40 <mm_map+0xa8>
ffffffffc0203ed4:	f04a                	sd	s2,32(sp)
ffffffffc0203ed6:	ec4e                	sd	s3,24(sp)
ffffffffc0203ed8:	e852                	sd	s4,16(sp)
ffffffffc0203eda:	892a                	mv	s2,a0
ffffffffc0203edc:	89ba                	mv	s3,a4
ffffffffc0203ede:	8a36                	mv	s4,a3
ffffffffc0203ee0:	c135                	beqz	a0,ffffffffc0203f44 <mm_map+0xac>
ffffffffc0203ee2:	85a6                	mv	a1,s1
ffffffffc0203ee4:	e55ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc0203ee8:	c501                	beqz	a0,ffffffffc0203ef0 <mm_map+0x58>
ffffffffc0203eea:	651c                	ld	a5,8(a0)
ffffffffc0203eec:	0487e763          	bltu	a5,s0,ffffffffc0203f3a <mm_map+0xa2>
ffffffffc0203ef0:	03000513          	li	a0,48
ffffffffc0203ef4:	908fe0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0203ef8:	85aa                	mv	a1,a0
ffffffffc0203efa:	5571                	li	a0,-4
ffffffffc0203efc:	c59d                	beqz	a1,ffffffffc0203f2a <mm_map+0x92>
ffffffffc0203efe:	e584                	sd	s1,8(a1)
ffffffffc0203f00:	e980                	sd	s0,16(a1)
ffffffffc0203f02:	0145ac23          	sw	s4,24(a1)
ffffffffc0203f06:	854a                	mv	a0,s2
ffffffffc0203f08:	e42e                	sd	a1,8(sp)
ffffffffc0203f0a:	e6fff0ef          	jal	ffffffffc0203d78 <insert_vma_struct>
ffffffffc0203f0e:	65a2                	ld	a1,8(sp)
ffffffffc0203f10:	00098463          	beqz	s3,ffffffffc0203f18 <mm_map+0x80>
ffffffffc0203f14:	00b9b023          	sd	a1,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203f18:	7902                	ld	s2,32(sp)
ffffffffc0203f1a:	69e2                	ld	s3,24(sp)
ffffffffc0203f1c:	6a42                	ld	s4,16(sp)
ffffffffc0203f1e:	4501                	li	a0,0
ffffffffc0203f20:	70e2                	ld	ra,56(sp)
ffffffffc0203f22:	7442                	ld	s0,48(sp)
ffffffffc0203f24:	74a2                	ld	s1,40(sp)
ffffffffc0203f26:	6121                	addi	sp,sp,64
ffffffffc0203f28:	8082                	ret
ffffffffc0203f2a:	70e2                	ld	ra,56(sp)
ffffffffc0203f2c:	7442                	ld	s0,48(sp)
ffffffffc0203f2e:	7902                	ld	s2,32(sp)
ffffffffc0203f30:	69e2                	ld	s3,24(sp)
ffffffffc0203f32:	6a42                	ld	s4,16(sp)
ffffffffc0203f34:	74a2                	ld	s1,40(sp)
ffffffffc0203f36:	6121                	addi	sp,sp,64
ffffffffc0203f38:	8082                	ret
ffffffffc0203f3a:	7902                	ld	s2,32(sp)
ffffffffc0203f3c:	69e2                	ld	s3,24(sp)
ffffffffc0203f3e:	6a42                	ld	s4,16(sp)
ffffffffc0203f40:	5575                	li	a0,-3
ffffffffc0203f42:	bff9                	j	ffffffffc0203f20 <mm_map+0x88>
ffffffffc0203f44:	00009697          	auipc	a3,0x9
ffffffffc0203f48:	66468693          	addi	a3,a3,1636 # ffffffffc020d5a8 <etext+0x1794>
ffffffffc0203f4c:	00008617          	auipc	a2,0x8
ffffffffc0203f50:	30460613          	addi	a2,a2,772 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203f54:	0b300593          	li	a1,179
ffffffffc0203f58:	00009517          	auipc	a0,0x9
ffffffffc0203f5c:	5c850513          	addi	a0,a0,1480 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203f60:	ceafc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203f64 <dup_mmap>:
ffffffffc0203f64:	7139                	addi	sp,sp,-64
ffffffffc0203f66:	fc06                	sd	ra,56(sp)
ffffffffc0203f68:	f822                	sd	s0,48(sp)
ffffffffc0203f6a:	f426                	sd	s1,40(sp)
ffffffffc0203f6c:	f04a                	sd	s2,32(sp)
ffffffffc0203f6e:	ec4e                	sd	s3,24(sp)
ffffffffc0203f70:	e852                	sd	s4,16(sp)
ffffffffc0203f72:	e456                	sd	s5,8(sp)
ffffffffc0203f74:	c525                	beqz	a0,ffffffffc0203fdc <dup_mmap+0x78>
ffffffffc0203f76:	892a                	mv	s2,a0
ffffffffc0203f78:	84ae                	mv	s1,a1
ffffffffc0203f7a:	842e                	mv	s0,a1
ffffffffc0203f7c:	c1a5                	beqz	a1,ffffffffc0203fdc <dup_mmap+0x78>
ffffffffc0203f7e:	6000                	ld	s0,0(s0)
ffffffffc0203f80:	04848c63          	beq	s1,s0,ffffffffc0203fd8 <dup_mmap+0x74>
ffffffffc0203f84:	03000513          	li	a0,48
ffffffffc0203f88:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203f8c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203f90:	ff842983          	lw	s3,-8(s0)
ffffffffc0203f94:	868fe0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0203f98:	c515                	beqz	a0,ffffffffc0203fc4 <dup_mmap+0x60>
ffffffffc0203f9a:	85aa                	mv	a1,a0
ffffffffc0203f9c:	01553423          	sd	s5,8(a0)
ffffffffc0203fa0:	01453823          	sd	s4,16(a0)
ffffffffc0203fa4:	01352c23          	sw	s3,24(a0)
ffffffffc0203fa8:	854a                	mv	a0,s2
ffffffffc0203faa:	dcfff0ef          	jal	ffffffffc0203d78 <insert_vma_struct>
ffffffffc0203fae:	ff043683          	ld	a3,-16(s0)
ffffffffc0203fb2:	fe843603          	ld	a2,-24(s0)
ffffffffc0203fb6:	6c8c                	ld	a1,24(s1)
ffffffffc0203fb8:	01893503          	ld	a0,24(s2)
ffffffffc0203fbc:	4701                	li	a4,0
ffffffffc0203fbe:	9b1ff0ef          	jal	ffffffffc020396e <copy_range>
ffffffffc0203fc2:	dd55                	beqz	a0,ffffffffc0203f7e <dup_mmap+0x1a>
ffffffffc0203fc4:	5571                	li	a0,-4
ffffffffc0203fc6:	70e2                	ld	ra,56(sp)
ffffffffc0203fc8:	7442                	ld	s0,48(sp)
ffffffffc0203fca:	74a2                	ld	s1,40(sp)
ffffffffc0203fcc:	7902                	ld	s2,32(sp)
ffffffffc0203fce:	69e2                	ld	s3,24(sp)
ffffffffc0203fd0:	6a42                	ld	s4,16(sp)
ffffffffc0203fd2:	6aa2                	ld	s5,8(sp)
ffffffffc0203fd4:	6121                	addi	sp,sp,64
ffffffffc0203fd6:	8082                	ret
ffffffffc0203fd8:	4501                	li	a0,0
ffffffffc0203fda:	b7f5                	j	ffffffffc0203fc6 <dup_mmap+0x62>
ffffffffc0203fdc:	00009697          	auipc	a3,0x9
ffffffffc0203fe0:	5dc68693          	addi	a3,a3,1500 # ffffffffc020d5b8 <etext+0x17a4>
ffffffffc0203fe4:	00008617          	auipc	a2,0x8
ffffffffc0203fe8:	26c60613          	addi	a2,a2,620 # ffffffffc020c250 <etext+0x43c>
ffffffffc0203fec:	0cf00593          	li	a1,207
ffffffffc0203ff0:	00009517          	auipc	a0,0x9
ffffffffc0203ff4:	53050513          	addi	a0,a0,1328 # ffffffffc020d520 <etext+0x170c>
ffffffffc0203ff8:	c52fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203ffc <exit_mmap>:
ffffffffc0203ffc:	1101                	addi	sp,sp,-32
ffffffffc0203ffe:	ec06                	sd	ra,24(sp)
ffffffffc0204000:	e822                	sd	s0,16(sp)
ffffffffc0204002:	e426                	sd	s1,8(sp)
ffffffffc0204004:	e04a                	sd	s2,0(sp)
ffffffffc0204006:	c531                	beqz	a0,ffffffffc0204052 <exit_mmap+0x56>
ffffffffc0204008:	591c                	lw	a5,48(a0)
ffffffffc020400a:	84aa                	mv	s1,a0
ffffffffc020400c:	e3b9                	bnez	a5,ffffffffc0204052 <exit_mmap+0x56>
ffffffffc020400e:	6500                	ld	s0,8(a0)
ffffffffc0204010:	01853903          	ld	s2,24(a0)
ffffffffc0204014:	02850663          	beq	a0,s0,ffffffffc0204040 <exit_mmap+0x44>
ffffffffc0204018:	ff043603          	ld	a2,-16(s0)
ffffffffc020401c:	fe843583          	ld	a1,-24(s0)
ffffffffc0204020:	854a                	mv	a0,s2
ffffffffc0204022:	dc0fe0ef          	jal	ffffffffc02025e2 <unmap_range>
ffffffffc0204026:	6400                	ld	s0,8(s0)
ffffffffc0204028:	fe8498e3          	bne	s1,s0,ffffffffc0204018 <exit_mmap+0x1c>
ffffffffc020402c:	6400                	ld	s0,8(s0)
ffffffffc020402e:	00848c63          	beq	s1,s0,ffffffffc0204046 <exit_mmap+0x4a>
ffffffffc0204032:	ff043603          	ld	a2,-16(s0)
ffffffffc0204036:	fe843583          	ld	a1,-24(s0)
ffffffffc020403a:	854a                	mv	a0,s2
ffffffffc020403c:	edafe0ef          	jal	ffffffffc0202716 <exit_range>
ffffffffc0204040:	6400                	ld	s0,8(s0)
ffffffffc0204042:	fe8498e3          	bne	s1,s0,ffffffffc0204032 <exit_mmap+0x36>
ffffffffc0204046:	60e2                	ld	ra,24(sp)
ffffffffc0204048:	6442                	ld	s0,16(sp)
ffffffffc020404a:	64a2                	ld	s1,8(sp)
ffffffffc020404c:	6902                	ld	s2,0(sp)
ffffffffc020404e:	6105                	addi	sp,sp,32
ffffffffc0204050:	8082                	ret
ffffffffc0204052:	00009697          	auipc	a3,0x9
ffffffffc0204056:	58668693          	addi	a3,a3,1414 # ffffffffc020d5d8 <etext+0x17c4>
ffffffffc020405a:	00008617          	auipc	a2,0x8
ffffffffc020405e:	1f660613          	addi	a2,a2,502 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204062:	0e800593          	li	a1,232
ffffffffc0204066:	00009517          	auipc	a0,0x9
ffffffffc020406a:	4ba50513          	addi	a0,a0,1210 # ffffffffc020d520 <etext+0x170c>
ffffffffc020406e:	bdcfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204072 <vmm_init>:
ffffffffc0204072:	7179                	addi	sp,sp,-48
ffffffffc0204074:	05800513          	li	a0,88
ffffffffc0204078:	f406                	sd	ra,40(sp)
ffffffffc020407a:	f022                	sd	s0,32(sp)
ffffffffc020407c:	ec26                	sd	s1,24(sp)
ffffffffc020407e:	e84a                	sd	s2,16(sp)
ffffffffc0204080:	e44e                	sd	s3,8(sp)
ffffffffc0204082:	e052                	sd	s4,0(sp)
ffffffffc0204084:	f79fd0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0204088:	16050f63          	beqz	a0,ffffffffc0204206 <vmm_init+0x194>
ffffffffc020408c:	e508                	sd	a0,8(a0)
ffffffffc020408e:	e108                	sd	a0,0(a0)
ffffffffc0204090:	00053823          	sd	zero,16(a0)
ffffffffc0204094:	00053c23          	sd	zero,24(a0)
ffffffffc0204098:	02052023          	sw	zero,32(a0)
ffffffffc020409c:	02053423          	sd	zero,40(a0)
ffffffffc02040a0:	02052823          	sw	zero,48(a0)
ffffffffc02040a4:	842a                	mv	s0,a0
ffffffffc02040a6:	4585                	li	a1,1
ffffffffc02040a8:	03850513          	addi	a0,a0,56
ffffffffc02040ac:	5c4000ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc02040b0:	03200493          	li	s1,50
ffffffffc02040b4:	03000513          	li	a0,48
ffffffffc02040b8:	f45fd0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02040bc:	12050563          	beqz	a0,ffffffffc02041e6 <vmm_init+0x174>
ffffffffc02040c0:	00248793          	addi	a5,s1,2
ffffffffc02040c4:	e504                	sd	s1,8(a0)
ffffffffc02040c6:	00052c23          	sw	zero,24(a0)
ffffffffc02040ca:	e91c                	sd	a5,16(a0)
ffffffffc02040cc:	85aa                	mv	a1,a0
ffffffffc02040ce:	14ed                	addi	s1,s1,-5
ffffffffc02040d0:	8522                	mv	a0,s0
ffffffffc02040d2:	ca7ff0ef          	jal	ffffffffc0203d78 <insert_vma_struct>
ffffffffc02040d6:	fcf9                	bnez	s1,ffffffffc02040b4 <vmm_init+0x42>
ffffffffc02040d8:	03700493          	li	s1,55
ffffffffc02040dc:	1f900913          	li	s2,505
ffffffffc02040e0:	03000513          	li	a0,48
ffffffffc02040e4:	f19fd0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02040e8:	12050f63          	beqz	a0,ffffffffc0204226 <vmm_init+0x1b4>
ffffffffc02040ec:	00248793          	addi	a5,s1,2
ffffffffc02040f0:	e504                	sd	s1,8(a0)
ffffffffc02040f2:	00052c23          	sw	zero,24(a0)
ffffffffc02040f6:	e91c                	sd	a5,16(a0)
ffffffffc02040f8:	85aa                	mv	a1,a0
ffffffffc02040fa:	0495                	addi	s1,s1,5
ffffffffc02040fc:	8522                	mv	a0,s0
ffffffffc02040fe:	c7bff0ef          	jal	ffffffffc0203d78 <insert_vma_struct>
ffffffffc0204102:	fd249fe3          	bne	s1,s2,ffffffffc02040e0 <vmm_init+0x6e>
ffffffffc0204106:	641c                	ld	a5,8(s0)
ffffffffc0204108:	471d                	li	a4,7
ffffffffc020410a:	1fb00593          	li	a1,507
ffffffffc020410e:	1ef40c63          	beq	s0,a5,ffffffffc0204306 <vmm_init+0x294>
ffffffffc0204112:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0204116:	ffe70693          	addi	a3,a4,-2
ffffffffc020411a:	12d61663          	bne	a2,a3,ffffffffc0204246 <vmm_init+0x1d4>
ffffffffc020411e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0204122:	12e69263          	bne	a3,a4,ffffffffc0204246 <vmm_init+0x1d4>
ffffffffc0204126:	0715                	addi	a4,a4,5
ffffffffc0204128:	679c                	ld	a5,8(a5)
ffffffffc020412a:	feb712e3          	bne	a4,a1,ffffffffc020410e <vmm_init+0x9c>
ffffffffc020412e:	491d                	li	s2,7
ffffffffc0204130:	4495                	li	s1,5
ffffffffc0204132:	85a6                	mv	a1,s1
ffffffffc0204134:	8522                	mv	a0,s0
ffffffffc0204136:	c03ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc020413a:	8a2a                	mv	s4,a0
ffffffffc020413c:	20050563          	beqz	a0,ffffffffc0204346 <vmm_init+0x2d4>
ffffffffc0204140:	00148593          	addi	a1,s1,1
ffffffffc0204144:	8522                	mv	a0,s0
ffffffffc0204146:	bf3ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc020414a:	89aa                	mv	s3,a0
ffffffffc020414c:	1c050d63          	beqz	a0,ffffffffc0204326 <vmm_init+0x2b4>
ffffffffc0204150:	85ca                	mv	a1,s2
ffffffffc0204152:	8522                	mv	a0,s0
ffffffffc0204154:	be5ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc0204158:	18051763          	bnez	a0,ffffffffc02042e6 <vmm_init+0x274>
ffffffffc020415c:	00348593          	addi	a1,s1,3
ffffffffc0204160:	8522                	mv	a0,s0
ffffffffc0204162:	bd7ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc0204166:	16051063          	bnez	a0,ffffffffc02042c6 <vmm_init+0x254>
ffffffffc020416a:	00448593          	addi	a1,s1,4
ffffffffc020416e:	8522                	mv	a0,s0
ffffffffc0204170:	bc9ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc0204174:	12051963          	bnez	a0,ffffffffc02042a6 <vmm_init+0x234>
ffffffffc0204178:	008a3783          	ld	a5,8(s4)
ffffffffc020417c:	10979563          	bne	a5,s1,ffffffffc0204286 <vmm_init+0x214>
ffffffffc0204180:	010a3783          	ld	a5,16(s4)
ffffffffc0204184:	11279163          	bne	a5,s2,ffffffffc0204286 <vmm_init+0x214>
ffffffffc0204188:	0089b783          	ld	a5,8(s3)
ffffffffc020418c:	0c979d63          	bne	a5,s1,ffffffffc0204266 <vmm_init+0x1f4>
ffffffffc0204190:	0109b783          	ld	a5,16(s3)
ffffffffc0204194:	0d279963          	bne	a5,s2,ffffffffc0204266 <vmm_init+0x1f4>
ffffffffc0204198:	0495                	addi	s1,s1,5
ffffffffc020419a:	1f900793          	li	a5,505
ffffffffc020419e:	0915                	addi	s2,s2,5
ffffffffc02041a0:	f8f499e3          	bne	s1,a5,ffffffffc0204132 <vmm_init+0xc0>
ffffffffc02041a4:	4491                	li	s1,4
ffffffffc02041a6:	597d                	li	s2,-1
ffffffffc02041a8:	85a6                	mv	a1,s1
ffffffffc02041aa:	8522                	mv	a0,s0
ffffffffc02041ac:	b8dff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc02041b0:	1a051b63          	bnez	a0,ffffffffc0204366 <vmm_init+0x2f4>
ffffffffc02041b4:	14fd                	addi	s1,s1,-1
ffffffffc02041b6:	ff2499e3          	bne	s1,s2,ffffffffc02041a8 <vmm_init+0x136>
ffffffffc02041ba:	8522                	mv	a0,s0
ffffffffc02041bc:	c8bff0ef          	jal	ffffffffc0203e46 <mm_destroy>
ffffffffc02041c0:	00009517          	auipc	a0,0x9
ffffffffc02041c4:	58850513          	addi	a0,a0,1416 # ffffffffc020d748 <etext+0x1934>
ffffffffc02041c8:	fdffb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02041cc:	7402                	ld	s0,32(sp)
ffffffffc02041ce:	70a2                	ld	ra,40(sp)
ffffffffc02041d0:	64e2                	ld	s1,24(sp)
ffffffffc02041d2:	6942                	ld	s2,16(sp)
ffffffffc02041d4:	69a2                	ld	s3,8(sp)
ffffffffc02041d6:	6a02                	ld	s4,0(sp)
ffffffffc02041d8:	00009517          	auipc	a0,0x9
ffffffffc02041dc:	59050513          	addi	a0,a0,1424 # ffffffffc020d768 <etext+0x1954>
ffffffffc02041e0:	6145                	addi	sp,sp,48
ffffffffc02041e2:	fc5fb06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02041e6:	00009697          	auipc	a3,0x9
ffffffffc02041ea:	41268693          	addi	a3,a3,1042 # ffffffffc020d5f8 <etext+0x17e4>
ffffffffc02041ee:	00008617          	auipc	a2,0x8
ffffffffc02041f2:	06260613          	addi	a2,a2,98 # ffffffffc020c250 <etext+0x43c>
ffffffffc02041f6:	12c00593          	li	a1,300
ffffffffc02041fa:	00009517          	auipc	a0,0x9
ffffffffc02041fe:	32650513          	addi	a0,a0,806 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204202:	a48fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204206:	00009697          	auipc	a3,0x9
ffffffffc020420a:	3a268693          	addi	a3,a3,930 # ffffffffc020d5a8 <etext+0x1794>
ffffffffc020420e:	00008617          	auipc	a2,0x8
ffffffffc0204212:	04260613          	addi	a2,a2,66 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204216:	12400593          	li	a1,292
ffffffffc020421a:	00009517          	auipc	a0,0x9
ffffffffc020421e:	30650513          	addi	a0,a0,774 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204222:	a28fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204226:	00009697          	auipc	a3,0x9
ffffffffc020422a:	3d268693          	addi	a3,a3,978 # ffffffffc020d5f8 <etext+0x17e4>
ffffffffc020422e:	00008617          	auipc	a2,0x8
ffffffffc0204232:	02260613          	addi	a2,a2,34 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204236:	13300593          	li	a1,307
ffffffffc020423a:	00009517          	auipc	a0,0x9
ffffffffc020423e:	2e650513          	addi	a0,a0,742 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204242:	a08fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204246:	00009697          	auipc	a3,0x9
ffffffffc020424a:	3da68693          	addi	a3,a3,986 # ffffffffc020d620 <etext+0x180c>
ffffffffc020424e:	00008617          	auipc	a2,0x8
ffffffffc0204252:	00260613          	addi	a2,a2,2 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204256:	13d00593          	li	a1,317
ffffffffc020425a:	00009517          	auipc	a0,0x9
ffffffffc020425e:	2c650513          	addi	a0,a0,710 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204262:	9e8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204266:	00009697          	auipc	a3,0x9
ffffffffc020426a:	47268693          	addi	a3,a3,1138 # ffffffffc020d6d8 <etext+0x18c4>
ffffffffc020426e:	00008617          	auipc	a2,0x8
ffffffffc0204272:	fe260613          	addi	a2,a2,-30 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204276:	14f00593          	li	a1,335
ffffffffc020427a:	00009517          	auipc	a0,0x9
ffffffffc020427e:	2a650513          	addi	a0,a0,678 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204282:	9c8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204286:	00009697          	auipc	a3,0x9
ffffffffc020428a:	42268693          	addi	a3,a3,1058 # ffffffffc020d6a8 <etext+0x1894>
ffffffffc020428e:	00008617          	auipc	a2,0x8
ffffffffc0204292:	fc260613          	addi	a2,a2,-62 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204296:	14e00593          	li	a1,334
ffffffffc020429a:	00009517          	auipc	a0,0x9
ffffffffc020429e:	28650513          	addi	a0,a0,646 # ffffffffc020d520 <etext+0x170c>
ffffffffc02042a2:	9a8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042a6:	00009697          	auipc	a3,0x9
ffffffffc02042aa:	3f268693          	addi	a3,a3,1010 # ffffffffc020d698 <etext+0x1884>
ffffffffc02042ae:	00008617          	auipc	a2,0x8
ffffffffc02042b2:	fa260613          	addi	a2,a2,-94 # ffffffffc020c250 <etext+0x43c>
ffffffffc02042b6:	14c00593          	li	a1,332
ffffffffc02042ba:	00009517          	auipc	a0,0x9
ffffffffc02042be:	26650513          	addi	a0,a0,614 # ffffffffc020d520 <etext+0x170c>
ffffffffc02042c2:	988fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042c6:	00009697          	auipc	a3,0x9
ffffffffc02042ca:	3c268693          	addi	a3,a3,962 # ffffffffc020d688 <etext+0x1874>
ffffffffc02042ce:	00008617          	auipc	a2,0x8
ffffffffc02042d2:	f8260613          	addi	a2,a2,-126 # ffffffffc020c250 <etext+0x43c>
ffffffffc02042d6:	14a00593          	li	a1,330
ffffffffc02042da:	00009517          	auipc	a0,0x9
ffffffffc02042de:	24650513          	addi	a0,a0,582 # ffffffffc020d520 <etext+0x170c>
ffffffffc02042e2:	968fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02042e6:	00009697          	auipc	a3,0x9
ffffffffc02042ea:	39268693          	addi	a3,a3,914 # ffffffffc020d678 <etext+0x1864>
ffffffffc02042ee:	00008617          	auipc	a2,0x8
ffffffffc02042f2:	f6260613          	addi	a2,a2,-158 # ffffffffc020c250 <etext+0x43c>
ffffffffc02042f6:	14800593          	li	a1,328
ffffffffc02042fa:	00009517          	auipc	a0,0x9
ffffffffc02042fe:	22650513          	addi	a0,a0,550 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204302:	948fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204306:	00009697          	auipc	a3,0x9
ffffffffc020430a:	30268693          	addi	a3,a3,770 # ffffffffc020d608 <etext+0x17f4>
ffffffffc020430e:	00008617          	auipc	a2,0x8
ffffffffc0204312:	f4260613          	addi	a2,a2,-190 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204316:	13b00593          	li	a1,315
ffffffffc020431a:	00009517          	auipc	a0,0x9
ffffffffc020431e:	20650513          	addi	a0,a0,518 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204322:	928fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204326:	00009697          	auipc	a3,0x9
ffffffffc020432a:	34268693          	addi	a3,a3,834 # ffffffffc020d668 <etext+0x1854>
ffffffffc020432e:	00008617          	auipc	a2,0x8
ffffffffc0204332:	f2260613          	addi	a2,a2,-222 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204336:	14600593          	li	a1,326
ffffffffc020433a:	00009517          	auipc	a0,0x9
ffffffffc020433e:	1e650513          	addi	a0,a0,486 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204342:	908fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204346:	00009697          	auipc	a3,0x9
ffffffffc020434a:	31268693          	addi	a3,a3,786 # ffffffffc020d658 <etext+0x1844>
ffffffffc020434e:	00008617          	auipc	a2,0x8
ffffffffc0204352:	f0260613          	addi	a2,a2,-254 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204356:	14400593          	li	a1,324
ffffffffc020435a:	00009517          	auipc	a0,0x9
ffffffffc020435e:	1c650513          	addi	a0,a0,454 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204362:	8e8fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204366:	6914                	ld	a3,16(a0)
ffffffffc0204368:	6510                	ld	a2,8(a0)
ffffffffc020436a:	0004859b          	sext.w	a1,s1
ffffffffc020436e:	00009517          	auipc	a0,0x9
ffffffffc0204372:	39a50513          	addi	a0,a0,922 # ffffffffc020d708 <etext+0x18f4>
ffffffffc0204376:	e31fb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020437a:	00009697          	auipc	a3,0x9
ffffffffc020437e:	3b668693          	addi	a3,a3,950 # ffffffffc020d730 <etext+0x191c>
ffffffffc0204382:	00008617          	auipc	a2,0x8
ffffffffc0204386:	ece60613          	addi	a2,a2,-306 # ffffffffc020c250 <etext+0x43c>
ffffffffc020438a:	15900593          	li	a1,345
ffffffffc020438e:	00009517          	auipc	a0,0x9
ffffffffc0204392:	19250513          	addi	a0,a0,402 # ffffffffc020d520 <etext+0x170c>
ffffffffc0204396:	8b4fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020439a <user_mem_check>:
ffffffffc020439a:	7179                	addi	sp,sp,-48
ffffffffc020439c:	f022                	sd	s0,32(sp)
ffffffffc020439e:	f406                	sd	ra,40(sp)
ffffffffc02043a0:	842e                	mv	s0,a1
ffffffffc02043a2:	c52d                	beqz	a0,ffffffffc020440c <user_mem_check+0x72>
ffffffffc02043a4:	002007b7          	lui	a5,0x200
ffffffffc02043a8:	04f5ed63          	bltu	a1,a5,ffffffffc0204402 <user_mem_check+0x68>
ffffffffc02043ac:	ec26                	sd	s1,24(sp)
ffffffffc02043ae:	00c584b3          	add	s1,a1,a2
ffffffffc02043b2:	0695ff63          	bgeu	a1,s1,ffffffffc0204430 <user_mem_check+0x96>
ffffffffc02043b6:	4785                	li	a5,1
ffffffffc02043b8:	07fe                	slli	a5,a5,0x1f
ffffffffc02043ba:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc02043bc:	06f4fa63          	bgeu	s1,a5,ffffffffc0204430 <user_mem_check+0x96>
ffffffffc02043c0:	e84a                	sd	s2,16(sp)
ffffffffc02043c2:	e44e                	sd	s3,8(sp)
ffffffffc02043c4:	8936                	mv	s2,a3
ffffffffc02043c6:	89aa                	mv	s3,a0
ffffffffc02043c8:	a829                	j	ffffffffc02043e2 <user_mem_check+0x48>
ffffffffc02043ca:	6685                	lui	a3,0x1
ffffffffc02043cc:	9736                	add	a4,a4,a3
ffffffffc02043ce:	0027f693          	andi	a3,a5,2
ffffffffc02043d2:	8ba1                	andi	a5,a5,8
ffffffffc02043d4:	c685                	beqz	a3,ffffffffc02043fc <user_mem_check+0x62>
ffffffffc02043d6:	c399                	beqz	a5,ffffffffc02043dc <user_mem_check+0x42>
ffffffffc02043d8:	02e46263          	bltu	s0,a4,ffffffffc02043fc <user_mem_check+0x62>
ffffffffc02043dc:	6900                	ld	s0,16(a0)
ffffffffc02043de:	04947b63          	bgeu	s0,s1,ffffffffc0204434 <user_mem_check+0x9a>
ffffffffc02043e2:	85a2                	mv	a1,s0
ffffffffc02043e4:	854e                	mv	a0,s3
ffffffffc02043e6:	953ff0ef          	jal	ffffffffc0203d38 <find_vma>
ffffffffc02043ea:	c909                	beqz	a0,ffffffffc02043fc <user_mem_check+0x62>
ffffffffc02043ec:	6518                	ld	a4,8(a0)
ffffffffc02043ee:	00e46763          	bltu	s0,a4,ffffffffc02043fc <user_mem_check+0x62>
ffffffffc02043f2:	4d1c                	lw	a5,24(a0)
ffffffffc02043f4:	fc091be3          	bnez	s2,ffffffffc02043ca <user_mem_check+0x30>
ffffffffc02043f8:	8b85                	andi	a5,a5,1
ffffffffc02043fa:	f3ed                	bnez	a5,ffffffffc02043dc <user_mem_check+0x42>
ffffffffc02043fc:	64e2                	ld	s1,24(sp)
ffffffffc02043fe:	6942                	ld	s2,16(sp)
ffffffffc0204400:	69a2                	ld	s3,8(sp)
ffffffffc0204402:	4501                	li	a0,0
ffffffffc0204404:	70a2                	ld	ra,40(sp)
ffffffffc0204406:	7402                	ld	s0,32(sp)
ffffffffc0204408:	6145                	addi	sp,sp,48
ffffffffc020440a:	8082                	ret
ffffffffc020440c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204410:	fef5eae3          	bltu	a1,a5,ffffffffc0204404 <user_mem_check+0x6a>
ffffffffc0204414:	c80007b7          	lui	a5,0xc8000
ffffffffc0204418:	962e                	add	a2,a2,a1
ffffffffc020441a:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d696f1>
ffffffffc020441c:	00c5b433          	sltu	s0,a1,a2
ffffffffc0204420:	00f63633          	sltu	a2,a2,a5
ffffffffc0204424:	70a2                	ld	ra,40(sp)
ffffffffc0204426:	00867533          	and	a0,a2,s0
ffffffffc020442a:	7402                	ld	s0,32(sp)
ffffffffc020442c:	6145                	addi	sp,sp,48
ffffffffc020442e:	8082                	ret
ffffffffc0204430:	64e2                	ld	s1,24(sp)
ffffffffc0204432:	bfc1                	j	ffffffffc0204402 <user_mem_check+0x68>
ffffffffc0204434:	64e2                	ld	s1,24(sp)
ffffffffc0204436:	6942                	ld	s2,16(sp)
ffffffffc0204438:	69a2                	ld	s3,8(sp)
ffffffffc020443a:	4505                	li	a0,1
ffffffffc020443c:	b7e1                	j	ffffffffc0204404 <user_mem_check+0x6a>

ffffffffc020443e <copy_from_user>:
ffffffffc020443e:	7179                	addi	sp,sp,-48
ffffffffc0204440:	f022                	sd	s0,32(sp)
ffffffffc0204442:	8432                	mv	s0,a2
ffffffffc0204444:	ec26                	sd	s1,24(sp)
ffffffffc0204446:	8636                	mv	a2,a3
ffffffffc0204448:	84ae                	mv	s1,a1
ffffffffc020444a:	86ba                	mv	a3,a4
ffffffffc020444c:	85a2                	mv	a1,s0
ffffffffc020444e:	f406                	sd	ra,40(sp)
ffffffffc0204450:	e032                	sd	a2,0(sp)
ffffffffc0204452:	f49ff0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc0204456:	87aa                	mv	a5,a0
ffffffffc0204458:	c901                	beqz	a0,ffffffffc0204468 <copy_from_user+0x2a>
ffffffffc020445a:	6602                	ld	a2,0(sp)
ffffffffc020445c:	e42a                	sd	a0,8(sp)
ffffffffc020445e:	85a2                	mv	a1,s0
ffffffffc0204460:	8526                	mv	a0,s1
ffffffffc0204462:	19b070ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0204466:	67a2                	ld	a5,8(sp)
ffffffffc0204468:	70a2                	ld	ra,40(sp)
ffffffffc020446a:	7402                	ld	s0,32(sp)
ffffffffc020446c:	64e2                	ld	s1,24(sp)
ffffffffc020446e:	853e                	mv	a0,a5
ffffffffc0204470:	6145                	addi	sp,sp,48
ffffffffc0204472:	8082                	ret

ffffffffc0204474 <copy_to_user>:
ffffffffc0204474:	7179                	addi	sp,sp,-48
ffffffffc0204476:	f022                	sd	s0,32(sp)
ffffffffc0204478:	8436                	mv	s0,a3
ffffffffc020447a:	e84a                	sd	s2,16(sp)
ffffffffc020447c:	4685                	li	a3,1
ffffffffc020447e:	8932                	mv	s2,a2
ffffffffc0204480:	8622                	mv	a2,s0
ffffffffc0204482:	ec26                	sd	s1,24(sp)
ffffffffc0204484:	f406                	sd	ra,40(sp)
ffffffffc0204486:	84ae                	mv	s1,a1
ffffffffc0204488:	f13ff0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc020448c:	87aa                	mv	a5,a0
ffffffffc020448e:	c901                	beqz	a0,ffffffffc020449e <copy_to_user+0x2a>
ffffffffc0204490:	e42a                	sd	a0,8(sp)
ffffffffc0204492:	8622                	mv	a2,s0
ffffffffc0204494:	85ca                	mv	a1,s2
ffffffffc0204496:	8526                	mv	a0,s1
ffffffffc0204498:	165070ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc020449c:	67a2                	ld	a5,8(sp)
ffffffffc020449e:	70a2                	ld	ra,40(sp)
ffffffffc02044a0:	7402                	ld	s0,32(sp)
ffffffffc02044a2:	64e2                	ld	s1,24(sp)
ffffffffc02044a4:	6942                	ld	s2,16(sp)
ffffffffc02044a6:	853e                	mv	a0,a5
ffffffffc02044a8:	6145                	addi	sp,sp,48
ffffffffc02044aa:	8082                	ret

ffffffffc02044ac <copy_string>:
ffffffffc02044ac:	7139                	addi	sp,sp,-64
ffffffffc02044ae:	e852                	sd	s4,16(sp)
ffffffffc02044b0:	6a05                	lui	s4,0x1
ffffffffc02044b2:	9a32                	add	s4,s4,a2
ffffffffc02044b4:	77fd                	lui	a5,0xfffff
ffffffffc02044b6:	00fa7a33          	and	s4,s4,a5
ffffffffc02044ba:	f426                	sd	s1,40(sp)
ffffffffc02044bc:	f04a                	sd	s2,32(sp)
ffffffffc02044be:	e456                	sd	s5,8(sp)
ffffffffc02044c0:	e05a                	sd	s6,0(sp)
ffffffffc02044c2:	fc06                	sd	ra,56(sp)
ffffffffc02044c4:	f822                	sd	s0,48(sp)
ffffffffc02044c6:	ec4e                	sd	s3,24(sp)
ffffffffc02044c8:	84b2                	mv	s1,a2
ffffffffc02044ca:	8aae                	mv	s5,a1
ffffffffc02044cc:	8936                	mv	s2,a3
ffffffffc02044ce:	8b2a                	mv	s6,a0
ffffffffc02044d0:	40ca0a33          	sub	s4,s4,a2
ffffffffc02044d4:	a015                	j	ffffffffc02044f8 <copy_string+0x4c>
ffffffffc02044d6:	03b070ef          	jal	ffffffffc020bd10 <strnlen>
ffffffffc02044da:	87aa                	mv	a5,a0
ffffffffc02044dc:	8622                	mv	a2,s0
ffffffffc02044de:	85a6                	mv	a1,s1
ffffffffc02044e0:	8556                	mv	a0,s5
ffffffffc02044e2:	0487e663          	bltu	a5,s0,ffffffffc020452e <copy_string+0x82>
ffffffffc02044e6:	032a7863          	bgeu	s4,s2,ffffffffc0204516 <copy_string+0x6a>
ffffffffc02044ea:	113070ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc02044ee:	9aa2                	add	s5,s5,s0
ffffffffc02044f0:	94a2                	add	s1,s1,s0
ffffffffc02044f2:	40890933          	sub	s2,s2,s0
ffffffffc02044f6:	6a05                	lui	s4,0x1
ffffffffc02044f8:	4681                	li	a3,0
ffffffffc02044fa:	85a6                	mv	a1,s1
ffffffffc02044fc:	855a                	mv	a0,s6
ffffffffc02044fe:	844a                	mv	s0,s2
ffffffffc0204500:	012a7363          	bgeu	s4,s2,ffffffffc0204506 <copy_string+0x5a>
ffffffffc0204504:	8452                	mv	s0,s4
ffffffffc0204506:	8622                	mv	a2,s0
ffffffffc0204508:	e93ff0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc020450c:	89aa                	mv	s3,a0
ffffffffc020450e:	85a2                	mv	a1,s0
ffffffffc0204510:	8526                	mv	a0,s1
ffffffffc0204512:	fc0992e3          	bnez	s3,ffffffffc02044d6 <copy_string+0x2a>
ffffffffc0204516:	4981                	li	s3,0
ffffffffc0204518:	70e2                	ld	ra,56(sp)
ffffffffc020451a:	7442                	ld	s0,48(sp)
ffffffffc020451c:	74a2                	ld	s1,40(sp)
ffffffffc020451e:	7902                	ld	s2,32(sp)
ffffffffc0204520:	6a42                	ld	s4,16(sp)
ffffffffc0204522:	6aa2                	ld	s5,8(sp)
ffffffffc0204524:	6b02                	ld	s6,0(sp)
ffffffffc0204526:	854e                	mv	a0,s3
ffffffffc0204528:	69e2                	ld	s3,24(sp)
ffffffffc020452a:	6121                	addi	sp,sp,64
ffffffffc020452c:	8082                	ret
ffffffffc020452e:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0204532:	0cb070ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0204536:	b7cd                	j	ffffffffc0204518 <copy_string+0x6c>

ffffffffc0204538 <__down.constprop.0>:
ffffffffc0204538:	711d                	addi	sp,sp,-96
ffffffffc020453a:	ec86                	sd	ra,88(sp)
ffffffffc020453c:	100027f3          	csrr	a5,sstatus
ffffffffc0204540:	8b89                	andi	a5,a5,2
ffffffffc0204542:	eba1                	bnez	a5,ffffffffc0204592 <__down.constprop.0+0x5a>
ffffffffc0204544:	411c                	lw	a5,0(a0)
ffffffffc0204546:	00f05863          	blez	a5,ffffffffc0204556 <__down.constprop.0+0x1e>
ffffffffc020454a:	37fd                	addiw	a5,a5,-1
ffffffffc020454c:	c11c                	sw	a5,0(a0)
ffffffffc020454e:	60e6                	ld	ra,88(sp)
ffffffffc0204550:	4501                	li	a0,0
ffffffffc0204552:	6125                	addi	sp,sp,96
ffffffffc0204554:	8082                	ret
ffffffffc0204556:	0521                	addi	a0,a0,8
ffffffffc0204558:	082c                	addi	a1,sp,24
ffffffffc020455a:	10000613          	li	a2,256
ffffffffc020455e:	e8a2                	sd	s0,80(sp)
ffffffffc0204560:	e4a6                	sd	s1,72(sp)
ffffffffc0204562:	0820                	addi	s0,sp,24
ffffffffc0204564:	84aa                	mv	s1,a0
ffffffffc0204566:	2d0000ef          	jal	ffffffffc0204836 <wait_current_set>
ffffffffc020456a:	57c030ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc020456e:	100027f3          	csrr	a5,sstatus
ffffffffc0204572:	8b89                	andi	a5,a5,2
ffffffffc0204574:	efa9                	bnez	a5,ffffffffc02045ce <__down.constprop.0+0x96>
ffffffffc0204576:	8522                	mv	a0,s0
ffffffffc0204578:	192000ef          	jal	ffffffffc020470a <wait_in_queue>
ffffffffc020457c:	e521                	bnez	a0,ffffffffc02045c4 <__down.constprop.0+0x8c>
ffffffffc020457e:	5502                	lw	a0,32(sp)
ffffffffc0204580:	10000793          	li	a5,256
ffffffffc0204584:	6446                	ld	s0,80(sp)
ffffffffc0204586:	64a6                	ld	s1,72(sp)
ffffffffc0204588:	fcf503e3          	beq	a0,a5,ffffffffc020454e <__down.constprop.0+0x16>
ffffffffc020458c:	60e6                	ld	ra,88(sp)
ffffffffc020458e:	6125                	addi	sp,sp,96
ffffffffc0204590:	8082                	ret
ffffffffc0204592:	e42a                	sd	a0,8(sp)
ffffffffc0204594:	e44fc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0204598:	6522                	ld	a0,8(sp)
ffffffffc020459a:	411c                	lw	a5,0(a0)
ffffffffc020459c:	00f05763          	blez	a5,ffffffffc02045aa <__down.constprop.0+0x72>
ffffffffc02045a0:	37fd                	addiw	a5,a5,-1
ffffffffc02045a2:	c11c                	sw	a5,0(a0)
ffffffffc02045a4:	e2efc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02045a8:	b75d                	j	ffffffffc020454e <__down.constprop.0+0x16>
ffffffffc02045aa:	0521                	addi	a0,a0,8
ffffffffc02045ac:	082c                	addi	a1,sp,24
ffffffffc02045ae:	10000613          	li	a2,256
ffffffffc02045b2:	e8a2                	sd	s0,80(sp)
ffffffffc02045b4:	e4a6                	sd	s1,72(sp)
ffffffffc02045b6:	0820                	addi	s0,sp,24
ffffffffc02045b8:	84aa                	mv	s1,a0
ffffffffc02045ba:	27c000ef          	jal	ffffffffc0204836 <wait_current_set>
ffffffffc02045be:	e14fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02045c2:	b765                	j	ffffffffc020456a <__down.constprop.0+0x32>
ffffffffc02045c4:	85a2                	mv	a1,s0
ffffffffc02045c6:	8526                	mv	a0,s1
ffffffffc02045c8:	0e8000ef          	jal	ffffffffc02046b0 <wait_queue_del>
ffffffffc02045cc:	bf4d                	j	ffffffffc020457e <__down.constprop.0+0x46>
ffffffffc02045ce:	e0afc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02045d2:	8522                	mv	a0,s0
ffffffffc02045d4:	136000ef          	jal	ffffffffc020470a <wait_in_queue>
ffffffffc02045d8:	e501                	bnez	a0,ffffffffc02045e0 <__down.constprop.0+0xa8>
ffffffffc02045da:	df8fc0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02045de:	b745                	j	ffffffffc020457e <__down.constprop.0+0x46>
ffffffffc02045e0:	85a2                	mv	a1,s0
ffffffffc02045e2:	8526                	mv	a0,s1
ffffffffc02045e4:	0cc000ef          	jal	ffffffffc02046b0 <wait_queue_del>
ffffffffc02045e8:	bfcd                	j	ffffffffc02045da <__down.constprop.0+0xa2>

ffffffffc02045ea <__up.constprop.0>:
ffffffffc02045ea:	1101                	addi	sp,sp,-32
ffffffffc02045ec:	e426                	sd	s1,8(sp)
ffffffffc02045ee:	ec06                	sd	ra,24(sp)
ffffffffc02045f0:	e822                	sd	s0,16(sp)
ffffffffc02045f2:	e04a                	sd	s2,0(sp)
ffffffffc02045f4:	84aa                	mv	s1,a0
ffffffffc02045f6:	100027f3          	csrr	a5,sstatus
ffffffffc02045fa:	8b89                	andi	a5,a5,2
ffffffffc02045fc:	4901                	li	s2,0
ffffffffc02045fe:	e7b1                	bnez	a5,ffffffffc020464a <__up.constprop.0+0x60>
ffffffffc0204600:	00848413          	addi	s0,s1,8
ffffffffc0204604:	8522                	mv	a0,s0
ffffffffc0204606:	0e8000ef          	jal	ffffffffc02046ee <wait_queue_first>
ffffffffc020460a:	cd05                	beqz	a0,ffffffffc0204642 <__up.constprop.0+0x58>
ffffffffc020460c:	6118                	ld	a4,0(a0)
ffffffffc020460e:	10000793          	li	a5,256
ffffffffc0204612:	0ec72603          	lw	a2,236(a4)
ffffffffc0204616:	02f61e63          	bne	a2,a5,ffffffffc0204652 <__up.constprop.0+0x68>
ffffffffc020461a:	85aa                	mv	a1,a0
ffffffffc020461c:	4685                	li	a3,1
ffffffffc020461e:	8522                	mv	a0,s0
ffffffffc0204620:	0f8000ef          	jal	ffffffffc0204718 <wakeup_wait>
ffffffffc0204624:	00091863          	bnez	s2,ffffffffc0204634 <__up.constprop.0+0x4a>
ffffffffc0204628:	60e2                	ld	ra,24(sp)
ffffffffc020462a:	6442                	ld	s0,16(sp)
ffffffffc020462c:	64a2                	ld	s1,8(sp)
ffffffffc020462e:	6902                	ld	s2,0(sp)
ffffffffc0204630:	6105                	addi	sp,sp,32
ffffffffc0204632:	8082                	ret
ffffffffc0204634:	6442                	ld	s0,16(sp)
ffffffffc0204636:	60e2                	ld	ra,24(sp)
ffffffffc0204638:	64a2                	ld	s1,8(sp)
ffffffffc020463a:	6902                	ld	s2,0(sp)
ffffffffc020463c:	6105                	addi	sp,sp,32
ffffffffc020463e:	d94fc06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0204642:	409c                	lw	a5,0(s1)
ffffffffc0204644:	2785                	addiw	a5,a5,1
ffffffffc0204646:	c09c                	sw	a5,0(s1)
ffffffffc0204648:	bff1                	j	ffffffffc0204624 <__up.constprop.0+0x3a>
ffffffffc020464a:	d8efc0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc020464e:	4905                	li	s2,1
ffffffffc0204650:	bf45                	j	ffffffffc0204600 <__up.constprop.0+0x16>
ffffffffc0204652:	00009697          	auipc	a3,0x9
ffffffffc0204656:	12e68693          	addi	a3,a3,302 # ffffffffc020d780 <etext+0x196c>
ffffffffc020465a:	00008617          	auipc	a2,0x8
ffffffffc020465e:	bf660613          	addi	a2,a2,-1034 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204662:	45e5                	li	a1,25
ffffffffc0204664:	00009517          	auipc	a0,0x9
ffffffffc0204668:	14450513          	addi	a0,a0,324 # ffffffffc020d7a8 <etext+0x1994>
ffffffffc020466c:	ddffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204670 <sem_init>:
ffffffffc0204670:	c10c                	sw	a1,0(a0)
ffffffffc0204672:	0521                	addi	a0,a0,8
ffffffffc0204674:	a81d                	j	ffffffffc02046aa <wait_queue_init>

ffffffffc0204676 <up>:
ffffffffc0204676:	f75ff06f          	j	ffffffffc02045ea <__up.constprop.0>

ffffffffc020467a <down>:
ffffffffc020467a:	1141                	addi	sp,sp,-16
ffffffffc020467c:	e406                	sd	ra,8(sp)
ffffffffc020467e:	ebbff0ef          	jal	ffffffffc0204538 <__down.constprop.0>
ffffffffc0204682:	e501                	bnez	a0,ffffffffc020468a <down+0x10>
ffffffffc0204684:	60a2                	ld	ra,8(sp)
ffffffffc0204686:	0141                	addi	sp,sp,16
ffffffffc0204688:	8082                	ret
ffffffffc020468a:	00009697          	auipc	a3,0x9
ffffffffc020468e:	12e68693          	addi	a3,a3,302 # ffffffffc020d7b8 <etext+0x19a4>
ffffffffc0204692:	00008617          	auipc	a2,0x8
ffffffffc0204696:	bbe60613          	addi	a2,a2,-1090 # ffffffffc020c250 <etext+0x43c>
ffffffffc020469a:	04000593          	li	a1,64
ffffffffc020469e:	00009517          	auipc	a0,0x9
ffffffffc02046a2:	10a50513          	addi	a0,a0,266 # ffffffffc020d7a8 <etext+0x1994>
ffffffffc02046a6:	da5fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046aa <wait_queue_init>:
ffffffffc02046aa:	e508                	sd	a0,8(a0)
ffffffffc02046ac:	e108                	sd	a0,0(a0)
ffffffffc02046ae:	8082                	ret

ffffffffc02046b0 <wait_queue_del>:
ffffffffc02046b0:	7198                	ld	a4,32(a1)
ffffffffc02046b2:	01858793          	addi	a5,a1,24
ffffffffc02046b6:	00e78b63          	beq	a5,a4,ffffffffc02046cc <wait_queue_del+0x1c>
ffffffffc02046ba:	6994                	ld	a3,16(a1)
ffffffffc02046bc:	00a69863          	bne	a3,a0,ffffffffc02046cc <wait_queue_del+0x1c>
ffffffffc02046c0:	6d94                	ld	a3,24(a1)
ffffffffc02046c2:	e698                	sd	a4,8(a3)
ffffffffc02046c4:	e314                	sd	a3,0(a4)
ffffffffc02046c6:	f19c                	sd	a5,32(a1)
ffffffffc02046c8:	ed9c                	sd	a5,24(a1)
ffffffffc02046ca:	8082                	ret
ffffffffc02046cc:	1141                	addi	sp,sp,-16
ffffffffc02046ce:	00009697          	auipc	a3,0x9
ffffffffc02046d2:	14a68693          	addi	a3,a3,330 # ffffffffc020d818 <etext+0x1a04>
ffffffffc02046d6:	00008617          	auipc	a2,0x8
ffffffffc02046da:	b7a60613          	addi	a2,a2,-1158 # ffffffffc020c250 <etext+0x43c>
ffffffffc02046de:	45f1                	li	a1,28
ffffffffc02046e0:	00009517          	auipc	a0,0x9
ffffffffc02046e4:	12050513          	addi	a0,a0,288 # ffffffffc020d800 <etext+0x19ec>
ffffffffc02046e8:	e406                	sd	ra,8(sp)
ffffffffc02046ea:	d61fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02046ee <wait_queue_first>:
ffffffffc02046ee:	651c                	ld	a5,8(a0)
ffffffffc02046f0:	00f50563          	beq	a0,a5,ffffffffc02046fa <wait_queue_first+0xc>
ffffffffc02046f4:	fe878513          	addi	a0,a5,-24
ffffffffc02046f8:	8082                	ret
ffffffffc02046fa:	4501                	li	a0,0
ffffffffc02046fc:	8082                	ret

ffffffffc02046fe <wait_queue_empty>:
ffffffffc02046fe:	651c                	ld	a5,8(a0)
ffffffffc0204700:	40a78533          	sub	a0,a5,a0
ffffffffc0204704:	00153513          	seqz	a0,a0
ffffffffc0204708:	8082                	ret

ffffffffc020470a <wait_in_queue>:
ffffffffc020470a:	711c                	ld	a5,32(a0)
ffffffffc020470c:	0561                	addi	a0,a0,24
ffffffffc020470e:	40a78533          	sub	a0,a5,a0
ffffffffc0204712:	00a03533          	snez	a0,a0
ffffffffc0204716:	8082                	ret

ffffffffc0204718 <wakeup_wait>:
ffffffffc0204718:	e689                	bnez	a3,ffffffffc0204722 <wakeup_wait+0xa>
ffffffffc020471a:	6188                	ld	a0,0(a1)
ffffffffc020471c:	c590                	sw	a2,8(a1)
ffffffffc020471e:	2d00306f          	j	ffffffffc02079ee <wakeup_proc>
ffffffffc0204722:	7198                	ld	a4,32(a1)
ffffffffc0204724:	01858793          	addi	a5,a1,24
ffffffffc0204728:	00e78e63          	beq	a5,a4,ffffffffc0204744 <wakeup_wait+0x2c>
ffffffffc020472c:	6994                	ld	a3,16(a1)
ffffffffc020472e:	00d51b63          	bne	a0,a3,ffffffffc0204744 <wakeup_wait+0x2c>
ffffffffc0204732:	6d94                	ld	a3,24(a1)
ffffffffc0204734:	6188                	ld	a0,0(a1)
ffffffffc0204736:	e698                	sd	a4,8(a3)
ffffffffc0204738:	e314                	sd	a3,0(a4)
ffffffffc020473a:	f19c                	sd	a5,32(a1)
ffffffffc020473c:	ed9c                	sd	a5,24(a1)
ffffffffc020473e:	c590                	sw	a2,8(a1)
ffffffffc0204740:	2ae0306f          	j	ffffffffc02079ee <wakeup_proc>
ffffffffc0204744:	1141                	addi	sp,sp,-16
ffffffffc0204746:	00009697          	auipc	a3,0x9
ffffffffc020474a:	0d268693          	addi	a3,a3,210 # ffffffffc020d818 <etext+0x1a04>
ffffffffc020474e:	00008617          	auipc	a2,0x8
ffffffffc0204752:	b0260613          	addi	a2,a2,-1278 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204756:	45f1                	li	a1,28
ffffffffc0204758:	00009517          	auipc	a0,0x9
ffffffffc020475c:	0a850513          	addi	a0,a0,168 # ffffffffc020d800 <etext+0x19ec>
ffffffffc0204760:	e406                	sd	ra,8(sp)
ffffffffc0204762:	ce9fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204766 <wakeup_queue>:
ffffffffc0204766:	651c                	ld	a5,8(a0)
ffffffffc0204768:	0aa78763          	beq	a5,a0,ffffffffc0204816 <wakeup_queue+0xb0>
ffffffffc020476c:	1101                	addi	sp,sp,-32
ffffffffc020476e:	e822                	sd	s0,16(sp)
ffffffffc0204770:	e426                	sd	s1,8(sp)
ffffffffc0204772:	e04a                	sd	s2,0(sp)
ffffffffc0204774:	ec06                	sd	ra,24(sp)
ffffffffc0204776:	892e                	mv	s2,a1
ffffffffc0204778:	84aa                	mv	s1,a0
ffffffffc020477a:	fe878413          	addi	s0,a5,-24
ffffffffc020477e:	ee29                	bnez	a2,ffffffffc02047d8 <wakeup_queue+0x72>
ffffffffc0204780:	6008                	ld	a0,0(s0)
ffffffffc0204782:	01242423          	sw	s2,8(s0)
ffffffffc0204786:	268030ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc020478a:	701c                	ld	a5,32(s0)
ffffffffc020478c:	01840713          	addi	a4,s0,24
ffffffffc0204790:	02e78463          	beq	a5,a4,ffffffffc02047b8 <wakeup_queue+0x52>
ffffffffc0204794:	6818                	ld	a4,16(s0)
ffffffffc0204796:	02e49163          	bne	s1,a4,ffffffffc02047b8 <wakeup_queue+0x52>
ffffffffc020479a:	06f48863          	beq	s1,a5,ffffffffc020480a <wakeup_queue+0xa4>
ffffffffc020479e:	fe87b503          	ld	a0,-24(a5)
ffffffffc02047a2:	ff27a823          	sw	s2,-16(a5)
ffffffffc02047a6:	fe878413          	addi	s0,a5,-24
ffffffffc02047aa:	244030ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc02047ae:	701c                	ld	a5,32(s0)
ffffffffc02047b0:	01840713          	addi	a4,s0,24
ffffffffc02047b4:	fee790e3          	bne	a5,a4,ffffffffc0204794 <wakeup_queue+0x2e>
ffffffffc02047b8:	00009697          	auipc	a3,0x9
ffffffffc02047bc:	06068693          	addi	a3,a3,96 # ffffffffc020d818 <etext+0x1a04>
ffffffffc02047c0:	00008617          	auipc	a2,0x8
ffffffffc02047c4:	a9060613          	addi	a2,a2,-1392 # ffffffffc020c250 <etext+0x43c>
ffffffffc02047c8:	02200593          	li	a1,34
ffffffffc02047cc:	00009517          	auipc	a0,0x9
ffffffffc02047d0:	03450513          	addi	a0,a0,52 # ffffffffc020d800 <etext+0x19ec>
ffffffffc02047d4:	c77fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02047d8:	6798                	ld	a4,8(a5)
ffffffffc02047da:	00e79863          	bne	a5,a4,ffffffffc02047ea <wakeup_queue+0x84>
ffffffffc02047de:	a82d                	j	ffffffffc0204818 <wakeup_queue+0xb2>
ffffffffc02047e0:	6418                	ld	a4,8(s0)
ffffffffc02047e2:	87a2                	mv	a5,s0
ffffffffc02047e4:	1421                	addi	s0,s0,-24
ffffffffc02047e6:	02e78963          	beq	a5,a4,ffffffffc0204818 <wakeup_queue+0xb2>
ffffffffc02047ea:	6814                	ld	a3,16(s0)
ffffffffc02047ec:	02d49663          	bne	s1,a3,ffffffffc0204818 <wakeup_queue+0xb2>
ffffffffc02047f0:	6c14                	ld	a3,24(s0)
ffffffffc02047f2:	6008                	ld	a0,0(s0)
ffffffffc02047f4:	e698                	sd	a4,8(a3)
ffffffffc02047f6:	e314                	sd	a3,0(a4)
ffffffffc02047f8:	f01c                	sd	a5,32(s0)
ffffffffc02047fa:	ec1c                	sd	a5,24(s0)
ffffffffc02047fc:	01242423          	sw	s2,8(s0)
ffffffffc0204800:	1ee030ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc0204804:	6480                	ld	s0,8(s1)
ffffffffc0204806:	fc849de3          	bne	s1,s0,ffffffffc02047e0 <wakeup_queue+0x7a>
ffffffffc020480a:	60e2                	ld	ra,24(sp)
ffffffffc020480c:	6442                	ld	s0,16(sp)
ffffffffc020480e:	64a2                	ld	s1,8(sp)
ffffffffc0204810:	6902                	ld	s2,0(sp)
ffffffffc0204812:	6105                	addi	sp,sp,32
ffffffffc0204814:	8082                	ret
ffffffffc0204816:	8082                	ret
ffffffffc0204818:	00009697          	auipc	a3,0x9
ffffffffc020481c:	00068693          	mv	a3,a3
ffffffffc0204820:	00008617          	auipc	a2,0x8
ffffffffc0204824:	a3060613          	addi	a2,a2,-1488 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204828:	45f1                	li	a1,28
ffffffffc020482a:	00009517          	auipc	a0,0x9
ffffffffc020482e:	fd650513          	addi	a0,a0,-42 # ffffffffc020d800 <etext+0x19ec>
ffffffffc0204832:	c19fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204836 <wait_current_set>:
ffffffffc0204836:	00092797          	auipc	a5,0x92
ffffffffc020483a:	0927b783          	ld	a5,146(a5) # ffffffffc02968c8 <current>
ffffffffc020483e:	c39d                	beqz	a5,ffffffffc0204864 <wait_current_set+0x2e>
ffffffffc0204840:	80000737          	lui	a4,0x80000
ffffffffc0204844:	c598                	sw	a4,8(a1)
ffffffffc0204846:	01858713          	addi	a4,a1,24
ffffffffc020484a:	ed98                	sd	a4,24(a1)
ffffffffc020484c:	e19c                	sd	a5,0(a1)
ffffffffc020484e:	0ec7a623          	sw	a2,236(a5)
ffffffffc0204852:	4605                	li	a2,1
ffffffffc0204854:	6114                	ld	a3,0(a0)
ffffffffc0204856:	c390                	sw	a2,0(a5)
ffffffffc0204858:	e988                	sd	a0,16(a1)
ffffffffc020485a:	e118                	sd	a4,0(a0)
ffffffffc020485c:	e698                	sd	a4,8(a3)
ffffffffc020485e:	ed94                	sd	a3,24(a1)
ffffffffc0204860:	f188                	sd	a0,32(a1)
ffffffffc0204862:	8082                	ret
ffffffffc0204864:	1141                	addi	sp,sp,-16
ffffffffc0204866:	00009697          	auipc	a3,0x9
ffffffffc020486a:	ff268693          	addi	a3,a3,-14 # ffffffffc020d858 <etext+0x1a44>
ffffffffc020486e:	00008617          	auipc	a2,0x8
ffffffffc0204872:	9e260613          	addi	a2,a2,-1566 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204876:	07400593          	li	a1,116
ffffffffc020487a:	00009517          	auipc	a0,0x9
ffffffffc020487e:	f8650513          	addi	a0,a0,-122 # ffffffffc020d800 <etext+0x19ec>
ffffffffc0204882:	e406                	sd	ra,8(sp)
ffffffffc0204884:	bc7fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204888 <get_fd_array.part.0>:
ffffffffc0204888:	1141                	addi	sp,sp,-16
ffffffffc020488a:	00009697          	auipc	a3,0x9
ffffffffc020488e:	fde68693          	addi	a3,a3,-34 # ffffffffc020d868 <etext+0x1a54>
ffffffffc0204892:	00008617          	auipc	a2,0x8
ffffffffc0204896:	9be60613          	addi	a2,a2,-1602 # ffffffffc020c250 <etext+0x43c>
ffffffffc020489a:	45d1                	li	a1,20
ffffffffc020489c:	00009517          	auipc	a0,0x9
ffffffffc02048a0:	ffc50513          	addi	a0,a0,-4 # ffffffffc020d898 <etext+0x1a84>
ffffffffc02048a4:	e406                	sd	ra,8(sp)
ffffffffc02048a6:	ba5fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02048aa <fd_array_alloc>:
ffffffffc02048aa:	00092797          	auipc	a5,0x92
ffffffffc02048ae:	01e7b783          	ld	a5,30(a5) # ffffffffc02968c8 <current>
ffffffffc02048b2:	1141                	addi	sp,sp,-16
ffffffffc02048b4:	e406                	sd	ra,8(sp)
ffffffffc02048b6:	1487b783          	ld	a5,328(a5)
ffffffffc02048ba:	cfb9                	beqz	a5,ffffffffc0204918 <fd_array_alloc+0x6e>
ffffffffc02048bc:	4b98                	lw	a4,16(a5)
ffffffffc02048be:	04e05d63          	blez	a4,ffffffffc0204918 <fd_array_alloc+0x6e>
ffffffffc02048c2:	775d                	lui	a4,0xffff7
ffffffffc02048c4:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02048c8:	679c                	ld	a5,8(a5)
ffffffffc02048ca:	02e50763          	beq	a0,a4,ffffffffc02048f8 <fd_array_alloc+0x4e>
ffffffffc02048ce:	04700713          	li	a4,71
ffffffffc02048d2:	04a76163          	bltu	a4,a0,ffffffffc0204914 <fd_array_alloc+0x6a>
ffffffffc02048d6:	00351713          	slli	a4,a0,0x3
ffffffffc02048da:	8f09                	sub	a4,a4,a0
ffffffffc02048dc:	070e                	slli	a4,a4,0x3
ffffffffc02048de:	97ba                	add	a5,a5,a4
ffffffffc02048e0:	4398                	lw	a4,0(a5)
ffffffffc02048e2:	e71d                	bnez	a4,ffffffffc0204910 <fd_array_alloc+0x66>
ffffffffc02048e4:	5b88                	lw	a0,48(a5)
ffffffffc02048e6:	e91d                	bnez	a0,ffffffffc020491c <fd_array_alloc+0x72>
ffffffffc02048e8:	4705                	li	a4,1
ffffffffc02048ea:	0207b423          	sd	zero,40(a5)
ffffffffc02048ee:	c398                	sw	a4,0(a5)
ffffffffc02048f0:	e19c                	sd	a5,0(a1)
ffffffffc02048f2:	60a2                	ld	ra,8(sp)
ffffffffc02048f4:	0141                	addi	sp,sp,16
ffffffffc02048f6:	8082                	ret
ffffffffc02048f8:	7ff78693          	addi	a3,a5,2047
ffffffffc02048fc:	7c168693          	addi	a3,a3,1985
ffffffffc0204900:	4398                	lw	a4,0(a5)
ffffffffc0204902:	d36d                	beqz	a4,ffffffffc02048e4 <fd_array_alloc+0x3a>
ffffffffc0204904:	03878793          	addi	a5,a5,56
ffffffffc0204908:	fed79ce3          	bne	a5,a3,ffffffffc0204900 <fd_array_alloc+0x56>
ffffffffc020490c:	5529                	li	a0,-22
ffffffffc020490e:	b7d5                	j	ffffffffc02048f2 <fd_array_alloc+0x48>
ffffffffc0204910:	5545                	li	a0,-15
ffffffffc0204912:	b7c5                	j	ffffffffc02048f2 <fd_array_alloc+0x48>
ffffffffc0204914:	5575                	li	a0,-3
ffffffffc0204916:	bff1                	j	ffffffffc02048f2 <fd_array_alloc+0x48>
ffffffffc0204918:	f71ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>
ffffffffc020491c:	00009697          	auipc	a3,0x9
ffffffffc0204920:	f8c68693          	addi	a3,a3,-116 # ffffffffc020d8a8 <etext+0x1a94>
ffffffffc0204924:	00008617          	auipc	a2,0x8
ffffffffc0204928:	92c60613          	addi	a2,a2,-1748 # ffffffffc020c250 <etext+0x43c>
ffffffffc020492c:	03b00593          	li	a1,59
ffffffffc0204930:	00009517          	auipc	a0,0x9
ffffffffc0204934:	f6850513          	addi	a0,a0,-152 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204938:	b13fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020493c <fd_array_free>:
ffffffffc020493c:	4118                	lw	a4,0(a0)
ffffffffc020493e:	1101                	addi	sp,sp,-32
ffffffffc0204940:	ec06                	sd	ra,24(sp)
ffffffffc0204942:	4685                	li	a3,1
ffffffffc0204944:	ffd77613          	andi	a2,a4,-3
ffffffffc0204948:	04d61763          	bne	a2,a3,ffffffffc0204996 <fd_array_free+0x5a>
ffffffffc020494c:	5914                	lw	a3,48(a0)
ffffffffc020494e:	87aa                	mv	a5,a0
ffffffffc0204950:	e29d                	bnez	a3,ffffffffc0204976 <fd_array_free+0x3a>
ffffffffc0204952:	468d                	li	a3,3
ffffffffc0204954:	00d70763          	beq	a4,a3,ffffffffc0204962 <fd_array_free+0x26>
ffffffffc0204958:	60e2                	ld	ra,24(sp)
ffffffffc020495a:	0007a023          	sw	zero,0(a5)
ffffffffc020495e:	6105                	addi	sp,sp,32
ffffffffc0204960:	8082                	ret
ffffffffc0204962:	7508                	ld	a0,40(a0)
ffffffffc0204964:	e43e                	sd	a5,8(sp)
ffffffffc0204966:	7c3030ef          	jal	ffffffffc0208928 <vfs_close>
ffffffffc020496a:	67a2                	ld	a5,8(sp)
ffffffffc020496c:	60e2                	ld	ra,24(sp)
ffffffffc020496e:	0007a023          	sw	zero,0(a5)
ffffffffc0204972:	6105                	addi	sp,sp,32
ffffffffc0204974:	8082                	ret
ffffffffc0204976:	00009697          	auipc	a3,0x9
ffffffffc020497a:	f3268693          	addi	a3,a3,-206 # ffffffffc020d8a8 <etext+0x1a94>
ffffffffc020497e:	00008617          	auipc	a2,0x8
ffffffffc0204982:	8d260613          	addi	a2,a2,-1838 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204986:	04500593          	li	a1,69
ffffffffc020498a:	00009517          	auipc	a0,0x9
ffffffffc020498e:	f0e50513          	addi	a0,a0,-242 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204992:	ab9fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204996:	00009697          	auipc	a3,0x9
ffffffffc020499a:	f4a68693          	addi	a3,a3,-182 # ffffffffc020d8e0 <etext+0x1acc>
ffffffffc020499e:	00008617          	auipc	a2,0x8
ffffffffc02049a2:	8b260613          	addi	a2,a2,-1870 # ffffffffc020c250 <etext+0x43c>
ffffffffc02049a6:	04400593          	li	a1,68
ffffffffc02049aa:	00009517          	auipc	a0,0x9
ffffffffc02049ae:	eee50513          	addi	a0,a0,-274 # ffffffffc020d898 <etext+0x1a84>
ffffffffc02049b2:	a99fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02049b6 <fd_array_release>:
ffffffffc02049b6:	411c                	lw	a5,0(a0)
ffffffffc02049b8:	1141                	addi	sp,sp,-16
ffffffffc02049ba:	e406                	sd	ra,8(sp)
ffffffffc02049bc:	4685                	li	a3,1
ffffffffc02049be:	37f9                	addiw	a5,a5,-2
ffffffffc02049c0:	02f6ef63          	bltu	a3,a5,ffffffffc02049fe <fd_array_release+0x48>
ffffffffc02049c4:	591c                	lw	a5,48(a0)
ffffffffc02049c6:	00f05c63          	blez	a5,ffffffffc02049de <fd_array_release+0x28>
ffffffffc02049ca:	37fd                	addiw	a5,a5,-1
ffffffffc02049cc:	d91c                	sw	a5,48(a0)
ffffffffc02049ce:	c781                	beqz	a5,ffffffffc02049d6 <fd_array_release+0x20>
ffffffffc02049d0:	60a2                	ld	ra,8(sp)
ffffffffc02049d2:	0141                	addi	sp,sp,16
ffffffffc02049d4:	8082                	ret
ffffffffc02049d6:	60a2                	ld	ra,8(sp)
ffffffffc02049d8:	0141                	addi	sp,sp,16
ffffffffc02049da:	f63ff06f          	j	ffffffffc020493c <fd_array_free>
ffffffffc02049de:	00009697          	auipc	a3,0x9
ffffffffc02049e2:	f7268693          	addi	a3,a3,-142 # ffffffffc020d950 <etext+0x1b3c>
ffffffffc02049e6:	00008617          	auipc	a2,0x8
ffffffffc02049ea:	86a60613          	addi	a2,a2,-1942 # ffffffffc020c250 <etext+0x43c>
ffffffffc02049ee:	05600593          	li	a1,86
ffffffffc02049f2:	00009517          	auipc	a0,0x9
ffffffffc02049f6:	ea650513          	addi	a0,a0,-346 # ffffffffc020d898 <etext+0x1a84>
ffffffffc02049fa:	a51fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02049fe:	00009697          	auipc	a3,0x9
ffffffffc0204a02:	f1a68693          	addi	a3,a3,-230 # ffffffffc020d918 <etext+0x1b04>
ffffffffc0204a06:	00008617          	auipc	a2,0x8
ffffffffc0204a0a:	84a60613          	addi	a2,a2,-1974 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204a0e:	05500593          	li	a1,85
ffffffffc0204a12:	00009517          	auipc	a0,0x9
ffffffffc0204a16:	e8650513          	addi	a0,a0,-378 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204a1a:	a31fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204a1e <fd_array_open.part.0>:
ffffffffc0204a1e:	1141                	addi	sp,sp,-16
ffffffffc0204a20:	00009697          	auipc	a3,0x9
ffffffffc0204a24:	f4868693          	addi	a3,a3,-184 # ffffffffc020d968 <etext+0x1b54>
ffffffffc0204a28:	00008617          	auipc	a2,0x8
ffffffffc0204a2c:	82860613          	addi	a2,a2,-2008 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204a30:	05f00593          	li	a1,95
ffffffffc0204a34:	00009517          	auipc	a0,0x9
ffffffffc0204a38:	e6450513          	addi	a0,a0,-412 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204a3c:	e406                	sd	ra,8(sp)
ffffffffc0204a3e:	a0dfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204a42 <fd_array_init>:
ffffffffc0204a42:	4781                	li	a5,0
ffffffffc0204a44:	04800713          	li	a4,72
ffffffffc0204a48:	cd1c                	sw	a5,24(a0)
ffffffffc0204a4a:	02052823          	sw	zero,48(a0)
ffffffffc0204a4e:	00052023          	sw	zero,0(a0)
ffffffffc0204a52:	2785                	addiw	a5,a5,1
ffffffffc0204a54:	03850513          	addi	a0,a0,56
ffffffffc0204a58:	fee798e3          	bne	a5,a4,ffffffffc0204a48 <fd_array_init+0x6>
ffffffffc0204a5c:	8082                	ret

ffffffffc0204a5e <fd_array_close>:
ffffffffc0204a5e:	4114                	lw	a3,0(a0)
ffffffffc0204a60:	1101                	addi	sp,sp,-32
ffffffffc0204a62:	ec06                	sd	ra,24(sp)
ffffffffc0204a64:	4789                	li	a5,2
ffffffffc0204a66:	04f69863          	bne	a3,a5,ffffffffc0204ab6 <fd_array_close+0x58>
ffffffffc0204a6a:	591c                	lw	a5,48(a0)
ffffffffc0204a6c:	872a                	mv	a4,a0
ffffffffc0204a6e:	02f05463          	blez	a5,ffffffffc0204a96 <fd_array_close+0x38>
ffffffffc0204a72:	37fd                	addiw	a5,a5,-1
ffffffffc0204a74:	468d                	li	a3,3
ffffffffc0204a76:	d91c                	sw	a5,48(a0)
ffffffffc0204a78:	c114                	sw	a3,0(a0)
ffffffffc0204a7a:	c781                	beqz	a5,ffffffffc0204a82 <fd_array_close+0x24>
ffffffffc0204a7c:	60e2                	ld	ra,24(sp)
ffffffffc0204a7e:	6105                	addi	sp,sp,32
ffffffffc0204a80:	8082                	ret
ffffffffc0204a82:	7508                	ld	a0,40(a0)
ffffffffc0204a84:	e43a                	sd	a4,8(sp)
ffffffffc0204a86:	6a3030ef          	jal	ffffffffc0208928 <vfs_close>
ffffffffc0204a8a:	6722                	ld	a4,8(sp)
ffffffffc0204a8c:	60e2                	ld	ra,24(sp)
ffffffffc0204a8e:	00072023          	sw	zero,0(a4)
ffffffffc0204a92:	6105                	addi	sp,sp,32
ffffffffc0204a94:	8082                	ret
ffffffffc0204a96:	00009697          	auipc	a3,0x9
ffffffffc0204a9a:	eba68693          	addi	a3,a3,-326 # ffffffffc020d950 <etext+0x1b3c>
ffffffffc0204a9e:	00007617          	auipc	a2,0x7
ffffffffc0204aa2:	7b260613          	addi	a2,a2,1970 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204aa6:	06800593          	li	a1,104
ffffffffc0204aaa:	00009517          	auipc	a0,0x9
ffffffffc0204aae:	dee50513          	addi	a0,a0,-530 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204ab2:	999fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ab6:	00009697          	auipc	a3,0x9
ffffffffc0204aba:	e0a68693          	addi	a3,a3,-502 # ffffffffc020d8c0 <etext+0x1aac>
ffffffffc0204abe:	00007617          	auipc	a2,0x7
ffffffffc0204ac2:	79260613          	addi	a2,a2,1938 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204ac6:	06700593          	li	a1,103
ffffffffc0204aca:	00009517          	auipc	a0,0x9
ffffffffc0204ace:	dce50513          	addi	a0,a0,-562 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204ad2:	979fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204ad6 <fd_array_dup>:
ffffffffc0204ad6:	4118                	lw	a4,0(a0)
ffffffffc0204ad8:	1101                	addi	sp,sp,-32
ffffffffc0204ada:	ec06                	sd	ra,24(sp)
ffffffffc0204adc:	e822                	sd	s0,16(sp)
ffffffffc0204ade:	e426                	sd	s1,8(sp)
ffffffffc0204ae0:	e04a                	sd	s2,0(sp)
ffffffffc0204ae2:	4785                	li	a5,1
ffffffffc0204ae4:	04f71563          	bne	a4,a5,ffffffffc0204b2e <fd_array_dup+0x58>
ffffffffc0204ae8:	0005a903          	lw	s2,0(a1)
ffffffffc0204aec:	4789                	li	a5,2
ffffffffc0204aee:	04f91063          	bne	s2,a5,ffffffffc0204b2e <fd_array_dup+0x58>
ffffffffc0204af2:	719c                	ld	a5,32(a1)
ffffffffc0204af4:	7584                	ld	s1,40(a1)
ffffffffc0204af6:	842a                	mv	s0,a0
ffffffffc0204af8:	f11c                	sd	a5,32(a0)
ffffffffc0204afa:	699c                	ld	a5,16(a1)
ffffffffc0204afc:	6598                	ld	a4,8(a1)
ffffffffc0204afe:	8526                	mv	a0,s1
ffffffffc0204b00:	e81c                	sd	a5,16(s0)
ffffffffc0204b02:	e418                	sd	a4,8(s0)
ffffffffc0204b04:	538030ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0204b08:	8526                	mv	a0,s1
ffffffffc0204b0a:	53c030ef          	jal	ffffffffc0208046 <inode_open_inc>
ffffffffc0204b0e:	401c                	lw	a5,0(s0)
ffffffffc0204b10:	f404                	sd	s1,40(s0)
ffffffffc0204b12:	17fd                	addi	a5,a5,-1
ffffffffc0204b14:	ef8d                	bnez	a5,ffffffffc0204b4e <fd_array_dup+0x78>
ffffffffc0204b16:	cc85                	beqz	s1,ffffffffc0204b4e <fd_array_dup+0x78>
ffffffffc0204b18:	581c                	lw	a5,48(s0)
ffffffffc0204b1a:	01242023          	sw	s2,0(s0)
ffffffffc0204b1e:	60e2                	ld	ra,24(sp)
ffffffffc0204b20:	2785                	addiw	a5,a5,1
ffffffffc0204b22:	d81c                	sw	a5,48(s0)
ffffffffc0204b24:	6442                	ld	s0,16(sp)
ffffffffc0204b26:	64a2                	ld	s1,8(sp)
ffffffffc0204b28:	6902                	ld	s2,0(sp)
ffffffffc0204b2a:	6105                	addi	sp,sp,32
ffffffffc0204b2c:	8082                	ret
ffffffffc0204b2e:	00009697          	auipc	a3,0x9
ffffffffc0204b32:	e6a68693          	addi	a3,a3,-406 # ffffffffc020d998 <etext+0x1b84>
ffffffffc0204b36:	00007617          	auipc	a2,0x7
ffffffffc0204b3a:	71a60613          	addi	a2,a2,1818 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204b3e:	07300593          	li	a1,115
ffffffffc0204b42:	00009517          	auipc	a0,0x9
ffffffffc0204b46:	d5650513          	addi	a0,a0,-682 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204b4a:	901fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204b4e:	ed1ff0ef          	jal	ffffffffc0204a1e <fd_array_open.part.0>

ffffffffc0204b52 <file_testfd>:
ffffffffc0204b52:	04700793          	li	a5,71
ffffffffc0204b56:	04a7e263          	bltu	a5,a0,ffffffffc0204b9a <file_testfd+0x48>
ffffffffc0204b5a:	00092797          	auipc	a5,0x92
ffffffffc0204b5e:	d6e7b783          	ld	a5,-658(a5) # ffffffffc02968c8 <current>
ffffffffc0204b62:	1487b783          	ld	a5,328(a5)
ffffffffc0204b66:	cf85                	beqz	a5,ffffffffc0204b9e <file_testfd+0x4c>
ffffffffc0204b68:	4b98                	lw	a4,16(a5)
ffffffffc0204b6a:	02e05a63          	blez	a4,ffffffffc0204b9e <file_testfd+0x4c>
ffffffffc0204b6e:	6798                	ld	a4,8(a5)
ffffffffc0204b70:	00351793          	slli	a5,a0,0x3
ffffffffc0204b74:	8f89                	sub	a5,a5,a0
ffffffffc0204b76:	078e                	slli	a5,a5,0x3
ffffffffc0204b78:	97ba                	add	a5,a5,a4
ffffffffc0204b7a:	4394                	lw	a3,0(a5)
ffffffffc0204b7c:	4709                	li	a4,2
ffffffffc0204b7e:	00e69e63          	bne	a3,a4,ffffffffc0204b9a <file_testfd+0x48>
ffffffffc0204b82:	4f98                	lw	a4,24(a5)
ffffffffc0204b84:	00a71b63          	bne	a4,a0,ffffffffc0204b9a <file_testfd+0x48>
ffffffffc0204b88:	c199                	beqz	a1,ffffffffc0204b8e <file_testfd+0x3c>
ffffffffc0204b8a:	6788                	ld	a0,8(a5)
ffffffffc0204b8c:	c901                	beqz	a0,ffffffffc0204b9c <file_testfd+0x4a>
ffffffffc0204b8e:	4505                	li	a0,1
ffffffffc0204b90:	c611                	beqz	a2,ffffffffc0204b9c <file_testfd+0x4a>
ffffffffc0204b92:	6b88                	ld	a0,16(a5)
ffffffffc0204b94:	00a03533          	snez	a0,a0
ffffffffc0204b98:	8082                	ret
ffffffffc0204b9a:	4501                	li	a0,0
ffffffffc0204b9c:	8082                	ret
ffffffffc0204b9e:	1141                	addi	sp,sp,-16
ffffffffc0204ba0:	e406                	sd	ra,8(sp)
ffffffffc0204ba2:	ce7ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc0204ba6 <file_open>:
ffffffffc0204ba6:	0035f793          	andi	a5,a1,3
ffffffffc0204baa:	470d                	li	a4,3
ffffffffc0204bac:	0ee78563          	beq	a5,a4,ffffffffc0204c96 <file_open+0xf0>
ffffffffc0204bb0:	078e                	slli	a5,a5,0x3
ffffffffc0204bb2:	0000b717          	auipc	a4,0xb
ffffffffc0204bb6:	81670713          	addi	a4,a4,-2026 # ffffffffc020f3c8 <CSWTCH.79>
ffffffffc0204bba:	0000b697          	auipc	a3,0xb
ffffffffc0204bbe:	82668693          	addi	a3,a3,-2010 # ffffffffc020f3e0 <CSWTCH.78>
ffffffffc0204bc2:	96be                	add	a3,a3,a5
ffffffffc0204bc4:	97ba                	add	a5,a5,a4
ffffffffc0204bc6:	7159                	addi	sp,sp,-112
ffffffffc0204bc8:	639c                	ld	a5,0(a5)
ffffffffc0204bca:	6298                	ld	a4,0(a3)
ffffffffc0204bcc:	eca6                	sd	s1,88(sp)
ffffffffc0204bce:	84aa                	mv	s1,a0
ffffffffc0204bd0:	755d                	lui	a0,0xffff7
ffffffffc0204bd2:	f0a2                	sd	s0,96(sp)
ffffffffc0204bd4:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204bd8:	842e                	mv	s0,a1
ffffffffc0204bda:	080c                	addi	a1,sp,16
ffffffffc0204bdc:	e8ca                	sd	s2,80(sp)
ffffffffc0204bde:	e4ce                	sd	s3,72(sp)
ffffffffc0204be0:	f486                	sd	ra,104(sp)
ffffffffc0204be2:	89be                	mv	s3,a5
ffffffffc0204be4:	893a                	mv	s2,a4
ffffffffc0204be6:	cc5ff0ef          	jal	ffffffffc02048aa <fd_array_alloc>
ffffffffc0204bea:	87aa                	mv	a5,a0
ffffffffc0204bec:	c909                	beqz	a0,ffffffffc0204bfe <file_open+0x58>
ffffffffc0204bee:	70a6                	ld	ra,104(sp)
ffffffffc0204bf0:	7406                	ld	s0,96(sp)
ffffffffc0204bf2:	64e6                	ld	s1,88(sp)
ffffffffc0204bf4:	6946                	ld	s2,80(sp)
ffffffffc0204bf6:	69a6                	ld	s3,72(sp)
ffffffffc0204bf8:	853e                	mv	a0,a5
ffffffffc0204bfa:	6165                	addi	sp,sp,112
ffffffffc0204bfc:	8082                	ret
ffffffffc0204bfe:	8526                	mv	a0,s1
ffffffffc0204c00:	0830                	addi	a2,sp,24
ffffffffc0204c02:	85a2                	mv	a1,s0
ffffffffc0204c04:	34f030ef          	jal	ffffffffc0208752 <vfs_open>
ffffffffc0204c08:	6742                	ld	a4,16(sp)
ffffffffc0204c0a:	e141                	bnez	a0,ffffffffc0204c8a <file_open+0xe4>
ffffffffc0204c0c:	02073023          	sd	zero,32(a4)
ffffffffc0204c10:	02047593          	andi	a1,s0,32
ffffffffc0204c14:	c98d                	beqz	a1,ffffffffc0204c46 <file_open+0xa0>
ffffffffc0204c16:	6562                	ld	a0,24(sp)
ffffffffc0204c18:	c541                	beqz	a0,ffffffffc0204ca0 <file_open+0xfa>
ffffffffc0204c1a:	793c                	ld	a5,112(a0)
ffffffffc0204c1c:	c3d1                	beqz	a5,ffffffffc0204ca0 <file_open+0xfa>
ffffffffc0204c1e:	779c                	ld	a5,40(a5)
ffffffffc0204c20:	c3c1                	beqz	a5,ffffffffc0204ca0 <file_open+0xfa>
ffffffffc0204c22:	00009597          	auipc	a1,0x9
ffffffffc0204c26:	dfe58593          	addi	a1,a1,-514 # ffffffffc020da20 <etext+0x1c0c>
ffffffffc0204c2a:	e43a                	sd	a4,8(sp)
ffffffffc0204c2c:	e02a                	sd	a0,0(sp)
ffffffffc0204c2e:	422030ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0204c32:	6502                	ld	a0,0(sp)
ffffffffc0204c34:	100c                	addi	a1,sp,32
ffffffffc0204c36:	793c                	ld	a5,112(a0)
ffffffffc0204c38:	6562                	ld	a0,24(sp)
ffffffffc0204c3a:	779c                	ld	a5,40(a5)
ffffffffc0204c3c:	9782                	jalr	a5
ffffffffc0204c3e:	6722                	ld	a4,8(sp)
ffffffffc0204c40:	e91d                	bnez	a0,ffffffffc0204c76 <file_open+0xd0>
ffffffffc0204c42:	77e2                	ld	a5,56(sp)
ffffffffc0204c44:	f31c                	sd	a5,32(a4)
ffffffffc0204c46:	66e2                	ld	a3,24(sp)
ffffffffc0204c48:	431c                	lw	a5,0(a4)
ffffffffc0204c4a:	01273423          	sd	s2,8(a4)
ffffffffc0204c4e:	01373823          	sd	s3,16(a4)
ffffffffc0204c52:	f714                	sd	a3,40(a4)
ffffffffc0204c54:	17fd                	addi	a5,a5,-1
ffffffffc0204c56:	e3b9                	bnez	a5,ffffffffc0204c9c <file_open+0xf6>
ffffffffc0204c58:	c2b1                	beqz	a3,ffffffffc0204c9c <file_open+0xf6>
ffffffffc0204c5a:	5b1c                	lw	a5,48(a4)
ffffffffc0204c5c:	70a6                	ld	ra,104(sp)
ffffffffc0204c5e:	7406                	ld	s0,96(sp)
ffffffffc0204c60:	2785                	addiw	a5,a5,1
ffffffffc0204c62:	db1c                	sw	a5,48(a4)
ffffffffc0204c64:	4f1c                	lw	a5,24(a4)
ffffffffc0204c66:	4689                	li	a3,2
ffffffffc0204c68:	c314                	sw	a3,0(a4)
ffffffffc0204c6a:	64e6                	ld	s1,88(sp)
ffffffffc0204c6c:	6946                	ld	s2,80(sp)
ffffffffc0204c6e:	69a6                	ld	s3,72(sp)
ffffffffc0204c70:	853e                	mv	a0,a5
ffffffffc0204c72:	6165                	addi	sp,sp,112
ffffffffc0204c74:	8082                	ret
ffffffffc0204c76:	e42a                	sd	a0,8(sp)
ffffffffc0204c78:	6562                	ld	a0,24(sp)
ffffffffc0204c7a:	e03a                	sd	a4,0(sp)
ffffffffc0204c7c:	4ad030ef          	jal	ffffffffc0208928 <vfs_close>
ffffffffc0204c80:	6502                	ld	a0,0(sp)
ffffffffc0204c82:	cbbff0ef          	jal	ffffffffc020493c <fd_array_free>
ffffffffc0204c86:	67a2                	ld	a5,8(sp)
ffffffffc0204c88:	b79d                	j	ffffffffc0204bee <file_open+0x48>
ffffffffc0204c8a:	e02a                	sd	a0,0(sp)
ffffffffc0204c8c:	853a                	mv	a0,a4
ffffffffc0204c8e:	cafff0ef          	jal	ffffffffc020493c <fd_array_free>
ffffffffc0204c92:	6782                	ld	a5,0(sp)
ffffffffc0204c94:	bfa9                	j	ffffffffc0204bee <file_open+0x48>
ffffffffc0204c96:	57f5                	li	a5,-3
ffffffffc0204c98:	853e                	mv	a0,a5
ffffffffc0204c9a:	8082                	ret
ffffffffc0204c9c:	d83ff0ef          	jal	ffffffffc0204a1e <fd_array_open.part.0>
ffffffffc0204ca0:	00009697          	auipc	a3,0x9
ffffffffc0204ca4:	d3068693          	addi	a3,a3,-720 # ffffffffc020d9d0 <etext+0x1bbc>
ffffffffc0204ca8:	00007617          	auipc	a2,0x7
ffffffffc0204cac:	5a860613          	addi	a2,a2,1448 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204cb0:	0b500593          	li	a1,181
ffffffffc0204cb4:	00009517          	auipc	a0,0x9
ffffffffc0204cb8:	be450513          	addi	a0,a0,-1052 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204cbc:	f8efb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204cc0 <file_close>:
ffffffffc0204cc0:	04700793          	li	a5,71
ffffffffc0204cc4:	04a7e663          	bltu	a5,a0,ffffffffc0204d10 <file_close+0x50>
ffffffffc0204cc8:	00092717          	auipc	a4,0x92
ffffffffc0204ccc:	c0073703          	ld	a4,-1024(a4) # ffffffffc02968c8 <current>
ffffffffc0204cd0:	1141                	addi	sp,sp,-16
ffffffffc0204cd2:	e406                	sd	ra,8(sp)
ffffffffc0204cd4:	14873703          	ld	a4,328(a4)
ffffffffc0204cd8:	87aa                	mv	a5,a0
ffffffffc0204cda:	cf0d                	beqz	a4,ffffffffc0204d14 <file_close+0x54>
ffffffffc0204cdc:	4b14                	lw	a3,16(a4)
ffffffffc0204cde:	02d05b63          	blez	a3,ffffffffc0204d14 <file_close+0x54>
ffffffffc0204ce2:	6708                	ld	a0,8(a4)
ffffffffc0204ce4:	00379713          	slli	a4,a5,0x3
ffffffffc0204ce8:	8f1d                	sub	a4,a4,a5
ffffffffc0204cea:	070e                	slli	a4,a4,0x3
ffffffffc0204cec:	953a                	add	a0,a0,a4
ffffffffc0204cee:	4114                	lw	a3,0(a0)
ffffffffc0204cf0:	4709                	li	a4,2
ffffffffc0204cf2:	00e69b63          	bne	a3,a4,ffffffffc0204d08 <file_close+0x48>
ffffffffc0204cf6:	4d18                	lw	a4,24(a0)
ffffffffc0204cf8:	00f71863          	bne	a4,a5,ffffffffc0204d08 <file_close+0x48>
ffffffffc0204cfc:	d63ff0ef          	jal	ffffffffc0204a5e <fd_array_close>
ffffffffc0204d00:	60a2                	ld	ra,8(sp)
ffffffffc0204d02:	4501                	li	a0,0
ffffffffc0204d04:	0141                	addi	sp,sp,16
ffffffffc0204d06:	8082                	ret
ffffffffc0204d08:	60a2                	ld	ra,8(sp)
ffffffffc0204d0a:	5575                	li	a0,-3
ffffffffc0204d0c:	0141                	addi	sp,sp,16
ffffffffc0204d0e:	8082                	ret
ffffffffc0204d10:	5575                	li	a0,-3
ffffffffc0204d12:	8082                	ret
ffffffffc0204d14:	b75ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc0204d18 <file_read>:
ffffffffc0204d18:	711d                	addi	sp,sp,-96
ffffffffc0204d1a:	ec86                	sd	ra,88(sp)
ffffffffc0204d1c:	e0ca                	sd	s2,64(sp)
ffffffffc0204d1e:	0006b023          	sd	zero,0(a3)
ffffffffc0204d22:	04700793          	li	a5,71
ffffffffc0204d26:	0aa7ec63          	bltu	a5,a0,ffffffffc0204dde <file_read+0xc6>
ffffffffc0204d2a:	00092797          	auipc	a5,0x92
ffffffffc0204d2e:	b9e7b783          	ld	a5,-1122(a5) # ffffffffc02968c8 <current>
ffffffffc0204d32:	e4a6                	sd	s1,72(sp)
ffffffffc0204d34:	e8a2                	sd	s0,80(sp)
ffffffffc0204d36:	1487b783          	ld	a5,328(a5)
ffffffffc0204d3a:	fc4e                	sd	s3,56(sp)
ffffffffc0204d3c:	84b6                	mv	s1,a3
ffffffffc0204d3e:	c3f1                	beqz	a5,ffffffffc0204e02 <file_read+0xea>
ffffffffc0204d40:	4b98                	lw	a4,16(a5)
ffffffffc0204d42:	0ce05063          	blez	a4,ffffffffc0204e02 <file_read+0xea>
ffffffffc0204d46:	6780                	ld	s0,8(a5)
ffffffffc0204d48:	00351793          	slli	a5,a0,0x3
ffffffffc0204d4c:	8f89                	sub	a5,a5,a0
ffffffffc0204d4e:	078e                	slli	a5,a5,0x3
ffffffffc0204d50:	943e                	add	s0,s0,a5
ffffffffc0204d52:	00042983          	lw	s3,0(s0)
ffffffffc0204d56:	4789                	li	a5,2
ffffffffc0204d58:	06f99a63          	bne	s3,a5,ffffffffc0204dcc <file_read+0xb4>
ffffffffc0204d5c:	4c1c                	lw	a5,24(s0)
ffffffffc0204d5e:	06a79763          	bne	a5,a0,ffffffffc0204dcc <file_read+0xb4>
ffffffffc0204d62:	641c                	ld	a5,8(s0)
ffffffffc0204d64:	c7a5                	beqz	a5,ffffffffc0204dcc <file_read+0xb4>
ffffffffc0204d66:	581c                	lw	a5,48(s0)
ffffffffc0204d68:	7014                	ld	a3,32(s0)
ffffffffc0204d6a:	0808                	addi	a0,sp,16
ffffffffc0204d6c:	2785                	addiw	a5,a5,1
ffffffffc0204d6e:	d81c                	sw	a5,48(s0)
ffffffffc0204d70:	7a0000ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0204d74:	892a                	mv	s2,a0
ffffffffc0204d76:	7408                	ld	a0,40(s0)
ffffffffc0204d78:	c52d                	beqz	a0,ffffffffc0204de2 <file_read+0xca>
ffffffffc0204d7a:	793c                	ld	a5,112(a0)
ffffffffc0204d7c:	c3bd                	beqz	a5,ffffffffc0204de2 <file_read+0xca>
ffffffffc0204d7e:	6f9c                	ld	a5,24(a5)
ffffffffc0204d80:	c3ad                	beqz	a5,ffffffffc0204de2 <file_read+0xca>
ffffffffc0204d82:	00009597          	auipc	a1,0x9
ffffffffc0204d86:	cf658593          	addi	a1,a1,-778 # ffffffffc020da78 <etext+0x1c64>
ffffffffc0204d8a:	e42a                	sd	a0,8(sp)
ffffffffc0204d8c:	2c4030ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0204d90:	6522                	ld	a0,8(sp)
ffffffffc0204d92:	85ca                	mv	a1,s2
ffffffffc0204d94:	793c                	ld	a5,112(a0)
ffffffffc0204d96:	7408                	ld	a0,40(s0)
ffffffffc0204d98:	6f9c                	ld	a5,24(a5)
ffffffffc0204d9a:	9782                	jalr	a5
ffffffffc0204d9c:	01093783          	ld	a5,16(s2)
ffffffffc0204da0:	01893683          	ld	a3,24(s2)
ffffffffc0204da4:	4018                	lw	a4,0(s0)
ffffffffc0204da6:	892a                	mv	s2,a0
ffffffffc0204da8:	8f95                	sub	a5,a5,a3
ffffffffc0204daa:	01371563          	bne	a4,s3,ffffffffc0204db4 <file_read+0x9c>
ffffffffc0204dae:	7018                	ld	a4,32(s0)
ffffffffc0204db0:	973e                	add	a4,a4,a5
ffffffffc0204db2:	f018                	sd	a4,32(s0)
ffffffffc0204db4:	e09c                	sd	a5,0(s1)
ffffffffc0204db6:	8522                	mv	a0,s0
ffffffffc0204db8:	bffff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc0204dbc:	6446                	ld	s0,80(sp)
ffffffffc0204dbe:	64a6                	ld	s1,72(sp)
ffffffffc0204dc0:	79e2                	ld	s3,56(sp)
ffffffffc0204dc2:	60e6                	ld	ra,88(sp)
ffffffffc0204dc4:	854a                	mv	a0,s2
ffffffffc0204dc6:	6906                	ld	s2,64(sp)
ffffffffc0204dc8:	6125                	addi	sp,sp,96
ffffffffc0204dca:	8082                	ret
ffffffffc0204dcc:	6446                	ld	s0,80(sp)
ffffffffc0204dce:	60e6                	ld	ra,88(sp)
ffffffffc0204dd0:	5975                	li	s2,-3
ffffffffc0204dd2:	64a6                	ld	s1,72(sp)
ffffffffc0204dd4:	79e2                	ld	s3,56(sp)
ffffffffc0204dd6:	854a                	mv	a0,s2
ffffffffc0204dd8:	6906                	ld	s2,64(sp)
ffffffffc0204dda:	6125                	addi	sp,sp,96
ffffffffc0204ddc:	8082                	ret
ffffffffc0204dde:	5975                	li	s2,-3
ffffffffc0204de0:	b7cd                	j	ffffffffc0204dc2 <file_read+0xaa>
ffffffffc0204de2:	00009697          	auipc	a3,0x9
ffffffffc0204de6:	c4668693          	addi	a3,a3,-954 # ffffffffc020da28 <etext+0x1c14>
ffffffffc0204dea:	00007617          	auipc	a2,0x7
ffffffffc0204dee:	46660613          	addi	a2,a2,1126 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204df2:	0de00593          	li	a1,222
ffffffffc0204df6:	00009517          	auipc	a0,0x9
ffffffffc0204dfa:	aa250513          	addi	a0,a0,-1374 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204dfe:	e4cfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204e02:	a87ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc0204e06 <file_write>:
ffffffffc0204e06:	711d                	addi	sp,sp,-96
ffffffffc0204e08:	ec86                	sd	ra,88(sp)
ffffffffc0204e0a:	e0ca                	sd	s2,64(sp)
ffffffffc0204e0c:	0006b023          	sd	zero,0(a3)
ffffffffc0204e10:	04700793          	li	a5,71
ffffffffc0204e14:	0aa7ec63          	bltu	a5,a0,ffffffffc0204ecc <file_write+0xc6>
ffffffffc0204e18:	00092797          	auipc	a5,0x92
ffffffffc0204e1c:	ab07b783          	ld	a5,-1360(a5) # ffffffffc02968c8 <current>
ffffffffc0204e20:	e4a6                	sd	s1,72(sp)
ffffffffc0204e22:	e8a2                	sd	s0,80(sp)
ffffffffc0204e24:	1487b783          	ld	a5,328(a5)
ffffffffc0204e28:	fc4e                	sd	s3,56(sp)
ffffffffc0204e2a:	84b6                	mv	s1,a3
ffffffffc0204e2c:	c3f1                	beqz	a5,ffffffffc0204ef0 <file_write+0xea>
ffffffffc0204e2e:	4b98                	lw	a4,16(a5)
ffffffffc0204e30:	0ce05063          	blez	a4,ffffffffc0204ef0 <file_write+0xea>
ffffffffc0204e34:	6780                	ld	s0,8(a5)
ffffffffc0204e36:	00351793          	slli	a5,a0,0x3
ffffffffc0204e3a:	8f89                	sub	a5,a5,a0
ffffffffc0204e3c:	078e                	slli	a5,a5,0x3
ffffffffc0204e3e:	943e                	add	s0,s0,a5
ffffffffc0204e40:	00042983          	lw	s3,0(s0)
ffffffffc0204e44:	4789                	li	a5,2
ffffffffc0204e46:	06f99a63          	bne	s3,a5,ffffffffc0204eba <file_write+0xb4>
ffffffffc0204e4a:	4c1c                	lw	a5,24(s0)
ffffffffc0204e4c:	06a79763          	bne	a5,a0,ffffffffc0204eba <file_write+0xb4>
ffffffffc0204e50:	681c                	ld	a5,16(s0)
ffffffffc0204e52:	c7a5                	beqz	a5,ffffffffc0204eba <file_write+0xb4>
ffffffffc0204e54:	581c                	lw	a5,48(s0)
ffffffffc0204e56:	7014                	ld	a3,32(s0)
ffffffffc0204e58:	0808                	addi	a0,sp,16
ffffffffc0204e5a:	2785                	addiw	a5,a5,1
ffffffffc0204e5c:	d81c                	sw	a5,48(s0)
ffffffffc0204e5e:	6b2000ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0204e62:	892a                	mv	s2,a0
ffffffffc0204e64:	7408                	ld	a0,40(s0)
ffffffffc0204e66:	c52d                	beqz	a0,ffffffffc0204ed0 <file_write+0xca>
ffffffffc0204e68:	793c                	ld	a5,112(a0)
ffffffffc0204e6a:	c3bd                	beqz	a5,ffffffffc0204ed0 <file_write+0xca>
ffffffffc0204e6c:	739c                	ld	a5,32(a5)
ffffffffc0204e6e:	c3ad                	beqz	a5,ffffffffc0204ed0 <file_write+0xca>
ffffffffc0204e70:	00009597          	auipc	a1,0x9
ffffffffc0204e74:	c6058593          	addi	a1,a1,-928 # ffffffffc020dad0 <etext+0x1cbc>
ffffffffc0204e78:	e42a                	sd	a0,8(sp)
ffffffffc0204e7a:	1d6030ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0204e7e:	6522                	ld	a0,8(sp)
ffffffffc0204e80:	85ca                	mv	a1,s2
ffffffffc0204e82:	793c                	ld	a5,112(a0)
ffffffffc0204e84:	7408                	ld	a0,40(s0)
ffffffffc0204e86:	739c                	ld	a5,32(a5)
ffffffffc0204e88:	9782                	jalr	a5
ffffffffc0204e8a:	01093783          	ld	a5,16(s2)
ffffffffc0204e8e:	01893683          	ld	a3,24(s2)
ffffffffc0204e92:	4018                	lw	a4,0(s0)
ffffffffc0204e94:	892a                	mv	s2,a0
ffffffffc0204e96:	8f95                	sub	a5,a5,a3
ffffffffc0204e98:	01371563          	bne	a4,s3,ffffffffc0204ea2 <file_write+0x9c>
ffffffffc0204e9c:	7018                	ld	a4,32(s0)
ffffffffc0204e9e:	973e                	add	a4,a4,a5
ffffffffc0204ea0:	f018                	sd	a4,32(s0)
ffffffffc0204ea2:	e09c                	sd	a5,0(s1)
ffffffffc0204ea4:	8522                	mv	a0,s0
ffffffffc0204ea6:	b11ff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc0204eaa:	6446                	ld	s0,80(sp)
ffffffffc0204eac:	64a6                	ld	s1,72(sp)
ffffffffc0204eae:	79e2                	ld	s3,56(sp)
ffffffffc0204eb0:	60e6                	ld	ra,88(sp)
ffffffffc0204eb2:	854a                	mv	a0,s2
ffffffffc0204eb4:	6906                	ld	s2,64(sp)
ffffffffc0204eb6:	6125                	addi	sp,sp,96
ffffffffc0204eb8:	8082                	ret
ffffffffc0204eba:	6446                	ld	s0,80(sp)
ffffffffc0204ebc:	60e6                	ld	ra,88(sp)
ffffffffc0204ebe:	5975                	li	s2,-3
ffffffffc0204ec0:	64a6                	ld	s1,72(sp)
ffffffffc0204ec2:	79e2                	ld	s3,56(sp)
ffffffffc0204ec4:	854a                	mv	a0,s2
ffffffffc0204ec6:	6906                	ld	s2,64(sp)
ffffffffc0204ec8:	6125                	addi	sp,sp,96
ffffffffc0204eca:	8082                	ret
ffffffffc0204ecc:	5975                	li	s2,-3
ffffffffc0204ece:	b7cd                	j	ffffffffc0204eb0 <file_write+0xaa>
ffffffffc0204ed0:	00009697          	auipc	a3,0x9
ffffffffc0204ed4:	bb068693          	addi	a3,a3,-1104 # ffffffffc020da80 <etext+0x1c6c>
ffffffffc0204ed8:	00007617          	auipc	a2,0x7
ffffffffc0204edc:	37860613          	addi	a2,a2,888 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204ee0:	0f800593          	li	a1,248
ffffffffc0204ee4:	00009517          	auipc	a0,0x9
ffffffffc0204ee8:	9b450513          	addi	a0,a0,-1612 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204eec:	d5efb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ef0:	999ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc0204ef4 <file_seek>:
ffffffffc0204ef4:	7139                	addi	sp,sp,-64
ffffffffc0204ef6:	fc06                	sd	ra,56(sp)
ffffffffc0204ef8:	f426                	sd	s1,40(sp)
ffffffffc0204efa:	04700793          	li	a5,71
ffffffffc0204efe:	0ca7e563          	bltu	a5,a0,ffffffffc0204fc8 <file_seek+0xd4>
ffffffffc0204f02:	00092797          	auipc	a5,0x92
ffffffffc0204f06:	9c67b783          	ld	a5,-1594(a5) # ffffffffc02968c8 <current>
ffffffffc0204f0a:	f822                	sd	s0,48(sp)
ffffffffc0204f0c:	1487b783          	ld	a5,328(a5)
ffffffffc0204f10:	c3e9                	beqz	a5,ffffffffc0204fd2 <file_seek+0xde>
ffffffffc0204f12:	4b98                	lw	a4,16(a5)
ffffffffc0204f14:	0ae05f63          	blez	a4,ffffffffc0204fd2 <file_seek+0xde>
ffffffffc0204f18:	6780                	ld	s0,8(a5)
ffffffffc0204f1a:	00351793          	slli	a5,a0,0x3
ffffffffc0204f1e:	8f89                	sub	a5,a5,a0
ffffffffc0204f20:	078e                	slli	a5,a5,0x3
ffffffffc0204f22:	943e                	add	s0,s0,a5
ffffffffc0204f24:	4018                	lw	a4,0(s0)
ffffffffc0204f26:	4789                	li	a5,2
ffffffffc0204f28:	0af71263          	bne	a4,a5,ffffffffc0204fcc <file_seek+0xd8>
ffffffffc0204f2c:	4c1c                	lw	a5,24(s0)
ffffffffc0204f2e:	f04a                	sd	s2,32(sp)
ffffffffc0204f30:	08a79863          	bne	a5,a0,ffffffffc0204fc0 <file_seek+0xcc>
ffffffffc0204f34:	581c                	lw	a5,48(s0)
ffffffffc0204f36:	4685                	li	a3,1
ffffffffc0204f38:	892e                	mv	s2,a1
ffffffffc0204f3a:	2785                	addiw	a5,a5,1
ffffffffc0204f3c:	d81c                	sw	a5,48(s0)
ffffffffc0204f3e:	06d60d63          	beq	a2,a3,ffffffffc0204fb8 <file_seek+0xc4>
ffffffffc0204f42:	04e60463          	beq	a2,a4,ffffffffc0204f8a <file_seek+0x96>
ffffffffc0204f46:	54f5                	li	s1,-3
ffffffffc0204f48:	e61d                	bnez	a2,ffffffffc0204f76 <file_seek+0x82>
ffffffffc0204f4a:	7404                	ld	s1,40(s0)
ffffffffc0204f4c:	c4d1                	beqz	s1,ffffffffc0204fd8 <file_seek+0xe4>
ffffffffc0204f4e:	78bc                	ld	a5,112(s1)
ffffffffc0204f50:	c7c1                	beqz	a5,ffffffffc0204fd8 <file_seek+0xe4>
ffffffffc0204f52:	6fbc                	ld	a5,88(a5)
ffffffffc0204f54:	c3d1                	beqz	a5,ffffffffc0204fd8 <file_seek+0xe4>
ffffffffc0204f56:	8526                	mv	a0,s1
ffffffffc0204f58:	00009597          	auipc	a1,0x9
ffffffffc0204f5c:	bd058593          	addi	a1,a1,-1072 # ffffffffc020db28 <etext+0x1d14>
ffffffffc0204f60:	0f0030ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0204f64:	78bc                	ld	a5,112(s1)
ffffffffc0204f66:	7408                	ld	a0,40(s0)
ffffffffc0204f68:	85ca                	mv	a1,s2
ffffffffc0204f6a:	6fbc                	ld	a5,88(a5)
ffffffffc0204f6c:	9782                	jalr	a5
ffffffffc0204f6e:	84aa                	mv	s1,a0
ffffffffc0204f70:	e119                	bnez	a0,ffffffffc0204f76 <file_seek+0x82>
ffffffffc0204f72:	03243023          	sd	s2,32(s0)
ffffffffc0204f76:	8522                	mv	a0,s0
ffffffffc0204f78:	a3fff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc0204f7c:	7442                	ld	s0,48(sp)
ffffffffc0204f7e:	7902                	ld	s2,32(sp)
ffffffffc0204f80:	70e2                	ld	ra,56(sp)
ffffffffc0204f82:	8526                	mv	a0,s1
ffffffffc0204f84:	74a2                	ld	s1,40(sp)
ffffffffc0204f86:	6121                	addi	sp,sp,64
ffffffffc0204f88:	8082                	ret
ffffffffc0204f8a:	7404                	ld	s1,40(s0)
ffffffffc0204f8c:	c4b5                	beqz	s1,ffffffffc0204ff8 <file_seek+0x104>
ffffffffc0204f8e:	78bc                	ld	a5,112(s1)
ffffffffc0204f90:	c7a5                	beqz	a5,ffffffffc0204ff8 <file_seek+0x104>
ffffffffc0204f92:	779c                	ld	a5,40(a5)
ffffffffc0204f94:	c3b5                	beqz	a5,ffffffffc0204ff8 <file_seek+0x104>
ffffffffc0204f96:	8526                	mv	a0,s1
ffffffffc0204f98:	00009597          	auipc	a1,0x9
ffffffffc0204f9c:	a8858593          	addi	a1,a1,-1400 # ffffffffc020da20 <etext+0x1c0c>
ffffffffc0204fa0:	0b0030ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0204fa4:	78bc                	ld	a5,112(s1)
ffffffffc0204fa6:	7408                	ld	a0,40(s0)
ffffffffc0204fa8:	858a                	mv	a1,sp
ffffffffc0204faa:	779c                	ld	a5,40(a5)
ffffffffc0204fac:	9782                	jalr	a5
ffffffffc0204fae:	84aa                	mv	s1,a0
ffffffffc0204fb0:	f179                	bnez	a0,ffffffffc0204f76 <file_seek+0x82>
ffffffffc0204fb2:	67e2                	ld	a5,24(sp)
ffffffffc0204fb4:	993e                	add	s2,s2,a5
ffffffffc0204fb6:	bf51                	j	ffffffffc0204f4a <file_seek+0x56>
ffffffffc0204fb8:	701c                	ld	a5,32(s0)
ffffffffc0204fba:	00f58933          	add	s2,a1,a5
ffffffffc0204fbe:	b771                	j	ffffffffc0204f4a <file_seek+0x56>
ffffffffc0204fc0:	7442                	ld	s0,48(sp)
ffffffffc0204fc2:	7902                	ld	s2,32(sp)
ffffffffc0204fc4:	54f5                	li	s1,-3
ffffffffc0204fc6:	bf6d                	j	ffffffffc0204f80 <file_seek+0x8c>
ffffffffc0204fc8:	54f5                	li	s1,-3
ffffffffc0204fca:	bf5d                	j	ffffffffc0204f80 <file_seek+0x8c>
ffffffffc0204fcc:	7442                	ld	s0,48(sp)
ffffffffc0204fce:	54f5                	li	s1,-3
ffffffffc0204fd0:	bf45                	j	ffffffffc0204f80 <file_seek+0x8c>
ffffffffc0204fd2:	f04a                	sd	s2,32(sp)
ffffffffc0204fd4:	8b5ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>
ffffffffc0204fd8:	00009697          	auipc	a3,0x9
ffffffffc0204fdc:	b0068693          	addi	a3,a3,-1280 # ffffffffc020dad8 <etext+0x1cc4>
ffffffffc0204fe0:	00007617          	auipc	a2,0x7
ffffffffc0204fe4:	27060613          	addi	a2,a2,624 # ffffffffc020c250 <etext+0x43c>
ffffffffc0204fe8:	11a00593          	li	a1,282
ffffffffc0204fec:	00009517          	auipc	a0,0x9
ffffffffc0204ff0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0204ff4:	c56fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204ff8:	00009697          	auipc	a3,0x9
ffffffffc0204ffc:	9d868693          	addi	a3,a3,-1576 # ffffffffc020d9d0 <etext+0x1bbc>
ffffffffc0205000:	00007617          	auipc	a2,0x7
ffffffffc0205004:	25060613          	addi	a2,a2,592 # ffffffffc020c250 <etext+0x43c>
ffffffffc0205008:	11200593          	li	a1,274
ffffffffc020500c:	00009517          	auipc	a0,0x9
ffffffffc0205010:	88c50513          	addi	a0,a0,-1908 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0205014:	c36fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205018 <file_fstat>:
ffffffffc0205018:	7179                	addi	sp,sp,-48
ffffffffc020501a:	f406                	sd	ra,40(sp)
ffffffffc020501c:	f022                	sd	s0,32(sp)
ffffffffc020501e:	04700793          	li	a5,71
ffffffffc0205022:	08a7e363          	bltu	a5,a0,ffffffffc02050a8 <file_fstat+0x90>
ffffffffc0205026:	00092797          	auipc	a5,0x92
ffffffffc020502a:	8a27b783          	ld	a5,-1886(a5) # ffffffffc02968c8 <current>
ffffffffc020502e:	ec26                	sd	s1,24(sp)
ffffffffc0205030:	84ae                	mv	s1,a1
ffffffffc0205032:	1487b783          	ld	a5,328(a5)
ffffffffc0205036:	cbd9                	beqz	a5,ffffffffc02050cc <file_fstat+0xb4>
ffffffffc0205038:	4b98                	lw	a4,16(a5)
ffffffffc020503a:	08e05963          	blez	a4,ffffffffc02050cc <file_fstat+0xb4>
ffffffffc020503e:	6780                	ld	s0,8(a5)
ffffffffc0205040:	00351793          	slli	a5,a0,0x3
ffffffffc0205044:	8f89                	sub	a5,a5,a0
ffffffffc0205046:	078e                	slli	a5,a5,0x3
ffffffffc0205048:	943e                	add	s0,s0,a5
ffffffffc020504a:	4018                	lw	a4,0(s0)
ffffffffc020504c:	4789                	li	a5,2
ffffffffc020504e:	04f71663          	bne	a4,a5,ffffffffc020509a <file_fstat+0x82>
ffffffffc0205052:	4c1c                	lw	a5,24(s0)
ffffffffc0205054:	04a79363          	bne	a5,a0,ffffffffc020509a <file_fstat+0x82>
ffffffffc0205058:	581c                	lw	a5,48(s0)
ffffffffc020505a:	7408                	ld	a0,40(s0)
ffffffffc020505c:	2785                	addiw	a5,a5,1
ffffffffc020505e:	d81c                	sw	a5,48(s0)
ffffffffc0205060:	c531                	beqz	a0,ffffffffc02050ac <file_fstat+0x94>
ffffffffc0205062:	793c                	ld	a5,112(a0)
ffffffffc0205064:	c7a1                	beqz	a5,ffffffffc02050ac <file_fstat+0x94>
ffffffffc0205066:	779c                	ld	a5,40(a5)
ffffffffc0205068:	c3b1                	beqz	a5,ffffffffc02050ac <file_fstat+0x94>
ffffffffc020506a:	00009597          	auipc	a1,0x9
ffffffffc020506e:	9b658593          	addi	a1,a1,-1610 # ffffffffc020da20 <etext+0x1c0c>
ffffffffc0205072:	e42a                	sd	a0,8(sp)
ffffffffc0205074:	7dd020ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0205078:	6522                	ld	a0,8(sp)
ffffffffc020507a:	85a6                	mv	a1,s1
ffffffffc020507c:	793c                	ld	a5,112(a0)
ffffffffc020507e:	7408                	ld	a0,40(s0)
ffffffffc0205080:	779c                	ld	a5,40(a5)
ffffffffc0205082:	9782                	jalr	a5
ffffffffc0205084:	87aa                	mv	a5,a0
ffffffffc0205086:	8522                	mv	a0,s0
ffffffffc0205088:	843e                	mv	s0,a5
ffffffffc020508a:	92dff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc020508e:	64e2                	ld	s1,24(sp)
ffffffffc0205090:	70a2                	ld	ra,40(sp)
ffffffffc0205092:	8522                	mv	a0,s0
ffffffffc0205094:	7402                	ld	s0,32(sp)
ffffffffc0205096:	6145                	addi	sp,sp,48
ffffffffc0205098:	8082                	ret
ffffffffc020509a:	5475                	li	s0,-3
ffffffffc020509c:	70a2                	ld	ra,40(sp)
ffffffffc020509e:	8522                	mv	a0,s0
ffffffffc02050a0:	7402                	ld	s0,32(sp)
ffffffffc02050a2:	64e2                	ld	s1,24(sp)
ffffffffc02050a4:	6145                	addi	sp,sp,48
ffffffffc02050a6:	8082                	ret
ffffffffc02050a8:	5475                	li	s0,-3
ffffffffc02050aa:	b7dd                	j	ffffffffc0205090 <file_fstat+0x78>
ffffffffc02050ac:	00009697          	auipc	a3,0x9
ffffffffc02050b0:	92468693          	addi	a3,a3,-1756 # ffffffffc020d9d0 <etext+0x1bbc>
ffffffffc02050b4:	00007617          	auipc	a2,0x7
ffffffffc02050b8:	19c60613          	addi	a2,a2,412 # ffffffffc020c250 <etext+0x43c>
ffffffffc02050bc:	12c00593          	li	a1,300
ffffffffc02050c0:	00008517          	auipc	a0,0x8
ffffffffc02050c4:	7d850513          	addi	a0,a0,2008 # ffffffffc020d898 <etext+0x1a84>
ffffffffc02050c8:	b82fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02050cc:	fbcff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc02050d0 <file_fsync>:
ffffffffc02050d0:	1101                	addi	sp,sp,-32
ffffffffc02050d2:	ec06                	sd	ra,24(sp)
ffffffffc02050d4:	e822                	sd	s0,16(sp)
ffffffffc02050d6:	04700793          	li	a5,71
ffffffffc02050da:	06a7e863          	bltu	a5,a0,ffffffffc020514a <file_fsync+0x7a>
ffffffffc02050de:	00091797          	auipc	a5,0x91
ffffffffc02050e2:	7ea7b783          	ld	a5,2026(a5) # ffffffffc02968c8 <current>
ffffffffc02050e6:	1487b783          	ld	a5,328(a5)
ffffffffc02050ea:	c7d1                	beqz	a5,ffffffffc0205176 <file_fsync+0xa6>
ffffffffc02050ec:	4b98                	lw	a4,16(a5)
ffffffffc02050ee:	08e05463          	blez	a4,ffffffffc0205176 <file_fsync+0xa6>
ffffffffc02050f2:	6780                	ld	s0,8(a5)
ffffffffc02050f4:	00351793          	slli	a5,a0,0x3
ffffffffc02050f8:	8f89                	sub	a5,a5,a0
ffffffffc02050fa:	078e                	slli	a5,a5,0x3
ffffffffc02050fc:	943e                	add	s0,s0,a5
ffffffffc02050fe:	4018                	lw	a4,0(s0)
ffffffffc0205100:	4789                	li	a5,2
ffffffffc0205102:	04f71463          	bne	a4,a5,ffffffffc020514a <file_fsync+0x7a>
ffffffffc0205106:	4c1c                	lw	a5,24(s0)
ffffffffc0205108:	04a79163          	bne	a5,a0,ffffffffc020514a <file_fsync+0x7a>
ffffffffc020510c:	581c                	lw	a5,48(s0)
ffffffffc020510e:	7408                	ld	a0,40(s0)
ffffffffc0205110:	2785                	addiw	a5,a5,1
ffffffffc0205112:	d81c                	sw	a5,48(s0)
ffffffffc0205114:	c129                	beqz	a0,ffffffffc0205156 <file_fsync+0x86>
ffffffffc0205116:	793c                	ld	a5,112(a0)
ffffffffc0205118:	cf9d                	beqz	a5,ffffffffc0205156 <file_fsync+0x86>
ffffffffc020511a:	7b9c                	ld	a5,48(a5)
ffffffffc020511c:	cf8d                	beqz	a5,ffffffffc0205156 <file_fsync+0x86>
ffffffffc020511e:	00009597          	auipc	a1,0x9
ffffffffc0205122:	a6258593          	addi	a1,a1,-1438 # ffffffffc020db80 <etext+0x1d6c>
ffffffffc0205126:	e42a                	sd	a0,8(sp)
ffffffffc0205128:	729020ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc020512c:	6522                	ld	a0,8(sp)
ffffffffc020512e:	793c                	ld	a5,112(a0)
ffffffffc0205130:	7408                	ld	a0,40(s0)
ffffffffc0205132:	7b9c                	ld	a5,48(a5)
ffffffffc0205134:	9782                	jalr	a5
ffffffffc0205136:	87aa                	mv	a5,a0
ffffffffc0205138:	8522                	mv	a0,s0
ffffffffc020513a:	843e                	mv	s0,a5
ffffffffc020513c:	87bff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc0205140:	60e2                	ld	ra,24(sp)
ffffffffc0205142:	8522                	mv	a0,s0
ffffffffc0205144:	6442                	ld	s0,16(sp)
ffffffffc0205146:	6105                	addi	sp,sp,32
ffffffffc0205148:	8082                	ret
ffffffffc020514a:	5475                	li	s0,-3
ffffffffc020514c:	60e2                	ld	ra,24(sp)
ffffffffc020514e:	8522                	mv	a0,s0
ffffffffc0205150:	6442                	ld	s0,16(sp)
ffffffffc0205152:	6105                	addi	sp,sp,32
ffffffffc0205154:	8082                	ret
ffffffffc0205156:	00009697          	auipc	a3,0x9
ffffffffc020515a:	9da68693          	addi	a3,a3,-1574 # ffffffffc020db30 <etext+0x1d1c>
ffffffffc020515e:	00007617          	auipc	a2,0x7
ffffffffc0205162:	0f260613          	addi	a2,a2,242 # ffffffffc020c250 <etext+0x43c>
ffffffffc0205166:	13a00593          	li	a1,314
ffffffffc020516a:	00008517          	auipc	a0,0x8
ffffffffc020516e:	72e50513          	addi	a0,a0,1838 # ffffffffc020d898 <etext+0x1a84>
ffffffffc0205172:	ad8fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205176:	f12ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc020517a <file_getdirentry>:
ffffffffc020517a:	715d                	addi	sp,sp,-80
ffffffffc020517c:	e486                	sd	ra,72(sp)
ffffffffc020517e:	f84a                	sd	s2,48(sp)
ffffffffc0205180:	04700793          	li	a5,71
ffffffffc0205184:	0aa7e963          	bltu	a5,a0,ffffffffc0205236 <file_getdirentry+0xbc>
ffffffffc0205188:	00091797          	auipc	a5,0x91
ffffffffc020518c:	7407b783          	ld	a5,1856(a5) # ffffffffc02968c8 <current>
ffffffffc0205190:	fc26                	sd	s1,56(sp)
ffffffffc0205192:	e0a2                	sd	s0,64(sp)
ffffffffc0205194:	1487b783          	ld	a5,328(a5)
ffffffffc0205198:	84ae                	mv	s1,a1
ffffffffc020519a:	c7e1                	beqz	a5,ffffffffc0205262 <file_getdirentry+0xe8>
ffffffffc020519c:	4b98                	lw	a4,16(a5)
ffffffffc020519e:	0ce05263          	blez	a4,ffffffffc0205262 <file_getdirentry+0xe8>
ffffffffc02051a2:	6780                	ld	s0,8(a5)
ffffffffc02051a4:	00351793          	slli	a5,a0,0x3
ffffffffc02051a8:	8f89                	sub	a5,a5,a0
ffffffffc02051aa:	078e                	slli	a5,a5,0x3
ffffffffc02051ac:	943e                	add	s0,s0,a5
ffffffffc02051ae:	4018                	lw	a4,0(s0)
ffffffffc02051b0:	4789                	li	a5,2
ffffffffc02051b2:	08f71463          	bne	a4,a5,ffffffffc020523a <file_getdirentry+0xc0>
ffffffffc02051b6:	4c1c                	lw	a5,24(s0)
ffffffffc02051b8:	f44e                	sd	s3,40(sp)
ffffffffc02051ba:	06a79963          	bne	a5,a0,ffffffffc020522c <file_getdirentry+0xb2>
ffffffffc02051be:	581c                	lw	a5,48(s0)
ffffffffc02051c0:	6194                	ld	a3,0(a1)
ffffffffc02051c2:	10000613          	li	a2,256
ffffffffc02051c6:	2785                	addiw	a5,a5,1
ffffffffc02051c8:	d81c                	sw	a5,48(s0)
ffffffffc02051ca:	05a1                	addi	a1,a1,8
ffffffffc02051cc:	850a                	mv	a0,sp
ffffffffc02051ce:	342000ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc02051d2:	02843903          	ld	s2,40(s0)
ffffffffc02051d6:	89aa                	mv	s3,a0
ffffffffc02051d8:	06090563          	beqz	s2,ffffffffc0205242 <file_getdirentry+0xc8>
ffffffffc02051dc:	07093783          	ld	a5,112(s2)
ffffffffc02051e0:	c3ad                	beqz	a5,ffffffffc0205242 <file_getdirentry+0xc8>
ffffffffc02051e2:	63bc                	ld	a5,64(a5)
ffffffffc02051e4:	cfb9                	beqz	a5,ffffffffc0205242 <file_getdirentry+0xc8>
ffffffffc02051e6:	854a                	mv	a0,s2
ffffffffc02051e8:	00009597          	auipc	a1,0x9
ffffffffc02051ec:	9f858593          	addi	a1,a1,-1544 # ffffffffc020dbe0 <etext+0x1dcc>
ffffffffc02051f0:	661020ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc02051f4:	07093783          	ld	a5,112(s2)
ffffffffc02051f8:	7408                	ld	a0,40(s0)
ffffffffc02051fa:	85ce                	mv	a1,s3
ffffffffc02051fc:	63bc                	ld	a5,64(a5)
ffffffffc02051fe:	9782                	jalr	a5
ffffffffc0205200:	892a                	mv	s2,a0
ffffffffc0205202:	cd01                	beqz	a0,ffffffffc020521a <file_getdirentry+0xa0>
ffffffffc0205204:	8522                	mv	a0,s0
ffffffffc0205206:	fb0ff0ef          	jal	ffffffffc02049b6 <fd_array_release>
ffffffffc020520a:	6406                	ld	s0,64(sp)
ffffffffc020520c:	74e2                	ld	s1,56(sp)
ffffffffc020520e:	79a2                	ld	s3,40(sp)
ffffffffc0205210:	60a6                	ld	ra,72(sp)
ffffffffc0205212:	854a                	mv	a0,s2
ffffffffc0205214:	7942                	ld	s2,48(sp)
ffffffffc0205216:	6161                	addi	sp,sp,80
ffffffffc0205218:	8082                	ret
ffffffffc020521a:	609c                	ld	a5,0(s1)
ffffffffc020521c:	0109b683          	ld	a3,16(s3)
ffffffffc0205220:	0189b703          	ld	a4,24(s3)
ffffffffc0205224:	97b6                	add	a5,a5,a3
ffffffffc0205226:	8f99                	sub	a5,a5,a4
ffffffffc0205228:	e09c                	sd	a5,0(s1)
ffffffffc020522a:	bfe9                	j	ffffffffc0205204 <file_getdirentry+0x8a>
ffffffffc020522c:	6406                	ld	s0,64(sp)
ffffffffc020522e:	74e2                	ld	s1,56(sp)
ffffffffc0205230:	79a2                	ld	s3,40(sp)
ffffffffc0205232:	5975                	li	s2,-3
ffffffffc0205234:	bff1                	j	ffffffffc0205210 <file_getdirentry+0x96>
ffffffffc0205236:	5975                	li	s2,-3
ffffffffc0205238:	bfe1                	j	ffffffffc0205210 <file_getdirentry+0x96>
ffffffffc020523a:	6406                	ld	s0,64(sp)
ffffffffc020523c:	74e2                	ld	s1,56(sp)
ffffffffc020523e:	5975                	li	s2,-3
ffffffffc0205240:	bfc1                	j	ffffffffc0205210 <file_getdirentry+0x96>
ffffffffc0205242:	00009697          	auipc	a3,0x9
ffffffffc0205246:	94668693          	addi	a3,a3,-1722 # ffffffffc020db88 <etext+0x1d74>
ffffffffc020524a:	00007617          	auipc	a2,0x7
ffffffffc020524e:	00660613          	addi	a2,a2,6 # ffffffffc020c250 <etext+0x43c>
ffffffffc0205252:	14a00593          	li	a1,330
ffffffffc0205256:	00008517          	auipc	a0,0x8
ffffffffc020525a:	64250513          	addi	a0,a0,1602 # ffffffffc020d898 <etext+0x1a84>
ffffffffc020525e:	9ecfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205262:	f44e                	sd	s3,40(sp)
ffffffffc0205264:	e24ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc0205268 <file_dup>:
ffffffffc0205268:	04700713          	li	a4,71
ffffffffc020526c:	06a76263          	bltu	a4,a0,ffffffffc02052d0 <file_dup+0x68>
ffffffffc0205270:	00091717          	auipc	a4,0x91
ffffffffc0205274:	65873703          	ld	a4,1624(a4) # ffffffffc02968c8 <current>
ffffffffc0205278:	7179                	addi	sp,sp,-48
ffffffffc020527a:	f406                	sd	ra,40(sp)
ffffffffc020527c:	14873703          	ld	a4,328(a4)
ffffffffc0205280:	f022                	sd	s0,32(sp)
ffffffffc0205282:	87aa                	mv	a5,a0
ffffffffc0205284:	852e                	mv	a0,a1
ffffffffc0205286:	c739                	beqz	a4,ffffffffc02052d4 <file_dup+0x6c>
ffffffffc0205288:	4b14                	lw	a3,16(a4)
ffffffffc020528a:	04d05563          	blez	a3,ffffffffc02052d4 <file_dup+0x6c>
ffffffffc020528e:	6700                	ld	s0,8(a4)
ffffffffc0205290:	00379713          	slli	a4,a5,0x3
ffffffffc0205294:	8f1d                	sub	a4,a4,a5
ffffffffc0205296:	070e                	slli	a4,a4,0x3
ffffffffc0205298:	943a                	add	s0,s0,a4
ffffffffc020529a:	4014                	lw	a3,0(s0)
ffffffffc020529c:	4709                	li	a4,2
ffffffffc020529e:	02e69463          	bne	a3,a4,ffffffffc02052c6 <file_dup+0x5e>
ffffffffc02052a2:	4c18                	lw	a4,24(s0)
ffffffffc02052a4:	02f71163          	bne	a4,a5,ffffffffc02052c6 <file_dup+0x5e>
ffffffffc02052a8:	082c                	addi	a1,sp,24
ffffffffc02052aa:	e00ff0ef          	jal	ffffffffc02048aa <fd_array_alloc>
ffffffffc02052ae:	e901                	bnez	a0,ffffffffc02052be <file_dup+0x56>
ffffffffc02052b0:	6562                	ld	a0,24(sp)
ffffffffc02052b2:	85a2                	mv	a1,s0
ffffffffc02052b4:	e42a                	sd	a0,8(sp)
ffffffffc02052b6:	821ff0ef          	jal	ffffffffc0204ad6 <fd_array_dup>
ffffffffc02052ba:	6522                	ld	a0,8(sp)
ffffffffc02052bc:	4d08                	lw	a0,24(a0)
ffffffffc02052be:	70a2                	ld	ra,40(sp)
ffffffffc02052c0:	7402                	ld	s0,32(sp)
ffffffffc02052c2:	6145                	addi	sp,sp,48
ffffffffc02052c4:	8082                	ret
ffffffffc02052c6:	70a2                	ld	ra,40(sp)
ffffffffc02052c8:	7402                	ld	s0,32(sp)
ffffffffc02052ca:	5575                	li	a0,-3
ffffffffc02052cc:	6145                	addi	sp,sp,48
ffffffffc02052ce:	8082                	ret
ffffffffc02052d0:	5575                	li	a0,-3
ffffffffc02052d2:	8082                	ret
ffffffffc02052d4:	db4ff0ef          	jal	ffffffffc0204888 <get_fd_array.part.0>

ffffffffc02052d8 <fs_init>:
ffffffffc02052d8:	1141                	addi	sp,sp,-16
ffffffffc02052da:	e406                	sd	ra,8(sp)
ffffffffc02052dc:	77f020ef          	jal	ffffffffc020825a <vfs_init>
ffffffffc02052e0:	48d030ef          	jal	ffffffffc0208f6c <dev_init>
ffffffffc02052e4:	60a2                	ld	ra,8(sp)
ffffffffc02052e6:	0141                	addi	sp,sp,16
ffffffffc02052e8:	6000406f          	j	ffffffffc02098e8 <sfs_init>

ffffffffc02052ec <fs_cleanup>:
ffffffffc02052ec:	1ea0306f          	j	ffffffffc02084d6 <vfs_cleanup>

ffffffffc02052f0 <lock_files>:
ffffffffc02052f0:	0561                	addi	a0,a0,24
ffffffffc02052f2:	b88ff06f          	j	ffffffffc020467a <down>

ffffffffc02052f6 <unlock_files>:
ffffffffc02052f6:	0561                	addi	a0,a0,24
ffffffffc02052f8:	b7eff06f          	j	ffffffffc0204676 <up>

ffffffffc02052fc <files_create>:
ffffffffc02052fc:	1141                	addi	sp,sp,-16
ffffffffc02052fe:	6505                	lui	a0,0x1
ffffffffc0205300:	e022                	sd	s0,0(sp)
ffffffffc0205302:	e406                	sd	ra,8(sp)
ffffffffc0205304:	cf9fc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0205308:	842a                	mv	s0,a0
ffffffffc020530a:	cd19                	beqz	a0,ffffffffc0205328 <files_create+0x2c>
ffffffffc020530c:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc0205310:	e51c                	sd	a5,8(a0)
ffffffffc0205312:	00053023          	sd	zero,0(a0)
ffffffffc0205316:	00052823          	sw	zero,16(a0)
ffffffffc020531a:	4585                	li	a1,1
ffffffffc020531c:	0561                	addi	a0,a0,24
ffffffffc020531e:	b52ff0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc0205322:	6408                	ld	a0,8(s0)
ffffffffc0205324:	f1eff0ef          	jal	ffffffffc0204a42 <fd_array_init>
ffffffffc0205328:	60a2                	ld	ra,8(sp)
ffffffffc020532a:	8522                	mv	a0,s0
ffffffffc020532c:	6402                	ld	s0,0(sp)
ffffffffc020532e:	0141                	addi	sp,sp,16
ffffffffc0205330:	8082                	ret

ffffffffc0205332 <files_destroy>:
ffffffffc0205332:	7179                	addi	sp,sp,-48
ffffffffc0205334:	f406                	sd	ra,40(sp)
ffffffffc0205336:	f022                	sd	s0,32(sp)
ffffffffc0205338:	ec26                	sd	s1,24(sp)
ffffffffc020533a:	e84a                	sd	s2,16(sp)
ffffffffc020533c:	e44e                	sd	s3,8(sp)
ffffffffc020533e:	c52d                	beqz	a0,ffffffffc02053a8 <files_destroy+0x76>
ffffffffc0205340:	491c                	lw	a5,16(a0)
ffffffffc0205342:	89aa                	mv	s3,a0
ffffffffc0205344:	e3b5                	bnez	a5,ffffffffc02053a8 <files_destroy+0x76>
ffffffffc0205346:	6108                	ld	a0,0(a0)
ffffffffc0205348:	c119                	beqz	a0,ffffffffc020534e <files_destroy+0x1c>
ffffffffc020534a:	5c1020ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020534e:	0089b403          	ld	s0,8(s3)
ffffffffc0205352:	4909                	li	s2,2
ffffffffc0205354:	7ff40493          	addi	s1,s0,2047
ffffffffc0205358:	7c148493          	addi	s1,s1,1985
ffffffffc020535c:	401c                	lw	a5,0(s0)
ffffffffc020535e:	03278063          	beq	a5,s2,ffffffffc020537e <files_destroy+0x4c>
ffffffffc0205362:	e39d                	bnez	a5,ffffffffc0205388 <files_destroy+0x56>
ffffffffc0205364:	03840413          	addi	s0,s0,56
ffffffffc0205368:	fe941ae3          	bne	s0,s1,ffffffffc020535c <files_destroy+0x2a>
ffffffffc020536c:	7402                	ld	s0,32(sp)
ffffffffc020536e:	70a2                	ld	ra,40(sp)
ffffffffc0205370:	64e2                	ld	s1,24(sp)
ffffffffc0205372:	6942                	ld	s2,16(sp)
ffffffffc0205374:	854e                	mv	a0,s3
ffffffffc0205376:	69a2                	ld	s3,8(sp)
ffffffffc0205378:	6145                	addi	sp,sp,48
ffffffffc020537a:	d29fc06f          	j	ffffffffc02020a2 <kfree>
ffffffffc020537e:	8522                	mv	a0,s0
ffffffffc0205380:	edeff0ef          	jal	ffffffffc0204a5e <fd_array_close>
ffffffffc0205384:	401c                	lw	a5,0(s0)
ffffffffc0205386:	bff1                	j	ffffffffc0205362 <files_destroy+0x30>
ffffffffc0205388:	00009697          	auipc	a3,0x9
ffffffffc020538c:	8a868693          	addi	a3,a3,-1880 # ffffffffc020dc30 <etext+0x1e1c>
ffffffffc0205390:	00007617          	auipc	a2,0x7
ffffffffc0205394:	ec060613          	addi	a2,a2,-320 # ffffffffc020c250 <etext+0x43c>
ffffffffc0205398:	03d00593          	li	a1,61
ffffffffc020539c:	00009517          	auipc	a0,0x9
ffffffffc02053a0:	88450513          	addi	a0,a0,-1916 # ffffffffc020dc20 <etext+0x1e0c>
ffffffffc02053a4:	8a6fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02053a8:	00009697          	auipc	a3,0x9
ffffffffc02053ac:	84868693          	addi	a3,a3,-1976 # ffffffffc020dbf0 <etext+0x1ddc>
ffffffffc02053b0:	00007617          	auipc	a2,0x7
ffffffffc02053b4:	ea060613          	addi	a2,a2,-352 # ffffffffc020c250 <etext+0x43c>
ffffffffc02053b8:	03300593          	li	a1,51
ffffffffc02053bc:	00009517          	auipc	a0,0x9
ffffffffc02053c0:	86450513          	addi	a0,a0,-1948 # ffffffffc020dc20 <etext+0x1e0c>
ffffffffc02053c4:	886fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02053c8 <files_closeall>:
ffffffffc02053c8:	1101                	addi	sp,sp,-32
ffffffffc02053ca:	ec06                	sd	ra,24(sp)
ffffffffc02053cc:	e822                	sd	s0,16(sp)
ffffffffc02053ce:	e426                	sd	s1,8(sp)
ffffffffc02053d0:	e04a                	sd	s2,0(sp)
ffffffffc02053d2:	c129                	beqz	a0,ffffffffc0205414 <files_closeall+0x4c>
ffffffffc02053d4:	491c                	lw	a5,16(a0)
ffffffffc02053d6:	02f05f63          	blez	a5,ffffffffc0205414 <files_closeall+0x4c>
ffffffffc02053da:	6500                	ld	s0,8(a0)
ffffffffc02053dc:	4909                	li	s2,2
ffffffffc02053de:	7ff40493          	addi	s1,s0,2047
ffffffffc02053e2:	7c148493          	addi	s1,s1,1985
ffffffffc02053e6:	07040413          	addi	s0,s0,112
ffffffffc02053ea:	a029                	j	ffffffffc02053f4 <files_closeall+0x2c>
ffffffffc02053ec:	03840413          	addi	s0,s0,56
ffffffffc02053f0:	00940c63          	beq	s0,s1,ffffffffc0205408 <files_closeall+0x40>
ffffffffc02053f4:	401c                	lw	a5,0(s0)
ffffffffc02053f6:	ff279be3          	bne	a5,s2,ffffffffc02053ec <files_closeall+0x24>
ffffffffc02053fa:	8522                	mv	a0,s0
ffffffffc02053fc:	03840413          	addi	s0,s0,56
ffffffffc0205400:	e5eff0ef          	jal	ffffffffc0204a5e <fd_array_close>
ffffffffc0205404:	fe9418e3          	bne	s0,s1,ffffffffc02053f4 <files_closeall+0x2c>
ffffffffc0205408:	60e2                	ld	ra,24(sp)
ffffffffc020540a:	6442                	ld	s0,16(sp)
ffffffffc020540c:	64a2                	ld	s1,8(sp)
ffffffffc020540e:	6902                	ld	s2,0(sp)
ffffffffc0205410:	6105                	addi	sp,sp,32
ffffffffc0205412:	8082                	ret
ffffffffc0205414:	00008697          	auipc	a3,0x8
ffffffffc0205418:	45468693          	addi	a3,a3,1108 # ffffffffc020d868 <etext+0x1a54>
ffffffffc020541c:	00007617          	auipc	a2,0x7
ffffffffc0205420:	e3460613          	addi	a2,a2,-460 # ffffffffc020c250 <etext+0x43c>
ffffffffc0205424:	04500593          	li	a1,69
ffffffffc0205428:	00008517          	auipc	a0,0x8
ffffffffc020542c:	7f850513          	addi	a0,a0,2040 # ffffffffc020dc20 <etext+0x1e0c>
ffffffffc0205430:	81afb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205434 <dup_files>:
ffffffffc0205434:	7179                	addi	sp,sp,-48
ffffffffc0205436:	f406                	sd	ra,40(sp)
ffffffffc0205438:	f022                	sd	s0,32(sp)
ffffffffc020543a:	ec26                	sd	s1,24(sp)
ffffffffc020543c:	e84a                	sd	s2,16(sp)
ffffffffc020543e:	e44e                	sd	s3,8(sp)
ffffffffc0205440:	e052                	sd	s4,0(sp)
ffffffffc0205442:	c52d                	beqz	a0,ffffffffc02054ac <dup_files+0x78>
ffffffffc0205444:	842e                	mv	s0,a1
ffffffffc0205446:	c1bd                	beqz	a1,ffffffffc02054ac <dup_files+0x78>
ffffffffc0205448:	491c                	lw	a5,16(a0)
ffffffffc020544a:	84aa                	mv	s1,a0
ffffffffc020544c:	e3c1                	bnez	a5,ffffffffc02054cc <dup_files+0x98>
ffffffffc020544e:	499c                	lw	a5,16(a1)
ffffffffc0205450:	06f05e63          	blez	a5,ffffffffc02054cc <dup_files+0x98>
ffffffffc0205454:	6188                	ld	a0,0(a1)
ffffffffc0205456:	e088                	sd	a0,0(s1)
ffffffffc0205458:	c119                	beqz	a0,ffffffffc020545e <dup_files+0x2a>
ffffffffc020545a:	3e3020ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc020545e:	6400                	ld	s0,8(s0)
ffffffffc0205460:	6484                	ld	s1,8(s1)
ffffffffc0205462:	4989                	li	s3,2
ffffffffc0205464:	7ff40913          	addi	s2,s0,2047
ffffffffc0205468:	7c190913          	addi	s2,s2,1985
ffffffffc020546c:	4a05                	li	s4,1
ffffffffc020546e:	a039                	j	ffffffffc020547c <dup_files+0x48>
ffffffffc0205470:	03840413          	addi	s0,s0,56
ffffffffc0205474:	03848493          	addi	s1,s1,56
ffffffffc0205478:	03240163          	beq	s0,s2,ffffffffc020549a <dup_files+0x66>
ffffffffc020547c:	401c                	lw	a5,0(s0)
ffffffffc020547e:	ff3799e3          	bne	a5,s3,ffffffffc0205470 <dup_files+0x3c>
ffffffffc0205482:	0144a023          	sw	s4,0(s1)
ffffffffc0205486:	85a2                	mv	a1,s0
ffffffffc0205488:	8526                	mv	a0,s1
ffffffffc020548a:	03840413          	addi	s0,s0,56
ffffffffc020548e:	e48ff0ef          	jal	ffffffffc0204ad6 <fd_array_dup>
ffffffffc0205492:	03848493          	addi	s1,s1,56
ffffffffc0205496:	ff2413e3          	bne	s0,s2,ffffffffc020547c <dup_files+0x48>
ffffffffc020549a:	70a2                	ld	ra,40(sp)
ffffffffc020549c:	7402                	ld	s0,32(sp)
ffffffffc020549e:	64e2                	ld	s1,24(sp)
ffffffffc02054a0:	6942                	ld	s2,16(sp)
ffffffffc02054a2:	69a2                	ld	s3,8(sp)
ffffffffc02054a4:	6a02                	ld	s4,0(sp)
ffffffffc02054a6:	4501                	li	a0,0
ffffffffc02054a8:	6145                	addi	sp,sp,48
ffffffffc02054aa:	8082                	ret
ffffffffc02054ac:	00008697          	auipc	a3,0x8
ffffffffc02054b0:	10c68693          	addi	a3,a3,268 # ffffffffc020d5b8 <etext+0x17a4>
ffffffffc02054b4:	00007617          	auipc	a2,0x7
ffffffffc02054b8:	d9c60613          	addi	a2,a2,-612 # ffffffffc020c250 <etext+0x43c>
ffffffffc02054bc:	05300593          	li	a1,83
ffffffffc02054c0:	00008517          	auipc	a0,0x8
ffffffffc02054c4:	76050513          	addi	a0,a0,1888 # ffffffffc020dc20 <etext+0x1e0c>
ffffffffc02054c8:	f83fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02054cc:	00008697          	auipc	a3,0x8
ffffffffc02054d0:	77c68693          	addi	a3,a3,1916 # ffffffffc020dc48 <etext+0x1e34>
ffffffffc02054d4:	00007617          	auipc	a2,0x7
ffffffffc02054d8:	d7c60613          	addi	a2,a2,-644 # ffffffffc020c250 <etext+0x43c>
ffffffffc02054dc:	05400593          	li	a1,84
ffffffffc02054e0:	00008517          	auipc	a0,0x8
ffffffffc02054e4:	74050513          	addi	a0,a0,1856 # ffffffffc020dc20 <etext+0x1e0c>
ffffffffc02054e8:	f63fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02054ec <iobuf_skip.part.0>:
ffffffffc02054ec:	1141                	addi	sp,sp,-16
ffffffffc02054ee:	00008697          	auipc	a3,0x8
ffffffffc02054f2:	78a68693          	addi	a3,a3,1930 # ffffffffc020dc78 <etext+0x1e64>
ffffffffc02054f6:	00007617          	auipc	a2,0x7
ffffffffc02054fa:	d5a60613          	addi	a2,a2,-678 # ffffffffc020c250 <etext+0x43c>
ffffffffc02054fe:	04a00593          	li	a1,74
ffffffffc0205502:	00008517          	auipc	a0,0x8
ffffffffc0205506:	78e50513          	addi	a0,a0,1934 # ffffffffc020dc90 <etext+0x1e7c>
ffffffffc020550a:	e406                	sd	ra,8(sp)
ffffffffc020550c:	f3ffa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205510 <iobuf_init>:
ffffffffc0205510:	e10c                	sd	a1,0(a0)
ffffffffc0205512:	e514                	sd	a3,8(a0)
ffffffffc0205514:	ed10                	sd	a2,24(a0)
ffffffffc0205516:	e910                	sd	a2,16(a0)
ffffffffc0205518:	8082                	ret

ffffffffc020551a <iobuf_move>:
ffffffffc020551a:	6d1c                	ld	a5,24(a0)
ffffffffc020551c:	88aa                	mv	a7,a0
ffffffffc020551e:	8832                	mv	a6,a2
ffffffffc0205520:	00f67363          	bgeu	a2,a5,ffffffffc0205526 <iobuf_move+0xc>
ffffffffc0205524:	87b2                	mv	a5,a2
ffffffffc0205526:	cfa1                	beqz	a5,ffffffffc020557e <iobuf_move+0x64>
ffffffffc0205528:	7179                	addi	sp,sp,-48
ffffffffc020552a:	f406                	sd	ra,40(sp)
ffffffffc020552c:	0008b503          	ld	a0,0(a7)
ffffffffc0205530:	cea9                	beqz	a3,ffffffffc020558a <iobuf_move+0x70>
ffffffffc0205532:	863e                	mv	a2,a5
ffffffffc0205534:	ec3a                	sd	a4,24(sp)
ffffffffc0205536:	e846                	sd	a7,16(sp)
ffffffffc0205538:	e442                	sd	a6,8(sp)
ffffffffc020553a:	e03e                	sd	a5,0(sp)
ffffffffc020553c:	083060ef          	jal	ffffffffc020bdbe <memmove>
ffffffffc0205540:	68c2                	ld	a7,16(sp)
ffffffffc0205542:	6782                	ld	a5,0(sp)
ffffffffc0205544:	6822                	ld	a6,8(sp)
ffffffffc0205546:	0188b683          	ld	a3,24(a7)
ffffffffc020554a:	6762                	ld	a4,24(sp)
ffffffffc020554c:	04f6e763          	bltu	a3,a5,ffffffffc020559a <iobuf_move+0x80>
ffffffffc0205550:	0008b583          	ld	a1,0(a7)
ffffffffc0205554:	0088b603          	ld	a2,8(a7)
ffffffffc0205558:	8e9d                	sub	a3,a3,a5
ffffffffc020555a:	95be                	add	a1,a1,a5
ffffffffc020555c:	963e                	add	a2,a2,a5
ffffffffc020555e:	00d8bc23          	sd	a3,24(a7)
ffffffffc0205562:	00b8b023          	sd	a1,0(a7)
ffffffffc0205566:	00c8b423          	sd	a2,8(a7)
ffffffffc020556a:	40f80833          	sub	a6,a6,a5
ffffffffc020556e:	c311                	beqz	a4,ffffffffc0205572 <iobuf_move+0x58>
ffffffffc0205570:	e31c                	sd	a5,0(a4)
ffffffffc0205572:	02081263          	bnez	a6,ffffffffc0205596 <iobuf_move+0x7c>
ffffffffc0205576:	4501                	li	a0,0
ffffffffc0205578:	70a2                	ld	ra,40(sp)
ffffffffc020557a:	6145                	addi	sp,sp,48
ffffffffc020557c:	8082                	ret
ffffffffc020557e:	c311                	beqz	a4,ffffffffc0205582 <iobuf_move+0x68>
ffffffffc0205580:	e31c                	sd	a5,0(a4)
ffffffffc0205582:	00081863          	bnez	a6,ffffffffc0205592 <iobuf_move+0x78>
ffffffffc0205586:	4501                	li	a0,0
ffffffffc0205588:	8082                	ret
ffffffffc020558a:	86ae                	mv	a3,a1
ffffffffc020558c:	85aa                	mv	a1,a0
ffffffffc020558e:	8536                	mv	a0,a3
ffffffffc0205590:	b74d                	j	ffffffffc0205532 <iobuf_move+0x18>
ffffffffc0205592:	5571                	li	a0,-4
ffffffffc0205594:	8082                	ret
ffffffffc0205596:	5571                	li	a0,-4
ffffffffc0205598:	b7c5                	j	ffffffffc0205578 <iobuf_move+0x5e>
ffffffffc020559a:	f53ff0ef          	jal	ffffffffc02054ec <iobuf_skip.part.0>

ffffffffc020559e <iobuf_skip>:
ffffffffc020559e:	6d1c                	ld	a5,24(a0)
ffffffffc02055a0:	00b7eb63          	bltu	a5,a1,ffffffffc02055b6 <iobuf_skip+0x18>
ffffffffc02055a4:	6114                	ld	a3,0(a0)
ffffffffc02055a6:	6518                	ld	a4,8(a0)
ffffffffc02055a8:	8f8d                	sub	a5,a5,a1
ffffffffc02055aa:	96ae                	add	a3,a3,a1
ffffffffc02055ac:	972e                	add	a4,a4,a1
ffffffffc02055ae:	ed1c                	sd	a5,24(a0)
ffffffffc02055b0:	e114                	sd	a3,0(a0)
ffffffffc02055b2:	e518                	sd	a4,8(a0)
ffffffffc02055b4:	8082                	ret
ffffffffc02055b6:	1141                	addi	sp,sp,-16
ffffffffc02055b8:	e406                	sd	ra,8(sp)
ffffffffc02055ba:	f33ff0ef          	jal	ffffffffc02054ec <iobuf_skip.part.0>

ffffffffc02055be <copy_path>:
ffffffffc02055be:	7139                	addi	sp,sp,-64
ffffffffc02055c0:	f04a                	sd	s2,32(sp)
ffffffffc02055c2:	00091917          	auipc	s2,0x91
ffffffffc02055c6:	30690913          	addi	s2,s2,774 # ffffffffc02968c8 <current>
ffffffffc02055ca:	00093783          	ld	a5,0(s2)
ffffffffc02055ce:	e852                	sd	s4,16(sp)
ffffffffc02055d0:	8a2a                	mv	s4,a0
ffffffffc02055d2:	6505                	lui	a0,0x1
ffffffffc02055d4:	f426                	sd	s1,40(sp)
ffffffffc02055d6:	ec4e                	sd	s3,24(sp)
ffffffffc02055d8:	fc06                	sd	ra,56(sp)
ffffffffc02055da:	7784                	ld	s1,40(a5)
ffffffffc02055dc:	89ae                	mv	s3,a1
ffffffffc02055de:	a1ffc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02055e2:	c92d                	beqz	a0,ffffffffc0205654 <copy_path+0x96>
ffffffffc02055e4:	f822                	sd	s0,48(sp)
ffffffffc02055e6:	842a                	mv	s0,a0
ffffffffc02055e8:	c0b1                	beqz	s1,ffffffffc020562c <copy_path+0x6e>
ffffffffc02055ea:	03848513          	addi	a0,s1,56
ffffffffc02055ee:	88cff0ef          	jal	ffffffffc020467a <down>
ffffffffc02055f2:	00093783          	ld	a5,0(s2)
ffffffffc02055f6:	c399                	beqz	a5,ffffffffc02055fc <copy_path+0x3e>
ffffffffc02055f8:	43dc                	lw	a5,4(a5)
ffffffffc02055fa:	c8bc                	sw	a5,80(s1)
ffffffffc02055fc:	864e                	mv	a2,s3
ffffffffc02055fe:	6685                	lui	a3,0x1
ffffffffc0205600:	85a2                	mv	a1,s0
ffffffffc0205602:	8526                	mv	a0,s1
ffffffffc0205604:	ea9fe0ef          	jal	ffffffffc02044ac <copy_string>
ffffffffc0205608:	cd1d                	beqz	a0,ffffffffc0205646 <copy_path+0x88>
ffffffffc020560a:	03848513          	addi	a0,s1,56
ffffffffc020560e:	868ff0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205612:	0404a823          	sw	zero,80(s1)
ffffffffc0205616:	008a3023          	sd	s0,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020561a:	7442                	ld	s0,48(sp)
ffffffffc020561c:	4501                	li	a0,0
ffffffffc020561e:	70e2                	ld	ra,56(sp)
ffffffffc0205620:	74a2                	ld	s1,40(sp)
ffffffffc0205622:	7902                	ld	s2,32(sp)
ffffffffc0205624:	69e2                	ld	s3,24(sp)
ffffffffc0205626:	6a42                	ld	s4,16(sp)
ffffffffc0205628:	6121                	addi	sp,sp,64
ffffffffc020562a:	8082                	ret
ffffffffc020562c:	85aa                	mv	a1,a0
ffffffffc020562e:	864e                	mv	a2,s3
ffffffffc0205630:	6685                	lui	a3,0x1
ffffffffc0205632:	4501                	li	a0,0
ffffffffc0205634:	e79fe0ef          	jal	ffffffffc02044ac <copy_string>
ffffffffc0205638:	fd79                	bnez	a0,ffffffffc0205616 <copy_path+0x58>
ffffffffc020563a:	8522                	mv	a0,s0
ffffffffc020563c:	a67fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0205640:	5575                	li	a0,-3
ffffffffc0205642:	7442                	ld	s0,48(sp)
ffffffffc0205644:	bfe9                	j	ffffffffc020561e <copy_path+0x60>
ffffffffc0205646:	03848513          	addi	a0,s1,56
ffffffffc020564a:	82cff0ef          	jal	ffffffffc0204676 <up>
ffffffffc020564e:	0404a823          	sw	zero,80(s1)
ffffffffc0205652:	b7e5                	j	ffffffffc020563a <copy_path+0x7c>
ffffffffc0205654:	5571                	li	a0,-4
ffffffffc0205656:	b7e1                	j	ffffffffc020561e <copy_path+0x60>

ffffffffc0205658 <sysfile_open>:
ffffffffc0205658:	7179                	addi	sp,sp,-48
ffffffffc020565a:	f022                	sd	s0,32(sp)
ffffffffc020565c:	842e                	mv	s0,a1
ffffffffc020565e:	85aa                	mv	a1,a0
ffffffffc0205660:	0828                	addi	a0,sp,24
ffffffffc0205662:	f406                	sd	ra,40(sp)
ffffffffc0205664:	f5bff0ef          	jal	ffffffffc02055be <copy_path>
ffffffffc0205668:	87aa                	mv	a5,a0
ffffffffc020566a:	ed09                	bnez	a0,ffffffffc0205684 <sysfile_open+0x2c>
ffffffffc020566c:	6762                	ld	a4,24(sp)
ffffffffc020566e:	85a2                	mv	a1,s0
ffffffffc0205670:	853a                	mv	a0,a4
ffffffffc0205672:	e43a                	sd	a4,8(sp)
ffffffffc0205674:	d32ff0ef          	jal	ffffffffc0204ba6 <file_open>
ffffffffc0205678:	6722                	ld	a4,8(sp)
ffffffffc020567a:	e42a                	sd	a0,8(sp)
ffffffffc020567c:	853a                	mv	a0,a4
ffffffffc020567e:	a25fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0205682:	67a2                	ld	a5,8(sp)
ffffffffc0205684:	70a2                	ld	ra,40(sp)
ffffffffc0205686:	7402                	ld	s0,32(sp)
ffffffffc0205688:	853e                	mv	a0,a5
ffffffffc020568a:	6145                	addi	sp,sp,48
ffffffffc020568c:	8082                	ret

ffffffffc020568e <sysfile_close>:
ffffffffc020568e:	e32ff06f          	j	ffffffffc0204cc0 <file_close>

ffffffffc0205692 <sysfile_read>:
ffffffffc0205692:	7119                	addi	sp,sp,-128
ffffffffc0205694:	f466                	sd	s9,40(sp)
ffffffffc0205696:	fc86                	sd	ra,120(sp)
ffffffffc0205698:	4c81                	li	s9,0
ffffffffc020569a:	e611                	bnez	a2,ffffffffc02056a6 <sysfile_read+0x14>
ffffffffc020569c:	70e6                	ld	ra,120(sp)
ffffffffc020569e:	8566                	mv	a0,s9
ffffffffc02056a0:	7ca2                	ld	s9,40(sp)
ffffffffc02056a2:	6109                	addi	sp,sp,128
ffffffffc02056a4:	8082                	ret
ffffffffc02056a6:	f862                	sd	s8,48(sp)
ffffffffc02056a8:	00091c17          	auipc	s8,0x91
ffffffffc02056ac:	220c0c13          	addi	s8,s8,544 # ffffffffc02968c8 <current>
ffffffffc02056b0:	000c3783          	ld	a5,0(s8)
ffffffffc02056b4:	f8a2                	sd	s0,112(sp)
ffffffffc02056b6:	f0ca                	sd	s2,96(sp)
ffffffffc02056b8:	8432                	mv	s0,a2
ffffffffc02056ba:	892e                	mv	s2,a1
ffffffffc02056bc:	4601                	li	a2,0
ffffffffc02056be:	4585                	li	a1,1
ffffffffc02056c0:	f4a6                	sd	s1,104(sp)
ffffffffc02056c2:	e8d2                	sd	s4,80(sp)
ffffffffc02056c4:	7784                	ld	s1,40(a5)
ffffffffc02056c6:	8a2a                	mv	s4,a0
ffffffffc02056c8:	c8aff0ef          	jal	ffffffffc0204b52 <file_testfd>
ffffffffc02056cc:	c969                	beqz	a0,ffffffffc020579e <sysfile_read+0x10c>
ffffffffc02056ce:	6505                	lui	a0,0x1
ffffffffc02056d0:	ecce                	sd	s3,88(sp)
ffffffffc02056d2:	92bfc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02056d6:	89aa                	mv	s3,a0
ffffffffc02056d8:	c971                	beqz	a0,ffffffffc02057ac <sysfile_read+0x11a>
ffffffffc02056da:	e4d6                	sd	s5,72(sp)
ffffffffc02056dc:	e0da                	sd	s6,64(sp)
ffffffffc02056de:	6a85                	lui	s5,0x1
ffffffffc02056e0:	4b01                	li	s6,0
ffffffffc02056e2:	09546863          	bltu	s0,s5,ffffffffc0205772 <sysfile_read+0xe0>
ffffffffc02056e6:	6785                	lui	a5,0x1
ffffffffc02056e8:	863e                	mv	a2,a5
ffffffffc02056ea:	0834                	addi	a3,sp,24
ffffffffc02056ec:	85ce                	mv	a1,s3
ffffffffc02056ee:	8552                	mv	a0,s4
ffffffffc02056f0:	ec3e                	sd	a5,24(sp)
ffffffffc02056f2:	e26ff0ef          	jal	ffffffffc0204d18 <file_read>
ffffffffc02056f6:	66e2                	ld	a3,24(sp)
ffffffffc02056f8:	8caa                	mv	s9,a0
ffffffffc02056fa:	e68d                	bnez	a3,ffffffffc0205724 <sysfile_read+0x92>
ffffffffc02056fc:	854e                	mv	a0,s3
ffffffffc02056fe:	9a5fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0205702:	000b0463          	beqz	s6,ffffffffc020570a <sysfile_read+0x78>
ffffffffc0205706:	000b0c9b          	sext.w	s9,s6
ffffffffc020570a:	7446                	ld	s0,112(sp)
ffffffffc020570c:	70e6                	ld	ra,120(sp)
ffffffffc020570e:	74a6                	ld	s1,104(sp)
ffffffffc0205710:	7906                	ld	s2,96(sp)
ffffffffc0205712:	69e6                	ld	s3,88(sp)
ffffffffc0205714:	6a46                	ld	s4,80(sp)
ffffffffc0205716:	6aa6                	ld	s5,72(sp)
ffffffffc0205718:	6b06                	ld	s6,64(sp)
ffffffffc020571a:	7c42                	ld	s8,48(sp)
ffffffffc020571c:	8566                	mv	a0,s9
ffffffffc020571e:	7ca2                	ld	s9,40(sp)
ffffffffc0205720:	6109                	addi	sp,sp,128
ffffffffc0205722:	8082                	ret
ffffffffc0205724:	c899                	beqz	s1,ffffffffc020573a <sysfile_read+0xa8>
ffffffffc0205726:	03848513          	addi	a0,s1,56
ffffffffc020572a:	f51fe0ef          	jal	ffffffffc020467a <down>
ffffffffc020572e:	000c3783          	ld	a5,0(s8)
ffffffffc0205732:	66e2                	ld	a3,24(sp)
ffffffffc0205734:	c399                	beqz	a5,ffffffffc020573a <sysfile_read+0xa8>
ffffffffc0205736:	43dc                	lw	a5,4(a5)
ffffffffc0205738:	c8bc                	sw	a5,80(s1)
ffffffffc020573a:	864e                	mv	a2,s3
ffffffffc020573c:	85ca                	mv	a1,s2
ffffffffc020573e:	8526                	mv	a0,s1
ffffffffc0205740:	d35fe0ef          	jal	ffffffffc0204474 <copy_to_user>
ffffffffc0205744:	c915                	beqz	a0,ffffffffc0205778 <sysfile_read+0xe6>
ffffffffc0205746:	67e2                	ld	a5,24(sp)
ffffffffc0205748:	06f46a63          	bltu	s0,a5,ffffffffc02057bc <sysfile_read+0x12a>
ffffffffc020574c:	9b3e                	add	s6,s6,a5
ffffffffc020574e:	c889                	beqz	s1,ffffffffc0205760 <sysfile_read+0xce>
ffffffffc0205750:	03848513          	addi	a0,s1,56
ffffffffc0205754:	e43e                	sd	a5,8(sp)
ffffffffc0205756:	f21fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc020575a:	67a2                	ld	a5,8(sp)
ffffffffc020575c:	0404a823          	sw	zero,80(s1)
ffffffffc0205760:	f80c9ee3          	bnez	s9,ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc0205764:	6762                	ld	a4,24(sp)
ffffffffc0205766:	db59                	beqz	a4,ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc0205768:	8c1d                	sub	s0,s0,a5
ffffffffc020576a:	d849                	beqz	s0,ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc020576c:	993e                	add	s2,s2,a5
ffffffffc020576e:	f7547ce3          	bgeu	s0,s5,ffffffffc02056e6 <sysfile_read+0x54>
ffffffffc0205772:	87a2                	mv	a5,s0
ffffffffc0205774:	8622                	mv	a2,s0
ffffffffc0205776:	bf95                	j	ffffffffc02056ea <sysfile_read+0x58>
ffffffffc0205778:	000c8a63          	beqz	s9,ffffffffc020578c <sysfile_read+0xfa>
ffffffffc020577c:	d0c1                	beqz	s1,ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc020577e:	03848513          	addi	a0,s1,56
ffffffffc0205782:	ef5fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205786:	0404a823          	sw	zero,80(s1)
ffffffffc020578a:	bf8d                	j	ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc020578c:	c499                	beqz	s1,ffffffffc020579a <sysfile_read+0x108>
ffffffffc020578e:	03848513          	addi	a0,s1,56
ffffffffc0205792:	ee5fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205796:	0404a823          	sw	zero,80(s1)
ffffffffc020579a:	5cf5                	li	s9,-3
ffffffffc020579c:	b785                	j	ffffffffc02056fc <sysfile_read+0x6a>
ffffffffc020579e:	7446                	ld	s0,112(sp)
ffffffffc02057a0:	74a6                	ld	s1,104(sp)
ffffffffc02057a2:	7906                	ld	s2,96(sp)
ffffffffc02057a4:	6a46                	ld	s4,80(sp)
ffffffffc02057a6:	7c42                	ld	s8,48(sp)
ffffffffc02057a8:	5cf5                	li	s9,-3
ffffffffc02057aa:	bdcd                	j	ffffffffc020569c <sysfile_read+0xa>
ffffffffc02057ac:	7446                	ld	s0,112(sp)
ffffffffc02057ae:	74a6                	ld	s1,104(sp)
ffffffffc02057b0:	7906                	ld	s2,96(sp)
ffffffffc02057b2:	69e6                	ld	s3,88(sp)
ffffffffc02057b4:	6a46                	ld	s4,80(sp)
ffffffffc02057b6:	7c42                	ld	s8,48(sp)
ffffffffc02057b8:	5cf1                	li	s9,-4
ffffffffc02057ba:	b5cd                	j	ffffffffc020569c <sysfile_read+0xa>
ffffffffc02057bc:	00008697          	auipc	a3,0x8
ffffffffc02057c0:	4e468693          	addi	a3,a3,1252 # ffffffffc020dca0 <etext+0x1e8c>
ffffffffc02057c4:	00007617          	auipc	a2,0x7
ffffffffc02057c8:	a8c60613          	addi	a2,a2,-1396 # ffffffffc020c250 <etext+0x43c>
ffffffffc02057cc:	05500593          	li	a1,85
ffffffffc02057d0:	00008517          	auipc	a0,0x8
ffffffffc02057d4:	4e050513          	addi	a0,a0,1248 # ffffffffc020dcb0 <etext+0x1e9c>
ffffffffc02057d8:	fc5e                	sd	s7,56(sp)
ffffffffc02057da:	c71fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02057de <sysfile_write>:
ffffffffc02057de:	e601                	bnez	a2,ffffffffc02057e6 <sysfile_write+0x8>
ffffffffc02057e0:	4701                	li	a4,0
ffffffffc02057e2:	853a                	mv	a0,a4
ffffffffc02057e4:	8082                	ret
ffffffffc02057e6:	7159                	addi	sp,sp,-112
ffffffffc02057e8:	f062                	sd	s8,32(sp)
ffffffffc02057ea:	00091c17          	auipc	s8,0x91
ffffffffc02057ee:	0dec0c13          	addi	s8,s8,222 # ffffffffc02968c8 <current>
ffffffffc02057f2:	000c3783          	ld	a5,0(s8)
ffffffffc02057f6:	f0a2                	sd	s0,96(sp)
ffffffffc02057f8:	eca6                	sd	s1,88(sp)
ffffffffc02057fa:	8432                	mv	s0,a2
ffffffffc02057fc:	84ae                	mv	s1,a1
ffffffffc02057fe:	4605                	li	a2,1
ffffffffc0205800:	4581                	li	a1,0
ffffffffc0205802:	e8ca                	sd	s2,80(sp)
ffffffffc0205804:	e0d2                	sd	s4,64(sp)
ffffffffc0205806:	f486                	sd	ra,104(sp)
ffffffffc0205808:	0287b903          	ld	s2,40(a5) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc020580c:	8a2a                	mv	s4,a0
ffffffffc020580e:	b44ff0ef          	jal	ffffffffc0204b52 <file_testfd>
ffffffffc0205812:	c969                	beqz	a0,ffffffffc02058e4 <sysfile_write+0x106>
ffffffffc0205814:	6505                	lui	a0,0x1
ffffffffc0205816:	e4ce                	sd	s3,72(sp)
ffffffffc0205818:	fe4fc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020581c:	89aa                	mv	s3,a0
ffffffffc020581e:	c569                	beqz	a0,ffffffffc02058e8 <sysfile_write+0x10a>
ffffffffc0205820:	fc56                	sd	s5,56(sp)
ffffffffc0205822:	f45e                	sd	s7,40(sp)
ffffffffc0205824:	4a81                	li	s5,0
ffffffffc0205826:	6b85                	lui	s7,0x1
ffffffffc0205828:	86a2                	mv	a3,s0
ffffffffc020582a:	008bf363          	bgeu	s7,s0,ffffffffc0205830 <sysfile_write+0x52>
ffffffffc020582e:	6685                	lui	a3,0x1
ffffffffc0205830:	ec36                	sd	a3,24(sp)
ffffffffc0205832:	04090e63          	beqz	s2,ffffffffc020588e <sysfile_write+0xb0>
ffffffffc0205836:	03890513          	addi	a0,s2,56
ffffffffc020583a:	e41fe0ef          	jal	ffffffffc020467a <down>
ffffffffc020583e:	000c3783          	ld	a5,0(s8)
ffffffffc0205842:	c781                	beqz	a5,ffffffffc020584a <sysfile_write+0x6c>
ffffffffc0205844:	43dc                	lw	a5,4(a5)
ffffffffc0205846:	04f92823          	sw	a5,80(s2)
ffffffffc020584a:	66e2                	ld	a3,24(sp)
ffffffffc020584c:	4701                	li	a4,0
ffffffffc020584e:	8626                	mv	a2,s1
ffffffffc0205850:	85ce                	mv	a1,s3
ffffffffc0205852:	854a                	mv	a0,s2
ffffffffc0205854:	bebfe0ef          	jal	ffffffffc020443e <copy_from_user>
ffffffffc0205858:	ed3d                	bnez	a0,ffffffffc02058d6 <sysfile_write+0xf8>
ffffffffc020585a:	03890513          	addi	a0,s2,56
ffffffffc020585e:	e19fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205862:	04092823          	sw	zero,80(s2)
ffffffffc0205866:	5775                	li	a4,-3
ffffffffc0205868:	854e                	mv	a0,s3
ffffffffc020586a:	e43a                	sd	a4,8(sp)
ffffffffc020586c:	837fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0205870:	6722                	ld	a4,8(sp)
ffffffffc0205872:	040a9c63          	bnez	s5,ffffffffc02058ca <sysfile_write+0xec>
ffffffffc0205876:	69a6                	ld	s3,72(sp)
ffffffffc0205878:	7ae2                	ld	s5,56(sp)
ffffffffc020587a:	7ba2                	ld	s7,40(sp)
ffffffffc020587c:	70a6                	ld	ra,104(sp)
ffffffffc020587e:	7406                	ld	s0,96(sp)
ffffffffc0205880:	64e6                	ld	s1,88(sp)
ffffffffc0205882:	6946                	ld	s2,80(sp)
ffffffffc0205884:	6a06                	ld	s4,64(sp)
ffffffffc0205886:	7c02                	ld	s8,32(sp)
ffffffffc0205888:	853a                	mv	a0,a4
ffffffffc020588a:	6165                	addi	sp,sp,112
ffffffffc020588c:	8082                	ret
ffffffffc020588e:	4701                	li	a4,0
ffffffffc0205890:	8626                	mv	a2,s1
ffffffffc0205892:	85ce                	mv	a1,s3
ffffffffc0205894:	4501                	li	a0,0
ffffffffc0205896:	ba9fe0ef          	jal	ffffffffc020443e <copy_from_user>
ffffffffc020589a:	d571                	beqz	a0,ffffffffc0205866 <sysfile_write+0x88>
ffffffffc020589c:	6662                	ld	a2,24(sp)
ffffffffc020589e:	0834                	addi	a3,sp,24
ffffffffc02058a0:	85ce                	mv	a1,s3
ffffffffc02058a2:	8552                	mv	a0,s4
ffffffffc02058a4:	d62ff0ef          	jal	ffffffffc0204e06 <file_write>
ffffffffc02058a8:	67e2                	ld	a5,24(sp)
ffffffffc02058aa:	872a                	mv	a4,a0
ffffffffc02058ac:	dfd5                	beqz	a5,ffffffffc0205868 <sysfile_write+0x8a>
ffffffffc02058ae:	04f46063          	bltu	s0,a5,ffffffffc02058ee <sysfile_write+0x110>
ffffffffc02058b2:	9abe                	add	s5,s5,a5
ffffffffc02058b4:	f955                	bnez	a0,ffffffffc0205868 <sysfile_write+0x8a>
ffffffffc02058b6:	8c1d                	sub	s0,s0,a5
ffffffffc02058b8:	94be                	add	s1,s1,a5
ffffffffc02058ba:	f43d                	bnez	s0,ffffffffc0205828 <sysfile_write+0x4a>
ffffffffc02058bc:	854e                	mv	a0,s3
ffffffffc02058be:	e43a                	sd	a4,8(sp)
ffffffffc02058c0:	fe2fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02058c4:	6722                	ld	a4,8(sp)
ffffffffc02058c6:	fa0a88e3          	beqz	s5,ffffffffc0205876 <sysfile_write+0x98>
ffffffffc02058ca:	000a871b          	sext.w	a4,s5
ffffffffc02058ce:	69a6                	ld	s3,72(sp)
ffffffffc02058d0:	7ae2                	ld	s5,56(sp)
ffffffffc02058d2:	7ba2                	ld	s7,40(sp)
ffffffffc02058d4:	b765                	j	ffffffffc020587c <sysfile_write+0x9e>
ffffffffc02058d6:	03890513          	addi	a0,s2,56
ffffffffc02058da:	d9dfe0ef          	jal	ffffffffc0204676 <up>
ffffffffc02058de:	04092823          	sw	zero,80(s2)
ffffffffc02058e2:	bf6d                	j	ffffffffc020589c <sysfile_write+0xbe>
ffffffffc02058e4:	5775                	li	a4,-3
ffffffffc02058e6:	bf59                	j	ffffffffc020587c <sysfile_write+0x9e>
ffffffffc02058e8:	69a6                	ld	s3,72(sp)
ffffffffc02058ea:	5771                	li	a4,-4
ffffffffc02058ec:	bf41                	j	ffffffffc020587c <sysfile_write+0x9e>
ffffffffc02058ee:	00008697          	auipc	a3,0x8
ffffffffc02058f2:	3b268693          	addi	a3,a3,946 # ffffffffc020dca0 <etext+0x1e8c>
ffffffffc02058f6:	00007617          	auipc	a2,0x7
ffffffffc02058fa:	95a60613          	addi	a2,a2,-1702 # ffffffffc020c250 <etext+0x43c>
ffffffffc02058fe:	08a00593          	li	a1,138
ffffffffc0205902:	00008517          	auipc	a0,0x8
ffffffffc0205906:	3ae50513          	addi	a0,a0,942 # ffffffffc020dcb0 <etext+0x1e9c>
ffffffffc020590a:	f85a                	sd	s6,48(sp)
ffffffffc020590c:	b3ffa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205910 <sysfile_seek>:
ffffffffc0205910:	de4ff06f          	j	ffffffffc0204ef4 <file_seek>

ffffffffc0205914 <sysfile_fstat>:
ffffffffc0205914:	715d                	addi	sp,sp,-80
ffffffffc0205916:	f84a                	sd	s2,48(sp)
ffffffffc0205918:	00091917          	auipc	s2,0x91
ffffffffc020591c:	fb090913          	addi	s2,s2,-80 # ffffffffc02968c8 <current>
ffffffffc0205920:	00093783          	ld	a5,0(s2)
ffffffffc0205924:	f44e                	sd	s3,40(sp)
ffffffffc0205926:	89ae                	mv	s3,a1
ffffffffc0205928:	858a                	mv	a1,sp
ffffffffc020592a:	e0a2                	sd	s0,64(sp)
ffffffffc020592c:	fc26                	sd	s1,56(sp)
ffffffffc020592e:	e486                	sd	ra,72(sp)
ffffffffc0205930:	7784                	ld	s1,40(a5)
ffffffffc0205932:	ee6ff0ef          	jal	ffffffffc0205018 <file_fstat>
ffffffffc0205936:	842a                	mv	s0,a0
ffffffffc0205938:	e915                	bnez	a0,ffffffffc020596c <sysfile_fstat+0x58>
ffffffffc020593a:	c0a9                	beqz	s1,ffffffffc020597c <sysfile_fstat+0x68>
ffffffffc020593c:	03848513          	addi	a0,s1,56
ffffffffc0205940:	d3bfe0ef          	jal	ffffffffc020467a <down>
ffffffffc0205944:	00093783          	ld	a5,0(s2)
ffffffffc0205948:	c399                	beqz	a5,ffffffffc020594e <sysfile_fstat+0x3a>
ffffffffc020594a:	43dc                	lw	a5,4(a5)
ffffffffc020594c:	c8bc                	sw	a5,80(s1)
ffffffffc020594e:	860a                	mv	a2,sp
ffffffffc0205950:	85ce                	mv	a1,s3
ffffffffc0205952:	02000693          	li	a3,32
ffffffffc0205956:	8526                	mv	a0,s1
ffffffffc0205958:	b1dfe0ef          	jal	ffffffffc0204474 <copy_to_user>
ffffffffc020595c:	e111                	bnez	a0,ffffffffc0205960 <sysfile_fstat+0x4c>
ffffffffc020595e:	5475                	li	s0,-3
ffffffffc0205960:	03848513          	addi	a0,s1,56
ffffffffc0205964:	d13fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205968:	0404a823          	sw	zero,80(s1)
ffffffffc020596c:	60a6                	ld	ra,72(sp)
ffffffffc020596e:	8522                	mv	a0,s0
ffffffffc0205970:	6406                	ld	s0,64(sp)
ffffffffc0205972:	74e2                	ld	s1,56(sp)
ffffffffc0205974:	7942                	ld	s2,48(sp)
ffffffffc0205976:	79a2                	ld	s3,40(sp)
ffffffffc0205978:	6161                	addi	sp,sp,80
ffffffffc020597a:	8082                	ret
ffffffffc020597c:	860a                	mv	a2,sp
ffffffffc020597e:	85ce                	mv	a1,s3
ffffffffc0205980:	02000693          	li	a3,32
ffffffffc0205984:	af1fe0ef          	jal	ffffffffc0204474 <copy_to_user>
ffffffffc0205988:	f175                	bnez	a0,ffffffffc020596c <sysfile_fstat+0x58>
ffffffffc020598a:	5475                	li	s0,-3
ffffffffc020598c:	60a6                	ld	ra,72(sp)
ffffffffc020598e:	8522                	mv	a0,s0
ffffffffc0205990:	6406                	ld	s0,64(sp)
ffffffffc0205992:	74e2                	ld	s1,56(sp)
ffffffffc0205994:	7942                	ld	s2,48(sp)
ffffffffc0205996:	79a2                	ld	s3,40(sp)
ffffffffc0205998:	6161                	addi	sp,sp,80
ffffffffc020599a:	8082                	ret

ffffffffc020599c <sysfile_fsync>:
ffffffffc020599c:	f34ff06f          	j	ffffffffc02050d0 <file_fsync>

ffffffffc02059a0 <sysfile_getcwd>:
ffffffffc02059a0:	c1d5                	beqz	a1,ffffffffc0205a44 <sysfile_getcwd+0xa4>
ffffffffc02059a2:	00091717          	auipc	a4,0x91
ffffffffc02059a6:	f2673703          	ld	a4,-218(a4) # ffffffffc02968c8 <current>
ffffffffc02059aa:	711d                	addi	sp,sp,-96
ffffffffc02059ac:	e8a2                	sd	s0,80(sp)
ffffffffc02059ae:	7700                	ld	s0,40(a4)
ffffffffc02059b0:	e4a6                	sd	s1,72(sp)
ffffffffc02059b2:	e0ca                	sd	s2,64(sp)
ffffffffc02059b4:	ec86                	sd	ra,88(sp)
ffffffffc02059b6:	892a                	mv	s2,a0
ffffffffc02059b8:	84ae                	mv	s1,a1
ffffffffc02059ba:	c039                	beqz	s0,ffffffffc0205a00 <sysfile_getcwd+0x60>
ffffffffc02059bc:	03840513          	addi	a0,s0,56
ffffffffc02059c0:	cbbfe0ef          	jal	ffffffffc020467a <down>
ffffffffc02059c4:	00091797          	auipc	a5,0x91
ffffffffc02059c8:	f047b783          	ld	a5,-252(a5) # ffffffffc02968c8 <current>
ffffffffc02059cc:	c399                	beqz	a5,ffffffffc02059d2 <sysfile_getcwd+0x32>
ffffffffc02059ce:	43dc                	lw	a5,4(a5)
ffffffffc02059d0:	c83c                	sw	a5,80(s0)
ffffffffc02059d2:	4685                	li	a3,1
ffffffffc02059d4:	8626                	mv	a2,s1
ffffffffc02059d6:	85ca                	mv	a1,s2
ffffffffc02059d8:	8522                	mv	a0,s0
ffffffffc02059da:	9c1fe0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc02059de:	57f5                	li	a5,-3
ffffffffc02059e0:	e921                	bnez	a0,ffffffffc0205a30 <sysfile_getcwd+0x90>
ffffffffc02059e2:	03840513          	addi	a0,s0,56
ffffffffc02059e6:	e43e                	sd	a5,8(sp)
ffffffffc02059e8:	c8ffe0ef          	jal	ffffffffc0204676 <up>
ffffffffc02059ec:	67a2                	ld	a5,8(sp)
ffffffffc02059ee:	04042823          	sw	zero,80(s0)
ffffffffc02059f2:	60e6                	ld	ra,88(sp)
ffffffffc02059f4:	6446                	ld	s0,80(sp)
ffffffffc02059f6:	64a6                	ld	s1,72(sp)
ffffffffc02059f8:	6906                	ld	s2,64(sp)
ffffffffc02059fa:	853e                	mv	a0,a5
ffffffffc02059fc:	6125                	addi	sp,sp,96
ffffffffc02059fe:	8082                	ret
ffffffffc0205a00:	862e                	mv	a2,a1
ffffffffc0205a02:	4685                	li	a3,1
ffffffffc0205a04:	85aa                	mv	a1,a0
ffffffffc0205a06:	4501                	li	a0,0
ffffffffc0205a08:	993fe0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc0205a0c:	57f5                	li	a5,-3
ffffffffc0205a0e:	d175                	beqz	a0,ffffffffc02059f2 <sysfile_getcwd+0x52>
ffffffffc0205a10:	8626                	mv	a2,s1
ffffffffc0205a12:	85ca                	mv	a1,s2
ffffffffc0205a14:	4681                	li	a3,0
ffffffffc0205a16:	0808                	addi	a0,sp,16
ffffffffc0205a18:	af9ff0ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0205a1c:	206030ef          	jal	ffffffffc0208c22 <vfs_getcwd>
ffffffffc0205a20:	60e6                	ld	ra,88(sp)
ffffffffc0205a22:	6446                	ld	s0,80(sp)
ffffffffc0205a24:	87aa                	mv	a5,a0
ffffffffc0205a26:	64a6                	ld	s1,72(sp)
ffffffffc0205a28:	6906                	ld	s2,64(sp)
ffffffffc0205a2a:	853e                	mv	a0,a5
ffffffffc0205a2c:	6125                	addi	sp,sp,96
ffffffffc0205a2e:	8082                	ret
ffffffffc0205a30:	8626                	mv	a2,s1
ffffffffc0205a32:	85ca                	mv	a1,s2
ffffffffc0205a34:	4681                	li	a3,0
ffffffffc0205a36:	0808                	addi	a0,sp,16
ffffffffc0205a38:	ad9ff0ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0205a3c:	1e6030ef          	jal	ffffffffc0208c22 <vfs_getcwd>
ffffffffc0205a40:	87aa                	mv	a5,a0
ffffffffc0205a42:	b745                	j	ffffffffc02059e2 <sysfile_getcwd+0x42>
ffffffffc0205a44:	57f5                	li	a5,-3
ffffffffc0205a46:	853e                	mv	a0,a5
ffffffffc0205a48:	8082                	ret

ffffffffc0205a4a <sysfile_getdirentry>:
ffffffffc0205a4a:	7139                	addi	sp,sp,-64
ffffffffc0205a4c:	ec4e                	sd	s3,24(sp)
ffffffffc0205a4e:	00091997          	auipc	s3,0x91
ffffffffc0205a52:	e7a98993          	addi	s3,s3,-390 # ffffffffc02968c8 <current>
ffffffffc0205a56:	0009b783          	ld	a5,0(s3)
ffffffffc0205a5a:	f04a                	sd	s2,32(sp)
ffffffffc0205a5c:	892a                	mv	s2,a0
ffffffffc0205a5e:	10800513          	li	a0,264
ffffffffc0205a62:	f426                	sd	s1,40(sp)
ffffffffc0205a64:	e852                	sd	s4,16(sp)
ffffffffc0205a66:	fc06                	sd	ra,56(sp)
ffffffffc0205a68:	7784                	ld	s1,40(a5)
ffffffffc0205a6a:	8a2e                	mv	s4,a1
ffffffffc0205a6c:	d90fc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0205a70:	c179                	beqz	a0,ffffffffc0205b36 <sysfile_getdirentry+0xec>
ffffffffc0205a72:	f822                	sd	s0,48(sp)
ffffffffc0205a74:	842a                	mv	s0,a0
ffffffffc0205a76:	c8d1                	beqz	s1,ffffffffc0205b0a <sysfile_getdirentry+0xc0>
ffffffffc0205a78:	03848513          	addi	a0,s1,56
ffffffffc0205a7c:	bfffe0ef          	jal	ffffffffc020467a <down>
ffffffffc0205a80:	0009b783          	ld	a5,0(s3)
ffffffffc0205a84:	c399                	beqz	a5,ffffffffc0205a8a <sysfile_getdirentry+0x40>
ffffffffc0205a86:	43dc                	lw	a5,4(a5)
ffffffffc0205a88:	c8bc                	sw	a5,80(s1)
ffffffffc0205a8a:	4705                	li	a4,1
ffffffffc0205a8c:	46a1                	li	a3,8
ffffffffc0205a8e:	8652                	mv	a2,s4
ffffffffc0205a90:	85a2                	mv	a1,s0
ffffffffc0205a92:	8526                	mv	a0,s1
ffffffffc0205a94:	9abfe0ef          	jal	ffffffffc020443e <copy_from_user>
ffffffffc0205a98:	e505                	bnez	a0,ffffffffc0205ac0 <sysfile_getdirentry+0x76>
ffffffffc0205a9a:	03848513          	addi	a0,s1,56
ffffffffc0205a9e:	bd9fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205aa2:	0404a823          	sw	zero,80(s1)
ffffffffc0205aa6:	5975                	li	s2,-3
ffffffffc0205aa8:	8522                	mv	a0,s0
ffffffffc0205aaa:	df8fc0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0205aae:	7442                	ld	s0,48(sp)
ffffffffc0205ab0:	70e2                	ld	ra,56(sp)
ffffffffc0205ab2:	74a2                	ld	s1,40(sp)
ffffffffc0205ab4:	69e2                	ld	s3,24(sp)
ffffffffc0205ab6:	6a42                	ld	s4,16(sp)
ffffffffc0205ab8:	854a                	mv	a0,s2
ffffffffc0205aba:	7902                	ld	s2,32(sp)
ffffffffc0205abc:	6121                	addi	sp,sp,64
ffffffffc0205abe:	8082                	ret
ffffffffc0205ac0:	03848513          	addi	a0,s1,56
ffffffffc0205ac4:	bb3fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205ac8:	854a                	mv	a0,s2
ffffffffc0205aca:	0404a823          	sw	zero,80(s1)
ffffffffc0205ace:	85a2                	mv	a1,s0
ffffffffc0205ad0:	eaaff0ef          	jal	ffffffffc020517a <file_getdirentry>
ffffffffc0205ad4:	892a                	mv	s2,a0
ffffffffc0205ad6:	f969                	bnez	a0,ffffffffc0205aa8 <sysfile_getdirentry+0x5e>
ffffffffc0205ad8:	03848513          	addi	a0,s1,56
ffffffffc0205adc:	b9ffe0ef          	jal	ffffffffc020467a <down>
ffffffffc0205ae0:	0009b783          	ld	a5,0(s3)
ffffffffc0205ae4:	c399                	beqz	a5,ffffffffc0205aea <sysfile_getdirentry+0xa0>
ffffffffc0205ae6:	43dc                	lw	a5,4(a5)
ffffffffc0205ae8:	c8bc                	sw	a5,80(s1)
ffffffffc0205aea:	85d2                	mv	a1,s4
ffffffffc0205aec:	10800693          	li	a3,264
ffffffffc0205af0:	8622                	mv	a2,s0
ffffffffc0205af2:	8526                	mv	a0,s1
ffffffffc0205af4:	981fe0ef          	jal	ffffffffc0204474 <copy_to_user>
ffffffffc0205af8:	e111                	bnez	a0,ffffffffc0205afc <sysfile_getdirentry+0xb2>
ffffffffc0205afa:	5975                	li	s2,-3
ffffffffc0205afc:	03848513          	addi	a0,s1,56
ffffffffc0205b00:	b77fe0ef          	jal	ffffffffc0204676 <up>
ffffffffc0205b04:	0404a823          	sw	zero,80(s1)
ffffffffc0205b08:	b745                	j	ffffffffc0205aa8 <sysfile_getdirentry+0x5e>
ffffffffc0205b0a:	85aa                	mv	a1,a0
ffffffffc0205b0c:	4705                	li	a4,1
ffffffffc0205b0e:	46a1                	li	a3,8
ffffffffc0205b10:	8652                	mv	a2,s4
ffffffffc0205b12:	4501                	li	a0,0
ffffffffc0205b14:	92bfe0ef          	jal	ffffffffc020443e <copy_from_user>
ffffffffc0205b18:	d559                	beqz	a0,ffffffffc0205aa6 <sysfile_getdirentry+0x5c>
ffffffffc0205b1a:	854a                	mv	a0,s2
ffffffffc0205b1c:	85a2                	mv	a1,s0
ffffffffc0205b1e:	e5cff0ef          	jal	ffffffffc020517a <file_getdirentry>
ffffffffc0205b22:	892a                	mv	s2,a0
ffffffffc0205b24:	f151                	bnez	a0,ffffffffc0205aa8 <sysfile_getdirentry+0x5e>
ffffffffc0205b26:	85d2                	mv	a1,s4
ffffffffc0205b28:	10800693          	li	a3,264
ffffffffc0205b2c:	8622                	mv	a2,s0
ffffffffc0205b2e:	947fe0ef          	jal	ffffffffc0204474 <copy_to_user>
ffffffffc0205b32:	f93d                	bnez	a0,ffffffffc0205aa8 <sysfile_getdirentry+0x5e>
ffffffffc0205b34:	bf8d                	j	ffffffffc0205aa6 <sysfile_getdirentry+0x5c>
ffffffffc0205b36:	5971                	li	s2,-4
ffffffffc0205b38:	bfa5                	j	ffffffffc0205ab0 <sysfile_getdirentry+0x66>

ffffffffc0205b3a <sysfile_dup>:
ffffffffc0205b3a:	f2eff06f          	j	ffffffffc0205268 <file_dup>

ffffffffc0205b3e <kernel_thread_entry>:
ffffffffc0205b3e:	8526                	mv	a0,s1
ffffffffc0205b40:	9402                	jalr	s0
ffffffffc0205b42:	720000ef          	jal	ffffffffc0206262 <do_exit>

ffffffffc0205b46 <alloc_proc>:
ffffffffc0205b46:	1141                	addi	sp,sp,-16
ffffffffc0205b48:	15000513          	li	a0,336
ffffffffc0205b4c:	e022                	sd	s0,0(sp)
ffffffffc0205b4e:	e406                	sd	ra,8(sp)
ffffffffc0205b50:	cacfc0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0205b54:	842a                	mv	s0,a0
ffffffffc0205b56:	c151                	beqz	a0,ffffffffc0205bda <alloc_proc+0x94>
ffffffffc0205b58:	57fd                	li	a5,-1
ffffffffc0205b5a:	1782                	slli	a5,a5,0x20
ffffffffc0205b5c:	e11c                	sd	a5,0(a0)
ffffffffc0205b5e:	00052423          	sw	zero,8(a0)
ffffffffc0205b62:	00053823          	sd	zero,16(a0)
ffffffffc0205b66:	00053c23          	sd	zero,24(a0)
ffffffffc0205b6a:	02053023          	sd	zero,32(a0)
ffffffffc0205b6e:	02053423          	sd	zero,40(a0)
ffffffffc0205b72:	07000613          	li	a2,112
ffffffffc0205b76:	4581                	li	a1,0
ffffffffc0205b78:	03050513          	addi	a0,a0,48
ffffffffc0205b7c:	230060ef          	jal	ffffffffc020bdac <memset>
ffffffffc0205b80:	00091797          	auipc	a5,0x91
ffffffffc0205b84:	d187b783          	ld	a5,-744(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0205b88:	0a043023          	sd	zero,160(s0)
ffffffffc0205b8c:	0a042823          	sw	zero,176(s0)
ffffffffc0205b90:	f45c                	sd	a5,168(s0)
ffffffffc0205b92:	0b440513          	addi	a0,s0,180
ffffffffc0205b96:	463d                	li	a2,15
ffffffffc0205b98:	4581                	li	a1,0
ffffffffc0205b9a:	212060ef          	jal	ffffffffc020bdac <memset>
ffffffffc0205b9e:	4785                	li	a5,1
ffffffffc0205ba0:	11040713          	addi	a4,s0,272
ffffffffc0205ba4:	1782                	slli	a5,a5,0x20
ffffffffc0205ba6:	14043423          	sd	zero,328(s0)
ffffffffc0205baa:	0e042623          	sw	zero,236(s0)
ffffffffc0205bae:	0e043c23          	sd	zero,248(s0)
ffffffffc0205bb2:	10043023          	sd	zero,256(s0)
ffffffffc0205bb6:	0e043823          	sd	zero,240(s0)
ffffffffc0205bba:	10043423          	sd	zero,264(s0)
ffffffffc0205bbe:	12042023          	sw	zero,288(s0)
ffffffffc0205bc2:	12043423          	sd	zero,296(s0)
ffffffffc0205bc6:	12043c23          	sd	zero,312(s0)
ffffffffc0205bca:	12043823          	sd	zero,304(s0)
ffffffffc0205bce:	14f43023          	sd	a5,320(s0)
ffffffffc0205bd2:	10e43c23          	sd	a4,280(s0)
ffffffffc0205bd6:	10e43823          	sd	a4,272(s0)
ffffffffc0205bda:	60a2                	ld	ra,8(sp)
ffffffffc0205bdc:	8522                	mv	a0,s0
ffffffffc0205bde:	6402                	ld	s0,0(sp)
ffffffffc0205be0:	0141                	addi	sp,sp,16
ffffffffc0205be2:	8082                	ret

ffffffffc0205be4 <forkret>:
ffffffffc0205be4:	00091797          	auipc	a5,0x91
ffffffffc0205be8:	ce47b783          	ld	a5,-796(a5) # ffffffffc02968c8 <current>
ffffffffc0205bec:	73c8                	ld	a0,160(a5)
ffffffffc0205bee:	e9cfb06f          	j	ffffffffc020128a <forkrets>

ffffffffc0205bf2 <put_pgdir.isra.0>:
ffffffffc0205bf2:	1141                	addi	sp,sp,-16
ffffffffc0205bf4:	e406                	sd	ra,8(sp)
ffffffffc0205bf6:	c02007b7          	lui	a5,0xc0200
ffffffffc0205bfa:	02f56f63          	bltu	a0,a5,ffffffffc0205c38 <put_pgdir.isra.0+0x46>
ffffffffc0205bfe:	00091797          	auipc	a5,0x91
ffffffffc0205c02:	caa7b783          	ld	a5,-854(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205c06:	00091717          	auipc	a4,0x91
ffffffffc0205c0a:	caa73703          	ld	a4,-854(a4) # ffffffffc02968b0 <npage>
ffffffffc0205c0e:	8d1d                	sub	a0,a0,a5
ffffffffc0205c10:	00c55793          	srli	a5,a0,0xc
ffffffffc0205c14:	02e7ff63          	bgeu	a5,a4,ffffffffc0205c52 <put_pgdir.isra.0+0x60>
ffffffffc0205c18:	0000a717          	auipc	a4,0xa
ffffffffc0205c1c:	38073703          	ld	a4,896(a4) # ffffffffc020ff98 <nbase>
ffffffffc0205c20:	00091517          	auipc	a0,0x91
ffffffffc0205c24:	c9853503          	ld	a0,-872(a0) # ffffffffc02968b8 <pages>
ffffffffc0205c28:	60a2                	ld	ra,8(sp)
ffffffffc0205c2a:	8f99                	sub	a5,a5,a4
ffffffffc0205c2c:	079a                	slli	a5,a5,0x6
ffffffffc0205c2e:	4585                	li	a1,1
ffffffffc0205c30:	953e                	add	a0,a0,a5
ffffffffc0205c32:	0141                	addi	sp,sp,16
ffffffffc0205c34:	dc6fc06f          	j	ffffffffc02021fa <free_pages>
ffffffffc0205c38:	86aa                	mv	a3,a0
ffffffffc0205c3a:	00007617          	auipc	a2,0x7
ffffffffc0205c3e:	18660613          	addi	a2,a2,390 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc0205c42:	07700593          	li	a1,119
ffffffffc0205c46:	00007517          	auipc	a0,0x7
ffffffffc0205c4a:	0fa50513          	addi	a0,a0,250 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0205c4e:	ffcfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205c52:	00007617          	auipc	a2,0x7
ffffffffc0205c56:	19660613          	addi	a2,a2,406 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc0205c5a:	06900593          	li	a1,105
ffffffffc0205c5e:	00007517          	auipc	a0,0x7
ffffffffc0205c62:	0e250513          	addi	a0,a0,226 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0205c66:	fe4fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205c6a <copy_to_user_pages>:
ffffffffc0205c6a:	cee9                	beqz	a3,ffffffffc0205d44 <copy_to_user_pages+0xda>
ffffffffc0205c6c:	7119                	addi	sp,sp,-128
ffffffffc0205c6e:	f0ca                	sd	s2,96(sp)
ffffffffc0205c70:	597d                	li	s2,-1
ffffffffc0205c72:	f8a2                	sd	s0,112(sp)
ffffffffc0205c74:	f4a6                	sd	s1,104(sp)
ffffffffc0205c76:	ecce                	sd	s3,88(sp)
ffffffffc0205c78:	e8d2                	sd	s4,80(sp)
ffffffffc0205c7a:	e4d6                	sd	s5,72(sp)
ffffffffc0205c7c:	e0da                	sd	s6,64(sp)
ffffffffc0205c7e:	fc5e                	sd	s7,56(sp)
ffffffffc0205c80:	f862                	sd	s8,48(sp)
ffffffffc0205c82:	ec6e                	sd	s11,24(sp)
ffffffffc0205c84:	fc86                	sd	ra,120(sp)
ffffffffc0205c86:	f466                	sd	s9,40(sp)
ffffffffc0205c88:	f06a                	sd	s10,32(sp)
ffffffffc0205c8a:	8c36                	mv	s8,a3
ffffffffc0205c8c:	8dae                	mv	s11,a1
ffffffffc0205c8e:	8432                	mv	s0,a2
ffffffffc0205c90:	e43a                	sd	a4,8(sp)
ffffffffc0205c92:	84aa                	mv	s1,a0
ffffffffc0205c94:	00c95913          	srli	s2,s2,0xc
ffffffffc0205c98:	79fd                	lui	s3,0xfffff
ffffffffc0205c9a:	00091b97          	auipc	s7,0x91
ffffffffc0205c9e:	c1eb8b93          	addi	s7,s7,-994 # ffffffffc02968b8 <pages>
ffffffffc0205ca2:	0000ab17          	auipc	s6,0xa
ffffffffc0205ca6:	2f6b0b13          	addi	s6,s6,758 # ffffffffc020ff98 <nbase>
ffffffffc0205caa:	00091a97          	auipc	s5,0x91
ffffffffc0205cae:	c06a8a93          	addi	s5,s5,-1018 # ffffffffc02968b0 <npage>
ffffffffc0205cb2:	6a05                	lui	s4,0x1
ffffffffc0205cb4:	a881                	j	ffffffffc0205d04 <copy_to_user_pages+0x9a>
ffffffffc0205cb6:	000bb683          	ld	a3,0(s7)
ffffffffc0205cba:	000b3603          	ld	a2,0(s6)
ffffffffc0205cbe:	000ab703          	ld	a4,0(s5)
ffffffffc0205cc2:	40d506b3          	sub	a3,a0,a3
ffffffffc0205cc6:	8699                	srai	a3,a3,0x6
ffffffffc0205cc8:	96b2                	add	a3,a3,a2
ffffffffc0205cca:	0126f633          	and	a2,a3,s2
ffffffffc0205cce:	06b2                	slli	a3,a3,0xc
ffffffffc0205cd0:	06e67c63          	bgeu	a2,a4,ffffffffc0205d48 <copy_to_user_pages+0xde>
ffffffffc0205cd4:	41bd0cb3          	sub	s9,s10,s11
ffffffffc0205cd8:	9cd2                	add	s9,s9,s4
ffffffffc0205cda:	019c7363          	bgeu	s8,s9,ffffffffc0205ce0 <copy_to_user_pages+0x76>
ffffffffc0205cde:	8ce2                	mv	s9,s8
ffffffffc0205ce0:	00091717          	auipc	a4,0x91
ffffffffc0205ce4:	bc873703          	ld	a4,-1080(a4) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205ce8:	41ad8533          	sub	a0,s11,s10
ffffffffc0205cec:	85a2                	mv	a1,s0
ffffffffc0205cee:	96ba                	add	a3,a3,a4
ffffffffc0205cf0:	8666                	mv	a2,s9
ffffffffc0205cf2:	9536                	add	a0,a0,a3
ffffffffc0205cf4:	419c0c33          	sub	s8,s8,s9
ffffffffc0205cf8:	104060ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0205cfc:	9de6                	add	s11,s11,s9
ffffffffc0205cfe:	9466                	add	s0,s0,s9
ffffffffc0205d00:	020c0263          	beqz	s8,ffffffffc0205d24 <copy_to_user_pages+0xba>
ffffffffc0205d04:	013dfd33          	and	s10,s11,s3
ffffffffc0205d08:	85ea                	mv	a1,s10
ffffffffc0205d0a:	4601                	li	a2,0
ffffffffc0205d0c:	8526                	mv	a0,s1
ffffffffc0205d0e:	881fc0ef          	jal	ffffffffc020258e <get_page>
ffffffffc0205d12:	f155                	bnez	a0,ffffffffc0205cb6 <copy_to_user_pages+0x4c>
ffffffffc0205d14:	6622                	ld	a2,8(sp)
ffffffffc0205d16:	85ea                	mv	a1,s10
ffffffffc0205d18:	8526                	mv	a0,s1
ffffffffc0205d1a:	efffd0ef          	jal	ffffffffc0203c18 <pgdir_alloc_page>
ffffffffc0205d1e:	fd41                	bnez	a0,ffffffffc0205cb6 <copy_to_user_pages+0x4c>
ffffffffc0205d20:	5571                	li	a0,-4
ffffffffc0205d22:	a011                	j	ffffffffc0205d26 <copy_to_user_pages+0xbc>
ffffffffc0205d24:	4501                	li	a0,0
ffffffffc0205d26:	70e6                	ld	ra,120(sp)
ffffffffc0205d28:	7446                	ld	s0,112(sp)
ffffffffc0205d2a:	74a6                	ld	s1,104(sp)
ffffffffc0205d2c:	7906                	ld	s2,96(sp)
ffffffffc0205d2e:	69e6                	ld	s3,88(sp)
ffffffffc0205d30:	6a46                	ld	s4,80(sp)
ffffffffc0205d32:	6aa6                	ld	s5,72(sp)
ffffffffc0205d34:	6b06                	ld	s6,64(sp)
ffffffffc0205d36:	7be2                	ld	s7,56(sp)
ffffffffc0205d38:	7c42                	ld	s8,48(sp)
ffffffffc0205d3a:	7ca2                	ld	s9,40(sp)
ffffffffc0205d3c:	7d02                	ld	s10,32(sp)
ffffffffc0205d3e:	6de2                	ld	s11,24(sp)
ffffffffc0205d40:	6109                	addi	sp,sp,128
ffffffffc0205d42:	8082                	ret
ffffffffc0205d44:	4501                	li	a0,0
ffffffffc0205d46:	8082                	ret
ffffffffc0205d48:	00007617          	auipc	a2,0x7
ffffffffc0205d4c:	fd060613          	addi	a2,a2,-48 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0205d50:	07100593          	li	a1,113
ffffffffc0205d54:	00007517          	auipc	a0,0x7
ffffffffc0205d58:	fec50513          	addi	a0,a0,-20 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0205d5c:	eeefa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205d60 <setup_pgdir>:
ffffffffc0205d60:	1101                	addi	sp,sp,-32
ffffffffc0205d62:	e426                	sd	s1,8(sp)
ffffffffc0205d64:	84aa                	mv	s1,a0
ffffffffc0205d66:	4505                	li	a0,1
ffffffffc0205d68:	ec06                	sd	ra,24(sp)
ffffffffc0205d6a:	c56fc0ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0205d6e:	cd29                	beqz	a0,ffffffffc0205dc8 <setup_pgdir+0x68>
ffffffffc0205d70:	00091697          	auipc	a3,0x91
ffffffffc0205d74:	b486b683          	ld	a3,-1208(a3) # ffffffffc02968b8 <pages>
ffffffffc0205d78:	0000a797          	auipc	a5,0xa
ffffffffc0205d7c:	2207b783          	ld	a5,544(a5) # ffffffffc020ff98 <nbase>
ffffffffc0205d80:	00091717          	auipc	a4,0x91
ffffffffc0205d84:	b3073703          	ld	a4,-1232(a4) # ffffffffc02968b0 <npage>
ffffffffc0205d88:	40d506b3          	sub	a3,a0,a3
ffffffffc0205d8c:	8699                	srai	a3,a3,0x6
ffffffffc0205d8e:	96be                	add	a3,a3,a5
ffffffffc0205d90:	00c69793          	slli	a5,a3,0xc
ffffffffc0205d94:	e822                	sd	s0,16(sp)
ffffffffc0205d96:	83b1                	srli	a5,a5,0xc
ffffffffc0205d98:	06b2                	slli	a3,a3,0xc
ffffffffc0205d9a:	02e7f963          	bgeu	a5,a4,ffffffffc0205dcc <setup_pgdir+0x6c>
ffffffffc0205d9e:	00091797          	auipc	a5,0x91
ffffffffc0205da2:	b0a7b783          	ld	a5,-1270(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205da6:	00091597          	auipc	a1,0x91
ffffffffc0205daa:	afa5b583          	ld	a1,-1286(a1) # ffffffffc02968a0 <boot_pgdir_va>
ffffffffc0205dae:	6605                	lui	a2,0x1
ffffffffc0205db0:	00f68433          	add	s0,a3,a5
ffffffffc0205db4:	8522                	mv	a0,s0
ffffffffc0205db6:	046060ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0205dba:	ec80                	sd	s0,24(s1)
ffffffffc0205dbc:	6442                	ld	s0,16(sp)
ffffffffc0205dbe:	4501                	li	a0,0
ffffffffc0205dc0:	60e2                	ld	ra,24(sp)
ffffffffc0205dc2:	64a2                	ld	s1,8(sp)
ffffffffc0205dc4:	6105                	addi	sp,sp,32
ffffffffc0205dc6:	8082                	ret
ffffffffc0205dc8:	5571                	li	a0,-4
ffffffffc0205dca:	bfdd                	j	ffffffffc0205dc0 <setup_pgdir+0x60>
ffffffffc0205dcc:	00007617          	auipc	a2,0x7
ffffffffc0205dd0:	f4c60613          	addi	a2,a2,-180 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0205dd4:	07100593          	li	a1,113
ffffffffc0205dd8:	00007517          	auipc	a0,0x7
ffffffffc0205ddc:	f6850513          	addi	a0,a0,-152 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0205de0:	e6afa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205de4 <proc_run>:
ffffffffc0205de4:	1101                	addi	sp,sp,-32
ffffffffc0205de6:	00091717          	auipc	a4,0x91
ffffffffc0205dea:	ae270713          	addi	a4,a4,-1310 # ffffffffc02968c8 <current>
ffffffffc0205dee:	6310                	ld	a2,0(a4)
ffffffffc0205df0:	ec06                	sd	ra,24(sp)
ffffffffc0205df2:	e822                	sd	s0,16(sp)
ffffffffc0205df4:	100027f3          	csrr	a5,sstatus
ffffffffc0205df8:	8b89                	andi	a5,a5,2
ffffffffc0205dfa:	4401                	li	s0,0
ffffffffc0205dfc:	ef85                	bnez	a5,ffffffffc0205e34 <proc_run+0x50>
ffffffffc0205dfe:	755c                	ld	a5,168(a0)
ffffffffc0205e00:	56fd                	li	a3,-1
ffffffffc0205e02:	16fe                	slli	a3,a3,0x3f
ffffffffc0205e04:	83b1                	srli	a5,a5,0xc
ffffffffc0205e06:	e308                	sd	a0,0(a4)
ffffffffc0205e08:	8fd5                	or	a5,a5,a3
ffffffffc0205e0a:	18079073          	csrw	satp,a5
ffffffffc0205e0e:	12000073          	sfence.vma
ffffffffc0205e12:	630c                	ld	a1,0(a4)
ffffffffc0205e14:	03060513          	addi	a0,a2,48
ffffffffc0205e18:	03058593          	addi	a1,a1,48
ffffffffc0205e1c:	4fa010ef          	jal	ffffffffc0207316 <switch_to>
ffffffffc0205e20:	e409                	bnez	s0,ffffffffc0205e2a <proc_run+0x46>
ffffffffc0205e22:	60e2                	ld	ra,24(sp)
ffffffffc0205e24:	6442                	ld	s0,16(sp)
ffffffffc0205e26:	6105                	addi	sp,sp,32
ffffffffc0205e28:	8082                	ret
ffffffffc0205e2a:	6442                	ld	s0,16(sp)
ffffffffc0205e2c:	60e2                	ld	ra,24(sp)
ffffffffc0205e2e:	6105                	addi	sp,sp,32
ffffffffc0205e30:	da3fa06f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0205e34:	e42a                	sd	a0,8(sp)
ffffffffc0205e36:	e032                	sd	a2,0(sp)
ffffffffc0205e38:	da1fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0205e3c:	6522                	ld	a0,8(sp)
ffffffffc0205e3e:	6602                	ld	a2,0(sp)
ffffffffc0205e40:	4405                	li	s0,1
ffffffffc0205e42:	00091717          	auipc	a4,0x91
ffffffffc0205e46:	a8670713          	addi	a4,a4,-1402 # ffffffffc02968c8 <current>
ffffffffc0205e4a:	bf55                	j	ffffffffc0205dfe <proc_run+0x1a>

ffffffffc0205e4c <do_fork>:
ffffffffc0205e4c:	00091717          	auipc	a4,0x91
ffffffffc0205e50:	a7472703          	lw	a4,-1420(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0205e54:	6785                	lui	a5,0x1
ffffffffc0205e56:	30f75f63          	bge	a4,a5,ffffffffc0206174 <do_fork+0x328>
ffffffffc0205e5a:	7119                	addi	sp,sp,-128
ffffffffc0205e5c:	f8a2                	sd	s0,112(sp)
ffffffffc0205e5e:	f4a6                	sd	s1,104(sp)
ffffffffc0205e60:	f0ca                	sd	s2,96(sp)
ffffffffc0205e62:	ecce                	sd	s3,88(sp)
ffffffffc0205e64:	fc86                	sd	ra,120(sp)
ffffffffc0205e66:	892e                	mv	s2,a1
ffffffffc0205e68:	84b2                	mv	s1,a2
ffffffffc0205e6a:	89aa                	mv	s3,a0
ffffffffc0205e6c:	cdbff0ef          	jal	ffffffffc0205b46 <alloc_proc>
ffffffffc0205e70:	842a                	mv	s0,a0
ffffffffc0205e72:	28050763          	beqz	a0,ffffffffc0206100 <do_fork+0x2b4>
ffffffffc0205e76:	f466                	sd	s9,40(sp)
ffffffffc0205e78:	00091c97          	auipc	s9,0x91
ffffffffc0205e7c:	a50c8c93          	addi	s9,s9,-1456 # ffffffffc02968c8 <current>
ffffffffc0205e80:	000cb783          	ld	a5,0(s9)
ffffffffc0205e84:	4509                	li	a0,2
ffffffffc0205e86:	f01c                	sd	a5,32(s0)
ffffffffc0205e88:	0e07a623          	sw	zero,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205e8c:	b34fc0ef          	jal	ffffffffc02021c0 <alloc_pages>
ffffffffc0205e90:	26050463          	beqz	a0,ffffffffc02060f8 <do_fork+0x2ac>
ffffffffc0205e94:	e4d6                	sd	s5,72(sp)
ffffffffc0205e96:	00091a97          	auipc	s5,0x91
ffffffffc0205e9a:	a22a8a93          	addi	s5,s5,-1502 # ffffffffc02968b8 <pages>
ffffffffc0205e9e:	000ab783          	ld	a5,0(s5)
ffffffffc0205ea2:	e8d2                	sd	s4,80(sp)
ffffffffc0205ea4:	0000aa17          	auipc	s4,0xa
ffffffffc0205ea8:	0f4a3a03          	ld	s4,244(s4) # ffffffffc020ff98 <nbase>
ffffffffc0205eac:	40f506b3          	sub	a3,a0,a5
ffffffffc0205eb0:	e0da                	sd	s6,64(sp)
ffffffffc0205eb2:	8699                	srai	a3,a3,0x6
ffffffffc0205eb4:	00091b17          	auipc	s6,0x91
ffffffffc0205eb8:	9fcb0b13          	addi	s6,s6,-1540 # ffffffffc02968b0 <npage>
ffffffffc0205ebc:	96d2                	add	a3,a3,s4
ffffffffc0205ebe:	000b3703          	ld	a4,0(s6)
ffffffffc0205ec2:	00c69793          	slli	a5,a3,0xc
ffffffffc0205ec6:	fc5e                	sd	s7,56(sp)
ffffffffc0205ec8:	f862                	sd	s8,48(sp)
ffffffffc0205eca:	83b1                	srli	a5,a5,0xc
ffffffffc0205ecc:	06b2                	slli	a3,a3,0xc
ffffffffc0205ece:	2ee7f463          	bgeu	a5,a4,ffffffffc02061b6 <do_fork+0x36a>
ffffffffc0205ed2:	000cb703          	ld	a4,0(s9)
ffffffffc0205ed6:	00091b97          	auipc	s7,0x91
ffffffffc0205eda:	9d2b8b93          	addi	s7,s7,-1582 # ffffffffc02968a8 <va_pa_offset>
ffffffffc0205ede:	000bb783          	ld	a5,0(s7)
ffffffffc0205ee2:	02873c03          	ld	s8,40(a4)
ffffffffc0205ee6:	96be                	add	a3,a3,a5
ffffffffc0205ee8:	e814                	sd	a3,16(s0)
ffffffffc0205eea:	020c0a63          	beqz	s8,ffffffffc0205f1e <do_fork+0xd2>
ffffffffc0205eee:	1009f793          	andi	a5,s3,256
ffffffffc0205ef2:	1a078b63          	beqz	a5,ffffffffc02060a8 <do_fork+0x25c>
ffffffffc0205ef6:	030c2703          	lw	a4,48(s8)
ffffffffc0205efa:	018c3783          	ld	a5,24(s8)
ffffffffc0205efe:	c02006b7          	lui	a3,0xc0200
ffffffffc0205f02:	2705                	addiw	a4,a4,1
ffffffffc0205f04:	02ec2823          	sw	a4,48(s8)
ffffffffc0205f08:	03843423          	sd	s8,40(s0)
ffffffffc0205f0c:	28d7e663          	bltu	a5,a3,ffffffffc0206198 <do_fork+0x34c>
ffffffffc0205f10:	000bb603          	ld	a2,0(s7)
ffffffffc0205f14:	000cb703          	ld	a4,0(s9)
ffffffffc0205f18:	6814                	ld	a3,16(s0)
ffffffffc0205f1a:	8f91                	sub	a5,a5,a2
ffffffffc0205f1c:	f45c                	sd	a5,168(s0)
ffffffffc0205f1e:	6789                	lui	a5,0x2
ffffffffc0205f20:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205f24:	96be                	add	a3,a3,a5
ffffffffc0205f26:	f054                	sd	a3,160(s0)
ffffffffc0205f28:	87b6                	mv	a5,a3
ffffffffc0205f2a:	12048613          	addi	a2,s1,288
ffffffffc0205f2e:	688c                	ld	a1,16(s1)
ffffffffc0205f30:	0004b803          	ld	a6,0(s1)
ffffffffc0205f34:	6488                	ld	a0,8(s1)
ffffffffc0205f36:	eb8c                	sd	a1,16(a5)
ffffffffc0205f38:	0107b023          	sd	a6,0(a5)
ffffffffc0205f3c:	e788                	sd	a0,8(a5)
ffffffffc0205f3e:	6c8c                	ld	a1,24(s1)
ffffffffc0205f40:	02048493          	addi	s1,s1,32
ffffffffc0205f44:	02078793          	addi	a5,a5,32
ffffffffc0205f48:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0205f4c:	fec491e3          	bne	s1,a2,ffffffffc0205f2e <do_fork+0xe2>
ffffffffc0205f50:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205f54:	1a090863          	beqz	s2,ffffffffc0206104 <do_fork+0x2b8>
ffffffffc0205f58:	14873483          	ld	s1,328(a4)
ffffffffc0205f5c:	00000797          	auipc	a5,0x0
ffffffffc0205f60:	c8878793          	addi	a5,a5,-888 # ffffffffc0205be4 <forkret>
ffffffffc0205f64:	0126b823          	sd	s2,16(a3)
ffffffffc0205f68:	fc14                	sd	a3,56(s0)
ffffffffc0205f6a:	f81c                	sd	a5,48(s0)
ffffffffc0205f6c:	28048163          	beqz	s1,ffffffffc02061ee <do_fork+0x3a2>
ffffffffc0205f70:	03499793          	slli	a5,s3,0x34
ffffffffc0205f74:	0007cd63          	bltz	a5,ffffffffc0205f8e <do_fork+0x142>
ffffffffc0205f78:	b84ff0ef          	jal	ffffffffc02052fc <files_create>
ffffffffc0205f7c:	892a                	mv	s2,a0
ffffffffc0205f7e:	14050163          	beqz	a0,ffffffffc02060c0 <do_fork+0x274>
ffffffffc0205f82:	85a6                	mv	a1,s1
ffffffffc0205f84:	cb0ff0ef          	jal	ffffffffc0205434 <dup_files>
ffffffffc0205f88:	84ca                	mv	s1,s2
ffffffffc0205f8a:	1c051863          	bnez	a0,ffffffffc020615a <do_fork+0x30e>
ffffffffc0205f8e:	489c                	lw	a5,16(s1)
ffffffffc0205f90:	0008b517          	auipc	a0,0x8b
ffffffffc0205f94:	0cc52503          	lw	a0,204(a0) # ffffffffc029105c <last_pid.1>
ffffffffc0205f98:	6709                	lui	a4,0x2
ffffffffc0205f9a:	2785                	addiw	a5,a5,1
ffffffffc0205f9c:	c89c                	sw	a5,16(s1)
ffffffffc0205f9e:	2505                	addiw	a0,a0,1
ffffffffc0205fa0:	14943423          	sd	s1,328(s0)
ffffffffc0205fa4:	0008b797          	auipc	a5,0x8b
ffffffffc0205fa8:	0aa7ac23          	sw	a0,184(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0205fac:	14e55e63          	bge	a0,a4,ffffffffc0206108 <do_fork+0x2bc>
ffffffffc0205fb0:	0008b797          	auipc	a5,0x8b
ffffffffc0205fb4:	0a87a783          	lw	a5,168(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc0205fb8:	00090497          	auipc	s1,0x90
ffffffffc0205fbc:	80848493          	addi	s1,s1,-2040 # ffffffffc02957c0 <proc_list>
ffffffffc0205fc0:	06f54563          	blt	a0,a5,ffffffffc020602a <do_fork+0x1de>
ffffffffc0205fc4:	0008f497          	auipc	s1,0x8f
ffffffffc0205fc8:	7fc48493          	addi	s1,s1,2044 # ffffffffc02957c0 <proc_list>
ffffffffc0205fcc:	0084b883          	ld	a7,8(s1)
ffffffffc0205fd0:	6789                	lui	a5,0x2
ffffffffc0205fd2:	0008b717          	auipc	a4,0x8b
ffffffffc0205fd6:	08f72323          	sw	a5,134(a4) # ffffffffc0291058 <next_safe.0>
ffffffffc0205fda:	86aa                	mv	a3,a0
ffffffffc0205fdc:	4581                	li	a1,0
ffffffffc0205fde:	04988063          	beq	a7,s1,ffffffffc020601e <do_fork+0x1d2>
ffffffffc0205fe2:	882e                	mv	a6,a1
ffffffffc0205fe4:	87c6                	mv	a5,a7
ffffffffc0205fe6:	6609                	lui	a2,0x2
ffffffffc0205fe8:	a811                	j	ffffffffc0205ffc <do_fork+0x1b0>
ffffffffc0205fea:	00e6d663          	bge	a3,a4,ffffffffc0205ff6 <do_fork+0x1aa>
ffffffffc0205fee:	00c75463          	bge	a4,a2,ffffffffc0205ff6 <do_fork+0x1aa>
ffffffffc0205ff2:	863a                	mv	a2,a4
ffffffffc0205ff4:	4805                	li	a6,1
ffffffffc0205ff6:	679c                	ld	a5,8(a5)
ffffffffc0205ff8:	00978d63          	beq	a5,s1,ffffffffc0206012 <do_fork+0x1c6>
ffffffffc0205ffc:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0206000:	fed715e3          	bne	a4,a3,ffffffffc0205fea <do_fork+0x19e>
ffffffffc0206004:	2685                	addiw	a3,a3,1
ffffffffc0206006:	14c6d463          	bge	a3,a2,ffffffffc020614e <do_fork+0x302>
ffffffffc020600a:	679c                	ld	a5,8(a5)
ffffffffc020600c:	4585                	li	a1,1
ffffffffc020600e:	fe9797e3          	bne	a5,s1,ffffffffc0205ffc <do_fork+0x1b0>
ffffffffc0206012:	00080663          	beqz	a6,ffffffffc020601e <do_fork+0x1d2>
ffffffffc0206016:	0008b797          	auipc	a5,0x8b
ffffffffc020601a:	04c7a123          	sw	a2,66(a5) # ffffffffc0291058 <next_safe.0>
ffffffffc020601e:	c591                	beqz	a1,ffffffffc020602a <do_fork+0x1de>
ffffffffc0206020:	0008b797          	auipc	a5,0x8b
ffffffffc0206024:	02d7ae23          	sw	a3,60(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0206028:	8536                	mv	a0,a3
ffffffffc020602a:	c048                	sw	a0,4(s0)
ffffffffc020602c:	45a9                	li	a1,10
ffffffffc020602e:	043050ef          	jal	ffffffffc020b870 <hash32>
ffffffffc0206032:	02051793          	slli	a5,a0,0x20
ffffffffc0206036:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020603a:	0008b797          	auipc	a5,0x8b
ffffffffc020603e:	78678793          	addi	a5,a5,1926 # ffffffffc02917c0 <hash_list>
ffffffffc0206042:	953e                	add	a0,a0,a5
ffffffffc0206044:	6518                	ld	a4,8(a0)
ffffffffc0206046:	0d840793          	addi	a5,s0,216
ffffffffc020604a:	6490                	ld	a2,8(s1)
ffffffffc020604c:	e31c                	sd	a5,0(a4)
ffffffffc020604e:	e51c                	sd	a5,8(a0)
ffffffffc0206050:	f078                	sd	a4,224(s0)
ffffffffc0206052:	0c840793          	addi	a5,s0,200
ffffffffc0206056:	7018                	ld	a4,32(s0)
ffffffffc0206058:	ec68                	sd	a0,216(s0)
ffffffffc020605a:	e21c                	sd	a5,0(a2)
ffffffffc020605c:	0e043c23          	sd	zero,248(s0)
ffffffffc0206060:	7b74                	ld	a3,240(a4)
ffffffffc0206062:	e49c                	sd	a5,8(s1)
ffffffffc0206064:	e870                	sd	a2,208(s0)
ffffffffc0206066:	e464                	sd	s1,200(s0)
ffffffffc0206068:	10d43023          	sd	a3,256(s0)
ffffffffc020606c:	c299                	beqz	a3,ffffffffc0206072 <do_fork+0x226>
ffffffffc020606e:	fee0                	sd	s0,248(a3)
ffffffffc0206070:	7018                	ld	a4,32(s0)
ffffffffc0206072:	00091797          	auipc	a5,0x91
ffffffffc0206076:	84e7a783          	lw	a5,-1970(a5) # ffffffffc02968c0 <nr_process>
ffffffffc020607a:	fb60                	sd	s0,240(a4)
ffffffffc020607c:	8522                	mv	a0,s0
ffffffffc020607e:	2785                	addiw	a5,a5,1
ffffffffc0206080:	00091717          	auipc	a4,0x91
ffffffffc0206084:	84f72023          	sw	a5,-1984(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0206088:	167010ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc020608c:	4048                	lw	a0,4(s0)
ffffffffc020608e:	6a46                	ld	s4,80(sp)
ffffffffc0206090:	6aa6                	ld	s5,72(sp)
ffffffffc0206092:	6b06                	ld	s6,64(sp)
ffffffffc0206094:	7be2                	ld	s7,56(sp)
ffffffffc0206096:	7c42                	ld	s8,48(sp)
ffffffffc0206098:	7ca2                	ld	s9,40(sp)
ffffffffc020609a:	70e6                	ld	ra,120(sp)
ffffffffc020609c:	7446                	ld	s0,112(sp)
ffffffffc020609e:	74a6                	ld	s1,104(sp)
ffffffffc02060a0:	7906                	ld	s2,96(sp)
ffffffffc02060a2:	69e6                	ld	s3,88(sp)
ffffffffc02060a4:	6109                	addi	sp,sp,128
ffffffffc02060a6:	8082                	ret
ffffffffc02060a8:	f06a                	sd	s10,32(sp)
ffffffffc02060aa:	c51fd0ef          	jal	ffffffffc0203cfa <mm_create>
ffffffffc02060ae:	8d2a                	mv	s10,a0
ffffffffc02060b0:	c561                	beqz	a0,ffffffffc0206178 <do_fork+0x32c>
ffffffffc02060b2:	cafff0ef          	jal	ffffffffc0205d60 <setup_pgdir>
ffffffffc02060b6:	cd39                	beqz	a0,ffffffffc0206114 <do_fork+0x2c8>
ffffffffc02060b8:	856a                	mv	a0,s10
ffffffffc02060ba:	d8dfd0ef          	jal	ffffffffc0203e46 <mm_destroy>
ffffffffc02060be:	7d02                	ld	s10,32(sp)
ffffffffc02060c0:	6814                	ld	a3,16(s0)
ffffffffc02060c2:	c02007b7          	lui	a5,0xc0200
ffffffffc02060c6:	10f6e663          	bltu	a3,a5,ffffffffc02061d2 <do_fork+0x386>
ffffffffc02060ca:	000bb783          	ld	a5,0(s7)
ffffffffc02060ce:	000b3703          	ld	a4,0(s6)
ffffffffc02060d2:	40f687b3          	sub	a5,a3,a5
ffffffffc02060d6:	83b1                	srli	a5,a5,0xc
ffffffffc02060d8:	0ae7f263          	bgeu	a5,a4,ffffffffc020617c <do_fork+0x330>
ffffffffc02060dc:	000ab503          	ld	a0,0(s5)
ffffffffc02060e0:	414787b3          	sub	a5,a5,s4
ffffffffc02060e4:	079a                	slli	a5,a5,0x6
ffffffffc02060e6:	953e                	add	a0,a0,a5
ffffffffc02060e8:	4589                	li	a1,2
ffffffffc02060ea:	910fc0ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02060ee:	6a46                	ld	s4,80(sp)
ffffffffc02060f0:	6aa6                	ld	s5,72(sp)
ffffffffc02060f2:	6b06                	ld	s6,64(sp)
ffffffffc02060f4:	7be2                	ld	s7,56(sp)
ffffffffc02060f6:	7c42                	ld	s8,48(sp)
ffffffffc02060f8:	8522                	mv	a0,s0
ffffffffc02060fa:	fa9fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02060fe:	7ca2                	ld	s9,40(sp)
ffffffffc0206100:	5571                	li	a0,-4
ffffffffc0206102:	bf61                	j	ffffffffc020609a <do_fork+0x24e>
ffffffffc0206104:	8936                	mv	s2,a3
ffffffffc0206106:	bd89                	j	ffffffffc0205f58 <do_fork+0x10c>
ffffffffc0206108:	4505                	li	a0,1
ffffffffc020610a:	0008b797          	auipc	a5,0x8b
ffffffffc020610e:	f4a7a923          	sw	a0,-174(a5) # ffffffffc029105c <last_pid.1>
ffffffffc0206112:	bd4d                	j	ffffffffc0205fc4 <do_fork+0x178>
ffffffffc0206114:	038c0793          	addi	a5,s8,56
ffffffffc0206118:	853e                	mv	a0,a5
ffffffffc020611a:	e43e                	sd	a5,8(sp)
ffffffffc020611c:	ec6e                	sd	s11,24(sp)
ffffffffc020611e:	d5cfe0ef          	jal	ffffffffc020467a <down>
ffffffffc0206122:	000cb783          	ld	a5,0(s9)
ffffffffc0206126:	c781                	beqz	a5,ffffffffc020612e <do_fork+0x2e2>
ffffffffc0206128:	43dc                	lw	a5,4(a5)
ffffffffc020612a:	04fc2823          	sw	a5,80(s8)
ffffffffc020612e:	85e2                	mv	a1,s8
ffffffffc0206130:	856a                	mv	a0,s10
ffffffffc0206132:	e33fd0ef          	jal	ffffffffc0203f64 <dup_mmap>
ffffffffc0206136:	8daa                	mv	s11,a0
ffffffffc0206138:	6522                	ld	a0,8(sp)
ffffffffc020613a:	d3cfe0ef          	jal	ffffffffc0204676 <up>
ffffffffc020613e:	040c2823          	sw	zero,80(s8)
ffffffffc0206142:	8c6a                	mv	s8,s10
ffffffffc0206144:	000d9f63          	bnez	s11,ffffffffc0206162 <do_fork+0x316>
ffffffffc0206148:	7d02                	ld	s10,32(sp)
ffffffffc020614a:	6de2                	ld	s11,24(sp)
ffffffffc020614c:	b36d                	j	ffffffffc0205ef6 <do_fork+0xaa>
ffffffffc020614e:	6789                	lui	a5,0x2
ffffffffc0206150:	00f6c363          	blt	a3,a5,ffffffffc0206156 <do_fork+0x30a>
ffffffffc0206154:	4685                	li	a3,1
ffffffffc0206156:	4585                	li	a1,1
ffffffffc0206158:	b559                	j	ffffffffc0205fde <do_fork+0x192>
ffffffffc020615a:	854a                	mv	a0,s2
ffffffffc020615c:	9d6ff0ef          	jal	ffffffffc0205332 <files_destroy>
ffffffffc0206160:	b785                	j	ffffffffc02060c0 <do_fork+0x274>
ffffffffc0206162:	856a                	mv	a0,s10
ffffffffc0206164:	e99fd0ef          	jal	ffffffffc0203ffc <exit_mmap>
ffffffffc0206168:	018d3503          	ld	a0,24(s10)
ffffffffc020616c:	a87ff0ef          	jal	ffffffffc0205bf2 <put_pgdir.isra.0>
ffffffffc0206170:	6de2                	ld	s11,24(sp)
ffffffffc0206172:	b799                	j	ffffffffc02060b8 <do_fork+0x26c>
ffffffffc0206174:	556d                	li	a0,-5
ffffffffc0206176:	8082                	ret
ffffffffc0206178:	7d02                	ld	s10,32(sp)
ffffffffc020617a:	b799                	j	ffffffffc02060c0 <do_fork+0x274>
ffffffffc020617c:	00007617          	auipc	a2,0x7
ffffffffc0206180:	c6c60613          	addi	a2,a2,-916 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc0206184:	06900593          	li	a1,105
ffffffffc0206188:	00007517          	auipc	a0,0x7
ffffffffc020618c:	bb850513          	addi	a0,a0,-1096 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0206190:	f06a                	sd	s10,32(sp)
ffffffffc0206192:	ec6e                	sd	s11,24(sp)
ffffffffc0206194:	ab6fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206198:	86be                	mv	a3,a5
ffffffffc020619a:	00007617          	auipc	a2,0x7
ffffffffc020619e:	c2660613          	addi	a2,a2,-986 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02061a2:	1bb00593          	li	a1,443
ffffffffc02061a6:	00008517          	auipc	a0,0x8
ffffffffc02061aa:	b2250513          	addi	a0,a0,-1246 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02061ae:	f06a                	sd	s10,32(sp)
ffffffffc02061b0:	ec6e                	sd	s11,24(sp)
ffffffffc02061b2:	a98fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02061b6:	00007617          	auipc	a2,0x7
ffffffffc02061ba:	b6260613          	addi	a2,a2,-1182 # ffffffffc020cd18 <etext+0xf04>
ffffffffc02061be:	07100593          	li	a1,113
ffffffffc02061c2:	00007517          	auipc	a0,0x7
ffffffffc02061c6:	b7e50513          	addi	a0,a0,-1154 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02061ca:	f06a                	sd	s10,32(sp)
ffffffffc02061cc:	ec6e                	sd	s11,24(sp)
ffffffffc02061ce:	a7cfa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02061d2:	00007617          	auipc	a2,0x7
ffffffffc02061d6:	bee60613          	addi	a2,a2,-1042 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc02061da:	07700593          	li	a1,119
ffffffffc02061de:	00007517          	auipc	a0,0x7
ffffffffc02061e2:	b6250513          	addi	a0,a0,-1182 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02061e6:	f06a                	sd	s10,32(sp)
ffffffffc02061e8:	ec6e                	sd	s11,24(sp)
ffffffffc02061ea:	a60fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02061ee:	00008697          	auipc	a3,0x8
ffffffffc02061f2:	af268693          	addi	a3,a3,-1294 # ffffffffc020dce0 <etext+0x1ecc>
ffffffffc02061f6:	00006617          	auipc	a2,0x6
ffffffffc02061fa:	05a60613          	addi	a2,a2,90 # ffffffffc020c250 <etext+0x43c>
ffffffffc02061fe:	1db00593          	li	a1,475
ffffffffc0206202:	00008517          	auipc	a0,0x8
ffffffffc0206206:	ac650513          	addi	a0,a0,-1338 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc020620a:	f06a                	sd	s10,32(sp)
ffffffffc020620c:	ec6e                	sd	s11,24(sp)
ffffffffc020620e:	a3cfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206212 <kernel_thread>:
ffffffffc0206212:	7129                	addi	sp,sp,-320
ffffffffc0206214:	fa22                	sd	s0,304(sp)
ffffffffc0206216:	f626                	sd	s1,296(sp)
ffffffffc0206218:	f24a                	sd	s2,288(sp)
ffffffffc020621a:	842a                	mv	s0,a0
ffffffffc020621c:	84ae                	mv	s1,a1
ffffffffc020621e:	8932                	mv	s2,a2
ffffffffc0206220:	850a                	mv	a0,sp
ffffffffc0206222:	12000613          	li	a2,288
ffffffffc0206226:	4581                	li	a1,0
ffffffffc0206228:	fe06                	sd	ra,312(sp)
ffffffffc020622a:	383050ef          	jal	ffffffffc020bdac <memset>
ffffffffc020622e:	e0a2                	sd	s0,64(sp)
ffffffffc0206230:	e4a6                	sd	s1,72(sp)
ffffffffc0206232:	100027f3          	csrr	a5,sstatus
ffffffffc0206236:	edd7f793          	andi	a5,a5,-291
ffffffffc020623a:	1207e793          	ori	a5,a5,288
ffffffffc020623e:	860a                	mv	a2,sp
ffffffffc0206240:	10096513          	ori	a0,s2,256
ffffffffc0206244:	00000717          	auipc	a4,0x0
ffffffffc0206248:	8fa70713          	addi	a4,a4,-1798 # ffffffffc0205b3e <kernel_thread_entry>
ffffffffc020624c:	4581                	li	a1,0
ffffffffc020624e:	e23e                	sd	a5,256(sp)
ffffffffc0206250:	e63a                	sd	a4,264(sp)
ffffffffc0206252:	bfbff0ef          	jal	ffffffffc0205e4c <do_fork>
ffffffffc0206256:	70f2                	ld	ra,312(sp)
ffffffffc0206258:	7452                	ld	s0,304(sp)
ffffffffc020625a:	74b2                	ld	s1,296(sp)
ffffffffc020625c:	7912                	ld	s2,288(sp)
ffffffffc020625e:	6131                	addi	sp,sp,320
ffffffffc0206260:	8082                	ret

ffffffffc0206262 <do_exit>:
ffffffffc0206262:	7179                	addi	sp,sp,-48
ffffffffc0206264:	f022                	sd	s0,32(sp)
ffffffffc0206266:	00090417          	auipc	s0,0x90
ffffffffc020626a:	66240413          	addi	s0,s0,1634 # ffffffffc02968c8 <current>
ffffffffc020626e:	601c                	ld	a5,0(s0)
ffffffffc0206270:	00090717          	auipc	a4,0x90
ffffffffc0206274:	66873703          	ld	a4,1640(a4) # ffffffffc02968d8 <idleproc>
ffffffffc0206278:	f406                	sd	ra,40(sp)
ffffffffc020627a:	ec26                	sd	s1,24(sp)
ffffffffc020627c:	0ee78763          	beq	a5,a4,ffffffffc020636a <do_exit+0x108>
ffffffffc0206280:	00090497          	auipc	s1,0x90
ffffffffc0206284:	65048493          	addi	s1,s1,1616 # ffffffffc02968d0 <initproc>
ffffffffc0206288:	6098                	ld	a4,0(s1)
ffffffffc020628a:	e84a                	sd	s2,16(sp)
ffffffffc020628c:	10e78863          	beq	a5,a4,ffffffffc020639c <do_exit+0x13a>
ffffffffc0206290:	7798                	ld	a4,40(a5)
ffffffffc0206292:	892a                	mv	s2,a0
ffffffffc0206294:	cb0d                	beqz	a4,ffffffffc02062c6 <do_exit+0x64>
ffffffffc0206296:	00090797          	auipc	a5,0x90
ffffffffc020629a:	6027b783          	ld	a5,1538(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc020629e:	56fd                	li	a3,-1
ffffffffc02062a0:	16fe                	slli	a3,a3,0x3f
ffffffffc02062a2:	83b1                	srli	a5,a5,0xc
ffffffffc02062a4:	8fd5                	or	a5,a5,a3
ffffffffc02062a6:	18079073          	csrw	satp,a5
ffffffffc02062aa:	5b1c                	lw	a5,48(a4)
ffffffffc02062ac:	37fd                	addiw	a5,a5,-1
ffffffffc02062ae:	db1c                	sw	a5,48(a4)
ffffffffc02062b0:	cbf1                	beqz	a5,ffffffffc0206384 <do_exit+0x122>
ffffffffc02062b2:	601c                	ld	a5,0(s0)
ffffffffc02062b4:	1487b503          	ld	a0,328(a5)
ffffffffc02062b8:	0207b423          	sd	zero,40(a5)
ffffffffc02062bc:	c509                	beqz	a0,ffffffffc02062c6 <do_exit+0x64>
ffffffffc02062be:	491c                	lw	a5,16(a0)
ffffffffc02062c0:	37fd                	addiw	a5,a5,-1
ffffffffc02062c2:	c91c                	sw	a5,16(a0)
ffffffffc02062c4:	c3c5                	beqz	a5,ffffffffc0206364 <do_exit+0x102>
ffffffffc02062c6:	601c                	ld	a5,0(s0)
ffffffffc02062c8:	470d                	li	a4,3
ffffffffc02062ca:	0f27a423          	sw	s2,232(a5)
ffffffffc02062ce:	c398                	sw	a4,0(a5)
ffffffffc02062d0:	100027f3          	csrr	a5,sstatus
ffffffffc02062d4:	8b89                	andi	a5,a5,2
ffffffffc02062d6:	4901                	li	s2,0
ffffffffc02062d8:	0c079e63          	bnez	a5,ffffffffc02063b4 <do_exit+0x152>
ffffffffc02062dc:	6018                	ld	a4,0(s0)
ffffffffc02062de:	800007b7          	lui	a5,0x80000
ffffffffc02062e2:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02062e4:	7308                	ld	a0,32(a4)
ffffffffc02062e6:	0ec52703          	lw	a4,236(a0)
ffffffffc02062ea:	0cf70963          	beq	a4,a5,ffffffffc02063bc <do_exit+0x15a>
ffffffffc02062ee:	6018                	ld	a4,0(s0)
ffffffffc02062f0:	7b7c                	ld	a5,240(a4)
ffffffffc02062f2:	c7a1                	beqz	a5,ffffffffc020633a <do_exit+0xd8>
ffffffffc02062f4:	800005b7          	lui	a1,0x80000
ffffffffc02062f8:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02062fa:	460d                	li	a2,3
ffffffffc02062fc:	a021                	j	ffffffffc0206304 <do_exit+0xa2>
ffffffffc02062fe:	6018                	ld	a4,0(s0)
ffffffffc0206300:	7b7c                	ld	a5,240(a4)
ffffffffc0206302:	cf85                	beqz	a5,ffffffffc020633a <do_exit+0xd8>
ffffffffc0206304:	1007b683          	ld	a3,256(a5)
ffffffffc0206308:	6088                	ld	a0,0(s1)
ffffffffc020630a:	fb74                	sd	a3,240(a4)
ffffffffc020630c:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206310:	7978                	ld	a4,240(a0)
ffffffffc0206312:	10e7b023          	sd	a4,256(a5)
ffffffffc0206316:	c311                	beqz	a4,ffffffffc020631a <do_exit+0xb8>
ffffffffc0206318:	ff7c                	sd	a5,248(a4)
ffffffffc020631a:	4398                	lw	a4,0(a5)
ffffffffc020631c:	f388                	sd	a0,32(a5)
ffffffffc020631e:	f97c                	sd	a5,240(a0)
ffffffffc0206320:	fcc71fe3          	bne	a4,a2,ffffffffc02062fe <do_exit+0x9c>
ffffffffc0206324:	0ec52783          	lw	a5,236(a0)
ffffffffc0206328:	fcb79be3          	bne	a5,a1,ffffffffc02062fe <do_exit+0x9c>
ffffffffc020632c:	6c2010ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc0206330:	800005b7          	lui	a1,0x80000
ffffffffc0206334:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0206336:	460d                	li	a2,3
ffffffffc0206338:	b7d9                	j	ffffffffc02062fe <do_exit+0x9c>
ffffffffc020633a:	02091263          	bnez	s2,ffffffffc020635e <do_exit+0xfc>
ffffffffc020633e:	7a8010ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc0206342:	601c                	ld	a5,0(s0)
ffffffffc0206344:	00008617          	auipc	a2,0x8
ffffffffc0206348:	9d460613          	addi	a2,a2,-1580 # ffffffffc020dd18 <etext+0x1f04>
ffffffffc020634c:	29e00593          	li	a1,670
ffffffffc0206350:	43d4                	lw	a3,4(a5)
ffffffffc0206352:	00008517          	auipc	a0,0x8
ffffffffc0206356:	97650513          	addi	a0,a0,-1674 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc020635a:	8f0fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020635e:	875fa0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0206362:	bff1                	j	ffffffffc020633e <do_exit+0xdc>
ffffffffc0206364:	fcffe0ef          	jal	ffffffffc0205332 <files_destroy>
ffffffffc0206368:	bfb9                	j	ffffffffc02062c6 <do_exit+0x64>
ffffffffc020636a:	00008617          	auipc	a2,0x8
ffffffffc020636e:	98e60613          	addi	a2,a2,-1650 # ffffffffc020dcf8 <etext+0x1ee4>
ffffffffc0206372:	26900593          	li	a1,617
ffffffffc0206376:	00008517          	auipc	a0,0x8
ffffffffc020637a:	95250513          	addi	a0,a0,-1710 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc020637e:	e84a                	sd	s2,16(sp)
ffffffffc0206380:	8cafa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206384:	853a                	mv	a0,a4
ffffffffc0206386:	e43a                	sd	a4,8(sp)
ffffffffc0206388:	c75fd0ef          	jal	ffffffffc0203ffc <exit_mmap>
ffffffffc020638c:	6722                	ld	a4,8(sp)
ffffffffc020638e:	6f08                	ld	a0,24(a4)
ffffffffc0206390:	863ff0ef          	jal	ffffffffc0205bf2 <put_pgdir.isra.0>
ffffffffc0206394:	6522                	ld	a0,8(sp)
ffffffffc0206396:	ab1fd0ef          	jal	ffffffffc0203e46 <mm_destroy>
ffffffffc020639a:	bf21                	j	ffffffffc02062b2 <do_exit+0x50>
ffffffffc020639c:	00008617          	auipc	a2,0x8
ffffffffc02063a0:	96c60613          	addi	a2,a2,-1684 # ffffffffc020dd08 <etext+0x1ef4>
ffffffffc02063a4:	26d00593          	li	a1,621
ffffffffc02063a8:	00008517          	auipc	a0,0x8
ffffffffc02063ac:	92050513          	addi	a0,a0,-1760 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02063b0:	89afa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02063b4:	825fa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02063b8:	4905                	li	s2,1
ffffffffc02063ba:	b70d                	j	ffffffffc02062dc <do_exit+0x7a>
ffffffffc02063bc:	632010ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc02063c0:	b73d                	j	ffffffffc02062ee <do_exit+0x8c>

ffffffffc02063c2 <do_wait.part.0>:
ffffffffc02063c2:	7179                	addi	sp,sp,-48
ffffffffc02063c4:	ec26                	sd	s1,24(sp)
ffffffffc02063c6:	e84a                	sd	s2,16(sp)
ffffffffc02063c8:	e44e                	sd	s3,8(sp)
ffffffffc02063ca:	f406                	sd	ra,40(sp)
ffffffffc02063cc:	f022                	sd	s0,32(sp)
ffffffffc02063ce:	84aa                	mv	s1,a0
ffffffffc02063d0:	892e                	mv	s2,a1
ffffffffc02063d2:	00090997          	auipc	s3,0x90
ffffffffc02063d6:	4f698993          	addi	s3,s3,1270 # ffffffffc02968c8 <current>
ffffffffc02063da:	cd19                	beqz	a0,ffffffffc02063f8 <do_wait.part.0+0x36>
ffffffffc02063dc:	6789                	lui	a5,0x2
ffffffffc02063de:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc02063e0:	fff5071b          	addiw	a4,a0,-1
ffffffffc02063e4:	12e7f563          	bgeu	a5,a4,ffffffffc020650e <do_wait.part.0+0x14c>
ffffffffc02063e8:	70a2                	ld	ra,40(sp)
ffffffffc02063ea:	7402                	ld	s0,32(sp)
ffffffffc02063ec:	64e2                	ld	s1,24(sp)
ffffffffc02063ee:	6942                	ld	s2,16(sp)
ffffffffc02063f0:	69a2                	ld	s3,8(sp)
ffffffffc02063f2:	5579                	li	a0,-2
ffffffffc02063f4:	6145                	addi	sp,sp,48
ffffffffc02063f6:	8082                	ret
ffffffffc02063f8:	0009b703          	ld	a4,0(s3)
ffffffffc02063fc:	7b60                	ld	s0,240(a4)
ffffffffc02063fe:	d46d                	beqz	s0,ffffffffc02063e8 <do_wait.part.0+0x26>
ffffffffc0206400:	468d                	li	a3,3
ffffffffc0206402:	a021                	j	ffffffffc020640a <do_wait.part.0+0x48>
ffffffffc0206404:	10043403          	ld	s0,256(s0)
ffffffffc0206408:	c075                	beqz	s0,ffffffffc02064ec <do_wait.part.0+0x12a>
ffffffffc020640a:	401c                	lw	a5,0(s0)
ffffffffc020640c:	fed79ce3          	bne	a5,a3,ffffffffc0206404 <do_wait.part.0+0x42>
ffffffffc0206410:	00090797          	auipc	a5,0x90
ffffffffc0206414:	4c87b783          	ld	a5,1224(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0206418:	14878263          	beq	a5,s0,ffffffffc020655c <do_wait.part.0+0x19a>
ffffffffc020641c:	00090797          	auipc	a5,0x90
ffffffffc0206420:	4b47b783          	ld	a5,1204(a5) # ffffffffc02968d0 <initproc>
ffffffffc0206424:	12f40c63          	beq	s0,a5,ffffffffc020655c <do_wait.part.0+0x19a>
ffffffffc0206428:	00090663          	beqz	s2,ffffffffc0206434 <do_wait.part.0+0x72>
ffffffffc020642c:	0e842783          	lw	a5,232(s0)
ffffffffc0206430:	00f92023          	sw	a5,0(s2)
ffffffffc0206434:	100027f3          	csrr	a5,sstatus
ffffffffc0206438:	8b89                	andi	a5,a5,2
ffffffffc020643a:	4601                	li	a2,0
ffffffffc020643c:	10079963          	bnez	a5,ffffffffc020654e <do_wait.part.0+0x18c>
ffffffffc0206440:	6c74                	ld	a3,216(s0)
ffffffffc0206442:	7078                	ld	a4,224(s0)
ffffffffc0206444:	10043783          	ld	a5,256(s0)
ffffffffc0206448:	e698                	sd	a4,8(a3)
ffffffffc020644a:	e314                	sd	a3,0(a4)
ffffffffc020644c:	6474                	ld	a3,200(s0)
ffffffffc020644e:	6878                	ld	a4,208(s0)
ffffffffc0206450:	e698                	sd	a4,8(a3)
ffffffffc0206452:	e314                	sd	a3,0(a4)
ffffffffc0206454:	c789                	beqz	a5,ffffffffc020645e <do_wait.part.0+0x9c>
ffffffffc0206456:	7c78                	ld	a4,248(s0)
ffffffffc0206458:	fff8                	sd	a4,248(a5)
ffffffffc020645a:	10043783          	ld	a5,256(s0)
ffffffffc020645e:	7c78                	ld	a4,248(s0)
ffffffffc0206460:	c36d                	beqz	a4,ffffffffc0206542 <do_wait.part.0+0x180>
ffffffffc0206462:	10f73023          	sd	a5,256(a4)
ffffffffc0206466:	00090797          	auipc	a5,0x90
ffffffffc020646a:	45a7a783          	lw	a5,1114(a5) # ffffffffc02968c0 <nr_process>
ffffffffc020646e:	37fd                	addiw	a5,a5,-1
ffffffffc0206470:	00090717          	auipc	a4,0x90
ffffffffc0206474:	44f72823          	sw	a5,1104(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0206478:	e271                	bnez	a2,ffffffffc020653c <do_wait.part.0+0x17a>
ffffffffc020647a:	6814                	ld	a3,16(s0)
ffffffffc020647c:	c02007b7          	lui	a5,0xc0200
ffffffffc0206480:	10f6e663          	bltu	a3,a5,ffffffffc020658c <do_wait.part.0+0x1ca>
ffffffffc0206484:	00090717          	auipc	a4,0x90
ffffffffc0206488:	42473703          	ld	a4,1060(a4) # ffffffffc02968a8 <va_pa_offset>
ffffffffc020648c:	00090797          	auipc	a5,0x90
ffffffffc0206490:	4247b783          	ld	a5,1060(a5) # ffffffffc02968b0 <npage>
ffffffffc0206494:	8e99                	sub	a3,a3,a4
ffffffffc0206496:	82b1                	srli	a3,a3,0xc
ffffffffc0206498:	0cf6fe63          	bgeu	a3,a5,ffffffffc0206574 <do_wait.part.0+0x1b2>
ffffffffc020649c:	0000a797          	auipc	a5,0xa
ffffffffc02064a0:	afc7b783          	ld	a5,-1284(a5) # ffffffffc020ff98 <nbase>
ffffffffc02064a4:	00090517          	auipc	a0,0x90
ffffffffc02064a8:	41453503          	ld	a0,1044(a0) # ffffffffc02968b8 <pages>
ffffffffc02064ac:	4589                	li	a1,2
ffffffffc02064ae:	8e9d                	sub	a3,a3,a5
ffffffffc02064b0:	069a                	slli	a3,a3,0x6
ffffffffc02064b2:	9536                	add	a0,a0,a3
ffffffffc02064b4:	d47fb0ef          	jal	ffffffffc02021fa <free_pages>
ffffffffc02064b8:	8522                	mv	a0,s0
ffffffffc02064ba:	be9fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02064be:	70a2                	ld	ra,40(sp)
ffffffffc02064c0:	7402                	ld	s0,32(sp)
ffffffffc02064c2:	64e2                	ld	s1,24(sp)
ffffffffc02064c4:	6942                	ld	s2,16(sp)
ffffffffc02064c6:	69a2                	ld	s3,8(sp)
ffffffffc02064c8:	4501                	li	a0,0
ffffffffc02064ca:	6145                	addi	sp,sp,48
ffffffffc02064cc:	8082                	ret
ffffffffc02064ce:	00090997          	auipc	s3,0x90
ffffffffc02064d2:	3fa98993          	addi	s3,s3,1018 # ffffffffc02968c8 <current>
ffffffffc02064d6:	0009b703          	ld	a4,0(s3)
ffffffffc02064da:	f487b683          	ld	a3,-184(a5)
ffffffffc02064de:	f0e695e3          	bne	a3,a4,ffffffffc02063e8 <do_wait.part.0+0x26>
ffffffffc02064e2:	f287a603          	lw	a2,-216(a5)
ffffffffc02064e6:	468d                	li	a3,3
ffffffffc02064e8:	06d60063          	beq	a2,a3,ffffffffc0206548 <do_wait.part.0+0x186>
ffffffffc02064ec:	800007b7          	lui	a5,0x80000
ffffffffc02064f0:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02064f2:	4685                	li	a3,1
ffffffffc02064f4:	0ef72623          	sw	a5,236(a4)
ffffffffc02064f8:	c314                	sw	a3,0(a4)
ffffffffc02064fa:	5ec010ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc02064fe:	0009b783          	ld	a5,0(s3)
ffffffffc0206502:	0b07a783          	lw	a5,176(a5)
ffffffffc0206506:	8b85                	andi	a5,a5,1
ffffffffc0206508:	e7b9                	bnez	a5,ffffffffc0206556 <do_wait.part.0+0x194>
ffffffffc020650a:	ee0487e3          	beqz	s1,ffffffffc02063f8 <do_wait.part.0+0x36>
ffffffffc020650e:	45a9                	li	a1,10
ffffffffc0206510:	8526                	mv	a0,s1
ffffffffc0206512:	35e050ef          	jal	ffffffffc020b870 <hash32>
ffffffffc0206516:	02051793          	slli	a5,a0,0x20
ffffffffc020651a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020651e:	0008b797          	auipc	a5,0x8b
ffffffffc0206522:	2a278793          	addi	a5,a5,674 # ffffffffc02917c0 <hash_list>
ffffffffc0206526:	953e                	add	a0,a0,a5
ffffffffc0206528:	87aa                	mv	a5,a0
ffffffffc020652a:	a029                	j	ffffffffc0206534 <do_wait.part.0+0x172>
ffffffffc020652c:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206530:	f8970fe3          	beq	a4,s1,ffffffffc02064ce <do_wait.part.0+0x10c>
ffffffffc0206534:	679c                	ld	a5,8(a5)
ffffffffc0206536:	fef51be3          	bne	a0,a5,ffffffffc020652c <do_wait.part.0+0x16a>
ffffffffc020653a:	b57d                	j	ffffffffc02063e8 <do_wait.part.0+0x26>
ffffffffc020653c:	e96fa0ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0206540:	bf2d                	j	ffffffffc020647a <do_wait.part.0+0xb8>
ffffffffc0206542:	7018                	ld	a4,32(s0)
ffffffffc0206544:	fb7c                	sd	a5,240(a4)
ffffffffc0206546:	b705                	j	ffffffffc0206466 <do_wait.part.0+0xa4>
ffffffffc0206548:	f2878413          	addi	s0,a5,-216
ffffffffc020654c:	b5d1                	j	ffffffffc0206410 <do_wait.part.0+0x4e>
ffffffffc020654e:	e8afa0ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0206552:	4605                	li	a2,1
ffffffffc0206554:	b5f5                	j	ffffffffc0206440 <do_wait.part.0+0x7e>
ffffffffc0206556:	555d                	li	a0,-9
ffffffffc0206558:	d0bff0ef          	jal	ffffffffc0206262 <do_exit>
ffffffffc020655c:	00007617          	auipc	a2,0x7
ffffffffc0206560:	7dc60613          	addi	a2,a2,2012 # ffffffffc020dd38 <etext+0x1f24>
ffffffffc0206564:	49c00593          	li	a1,1180
ffffffffc0206568:	00007517          	auipc	a0,0x7
ffffffffc020656c:	76050513          	addi	a0,a0,1888 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0206570:	edbf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206574:	00007617          	auipc	a2,0x7
ffffffffc0206578:	87460613          	addi	a2,a2,-1932 # ffffffffc020cde8 <etext+0xfd4>
ffffffffc020657c:	06900593          	li	a1,105
ffffffffc0206580:	00006517          	auipc	a0,0x6
ffffffffc0206584:	7c050513          	addi	a0,a0,1984 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0206588:	ec3f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020658c:	00007617          	auipc	a2,0x7
ffffffffc0206590:	83460613          	addi	a2,a2,-1996 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc0206594:	07700593          	li	a1,119
ffffffffc0206598:	00006517          	auipc	a0,0x6
ffffffffc020659c:	7a850513          	addi	a0,a0,1960 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc02065a0:	eabf90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02065a4 <init_main>:
ffffffffc02065a4:	1141                	addi	sp,sp,-16
ffffffffc02065a6:	00007517          	auipc	a0,0x7
ffffffffc02065aa:	7b250513          	addi	a0,a0,1970 # ffffffffc020dd58 <etext+0x1f44>
ffffffffc02065ae:	e406                	sd	ra,8(sp)
ffffffffc02065b0:	4c3010ef          	jal	ffffffffc0208272 <vfs_set_bootfs>
ffffffffc02065b4:	e179                	bnez	a0,ffffffffc020667a <init_main+0xd6>
ffffffffc02065b6:	c7dfb0ef          	jal	ffffffffc0202232 <nr_free_pages>
ffffffffc02065ba:	a3ffb0ef          	jal	ffffffffc0201ff8 <kallocated>
ffffffffc02065be:	4601                	li	a2,0
ffffffffc02065c0:	4581                	li	a1,0
ffffffffc02065c2:	00001517          	auipc	a0,0x1
ffffffffc02065c6:	95c50513          	addi	a0,a0,-1700 # ffffffffc0206f1e <user_main>
ffffffffc02065ca:	c49ff0ef          	jal	ffffffffc0206212 <kernel_thread>
ffffffffc02065ce:	00a04563          	bgtz	a0,ffffffffc02065d8 <init_main+0x34>
ffffffffc02065d2:	a841                	j	ffffffffc0206662 <init_main+0xbe>
ffffffffc02065d4:	512010ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc02065d8:	4581                	li	a1,0
ffffffffc02065da:	4501                	li	a0,0
ffffffffc02065dc:	de7ff0ef          	jal	ffffffffc02063c2 <do_wait.part.0>
ffffffffc02065e0:	d975                	beqz	a0,ffffffffc02065d4 <init_main+0x30>
ffffffffc02065e2:	d0bfe0ef          	jal	ffffffffc02052ec <fs_cleanup>
ffffffffc02065e6:	00007517          	auipc	a0,0x7
ffffffffc02065ea:	7ba50513          	addi	a0,a0,1978 # ffffffffc020dda0 <etext+0x1f8c>
ffffffffc02065ee:	bb9f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02065f2:	00090797          	auipc	a5,0x90
ffffffffc02065f6:	2de7b783          	ld	a5,734(a5) # ffffffffc02968d0 <initproc>
ffffffffc02065fa:	7bf8                	ld	a4,240(a5)
ffffffffc02065fc:	e339                	bnez	a4,ffffffffc0206642 <init_main+0x9e>
ffffffffc02065fe:	7ff8                	ld	a4,248(a5)
ffffffffc0206600:	e329                	bnez	a4,ffffffffc0206642 <init_main+0x9e>
ffffffffc0206602:	1007b703          	ld	a4,256(a5)
ffffffffc0206606:	ef15                	bnez	a4,ffffffffc0206642 <init_main+0x9e>
ffffffffc0206608:	00090697          	auipc	a3,0x90
ffffffffc020660c:	2b86a683          	lw	a3,696(a3) # ffffffffc02968c0 <nr_process>
ffffffffc0206610:	4709                	li	a4,2
ffffffffc0206612:	0ce69163          	bne	a3,a4,ffffffffc02066d4 <init_main+0x130>
ffffffffc0206616:	0008f717          	auipc	a4,0x8f
ffffffffc020661a:	1aa70713          	addi	a4,a4,426 # ffffffffc02957c0 <proc_list>
ffffffffc020661e:	6714                	ld	a3,8(a4)
ffffffffc0206620:	0c878793          	addi	a5,a5,200
ffffffffc0206624:	08d79863          	bne	a5,a3,ffffffffc02066b4 <init_main+0x110>
ffffffffc0206628:	6318                	ld	a4,0(a4)
ffffffffc020662a:	06e79563          	bne	a5,a4,ffffffffc0206694 <init_main+0xf0>
ffffffffc020662e:	00008517          	auipc	a0,0x8
ffffffffc0206632:	85a50513          	addi	a0,a0,-1958 # ffffffffc020de88 <etext+0x2074>
ffffffffc0206636:	b71f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020663a:	60a2                	ld	ra,8(sp)
ffffffffc020663c:	4501                	li	a0,0
ffffffffc020663e:	0141                	addi	sp,sp,16
ffffffffc0206640:	8082                	ret
ffffffffc0206642:	00007697          	auipc	a3,0x7
ffffffffc0206646:	78668693          	addi	a3,a3,1926 # ffffffffc020ddc8 <etext+0x1fb4>
ffffffffc020664a:	00006617          	auipc	a2,0x6
ffffffffc020664e:	c0660613          	addi	a2,a2,-1018 # ffffffffc020c250 <etext+0x43c>
ffffffffc0206652:	51200593          	li	a1,1298
ffffffffc0206656:	00007517          	auipc	a0,0x7
ffffffffc020665a:	67250513          	addi	a0,a0,1650 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc020665e:	dedf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206662:	00007617          	auipc	a2,0x7
ffffffffc0206666:	71e60613          	addi	a2,a2,1822 # ffffffffc020dd80 <etext+0x1f6c>
ffffffffc020666a:	50500593          	li	a1,1285
ffffffffc020666e:	00007517          	auipc	a0,0x7
ffffffffc0206672:	65a50513          	addi	a0,a0,1626 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0206676:	dd5f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020667a:	86aa                	mv	a3,a0
ffffffffc020667c:	00007617          	auipc	a2,0x7
ffffffffc0206680:	6e460613          	addi	a2,a2,1764 # ffffffffc020dd60 <etext+0x1f4c>
ffffffffc0206684:	4fd00593          	li	a1,1277
ffffffffc0206688:	00007517          	auipc	a0,0x7
ffffffffc020668c:	64050513          	addi	a0,a0,1600 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0206690:	dbbf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206694:	00007697          	auipc	a3,0x7
ffffffffc0206698:	7c468693          	addi	a3,a3,1988 # ffffffffc020de58 <etext+0x2044>
ffffffffc020669c:	00006617          	auipc	a2,0x6
ffffffffc02066a0:	bb460613          	addi	a2,a2,-1100 # ffffffffc020c250 <etext+0x43c>
ffffffffc02066a4:	51500593          	li	a1,1301
ffffffffc02066a8:	00007517          	auipc	a0,0x7
ffffffffc02066ac:	62050513          	addi	a0,a0,1568 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02066b0:	d9bf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02066b4:	00007697          	auipc	a3,0x7
ffffffffc02066b8:	77468693          	addi	a3,a3,1908 # ffffffffc020de28 <etext+0x2014>
ffffffffc02066bc:	00006617          	auipc	a2,0x6
ffffffffc02066c0:	b9460613          	addi	a2,a2,-1132 # ffffffffc020c250 <etext+0x43c>
ffffffffc02066c4:	51400593          	li	a1,1300
ffffffffc02066c8:	00007517          	auipc	a0,0x7
ffffffffc02066cc:	60050513          	addi	a0,a0,1536 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02066d0:	d7bf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02066d4:	00007697          	auipc	a3,0x7
ffffffffc02066d8:	74468693          	addi	a3,a3,1860 # ffffffffc020de18 <etext+0x2004>
ffffffffc02066dc:	00006617          	auipc	a2,0x6
ffffffffc02066e0:	b7460613          	addi	a2,a2,-1164 # ffffffffc020c250 <etext+0x43c>
ffffffffc02066e4:	51300593          	li	a1,1299
ffffffffc02066e8:	00007517          	auipc	a0,0x7
ffffffffc02066ec:	5e050513          	addi	a0,a0,1504 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02066f0:	d5bf90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02066f4 <do_execve>:
ffffffffc02066f4:	bf010113          	addi	sp,sp,-1040
ffffffffc02066f8:	3e913c23          	sd	s1,1016(sp)
ffffffffc02066fc:	40113423          	sd	ra,1032(sp)
ffffffffc0206700:	3d713423          	sd	s7,968(sp)
ffffffffc0206704:	fff5849b          	addiw	s1,a1,-1
ffffffffc0206708:	47fd                	li	a5,31
ffffffffc020670a:	7697e763          	bltu	a5,s1,ffffffffc0206e78 <do_execve+0x784>
ffffffffc020670e:	3f313423          	sd	s3,1000(sp)
ffffffffc0206712:	00090997          	auipc	s3,0x90
ffffffffc0206716:	1b698993          	addi	s3,s3,438 # ffffffffc02968c8 <current>
ffffffffc020671a:	0009b783          	ld	a5,0(s3)
ffffffffc020671e:	3d613823          	sd	s6,976(sp)
ffffffffc0206722:	3f213823          	sd	s2,1008(sp)
ffffffffc0206726:	0287bb03          	ld	s6,40(a5)
ffffffffc020672a:	3d813023          	sd	s8,960(sp)
ffffffffc020672e:	3b913c23          	sd	s9,952(sp)
ffffffffc0206732:	8c32                	mv	s8,a2
ffffffffc0206734:	892a                	mv	s2,a0
ffffffffc0206736:	8cae                	mv	s9,a1
ffffffffc0206738:	00a8                	addi	a0,sp,72
ffffffffc020673a:	4641                	li	a2,16
ffffffffc020673c:	4581                	li	a1,0
ffffffffc020673e:	66e050ef          	jal	ffffffffc020bdac <memset>
ffffffffc0206742:	000b0c63          	beqz	s6,ffffffffc020675a <do_execve+0x66>
ffffffffc0206746:	038b0513          	addi	a0,s6,56
ffffffffc020674a:	f31fd0ef          	jal	ffffffffc020467a <down>
ffffffffc020674e:	0009b783          	ld	a5,0(s3)
ffffffffc0206752:	c781                	beqz	a5,ffffffffc020675a <do_execve+0x66>
ffffffffc0206754:	43dc                	lw	a5,4(a5)
ffffffffc0206756:	04fb2823          	sw	a5,80(s6)
ffffffffc020675a:	1e090d63          	beqz	s2,ffffffffc0206954 <do_execve+0x260>
ffffffffc020675e:	864a                	mv	a2,s2
ffffffffc0206760:	46c1                	li	a3,16
ffffffffc0206762:	00ac                	addi	a1,sp,72
ffffffffc0206764:	855a                	mv	a0,s6
ffffffffc0206766:	d47fd0ef          	jal	ffffffffc02044ac <copy_string>
ffffffffc020676a:	6e050563          	beqz	a0,ffffffffc0206e54 <do_execve+0x760>
ffffffffc020676e:	3d513c23          	sd	s5,984(sp)
ffffffffc0206772:	3bb13423          	sd	s11,936(sp)
ffffffffc0206776:	003c9613          	slli	a2,s9,0x3
ffffffffc020677a:	4681                	li	a3,0
ffffffffc020677c:	85e2                	mv	a1,s8
ffffffffc020677e:	855a                	mv	a0,s6
ffffffffc0206780:	003c9d93          	slli	s11,s9,0x3
ffffffffc0206784:	8ae2                	mv	s5,s8
ffffffffc0206786:	c15fd0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc020678a:	70050d63          	beqz	a0,ffffffffc0206ea4 <do_execve+0x7b0>
ffffffffc020678e:	3f413023          	sd	s4,992(sp)
ffffffffc0206792:	09810b93          	addi	s7,sp,152
ffffffffc0206796:	4a01                	li	s4,0
ffffffffc0206798:	6505                	lui	a0,0x1
ffffffffc020679a:	863fb0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020679e:	892a                	mv	s2,a0
ffffffffc02067a0:	12050963          	beqz	a0,ffffffffc02068d2 <do_execve+0x1de>
ffffffffc02067a4:	000ab603          	ld	a2,0(s5)
ffffffffc02067a8:	85aa                	mv	a1,a0
ffffffffc02067aa:	6685                	lui	a3,0x1
ffffffffc02067ac:	855a                	mv	a0,s6
ffffffffc02067ae:	cfffd0ef          	jal	ffffffffc02044ac <copy_string>
ffffffffc02067b2:	18050c63          	beqz	a0,ffffffffc020694a <do_execve+0x256>
ffffffffc02067b6:	012bb023          	sd	s2,0(s7)
ffffffffc02067ba:	2a05                	addiw	s4,s4,1
ffffffffc02067bc:	0ba1                	addi	s7,s7,8
ffffffffc02067be:	0aa1                	addi	s5,s5,8
ffffffffc02067c0:	fd4c9ce3          	bne	s9,s4,ffffffffc0206798 <do_execve+0xa4>
ffffffffc02067c4:	40813023          	sd	s0,1024(sp)
ffffffffc02067c8:	3ba13823          	sd	s10,944(sp)
ffffffffc02067cc:	000c3903          	ld	s2,0(s8)
ffffffffc02067d0:	0a0b0163          	beqz	s6,ffffffffc0206872 <do_execve+0x17e>
ffffffffc02067d4:	038b0513          	addi	a0,s6,56
ffffffffc02067d8:	e9ffd0ef          	jal	ffffffffc0204676 <up>
ffffffffc02067dc:	0009b783          	ld	a5,0(s3)
ffffffffc02067e0:	040b2823          	sw	zero,80(s6)
ffffffffc02067e4:	1487b503          	ld	a0,328(a5)
ffffffffc02067e8:	be1fe0ef          	jal	ffffffffc02053c8 <files_closeall>
ffffffffc02067ec:	854a                	mv	a0,s2
ffffffffc02067ee:	4581                	li	a1,0
ffffffffc02067f0:	e69fe0ef          	jal	ffffffffc0205658 <sysfile_open>
ffffffffc02067f4:	892a                	mv	s2,a0
ffffffffc02067f6:	08054b63          	bltz	a0,ffffffffc020688c <do_execve+0x198>
ffffffffc02067fa:	00090797          	auipc	a5,0x90
ffffffffc02067fe:	09e7b783          	ld	a5,158(a5) # ffffffffc0296898 <boot_pgdir_pa>
ffffffffc0206802:	577d                	li	a4,-1
ffffffffc0206804:	177e                	slli	a4,a4,0x3f
ffffffffc0206806:	83b1                	srli	a5,a5,0xc
ffffffffc0206808:	8fd9                	or	a5,a5,a4
ffffffffc020680a:	18079073          	csrw	satp,a5
ffffffffc020680e:	030b2783          	lw	a5,48(s6)
ffffffffc0206812:	37fd                	addiw	a5,a5,-1
ffffffffc0206814:	02fb2823          	sw	a5,48(s6)
ffffffffc0206818:	18078f63          	beqz	a5,ffffffffc02069b6 <do_execve+0x2c2>
ffffffffc020681c:	0009b783          	ld	a5,0(s3)
ffffffffc0206820:	0207b423          	sd	zero,40(a5)
ffffffffc0206824:	cd6fd0ef          	jal	ffffffffc0203cfa <mm_create>
ffffffffc0206828:	8a2a                	mv	s4,a0
ffffffffc020682a:	68050b63          	beqz	a0,ffffffffc0206ec0 <do_execve+0x7cc>
ffffffffc020682e:	d32ff0ef          	jal	ffffffffc0205d60 <setup_pgdir>
ffffffffc0206832:	e551                	bnez	a0,ffffffffc02068be <do_execve+0x1ca>
ffffffffc0206834:	4601                	li	a2,0
ffffffffc0206836:	4581                	li	a1,0
ffffffffc0206838:	854a                	mv	a0,s2
ffffffffc020683a:	8d6ff0ef          	jal	ffffffffc0205910 <sysfile_seek>
ffffffffc020683e:	8aaa                	mv	s5,a0
ffffffffc0206840:	12050a63          	beqz	a0,ffffffffc0206974 <do_execve+0x280>
ffffffffc0206844:	02049d13          	slli	s10,s1,0x20
ffffffffc0206848:	020d5d13          	srli	s10,s10,0x20
ffffffffc020684c:	09010b13          	addi	s6,sp,144
ffffffffc0206850:	08810c13          	addi	s8,sp,136
ffffffffc0206854:	8552                	mv	a0,s4
ffffffffc0206856:	fa6fd0ef          	jal	ffffffffc0203ffc <exit_mmap>
ffffffffc020685a:	018a3503          	ld	a0,24(s4)
ffffffffc020685e:	b94ff0ef          	jal	ffffffffc0205bf2 <put_pgdir.isra.0>
ffffffffc0206862:	8552                	mv	a0,s4
ffffffffc0206864:	de2fd0ef          	jal	ffffffffc0203e46 <mm_destroy>
ffffffffc0206868:	854a                	mv	a0,s2
ffffffffc020686a:	e25fe0ef          	jal	ffffffffc020568e <sysfile_close>
ffffffffc020686e:	8956                	mv	s2,s5
ffffffffc0206870:	a035                	j	ffffffffc020689c <do_execve+0x1a8>
ffffffffc0206872:	0009b783          	ld	a5,0(s3)
ffffffffc0206876:	1487b503          	ld	a0,328(a5)
ffffffffc020687a:	b4ffe0ef          	jal	ffffffffc02053c8 <files_closeall>
ffffffffc020687e:	854a                	mv	a0,s2
ffffffffc0206880:	4581                	li	a1,0
ffffffffc0206882:	dd7fe0ef          	jal	ffffffffc0205658 <sysfile_open>
ffffffffc0206886:	892a                	mv	s2,a0
ffffffffc0206888:	f8055ee3          	bgez	a0,ffffffffc0206824 <do_execve+0x130>
ffffffffc020688c:	02049d13          	slli	s10,s1,0x20
ffffffffc0206890:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206894:	09010b13          	addi	s6,sp,144
ffffffffc0206898:	08810c13          	addi	s8,sp,136
ffffffffc020689c:	01bc07b3          	add	a5,s8,s11
ffffffffc02068a0:	003d1493          	slli	s1,s10,0x3
ffffffffc02068a4:	409784b3          	sub	s1,a5,s1
ffffffffc02068a8:	9b6e                	add	s6,s6,s11
ffffffffc02068aa:	000b3503          	ld	a0,0(s6)
ffffffffc02068ae:	1b61                	addi	s6,s6,-8
ffffffffc02068b0:	ff2fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02068b4:	ff649be3          	bne	s1,s6,ffffffffc02068aa <do_execve+0x1b6>
ffffffffc02068b8:	854a                	mv	a0,s2
ffffffffc02068ba:	9a9ff0ef          	jal	ffffffffc0206262 <do_exit>
ffffffffc02068be:	02049d13          	slli	s10,s1,0x20
ffffffffc02068c2:	020d5d13          	srli	s10,s10,0x20
ffffffffc02068c6:	5af1                	li	s5,-4
ffffffffc02068c8:	09010b13          	addi	s6,sp,144
ffffffffc02068cc:	08810c13          	addi	s8,sp,136
ffffffffc02068d0:	bf49                	j	ffffffffc0206862 <do_execve+0x16e>
ffffffffc02068d2:	5bf1                	li	s7,-4
ffffffffc02068d4:	340a0563          	beqz	s4,ffffffffc0206c1e <do_execve+0x52a>
ffffffffc02068d8:	003a1793          	slli	a5,s4,0x3
ffffffffc02068dc:	3a7d                	addiw	s4,s4,-1
ffffffffc02068de:	0124                	addi	s1,sp,136
ffffffffc02068e0:	020a1713          	slli	a4,s4,0x20
ffffffffc02068e4:	40813023          	sd	s0,1024(sp)
ffffffffc02068e8:	01d75a13          	srli	s4,a4,0x1d
ffffffffc02068ec:	94be                	add	s1,s1,a5
ffffffffc02068ee:	0900                	addi	s0,sp,144
ffffffffc02068f0:	414484b3          	sub	s1,s1,s4
ffffffffc02068f4:	943e                	add	s0,s0,a5
ffffffffc02068f6:	6008                	ld	a0,0(s0)
ffffffffc02068f8:	1461                	addi	s0,s0,-8
ffffffffc02068fa:	fa8fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02068fe:	fe941ce3          	bne	s0,s1,ffffffffc02068f6 <do_execve+0x202>
ffffffffc0206902:	40013403          	ld	s0,1024(sp)
ffffffffc0206906:	3e013a03          	ld	s4,992(sp)
ffffffffc020690a:	000b0863          	beqz	s6,ffffffffc020691a <do_execve+0x226>
ffffffffc020690e:	038b0513          	addi	a0,s6,56
ffffffffc0206912:	d65fd0ef          	jal	ffffffffc0204676 <up>
ffffffffc0206916:	040b2823          	sw	zero,80(s6)
ffffffffc020691a:	3f013903          	ld	s2,1008(sp)
ffffffffc020691e:	3e813983          	ld	s3,1000(sp)
ffffffffc0206922:	3d813a83          	ld	s5,984(sp)
ffffffffc0206926:	3d013b03          	ld	s6,976(sp)
ffffffffc020692a:	3c013c03          	ld	s8,960(sp)
ffffffffc020692e:	3b813c83          	ld	s9,952(sp)
ffffffffc0206932:	3a813d83          	ld	s11,936(sp)
ffffffffc0206936:	40813083          	ld	ra,1032(sp)
ffffffffc020693a:	3f813483          	ld	s1,1016(sp)
ffffffffc020693e:	855e                	mv	a0,s7
ffffffffc0206940:	3c813b83          	ld	s7,968(sp)
ffffffffc0206944:	41010113          	addi	sp,sp,1040
ffffffffc0206948:	8082                	ret
ffffffffc020694a:	854a                	mv	a0,s2
ffffffffc020694c:	f56fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206950:	5bf5                	li	s7,-3
ffffffffc0206952:	b749                	j	ffffffffc02068d4 <do_execve+0x1e0>
ffffffffc0206954:	0009b783          	ld	a5,0(s3)
ffffffffc0206958:	00007617          	auipc	a2,0x7
ffffffffc020695c:	55060613          	addi	a2,a2,1360 # ffffffffc020dea8 <etext+0x2094>
ffffffffc0206960:	45c1                	li	a1,16
ffffffffc0206962:	43d4                	lw	a3,4(a5)
ffffffffc0206964:	00a8                	addi	a0,sp,72
ffffffffc0206966:	3d513c23          	sd	s5,984(sp)
ffffffffc020696a:	3bb13423          	sd	s11,936(sp)
ffffffffc020696e:	33c050ef          	jal	ffffffffc020bcaa <snprintf>
ffffffffc0206972:	b511                	j	ffffffffc0206776 <do_execve+0x82>
ffffffffc0206974:	04000613          	li	a2,64
ffffffffc0206978:	08ac                	addi	a1,sp,88
ffffffffc020697a:	854a                	mv	a0,s2
ffffffffc020697c:	d17fe0ef          	jal	ffffffffc0205692 <sysfile_read>
ffffffffc0206980:	04000793          	li	a5,64
ffffffffc0206984:	00f50863          	beq	a0,a5,ffffffffc0206994 <do_execve+0x2a0>
ffffffffc0206988:	00050a9b          	sext.w	s5,a0
ffffffffc020698c:	ea054ce3          	bltz	a0,ffffffffc0206844 <do_execve+0x150>
ffffffffc0206990:	5afd                	li	s5,-1
ffffffffc0206992:	bd4d                	j	ffffffffc0206844 <do_execve+0x150>
ffffffffc0206994:	4766                	lw	a4,88(sp)
ffffffffc0206996:	464c47b7          	lui	a5,0x464c4
ffffffffc020699a:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc020699e:	02f70763          	beq	a4,a5,ffffffffc02069cc <do_execve+0x2d8>
ffffffffc02069a2:	02049d13          	slli	s10,s1,0x20
ffffffffc02069a6:	020d5d13          	srli	s10,s10,0x20
ffffffffc02069aa:	5af5                	li	s5,-3
ffffffffc02069ac:	09010b13          	addi	s6,sp,144
ffffffffc02069b0:	08810c13          	addi	s8,sp,136
ffffffffc02069b4:	b545                	j	ffffffffc0206854 <do_execve+0x160>
ffffffffc02069b6:	855a                	mv	a0,s6
ffffffffc02069b8:	e44fd0ef          	jal	ffffffffc0203ffc <exit_mmap>
ffffffffc02069bc:	018b3503          	ld	a0,24(s6)
ffffffffc02069c0:	a32ff0ef          	jal	ffffffffc0205bf2 <put_pgdir.isra.0>
ffffffffc02069c4:	855a                	mv	a0,s6
ffffffffc02069c6:	c80fd0ef          	jal	ffffffffc0203e46 <mm_destroy>
ffffffffc02069ca:	bd89                	j	ffffffffc020681c <do_execve+0x128>
ffffffffc02069cc:	09015783          	lhu	a5,144(sp)
ffffffffc02069d0:	24079c63          	bnez	a5,ffffffffc0206c28 <do_execve+0x534>
ffffffffc02069d4:	6505                	lui	a0,0x1
ffffffffc02069d6:	e26fb0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02069da:	e82a                	sd	a0,16(sp)
ffffffffc02069dc:	e402                	sd	zero,8(sp)
ffffffffc02069de:	2a050b63          	beqz	a0,ffffffffc0206c94 <do_execve+0x5a0>
ffffffffc02069e2:	09015783          	lhu	a5,144(sp)
ffffffffc02069e6:	873e                	mv	a4,a5
ffffffffc02069e8:	cfa1                	beqz	a5,ffffffffc0206a40 <do_execve+0x34c>
ffffffffc02069ea:	6b22                	ld	s6,8(sp)
ffffffffc02069ec:	4b85                	li	s7,1
ffffffffc02069ee:	000b2783          	lw	a5,0(s6)
ffffffffc02069f2:	05779063          	bne	a5,s7,ffffffffc0206a32 <do_execve+0x33e>
ffffffffc02069f6:	028b3603          	ld	a2,40(s6)
ffffffffc02069fa:	020b3783          	ld	a5,32(s6)
ffffffffc02069fe:	48f66963          	bltu	a2,a5,ffffffffc0206e90 <do_execve+0x79c>
ffffffffc0206a02:	004b2783          	lw	a5,4(s6)
ffffffffc0206a06:	0027d693          	srli	a3,a5,0x2
ffffffffc0206a0a:	0027f713          	andi	a4,a5,2
ffffffffc0206a0e:	8a85                	andi	a3,a3,1
ffffffffc0206a10:	c319                	beqz	a4,ffffffffc0206a16 <do_execve+0x322>
ffffffffc0206a12:	0026e693          	ori	a3,a3,2
ffffffffc0206a16:	8b85                	andi	a5,a5,1
ffffffffc0206a18:	010b3583          	ld	a1,16(s6)
ffffffffc0206a1c:	0027979b          	slliw	a5,a5,0x2
ffffffffc0206a20:	8edd                	or	a3,a3,a5
ffffffffc0206a22:	4701                	li	a4,0
ffffffffc0206a24:	8552                	mv	a0,s4
ffffffffc0206a26:	c72fd0ef          	jal	ffffffffc0203e98 <mm_map>
ffffffffc0206a2a:	44051963          	bnez	a0,ffffffffc0206e7c <do_execve+0x788>
ffffffffc0206a2e:	09015703          	lhu	a4,144(sp)
ffffffffc0206a32:	2a85                	addiw	s5,s5,1
ffffffffc0206a34:	0007079b          	sext.w	a5,a4
ffffffffc0206a38:	038b0b13          	addi	s6,s6,56
ffffffffc0206a3c:	fafac9e3          	blt	s5,a5,ffffffffc02069ee <do_execve+0x2fa>
ffffffffc0206a40:	4701                	li	a4,0
ffffffffc0206a42:	46ad                	li	a3,11
ffffffffc0206a44:	00100637          	lui	a2,0x100
ffffffffc0206a48:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206a4c:	8552                	mv	a0,s4
ffffffffc0206a4e:	c4afd0ef          	jal	ffffffffc0203e98 <mm_map>
ffffffffc0206a52:	8aaa                	mv	s5,a0
ffffffffc0206a54:	2e051863          	bnez	a0,ffffffffc0206d44 <do_execve+0x650>
ffffffffc0206a58:	09015783          	lhu	a5,144(sp)
ffffffffc0206a5c:	873e                	mv	a4,a5
ffffffffc0206a5e:	c385                	beqz	a5,ffffffffc0206a7e <do_execve+0x38a>
ffffffffc0206a60:	66a2                	ld	a3,8(sp)
ffffffffc0206a62:	4801                	li	a6,0
ffffffffc0206a64:	ec66                	sd	s9,24(sp)
ffffffffc0206a66:	429c                	lw	a5,0(a3)
ffffffffc0206a68:	4605                	li	a2,1
ffffffffc0206a6a:	26c78663          	beq	a5,a2,ffffffffc0206cd6 <do_execve+0x5e2>
ffffffffc0206a6e:	2805                	addiw	a6,a6,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0206a70:	0007079b          	sext.w	a5,a4
ffffffffc0206a74:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206a78:	fef847e3          	blt	a6,a5,ffffffffc0206a66 <do_execve+0x372>
ffffffffc0206a7c:	6ce2                	ld	s9,24(sp)
ffffffffc0206a7e:	02049793          	slli	a5,s1,0x20
ffffffffc0206a82:	9381                	srli	a5,a5,0x20
ffffffffc0206a84:	08810c13          	addi	s8,sp,136
ffffffffc0206a88:	00379713          	slli	a4,a5,0x3
ffffffffc0206a8c:	09010b13          	addi	s6,sp,144
ffffffffc0206a90:	8d3e                	mv	s10,a5
ffffffffc0206a92:	01bc04b3          	add	s1,s8,s11
ffffffffc0206a96:	0b3c                	addi	a5,sp,408
ffffffffc0206a98:	6685                	lui	a3,0x1
ffffffffc0206a9a:	8c99                	sub	s1,s1,a4
ffffffffc0206a9c:	00f705b3          	add	a1,a4,a5
ffffffffc0206aa0:	01bb0ab3          	add	s5,s6,s11
ffffffffc0206aa4:	4605                	li	a2,1
ffffffffc0206aa6:	fff68713          	addi	a4,a3,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0206aaa:	ec4a                	sd	s2,24(sp)
ffffffffc0206aac:	f866                	sd	s9,48(sp)
ffffffffc0206aae:	8926                	mv	s2,s1
ffffffffc0206ab0:	8bd6                	mv	s7,s5
ffffffffc0206ab2:	f03a                	sd	a4,32(sp)
ffffffffc0206ab4:	01f61413          	slli	s0,a2,0x1f
ffffffffc0206ab8:	f43e                	sd	a5,40(sp)
ffffffffc0206aba:	84ae                	mv	s1,a1
ffffffffc0206abc:	8cda                	mv	s9,s6
ffffffffc0206abe:	000abb03          	ld	s6,0(s5)
ffffffffc0206ac2:	7582                	ld	a1,32(sp)
ffffffffc0206ac4:	855a                	mv	a0,s6
ffffffffc0206ac6:	24a050ef          	jal	ffffffffc020bd10 <strnlen>
ffffffffc0206aca:	00150693          	addi	a3,a0,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0206ace:	8c15                	sub	s0,s0,a3
ffffffffc0206ad0:	7ff017b7          	lui	a5,0x7ff01
ffffffffc0206ad4:	40f46863          	bltu	s0,a5,ffffffffc0206ee4 <do_execve+0x7f0>
ffffffffc0206ad8:	018a3503          	ld	a0,24(s4)
ffffffffc0206adc:	865a                	mv	a2,s6
ffffffffc0206ade:	4759                	li	a4,22
ffffffffc0206ae0:	85a2                	mv	a1,s0
ffffffffc0206ae2:	988ff0ef          	jal	ffffffffc0205c6a <copy_to_user_pages>
ffffffffc0206ae6:	3e051f63          	bnez	a0,ffffffffc0206ee4 <do_execve+0x7f0>
ffffffffc0206aea:	e080                	sd	s0,0(s1)
ffffffffc0206aec:	1ae1                	addi	s5,s5,-8
ffffffffc0206aee:	14e1                	addi	s1,s1,-8
ffffffffc0206af0:	fd2a97e3          	bne	s5,s2,ffffffffc0206abe <do_execve+0x3ca>
ffffffffc0206af4:	ff847713          	andi	a4,s0,-8
ffffffffc0206af8:	008d8693          	addi	a3,s11,8
ffffffffc0206afc:	40d70433          	sub	s0,a4,a3
ffffffffc0206b00:	7ff01737          	lui	a4,0x7ff01
ffffffffc0206b04:	84ca                	mv	s1,s2
ffffffffc0206b06:	8b66                	mv	s6,s9
ffffffffc0206b08:	77a2                	ld	a5,40(sp)
ffffffffc0206b0a:	6962                	ld	s2,24(sp)
ffffffffc0206b0c:	7cc2                	ld	s9,48(sp)
ffffffffc0206b0e:	8ade                	mv	s5,s7
ffffffffc0206b10:	34e46063          	bltu	s0,a4,ffffffffc0206e50 <do_execve+0x75c>
ffffffffc0206b14:	0d30                	addi	a2,sp,664
ffffffffc0206b16:	8732                	mv	a4,a2
ffffffffc0206b18:	638c                	ld	a1,0(a5)
ffffffffc0206b1a:	2505                	addiw	a0,a0,1
ffffffffc0206b1c:	07a1                	addi	a5,a5,8 # 7ff01008 <_binary_bin_sfs_img_size+0x7fe8bd08>
ffffffffc0206b1e:	e30c                	sd	a1,0(a4)
ffffffffc0206b20:	0721                	addi	a4,a4,8 # 7ff01008 <_binary_bin_sfs_img_size+0x7fe8bd08>
ffffffffc0206b22:	ff954be3          	blt	a0,s9,ffffffffc0206b18 <do_execve+0x424>
ffffffffc0206b26:	018a3503          	ld	a0,24(s4)
ffffffffc0206b2a:	01b607b3          	add	a5,a2,s11
ffffffffc0206b2e:	4759                	li	a4,22
ffffffffc0206b30:	85a2                	mv	a1,s0
ffffffffc0206b32:	0007b023          	sd	zero,0(a5)
ffffffffc0206b36:	934ff0ef          	jal	ffffffffc0205c6a <copy_to_user_pages>
ffffffffc0206b3a:	8baa                	mv	s7,a0
ffffffffc0206b3c:	30051a63          	bnez	a0,ffffffffc0206e50 <do_execve+0x75c>
ffffffffc0206b40:	0009b603          	ld	a2,0(s3)
ffffffffc0206b44:	7746                	ld	a4,112(sp)
ffffffffc0206b46:	ff047693          	andi	a3,s0,-16
ffffffffc0206b4a:	725c                	ld	a5,160(a2)
ffffffffc0206b4c:	0597b823          	sd	s9,80(a5)
ffffffffc0206b50:	efa0                	sd	s0,88(a5)
ffffffffc0206b52:	eb94                	sd	a3,16(a5)
ffffffffc0206b54:	10e7b423          	sd	a4,264(a5)
ffffffffc0206b58:	10002773          	csrr	a4,sstatus
ffffffffc0206b5c:	030a2583          	lw	a1,48(s4)
ffffffffc0206b60:	edd77713          	andi	a4,a4,-291
ffffffffc0206b64:	02076713          	ori	a4,a4,32
ffffffffc0206b68:	10e7b023          	sd	a4,256(a5)
ffffffffc0206b6c:	018a3683          	ld	a3,24(s4)
ffffffffc0206b70:	0015879b          	addiw	a5,a1,1 # 7ff00001 <_binary_bin_sfs_img_size+0x7fe8ad01>
ffffffffc0206b74:	03463423          	sd	s4,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc0206b78:	02fa2823          	sw	a5,48(s4)
ffffffffc0206b7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0206b80:	38f6e363          	bltu	a3,a5,ffffffffc0206f06 <do_execve+0x812>
ffffffffc0206b84:	00090797          	auipc	a5,0x90
ffffffffc0206b88:	d247b783          	ld	a5,-732(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206b8c:	577d                	li	a4,-1
ffffffffc0206b8e:	177e                	slli	a4,a4,0x3f
ffffffffc0206b90:	8e9d                	sub	a3,a3,a5
ffffffffc0206b92:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206b96:	f654                	sd	a3,168(a2)
ffffffffc0206b98:	8fd9                	or	a5,a5,a4
ffffffffc0206b9a:	18079073          	csrw	satp,a5
ffffffffc0206b9e:	12000073          	sfence.vma
ffffffffc0206ba2:	6542                	ld	a0,16(sp)
ffffffffc0206ba4:	cfefb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206ba8:	67a2                	ld	a5,8(sp)
ffffffffc0206baa:	c781                	beqz	a5,ffffffffc0206bb2 <do_execve+0x4be>
ffffffffc0206bac:	853e                	mv	a0,a5
ffffffffc0206bae:	cf4fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206bb2:	854a                	mv	a0,s2
ffffffffc0206bb4:	adbfe0ef          	jal	ffffffffc020568e <sysfile_close>
ffffffffc0206bb8:	000ab503          	ld	a0,0(s5)
ffffffffc0206bbc:	1ae1                	addi	s5,s5,-8
ffffffffc0206bbe:	ce4fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206bc2:	fe9a9be3          	bne	s5,s1,ffffffffc0206bb8 <do_execve+0x4c4>
ffffffffc0206bc6:	0009b403          	ld	s0,0(s3)
ffffffffc0206bca:	4641                	li	a2,16
ffffffffc0206bcc:	4581                	li	a1,0
ffffffffc0206bce:	0b440413          	addi	s0,s0,180
ffffffffc0206bd2:	8522                	mv	a0,s0
ffffffffc0206bd4:	1d8050ef          	jal	ffffffffc020bdac <memset>
ffffffffc0206bd8:	00ac                	addi	a1,sp,72
ffffffffc0206bda:	8522                	mv	a0,s0
ffffffffc0206bdc:	463d                	li	a2,15
ffffffffc0206bde:	21e050ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0206be2:	40813083          	ld	ra,1032(sp)
ffffffffc0206be6:	40013403          	ld	s0,1024(sp)
ffffffffc0206bea:	3f013903          	ld	s2,1008(sp)
ffffffffc0206bee:	3e813983          	ld	s3,1000(sp)
ffffffffc0206bf2:	3e013a03          	ld	s4,992(sp)
ffffffffc0206bf6:	3d813a83          	ld	s5,984(sp)
ffffffffc0206bfa:	3d013b03          	ld	s6,976(sp)
ffffffffc0206bfe:	3c013c03          	ld	s8,960(sp)
ffffffffc0206c02:	3b813c83          	ld	s9,952(sp)
ffffffffc0206c06:	3b013d03          	ld	s10,944(sp)
ffffffffc0206c0a:	3a813d83          	ld	s11,936(sp)
ffffffffc0206c0e:	3f813483          	ld	s1,1016(sp)
ffffffffc0206c12:	855e                	mv	a0,s7
ffffffffc0206c14:	3c813b83          	ld	s7,968(sp)
ffffffffc0206c18:	41010113          	addi	sp,sp,1040
ffffffffc0206c1c:	8082                	ret
ffffffffc0206c1e:	3e013a03          	ld	s4,992(sp)
ffffffffc0206c22:	ce0b16e3          	bnez	s6,ffffffffc020690e <do_execve+0x21a>
ffffffffc0206c26:	b9d5                	j	ffffffffc020691a <do_execve+0x226>
ffffffffc0206c28:	00379513          	slli	a0,a5,0x3
ffffffffc0206c2c:	8d1d                	sub	a0,a0,a5
ffffffffc0206c2e:	050e                	slli	a0,a0,0x3
ffffffffc0206c30:	bccfb0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0206c34:	e42a                	sd	a0,8(sp)
ffffffffc0206c36:	cd39                	beqz	a0,ffffffffc0206c94 <do_execve+0x5a0>
ffffffffc0206c38:	09015783          	lhu	a5,144(sp)
ffffffffc0206c3c:	6ba2                	ld	s7,8(sp)
ffffffffc0206c3e:	4b01                	li	s6,0
ffffffffc0206c40:	03800c13          	li	s8,56
ffffffffc0206c44:	cbad                	beqz	a5,ffffffffc0206cb6 <do_execve+0x5c2>
ffffffffc0206c46:	08e15783          	lhu	a5,142(sp)
ffffffffc0206c4a:	75e6                	ld	a1,120(sp)
ffffffffc0206c4c:	4601                	li	a2,0
ffffffffc0206c4e:	036787bb          	mulw	a5,a5,s6
ffffffffc0206c52:	854a                	mv	a0,s2
ffffffffc0206c54:	95be                	add	a1,a1,a5
ffffffffc0206c56:	cbbfe0ef          	jal	ffffffffc0205910 <sysfile_seek>
ffffffffc0206c5a:	842a                	mv	s0,a0
ffffffffc0206c5c:	ed19                	bnez	a0,ffffffffc0206c7a <do_execve+0x586>
ffffffffc0206c5e:	03800613          	li	a2,56
ffffffffc0206c62:	85de                	mv	a1,s7
ffffffffc0206c64:	854a                	mv	a0,s2
ffffffffc0206c66:	a2dfe0ef          	jal	ffffffffc0205692 <sysfile_read>
ffffffffc0206c6a:	03850f63          	beq	a0,s8,ffffffffc0206ca8 <do_execve+0x5b4>
ffffffffc0206c6e:	8b2a                	mv	s6,a0
ffffffffc0206c70:	00054363          	bltz	a0,ffffffffc0206c76 <do_execve+0x582>
ffffffffc0206c74:	5b7d                	li	s6,-1
ffffffffc0206c76:	000b041b          	sext.w	s0,s6
ffffffffc0206c7a:	02049d13          	slli	s10,s1,0x20
ffffffffc0206c7e:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206c82:	09010b13          	addi	s6,sp,144
ffffffffc0206c86:	08810c13          	addi	s8,sp,136
ffffffffc0206c8a:	6522                	ld	a0,8(sp)
ffffffffc0206c8c:	8aa2                	mv	s5,s0
ffffffffc0206c8e:	c14fb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206c92:	b6c9                	j	ffffffffc0206854 <do_execve+0x160>
ffffffffc0206c94:	02049d13          	slli	s10,s1,0x20
ffffffffc0206c98:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206c9c:	5af1                	li	s5,-4
ffffffffc0206c9e:	09010b13          	addi	s6,sp,144
ffffffffc0206ca2:	08810c13          	addi	s8,sp,136
ffffffffc0206ca6:	b67d                	j	ffffffffc0206854 <do_execve+0x160>
ffffffffc0206ca8:	09015783          	lhu	a5,144(sp)
ffffffffc0206cac:	2b05                	addiw	s6,s6,1
ffffffffc0206cae:	038b8b93          	addi	s7,s7,56
ffffffffc0206cb2:	f8fb4ae3          	blt	s6,a5,ffffffffc0206c46 <do_execve+0x552>
ffffffffc0206cb6:	6505                	lui	a0,0x1
ffffffffc0206cb8:	b44fb0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0206cbc:	e82a                	sd	a0,16(sp)
ffffffffc0206cbe:	d20512e3          	bnez	a0,ffffffffc02069e2 <do_execve+0x2ee>
ffffffffc0206cc2:	02049d13          	slli	s10,s1,0x20
ffffffffc0206cc6:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206cca:	5471                	li	s0,-4
ffffffffc0206ccc:	09010b13          	addi	s6,sp,144
ffffffffc0206cd0:	08810c13          	addi	s8,sp,136
ffffffffc0206cd4:	bf5d                	j	ffffffffc0206c8a <do_execve+0x596>
ffffffffc0206cd6:	42d8                	lw	a4,4(a3)
ffffffffc0206cd8:	4649                	li	a2,18
ffffffffc0206cda:	00477793          	andi	a5,a4,4
ffffffffc0206cde:	e391                	bnez	a5,ffffffffc0206ce2 <do_execve+0x5ee>
ffffffffc0206ce0:	4641                	li	a2,16
ffffffffc0206ce2:	00277793          	andi	a5,a4,2
ffffffffc0206ce6:	c399                	beqz	a5,ffffffffc0206cec <do_execve+0x5f8>
ffffffffc0206ce8:	00466613          	ori	a2,a2,4
ffffffffc0206cec:	0106bc03          	ld	s8,16(a3)
ffffffffc0206cf0:	0206bb83          	ld	s7,32(a3)
ffffffffc0206cf4:	00177413          	andi	s0,a4,1
ffffffffc0206cf8:	0034141b          	slliw	s0,s0,0x3
ffffffffc0206cfc:	8c51                	or	s0,s0,a2
ffffffffc0206cfe:	9be2                	add	s7,s7,s8
ffffffffc0206d00:	2401                	sext.w	s0,s0
ffffffffc0206d02:	8762                	mv	a4,s8
ffffffffc0206d04:	097c7163          	bgeu	s8,s7,ffffffffc0206d86 <do_execve+0x692>
ffffffffc0206d08:	0086bb03          	ld	s6,8(a3)
ffffffffc0206d0c:	8cc2                	mv	s9,a6
ffffffffc0206d0e:	f036                	sd	a3,32(sp)
ffffffffc0206d10:	4601                	li	a2,0
ffffffffc0206d12:	85da                	mv	a1,s6
ffffffffc0206d14:	854a                	mv	a0,s2
ffffffffc0206d16:	bfbfe0ef          	jal	ffffffffc0205910 <sysfile_seek>
ffffffffc0206d1a:	8aaa                	mv	s5,a0
ffffffffc0206d1c:	e505                	bnez	a0,ffffffffc0206d44 <do_execve+0x650>
ffffffffc0206d1e:	418b8ab3          	sub	s5,s7,s8
ffffffffc0206d22:	6785                	lui	a5,0x1
ffffffffc0206d24:	0157f363          	bgeu	a5,s5,ffffffffc0206d2a <do_execve+0x636>
ffffffffc0206d28:	8abe                	mv	s5,a5
ffffffffc0206d2a:	6d42                	ld	s10,16(sp)
ffffffffc0206d2c:	8656                	mv	a2,s5
ffffffffc0206d2e:	854a                	mv	a0,s2
ffffffffc0206d30:	85ea                	mv	a1,s10
ffffffffc0206d32:	961fe0ef          	jal	ffffffffc0205692 <sysfile_read>
ffffffffc0206d36:	02aa8763          	beq	s5,a0,ffffffffc0206d64 <do_execve+0x670>
ffffffffc0206d3a:	00050a9b          	sext.w	s5,a0
ffffffffc0206d3e:	00054363          	bltz	a0,ffffffffc0206d44 <do_execve+0x650>
ffffffffc0206d42:	5afd                	li	s5,-1
ffffffffc0206d44:	02049d13          	slli	s10,s1,0x20
ffffffffc0206d48:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206d4c:	09010b13          	addi	s6,sp,144
ffffffffc0206d50:	08810c13          	addi	s8,sp,136
ffffffffc0206d54:	6542                	ld	a0,16(sp)
ffffffffc0206d56:	b4cfb0ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0206d5a:	67a2                	ld	a5,8(sp)
ffffffffc0206d5c:	ae078ce3          	beqz	a5,ffffffffc0206854 <do_execve+0x160>
ffffffffc0206d60:	8456                	mv	s0,s5
ffffffffc0206d62:	b725                	j	ffffffffc0206c8a <do_execve+0x596>
ffffffffc0206d64:	018a3503          	ld	a0,24(s4)
ffffffffc0206d68:	8722                	mv	a4,s0
ffffffffc0206d6a:	86d6                	mv	a3,s5
ffffffffc0206d6c:	866a                	mv	a2,s10
ffffffffc0206d6e:	85e2                	mv	a1,s8
ffffffffc0206d70:	efbfe0ef          	jal	ffffffffc0205c6a <copy_to_user_pages>
ffffffffc0206d74:	12051c63          	bnez	a0,ffffffffc0206eac <do_execve+0x7b8>
ffffffffc0206d78:	9c56                	add	s8,s8,s5
ffffffffc0206d7a:	9b56                	add	s6,s6,s5
ffffffffc0206d7c:	f97c6ae3          	bltu	s8,s7,ffffffffc0206d10 <do_execve+0x61c>
ffffffffc0206d80:	7682                	ld	a3,32(sp)
ffffffffc0206d82:	8866                	mv	a6,s9
ffffffffc0206d84:	6a98                	ld	a4,16(a3)
ffffffffc0206d86:	7690                	ld	a2,40(a3)
ffffffffc0206d88:	9732                	add	a4,a4,a2
ffffffffc0206d8a:	00ec6563          	bltu	s8,a4,ffffffffc0206d94 <do_execve+0x6a0>
ffffffffc0206d8e:	09015703          	lhu	a4,144(sp)
ffffffffc0206d92:	b9f1                	j	ffffffffc0206a6e <do_execve+0x37a>
ffffffffc0206d94:	018a3783          	ld	a5,24(s4)
ffffffffc0206d98:	5afd                	li	s5,-1
ffffffffc0206d9a:	f04a                	sd	s2,32(sp)
ffffffffc0206d9c:	8d3e                	mv	s10,a5
ffffffffc0206d9e:	87a6                	mv	a5,s1
ffffffffc0206da0:	41870933          	sub	s2,a4,s8
ffffffffc0206da4:	84a2                	mv	s1,s0
ffffffffc0206da6:	00cada93          	srli	s5,s5,0xc
ffffffffc0206daa:	8462                	mv	s0,s8
ffffffffc0206dac:	00090c97          	auipc	s9,0x90
ffffffffc0206db0:	b0cc8c93          	addi	s9,s9,-1268 # ffffffffc02968b8 <pages>
ffffffffc0206db4:	00090b97          	auipc	s7,0x90
ffffffffc0206db8:	afcb8b93          	addi	s7,s7,-1284 # ffffffffc02968b0 <npage>
ffffffffc0206dbc:	f842                	sd	a6,48(sp)
ffffffffc0206dbe:	fc36                	sd	a3,56(sp)
ffffffffc0206dc0:	f452                	sd	s4,40(sp)
ffffffffc0206dc2:	8c3e                	mv	s8,a5
ffffffffc0206dc4:	a8a9                	j	ffffffffc0206e1e <do_execve+0x72a>
ffffffffc0206dc6:	000cb783          	ld	a5,0(s9)
ffffffffc0206dca:	00009717          	auipc	a4,0x9
ffffffffc0206dce:	1ce73703          	ld	a4,462(a4) # ffffffffc020ff98 <nbase>
ffffffffc0206dd2:	000bb603          	ld	a2,0(s7)
ffffffffc0206dd6:	40f507b3          	sub	a5,a0,a5
ffffffffc0206dda:	8799                	srai	a5,a5,0x6
ffffffffc0206ddc:	97ba                	add	a5,a5,a4
ffffffffc0206dde:	0157f533          	and	a0,a5,s5
ffffffffc0206de2:	00c79713          	slli	a4,a5,0xc
ffffffffc0206de6:	10c57363          	bgeu	a0,a2,ffffffffc0206eec <do_execve+0x7f8>
ffffffffc0206dea:	408b0633          	sub	a2,s6,s0
ffffffffc0206dee:	6785                	lui	a5,0x1
ffffffffc0206df0:	00f60a33          	add	s4,a2,a5
ffffffffc0206df4:	01497363          	bgeu	s2,s4,ffffffffc0206dfa <do_execve+0x706>
ffffffffc0206df8:	8a4a                	mv	s4,s2
ffffffffc0206dfa:	00090797          	auipc	a5,0x90
ffffffffc0206dfe:	aae7b783          	ld	a5,-1362(a5) # ffffffffc02968a8 <va_pa_offset>
ffffffffc0206e02:	416405b3          	sub	a1,s0,s6
ffffffffc0206e06:	8652                	mv	a2,s4
ffffffffc0206e08:	97ba                	add	a5,a5,a4
ffffffffc0206e0a:	00b78533          	add	a0,a5,a1
ffffffffc0206e0e:	41490933          	sub	s2,s2,s4
ffffffffc0206e12:	4581                	li	a1,0
ffffffffc0206e14:	799040ef          	jal	ffffffffc020bdac <memset>
ffffffffc0206e18:	9452                	add	s0,s0,s4
ffffffffc0206e1a:	0a090d63          	beqz	s2,ffffffffc0206ed4 <do_execve+0x7e0>
ffffffffc0206e1e:	77fd                	lui	a5,0xfffff
ffffffffc0206e20:	00f47b33          	and	s6,s0,a5
ffffffffc0206e24:	85da                	mv	a1,s6
ffffffffc0206e26:	4601                	li	a2,0
ffffffffc0206e28:	856a                	mv	a0,s10
ffffffffc0206e2a:	f64fb0ef          	jal	ffffffffc020258e <get_page>
ffffffffc0206e2e:	fd41                	bnez	a0,ffffffffc0206dc6 <do_execve+0x6d2>
ffffffffc0206e30:	8626                	mv	a2,s1
ffffffffc0206e32:	85da                	mv	a1,s6
ffffffffc0206e34:	856a                	mv	a0,s10
ffffffffc0206e36:	de3fc0ef          	jal	ffffffffc0203c18 <pgdir_alloc_page>
ffffffffc0206e3a:	f551                	bnez	a0,ffffffffc0206dc6 <do_execve+0x6d2>
ffffffffc0206e3c:	7902                	ld	s2,32(sp)
ffffffffc0206e3e:	7a22                	ld	s4,40(sp)
ffffffffc0206e40:	020c1d13          	slli	s10,s8,0x20
ffffffffc0206e44:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206e48:	09010b13          	addi	s6,sp,144
ffffffffc0206e4c:	08810c13          	addi	s8,sp,136
ffffffffc0206e50:	5af1                	li	s5,-4
ffffffffc0206e52:	b709                	j	ffffffffc0206d54 <do_execve+0x660>
ffffffffc0206e54:	000b0863          	beqz	s6,ffffffffc0206e64 <do_execve+0x770>
ffffffffc0206e58:	038b0513          	addi	a0,s6,56
ffffffffc0206e5c:	81bfd0ef          	jal	ffffffffc0204676 <up>
ffffffffc0206e60:	040b2823          	sw	zero,80(s6)
ffffffffc0206e64:	3f013903          	ld	s2,1008(sp)
ffffffffc0206e68:	3e813983          	ld	s3,1000(sp)
ffffffffc0206e6c:	3d013b03          	ld	s6,976(sp)
ffffffffc0206e70:	3c013c03          	ld	s8,960(sp)
ffffffffc0206e74:	3b813c83          	ld	s9,952(sp)
ffffffffc0206e78:	5bf5                	li	s7,-3
ffffffffc0206e7a:	bc75                	j	ffffffffc0206936 <do_execve+0x242>
ffffffffc0206e7c:	02049d13          	slli	s10,s1,0x20
ffffffffc0206e80:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206e84:	8aaa                	mv	s5,a0
ffffffffc0206e86:	09010b13          	addi	s6,sp,144
ffffffffc0206e8a:	08810c13          	addi	s8,sp,136
ffffffffc0206e8e:	b5d9                	j	ffffffffc0206d54 <do_execve+0x660>
ffffffffc0206e90:	02049d13          	slli	s10,s1,0x20
ffffffffc0206e94:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206e98:	5af5                	li	s5,-3
ffffffffc0206e9a:	09010b13          	addi	s6,sp,144
ffffffffc0206e9e:	08810c13          	addi	s8,sp,136
ffffffffc0206ea2:	bd4d                	j	ffffffffc0206d54 <do_execve+0x660>
ffffffffc0206ea4:	5bf5                	li	s7,-3
ffffffffc0206ea6:	a60b14e3          	bnez	s6,ffffffffc020690e <do_execve+0x21a>
ffffffffc0206eaa:	bc85                	j	ffffffffc020691a <do_execve+0x226>
ffffffffc0206eac:	02049d13          	slli	s10,s1,0x20
ffffffffc0206eb0:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206eb4:	09010b13          	addi	s6,sp,144
ffffffffc0206eb8:	08810c13          	addi	s8,sp,136
ffffffffc0206ebc:	5af1                	li	s5,-4
ffffffffc0206ebe:	bd59                	j	ffffffffc0206d54 <do_execve+0x660>
ffffffffc0206ec0:	02049d13          	slli	s10,s1,0x20
ffffffffc0206ec4:	020d5d13          	srli	s10,s10,0x20
ffffffffc0206ec8:	5af1                	li	s5,-4
ffffffffc0206eca:	09010b13          	addi	s6,sp,144
ffffffffc0206ece:	08810c13          	addi	s8,sp,136
ffffffffc0206ed2:	ba59                	j	ffffffffc0206868 <do_execve+0x174>
ffffffffc0206ed4:	7842                	ld	a6,48(sp)
ffffffffc0206ed6:	7902                	ld	s2,32(sp)
ffffffffc0206ed8:	76e2                	ld	a3,56(sp)
ffffffffc0206eda:	7a22                	ld	s4,40(sp)
ffffffffc0206edc:	09015703          	lhu	a4,144(sp)
ffffffffc0206ee0:	84e2                	mv	s1,s8
ffffffffc0206ee2:	b671                	j	ffffffffc0206a6e <do_execve+0x37a>
ffffffffc0206ee4:	6962                	ld	s2,24(sp)
ffffffffc0206ee6:	8b66                	mv	s6,s9
ffffffffc0206ee8:	5af1                	li	s5,-4
ffffffffc0206eea:	b5ad                	j	ffffffffc0206d54 <do_execve+0x660>
ffffffffc0206eec:	86ba                	mv	a3,a4
ffffffffc0206eee:	00006617          	auipc	a2,0x6
ffffffffc0206ef2:	e2a60613          	addi	a2,a2,-470 # ffffffffc020cd18 <etext+0xf04>
ffffffffc0206ef6:	07100593          	li	a1,113
ffffffffc0206efa:	00006517          	auipc	a0,0x6
ffffffffc0206efe:	e4650513          	addi	a0,a0,-442 # ffffffffc020cd40 <etext+0xf2c>
ffffffffc0206f02:	d48f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206f06:	00006617          	auipc	a2,0x6
ffffffffc0206f0a:	eba60613          	addi	a2,a2,-326 # ffffffffc020cdc0 <etext+0xfac>
ffffffffc0206f0e:	3c500593          	li	a1,965
ffffffffc0206f12:	00007517          	auipc	a0,0x7
ffffffffc0206f16:	db650513          	addi	a0,a0,-586 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0206f1a:	d30f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206f1e <user_main>:
ffffffffc0206f1e:	7179                	addi	sp,sp,-48
ffffffffc0206f20:	e84a                	sd	s2,16(sp)
ffffffffc0206f22:	00090917          	auipc	s2,0x90
ffffffffc0206f26:	9a690913          	addi	s2,s2,-1626 # ffffffffc02968c8 <current>
ffffffffc0206f2a:	00093783          	ld	a5,0(s2)
ffffffffc0206f2e:	00007617          	auipc	a2,0x7
ffffffffc0206f32:	f8a60613          	addi	a2,a2,-118 # ffffffffc020deb8 <etext+0x20a4>
ffffffffc0206f36:	00007517          	auipc	a0,0x7
ffffffffc0206f3a:	f8a50513          	addi	a0,a0,-118 # ffffffffc020dec0 <etext+0x20ac>
ffffffffc0206f3e:	43cc                	lw	a1,4(a5)
ffffffffc0206f40:	f406                	sd	ra,40(sp)
ffffffffc0206f42:	f022                	sd	s0,32(sp)
ffffffffc0206f44:	ec26                	sd	s1,24(sp)
ffffffffc0206f46:	e402                	sd	zero,8(sp)
ffffffffc0206f48:	e032                	sd	a2,0(sp)
ffffffffc0206f4a:	a5cf90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206f4e:	6782                	ld	a5,0(sp)
ffffffffc0206f50:	cfb9                	beqz	a5,ffffffffc0206fae <user_main+0x90>
ffffffffc0206f52:	003c                	addi	a5,sp,8
ffffffffc0206f54:	4401                	li	s0,0
ffffffffc0206f56:	6398                	ld	a4,0(a5)
ffffffffc0206f58:	07a1                	addi	a5,a5,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0206f5a:	0405                	addi	s0,s0,1
ffffffffc0206f5c:	ff6d                	bnez	a4,ffffffffc0206f56 <user_main+0x38>
ffffffffc0206f5e:	00093703          	ld	a4,0(s2)
ffffffffc0206f62:	6789                	lui	a5,0x2
ffffffffc0206f64:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206f68:	6b04                	ld	s1,16(a4)
ffffffffc0206f6a:	734c                	ld	a1,160(a4)
ffffffffc0206f6c:	12000613          	li	a2,288
ffffffffc0206f70:	94be                	add	s1,s1,a5
ffffffffc0206f72:	8526                	mv	a0,s1
ffffffffc0206f74:	689040ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0206f78:	00093783          	ld	a5,0(s2)
ffffffffc0206f7c:	0004059b          	sext.w	a1,s0
ffffffffc0206f80:	860a                	mv	a2,sp
ffffffffc0206f82:	f3c4                	sd	s1,160(a5)
ffffffffc0206f84:	00007517          	auipc	a0,0x7
ffffffffc0206f88:	f3450513          	addi	a0,a0,-204 # ffffffffc020deb8 <etext+0x20a4>
ffffffffc0206f8c:	f68ff0ef          	jal	ffffffffc02066f4 <do_execve>
ffffffffc0206f90:	8126                	mv	sp,s1
ffffffffc0206f92:	a9efa06f          	j	ffffffffc0201230 <__trapret>
ffffffffc0206f96:	00007617          	auipc	a2,0x7
ffffffffc0206f9a:	f5260613          	addi	a2,a2,-174 # ffffffffc020dee8 <etext+0x20d4>
ffffffffc0206f9e:	4f300593          	li	a1,1267
ffffffffc0206fa2:	00007517          	auipc	a0,0x7
ffffffffc0206fa6:	d2650513          	addi	a0,a0,-730 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0206faa:	ca0f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206fae:	4401                	li	s0,0
ffffffffc0206fb0:	b77d                	j	ffffffffc0206f5e <user_main+0x40>

ffffffffc0206fb2 <do_yield>:
ffffffffc0206fb2:	00090797          	auipc	a5,0x90
ffffffffc0206fb6:	9167b783          	ld	a5,-1770(a5) # ffffffffc02968c8 <current>
ffffffffc0206fba:	4705                	li	a4,1
ffffffffc0206fbc:	4501                	li	a0,0
ffffffffc0206fbe:	ef98                	sd	a4,24(a5)
ffffffffc0206fc0:	8082                	ret

ffffffffc0206fc2 <do_wait>:
ffffffffc0206fc2:	c59d                	beqz	a1,ffffffffc0206ff0 <do_wait+0x2e>
ffffffffc0206fc4:	1101                	addi	sp,sp,-32
ffffffffc0206fc6:	e02a                	sd	a0,0(sp)
ffffffffc0206fc8:	00090517          	auipc	a0,0x90
ffffffffc0206fcc:	90053503          	ld	a0,-1792(a0) # ffffffffc02968c8 <current>
ffffffffc0206fd0:	4685                	li	a3,1
ffffffffc0206fd2:	4611                	li	a2,4
ffffffffc0206fd4:	7508                	ld	a0,40(a0)
ffffffffc0206fd6:	ec06                	sd	ra,24(sp)
ffffffffc0206fd8:	e42e                	sd	a1,8(sp)
ffffffffc0206fda:	bc0fd0ef          	jal	ffffffffc020439a <user_mem_check>
ffffffffc0206fde:	6702                	ld	a4,0(sp)
ffffffffc0206fe0:	67a2                	ld	a5,8(sp)
ffffffffc0206fe2:	c909                	beqz	a0,ffffffffc0206ff4 <do_wait+0x32>
ffffffffc0206fe4:	60e2                	ld	ra,24(sp)
ffffffffc0206fe6:	85be                	mv	a1,a5
ffffffffc0206fe8:	853a                	mv	a0,a4
ffffffffc0206fea:	6105                	addi	sp,sp,32
ffffffffc0206fec:	bd6ff06f          	j	ffffffffc02063c2 <do_wait.part.0>
ffffffffc0206ff0:	bd2ff06f          	j	ffffffffc02063c2 <do_wait.part.0>
ffffffffc0206ff4:	60e2                	ld	ra,24(sp)
ffffffffc0206ff6:	5575                	li	a0,-3
ffffffffc0206ff8:	6105                	addi	sp,sp,32
ffffffffc0206ffa:	8082                	ret

ffffffffc0206ffc <do_kill>:
ffffffffc0206ffc:	6789                	lui	a5,0x2
ffffffffc0206ffe:	fff5071b          	addiw	a4,a0,-1
ffffffffc0207002:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0207004:	06e7e463          	bltu	a5,a4,ffffffffc020706c <do_kill+0x70>
ffffffffc0207008:	1101                	addi	sp,sp,-32
ffffffffc020700a:	45a9                	li	a1,10
ffffffffc020700c:	ec06                	sd	ra,24(sp)
ffffffffc020700e:	e42a                	sd	a0,8(sp)
ffffffffc0207010:	061040ef          	jal	ffffffffc020b870 <hash32>
ffffffffc0207014:	02051793          	slli	a5,a0,0x20
ffffffffc0207018:	01c7d693          	srli	a3,a5,0x1c
ffffffffc020701c:	0008a797          	auipc	a5,0x8a
ffffffffc0207020:	7a478793          	addi	a5,a5,1956 # ffffffffc02917c0 <hash_list>
ffffffffc0207024:	96be                	add	a3,a3,a5
ffffffffc0207026:	6622                	ld	a2,8(sp)
ffffffffc0207028:	8536                	mv	a0,a3
ffffffffc020702a:	a029                	j	ffffffffc0207034 <do_kill+0x38>
ffffffffc020702c:	f2c52703          	lw	a4,-212(a0)
ffffffffc0207030:	00c70963          	beq	a4,a2,ffffffffc0207042 <do_kill+0x46>
ffffffffc0207034:	6508                	ld	a0,8(a0)
ffffffffc0207036:	fea69be3          	bne	a3,a0,ffffffffc020702c <do_kill+0x30>
ffffffffc020703a:	60e2                	ld	ra,24(sp)
ffffffffc020703c:	5575                	li	a0,-3
ffffffffc020703e:	6105                	addi	sp,sp,32
ffffffffc0207040:	8082                	ret
ffffffffc0207042:	fd852703          	lw	a4,-40(a0)
ffffffffc0207046:	00177693          	andi	a3,a4,1
ffffffffc020704a:	e29d                	bnez	a3,ffffffffc0207070 <do_kill+0x74>
ffffffffc020704c:	4954                	lw	a3,20(a0)
ffffffffc020704e:	00176713          	ori	a4,a4,1
ffffffffc0207052:	fce52c23          	sw	a4,-40(a0)
ffffffffc0207056:	0006c663          	bltz	a3,ffffffffc0207062 <do_kill+0x66>
ffffffffc020705a:	4501                	li	a0,0
ffffffffc020705c:	60e2                	ld	ra,24(sp)
ffffffffc020705e:	6105                	addi	sp,sp,32
ffffffffc0207060:	8082                	ret
ffffffffc0207062:	f2850513          	addi	a0,a0,-216
ffffffffc0207066:	189000ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc020706a:	bfc5                	j	ffffffffc020705a <do_kill+0x5e>
ffffffffc020706c:	5575                	li	a0,-3
ffffffffc020706e:	8082                	ret
ffffffffc0207070:	555d                	li	a0,-9
ffffffffc0207072:	b7ed                	j	ffffffffc020705c <do_kill+0x60>

ffffffffc0207074 <proc_init>:
ffffffffc0207074:	1101                	addi	sp,sp,-32
ffffffffc0207076:	e426                	sd	s1,8(sp)
ffffffffc0207078:	0008e797          	auipc	a5,0x8e
ffffffffc020707c:	74878793          	addi	a5,a5,1864 # ffffffffc02957c0 <proc_list>
ffffffffc0207080:	ec06                	sd	ra,24(sp)
ffffffffc0207082:	e822                	sd	s0,16(sp)
ffffffffc0207084:	e04a                	sd	s2,0(sp)
ffffffffc0207086:	0008a497          	auipc	s1,0x8a
ffffffffc020708a:	73a48493          	addi	s1,s1,1850 # ffffffffc02917c0 <hash_list>
ffffffffc020708e:	e79c                	sd	a5,8(a5)
ffffffffc0207090:	e39c                	sd	a5,0(a5)
ffffffffc0207092:	0008e717          	auipc	a4,0x8e
ffffffffc0207096:	72e70713          	addi	a4,a4,1838 # ffffffffc02957c0 <proc_list>
ffffffffc020709a:	87a6                	mv	a5,s1
ffffffffc020709c:	e79c                	sd	a5,8(a5)
ffffffffc020709e:	e39c                	sd	a5,0(a5)
ffffffffc02070a0:	07c1                	addi	a5,a5,16
ffffffffc02070a2:	fee79de3          	bne	a5,a4,ffffffffc020709c <proc_init+0x28>
ffffffffc02070a6:	aa1fe0ef          	jal	ffffffffc0205b46 <alloc_proc>
ffffffffc02070aa:	00090917          	auipc	s2,0x90
ffffffffc02070ae:	82e90913          	addi	s2,s2,-2002 # ffffffffc02968d8 <idleproc>
ffffffffc02070b2:	00a93023          	sd	a0,0(s2)
ffffffffc02070b6:	842a                	mv	s0,a0
ffffffffc02070b8:	12050c63          	beqz	a0,ffffffffc02071f0 <proc_init+0x17c>
ffffffffc02070bc:	4689                	li	a3,2
ffffffffc02070be:	0000a717          	auipc	a4,0xa
ffffffffc02070c2:	f4270713          	addi	a4,a4,-190 # ffffffffc0211000 <bootstack>
ffffffffc02070c6:	4785                	li	a5,1
ffffffffc02070c8:	e114                	sd	a3,0(a0)
ffffffffc02070ca:	e918                	sd	a4,16(a0)
ffffffffc02070cc:	ed1c                	sd	a5,24(a0)
ffffffffc02070ce:	a2efe0ef          	jal	ffffffffc02052fc <files_create>
ffffffffc02070d2:	14a43423          	sd	a0,328(s0)
ffffffffc02070d6:	10050163          	beqz	a0,ffffffffc02071d8 <proc_init+0x164>
ffffffffc02070da:	00093403          	ld	s0,0(s2)
ffffffffc02070de:	4641                	li	a2,16
ffffffffc02070e0:	4581                	li	a1,0
ffffffffc02070e2:	14843703          	ld	a4,328(s0)
ffffffffc02070e6:	0b440413          	addi	s0,s0,180
ffffffffc02070ea:	8522                	mv	a0,s0
ffffffffc02070ec:	4b1c                	lw	a5,16(a4)
ffffffffc02070ee:	2785                	addiw	a5,a5,1
ffffffffc02070f0:	cb1c                	sw	a5,16(a4)
ffffffffc02070f2:	4bb040ef          	jal	ffffffffc020bdac <memset>
ffffffffc02070f6:	8522                	mv	a0,s0
ffffffffc02070f8:	463d                	li	a2,15
ffffffffc02070fa:	00007597          	auipc	a1,0x7
ffffffffc02070fe:	e4e58593          	addi	a1,a1,-434 # ffffffffc020df48 <etext+0x2134>
ffffffffc0207102:	4fb040ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0207106:	0008f797          	auipc	a5,0x8f
ffffffffc020710a:	7ba7a783          	lw	a5,1978(a5) # ffffffffc02968c0 <nr_process>
ffffffffc020710e:	00093703          	ld	a4,0(s2)
ffffffffc0207112:	4601                	li	a2,0
ffffffffc0207114:	2785                	addiw	a5,a5,1
ffffffffc0207116:	4581                	li	a1,0
ffffffffc0207118:	fffff517          	auipc	a0,0xfffff
ffffffffc020711c:	48c50513          	addi	a0,a0,1164 # ffffffffc02065a4 <init_main>
ffffffffc0207120:	0008f697          	auipc	a3,0x8f
ffffffffc0207124:	7ae6b423          	sd	a4,1960(a3) # ffffffffc02968c8 <current>
ffffffffc0207128:	0008f717          	auipc	a4,0x8f
ffffffffc020712c:	78f72c23          	sw	a5,1944(a4) # ffffffffc02968c0 <nr_process>
ffffffffc0207130:	8e2ff0ef          	jal	ffffffffc0206212 <kernel_thread>
ffffffffc0207134:	842a                	mv	s0,a0
ffffffffc0207136:	08a05563          	blez	a0,ffffffffc02071c0 <proc_init+0x14c>
ffffffffc020713a:	6789                	lui	a5,0x2
ffffffffc020713c:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc020713e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0207142:	02e7e463          	bltu	a5,a4,ffffffffc020716a <proc_init+0xf6>
ffffffffc0207146:	45a9                	li	a1,10
ffffffffc0207148:	728040ef          	jal	ffffffffc020b870 <hash32>
ffffffffc020714c:	02051713          	slli	a4,a0,0x20
ffffffffc0207150:	01c75793          	srli	a5,a4,0x1c
ffffffffc0207154:	00f486b3          	add	a3,s1,a5
ffffffffc0207158:	87b6                	mv	a5,a3
ffffffffc020715a:	a029                	j	ffffffffc0207164 <proc_init+0xf0>
ffffffffc020715c:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0207160:	04870d63          	beq	a4,s0,ffffffffc02071ba <proc_init+0x146>
ffffffffc0207164:	679c                	ld	a5,8(a5)
ffffffffc0207166:	fef69be3          	bne	a3,a5,ffffffffc020715c <proc_init+0xe8>
ffffffffc020716a:	4781                	li	a5,0
ffffffffc020716c:	0b478413          	addi	s0,a5,180
ffffffffc0207170:	4641                	li	a2,16
ffffffffc0207172:	4581                	li	a1,0
ffffffffc0207174:	8522                	mv	a0,s0
ffffffffc0207176:	0008f717          	auipc	a4,0x8f
ffffffffc020717a:	74f73d23          	sd	a5,1882(a4) # ffffffffc02968d0 <initproc>
ffffffffc020717e:	42f040ef          	jal	ffffffffc020bdac <memset>
ffffffffc0207182:	8522                	mv	a0,s0
ffffffffc0207184:	463d                	li	a2,15
ffffffffc0207186:	00007597          	auipc	a1,0x7
ffffffffc020718a:	dea58593          	addi	a1,a1,-534 # ffffffffc020df70 <etext+0x215c>
ffffffffc020718e:	46f040ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc0207192:	00093783          	ld	a5,0(s2)
ffffffffc0207196:	cbc9                	beqz	a5,ffffffffc0207228 <proc_init+0x1b4>
ffffffffc0207198:	43dc                	lw	a5,4(a5)
ffffffffc020719a:	e7d9                	bnez	a5,ffffffffc0207228 <proc_init+0x1b4>
ffffffffc020719c:	0008f797          	auipc	a5,0x8f
ffffffffc02071a0:	7347b783          	ld	a5,1844(a5) # ffffffffc02968d0 <initproc>
ffffffffc02071a4:	c3b5                	beqz	a5,ffffffffc0207208 <proc_init+0x194>
ffffffffc02071a6:	43d8                	lw	a4,4(a5)
ffffffffc02071a8:	4785                	li	a5,1
ffffffffc02071aa:	04f71f63          	bne	a4,a5,ffffffffc0207208 <proc_init+0x194>
ffffffffc02071ae:	60e2                	ld	ra,24(sp)
ffffffffc02071b0:	6442                	ld	s0,16(sp)
ffffffffc02071b2:	64a2                	ld	s1,8(sp)
ffffffffc02071b4:	6902                	ld	s2,0(sp)
ffffffffc02071b6:	6105                	addi	sp,sp,32
ffffffffc02071b8:	8082                	ret
ffffffffc02071ba:	f2878793          	addi	a5,a5,-216
ffffffffc02071be:	b77d                	j	ffffffffc020716c <proc_init+0xf8>
ffffffffc02071c0:	00007617          	auipc	a2,0x7
ffffffffc02071c4:	d9060613          	addi	a2,a2,-624 # ffffffffc020df50 <etext+0x213c>
ffffffffc02071c8:	53f00593          	li	a1,1343
ffffffffc02071cc:	00007517          	auipc	a0,0x7
ffffffffc02071d0:	afc50513          	addi	a0,a0,-1284 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02071d4:	a76f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02071d8:	00007617          	auipc	a2,0x7
ffffffffc02071dc:	d4860613          	addi	a2,a2,-696 # ffffffffc020df20 <etext+0x210c>
ffffffffc02071e0:	53300593          	li	a1,1331
ffffffffc02071e4:	00007517          	auipc	a0,0x7
ffffffffc02071e8:	ae450513          	addi	a0,a0,-1308 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc02071ec:	a5ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02071f0:	00007617          	auipc	a2,0x7
ffffffffc02071f4:	d1860613          	addi	a2,a2,-744 # ffffffffc020df08 <etext+0x20f4>
ffffffffc02071f8:	52900593          	li	a1,1321
ffffffffc02071fc:	00007517          	auipc	a0,0x7
ffffffffc0207200:	acc50513          	addi	a0,a0,-1332 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0207204:	a46f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207208:	00007697          	auipc	a3,0x7
ffffffffc020720c:	d9868693          	addi	a3,a3,-616 # ffffffffc020dfa0 <etext+0x218c>
ffffffffc0207210:	00005617          	auipc	a2,0x5
ffffffffc0207214:	04060613          	addi	a2,a2,64 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207218:	54600593          	li	a1,1350
ffffffffc020721c:	00007517          	auipc	a0,0x7
ffffffffc0207220:	aac50513          	addi	a0,a0,-1364 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0207224:	a26f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207228:	00007697          	auipc	a3,0x7
ffffffffc020722c:	d5068693          	addi	a3,a3,-688 # ffffffffc020df78 <etext+0x2164>
ffffffffc0207230:	00005617          	auipc	a2,0x5
ffffffffc0207234:	02060613          	addi	a2,a2,32 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207238:	54500593          	li	a1,1349
ffffffffc020723c:	00007517          	auipc	a0,0x7
ffffffffc0207240:	a8c50513          	addi	a0,a0,-1396 # ffffffffc020dcc8 <etext+0x1eb4>
ffffffffc0207244:	a06f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207248 <cpu_idle>:
ffffffffc0207248:	1141                	addi	sp,sp,-16
ffffffffc020724a:	e022                	sd	s0,0(sp)
ffffffffc020724c:	e406                	sd	ra,8(sp)
ffffffffc020724e:	0008f417          	auipc	s0,0x8f
ffffffffc0207252:	67a40413          	addi	s0,s0,1658 # ffffffffc02968c8 <current>
ffffffffc0207256:	6018                	ld	a4,0(s0)
ffffffffc0207258:	6f1c                	ld	a5,24(a4)
ffffffffc020725a:	dffd                	beqz	a5,ffffffffc0207258 <cpu_idle+0x10>
ffffffffc020725c:	08b000ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc0207260:	bfdd                	j	ffffffffc0207256 <cpu_idle+0xe>

ffffffffc0207262 <lab6_set_priority>:
ffffffffc0207262:	1101                	addi	sp,sp,-32
ffffffffc0207264:	85aa                	mv	a1,a0
ffffffffc0207266:	e42a                	sd	a0,8(sp)
ffffffffc0207268:	00007517          	auipc	a0,0x7
ffffffffc020726c:	d6050513          	addi	a0,a0,-672 # ffffffffc020dfc8 <etext+0x21b4>
ffffffffc0207270:	ec06                	sd	ra,24(sp)
ffffffffc0207272:	f35f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207276:	65a2                	ld	a1,8(sp)
ffffffffc0207278:	0008f717          	auipc	a4,0x8f
ffffffffc020727c:	65073703          	ld	a4,1616(a4) # ffffffffc02968c8 <current>
ffffffffc0207280:	4785                	li	a5,1
ffffffffc0207282:	c191                	beqz	a1,ffffffffc0207286 <lab6_set_priority+0x24>
ffffffffc0207284:	87ae                	mv	a5,a1
ffffffffc0207286:	60e2                	ld	ra,24(sp)
ffffffffc0207288:	14f72223          	sw	a5,324(a4)
ffffffffc020728c:	6105                	addi	sp,sp,32
ffffffffc020728e:	8082                	ret

ffffffffc0207290 <do_sleep>:
ffffffffc0207290:	c531                	beqz	a0,ffffffffc02072dc <do_sleep+0x4c>
ffffffffc0207292:	7139                	addi	sp,sp,-64
ffffffffc0207294:	fc06                	sd	ra,56(sp)
ffffffffc0207296:	f822                	sd	s0,48(sp)
ffffffffc0207298:	100027f3          	csrr	a5,sstatus
ffffffffc020729c:	8b89                	andi	a5,a5,2
ffffffffc020729e:	e3a9                	bnez	a5,ffffffffc02072e0 <do_sleep+0x50>
ffffffffc02072a0:	0008f797          	auipc	a5,0x8f
ffffffffc02072a4:	6287b783          	ld	a5,1576(a5) # ffffffffc02968c8 <current>
ffffffffc02072a8:	1014                	addi	a3,sp,32
ffffffffc02072aa:	80000737          	lui	a4,0x80000
ffffffffc02072ae:	c82a                	sw	a0,16(sp)
ffffffffc02072b0:	f436                	sd	a3,40(sp)
ffffffffc02072b2:	f036                	sd	a3,32(sp)
ffffffffc02072b4:	ec3e                	sd	a5,24(sp)
ffffffffc02072b6:	4685                	li	a3,1
ffffffffc02072b8:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc02072ba:	0808                	addi	a0,sp,16
ffffffffc02072bc:	c394                	sw	a3,0(a5)
ffffffffc02072be:	0ee7a623          	sw	a4,236(a5)
ffffffffc02072c2:	842a                	mv	s0,a0
ffffffffc02072c4:	0d9000ef          	jal	ffffffffc0207b9c <add_timer>
ffffffffc02072c8:	01f000ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc02072cc:	8522                	mv	a0,s0
ffffffffc02072ce:	195000ef          	jal	ffffffffc0207c62 <del_timer>
ffffffffc02072d2:	70e2                	ld	ra,56(sp)
ffffffffc02072d4:	7442                	ld	s0,48(sp)
ffffffffc02072d6:	4501                	li	a0,0
ffffffffc02072d8:	6121                	addi	sp,sp,64
ffffffffc02072da:	8082                	ret
ffffffffc02072dc:	4501                	li	a0,0
ffffffffc02072de:	8082                	ret
ffffffffc02072e0:	e42a                	sd	a0,8(sp)
ffffffffc02072e2:	8f7f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02072e6:	0008f797          	auipc	a5,0x8f
ffffffffc02072ea:	5e27b783          	ld	a5,1506(a5) # ffffffffc02968c8 <current>
ffffffffc02072ee:	6522                	ld	a0,8(sp)
ffffffffc02072f0:	1014                	addi	a3,sp,32
ffffffffc02072f2:	80000737          	lui	a4,0x80000
ffffffffc02072f6:	c82a                	sw	a0,16(sp)
ffffffffc02072f8:	f436                	sd	a3,40(sp)
ffffffffc02072fa:	f036                	sd	a3,32(sp)
ffffffffc02072fc:	ec3e                	sd	a5,24(sp)
ffffffffc02072fe:	4685                	li	a3,1
ffffffffc0207300:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0207302:	0808                	addi	a0,sp,16
ffffffffc0207304:	c394                	sw	a3,0(a5)
ffffffffc0207306:	0ee7a623          	sw	a4,236(a5)
ffffffffc020730a:	842a                	mv	s0,a0
ffffffffc020730c:	091000ef          	jal	ffffffffc0207b9c <add_timer>
ffffffffc0207310:	8c3f90ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0207314:	bf55                	j	ffffffffc02072c8 <do_sleep+0x38>

ffffffffc0207316 <switch_to>:
ffffffffc0207316:	00153023          	sd	ra,0(a0)
ffffffffc020731a:	00253423          	sd	sp,8(a0)
ffffffffc020731e:	e900                	sd	s0,16(a0)
ffffffffc0207320:	ed04                	sd	s1,24(a0)
ffffffffc0207322:	03253023          	sd	s2,32(a0)
ffffffffc0207326:	03353423          	sd	s3,40(a0)
ffffffffc020732a:	03453823          	sd	s4,48(a0)
ffffffffc020732e:	03553c23          	sd	s5,56(a0)
ffffffffc0207332:	05653023          	sd	s6,64(a0)
ffffffffc0207336:	05753423          	sd	s7,72(a0)
ffffffffc020733a:	05853823          	sd	s8,80(a0)
ffffffffc020733e:	05953c23          	sd	s9,88(a0)
ffffffffc0207342:	07a53023          	sd	s10,96(a0)
ffffffffc0207346:	07b53423          	sd	s11,104(a0)
ffffffffc020734a:	0005b083          	ld	ra,0(a1)
ffffffffc020734e:	0085b103          	ld	sp,8(a1)
ffffffffc0207352:	6980                	ld	s0,16(a1)
ffffffffc0207354:	6d84                	ld	s1,24(a1)
ffffffffc0207356:	0205b903          	ld	s2,32(a1)
ffffffffc020735a:	0285b983          	ld	s3,40(a1)
ffffffffc020735e:	0305ba03          	ld	s4,48(a1)
ffffffffc0207362:	0385ba83          	ld	s5,56(a1)
ffffffffc0207366:	0405bb03          	ld	s6,64(a1)
ffffffffc020736a:	0485bb83          	ld	s7,72(a1)
ffffffffc020736e:	0505bc03          	ld	s8,80(a1)
ffffffffc0207372:	0585bc83          	ld	s9,88(a1)
ffffffffc0207376:	0605bd03          	ld	s10,96(a1)
ffffffffc020737a:	0685bd83          	ld	s11,104(a1)
ffffffffc020737e:	8082                	ret

ffffffffc0207380 <stride_init>:
ffffffffc0207380:	e508                	sd	a0,8(a0)
ffffffffc0207382:	e108                	sd	a0,0(a0)
ffffffffc0207384:	00053c23          	sd	zero,24(a0)
ffffffffc0207388:	00052823          	sw	zero,16(a0)
ffffffffc020738c:	8082                	ret

ffffffffc020738e <stride_pick_next>:
ffffffffc020738e:	6d1c                	ld	a5,24(a0)
ffffffffc0207390:	cf81                	beqz	a5,ffffffffc02073a8 <stride_pick_next+0x1a>
ffffffffc0207392:	4fd0                	lw	a2,28(a5)
ffffffffc0207394:	400006b7          	lui	a3,0x40000
ffffffffc0207398:	4f98                	lw	a4,24(a5)
ffffffffc020739a:	02c6d6bb          	divuw	a3,a3,a2
ffffffffc020739e:	ed878513          	addi	a0,a5,-296
ffffffffc02073a2:	9f35                	addw	a4,a4,a3
ffffffffc02073a4:	cf98                	sw	a4,24(a5)
ffffffffc02073a6:	8082                	ret
ffffffffc02073a8:	4501                	li	a0,0
ffffffffc02073aa:	8082                	ret

ffffffffc02073ac <stride_proc_tick>:
ffffffffc02073ac:	1205a783          	lw	a5,288(a1)
ffffffffc02073b0:	00f05563          	blez	a5,ffffffffc02073ba <stride_proc_tick+0xe>
ffffffffc02073b4:	37fd                	addiw	a5,a5,-1
ffffffffc02073b6:	12f5a023          	sw	a5,288(a1)
ffffffffc02073ba:	e399                	bnez	a5,ffffffffc02073c0 <stride_proc_tick+0x14>
ffffffffc02073bc:	4785                	li	a5,1
ffffffffc02073be:	ed9c                	sd	a5,24(a1)
ffffffffc02073c0:	8082                	ret

ffffffffc02073c2 <skew_heap_merge.constprop.0>:
ffffffffc02073c2:	87ae                	mv	a5,a1
ffffffffc02073c4:	1c050963          	beqz	a0,ffffffffc0207596 <skew_heap_merge.constprop.0+0x1d4>
ffffffffc02073c8:	862a                	mv	a2,a0
ffffffffc02073ca:	1c058863          	beqz	a1,ffffffffc020759a <skew_heap_merge.constprop.0+0x1d8>
ffffffffc02073ce:	4d14                	lw	a3,24(a0)
ffffffffc02073d0:	4d98                	lw	a4,24(a1)
ffffffffc02073d2:	7139                	addi	sp,sp,-64
ffffffffc02073d4:	fc06                	sd	ra,56(sp)
ffffffffc02073d6:	40e6883b          	subw	a6,a3,a4
ffffffffc02073da:	06084d63          	bltz	a6,ffffffffc0207454 <skew_heap_merge.constprop.0+0x92>
ffffffffc02073de:	6998                	ld	a4,16(a1)
ffffffffc02073e0:	0085b883          	ld	a7,8(a1)
ffffffffc02073e4:	10070d63          	beqz	a4,ffffffffc02074fe <skew_heap_merge.constprop.0+0x13c>
ffffffffc02073e8:	4f0c                	lw	a1,24(a4)
ffffffffc02073ea:	40b6883b          	subw	a6,a3,a1
ffffffffc02073ee:	0c084663          	bltz	a6,ffffffffc02074ba <skew_heap_merge.constprop.0+0xf8>
ffffffffc02073f2:	01073803          	ld	a6,16(a4)
ffffffffc02073f6:	00873303          	ld	t1,8(a4)
ffffffffc02073fa:	04080163          	beqz	a6,ffffffffc020743c <skew_heap_merge.constprop.0+0x7a>
ffffffffc02073fe:	01882583          	lw	a1,24(a6)
ffffffffc0207402:	f43e                	sd	a5,40(sp)
ffffffffc0207404:	f01a                	sd	t1,32(sp)
ffffffffc0207406:	9e8d                	subw	a3,a3,a1
ffffffffc0207408:	ec3a                	sd	a4,24(sp)
ffffffffc020740a:	e846                	sd	a7,16(sp)
ffffffffc020740c:	1606c263          	bltz	a3,ffffffffc0207570 <skew_heap_merge.constprop.0+0x1ae>
ffffffffc0207410:	00883683          	ld	a3,8(a6)
ffffffffc0207414:	01083583          	ld	a1,16(a6)
ffffffffc0207418:	e442                	sd	a6,8(sp)
ffffffffc020741a:	e036                	sd	a3,0(sp)
ffffffffc020741c:	fa7ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207420:	6822                	ld	a6,8(sp)
ffffffffc0207422:	6682                	ld	a3,0(sp)
ffffffffc0207424:	68c2                	ld	a7,16(sp)
ffffffffc0207426:	00a83423          	sd	a0,8(a6)
ffffffffc020742a:	00d83823          	sd	a3,16(a6)
ffffffffc020742e:	6762                	ld	a4,24(sp)
ffffffffc0207430:	7302                	ld	t1,32(sp)
ffffffffc0207432:	77a2                	ld	a5,40(sp)
ffffffffc0207434:	c119                	beqz	a0,ffffffffc020743a <skew_heap_merge.constprop.0+0x78>
ffffffffc0207436:	01053023          	sd	a6,0(a0)
ffffffffc020743a:	8642                	mv	a2,a6
ffffffffc020743c:	e710                	sd	a2,8(a4)
ffffffffc020743e:	00673823          	sd	t1,16(a4)
ffffffffc0207442:	e218                	sd	a4,0(a2)
ffffffffc0207444:	70e2                	ld	ra,56(sp)
ffffffffc0207446:	e798                	sd	a4,8(a5)
ffffffffc0207448:	0117b823          	sd	a7,16(a5)
ffffffffc020744c:	e31c                	sd	a5,0(a4)
ffffffffc020744e:	853e                	mv	a0,a5
ffffffffc0207450:	6121                	addi	sp,sp,64
ffffffffc0207452:	8082                	ret
ffffffffc0207454:	6914                	ld	a3,16(a0)
ffffffffc0207456:	00853803          	ld	a6,8(a0)
ffffffffc020745a:	caa1                	beqz	a3,ffffffffc02074aa <skew_heap_merge.constprop.0+0xe8>
ffffffffc020745c:	4e88                	lw	a0,24(a3)
ffffffffc020745e:	40e5073b          	subw	a4,a0,a4
ffffffffc0207462:	0a074063          	bltz	a4,ffffffffc0207502 <skew_heap_merge.constprop.0+0x140>
ffffffffc0207466:	6998                	ld	a4,16(a1)
ffffffffc0207468:	0085b883          	ld	a7,8(a1)
ffffffffc020746c:	cb1d                	beqz	a4,ffffffffc02074a2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc020746e:	4f0c                	lw	a1,24(a4)
ffffffffc0207470:	f43e                	sd	a5,40(sp)
ffffffffc0207472:	f032                	sd	a2,32(sp)
ffffffffc0207474:	9d0d                	subw	a0,a0,a1
ffffffffc0207476:	ec46                	sd	a7,24(sp)
ffffffffc0207478:	e842                	sd	a6,16(sp)
ffffffffc020747a:	0c054963          	bltz	a0,ffffffffc020754c <skew_heap_merge.constprop.0+0x18a>
ffffffffc020747e:	6b0c                	ld	a1,16(a4)
ffffffffc0207480:	8536                	mv	a0,a3
ffffffffc0207482:	6714                	ld	a3,8(a4)
ffffffffc0207484:	e43a                	sd	a4,8(sp)
ffffffffc0207486:	e036                	sd	a3,0(sp)
ffffffffc0207488:	f3bff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc020748c:	6722                	ld	a4,8(sp)
ffffffffc020748e:	6682                	ld	a3,0(sp)
ffffffffc0207490:	6842                	ld	a6,16(sp)
ffffffffc0207492:	e708                	sd	a0,8(a4)
ffffffffc0207494:	eb14                	sd	a3,16(a4)
ffffffffc0207496:	68e2                	ld	a7,24(sp)
ffffffffc0207498:	7602                	ld	a2,32(sp)
ffffffffc020749a:	77a2                	ld	a5,40(sp)
ffffffffc020749c:	c111                	beqz	a0,ffffffffc02074a0 <skew_heap_merge.constprop.0+0xde>
ffffffffc020749e:	e118                	sd	a4,0(a0)
ffffffffc02074a0:	86ba                	mv	a3,a4
ffffffffc02074a2:	e794                	sd	a3,8(a5)
ffffffffc02074a4:	0117b823          	sd	a7,16(a5)
ffffffffc02074a8:	e29c                	sd	a5,0(a3)
ffffffffc02074aa:	70e2                	ld	ra,56(sp)
ffffffffc02074ac:	e61c                	sd	a5,8(a2)
ffffffffc02074ae:	01063823          	sd	a6,16(a2)
ffffffffc02074b2:	e390                	sd	a2,0(a5)
ffffffffc02074b4:	8532                	mv	a0,a2
ffffffffc02074b6:	6121                	addi	sp,sp,64
ffffffffc02074b8:	8082                	ret
ffffffffc02074ba:	6914                	ld	a3,16(a0)
ffffffffc02074bc:	00853803          	ld	a6,8(a0)
ffffffffc02074c0:	ca9d                	beqz	a3,ffffffffc02074f6 <skew_heap_merge.constprop.0+0x134>
ffffffffc02074c2:	4e88                	lw	a0,24(a3)
ffffffffc02074c4:	f43e                	sd	a5,40(sp)
ffffffffc02074c6:	f032                	sd	a2,32(sp)
ffffffffc02074c8:	40b505bb          	subw	a1,a0,a1
ffffffffc02074cc:	ec42                	sd	a6,24(sp)
ffffffffc02074ce:	e846                	sd	a7,16(sp)
ffffffffc02074d0:	0405cb63          	bltz	a1,ffffffffc0207526 <skew_heap_merge.constprop.0+0x164>
ffffffffc02074d4:	6b0c                	ld	a1,16(a4)
ffffffffc02074d6:	8536                	mv	a0,a3
ffffffffc02074d8:	6714                	ld	a3,8(a4)
ffffffffc02074da:	e43a                	sd	a4,8(sp)
ffffffffc02074dc:	e036                	sd	a3,0(sp)
ffffffffc02074de:	ee5ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc02074e2:	6722                	ld	a4,8(sp)
ffffffffc02074e4:	6682                	ld	a3,0(sp)
ffffffffc02074e6:	68c2                	ld	a7,16(sp)
ffffffffc02074e8:	e708                	sd	a0,8(a4)
ffffffffc02074ea:	eb14                	sd	a3,16(a4)
ffffffffc02074ec:	6862                	ld	a6,24(sp)
ffffffffc02074ee:	7602                	ld	a2,32(sp)
ffffffffc02074f0:	77a2                	ld	a5,40(sp)
ffffffffc02074f2:	c111                	beqz	a0,ffffffffc02074f6 <skew_heap_merge.constprop.0+0x134>
ffffffffc02074f4:	e118                	sd	a4,0(a0)
ffffffffc02074f6:	e618                	sd	a4,8(a2)
ffffffffc02074f8:	01063823          	sd	a6,16(a2)
ffffffffc02074fc:	e310                	sd	a2,0(a4)
ffffffffc02074fe:	8732                	mv	a4,a2
ffffffffc0207500:	b791                	j	ffffffffc0207444 <skew_heap_merge.constprop.0+0x82>
ffffffffc0207502:	669c                	ld	a5,8(a3)
ffffffffc0207504:	6a88                	ld	a0,16(a3)
ffffffffc0207506:	ec32                	sd	a2,24(sp)
ffffffffc0207508:	e842                	sd	a6,16(sp)
ffffffffc020750a:	e436                	sd	a3,8(sp)
ffffffffc020750c:	e03e                	sd	a5,0(sp)
ffffffffc020750e:	eb5ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207512:	66a2                	ld	a3,8(sp)
ffffffffc0207514:	6782                	ld	a5,0(sp)
ffffffffc0207516:	6842                	ld	a6,16(sp)
ffffffffc0207518:	e688                	sd	a0,8(a3)
ffffffffc020751a:	ea9c                	sd	a5,16(a3)
ffffffffc020751c:	6662                	ld	a2,24(sp)
ffffffffc020751e:	c111                	beqz	a0,ffffffffc0207522 <skew_heap_merge.constprop.0+0x160>
ffffffffc0207520:	e114                	sd	a3,0(a0)
ffffffffc0207522:	87b6                	mv	a5,a3
ffffffffc0207524:	b759                	j	ffffffffc02074aa <skew_heap_merge.constprop.0+0xe8>
ffffffffc0207526:	6a88                	ld	a0,16(a3)
ffffffffc0207528:	85ba                	mv	a1,a4
ffffffffc020752a:	6698                	ld	a4,8(a3)
ffffffffc020752c:	e436                	sd	a3,8(sp)
ffffffffc020752e:	e03a                	sd	a4,0(sp)
ffffffffc0207530:	e93ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207534:	66a2                	ld	a3,8(sp)
ffffffffc0207536:	6702                	ld	a4,0(sp)
ffffffffc0207538:	68c2                	ld	a7,16(sp)
ffffffffc020753a:	e688                	sd	a0,8(a3)
ffffffffc020753c:	ea98                	sd	a4,16(a3)
ffffffffc020753e:	6862                	ld	a6,24(sp)
ffffffffc0207540:	7602                	ld	a2,32(sp)
ffffffffc0207542:	77a2                	ld	a5,40(sp)
ffffffffc0207544:	c111                	beqz	a0,ffffffffc0207548 <skew_heap_merge.constprop.0+0x186>
ffffffffc0207546:	e114                	sd	a3,0(a0)
ffffffffc0207548:	8736                	mv	a4,a3
ffffffffc020754a:	b775                	j	ffffffffc02074f6 <skew_heap_merge.constprop.0+0x134>
ffffffffc020754c:	6a88                	ld	a0,16(a3)
ffffffffc020754e:	85ba                	mv	a1,a4
ffffffffc0207550:	6698                	ld	a4,8(a3)
ffffffffc0207552:	e436                	sd	a3,8(sp)
ffffffffc0207554:	e03a                	sd	a4,0(sp)
ffffffffc0207556:	e6dff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc020755a:	66a2                	ld	a3,8(sp)
ffffffffc020755c:	6702                	ld	a4,0(sp)
ffffffffc020755e:	6842                	ld	a6,16(sp)
ffffffffc0207560:	e688                	sd	a0,8(a3)
ffffffffc0207562:	ea98                	sd	a4,16(a3)
ffffffffc0207564:	68e2                	ld	a7,24(sp)
ffffffffc0207566:	7602                	ld	a2,32(sp)
ffffffffc0207568:	77a2                	ld	a5,40(sp)
ffffffffc020756a:	dd05                	beqz	a0,ffffffffc02074a2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc020756c:	e114                	sd	a3,0(a0)
ffffffffc020756e:	bf15                	j	ffffffffc02074a2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc0207570:	6614                	ld	a3,8(a2)
ffffffffc0207572:	6908                	ld	a0,16(a0)
ffffffffc0207574:	85c2                	mv	a1,a6
ffffffffc0207576:	e432                	sd	a2,8(sp)
ffffffffc0207578:	e036                	sd	a3,0(sp)
ffffffffc020757a:	e49ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc020757e:	6622                	ld	a2,8(sp)
ffffffffc0207580:	6682                	ld	a3,0(sp)
ffffffffc0207582:	68c2                	ld	a7,16(sp)
ffffffffc0207584:	e608                	sd	a0,8(a2)
ffffffffc0207586:	ea14                	sd	a3,16(a2)
ffffffffc0207588:	6762                	ld	a4,24(sp)
ffffffffc020758a:	7302                	ld	t1,32(sp)
ffffffffc020758c:	77a2                	ld	a5,40(sp)
ffffffffc020758e:	ea0507e3          	beqz	a0,ffffffffc020743c <skew_heap_merge.constprop.0+0x7a>
ffffffffc0207592:	e110                	sd	a2,0(a0)
ffffffffc0207594:	b565                	j	ffffffffc020743c <skew_heap_merge.constprop.0+0x7a>
ffffffffc0207596:	852e                	mv	a0,a1
ffffffffc0207598:	8082                	ret
ffffffffc020759a:	8082                	ret

ffffffffc020759c <stride_enqueue>:
ffffffffc020759c:	6d14                	ld	a3,24(a0)
ffffffffc020759e:	1205b423          	sd	zero,296(a1)
ffffffffc02075a2:	1205bc23          	sd	zero,312(a1)
ffffffffc02075a6:	1205b823          	sd	zero,304(a1)
ffffffffc02075aa:	87ae                	mv	a5,a1
ffffffffc02075ac:	872a                	mv	a4,a0
ffffffffc02075ae:	12858593          	addi	a1,a1,296
ffffffffc02075b2:	ca91                	beqz	a3,ffffffffc02075c6 <stride_enqueue+0x2a>
ffffffffc02075b4:	1407a503          	lw	a0,320(a5)
ffffffffc02075b8:	4e90                	lw	a2,24(a3)
ffffffffc02075ba:	9e09                	subw	a2,a2,a0
ffffffffc02075bc:	02064c63          	bltz	a2,ffffffffc02075f4 <stride_enqueue+0x58>
ffffffffc02075c0:	12d7b823          	sd	a3,304(a5)
ffffffffc02075c4:	e28c                	sd	a1,0(a3)
ffffffffc02075c6:	86ae                	mv	a3,a1
ffffffffc02075c8:	1447a603          	lw	a2,324(a5)
ffffffffc02075cc:	ef14                	sd	a3,24(a4)
ffffffffc02075ce:	e601                	bnez	a2,ffffffffc02075d6 <stride_enqueue+0x3a>
ffffffffc02075d0:	4685                	li	a3,1
ffffffffc02075d2:	14d7a223          	sw	a3,324(a5)
ffffffffc02075d6:	1207a683          	lw	a3,288(a5)
ffffffffc02075da:	4b50                	lw	a2,20(a4)
ffffffffc02075dc:	c299                	beqz	a3,ffffffffc02075e2 <stride_enqueue+0x46>
ffffffffc02075de:	00d65463          	bge	a2,a3,ffffffffc02075e6 <stride_enqueue+0x4a>
ffffffffc02075e2:	12c7a023          	sw	a2,288(a5)
ffffffffc02075e6:	4b14                	lw	a3,16(a4)
ffffffffc02075e8:	10e7b423          	sd	a4,264(a5)
ffffffffc02075ec:	0016879b          	addiw	a5,a3,1 # 40000001 <_binary_bin_sfs_img_size+0x3ff8ad01>
ffffffffc02075f0:	cb1c                	sw	a5,16(a4)
ffffffffc02075f2:	8082                	ret
ffffffffc02075f4:	6a90                	ld	a2,16(a3)
ffffffffc02075f6:	0086b883          	ld	a7,8(a3)
ffffffffc02075fa:	ca11                	beqz	a2,ffffffffc020760e <stride_enqueue+0x72>
ffffffffc02075fc:	01862803          	lw	a6,24(a2)
ffffffffc0207600:	40a8053b          	subw	a0,a6,a0
ffffffffc0207604:	00054a63          	bltz	a0,ffffffffc0207618 <stride_enqueue+0x7c>
ffffffffc0207608:	12c7b823          	sd	a2,304(a5)
ffffffffc020760c:	e20c                	sd	a1,0(a2)
ffffffffc020760e:	e68c                	sd	a1,8(a3)
ffffffffc0207610:	0116b823          	sd	a7,16(a3)
ffffffffc0207614:	e194                	sd	a3,0(a1)
ffffffffc0207616:	bf4d                	j	ffffffffc02075c8 <stride_enqueue+0x2c>
ffffffffc0207618:	00863803          	ld	a6,8(a2)
ffffffffc020761c:	6a08                	ld	a0,16(a2)
ffffffffc020761e:	7139                	addi	sp,sp,-64
ffffffffc0207620:	f43e                	sd	a5,40(sp)
ffffffffc0207622:	f03a                	sd	a4,32(sp)
ffffffffc0207624:	ec46                	sd	a7,24(sp)
ffffffffc0207626:	e836                	sd	a3,16(sp)
ffffffffc0207628:	e432                	sd	a2,8(sp)
ffffffffc020762a:	e042                	sd	a6,0(sp)
ffffffffc020762c:	fc06                	sd	ra,56(sp)
ffffffffc020762e:	d95ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207632:	6622                	ld	a2,8(sp)
ffffffffc0207634:	6802                	ld	a6,0(sp)
ffffffffc0207636:	66c2                	ld	a3,16(sp)
ffffffffc0207638:	e608                	sd	a0,8(a2)
ffffffffc020763a:	01063823          	sd	a6,16(a2)
ffffffffc020763e:	68e2                	ld	a7,24(sp)
ffffffffc0207640:	7702                	ld	a4,32(sp)
ffffffffc0207642:	77a2                	ld	a5,40(sp)
ffffffffc0207644:	c111                	beqz	a0,ffffffffc0207648 <stride_enqueue+0xac>
ffffffffc0207646:	e110                	sd	a2,0(a0)
ffffffffc0207648:	e690                	sd	a2,8(a3)
ffffffffc020764a:	0116b823          	sd	a7,16(a3)
ffffffffc020764e:	e214                	sd	a3,0(a2)
ffffffffc0207650:	1447a603          	lw	a2,324(a5)
ffffffffc0207654:	ef14                	sd	a3,24(a4)
ffffffffc0207656:	c215                	beqz	a2,ffffffffc020767a <stride_enqueue+0xde>
ffffffffc0207658:	1207a683          	lw	a3,288(a5)
ffffffffc020765c:	4b50                	lw	a2,20(a4)
ffffffffc020765e:	c299                	beqz	a3,ffffffffc0207664 <stride_enqueue+0xc8>
ffffffffc0207660:	00d65463          	bge	a2,a3,ffffffffc0207668 <stride_enqueue+0xcc>
ffffffffc0207664:	12c7a023          	sw	a2,288(a5)
ffffffffc0207668:	4b14                	lw	a3,16(a4)
ffffffffc020766a:	70e2                	ld	ra,56(sp)
ffffffffc020766c:	10e7b423          	sd	a4,264(a5)
ffffffffc0207670:	0016879b          	addiw	a5,a3,1
ffffffffc0207674:	cb1c                	sw	a5,16(a4)
ffffffffc0207676:	6121                	addi	sp,sp,64
ffffffffc0207678:	8082                	ret
ffffffffc020767a:	4685                	li	a3,1
ffffffffc020767c:	14d7a223          	sw	a3,324(a5)
ffffffffc0207680:	bfe1                	j	ffffffffc0207658 <stride_enqueue+0xbc>

ffffffffc0207682 <stride_dequeue>:
ffffffffc0207682:	1085b783          	ld	a5,264(a1)
ffffffffc0207686:	7159                	addi	sp,sp,-112
ffffffffc0207688:	f486                	sd	ra,104(sp)
ffffffffc020768a:	2ea79863          	bne	a5,a0,ffffffffc020797a <stride_dequeue+0x2f8>
ffffffffc020768e:	4910                	lw	a2,16(a0)
ffffffffc0207690:	86aa                	mv	a3,a0
ffffffffc0207692:	2e060463          	beqz	a2,ffffffffc020797a <stride_dequeue+0x2f8>
ffffffffc0207696:	1305b803          	ld	a6,304(a1)
ffffffffc020769a:	01853e03          	ld	t3,24(a0)
ffffffffc020769e:	1285b883          	ld	a7,296(a1)
ffffffffc02076a2:	1385b783          	ld	a5,312(a1)
ffffffffc02076a6:	872e                	mv	a4,a1
ffffffffc02076a8:	16080563          	beqz	a6,ffffffffc0207812 <stride_dequeue+0x190>
ffffffffc02076ac:	14078c63          	beqz	a5,ffffffffc0207804 <stride_dequeue+0x182>
ffffffffc02076b0:	01882583          	lw	a1,24(a6)
ffffffffc02076b4:	4f88                	lw	a0,24(a5)
ffffffffc02076b6:	40a5833b          	subw	t1,a1,a0
ffffffffc02076ba:	0a034d63          	bltz	t1,ffffffffc0207774 <stride_dequeue+0xf2>
ffffffffc02076be:	0107b303          	ld	t1,16(a5)
ffffffffc02076c2:	0087bf03          	ld	t5,8(a5)
ffffffffc02076c6:	1a030f63          	beqz	t1,ffffffffc0207884 <stride_dequeue+0x202>
ffffffffc02076ca:	01832503          	lw	a0,24(t1)
ffffffffc02076ce:	40a58ebb          	subw	t4,a1,a0
ffffffffc02076d2:	140ec463          	bltz	t4,ffffffffc020781a <stride_dequeue+0x198>
ffffffffc02076d6:	01033e83          	ld	t4,16(t1)
ffffffffc02076da:	00833f83          	ld	t6,8(t1)
ffffffffc02076de:	040e8c63          	beqz	t4,ffffffffc0207736 <stride_dequeue+0xb4>
ffffffffc02076e2:	018ea503          	lw	a0,24(t4)
ffffffffc02076e6:	ecba                	sd	a4,88(sp)
ffffffffc02076e8:	e8b6                	sd	a3,80(sp)
ffffffffc02076ea:	9d89                	subw	a1,a1,a0
ffffffffc02076ec:	e4be                	sd	a5,72(sp)
ffffffffc02076ee:	e0fe                	sd	t6,64(sp)
ffffffffc02076f0:	fc1a                	sd	t1,56(sp)
ffffffffc02076f2:	f87a                	sd	t5,48(sp)
ffffffffc02076f4:	f446                	sd	a7,40(sp)
ffffffffc02076f6:	f072                	sd	t3,32(sp)
ffffffffc02076f8:	ec32                	sd	a2,24(sp)
ffffffffc02076fa:	2405c363          	bltz	a1,ffffffffc0207940 <stride_dequeue+0x2be>
ffffffffc02076fe:	010eb583          	ld	a1,16(t4)
ffffffffc0207702:	8542                	mv	a0,a6
ffffffffc0207704:	008eb803          	ld	a6,8(t4)
ffffffffc0207708:	e876                	sd	t4,16(sp)
ffffffffc020770a:	e442                	sd	a6,8(sp)
ffffffffc020770c:	cb7ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207710:	6ec2                	ld	t4,16(sp)
ffffffffc0207712:	6822                	ld	a6,8(sp)
ffffffffc0207714:	6662                	ld	a2,24(sp)
ffffffffc0207716:	00aeb423          	sd	a0,8(t4)
ffffffffc020771a:	010eb823          	sd	a6,16(t4)
ffffffffc020771e:	7e02                	ld	t3,32(sp)
ffffffffc0207720:	78a2                	ld	a7,40(sp)
ffffffffc0207722:	7f42                	ld	t5,48(sp)
ffffffffc0207724:	7362                	ld	t1,56(sp)
ffffffffc0207726:	6f86                	ld	t6,64(sp)
ffffffffc0207728:	67a6                	ld	a5,72(sp)
ffffffffc020772a:	66c6                	ld	a3,80(sp)
ffffffffc020772c:	6766                	ld	a4,88(sp)
ffffffffc020772e:	c119                	beqz	a0,ffffffffc0207734 <stride_dequeue+0xb2>
ffffffffc0207730:	01d53023          	sd	t4,0(a0)
ffffffffc0207734:	8876                	mv	a6,t4
ffffffffc0207736:	01033423          	sd	a6,8(t1)
ffffffffc020773a:	01f33823          	sd	t6,16(t1)
ffffffffc020773e:	00683023          	sd	t1,0(a6)
ffffffffc0207742:	0067b423          	sd	t1,8(a5)
ffffffffc0207746:	01e7b823          	sd	t5,16(a5)
ffffffffc020774a:	00f33023          	sd	a5,0(t1)
ffffffffc020774e:	0117b023          	sd	a7,0(a5)
ffffffffc0207752:	00088b63          	beqz	a7,ffffffffc0207768 <stride_dequeue+0xe6>
ffffffffc0207756:	0088b583          	ld	a1,8(a7)
ffffffffc020775a:	12870713          	addi	a4,a4,296
ffffffffc020775e:	0ae58763          	beq	a1,a4,ffffffffc020780c <stride_dequeue+0x18a>
ffffffffc0207762:	00f8b823          	sd	a5,16(a7)
ffffffffc0207766:	87f2                	mv	a5,t3
ffffffffc0207768:	70a6                	ld	ra,104(sp)
ffffffffc020776a:	367d                	addiw	a2,a2,-1
ffffffffc020776c:	ca90                	sw	a2,16(a3)
ffffffffc020776e:	ee9c                	sd	a5,24(a3)
ffffffffc0207770:	6165                	addi	sp,sp,112
ffffffffc0207772:	8082                	ret
ffffffffc0207774:	01083303          	ld	t1,16(a6)
ffffffffc0207778:	00883f03          	ld	t5,8(a6)
ffffffffc020777c:	06030e63          	beqz	t1,ffffffffc02077f8 <stride_dequeue+0x176>
ffffffffc0207780:	01832583          	lw	a1,24(t1)
ffffffffc0207784:	40a5853b          	subw	a0,a1,a0
ffffffffc0207788:	10054063          	bltz	a0,ffffffffc0207888 <stride_dequeue+0x206>
ffffffffc020778c:	0107be83          	ld	t4,16(a5)
ffffffffc0207790:	0087bf83          	ld	t6,8(a5)
ffffffffc0207794:	040e8c63          	beqz	t4,ffffffffc02077ec <stride_dequeue+0x16a>
ffffffffc0207798:	018ea503          	lw	a0,24(t4)
ffffffffc020779c:	ecba                	sd	a4,88(sp)
ffffffffc020779e:	e8b6                	sd	a3,80(sp)
ffffffffc02077a0:	9d89                	subw	a1,a1,a0
ffffffffc02077a2:	e4be                	sd	a5,72(sp)
ffffffffc02077a4:	e0fe                	sd	t6,64(sp)
ffffffffc02077a6:	fc7a                	sd	t5,56(sp)
ffffffffc02077a8:	f842                	sd	a6,48(sp)
ffffffffc02077aa:	f446                	sd	a7,40(sp)
ffffffffc02077ac:	f072                	sd	t3,32(sp)
ffffffffc02077ae:	ec32                	sd	a2,24(sp)
ffffffffc02077b0:	1405cb63          	bltz	a1,ffffffffc0207906 <stride_dequeue+0x284>
ffffffffc02077b4:	010eb583          	ld	a1,16(t4)
ffffffffc02077b8:	851a                	mv	a0,t1
ffffffffc02077ba:	008eb303          	ld	t1,8(t4)
ffffffffc02077be:	e876                	sd	t4,16(sp)
ffffffffc02077c0:	e41a                	sd	t1,8(sp)
ffffffffc02077c2:	c01ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc02077c6:	6ec2                	ld	t4,16(sp)
ffffffffc02077c8:	6322                	ld	t1,8(sp)
ffffffffc02077ca:	6662                	ld	a2,24(sp)
ffffffffc02077cc:	00aeb423          	sd	a0,8(t4)
ffffffffc02077d0:	006eb823          	sd	t1,16(t4)
ffffffffc02077d4:	7e02                	ld	t3,32(sp)
ffffffffc02077d6:	78a2                	ld	a7,40(sp)
ffffffffc02077d8:	7842                	ld	a6,48(sp)
ffffffffc02077da:	7f62                	ld	t5,56(sp)
ffffffffc02077dc:	6f86                	ld	t6,64(sp)
ffffffffc02077de:	67a6                	ld	a5,72(sp)
ffffffffc02077e0:	66c6                	ld	a3,80(sp)
ffffffffc02077e2:	6766                	ld	a4,88(sp)
ffffffffc02077e4:	c119                	beqz	a0,ffffffffc02077ea <stride_dequeue+0x168>
ffffffffc02077e6:	01d53023          	sd	t4,0(a0)
ffffffffc02077ea:	8376                	mv	t1,t4
ffffffffc02077ec:	0067b423          	sd	t1,8(a5)
ffffffffc02077f0:	01f7b823          	sd	t6,16(a5)
ffffffffc02077f4:	00f33023          	sd	a5,0(t1)
ffffffffc02077f8:	00f83423          	sd	a5,8(a6)
ffffffffc02077fc:	01e83823          	sd	t5,16(a6)
ffffffffc0207800:	0107b023          	sd	a6,0(a5)
ffffffffc0207804:	87c2                	mv	a5,a6
ffffffffc0207806:	0117b023          	sd	a7,0(a5)
ffffffffc020780a:	b7a1                	j	ffffffffc0207752 <stride_dequeue+0xd0>
ffffffffc020780c:	00f8b423          	sd	a5,8(a7)
ffffffffc0207810:	bf99                	j	ffffffffc0207766 <stride_dequeue+0xe4>
ffffffffc0207812:	d3a1                	beqz	a5,ffffffffc0207752 <stride_dequeue+0xd0>
ffffffffc0207814:	0117b023          	sd	a7,0(a5)
ffffffffc0207818:	bf2d                	j	ffffffffc0207752 <stride_dequeue+0xd0>
ffffffffc020781a:	01083e83          	ld	t4,16(a6)
ffffffffc020781e:	00883f83          	ld	t6,8(a6)
ffffffffc0207822:	040e8b63          	beqz	t4,ffffffffc0207878 <stride_dequeue+0x1f6>
ffffffffc0207826:	018ea583          	lw	a1,24(t4)
ffffffffc020782a:	ecba                	sd	a4,88(sp)
ffffffffc020782c:	e8b6                	sd	a3,80(sp)
ffffffffc020782e:	9d89                	subw	a1,a1,a0
ffffffffc0207830:	e4be                	sd	a5,72(sp)
ffffffffc0207832:	e0fe                	sd	t6,64(sp)
ffffffffc0207834:	fc7a                	sd	t5,56(sp)
ffffffffc0207836:	f842                	sd	a6,48(sp)
ffffffffc0207838:	f446                	sd	a7,40(sp)
ffffffffc020783a:	f072                	sd	t3,32(sp)
ffffffffc020783c:	ec32                	sd	a2,24(sp)
ffffffffc020783e:	0805c763          	bltz	a1,ffffffffc02078cc <stride_dequeue+0x24a>
ffffffffc0207842:	01033583          	ld	a1,16(t1)
ffffffffc0207846:	8576                	mv	a0,t4
ffffffffc0207848:	00833e83          	ld	t4,8(t1)
ffffffffc020784c:	e81a                	sd	t1,16(sp)
ffffffffc020784e:	e476                	sd	t4,8(sp)
ffffffffc0207850:	b73ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207854:	6342                	ld	t1,16(sp)
ffffffffc0207856:	6ea2                	ld	t4,8(sp)
ffffffffc0207858:	6662                	ld	a2,24(sp)
ffffffffc020785a:	00a33423          	sd	a0,8(t1)
ffffffffc020785e:	01d33823          	sd	t4,16(t1)
ffffffffc0207862:	7e02                	ld	t3,32(sp)
ffffffffc0207864:	78a2                	ld	a7,40(sp)
ffffffffc0207866:	7842                	ld	a6,48(sp)
ffffffffc0207868:	7f62                	ld	t5,56(sp)
ffffffffc020786a:	6f86                	ld	t6,64(sp)
ffffffffc020786c:	67a6                	ld	a5,72(sp)
ffffffffc020786e:	66c6                	ld	a3,80(sp)
ffffffffc0207870:	6766                	ld	a4,88(sp)
ffffffffc0207872:	c119                	beqz	a0,ffffffffc0207878 <stride_dequeue+0x1f6>
ffffffffc0207874:	00653023          	sd	t1,0(a0)
ffffffffc0207878:	00683423          	sd	t1,8(a6)
ffffffffc020787c:	01f83823          	sd	t6,16(a6)
ffffffffc0207880:	01033023          	sd	a6,0(t1)
ffffffffc0207884:	8342                	mv	t1,a6
ffffffffc0207886:	bd75                	j	ffffffffc0207742 <stride_dequeue+0xc0>
ffffffffc0207888:	01033503          	ld	a0,16(t1)
ffffffffc020788c:	85be                	mv	a1,a5
ffffffffc020788e:	00833783          	ld	a5,8(t1)
ffffffffc0207892:	e4ba                	sd	a4,72(sp)
ffffffffc0207894:	e0b6                	sd	a3,64(sp)
ffffffffc0207896:	fc7a                	sd	t5,56(sp)
ffffffffc0207898:	f842                	sd	a6,48(sp)
ffffffffc020789a:	f446                	sd	a7,40(sp)
ffffffffc020789c:	f072                	sd	t3,32(sp)
ffffffffc020789e:	ec32                	sd	a2,24(sp)
ffffffffc02078a0:	e81a                	sd	t1,16(sp)
ffffffffc02078a2:	e43e                	sd	a5,8(sp)
ffffffffc02078a4:	b1fff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc02078a8:	6342                	ld	t1,16(sp)
ffffffffc02078aa:	67a2                	ld	a5,8(sp)
ffffffffc02078ac:	6662                	ld	a2,24(sp)
ffffffffc02078ae:	00a33423          	sd	a0,8(t1)
ffffffffc02078b2:	00f33823          	sd	a5,16(t1)
ffffffffc02078b6:	7e02                	ld	t3,32(sp)
ffffffffc02078b8:	78a2                	ld	a7,40(sp)
ffffffffc02078ba:	7842                	ld	a6,48(sp)
ffffffffc02078bc:	7f62                	ld	t5,56(sp)
ffffffffc02078be:	6686                	ld	a3,64(sp)
ffffffffc02078c0:	6726                	ld	a4,72(sp)
ffffffffc02078c2:	c119                	beqz	a0,ffffffffc02078c8 <stride_dequeue+0x246>
ffffffffc02078c4:	00653023          	sd	t1,0(a0)
ffffffffc02078c8:	879a                	mv	a5,t1
ffffffffc02078ca:	b73d                	j	ffffffffc02077f8 <stride_dequeue+0x176>
ffffffffc02078cc:	010eb503          	ld	a0,16(t4)
ffffffffc02078d0:	859a                	mv	a1,t1
ffffffffc02078d2:	008eb303          	ld	t1,8(t4)
ffffffffc02078d6:	e876                	sd	t4,16(sp)
ffffffffc02078d8:	e41a                	sd	t1,8(sp)
ffffffffc02078da:	ae9ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc02078de:	6ec2                	ld	t4,16(sp)
ffffffffc02078e0:	6322                	ld	t1,8(sp)
ffffffffc02078e2:	6662                	ld	a2,24(sp)
ffffffffc02078e4:	00aeb423          	sd	a0,8(t4)
ffffffffc02078e8:	006eb823          	sd	t1,16(t4)
ffffffffc02078ec:	7e02                	ld	t3,32(sp)
ffffffffc02078ee:	78a2                	ld	a7,40(sp)
ffffffffc02078f0:	7842                	ld	a6,48(sp)
ffffffffc02078f2:	7f62                	ld	t5,56(sp)
ffffffffc02078f4:	6f86                	ld	t6,64(sp)
ffffffffc02078f6:	67a6                	ld	a5,72(sp)
ffffffffc02078f8:	66c6                	ld	a3,80(sp)
ffffffffc02078fa:	6766                	ld	a4,88(sp)
ffffffffc02078fc:	c119                	beqz	a0,ffffffffc0207902 <stride_dequeue+0x280>
ffffffffc02078fe:	01d53023          	sd	t4,0(a0)
ffffffffc0207902:	8376                	mv	t1,t4
ffffffffc0207904:	bf95                	j	ffffffffc0207878 <stride_dequeue+0x1f6>
ffffffffc0207906:	01033503          	ld	a0,16(t1)
ffffffffc020790a:	85f6                	mv	a1,t4
ffffffffc020790c:	00833e83          	ld	t4,8(t1)
ffffffffc0207910:	e81a                	sd	t1,16(sp)
ffffffffc0207912:	e476                	sd	t4,8(sp)
ffffffffc0207914:	aafff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207918:	6342                	ld	t1,16(sp)
ffffffffc020791a:	6ea2                	ld	t4,8(sp)
ffffffffc020791c:	6662                	ld	a2,24(sp)
ffffffffc020791e:	00a33423          	sd	a0,8(t1)
ffffffffc0207922:	01d33823          	sd	t4,16(t1)
ffffffffc0207926:	7e02                	ld	t3,32(sp)
ffffffffc0207928:	78a2                	ld	a7,40(sp)
ffffffffc020792a:	7842                	ld	a6,48(sp)
ffffffffc020792c:	7f62                	ld	t5,56(sp)
ffffffffc020792e:	6f86                	ld	t6,64(sp)
ffffffffc0207930:	67a6                	ld	a5,72(sp)
ffffffffc0207932:	66c6                	ld	a3,80(sp)
ffffffffc0207934:	6766                	ld	a4,88(sp)
ffffffffc0207936:	ea050be3          	beqz	a0,ffffffffc02077ec <stride_dequeue+0x16a>
ffffffffc020793a:	00653023          	sd	t1,0(a0)
ffffffffc020793e:	b57d                	j	ffffffffc02077ec <stride_dequeue+0x16a>
ffffffffc0207940:	01083503          	ld	a0,16(a6)
ffffffffc0207944:	85f6                	mv	a1,t4
ffffffffc0207946:	00883e83          	ld	t4,8(a6)
ffffffffc020794a:	e842                	sd	a6,16(sp)
ffffffffc020794c:	e476                	sd	t4,8(sp)
ffffffffc020794e:	a75ff0ef          	jal	ffffffffc02073c2 <skew_heap_merge.constprop.0>
ffffffffc0207952:	6842                	ld	a6,16(sp)
ffffffffc0207954:	6ea2                	ld	t4,8(sp)
ffffffffc0207956:	6662                	ld	a2,24(sp)
ffffffffc0207958:	00a83423          	sd	a0,8(a6)
ffffffffc020795c:	01d83823          	sd	t4,16(a6)
ffffffffc0207960:	7e02                	ld	t3,32(sp)
ffffffffc0207962:	78a2                	ld	a7,40(sp)
ffffffffc0207964:	7f42                	ld	t5,48(sp)
ffffffffc0207966:	7362                	ld	t1,56(sp)
ffffffffc0207968:	6f86                	ld	t6,64(sp)
ffffffffc020796a:	67a6                	ld	a5,72(sp)
ffffffffc020796c:	66c6                	ld	a3,80(sp)
ffffffffc020796e:	6766                	ld	a4,88(sp)
ffffffffc0207970:	dc0503e3          	beqz	a0,ffffffffc0207736 <stride_dequeue+0xb4>
ffffffffc0207974:	01053023          	sd	a6,0(a0)
ffffffffc0207978:	bb7d                	j	ffffffffc0207736 <stride_dequeue+0xb4>
ffffffffc020797a:	00006697          	auipc	a3,0x6
ffffffffc020797e:	66668693          	addi	a3,a3,1638 # ffffffffc020dfe0 <etext+0x21cc>
ffffffffc0207982:	00005617          	auipc	a2,0x5
ffffffffc0207986:	8ce60613          	addi	a2,a2,-1842 # ffffffffc020c250 <etext+0x43c>
ffffffffc020798a:	06e00593          	li	a1,110
ffffffffc020798e:	00006517          	auipc	a0,0x6
ffffffffc0207992:	67a50513          	addi	a0,a0,1658 # ffffffffc020e008 <etext+0x21f4>
ffffffffc0207996:	ab5f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020799a <sched_init>:
ffffffffc020799a:	00089797          	auipc	a5,0x89
ffffffffc020799e:	68678793          	addi	a5,a5,1670 # ffffffffc0291020 <stride_sched_class>
ffffffffc02079a2:	1141                	addi	sp,sp,-16
ffffffffc02079a4:	6794                	ld	a3,8(a5)
ffffffffc02079a6:	0008f717          	auipc	a4,0x8f
ffffffffc02079aa:	f4f73123          	sd	a5,-190(a4) # ffffffffc02968e8 <sched_class>
ffffffffc02079ae:	e406                	sd	ra,8(sp)
ffffffffc02079b0:	0008e797          	auipc	a5,0x8e
ffffffffc02079b4:	e4078793          	addi	a5,a5,-448 # ffffffffc02957f0 <timer_list>
ffffffffc02079b8:	0008e717          	auipc	a4,0x8e
ffffffffc02079bc:	e1870713          	addi	a4,a4,-488 # ffffffffc02957d0 <__rq>
ffffffffc02079c0:	4615                	li	a2,5
ffffffffc02079c2:	e79c                	sd	a5,8(a5)
ffffffffc02079c4:	e39c                	sd	a5,0(a5)
ffffffffc02079c6:	853a                	mv	a0,a4
ffffffffc02079c8:	cb50                	sw	a2,20(a4)
ffffffffc02079ca:	0008f797          	auipc	a5,0x8f
ffffffffc02079ce:	f0e7bb23          	sd	a4,-234(a5) # ffffffffc02968e0 <rq>
ffffffffc02079d2:	9682                	jalr	a3
ffffffffc02079d4:	0008f797          	auipc	a5,0x8f
ffffffffc02079d8:	f147b783          	ld	a5,-236(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02079dc:	60a2                	ld	ra,8(sp)
ffffffffc02079de:	00006517          	auipc	a0,0x6
ffffffffc02079e2:	66a50513          	addi	a0,a0,1642 # ffffffffc020e048 <etext+0x2234>
ffffffffc02079e6:	638c                	ld	a1,0(a5)
ffffffffc02079e8:	0141                	addi	sp,sp,16
ffffffffc02079ea:	fbcf806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc02079ee <wakeup_proc>:
ffffffffc02079ee:	4118                	lw	a4,0(a0)
ffffffffc02079f0:	1101                	addi	sp,sp,-32
ffffffffc02079f2:	ec06                	sd	ra,24(sp)
ffffffffc02079f4:	478d                	li	a5,3
ffffffffc02079f6:	0cf70863          	beq	a4,a5,ffffffffc0207ac6 <wakeup_proc+0xd8>
ffffffffc02079fa:	85aa                	mv	a1,a0
ffffffffc02079fc:	100027f3          	csrr	a5,sstatus
ffffffffc0207a00:	8b89                	andi	a5,a5,2
ffffffffc0207a02:	e3b1                	bnez	a5,ffffffffc0207a46 <wakeup_proc+0x58>
ffffffffc0207a04:	4789                	li	a5,2
ffffffffc0207a06:	08f70563          	beq	a4,a5,ffffffffc0207a90 <wakeup_proc+0xa2>
ffffffffc0207a0a:	0008f717          	auipc	a4,0x8f
ffffffffc0207a0e:	ebe73703          	ld	a4,-322(a4) # ffffffffc02968c8 <current>
ffffffffc0207a12:	0e052623          	sw	zero,236(a0)
ffffffffc0207a16:	c11c                	sw	a5,0(a0)
ffffffffc0207a18:	02e50463          	beq	a0,a4,ffffffffc0207a40 <wakeup_proc+0x52>
ffffffffc0207a1c:	0008f797          	auipc	a5,0x8f
ffffffffc0207a20:	ebc7b783          	ld	a5,-324(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207a24:	00f50e63          	beq	a0,a5,ffffffffc0207a40 <wakeup_proc+0x52>
ffffffffc0207a28:	0008f797          	auipc	a5,0x8f
ffffffffc0207a2c:	ec07b783          	ld	a5,-320(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207a30:	60e2                	ld	ra,24(sp)
ffffffffc0207a32:	0008f517          	auipc	a0,0x8f
ffffffffc0207a36:	eae53503          	ld	a0,-338(a0) # ffffffffc02968e0 <rq>
ffffffffc0207a3a:	6b9c                	ld	a5,16(a5)
ffffffffc0207a3c:	6105                	addi	sp,sp,32
ffffffffc0207a3e:	8782                	jr	a5
ffffffffc0207a40:	60e2                	ld	ra,24(sp)
ffffffffc0207a42:	6105                	addi	sp,sp,32
ffffffffc0207a44:	8082                	ret
ffffffffc0207a46:	e42a                	sd	a0,8(sp)
ffffffffc0207a48:	990f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207a4c:	65a2                	ld	a1,8(sp)
ffffffffc0207a4e:	4789                	li	a5,2
ffffffffc0207a50:	4198                	lw	a4,0(a1)
ffffffffc0207a52:	04f70d63          	beq	a4,a5,ffffffffc0207aac <wakeup_proc+0xbe>
ffffffffc0207a56:	0008f717          	auipc	a4,0x8f
ffffffffc0207a5a:	e7273703          	ld	a4,-398(a4) # ffffffffc02968c8 <current>
ffffffffc0207a5e:	0e05a623          	sw	zero,236(a1)
ffffffffc0207a62:	c19c                	sw	a5,0(a1)
ffffffffc0207a64:	02e58263          	beq	a1,a4,ffffffffc0207a88 <wakeup_proc+0x9a>
ffffffffc0207a68:	0008f797          	auipc	a5,0x8f
ffffffffc0207a6c:	e707b783          	ld	a5,-400(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207a70:	00f58c63          	beq	a1,a5,ffffffffc0207a88 <wakeup_proc+0x9a>
ffffffffc0207a74:	0008f797          	auipc	a5,0x8f
ffffffffc0207a78:	e747b783          	ld	a5,-396(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207a7c:	0008f517          	auipc	a0,0x8f
ffffffffc0207a80:	e6453503          	ld	a0,-412(a0) # ffffffffc02968e0 <rq>
ffffffffc0207a84:	6b9c                	ld	a5,16(a5)
ffffffffc0207a86:	9782                	jalr	a5
ffffffffc0207a88:	60e2                	ld	ra,24(sp)
ffffffffc0207a8a:	6105                	addi	sp,sp,32
ffffffffc0207a8c:	946f906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207a90:	60e2                	ld	ra,24(sp)
ffffffffc0207a92:	00006617          	auipc	a2,0x6
ffffffffc0207a96:	60660613          	addi	a2,a2,1542 # ffffffffc020e098 <etext+0x2284>
ffffffffc0207a9a:	05300593          	li	a1,83
ffffffffc0207a9e:	00006517          	auipc	a0,0x6
ffffffffc0207aa2:	5e250513          	addi	a0,a0,1506 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207aa6:	6105                	addi	sp,sp,32
ffffffffc0207aa8:	a0df806f          	j	ffffffffc02004b4 <__warn>
ffffffffc0207aac:	00006617          	auipc	a2,0x6
ffffffffc0207ab0:	5ec60613          	addi	a2,a2,1516 # ffffffffc020e098 <etext+0x2284>
ffffffffc0207ab4:	05300593          	li	a1,83
ffffffffc0207ab8:	00006517          	auipc	a0,0x6
ffffffffc0207abc:	5c850513          	addi	a0,a0,1480 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207ac0:	9f5f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207ac4:	b7d1                	j	ffffffffc0207a88 <wakeup_proc+0x9a>
ffffffffc0207ac6:	00006697          	auipc	a3,0x6
ffffffffc0207aca:	59a68693          	addi	a3,a3,1434 # ffffffffc020e060 <etext+0x224c>
ffffffffc0207ace:	00004617          	auipc	a2,0x4
ffffffffc0207ad2:	78260613          	addi	a2,a2,1922 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207ad6:	04400593          	li	a1,68
ffffffffc0207ada:	00006517          	auipc	a0,0x6
ffffffffc0207ade:	5a650513          	addi	a0,a0,1446 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207ae2:	969f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207ae6 <schedule>:
ffffffffc0207ae6:	7139                	addi	sp,sp,-64
ffffffffc0207ae8:	fc06                	sd	ra,56(sp)
ffffffffc0207aea:	f822                	sd	s0,48(sp)
ffffffffc0207aec:	f426                	sd	s1,40(sp)
ffffffffc0207aee:	f04a                	sd	s2,32(sp)
ffffffffc0207af0:	ec4e                	sd	s3,24(sp)
ffffffffc0207af2:	100027f3          	csrr	a5,sstatus
ffffffffc0207af6:	8b89                	andi	a5,a5,2
ffffffffc0207af8:	4981                	li	s3,0
ffffffffc0207afa:	efc9                	bnez	a5,ffffffffc0207b94 <schedule+0xae>
ffffffffc0207afc:	0008f417          	auipc	s0,0x8f
ffffffffc0207b00:	dcc40413          	addi	s0,s0,-564 # ffffffffc02968c8 <current>
ffffffffc0207b04:	600c                	ld	a1,0(s0)
ffffffffc0207b06:	4789                	li	a5,2
ffffffffc0207b08:	0008f497          	auipc	s1,0x8f
ffffffffc0207b0c:	dd848493          	addi	s1,s1,-552 # ffffffffc02968e0 <rq>
ffffffffc0207b10:	4198                	lw	a4,0(a1)
ffffffffc0207b12:	0005bc23          	sd	zero,24(a1)
ffffffffc0207b16:	0008f917          	auipc	s2,0x8f
ffffffffc0207b1a:	dd290913          	addi	s2,s2,-558 # ffffffffc02968e8 <sched_class>
ffffffffc0207b1e:	04f70f63          	beq	a4,a5,ffffffffc0207b7c <schedule+0x96>
ffffffffc0207b22:	00093783          	ld	a5,0(s2)
ffffffffc0207b26:	6088                	ld	a0,0(s1)
ffffffffc0207b28:	739c                	ld	a5,32(a5)
ffffffffc0207b2a:	9782                	jalr	a5
ffffffffc0207b2c:	85aa                	mv	a1,a0
ffffffffc0207b2e:	c131                	beqz	a0,ffffffffc0207b72 <schedule+0x8c>
ffffffffc0207b30:	00093783          	ld	a5,0(s2)
ffffffffc0207b34:	6088                	ld	a0,0(s1)
ffffffffc0207b36:	e42e                	sd	a1,8(sp)
ffffffffc0207b38:	6f9c                	ld	a5,24(a5)
ffffffffc0207b3a:	9782                	jalr	a5
ffffffffc0207b3c:	65a2                	ld	a1,8(sp)
ffffffffc0207b3e:	459c                	lw	a5,8(a1)
ffffffffc0207b40:	6018                	ld	a4,0(s0)
ffffffffc0207b42:	2785                	addiw	a5,a5,1
ffffffffc0207b44:	c59c                	sw	a5,8(a1)
ffffffffc0207b46:	00b70563          	beq	a4,a1,ffffffffc0207b50 <schedule+0x6a>
ffffffffc0207b4a:	852e                	mv	a0,a1
ffffffffc0207b4c:	a98fe0ef          	jal	ffffffffc0205de4 <proc_run>
ffffffffc0207b50:	00099963          	bnez	s3,ffffffffc0207b62 <schedule+0x7c>
ffffffffc0207b54:	70e2                	ld	ra,56(sp)
ffffffffc0207b56:	7442                	ld	s0,48(sp)
ffffffffc0207b58:	74a2                	ld	s1,40(sp)
ffffffffc0207b5a:	7902                	ld	s2,32(sp)
ffffffffc0207b5c:	69e2                	ld	s3,24(sp)
ffffffffc0207b5e:	6121                	addi	sp,sp,64
ffffffffc0207b60:	8082                	ret
ffffffffc0207b62:	7442                	ld	s0,48(sp)
ffffffffc0207b64:	70e2                	ld	ra,56(sp)
ffffffffc0207b66:	74a2                	ld	s1,40(sp)
ffffffffc0207b68:	7902                	ld	s2,32(sp)
ffffffffc0207b6a:	69e2                	ld	s3,24(sp)
ffffffffc0207b6c:	6121                	addi	sp,sp,64
ffffffffc0207b6e:	864f906f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207b72:	0008f597          	auipc	a1,0x8f
ffffffffc0207b76:	d665b583          	ld	a1,-666(a1) # ffffffffc02968d8 <idleproc>
ffffffffc0207b7a:	b7d1                	j	ffffffffc0207b3e <schedule+0x58>
ffffffffc0207b7c:	0008f797          	auipc	a5,0x8f
ffffffffc0207b80:	d5c7b783          	ld	a5,-676(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207b84:	f8f58fe3          	beq	a1,a5,ffffffffc0207b22 <schedule+0x3c>
ffffffffc0207b88:	00093783          	ld	a5,0(s2)
ffffffffc0207b8c:	6088                	ld	a0,0(s1)
ffffffffc0207b8e:	6b9c                	ld	a5,16(a5)
ffffffffc0207b90:	9782                	jalr	a5
ffffffffc0207b92:	bf41                	j	ffffffffc0207b22 <schedule+0x3c>
ffffffffc0207b94:	844f90ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207b98:	4985                	li	s3,1
ffffffffc0207b9a:	b78d                	j	ffffffffc0207afc <schedule+0x16>

ffffffffc0207b9c <add_timer>:
ffffffffc0207b9c:	1101                	addi	sp,sp,-32
ffffffffc0207b9e:	ec06                	sd	ra,24(sp)
ffffffffc0207ba0:	100027f3          	csrr	a5,sstatus
ffffffffc0207ba4:	8b89                	andi	a5,a5,2
ffffffffc0207ba6:	4801                	li	a6,0
ffffffffc0207ba8:	e7bd                	bnez	a5,ffffffffc0207c16 <add_timer+0x7a>
ffffffffc0207baa:	4118                	lw	a4,0(a0)
ffffffffc0207bac:	cb3d                	beqz	a4,ffffffffc0207c22 <add_timer+0x86>
ffffffffc0207bae:	651c                	ld	a5,8(a0)
ffffffffc0207bb0:	cbad                	beqz	a5,ffffffffc0207c22 <add_timer+0x86>
ffffffffc0207bb2:	6d1c                	ld	a5,24(a0)
ffffffffc0207bb4:	01050593          	addi	a1,a0,16
ffffffffc0207bb8:	08f59563          	bne	a1,a5,ffffffffc0207c42 <add_timer+0xa6>
ffffffffc0207bbc:	0008e617          	auipc	a2,0x8e
ffffffffc0207bc0:	c3460613          	addi	a2,a2,-972 # ffffffffc02957f0 <timer_list>
ffffffffc0207bc4:	661c                	ld	a5,8(a2)
ffffffffc0207bc6:	00c79863          	bne	a5,a2,ffffffffc0207bd6 <add_timer+0x3a>
ffffffffc0207bca:	a805                	j	ffffffffc0207bfa <add_timer+0x5e>
ffffffffc0207bcc:	679c                	ld	a5,8(a5)
ffffffffc0207bce:	9f15                	subw	a4,a4,a3
ffffffffc0207bd0:	c118                	sw	a4,0(a0)
ffffffffc0207bd2:	02c78463          	beq	a5,a2,ffffffffc0207bfa <add_timer+0x5e>
ffffffffc0207bd6:	ff07a683          	lw	a3,-16(a5)
ffffffffc0207bda:	fed779e3          	bgeu	a4,a3,ffffffffc0207bcc <add_timer+0x30>
ffffffffc0207bde:	9e99                	subw	a3,a3,a4
ffffffffc0207be0:	6398                	ld	a4,0(a5)
ffffffffc0207be2:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207be6:	e38c                	sd	a1,0(a5)
ffffffffc0207be8:	e70c                	sd	a1,8(a4)
ffffffffc0207bea:	e918                	sd	a4,16(a0)
ffffffffc0207bec:	ed1c                	sd	a5,24(a0)
ffffffffc0207bee:	02080163          	beqz	a6,ffffffffc0207c10 <add_timer+0x74>
ffffffffc0207bf2:	60e2                	ld	ra,24(sp)
ffffffffc0207bf4:	6105                	addi	sp,sp,32
ffffffffc0207bf6:	fddf806f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207bfa:	0008e797          	auipc	a5,0x8e
ffffffffc0207bfe:	bf678793          	addi	a5,a5,-1034 # ffffffffc02957f0 <timer_list>
ffffffffc0207c02:	6398                	ld	a4,0(a5)
ffffffffc0207c04:	e38c                	sd	a1,0(a5)
ffffffffc0207c06:	e70c                	sd	a1,8(a4)
ffffffffc0207c08:	e918                	sd	a4,16(a0)
ffffffffc0207c0a:	ed1c                	sd	a5,24(a0)
ffffffffc0207c0c:	fe0813e3          	bnez	a6,ffffffffc0207bf2 <add_timer+0x56>
ffffffffc0207c10:	60e2                	ld	ra,24(sp)
ffffffffc0207c12:	6105                	addi	sp,sp,32
ffffffffc0207c14:	8082                	ret
ffffffffc0207c16:	e42a                	sd	a0,8(sp)
ffffffffc0207c18:	fc1f80ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207c1c:	6522                	ld	a0,8(sp)
ffffffffc0207c1e:	4805                	li	a6,1
ffffffffc0207c20:	b769                	j	ffffffffc0207baa <add_timer+0xe>
ffffffffc0207c22:	00006697          	auipc	a3,0x6
ffffffffc0207c26:	49668693          	addi	a3,a3,1174 # ffffffffc020e0b8 <etext+0x22a4>
ffffffffc0207c2a:	00004617          	auipc	a2,0x4
ffffffffc0207c2e:	62660613          	addi	a2,a2,1574 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207c32:	07b00593          	li	a1,123
ffffffffc0207c36:	00006517          	auipc	a0,0x6
ffffffffc0207c3a:	44a50513          	addi	a0,a0,1098 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207c3e:	80df80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207c42:	00006697          	auipc	a3,0x6
ffffffffc0207c46:	4a668693          	addi	a3,a3,1190 # ffffffffc020e0e8 <etext+0x22d4>
ffffffffc0207c4a:	00004617          	auipc	a2,0x4
ffffffffc0207c4e:	60660613          	addi	a2,a2,1542 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207c52:	07c00593          	li	a1,124
ffffffffc0207c56:	00006517          	auipc	a0,0x6
ffffffffc0207c5a:	42a50513          	addi	a0,a0,1066 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207c5e:	fecf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207c62 <del_timer>:
ffffffffc0207c62:	100027f3          	csrr	a5,sstatus
ffffffffc0207c66:	8b89                	andi	a5,a5,2
ffffffffc0207c68:	ef95                	bnez	a5,ffffffffc0207ca4 <del_timer+0x42>
ffffffffc0207c6a:	6d1c                	ld	a5,24(a0)
ffffffffc0207c6c:	01050713          	addi	a4,a0,16
ffffffffc0207c70:	4601                	li	a2,0
ffffffffc0207c72:	02f70863          	beq	a4,a5,ffffffffc0207ca2 <del_timer+0x40>
ffffffffc0207c76:	0008e597          	auipc	a1,0x8e
ffffffffc0207c7a:	b7a58593          	addi	a1,a1,-1158 # ffffffffc02957f0 <timer_list>
ffffffffc0207c7e:	4114                	lw	a3,0(a0)
ffffffffc0207c80:	00b78863          	beq	a5,a1,ffffffffc0207c90 <del_timer+0x2e>
ffffffffc0207c84:	c691                	beqz	a3,ffffffffc0207c90 <del_timer+0x2e>
ffffffffc0207c86:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207c8a:	9ead                	addw	a3,a3,a1
ffffffffc0207c8c:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207c90:	6914                	ld	a3,16(a0)
ffffffffc0207c92:	e69c                	sd	a5,8(a3)
ffffffffc0207c94:	e394                	sd	a3,0(a5)
ffffffffc0207c96:	ed18                	sd	a4,24(a0)
ffffffffc0207c98:	e918                	sd	a4,16(a0)
ffffffffc0207c9a:	e211                	bnez	a2,ffffffffc0207c9e <del_timer+0x3c>
ffffffffc0207c9c:	8082                	ret
ffffffffc0207c9e:	f35f806f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207ca2:	8082                	ret
ffffffffc0207ca4:	1101                	addi	sp,sp,-32
ffffffffc0207ca6:	e42a                	sd	a0,8(sp)
ffffffffc0207ca8:	ec06                	sd	ra,24(sp)
ffffffffc0207caa:	f2ff80ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207cae:	6522                	ld	a0,8(sp)
ffffffffc0207cb0:	4605                	li	a2,1
ffffffffc0207cb2:	6d1c                	ld	a5,24(a0)
ffffffffc0207cb4:	01050713          	addi	a4,a0,16
ffffffffc0207cb8:	02f70863          	beq	a4,a5,ffffffffc0207ce8 <del_timer+0x86>
ffffffffc0207cbc:	0008e597          	auipc	a1,0x8e
ffffffffc0207cc0:	b3458593          	addi	a1,a1,-1228 # ffffffffc02957f0 <timer_list>
ffffffffc0207cc4:	4114                	lw	a3,0(a0)
ffffffffc0207cc6:	00b78863          	beq	a5,a1,ffffffffc0207cd6 <del_timer+0x74>
ffffffffc0207cca:	c691                	beqz	a3,ffffffffc0207cd6 <del_timer+0x74>
ffffffffc0207ccc:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207cd0:	9ead                	addw	a3,a3,a1
ffffffffc0207cd2:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207cd6:	6914                	ld	a3,16(a0)
ffffffffc0207cd8:	e69c                	sd	a5,8(a3)
ffffffffc0207cda:	e394                	sd	a3,0(a5)
ffffffffc0207cdc:	ed18                	sd	a4,24(a0)
ffffffffc0207cde:	e918                	sd	a4,16(a0)
ffffffffc0207ce0:	e601                	bnez	a2,ffffffffc0207ce8 <del_timer+0x86>
ffffffffc0207ce2:	60e2                	ld	ra,24(sp)
ffffffffc0207ce4:	6105                	addi	sp,sp,32
ffffffffc0207ce6:	8082                	ret
ffffffffc0207ce8:	60e2                	ld	ra,24(sp)
ffffffffc0207cea:	6105                	addi	sp,sp,32
ffffffffc0207cec:	ee7f806f          	j	ffffffffc0200bd2 <intr_enable>

ffffffffc0207cf0 <run_timer_list>:
ffffffffc0207cf0:	7179                	addi	sp,sp,-48
ffffffffc0207cf2:	f406                	sd	ra,40(sp)
ffffffffc0207cf4:	f022                	sd	s0,32(sp)
ffffffffc0207cf6:	e44e                	sd	s3,8(sp)
ffffffffc0207cf8:	e052                	sd	s4,0(sp)
ffffffffc0207cfa:	100027f3          	csrr	a5,sstatus
ffffffffc0207cfe:	8b89                	andi	a5,a5,2
ffffffffc0207d00:	0e079b63          	bnez	a5,ffffffffc0207df6 <run_timer_list+0x106>
ffffffffc0207d04:	0008e997          	auipc	s3,0x8e
ffffffffc0207d08:	aec98993          	addi	s3,s3,-1300 # ffffffffc02957f0 <timer_list>
ffffffffc0207d0c:	0089b403          	ld	s0,8(s3)
ffffffffc0207d10:	4a01                	li	s4,0
ffffffffc0207d12:	0d340463          	beq	s0,s3,ffffffffc0207dda <run_timer_list+0xea>
ffffffffc0207d16:	ff042783          	lw	a5,-16(s0)
ffffffffc0207d1a:	12078763          	beqz	a5,ffffffffc0207e48 <run_timer_list+0x158>
ffffffffc0207d1e:	e84a                	sd	s2,16(sp)
ffffffffc0207d20:	37fd                	addiw	a5,a5,-1
ffffffffc0207d22:	fef42823          	sw	a5,-16(s0)
ffffffffc0207d26:	ff040913          	addi	s2,s0,-16
ffffffffc0207d2a:	efb1                	bnez	a5,ffffffffc0207d86 <run_timer_list+0x96>
ffffffffc0207d2c:	ec26                	sd	s1,24(sp)
ffffffffc0207d2e:	a005                	j	ffffffffc0207d4e <run_timer_list+0x5e>
ffffffffc0207d30:	0e07dc63          	bgez	a5,ffffffffc0207e28 <run_timer_list+0x138>
ffffffffc0207d34:	8526                	mv	a0,s1
ffffffffc0207d36:	cb9ff0ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc0207d3a:	854a                	mv	a0,s2
ffffffffc0207d3c:	f27ff0ef          	jal	ffffffffc0207c62 <del_timer>
ffffffffc0207d40:	05340263          	beq	s0,s3,ffffffffc0207d84 <run_timer_list+0x94>
ffffffffc0207d44:	ff042783          	lw	a5,-16(s0)
ffffffffc0207d48:	ff040913          	addi	s2,s0,-16
ffffffffc0207d4c:	ef85                	bnez	a5,ffffffffc0207d84 <run_timer_list+0x94>
ffffffffc0207d4e:	00893483          	ld	s1,8(s2)
ffffffffc0207d52:	6400                	ld	s0,8(s0)
ffffffffc0207d54:	0ec4a783          	lw	a5,236(s1)
ffffffffc0207d58:	ffe1                	bnez	a5,ffffffffc0207d30 <run_timer_list+0x40>
ffffffffc0207d5a:	40d4                	lw	a3,4(s1)
ffffffffc0207d5c:	00006617          	auipc	a2,0x6
ffffffffc0207d60:	3f460613          	addi	a2,a2,1012 # ffffffffc020e150 <etext+0x233c>
ffffffffc0207d64:	0bb00593          	li	a1,187
ffffffffc0207d68:	00006517          	auipc	a0,0x6
ffffffffc0207d6c:	31850513          	addi	a0,a0,792 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207d70:	f44f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207d74:	8526                	mv	a0,s1
ffffffffc0207d76:	c79ff0ef          	jal	ffffffffc02079ee <wakeup_proc>
ffffffffc0207d7a:	854a                	mv	a0,s2
ffffffffc0207d7c:	ee7ff0ef          	jal	ffffffffc0207c62 <del_timer>
ffffffffc0207d80:	fd3412e3          	bne	s0,s3,ffffffffc0207d44 <run_timer_list+0x54>
ffffffffc0207d84:	64e2                	ld	s1,24(sp)
ffffffffc0207d86:	0008f597          	auipc	a1,0x8f
ffffffffc0207d8a:	b425b583          	ld	a1,-1214(a1) # ffffffffc02968c8 <current>
ffffffffc0207d8e:	cd85                	beqz	a1,ffffffffc0207dc6 <run_timer_list+0xd6>
ffffffffc0207d90:	0008f797          	auipc	a5,0x8f
ffffffffc0207d94:	b487b783          	ld	a5,-1208(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207d98:	02f58563          	beq	a1,a5,ffffffffc0207dc2 <run_timer_list+0xd2>
ffffffffc0207d9c:	6942                	ld	s2,16(sp)
ffffffffc0207d9e:	0008f797          	auipc	a5,0x8f
ffffffffc0207da2:	b4a7b783          	ld	a5,-1206(a5) # ffffffffc02968e8 <sched_class>
ffffffffc0207da6:	0008f517          	auipc	a0,0x8f
ffffffffc0207daa:	b3a53503          	ld	a0,-1222(a0) # ffffffffc02968e0 <rq>
ffffffffc0207dae:	779c                	ld	a5,40(a5)
ffffffffc0207db0:	9782                	jalr	a5
ffffffffc0207db2:	000a1d63          	bnez	s4,ffffffffc0207dcc <run_timer_list+0xdc>
ffffffffc0207db6:	70a2                	ld	ra,40(sp)
ffffffffc0207db8:	7402                	ld	s0,32(sp)
ffffffffc0207dba:	69a2                	ld	s3,8(sp)
ffffffffc0207dbc:	6a02                	ld	s4,0(sp)
ffffffffc0207dbe:	6145                	addi	sp,sp,48
ffffffffc0207dc0:	8082                	ret
ffffffffc0207dc2:	4785                	li	a5,1
ffffffffc0207dc4:	ed9c                	sd	a5,24(a1)
ffffffffc0207dc6:	6942                	ld	s2,16(sp)
ffffffffc0207dc8:	fe0a07e3          	beqz	s4,ffffffffc0207db6 <run_timer_list+0xc6>
ffffffffc0207dcc:	7402                	ld	s0,32(sp)
ffffffffc0207dce:	70a2                	ld	ra,40(sp)
ffffffffc0207dd0:	69a2                	ld	s3,8(sp)
ffffffffc0207dd2:	6a02                	ld	s4,0(sp)
ffffffffc0207dd4:	6145                	addi	sp,sp,48
ffffffffc0207dd6:	dfdf806f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0207dda:	0008f597          	auipc	a1,0x8f
ffffffffc0207dde:	aee5b583          	ld	a1,-1298(a1) # ffffffffc02968c8 <current>
ffffffffc0207de2:	d9f1                	beqz	a1,ffffffffc0207db6 <run_timer_list+0xc6>
ffffffffc0207de4:	0008f797          	auipc	a5,0x8f
ffffffffc0207de8:	af47b783          	ld	a5,-1292(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207dec:	fab799e3          	bne	a5,a1,ffffffffc0207d9e <run_timer_list+0xae>
ffffffffc0207df0:	4705                	li	a4,1
ffffffffc0207df2:	ef98                	sd	a4,24(a5)
ffffffffc0207df4:	b7c9                	j	ffffffffc0207db6 <run_timer_list+0xc6>
ffffffffc0207df6:	0008e997          	auipc	s3,0x8e
ffffffffc0207dfa:	9fa98993          	addi	s3,s3,-1542 # ffffffffc02957f0 <timer_list>
ffffffffc0207dfe:	ddbf80ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0207e02:	0089b403          	ld	s0,8(s3)
ffffffffc0207e06:	4a05                	li	s4,1
ffffffffc0207e08:	f13417e3          	bne	s0,s3,ffffffffc0207d16 <run_timer_list+0x26>
ffffffffc0207e0c:	0008f597          	auipc	a1,0x8f
ffffffffc0207e10:	abc5b583          	ld	a1,-1348(a1) # ffffffffc02968c8 <current>
ffffffffc0207e14:	ddc5                	beqz	a1,ffffffffc0207dcc <run_timer_list+0xdc>
ffffffffc0207e16:	0008f797          	auipc	a5,0x8f
ffffffffc0207e1a:	ac27b783          	ld	a5,-1342(a5) # ffffffffc02968d8 <idleproc>
ffffffffc0207e1e:	f8f590e3          	bne	a1,a5,ffffffffc0207d9e <run_timer_list+0xae>
ffffffffc0207e22:	0145bc23          	sd	s4,24(a1)
ffffffffc0207e26:	b75d                	j	ffffffffc0207dcc <run_timer_list+0xdc>
ffffffffc0207e28:	00006697          	auipc	a3,0x6
ffffffffc0207e2c:	30068693          	addi	a3,a3,768 # ffffffffc020e128 <etext+0x2314>
ffffffffc0207e30:	00004617          	auipc	a2,0x4
ffffffffc0207e34:	42060613          	addi	a2,a2,1056 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207e38:	0b700593          	li	a1,183
ffffffffc0207e3c:	00006517          	auipc	a0,0x6
ffffffffc0207e40:	24450513          	addi	a0,a0,580 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207e44:	e06f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207e48:	00006697          	auipc	a3,0x6
ffffffffc0207e4c:	2c868693          	addi	a3,a3,712 # ffffffffc020e110 <etext+0x22fc>
ffffffffc0207e50:	00004617          	auipc	a2,0x4
ffffffffc0207e54:	40060613          	addi	a2,a2,1024 # ffffffffc020c250 <etext+0x43c>
ffffffffc0207e58:	0af00593          	li	a1,175
ffffffffc0207e5c:	00006517          	auipc	a0,0x6
ffffffffc0207e60:	22450513          	addi	a0,a0,548 # ffffffffc020e080 <etext+0x226c>
ffffffffc0207e64:	ec26                	sd	s1,24(sp)
ffffffffc0207e66:	e84a                	sd	s2,16(sp)
ffffffffc0207e68:	de2f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207e6c <sys_getpid>:
ffffffffc0207e6c:	0008f797          	auipc	a5,0x8f
ffffffffc0207e70:	a5c7b783          	ld	a5,-1444(a5) # ffffffffc02968c8 <current>
ffffffffc0207e74:	43c8                	lw	a0,4(a5)
ffffffffc0207e76:	8082                	ret

ffffffffc0207e78 <sys_pgdir>:
ffffffffc0207e78:	4501                	li	a0,0
ffffffffc0207e7a:	8082                	ret

ffffffffc0207e7c <sys_gettime>:
ffffffffc0207e7c:	0008f797          	auipc	a5,0x8f
ffffffffc0207e80:	9f47b783          	ld	a5,-1548(a5) # ffffffffc0296870 <ticks>
ffffffffc0207e84:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207e88:	9d3d                	addw	a0,a0,a5
ffffffffc0207e8a:	0015151b          	slliw	a0,a0,0x1
ffffffffc0207e8e:	8082                	ret

ffffffffc0207e90 <sys_lab6_set_priority>:
ffffffffc0207e90:	4108                	lw	a0,0(a0)
ffffffffc0207e92:	1141                	addi	sp,sp,-16
ffffffffc0207e94:	e406                	sd	ra,8(sp)
ffffffffc0207e96:	bccff0ef          	jal	ffffffffc0207262 <lab6_set_priority>
ffffffffc0207e9a:	60a2                	ld	ra,8(sp)
ffffffffc0207e9c:	4501                	li	a0,0
ffffffffc0207e9e:	0141                	addi	sp,sp,16
ffffffffc0207ea0:	8082                	ret

ffffffffc0207ea2 <sys_dup>:
ffffffffc0207ea2:	450c                	lw	a1,8(a0)
ffffffffc0207ea4:	4108                	lw	a0,0(a0)
ffffffffc0207ea6:	c95fd06f          	j	ffffffffc0205b3a <sysfile_dup>

ffffffffc0207eaa <sys_getdirentry>:
ffffffffc0207eaa:	650c                	ld	a1,8(a0)
ffffffffc0207eac:	4108                	lw	a0,0(a0)
ffffffffc0207eae:	b9dfd06f          	j	ffffffffc0205a4a <sysfile_getdirentry>

ffffffffc0207eb2 <sys_getcwd>:
ffffffffc0207eb2:	650c                	ld	a1,8(a0)
ffffffffc0207eb4:	6108                	ld	a0,0(a0)
ffffffffc0207eb6:	aebfd06f          	j	ffffffffc02059a0 <sysfile_getcwd>

ffffffffc0207eba <sys_fsync>:
ffffffffc0207eba:	4108                	lw	a0,0(a0)
ffffffffc0207ebc:	ae1fd06f          	j	ffffffffc020599c <sysfile_fsync>

ffffffffc0207ec0 <sys_fstat>:
ffffffffc0207ec0:	650c                	ld	a1,8(a0)
ffffffffc0207ec2:	4108                	lw	a0,0(a0)
ffffffffc0207ec4:	a51fd06f          	j	ffffffffc0205914 <sysfile_fstat>

ffffffffc0207ec8 <sys_seek>:
ffffffffc0207ec8:	4910                	lw	a2,16(a0)
ffffffffc0207eca:	650c                	ld	a1,8(a0)
ffffffffc0207ecc:	4108                	lw	a0,0(a0)
ffffffffc0207ece:	a43fd06f          	j	ffffffffc0205910 <sysfile_seek>

ffffffffc0207ed2 <sys_write>:
ffffffffc0207ed2:	6910                	ld	a2,16(a0)
ffffffffc0207ed4:	650c                	ld	a1,8(a0)
ffffffffc0207ed6:	4108                	lw	a0,0(a0)
ffffffffc0207ed8:	907fd06f          	j	ffffffffc02057de <sysfile_write>

ffffffffc0207edc <sys_read>:
ffffffffc0207edc:	6910                	ld	a2,16(a0)
ffffffffc0207ede:	650c                	ld	a1,8(a0)
ffffffffc0207ee0:	4108                	lw	a0,0(a0)
ffffffffc0207ee2:	fb0fd06f          	j	ffffffffc0205692 <sysfile_read>

ffffffffc0207ee6 <sys_close>:
ffffffffc0207ee6:	4108                	lw	a0,0(a0)
ffffffffc0207ee8:	fa6fd06f          	j	ffffffffc020568e <sysfile_close>

ffffffffc0207eec <sys_open>:
ffffffffc0207eec:	450c                	lw	a1,8(a0)
ffffffffc0207eee:	6108                	ld	a0,0(a0)
ffffffffc0207ef0:	f68fd06f          	j	ffffffffc0205658 <sysfile_open>

ffffffffc0207ef4 <sys_putc>:
ffffffffc0207ef4:	4108                	lw	a0,0(a0)
ffffffffc0207ef6:	1141                	addi	sp,sp,-16
ffffffffc0207ef8:	e406                	sd	ra,8(sp)
ffffffffc0207efa:	ae6f80ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc0207efe:	60a2                	ld	ra,8(sp)
ffffffffc0207f00:	4501                	li	a0,0
ffffffffc0207f02:	0141                	addi	sp,sp,16
ffffffffc0207f04:	8082                	ret

ffffffffc0207f06 <sys_kill>:
ffffffffc0207f06:	4108                	lw	a0,0(a0)
ffffffffc0207f08:	8f4ff06f          	j	ffffffffc0206ffc <do_kill>

ffffffffc0207f0c <sys_sleep>:
ffffffffc0207f0c:	4108                	lw	a0,0(a0)
ffffffffc0207f0e:	b82ff06f          	j	ffffffffc0207290 <do_sleep>

ffffffffc0207f12 <sys_yield>:
ffffffffc0207f12:	8a0ff06f          	j	ffffffffc0206fb2 <do_yield>

ffffffffc0207f16 <sys_exec>:
ffffffffc0207f16:	6910                	ld	a2,16(a0)
ffffffffc0207f18:	450c                	lw	a1,8(a0)
ffffffffc0207f1a:	6108                	ld	a0,0(a0)
ffffffffc0207f1c:	fd8fe06f          	j	ffffffffc02066f4 <do_execve>

ffffffffc0207f20 <sys_wait>:
ffffffffc0207f20:	650c                	ld	a1,8(a0)
ffffffffc0207f22:	4108                	lw	a0,0(a0)
ffffffffc0207f24:	89eff06f          	j	ffffffffc0206fc2 <do_wait>

ffffffffc0207f28 <sys_fork>:
ffffffffc0207f28:	0008f797          	auipc	a5,0x8f
ffffffffc0207f2c:	9a07b783          	ld	a5,-1632(a5) # ffffffffc02968c8 <current>
ffffffffc0207f30:	4501                	li	a0,0
ffffffffc0207f32:	73d0                	ld	a2,160(a5)
ffffffffc0207f34:	6a0c                	ld	a1,16(a2)
ffffffffc0207f36:	f17fd06f          	j	ffffffffc0205e4c <do_fork>

ffffffffc0207f3a <sys_exit>:
ffffffffc0207f3a:	4108                	lw	a0,0(a0)
ffffffffc0207f3c:	b26fe06f          	j	ffffffffc0206262 <do_exit>

ffffffffc0207f40 <syscall>:
ffffffffc0207f40:	0008f697          	auipc	a3,0x8f
ffffffffc0207f44:	9886b683          	ld	a3,-1656(a3) # ffffffffc02968c8 <current>
ffffffffc0207f48:	715d                	addi	sp,sp,-80
ffffffffc0207f4a:	e0a2                	sd	s0,64(sp)
ffffffffc0207f4c:	72c0                	ld	s0,160(a3)
ffffffffc0207f4e:	e486                	sd	ra,72(sp)
ffffffffc0207f50:	0ff00793          	li	a5,255
ffffffffc0207f54:	4834                	lw	a3,80(s0)
ffffffffc0207f56:	02d7ec63          	bltu	a5,a3,ffffffffc0207f8e <syscall+0x4e>
ffffffffc0207f5a:	00007797          	auipc	a5,0x7
ffffffffc0207f5e:	49e78793          	addi	a5,a5,1182 # ffffffffc020f3f8 <syscalls>
ffffffffc0207f62:	00369613          	slli	a2,a3,0x3
ffffffffc0207f66:	97b2                	add	a5,a5,a2
ffffffffc0207f68:	639c                	ld	a5,0(a5)
ffffffffc0207f6a:	c395                	beqz	a5,ffffffffc0207f8e <syscall+0x4e>
ffffffffc0207f6c:	7028                	ld	a0,96(s0)
ffffffffc0207f6e:	742c                	ld	a1,104(s0)
ffffffffc0207f70:	7830                	ld	a2,112(s0)
ffffffffc0207f72:	7c34                	ld	a3,120(s0)
ffffffffc0207f74:	6c38                	ld	a4,88(s0)
ffffffffc0207f76:	f02a                	sd	a0,32(sp)
ffffffffc0207f78:	f42e                	sd	a1,40(sp)
ffffffffc0207f7a:	f832                	sd	a2,48(sp)
ffffffffc0207f7c:	fc36                	sd	a3,56(sp)
ffffffffc0207f7e:	ec3a                	sd	a4,24(sp)
ffffffffc0207f80:	0828                	addi	a0,sp,24
ffffffffc0207f82:	9782                	jalr	a5
ffffffffc0207f84:	60a6                	ld	ra,72(sp)
ffffffffc0207f86:	e828                	sd	a0,80(s0)
ffffffffc0207f88:	6406                	ld	s0,64(sp)
ffffffffc0207f8a:	6161                	addi	sp,sp,80
ffffffffc0207f8c:	8082                	ret
ffffffffc0207f8e:	8522                	mv	a0,s0
ffffffffc0207f90:	e436                	sd	a3,8(sp)
ffffffffc0207f92:	f5bf80ef          	jal	ffffffffc0200eec <print_trapframe>
ffffffffc0207f96:	0008f797          	auipc	a5,0x8f
ffffffffc0207f9a:	9327b783          	ld	a5,-1742(a5) # ffffffffc02968c8 <current>
ffffffffc0207f9e:	66a2                	ld	a3,8(sp)
ffffffffc0207fa0:	00006617          	auipc	a2,0x6
ffffffffc0207fa4:	1d060613          	addi	a2,a2,464 # ffffffffc020e170 <etext+0x235c>
ffffffffc0207fa8:	43d8                	lw	a4,4(a5)
ffffffffc0207faa:	0d800593          	li	a1,216
ffffffffc0207fae:	0b478793          	addi	a5,a5,180
ffffffffc0207fb2:	00006517          	auipc	a0,0x6
ffffffffc0207fb6:	1ee50513          	addi	a0,a0,494 # ffffffffc020e1a0 <etext+0x238c>
ffffffffc0207fba:	c90f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207fbe <__alloc_inode>:
ffffffffc0207fbe:	1141                	addi	sp,sp,-16
ffffffffc0207fc0:	e022                	sd	s0,0(sp)
ffffffffc0207fc2:	842a                	mv	s0,a0
ffffffffc0207fc4:	07800513          	li	a0,120
ffffffffc0207fc8:	e406                	sd	ra,8(sp)
ffffffffc0207fca:	832fa0ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0207fce:	c111                	beqz	a0,ffffffffc0207fd2 <__alloc_inode+0x14>
ffffffffc0207fd0:	cd20                	sw	s0,88(a0)
ffffffffc0207fd2:	60a2                	ld	ra,8(sp)
ffffffffc0207fd4:	6402                	ld	s0,0(sp)
ffffffffc0207fd6:	0141                	addi	sp,sp,16
ffffffffc0207fd8:	8082                	ret

ffffffffc0207fda <inode_init>:
ffffffffc0207fda:	4785                	li	a5,1
ffffffffc0207fdc:	06052023          	sw	zero,96(a0)
ffffffffc0207fe0:	f92c                	sd	a1,112(a0)
ffffffffc0207fe2:	f530                	sd	a2,104(a0)
ffffffffc0207fe4:	cd7c                	sw	a5,92(a0)
ffffffffc0207fe6:	8082                	ret

ffffffffc0207fe8 <inode_kill>:
ffffffffc0207fe8:	4d78                	lw	a4,92(a0)
ffffffffc0207fea:	1141                	addi	sp,sp,-16
ffffffffc0207fec:	e406                	sd	ra,8(sp)
ffffffffc0207fee:	e719                	bnez	a4,ffffffffc0207ffc <inode_kill+0x14>
ffffffffc0207ff0:	513c                	lw	a5,96(a0)
ffffffffc0207ff2:	e78d                	bnez	a5,ffffffffc020801c <inode_kill+0x34>
ffffffffc0207ff4:	60a2                	ld	ra,8(sp)
ffffffffc0207ff6:	0141                	addi	sp,sp,16
ffffffffc0207ff8:	8aafa06f          	j	ffffffffc02020a2 <kfree>
ffffffffc0207ffc:	00006697          	auipc	a3,0x6
ffffffffc0208000:	1bc68693          	addi	a3,a3,444 # ffffffffc020e1b8 <etext+0x23a4>
ffffffffc0208004:	00004617          	auipc	a2,0x4
ffffffffc0208008:	24c60613          	addi	a2,a2,588 # ffffffffc020c250 <etext+0x43c>
ffffffffc020800c:	02900593          	li	a1,41
ffffffffc0208010:	00006517          	auipc	a0,0x6
ffffffffc0208014:	1c850513          	addi	a0,a0,456 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208018:	c32f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020801c:	00006697          	auipc	a3,0x6
ffffffffc0208020:	1d468693          	addi	a3,a3,468 # ffffffffc020e1f0 <etext+0x23dc>
ffffffffc0208024:	00004617          	auipc	a2,0x4
ffffffffc0208028:	22c60613          	addi	a2,a2,556 # ffffffffc020c250 <etext+0x43c>
ffffffffc020802c:	02a00593          	li	a1,42
ffffffffc0208030:	00006517          	auipc	a0,0x6
ffffffffc0208034:	1a850513          	addi	a0,a0,424 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208038:	c12f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020803c <inode_ref_inc>:
ffffffffc020803c:	4d7c                	lw	a5,92(a0)
ffffffffc020803e:	2785                	addiw	a5,a5,1
ffffffffc0208040:	cd7c                	sw	a5,92(a0)
ffffffffc0208042:	853e                	mv	a0,a5
ffffffffc0208044:	8082                	ret

ffffffffc0208046 <inode_open_inc>:
ffffffffc0208046:	513c                	lw	a5,96(a0)
ffffffffc0208048:	2785                	addiw	a5,a5,1
ffffffffc020804a:	d13c                	sw	a5,96(a0)
ffffffffc020804c:	853e                	mv	a0,a5
ffffffffc020804e:	8082                	ret

ffffffffc0208050 <inode_check>:
ffffffffc0208050:	1141                	addi	sp,sp,-16
ffffffffc0208052:	e406                	sd	ra,8(sp)
ffffffffc0208054:	c91d                	beqz	a0,ffffffffc020808a <inode_check+0x3a>
ffffffffc0208056:	793c                	ld	a5,112(a0)
ffffffffc0208058:	cb8d                	beqz	a5,ffffffffc020808a <inode_check+0x3a>
ffffffffc020805a:	6398                	ld	a4,0(a5)
ffffffffc020805c:	4625d7b7          	lui	a5,0x4625d
ffffffffc0208060:	0786                	slli	a5,a5,0x1
ffffffffc0208062:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0208066:	08f71263          	bne	a4,a5,ffffffffc02080ea <inode_check+0x9a>
ffffffffc020806a:	4d74                	lw	a3,92(a0)
ffffffffc020806c:	5138                	lw	a4,96(a0)
ffffffffc020806e:	04e6ce63          	blt	a3,a4,ffffffffc02080ca <inode_check+0x7a>
ffffffffc0208072:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0208076:	ebb1                	bnez	a5,ffffffffc02080ca <inode_check+0x7a>
ffffffffc0208078:	67c1                	lui	a5,0x10
ffffffffc020807a:	17fd                	addi	a5,a5,-1 # ffff <_binary_bin_swap_img_size+0x82ff>
ffffffffc020807c:	02d7c763          	blt	a5,a3,ffffffffc02080aa <inode_check+0x5a>
ffffffffc0208080:	02e7c563          	blt	a5,a4,ffffffffc02080aa <inode_check+0x5a>
ffffffffc0208084:	60a2                	ld	ra,8(sp)
ffffffffc0208086:	0141                	addi	sp,sp,16
ffffffffc0208088:	8082                	ret
ffffffffc020808a:	00006697          	auipc	a3,0x6
ffffffffc020808e:	18668693          	addi	a3,a3,390 # ffffffffc020e210 <etext+0x23fc>
ffffffffc0208092:	00004617          	auipc	a2,0x4
ffffffffc0208096:	1be60613          	addi	a2,a2,446 # ffffffffc020c250 <etext+0x43c>
ffffffffc020809a:	06e00593          	li	a1,110
ffffffffc020809e:	00006517          	auipc	a0,0x6
ffffffffc02080a2:	13a50513          	addi	a0,a0,314 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc02080a6:	ba4f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080aa:	00006697          	auipc	a3,0x6
ffffffffc02080ae:	1e668693          	addi	a3,a3,486 # ffffffffc020e290 <etext+0x247c>
ffffffffc02080b2:	00004617          	auipc	a2,0x4
ffffffffc02080b6:	19e60613          	addi	a2,a2,414 # ffffffffc020c250 <etext+0x43c>
ffffffffc02080ba:	07200593          	li	a1,114
ffffffffc02080be:	00006517          	auipc	a0,0x6
ffffffffc02080c2:	11a50513          	addi	a0,a0,282 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc02080c6:	b84f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080ca:	00006697          	auipc	a3,0x6
ffffffffc02080ce:	19668693          	addi	a3,a3,406 # ffffffffc020e260 <etext+0x244c>
ffffffffc02080d2:	00004617          	auipc	a2,0x4
ffffffffc02080d6:	17e60613          	addi	a2,a2,382 # ffffffffc020c250 <etext+0x43c>
ffffffffc02080da:	07100593          	li	a1,113
ffffffffc02080de:	00006517          	auipc	a0,0x6
ffffffffc02080e2:	0fa50513          	addi	a0,a0,250 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc02080e6:	b64f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080ea:	00006697          	auipc	a3,0x6
ffffffffc02080ee:	14e68693          	addi	a3,a3,334 # ffffffffc020e238 <etext+0x2424>
ffffffffc02080f2:	00004617          	auipc	a2,0x4
ffffffffc02080f6:	15e60613          	addi	a2,a2,350 # ffffffffc020c250 <etext+0x43c>
ffffffffc02080fa:	06f00593          	li	a1,111
ffffffffc02080fe:	00006517          	auipc	a0,0x6
ffffffffc0208102:	0da50513          	addi	a0,a0,218 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208106:	b44f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020810a <inode_ref_dec>:
ffffffffc020810a:	4d7c                	lw	a5,92(a0)
ffffffffc020810c:	7179                	addi	sp,sp,-48
ffffffffc020810e:	f406                	sd	ra,40(sp)
ffffffffc0208110:	06f05b63          	blez	a5,ffffffffc0208186 <inode_ref_dec+0x7c>
ffffffffc0208114:	37fd                	addiw	a5,a5,-1
ffffffffc0208116:	cd7c                	sw	a5,92(a0)
ffffffffc0208118:	e795                	bnez	a5,ffffffffc0208144 <inode_ref_dec+0x3a>
ffffffffc020811a:	7934                	ld	a3,112(a0)
ffffffffc020811c:	c6a9                	beqz	a3,ffffffffc0208166 <inode_ref_dec+0x5c>
ffffffffc020811e:	66b4                	ld	a3,72(a3)
ffffffffc0208120:	c2b9                	beqz	a3,ffffffffc0208166 <inode_ref_dec+0x5c>
ffffffffc0208122:	00006597          	auipc	a1,0x6
ffffffffc0208126:	21e58593          	addi	a1,a1,542 # ffffffffc020e340 <etext+0x252c>
ffffffffc020812a:	e83e                	sd	a5,16(sp)
ffffffffc020812c:	ec2a                	sd	a0,24(sp)
ffffffffc020812e:	e436                	sd	a3,8(sp)
ffffffffc0208130:	f21ff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208134:	6562                	ld	a0,24(sp)
ffffffffc0208136:	66a2                	ld	a3,8(sp)
ffffffffc0208138:	9682                	jalr	a3
ffffffffc020813a:	00f50713          	addi	a4,a0,15
ffffffffc020813e:	67c2                	ld	a5,16(sp)
ffffffffc0208140:	c311                	beqz	a4,ffffffffc0208144 <inode_ref_dec+0x3a>
ffffffffc0208142:	e509                	bnez	a0,ffffffffc020814c <inode_ref_dec+0x42>
ffffffffc0208144:	70a2                	ld	ra,40(sp)
ffffffffc0208146:	853e                	mv	a0,a5
ffffffffc0208148:	6145                	addi	sp,sp,48
ffffffffc020814a:	8082                	ret
ffffffffc020814c:	85aa                	mv	a1,a0
ffffffffc020814e:	00006517          	auipc	a0,0x6
ffffffffc0208152:	1fa50513          	addi	a0,a0,506 # ffffffffc020e348 <etext+0x2534>
ffffffffc0208156:	e43e                	sd	a5,8(sp)
ffffffffc0208158:	84ef80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020815c:	67a2                	ld	a5,8(sp)
ffffffffc020815e:	70a2                	ld	ra,40(sp)
ffffffffc0208160:	853e                	mv	a0,a5
ffffffffc0208162:	6145                	addi	sp,sp,48
ffffffffc0208164:	8082                	ret
ffffffffc0208166:	00006697          	auipc	a3,0x6
ffffffffc020816a:	18a68693          	addi	a3,a3,394 # ffffffffc020e2f0 <etext+0x24dc>
ffffffffc020816e:	00004617          	auipc	a2,0x4
ffffffffc0208172:	0e260613          	addi	a2,a2,226 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208176:	04400593          	li	a1,68
ffffffffc020817a:	00006517          	auipc	a0,0x6
ffffffffc020817e:	05e50513          	addi	a0,a0,94 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208182:	ac8f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208186:	00006697          	auipc	a3,0x6
ffffffffc020818a:	14a68693          	addi	a3,a3,330 # ffffffffc020e2d0 <etext+0x24bc>
ffffffffc020818e:	00004617          	auipc	a2,0x4
ffffffffc0208192:	0c260613          	addi	a2,a2,194 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208196:	03f00593          	li	a1,63
ffffffffc020819a:	00006517          	auipc	a0,0x6
ffffffffc020819e:	03e50513          	addi	a0,a0,62 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc02081a2:	aa8f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02081a6 <inode_open_dec>:
ffffffffc02081a6:	513c                	lw	a5,96(a0)
ffffffffc02081a8:	7179                	addi	sp,sp,-48
ffffffffc02081aa:	f406                	sd	ra,40(sp)
ffffffffc02081ac:	06f05863          	blez	a5,ffffffffc020821c <inode_open_dec+0x76>
ffffffffc02081b0:	37fd                	addiw	a5,a5,-1
ffffffffc02081b2:	d13c                	sw	a5,96(a0)
ffffffffc02081b4:	e39d                	bnez	a5,ffffffffc02081da <inode_open_dec+0x34>
ffffffffc02081b6:	7934                	ld	a3,112(a0)
ffffffffc02081b8:	c2b1                	beqz	a3,ffffffffc02081fc <inode_open_dec+0x56>
ffffffffc02081ba:	6a94                	ld	a3,16(a3)
ffffffffc02081bc:	c2a1                	beqz	a3,ffffffffc02081fc <inode_open_dec+0x56>
ffffffffc02081be:	00006597          	auipc	a1,0x6
ffffffffc02081c2:	21a58593          	addi	a1,a1,538 # ffffffffc020e3d8 <etext+0x25c4>
ffffffffc02081c6:	e83e                	sd	a5,16(sp)
ffffffffc02081c8:	ec2a                	sd	a0,24(sp)
ffffffffc02081ca:	e436                	sd	a3,8(sp)
ffffffffc02081cc:	e85ff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc02081d0:	6562                	ld	a0,24(sp)
ffffffffc02081d2:	66a2                	ld	a3,8(sp)
ffffffffc02081d4:	9682                	jalr	a3
ffffffffc02081d6:	67c2                	ld	a5,16(sp)
ffffffffc02081d8:	e509                	bnez	a0,ffffffffc02081e2 <inode_open_dec+0x3c>
ffffffffc02081da:	70a2                	ld	ra,40(sp)
ffffffffc02081dc:	853e                	mv	a0,a5
ffffffffc02081de:	6145                	addi	sp,sp,48
ffffffffc02081e0:	8082                	ret
ffffffffc02081e2:	85aa                	mv	a1,a0
ffffffffc02081e4:	00006517          	auipc	a0,0x6
ffffffffc02081e8:	1fc50513          	addi	a0,a0,508 # ffffffffc020e3e0 <etext+0x25cc>
ffffffffc02081ec:	e43e                	sd	a5,8(sp)
ffffffffc02081ee:	fb9f70ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02081f2:	67a2                	ld	a5,8(sp)
ffffffffc02081f4:	70a2                	ld	ra,40(sp)
ffffffffc02081f6:	853e                	mv	a0,a5
ffffffffc02081f8:	6145                	addi	sp,sp,48
ffffffffc02081fa:	8082                	ret
ffffffffc02081fc:	00006697          	auipc	a3,0x6
ffffffffc0208200:	18c68693          	addi	a3,a3,396 # ffffffffc020e388 <etext+0x2574>
ffffffffc0208204:	00004617          	auipc	a2,0x4
ffffffffc0208208:	04c60613          	addi	a2,a2,76 # ffffffffc020c250 <etext+0x43c>
ffffffffc020820c:	06100593          	li	a1,97
ffffffffc0208210:	00006517          	auipc	a0,0x6
ffffffffc0208214:	fc850513          	addi	a0,a0,-56 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208218:	a32f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020821c:	00006697          	auipc	a3,0x6
ffffffffc0208220:	14c68693          	addi	a3,a3,332 # ffffffffc020e368 <etext+0x2554>
ffffffffc0208224:	00004617          	auipc	a2,0x4
ffffffffc0208228:	02c60613          	addi	a2,a2,44 # ffffffffc020c250 <etext+0x43c>
ffffffffc020822c:	05c00593          	li	a1,92
ffffffffc0208230:	00006517          	auipc	a0,0x6
ffffffffc0208234:	fa850513          	addi	a0,a0,-88 # ffffffffc020e1d8 <etext+0x23c4>
ffffffffc0208238:	a12f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020823c <__alloc_fs>:
ffffffffc020823c:	1141                	addi	sp,sp,-16
ffffffffc020823e:	e022                	sd	s0,0(sp)
ffffffffc0208240:	842a                	mv	s0,a0
ffffffffc0208242:	0d800513          	li	a0,216
ffffffffc0208246:	e406                	sd	ra,8(sp)
ffffffffc0208248:	db5f90ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020824c:	c119                	beqz	a0,ffffffffc0208252 <__alloc_fs+0x16>
ffffffffc020824e:	0a852823          	sw	s0,176(a0)
ffffffffc0208252:	60a2                	ld	ra,8(sp)
ffffffffc0208254:	6402                	ld	s0,0(sp)
ffffffffc0208256:	0141                	addi	sp,sp,16
ffffffffc0208258:	8082                	ret

ffffffffc020825a <vfs_init>:
ffffffffc020825a:	1141                	addi	sp,sp,-16
ffffffffc020825c:	4585                	li	a1,1
ffffffffc020825e:	0008d517          	auipc	a0,0x8d
ffffffffc0208262:	5a250513          	addi	a0,a0,1442 # ffffffffc0295800 <bootfs_sem>
ffffffffc0208266:	e406                	sd	ra,8(sp)
ffffffffc0208268:	c08fc0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc020826c:	60a2                	ld	ra,8(sp)
ffffffffc020826e:	0141                	addi	sp,sp,16
ffffffffc0208270:	a4b1                	j	ffffffffc02084bc <vfs_devlist_init>

ffffffffc0208272 <vfs_set_bootfs>:
ffffffffc0208272:	7179                	addi	sp,sp,-48
ffffffffc0208274:	f022                	sd	s0,32(sp)
ffffffffc0208276:	f406                	sd	ra,40(sp)
ffffffffc0208278:	ec02                	sd	zero,24(sp)
ffffffffc020827a:	842a                	mv	s0,a0
ffffffffc020827c:	c515                	beqz	a0,ffffffffc02082a8 <vfs_set_bootfs+0x36>
ffffffffc020827e:	03a00593          	li	a1,58
ffffffffc0208282:	319030ef          	jal	ffffffffc020bd9a <strchr>
ffffffffc0208286:	c125                	beqz	a0,ffffffffc02082e6 <vfs_set_bootfs+0x74>
ffffffffc0208288:	00154783          	lbu	a5,1(a0)
ffffffffc020828c:	efa9                	bnez	a5,ffffffffc02082e6 <vfs_set_bootfs+0x74>
ffffffffc020828e:	8522                	mv	a0,s0
ffffffffc0208290:	163000ef          	jal	ffffffffc0208bf2 <vfs_chdir>
ffffffffc0208294:	c509                	beqz	a0,ffffffffc020829e <vfs_set_bootfs+0x2c>
ffffffffc0208296:	70a2                	ld	ra,40(sp)
ffffffffc0208298:	7402                	ld	s0,32(sp)
ffffffffc020829a:	6145                	addi	sp,sp,48
ffffffffc020829c:	8082                	ret
ffffffffc020829e:	0828                	addi	a0,sp,24
ffffffffc02082a0:	05f000ef          	jal	ffffffffc0208afe <vfs_get_curdir>
ffffffffc02082a4:	f96d                	bnez	a0,ffffffffc0208296 <vfs_set_bootfs+0x24>
ffffffffc02082a6:	6462                	ld	s0,24(sp)
ffffffffc02082a8:	0008d517          	auipc	a0,0x8d
ffffffffc02082ac:	55850513          	addi	a0,a0,1368 # ffffffffc0295800 <bootfs_sem>
ffffffffc02082b0:	bcafc0ef          	jal	ffffffffc020467a <down>
ffffffffc02082b4:	0008e797          	auipc	a5,0x8e
ffffffffc02082b8:	63c7b783          	ld	a5,1596(a5) # ffffffffc02968f0 <bootfs_node>
ffffffffc02082bc:	0008d517          	auipc	a0,0x8d
ffffffffc02082c0:	54450513          	addi	a0,a0,1348 # ffffffffc0295800 <bootfs_sem>
ffffffffc02082c4:	0008e717          	auipc	a4,0x8e
ffffffffc02082c8:	62873623          	sd	s0,1580(a4) # ffffffffc02968f0 <bootfs_node>
ffffffffc02082cc:	e43e                	sd	a5,8(sp)
ffffffffc02082ce:	ba8fc0ef          	jal	ffffffffc0204676 <up>
ffffffffc02082d2:	67a2                	ld	a5,8(sp)
ffffffffc02082d4:	c781                	beqz	a5,ffffffffc02082dc <vfs_set_bootfs+0x6a>
ffffffffc02082d6:	853e                	mv	a0,a5
ffffffffc02082d8:	e33ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc02082dc:	70a2                	ld	ra,40(sp)
ffffffffc02082de:	7402                	ld	s0,32(sp)
ffffffffc02082e0:	4501                	li	a0,0
ffffffffc02082e2:	6145                	addi	sp,sp,48
ffffffffc02082e4:	8082                	ret
ffffffffc02082e6:	5575                	li	a0,-3
ffffffffc02082e8:	b77d                	j	ffffffffc0208296 <vfs_set_bootfs+0x24>

ffffffffc02082ea <vfs_get_bootfs>:
ffffffffc02082ea:	1101                	addi	sp,sp,-32
ffffffffc02082ec:	e426                	sd	s1,8(sp)
ffffffffc02082ee:	0008e497          	auipc	s1,0x8e
ffffffffc02082f2:	60248493          	addi	s1,s1,1538 # ffffffffc02968f0 <bootfs_node>
ffffffffc02082f6:	609c                	ld	a5,0(s1)
ffffffffc02082f8:	ec06                	sd	ra,24(sp)
ffffffffc02082fa:	c3b1                	beqz	a5,ffffffffc020833e <vfs_get_bootfs+0x54>
ffffffffc02082fc:	e822                	sd	s0,16(sp)
ffffffffc02082fe:	842a                	mv	s0,a0
ffffffffc0208300:	0008d517          	auipc	a0,0x8d
ffffffffc0208304:	50050513          	addi	a0,a0,1280 # ffffffffc0295800 <bootfs_sem>
ffffffffc0208308:	b72fc0ef          	jal	ffffffffc020467a <down>
ffffffffc020830c:	6084                	ld	s1,0(s1)
ffffffffc020830e:	c08d                	beqz	s1,ffffffffc0208330 <vfs_get_bootfs+0x46>
ffffffffc0208310:	8526                	mv	a0,s1
ffffffffc0208312:	d2bff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0208316:	0008d517          	auipc	a0,0x8d
ffffffffc020831a:	4ea50513          	addi	a0,a0,1258 # ffffffffc0295800 <bootfs_sem>
ffffffffc020831e:	b58fc0ef          	jal	ffffffffc0204676 <up>
ffffffffc0208322:	60e2                	ld	ra,24(sp)
ffffffffc0208324:	e004                	sd	s1,0(s0)
ffffffffc0208326:	6442                	ld	s0,16(sp)
ffffffffc0208328:	64a2                	ld	s1,8(sp)
ffffffffc020832a:	4501                	li	a0,0
ffffffffc020832c:	6105                	addi	sp,sp,32
ffffffffc020832e:	8082                	ret
ffffffffc0208330:	0008d517          	auipc	a0,0x8d
ffffffffc0208334:	4d050513          	addi	a0,a0,1232 # ffffffffc0295800 <bootfs_sem>
ffffffffc0208338:	b3efc0ef          	jal	ffffffffc0204676 <up>
ffffffffc020833c:	6442                	ld	s0,16(sp)
ffffffffc020833e:	60e2                	ld	ra,24(sp)
ffffffffc0208340:	64a2                	ld	s1,8(sp)
ffffffffc0208342:	5541                	li	a0,-16
ffffffffc0208344:	6105                	addi	sp,sp,32
ffffffffc0208346:	8082                	ret

ffffffffc0208348 <vfs_do_add>:
ffffffffc0208348:	7139                	addi	sp,sp,-64
ffffffffc020834a:	fc06                	sd	ra,56(sp)
ffffffffc020834c:	f822                	sd	s0,48(sp)
ffffffffc020834e:	e852                	sd	s4,16(sp)
ffffffffc0208350:	e456                	sd	s5,8(sp)
ffffffffc0208352:	e05a                	sd	s6,0(sp)
ffffffffc0208354:	10050f63          	beqz	a0,ffffffffc0208472 <vfs_do_add+0x12a>
ffffffffc0208358:	00d5e7b3          	or	a5,a1,a3
ffffffffc020835c:	842a                	mv	s0,a0
ffffffffc020835e:	8a2e                	mv	s4,a1
ffffffffc0208360:	8b32                	mv	s6,a2
ffffffffc0208362:	8ab6                	mv	s5,a3
ffffffffc0208364:	cb89                	beqz	a5,ffffffffc0208376 <vfs_do_add+0x2e>
ffffffffc0208366:	0e058363          	beqz	a1,ffffffffc020844c <vfs_do_add+0x104>
ffffffffc020836a:	4db8                	lw	a4,88(a1)
ffffffffc020836c:	6785                	lui	a5,0x1
ffffffffc020836e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208372:	0cf71d63          	bne	a4,a5,ffffffffc020844c <vfs_do_add+0x104>
ffffffffc0208376:	8522                	mv	a0,s0
ffffffffc0208378:	181030ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc020837c:	47fd                	li	a5,31
ffffffffc020837e:	0ca7e263          	bltu	a5,a0,ffffffffc0208442 <vfs_do_add+0xfa>
ffffffffc0208382:	8522                	mv	a0,s0
ffffffffc0208384:	f426                	sd	s1,40(sp)
ffffffffc0208386:	e6df70ef          	jal	ffffffffc02001f2 <strdup>
ffffffffc020838a:	84aa                	mv	s1,a0
ffffffffc020838c:	cd4d                	beqz	a0,ffffffffc0208446 <vfs_do_add+0xfe>
ffffffffc020838e:	03000513          	li	a0,48
ffffffffc0208392:	ec4e                	sd	s3,24(sp)
ffffffffc0208394:	c69f90ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0208398:	89aa                	mv	s3,a0
ffffffffc020839a:	c935                	beqz	a0,ffffffffc020840e <vfs_do_add+0xc6>
ffffffffc020839c:	f04a                	sd	s2,32(sp)
ffffffffc020839e:	0008d517          	auipc	a0,0x8d
ffffffffc02083a2:	47a50513          	addi	a0,a0,1146 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02083a6:	0008d917          	auipc	s2,0x8d
ffffffffc02083aa:	48a90913          	addi	s2,s2,1162 # ffffffffc0295830 <vdev_list>
ffffffffc02083ae:	accfc0ef          	jal	ffffffffc020467a <down>
ffffffffc02083b2:	844a                	mv	s0,s2
ffffffffc02083b4:	a039                	j	ffffffffc02083c2 <vfs_do_add+0x7a>
ffffffffc02083b6:	fe043503          	ld	a0,-32(s0)
ffffffffc02083ba:	85a6                	mv	a1,s1
ffffffffc02083bc:	183030ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc02083c0:	c52d                	beqz	a0,ffffffffc020842a <vfs_do_add+0xe2>
ffffffffc02083c2:	6400                	ld	s0,8(s0)
ffffffffc02083c4:	ff2419e3          	bne	s0,s2,ffffffffc02083b6 <vfs_do_add+0x6e>
ffffffffc02083c8:	6418                	ld	a4,8(s0)
ffffffffc02083ca:	02098793          	addi	a5,s3,32
ffffffffc02083ce:	0099b023          	sd	s1,0(s3)
ffffffffc02083d2:	0149b423          	sd	s4,8(s3)
ffffffffc02083d6:	0159bc23          	sd	s5,24(s3)
ffffffffc02083da:	0169b823          	sd	s6,16(s3)
ffffffffc02083de:	e31c                	sd	a5,0(a4)
ffffffffc02083e0:	0289b023          	sd	s0,32(s3)
ffffffffc02083e4:	02e9b423          	sd	a4,40(s3)
ffffffffc02083e8:	0008d517          	auipc	a0,0x8d
ffffffffc02083ec:	43050513          	addi	a0,a0,1072 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02083f0:	e41c                	sd	a5,8(s0)
ffffffffc02083f2:	a84fc0ef          	jal	ffffffffc0204676 <up>
ffffffffc02083f6:	74a2                	ld	s1,40(sp)
ffffffffc02083f8:	7902                	ld	s2,32(sp)
ffffffffc02083fa:	69e2                	ld	s3,24(sp)
ffffffffc02083fc:	4401                	li	s0,0
ffffffffc02083fe:	70e2                	ld	ra,56(sp)
ffffffffc0208400:	8522                	mv	a0,s0
ffffffffc0208402:	7442                	ld	s0,48(sp)
ffffffffc0208404:	6a42                	ld	s4,16(sp)
ffffffffc0208406:	6aa2                	ld	s5,8(sp)
ffffffffc0208408:	6b02                	ld	s6,0(sp)
ffffffffc020840a:	6121                	addi	sp,sp,64
ffffffffc020840c:	8082                	ret
ffffffffc020840e:	5471                	li	s0,-4
ffffffffc0208410:	8526                	mv	a0,s1
ffffffffc0208412:	c91f90ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0208416:	70e2                	ld	ra,56(sp)
ffffffffc0208418:	8522                	mv	a0,s0
ffffffffc020841a:	7442                	ld	s0,48(sp)
ffffffffc020841c:	74a2                	ld	s1,40(sp)
ffffffffc020841e:	69e2                	ld	s3,24(sp)
ffffffffc0208420:	6a42                	ld	s4,16(sp)
ffffffffc0208422:	6aa2                	ld	s5,8(sp)
ffffffffc0208424:	6b02                	ld	s6,0(sp)
ffffffffc0208426:	6121                	addi	sp,sp,64
ffffffffc0208428:	8082                	ret
ffffffffc020842a:	0008d517          	auipc	a0,0x8d
ffffffffc020842e:	3ee50513          	addi	a0,a0,1006 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0208432:	a44fc0ef          	jal	ffffffffc0204676 <up>
ffffffffc0208436:	854e                	mv	a0,s3
ffffffffc0208438:	c6bf90ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020843c:	5425                	li	s0,-23
ffffffffc020843e:	7902                	ld	s2,32(sp)
ffffffffc0208440:	bfc1                	j	ffffffffc0208410 <vfs_do_add+0xc8>
ffffffffc0208442:	5451                	li	s0,-12
ffffffffc0208444:	bf6d                	j	ffffffffc02083fe <vfs_do_add+0xb6>
ffffffffc0208446:	74a2                	ld	s1,40(sp)
ffffffffc0208448:	5471                	li	s0,-4
ffffffffc020844a:	bf55                	j	ffffffffc02083fe <vfs_do_add+0xb6>
ffffffffc020844c:	00006697          	auipc	a3,0x6
ffffffffc0208450:	fdc68693          	addi	a3,a3,-36 # ffffffffc020e428 <etext+0x2614>
ffffffffc0208454:	00004617          	auipc	a2,0x4
ffffffffc0208458:	dfc60613          	addi	a2,a2,-516 # ffffffffc020c250 <etext+0x43c>
ffffffffc020845c:	08f00593          	li	a1,143
ffffffffc0208460:	00006517          	auipc	a0,0x6
ffffffffc0208464:	fb050513          	addi	a0,a0,-80 # ffffffffc020e410 <etext+0x25fc>
ffffffffc0208468:	f426                	sd	s1,40(sp)
ffffffffc020846a:	f04a                	sd	s2,32(sp)
ffffffffc020846c:	ec4e                	sd	s3,24(sp)
ffffffffc020846e:	fddf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208472:	00006697          	auipc	a3,0x6
ffffffffc0208476:	f8e68693          	addi	a3,a3,-114 # ffffffffc020e400 <etext+0x25ec>
ffffffffc020847a:	00004617          	auipc	a2,0x4
ffffffffc020847e:	dd660613          	addi	a2,a2,-554 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208482:	08e00593          	li	a1,142
ffffffffc0208486:	00006517          	auipc	a0,0x6
ffffffffc020848a:	f8a50513          	addi	a0,a0,-118 # ffffffffc020e410 <etext+0x25fc>
ffffffffc020848e:	f426                	sd	s1,40(sp)
ffffffffc0208490:	f04a                	sd	s2,32(sp)
ffffffffc0208492:	ec4e                	sd	s3,24(sp)
ffffffffc0208494:	fb7f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208498 <find_mount.part.0>:
ffffffffc0208498:	1141                	addi	sp,sp,-16
ffffffffc020849a:	00006697          	auipc	a3,0x6
ffffffffc020849e:	f6668693          	addi	a3,a3,-154 # ffffffffc020e400 <etext+0x25ec>
ffffffffc02084a2:	00004617          	auipc	a2,0x4
ffffffffc02084a6:	dae60613          	addi	a2,a2,-594 # ffffffffc020c250 <etext+0x43c>
ffffffffc02084aa:	0cd00593          	li	a1,205
ffffffffc02084ae:	00006517          	auipc	a0,0x6
ffffffffc02084b2:	f6250513          	addi	a0,a0,-158 # ffffffffc020e410 <etext+0x25fc>
ffffffffc02084b6:	e406                	sd	ra,8(sp)
ffffffffc02084b8:	f93f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02084bc <vfs_devlist_init>:
ffffffffc02084bc:	0008d797          	auipc	a5,0x8d
ffffffffc02084c0:	37478793          	addi	a5,a5,884 # ffffffffc0295830 <vdev_list>
ffffffffc02084c4:	4585                	li	a1,1
ffffffffc02084c6:	0008d517          	auipc	a0,0x8d
ffffffffc02084ca:	35250513          	addi	a0,a0,850 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02084ce:	e79c                	sd	a5,8(a5)
ffffffffc02084d0:	e39c                	sd	a5,0(a5)
ffffffffc02084d2:	99efc06f          	j	ffffffffc0204670 <sem_init>

ffffffffc02084d6 <vfs_cleanup>:
ffffffffc02084d6:	1101                	addi	sp,sp,-32
ffffffffc02084d8:	e426                	sd	s1,8(sp)
ffffffffc02084da:	0008d497          	auipc	s1,0x8d
ffffffffc02084de:	35648493          	addi	s1,s1,854 # ffffffffc0295830 <vdev_list>
ffffffffc02084e2:	649c                	ld	a5,8(s1)
ffffffffc02084e4:	ec06                	sd	ra,24(sp)
ffffffffc02084e6:	02978f63          	beq	a5,s1,ffffffffc0208524 <vfs_cleanup+0x4e>
ffffffffc02084ea:	0008d517          	auipc	a0,0x8d
ffffffffc02084ee:	32e50513          	addi	a0,a0,814 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02084f2:	e822                	sd	s0,16(sp)
ffffffffc02084f4:	986fc0ef          	jal	ffffffffc020467a <down>
ffffffffc02084f8:	6480                	ld	s0,8(s1)
ffffffffc02084fa:	00940b63          	beq	s0,s1,ffffffffc0208510 <vfs_cleanup+0x3a>
ffffffffc02084fe:	ff043783          	ld	a5,-16(s0)
ffffffffc0208502:	853e                	mv	a0,a5
ffffffffc0208504:	c399                	beqz	a5,ffffffffc020850a <vfs_cleanup+0x34>
ffffffffc0208506:	6bfc                	ld	a5,208(a5)
ffffffffc0208508:	9782                	jalr	a5
ffffffffc020850a:	6400                	ld	s0,8(s0)
ffffffffc020850c:	fe9419e3          	bne	s0,s1,ffffffffc02084fe <vfs_cleanup+0x28>
ffffffffc0208510:	6442                	ld	s0,16(sp)
ffffffffc0208512:	60e2                	ld	ra,24(sp)
ffffffffc0208514:	64a2                	ld	s1,8(sp)
ffffffffc0208516:	0008d517          	auipc	a0,0x8d
ffffffffc020851a:	30250513          	addi	a0,a0,770 # ffffffffc0295818 <vdev_list_sem>
ffffffffc020851e:	6105                	addi	sp,sp,32
ffffffffc0208520:	956fc06f          	j	ffffffffc0204676 <up>
ffffffffc0208524:	60e2                	ld	ra,24(sp)
ffffffffc0208526:	64a2                	ld	s1,8(sp)
ffffffffc0208528:	6105                	addi	sp,sp,32
ffffffffc020852a:	8082                	ret

ffffffffc020852c <vfs_get_root>:
ffffffffc020852c:	7179                	addi	sp,sp,-48
ffffffffc020852e:	f406                	sd	ra,40(sp)
ffffffffc0208530:	c949                	beqz	a0,ffffffffc02085c2 <vfs_get_root+0x96>
ffffffffc0208532:	e84a                	sd	s2,16(sp)
ffffffffc0208534:	0008d917          	auipc	s2,0x8d
ffffffffc0208538:	2fc90913          	addi	s2,s2,764 # ffffffffc0295830 <vdev_list>
ffffffffc020853c:	00893783          	ld	a5,8(s2)
ffffffffc0208540:	ec26                	sd	s1,24(sp)
ffffffffc0208542:	07278e63          	beq	a5,s2,ffffffffc02085be <vfs_get_root+0x92>
ffffffffc0208546:	e44e                	sd	s3,8(sp)
ffffffffc0208548:	89aa                	mv	s3,a0
ffffffffc020854a:	0008d517          	auipc	a0,0x8d
ffffffffc020854e:	2ce50513          	addi	a0,a0,718 # ffffffffc0295818 <vdev_list_sem>
ffffffffc0208552:	f022                	sd	s0,32(sp)
ffffffffc0208554:	e052                	sd	s4,0(sp)
ffffffffc0208556:	844a                	mv	s0,s2
ffffffffc0208558:	8a2e                	mv	s4,a1
ffffffffc020855a:	920fc0ef          	jal	ffffffffc020467a <down>
ffffffffc020855e:	a801                	j	ffffffffc020856e <vfs_get_root+0x42>
ffffffffc0208560:	fe043583          	ld	a1,-32(s0)
ffffffffc0208564:	854e                	mv	a0,s3
ffffffffc0208566:	7d8030ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc020856a:	84aa                	mv	s1,a0
ffffffffc020856c:	c505                	beqz	a0,ffffffffc0208594 <vfs_get_root+0x68>
ffffffffc020856e:	6400                	ld	s0,8(s0)
ffffffffc0208570:	ff2418e3          	bne	s0,s2,ffffffffc0208560 <vfs_get_root+0x34>
ffffffffc0208574:	54cd                	li	s1,-13
ffffffffc0208576:	0008d517          	auipc	a0,0x8d
ffffffffc020857a:	2a250513          	addi	a0,a0,674 # ffffffffc0295818 <vdev_list_sem>
ffffffffc020857e:	8f8fc0ef          	jal	ffffffffc0204676 <up>
ffffffffc0208582:	7402                	ld	s0,32(sp)
ffffffffc0208584:	69a2                	ld	s3,8(sp)
ffffffffc0208586:	6a02                	ld	s4,0(sp)
ffffffffc0208588:	70a2                	ld	ra,40(sp)
ffffffffc020858a:	6942                	ld	s2,16(sp)
ffffffffc020858c:	8526                	mv	a0,s1
ffffffffc020858e:	64e2                	ld	s1,24(sp)
ffffffffc0208590:	6145                	addi	sp,sp,48
ffffffffc0208592:	8082                	ret
ffffffffc0208594:	ff043503          	ld	a0,-16(s0)
ffffffffc0208598:	c519                	beqz	a0,ffffffffc02085a6 <vfs_get_root+0x7a>
ffffffffc020859a:	617c                	ld	a5,192(a0)
ffffffffc020859c:	9782                	jalr	a5
ffffffffc020859e:	c519                	beqz	a0,ffffffffc02085ac <vfs_get_root+0x80>
ffffffffc02085a0:	00aa3023          	sd	a0,0(s4)
ffffffffc02085a4:	bfc9                	j	ffffffffc0208576 <vfs_get_root+0x4a>
ffffffffc02085a6:	ff843783          	ld	a5,-8(s0)
ffffffffc02085aa:	c399                	beqz	a5,ffffffffc02085b0 <vfs_get_root+0x84>
ffffffffc02085ac:	54c9                	li	s1,-14
ffffffffc02085ae:	b7e1                	j	ffffffffc0208576 <vfs_get_root+0x4a>
ffffffffc02085b0:	fe843503          	ld	a0,-24(s0)
ffffffffc02085b4:	a89ff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc02085b8:	fe843503          	ld	a0,-24(s0)
ffffffffc02085bc:	b7cd                	j	ffffffffc020859e <vfs_get_root+0x72>
ffffffffc02085be:	54cd                	li	s1,-13
ffffffffc02085c0:	b7e1                	j	ffffffffc0208588 <vfs_get_root+0x5c>
ffffffffc02085c2:	00006697          	auipc	a3,0x6
ffffffffc02085c6:	e3e68693          	addi	a3,a3,-450 # ffffffffc020e400 <etext+0x25ec>
ffffffffc02085ca:	00004617          	auipc	a2,0x4
ffffffffc02085ce:	c8660613          	addi	a2,a2,-890 # ffffffffc020c250 <etext+0x43c>
ffffffffc02085d2:	04500593          	li	a1,69
ffffffffc02085d6:	00006517          	auipc	a0,0x6
ffffffffc02085da:	e3a50513          	addi	a0,a0,-454 # ffffffffc020e410 <etext+0x25fc>
ffffffffc02085de:	f022                	sd	s0,32(sp)
ffffffffc02085e0:	ec26                	sd	s1,24(sp)
ffffffffc02085e2:	e84a                	sd	s2,16(sp)
ffffffffc02085e4:	e44e                	sd	s3,8(sp)
ffffffffc02085e6:	e052                	sd	s4,0(sp)
ffffffffc02085e8:	e63f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02085ec <vfs_get_devname>:
ffffffffc02085ec:	0008d697          	auipc	a3,0x8d
ffffffffc02085f0:	24468693          	addi	a3,a3,580 # ffffffffc0295830 <vdev_list>
ffffffffc02085f4:	87b6                	mv	a5,a3
ffffffffc02085f6:	e511                	bnez	a0,ffffffffc0208602 <vfs_get_devname+0x16>
ffffffffc02085f8:	a829                	j	ffffffffc0208612 <vfs_get_devname+0x26>
ffffffffc02085fa:	ff07b703          	ld	a4,-16(a5)
ffffffffc02085fe:	00a70763          	beq	a4,a0,ffffffffc020860c <vfs_get_devname+0x20>
ffffffffc0208602:	679c                	ld	a5,8(a5)
ffffffffc0208604:	fed79be3          	bne	a5,a3,ffffffffc02085fa <vfs_get_devname+0xe>
ffffffffc0208608:	4501                	li	a0,0
ffffffffc020860a:	8082                	ret
ffffffffc020860c:	fe07b503          	ld	a0,-32(a5)
ffffffffc0208610:	8082                	ret
ffffffffc0208612:	1141                	addi	sp,sp,-16
ffffffffc0208614:	00006697          	auipc	a3,0x6
ffffffffc0208618:	e7468693          	addi	a3,a3,-396 # ffffffffc020e488 <etext+0x2674>
ffffffffc020861c:	00004617          	auipc	a2,0x4
ffffffffc0208620:	c3460613          	addi	a2,a2,-972 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208624:	06a00593          	li	a1,106
ffffffffc0208628:	00006517          	auipc	a0,0x6
ffffffffc020862c:	de850513          	addi	a0,a0,-536 # ffffffffc020e410 <etext+0x25fc>
ffffffffc0208630:	e406                	sd	ra,8(sp)
ffffffffc0208632:	e19f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208636 <vfs_add_dev>:
ffffffffc0208636:	86b2                	mv	a3,a2
ffffffffc0208638:	4601                	li	a2,0
ffffffffc020863a:	d0fff06f          	j	ffffffffc0208348 <vfs_do_add>

ffffffffc020863e <vfs_mount>:
ffffffffc020863e:	7179                	addi	sp,sp,-48
ffffffffc0208640:	e84a                	sd	s2,16(sp)
ffffffffc0208642:	892a                	mv	s2,a0
ffffffffc0208644:	0008d517          	auipc	a0,0x8d
ffffffffc0208648:	1d450513          	addi	a0,a0,468 # ffffffffc0295818 <vdev_list_sem>
ffffffffc020864c:	e44e                	sd	s3,8(sp)
ffffffffc020864e:	f406                	sd	ra,40(sp)
ffffffffc0208650:	f022                	sd	s0,32(sp)
ffffffffc0208652:	ec26                	sd	s1,24(sp)
ffffffffc0208654:	89ae                	mv	s3,a1
ffffffffc0208656:	824fc0ef          	jal	ffffffffc020467a <down>
ffffffffc020865a:	0c090a63          	beqz	s2,ffffffffc020872e <vfs_mount+0xf0>
ffffffffc020865e:	0008d497          	auipc	s1,0x8d
ffffffffc0208662:	1d248493          	addi	s1,s1,466 # ffffffffc0295830 <vdev_list>
ffffffffc0208666:	6480                	ld	s0,8(s1)
ffffffffc0208668:	00941663          	bne	s0,s1,ffffffffc0208674 <vfs_mount+0x36>
ffffffffc020866c:	a8ad                	j	ffffffffc02086e6 <vfs_mount+0xa8>
ffffffffc020866e:	6400                	ld	s0,8(s0)
ffffffffc0208670:	06940b63          	beq	s0,s1,ffffffffc02086e6 <vfs_mount+0xa8>
ffffffffc0208674:	ff843783          	ld	a5,-8(s0)
ffffffffc0208678:	dbfd                	beqz	a5,ffffffffc020866e <vfs_mount+0x30>
ffffffffc020867a:	fe043503          	ld	a0,-32(s0)
ffffffffc020867e:	85ca                	mv	a1,s2
ffffffffc0208680:	6be030ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc0208684:	f56d                	bnez	a0,ffffffffc020866e <vfs_mount+0x30>
ffffffffc0208686:	ff043783          	ld	a5,-16(s0)
ffffffffc020868a:	e3a5                	bnez	a5,ffffffffc02086ea <vfs_mount+0xac>
ffffffffc020868c:	fe043783          	ld	a5,-32(s0)
ffffffffc0208690:	cfbd                	beqz	a5,ffffffffc020870e <vfs_mount+0xd0>
ffffffffc0208692:	ff843783          	ld	a5,-8(s0)
ffffffffc0208696:	cfa5                	beqz	a5,ffffffffc020870e <vfs_mount+0xd0>
ffffffffc0208698:	fe843503          	ld	a0,-24(s0)
ffffffffc020869c:	c929                	beqz	a0,ffffffffc02086ee <vfs_mount+0xb0>
ffffffffc020869e:	4d38                	lw	a4,88(a0)
ffffffffc02086a0:	6785                	lui	a5,0x1
ffffffffc02086a2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086a6:	04f71463          	bne	a4,a5,ffffffffc02086ee <vfs_mount+0xb0>
ffffffffc02086aa:	ff040593          	addi	a1,s0,-16
ffffffffc02086ae:	9982                	jalr	s3
ffffffffc02086b0:	84aa                	mv	s1,a0
ffffffffc02086b2:	ed01                	bnez	a0,ffffffffc02086ca <vfs_mount+0x8c>
ffffffffc02086b4:	ff043783          	ld	a5,-16(s0)
ffffffffc02086b8:	cfad                	beqz	a5,ffffffffc0208732 <vfs_mount+0xf4>
ffffffffc02086ba:	fe043583          	ld	a1,-32(s0)
ffffffffc02086be:	00006517          	auipc	a0,0x6
ffffffffc02086c2:	e5a50513          	addi	a0,a0,-422 # ffffffffc020e518 <etext+0x2704>
ffffffffc02086c6:	ae1f70ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02086ca:	0008d517          	auipc	a0,0x8d
ffffffffc02086ce:	14e50513          	addi	a0,a0,334 # ffffffffc0295818 <vdev_list_sem>
ffffffffc02086d2:	fa5fb0ef          	jal	ffffffffc0204676 <up>
ffffffffc02086d6:	70a2                	ld	ra,40(sp)
ffffffffc02086d8:	7402                	ld	s0,32(sp)
ffffffffc02086da:	6942                	ld	s2,16(sp)
ffffffffc02086dc:	69a2                	ld	s3,8(sp)
ffffffffc02086de:	8526                	mv	a0,s1
ffffffffc02086e0:	64e2                	ld	s1,24(sp)
ffffffffc02086e2:	6145                	addi	sp,sp,48
ffffffffc02086e4:	8082                	ret
ffffffffc02086e6:	54cd                	li	s1,-13
ffffffffc02086e8:	b7cd                	j	ffffffffc02086ca <vfs_mount+0x8c>
ffffffffc02086ea:	54c5                	li	s1,-15
ffffffffc02086ec:	bff9                	j	ffffffffc02086ca <vfs_mount+0x8c>
ffffffffc02086ee:	00006697          	auipc	a3,0x6
ffffffffc02086f2:	dda68693          	addi	a3,a3,-550 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc02086f6:	00004617          	auipc	a2,0x4
ffffffffc02086fa:	b5a60613          	addi	a2,a2,-1190 # ffffffffc020c250 <etext+0x43c>
ffffffffc02086fe:	0ed00593          	li	a1,237
ffffffffc0208702:	00006517          	auipc	a0,0x6
ffffffffc0208706:	d0e50513          	addi	a0,a0,-754 # ffffffffc020e410 <etext+0x25fc>
ffffffffc020870a:	d41f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020870e:	00006697          	auipc	a3,0x6
ffffffffc0208712:	d8a68693          	addi	a3,a3,-630 # ffffffffc020e498 <etext+0x2684>
ffffffffc0208716:	00004617          	auipc	a2,0x4
ffffffffc020871a:	b3a60613          	addi	a2,a2,-1222 # ffffffffc020c250 <etext+0x43c>
ffffffffc020871e:	0eb00593          	li	a1,235
ffffffffc0208722:	00006517          	auipc	a0,0x6
ffffffffc0208726:	cee50513          	addi	a0,a0,-786 # ffffffffc020e410 <etext+0x25fc>
ffffffffc020872a:	d21f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020872e:	d6bff0ef          	jal	ffffffffc0208498 <find_mount.part.0>
ffffffffc0208732:	00006697          	auipc	a3,0x6
ffffffffc0208736:	dce68693          	addi	a3,a3,-562 # ffffffffc020e500 <etext+0x26ec>
ffffffffc020873a:	00004617          	auipc	a2,0x4
ffffffffc020873e:	b1660613          	addi	a2,a2,-1258 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208742:	0ef00593          	li	a1,239
ffffffffc0208746:	00006517          	auipc	a0,0x6
ffffffffc020874a:	cca50513          	addi	a0,a0,-822 # ffffffffc020e410 <etext+0x25fc>
ffffffffc020874e:	cfdf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208752 <vfs_open>:
ffffffffc0208752:	7159                	addi	sp,sp,-112
ffffffffc0208754:	f486                	sd	ra,104(sp)
ffffffffc0208756:	e0d2                	sd	s4,64(sp)
ffffffffc0208758:	0035f793          	andi	a5,a1,3
ffffffffc020875c:	10078363          	beqz	a5,ffffffffc0208862 <vfs_open+0x110>
ffffffffc0208760:	470d                	li	a4,3
ffffffffc0208762:	12e78163          	beq	a5,a4,ffffffffc0208884 <vfs_open+0x132>
ffffffffc0208766:	f0a2                	sd	s0,96(sp)
ffffffffc0208768:	eca6                	sd	s1,88(sp)
ffffffffc020876a:	e8ca                	sd	s2,80(sp)
ffffffffc020876c:	e4ce                	sd	s3,72(sp)
ffffffffc020876e:	fc56                	sd	s5,56(sp)
ffffffffc0208770:	f85a                	sd	s6,48(sp)
ffffffffc0208772:	0105fa13          	andi	s4,a1,16
ffffffffc0208776:	842e                	mv	s0,a1
ffffffffc0208778:	00447793          	andi	a5,s0,4
ffffffffc020877c:	8b32                	mv	s6,a2
ffffffffc020877e:	082c                	addi	a1,sp,24
ffffffffc0208780:	00345613          	srli	a2,s0,0x3
ffffffffc0208784:	8abe                	mv	s5,a5
ffffffffc0208786:	0027d493          	srli	s1,a5,0x2
ffffffffc020878a:	892a                	mv	s2,a0
ffffffffc020878c:	00167993          	andi	s3,a2,1
ffffffffc0208790:	2ba000ef          	jal	ffffffffc0208a4a <vfs_lookup>
ffffffffc0208794:	87aa                	mv	a5,a0
ffffffffc0208796:	c175                	beqz	a0,ffffffffc020887a <vfs_open+0x128>
ffffffffc0208798:	01050713          	addi	a4,a0,16
ffffffffc020879c:	eb45                	bnez	a4,ffffffffc020884c <vfs_open+0xfa>
ffffffffc020879e:	c4dd                	beqz	s1,ffffffffc020884c <vfs_open+0xfa>
ffffffffc02087a0:	854a                	mv	a0,s2
ffffffffc02087a2:	1010                	addi	a2,sp,32
ffffffffc02087a4:	102c                	addi	a1,sp,40
ffffffffc02087a6:	32e000ef          	jal	ffffffffc0208ad4 <vfs_lookup_parent>
ffffffffc02087aa:	87aa                	mv	a5,a0
ffffffffc02087ac:	e145                	bnez	a0,ffffffffc020884c <vfs_open+0xfa>
ffffffffc02087ae:	7522                	ld	a0,40(sp)
ffffffffc02087b0:	14050c63          	beqz	a0,ffffffffc0208908 <vfs_open+0x1b6>
ffffffffc02087b4:	793c                	ld	a5,112(a0)
ffffffffc02087b6:	14078963          	beqz	a5,ffffffffc0208908 <vfs_open+0x1b6>
ffffffffc02087ba:	77bc                	ld	a5,104(a5)
ffffffffc02087bc:	14078663          	beqz	a5,ffffffffc0208908 <vfs_open+0x1b6>
ffffffffc02087c0:	00006597          	auipc	a1,0x6
ffffffffc02087c4:	dd058593          	addi	a1,a1,-560 # ffffffffc020e590 <etext+0x277c>
ffffffffc02087c8:	e42a                	sd	a0,8(sp)
ffffffffc02087ca:	887ff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc02087ce:	6522                	ld	a0,8(sp)
ffffffffc02087d0:	7582                	ld	a1,32(sp)
ffffffffc02087d2:	0834                	addi	a3,sp,24
ffffffffc02087d4:	793c                	ld	a5,112(a0)
ffffffffc02087d6:	7522                	ld	a0,40(sp)
ffffffffc02087d8:	864e                	mv	a2,s3
ffffffffc02087da:	77bc                	ld	a5,104(a5)
ffffffffc02087dc:	9782                	jalr	a5
ffffffffc02087de:	6562                	ld	a0,24(sp)
ffffffffc02087e0:	10050463          	beqz	a0,ffffffffc02088e8 <vfs_open+0x196>
ffffffffc02087e4:	793c                	ld	a5,112(a0)
ffffffffc02087e6:	c3e9                	beqz	a5,ffffffffc02088a8 <vfs_open+0x156>
ffffffffc02087e8:	679c                	ld	a5,8(a5)
ffffffffc02087ea:	cfdd                	beqz	a5,ffffffffc02088a8 <vfs_open+0x156>
ffffffffc02087ec:	00006597          	auipc	a1,0x6
ffffffffc02087f0:	e0c58593          	addi	a1,a1,-500 # ffffffffc020e5f8 <etext+0x27e4>
ffffffffc02087f4:	e42a                	sd	a0,8(sp)
ffffffffc02087f6:	85bff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc02087fa:	6522                	ld	a0,8(sp)
ffffffffc02087fc:	85a2                	mv	a1,s0
ffffffffc02087fe:	793c                	ld	a5,112(a0)
ffffffffc0208800:	6562                	ld	a0,24(sp)
ffffffffc0208802:	679c                	ld	a5,8(a5)
ffffffffc0208804:	9782                	jalr	a5
ffffffffc0208806:	87aa                	mv	a5,a0
ffffffffc0208808:	e43e                	sd	a5,8(sp)
ffffffffc020880a:	6562                	ld	a0,24(sp)
ffffffffc020880c:	e3d1                	bnez	a5,ffffffffc0208890 <vfs_open+0x13e>
ffffffffc020880e:	839ff0ef          	jal	ffffffffc0208046 <inode_open_inc>
ffffffffc0208812:	014ae733          	or	a4,s5,s4
ffffffffc0208816:	67a2                	ld	a5,8(sp)
ffffffffc0208818:	c71d                	beqz	a4,ffffffffc0208846 <vfs_open+0xf4>
ffffffffc020881a:	6462                	ld	s0,24(sp)
ffffffffc020881c:	c455                	beqz	s0,ffffffffc02088c8 <vfs_open+0x176>
ffffffffc020881e:	7838                	ld	a4,112(s0)
ffffffffc0208820:	c745                	beqz	a4,ffffffffc02088c8 <vfs_open+0x176>
ffffffffc0208822:	7338                	ld	a4,96(a4)
ffffffffc0208824:	c355                	beqz	a4,ffffffffc02088c8 <vfs_open+0x176>
ffffffffc0208826:	8522                	mv	a0,s0
ffffffffc0208828:	00006597          	auipc	a1,0x6
ffffffffc020882c:	e3058593          	addi	a1,a1,-464 # ffffffffc020e658 <etext+0x2844>
ffffffffc0208830:	e43e                	sd	a5,8(sp)
ffffffffc0208832:	81fff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208836:	7838                	ld	a4,112(s0)
ffffffffc0208838:	6562                	ld	a0,24(sp)
ffffffffc020883a:	4581                	li	a1,0
ffffffffc020883c:	7338                	ld	a4,96(a4)
ffffffffc020883e:	9702                	jalr	a4
ffffffffc0208840:	67a2                	ld	a5,8(sp)
ffffffffc0208842:	842a                	mv	s0,a0
ffffffffc0208844:	e931                	bnez	a0,ffffffffc0208898 <vfs_open+0x146>
ffffffffc0208846:	6762                	ld	a4,24(sp)
ffffffffc0208848:	00eb3023          	sd	a4,0(s6)
ffffffffc020884c:	7406                	ld	s0,96(sp)
ffffffffc020884e:	64e6                	ld	s1,88(sp)
ffffffffc0208850:	6946                	ld	s2,80(sp)
ffffffffc0208852:	69a6                	ld	s3,72(sp)
ffffffffc0208854:	7ae2                	ld	s5,56(sp)
ffffffffc0208856:	7b42                	ld	s6,48(sp)
ffffffffc0208858:	70a6                	ld	ra,104(sp)
ffffffffc020885a:	6a06                	ld	s4,64(sp)
ffffffffc020885c:	853e                	mv	a0,a5
ffffffffc020885e:	6165                	addi	sp,sp,112
ffffffffc0208860:	8082                	ret
ffffffffc0208862:	0105f713          	andi	a4,a1,16
ffffffffc0208866:	8a3a                	mv	s4,a4
ffffffffc0208868:	57f5                	li	a5,-3
ffffffffc020886a:	f77d                	bnez	a4,ffffffffc0208858 <vfs_open+0x106>
ffffffffc020886c:	f0a2                	sd	s0,96(sp)
ffffffffc020886e:	eca6                	sd	s1,88(sp)
ffffffffc0208870:	e8ca                	sd	s2,80(sp)
ffffffffc0208872:	e4ce                	sd	s3,72(sp)
ffffffffc0208874:	fc56                	sd	s5,56(sp)
ffffffffc0208876:	f85a                	sd	s6,48(sp)
ffffffffc0208878:	bdfd                	j	ffffffffc0208776 <vfs_open+0x24>
ffffffffc020887a:	f60982e3          	beqz	s3,ffffffffc02087de <vfs_open+0x8c>
ffffffffc020887e:	d0a5                	beqz	s1,ffffffffc02087de <vfs_open+0x8c>
ffffffffc0208880:	57a5                	li	a5,-23
ffffffffc0208882:	b7e9                	j	ffffffffc020884c <vfs_open+0xfa>
ffffffffc0208884:	70a6                	ld	ra,104(sp)
ffffffffc0208886:	57f5                	li	a5,-3
ffffffffc0208888:	6a06                	ld	s4,64(sp)
ffffffffc020888a:	853e                	mv	a0,a5
ffffffffc020888c:	6165                	addi	sp,sp,112
ffffffffc020888e:	8082                	ret
ffffffffc0208890:	87bff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc0208894:	67a2                	ld	a5,8(sp)
ffffffffc0208896:	bf5d                	j	ffffffffc020884c <vfs_open+0xfa>
ffffffffc0208898:	6562                	ld	a0,24(sp)
ffffffffc020889a:	90dff0ef          	jal	ffffffffc02081a6 <inode_open_dec>
ffffffffc020889e:	6562                	ld	a0,24(sp)
ffffffffc02088a0:	86bff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc02088a4:	87a2                	mv	a5,s0
ffffffffc02088a6:	b75d                	j	ffffffffc020884c <vfs_open+0xfa>
ffffffffc02088a8:	00006697          	auipc	a3,0x6
ffffffffc02088ac:	d0068693          	addi	a3,a3,-768 # ffffffffc020e5a8 <etext+0x2794>
ffffffffc02088b0:	00004617          	auipc	a2,0x4
ffffffffc02088b4:	9a060613          	addi	a2,a2,-1632 # ffffffffc020c250 <etext+0x43c>
ffffffffc02088b8:	03300593          	li	a1,51
ffffffffc02088bc:	00006517          	auipc	a0,0x6
ffffffffc02088c0:	cbc50513          	addi	a0,a0,-836 # ffffffffc020e578 <etext+0x2764>
ffffffffc02088c4:	b87f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02088c8:	00006697          	auipc	a3,0x6
ffffffffc02088cc:	d3868693          	addi	a3,a3,-712 # ffffffffc020e600 <etext+0x27ec>
ffffffffc02088d0:	00004617          	auipc	a2,0x4
ffffffffc02088d4:	98060613          	addi	a2,a2,-1664 # ffffffffc020c250 <etext+0x43c>
ffffffffc02088d8:	03a00593          	li	a1,58
ffffffffc02088dc:	00006517          	auipc	a0,0x6
ffffffffc02088e0:	c9c50513          	addi	a0,a0,-868 # ffffffffc020e578 <etext+0x2764>
ffffffffc02088e4:	b67f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02088e8:	00006697          	auipc	a3,0x6
ffffffffc02088ec:	cb068693          	addi	a3,a3,-848 # ffffffffc020e598 <etext+0x2784>
ffffffffc02088f0:	00004617          	auipc	a2,0x4
ffffffffc02088f4:	96060613          	addi	a2,a2,-1696 # ffffffffc020c250 <etext+0x43c>
ffffffffc02088f8:	03100593          	li	a1,49
ffffffffc02088fc:	00006517          	auipc	a0,0x6
ffffffffc0208900:	c7c50513          	addi	a0,a0,-900 # ffffffffc020e578 <etext+0x2764>
ffffffffc0208904:	b47f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208908:	00006697          	auipc	a3,0x6
ffffffffc020890c:	c2068693          	addi	a3,a3,-992 # ffffffffc020e528 <etext+0x2714>
ffffffffc0208910:	00004617          	auipc	a2,0x4
ffffffffc0208914:	94060613          	addi	a2,a2,-1728 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208918:	02c00593          	li	a1,44
ffffffffc020891c:	00006517          	auipc	a0,0x6
ffffffffc0208920:	c5c50513          	addi	a0,a0,-932 # ffffffffc020e578 <etext+0x2764>
ffffffffc0208924:	b27f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208928 <vfs_close>:
ffffffffc0208928:	1141                	addi	sp,sp,-16
ffffffffc020892a:	e406                	sd	ra,8(sp)
ffffffffc020892c:	e022                	sd	s0,0(sp)
ffffffffc020892e:	842a                	mv	s0,a0
ffffffffc0208930:	877ff0ef          	jal	ffffffffc02081a6 <inode_open_dec>
ffffffffc0208934:	8522                	mv	a0,s0
ffffffffc0208936:	fd4ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020893a:	60a2                	ld	ra,8(sp)
ffffffffc020893c:	6402                	ld	s0,0(sp)
ffffffffc020893e:	4501                	li	a0,0
ffffffffc0208940:	0141                	addi	sp,sp,16
ffffffffc0208942:	8082                	ret

ffffffffc0208944 <get_device>:
ffffffffc0208944:	00054e03          	lbu	t3,0(a0)
ffffffffc0208948:	020e0463          	beqz	t3,ffffffffc0208970 <get_device+0x2c>
ffffffffc020894c:	00150693          	addi	a3,a0,1
ffffffffc0208950:	8736                	mv	a4,a3
ffffffffc0208952:	87f2                	mv	a5,t3
ffffffffc0208954:	4801                	li	a6,0
ffffffffc0208956:	03a00893          	li	a7,58
ffffffffc020895a:	02f00313          	li	t1,47
ffffffffc020895e:	01178c63          	beq	a5,a7,ffffffffc0208976 <get_device+0x32>
ffffffffc0208962:	02678e63          	beq	a5,t1,ffffffffc020899e <get_device+0x5a>
ffffffffc0208966:	00074783          	lbu	a5,0(a4)
ffffffffc020896a:	0705                	addi	a4,a4,1
ffffffffc020896c:	2805                	addiw	a6,a6,1
ffffffffc020896e:	fbe5                	bnez	a5,ffffffffc020895e <get_device+0x1a>
ffffffffc0208970:	e188                	sd	a0,0(a1)
ffffffffc0208972:	8532                	mv	a0,a2
ffffffffc0208974:	a269                	j	ffffffffc0208afe <vfs_get_curdir>
ffffffffc0208976:	02080663          	beqz	a6,ffffffffc02089a2 <get_device+0x5e>
ffffffffc020897a:	01050733          	add	a4,a0,a6
ffffffffc020897e:	010687b3          	add	a5,a3,a6
ffffffffc0208982:	00070023          	sb	zero,0(a4)
ffffffffc0208986:	02f00813          	li	a6,47
ffffffffc020898a:	86be                	mv	a3,a5
ffffffffc020898c:	0007c703          	lbu	a4,0(a5)
ffffffffc0208990:	0785                	addi	a5,a5,1
ffffffffc0208992:	ff070ce3          	beq	a4,a6,ffffffffc020898a <get_device+0x46>
ffffffffc0208996:	e194                	sd	a3,0(a1)
ffffffffc0208998:	85b2                	mv	a1,a2
ffffffffc020899a:	b93ff06f          	j	ffffffffc020852c <vfs_get_root>
ffffffffc020899e:	fc0819e3          	bnez	a6,ffffffffc0208970 <get_device+0x2c>
ffffffffc02089a2:	7139                	addi	sp,sp,-64
ffffffffc02089a4:	f822                	sd	s0,48(sp)
ffffffffc02089a6:	f426                	sd	s1,40(sp)
ffffffffc02089a8:	fc06                	sd	ra,56(sp)
ffffffffc02089aa:	02f00793          	li	a5,47
ffffffffc02089ae:	8432                	mv	s0,a2
ffffffffc02089b0:	84ae                	mv	s1,a1
ffffffffc02089b2:	04fe0563          	beq	t3,a5,ffffffffc02089fc <get_device+0xb8>
ffffffffc02089b6:	03a00793          	li	a5,58
ffffffffc02089ba:	06fe1863          	bne	t3,a5,ffffffffc0208a2a <get_device+0xe6>
ffffffffc02089be:	0828                	addi	a0,sp,24
ffffffffc02089c0:	e436                	sd	a3,8(sp)
ffffffffc02089c2:	13c000ef          	jal	ffffffffc0208afe <vfs_get_curdir>
ffffffffc02089c6:	e515                	bnez	a0,ffffffffc02089f2 <get_device+0xae>
ffffffffc02089c8:	67e2                	ld	a5,24(sp)
ffffffffc02089ca:	77a8                	ld	a0,104(a5)
ffffffffc02089cc:	cd1d                	beqz	a0,ffffffffc0208a0a <get_device+0xc6>
ffffffffc02089ce:	617c                	ld	a5,192(a0)
ffffffffc02089d0:	9782                	jalr	a5
ffffffffc02089d2:	87aa                	mv	a5,a0
ffffffffc02089d4:	6562                	ld	a0,24(sp)
ffffffffc02089d6:	e01c                	sd	a5,0(s0)
ffffffffc02089d8:	f32ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc02089dc:	66a2                	ld	a3,8(sp)
ffffffffc02089de:	02f00713          	li	a4,47
ffffffffc02089e2:	a011                	j	ffffffffc02089e6 <get_device+0xa2>
ffffffffc02089e4:	0685                	addi	a3,a3,1
ffffffffc02089e6:	0006c783          	lbu	a5,0(a3)
ffffffffc02089ea:	fee78de3          	beq	a5,a4,ffffffffc02089e4 <get_device+0xa0>
ffffffffc02089ee:	e094                	sd	a3,0(s1)
ffffffffc02089f0:	4501                	li	a0,0
ffffffffc02089f2:	70e2                	ld	ra,56(sp)
ffffffffc02089f4:	7442                	ld	s0,48(sp)
ffffffffc02089f6:	74a2                	ld	s1,40(sp)
ffffffffc02089f8:	6121                	addi	sp,sp,64
ffffffffc02089fa:	8082                	ret
ffffffffc02089fc:	8532                	mv	a0,a2
ffffffffc02089fe:	e436                	sd	a3,8(sp)
ffffffffc0208a00:	8ebff0ef          	jal	ffffffffc02082ea <vfs_get_bootfs>
ffffffffc0208a04:	66a2                	ld	a3,8(sp)
ffffffffc0208a06:	dd61                	beqz	a0,ffffffffc02089de <get_device+0x9a>
ffffffffc0208a08:	b7ed                	j	ffffffffc02089f2 <get_device+0xae>
ffffffffc0208a0a:	00006697          	auipc	a3,0x6
ffffffffc0208a0e:	c8668693          	addi	a3,a3,-890 # ffffffffc020e690 <etext+0x287c>
ffffffffc0208a12:	00004617          	auipc	a2,0x4
ffffffffc0208a16:	83e60613          	addi	a2,a2,-1986 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208a1a:	03900593          	li	a1,57
ffffffffc0208a1e:	00006517          	auipc	a0,0x6
ffffffffc0208a22:	c5a50513          	addi	a0,a0,-934 # ffffffffc020e678 <etext+0x2864>
ffffffffc0208a26:	a25f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208a2a:	00006697          	auipc	a3,0x6
ffffffffc0208a2e:	c3e68693          	addi	a3,a3,-962 # ffffffffc020e668 <etext+0x2854>
ffffffffc0208a32:	00004617          	auipc	a2,0x4
ffffffffc0208a36:	81e60613          	addi	a2,a2,-2018 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208a3a:	03300593          	li	a1,51
ffffffffc0208a3e:	00006517          	auipc	a0,0x6
ffffffffc0208a42:	c3a50513          	addi	a0,a0,-966 # ffffffffc020e678 <etext+0x2864>
ffffffffc0208a46:	a05f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208a4a <vfs_lookup>:
ffffffffc0208a4a:	7139                	addi	sp,sp,-64
ffffffffc0208a4c:	f822                	sd	s0,48(sp)
ffffffffc0208a4e:	1030                	addi	a2,sp,40
ffffffffc0208a50:	842e                	mv	s0,a1
ffffffffc0208a52:	082c                	addi	a1,sp,24
ffffffffc0208a54:	fc06                	sd	ra,56(sp)
ffffffffc0208a56:	ec2a                	sd	a0,24(sp)
ffffffffc0208a58:	eedff0ef          	jal	ffffffffc0208944 <get_device>
ffffffffc0208a5c:	87aa                	mv	a5,a0
ffffffffc0208a5e:	e121                	bnez	a0,ffffffffc0208a9e <vfs_lookup+0x54>
ffffffffc0208a60:	6762                	ld	a4,24(sp)
ffffffffc0208a62:	7522                	ld	a0,40(sp)
ffffffffc0208a64:	00074683          	lbu	a3,0(a4)
ffffffffc0208a68:	c2a1                	beqz	a3,ffffffffc0208aa8 <vfs_lookup+0x5e>
ffffffffc0208a6a:	c529                	beqz	a0,ffffffffc0208ab4 <vfs_lookup+0x6a>
ffffffffc0208a6c:	793c                	ld	a5,112(a0)
ffffffffc0208a6e:	c3b9                	beqz	a5,ffffffffc0208ab4 <vfs_lookup+0x6a>
ffffffffc0208a70:	7bbc                	ld	a5,112(a5)
ffffffffc0208a72:	c3a9                	beqz	a5,ffffffffc0208ab4 <vfs_lookup+0x6a>
ffffffffc0208a74:	00006597          	auipc	a1,0x6
ffffffffc0208a78:	c8458593          	addi	a1,a1,-892 # ffffffffc020e6f8 <etext+0x28e4>
ffffffffc0208a7c:	e83a                	sd	a4,16(sp)
ffffffffc0208a7e:	e42a                	sd	a0,8(sp)
ffffffffc0208a80:	dd0ff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208a84:	6522                	ld	a0,8(sp)
ffffffffc0208a86:	65c2                	ld	a1,16(sp)
ffffffffc0208a88:	8622                	mv	a2,s0
ffffffffc0208a8a:	793c                	ld	a5,112(a0)
ffffffffc0208a8c:	7522                	ld	a0,40(sp)
ffffffffc0208a8e:	7bbc                	ld	a5,112(a5)
ffffffffc0208a90:	9782                	jalr	a5
ffffffffc0208a92:	87aa                	mv	a5,a0
ffffffffc0208a94:	7522                	ld	a0,40(sp)
ffffffffc0208a96:	e43e                	sd	a5,8(sp)
ffffffffc0208a98:	e72ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc0208a9c:	67a2                	ld	a5,8(sp)
ffffffffc0208a9e:	70e2                	ld	ra,56(sp)
ffffffffc0208aa0:	7442                	ld	s0,48(sp)
ffffffffc0208aa2:	853e                	mv	a0,a5
ffffffffc0208aa4:	6121                	addi	sp,sp,64
ffffffffc0208aa6:	8082                	ret
ffffffffc0208aa8:	e008                	sd	a0,0(s0)
ffffffffc0208aaa:	70e2                	ld	ra,56(sp)
ffffffffc0208aac:	7442                	ld	s0,48(sp)
ffffffffc0208aae:	853e                	mv	a0,a5
ffffffffc0208ab0:	6121                	addi	sp,sp,64
ffffffffc0208ab2:	8082                	ret
ffffffffc0208ab4:	00006697          	auipc	a3,0x6
ffffffffc0208ab8:	bf468693          	addi	a3,a3,-1036 # ffffffffc020e6a8 <etext+0x2894>
ffffffffc0208abc:	00003617          	auipc	a2,0x3
ffffffffc0208ac0:	79460613          	addi	a2,a2,1940 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208ac4:	04f00593          	li	a1,79
ffffffffc0208ac8:	00006517          	auipc	a0,0x6
ffffffffc0208acc:	bb050513          	addi	a0,a0,-1104 # ffffffffc020e678 <etext+0x2864>
ffffffffc0208ad0:	97bf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208ad4 <vfs_lookup_parent>:
ffffffffc0208ad4:	7139                	addi	sp,sp,-64
ffffffffc0208ad6:	f822                	sd	s0,48(sp)
ffffffffc0208ad8:	f426                	sd	s1,40(sp)
ffffffffc0208ada:	8432                	mv	s0,a2
ffffffffc0208adc:	84ae                	mv	s1,a1
ffffffffc0208ade:	0830                	addi	a2,sp,24
ffffffffc0208ae0:	002c                	addi	a1,sp,8
ffffffffc0208ae2:	fc06                	sd	ra,56(sp)
ffffffffc0208ae4:	e42a                	sd	a0,8(sp)
ffffffffc0208ae6:	e5fff0ef          	jal	ffffffffc0208944 <get_device>
ffffffffc0208aea:	e509                	bnez	a0,ffffffffc0208af4 <vfs_lookup_parent+0x20>
ffffffffc0208aec:	6722                	ld	a4,8(sp)
ffffffffc0208aee:	67e2                	ld	a5,24(sp)
ffffffffc0208af0:	e018                	sd	a4,0(s0)
ffffffffc0208af2:	e09c                	sd	a5,0(s1)
ffffffffc0208af4:	70e2                	ld	ra,56(sp)
ffffffffc0208af6:	7442                	ld	s0,48(sp)
ffffffffc0208af8:	74a2                	ld	s1,40(sp)
ffffffffc0208afa:	6121                	addi	sp,sp,64
ffffffffc0208afc:	8082                	ret

ffffffffc0208afe <vfs_get_curdir>:
ffffffffc0208afe:	0008e797          	auipc	a5,0x8e
ffffffffc0208b02:	dca7b783          	ld	a5,-566(a5) # ffffffffc02968c8 <current>
ffffffffc0208b06:	1101                	addi	sp,sp,-32
ffffffffc0208b08:	e822                	sd	s0,16(sp)
ffffffffc0208b0a:	1487b783          	ld	a5,328(a5)
ffffffffc0208b0e:	ec06                	sd	ra,24(sp)
ffffffffc0208b10:	6380                	ld	s0,0(a5)
ffffffffc0208b12:	cc09                	beqz	s0,ffffffffc0208b2c <vfs_get_curdir+0x2e>
ffffffffc0208b14:	e426                	sd	s1,8(sp)
ffffffffc0208b16:	84aa                	mv	s1,a0
ffffffffc0208b18:	8522                	mv	a0,s0
ffffffffc0208b1a:	d22ff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0208b1e:	e080                	sd	s0,0(s1)
ffffffffc0208b20:	64a2                	ld	s1,8(sp)
ffffffffc0208b22:	4501                	li	a0,0
ffffffffc0208b24:	60e2                	ld	ra,24(sp)
ffffffffc0208b26:	6442                	ld	s0,16(sp)
ffffffffc0208b28:	6105                	addi	sp,sp,32
ffffffffc0208b2a:	8082                	ret
ffffffffc0208b2c:	5541                	li	a0,-16
ffffffffc0208b2e:	bfdd                	j	ffffffffc0208b24 <vfs_get_curdir+0x26>

ffffffffc0208b30 <vfs_set_curdir>:
ffffffffc0208b30:	7139                	addi	sp,sp,-64
ffffffffc0208b32:	f04a                	sd	s2,32(sp)
ffffffffc0208b34:	0008e917          	auipc	s2,0x8e
ffffffffc0208b38:	d9490913          	addi	s2,s2,-620 # ffffffffc02968c8 <current>
ffffffffc0208b3c:	00093783          	ld	a5,0(s2)
ffffffffc0208b40:	f822                	sd	s0,48(sp)
ffffffffc0208b42:	842a                	mv	s0,a0
ffffffffc0208b44:	1487b503          	ld	a0,328(a5)
ffffffffc0208b48:	fc06                	sd	ra,56(sp)
ffffffffc0208b4a:	f426                	sd	s1,40(sp)
ffffffffc0208b4c:	fa4fc0ef          	jal	ffffffffc02052f0 <lock_files>
ffffffffc0208b50:	00093783          	ld	a5,0(s2)
ffffffffc0208b54:	1487b503          	ld	a0,328(a5)
ffffffffc0208b58:	611c                	ld	a5,0(a0)
ffffffffc0208b5a:	06f40a63          	beq	s0,a5,ffffffffc0208bce <vfs_set_curdir+0x9e>
ffffffffc0208b5e:	c02d                	beqz	s0,ffffffffc0208bc0 <vfs_set_curdir+0x90>
ffffffffc0208b60:	7838                	ld	a4,112(s0)
ffffffffc0208b62:	cb25                	beqz	a4,ffffffffc0208bd2 <vfs_set_curdir+0xa2>
ffffffffc0208b64:	6b38                	ld	a4,80(a4)
ffffffffc0208b66:	c735                	beqz	a4,ffffffffc0208bd2 <vfs_set_curdir+0xa2>
ffffffffc0208b68:	00006597          	auipc	a1,0x6
ffffffffc0208b6c:	c0058593          	addi	a1,a1,-1024 # ffffffffc020e768 <etext+0x2954>
ffffffffc0208b70:	8522                	mv	a0,s0
ffffffffc0208b72:	e43e                	sd	a5,8(sp)
ffffffffc0208b74:	cdcff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208b78:	7838                	ld	a4,112(s0)
ffffffffc0208b7a:	086c                	addi	a1,sp,28
ffffffffc0208b7c:	8522                	mv	a0,s0
ffffffffc0208b7e:	6b38                	ld	a4,80(a4)
ffffffffc0208b80:	9702                	jalr	a4
ffffffffc0208b82:	84aa                	mv	s1,a0
ffffffffc0208b84:	e909                	bnez	a0,ffffffffc0208b96 <vfs_set_curdir+0x66>
ffffffffc0208b86:	4772                	lw	a4,28(sp)
ffffffffc0208b88:	4609                	li	a2,2
ffffffffc0208b8a:	54b9                	li	s1,-18
ffffffffc0208b8c:	40c75693          	srai	a3,a4,0xc
ffffffffc0208b90:	8a9d                	andi	a3,a3,7
ffffffffc0208b92:	00c68f63          	beq	a3,a2,ffffffffc0208bb0 <vfs_set_curdir+0x80>
ffffffffc0208b96:	00093783          	ld	a5,0(s2)
ffffffffc0208b9a:	1487b503          	ld	a0,328(a5)
ffffffffc0208b9e:	f58fc0ef          	jal	ffffffffc02052f6 <unlock_files>
ffffffffc0208ba2:	70e2                	ld	ra,56(sp)
ffffffffc0208ba4:	7442                	ld	s0,48(sp)
ffffffffc0208ba6:	7902                	ld	s2,32(sp)
ffffffffc0208ba8:	8526                	mv	a0,s1
ffffffffc0208baa:	74a2                	ld	s1,40(sp)
ffffffffc0208bac:	6121                	addi	sp,sp,64
ffffffffc0208bae:	8082                	ret
ffffffffc0208bb0:	8522                	mv	a0,s0
ffffffffc0208bb2:	c8aff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0208bb6:	00093703          	ld	a4,0(s2)
ffffffffc0208bba:	67a2                	ld	a5,8(sp)
ffffffffc0208bbc:	14873503          	ld	a0,328(a4)
ffffffffc0208bc0:	e100                	sd	s0,0(a0)
ffffffffc0208bc2:	4481                	li	s1,0
ffffffffc0208bc4:	dfe9                	beqz	a5,ffffffffc0208b9e <vfs_set_curdir+0x6e>
ffffffffc0208bc6:	853e                	mv	a0,a5
ffffffffc0208bc8:	d42ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc0208bcc:	b7e9                	j	ffffffffc0208b96 <vfs_set_curdir+0x66>
ffffffffc0208bce:	4481                	li	s1,0
ffffffffc0208bd0:	b7f9                	j	ffffffffc0208b9e <vfs_set_curdir+0x6e>
ffffffffc0208bd2:	00006697          	auipc	a3,0x6
ffffffffc0208bd6:	b2e68693          	addi	a3,a3,-1234 # ffffffffc020e700 <etext+0x28ec>
ffffffffc0208bda:	00003617          	auipc	a2,0x3
ffffffffc0208bde:	67660613          	addi	a2,a2,1654 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208be2:	04300593          	li	a1,67
ffffffffc0208be6:	00006517          	auipc	a0,0x6
ffffffffc0208bea:	b6a50513          	addi	a0,a0,-1174 # ffffffffc020e750 <etext+0x293c>
ffffffffc0208bee:	85df70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208bf2 <vfs_chdir>:
ffffffffc0208bf2:	7179                	addi	sp,sp,-48
ffffffffc0208bf4:	082c                	addi	a1,sp,24
ffffffffc0208bf6:	f406                	sd	ra,40(sp)
ffffffffc0208bf8:	e53ff0ef          	jal	ffffffffc0208a4a <vfs_lookup>
ffffffffc0208bfc:	87aa                	mv	a5,a0
ffffffffc0208bfe:	c509                	beqz	a0,ffffffffc0208c08 <vfs_chdir+0x16>
ffffffffc0208c00:	70a2                	ld	ra,40(sp)
ffffffffc0208c02:	853e                	mv	a0,a5
ffffffffc0208c04:	6145                	addi	sp,sp,48
ffffffffc0208c06:	8082                	ret
ffffffffc0208c08:	6562                	ld	a0,24(sp)
ffffffffc0208c0a:	f27ff0ef          	jal	ffffffffc0208b30 <vfs_set_curdir>
ffffffffc0208c0e:	87aa                	mv	a5,a0
ffffffffc0208c10:	6562                	ld	a0,24(sp)
ffffffffc0208c12:	e43e                	sd	a5,8(sp)
ffffffffc0208c14:	cf6ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc0208c18:	67a2                	ld	a5,8(sp)
ffffffffc0208c1a:	70a2                	ld	ra,40(sp)
ffffffffc0208c1c:	853e                	mv	a0,a5
ffffffffc0208c1e:	6145                	addi	sp,sp,48
ffffffffc0208c20:	8082                	ret

ffffffffc0208c22 <vfs_getcwd>:
ffffffffc0208c22:	0008e797          	auipc	a5,0x8e
ffffffffc0208c26:	ca67b783          	ld	a5,-858(a5) # ffffffffc02968c8 <current>
ffffffffc0208c2a:	7179                	addi	sp,sp,-48
ffffffffc0208c2c:	ec26                	sd	s1,24(sp)
ffffffffc0208c2e:	1487b783          	ld	a5,328(a5)
ffffffffc0208c32:	f406                	sd	ra,40(sp)
ffffffffc0208c34:	f022                	sd	s0,32(sp)
ffffffffc0208c36:	6384                	ld	s1,0(a5)
ffffffffc0208c38:	c0c1                	beqz	s1,ffffffffc0208cb8 <vfs_getcwd+0x96>
ffffffffc0208c3a:	e84a                	sd	s2,16(sp)
ffffffffc0208c3c:	892a                	mv	s2,a0
ffffffffc0208c3e:	8526                	mv	a0,s1
ffffffffc0208c40:	bfcff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0208c44:	74a8                	ld	a0,104(s1)
ffffffffc0208c46:	c93d                	beqz	a0,ffffffffc0208cbc <vfs_getcwd+0x9a>
ffffffffc0208c48:	9a5ff0ef          	jal	ffffffffc02085ec <vfs_get_devname>
ffffffffc0208c4c:	842a                	mv	s0,a0
ffffffffc0208c4e:	0aa030ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc0208c52:	862a                	mv	a2,a0
ffffffffc0208c54:	85a2                	mv	a1,s0
ffffffffc0208c56:	854a                	mv	a0,s2
ffffffffc0208c58:	4701                	li	a4,0
ffffffffc0208c5a:	4685                	li	a3,1
ffffffffc0208c5c:	8bffc0ef          	jal	ffffffffc020551a <iobuf_move>
ffffffffc0208c60:	842a                	mv	s0,a0
ffffffffc0208c62:	c919                	beqz	a0,ffffffffc0208c78 <vfs_getcwd+0x56>
ffffffffc0208c64:	8526                	mv	a0,s1
ffffffffc0208c66:	ca4ff0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc0208c6a:	6942                	ld	s2,16(sp)
ffffffffc0208c6c:	70a2                	ld	ra,40(sp)
ffffffffc0208c6e:	8522                	mv	a0,s0
ffffffffc0208c70:	7402                	ld	s0,32(sp)
ffffffffc0208c72:	64e2                	ld	s1,24(sp)
ffffffffc0208c74:	6145                	addi	sp,sp,48
ffffffffc0208c76:	8082                	ret
ffffffffc0208c78:	4685                	li	a3,1
ffffffffc0208c7a:	03a00793          	li	a5,58
ffffffffc0208c7e:	8636                	mv	a2,a3
ffffffffc0208c80:	4701                	li	a4,0
ffffffffc0208c82:	00f10593          	addi	a1,sp,15
ffffffffc0208c86:	854a                	mv	a0,s2
ffffffffc0208c88:	00f107a3          	sb	a5,15(sp)
ffffffffc0208c8c:	88ffc0ef          	jal	ffffffffc020551a <iobuf_move>
ffffffffc0208c90:	842a                	mv	s0,a0
ffffffffc0208c92:	f969                	bnez	a0,ffffffffc0208c64 <vfs_getcwd+0x42>
ffffffffc0208c94:	78bc                	ld	a5,112(s1)
ffffffffc0208c96:	c3b9                	beqz	a5,ffffffffc0208cdc <vfs_getcwd+0xba>
ffffffffc0208c98:	7f9c                	ld	a5,56(a5)
ffffffffc0208c9a:	c3a9                	beqz	a5,ffffffffc0208cdc <vfs_getcwd+0xba>
ffffffffc0208c9c:	00006597          	auipc	a1,0x6
ffffffffc0208ca0:	b2c58593          	addi	a1,a1,-1236 # ffffffffc020e7c8 <etext+0x29b4>
ffffffffc0208ca4:	8526                	mv	a0,s1
ffffffffc0208ca6:	baaff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208caa:	78bc                	ld	a5,112(s1)
ffffffffc0208cac:	85ca                	mv	a1,s2
ffffffffc0208cae:	8526                	mv	a0,s1
ffffffffc0208cb0:	7f9c                	ld	a5,56(a5)
ffffffffc0208cb2:	9782                	jalr	a5
ffffffffc0208cb4:	842a                	mv	s0,a0
ffffffffc0208cb6:	b77d                	j	ffffffffc0208c64 <vfs_getcwd+0x42>
ffffffffc0208cb8:	5441                	li	s0,-16
ffffffffc0208cba:	bf4d                	j	ffffffffc0208c6c <vfs_getcwd+0x4a>
ffffffffc0208cbc:	00006697          	auipc	a3,0x6
ffffffffc0208cc0:	9d468693          	addi	a3,a3,-1580 # ffffffffc020e690 <etext+0x287c>
ffffffffc0208cc4:	00003617          	auipc	a2,0x3
ffffffffc0208cc8:	58c60613          	addi	a2,a2,1420 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208ccc:	06e00593          	li	a1,110
ffffffffc0208cd0:	00006517          	auipc	a0,0x6
ffffffffc0208cd4:	a8050513          	addi	a0,a0,-1408 # ffffffffc020e750 <etext+0x293c>
ffffffffc0208cd8:	f72f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208cdc:	00006697          	auipc	a3,0x6
ffffffffc0208ce0:	a9468693          	addi	a3,a3,-1388 # ffffffffc020e770 <etext+0x295c>
ffffffffc0208ce4:	00003617          	auipc	a2,0x3
ffffffffc0208ce8:	56c60613          	addi	a2,a2,1388 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208cec:	07800593          	li	a1,120
ffffffffc0208cf0:	00006517          	auipc	a0,0x6
ffffffffc0208cf4:	a6050513          	addi	a0,a0,-1440 # ffffffffc020e750 <etext+0x293c>
ffffffffc0208cf8:	f52f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208cfc <dev_lookup>:
ffffffffc0208cfc:	0005c703          	lbu	a4,0(a1)
ffffffffc0208d00:	ef11                	bnez	a4,ffffffffc0208d1c <dev_lookup+0x20>
ffffffffc0208d02:	1101                	addi	sp,sp,-32
ffffffffc0208d04:	ec06                	sd	ra,24(sp)
ffffffffc0208d06:	e032                	sd	a2,0(sp)
ffffffffc0208d08:	e42a                	sd	a0,8(sp)
ffffffffc0208d0a:	b32ff0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc0208d0e:	6602                	ld	a2,0(sp)
ffffffffc0208d10:	67a2                	ld	a5,8(sp)
ffffffffc0208d12:	60e2                	ld	ra,24(sp)
ffffffffc0208d14:	4501                	li	a0,0
ffffffffc0208d16:	e21c                	sd	a5,0(a2)
ffffffffc0208d18:	6105                	addi	sp,sp,32
ffffffffc0208d1a:	8082                	ret
ffffffffc0208d1c:	5541                	li	a0,-16
ffffffffc0208d1e:	8082                	ret

ffffffffc0208d20 <dev_fstat>:
ffffffffc0208d20:	1101                	addi	sp,sp,-32
ffffffffc0208d22:	e822                	sd	s0,16(sp)
ffffffffc0208d24:	e426                	sd	s1,8(sp)
ffffffffc0208d26:	842a                	mv	s0,a0
ffffffffc0208d28:	84ae                	mv	s1,a1
ffffffffc0208d2a:	852e                	mv	a0,a1
ffffffffc0208d2c:	02000613          	li	a2,32
ffffffffc0208d30:	4581                	li	a1,0
ffffffffc0208d32:	ec06                	sd	ra,24(sp)
ffffffffc0208d34:	078030ef          	jal	ffffffffc020bdac <memset>
ffffffffc0208d38:	c429                	beqz	s0,ffffffffc0208d82 <dev_fstat+0x62>
ffffffffc0208d3a:	783c                	ld	a5,112(s0)
ffffffffc0208d3c:	c3b9                	beqz	a5,ffffffffc0208d82 <dev_fstat+0x62>
ffffffffc0208d3e:	6bbc                	ld	a5,80(a5)
ffffffffc0208d40:	c3a9                	beqz	a5,ffffffffc0208d82 <dev_fstat+0x62>
ffffffffc0208d42:	00006597          	auipc	a1,0x6
ffffffffc0208d46:	a2658593          	addi	a1,a1,-1498 # ffffffffc020e768 <etext+0x2954>
ffffffffc0208d4a:	8522                	mv	a0,s0
ffffffffc0208d4c:	b04ff0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0208d50:	783c                	ld	a5,112(s0)
ffffffffc0208d52:	85a6                	mv	a1,s1
ffffffffc0208d54:	8522                	mv	a0,s0
ffffffffc0208d56:	6bbc                	ld	a5,80(a5)
ffffffffc0208d58:	9782                	jalr	a5
ffffffffc0208d5a:	ed19                	bnez	a0,ffffffffc0208d78 <dev_fstat+0x58>
ffffffffc0208d5c:	4c38                	lw	a4,88(s0)
ffffffffc0208d5e:	6785                	lui	a5,0x1
ffffffffc0208d60:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d64:	02f71f63          	bne	a4,a5,ffffffffc0208da2 <dev_fstat+0x82>
ffffffffc0208d68:	6018                	ld	a4,0(s0)
ffffffffc0208d6a:	641c                	ld	a5,8(s0)
ffffffffc0208d6c:	4685                	li	a3,1
ffffffffc0208d6e:	e898                	sd	a4,16(s1)
ffffffffc0208d70:	02e787b3          	mul	a5,a5,a4
ffffffffc0208d74:	e494                	sd	a3,8(s1)
ffffffffc0208d76:	ec9c                	sd	a5,24(s1)
ffffffffc0208d78:	60e2                	ld	ra,24(sp)
ffffffffc0208d7a:	6442                	ld	s0,16(sp)
ffffffffc0208d7c:	64a2                	ld	s1,8(sp)
ffffffffc0208d7e:	6105                	addi	sp,sp,32
ffffffffc0208d80:	8082                	ret
ffffffffc0208d82:	00006697          	auipc	a3,0x6
ffffffffc0208d86:	97e68693          	addi	a3,a3,-1666 # ffffffffc020e700 <etext+0x28ec>
ffffffffc0208d8a:	00003617          	auipc	a2,0x3
ffffffffc0208d8e:	4c660613          	addi	a2,a2,1222 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208d92:	04200593          	li	a1,66
ffffffffc0208d96:	00006517          	auipc	a0,0x6
ffffffffc0208d9a:	a4250513          	addi	a0,a0,-1470 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208d9e:	eacf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208da2:	00005697          	auipc	a3,0x5
ffffffffc0208da6:	72668693          	addi	a3,a3,1830 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208daa:	00003617          	auipc	a2,0x3
ffffffffc0208dae:	4a660613          	addi	a2,a2,1190 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208db2:	04500593          	li	a1,69
ffffffffc0208db6:	00006517          	auipc	a0,0x6
ffffffffc0208dba:	a2250513          	addi	a0,a0,-1502 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208dbe:	e8cf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208dc2 <dev_ioctl>:
ffffffffc0208dc2:	c909                	beqz	a0,ffffffffc0208dd4 <dev_ioctl+0x12>
ffffffffc0208dc4:	4d34                	lw	a3,88(a0)
ffffffffc0208dc6:	6705                	lui	a4,0x1
ffffffffc0208dc8:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dcc:	00e69463          	bne	a3,a4,ffffffffc0208dd4 <dev_ioctl+0x12>
ffffffffc0208dd0:	751c                	ld	a5,40(a0)
ffffffffc0208dd2:	8782                	jr	a5
ffffffffc0208dd4:	1141                	addi	sp,sp,-16
ffffffffc0208dd6:	00005697          	auipc	a3,0x5
ffffffffc0208dda:	6f268693          	addi	a3,a3,1778 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208dde:	00003617          	auipc	a2,0x3
ffffffffc0208de2:	47260613          	addi	a2,a2,1138 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208de6:	03500593          	li	a1,53
ffffffffc0208dea:	00006517          	auipc	a0,0x6
ffffffffc0208dee:	9ee50513          	addi	a0,a0,-1554 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208df2:	e406                	sd	ra,8(sp)
ffffffffc0208df4:	e56f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208df8 <dev_tryseek>:
ffffffffc0208df8:	c51d                	beqz	a0,ffffffffc0208e26 <dev_tryseek+0x2e>
ffffffffc0208dfa:	4d38                	lw	a4,88(a0)
ffffffffc0208dfc:	6785                	lui	a5,0x1
ffffffffc0208dfe:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e02:	02f71263          	bne	a4,a5,ffffffffc0208e26 <dev_tryseek+0x2e>
ffffffffc0208e06:	611c                	ld	a5,0(a0)
ffffffffc0208e08:	cf89                	beqz	a5,ffffffffc0208e22 <dev_tryseek+0x2a>
ffffffffc0208e0a:	6518                	ld	a4,8(a0)
ffffffffc0208e0c:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208e10:	ea89                	bnez	a3,ffffffffc0208e22 <dev_tryseek+0x2a>
ffffffffc0208e12:	0005c863          	bltz	a1,ffffffffc0208e22 <dev_tryseek+0x2a>
ffffffffc0208e16:	02e787b3          	mul	a5,a5,a4
ffffffffc0208e1a:	4501                	li	a0,0
ffffffffc0208e1c:	00f5f363          	bgeu	a1,a5,ffffffffc0208e22 <dev_tryseek+0x2a>
ffffffffc0208e20:	8082                	ret
ffffffffc0208e22:	5575                	li	a0,-3
ffffffffc0208e24:	8082                	ret
ffffffffc0208e26:	1141                	addi	sp,sp,-16
ffffffffc0208e28:	00005697          	auipc	a3,0x5
ffffffffc0208e2c:	6a068693          	addi	a3,a3,1696 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208e30:	00003617          	auipc	a2,0x3
ffffffffc0208e34:	42060613          	addi	a2,a2,1056 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208e38:	05f00593          	li	a1,95
ffffffffc0208e3c:	00006517          	auipc	a0,0x6
ffffffffc0208e40:	99c50513          	addi	a0,a0,-1636 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208e44:	e406                	sd	ra,8(sp)
ffffffffc0208e46:	e04f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e4a <dev_gettype>:
ffffffffc0208e4a:	cd11                	beqz	a0,ffffffffc0208e66 <dev_gettype+0x1c>
ffffffffc0208e4c:	4d38                	lw	a4,88(a0)
ffffffffc0208e4e:	6785                	lui	a5,0x1
ffffffffc0208e50:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e54:	00f71963          	bne	a4,a5,ffffffffc0208e66 <dev_gettype+0x1c>
ffffffffc0208e58:	6118                	ld	a4,0(a0)
ffffffffc0208e5a:	6791                	lui	a5,0x4
ffffffffc0208e5c:	c311                	beqz	a4,ffffffffc0208e60 <dev_gettype+0x16>
ffffffffc0208e5e:	6795                	lui	a5,0x5
ffffffffc0208e60:	c19c                	sw	a5,0(a1)
ffffffffc0208e62:	4501                	li	a0,0
ffffffffc0208e64:	8082                	ret
ffffffffc0208e66:	1141                	addi	sp,sp,-16
ffffffffc0208e68:	00005697          	auipc	a3,0x5
ffffffffc0208e6c:	66068693          	addi	a3,a3,1632 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208e70:	00003617          	auipc	a2,0x3
ffffffffc0208e74:	3e060613          	addi	a2,a2,992 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208e78:	05300593          	li	a1,83
ffffffffc0208e7c:	00006517          	auipc	a0,0x6
ffffffffc0208e80:	95c50513          	addi	a0,a0,-1700 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208e84:	e406                	sd	ra,8(sp)
ffffffffc0208e86:	dc4f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e8a <dev_write>:
ffffffffc0208e8a:	c911                	beqz	a0,ffffffffc0208e9e <dev_write+0x14>
ffffffffc0208e8c:	4d34                	lw	a3,88(a0)
ffffffffc0208e8e:	6705                	lui	a4,0x1
ffffffffc0208e90:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e94:	00e69563          	bne	a3,a4,ffffffffc0208e9e <dev_write+0x14>
ffffffffc0208e98:	711c                	ld	a5,32(a0)
ffffffffc0208e9a:	4605                	li	a2,1
ffffffffc0208e9c:	8782                	jr	a5
ffffffffc0208e9e:	1141                	addi	sp,sp,-16
ffffffffc0208ea0:	00005697          	auipc	a3,0x5
ffffffffc0208ea4:	62868693          	addi	a3,a3,1576 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208ea8:	00003617          	auipc	a2,0x3
ffffffffc0208eac:	3a860613          	addi	a2,a2,936 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208eb0:	02c00593          	li	a1,44
ffffffffc0208eb4:	00006517          	auipc	a0,0x6
ffffffffc0208eb8:	92450513          	addi	a0,a0,-1756 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208ebc:	e406                	sd	ra,8(sp)
ffffffffc0208ebe:	d8cf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208ec2 <dev_read>:
ffffffffc0208ec2:	c911                	beqz	a0,ffffffffc0208ed6 <dev_read+0x14>
ffffffffc0208ec4:	4d34                	lw	a3,88(a0)
ffffffffc0208ec6:	6705                	lui	a4,0x1
ffffffffc0208ec8:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ecc:	00e69563          	bne	a3,a4,ffffffffc0208ed6 <dev_read+0x14>
ffffffffc0208ed0:	711c                	ld	a5,32(a0)
ffffffffc0208ed2:	4601                	li	a2,0
ffffffffc0208ed4:	8782                	jr	a5
ffffffffc0208ed6:	1141                	addi	sp,sp,-16
ffffffffc0208ed8:	00005697          	auipc	a3,0x5
ffffffffc0208edc:	5f068693          	addi	a3,a3,1520 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208ee0:	00003617          	auipc	a2,0x3
ffffffffc0208ee4:	37060613          	addi	a2,a2,880 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208ee8:	02300593          	li	a1,35
ffffffffc0208eec:	00006517          	auipc	a0,0x6
ffffffffc0208ef0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208ef4:	e406                	sd	ra,8(sp)
ffffffffc0208ef6:	d54f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208efa <dev_close>:
ffffffffc0208efa:	c909                	beqz	a0,ffffffffc0208f0c <dev_close+0x12>
ffffffffc0208efc:	4d34                	lw	a3,88(a0)
ffffffffc0208efe:	6705                	lui	a4,0x1
ffffffffc0208f00:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f04:	00e69463          	bne	a3,a4,ffffffffc0208f0c <dev_close+0x12>
ffffffffc0208f08:	6d1c                	ld	a5,24(a0)
ffffffffc0208f0a:	8782                	jr	a5
ffffffffc0208f0c:	1141                	addi	sp,sp,-16
ffffffffc0208f0e:	00005697          	auipc	a3,0x5
ffffffffc0208f12:	5ba68693          	addi	a3,a3,1466 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208f16:	00003617          	auipc	a2,0x3
ffffffffc0208f1a:	33a60613          	addi	a2,a2,826 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208f1e:	45e9                	li	a1,26
ffffffffc0208f20:	00006517          	auipc	a0,0x6
ffffffffc0208f24:	8b850513          	addi	a0,a0,-1864 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208f28:	e406                	sd	ra,8(sp)
ffffffffc0208f2a:	d20f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208f2e <dev_open>:
ffffffffc0208f2e:	03c5f793          	andi	a5,a1,60
ffffffffc0208f32:	eb91                	bnez	a5,ffffffffc0208f46 <dev_open+0x18>
ffffffffc0208f34:	c919                	beqz	a0,ffffffffc0208f4a <dev_open+0x1c>
ffffffffc0208f36:	4d34                	lw	a3,88(a0)
ffffffffc0208f38:	6785                	lui	a5,0x1
ffffffffc0208f3a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f3e:	00f69663          	bne	a3,a5,ffffffffc0208f4a <dev_open+0x1c>
ffffffffc0208f42:	691c                	ld	a5,16(a0)
ffffffffc0208f44:	8782                	jr	a5
ffffffffc0208f46:	5575                	li	a0,-3
ffffffffc0208f48:	8082                	ret
ffffffffc0208f4a:	1141                	addi	sp,sp,-16
ffffffffc0208f4c:	00005697          	auipc	a3,0x5
ffffffffc0208f50:	57c68693          	addi	a3,a3,1404 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0208f54:	00003617          	auipc	a2,0x3
ffffffffc0208f58:	2fc60613          	addi	a2,a2,764 # ffffffffc020c250 <etext+0x43c>
ffffffffc0208f5c:	45c5                	li	a1,17
ffffffffc0208f5e:	00006517          	auipc	a0,0x6
ffffffffc0208f62:	87a50513          	addi	a0,a0,-1926 # ffffffffc020e7d8 <etext+0x29c4>
ffffffffc0208f66:	e406                	sd	ra,8(sp)
ffffffffc0208f68:	ce2f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208f6c <dev_init>:
ffffffffc0208f6c:	1141                	addi	sp,sp,-16
ffffffffc0208f6e:	e406                	sd	ra,8(sp)
ffffffffc0208f70:	544000ef          	jal	ffffffffc02094b4 <dev_init_stdin>
ffffffffc0208f74:	65c000ef          	jal	ffffffffc02095d0 <dev_init_stdout>
ffffffffc0208f78:	60a2                	ld	ra,8(sp)
ffffffffc0208f7a:	0141                	addi	sp,sp,16
ffffffffc0208f7c:	ac01                	j	ffffffffc020918c <dev_init_disk0>

ffffffffc0208f7e <dev_create_inode>:
ffffffffc0208f7e:	6505                	lui	a0,0x1
ffffffffc0208f80:	1101                	addi	sp,sp,-32
ffffffffc0208f82:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208f86:	ec06                	sd	ra,24(sp)
ffffffffc0208f88:	836ff0ef          	jal	ffffffffc0207fbe <__alloc_inode>
ffffffffc0208f8c:	87aa                	mv	a5,a0
ffffffffc0208f8e:	c911                	beqz	a0,ffffffffc0208fa2 <dev_create_inode+0x24>
ffffffffc0208f90:	4601                	li	a2,0
ffffffffc0208f92:	00007597          	auipc	a1,0x7
ffffffffc0208f96:	c6658593          	addi	a1,a1,-922 # ffffffffc020fbf8 <dev_node_ops>
ffffffffc0208f9a:	e42a                	sd	a0,8(sp)
ffffffffc0208f9c:	83eff0ef          	jal	ffffffffc0207fda <inode_init>
ffffffffc0208fa0:	67a2                	ld	a5,8(sp)
ffffffffc0208fa2:	60e2                	ld	ra,24(sp)
ffffffffc0208fa4:	853e                	mv	a0,a5
ffffffffc0208fa6:	6105                	addi	sp,sp,32
ffffffffc0208fa8:	8082                	ret

ffffffffc0208faa <disk0_open>:
ffffffffc0208faa:	4501                	li	a0,0
ffffffffc0208fac:	8082                	ret

ffffffffc0208fae <disk0_close>:
ffffffffc0208fae:	4501                	li	a0,0
ffffffffc0208fb0:	8082                	ret

ffffffffc0208fb2 <disk0_ioctl>:
ffffffffc0208fb2:	5531                	li	a0,-20
ffffffffc0208fb4:	8082                	ret

ffffffffc0208fb6 <disk0_io>:
ffffffffc0208fb6:	711d                	addi	sp,sp,-96
ffffffffc0208fb8:	6594                	ld	a3,8(a1)
ffffffffc0208fba:	e8a2                	sd	s0,80(sp)
ffffffffc0208fbc:	6d80                	ld	s0,24(a1)
ffffffffc0208fbe:	6785                	lui	a5,0x1
ffffffffc0208fc0:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208fc2:	0086e733          	or	a4,a3,s0
ffffffffc0208fc6:	ec86                	sd	ra,88(sp)
ffffffffc0208fc8:	8f7d                	and	a4,a4,a5
ffffffffc0208fca:	14071663          	bnez	a4,ffffffffc0209116 <disk0_io+0x160>
ffffffffc0208fce:	e0ca                	sd	s2,64(sp)
ffffffffc0208fd0:	43f6d913          	srai	s2,a3,0x3f
ffffffffc0208fd4:	00f97933          	and	s2,s2,a5
ffffffffc0208fd8:	9936                	add	s2,s2,a3
ffffffffc0208fda:	40c95913          	srai	s2,s2,0xc
ffffffffc0208fde:	00c45793          	srli	a5,s0,0xc
ffffffffc0208fe2:	0127873b          	addw	a4,a5,s2
ffffffffc0208fe6:	6114                	ld	a3,0(a0)
ffffffffc0208fe8:	1702                	slli	a4,a4,0x20
ffffffffc0208fea:	9301                	srli	a4,a4,0x20
ffffffffc0208fec:	2901                	sext.w	s2,s2
ffffffffc0208fee:	2781                	sext.w	a5,a5
ffffffffc0208ff0:	12e6e063          	bltu	a3,a4,ffffffffc0209110 <disk0_io+0x15a>
ffffffffc0208ff4:	e799                	bnez	a5,ffffffffc0209002 <disk0_io+0x4c>
ffffffffc0208ff6:	6906                	ld	s2,64(sp)
ffffffffc0208ff8:	4501                	li	a0,0
ffffffffc0208ffa:	60e6                	ld	ra,88(sp)
ffffffffc0208ffc:	6446                	ld	s0,80(sp)
ffffffffc0208ffe:	6125                	addi	sp,sp,96
ffffffffc0209000:	8082                	ret
ffffffffc0209002:	0008d517          	auipc	a0,0x8d
ffffffffc0209006:	83e50513          	addi	a0,a0,-1986 # ffffffffc0295840 <disk0_sem>
ffffffffc020900a:	e4a6                	sd	s1,72(sp)
ffffffffc020900c:	f852                	sd	s4,48(sp)
ffffffffc020900e:	f456                	sd	s5,40(sp)
ffffffffc0209010:	84b2                	mv	s1,a2
ffffffffc0209012:	8aae                	mv	s5,a1
ffffffffc0209014:	0008ea17          	auipc	s4,0x8e
ffffffffc0209018:	8e4a0a13          	addi	s4,s4,-1820 # ffffffffc02968f8 <disk0_buffer>
ffffffffc020901c:	e5efb0ef          	jal	ffffffffc020467a <down>
ffffffffc0209020:	000a3603          	ld	a2,0(s4)
ffffffffc0209024:	e8ad                	bnez	s1,ffffffffc0209096 <disk0_io+0xe0>
ffffffffc0209026:	e862                	sd	s8,16(sp)
ffffffffc0209028:	fc4e                	sd	s3,56(sp)
ffffffffc020902a:	ec5e                	sd	s7,24(sp)
ffffffffc020902c:	6c11                	lui	s8,0x4
ffffffffc020902e:	a029                	j	ffffffffc0209038 <disk0_io+0x82>
ffffffffc0209030:	000a3603          	ld	a2,0(s4)
ffffffffc0209034:	0129893b          	addw	s2,s3,s2
ffffffffc0209038:	84a2                	mv	s1,s0
ffffffffc020903a:	008c7363          	bgeu	s8,s0,ffffffffc0209040 <disk0_io+0x8a>
ffffffffc020903e:	6491                	lui	s1,0x4
ffffffffc0209040:	00c4d993          	srli	s3,s1,0xc
ffffffffc0209044:	2981                	sext.w	s3,s3
ffffffffc0209046:	00399b9b          	slliw	s7,s3,0x3
ffffffffc020904a:	020b9693          	slli	a3,s7,0x20
ffffffffc020904e:	9281                	srli	a3,a3,0x20
ffffffffc0209050:	0039159b          	slliw	a1,s2,0x3
ffffffffc0209054:	4509                	li	a0,2
ffffffffc0209056:	a49f70ef          	jal	ffffffffc0200a9e <ide_read_secs>
ffffffffc020905a:	e16d                	bnez	a0,ffffffffc020913c <disk0_io+0x186>
ffffffffc020905c:	000a3583          	ld	a1,0(s4)
ffffffffc0209060:	0038                	addi	a4,sp,8
ffffffffc0209062:	4685                	li	a3,1
ffffffffc0209064:	8626                	mv	a2,s1
ffffffffc0209066:	8556                	mv	a0,s5
ffffffffc0209068:	cb2fc0ef          	jal	ffffffffc020551a <iobuf_move>
ffffffffc020906c:	67a2                	ld	a5,8(sp)
ffffffffc020906e:	0a979663          	bne	a5,s1,ffffffffc020911a <disk0_io+0x164>
ffffffffc0209072:	03449793          	slli	a5,s1,0x34
ffffffffc0209076:	e3d5                	bnez	a5,ffffffffc020911a <disk0_io+0x164>
ffffffffc0209078:	8c05                	sub	s0,s0,s1
ffffffffc020907a:	f85d                	bnez	s0,ffffffffc0209030 <disk0_io+0x7a>
ffffffffc020907c:	79e2                	ld	s3,56(sp)
ffffffffc020907e:	6be2                	ld	s7,24(sp)
ffffffffc0209080:	6c42                	ld	s8,16(sp)
ffffffffc0209082:	0008c517          	auipc	a0,0x8c
ffffffffc0209086:	7be50513          	addi	a0,a0,1982 # ffffffffc0295840 <disk0_sem>
ffffffffc020908a:	decfb0ef          	jal	ffffffffc0204676 <up>
ffffffffc020908e:	64a6                	ld	s1,72(sp)
ffffffffc0209090:	7a42                	ld	s4,48(sp)
ffffffffc0209092:	7aa2                	ld	s5,40(sp)
ffffffffc0209094:	b78d                	j	ffffffffc0208ff6 <disk0_io+0x40>
ffffffffc0209096:	f05a                	sd	s6,32(sp)
ffffffffc0209098:	a029                	j	ffffffffc02090a2 <disk0_io+0xec>
ffffffffc020909a:	000a3603          	ld	a2,0(s4)
ffffffffc020909e:	0124893b          	addw	s2,s1,s2
ffffffffc02090a2:	85b2                	mv	a1,a2
ffffffffc02090a4:	0038                	addi	a4,sp,8
ffffffffc02090a6:	4681                	li	a3,0
ffffffffc02090a8:	6611                	lui	a2,0x4
ffffffffc02090aa:	8556                	mv	a0,s5
ffffffffc02090ac:	c6efc0ef          	jal	ffffffffc020551a <iobuf_move>
ffffffffc02090b0:	67a2                	ld	a5,8(sp)
ffffffffc02090b2:	fff78713          	addi	a4,a5,-1
ffffffffc02090b6:	02877a63          	bgeu	a4,s0,ffffffffc02090ea <disk0_io+0x134>
ffffffffc02090ba:	03479713          	slli	a4,a5,0x34
ffffffffc02090be:	e715                	bnez	a4,ffffffffc02090ea <disk0_io+0x134>
ffffffffc02090c0:	83b1                	srli	a5,a5,0xc
ffffffffc02090c2:	0007849b          	sext.w	s1,a5
ffffffffc02090c6:	00349b1b          	slliw	s6,s1,0x3
ffffffffc02090ca:	000a3603          	ld	a2,0(s4)
ffffffffc02090ce:	020b1693          	slli	a3,s6,0x20
ffffffffc02090d2:	9281                	srli	a3,a3,0x20
ffffffffc02090d4:	0039159b          	slliw	a1,s2,0x3
ffffffffc02090d8:	4509                	li	a0,2
ffffffffc02090da:	a5ff70ef          	jal	ffffffffc0200b38 <ide_write_secs>
ffffffffc02090de:	e151                	bnez	a0,ffffffffc0209162 <disk0_io+0x1ac>
ffffffffc02090e0:	67a2                	ld	a5,8(sp)
ffffffffc02090e2:	8c1d                	sub	s0,s0,a5
ffffffffc02090e4:	f85d                	bnez	s0,ffffffffc020909a <disk0_io+0xe4>
ffffffffc02090e6:	7b02                	ld	s6,32(sp)
ffffffffc02090e8:	bf69                	j	ffffffffc0209082 <disk0_io+0xcc>
ffffffffc02090ea:	00005697          	auipc	a3,0x5
ffffffffc02090ee:	70668693          	addi	a3,a3,1798 # ffffffffc020e7f0 <etext+0x29dc>
ffffffffc02090f2:	00003617          	auipc	a2,0x3
ffffffffc02090f6:	15e60613          	addi	a2,a2,350 # ffffffffc020c250 <etext+0x43c>
ffffffffc02090fa:	05700593          	li	a1,87
ffffffffc02090fe:	00005517          	auipc	a0,0x5
ffffffffc0209102:	73250513          	addi	a0,a0,1842 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc0209106:	fc4e                	sd	s3,56(sp)
ffffffffc0209108:	ec5e                	sd	s7,24(sp)
ffffffffc020910a:	e862                	sd	s8,16(sp)
ffffffffc020910c:	b3ef70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209110:	6906                	ld	s2,64(sp)
ffffffffc0209112:	5575                	li	a0,-3
ffffffffc0209114:	b5dd                	j	ffffffffc0208ffa <disk0_io+0x44>
ffffffffc0209116:	5575                	li	a0,-3
ffffffffc0209118:	b5cd                	j	ffffffffc0208ffa <disk0_io+0x44>
ffffffffc020911a:	00005697          	auipc	a3,0x5
ffffffffc020911e:	7ce68693          	addi	a3,a3,1998 # ffffffffc020e8e8 <etext+0x2ad4>
ffffffffc0209122:	00003617          	auipc	a2,0x3
ffffffffc0209126:	12e60613          	addi	a2,a2,302 # ffffffffc020c250 <etext+0x43c>
ffffffffc020912a:	06200593          	li	a1,98
ffffffffc020912e:	00005517          	auipc	a0,0x5
ffffffffc0209132:	70250513          	addi	a0,a0,1794 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc0209136:	f05a                	sd	s6,32(sp)
ffffffffc0209138:	b12f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020913c:	88aa                	mv	a7,a0
ffffffffc020913e:	885e                	mv	a6,s7
ffffffffc0209140:	87ce                	mv	a5,s3
ffffffffc0209142:	0039171b          	slliw	a4,s2,0x3
ffffffffc0209146:	86ca                	mv	a3,s2
ffffffffc0209148:	00005617          	auipc	a2,0x5
ffffffffc020914c:	75860613          	addi	a2,a2,1880 # ffffffffc020e8a0 <etext+0x2a8c>
ffffffffc0209150:	02d00593          	li	a1,45
ffffffffc0209154:	00005517          	auipc	a0,0x5
ffffffffc0209158:	6dc50513          	addi	a0,a0,1756 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc020915c:	f05a                	sd	s6,32(sp)
ffffffffc020915e:	aecf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209162:	88aa                	mv	a7,a0
ffffffffc0209164:	885a                	mv	a6,s6
ffffffffc0209166:	87a6                	mv	a5,s1
ffffffffc0209168:	0039171b          	slliw	a4,s2,0x3
ffffffffc020916c:	86ca                	mv	a3,s2
ffffffffc020916e:	00005617          	auipc	a2,0x5
ffffffffc0209172:	6e260613          	addi	a2,a2,1762 # ffffffffc020e850 <etext+0x2a3c>
ffffffffc0209176:	03700593          	li	a1,55
ffffffffc020917a:	00005517          	auipc	a0,0x5
ffffffffc020917e:	6b650513          	addi	a0,a0,1718 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc0209182:	fc4e                	sd	s3,56(sp)
ffffffffc0209184:	ec5e                	sd	s7,24(sp)
ffffffffc0209186:	e862                	sd	s8,16(sp)
ffffffffc0209188:	ac2f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020918c <dev_init_disk0>:
ffffffffc020918c:	1101                	addi	sp,sp,-32
ffffffffc020918e:	ec06                	sd	ra,24(sp)
ffffffffc0209190:	e822                	sd	s0,16(sp)
ffffffffc0209192:	e426                	sd	s1,8(sp)
ffffffffc0209194:	debff0ef          	jal	ffffffffc0208f7e <dev_create_inode>
ffffffffc0209198:	c541                	beqz	a0,ffffffffc0209220 <dev_init_disk0+0x94>
ffffffffc020919a:	4d38                	lw	a4,88(a0)
ffffffffc020919c:	6785                	lui	a5,0x1
ffffffffc020919e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02091a2:	842a                	mv	s0,a0
ffffffffc02091a4:	6485                	lui	s1,0x1
ffffffffc02091a6:	0cf71e63          	bne	a4,a5,ffffffffc0209282 <dev_init_disk0+0xf6>
ffffffffc02091aa:	4509                	li	a0,2
ffffffffc02091ac:	8a7f70ef          	jal	ffffffffc0200a52 <ide_device_valid>
ffffffffc02091b0:	cd4d                	beqz	a0,ffffffffc020926a <dev_init_disk0+0xde>
ffffffffc02091b2:	4509                	li	a0,2
ffffffffc02091b4:	8c3f70ef          	jal	ffffffffc0200a76 <ide_device_size>
ffffffffc02091b8:	00000797          	auipc	a5,0x0
ffffffffc02091bc:	dfa78793          	addi	a5,a5,-518 # ffffffffc0208fb2 <disk0_ioctl>
ffffffffc02091c0:	00000617          	auipc	a2,0x0
ffffffffc02091c4:	dea60613          	addi	a2,a2,-534 # ffffffffc0208faa <disk0_open>
ffffffffc02091c8:	00000697          	auipc	a3,0x0
ffffffffc02091cc:	de668693          	addi	a3,a3,-538 # ffffffffc0208fae <disk0_close>
ffffffffc02091d0:	00000717          	auipc	a4,0x0
ffffffffc02091d4:	de670713          	addi	a4,a4,-538 # ffffffffc0208fb6 <disk0_io>
ffffffffc02091d8:	810d                	srli	a0,a0,0x3
ffffffffc02091da:	f41c                	sd	a5,40(s0)
ffffffffc02091dc:	e008                	sd	a0,0(s0)
ffffffffc02091de:	e810                	sd	a2,16(s0)
ffffffffc02091e0:	ec14                	sd	a3,24(s0)
ffffffffc02091e2:	f018                	sd	a4,32(s0)
ffffffffc02091e4:	4585                	li	a1,1
ffffffffc02091e6:	0008c517          	auipc	a0,0x8c
ffffffffc02091ea:	65a50513          	addi	a0,a0,1626 # ffffffffc0295840 <disk0_sem>
ffffffffc02091ee:	e404                	sd	s1,8(s0)
ffffffffc02091f0:	c80fb0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc02091f4:	6511                	lui	a0,0x4
ffffffffc02091f6:	e07f80ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02091fa:	0008d797          	auipc	a5,0x8d
ffffffffc02091fe:	6ea7bf23          	sd	a0,1790(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc0209202:	c921                	beqz	a0,ffffffffc0209252 <dev_init_disk0+0xc6>
ffffffffc0209204:	85a2                	mv	a1,s0
ffffffffc0209206:	4605                	li	a2,1
ffffffffc0209208:	00005517          	auipc	a0,0x5
ffffffffc020920c:	77050513          	addi	a0,a0,1904 # ffffffffc020e978 <etext+0x2b64>
ffffffffc0209210:	c26ff0ef          	jal	ffffffffc0208636 <vfs_add_dev>
ffffffffc0209214:	e115                	bnez	a0,ffffffffc0209238 <dev_init_disk0+0xac>
ffffffffc0209216:	60e2                	ld	ra,24(sp)
ffffffffc0209218:	6442                	ld	s0,16(sp)
ffffffffc020921a:	64a2                	ld	s1,8(sp)
ffffffffc020921c:	6105                	addi	sp,sp,32
ffffffffc020921e:	8082                	ret
ffffffffc0209220:	00005617          	auipc	a2,0x5
ffffffffc0209224:	6f860613          	addi	a2,a2,1784 # ffffffffc020e918 <etext+0x2b04>
ffffffffc0209228:	08700593          	li	a1,135
ffffffffc020922c:	00005517          	auipc	a0,0x5
ffffffffc0209230:	60450513          	addi	a0,a0,1540 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc0209234:	a16f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209238:	86aa                	mv	a3,a0
ffffffffc020923a:	00005617          	auipc	a2,0x5
ffffffffc020923e:	74660613          	addi	a2,a2,1862 # ffffffffc020e980 <etext+0x2b6c>
ffffffffc0209242:	08d00593          	li	a1,141
ffffffffc0209246:	00005517          	auipc	a0,0x5
ffffffffc020924a:	5ea50513          	addi	a0,a0,1514 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc020924e:	9fcf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209252:	00005617          	auipc	a2,0x5
ffffffffc0209256:	70660613          	addi	a2,a2,1798 # ffffffffc020e958 <etext+0x2b44>
ffffffffc020925a:	07f00593          	li	a1,127
ffffffffc020925e:	00005517          	auipc	a0,0x5
ffffffffc0209262:	5d250513          	addi	a0,a0,1490 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc0209266:	9e4f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020926a:	00005617          	auipc	a2,0x5
ffffffffc020926e:	6ce60613          	addi	a2,a2,1742 # ffffffffc020e938 <etext+0x2b24>
ffffffffc0209272:	07300593          	li	a1,115
ffffffffc0209276:	00005517          	auipc	a0,0x5
ffffffffc020927a:	5ba50513          	addi	a0,a0,1466 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc020927e:	9ccf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209282:	00005697          	auipc	a3,0x5
ffffffffc0209286:	24668693          	addi	a3,a3,582 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc020928a:	00003617          	auipc	a2,0x3
ffffffffc020928e:	fc660613          	addi	a2,a2,-58 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209292:	08900593          	li	a1,137
ffffffffc0209296:	00005517          	auipc	a0,0x5
ffffffffc020929a:	59a50513          	addi	a0,a0,1434 # ffffffffc020e830 <etext+0x2a1c>
ffffffffc020929e:	9acf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02092a2 <stdin_open>:
ffffffffc02092a2:	e199                	bnez	a1,ffffffffc02092a8 <stdin_open+0x6>
ffffffffc02092a4:	4501                	li	a0,0
ffffffffc02092a6:	8082                	ret
ffffffffc02092a8:	5575                	li	a0,-3
ffffffffc02092aa:	8082                	ret

ffffffffc02092ac <stdin_close>:
ffffffffc02092ac:	4501                	li	a0,0
ffffffffc02092ae:	8082                	ret

ffffffffc02092b0 <stdin_ioctl>:
ffffffffc02092b0:	5575                	li	a0,-3
ffffffffc02092b2:	8082                	ret

ffffffffc02092b4 <stdin_io>:
ffffffffc02092b4:	14061f63          	bnez	a2,ffffffffc0209412 <stdin_io+0x15e>
ffffffffc02092b8:	7175                	addi	sp,sp,-144
ffffffffc02092ba:	ecd6                	sd	s5,88(sp)
ffffffffc02092bc:	e8da                	sd	s6,80(sp)
ffffffffc02092be:	e4de                	sd	s7,72(sp)
ffffffffc02092c0:	0185bb03          	ld	s6,24(a1)
ffffffffc02092c4:	0005bb83          	ld	s7,0(a1)
ffffffffc02092c8:	e506                	sd	ra,136(sp)
ffffffffc02092ca:	e122                	sd	s0,128(sp)
ffffffffc02092cc:	8aae                	mv	s5,a1
ffffffffc02092ce:	100027f3          	csrr	a5,sstatus
ffffffffc02092d2:	8b89                	andi	a5,a5,2
ffffffffc02092d4:	12079663          	bnez	a5,ffffffffc0209400 <stdin_io+0x14c>
ffffffffc02092d8:	4401                	li	s0,0
ffffffffc02092da:	120b0a63          	beqz	s6,ffffffffc020940e <stdin_io+0x15a>
ffffffffc02092de:	f8ca                	sd	s2,112(sp)
ffffffffc02092e0:	0008d917          	auipc	s2,0x8d
ffffffffc02092e4:	62890913          	addi	s2,s2,1576 # ffffffffc0296908 <p_rpos>
ffffffffc02092e8:	00093783          	ld	a5,0(s2)
ffffffffc02092ec:	fca6                	sd	s1,120(sp)
ffffffffc02092ee:	6705                	lui	a4,0x1
ffffffffc02092f0:	800004b7          	lui	s1,0x80000
ffffffffc02092f4:	f4ce                	sd	s3,104(sp)
ffffffffc02092f6:	f0d2                	sd	s4,96(sp)
ffffffffc02092f8:	e0e2                	sd	s8,64(sp)
ffffffffc02092fa:	0491                	addi	s1,s1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc02092fc:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209300:	4a01                	li	s4,0
ffffffffc0209302:	0008d997          	auipc	s3,0x8d
ffffffffc0209306:	5fe98993          	addi	s3,s3,1534 # ffffffffc0296900 <p_wpos>
ffffffffc020930a:	0009b703          	ld	a4,0(s3)
ffffffffc020930e:	02e7d763          	bge	a5,a4,ffffffffc020933c <stdin_io+0x88>
ffffffffc0209312:	a045                	j	ffffffffc02093b2 <stdin_io+0xfe>
ffffffffc0209314:	fd2fe0ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc0209318:	100027f3          	csrr	a5,sstatus
ffffffffc020931c:	8b89                	andi	a5,a5,2
ffffffffc020931e:	4401                	li	s0,0
ffffffffc0209320:	e3b1                	bnez	a5,ffffffffc0209364 <stdin_io+0xb0>
ffffffffc0209322:	0828                	addi	a0,sp,24
ffffffffc0209324:	be6fb0ef          	jal	ffffffffc020470a <wait_in_queue>
ffffffffc0209328:	e529                	bnez	a0,ffffffffc0209372 <stdin_io+0xbe>
ffffffffc020932a:	5782                	lw	a5,32(sp)
ffffffffc020932c:	04979d63          	bne	a5,s1,ffffffffc0209386 <stdin_io+0xd2>
ffffffffc0209330:	00093783          	ld	a5,0(s2)
ffffffffc0209334:	0009b703          	ld	a4,0(s3)
ffffffffc0209338:	06e7cd63          	blt	a5,a4,ffffffffc02093b2 <stdin_io+0xfe>
ffffffffc020933c:	80000637          	lui	a2,0x80000
ffffffffc0209340:	0611                	addi	a2,a2,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0209342:	082c                	addi	a1,sp,24
ffffffffc0209344:	0008c517          	auipc	a0,0x8c
ffffffffc0209348:	51450513          	addi	a0,a0,1300 # ffffffffc0295858 <__wait_queue>
ffffffffc020934c:	ceafb0ef          	jal	ffffffffc0204836 <wait_current_set>
ffffffffc0209350:	d071                	beqz	s0,ffffffffc0209314 <stdin_io+0x60>
ffffffffc0209352:	881f70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc0209356:	f90fe0ef          	jal	ffffffffc0207ae6 <schedule>
ffffffffc020935a:	100027f3          	csrr	a5,sstatus
ffffffffc020935e:	8b89                	andi	a5,a5,2
ffffffffc0209360:	4401                	li	s0,0
ffffffffc0209362:	d3e1                	beqz	a5,ffffffffc0209322 <stdin_io+0x6e>
ffffffffc0209364:	875f70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0209368:	0828                	addi	a0,sp,24
ffffffffc020936a:	4405                	li	s0,1
ffffffffc020936c:	b9efb0ef          	jal	ffffffffc020470a <wait_in_queue>
ffffffffc0209370:	dd4d                	beqz	a0,ffffffffc020932a <stdin_io+0x76>
ffffffffc0209372:	082c                	addi	a1,sp,24
ffffffffc0209374:	0008c517          	auipc	a0,0x8c
ffffffffc0209378:	4e450513          	addi	a0,a0,1252 # ffffffffc0295858 <__wait_queue>
ffffffffc020937c:	b34fb0ef          	jal	ffffffffc02046b0 <wait_queue_del>
ffffffffc0209380:	5782                	lw	a5,32(sp)
ffffffffc0209382:	fa9787e3          	beq	a5,s1,ffffffffc0209330 <stdin_io+0x7c>
ffffffffc0209386:	000a051b          	sext.w	a0,s4
ffffffffc020938a:	e42d                	bnez	s0,ffffffffc02093f4 <stdin_io+0x140>
ffffffffc020938c:	c519                	beqz	a0,ffffffffc020939a <stdin_io+0xe6>
ffffffffc020938e:	018ab783          	ld	a5,24(s5)
ffffffffc0209392:	414787b3          	sub	a5,a5,s4
ffffffffc0209396:	00fabc23          	sd	a5,24(s5)
ffffffffc020939a:	74e6                	ld	s1,120(sp)
ffffffffc020939c:	7946                	ld	s2,112(sp)
ffffffffc020939e:	79a6                	ld	s3,104(sp)
ffffffffc02093a0:	7a06                	ld	s4,96(sp)
ffffffffc02093a2:	6c06                	ld	s8,64(sp)
ffffffffc02093a4:	60aa                	ld	ra,136(sp)
ffffffffc02093a6:	640a                	ld	s0,128(sp)
ffffffffc02093a8:	6ae6                	ld	s5,88(sp)
ffffffffc02093aa:	6b46                	ld	s6,80(sp)
ffffffffc02093ac:	6ba6                	ld	s7,72(sp)
ffffffffc02093ae:	6149                	addi	sp,sp,144
ffffffffc02093b0:	8082                	ret
ffffffffc02093b2:	43f7d693          	srai	a3,a5,0x3f
ffffffffc02093b6:	92d1                	srli	a3,a3,0x34
ffffffffc02093b8:	00d78733          	add	a4,a5,a3
ffffffffc02093bc:	01877733          	and	a4,a4,s8
ffffffffc02093c0:	8f15                	sub	a4,a4,a3
ffffffffc02093c2:	0008c697          	auipc	a3,0x8c
ffffffffc02093c6:	4a668693          	addi	a3,a3,1190 # ffffffffc0295868 <stdin_buffer>
ffffffffc02093ca:	9736                	add	a4,a4,a3
ffffffffc02093cc:	00074683          	lbu	a3,0(a4)
ffffffffc02093d0:	0785                	addi	a5,a5,1
ffffffffc02093d2:	014b8733          	add	a4,s7,s4
ffffffffc02093d6:	001a051b          	addiw	a0,s4,1
ffffffffc02093da:	00f93023          	sd	a5,0(s2)
ffffffffc02093de:	00d70023          	sb	a3,0(a4)
ffffffffc02093e2:	0a05                	addi	s4,s4,1
ffffffffc02093e4:	f36a63e3          	bltu	s4,s6,ffffffffc020930a <stdin_io+0x56>
ffffffffc02093e8:	d05d                	beqz	s0,ffffffffc020938e <stdin_io+0xda>
ffffffffc02093ea:	e42a                	sd	a0,8(sp)
ffffffffc02093ec:	fe6f70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02093f0:	6522                	ld	a0,8(sp)
ffffffffc02093f2:	bf71                	j	ffffffffc020938e <stdin_io+0xda>
ffffffffc02093f4:	e42a                	sd	a0,8(sp)
ffffffffc02093f6:	fdcf70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc02093fa:	6522                	ld	a0,8(sp)
ffffffffc02093fc:	f949                	bnez	a0,ffffffffc020938e <stdin_io+0xda>
ffffffffc02093fe:	bf71                	j	ffffffffc020939a <stdin_io+0xe6>
ffffffffc0209400:	fd8f70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc0209404:	4405                	li	s0,1
ffffffffc0209406:	ec0b1ce3          	bnez	s6,ffffffffc02092de <stdin_io+0x2a>
ffffffffc020940a:	fc8f70ef          	jal	ffffffffc0200bd2 <intr_enable>
ffffffffc020940e:	4501                	li	a0,0
ffffffffc0209410:	bf51                	j	ffffffffc02093a4 <stdin_io+0xf0>
ffffffffc0209412:	5575                	li	a0,-3
ffffffffc0209414:	8082                	ret

ffffffffc0209416 <dev_stdin_write>:
ffffffffc0209416:	e111                	bnez	a0,ffffffffc020941a <dev_stdin_write+0x4>
ffffffffc0209418:	8082                	ret
ffffffffc020941a:	1101                	addi	sp,sp,-32
ffffffffc020941c:	ec06                	sd	ra,24(sp)
ffffffffc020941e:	e822                	sd	s0,16(sp)
ffffffffc0209420:	100027f3          	csrr	a5,sstatus
ffffffffc0209424:	8b89                	andi	a5,a5,2
ffffffffc0209426:	4401                	li	s0,0
ffffffffc0209428:	e3c1                	bnez	a5,ffffffffc02094a8 <dev_stdin_write+0x92>
ffffffffc020942a:	0008d717          	auipc	a4,0x8d
ffffffffc020942e:	4d673703          	ld	a4,1238(a4) # ffffffffc0296900 <p_wpos>
ffffffffc0209432:	6585                	lui	a1,0x1
ffffffffc0209434:	fff58613          	addi	a2,a1,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209438:	43f75693          	srai	a3,a4,0x3f
ffffffffc020943c:	92d1                	srli	a3,a3,0x34
ffffffffc020943e:	00d707b3          	add	a5,a4,a3
ffffffffc0209442:	8ff1                	and	a5,a5,a2
ffffffffc0209444:	0008d617          	auipc	a2,0x8d
ffffffffc0209448:	4c463603          	ld	a2,1220(a2) # ffffffffc0296908 <p_rpos>
ffffffffc020944c:	8f95                	sub	a5,a5,a3
ffffffffc020944e:	0008c697          	auipc	a3,0x8c
ffffffffc0209452:	41a68693          	addi	a3,a3,1050 # ffffffffc0295868 <stdin_buffer>
ffffffffc0209456:	97b6                	add	a5,a5,a3
ffffffffc0209458:	00a78023          	sb	a0,0(a5)
ffffffffc020945c:	40c707b3          	sub	a5,a4,a2
ffffffffc0209460:	00b7d763          	bge	a5,a1,ffffffffc020946e <dev_stdin_write+0x58>
ffffffffc0209464:	0705                	addi	a4,a4,1
ffffffffc0209466:	0008d797          	auipc	a5,0x8d
ffffffffc020946a:	48e7bd23          	sd	a4,1178(a5) # ffffffffc0296900 <p_wpos>
ffffffffc020946e:	0008c517          	auipc	a0,0x8c
ffffffffc0209472:	3ea50513          	addi	a0,a0,1002 # ffffffffc0295858 <__wait_queue>
ffffffffc0209476:	a88fb0ef          	jal	ffffffffc02046fe <wait_queue_empty>
ffffffffc020947a:	c919                	beqz	a0,ffffffffc0209490 <dev_stdin_write+0x7a>
ffffffffc020947c:	e409                	bnez	s0,ffffffffc0209486 <dev_stdin_write+0x70>
ffffffffc020947e:	60e2                	ld	ra,24(sp)
ffffffffc0209480:	6442                	ld	s0,16(sp)
ffffffffc0209482:	6105                	addi	sp,sp,32
ffffffffc0209484:	8082                	ret
ffffffffc0209486:	6442                	ld	s0,16(sp)
ffffffffc0209488:	60e2                	ld	ra,24(sp)
ffffffffc020948a:	6105                	addi	sp,sp,32
ffffffffc020948c:	f46f706f          	j	ffffffffc0200bd2 <intr_enable>
ffffffffc0209490:	800005b7          	lui	a1,0x80000
ffffffffc0209494:	0591                	addi	a1,a1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0209496:	4605                	li	a2,1
ffffffffc0209498:	0008c517          	auipc	a0,0x8c
ffffffffc020949c:	3c050513          	addi	a0,a0,960 # ffffffffc0295858 <__wait_queue>
ffffffffc02094a0:	ac6fb0ef          	jal	ffffffffc0204766 <wakeup_queue>
ffffffffc02094a4:	dc69                	beqz	s0,ffffffffc020947e <dev_stdin_write+0x68>
ffffffffc02094a6:	b7c5                	j	ffffffffc0209486 <dev_stdin_write+0x70>
ffffffffc02094a8:	e42a                	sd	a0,8(sp)
ffffffffc02094aa:	f2ef70ef          	jal	ffffffffc0200bd8 <intr_disable>
ffffffffc02094ae:	6522                	ld	a0,8(sp)
ffffffffc02094b0:	4405                	li	s0,1
ffffffffc02094b2:	bfa5                	j	ffffffffc020942a <dev_stdin_write+0x14>

ffffffffc02094b4 <dev_init_stdin>:
ffffffffc02094b4:	1101                	addi	sp,sp,-32
ffffffffc02094b6:	ec06                	sd	ra,24(sp)
ffffffffc02094b8:	ac7ff0ef          	jal	ffffffffc0208f7e <dev_create_inode>
ffffffffc02094bc:	c935                	beqz	a0,ffffffffc0209530 <dev_init_stdin+0x7c>
ffffffffc02094be:	4d38                	lw	a4,88(a0)
ffffffffc02094c0:	6785                	lui	a5,0x1
ffffffffc02094c2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02094c6:	08f71e63          	bne	a4,a5,ffffffffc0209562 <dev_init_stdin+0xae>
ffffffffc02094ca:	4785                	li	a5,1
ffffffffc02094cc:	e51c                	sd	a5,8(a0)
ffffffffc02094ce:	00000797          	auipc	a5,0x0
ffffffffc02094d2:	dd478793          	addi	a5,a5,-556 # ffffffffc02092a2 <stdin_open>
ffffffffc02094d6:	e91c                	sd	a5,16(a0)
ffffffffc02094d8:	00000797          	auipc	a5,0x0
ffffffffc02094dc:	dd478793          	addi	a5,a5,-556 # ffffffffc02092ac <stdin_close>
ffffffffc02094e0:	ed1c                	sd	a5,24(a0)
ffffffffc02094e2:	00000797          	auipc	a5,0x0
ffffffffc02094e6:	dd278793          	addi	a5,a5,-558 # ffffffffc02092b4 <stdin_io>
ffffffffc02094ea:	f11c                	sd	a5,32(a0)
ffffffffc02094ec:	00000797          	auipc	a5,0x0
ffffffffc02094f0:	dc478793          	addi	a5,a5,-572 # ffffffffc02092b0 <stdin_ioctl>
ffffffffc02094f4:	f51c                	sd	a5,40(a0)
ffffffffc02094f6:	00053023          	sd	zero,0(a0)
ffffffffc02094fa:	e42a                	sd	a0,8(sp)
ffffffffc02094fc:	0008c517          	auipc	a0,0x8c
ffffffffc0209500:	35c50513          	addi	a0,a0,860 # ffffffffc0295858 <__wait_queue>
ffffffffc0209504:	0008d797          	auipc	a5,0x8d
ffffffffc0209508:	3e07be23          	sd	zero,1020(a5) # ffffffffc0296900 <p_wpos>
ffffffffc020950c:	0008d797          	auipc	a5,0x8d
ffffffffc0209510:	3e07be23          	sd	zero,1020(a5) # ffffffffc0296908 <p_rpos>
ffffffffc0209514:	996fb0ef          	jal	ffffffffc02046aa <wait_queue_init>
ffffffffc0209518:	65a2                	ld	a1,8(sp)
ffffffffc020951a:	4601                	li	a2,0
ffffffffc020951c:	00005517          	auipc	a0,0x5
ffffffffc0209520:	4c450513          	addi	a0,a0,1220 # ffffffffc020e9e0 <etext+0x2bcc>
ffffffffc0209524:	912ff0ef          	jal	ffffffffc0208636 <vfs_add_dev>
ffffffffc0209528:	e105                	bnez	a0,ffffffffc0209548 <dev_init_stdin+0x94>
ffffffffc020952a:	60e2                	ld	ra,24(sp)
ffffffffc020952c:	6105                	addi	sp,sp,32
ffffffffc020952e:	8082                	ret
ffffffffc0209530:	00005617          	auipc	a2,0x5
ffffffffc0209534:	47060613          	addi	a2,a2,1136 # ffffffffc020e9a0 <etext+0x2b8c>
ffffffffc0209538:	07500593          	li	a1,117
ffffffffc020953c:	00005517          	auipc	a0,0x5
ffffffffc0209540:	48450513          	addi	a0,a0,1156 # ffffffffc020e9c0 <etext+0x2bac>
ffffffffc0209544:	f07f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209548:	86aa                	mv	a3,a0
ffffffffc020954a:	00005617          	auipc	a2,0x5
ffffffffc020954e:	49e60613          	addi	a2,a2,1182 # ffffffffc020e9e8 <etext+0x2bd4>
ffffffffc0209552:	07b00593          	li	a1,123
ffffffffc0209556:	00005517          	auipc	a0,0x5
ffffffffc020955a:	46a50513          	addi	a0,a0,1130 # ffffffffc020e9c0 <etext+0x2bac>
ffffffffc020955e:	eedf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209562:	00005697          	auipc	a3,0x5
ffffffffc0209566:	f6668693          	addi	a3,a3,-154 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc020956a:	00003617          	auipc	a2,0x3
ffffffffc020956e:	ce660613          	addi	a2,a2,-794 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209572:	07700593          	li	a1,119
ffffffffc0209576:	00005517          	auipc	a0,0x5
ffffffffc020957a:	44a50513          	addi	a0,a0,1098 # ffffffffc020e9c0 <etext+0x2bac>
ffffffffc020957e:	ecdf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209582 <stdout_open>:
ffffffffc0209582:	4785                	li	a5,1
ffffffffc0209584:	00f59463          	bne	a1,a5,ffffffffc020958c <stdout_open+0xa>
ffffffffc0209588:	4501                	li	a0,0
ffffffffc020958a:	8082                	ret
ffffffffc020958c:	5575                	li	a0,-3
ffffffffc020958e:	8082                	ret

ffffffffc0209590 <stdout_close>:
ffffffffc0209590:	4501                	li	a0,0
ffffffffc0209592:	8082                	ret

ffffffffc0209594 <stdout_ioctl>:
ffffffffc0209594:	5575                	li	a0,-3
ffffffffc0209596:	8082                	ret

ffffffffc0209598 <stdout_io>:
ffffffffc0209598:	ca15                	beqz	a2,ffffffffc02095cc <stdout_io+0x34>
ffffffffc020959a:	6d9c                	ld	a5,24(a1)
ffffffffc020959c:	c795                	beqz	a5,ffffffffc02095c8 <stdout_io+0x30>
ffffffffc020959e:	1101                	addi	sp,sp,-32
ffffffffc02095a0:	e822                	sd	s0,16(sp)
ffffffffc02095a2:	6180                	ld	s0,0(a1)
ffffffffc02095a4:	e426                	sd	s1,8(sp)
ffffffffc02095a6:	ec06                	sd	ra,24(sp)
ffffffffc02095a8:	84ae                	mv	s1,a1
ffffffffc02095aa:	00044503          	lbu	a0,0(s0)
ffffffffc02095ae:	0405                	addi	s0,s0,1
ffffffffc02095b0:	c31f60ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02095b4:	6c9c                	ld	a5,24(s1)
ffffffffc02095b6:	17fd                	addi	a5,a5,-1
ffffffffc02095b8:	ec9c                	sd	a5,24(s1)
ffffffffc02095ba:	fbe5                	bnez	a5,ffffffffc02095aa <stdout_io+0x12>
ffffffffc02095bc:	60e2                	ld	ra,24(sp)
ffffffffc02095be:	6442                	ld	s0,16(sp)
ffffffffc02095c0:	64a2                	ld	s1,8(sp)
ffffffffc02095c2:	4501                	li	a0,0
ffffffffc02095c4:	6105                	addi	sp,sp,32
ffffffffc02095c6:	8082                	ret
ffffffffc02095c8:	4501                	li	a0,0
ffffffffc02095ca:	8082                	ret
ffffffffc02095cc:	5575                	li	a0,-3
ffffffffc02095ce:	8082                	ret

ffffffffc02095d0 <dev_init_stdout>:
ffffffffc02095d0:	1141                	addi	sp,sp,-16
ffffffffc02095d2:	e406                	sd	ra,8(sp)
ffffffffc02095d4:	9abff0ef          	jal	ffffffffc0208f7e <dev_create_inode>
ffffffffc02095d8:	c939                	beqz	a0,ffffffffc020962e <dev_init_stdout+0x5e>
ffffffffc02095da:	4d38                	lw	a4,88(a0)
ffffffffc02095dc:	6785                	lui	a5,0x1
ffffffffc02095de:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02095e2:	06f71f63          	bne	a4,a5,ffffffffc0209660 <dev_init_stdout+0x90>
ffffffffc02095e6:	4785                	li	a5,1
ffffffffc02095e8:	e51c                	sd	a5,8(a0)
ffffffffc02095ea:	00000797          	auipc	a5,0x0
ffffffffc02095ee:	f9878793          	addi	a5,a5,-104 # ffffffffc0209582 <stdout_open>
ffffffffc02095f2:	e91c                	sd	a5,16(a0)
ffffffffc02095f4:	00000797          	auipc	a5,0x0
ffffffffc02095f8:	f9c78793          	addi	a5,a5,-100 # ffffffffc0209590 <stdout_close>
ffffffffc02095fc:	ed1c                	sd	a5,24(a0)
ffffffffc02095fe:	00000797          	auipc	a5,0x0
ffffffffc0209602:	f9a78793          	addi	a5,a5,-102 # ffffffffc0209598 <stdout_io>
ffffffffc0209606:	f11c                	sd	a5,32(a0)
ffffffffc0209608:	00000797          	auipc	a5,0x0
ffffffffc020960c:	f8c78793          	addi	a5,a5,-116 # ffffffffc0209594 <stdout_ioctl>
ffffffffc0209610:	f51c                	sd	a5,40(a0)
ffffffffc0209612:	00053023          	sd	zero,0(a0)
ffffffffc0209616:	85aa                	mv	a1,a0
ffffffffc0209618:	4601                	li	a2,0
ffffffffc020961a:	00005517          	auipc	a0,0x5
ffffffffc020961e:	42e50513          	addi	a0,a0,1070 # ffffffffc020ea48 <etext+0x2c34>
ffffffffc0209622:	814ff0ef          	jal	ffffffffc0208636 <vfs_add_dev>
ffffffffc0209626:	e105                	bnez	a0,ffffffffc0209646 <dev_init_stdout+0x76>
ffffffffc0209628:	60a2                	ld	ra,8(sp)
ffffffffc020962a:	0141                	addi	sp,sp,16
ffffffffc020962c:	8082                	ret
ffffffffc020962e:	00005617          	auipc	a2,0x5
ffffffffc0209632:	3da60613          	addi	a2,a2,986 # ffffffffc020ea08 <etext+0x2bf4>
ffffffffc0209636:	03700593          	li	a1,55
ffffffffc020963a:	00005517          	auipc	a0,0x5
ffffffffc020963e:	3ee50513          	addi	a0,a0,1006 # ffffffffc020ea28 <etext+0x2c14>
ffffffffc0209642:	e09f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209646:	86aa                	mv	a3,a0
ffffffffc0209648:	00005617          	auipc	a2,0x5
ffffffffc020964c:	40860613          	addi	a2,a2,1032 # ffffffffc020ea50 <etext+0x2c3c>
ffffffffc0209650:	03d00593          	li	a1,61
ffffffffc0209654:	00005517          	auipc	a0,0x5
ffffffffc0209658:	3d450513          	addi	a0,a0,980 # ffffffffc020ea28 <etext+0x2c14>
ffffffffc020965c:	deff60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209660:	00005697          	auipc	a3,0x5
ffffffffc0209664:	e6868693          	addi	a3,a3,-408 # ffffffffc020e4c8 <etext+0x26b4>
ffffffffc0209668:	00003617          	auipc	a2,0x3
ffffffffc020966c:	be860613          	addi	a2,a2,-1048 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209670:	03900593          	li	a1,57
ffffffffc0209674:	00005517          	auipc	a0,0x5
ffffffffc0209678:	3b450513          	addi	a0,a0,948 # ffffffffc020ea28 <etext+0x2c14>
ffffffffc020967c:	dcff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209680 <bitmap_translate.part.0>:
ffffffffc0209680:	1141                	addi	sp,sp,-16
ffffffffc0209682:	00005697          	auipc	a3,0x5
ffffffffc0209686:	3ee68693          	addi	a3,a3,1006 # ffffffffc020ea70 <etext+0x2c5c>
ffffffffc020968a:	00003617          	auipc	a2,0x3
ffffffffc020968e:	bc660613          	addi	a2,a2,-1082 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209692:	04c00593          	li	a1,76
ffffffffc0209696:	00005517          	auipc	a0,0x5
ffffffffc020969a:	3f250513          	addi	a0,a0,1010 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc020969e:	e406                	sd	ra,8(sp)
ffffffffc02096a0:	dabf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02096a4 <bitmap_create>:
ffffffffc02096a4:	7139                	addi	sp,sp,-64
ffffffffc02096a6:	fc06                	sd	ra,56(sp)
ffffffffc02096a8:	f822                	sd	s0,48(sp)
ffffffffc02096aa:	f426                	sd	s1,40(sp)
ffffffffc02096ac:	c179                	beqz	a0,ffffffffc0209772 <bitmap_create+0xce>
ffffffffc02096ae:	842a                	mv	s0,a0
ffffffffc02096b0:	4541                	li	a0,16
ffffffffc02096b2:	94bf80ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02096b6:	84aa                	mv	s1,a0
ffffffffc02096b8:	c555                	beqz	a0,ffffffffc0209764 <bitmap_create+0xc0>
ffffffffc02096ba:	e852                	sd	s4,16(sp)
ffffffffc02096bc:	02041a13          	slli	s4,s0,0x20
ffffffffc02096c0:	020a5a13          	srli	s4,s4,0x20
ffffffffc02096c4:	f04a                	sd	s2,32(sp)
ffffffffc02096c6:	01fa0913          	addi	s2,s4,31
ffffffffc02096ca:	ec4e                	sd	s3,24(sp)
ffffffffc02096cc:	00595993          	srli	s3,s2,0x5
ffffffffc02096d0:	00299613          	slli	a2,s3,0x2
ffffffffc02096d4:	8532                	mv	a0,a2
ffffffffc02096d6:	e432                	sd	a2,8(sp)
ffffffffc02096d8:	925f80ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc02096dc:	6622                	ld	a2,8(sp)
ffffffffc02096de:	cd2d                	beqz	a0,ffffffffc0209758 <bitmap_create+0xb4>
ffffffffc02096e0:	c080                	sw	s0,0(s1)
ffffffffc02096e2:	0134a223          	sw	s3,4(s1)
ffffffffc02096e6:	0ff00593          	li	a1,255
ffffffffc02096ea:	6c2020ef          	jal	ffffffffc020bdac <memset>
ffffffffc02096ee:	4785                	li	a5,1
ffffffffc02096f0:	1796                	slli	a5,a5,0x25
ffffffffc02096f2:	1781                	addi	a5,a5,-32
ffffffffc02096f4:	e488                	sd	a0,8(s1)
ffffffffc02096f6:	00f97933          	and	s2,s2,a5
ffffffffc02096fa:	052a0663          	beq	s4,s2,ffffffffc0209746 <bitmap_create+0xa2>
ffffffffc02096fe:	39fd                	addiw	s3,s3,-1
ffffffffc0209700:	0054571b          	srliw	a4,s0,0x5
ffffffffc0209704:	0b371963          	bne	a4,s3,ffffffffc02097b6 <bitmap_create+0x112>
ffffffffc0209708:	0057179b          	slliw	a5,a4,0x5
ffffffffc020970c:	40f407bb          	subw	a5,s0,a5
ffffffffc0209710:	fff7861b          	addiw	a2,a5,-1
ffffffffc0209714:	46f9                	li	a3,30
ffffffffc0209716:	08c6e063          	bltu	a3,a2,ffffffffc0209796 <bitmap_create+0xf2>
ffffffffc020971a:	070a                	slli	a4,a4,0x2
ffffffffc020971c:	953a                	add	a0,a0,a4
ffffffffc020971e:	4118                	lw	a4,0(a0)
ffffffffc0209720:	4585                	li	a1,1
ffffffffc0209722:	02000613          	li	a2,32
ffffffffc0209726:	00f596bb          	sllw	a3,a1,a5
ffffffffc020972a:	2785                	addiw	a5,a5,1
ffffffffc020972c:	8f35                	xor	a4,a4,a3
ffffffffc020972e:	fec79ce3          	bne	a5,a2,ffffffffc0209726 <bitmap_create+0x82>
ffffffffc0209732:	7442                	ld	s0,48(sp)
ffffffffc0209734:	70e2                	ld	ra,56(sp)
ffffffffc0209736:	c118                	sw	a4,0(a0)
ffffffffc0209738:	7902                	ld	s2,32(sp)
ffffffffc020973a:	69e2                	ld	s3,24(sp)
ffffffffc020973c:	6a42                	ld	s4,16(sp)
ffffffffc020973e:	8526                	mv	a0,s1
ffffffffc0209740:	74a2                	ld	s1,40(sp)
ffffffffc0209742:	6121                	addi	sp,sp,64
ffffffffc0209744:	8082                	ret
ffffffffc0209746:	7442                	ld	s0,48(sp)
ffffffffc0209748:	70e2                	ld	ra,56(sp)
ffffffffc020974a:	7902                	ld	s2,32(sp)
ffffffffc020974c:	69e2                	ld	s3,24(sp)
ffffffffc020974e:	6a42                	ld	s4,16(sp)
ffffffffc0209750:	8526                	mv	a0,s1
ffffffffc0209752:	74a2                	ld	s1,40(sp)
ffffffffc0209754:	6121                	addi	sp,sp,64
ffffffffc0209756:	8082                	ret
ffffffffc0209758:	8526                	mv	a0,s1
ffffffffc020975a:	949f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020975e:	7902                	ld	s2,32(sp)
ffffffffc0209760:	69e2                	ld	s3,24(sp)
ffffffffc0209762:	6a42                	ld	s4,16(sp)
ffffffffc0209764:	7442                	ld	s0,48(sp)
ffffffffc0209766:	70e2                	ld	ra,56(sp)
ffffffffc0209768:	4481                	li	s1,0
ffffffffc020976a:	8526                	mv	a0,s1
ffffffffc020976c:	74a2                	ld	s1,40(sp)
ffffffffc020976e:	6121                	addi	sp,sp,64
ffffffffc0209770:	8082                	ret
ffffffffc0209772:	00005697          	auipc	a3,0x5
ffffffffc0209776:	32e68693          	addi	a3,a3,814 # ffffffffc020eaa0 <etext+0x2c8c>
ffffffffc020977a:	00003617          	auipc	a2,0x3
ffffffffc020977e:	ad660613          	addi	a2,a2,-1322 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209782:	45d5                	li	a1,21
ffffffffc0209784:	00005517          	auipc	a0,0x5
ffffffffc0209788:	30450513          	addi	a0,a0,772 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc020978c:	f04a                	sd	s2,32(sp)
ffffffffc020978e:	ec4e                	sd	s3,24(sp)
ffffffffc0209790:	e852                	sd	s4,16(sp)
ffffffffc0209792:	cb9f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209796:	00005697          	auipc	a3,0x5
ffffffffc020979a:	34a68693          	addi	a3,a3,842 # ffffffffc020eae0 <etext+0x2ccc>
ffffffffc020979e:	00003617          	auipc	a2,0x3
ffffffffc02097a2:	ab260613          	addi	a2,a2,-1358 # ffffffffc020c250 <etext+0x43c>
ffffffffc02097a6:	02b00593          	li	a1,43
ffffffffc02097aa:	00005517          	auipc	a0,0x5
ffffffffc02097ae:	2de50513          	addi	a0,a0,734 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc02097b2:	c99f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02097b6:	00005697          	auipc	a3,0x5
ffffffffc02097ba:	31268693          	addi	a3,a3,786 # ffffffffc020eac8 <etext+0x2cb4>
ffffffffc02097be:	00003617          	auipc	a2,0x3
ffffffffc02097c2:	a9260613          	addi	a2,a2,-1390 # ffffffffc020c250 <etext+0x43c>
ffffffffc02097c6:	02a00593          	li	a1,42
ffffffffc02097ca:	00005517          	auipc	a0,0x5
ffffffffc02097ce:	2be50513          	addi	a0,a0,702 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc02097d2:	c79f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02097d6 <bitmap_alloc>:
ffffffffc02097d6:	4150                	lw	a2,4(a0)
ffffffffc02097d8:	c229                	beqz	a2,ffffffffc020981a <bitmap_alloc+0x44>
ffffffffc02097da:	6518                	ld	a4,8(a0)
ffffffffc02097dc:	4781                	li	a5,0
ffffffffc02097de:	a029                	j	ffffffffc02097e8 <bitmap_alloc+0x12>
ffffffffc02097e0:	2785                	addiw	a5,a5,1
ffffffffc02097e2:	0711                	addi	a4,a4,4
ffffffffc02097e4:	02f60b63          	beq	a2,a5,ffffffffc020981a <bitmap_alloc+0x44>
ffffffffc02097e8:	4314                	lw	a3,0(a4)
ffffffffc02097ea:	dafd                	beqz	a3,ffffffffc02097e0 <bitmap_alloc+0xa>
ffffffffc02097ec:	0016f613          	andi	a2,a3,1
ffffffffc02097f0:	ea29                	bnez	a2,ffffffffc0209842 <bitmap_alloc+0x6c>
ffffffffc02097f2:	02000893          	li	a7,32
ffffffffc02097f6:	4305                	li	t1,1
ffffffffc02097f8:	2605                	addiw	a2,a2,1
ffffffffc02097fa:	03160263          	beq	a2,a7,ffffffffc020981e <bitmap_alloc+0x48>
ffffffffc02097fe:	00c3153b          	sllw	a0,t1,a2
ffffffffc0209802:	00a6f833          	and	a6,a3,a0
ffffffffc0209806:	fe0809e3          	beqz	a6,ffffffffc02097f8 <bitmap_alloc+0x22>
ffffffffc020980a:	8ea9                	xor	a3,a3,a0
ffffffffc020980c:	0057979b          	slliw	a5,a5,0x5
ffffffffc0209810:	c314                	sw	a3,0(a4)
ffffffffc0209812:	9fb1                	addw	a5,a5,a2
ffffffffc0209814:	c19c                	sw	a5,0(a1)
ffffffffc0209816:	4501                	li	a0,0
ffffffffc0209818:	8082                	ret
ffffffffc020981a:	5571                	li	a0,-4
ffffffffc020981c:	8082                	ret
ffffffffc020981e:	1141                	addi	sp,sp,-16
ffffffffc0209820:	00005697          	auipc	a3,0x5
ffffffffc0209824:	2e868693          	addi	a3,a3,744 # ffffffffc020eb08 <etext+0x2cf4>
ffffffffc0209828:	00003617          	auipc	a2,0x3
ffffffffc020982c:	a2860613          	addi	a2,a2,-1496 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209830:	04300593          	li	a1,67
ffffffffc0209834:	00005517          	auipc	a0,0x5
ffffffffc0209838:	25450513          	addi	a0,a0,596 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc020983c:	e406                	sd	ra,8(sp)
ffffffffc020983e:	c0df60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209842:	8532                	mv	a0,a2
ffffffffc0209844:	4601                	li	a2,0
ffffffffc0209846:	b7d1                	j	ffffffffc020980a <bitmap_alloc+0x34>

ffffffffc0209848 <bitmap_test>:
ffffffffc0209848:	411c                	lw	a5,0(a0)
ffffffffc020984a:	00f5ff63          	bgeu	a1,a5,ffffffffc0209868 <bitmap_test+0x20>
ffffffffc020984e:	651c                	ld	a5,8(a0)
ffffffffc0209850:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209854:	070a                	slli	a4,a4,0x2
ffffffffc0209856:	97ba                	add	a5,a5,a4
ffffffffc0209858:	439c                	lw	a5,0(a5)
ffffffffc020985a:	4505                	li	a0,1
ffffffffc020985c:	00b5153b          	sllw	a0,a0,a1
ffffffffc0209860:	8d7d                	and	a0,a0,a5
ffffffffc0209862:	1502                	slli	a0,a0,0x20
ffffffffc0209864:	9101                	srli	a0,a0,0x20
ffffffffc0209866:	8082                	ret
ffffffffc0209868:	1141                	addi	sp,sp,-16
ffffffffc020986a:	e406                	sd	ra,8(sp)
ffffffffc020986c:	e15ff0ef          	jal	ffffffffc0209680 <bitmap_translate.part.0>

ffffffffc0209870 <bitmap_free>:
ffffffffc0209870:	411c                	lw	a5,0(a0)
ffffffffc0209872:	1141                	addi	sp,sp,-16
ffffffffc0209874:	e406                	sd	ra,8(sp)
ffffffffc0209876:	02f5f363          	bgeu	a1,a5,ffffffffc020989c <bitmap_free+0x2c>
ffffffffc020987a:	651c                	ld	a5,8(a0)
ffffffffc020987c:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209880:	070a                	slli	a4,a4,0x2
ffffffffc0209882:	97ba                	add	a5,a5,a4
ffffffffc0209884:	4394                	lw	a3,0(a5)
ffffffffc0209886:	4705                	li	a4,1
ffffffffc0209888:	00b715bb          	sllw	a1,a4,a1
ffffffffc020988c:	00b6f733          	and	a4,a3,a1
ffffffffc0209890:	eb01                	bnez	a4,ffffffffc02098a0 <bitmap_free+0x30>
ffffffffc0209892:	60a2                	ld	ra,8(sp)
ffffffffc0209894:	8ecd                	or	a3,a3,a1
ffffffffc0209896:	c394                	sw	a3,0(a5)
ffffffffc0209898:	0141                	addi	sp,sp,16
ffffffffc020989a:	8082                	ret
ffffffffc020989c:	de5ff0ef          	jal	ffffffffc0209680 <bitmap_translate.part.0>
ffffffffc02098a0:	00005697          	auipc	a3,0x5
ffffffffc02098a4:	27068693          	addi	a3,a3,624 # ffffffffc020eb10 <etext+0x2cfc>
ffffffffc02098a8:	00003617          	auipc	a2,0x3
ffffffffc02098ac:	9a860613          	addi	a2,a2,-1624 # ffffffffc020c250 <etext+0x43c>
ffffffffc02098b0:	05f00593          	li	a1,95
ffffffffc02098b4:	00005517          	auipc	a0,0x5
ffffffffc02098b8:	1d450513          	addi	a0,a0,468 # ffffffffc020ea88 <etext+0x2c74>
ffffffffc02098bc:	b8ff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02098c0 <bitmap_destroy>:
ffffffffc02098c0:	1141                	addi	sp,sp,-16
ffffffffc02098c2:	e022                	sd	s0,0(sp)
ffffffffc02098c4:	842a                	mv	s0,a0
ffffffffc02098c6:	6508                	ld	a0,8(a0)
ffffffffc02098c8:	e406                	sd	ra,8(sp)
ffffffffc02098ca:	fd8f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc02098ce:	8522                	mv	a0,s0
ffffffffc02098d0:	6402                	ld	s0,0(sp)
ffffffffc02098d2:	60a2                	ld	ra,8(sp)
ffffffffc02098d4:	0141                	addi	sp,sp,16
ffffffffc02098d6:	fccf806f          	j	ffffffffc02020a2 <kfree>

ffffffffc02098da <bitmap_getdata>:
ffffffffc02098da:	c589                	beqz	a1,ffffffffc02098e4 <bitmap_getdata+0xa>
ffffffffc02098dc:	00456783          	lwu	a5,4(a0)
ffffffffc02098e0:	078a                	slli	a5,a5,0x2
ffffffffc02098e2:	e19c                	sd	a5,0(a1)
ffffffffc02098e4:	6508                	ld	a0,8(a0)
ffffffffc02098e6:	8082                	ret

ffffffffc02098e8 <sfs_init>:
ffffffffc02098e8:	1141                	addi	sp,sp,-16
ffffffffc02098ea:	00005517          	auipc	a0,0x5
ffffffffc02098ee:	08e50513          	addi	a0,a0,142 # ffffffffc020e978 <etext+0x2b64>
ffffffffc02098f2:	e406                	sd	ra,8(sp)
ffffffffc02098f4:	576000ef          	jal	ffffffffc0209e6a <sfs_mount>
ffffffffc02098f8:	e501                	bnez	a0,ffffffffc0209900 <sfs_init+0x18>
ffffffffc02098fa:	60a2                	ld	ra,8(sp)
ffffffffc02098fc:	0141                	addi	sp,sp,16
ffffffffc02098fe:	8082                	ret
ffffffffc0209900:	86aa                	mv	a3,a0
ffffffffc0209902:	00005617          	auipc	a2,0x5
ffffffffc0209906:	21e60613          	addi	a2,a2,542 # ffffffffc020eb20 <etext+0x2d0c>
ffffffffc020990a:	45c1                	li	a1,16
ffffffffc020990c:	00005517          	auipc	a0,0x5
ffffffffc0209910:	23450513          	addi	a0,a0,564 # ffffffffc020eb40 <etext+0x2d2c>
ffffffffc0209914:	b37f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209918 <sfs_unmount>:
ffffffffc0209918:	1141                	addi	sp,sp,-16
ffffffffc020991a:	e406                	sd	ra,8(sp)
ffffffffc020991c:	e022                	sd	s0,0(sp)
ffffffffc020991e:	cd1d                	beqz	a0,ffffffffc020995c <sfs_unmount+0x44>
ffffffffc0209920:	0b052783          	lw	a5,176(a0)
ffffffffc0209924:	842a                	mv	s0,a0
ffffffffc0209926:	eb9d                	bnez	a5,ffffffffc020995c <sfs_unmount+0x44>
ffffffffc0209928:	7158                	ld	a4,160(a0)
ffffffffc020992a:	09850793          	addi	a5,a0,152
ffffffffc020992e:	02f71563          	bne	a4,a5,ffffffffc0209958 <sfs_unmount+0x40>
ffffffffc0209932:	613c                	ld	a5,64(a0)
ffffffffc0209934:	e7a1                	bnez	a5,ffffffffc020997c <sfs_unmount+0x64>
ffffffffc0209936:	7d08                	ld	a0,56(a0)
ffffffffc0209938:	f89ff0ef          	jal	ffffffffc02098c0 <bitmap_destroy>
ffffffffc020993c:	6428                	ld	a0,72(s0)
ffffffffc020993e:	f64f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0209942:	7448                	ld	a0,168(s0)
ffffffffc0209944:	f5ef80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0209948:	8522                	mv	a0,s0
ffffffffc020994a:	f58f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020994e:	4501                	li	a0,0
ffffffffc0209950:	60a2                	ld	ra,8(sp)
ffffffffc0209952:	6402                	ld	s0,0(sp)
ffffffffc0209954:	0141                	addi	sp,sp,16
ffffffffc0209956:	8082                	ret
ffffffffc0209958:	5545                	li	a0,-15
ffffffffc020995a:	bfdd                	j	ffffffffc0209950 <sfs_unmount+0x38>
ffffffffc020995c:	00005697          	auipc	a3,0x5
ffffffffc0209960:	1fc68693          	addi	a3,a3,508 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209964:	00003617          	auipc	a2,0x3
ffffffffc0209968:	8ec60613          	addi	a2,a2,-1812 # ffffffffc020c250 <etext+0x43c>
ffffffffc020996c:	04100593          	li	a1,65
ffffffffc0209970:	00005517          	auipc	a0,0x5
ffffffffc0209974:	21850513          	addi	a0,a0,536 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209978:	ad3f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020997c:	00005697          	auipc	a3,0x5
ffffffffc0209980:	22468693          	addi	a3,a3,548 # ffffffffc020eba0 <etext+0x2d8c>
ffffffffc0209984:	00003617          	auipc	a2,0x3
ffffffffc0209988:	8cc60613          	addi	a2,a2,-1844 # ffffffffc020c250 <etext+0x43c>
ffffffffc020998c:	04500593          	li	a1,69
ffffffffc0209990:	00005517          	auipc	a0,0x5
ffffffffc0209994:	1f850513          	addi	a0,a0,504 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209998:	ab3f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020999c <sfs_cleanup>:
ffffffffc020999c:	1101                	addi	sp,sp,-32
ffffffffc020999e:	ec06                	sd	ra,24(sp)
ffffffffc02099a0:	e426                	sd	s1,8(sp)
ffffffffc02099a2:	c13d                	beqz	a0,ffffffffc0209a08 <sfs_cleanup+0x6c>
ffffffffc02099a4:	0b052783          	lw	a5,176(a0)
ffffffffc02099a8:	84aa                	mv	s1,a0
ffffffffc02099aa:	efb9                	bnez	a5,ffffffffc0209a08 <sfs_cleanup+0x6c>
ffffffffc02099ac:	4158                	lw	a4,4(a0)
ffffffffc02099ae:	4514                	lw	a3,8(a0)
ffffffffc02099b0:	00c50593          	addi	a1,a0,12
ffffffffc02099b4:	00005517          	auipc	a0,0x5
ffffffffc02099b8:	20450513          	addi	a0,a0,516 # ffffffffc020ebb8 <etext+0x2da4>
ffffffffc02099bc:	40d7063b          	subw	a2,a4,a3
ffffffffc02099c0:	e822                	sd	s0,16(sp)
ffffffffc02099c2:	fe4f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02099c6:	02000413          	li	s0,32
ffffffffc02099ca:	a019                	j	ffffffffc02099d0 <sfs_cleanup+0x34>
ffffffffc02099cc:	347d                	addiw	s0,s0,-1
ffffffffc02099ce:	c811                	beqz	s0,ffffffffc02099e2 <sfs_cleanup+0x46>
ffffffffc02099d0:	7cdc                	ld	a5,184(s1)
ffffffffc02099d2:	8526                	mv	a0,s1
ffffffffc02099d4:	9782                	jalr	a5
ffffffffc02099d6:	f97d                	bnez	a0,ffffffffc02099cc <sfs_cleanup+0x30>
ffffffffc02099d8:	6442                	ld	s0,16(sp)
ffffffffc02099da:	60e2                	ld	ra,24(sp)
ffffffffc02099dc:	64a2                	ld	s1,8(sp)
ffffffffc02099de:	6105                	addi	sp,sp,32
ffffffffc02099e0:	8082                	ret
ffffffffc02099e2:	6442                	ld	s0,16(sp)
ffffffffc02099e4:	60e2                	ld	ra,24(sp)
ffffffffc02099e6:	00c48693          	addi	a3,s1,12
ffffffffc02099ea:	64a2                	ld	s1,8(sp)
ffffffffc02099ec:	872a                	mv	a4,a0
ffffffffc02099ee:	00005617          	auipc	a2,0x5
ffffffffc02099f2:	1ea60613          	addi	a2,a2,490 # ffffffffc020ebd8 <etext+0x2dc4>
ffffffffc02099f6:	05f00593          	li	a1,95
ffffffffc02099fa:	00005517          	auipc	a0,0x5
ffffffffc02099fe:	18e50513          	addi	a0,a0,398 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209a02:	6105                	addi	sp,sp,32
ffffffffc0209a04:	ab1f606f          	j	ffffffffc02004b4 <__warn>
ffffffffc0209a08:	00005697          	auipc	a3,0x5
ffffffffc0209a0c:	15068693          	addi	a3,a3,336 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209a10:	00003617          	auipc	a2,0x3
ffffffffc0209a14:	84060613          	addi	a2,a2,-1984 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209a18:	05400593          	li	a1,84
ffffffffc0209a1c:	00005517          	auipc	a0,0x5
ffffffffc0209a20:	16c50513          	addi	a0,a0,364 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209a24:	e822                	sd	s0,16(sp)
ffffffffc0209a26:	e04a                	sd	s2,0(sp)
ffffffffc0209a28:	a23f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209a2c <sfs_sync>:
ffffffffc0209a2c:	7179                	addi	sp,sp,-48
ffffffffc0209a2e:	f406                	sd	ra,40(sp)
ffffffffc0209a30:	e44e                	sd	s3,8(sp)
ffffffffc0209a32:	c94d                	beqz	a0,ffffffffc0209ae4 <sfs_sync+0xb8>
ffffffffc0209a34:	0b052783          	lw	a5,176(a0)
ffffffffc0209a38:	89aa                	mv	s3,a0
ffffffffc0209a3a:	e7cd                	bnez	a5,ffffffffc0209ae4 <sfs_sync+0xb8>
ffffffffc0209a3c:	f022                	sd	s0,32(sp)
ffffffffc0209a3e:	e84a                	sd	s2,16(sp)
ffffffffc0209a40:	611010ef          	jal	ffffffffc020b850 <lock_sfs_fs>
ffffffffc0209a44:	0a09b403          	ld	s0,160(s3)
ffffffffc0209a48:	09898913          	addi	s2,s3,152
ffffffffc0209a4c:	02890663          	beq	s2,s0,ffffffffc0209a78 <sfs_sync+0x4c>
ffffffffc0209a50:	7c1c                	ld	a5,56(s0)
ffffffffc0209a52:	cbad                	beqz	a5,ffffffffc0209ac4 <sfs_sync+0x98>
ffffffffc0209a54:	7b9c                	ld	a5,48(a5)
ffffffffc0209a56:	c7bd                	beqz	a5,ffffffffc0209ac4 <sfs_sync+0x98>
ffffffffc0209a58:	fc840513          	addi	a0,s0,-56
ffffffffc0209a5c:	00004597          	auipc	a1,0x4
ffffffffc0209a60:	12458593          	addi	a1,a1,292 # ffffffffc020db80 <etext+0x1d6c>
ffffffffc0209a64:	decfe0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0209a68:	7c1c                	ld	a5,56(s0)
ffffffffc0209a6a:	fc840513          	addi	a0,s0,-56
ffffffffc0209a6e:	7b9c                	ld	a5,48(a5)
ffffffffc0209a70:	9782                	jalr	a5
ffffffffc0209a72:	6400                	ld	s0,8(s0)
ffffffffc0209a74:	fc891ee3          	bne	s2,s0,ffffffffc0209a50 <sfs_sync+0x24>
ffffffffc0209a78:	854e                	mv	a0,s3
ffffffffc0209a7a:	5e7010ef          	jal	ffffffffc020b860 <unlock_sfs_fs>
ffffffffc0209a7e:	0409b783          	ld	a5,64(s3)
ffffffffc0209a82:	4501                	li	a0,0
ffffffffc0209a84:	e799                	bnez	a5,ffffffffc0209a92 <sfs_sync+0x66>
ffffffffc0209a86:	7402                	ld	s0,32(sp)
ffffffffc0209a88:	70a2                	ld	ra,40(sp)
ffffffffc0209a8a:	6942                	ld	s2,16(sp)
ffffffffc0209a8c:	69a2                	ld	s3,8(sp)
ffffffffc0209a8e:	6145                	addi	sp,sp,48
ffffffffc0209a90:	8082                	ret
ffffffffc0209a92:	0409b023          	sd	zero,64(s3)
ffffffffc0209a96:	854e                	mv	a0,s3
ffffffffc0209a98:	499010ef          	jal	ffffffffc020b730 <sfs_sync_super>
ffffffffc0209a9c:	c911                	beqz	a0,ffffffffc0209ab0 <sfs_sync+0x84>
ffffffffc0209a9e:	7402                	ld	s0,32(sp)
ffffffffc0209aa0:	70a2                	ld	ra,40(sp)
ffffffffc0209aa2:	4785                	li	a5,1
ffffffffc0209aa4:	04f9b023          	sd	a5,64(s3)
ffffffffc0209aa8:	6942                	ld	s2,16(sp)
ffffffffc0209aaa:	69a2                	ld	s3,8(sp)
ffffffffc0209aac:	6145                	addi	sp,sp,48
ffffffffc0209aae:	8082                	ret
ffffffffc0209ab0:	854e                	mv	a0,s3
ffffffffc0209ab2:	4c5010ef          	jal	ffffffffc020b776 <sfs_sync_freemap>
ffffffffc0209ab6:	f565                	bnez	a0,ffffffffc0209a9e <sfs_sync+0x72>
ffffffffc0209ab8:	7402                	ld	s0,32(sp)
ffffffffc0209aba:	70a2                	ld	ra,40(sp)
ffffffffc0209abc:	6942                	ld	s2,16(sp)
ffffffffc0209abe:	69a2                	ld	s3,8(sp)
ffffffffc0209ac0:	6145                	addi	sp,sp,48
ffffffffc0209ac2:	8082                	ret
ffffffffc0209ac4:	00004697          	auipc	a3,0x4
ffffffffc0209ac8:	06c68693          	addi	a3,a3,108 # ffffffffc020db30 <etext+0x1d1c>
ffffffffc0209acc:	00002617          	auipc	a2,0x2
ffffffffc0209ad0:	78460613          	addi	a2,a2,1924 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209ad4:	45ed                	li	a1,27
ffffffffc0209ad6:	00005517          	auipc	a0,0x5
ffffffffc0209ada:	0b250513          	addi	a0,a0,178 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209ade:	ec26                	sd	s1,24(sp)
ffffffffc0209ae0:	96bf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209ae4:	00005697          	auipc	a3,0x5
ffffffffc0209ae8:	07468693          	addi	a3,a3,116 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209aec:	00002617          	auipc	a2,0x2
ffffffffc0209af0:	76460613          	addi	a2,a2,1892 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209af4:	45d5                	li	a1,21
ffffffffc0209af6:	00005517          	auipc	a0,0x5
ffffffffc0209afa:	09250513          	addi	a0,a0,146 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209afe:	f022                	sd	s0,32(sp)
ffffffffc0209b00:	ec26                	sd	s1,24(sp)
ffffffffc0209b02:	e84a                	sd	s2,16(sp)
ffffffffc0209b04:	947f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209b08 <sfs_get_root>:
ffffffffc0209b08:	1101                	addi	sp,sp,-32
ffffffffc0209b0a:	ec06                	sd	ra,24(sp)
ffffffffc0209b0c:	cd09                	beqz	a0,ffffffffc0209b26 <sfs_get_root+0x1e>
ffffffffc0209b0e:	0b052783          	lw	a5,176(a0)
ffffffffc0209b12:	eb91                	bnez	a5,ffffffffc0209b26 <sfs_get_root+0x1e>
ffffffffc0209b14:	4605                	li	a2,1
ffffffffc0209b16:	002c                	addi	a1,sp,8
ffffffffc0209b18:	376010ef          	jal	ffffffffc020ae8e <sfs_load_inode>
ffffffffc0209b1c:	e50d                	bnez	a0,ffffffffc0209b46 <sfs_get_root+0x3e>
ffffffffc0209b1e:	60e2                	ld	ra,24(sp)
ffffffffc0209b20:	6522                	ld	a0,8(sp)
ffffffffc0209b22:	6105                	addi	sp,sp,32
ffffffffc0209b24:	8082                	ret
ffffffffc0209b26:	00005697          	auipc	a3,0x5
ffffffffc0209b2a:	03268693          	addi	a3,a3,50 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209b2e:	00002617          	auipc	a2,0x2
ffffffffc0209b32:	72260613          	addi	a2,a2,1826 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209b36:	03600593          	li	a1,54
ffffffffc0209b3a:	00005517          	auipc	a0,0x5
ffffffffc0209b3e:	04e50513          	addi	a0,a0,78 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209b42:	909f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209b46:	86aa                	mv	a3,a0
ffffffffc0209b48:	00005617          	auipc	a2,0x5
ffffffffc0209b4c:	0b060613          	addi	a2,a2,176 # ffffffffc020ebf8 <etext+0x2de4>
ffffffffc0209b50:	03700593          	li	a1,55
ffffffffc0209b54:	00005517          	auipc	a0,0x5
ffffffffc0209b58:	03450513          	addi	a0,a0,52 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209b5c:	8eff60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209b60 <sfs_do_mount>:
ffffffffc0209b60:	7171                	addi	sp,sp,-176
ffffffffc0209b62:	e54e                	sd	s3,136(sp)
ffffffffc0209b64:	00853983          	ld	s3,8(a0)
ffffffffc0209b68:	f506                	sd	ra,168(sp)
ffffffffc0209b6a:	6785                	lui	a5,0x1
ffffffffc0209b6c:	26f99a63          	bne	s3,a5,ffffffffc0209de0 <sfs_do_mount+0x280>
ffffffffc0209b70:	ed26                	sd	s1,152(sp)
ffffffffc0209b72:	84aa                	mv	s1,a0
ffffffffc0209b74:	4501                	li	a0,0
ffffffffc0209b76:	f122                	sd	s0,160(sp)
ffffffffc0209b78:	f4de                	sd	s7,104(sp)
ffffffffc0209b7a:	8bae                	mv	s7,a1
ffffffffc0209b7c:	ec0fe0ef          	jal	ffffffffc020823c <__alloc_fs>
ffffffffc0209b80:	842a                	mv	s0,a0
ffffffffc0209b82:	26050663          	beqz	a0,ffffffffc0209dee <sfs_do_mount+0x28e>
ffffffffc0209b86:	e152                	sd	s4,128(sp)
ffffffffc0209b88:	0b052a03          	lw	s4,176(a0)
ffffffffc0209b8c:	e94a                	sd	s2,144(sp)
ffffffffc0209b8e:	280a1763          	bnez	s4,ffffffffc0209e1c <sfs_do_mount+0x2bc>
ffffffffc0209b92:	f904                	sd	s1,48(a0)
ffffffffc0209b94:	854e                	mv	a0,s3
ffffffffc0209b96:	c66f80ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0209b9a:	e428                	sd	a0,72(s0)
ffffffffc0209b9c:	892a                	mv	s2,a0
ffffffffc0209b9e:	16050863          	beqz	a0,ffffffffc0209d0e <sfs_do_mount+0x1ae>
ffffffffc0209ba2:	864e                	mv	a2,s3
ffffffffc0209ba4:	4681                	li	a3,0
ffffffffc0209ba6:	85ca                	mv	a1,s2
ffffffffc0209ba8:	1008                	addi	a0,sp,32
ffffffffc0209baa:	967fb0ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0209bae:	709c                	ld	a5,32(s1)
ffffffffc0209bb0:	85aa                	mv	a1,a0
ffffffffc0209bb2:	4601                	li	a2,0
ffffffffc0209bb4:	8526                	mv	a0,s1
ffffffffc0209bb6:	9782                	jalr	a5
ffffffffc0209bb8:	89aa                	mv	s3,a0
ffffffffc0209bba:	12051a63          	bnez	a0,ffffffffc0209cee <sfs_do_mount+0x18e>
ffffffffc0209bbe:	00092583          	lw	a1,0(s2)
ffffffffc0209bc2:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc0209bc6:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc0209bca:	14c59d63          	bne	a1,a2,ffffffffc0209d24 <sfs_do_mount+0x1c4>
ffffffffc0209bce:	00492783          	lw	a5,4(s2)
ffffffffc0209bd2:	6090                	ld	a2,0(s1)
ffffffffc0209bd4:	02079713          	slli	a4,a5,0x20
ffffffffc0209bd8:	9301                	srli	a4,a4,0x20
ffffffffc0209bda:	12e66c63          	bltu	a2,a4,ffffffffc0209d12 <sfs_do_mount+0x1b2>
ffffffffc0209bde:	e4ee                	sd	s11,72(sp)
ffffffffc0209be0:	01892503          	lw	a0,24(s2)
ffffffffc0209be4:	00892e03          	lw	t3,8(s2)
ffffffffc0209be8:	00c92303          	lw	t1,12(s2)
ffffffffc0209bec:	01092883          	lw	a7,16(s2)
ffffffffc0209bf0:	01492803          	lw	a6,20(s2)
ffffffffc0209bf4:	01c92603          	lw	a2,28(s2)
ffffffffc0209bf8:	02092683          	lw	a3,32(s2)
ffffffffc0209bfc:	02492703          	lw	a4,36(s2)
ffffffffc0209c00:	020905a3          	sb	zero,43(s2)
ffffffffc0209c04:	cc08                	sw	a0,24(s0)
ffffffffc0209c06:	01c42423          	sw	t3,8(s0)
ffffffffc0209c0a:	00642623          	sw	t1,12(s0)
ffffffffc0209c0e:	01142823          	sw	a7,16(s0)
ffffffffc0209c12:	01042a23          	sw	a6,20(s0)
ffffffffc0209c16:	cc50                	sw	a2,28(s0)
ffffffffc0209c18:	d014                	sw	a3,32(s0)
ffffffffc0209c1a:	d058                	sw	a4,36(s0)
ffffffffc0209c1c:	c00c                	sw	a1,0(s0)
ffffffffc0209c1e:	c05c                	sw	a5,4(s0)
ffffffffc0209c20:	02892783          	lw	a5,40(s2)
ffffffffc0209c24:	6511                	lui	a0,0x4
ffffffffc0209c26:	d41c                	sw	a5,40(s0)
ffffffffc0209c28:	bd4f80ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc0209c2c:	f448                	sd	a0,168(s0)
ffffffffc0209c2e:	87aa                	mv	a5,a0
ffffffffc0209c30:	8daa                	mv	s11,a0
ffffffffc0209c32:	1a050963          	beqz	a0,ffffffffc0209de4 <sfs_do_mount+0x284>
ffffffffc0209c36:	6711                	lui	a4,0x4
ffffffffc0209c38:	fcd6                	sd	s5,120(sp)
ffffffffc0209c3a:	ece6                	sd	s9,88(sp)
ffffffffc0209c3c:	e8ea                	sd	s10,80(sp)
ffffffffc0209c3e:	972a                	add	a4,a4,a0
ffffffffc0209c40:	e79c                	sd	a5,8(a5)
ffffffffc0209c42:	e39c                	sd	a5,0(a5)
ffffffffc0209c44:	07c1                	addi	a5,a5,16 # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc0209c46:	fee79de3          	bne	a5,a4,ffffffffc0209c40 <sfs_do_mount+0xe0>
ffffffffc0209c4a:	00496783          	lwu	a5,4(s2)
ffffffffc0209c4e:	6721                	lui	a4,0x8
ffffffffc0209c50:	fff70a93          	addi	s5,a4,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209c54:	97d6                	add	a5,a5,s5
ffffffffc0209c56:	7761                	lui	a4,0xffff8
ffffffffc0209c58:	8ff9                	and	a5,a5,a4
ffffffffc0209c5a:	0007851b          	sext.w	a0,a5
ffffffffc0209c5e:	00078c9b          	sext.w	s9,a5
ffffffffc0209c62:	a43ff0ef          	jal	ffffffffc02096a4 <bitmap_create>
ffffffffc0209c66:	fc08                	sd	a0,56(s0)
ffffffffc0209c68:	8d2a                	mv	s10,a0
ffffffffc0209c6a:	16050963          	beqz	a0,ffffffffc0209ddc <sfs_do_mount+0x27c>
ffffffffc0209c6e:	00492783          	lw	a5,4(s2)
ffffffffc0209c72:	082c                	addi	a1,sp,24
ffffffffc0209c74:	e43e                	sd	a5,8(sp)
ffffffffc0209c76:	c65ff0ef          	jal	ffffffffc02098da <bitmap_getdata>
ffffffffc0209c7a:	16050f63          	beqz	a0,ffffffffc0209df8 <sfs_do_mount+0x298>
ffffffffc0209c7e:	00816783          	lwu	a5,8(sp)
ffffffffc0209c82:	66e2                	ld	a3,24(sp)
ffffffffc0209c84:	97d6                	add	a5,a5,s5
ffffffffc0209c86:	83bd                	srli	a5,a5,0xf
ffffffffc0209c88:	00c7971b          	slliw	a4,a5,0xc
ffffffffc0209c8c:	1702                	slli	a4,a4,0x20
ffffffffc0209c8e:	9301                	srli	a4,a4,0x20
ffffffffc0209c90:	16d71463          	bne	a4,a3,ffffffffc0209df8 <sfs_do_mount+0x298>
ffffffffc0209c94:	f0e2                	sd	s8,96(sp)
ffffffffc0209c96:	00c79713          	slli	a4,a5,0xc
ffffffffc0209c9a:	00e50c33          	add	s8,a0,a4
ffffffffc0209c9e:	8aaa                	mv	s5,a0
ffffffffc0209ca0:	cbd9                	beqz	a5,ffffffffc0209d36 <sfs_do_mount+0x1d6>
ffffffffc0209ca2:	6789                	lui	a5,0x2
ffffffffc0209ca4:	f8da                	sd	s6,112(sp)
ffffffffc0209ca6:	40a78b3b          	subw	s6,a5,a0
ffffffffc0209caa:	a029                	j	ffffffffc0209cb4 <sfs_do_mount+0x154>
ffffffffc0209cac:	6785                	lui	a5,0x1
ffffffffc0209cae:	9abe                	add	s5,s5,a5
ffffffffc0209cb0:	098a8263          	beq	s5,s8,ffffffffc0209d34 <sfs_do_mount+0x1d4>
ffffffffc0209cb4:	015b06bb          	addw	a3,s6,s5
ffffffffc0209cb8:	1682                	slli	a3,a3,0x20
ffffffffc0209cba:	6605                	lui	a2,0x1
ffffffffc0209cbc:	85d6                	mv	a1,s5
ffffffffc0209cbe:	9281                	srli	a3,a3,0x20
ffffffffc0209cc0:	1008                	addi	a0,sp,32
ffffffffc0209cc2:	84ffb0ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc0209cc6:	709c                	ld	a5,32(s1)
ffffffffc0209cc8:	85aa                	mv	a1,a0
ffffffffc0209cca:	4601                	li	a2,0
ffffffffc0209ccc:	8526                	mv	a0,s1
ffffffffc0209cce:	9782                	jalr	a5
ffffffffc0209cd0:	dd71                	beqz	a0,ffffffffc0209cac <sfs_do_mount+0x14c>
ffffffffc0209cd2:	e42a                	sd	a0,8(sp)
ffffffffc0209cd4:	856a                	mv	a0,s10
ffffffffc0209cd6:	bebff0ef          	jal	ffffffffc02098c0 <bitmap_destroy>
ffffffffc0209cda:	69a2                	ld	s3,8(sp)
ffffffffc0209cdc:	7b46                	ld	s6,112(sp)
ffffffffc0209cde:	7c06                	ld	s8,96(sp)
ffffffffc0209ce0:	856e                	mv	a0,s11
ffffffffc0209ce2:	bc0f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0209ce6:	7ae6                	ld	s5,120(sp)
ffffffffc0209ce8:	6ce6                	ld	s9,88(sp)
ffffffffc0209cea:	6d46                	ld	s10,80(sp)
ffffffffc0209cec:	6da6                	ld	s11,72(sp)
ffffffffc0209cee:	854a                	mv	a0,s2
ffffffffc0209cf0:	bb2f80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0209cf4:	8522                	mv	a0,s0
ffffffffc0209cf6:	bacf80ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc0209cfa:	740a                	ld	s0,160(sp)
ffffffffc0209cfc:	64ea                	ld	s1,152(sp)
ffffffffc0209cfe:	694a                	ld	s2,144(sp)
ffffffffc0209d00:	6a0a                	ld	s4,128(sp)
ffffffffc0209d02:	7ba6                	ld	s7,104(sp)
ffffffffc0209d04:	70aa                	ld	ra,168(sp)
ffffffffc0209d06:	854e                	mv	a0,s3
ffffffffc0209d08:	69aa                	ld	s3,136(sp)
ffffffffc0209d0a:	614d                	addi	sp,sp,176
ffffffffc0209d0c:	8082                	ret
ffffffffc0209d0e:	59f1                	li	s3,-4
ffffffffc0209d10:	b7d5                	j	ffffffffc0209cf4 <sfs_do_mount+0x194>
ffffffffc0209d12:	85be                	mv	a1,a5
ffffffffc0209d14:	00005517          	auipc	a0,0x5
ffffffffc0209d18:	f3c50513          	addi	a0,a0,-196 # ffffffffc020ec50 <etext+0x2e3c>
ffffffffc0209d1c:	c8af60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209d20:	59f5                	li	s3,-3
ffffffffc0209d22:	b7f1                	j	ffffffffc0209cee <sfs_do_mount+0x18e>
ffffffffc0209d24:	00005517          	auipc	a0,0x5
ffffffffc0209d28:	ef450513          	addi	a0,a0,-268 # ffffffffc020ec18 <etext+0x2e04>
ffffffffc0209d2c:	c7af60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209d30:	59f5                	li	s3,-3
ffffffffc0209d32:	bf75                	j	ffffffffc0209cee <sfs_do_mount+0x18e>
ffffffffc0209d34:	7b46                	ld	s6,112(sp)
ffffffffc0209d36:	00442903          	lw	s2,4(s0)
ffffffffc0209d3a:	0a0c8863          	beqz	s9,ffffffffc0209dea <sfs_do_mount+0x28a>
ffffffffc0209d3e:	4481                	li	s1,0
ffffffffc0209d40:	85a6                	mv	a1,s1
ffffffffc0209d42:	856a                	mv	a0,s10
ffffffffc0209d44:	b05ff0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc0209d48:	c111                	beqz	a0,ffffffffc0209d4c <sfs_do_mount+0x1ec>
ffffffffc0209d4a:	2a05                	addiw	s4,s4,1
ffffffffc0209d4c:	2485                	addiw	s1,s1,1
ffffffffc0209d4e:	fe9c99e3          	bne	s9,s1,ffffffffc0209d40 <sfs_do_mount+0x1e0>
ffffffffc0209d52:	441c                	lw	a5,8(s0)
ffffffffc0209d54:	0f479a63          	bne	a5,s4,ffffffffc0209e48 <sfs_do_mount+0x2e8>
ffffffffc0209d58:	05040513          	addi	a0,s0,80
ffffffffc0209d5c:	04043023          	sd	zero,64(s0)
ffffffffc0209d60:	4585                	li	a1,1
ffffffffc0209d62:	90ffa0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc0209d66:	06840513          	addi	a0,s0,104
ffffffffc0209d6a:	4585                	li	a1,1
ffffffffc0209d6c:	905fa0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc0209d70:	08040513          	addi	a0,s0,128
ffffffffc0209d74:	4585                	li	a1,1
ffffffffc0209d76:	8fbfa0ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc0209d7a:	09840793          	addi	a5,s0,152
ffffffffc0209d7e:	4149063b          	subw	a2,s2,s4
ffffffffc0209d82:	f05c                	sd	a5,160(s0)
ffffffffc0209d84:	ec5c                	sd	a5,152(s0)
ffffffffc0209d86:	874a                	mv	a4,s2
ffffffffc0209d88:	86d2                	mv	a3,s4
ffffffffc0209d8a:	00c40593          	addi	a1,s0,12
ffffffffc0209d8e:	00005517          	auipc	a0,0x5
ffffffffc0209d92:	f5250513          	addi	a0,a0,-174 # ffffffffc020ece0 <etext+0x2ecc>
ffffffffc0209d96:	c10f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209d9a:	00000617          	auipc	a2,0x0
ffffffffc0209d9e:	c9260613          	addi	a2,a2,-878 # ffffffffc0209a2c <sfs_sync>
ffffffffc0209da2:	00000697          	auipc	a3,0x0
ffffffffc0209da6:	d6668693          	addi	a3,a3,-666 # ffffffffc0209b08 <sfs_get_root>
ffffffffc0209daa:	00000717          	auipc	a4,0x0
ffffffffc0209dae:	b6e70713          	addi	a4,a4,-1170 # ffffffffc0209918 <sfs_unmount>
ffffffffc0209db2:	00000797          	auipc	a5,0x0
ffffffffc0209db6:	bea78793          	addi	a5,a5,-1046 # ffffffffc020999c <sfs_cleanup>
ffffffffc0209dba:	fc50                	sd	a2,184(s0)
ffffffffc0209dbc:	e074                	sd	a3,192(s0)
ffffffffc0209dbe:	e478                	sd	a4,200(s0)
ffffffffc0209dc0:	e87c                	sd	a5,208(s0)
ffffffffc0209dc2:	008bb023          	sd	s0,0(s7)
ffffffffc0209dc6:	64ea                	ld	s1,152(sp)
ffffffffc0209dc8:	740a                	ld	s0,160(sp)
ffffffffc0209dca:	694a                	ld	s2,144(sp)
ffffffffc0209dcc:	6a0a                	ld	s4,128(sp)
ffffffffc0209dce:	7ae6                	ld	s5,120(sp)
ffffffffc0209dd0:	7ba6                	ld	s7,104(sp)
ffffffffc0209dd2:	7c06                	ld	s8,96(sp)
ffffffffc0209dd4:	6ce6                	ld	s9,88(sp)
ffffffffc0209dd6:	6d46                	ld	s10,80(sp)
ffffffffc0209dd8:	6da6                	ld	s11,72(sp)
ffffffffc0209dda:	b72d                	j	ffffffffc0209d04 <sfs_do_mount+0x1a4>
ffffffffc0209ddc:	59f1                	li	s3,-4
ffffffffc0209dde:	b709                	j	ffffffffc0209ce0 <sfs_do_mount+0x180>
ffffffffc0209de0:	59c9                	li	s3,-14
ffffffffc0209de2:	b70d                	j	ffffffffc0209d04 <sfs_do_mount+0x1a4>
ffffffffc0209de4:	6da6                	ld	s11,72(sp)
ffffffffc0209de6:	59f1                	li	s3,-4
ffffffffc0209de8:	b719                	j	ffffffffc0209cee <sfs_do_mount+0x18e>
ffffffffc0209dea:	4a01                	li	s4,0
ffffffffc0209dec:	b79d                	j	ffffffffc0209d52 <sfs_do_mount+0x1f2>
ffffffffc0209dee:	740a                	ld	s0,160(sp)
ffffffffc0209df0:	64ea                	ld	s1,152(sp)
ffffffffc0209df2:	7ba6                	ld	s7,104(sp)
ffffffffc0209df4:	59f1                	li	s3,-4
ffffffffc0209df6:	b739                	j	ffffffffc0209d04 <sfs_do_mount+0x1a4>
ffffffffc0209df8:	00005697          	auipc	a3,0x5
ffffffffc0209dfc:	e8868693          	addi	a3,a3,-376 # ffffffffc020ec80 <etext+0x2e6c>
ffffffffc0209e00:	00002617          	auipc	a2,0x2
ffffffffc0209e04:	45060613          	addi	a2,a2,1104 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209e08:	08300593          	li	a1,131
ffffffffc0209e0c:	00005517          	auipc	a0,0x5
ffffffffc0209e10:	d7c50513          	addi	a0,a0,-644 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209e14:	f8da                	sd	s6,112(sp)
ffffffffc0209e16:	f0e2                	sd	s8,96(sp)
ffffffffc0209e18:	e32f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e1c:	00005697          	auipc	a3,0x5
ffffffffc0209e20:	d3c68693          	addi	a3,a3,-708 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209e24:	00002617          	auipc	a2,0x2
ffffffffc0209e28:	42c60613          	addi	a2,a2,1068 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209e2c:	0a300593          	li	a1,163
ffffffffc0209e30:	00005517          	auipc	a0,0x5
ffffffffc0209e34:	d5850513          	addi	a0,a0,-680 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209e38:	fcd6                	sd	s5,120(sp)
ffffffffc0209e3a:	f8da                	sd	s6,112(sp)
ffffffffc0209e3c:	f0e2                	sd	s8,96(sp)
ffffffffc0209e3e:	ece6                	sd	s9,88(sp)
ffffffffc0209e40:	e8ea                	sd	s10,80(sp)
ffffffffc0209e42:	e4ee                	sd	s11,72(sp)
ffffffffc0209e44:	e06f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e48:	00005697          	auipc	a3,0x5
ffffffffc0209e4c:	e6868693          	addi	a3,a3,-408 # ffffffffc020ecb0 <etext+0x2e9c>
ffffffffc0209e50:	00002617          	auipc	a2,0x2
ffffffffc0209e54:	40060613          	addi	a2,a2,1024 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209e58:	0e000593          	li	a1,224
ffffffffc0209e5c:	00005517          	auipc	a0,0x5
ffffffffc0209e60:	d2c50513          	addi	a0,a0,-724 # ffffffffc020eb88 <etext+0x2d74>
ffffffffc0209e64:	f8da                	sd	s6,112(sp)
ffffffffc0209e66:	de4f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209e6a <sfs_mount>:
ffffffffc0209e6a:	00000597          	auipc	a1,0x0
ffffffffc0209e6e:	cf658593          	addi	a1,a1,-778 # ffffffffc0209b60 <sfs_do_mount>
ffffffffc0209e72:	fccfe06f          	j	ffffffffc020863e <vfs_mount>

ffffffffc0209e76 <sfs_opendir>:
ffffffffc0209e76:	0235f593          	andi	a1,a1,35
ffffffffc0209e7a:	e199                	bnez	a1,ffffffffc0209e80 <sfs_opendir+0xa>
ffffffffc0209e7c:	4501                	li	a0,0
ffffffffc0209e7e:	8082                	ret
ffffffffc0209e80:	553d                	li	a0,-17
ffffffffc0209e82:	8082                	ret

ffffffffc0209e84 <sfs_openfile>:
ffffffffc0209e84:	4501                	li	a0,0
ffffffffc0209e86:	8082                	ret

ffffffffc0209e88 <sfs_gettype>:
ffffffffc0209e88:	1141                	addi	sp,sp,-16
ffffffffc0209e8a:	e406                	sd	ra,8(sp)
ffffffffc0209e8c:	c529                	beqz	a0,ffffffffc0209ed6 <sfs_gettype+0x4e>
ffffffffc0209e8e:	4d38                	lw	a4,88(a0)
ffffffffc0209e90:	6785                	lui	a5,0x1
ffffffffc0209e92:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209e96:	04f71063          	bne	a4,a5,ffffffffc0209ed6 <sfs_gettype+0x4e>
ffffffffc0209e9a:	6118                	ld	a4,0(a0)
ffffffffc0209e9c:	4789                	li	a5,2
ffffffffc0209e9e:	00475683          	lhu	a3,4(a4)
ffffffffc0209ea2:	02f68463          	beq	a3,a5,ffffffffc0209eca <sfs_gettype+0x42>
ffffffffc0209ea6:	478d                	li	a5,3
ffffffffc0209ea8:	00f68b63          	beq	a3,a5,ffffffffc0209ebe <sfs_gettype+0x36>
ffffffffc0209eac:	4705                	li	a4,1
ffffffffc0209eae:	6785                	lui	a5,0x1
ffffffffc0209eb0:	04e69363          	bne	a3,a4,ffffffffc0209ef6 <sfs_gettype+0x6e>
ffffffffc0209eb4:	60a2                	ld	ra,8(sp)
ffffffffc0209eb6:	c19c                	sw	a5,0(a1)
ffffffffc0209eb8:	4501                	li	a0,0
ffffffffc0209eba:	0141                	addi	sp,sp,16
ffffffffc0209ebc:	8082                	ret
ffffffffc0209ebe:	60a2                	ld	ra,8(sp)
ffffffffc0209ec0:	678d                	lui	a5,0x3
ffffffffc0209ec2:	c19c                	sw	a5,0(a1)
ffffffffc0209ec4:	4501                	li	a0,0
ffffffffc0209ec6:	0141                	addi	sp,sp,16
ffffffffc0209ec8:	8082                	ret
ffffffffc0209eca:	60a2                	ld	ra,8(sp)
ffffffffc0209ecc:	6789                	lui	a5,0x2
ffffffffc0209ece:	c19c                	sw	a5,0(a1)
ffffffffc0209ed0:	4501                	li	a0,0
ffffffffc0209ed2:	0141                	addi	sp,sp,16
ffffffffc0209ed4:	8082                	ret
ffffffffc0209ed6:	00005697          	auipc	a3,0x5
ffffffffc0209eda:	e2a68693          	addi	a3,a3,-470 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc0209ede:	00002617          	auipc	a2,0x2
ffffffffc0209ee2:	37260613          	addi	a2,a2,882 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209ee6:	38500593          	li	a1,901
ffffffffc0209eea:	00005517          	auipc	a0,0x5
ffffffffc0209eee:	e4e50513          	addi	a0,a0,-434 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc0209ef2:	d58f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209ef6:	00005617          	auipc	a2,0x5
ffffffffc0209efa:	e5a60613          	addi	a2,a2,-422 # ffffffffc020ed50 <etext+0x2f3c>
ffffffffc0209efe:	39100593          	li	a1,913
ffffffffc0209f02:	00005517          	auipc	a0,0x5
ffffffffc0209f06:	e3650513          	addi	a0,a0,-458 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc0209f0a:	d40f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209f0e <sfs_fsync>:
ffffffffc0209f0e:	7530                	ld	a2,104(a0)
ffffffffc0209f10:	7179                	addi	sp,sp,-48
ffffffffc0209f12:	f406                	sd	ra,40(sp)
ffffffffc0209f14:	ca2d                	beqz	a2,ffffffffc0209f86 <sfs_fsync+0x78>
ffffffffc0209f16:	0b062703          	lw	a4,176(a2)
ffffffffc0209f1a:	e735                	bnez	a4,ffffffffc0209f86 <sfs_fsync+0x78>
ffffffffc0209f1c:	4d34                	lw	a3,88(a0)
ffffffffc0209f1e:	6705                	lui	a4,0x1
ffffffffc0209f20:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209f24:	08e69263          	bne	a3,a4,ffffffffc0209fa8 <sfs_fsync+0x9a>
ffffffffc0209f28:	6914                	ld	a3,16(a0)
ffffffffc0209f2a:	4701                	li	a4,0
ffffffffc0209f2c:	e689                	bnez	a3,ffffffffc0209f36 <sfs_fsync+0x28>
ffffffffc0209f2e:	70a2                	ld	ra,40(sp)
ffffffffc0209f30:	853a                	mv	a0,a4
ffffffffc0209f32:	6145                	addi	sp,sp,48
ffffffffc0209f34:	8082                	ret
ffffffffc0209f36:	f022                	sd	s0,32(sp)
ffffffffc0209f38:	e42a                	sd	a0,8(sp)
ffffffffc0209f3a:	02050413          	addi	s0,a0,32
ffffffffc0209f3e:	02050513          	addi	a0,a0,32
ffffffffc0209f42:	ec3a                	sd	a4,24(sp)
ffffffffc0209f44:	e832                	sd	a2,16(sp)
ffffffffc0209f46:	f34fa0ef          	jal	ffffffffc020467a <down>
ffffffffc0209f4a:	67a2                	ld	a5,8(sp)
ffffffffc0209f4c:	6762                	ld	a4,24(sp)
ffffffffc0209f4e:	6b94                	ld	a3,16(a5)
ffffffffc0209f50:	ea99                	bnez	a3,ffffffffc0209f66 <sfs_fsync+0x58>
ffffffffc0209f52:	8522                	mv	a0,s0
ffffffffc0209f54:	e43a                	sd	a4,8(sp)
ffffffffc0209f56:	f20fa0ef          	jal	ffffffffc0204676 <up>
ffffffffc0209f5a:	6722                	ld	a4,8(sp)
ffffffffc0209f5c:	7402                	ld	s0,32(sp)
ffffffffc0209f5e:	70a2                	ld	ra,40(sp)
ffffffffc0209f60:	853a                	mv	a0,a4
ffffffffc0209f62:	6145                	addi	sp,sp,48
ffffffffc0209f64:	8082                	ret
ffffffffc0209f66:	4794                	lw	a3,8(a5)
ffffffffc0209f68:	638c                	ld	a1,0(a5)
ffffffffc0209f6a:	6542                	ld	a0,16(sp)
ffffffffc0209f6c:	4701                	li	a4,0
ffffffffc0209f6e:	0007b823          	sd	zero,16(a5) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0209f72:	04000613          	li	a2,64
ffffffffc0209f76:	726010ef          	jal	ffffffffc020b69c <sfs_wbuf>
ffffffffc0209f7a:	872a                	mv	a4,a0
ffffffffc0209f7c:	d979                	beqz	a0,ffffffffc0209f52 <sfs_fsync+0x44>
ffffffffc0209f7e:	67a2                	ld	a5,8(sp)
ffffffffc0209f80:	4685                	li	a3,1
ffffffffc0209f82:	eb94                	sd	a3,16(a5)
ffffffffc0209f84:	b7f9                	j	ffffffffc0209f52 <sfs_fsync+0x44>
ffffffffc0209f86:	00005697          	auipc	a3,0x5
ffffffffc0209f8a:	bd268693          	addi	a3,a3,-1070 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc0209f8e:	00002617          	auipc	a2,0x2
ffffffffc0209f92:	2c260613          	addi	a2,a2,706 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209f96:	2c900593          	li	a1,713
ffffffffc0209f9a:	00005517          	auipc	a0,0x5
ffffffffc0209f9e:	d9e50513          	addi	a0,a0,-610 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc0209fa2:	f022                	sd	s0,32(sp)
ffffffffc0209fa4:	ca6f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209fa8:	00005697          	auipc	a3,0x5
ffffffffc0209fac:	d5868693          	addi	a3,a3,-680 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc0209fb0:	00002617          	auipc	a2,0x2
ffffffffc0209fb4:	2a060613          	addi	a2,a2,672 # ffffffffc020c250 <etext+0x43c>
ffffffffc0209fb8:	2ca00593          	li	a1,714
ffffffffc0209fbc:	00005517          	auipc	a0,0x5
ffffffffc0209fc0:	d7c50513          	addi	a0,a0,-644 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc0209fc4:	f022                	sd	s0,32(sp)
ffffffffc0209fc6:	c84f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209fca <sfs_fstat>:
ffffffffc0209fca:	1101                	addi	sp,sp,-32
ffffffffc0209fcc:	e822                	sd	s0,16(sp)
ffffffffc0209fce:	e426                	sd	s1,8(sp)
ffffffffc0209fd0:	842a                	mv	s0,a0
ffffffffc0209fd2:	84ae                	mv	s1,a1
ffffffffc0209fd4:	852e                	mv	a0,a1
ffffffffc0209fd6:	02000613          	li	a2,32
ffffffffc0209fda:	4581                	li	a1,0
ffffffffc0209fdc:	ec06                	sd	ra,24(sp)
ffffffffc0209fde:	5cf010ef          	jal	ffffffffc020bdac <memset>
ffffffffc0209fe2:	c439                	beqz	s0,ffffffffc020a030 <sfs_fstat+0x66>
ffffffffc0209fe4:	783c                	ld	a5,112(s0)
ffffffffc0209fe6:	c7a9                	beqz	a5,ffffffffc020a030 <sfs_fstat+0x66>
ffffffffc0209fe8:	6bbc                	ld	a5,80(a5)
ffffffffc0209fea:	c3b9                	beqz	a5,ffffffffc020a030 <sfs_fstat+0x66>
ffffffffc0209fec:	00004597          	auipc	a1,0x4
ffffffffc0209ff0:	77c58593          	addi	a1,a1,1916 # ffffffffc020e768 <etext+0x2954>
ffffffffc0209ff4:	8522                	mv	a0,s0
ffffffffc0209ff6:	85afe0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc0209ffa:	783c                	ld	a5,112(s0)
ffffffffc0209ffc:	85a6                	mv	a1,s1
ffffffffc0209ffe:	8522                	mv	a0,s0
ffffffffc020a000:	6bbc                	ld	a5,80(a5)
ffffffffc020a002:	9782                	jalr	a5
ffffffffc020a004:	e10d                	bnez	a0,ffffffffc020a026 <sfs_fstat+0x5c>
ffffffffc020a006:	4c38                	lw	a4,88(s0)
ffffffffc020a008:	6785                	lui	a5,0x1
ffffffffc020a00a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a00e:	04f71163          	bne	a4,a5,ffffffffc020a050 <sfs_fstat+0x86>
ffffffffc020a012:	601c                	ld	a5,0(s0)
ffffffffc020a014:	0067d683          	lhu	a3,6(a5)
ffffffffc020a018:	0087e703          	lwu	a4,8(a5)
ffffffffc020a01c:	0007e783          	lwu	a5,0(a5)
ffffffffc020a020:	e494                	sd	a3,8(s1)
ffffffffc020a022:	e898                	sd	a4,16(s1)
ffffffffc020a024:	ec9c                	sd	a5,24(s1)
ffffffffc020a026:	60e2                	ld	ra,24(sp)
ffffffffc020a028:	6442                	ld	s0,16(sp)
ffffffffc020a02a:	64a2                	ld	s1,8(sp)
ffffffffc020a02c:	6105                	addi	sp,sp,32
ffffffffc020a02e:	8082                	ret
ffffffffc020a030:	00004697          	auipc	a3,0x4
ffffffffc020a034:	6d068693          	addi	a3,a3,1744 # ffffffffc020e700 <etext+0x28ec>
ffffffffc020a038:	00002617          	auipc	a2,0x2
ffffffffc020a03c:	21860613          	addi	a2,a2,536 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a040:	2ba00593          	li	a1,698
ffffffffc020a044:	00005517          	auipc	a0,0x5
ffffffffc020a048:	cf450513          	addi	a0,a0,-780 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a04c:	bfef60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a050:	00005697          	auipc	a3,0x5
ffffffffc020a054:	cb068693          	addi	a3,a3,-848 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020a058:	00002617          	auipc	a2,0x2
ffffffffc020a05c:	1f860613          	addi	a2,a2,504 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a060:	2bd00593          	li	a1,701
ffffffffc020a064:	00005517          	auipc	a0,0x5
ffffffffc020a068:	cd450513          	addi	a0,a0,-812 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a06c:	bdef60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a070 <sfs_tryseek>:
ffffffffc020a070:	08000737          	lui	a4,0x8000
ffffffffc020a074:	04e5f863          	bgeu	a1,a4,ffffffffc020a0c4 <sfs_tryseek+0x54>
ffffffffc020a078:	1101                	addi	sp,sp,-32
ffffffffc020a07a:	ec06                	sd	ra,24(sp)
ffffffffc020a07c:	c531                	beqz	a0,ffffffffc020a0c8 <sfs_tryseek+0x58>
ffffffffc020a07e:	4d30                	lw	a2,88(a0)
ffffffffc020a080:	6685                	lui	a3,0x1
ffffffffc020a082:	23568693          	addi	a3,a3,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a086:	04d61163          	bne	a2,a3,ffffffffc020a0c8 <sfs_tryseek+0x58>
ffffffffc020a08a:	6114                	ld	a3,0(a0)
ffffffffc020a08c:	0006e683          	lwu	a3,0(a3)
ffffffffc020a090:	02b6d663          	bge	a3,a1,ffffffffc020a0bc <sfs_tryseek+0x4c>
ffffffffc020a094:	7934                	ld	a3,112(a0)
ffffffffc020a096:	caa9                	beqz	a3,ffffffffc020a0e8 <sfs_tryseek+0x78>
ffffffffc020a098:	72b4                	ld	a3,96(a3)
ffffffffc020a09a:	c6b9                	beqz	a3,ffffffffc020a0e8 <sfs_tryseek+0x78>
ffffffffc020a09c:	e02e                	sd	a1,0(sp)
ffffffffc020a09e:	00004597          	auipc	a1,0x4
ffffffffc020a0a2:	5ba58593          	addi	a1,a1,1466 # ffffffffc020e658 <etext+0x2844>
ffffffffc020a0a6:	e42a                	sd	a0,8(sp)
ffffffffc020a0a8:	fa9fd0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc020a0ac:	67a2                	ld	a5,8(sp)
ffffffffc020a0ae:	6582                	ld	a1,0(sp)
ffffffffc020a0b0:	60e2                	ld	ra,24(sp)
ffffffffc020a0b2:	7bb4                	ld	a3,112(a5)
ffffffffc020a0b4:	853e                	mv	a0,a5
ffffffffc020a0b6:	72bc                	ld	a5,96(a3)
ffffffffc020a0b8:	6105                	addi	sp,sp,32
ffffffffc020a0ba:	8782                	jr	a5
ffffffffc020a0bc:	60e2                	ld	ra,24(sp)
ffffffffc020a0be:	4501                	li	a0,0
ffffffffc020a0c0:	6105                	addi	sp,sp,32
ffffffffc020a0c2:	8082                	ret
ffffffffc020a0c4:	5575                	li	a0,-3
ffffffffc020a0c6:	8082                	ret
ffffffffc020a0c8:	00005697          	auipc	a3,0x5
ffffffffc020a0cc:	c3868693          	addi	a3,a3,-968 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020a0d0:	00002617          	auipc	a2,0x2
ffffffffc020a0d4:	18060613          	addi	a2,a2,384 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a0d8:	39c00593          	li	a1,924
ffffffffc020a0dc:	00005517          	auipc	a0,0x5
ffffffffc020a0e0:	c5c50513          	addi	a0,a0,-932 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a0e4:	b66f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a0e8:	00004697          	auipc	a3,0x4
ffffffffc020a0ec:	51868693          	addi	a3,a3,1304 # ffffffffc020e600 <etext+0x27ec>
ffffffffc020a0f0:	00002617          	auipc	a2,0x2
ffffffffc020a0f4:	16060613          	addi	a2,a2,352 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a0f8:	39e00593          	li	a1,926
ffffffffc020a0fc:	00005517          	auipc	a0,0x5
ffffffffc020a100:	c3c50513          	addi	a0,a0,-964 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a104:	b46f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a108 <sfs_close>:
ffffffffc020a108:	1141                	addi	sp,sp,-16
ffffffffc020a10a:	e406                	sd	ra,8(sp)
ffffffffc020a10c:	e022                	sd	s0,0(sp)
ffffffffc020a10e:	c11d                	beqz	a0,ffffffffc020a134 <sfs_close+0x2c>
ffffffffc020a110:	793c                	ld	a5,112(a0)
ffffffffc020a112:	842a                	mv	s0,a0
ffffffffc020a114:	c385                	beqz	a5,ffffffffc020a134 <sfs_close+0x2c>
ffffffffc020a116:	7b9c                	ld	a5,48(a5)
ffffffffc020a118:	cf91                	beqz	a5,ffffffffc020a134 <sfs_close+0x2c>
ffffffffc020a11a:	00004597          	auipc	a1,0x4
ffffffffc020a11e:	a6658593          	addi	a1,a1,-1434 # ffffffffc020db80 <etext+0x1d6c>
ffffffffc020a122:	f2ffd0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc020a126:	783c                	ld	a5,112(s0)
ffffffffc020a128:	8522                	mv	a0,s0
ffffffffc020a12a:	6402                	ld	s0,0(sp)
ffffffffc020a12c:	60a2                	ld	ra,8(sp)
ffffffffc020a12e:	7b9c                	ld	a5,48(a5)
ffffffffc020a130:	0141                	addi	sp,sp,16
ffffffffc020a132:	8782                	jr	a5
ffffffffc020a134:	00004697          	auipc	a3,0x4
ffffffffc020a138:	9fc68693          	addi	a3,a3,-1540 # ffffffffc020db30 <etext+0x1d1c>
ffffffffc020a13c:	00002617          	auipc	a2,0x2
ffffffffc020a140:	11460613          	addi	a2,a2,276 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a144:	21c00593          	li	a1,540
ffffffffc020a148:	00005517          	auipc	a0,0x5
ffffffffc020a14c:	bf050513          	addi	a0,a0,-1040 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a150:	afaf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a154 <sfs_io.part.0>:
ffffffffc020a154:	1141                	addi	sp,sp,-16
ffffffffc020a156:	00005697          	auipc	a3,0x5
ffffffffc020a15a:	baa68693          	addi	a3,a3,-1110 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020a15e:	00002617          	auipc	a2,0x2
ffffffffc020a162:	0f260613          	addi	a2,a2,242 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a166:	29900593          	li	a1,665
ffffffffc020a16a:	00005517          	auipc	a0,0x5
ffffffffc020a16e:	bce50513          	addi	a0,a0,-1074 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a172:	e406                	sd	ra,8(sp)
ffffffffc020a174:	ad6f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a178 <sfs_block_free>:
ffffffffc020a178:	1101                	addi	sp,sp,-32
ffffffffc020a17a:	e822                	sd	s0,16(sp)
ffffffffc020a17c:	e426                	sd	s1,8(sp)
ffffffffc020a17e:	ec06                	sd	ra,24(sp)
ffffffffc020a180:	84ae                	mv	s1,a1
ffffffffc020a182:	842a                	mv	s0,a0
ffffffffc020a184:	c595                	beqz	a1,ffffffffc020a1b0 <sfs_block_free+0x38>
ffffffffc020a186:	415c                	lw	a5,4(a0)
ffffffffc020a188:	02f5f463          	bgeu	a1,a5,ffffffffc020a1b0 <sfs_block_free+0x38>
ffffffffc020a18c:	7d08                	ld	a0,56(a0)
ffffffffc020a18e:	ebaff0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020a192:	ed0d                	bnez	a0,ffffffffc020a1cc <sfs_block_free+0x54>
ffffffffc020a194:	7c08                	ld	a0,56(s0)
ffffffffc020a196:	85a6                	mv	a1,s1
ffffffffc020a198:	ed8ff0ef          	jal	ffffffffc0209870 <bitmap_free>
ffffffffc020a19c:	441c                	lw	a5,8(s0)
ffffffffc020a19e:	4705                	li	a4,1
ffffffffc020a1a0:	60e2                	ld	ra,24(sp)
ffffffffc020a1a2:	2785                	addiw	a5,a5,1
ffffffffc020a1a4:	e038                	sd	a4,64(s0)
ffffffffc020a1a6:	c41c                	sw	a5,8(s0)
ffffffffc020a1a8:	6442                	ld	s0,16(sp)
ffffffffc020a1aa:	64a2                	ld	s1,8(sp)
ffffffffc020a1ac:	6105                	addi	sp,sp,32
ffffffffc020a1ae:	8082                	ret
ffffffffc020a1b0:	4054                	lw	a3,4(s0)
ffffffffc020a1b2:	8726                	mv	a4,s1
ffffffffc020a1b4:	00005617          	auipc	a2,0x5
ffffffffc020a1b8:	bb460613          	addi	a2,a2,-1100 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020a1bc:	05300593          	li	a1,83
ffffffffc020a1c0:	00005517          	auipc	a0,0x5
ffffffffc020a1c4:	b7850513          	addi	a0,a0,-1160 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a1c8:	a82f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a1cc:	00005697          	auipc	a3,0x5
ffffffffc020a1d0:	bd468693          	addi	a3,a3,-1068 # ffffffffc020eda0 <etext+0x2f8c>
ffffffffc020a1d4:	00002617          	auipc	a2,0x2
ffffffffc020a1d8:	07c60613          	addi	a2,a2,124 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a1dc:	06a00593          	li	a1,106
ffffffffc020a1e0:	00005517          	auipc	a0,0x5
ffffffffc020a1e4:	b5850513          	addi	a0,a0,-1192 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a1e8:	a62f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a1ec <sfs_reclaim>:
ffffffffc020a1ec:	1101                	addi	sp,sp,-32
ffffffffc020a1ee:	e426                	sd	s1,8(sp)
ffffffffc020a1f0:	7524                	ld	s1,104(a0)
ffffffffc020a1f2:	ec06                	sd	ra,24(sp)
ffffffffc020a1f4:	e822                	sd	s0,16(sp)
ffffffffc020a1f6:	e04a                	sd	s2,0(sp)
ffffffffc020a1f8:	0e048963          	beqz	s1,ffffffffc020a2ea <sfs_reclaim+0xfe>
ffffffffc020a1fc:	0b04a783          	lw	a5,176(s1)
ffffffffc020a200:	0e079563          	bnez	a5,ffffffffc020a2ea <sfs_reclaim+0xfe>
ffffffffc020a204:	4d38                	lw	a4,88(a0)
ffffffffc020a206:	6785                	lui	a5,0x1
ffffffffc020a208:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a20c:	842a                	mv	s0,a0
ffffffffc020a20e:	10f71e63          	bne	a4,a5,ffffffffc020a32a <sfs_reclaim+0x13e>
ffffffffc020a212:	8526                	mv	a0,s1
ffffffffc020a214:	63c010ef          	jal	ffffffffc020b850 <lock_sfs_fs>
ffffffffc020a218:	4c1c                	lw	a5,24(s0)
ffffffffc020a21a:	0ef05863          	blez	a5,ffffffffc020a30a <sfs_reclaim+0x11e>
ffffffffc020a21e:	37fd                	addiw	a5,a5,-1
ffffffffc020a220:	cc1c                	sw	a5,24(s0)
ffffffffc020a222:	ebd9                	bnez	a5,ffffffffc020a2b8 <sfs_reclaim+0xcc>
ffffffffc020a224:	05c42903          	lw	s2,92(s0)
ffffffffc020a228:	08091863          	bnez	s2,ffffffffc020a2b8 <sfs_reclaim+0xcc>
ffffffffc020a22c:	601c                	ld	a5,0(s0)
ffffffffc020a22e:	0067d783          	lhu	a5,6(a5)
ffffffffc020a232:	e785                	bnez	a5,ffffffffc020a25a <sfs_reclaim+0x6e>
ffffffffc020a234:	783c                	ld	a5,112(s0)
ffffffffc020a236:	10078a63          	beqz	a5,ffffffffc020a34a <sfs_reclaim+0x15e>
ffffffffc020a23a:	73bc                	ld	a5,96(a5)
ffffffffc020a23c:	10078763          	beqz	a5,ffffffffc020a34a <sfs_reclaim+0x15e>
ffffffffc020a240:	00004597          	auipc	a1,0x4
ffffffffc020a244:	41858593          	addi	a1,a1,1048 # ffffffffc020e658 <etext+0x2844>
ffffffffc020a248:	8522                	mv	a0,s0
ffffffffc020a24a:	e07fd0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc020a24e:	783c                	ld	a5,112(s0)
ffffffffc020a250:	8522                	mv	a0,s0
ffffffffc020a252:	4581                	li	a1,0
ffffffffc020a254:	73bc                	ld	a5,96(a5)
ffffffffc020a256:	9782                	jalr	a5
ffffffffc020a258:	e559                	bnez	a0,ffffffffc020a2e6 <sfs_reclaim+0xfa>
ffffffffc020a25a:	681c                	ld	a5,16(s0)
ffffffffc020a25c:	c39d                	beqz	a5,ffffffffc020a282 <sfs_reclaim+0x96>
ffffffffc020a25e:	783c                	ld	a5,112(s0)
ffffffffc020a260:	10078563          	beqz	a5,ffffffffc020a36a <sfs_reclaim+0x17e>
ffffffffc020a264:	7b9c                	ld	a5,48(a5)
ffffffffc020a266:	10078263          	beqz	a5,ffffffffc020a36a <sfs_reclaim+0x17e>
ffffffffc020a26a:	8522                	mv	a0,s0
ffffffffc020a26c:	00004597          	auipc	a1,0x4
ffffffffc020a270:	91458593          	addi	a1,a1,-1772 # ffffffffc020db80 <etext+0x1d6c>
ffffffffc020a274:	dddfd0ef          	jal	ffffffffc0208050 <inode_check>
ffffffffc020a278:	783c                	ld	a5,112(s0)
ffffffffc020a27a:	8522                	mv	a0,s0
ffffffffc020a27c:	7b9c                	ld	a5,48(a5)
ffffffffc020a27e:	9782                	jalr	a5
ffffffffc020a280:	e13d                	bnez	a0,ffffffffc020a2e6 <sfs_reclaim+0xfa>
ffffffffc020a282:	7c18                	ld	a4,56(s0)
ffffffffc020a284:	603c                	ld	a5,64(s0)
ffffffffc020a286:	8526                	mv	a0,s1
ffffffffc020a288:	e71c                	sd	a5,8(a4)
ffffffffc020a28a:	e398                	sd	a4,0(a5)
ffffffffc020a28c:	6438                	ld	a4,72(s0)
ffffffffc020a28e:	683c                	ld	a5,80(s0)
ffffffffc020a290:	e71c                	sd	a5,8(a4)
ffffffffc020a292:	e398                	sd	a4,0(a5)
ffffffffc020a294:	5cc010ef          	jal	ffffffffc020b860 <unlock_sfs_fs>
ffffffffc020a298:	6008                	ld	a0,0(s0)
ffffffffc020a29a:	00655783          	lhu	a5,6(a0)
ffffffffc020a29e:	cb85                	beqz	a5,ffffffffc020a2ce <sfs_reclaim+0xe2>
ffffffffc020a2a0:	e03f70ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020a2a4:	8522                	mv	a0,s0
ffffffffc020a2a6:	d43fd0ef          	jal	ffffffffc0207fe8 <inode_kill>
ffffffffc020a2aa:	60e2                	ld	ra,24(sp)
ffffffffc020a2ac:	6442                	ld	s0,16(sp)
ffffffffc020a2ae:	64a2                	ld	s1,8(sp)
ffffffffc020a2b0:	854a                	mv	a0,s2
ffffffffc020a2b2:	6902                	ld	s2,0(sp)
ffffffffc020a2b4:	6105                	addi	sp,sp,32
ffffffffc020a2b6:	8082                	ret
ffffffffc020a2b8:	5945                	li	s2,-15
ffffffffc020a2ba:	8526                	mv	a0,s1
ffffffffc020a2bc:	5a4010ef          	jal	ffffffffc020b860 <unlock_sfs_fs>
ffffffffc020a2c0:	60e2                	ld	ra,24(sp)
ffffffffc020a2c2:	6442                	ld	s0,16(sp)
ffffffffc020a2c4:	64a2                	ld	s1,8(sp)
ffffffffc020a2c6:	854a                	mv	a0,s2
ffffffffc020a2c8:	6902                	ld	s2,0(sp)
ffffffffc020a2ca:	6105                	addi	sp,sp,32
ffffffffc020a2cc:	8082                	ret
ffffffffc020a2ce:	440c                	lw	a1,8(s0)
ffffffffc020a2d0:	8526                	mv	a0,s1
ffffffffc020a2d2:	ea7ff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020a2d6:	6008                	ld	a0,0(s0)
ffffffffc020a2d8:	5d4c                	lw	a1,60(a0)
ffffffffc020a2da:	d1f9                	beqz	a1,ffffffffc020a2a0 <sfs_reclaim+0xb4>
ffffffffc020a2dc:	8526                	mv	a0,s1
ffffffffc020a2de:	e9bff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020a2e2:	6008                	ld	a0,0(s0)
ffffffffc020a2e4:	bf75                	j	ffffffffc020a2a0 <sfs_reclaim+0xb4>
ffffffffc020a2e6:	892a                	mv	s2,a0
ffffffffc020a2e8:	bfc9                	j	ffffffffc020a2ba <sfs_reclaim+0xce>
ffffffffc020a2ea:	00005697          	auipc	a3,0x5
ffffffffc020a2ee:	86e68693          	addi	a3,a3,-1938 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020a2f2:	00002617          	auipc	a2,0x2
ffffffffc020a2f6:	f5e60613          	addi	a2,a2,-162 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a2fa:	35a00593          	li	a1,858
ffffffffc020a2fe:	00005517          	auipc	a0,0x5
ffffffffc020a302:	a3a50513          	addi	a0,a0,-1478 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a306:	944f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a30a:	00005697          	auipc	a3,0x5
ffffffffc020a30e:	ab668693          	addi	a3,a3,-1354 # ffffffffc020edc0 <etext+0x2fac>
ffffffffc020a312:	00002617          	auipc	a2,0x2
ffffffffc020a316:	f3e60613          	addi	a2,a2,-194 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a31a:	36000593          	li	a1,864
ffffffffc020a31e:	00005517          	auipc	a0,0x5
ffffffffc020a322:	a1a50513          	addi	a0,a0,-1510 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a326:	924f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a32a:	00005697          	auipc	a3,0x5
ffffffffc020a32e:	9d668693          	addi	a3,a3,-1578 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020a332:	00002617          	auipc	a2,0x2
ffffffffc020a336:	f1e60613          	addi	a2,a2,-226 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a33a:	35b00593          	li	a1,859
ffffffffc020a33e:	00005517          	auipc	a0,0x5
ffffffffc020a342:	9fa50513          	addi	a0,a0,-1542 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a346:	904f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a34a:	00004697          	auipc	a3,0x4
ffffffffc020a34e:	2b668693          	addi	a3,a3,694 # ffffffffc020e600 <etext+0x27ec>
ffffffffc020a352:	00002617          	auipc	a2,0x2
ffffffffc020a356:	efe60613          	addi	a2,a2,-258 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a35a:	36500593          	li	a1,869
ffffffffc020a35e:	00005517          	auipc	a0,0x5
ffffffffc020a362:	9da50513          	addi	a0,a0,-1574 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a366:	8e4f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a36a:	00003697          	auipc	a3,0x3
ffffffffc020a36e:	7c668693          	addi	a3,a3,1990 # ffffffffc020db30 <etext+0x1d1c>
ffffffffc020a372:	00002617          	auipc	a2,0x2
ffffffffc020a376:	ede60613          	addi	a2,a2,-290 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a37a:	36a00593          	li	a1,874
ffffffffc020a37e:	00005517          	auipc	a0,0x5
ffffffffc020a382:	9ba50513          	addi	a0,a0,-1606 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a386:	8c4f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a38a <sfs_block_alloc>:
ffffffffc020a38a:	1101                	addi	sp,sp,-32
ffffffffc020a38c:	e822                	sd	s0,16(sp)
ffffffffc020a38e:	842a                	mv	s0,a0
ffffffffc020a390:	7d08                	ld	a0,56(a0)
ffffffffc020a392:	e426                	sd	s1,8(sp)
ffffffffc020a394:	ec06                	sd	ra,24(sp)
ffffffffc020a396:	84ae                	mv	s1,a1
ffffffffc020a398:	c3eff0ef          	jal	ffffffffc02097d6 <bitmap_alloc>
ffffffffc020a39c:	e90d                	bnez	a0,ffffffffc020a3ce <sfs_block_alloc+0x44>
ffffffffc020a39e:	441c                	lw	a5,8(s0)
ffffffffc020a3a0:	cbb5                	beqz	a5,ffffffffc020a414 <sfs_block_alloc+0x8a>
ffffffffc020a3a2:	37fd                	addiw	a5,a5,-1
ffffffffc020a3a4:	c41c                	sw	a5,8(s0)
ffffffffc020a3a6:	408c                	lw	a1,0(s1)
ffffffffc020a3a8:	4605                	li	a2,1
ffffffffc020a3aa:	e030                	sd	a2,64(s0)
ffffffffc020a3ac:	c595                	beqz	a1,ffffffffc020a3d8 <sfs_block_alloc+0x4e>
ffffffffc020a3ae:	405c                	lw	a5,4(s0)
ffffffffc020a3b0:	02f5f463          	bgeu	a1,a5,ffffffffc020a3d8 <sfs_block_alloc+0x4e>
ffffffffc020a3b4:	7c08                	ld	a0,56(s0)
ffffffffc020a3b6:	c92ff0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020a3ba:	4605                	li	a2,1
ffffffffc020a3bc:	ed05                	bnez	a0,ffffffffc020a3f4 <sfs_block_alloc+0x6a>
ffffffffc020a3be:	8522                	mv	a0,s0
ffffffffc020a3c0:	6442                	ld	s0,16(sp)
ffffffffc020a3c2:	408c                	lw	a1,0(s1)
ffffffffc020a3c4:	60e2                	ld	ra,24(sp)
ffffffffc020a3c6:	64a2                	ld	s1,8(sp)
ffffffffc020a3c8:	6105                	addi	sp,sp,32
ffffffffc020a3ca:	4260106f          	j	ffffffffc020b7f0 <sfs_clear_block>
ffffffffc020a3ce:	60e2                	ld	ra,24(sp)
ffffffffc020a3d0:	6442                	ld	s0,16(sp)
ffffffffc020a3d2:	64a2                	ld	s1,8(sp)
ffffffffc020a3d4:	6105                	addi	sp,sp,32
ffffffffc020a3d6:	8082                	ret
ffffffffc020a3d8:	4054                	lw	a3,4(s0)
ffffffffc020a3da:	872e                	mv	a4,a1
ffffffffc020a3dc:	00005617          	auipc	a2,0x5
ffffffffc020a3e0:	98c60613          	addi	a2,a2,-1652 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020a3e4:	05300593          	li	a1,83
ffffffffc020a3e8:	00005517          	auipc	a0,0x5
ffffffffc020a3ec:	95050513          	addi	a0,a0,-1712 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a3f0:	85af60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a3f4:	00005697          	auipc	a3,0x5
ffffffffc020a3f8:	a0468693          	addi	a3,a3,-1532 # ffffffffc020edf8 <etext+0x2fe4>
ffffffffc020a3fc:	00002617          	auipc	a2,0x2
ffffffffc020a400:	e5460613          	addi	a2,a2,-428 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a404:	06100593          	li	a1,97
ffffffffc020a408:	00005517          	auipc	a0,0x5
ffffffffc020a40c:	93050513          	addi	a0,a0,-1744 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a410:	83af60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a414:	00005697          	auipc	a3,0x5
ffffffffc020a418:	9c468693          	addi	a3,a3,-1596 # ffffffffc020edd8 <etext+0x2fc4>
ffffffffc020a41c:	00002617          	auipc	a2,0x2
ffffffffc020a420:	e3460613          	addi	a2,a2,-460 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a424:	05f00593          	li	a1,95
ffffffffc020a428:	00005517          	auipc	a0,0x5
ffffffffc020a42c:	91050513          	addi	a0,a0,-1776 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a430:	81af60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a434 <sfs_bmap_load_nolock>:
ffffffffc020a434:	711d                	addi	sp,sp,-96
ffffffffc020a436:	e4a6                	sd	s1,72(sp)
ffffffffc020a438:	6184                	ld	s1,0(a1)
ffffffffc020a43a:	e0ca                	sd	s2,64(sp)
ffffffffc020a43c:	ec86                	sd	ra,88(sp)
ffffffffc020a43e:	0084a903          	lw	s2,8(s1)
ffffffffc020a442:	e8a2                	sd	s0,80(sp)
ffffffffc020a444:	fc4e                	sd	s3,56(sp)
ffffffffc020a446:	f852                	sd	s4,48(sp)
ffffffffc020a448:	1ac96663          	bltu	s2,a2,ffffffffc020a5f4 <sfs_bmap_load_nolock+0x1c0>
ffffffffc020a44c:	47ad                	li	a5,11
ffffffffc020a44e:	882e                	mv	a6,a1
ffffffffc020a450:	8432                	mv	s0,a2
ffffffffc020a452:	8a36                	mv	s4,a3
ffffffffc020a454:	89aa                	mv	s3,a0
ffffffffc020a456:	04c7f963          	bgeu	a5,a2,ffffffffc020a4a8 <sfs_bmap_load_nolock+0x74>
ffffffffc020a45a:	ff46079b          	addiw	a5,a2,-12
ffffffffc020a45e:	3ff00713          	li	a4,1023
ffffffffc020a462:	f456                	sd	s5,40(sp)
ffffffffc020a464:	1af76a63          	bltu	a4,a5,ffffffffc020a618 <sfs_bmap_load_nolock+0x1e4>
ffffffffc020a468:	03c4a883          	lw	a7,60(s1)
ffffffffc020a46c:	02079713          	slli	a4,a5,0x20
ffffffffc020a470:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a474:	ce02                	sw	zero,28(sp)
ffffffffc020a476:	cc46                	sw	a7,24(sp)
ffffffffc020a478:	8abe                	mv	s5,a5
ffffffffc020a47a:	12089063          	bnez	a7,ffffffffc020a59a <sfs_bmap_load_nolock+0x166>
ffffffffc020a47e:	08c90c63          	beq	s2,a2,ffffffffc020a516 <sfs_bmap_load_nolock+0xe2>
ffffffffc020a482:	7aa2                	ld	s5,40(sp)
ffffffffc020a484:	4581                	li	a1,0
ffffffffc020a486:	0049a683          	lw	a3,4(s3)
ffffffffc020a48a:	f456                	sd	s5,40(sp)
ffffffffc020a48c:	f05a                	sd	s6,32(sp)
ffffffffc020a48e:	872e                	mv	a4,a1
ffffffffc020a490:	00005617          	auipc	a2,0x5
ffffffffc020a494:	8d860613          	addi	a2,a2,-1832 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020a498:	05300593          	li	a1,83
ffffffffc020a49c:	00005517          	auipc	a0,0x5
ffffffffc020a4a0:	89c50513          	addi	a0,a0,-1892 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a4a4:	fa7f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a4a8:	02061793          	slli	a5,a2,0x20
ffffffffc020a4ac:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a4b0:	9726                	add	a4,a4,s1
ffffffffc020a4b2:	474c                	lw	a1,12(a4)
ffffffffc020a4b4:	ca2e                	sw	a1,20(sp)
ffffffffc020a4b6:	e581                	bnez	a1,ffffffffc020a4be <sfs_bmap_load_nolock+0x8a>
ffffffffc020a4b8:	0cc90063          	beq	s2,a2,ffffffffc020a578 <sfs_bmap_load_nolock+0x144>
ffffffffc020a4bc:	d5e1                	beqz	a1,ffffffffc020a484 <sfs_bmap_load_nolock+0x50>
ffffffffc020a4be:	0049a683          	lw	a3,4(s3)
ffffffffc020a4c2:	16d5f863          	bgeu	a1,a3,ffffffffc020a632 <sfs_bmap_load_nolock+0x1fe>
ffffffffc020a4c6:	0389b503          	ld	a0,56(s3)
ffffffffc020a4ca:	b7eff0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020a4ce:	18051763          	bnez	a0,ffffffffc020a65c <sfs_bmap_load_nolock+0x228>
ffffffffc020a4d2:	45d2                	lw	a1,20(sp)
ffffffffc020a4d4:	0049a783          	lw	a5,4(s3)
ffffffffc020a4d8:	d5d5                	beqz	a1,ffffffffc020a484 <sfs_bmap_load_nolock+0x50>
ffffffffc020a4da:	faf5f6e3          	bgeu	a1,a5,ffffffffc020a486 <sfs_bmap_load_nolock+0x52>
ffffffffc020a4de:	0389b503          	ld	a0,56(s3)
ffffffffc020a4e2:	e02e                	sd	a1,0(sp)
ffffffffc020a4e4:	b64ff0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020a4e8:	6582                	ld	a1,0(sp)
ffffffffc020a4ea:	14051763          	bnez	a0,ffffffffc020a638 <sfs_bmap_load_nolock+0x204>
ffffffffc020a4ee:	02890063          	beq	s2,s0,ffffffffc020a50e <sfs_bmap_load_nolock+0xda>
ffffffffc020a4f2:	000a0463          	beqz	s4,ffffffffc020a4fa <sfs_bmap_load_nolock+0xc6>
ffffffffc020a4f6:	00ba2023          	sw	a1,0(s4)
ffffffffc020a4fa:	4781                	li	a5,0
ffffffffc020a4fc:	6446                	ld	s0,80(sp)
ffffffffc020a4fe:	60e6                	ld	ra,88(sp)
ffffffffc020a500:	79e2                	ld	s3,56(sp)
ffffffffc020a502:	7a42                	ld	s4,48(sp)
ffffffffc020a504:	64a6                	ld	s1,72(sp)
ffffffffc020a506:	6906                	ld	s2,64(sp)
ffffffffc020a508:	853e                	mv	a0,a5
ffffffffc020a50a:	6125                	addi	sp,sp,96
ffffffffc020a50c:	8082                	ret
ffffffffc020a50e:	449c                	lw	a5,8(s1)
ffffffffc020a510:	2785                	addiw	a5,a5,1
ffffffffc020a512:	c49c                	sw	a5,8(s1)
ffffffffc020a514:	bff9                	j	ffffffffc020a4f2 <sfs_bmap_load_nolock+0xbe>
ffffffffc020a516:	082c                	addi	a1,sp,24
ffffffffc020a518:	e046                	sd	a7,0(sp)
ffffffffc020a51a:	e442                	sd	a6,8(sp)
ffffffffc020a51c:	e6fff0ef          	jal	ffffffffc020a38a <sfs_block_alloc>
ffffffffc020a520:	87aa                	mv	a5,a0
ffffffffc020a522:	ed5d                	bnez	a0,ffffffffc020a5e0 <sfs_bmap_load_nolock+0x1ac>
ffffffffc020a524:	6882                	ld	a7,0(sp)
ffffffffc020a526:	6822                	ld	a6,8(sp)
ffffffffc020a528:	f05a                	sd	s6,32(sp)
ffffffffc020a52a:	01c10b13          	addi	s6,sp,28
ffffffffc020a52e:	85da                	mv	a1,s6
ffffffffc020a530:	854e                	mv	a0,s3
ffffffffc020a532:	e046                	sd	a7,0(sp)
ffffffffc020a534:	e442                	sd	a6,8(sp)
ffffffffc020a536:	e55ff0ef          	jal	ffffffffc020a38a <sfs_block_alloc>
ffffffffc020a53a:	6882                	ld	a7,0(sp)
ffffffffc020a53c:	87aa                	mv	a5,a0
ffffffffc020a53e:	e959                	bnez	a0,ffffffffc020a5d4 <sfs_bmap_load_nolock+0x1a0>
ffffffffc020a540:	46e2                	lw	a3,24(sp)
ffffffffc020a542:	85da                	mv	a1,s6
ffffffffc020a544:	8756                	mv	a4,s5
ffffffffc020a546:	4611                	li	a2,4
ffffffffc020a548:	854e                	mv	a0,s3
ffffffffc020a54a:	e046                	sd	a7,0(sp)
ffffffffc020a54c:	150010ef          	jal	ffffffffc020b69c <sfs_wbuf>
ffffffffc020a550:	45f2                	lw	a1,28(sp)
ffffffffc020a552:	6882                	ld	a7,0(sp)
ffffffffc020a554:	e92d                	bnez	a0,ffffffffc020a5c6 <sfs_bmap_load_nolock+0x192>
ffffffffc020a556:	5cd8                	lw	a4,60(s1)
ffffffffc020a558:	47e2                	lw	a5,24(sp)
ffffffffc020a55a:	6822                	ld	a6,8(sp)
ffffffffc020a55c:	ca2e                	sw	a1,20(sp)
ffffffffc020a55e:	00f70863          	beq	a4,a5,ffffffffc020a56e <sfs_bmap_load_nolock+0x13a>
ffffffffc020a562:	10071f63          	bnez	a4,ffffffffc020a680 <sfs_bmap_load_nolock+0x24c>
ffffffffc020a566:	dcdc                	sw	a5,60(s1)
ffffffffc020a568:	4785                	li	a5,1
ffffffffc020a56a:	00f83823          	sd	a5,16(a6)
ffffffffc020a56e:	7aa2                	ld	s5,40(sp)
ffffffffc020a570:	7b02                	ld	s6,32(sp)
ffffffffc020a572:	f00589e3          	beqz	a1,ffffffffc020a484 <sfs_bmap_load_nolock+0x50>
ffffffffc020a576:	b7a1                	j	ffffffffc020a4be <sfs_bmap_load_nolock+0x8a>
ffffffffc020a578:	084c                	addi	a1,sp,20
ffffffffc020a57a:	e03a                	sd	a4,0(sp)
ffffffffc020a57c:	e442                	sd	a6,8(sp)
ffffffffc020a57e:	e0dff0ef          	jal	ffffffffc020a38a <sfs_block_alloc>
ffffffffc020a582:	87aa                	mv	a5,a0
ffffffffc020a584:	fd25                	bnez	a0,ffffffffc020a4fc <sfs_bmap_load_nolock+0xc8>
ffffffffc020a586:	45d2                	lw	a1,20(sp)
ffffffffc020a588:	6702                	ld	a4,0(sp)
ffffffffc020a58a:	6822                	ld	a6,8(sp)
ffffffffc020a58c:	4785                	li	a5,1
ffffffffc020a58e:	c74c                	sw	a1,12(a4)
ffffffffc020a590:	00f83823          	sd	a5,16(a6)
ffffffffc020a594:	ee0588e3          	beqz	a1,ffffffffc020a484 <sfs_bmap_load_nolock+0x50>
ffffffffc020a598:	b71d                	j	ffffffffc020a4be <sfs_bmap_load_nolock+0x8a>
ffffffffc020a59a:	e02e                	sd	a1,0(sp)
ffffffffc020a59c:	873e                	mv	a4,a5
ffffffffc020a59e:	086c                	addi	a1,sp,28
ffffffffc020a5a0:	86c6                	mv	a3,a7
ffffffffc020a5a2:	4611                	li	a2,4
ffffffffc020a5a4:	f05a                	sd	s6,32(sp)
ffffffffc020a5a6:	e446                	sd	a7,8(sp)
ffffffffc020a5a8:	074010ef          	jal	ffffffffc020b61c <sfs_rbuf>
ffffffffc020a5ac:	01c10b13          	addi	s6,sp,28
ffffffffc020a5b0:	87aa                	mv	a5,a0
ffffffffc020a5b2:	e505                	bnez	a0,ffffffffc020a5da <sfs_bmap_load_nolock+0x1a6>
ffffffffc020a5b4:	45f2                	lw	a1,28(sp)
ffffffffc020a5b6:	6802                	ld	a6,0(sp)
ffffffffc020a5b8:	00891463          	bne	s2,s0,ffffffffc020a5c0 <sfs_bmap_load_nolock+0x18c>
ffffffffc020a5bc:	68a2                	ld	a7,8(sp)
ffffffffc020a5be:	d9a5                	beqz	a1,ffffffffc020a52e <sfs_bmap_load_nolock+0xfa>
ffffffffc020a5c0:	5cd8                	lw	a4,60(s1)
ffffffffc020a5c2:	47e2                	lw	a5,24(sp)
ffffffffc020a5c4:	bf61                	j	ffffffffc020a55c <sfs_bmap_load_nolock+0x128>
ffffffffc020a5c6:	e42a                	sd	a0,8(sp)
ffffffffc020a5c8:	854e                	mv	a0,s3
ffffffffc020a5ca:	e046                	sd	a7,0(sp)
ffffffffc020a5cc:	badff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020a5d0:	6882                	ld	a7,0(sp)
ffffffffc020a5d2:	67a2                	ld	a5,8(sp)
ffffffffc020a5d4:	45e2                	lw	a1,24(sp)
ffffffffc020a5d6:	00b89763          	bne	a7,a1,ffffffffc020a5e4 <sfs_bmap_load_nolock+0x1b0>
ffffffffc020a5da:	7aa2                	ld	s5,40(sp)
ffffffffc020a5dc:	7b02                	ld	s6,32(sp)
ffffffffc020a5de:	bf39                	j	ffffffffc020a4fc <sfs_bmap_load_nolock+0xc8>
ffffffffc020a5e0:	7aa2                	ld	s5,40(sp)
ffffffffc020a5e2:	bf29                	j	ffffffffc020a4fc <sfs_bmap_load_nolock+0xc8>
ffffffffc020a5e4:	854e                	mv	a0,s3
ffffffffc020a5e6:	e03e                	sd	a5,0(sp)
ffffffffc020a5e8:	b91ff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020a5ec:	6782                	ld	a5,0(sp)
ffffffffc020a5ee:	7aa2                	ld	s5,40(sp)
ffffffffc020a5f0:	7b02                	ld	s6,32(sp)
ffffffffc020a5f2:	b729                	j	ffffffffc020a4fc <sfs_bmap_load_nolock+0xc8>
ffffffffc020a5f4:	00005697          	auipc	a3,0x5
ffffffffc020a5f8:	82c68693          	addi	a3,a3,-2004 # ffffffffc020ee20 <etext+0x300c>
ffffffffc020a5fc:	00002617          	auipc	a2,0x2
ffffffffc020a600:	c5460613          	addi	a2,a2,-940 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a604:	16400593          	li	a1,356
ffffffffc020a608:	00004517          	auipc	a0,0x4
ffffffffc020a60c:	73050513          	addi	a0,a0,1840 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a610:	f456                	sd	s5,40(sp)
ffffffffc020a612:	f05a                	sd	s6,32(sp)
ffffffffc020a614:	e37f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a618:	00005617          	auipc	a2,0x5
ffffffffc020a61c:	83860613          	addi	a2,a2,-1992 # ffffffffc020ee50 <etext+0x303c>
ffffffffc020a620:	11e00593          	li	a1,286
ffffffffc020a624:	00004517          	auipc	a0,0x4
ffffffffc020a628:	71450513          	addi	a0,a0,1812 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a62c:	f05a                	sd	s6,32(sp)
ffffffffc020a62e:	e1df50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a632:	f456                	sd	s5,40(sp)
ffffffffc020a634:	f05a                	sd	s6,32(sp)
ffffffffc020a636:	bda1                	j	ffffffffc020a48e <sfs_bmap_load_nolock+0x5a>
ffffffffc020a638:	00004697          	auipc	a3,0x4
ffffffffc020a63c:	76868693          	addi	a3,a3,1896 # ffffffffc020eda0 <etext+0x2f8c>
ffffffffc020a640:	00002617          	auipc	a2,0x2
ffffffffc020a644:	c1060613          	addi	a2,a2,-1008 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a648:	16b00593          	li	a1,363
ffffffffc020a64c:	00004517          	auipc	a0,0x4
ffffffffc020a650:	6ec50513          	addi	a0,a0,1772 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a654:	f456                	sd	s5,40(sp)
ffffffffc020a656:	f05a                	sd	s6,32(sp)
ffffffffc020a658:	df3f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a65c:	00005697          	auipc	a3,0x5
ffffffffc020a660:	82468693          	addi	a3,a3,-2012 # ffffffffc020ee80 <etext+0x306c>
ffffffffc020a664:	00002617          	auipc	a2,0x2
ffffffffc020a668:	bec60613          	addi	a2,a2,-1044 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a66c:	12100593          	li	a1,289
ffffffffc020a670:	00004517          	auipc	a0,0x4
ffffffffc020a674:	6c850513          	addi	a0,a0,1736 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a678:	f456                	sd	s5,40(sp)
ffffffffc020a67a:	f05a                	sd	s6,32(sp)
ffffffffc020a67c:	dcff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a680:	00004697          	auipc	a3,0x4
ffffffffc020a684:	7b868693          	addi	a3,a3,1976 # ffffffffc020ee38 <etext+0x3024>
ffffffffc020a688:	00002617          	auipc	a2,0x2
ffffffffc020a68c:	bc860613          	addi	a2,a2,-1080 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a690:	11800593          	li	a1,280
ffffffffc020a694:	00004517          	auipc	a0,0x4
ffffffffc020a698:	6a450513          	addi	a0,a0,1700 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a69c:	daff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a6a0 <sfs_io_nolock>:
ffffffffc020a6a0:	7135                	addi	sp,sp,-160
ffffffffc020a6a2:	f4d6                	sd	s5,104(sp)
ffffffffc020a6a4:	8aae                	mv	s5,a1
ffffffffc020a6a6:	618c                	ld	a1,0(a1)
ffffffffc020a6a8:	ed06                	sd	ra,152(sp)
ffffffffc020a6aa:	4809                	li	a6,2
ffffffffc020a6ac:	0045d883          	lhu	a7,4(a1)
ffffffffc020a6b0:	1d088d63          	beq	a7,a6,ffffffffc020a88a <sfs_io_nolock+0x1ea>
ffffffffc020a6b4:	fcce                	sd	s3,120(sp)
ffffffffc020a6b6:	00073983          	ld	s3,0(a4) # 8000000 <_binary_bin_sfs_img_size+0x7f8ad00>
ffffffffc020a6ba:	f8d2                	sd	s4,112(sp)
ffffffffc020a6bc:	e0ea                	sd	s10,64(sp)
ffffffffc020a6be:	8d3a                	mv	s10,a4
ffffffffc020a6c0:	000d3023          	sd	zero,0(s10)
ffffffffc020a6c4:	08000737          	lui	a4,0x8000
ffffffffc020a6c8:	8a36                	mv	s4,a3
ffffffffc020a6ca:	99b6                	add	s3,s3,a3
ffffffffc020a6cc:	1ae6fd63          	bgeu	a3,a4,ffffffffc020a886 <sfs_io_nolock+0x1e6>
ffffffffc020a6d0:	1ad9cb63          	blt	s3,a3,ffffffffc020a886 <sfs_io_nolock+0x1e6>
ffffffffc020a6d4:	15368463          	beq	a3,s3,ffffffffc020a81c <sfs_io_nolock+0x17c>
ffffffffc020a6d8:	e14a                	sd	s2,128(sp)
ffffffffc020a6da:	e4e6                	sd	s9,72(sp)
ffffffffc020a6dc:	e8e2                	sd	s8,80(sp)
ffffffffc020a6de:	8cb2                	mv	s9,a2
ffffffffc020a6e0:	892a                	mv	s2,a0
ffffffffc020a6e2:	01377363          	bgeu	a4,s3,ffffffffc020a6e8 <sfs_io_nolock+0x48>
ffffffffc020a6e6:	89ba                	mv	s3,a4
ffffffffc020a6e8:	c3f1                	beqz	a5,ffffffffc020a7ac <sfs_io_nolock+0x10c>
ffffffffc020a6ea:	00001797          	auipc	a5,0x1
ffffffffc020a6ee:	fb278793          	addi	a5,a5,-78 # ffffffffc020b69c <sfs_wbuf>
ffffffffc020a6f2:	e922                	sd	s0,144(sp)
ffffffffc020a6f4:	e526                	sd	s1,136(sp)
ffffffffc020a6f6:	f0da                	sd	s6,96(sp)
ffffffffc020a6f8:	ecde                	sd	s7,88(sp)
ffffffffc020a6fa:	fc6e                	sd	s11,56(sp)
ffffffffc020a6fc:	00001c17          	auipc	s8,0x1
ffffffffc020a700:	ebec0c13          	addi	s8,s8,-322 # ffffffffc020b5ba <sfs_wblock>
ffffffffc020a704:	e43e                	sd	a5,8(sp)
ffffffffc020a706:	6705                	lui	a4,0x1
ffffffffc020a708:	40ca5413          	srai	s0,s4,0xc
ffffffffc020a70c:	fff70b13          	addi	s6,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a710:	40c9db93          	srai	s7,s3,0xc
ffffffffc020a714:	408b8bbb          	subw	s7,s7,s0
ffffffffc020a718:	016a7b33          	and	s6,s4,s6
ffffffffc020a71c:	2401                	sext.w	s0,s0
ffffffffc020a71e:	87de                	mv	a5,s7
ffffffffc020a720:	100b0663          	beqz	s6,ffffffffc020a82c <sfs_io_nolock+0x18c>
ffffffffc020a724:	414984b3          	sub	s1,s3,s4
ffffffffc020a728:	100b9463          	bnez	s7,ffffffffc020a830 <sfs_io_nolock+0x190>
ffffffffc020a72c:	1074                	addi	a3,sp,44
ffffffffc020a72e:	8622                	mv	a2,s0
ffffffffc020a730:	85d6                	mv	a1,s5
ffffffffc020a732:	854a                	mv	a0,s2
ffffffffc020a734:	d01ff0ef          	jal	ffffffffc020a434 <sfs_bmap_load_nolock>
ffffffffc020a738:	e939                	bnez	a0,ffffffffc020a78e <sfs_io_nolock+0xee>
ffffffffc020a73a:	56b2                	lw	a3,44(sp)
ffffffffc020a73c:	67a2                	ld	a5,8(sp)
ffffffffc020a73e:	875a                	mv	a4,s6
ffffffffc020a740:	8626                	mv	a2,s1
ffffffffc020a742:	85e6                	mv	a1,s9
ffffffffc020a744:	854a                	mv	a0,s2
ffffffffc020a746:	8da6                	mv	s11,s1
ffffffffc020a748:	9782                	jalr	a5
ffffffffc020a74a:	e131                	bnez	a0,ffffffffc020a78e <sfs_io_nolock+0xee>
ffffffffc020a74c:	100b8563          	beqz	s7,ffffffffc020a856 <sfs_io_nolock+0x1b6>
ffffffffc020a750:	9ca6                	add	s9,s9,s1
ffffffffc020a752:	2405                	addiw	s0,s0,1
ffffffffc020a754:	fffb879b          	addiw	a5,s7,-1
ffffffffc020a758:	12078463          	beqz	a5,ffffffffc020a880 <sfs_io_nolock+0x1e0>
ffffffffc020a75c:	00878b3b          	addw	s6,a5,s0
ffffffffc020a760:	e85a                	sd	s6,16(sp)
ffffffffc020a762:	84e6                	mv	s1,s9
ffffffffc020a764:	6b85                	lui	s7,0x1
ffffffffc020a766:	a829                	j	ffffffffc020a780 <sfs_io_nolock+0xe0>
ffffffffc020a768:	5632                	lw	a2,44(sp)
ffffffffc020a76a:	4685                	li	a3,1
ffffffffc020a76c:	85a6                	mv	a1,s1
ffffffffc020a76e:	854a                	mv	a0,s2
ffffffffc020a770:	9c02                	jalr	s8
ffffffffc020a772:	ed11                	bnez	a0,ffffffffc020a78e <sfs_io_nolock+0xee>
ffffffffc020a774:	2405                	addiw	s0,s0,1
ffffffffc020a776:	017487b3          	add	a5,s1,s7
ffffffffc020a77a:	05640e63          	beq	s0,s6,ffffffffc020a7d6 <sfs_io_nolock+0x136>
ffffffffc020a77e:	84be                	mv	s1,a5
ffffffffc020a780:	1074                	addi	a3,sp,44
ffffffffc020a782:	8622                	mv	a2,s0
ffffffffc020a784:	85d6                	mv	a1,s5
ffffffffc020a786:	854a                	mv	a0,s2
ffffffffc020a788:	cadff0ef          	jal	ffffffffc020a434 <sfs_bmap_load_nolock>
ffffffffc020a78c:	dd71                	beqz	a0,ffffffffc020a768 <sfs_io_nolock+0xc8>
ffffffffc020a78e:	644a                	ld	s0,144(sp)
ffffffffc020a790:	64aa                	ld	s1,136(sp)
ffffffffc020a792:	690a                	ld	s2,128(sp)
ffffffffc020a794:	7b06                	ld	s6,96(sp)
ffffffffc020a796:	6be6                	ld	s7,88(sp)
ffffffffc020a798:	6c46                	ld	s8,80(sp)
ffffffffc020a79a:	6ca6                	ld	s9,72(sp)
ffffffffc020a79c:	7de2                	ld	s11,56(sp)
ffffffffc020a79e:	60ea                	ld	ra,152(sp)
ffffffffc020a7a0:	79e6                	ld	s3,120(sp)
ffffffffc020a7a2:	7a46                	ld	s4,112(sp)
ffffffffc020a7a4:	6d06                	ld	s10,64(sp)
ffffffffc020a7a6:	7aa6                	ld	s5,104(sp)
ffffffffc020a7a8:	610d                	addi	sp,sp,160
ffffffffc020a7aa:	8082                	ret
ffffffffc020a7ac:	0005e783          	lwu	a5,0(a1)
ffffffffc020a7b0:	08fa5e63          	bge	s4,a5,ffffffffc020a84c <sfs_io_nolock+0x1ac>
ffffffffc020a7b4:	e922                	sd	s0,144(sp)
ffffffffc020a7b6:	e526                	sd	s1,136(sp)
ffffffffc020a7b8:	f0da                	sd	s6,96(sp)
ffffffffc020a7ba:	ecde                	sd	s7,88(sp)
ffffffffc020a7bc:	fc6e                	sd	s11,56(sp)
ffffffffc020a7be:	0737cc63          	blt	a5,s3,ffffffffc020a836 <sfs_io_nolock+0x196>
ffffffffc020a7c2:	00001797          	auipc	a5,0x1
ffffffffc020a7c6:	e5a78793          	addi	a5,a5,-422 # ffffffffc020b61c <sfs_rbuf>
ffffffffc020a7ca:	00001c17          	auipc	s8,0x1
ffffffffc020a7ce:	d8ec0c13          	addi	s8,s8,-626 # ffffffffc020b558 <sfs_rblock>
ffffffffc020a7d2:	e43e                	sd	a5,8(sp)
ffffffffc020a7d4:	bf0d                	j	ffffffffc020a706 <sfs_io_nolock+0x66>
ffffffffc020a7d6:	9bee                	add	s7,s7,s11
ffffffffc020a7d8:	419b8bb3          	sub	s7,s7,s9
ffffffffc020a7dc:	01748db3          	add	s11,s1,s7
ffffffffc020a7e0:	19d2                	slli	s3,s3,0x34
ffffffffc020a7e2:	0349d413          	srli	s0,s3,0x34
ffffffffc020a7e6:	06099b63          	bnez	s3,ffffffffc020a85c <sfs_io_nolock+0x1bc>
ffffffffc020a7ea:	000ab703          	ld	a4,0(s5)
ffffffffc020a7ee:	01bd3023          	sd	s11,0(s10)
ffffffffc020a7f2:	01ba07b3          	add	a5,s4,s11
ffffffffc020a7f6:	00076683          	lwu	a3,0(a4)
ffffffffc020a7fa:	00f6f963          	bgeu	a3,a5,ffffffffc020a80c <sfs_io_nolock+0x16c>
ffffffffc020a7fe:	01ba0a3b          	addw	s4,s4,s11
ffffffffc020a802:	01472023          	sw	s4,0(a4)
ffffffffc020a806:	4785                	li	a5,1
ffffffffc020a808:	00fab823          	sd	a5,16(s5)
ffffffffc020a80c:	644a                	ld	s0,144(sp)
ffffffffc020a80e:	64aa                	ld	s1,136(sp)
ffffffffc020a810:	690a                	ld	s2,128(sp)
ffffffffc020a812:	7b06                	ld	s6,96(sp)
ffffffffc020a814:	6be6                	ld	s7,88(sp)
ffffffffc020a816:	6c46                	ld	s8,80(sp)
ffffffffc020a818:	6ca6                	ld	s9,72(sp)
ffffffffc020a81a:	7de2                	ld	s11,56(sp)
ffffffffc020a81c:	4501                	li	a0,0
ffffffffc020a81e:	60ea                	ld	ra,152(sp)
ffffffffc020a820:	79e6                	ld	s3,120(sp)
ffffffffc020a822:	7a46                	ld	s4,112(sp)
ffffffffc020a824:	6d06                	ld	s10,64(sp)
ffffffffc020a826:	7aa6                	ld	s5,104(sp)
ffffffffc020a828:	610d                	addi	sp,sp,160
ffffffffc020a82a:	8082                	ret
ffffffffc020a82c:	4d81                	li	s11,0
ffffffffc020a82e:	b72d                	j	ffffffffc020a758 <sfs_io_nolock+0xb8>
ffffffffc020a830:	416704b3          	sub	s1,a4,s6
ffffffffc020a834:	bde5                	j	ffffffffc020a72c <sfs_io_nolock+0x8c>
ffffffffc020a836:	89be                	mv	s3,a5
ffffffffc020a838:	00001797          	auipc	a5,0x1
ffffffffc020a83c:	de478793          	addi	a5,a5,-540 # ffffffffc020b61c <sfs_rbuf>
ffffffffc020a840:	00001c17          	auipc	s8,0x1
ffffffffc020a844:	d18c0c13          	addi	s8,s8,-744 # ffffffffc020b558 <sfs_rblock>
ffffffffc020a848:	e43e                	sd	a5,8(sp)
ffffffffc020a84a:	bd75                	j	ffffffffc020a706 <sfs_io_nolock+0x66>
ffffffffc020a84c:	690a                	ld	s2,128(sp)
ffffffffc020a84e:	6c46                	ld	s8,80(sp)
ffffffffc020a850:	6ca6                	ld	s9,72(sp)
ffffffffc020a852:	4501                	li	a0,0
ffffffffc020a854:	b7e9                	j	ffffffffc020a81e <sfs_io_nolock+0x17e>
ffffffffc020a856:	009d3023          	sd	s1,0(s10)
ffffffffc020a85a:	bf4d                	j	ffffffffc020a80c <sfs_io_nolock+0x16c>
ffffffffc020a85c:	6642                	ld	a2,16(sp)
ffffffffc020a85e:	1074                	addi	a3,sp,44
ffffffffc020a860:	85d6                	mv	a1,s5
ffffffffc020a862:	854a                	mv	a0,s2
ffffffffc020a864:	ec3e                	sd	a5,24(sp)
ffffffffc020a866:	bcfff0ef          	jal	ffffffffc020a434 <sfs_bmap_load_nolock>
ffffffffc020a86a:	f115                	bnez	a0,ffffffffc020a78e <sfs_io_nolock+0xee>
ffffffffc020a86c:	56b2                	lw	a3,44(sp)
ffffffffc020a86e:	65e2                	ld	a1,24(sp)
ffffffffc020a870:	67a2                	ld	a5,8(sp)
ffffffffc020a872:	854a                	mv	a0,s2
ffffffffc020a874:	4701                	li	a4,0
ffffffffc020a876:	8622                	mv	a2,s0
ffffffffc020a878:	9782                	jalr	a5
ffffffffc020a87a:	f911                	bnez	a0,ffffffffc020a78e <sfs_io_nolock+0xee>
ffffffffc020a87c:	9da2                	add	s11,s11,s0
ffffffffc020a87e:	b7b5                	j	ffffffffc020a7ea <sfs_io_nolock+0x14a>
ffffffffc020a880:	e822                	sd	s0,16(sp)
ffffffffc020a882:	87e6                	mv	a5,s9
ffffffffc020a884:	bfb1                	j	ffffffffc020a7e0 <sfs_io_nolock+0x140>
ffffffffc020a886:	5575                	li	a0,-3
ffffffffc020a888:	bf19                	j	ffffffffc020a79e <sfs_io_nolock+0xfe>
ffffffffc020a88a:	00004697          	auipc	a3,0x4
ffffffffc020a88e:	61e68693          	addi	a3,a3,1566 # ffffffffc020eea8 <etext+0x3094>
ffffffffc020a892:	00002617          	auipc	a2,0x2
ffffffffc020a896:	9be60613          	addi	a2,a2,-1602 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a89a:	22b00593          	li	a1,555
ffffffffc020a89e:	00004517          	auipc	a0,0x4
ffffffffc020a8a2:	49a50513          	addi	a0,a0,1178 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a8a6:	e922                	sd	s0,144(sp)
ffffffffc020a8a8:	e526                	sd	s1,136(sp)
ffffffffc020a8aa:	e14a                	sd	s2,128(sp)
ffffffffc020a8ac:	fcce                	sd	s3,120(sp)
ffffffffc020a8ae:	f8d2                	sd	s4,112(sp)
ffffffffc020a8b0:	f0da                	sd	s6,96(sp)
ffffffffc020a8b2:	ecde                	sd	s7,88(sp)
ffffffffc020a8b4:	e8e2                	sd	s8,80(sp)
ffffffffc020a8b6:	e4e6                	sd	s9,72(sp)
ffffffffc020a8b8:	e0ea                	sd	s10,64(sp)
ffffffffc020a8ba:	fc6e                	sd	s11,56(sp)
ffffffffc020a8bc:	b8ff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a8c0 <sfs_read>:
ffffffffc020a8c0:	7139                	addi	sp,sp,-64
ffffffffc020a8c2:	f04a                	sd	s2,32(sp)
ffffffffc020a8c4:	06853903          	ld	s2,104(a0)
ffffffffc020a8c8:	fc06                	sd	ra,56(sp)
ffffffffc020a8ca:	f822                	sd	s0,48(sp)
ffffffffc020a8cc:	f426                	sd	s1,40(sp)
ffffffffc020a8ce:	ec4e                	sd	s3,24(sp)
ffffffffc020a8d0:	04090e63          	beqz	s2,ffffffffc020a92c <sfs_read+0x6c>
ffffffffc020a8d4:	0b092783          	lw	a5,176(s2)
ffffffffc020a8d8:	ebb1                	bnez	a5,ffffffffc020a92c <sfs_read+0x6c>
ffffffffc020a8da:	4d38                	lw	a4,88(a0)
ffffffffc020a8dc:	6785                	lui	a5,0x1
ffffffffc020a8de:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a8e2:	842a                	mv	s0,a0
ffffffffc020a8e4:	06f71463          	bne	a4,a5,ffffffffc020a94c <sfs_read+0x8c>
ffffffffc020a8e8:	02050993          	addi	s3,a0,32
ffffffffc020a8ec:	854e                	mv	a0,s3
ffffffffc020a8ee:	84ae                	mv	s1,a1
ffffffffc020a8f0:	d8bf90ef          	jal	ffffffffc020467a <down>
ffffffffc020a8f4:	6c9c                	ld	a5,24(s1)
ffffffffc020a8f6:	6494                	ld	a3,8(s1)
ffffffffc020a8f8:	6090                	ld	a2,0(s1)
ffffffffc020a8fa:	85a2                	mv	a1,s0
ffffffffc020a8fc:	e43e                	sd	a5,8(sp)
ffffffffc020a8fe:	854a                	mv	a0,s2
ffffffffc020a900:	0038                	addi	a4,sp,8
ffffffffc020a902:	4781                	li	a5,0
ffffffffc020a904:	d9dff0ef          	jal	ffffffffc020a6a0 <sfs_io_nolock>
ffffffffc020a908:	65a2                	ld	a1,8(sp)
ffffffffc020a90a:	842a                	mv	s0,a0
ffffffffc020a90c:	ed81                	bnez	a1,ffffffffc020a924 <sfs_read+0x64>
ffffffffc020a90e:	854e                	mv	a0,s3
ffffffffc020a910:	d67f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020a914:	70e2                	ld	ra,56(sp)
ffffffffc020a916:	8522                	mv	a0,s0
ffffffffc020a918:	7442                	ld	s0,48(sp)
ffffffffc020a91a:	74a2                	ld	s1,40(sp)
ffffffffc020a91c:	7902                	ld	s2,32(sp)
ffffffffc020a91e:	69e2                	ld	s3,24(sp)
ffffffffc020a920:	6121                	addi	sp,sp,64
ffffffffc020a922:	8082                	ret
ffffffffc020a924:	8526                	mv	a0,s1
ffffffffc020a926:	c79fa0ef          	jal	ffffffffc020559e <iobuf_skip>
ffffffffc020a92a:	b7d5                	j	ffffffffc020a90e <sfs_read+0x4e>
ffffffffc020a92c:	00004697          	auipc	a3,0x4
ffffffffc020a930:	22c68693          	addi	a3,a3,556 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020a934:	00002617          	auipc	a2,0x2
ffffffffc020a938:	91c60613          	addi	a2,a2,-1764 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a93c:	29800593          	li	a1,664
ffffffffc020a940:	00004517          	auipc	a0,0x4
ffffffffc020a944:	3f850513          	addi	a0,a0,1016 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a948:	b03f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a94c:	809ff0ef          	jal	ffffffffc020a154 <sfs_io.part.0>

ffffffffc020a950 <sfs_write>:
ffffffffc020a950:	7139                	addi	sp,sp,-64
ffffffffc020a952:	f04a                	sd	s2,32(sp)
ffffffffc020a954:	06853903          	ld	s2,104(a0)
ffffffffc020a958:	fc06                	sd	ra,56(sp)
ffffffffc020a95a:	f822                	sd	s0,48(sp)
ffffffffc020a95c:	f426                	sd	s1,40(sp)
ffffffffc020a95e:	ec4e                	sd	s3,24(sp)
ffffffffc020a960:	04090e63          	beqz	s2,ffffffffc020a9bc <sfs_write+0x6c>
ffffffffc020a964:	0b092783          	lw	a5,176(s2)
ffffffffc020a968:	ebb1                	bnez	a5,ffffffffc020a9bc <sfs_write+0x6c>
ffffffffc020a96a:	4d38                	lw	a4,88(a0)
ffffffffc020a96c:	6785                	lui	a5,0x1
ffffffffc020a96e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a972:	842a                	mv	s0,a0
ffffffffc020a974:	06f71463          	bne	a4,a5,ffffffffc020a9dc <sfs_write+0x8c>
ffffffffc020a978:	02050993          	addi	s3,a0,32
ffffffffc020a97c:	854e                	mv	a0,s3
ffffffffc020a97e:	84ae                	mv	s1,a1
ffffffffc020a980:	cfbf90ef          	jal	ffffffffc020467a <down>
ffffffffc020a984:	6c9c                	ld	a5,24(s1)
ffffffffc020a986:	6494                	ld	a3,8(s1)
ffffffffc020a988:	6090                	ld	a2,0(s1)
ffffffffc020a98a:	85a2                	mv	a1,s0
ffffffffc020a98c:	e43e                	sd	a5,8(sp)
ffffffffc020a98e:	854a                	mv	a0,s2
ffffffffc020a990:	0038                	addi	a4,sp,8
ffffffffc020a992:	4785                	li	a5,1
ffffffffc020a994:	d0dff0ef          	jal	ffffffffc020a6a0 <sfs_io_nolock>
ffffffffc020a998:	65a2                	ld	a1,8(sp)
ffffffffc020a99a:	842a                	mv	s0,a0
ffffffffc020a99c:	ed81                	bnez	a1,ffffffffc020a9b4 <sfs_write+0x64>
ffffffffc020a99e:	854e                	mv	a0,s3
ffffffffc020a9a0:	cd7f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020a9a4:	70e2                	ld	ra,56(sp)
ffffffffc020a9a6:	8522                	mv	a0,s0
ffffffffc020a9a8:	7442                	ld	s0,48(sp)
ffffffffc020a9aa:	74a2                	ld	s1,40(sp)
ffffffffc020a9ac:	7902                	ld	s2,32(sp)
ffffffffc020a9ae:	69e2                	ld	s3,24(sp)
ffffffffc020a9b0:	6121                	addi	sp,sp,64
ffffffffc020a9b2:	8082                	ret
ffffffffc020a9b4:	8526                	mv	a0,s1
ffffffffc020a9b6:	be9fa0ef          	jal	ffffffffc020559e <iobuf_skip>
ffffffffc020a9ba:	b7d5                	j	ffffffffc020a99e <sfs_write+0x4e>
ffffffffc020a9bc:	00004697          	auipc	a3,0x4
ffffffffc020a9c0:	19c68693          	addi	a3,a3,412 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020a9c4:	00002617          	auipc	a2,0x2
ffffffffc020a9c8:	88c60613          	addi	a2,a2,-1908 # ffffffffc020c250 <etext+0x43c>
ffffffffc020a9cc:	29800593          	li	a1,664
ffffffffc020a9d0:	00004517          	auipc	a0,0x4
ffffffffc020a9d4:	36850513          	addi	a0,a0,872 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020a9d8:	a73f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9dc:	f78ff0ef          	jal	ffffffffc020a154 <sfs_io.part.0>

ffffffffc020a9e0 <sfs_dirent_read_nolock>:
ffffffffc020a9e0:	619c                	ld	a5,0(a1)
ffffffffc020a9e2:	7139                	addi	sp,sp,-64
ffffffffc020a9e4:	f426                	sd	s1,40(sp)
ffffffffc020a9e6:	84b6                	mv	s1,a3
ffffffffc020a9e8:	0047d683          	lhu	a3,4(a5)
ffffffffc020a9ec:	fc06                	sd	ra,56(sp)
ffffffffc020a9ee:	f822                	sd	s0,48(sp)
ffffffffc020a9f0:	4709                	li	a4,2
ffffffffc020a9f2:	04e69963          	bne	a3,a4,ffffffffc020aa44 <sfs_dirent_read_nolock+0x64>
ffffffffc020a9f6:	479c                	lw	a5,8(a5)
ffffffffc020a9f8:	04f67663          	bgeu	a2,a5,ffffffffc020aa44 <sfs_dirent_read_nolock+0x64>
ffffffffc020a9fc:	0874                	addi	a3,sp,28
ffffffffc020a9fe:	842a                	mv	s0,a0
ffffffffc020aa00:	a35ff0ef          	jal	ffffffffc020a434 <sfs_bmap_load_nolock>
ffffffffc020aa04:	c511                	beqz	a0,ffffffffc020aa10 <sfs_dirent_read_nolock+0x30>
ffffffffc020aa06:	70e2                	ld	ra,56(sp)
ffffffffc020aa08:	7442                	ld	s0,48(sp)
ffffffffc020aa0a:	74a2                	ld	s1,40(sp)
ffffffffc020aa0c:	6121                	addi	sp,sp,64
ffffffffc020aa0e:	8082                	ret
ffffffffc020aa10:	45f2                	lw	a1,28(sp)
ffffffffc020aa12:	c9a9                	beqz	a1,ffffffffc020aa64 <sfs_dirent_read_nolock+0x84>
ffffffffc020aa14:	405c                	lw	a5,4(s0)
ffffffffc020aa16:	04f5f763          	bgeu	a1,a5,ffffffffc020aa64 <sfs_dirent_read_nolock+0x84>
ffffffffc020aa1a:	7c08                	ld	a0,56(s0)
ffffffffc020aa1c:	e42e                	sd	a1,8(sp)
ffffffffc020aa1e:	e2bfe0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020aa22:	ed39                	bnez	a0,ffffffffc020aa80 <sfs_dirent_read_nolock+0xa0>
ffffffffc020aa24:	66a2                	ld	a3,8(sp)
ffffffffc020aa26:	8522                	mv	a0,s0
ffffffffc020aa28:	4701                	li	a4,0
ffffffffc020aa2a:	10400613          	li	a2,260
ffffffffc020aa2e:	85a6                	mv	a1,s1
ffffffffc020aa30:	3ed000ef          	jal	ffffffffc020b61c <sfs_rbuf>
ffffffffc020aa34:	f969                	bnez	a0,ffffffffc020aa06 <sfs_dirent_read_nolock+0x26>
ffffffffc020aa36:	100481a3          	sb	zero,259(s1)
ffffffffc020aa3a:	70e2                	ld	ra,56(sp)
ffffffffc020aa3c:	7442                	ld	s0,48(sp)
ffffffffc020aa3e:	74a2                	ld	s1,40(sp)
ffffffffc020aa40:	6121                	addi	sp,sp,64
ffffffffc020aa42:	8082                	ret
ffffffffc020aa44:	00004697          	auipc	a3,0x4
ffffffffc020aa48:	48468693          	addi	a3,a3,1156 # ffffffffc020eec8 <etext+0x30b4>
ffffffffc020aa4c:	00002617          	auipc	a2,0x2
ffffffffc020aa50:	80460613          	addi	a2,a2,-2044 # ffffffffc020c250 <etext+0x43c>
ffffffffc020aa54:	18e00593          	li	a1,398
ffffffffc020aa58:	00004517          	auipc	a0,0x4
ffffffffc020aa5c:	2e050513          	addi	a0,a0,736 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020aa60:	9ebf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa64:	4054                	lw	a3,4(s0)
ffffffffc020aa66:	872e                	mv	a4,a1
ffffffffc020aa68:	00004617          	auipc	a2,0x4
ffffffffc020aa6c:	30060613          	addi	a2,a2,768 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020aa70:	05300593          	li	a1,83
ffffffffc020aa74:	00004517          	auipc	a0,0x4
ffffffffc020aa78:	2c450513          	addi	a0,a0,708 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020aa7c:	9cff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aa80:	00004697          	auipc	a3,0x4
ffffffffc020aa84:	32068693          	addi	a3,a3,800 # ffffffffc020eda0 <etext+0x2f8c>
ffffffffc020aa88:	00001617          	auipc	a2,0x1
ffffffffc020aa8c:	7c860613          	addi	a2,a2,1992 # ffffffffc020c250 <etext+0x43c>
ffffffffc020aa90:	19500593          	li	a1,405
ffffffffc020aa94:	00004517          	auipc	a0,0x4
ffffffffc020aa98:	2a450513          	addi	a0,a0,676 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020aa9c:	9aff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aaa0 <sfs_getdirentry>:
ffffffffc020aaa0:	715d                	addi	sp,sp,-80
ffffffffc020aaa2:	f052                	sd	s4,32(sp)
ffffffffc020aaa4:	8a2a                	mv	s4,a0
ffffffffc020aaa6:	10400513          	li	a0,260
ffffffffc020aaaa:	e85a                	sd	s6,16(sp)
ffffffffc020aaac:	e486                	sd	ra,72(sp)
ffffffffc020aaae:	e0a2                	sd	s0,64(sp)
ffffffffc020aab0:	8b2e                	mv	s6,a1
ffffffffc020aab2:	d4af70ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020aab6:	0e050963          	beqz	a0,ffffffffc020aba8 <sfs_getdirentry+0x108>
ffffffffc020aaba:	ec56                	sd	s5,24(sp)
ffffffffc020aabc:	068a3a83          	ld	s5,104(s4)
ffffffffc020aac0:	0e0a8663          	beqz	s5,ffffffffc020abac <sfs_getdirentry+0x10c>
ffffffffc020aac4:	0b0aa783          	lw	a5,176(s5)
ffffffffc020aac8:	0e079263          	bnez	a5,ffffffffc020abac <sfs_getdirentry+0x10c>
ffffffffc020aacc:	058a2703          	lw	a4,88(s4)
ffffffffc020aad0:	6785                	lui	a5,0x1
ffffffffc020aad2:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020aad6:	10f71063          	bne	a4,a5,ffffffffc020abd6 <sfs_getdirentry+0x136>
ffffffffc020aada:	f44e                	sd	s3,40(sp)
ffffffffc020aadc:	57fd                	li	a5,-1
ffffffffc020aade:	008b3983          	ld	s3,8(s6)
ffffffffc020aae2:	17fe                	slli	a5,a5,0x3f
ffffffffc020aae4:	0ff78793          	addi	a5,a5,255
ffffffffc020aae8:	00f9f7b3          	and	a5,s3,a5
ffffffffc020aaec:	e3d5                	bnez	a5,ffffffffc020ab90 <sfs_getdirentry+0xf0>
ffffffffc020aaee:	000a3783          	ld	a5,0(s4)
ffffffffc020aaf2:	0089d993          	srli	s3,s3,0x8
ffffffffc020aaf6:	2981                	sext.w	s3,s3
ffffffffc020aaf8:	479c                	lw	a5,8(a5)
ffffffffc020aafa:	0b37e163          	bltu	a5,s3,ffffffffc020ab9c <sfs_getdirentry+0xfc>
ffffffffc020aafe:	f84a                	sd	s2,48(sp)
ffffffffc020ab00:	892a                	mv	s2,a0
ffffffffc020ab02:	020a0513          	addi	a0,s4,32
ffffffffc020ab06:	e45e                	sd	s7,8(sp)
ffffffffc020ab08:	b73f90ef          	jal	ffffffffc020467a <down>
ffffffffc020ab0c:	000a3783          	ld	a5,0(s4)
ffffffffc020ab10:	0087ab83          	lw	s7,8(a5)
ffffffffc020ab14:	07705c63          	blez	s7,ffffffffc020ab8c <sfs_getdirentry+0xec>
ffffffffc020ab18:	fc26                	sd	s1,56(sp)
ffffffffc020ab1a:	4481                	li	s1,0
ffffffffc020ab1c:	a811                	j	ffffffffc020ab30 <sfs_getdirentry+0x90>
ffffffffc020ab1e:	00092783          	lw	a5,0(s2)
ffffffffc020ab22:	c781                	beqz	a5,ffffffffc020ab2a <sfs_getdirentry+0x8a>
ffffffffc020ab24:	02098463          	beqz	s3,ffffffffc020ab4c <sfs_getdirentry+0xac>
ffffffffc020ab28:	39fd                	addiw	s3,s3,-1
ffffffffc020ab2a:	2485                	addiw	s1,s1,1
ffffffffc020ab2c:	049b8d63          	beq	s7,s1,ffffffffc020ab86 <sfs_getdirentry+0xe6>
ffffffffc020ab30:	86ca                	mv	a3,s2
ffffffffc020ab32:	8626                	mv	a2,s1
ffffffffc020ab34:	85d2                	mv	a1,s4
ffffffffc020ab36:	8556                	mv	a0,s5
ffffffffc020ab38:	ea9ff0ef          	jal	ffffffffc020a9e0 <sfs_dirent_read_nolock>
ffffffffc020ab3c:	842a                	mv	s0,a0
ffffffffc020ab3e:	d165                	beqz	a0,ffffffffc020ab1e <sfs_getdirentry+0x7e>
ffffffffc020ab40:	74e2                	ld	s1,56(sp)
ffffffffc020ab42:	020a0513          	addi	a0,s4,32
ffffffffc020ab46:	b31f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020ab4a:	a005                	j	ffffffffc020ab6a <sfs_getdirentry+0xca>
ffffffffc020ab4c:	020a0513          	addi	a0,s4,32
ffffffffc020ab50:	b27f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020ab54:	855a                	mv	a0,s6
ffffffffc020ab56:	00490593          	addi	a1,s2,4
ffffffffc020ab5a:	4701                	li	a4,0
ffffffffc020ab5c:	4685                	li	a3,1
ffffffffc020ab5e:	10000613          	li	a2,256
ffffffffc020ab62:	9b9fa0ef          	jal	ffffffffc020551a <iobuf_move>
ffffffffc020ab66:	74e2                	ld	s1,56(sp)
ffffffffc020ab68:	842a                	mv	s0,a0
ffffffffc020ab6a:	854a                	mv	a0,s2
ffffffffc020ab6c:	d36f70ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020ab70:	7942                	ld	s2,48(sp)
ffffffffc020ab72:	79a2                	ld	s3,40(sp)
ffffffffc020ab74:	6ae2                	ld	s5,24(sp)
ffffffffc020ab76:	6ba2                	ld	s7,8(sp)
ffffffffc020ab78:	60a6                	ld	ra,72(sp)
ffffffffc020ab7a:	8522                	mv	a0,s0
ffffffffc020ab7c:	6406                	ld	s0,64(sp)
ffffffffc020ab7e:	7a02                	ld	s4,32(sp)
ffffffffc020ab80:	6b42                	ld	s6,16(sp)
ffffffffc020ab82:	6161                	addi	sp,sp,80
ffffffffc020ab84:	8082                	ret
ffffffffc020ab86:	74e2                	ld	s1,56(sp)
ffffffffc020ab88:	5441                	li	s0,-16
ffffffffc020ab8a:	bf65                	j	ffffffffc020ab42 <sfs_getdirentry+0xa2>
ffffffffc020ab8c:	5441                	li	s0,-16
ffffffffc020ab8e:	bf55                	j	ffffffffc020ab42 <sfs_getdirentry+0xa2>
ffffffffc020ab90:	d12f70ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020ab94:	5475                	li	s0,-3
ffffffffc020ab96:	79a2                	ld	s3,40(sp)
ffffffffc020ab98:	6ae2                	ld	s5,24(sp)
ffffffffc020ab9a:	bff9                	j	ffffffffc020ab78 <sfs_getdirentry+0xd8>
ffffffffc020ab9c:	d06f70ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020aba0:	5441                	li	s0,-16
ffffffffc020aba2:	79a2                	ld	s3,40(sp)
ffffffffc020aba4:	6ae2                	ld	s5,24(sp)
ffffffffc020aba6:	bfc9                	j	ffffffffc020ab78 <sfs_getdirentry+0xd8>
ffffffffc020aba8:	5471                	li	s0,-4
ffffffffc020abaa:	b7f9                	j	ffffffffc020ab78 <sfs_getdirentry+0xd8>
ffffffffc020abac:	00004697          	auipc	a3,0x4
ffffffffc020abb0:	fac68693          	addi	a3,a3,-84 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020abb4:	00001617          	auipc	a2,0x1
ffffffffc020abb8:	69c60613          	addi	a2,a2,1692 # ffffffffc020c250 <etext+0x43c>
ffffffffc020abbc:	33c00593          	li	a1,828
ffffffffc020abc0:	00004517          	auipc	a0,0x4
ffffffffc020abc4:	17850513          	addi	a0,a0,376 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020abc8:	fc26                	sd	s1,56(sp)
ffffffffc020abca:	f84a                	sd	s2,48(sp)
ffffffffc020abcc:	f44e                	sd	s3,40(sp)
ffffffffc020abce:	e45e                	sd	s7,8(sp)
ffffffffc020abd0:	e062                	sd	s8,0(sp)
ffffffffc020abd2:	879f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020abd6:	00004697          	auipc	a3,0x4
ffffffffc020abda:	12a68693          	addi	a3,a3,298 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020abde:	00001617          	auipc	a2,0x1
ffffffffc020abe2:	67260613          	addi	a2,a2,1650 # ffffffffc020c250 <etext+0x43c>
ffffffffc020abe6:	33d00593          	li	a1,829
ffffffffc020abea:	00004517          	auipc	a0,0x4
ffffffffc020abee:	14e50513          	addi	a0,a0,334 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020abf2:	fc26                	sd	s1,56(sp)
ffffffffc020abf4:	f84a                	sd	s2,48(sp)
ffffffffc020abf6:	f44e                	sd	s3,40(sp)
ffffffffc020abf8:	e45e                	sd	s7,8(sp)
ffffffffc020abfa:	e062                	sd	s8,0(sp)
ffffffffc020abfc:	84ff50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ac00 <sfs_truncfile>:
ffffffffc020ac00:	080007b7          	lui	a5,0x8000
ffffffffc020ac04:	1ab7eb63          	bltu	a5,a1,ffffffffc020adba <sfs_truncfile+0x1ba>
ffffffffc020ac08:	7159                	addi	sp,sp,-112
ffffffffc020ac0a:	e0d2                	sd	s4,64(sp)
ffffffffc020ac0c:	06853a03          	ld	s4,104(a0)
ffffffffc020ac10:	e8ca                	sd	s2,80(sp)
ffffffffc020ac12:	e4ce                	sd	s3,72(sp)
ffffffffc020ac14:	f486                	sd	ra,104(sp)
ffffffffc020ac16:	f0a2                	sd	s0,96(sp)
ffffffffc020ac18:	fc56                	sd	s5,56(sp)
ffffffffc020ac1a:	892a                	mv	s2,a0
ffffffffc020ac1c:	89ae                	mv	s3,a1
ffffffffc020ac1e:	1a0a0163          	beqz	s4,ffffffffc020adc0 <sfs_truncfile+0x1c0>
ffffffffc020ac22:	0b0a2783          	lw	a5,176(s4)
ffffffffc020ac26:	18079d63          	bnez	a5,ffffffffc020adc0 <sfs_truncfile+0x1c0>
ffffffffc020ac2a:	4d38                	lw	a4,88(a0)
ffffffffc020ac2c:	6785                	lui	a5,0x1
ffffffffc020ac2e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ac32:	6405                	lui	s0,0x1
ffffffffc020ac34:	1cf71963          	bne	a4,a5,ffffffffc020ae06 <sfs_truncfile+0x206>
ffffffffc020ac38:	00053a83          	ld	s5,0(a0)
ffffffffc020ac3c:	147d                	addi	s0,s0,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020ac3e:	942e                	add	s0,s0,a1
ffffffffc020ac40:	000ae783          	lwu	a5,0(s5)
ffffffffc020ac44:	8031                	srli	s0,s0,0xc
ffffffffc020ac46:	2401                	sext.w	s0,s0
ffffffffc020ac48:	02b79063          	bne	a5,a1,ffffffffc020ac68 <sfs_truncfile+0x68>
ffffffffc020ac4c:	008aa703          	lw	a4,8(s5)
ffffffffc020ac50:	4781                	li	a5,0
ffffffffc020ac52:	1c871c63          	bne	a4,s0,ffffffffc020ae2a <sfs_truncfile+0x22a>
ffffffffc020ac56:	70a6                	ld	ra,104(sp)
ffffffffc020ac58:	7406                	ld	s0,96(sp)
ffffffffc020ac5a:	6946                	ld	s2,80(sp)
ffffffffc020ac5c:	69a6                	ld	s3,72(sp)
ffffffffc020ac5e:	6a06                	ld	s4,64(sp)
ffffffffc020ac60:	7ae2                	ld	s5,56(sp)
ffffffffc020ac62:	853e                	mv	a0,a5
ffffffffc020ac64:	6165                	addi	sp,sp,112
ffffffffc020ac66:	8082                	ret
ffffffffc020ac68:	02050513          	addi	a0,a0,32
ffffffffc020ac6c:	eca6                	sd	s1,88(sp)
ffffffffc020ac6e:	a0df90ef          	jal	ffffffffc020467a <down>
ffffffffc020ac72:	008aa483          	lw	s1,8(s5)
ffffffffc020ac76:	0c84e363          	bltu	s1,s0,ffffffffc020ad3c <sfs_truncfile+0x13c>
ffffffffc020ac7a:	0c947e63          	bgeu	s0,s1,ffffffffc020ad56 <sfs_truncfile+0x156>
ffffffffc020ac7e:	48ad                	li	a7,11
ffffffffc020ac80:	4305                	li	t1,1
ffffffffc020ac82:	a895                	j	ffffffffc020acf6 <sfs_truncfile+0xf6>
ffffffffc020ac84:	37cd                	addiw	a5,a5,-13
ffffffffc020ac86:	3ff00693          	li	a3,1023
ffffffffc020ac8a:	04f6ef63          	bltu	a3,a5,ffffffffc020ace8 <sfs_truncfile+0xe8>
ffffffffc020ac8e:	03c82683          	lw	a3,60(a6)
ffffffffc020ac92:	cab9                	beqz	a3,ffffffffc020ace8 <sfs_truncfile+0xe8>
ffffffffc020ac94:	004a2603          	lw	a2,4(s4)
ffffffffc020ac98:	1ac6fb63          	bgeu	a3,a2,ffffffffc020ae4e <sfs_truncfile+0x24e>
ffffffffc020ac9c:	038a3503          	ld	a0,56(s4)
ffffffffc020aca0:	85b6                	mv	a1,a3
ffffffffc020aca2:	e436                	sd	a3,8(sp)
ffffffffc020aca4:	e842                	sd	a6,16(sp)
ffffffffc020aca6:	ec3e                	sd	a5,24(sp)
ffffffffc020aca8:	ba1fe0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020acac:	66a2                	ld	a3,8(sp)
ffffffffc020acae:	6842                	ld	a6,16(sp)
ffffffffc020acb0:	67e2                	ld	a5,24(sp)
ffffffffc020acb2:	1a051d63          	bnez	a0,ffffffffc020ae6c <sfs_truncfile+0x26c>
ffffffffc020acb6:	02079613          	slli	a2,a5,0x20
ffffffffc020acba:	01e65713          	srli	a4,a2,0x1e
ffffffffc020acbe:	102c                	addi	a1,sp,40
ffffffffc020acc0:	4611                	li	a2,4
ffffffffc020acc2:	8552                	mv	a0,s4
ffffffffc020acc4:	ec42                	sd	a6,24(sp)
ffffffffc020acc6:	e83a                	sd	a4,16(sp)
ffffffffc020acc8:	e436                	sd	a3,8(sp)
ffffffffc020acca:	d602                	sw	zero,44(sp)
ffffffffc020accc:	151000ef          	jal	ffffffffc020b61c <sfs_rbuf>
ffffffffc020acd0:	87aa                	mv	a5,a0
ffffffffc020acd2:	e941                	bnez	a0,ffffffffc020ad62 <sfs_truncfile+0x162>
ffffffffc020acd4:	57a2                	lw	a5,40(sp)
ffffffffc020acd6:	66a2                	ld	a3,8(sp)
ffffffffc020acd8:	6742                	ld	a4,16(sp)
ffffffffc020acda:	6862                	ld	a6,24(sp)
ffffffffc020acdc:	48ad                	li	a7,11
ffffffffc020acde:	4305                	li	t1,1
ffffffffc020ace0:	ebd5                	bnez	a5,ffffffffc020ad94 <sfs_truncfile+0x194>
ffffffffc020ace2:	00882703          	lw	a4,8(a6)
ffffffffc020ace6:	377d                	addiw	a4,a4,-1
ffffffffc020ace8:	00e82423          	sw	a4,8(a6)
ffffffffc020acec:	00693823          	sd	t1,16(s2)
ffffffffc020acf0:	34fd                	addiw	s1,s1,-1
ffffffffc020acf2:	04940e63          	beq	s0,s1,ffffffffc020ad4e <sfs_truncfile+0x14e>
ffffffffc020acf6:	00093803          	ld	a6,0(s2)
ffffffffc020acfa:	00882783          	lw	a5,8(a6)
ffffffffc020acfe:	0e078363          	beqz	a5,ffffffffc020ade4 <sfs_truncfile+0x1e4>
ffffffffc020ad02:	fff7871b          	addiw	a4,a5,-1
ffffffffc020ad06:	f6e8efe3          	bltu	a7,a4,ffffffffc020ac84 <sfs_truncfile+0x84>
ffffffffc020ad0a:	02071693          	slli	a3,a4,0x20
ffffffffc020ad0e:	01e6d793          	srli	a5,a3,0x1e
ffffffffc020ad12:	97c2                	add	a5,a5,a6
ffffffffc020ad14:	47cc                	lw	a1,12(a5)
ffffffffc020ad16:	d9e9                	beqz	a1,ffffffffc020ace8 <sfs_truncfile+0xe8>
ffffffffc020ad18:	8552                	mv	a0,s4
ffffffffc020ad1a:	e83e                	sd	a5,16(sp)
ffffffffc020ad1c:	e442                	sd	a6,8(sp)
ffffffffc020ad1e:	c5aff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020ad22:	67c2                	ld	a5,16(sp)
ffffffffc020ad24:	6822                	ld	a6,8(sp)
ffffffffc020ad26:	48ad                	li	a7,11
ffffffffc020ad28:	0007a623          	sw	zero,12(a5)
ffffffffc020ad2c:	00882703          	lw	a4,8(a6)
ffffffffc020ad30:	4305                	li	t1,1
ffffffffc020ad32:	377d                	addiw	a4,a4,-1
ffffffffc020ad34:	bf55                	j	ffffffffc020ace8 <sfs_truncfile+0xe8>
ffffffffc020ad36:	2485                	addiw	s1,s1,1
ffffffffc020ad38:	00940b63          	beq	s0,s1,ffffffffc020ad4e <sfs_truncfile+0x14e>
ffffffffc020ad3c:	4681                	li	a3,0
ffffffffc020ad3e:	8626                	mv	a2,s1
ffffffffc020ad40:	85ca                	mv	a1,s2
ffffffffc020ad42:	8552                	mv	a0,s4
ffffffffc020ad44:	ef0ff0ef          	jal	ffffffffc020a434 <sfs_bmap_load_nolock>
ffffffffc020ad48:	87aa                	mv	a5,a0
ffffffffc020ad4a:	d575                	beqz	a0,ffffffffc020ad36 <sfs_truncfile+0x136>
ffffffffc020ad4c:	a819                	j	ffffffffc020ad62 <sfs_truncfile+0x162>
ffffffffc020ad4e:	008aa783          	lw	a5,8(s5)
ffffffffc020ad52:	02879063          	bne	a5,s0,ffffffffc020ad72 <sfs_truncfile+0x172>
ffffffffc020ad56:	4785                	li	a5,1
ffffffffc020ad58:	013aa023          	sw	s3,0(s5)
ffffffffc020ad5c:	00f93823          	sd	a5,16(s2)
ffffffffc020ad60:	4781                	li	a5,0
ffffffffc020ad62:	02090513          	addi	a0,s2,32
ffffffffc020ad66:	e43e                	sd	a5,8(sp)
ffffffffc020ad68:	90ff90ef          	jal	ffffffffc0204676 <up>
ffffffffc020ad6c:	67a2                	ld	a5,8(sp)
ffffffffc020ad6e:	64e6                	ld	s1,88(sp)
ffffffffc020ad70:	b5dd                	j	ffffffffc020ac56 <sfs_truncfile+0x56>
ffffffffc020ad72:	00004697          	auipc	a3,0x4
ffffffffc020ad76:	20e68693          	addi	a3,a3,526 # ffffffffc020ef80 <etext+0x316c>
ffffffffc020ad7a:	00001617          	auipc	a2,0x1
ffffffffc020ad7e:	4d660613          	addi	a2,a2,1238 # ffffffffc020c250 <etext+0x43c>
ffffffffc020ad82:	3cc00593          	li	a1,972
ffffffffc020ad86:	00004517          	auipc	a0,0x4
ffffffffc020ad8a:	fb250513          	addi	a0,a0,-78 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ad8e:	f85a                	sd	s6,48(sp)
ffffffffc020ad90:	ebaf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad94:	4611                	li	a2,4
ffffffffc020ad96:	106c                	addi	a1,sp,44
ffffffffc020ad98:	8552                	mv	a0,s4
ffffffffc020ad9a:	e442                	sd	a6,8(sp)
ffffffffc020ad9c:	101000ef          	jal	ffffffffc020b69c <sfs_wbuf>
ffffffffc020ada0:	87aa                	mv	a5,a0
ffffffffc020ada2:	f161                	bnez	a0,ffffffffc020ad62 <sfs_truncfile+0x162>
ffffffffc020ada4:	55a2                	lw	a1,40(sp)
ffffffffc020ada6:	8552                	mv	a0,s4
ffffffffc020ada8:	bd0ff0ef          	jal	ffffffffc020a178 <sfs_block_free>
ffffffffc020adac:	6822                	ld	a6,8(sp)
ffffffffc020adae:	4305                	li	t1,1
ffffffffc020adb0:	48ad                	li	a7,11
ffffffffc020adb2:	00882703          	lw	a4,8(a6)
ffffffffc020adb6:	377d                	addiw	a4,a4,-1
ffffffffc020adb8:	bf05                	j	ffffffffc020ace8 <sfs_truncfile+0xe8>
ffffffffc020adba:	57f5                	li	a5,-3
ffffffffc020adbc:	853e                	mv	a0,a5
ffffffffc020adbe:	8082                	ret
ffffffffc020adc0:	00004697          	auipc	a3,0x4
ffffffffc020adc4:	d9868693          	addi	a3,a3,-616 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020adc8:	00001617          	auipc	a2,0x1
ffffffffc020adcc:	48860613          	addi	a2,a2,1160 # ffffffffc020c250 <etext+0x43c>
ffffffffc020add0:	3ab00593          	li	a1,939
ffffffffc020add4:	00004517          	auipc	a0,0x4
ffffffffc020add8:	f6450513          	addi	a0,a0,-156 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020addc:	eca6                	sd	s1,88(sp)
ffffffffc020adde:	f85a                	sd	s6,48(sp)
ffffffffc020ade0:	e6af50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ade4:	00004697          	auipc	a3,0x4
ffffffffc020ade8:	14c68693          	addi	a3,a3,332 # ffffffffc020ef30 <etext+0x311c>
ffffffffc020adec:	00001617          	auipc	a2,0x1
ffffffffc020adf0:	46460613          	addi	a2,a2,1124 # ffffffffc020c250 <etext+0x43c>
ffffffffc020adf4:	17b00593          	li	a1,379
ffffffffc020adf8:	00004517          	auipc	a0,0x4
ffffffffc020adfc:	f4050513          	addi	a0,a0,-192 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ae00:	f85a                	sd	s6,48(sp)
ffffffffc020ae02:	e48f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae06:	00004697          	auipc	a3,0x4
ffffffffc020ae0a:	efa68693          	addi	a3,a3,-262 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020ae0e:	00001617          	auipc	a2,0x1
ffffffffc020ae12:	44260613          	addi	a2,a2,1090 # ffffffffc020c250 <etext+0x43c>
ffffffffc020ae16:	3ac00593          	li	a1,940
ffffffffc020ae1a:	00004517          	auipc	a0,0x4
ffffffffc020ae1e:	f1e50513          	addi	a0,a0,-226 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ae22:	eca6                	sd	s1,88(sp)
ffffffffc020ae24:	f85a                	sd	s6,48(sp)
ffffffffc020ae26:	e24f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae2a:	00004697          	auipc	a3,0x4
ffffffffc020ae2e:	0ee68693          	addi	a3,a3,238 # ffffffffc020ef18 <etext+0x3104>
ffffffffc020ae32:	00001617          	auipc	a2,0x1
ffffffffc020ae36:	41e60613          	addi	a2,a2,1054 # ffffffffc020c250 <etext+0x43c>
ffffffffc020ae3a:	3b300593          	li	a1,947
ffffffffc020ae3e:	00004517          	auipc	a0,0x4
ffffffffc020ae42:	efa50513          	addi	a0,a0,-262 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ae46:	eca6                	sd	s1,88(sp)
ffffffffc020ae48:	f85a                	sd	s6,48(sp)
ffffffffc020ae4a:	e00f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae4e:	8736                	mv	a4,a3
ffffffffc020ae50:	05300593          	li	a1,83
ffffffffc020ae54:	86b2                	mv	a3,a2
ffffffffc020ae56:	00004517          	auipc	a0,0x4
ffffffffc020ae5a:	ee250513          	addi	a0,a0,-286 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ae5e:	00004617          	auipc	a2,0x4
ffffffffc020ae62:	f0a60613          	addi	a2,a2,-246 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020ae66:	f85a                	sd	s6,48(sp)
ffffffffc020ae68:	de2f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ae6c:	00004697          	auipc	a3,0x4
ffffffffc020ae70:	0dc68693          	addi	a3,a3,220 # ffffffffc020ef48 <etext+0x3134>
ffffffffc020ae74:	00001617          	auipc	a2,0x1
ffffffffc020ae78:	3dc60613          	addi	a2,a2,988 # ffffffffc020c250 <etext+0x43c>
ffffffffc020ae7c:	12b00593          	li	a1,299
ffffffffc020ae80:	00004517          	auipc	a0,0x4
ffffffffc020ae84:	eb850513          	addi	a0,a0,-328 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020ae88:	f85a                	sd	s6,48(sp)
ffffffffc020ae8a:	dc0f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ae8e <sfs_load_inode>:
ffffffffc020ae8e:	7139                	addi	sp,sp,-64
ffffffffc020ae90:	fc06                	sd	ra,56(sp)
ffffffffc020ae92:	f822                	sd	s0,48(sp)
ffffffffc020ae94:	f426                	sd	s1,40(sp)
ffffffffc020ae96:	f04a                	sd	s2,32(sp)
ffffffffc020ae98:	84b2                	mv	s1,a2
ffffffffc020ae9a:	892a                	mv	s2,a0
ffffffffc020ae9c:	ec4e                	sd	s3,24(sp)
ffffffffc020ae9e:	89ae                	mv	s3,a1
ffffffffc020aea0:	1b1000ef          	jal	ffffffffc020b850 <lock_sfs_fs>
ffffffffc020aea4:	8526                	mv	a0,s1
ffffffffc020aea6:	45a9                	li	a1,10
ffffffffc020aea8:	0a893403          	ld	s0,168(s2)
ffffffffc020aeac:	1c5000ef          	jal	ffffffffc020b870 <hash32>
ffffffffc020aeb0:	02051793          	slli	a5,a0,0x20
ffffffffc020aeb4:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020aeb8:	00a406b3          	add	a3,s0,a0
ffffffffc020aebc:	87b6                	mv	a5,a3
ffffffffc020aebe:	a029                	j	ffffffffc020aec8 <sfs_load_inode+0x3a>
ffffffffc020aec0:	fc07a703          	lw	a4,-64(a5)
ffffffffc020aec4:	10970563          	beq	a4,s1,ffffffffc020afce <sfs_load_inode+0x140>
ffffffffc020aec8:	679c                	ld	a5,8(a5)
ffffffffc020aeca:	fef69be3          	bne	a3,a5,ffffffffc020aec0 <sfs_load_inode+0x32>
ffffffffc020aece:	04000513          	li	a0,64
ffffffffc020aed2:	92af70ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020aed6:	87aa                	mv	a5,a0
ffffffffc020aed8:	10050b63          	beqz	a0,ffffffffc020afee <sfs_load_inode+0x160>
ffffffffc020aedc:	14048f63          	beqz	s1,ffffffffc020b03a <sfs_load_inode+0x1ac>
ffffffffc020aee0:	00492703          	lw	a4,4(s2)
ffffffffc020aee4:	14e4fb63          	bgeu	s1,a4,ffffffffc020b03a <sfs_load_inode+0x1ac>
ffffffffc020aee8:	03893503          	ld	a0,56(s2)
ffffffffc020aeec:	85a6                	mv	a1,s1
ffffffffc020aeee:	e43e                	sd	a5,8(sp)
ffffffffc020aef0:	959fe0ef          	jal	ffffffffc0209848 <bitmap_test>
ffffffffc020aef4:	16051263          	bnez	a0,ffffffffc020b058 <sfs_load_inode+0x1ca>
ffffffffc020aef8:	65a2                	ld	a1,8(sp)
ffffffffc020aefa:	4701                	li	a4,0
ffffffffc020aefc:	86a6                	mv	a3,s1
ffffffffc020aefe:	04000613          	li	a2,64
ffffffffc020af02:	854a                	mv	a0,s2
ffffffffc020af04:	718000ef          	jal	ffffffffc020b61c <sfs_rbuf>
ffffffffc020af08:	67a2                	ld	a5,8(sp)
ffffffffc020af0a:	842a                	mv	s0,a0
ffffffffc020af0c:	0e051e63          	bnez	a0,ffffffffc020b008 <sfs_load_inode+0x17a>
ffffffffc020af10:	0067d703          	lhu	a4,6(a5)
ffffffffc020af14:	10070363          	beqz	a4,ffffffffc020b01a <sfs_load_inode+0x18c>
ffffffffc020af18:	6505                	lui	a0,0x1
ffffffffc020af1a:	23550513          	addi	a0,a0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020af1e:	e43e                	sd	a5,8(sp)
ffffffffc020af20:	89efd0ef          	jal	ffffffffc0207fbe <__alloc_inode>
ffffffffc020af24:	67a2                	ld	a5,8(sp)
ffffffffc020af26:	842a                	mv	s0,a0
ffffffffc020af28:	cd79                	beqz	a0,ffffffffc020b006 <sfs_load_inode+0x178>
ffffffffc020af2a:	0047d683          	lhu	a3,4(a5)
ffffffffc020af2e:	4705                	li	a4,1
ffffffffc020af30:	0ee68063          	beq	a3,a4,ffffffffc020b010 <sfs_load_inode+0x182>
ffffffffc020af34:	4709                	li	a4,2
ffffffffc020af36:	00005597          	auipc	a1,0x5
ffffffffc020af3a:	dc258593          	addi	a1,a1,-574 # ffffffffc020fcf8 <sfs_node_dirops>
ffffffffc020af3e:	16e69d63          	bne	a3,a4,ffffffffc020b0b8 <sfs_load_inode+0x22a>
ffffffffc020af42:	864a                	mv	a2,s2
ffffffffc020af44:	8522                	mv	a0,s0
ffffffffc020af46:	e43e                	sd	a5,8(sp)
ffffffffc020af48:	892fd0ef          	jal	ffffffffc0207fda <inode_init>
ffffffffc020af4c:	4c34                	lw	a3,88(s0)
ffffffffc020af4e:	6705                	lui	a4,0x1
ffffffffc020af50:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020af54:	67a2                	ld	a5,8(sp)
ffffffffc020af56:	14e69163          	bne	a3,a4,ffffffffc020b098 <sfs_load_inode+0x20a>
ffffffffc020af5a:	4585                	li	a1,1
ffffffffc020af5c:	e01c                	sd	a5,0(s0)
ffffffffc020af5e:	c404                	sw	s1,8(s0)
ffffffffc020af60:	00043823          	sd	zero,16(s0)
ffffffffc020af64:	cc0c                	sw	a1,24(s0)
ffffffffc020af66:	02040513          	addi	a0,s0,32
ffffffffc020af6a:	e436                	sd	a3,8(sp)
ffffffffc020af6c:	f04f90ef          	jal	ffffffffc0204670 <sem_init>
ffffffffc020af70:	4c3c                	lw	a5,88(s0)
ffffffffc020af72:	66a2                	ld	a3,8(sp)
ffffffffc020af74:	10d79263          	bne	a5,a3,ffffffffc020b078 <sfs_load_inode+0x1ea>
ffffffffc020af78:	0a093703          	ld	a4,160(s2)
ffffffffc020af7c:	03840793          	addi	a5,s0,56
ffffffffc020af80:	4408                	lw	a0,8(s0)
ffffffffc020af82:	e31c                	sd	a5,0(a4)
ffffffffc020af84:	0af93023          	sd	a5,160(s2)
ffffffffc020af88:	09890793          	addi	a5,s2,152
ffffffffc020af8c:	e038                	sd	a4,64(s0)
ffffffffc020af8e:	fc1c                	sd	a5,56(s0)
ffffffffc020af90:	45a9                	li	a1,10
ffffffffc020af92:	0a893483          	ld	s1,168(s2)
ffffffffc020af96:	0db000ef          	jal	ffffffffc020b870 <hash32>
ffffffffc020af9a:	02051713          	slli	a4,a0,0x20
ffffffffc020af9e:	01c75793          	srli	a5,a4,0x1c
ffffffffc020afa2:	97a6                	add	a5,a5,s1
ffffffffc020afa4:	6798                	ld	a4,8(a5)
ffffffffc020afa6:	04840693          	addi	a3,s0,72
ffffffffc020afaa:	e314                	sd	a3,0(a4)
ffffffffc020afac:	e794                	sd	a3,8(a5)
ffffffffc020afae:	e838                	sd	a4,80(s0)
ffffffffc020afb0:	e43c                	sd	a5,72(s0)
ffffffffc020afb2:	854a                	mv	a0,s2
ffffffffc020afb4:	0ad000ef          	jal	ffffffffc020b860 <unlock_sfs_fs>
ffffffffc020afb8:	0089b023          	sd	s0,0(s3)
ffffffffc020afbc:	4401                	li	s0,0
ffffffffc020afbe:	70e2                	ld	ra,56(sp)
ffffffffc020afc0:	8522                	mv	a0,s0
ffffffffc020afc2:	7442                	ld	s0,48(sp)
ffffffffc020afc4:	74a2                	ld	s1,40(sp)
ffffffffc020afc6:	7902                	ld	s2,32(sp)
ffffffffc020afc8:	69e2                	ld	s3,24(sp)
ffffffffc020afca:	6121                	addi	sp,sp,64
ffffffffc020afcc:	8082                	ret
ffffffffc020afce:	fb878413          	addi	s0,a5,-72
ffffffffc020afd2:	8522                	mv	a0,s0
ffffffffc020afd4:	e43e                	sd	a5,8(sp)
ffffffffc020afd6:	866fd0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc020afda:	4705                	li	a4,1
ffffffffc020afdc:	67a2                	ld	a5,8(sp)
ffffffffc020afde:	fce51ae3          	bne	a0,a4,ffffffffc020afb2 <sfs_load_inode+0x124>
ffffffffc020afe2:	fd07a703          	lw	a4,-48(a5)
ffffffffc020afe6:	2705                	addiw	a4,a4,1
ffffffffc020afe8:	fce7a823          	sw	a4,-48(a5)
ffffffffc020afec:	b7d9                	j	ffffffffc020afb2 <sfs_load_inode+0x124>
ffffffffc020afee:	5471                	li	s0,-4
ffffffffc020aff0:	854a                	mv	a0,s2
ffffffffc020aff2:	06f000ef          	jal	ffffffffc020b860 <unlock_sfs_fs>
ffffffffc020aff6:	70e2                	ld	ra,56(sp)
ffffffffc020aff8:	8522                	mv	a0,s0
ffffffffc020affa:	7442                	ld	s0,48(sp)
ffffffffc020affc:	74a2                	ld	s1,40(sp)
ffffffffc020affe:	7902                	ld	s2,32(sp)
ffffffffc020b000:	69e2                	ld	s3,24(sp)
ffffffffc020b002:	6121                	addi	sp,sp,64
ffffffffc020b004:	8082                	ret
ffffffffc020b006:	5471                	li	s0,-4
ffffffffc020b008:	853e                	mv	a0,a5
ffffffffc020b00a:	898f70ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020b00e:	b7cd                	j	ffffffffc020aff0 <sfs_load_inode+0x162>
ffffffffc020b010:	00005597          	auipc	a1,0x5
ffffffffc020b014:	c6858593          	addi	a1,a1,-920 # ffffffffc020fc78 <sfs_node_fileops>
ffffffffc020b018:	b72d                	j	ffffffffc020af42 <sfs_load_inode+0xb4>
ffffffffc020b01a:	00004697          	auipc	a3,0x4
ffffffffc020b01e:	f7e68693          	addi	a3,a3,-130 # ffffffffc020ef98 <etext+0x3184>
ffffffffc020b022:	00001617          	auipc	a2,0x1
ffffffffc020b026:	22e60613          	addi	a2,a2,558 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b02a:	0ad00593          	li	a1,173
ffffffffc020b02e:	00004517          	auipc	a0,0x4
ffffffffc020b032:	d0a50513          	addi	a0,a0,-758 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b036:	c14f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b03a:	00492683          	lw	a3,4(s2)
ffffffffc020b03e:	8726                	mv	a4,s1
ffffffffc020b040:	00004617          	auipc	a2,0x4
ffffffffc020b044:	d2860613          	addi	a2,a2,-728 # ffffffffc020ed68 <etext+0x2f54>
ffffffffc020b048:	05300593          	li	a1,83
ffffffffc020b04c:	00004517          	auipc	a0,0x4
ffffffffc020b050:	cec50513          	addi	a0,a0,-788 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b054:	bf6f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b058:	00004697          	auipc	a3,0x4
ffffffffc020b05c:	d4868693          	addi	a3,a3,-696 # ffffffffc020eda0 <etext+0x2f8c>
ffffffffc020b060:	00001617          	auipc	a2,0x1
ffffffffc020b064:	1f060613          	addi	a2,a2,496 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b068:	0a800593          	li	a1,168
ffffffffc020b06c:	00004517          	auipc	a0,0x4
ffffffffc020b070:	ccc50513          	addi	a0,a0,-820 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b074:	bd6f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b078:	00004697          	auipc	a3,0x4
ffffffffc020b07c:	c8868693          	addi	a3,a3,-888 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020b080:	00001617          	auipc	a2,0x1
ffffffffc020b084:	1d060613          	addi	a2,a2,464 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b088:	0b100593          	li	a1,177
ffffffffc020b08c:	00004517          	auipc	a0,0x4
ffffffffc020b090:	cac50513          	addi	a0,a0,-852 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b094:	bb6f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b098:	00004697          	auipc	a3,0x4
ffffffffc020b09c:	c6868693          	addi	a3,a3,-920 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020b0a0:	00001617          	auipc	a2,0x1
ffffffffc020b0a4:	1b060613          	addi	a2,a2,432 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b0a8:	07700593          	li	a1,119
ffffffffc020b0ac:	00004517          	auipc	a0,0x4
ffffffffc020b0b0:	c8c50513          	addi	a0,a0,-884 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b0b4:	b96f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b0b8:	00004617          	auipc	a2,0x4
ffffffffc020b0bc:	c9860613          	addi	a2,a2,-872 # ffffffffc020ed50 <etext+0x2f3c>
ffffffffc020b0c0:	02e00593          	li	a1,46
ffffffffc020b0c4:	00004517          	auipc	a0,0x4
ffffffffc020b0c8:	c7450513          	addi	a0,a0,-908 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b0cc:	b7ef50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b0d0 <sfs_lookup_once.constprop.0>:
ffffffffc020b0d0:	711d                	addi	sp,sp,-96
ffffffffc020b0d2:	f852                	sd	s4,48(sp)
ffffffffc020b0d4:	8a2a                	mv	s4,a0
ffffffffc020b0d6:	02058513          	addi	a0,a1,32
ffffffffc020b0da:	ec86                	sd	ra,88(sp)
ffffffffc020b0dc:	e0ca                	sd	s2,64(sp)
ffffffffc020b0de:	f456                	sd	s5,40(sp)
ffffffffc020b0e0:	e862                	sd	s8,16(sp)
ffffffffc020b0e2:	8ab2                	mv	s5,a2
ffffffffc020b0e4:	892e                	mv	s2,a1
ffffffffc020b0e6:	8c36                	mv	s8,a3
ffffffffc020b0e8:	d92f90ef          	jal	ffffffffc020467a <down>
ffffffffc020b0ec:	8556                	mv	a0,s5
ffffffffc020b0ee:	40b000ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc020b0f2:	0ff00793          	li	a5,255
ffffffffc020b0f6:	0aa7e963          	bltu	a5,a0,ffffffffc020b1a8 <sfs_lookup_once.constprop.0+0xd8>
ffffffffc020b0fa:	10400513          	li	a0,260
ffffffffc020b0fe:	e4a6                	sd	s1,72(sp)
ffffffffc020b100:	efdf60ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020b104:	84aa                	mv	s1,a0
ffffffffc020b106:	c959                	beqz	a0,ffffffffc020b19c <sfs_lookup_once.constprop.0+0xcc>
ffffffffc020b108:	00093783          	ld	a5,0(s2)
ffffffffc020b10c:	fc4e                	sd	s3,56(sp)
ffffffffc020b10e:	0087a983          	lw	s3,8(a5)
ffffffffc020b112:	05305d63          	blez	s3,ffffffffc020b16c <sfs_lookup_once.constprop.0+0x9c>
ffffffffc020b116:	e8a2                	sd	s0,80(sp)
ffffffffc020b118:	4401                	li	s0,0
ffffffffc020b11a:	a821                	j	ffffffffc020b132 <sfs_lookup_once.constprop.0+0x62>
ffffffffc020b11c:	409c                	lw	a5,0(s1)
ffffffffc020b11e:	c799                	beqz	a5,ffffffffc020b12c <sfs_lookup_once.constprop.0+0x5c>
ffffffffc020b120:	00448593          	addi	a1,s1,4
ffffffffc020b124:	8556                	mv	a0,s5
ffffffffc020b126:	419000ef          	jal	ffffffffc020bd3e <strcmp>
ffffffffc020b12a:	c139                	beqz	a0,ffffffffc020b170 <sfs_lookup_once.constprop.0+0xa0>
ffffffffc020b12c:	2405                	addiw	s0,s0,1
ffffffffc020b12e:	02898e63          	beq	s3,s0,ffffffffc020b16a <sfs_lookup_once.constprop.0+0x9a>
ffffffffc020b132:	86a6                	mv	a3,s1
ffffffffc020b134:	8622                	mv	a2,s0
ffffffffc020b136:	85ca                	mv	a1,s2
ffffffffc020b138:	8552                	mv	a0,s4
ffffffffc020b13a:	8a7ff0ef          	jal	ffffffffc020a9e0 <sfs_dirent_read_nolock>
ffffffffc020b13e:	87aa                	mv	a5,a0
ffffffffc020b140:	dd71                	beqz	a0,ffffffffc020b11c <sfs_lookup_once.constprop.0+0x4c>
ffffffffc020b142:	6446                	ld	s0,80(sp)
ffffffffc020b144:	8526                	mv	a0,s1
ffffffffc020b146:	e43e                	sd	a5,8(sp)
ffffffffc020b148:	f5bf60ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020b14c:	02090513          	addi	a0,s2,32
ffffffffc020b150:	d26f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b154:	67a2                	ld	a5,8(sp)
ffffffffc020b156:	79e2                	ld	s3,56(sp)
ffffffffc020b158:	60e6                	ld	ra,88(sp)
ffffffffc020b15a:	64a6                	ld	s1,72(sp)
ffffffffc020b15c:	6906                	ld	s2,64(sp)
ffffffffc020b15e:	7a42                	ld	s4,48(sp)
ffffffffc020b160:	7aa2                	ld	s5,40(sp)
ffffffffc020b162:	6c42                	ld	s8,16(sp)
ffffffffc020b164:	853e                	mv	a0,a5
ffffffffc020b166:	6125                	addi	sp,sp,96
ffffffffc020b168:	8082                	ret
ffffffffc020b16a:	6446                	ld	s0,80(sp)
ffffffffc020b16c:	57c1                	li	a5,-16
ffffffffc020b16e:	bfd9                	j	ffffffffc020b144 <sfs_lookup_once.constprop.0+0x74>
ffffffffc020b170:	8526                	mv	a0,s1
ffffffffc020b172:	4080                	lw	s0,0(s1)
ffffffffc020b174:	f2ff60ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020b178:	02090513          	addi	a0,s2,32
ffffffffc020b17c:	cfaf90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b180:	8622                	mv	a2,s0
ffffffffc020b182:	6446                	ld	s0,80(sp)
ffffffffc020b184:	64a6                	ld	s1,72(sp)
ffffffffc020b186:	79e2                	ld	s3,56(sp)
ffffffffc020b188:	60e6                	ld	ra,88(sp)
ffffffffc020b18a:	6906                	ld	s2,64(sp)
ffffffffc020b18c:	7aa2                	ld	s5,40(sp)
ffffffffc020b18e:	85e2                	mv	a1,s8
ffffffffc020b190:	8552                	mv	a0,s4
ffffffffc020b192:	6c42                	ld	s8,16(sp)
ffffffffc020b194:	7a42                	ld	s4,48(sp)
ffffffffc020b196:	6125                	addi	sp,sp,96
ffffffffc020b198:	cf7ff06f          	j	ffffffffc020ae8e <sfs_load_inode>
ffffffffc020b19c:	02090513          	addi	a0,s2,32
ffffffffc020b1a0:	cd6f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b1a4:	57f1                	li	a5,-4
ffffffffc020b1a6:	bf4d                	j	ffffffffc020b158 <sfs_lookup_once.constprop.0+0x88>
ffffffffc020b1a8:	00004697          	auipc	a3,0x4
ffffffffc020b1ac:	e0868693          	addi	a3,a3,-504 # ffffffffc020efb0 <etext+0x319c>
ffffffffc020b1b0:	00001617          	auipc	a2,0x1
ffffffffc020b1b4:	0a060613          	addi	a2,a2,160 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b1b8:	1ba00593          	li	a1,442
ffffffffc020b1bc:	00004517          	auipc	a0,0x4
ffffffffc020b1c0:	b7c50513          	addi	a0,a0,-1156 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b1c4:	e8a2                	sd	s0,80(sp)
ffffffffc020b1c6:	e4a6                	sd	s1,72(sp)
ffffffffc020b1c8:	fc4e                	sd	s3,56(sp)
ffffffffc020b1ca:	f05a                	sd	s6,32(sp)
ffffffffc020b1cc:	ec5e                	sd	s7,24(sp)
ffffffffc020b1ce:	a7cf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b1d2 <sfs_namefile>:
ffffffffc020b1d2:	6d9c                	ld	a5,24(a1)
ffffffffc020b1d4:	7175                	addi	sp,sp,-144
ffffffffc020b1d6:	f86a                	sd	s10,48(sp)
ffffffffc020b1d8:	e506                	sd	ra,136(sp)
ffffffffc020b1da:	f46e                	sd	s11,40(sp)
ffffffffc020b1dc:	4d09                	li	s10,2
ffffffffc020b1de:	1afd7763          	bgeu	s10,a5,ffffffffc020b38c <sfs_namefile+0x1ba>
ffffffffc020b1e2:	f4ce                	sd	s3,104(sp)
ffffffffc020b1e4:	89aa                	mv	s3,a0
ffffffffc020b1e6:	10400513          	li	a0,260
ffffffffc020b1ea:	fca6                	sd	s1,120(sp)
ffffffffc020b1ec:	e42e                	sd	a1,8(sp)
ffffffffc020b1ee:	e0ff60ef          	jal	ffffffffc0201ffc <kmalloc>
ffffffffc020b1f2:	84aa                	mv	s1,a0
ffffffffc020b1f4:	18050a63          	beqz	a0,ffffffffc020b388 <sfs_namefile+0x1b6>
ffffffffc020b1f8:	f0d2                	sd	s4,96(sp)
ffffffffc020b1fa:	0689ba03          	ld	s4,104(s3)
ffffffffc020b1fe:	1e0a0c63          	beqz	s4,ffffffffc020b3f6 <sfs_namefile+0x224>
ffffffffc020b202:	0b0a2783          	lw	a5,176(s4)
ffffffffc020b206:	1e079863          	bnez	a5,ffffffffc020b3f6 <sfs_namefile+0x224>
ffffffffc020b20a:	0589a703          	lw	a4,88(s3)
ffffffffc020b20e:	6785                	lui	a5,0x1
ffffffffc020b210:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020b214:	e03a                	sd	a4,0(sp)
ffffffffc020b216:	e122                	sd	s0,128(sp)
ffffffffc020b218:	f8ca                	sd	s2,112(sp)
ffffffffc020b21a:	ecd6                	sd	s5,88(sp)
ffffffffc020b21c:	e8da                	sd	s6,80(sp)
ffffffffc020b21e:	e4de                	sd	s7,72(sp)
ffffffffc020b220:	e0e2                	sd	s8,64(sp)
ffffffffc020b222:	1af71963          	bne	a4,a5,ffffffffc020b3d4 <sfs_namefile+0x202>
ffffffffc020b226:	6722                	ld	a4,8(sp)
ffffffffc020b228:	854e                	mv	a0,s3
ffffffffc020b22a:	8b4e                	mv	s6,s3
ffffffffc020b22c:	6f1c                	ld	a5,24(a4)
ffffffffc020b22e:	00073a83          	ld	s5,0(a4)
ffffffffc020b232:	ffe78c13          	addi	s8,a5,-2
ffffffffc020b236:	9abe                	add	s5,s5,a5
ffffffffc020b238:	e05fc0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc020b23c:	0834                	addi	a3,sp,24
ffffffffc020b23e:	00004617          	auipc	a2,0x4
ffffffffc020b242:	d9a60613          	addi	a2,a2,-614 # ffffffffc020efd8 <etext+0x31c4>
ffffffffc020b246:	85da                	mv	a1,s6
ffffffffc020b248:	8552                	mv	a0,s4
ffffffffc020b24a:	e87ff0ef          	jal	ffffffffc020b0d0 <sfs_lookup_once.constprop.0>
ffffffffc020b24e:	8daa                	mv	s11,a0
ffffffffc020b250:	e94d                	bnez	a0,ffffffffc020b302 <sfs_namefile+0x130>
ffffffffc020b252:	854e                	mv	a0,s3
ffffffffc020b254:	008b2903          	lw	s2,8(s6)
ffffffffc020b258:	eb3fc0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020b25c:	6462                	ld	s0,24(sp)
ffffffffc020b25e:	0f340563          	beq	s0,s3,ffffffffc020b348 <sfs_namefile+0x176>
ffffffffc020b262:	14040863          	beqz	s0,ffffffffc020b3b2 <sfs_namefile+0x1e0>
ffffffffc020b266:	4c38                	lw	a4,88(s0)
ffffffffc020b268:	6782                	ld	a5,0(sp)
ffffffffc020b26a:	14f71463          	bne	a4,a5,ffffffffc020b3b2 <sfs_namefile+0x1e0>
ffffffffc020b26e:	4418                	lw	a4,8(s0)
ffffffffc020b270:	13270063          	beq	a4,s2,ffffffffc020b390 <sfs_namefile+0x1be>
ffffffffc020b274:	6018                	ld	a4,0(s0)
ffffffffc020b276:	00475703          	lhu	a4,4(a4)
ffffffffc020b27a:	11a71b63          	bne	a4,s10,ffffffffc020b390 <sfs_namefile+0x1be>
ffffffffc020b27e:	02040b93          	addi	s7,s0,32
ffffffffc020b282:	855e                	mv	a0,s7
ffffffffc020b284:	bf6f90ef          	jal	ffffffffc020467a <down>
ffffffffc020b288:	6018                	ld	a4,0(s0)
ffffffffc020b28a:	00872983          	lw	s3,8(a4)
ffffffffc020b28e:	0b305763          	blez	s3,ffffffffc020b33c <sfs_namefile+0x16a>
ffffffffc020b292:	8b22                	mv	s6,s0
ffffffffc020b294:	a039                	j	ffffffffc020b2a2 <sfs_namefile+0xd0>
ffffffffc020b296:	4098                	lw	a4,0(s1)
ffffffffc020b298:	01270e63          	beq	a4,s2,ffffffffc020b2b4 <sfs_namefile+0xe2>
ffffffffc020b29c:	2d85                	addiw	s11,s11,1
ffffffffc020b29e:	09b98763          	beq	s3,s11,ffffffffc020b32c <sfs_namefile+0x15a>
ffffffffc020b2a2:	86a6                	mv	a3,s1
ffffffffc020b2a4:	866e                	mv	a2,s11
ffffffffc020b2a6:	85a2                	mv	a1,s0
ffffffffc020b2a8:	8552                	mv	a0,s4
ffffffffc020b2aa:	f36ff0ef          	jal	ffffffffc020a9e0 <sfs_dirent_read_nolock>
ffffffffc020b2ae:	872a                	mv	a4,a0
ffffffffc020b2b0:	d17d                	beqz	a0,ffffffffc020b296 <sfs_namefile+0xc4>
ffffffffc020b2b2:	a8b5                	j	ffffffffc020b32e <sfs_namefile+0x15c>
ffffffffc020b2b4:	855e                	mv	a0,s7
ffffffffc020b2b6:	bc0f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b2ba:	00448513          	addi	a0,s1,4
ffffffffc020b2be:	23b000ef          	jal	ffffffffc020bcf8 <strlen>
ffffffffc020b2c2:	00150793          	addi	a5,a0,1
ffffffffc020b2c6:	0afc6e63          	bltu	s8,a5,ffffffffc020b382 <sfs_namefile+0x1b0>
ffffffffc020b2ca:	fff54913          	not	s2,a0
ffffffffc020b2ce:	862a                	mv	a2,a0
ffffffffc020b2d0:	00448593          	addi	a1,s1,4
ffffffffc020b2d4:	012a8533          	add	a0,s5,s2
ffffffffc020b2d8:	40fc0c33          	sub	s8,s8,a5
ffffffffc020b2dc:	321000ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc020b2e0:	02f00793          	li	a5,47
ffffffffc020b2e4:	fefa8fa3          	sb	a5,-1(s5)
ffffffffc020b2e8:	0834                	addi	a3,sp,24
ffffffffc020b2ea:	00004617          	auipc	a2,0x4
ffffffffc020b2ee:	cee60613          	addi	a2,a2,-786 # ffffffffc020efd8 <etext+0x31c4>
ffffffffc020b2f2:	85da                	mv	a1,s6
ffffffffc020b2f4:	8552                	mv	a0,s4
ffffffffc020b2f6:	ddbff0ef          	jal	ffffffffc020b0d0 <sfs_lookup_once.constprop.0>
ffffffffc020b2fa:	89a2                	mv	s3,s0
ffffffffc020b2fc:	9aca                	add	s5,s5,s2
ffffffffc020b2fe:	8daa                	mv	s11,a0
ffffffffc020b300:	d929                	beqz	a0,ffffffffc020b252 <sfs_namefile+0x80>
ffffffffc020b302:	854e                	mv	a0,s3
ffffffffc020b304:	e07fc0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020b308:	8526                	mv	a0,s1
ffffffffc020b30a:	d99f60ef          	jal	ffffffffc02020a2 <kfree>
ffffffffc020b30e:	640a                	ld	s0,128(sp)
ffffffffc020b310:	74e6                	ld	s1,120(sp)
ffffffffc020b312:	7946                	ld	s2,112(sp)
ffffffffc020b314:	79a6                	ld	s3,104(sp)
ffffffffc020b316:	7a06                	ld	s4,96(sp)
ffffffffc020b318:	6ae6                	ld	s5,88(sp)
ffffffffc020b31a:	6b46                	ld	s6,80(sp)
ffffffffc020b31c:	6ba6                	ld	s7,72(sp)
ffffffffc020b31e:	6c06                	ld	s8,64(sp)
ffffffffc020b320:	60aa                	ld	ra,136(sp)
ffffffffc020b322:	7d42                	ld	s10,48(sp)
ffffffffc020b324:	856e                	mv	a0,s11
ffffffffc020b326:	7da2                	ld	s11,40(sp)
ffffffffc020b328:	6149                	addi	sp,sp,144
ffffffffc020b32a:	8082                	ret
ffffffffc020b32c:	5741                	li	a4,-16
ffffffffc020b32e:	855e                	mv	a0,s7
ffffffffc020b330:	e03a                	sd	a4,0(sp)
ffffffffc020b332:	89a2                	mv	s3,s0
ffffffffc020b334:	b42f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b338:	6d82                	ld	s11,0(sp)
ffffffffc020b33a:	b7e1                	j	ffffffffc020b302 <sfs_namefile+0x130>
ffffffffc020b33c:	855e                	mv	a0,s7
ffffffffc020b33e:	b38f90ef          	jal	ffffffffc0204676 <up>
ffffffffc020b342:	89a2                	mv	s3,s0
ffffffffc020b344:	5dc1                	li	s11,-16
ffffffffc020b346:	bf75                	j	ffffffffc020b302 <sfs_namefile+0x130>
ffffffffc020b348:	854e                	mv	a0,s3
ffffffffc020b34a:	dc1fc0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020b34e:	6922                	ld	s2,8(sp)
ffffffffc020b350:	85d6                	mv	a1,s5
ffffffffc020b352:	01893403          	ld	s0,24(s2)
ffffffffc020b356:	00093503          	ld	a0,0(s2)
ffffffffc020b35a:	1479                	addi	s0,s0,-2
ffffffffc020b35c:	41840433          	sub	s0,s0,s8
ffffffffc020b360:	8622                	mv	a2,s0
ffffffffc020b362:	0505                	addi	a0,a0,1
ffffffffc020b364:	25b000ef          	jal	ffffffffc020bdbe <memmove>
ffffffffc020b368:	02f00713          	li	a4,47
ffffffffc020b36c:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020b370:	00850733          	add	a4,a0,s0
ffffffffc020b374:	00070023          	sb	zero,0(a4)
ffffffffc020b378:	854a                	mv	a0,s2
ffffffffc020b37a:	85a2                	mv	a1,s0
ffffffffc020b37c:	a22fa0ef          	jal	ffffffffc020559e <iobuf_skip>
ffffffffc020b380:	b761                	j	ffffffffc020b308 <sfs_namefile+0x136>
ffffffffc020b382:	89a2                	mv	s3,s0
ffffffffc020b384:	5df1                	li	s11,-4
ffffffffc020b386:	bfb5                	j	ffffffffc020b302 <sfs_namefile+0x130>
ffffffffc020b388:	74e6                	ld	s1,120(sp)
ffffffffc020b38a:	79a6                	ld	s3,104(sp)
ffffffffc020b38c:	5df1                	li	s11,-4
ffffffffc020b38e:	bf49                	j	ffffffffc020b320 <sfs_namefile+0x14e>
ffffffffc020b390:	00004697          	auipc	a3,0x4
ffffffffc020b394:	c5068693          	addi	a3,a3,-944 # ffffffffc020efe0 <etext+0x31cc>
ffffffffc020b398:	00001617          	auipc	a2,0x1
ffffffffc020b39c:	eb860613          	addi	a2,a2,-328 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b3a0:	2fb00593          	li	a1,763
ffffffffc020b3a4:	00004517          	auipc	a0,0x4
ffffffffc020b3a8:	99450513          	addi	a0,a0,-1644 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b3ac:	fc66                	sd	s9,56(sp)
ffffffffc020b3ae:	89cf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b3b2:	00004697          	auipc	a3,0x4
ffffffffc020b3b6:	94e68693          	addi	a3,a3,-1714 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020b3ba:	00001617          	auipc	a2,0x1
ffffffffc020b3be:	e9660613          	addi	a2,a2,-362 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b3c2:	2fa00593          	li	a1,762
ffffffffc020b3c6:	00004517          	auipc	a0,0x4
ffffffffc020b3ca:	97250513          	addi	a0,a0,-1678 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b3ce:	fc66                	sd	s9,56(sp)
ffffffffc020b3d0:	87af50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b3d4:	00004697          	auipc	a3,0x4
ffffffffc020b3d8:	92c68693          	addi	a3,a3,-1748 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020b3dc:	00001617          	auipc	a2,0x1
ffffffffc020b3e0:	e7460613          	addi	a2,a2,-396 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b3e4:	2e700593          	li	a1,743
ffffffffc020b3e8:	00004517          	auipc	a0,0x4
ffffffffc020b3ec:	95050513          	addi	a0,a0,-1712 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b3f0:	fc66                	sd	s9,56(sp)
ffffffffc020b3f2:	858f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b3f6:	00003697          	auipc	a3,0x3
ffffffffc020b3fa:	76268693          	addi	a3,a3,1890 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020b3fe:	00001617          	auipc	a2,0x1
ffffffffc020b402:	e5260613          	addi	a2,a2,-430 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b406:	2e600593          	li	a1,742
ffffffffc020b40a:	00004517          	auipc	a0,0x4
ffffffffc020b40e:	92e50513          	addi	a0,a0,-1746 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b412:	e122                	sd	s0,128(sp)
ffffffffc020b414:	f8ca                	sd	s2,112(sp)
ffffffffc020b416:	ecd6                	sd	s5,88(sp)
ffffffffc020b418:	e8da                	sd	s6,80(sp)
ffffffffc020b41a:	e4de                	sd	s7,72(sp)
ffffffffc020b41c:	e0e2                	sd	s8,64(sp)
ffffffffc020b41e:	fc66                	sd	s9,56(sp)
ffffffffc020b420:	82af50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b424 <sfs_lookup>:
ffffffffc020b424:	7139                	addi	sp,sp,-64
ffffffffc020b426:	f426                	sd	s1,40(sp)
ffffffffc020b428:	7524                	ld	s1,104(a0)
ffffffffc020b42a:	fc06                	sd	ra,56(sp)
ffffffffc020b42c:	f822                	sd	s0,48(sp)
ffffffffc020b42e:	f04a                	sd	s2,32(sp)
ffffffffc020b430:	c4b5                	beqz	s1,ffffffffc020b49c <sfs_lookup+0x78>
ffffffffc020b432:	0b04a783          	lw	a5,176(s1)
ffffffffc020b436:	e3bd                	bnez	a5,ffffffffc020b49c <sfs_lookup+0x78>
ffffffffc020b438:	0005c783          	lbu	a5,0(a1)
ffffffffc020b43c:	c3c5                	beqz	a5,ffffffffc020b4dc <sfs_lookup+0xb8>
ffffffffc020b43e:	fd178793          	addi	a5,a5,-47
ffffffffc020b442:	cfc9                	beqz	a5,ffffffffc020b4dc <sfs_lookup+0xb8>
ffffffffc020b444:	842a                	mv	s0,a0
ffffffffc020b446:	8932                	mv	s2,a2
ffffffffc020b448:	e42e                	sd	a1,8(sp)
ffffffffc020b44a:	bf3fc0ef          	jal	ffffffffc020803c <inode_ref_inc>
ffffffffc020b44e:	4c38                	lw	a4,88(s0)
ffffffffc020b450:	6785                	lui	a5,0x1
ffffffffc020b452:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020b456:	06f71363          	bne	a4,a5,ffffffffc020b4bc <sfs_lookup+0x98>
ffffffffc020b45a:	6018                	ld	a4,0(s0)
ffffffffc020b45c:	4789                	li	a5,2
ffffffffc020b45e:	00475703          	lhu	a4,4(a4)
ffffffffc020b462:	02f71863          	bne	a4,a5,ffffffffc020b492 <sfs_lookup+0x6e>
ffffffffc020b466:	6622                	ld	a2,8(sp)
ffffffffc020b468:	85a2                	mv	a1,s0
ffffffffc020b46a:	8526                	mv	a0,s1
ffffffffc020b46c:	0834                	addi	a3,sp,24
ffffffffc020b46e:	c63ff0ef          	jal	ffffffffc020b0d0 <sfs_lookup_once.constprop.0>
ffffffffc020b472:	87aa                	mv	a5,a0
ffffffffc020b474:	8522                	mv	a0,s0
ffffffffc020b476:	843e                	mv	s0,a5
ffffffffc020b478:	c93fc0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020b47c:	e401                	bnez	s0,ffffffffc020b484 <sfs_lookup+0x60>
ffffffffc020b47e:	67e2                	ld	a5,24(sp)
ffffffffc020b480:	00f93023          	sd	a5,0(s2)
ffffffffc020b484:	70e2                	ld	ra,56(sp)
ffffffffc020b486:	8522                	mv	a0,s0
ffffffffc020b488:	7442                	ld	s0,48(sp)
ffffffffc020b48a:	74a2                	ld	s1,40(sp)
ffffffffc020b48c:	7902                	ld	s2,32(sp)
ffffffffc020b48e:	6121                	addi	sp,sp,64
ffffffffc020b490:	8082                	ret
ffffffffc020b492:	8522                	mv	a0,s0
ffffffffc020b494:	c77fc0ef          	jal	ffffffffc020810a <inode_ref_dec>
ffffffffc020b498:	5439                	li	s0,-18
ffffffffc020b49a:	b7ed                	j	ffffffffc020b484 <sfs_lookup+0x60>
ffffffffc020b49c:	00003697          	auipc	a3,0x3
ffffffffc020b4a0:	6bc68693          	addi	a3,a3,1724 # ffffffffc020eb58 <etext+0x2d44>
ffffffffc020b4a4:	00001617          	auipc	a2,0x1
ffffffffc020b4a8:	dac60613          	addi	a2,a2,-596 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b4ac:	3dc00593          	li	a1,988
ffffffffc020b4b0:	00004517          	auipc	a0,0x4
ffffffffc020b4b4:	88850513          	addi	a0,a0,-1912 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b4b8:	f93f40ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b4bc:	00004697          	auipc	a3,0x4
ffffffffc020b4c0:	84468693          	addi	a3,a3,-1980 # ffffffffc020ed00 <etext+0x2eec>
ffffffffc020b4c4:	00001617          	auipc	a2,0x1
ffffffffc020b4c8:	d8c60613          	addi	a2,a2,-628 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b4cc:	3df00593          	li	a1,991
ffffffffc020b4d0:	00004517          	auipc	a0,0x4
ffffffffc020b4d4:	86850513          	addi	a0,a0,-1944 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b4d8:	f73f40ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b4dc:	00004697          	auipc	a3,0x4
ffffffffc020b4e0:	b3c68693          	addi	a3,a3,-1220 # ffffffffc020f018 <etext+0x3204>
ffffffffc020b4e4:	00001617          	auipc	a2,0x1
ffffffffc020b4e8:	d6c60613          	addi	a2,a2,-660 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b4ec:	3dd00593          	li	a1,989
ffffffffc020b4f0:	00004517          	auipc	a0,0x4
ffffffffc020b4f4:	84850513          	addi	a0,a0,-1976 # ffffffffc020ed38 <etext+0x2f24>
ffffffffc020b4f8:	f53f40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b4fc <sfs_rwblock_nolock>:
ffffffffc020b4fc:	7139                	addi	sp,sp,-64
ffffffffc020b4fe:	f822                	sd	s0,48(sp)
ffffffffc020b500:	f426                	sd	s1,40(sp)
ffffffffc020b502:	fc06                	sd	ra,56(sp)
ffffffffc020b504:	842a                	mv	s0,a0
ffffffffc020b506:	84b6                	mv	s1,a3
ffffffffc020b508:	e219                	bnez	a2,ffffffffc020b50e <sfs_rwblock_nolock+0x12>
ffffffffc020b50a:	8b05                	andi	a4,a4,1
ffffffffc020b50c:	e71d                	bnez	a4,ffffffffc020b53a <sfs_rwblock_nolock+0x3e>
ffffffffc020b50e:	405c                	lw	a5,4(s0)
ffffffffc020b510:	02f67563          	bgeu	a2,a5,ffffffffc020b53a <sfs_rwblock_nolock+0x3e>
ffffffffc020b514:	00c6161b          	slliw	a2,a2,0xc
ffffffffc020b518:	02061693          	slli	a3,a2,0x20
ffffffffc020b51c:	9281                	srli	a3,a3,0x20
ffffffffc020b51e:	6605                	lui	a2,0x1
ffffffffc020b520:	850a                	mv	a0,sp
ffffffffc020b522:	feff90ef          	jal	ffffffffc0205510 <iobuf_init>
ffffffffc020b526:	85aa                	mv	a1,a0
ffffffffc020b528:	7808                	ld	a0,48(s0)
ffffffffc020b52a:	8626                	mv	a2,s1
ffffffffc020b52c:	7118                	ld	a4,32(a0)
ffffffffc020b52e:	9702                	jalr	a4
ffffffffc020b530:	70e2                	ld	ra,56(sp)
ffffffffc020b532:	7442                	ld	s0,48(sp)
ffffffffc020b534:	74a2                	ld	s1,40(sp)
ffffffffc020b536:	6121                	addi	sp,sp,64
ffffffffc020b538:	8082                	ret
ffffffffc020b53a:	00004697          	auipc	a3,0x4
ffffffffc020b53e:	afe68693          	addi	a3,a3,-1282 # ffffffffc020f038 <etext+0x3224>
ffffffffc020b542:	00001617          	auipc	a2,0x1
ffffffffc020b546:	d0e60613          	addi	a2,a2,-754 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b54a:	45d5                	li	a1,21
ffffffffc020b54c:	00004517          	auipc	a0,0x4
ffffffffc020b550:	b2450513          	addi	a0,a0,-1244 # ffffffffc020f070 <etext+0x325c>
ffffffffc020b554:	ef7f40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b558 <sfs_rblock>:
ffffffffc020b558:	7139                	addi	sp,sp,-64
ffffffffc020b55a:	ec4e                	sd	s3,24(sp)
ffffffffc020b55c:	89b6                	mv	s3,a3
ffffffffc020b55e:	f822                	sd	s0,48(sp)
ffffffffc020b560:	f04a                	sd	s2,32(sp)
ffffffffc020b562:	e852                	sd	s4,16(sp)
ffffffffc020b564:	fc06                	sd	ra,56(sp)
ffffffffc020b566:	f426                	sd	s1,40(sp)
ffffffffc020b568:	892e                	mv	s2,a1
ffffffffc020b56a:	8432                	mv	s0,a2
ffffffffc020b56c:	8a2a                	mv	s4,a0
ffffffffc020b56e:	2ea000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b572:	02098763          	beqz	s3,ffffffffc020b5a0 <sfs_rblock+0x48>
ffffffffc020b576:	e456                	sd	s5,8(sp)
ffffffffc020b578:	013409bb          	addw	s3,s0,s3
ffffffffc020b57c:	6a85                	lui	s5,0x1
ffffffffc020b57e:	a021                	j	ffffffffc020b586 <sfs_rblock+0x2e>
ffffffffc020b580:	9956                	add	s2,s2,s5
ffffffffc020b582:	01340e63          	beq	s0,s3,ffffffffc020b59e <sfs_rblock+0x46>
ffffffffc020b586:	8622                	mv	a2,s0
ffffffffc020b588:	4705                	li	a4,1
ffffffffc020b58a:	4681                	li	a3,0
ffffffffc020b58c:	85ca                	mv	a1,s2
ffffffffc020b58e:	8552                	mv	a0,s4
ffffffffc020b590:	f6dff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b594:	84aa                	mv	s1,a0
ffffffffc020b596:	2405                	addiw	s0,s0,1
ffffffffc020b598:	d565                	beqz	a0,ffffffffc020b580 <sfs_rblock+0x28>
ffffffffc020b59a:	6aa2                	ld	s5,8(sp)
ffffffffc020b59c:	a019                	j	ffffffffc020b5a2 <sfs_rblock+0x4a>
ffffffffc020b59e:	6aa2                	ld	s5,8(sp)
ffffffffc020b5a0:	4481                	li	s1,0
ffffffffc020b5a2:	8552                	mv	a0,s4
ffffffffc020b5a4:	2c4000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b5a8:	70e2                	ld	ra,56(sp)
ffffffffc020b5aa:	7442                	ld	s0,48(sp)
ffffffffc020b5ac:	7902                	ld	s2,32(sp)
ffffffffc020b5ae:	69e2                	ld	s3,24(sp)
ffffffffc020b5b0:	6a42                	ld	s4,16(sp)
ffffffffc020b5b2:	8526                	mv	a0,s1
ffffffffc020b5b4:	74a2                	ld	s1,40(sp)
ffffffffc020b5b6:	6121                	addi	sp,sp,64
ffffffffc020b5b8:	8082                	ret

ffffffffc020b5ba <sfs_wblock>:
ffffffffc020b5ba:	7139                	addi	sp,sp,-64
ffffffffc020b5bc:	ec4e                	sd	s3,24(sp)
ffffffffc020b5be:	89b6                	mv	s3,a3
ffffffffc020b5c0:	f822                	sd	s0,48(sp)
ffffffffc020b5c2:	f04a                	sd	s2,32(sp)
ffffffffc020b5c4:	e852                	sd	s4,16(sp)
ffffffffc020b5c6:	fc06                	sd	ra,56(sp)
ffffffffc020b5c8:	f426                	sd	s1,40(sp)
ffffffffc020b5ca:	892e                	mv	s2,a1
ffffffffc020b5cc:	8432                	mv	s0,a2
ffffffffc020b5ce:	8a2a                	mv	s4,a0
ffffffffc020b5d0:	288000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b5d4:	02098763          	beqz	s3,ffffffffc020b602 <sfs_wblock+0x48>
ffffffffc020b5d8:	e456                	sd	s5,8(sp)
ffffffffc020b5da:	013409bb          	addw	s3,s0,s3
ffffffffc020b5de:	6a85                	lui	s5,0x1
ffffffffc020b5e0:	a021                	j	ffffffffc020b5e8 <sfs_wblock+0x2e>
ffffffffc020b5e2:	9956                	add	s2,s2,s5
ffffffffc020b5e4:	01340e63          	beq	s0,s3,ffffffffc020b600 <sfs_wblock+0x46>
ffffffffc020b5e8:	4705                	li	a4,1
ffffffffc020b5ea:	8622                	mv	a2,s0
ffffffffc020b5ec:	86ba                	mv	a3,a4
ffffffffc020b5ee:	85ca                	mv	a1,s2
ffffffffc020b5f0:	8552                	mv	a0,s4
ffffffffc020b5f2:	f0bff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b5f6:	84aa                	mv	s1,a0
ffffffffc020b5f8:	2405                	addiw	s0,s0,1
ffffffffc020b5fa:	d565                	beqz	a0,ffffffffc020b5e2 <sfs_wblock+0x28>
ffffffffc020b5fc:	6aa2                	ld	s5,8(sp)
ffffffffc020b5fe:	a019                	j	ffffffffc020b604 <sfs_wblock+0x4a>
ffffffffc020b600:	6aa2                	ld	s5,8(sp)
ffffffffc020b602:	4481                	li	s1,0
ffffffffc020b604:	8552                	mv	a0,s4
ffffffffc020b606:	262000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b60a:	70e2                	ld	ra,56(sp)
ffffffffc020b60c:	7442                	ld	s0,48(sp)
ffffffffc020b60e:	7902                	ld	s2,32(sp)
ffffffffc020b610:	69e2                	ld	s3,24(sp)
ffffffffc020b612:	6a42                	ld	s4,16(sp)
ffffffffc020b614:	8526                	mv	a0,s1
ffffffffc020b616:	74a2                	ld	s1,40(sp)
ffffffffc020b618:	6121                	addi	sp,sp,64
ffffffffc020b61a:	8082                	ret

ffffffffc020b61c <sfs_rbuf>:
ffffffffc020b61c:	7179                	addi	sp,sp,-48
ffffffffc020b61e:	f406                	sd	ra,40(sp)
ffffffffc020b620:	f022                	sd	s0,32(sp)
ffffffffc020b622:	ec26                	sd	s1,24(sp)
ffffffffc020b624:	e84a                	sd	s2,16(sp)
ffffffffc020b626:	e44e                	sd	s3,8(sp)
ffffffffc020b628:	e052                	sd	s4,0(sp)
ffffffffc020b62a:	6785                	lui	a5,0x1
ffffffffc020b62c:	04f77863          	bgeu	a4,a5,ffffffffc020b67c <sfs_rbuf+0x60>
ffffffffc020b630:	84ba                	mv	s1,a4
ffffffffc020b632:	9732                	add	a4,a4,a2
ffffffffc020b634:	04e7e463          	bltu	a5,a4,ffffffffc020b67c <sfs_rbuf+0x60>
ffffffffc020b638:	8936                	mv	s2,a3
ffffffffc020b63a:	842a                	mv	s0,a0
ffffffffc020b63c:	89ae                	mv	s3,a1
ffffffffc020b63e:	8a32                	mv	s4,a2
ffffffffc020b640:	218000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b644:	642c                	ld	a1,72(s0)
ffffffffc020b646:	864a                	mv	a2,s2
ffffffffc020b648:	8522                	mv	a0,s0
ffffffffc020b64a:	4705                	li	a4,1
ffffffffc020b64c:	4681                	li	a3,0
ffffffffc020b64e:	eafff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b652:	892a                	mv	s2,a0
ffffffffc020b654:	cd09                	beqz	a0,ffffffffc020b66e <sfs_rbuf+0x52>
ffffffffc020b656:	8522                	mv	a0,s0
ffffffffc020b658:	210000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b65c:	70a2                	ld	ra,40(sp)
ffffffffc020b65e:	7402                	ld	s0,32(sp)
ffffffffc020b660:	64e2                	ld	s1,24(sp)
ffffffffc020b662:	69a2                	ld	s3,8(sp)
ffffffffc020b664:	6a02                	ld	s4,0(sp)
ffffffffc020b666:	854a                	mv	a0,s2
ffffffffc020b668:	6942                	ld	s2,16(sp)
ffffffffc020b66a:	6145                	addi	sp,sp,48
ffffffffc020b66c:	8082                	ret
ffffffffc020b66e:	642c                	ld	a1,72(s0)
ffffffffc020b670:	8652                	mv	a2,s4
ffffffffc020b672:	854e                	mv	a0,s3
ffffffffc020b674:	95a6                	add	a1,a1,s1
ffffffffc020b676:	786000ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc020b67a:	bff1                	j	ffffffffc020b656 <sfs_rbuf+0x3a>
ffffffffc020b67c:	00004697          	auipc	a3,0x4
ffffffffc020b680:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020f088 <etext+0x3274>
ffffffffc020b684:	00001617          	auipc	a2,0x1
ffffffffc020b688:	bcc60613          	addi	a2,a2,-1076 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b68c:	05500593          	li	a1,85
ffffffffc020b690:	00004517          	auipc	a0,0x4
ffffffffc020b694:	9e050513          	addi	a0,a0,-1568 # ffffffffc020f070 <etext+0x325c>
ffffffffc020b698:	db3f40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b69c <sfs_wbuf>:
ffffffffc020b69c:	7139                	addi	sp,sp,-64
ffffffffc020b69e:	fc06                	sd	ra,56(sp)
ffffffffc020b6a0:	f822                	sd	s0,48(sp)
ffffffffc020b6a2:	f426                	sd	s1,40(sp)
ffffffffc020b6a4:	f04a                	sd	s2,32(sp)
ffffffffc020b6a6:	ec4e                	sd	s3,24(sp)
ffffffffc020b6a8:	e852                	sd	s4,16(sp)
ffffffffc020b6aa:	e456                	sd	s5,8(sp)
ffffffffc020b6ac:	6785                	lui	a5,0x1
ffffffffc020b6ae:	06f77163          	bgeu	a4,a5,ffffffffc020b710 <sfs_wbuf+0x74>
ffffffffc020b6b2:	893a                	mv	s2,a4
ffffffffc020b6b4:	9732                	add	a4,a4,a2
ffffffffc020b6b6:	04e7ed63          	bltu	a5,a4,ffffffffc020b710 <sfs_wbuf+0x74>
ffffffffc020b6ba:	89b6                	mv	s3,a3
ffffffffc020b6bc:	84aa                	mv	s1,a0
ffffffffc020b6be:	8a2e                	mv	s4,a1
ffffffffc020b6c0:	8ab2                	mv	s5,a2
ffffffffc020b6c2:	196000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b6c6:	64ac                	ld	a1,72(s1)
ffffffffc020b6c8:	864e                	mv	a2,s3
ffffffffc020b6ca:	8526                	mv	a0,s1
ffffffffc020b6cc:	4705                	li	a4,1
ffffffffc020b6ce:	4681                	li	a3,0
ffffffffc020b6d0:	e2dff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b6d4:	842a                	mv	s0,a0
ffffffffc020b6d6:	cd11                	beqz	a0,ffffffffc020b6f2 <sfs_wbuf+0x56>
ffffffffc020b6d8:	8526                	mv	a0,s1
ffffffffc020b6da:	18e000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b6de:	70e2                	ld	ra,56(sp)
ffffffffc020b6e0:	8522                	mv	a0,s0
ffffffffc020b6e2:	7442                	ld	s0,48(sp)
ffffffffc020b6e4:	74a2                	ld	s1,40(sp)
ffffffffc020b6e6:	7902                	ld	s2,32(sp)
ffffffffc020b6e8:	69e2                	ld	s3,24(sp)
ffffffffc020b6ea:	6a42                	ld	s4,16(sp)
ffffffffc020b6ec:	6aa2                	ld	s5,8(sp)
ffffffffc020b6ee:	6121                	addi	sp,sp,64
ffffffffc020b6f0:	8082                	ret
ffffffffc020b6f2:	64a8                	ld	a0,72(s1)
ffffffffc020b6f4:	8656                	mv	a2,s5
ffffffffc020b6f6:	85d2                	mv	a1,s4
ffffffffc020b6f8:	954a                	add	a0,a0,s2
ffffffffc020b6fa:	702000ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc020b6fe:	64ac                	ld	a1,72(s1)
ffffffffc020b700:	4705                	li	a4,1
ffffffffc020b702:	864e                	mv	a2,s3
ffffffffc020b704:	8526                	mv	a0,s1
ffffffffc020b706:	86ba                	mv	a3,a4
ffffffffc020b708:	df5ff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b70c:	842a                	mv	s0,a0
ffffffffc020b70e:	b7e9                	j	ffffffffc020b6d8 <sfs_wbuf+0x3c>
ffffffffc020b710:	00004697          	auipc	a3,0x4
ffffffffc020b714:	97868693          	addi	a3,a3,-1672 # ffffffffc020f088 <etext+0x3274>
ffffffffc020b718:	00001617          	auipc	a2,0x1
ffffffffc020b71c:	b3860613          	addi	a2,a2,-1224 # ffffffffc020c250 <etext+0x43c>
ffffffffc020b720:	06b00593          	li	a1,107
ffffffffc020b724:	00004517          	auipc	a0,0x4
ffffffffc020b728:	94c50513          	addi	a0,a0,-1716 # ffffffffc020f070 <etext+0x325c>
ffffffffc020b72c:	d1ff40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b730 <sfs_sync_super>:
ffffffffc020b730:	1101                	addi	sp,sp,-32
ffffffffc020b732:	ec06                	sd	ra,24(sp)
ffffffffc020b734:	e822                	sd	s0,16(sp)
ffffffffc020b736:	e426                	sd	s1,8(sp)
ffffffffc020b738:	842a                	mv	s0,a0
ffffffffc020b73a:	11e000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b73e:	6428                	ld	a0,72(s0)
ffffffffc020b740:	6605                	lui	a2,0x1
ffffffffc020b742:	4581                	li	a1,0
ffffffffc020b744:	668000ef          	jal	ffffffffc020bdac <memset>
ffffffffc020b748:	6428                	ld	a0,72(s0)
ffffffffc020b74a:	85a2                	mv	a1,s0
ffffffffc020b74c:	02c00613          	li	a2,44
ffffffffc020b750:	6ac000ef          	jal	ffffffffc020bdfc <memcpy>
ffffffffc020b754:	642c                	ld	a1,72(s0)
ffffffffc020b756:	8522                	mv	a0,s0
ffffffffc020b758:	4701                	li	a4,0
ffffffffc020b75a:	4685                	li	a3,1
ffffffffc020b75c:	4601                	li	a2,0
ffffffffc020b75e:	d9fff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b762:	84aa                	mv	s1,a0
ffffffffc020b764:	8522                	mv	a0,s0
ffffffffc020b766:	102000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b76a:	60e2                	ld	ra,24(sp)
ffffffffc020b76c:	6442                	ld	s0,16(sp)
ffffffffc020b76e:	8526                	mv	a0,s1
ffffffffc020b770:	64a2                	ld	s1,8(sp)
ffffffffc020b772:	6105                	addi	sp,sp,32
ffffffffc020b774:	8082                	ret

ffffffffc020b776 <sfs_sync_freemap>:
ffffffffc020b776:	7139                	addi	sp,sp,-64
ffffffffc020b778:	ec4e                	sd	s3,24(sp)
ffffffffc020b77a:	e852                	sd	s4,16(sp)
ffffffffc020b77c:	00456983          	lwu	s3,4(a0)
ffffffffc020b780:	8a2a                	mv	s4,a0
ffffffffc020b782:	7d08                	ld	a0,56(a0)
ffffffffc020b784:	67a1                	lui	a5,0x8
ffffffffc020b786:	17fd                	addi	a5,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020b788:	4581                	li	a1,0
ffffffffc020b78a:	f822                	sd	s0,48(sp)
ffffffffc020b78c:	fc06                	sd	ra,56(sp)
ffffffffc020b78e:	f426                	sd	s1,40(sp)
ffffffffc020b790:	99be                	add	s3,s3,a5
ffffffffc020b792:	948fe0ef          	jal	ffffffffc02098da <bitmap_getdata>
ffffffffc020b796:	00f9d993          	srli	s3,s3,0xf
ffffffffc020b79a:	842a                	mv	s0,a0
ffffffffc020b79c:	8552                	mv	a0,s4
ffffffffc020b79e:	0ba000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b7a2:	02098b63          	beqz	s3,ffffffffc020b7d8 <sfs_sync_freemap+0x62>
ffffffffc020b7a6:	09b2                	slli	s3,s3,0xc
ffffffffc020b7a8:	f04a                	sd	s2,32(sp)
ffffffffc020b7aa:	e456                	sd	s5,8(sp)
ffffffffc020b7ac:	99a2                	add	s3,s3,s0
ffffffffc020b7ae:	4909                	li	s2,2
ffffffffc020b7b0:	6a85                	lui	s5,0x1
ffffffffc020b7b2:	a021                	j	ffffffffc020b7ba <sfs_sync_freemap+0x44>
ffffffffc020b7b4:	2905                	addiw	s2,s2,1
ffffffffc020b7b6:	01340f63          	beq	s0,s3,ffffffffc020b7d4 <sfs_sync_freemap+0x5e>
ffffffffc020b7ba:	4705                	li	a4,1
ffffffffc020b7bc:	85a2                	mv	a1,s0
ffffffffc020b7be:	86ba                	mv	a3,a4
ffffffffc020b7c0:	864a                	mv	a2,s2
ffffffffc020b7c2:	8552                	mv	a0,s4
ffffffffc020b7c4:	d39ff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b7c8:	84aa                	mv	s1,a0
ffffffffc020b7ca:	9456                	add	s0,s0,s5
ffffffffc020b7cc:	d565                	beqz	a0,ffffffffc020b7b4 <sfs_sync_freemap+0x3e>
ffffffffc020b7ce:	7902                	ld	s2,32(sp)
ffffffffc020b7d0:	6aa2                	ld	s5,8(sp)
ffffffffc020b7d2:	a021                	j	ffffffffc020b7da <sfs_sync_freemap+0x64>
ffffffffc020b7d4:	7902                	ld	s2,32(sp)
ffffffffc020b7d6:	6aa2                	ld	s5,8(sp)
ffffffffc020b7d8:	4481                	li	s1,0
ffffffffc020b7da:	8552                	mv	a0,s4
ffffffffc020b7dc:	08c000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b7e0:	70e2                	ld	ra,56(sp)
ffffffffc020b7e2:	7442                	ld	s0,48(sp)
ffffffffc020b7e4:	69e2                	ld	s3,24(sp)
ffffffffc020b7e6:	6a42                	ld	s4,16(sp)
ffffffffc020b7e8:	8526                	mv	a0,s1
ffffffffc020b7ea:	74a2                	ld	s1,40(sp)
ffffffffc020b7ec:	6121                	addi	sp,sp,64
ffffffffc020b7ee:	8082                	ret

ffffffffc020b7f0 <sfs_clear_block>:
ffffffffc020b7f0:	7179                	addi	sp,sp,-48
ffffffffc020b7f2:	f022                	sd	s0,32(sp)
ffffffffc020b7f4:	e84a                	sd	s2,16(sp)
ffffffffc020b7f6:	e44e                	sd	s3,8(sp)
ffffffffc020b7f8:	f406                	sd	ra,40(sp)
ffffffffc020b7fa:	89b2                	mv	s3,a2
ffffffffc020b7fc:	ec26                	sd	s1,24(sp)
ffffffffc020b7fe:	842e                	mv	s0,a1
ffffffffc020b800:	892a                	mv	s2,a0
ffffffffc020b802:	056000ef          	jal	ffffffffc020b858 <lock_sfs_io>
ffffffffc020b806:	04893503          	ld	a0,72(s2)
ffffffffc020b80a:	6605                	lui	a2,0x1
ffffffffc020b80c:	4581                	li	a1,0
ffffffffc020b80e:	59e000ef          	jal	ffffffffc020bdac <memset>
ffffffffc020b812:	02098d63          	beqz	s3,ffffffffc020b84c <sfs_clear_block+0x5c>
ffffffffc020b816:	013409bb          	addw	s3,s0,s3
ffffffffc020b81a:	a019                	j	ffffffffc020b820 <sfs_clear_block+0x30>
ffffffffc020b81c:	03340863          	beq	s0,s3,ffffffffc020b84c <sfs_clear_block+0x5c>
ffffffffc020b820:	04893583          	ld	a1,72(s2)
ffffffffc020b824:	4705                	li	a4,1
ffffffffc020b826:	8622                	mv	a2,s0
ffffffffc020b828:	86ba                	mv	a3,a4
ffffffffc020b82a:	854a                	mv	a0,s2
ffffffffc020b82c:	cd1ff0ef          	jal	ffffffffc020b4fc <sfs_rwblock_nolock>
ffffffffc020b830:	84aa                	mv	s1,a0
ffffffffc020b832:	2405                	addiw	s0,s0,1
ffffffffc020b834:	d565                	beqz	a0,ffffffffc020b81c <sfs_clear_block+0x2c>
ffffffffc020b836:	854a                	mv	a0,s2
ffffffffc020b838:	030000ef          	jal	ffffffffc020b868 <unlock_sfs_io>
ffffffffc020b83c:	70a2                	ld	ra,40(sp)
ffffffffc020b83e:	7402                	ld	s0,32(sp)
ffffffffc020b840:	6942                	ld	s2,16(sp)
ffffffffc020b842:	69a2                	ld	s3,8(sp)
ffffffffc020b844:	8526                	mv	a0,s1
ffffffffc020b846:	64e2                	ld	s1,24(sp)
ffffffffc020b848:	6145                	addi	sp,sp,48
ffffffffc020b84a:	8082                	ret
ffffffffc020b84c:	4481                	li	s1,0
ffffffffc020b84e:	b7e5                	j	ffffffffc020b836 <sfs_clear_block+0x46>

ffffffffc020b850 <lock_sfs_fs>:
ffffffffc020b850:	05050513          	addi	a0,a0,80
ffffffffc020b854:	e27f806f          	j	ffffffffc020467a <down>

ffffffffc020b858 <lock_sfs_io>:
ffffffffc020b858:	06850513          	addi	a0,a0,104
ffffffffc020b85c:	e1ff806f          	j	ffffffffc020467a <down>

ffffffffc020b860 <unlock_sfs_fs>:
ffffffffc020b860:	05050513          	addi	a0,a0,80
ffffffffc020b864:	e13f806f          	j	ffffffffc0204676 <up>

ffffffffc020b868 <unlock_sfs_io>:
ffffffffc020b868:	06850513          	addi	a0,a0,104
ffffffffc020b86c:	e0bf806f          	j	ffffffffc0204676 <up>

ffffffffc020b870 <hash32>:
ffffffffc020b870:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b874:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_bin_sfs_img_size+0xffffffff9e2fad01>
ffffffffc020b876:	02a787bb          	mulw	a5,a5,a0
ffffffffc020b87a:	02000513          	li	a0,32
ffffffffc020b87e:	9d0d                	subw	a0,a0,a1
ffffffffc020b880:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020b884:	8082                	ret

ffffffffc020b886 <printnum>:
ffffffffc020b886:	7139                	addi	sp,sp,-64
ffffffffc020b888:	02071893          	slli	a7,a4,0x20
ffffffffc020b88c:	f822                	sd	s0,48(sp)
ffffffffc020b88e:	f426                	sd	s1,40(sp)
ffffffffc020b890:	f04a                	sd	s2,32(sp)
ffffffffc020b892:	ec4e                	sd	s3,24(sp)
ffffffffc020b894:	e456                	sd	s5,8(sp)
ffffffffc020b896:	0208d893          	srli	a7,a7,0x20
ffffffffc020b89a:	fc06                	sd	ra,56(sp)
ffffffffc020b89c:	0316fab3          	remu	s5,a3,a7
ffffffffc020b8a0:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b8a4:	84aa                	mv	s1,a0
ffffffffc020b8a6:	89ae                	mv	s3,a1
ffffffffc020b8a8:	8932                	mv	s2,a2
ffffffffc020b8aa:	0516f063          	bgeu	a3,a7,ffffffffc020b8ea <printnum+0x64>
ffffffffc020b8ae:	e852                	sd	s4,16(sp)
ffffffffc020b8b0:	4705                	li	a4,1
ffffffffc020b8b2:	8a42                	mv	s4,a6
ffffffffc020b8b4:	00f75863          	bge	a4,a5,ffffffffc020b8c4 <printnum+0x3e>
ffffffffc020b8b8:	864e                	mv	a2,s3
ffffffffc020b8ba:	85ca                	mv	a1,s2
ffffffffc020b8bc:	8552                	mv	a0,s4
ffffffffc020b8be:	347d                	addiw	s0,s0,-1
ffffffffc020b8c0:	9482                	jalr	s1
ffffffffc020b8c2:	f87d                	bnez	s0,ffffffffc020b8b8 <printnum+0x32>
ffffffffc020b8c4:	6a42                	ld	s4,16(sp)
ffffffffc020b8c6:	00004797          	auipc	a5,0x4
ffffffffc020b8ca:	80a78793          	addi	a5,a5,-2038 # ffffffffc020f0d0 <etext+0x32bc>
ffffffffc020b8ce:	97d6                	add	a5,a5,s5
ffffffffc020b8d0:	7442                	ld	s0,48(sp)
ffffffffc020b8d2:	0007c503          	lbu	a0,0(a5)
ffffffffc020b8d6:	70e2                	ld	ra,56(sp)
ffffffffc020b8d8:	6aa2                	ld	s5,8(sp)
ffffffffc020b8da:	864e                	mv	a2,s3
ffffffffc020b8dc:	85ca                	mv	a1,s2
ffffffffc020b8de:	69e2                	ld	s3,24(sp)
ffffffffc020b8e0:	7902                	ld	s2,32(sp)
ffffffffc020b8e2:	87a6                	mv	a5,s1
ffffffffc020b8e4:	74a2                	ld	s1,40(sp)
ffffffffc020b8e6:	6121                	addi	sp,sp,64
ffffffffc020b8e8:	8782                	jr	a5
ffffffffc020b8ea:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b8ee:	87a2                	mv	a5,s0
ffffffffc020b8f0:	f97ff0ef          	jal	ffffffffc020b886 <printnum>
ffffffffc020b8f4:	bfc9                	j	ffffffffc020b8c6 <printnum+0x40>

ffffffffc020b8f6 <sprintputch>:
ffffffffc020b8f6:	499c                	lw	a5,16(a1)
ffffffffc020b8f8:	6198                	ld	a4,0(a1)
ffffffffc020b8fa:	6594                	ld	a3,8(a1)
ffffffffc020b8fc:	2785                	addiw	a5,a5,1
ffffffffc020b8fe:	c99c                	sw	a5,16(a1)
ffffffffc020b900:	00d77763          	bgeu	a4,a3,ffffffffc020b90e <sprintputch+0x18>
ffffffffc020b904:	00170793          	addi	a5,a4,1
ffffffffc020b908:	e19c                	sd	a5,0(a1)
ffffffffc020b90a:	00a70023          	sb	a0,0(a4)
ffffffffc020b90e:	8082                	ret

ffffffffc020b910 <vprintfmt>:
ffffffffc020b910:	7119                	addi	sp,sp,-128
ffffffffc020b912:	f4a6                	sd	s1,104(sp)
ffffffffc020b914:	f0ca                	sd	s2,96(sp)
ffffffffc020b916:	ecce                	sd	s3,88(sp)
ffffffffc020b918:	e8d2                	sd	s4,80(sp)
ffffffffc020b91a:	e4d6                	sd	s5,72(sp)
ffffffffc020b91c:	e0da                	sd	s6,64(sp)
ffffffffc020b91e:	fc5e                	sd	s7,56(sp)
ffffffffc020b920:	f466                	sd	s9,40(sp)
ffffffffc020b922:	fc86                	sd	ra,120(sp)
ffffffffc020b924:	f8a2                	sd	s0,112(sp)
ffffffffc020b926:	f862                	sd	s8,48(sp)
ffffffffc020b928:	f06a                	sd	s10,32(sp)
ffffffffc020b92a:	ec6e                	sd	s11,24(sp)
ffffffffc020b92c:	84aa                	mv	s1,a0
ffffffffc020b92e:	8cb6                	mv	s9,a3
ffffffffc020b930:	8aba                	mv	s5,a4
ffffffffc020b932:	89ae                	mv	s3,a1
ffffffffc020b934:	8932                	mv	s2,a2
ffffffffc020b936:	02500a13          	li	s4,37
ffffffffc020b93a:	05500b93          	li	s7,85
ffffffffc020b93e:	00004b17          	auipc	s6,0x4
ffffffffc020b942:	43ab0b13          	addi	s6,s6,1082 # ffffffffc020fd78 <sfs_node_dirops+0x80>
ffffffffc020b946:	000cc503          	lbu	a0,0(s9)
ffffffffc020b94a:	001c8413          	addi	s0,s9,1
ffffffffc020b94e:	01450b63          	beq	a0,s4,ffffffffc020b964 <vprintfmt+0x54>
ffffffffc020b952:	cd15                	beqz	a0,ffffffffc020b98e <vprintfmt+0x7e>
ffffffffc020b954:	864e                	mv	a2,s3
ffffffffc020b956:	85ca                	mv	a1,s2
ffffffffc020b958:	9482                	jalr	s1
ffffffffc020b95a:	00044503          	lbu	a0,0(s0)
ffffffffc020b95e:	0405                	addi	s0,s0,1
ffffffffc020b960:	ff4519e3          	bne	a0,s4,ffffffffc020b952 <vprintfmt+0x42>
ffffffffc020b964:	5d7d                	li	s10,-1
ffffffffc020b966:	8dea                	mv	s11,s10
ffffffffc020b968:	02000813          	li	a6,32
ffffffffc020b96c:	4c01                	li	s8,0
ffffffffc020b96e:	4581                	li	a1,0
ffffffffc020b970:	00044703          	lbu	a4,0(s0)
ffffffffc020b974:	00140c93          	addi	s9,s0,1
ffffffffc020b978:	fdd7061b          	addiw	a2,a4,-35
ffffffffc020b97c:	0ff67613          	zext.b	a2,a2
ffffffffc020b980:	02cbe663          	bltu	s7,a2,ffffffffc020b9ac <vprintfmt+0x9c>
ffffffffc020b984:	060a                	slli	a2,a2,0x2
ffffffffc020b986:	965a                	add	a2,a2,s6
ffffffffc020b988:	421c                	lw	a5,0(a2)
ffffffffc020b98a:	97da                	add	a5,a5,s6
ffffffffc020b98c:	8782                	jr	a5
ffffffffc020b98e:	70e6                	ld	ra,120(sp)
ffffffffc020b990:	7446                	ld	s0,112(sp)
ffffffffc020b992:	74a6                	ld	s1,104(sp)
ffffffffc020b994:	7906                	ld	s2,96(sp)
ffffffffc020b996:	69e6                	ld	s3,88(sp)
ffffffffc020b998:	6a46                	ld	s4,80(sp)
ffffffffc020b99a:	6aa6                	ld	s5,72(sp)
ffffffffc020b99c:	6b06                	ld	s6,64(sp)
ffffffffc020b99e:	7be2                	ld	s7,56(sp)
ffffffffc020b9a0:	7c42                	ld	s8,48(sp)
ffffffffc020b9a2:	7ca2                	ld	s9,40(sp)
ffffffffc020b9a4:	7d02                	ld	s10,32(sp)
ffffffffc020b9a6:	6de2                	ld	s11,24(sp)
ffffffffc020b9a8:	6109                	addi	sp,sp,128
ffffffffc020b9aa:	8082                	ret
ffffffffc020b9ac:	864e                	mv	a2,s3
ffffffffc020b9ae:	85ca                	mv	a1,s2
ffffffffc020b9b0:	02500513          	li	a0,37
ffffffffc020b9b4:	9482                	jalr	s1
ffffffffc020b9b6:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b9ba:	02500713          	li	a4,37
ffffffffc020b9be:	8ca2                	mv	s9,s0
ffffffffc020b9c0:	f8e783e3          	beq	a5,a4,ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020b9c4:	ffecc783          	lbu	a5,-2(s9)
ffffffffc020b9c8:	1cfd                	addi	s9,s9,-1
ffffffffc020b9ca:	fee79de3          	bne	a5,a4,ffffffffc020b9c4 <vprintfmt+0xb4>
ffffffffc020b9ce:	bfa5                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020b9d0:	00144683          	lbu	a3,1(s0)
ffffffffc020b9d4:	4525                	li	a0,9
ffffffffc020b9d6:	fd070d1b          	addiw	s10,a4,-48
ffffffffc020b9da:	fd06879b          	addiw	a5,a3,-48
ffffffffc020b9de:	28f56063          	bltu	a0,a5,ffffffffc020bc5e <vprintfmt+0x34e>
ffffffffc020b9e2:	2681                	sext.w	a3,a3
ffffffffc020b9e4:	8466                	mv	s0,s9
ffffffffc020b9e6:	002d179b          	slliw	a5,s10,0x2
ffffffffc020b9ea:	00144703          	lbu	a4,1(s0)
ffffffffc020b9ee:	01a787bb          	addw	a5,a5,s10
ffffffffc020b9f2:	0017979b          	slliw	a5,a5,0x1
ffffffffc020b9f6:	9fb5                	addw	a5,a5,a3
ffffffffc020b9f8:	fd07061b          	addiw	a2,a4,-48
ffffffffc020b9fc:	0405                	addi	s0,s0,1
ffffffffc020b9fe:	fd078d1b          	addiw	s10,a5,-48
ffffffffc020ba02:	0007069b          	sext.w	a3,a4
ffffffffc020ba06:	fec570e3          	bgeu	a0,a2,ffffffffc020b9e6 <vprintfmt+0xd6>
ffffffffc020ba0a:	f60dd3e3          	bgez	s11,ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020ba0e:	8dea                	mv	s11,s10
ffffffffc020ba10:	5d7d                	li	s10,-1
ffffffffc020ba12:	bfb9                	j	ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020ba14:	883a                	mv	a6,a4
ffffffffc020ba16:	8466                	mv	s0,s9
ffffffffc020ba18:	bfa1                	j	ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020ba1a:	8466                	mv	s0,s9
ffffffffc020ba1c:	4c05                	li	s8,1
ffffffffc020ba1e:	bf89                	j	ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020ba20:	4785                	li	a5,1
ffffffffc020ba22:	008a8613          	addi	a2,s5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020ba26:	00b7c463          	blt	a5,a1,ffffffffc020ba2e <vprintfmt+0x11e>
ffffffffc020ba2a:	1c058363          	beqz	a1,ffffffffc020bbf0 <vprintfmt+0x2e0>
ffffffffc020ba2e:	000ab683          	ld	a3,0(s5)
ffffffffc020ba32:	4741                	li	a4,16
ffffffffc020ba34:	8ab2                	mv	s5,a2
ffffffffc020ba36:	2801                	sext.w	a6,a6
ffffffffc020ba38:	87ee                	mv	a5,s11
ffffffffc020ba3a:	864a                	mv	a2,s2
ffffffffc020ba3c:	85ce                	mv	a1,s3
ffffffffc020ba3e:	8526                	mv	a0,s1
ffffffffc020ba40:	e47ff0ef          	jal	ffffffffc020b886 <printnum>
ffffffffc020ba44:	b709                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020ba46:	000aa503          	lw	a0,0(s5)
ffffffffc020ba4a:	864e                	mv	a2,s3
ffffffffc020ba4c:	85ca                	mv	a1,s2
ffffffffc020ba4e:	9482                	jalr	s1
ffffffffc020ba50:	0aa1                	addi	s5,s5,8
ffffffffc020ba52:	bdd5                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020ba54:	4785                	li	a5,1
ffffffffc020ba56:	008a8613          	addi	a2,s5,8
ffffffffc020ba5a:	00b7c463          	blt	a5,a1,ffffffffc020ba62 <vprintfmt+0x152>
ffffffffc020ba5e:	18058463          	beqz	a1,ffffffffc020bbe6 <vprintfmt+0x2d6>
ffffffffc020ba62:	000ab683          	ld	a3,0(s5)
ffffffffc020ba66:	4729                	li	a4,10
ffffffffc020ba68:	8ab2                	mv	s5,a2
ffffffffc020ba6a:	b7f1                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020ba6c:	864e                	mv	a2,s3
ffffffffc020ba6e:	85ca                	mv	a1,s2
ffffffffc020ba70:	03000513          	li	a0,48
ffffffffc020ba74:	e042                	sd	a6,0(sp)
ffffffffc020ba76:	9482                	jalr	s1
ffffffffc020ba78:	864e                	mv	a2,s3
ffffffffc020ba7a:	85ca                	mv	a1,s2
ffffffffc020ba7c:	07800513          	li	a0,120
ffffffffc020ba80:	9482                	jalr	s1
ffffffffc020ba82:	000ab683          	ld	a3,0(s5)
ffffffffc020ba86:	6802                	ld	a6,0(sp)
ffffffffc020ba88:	4741                	li	a4,16
ffffffffc020ba8a:	0aa1                	addi	s5,s5,8
ffffffffc020ba8c:	b76d                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020ba8e:	864e                	mv	a2,s3
ffffffffc020ba90:	85ca                	mv	a1,s2
ffffffffc020ba92:	02500513          	li	a0,37
ffffffffc020ba96:	9482                	jalr	s1
ffffffffc020ba98:	b57d                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020ba9a:	000aad03          	lw	s10,0(s5)
ffffffffc020ba9e:	8466                	mv	s0,s9
ffffffffc020baa0:	0aa1                	addi	s5,s5,8
ffffffffc020baa2:	b7a5                	j	ffffffffc020ba0a <vprintfmt+0xfa>
ffffffffc020baa4:	4785                	li	a5,1
ffffffffc020baa6:	008a8613          	addi	a2,s5,8
ffffffffc020baaa:	00b7c463          	blt	a5,a1,ffffffffc020bab2 <vprintfmt+0x1a2>
ffffffffc020baae:	12058763          	beqz	a1,ffffffffc020bbdc <vprintfmt+0x2cc>
ffffffffc020bab2:	000ab683          	ld	a3,0(s5)
ffffffffc020bab6:	4721                	li	a4,8
ffffffffc020bab8:	8ab2                	mv	s5,a2
ffffffffc020baba:	bfb5                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020babc:	87ee                	mv	a5,s11
ffffffffc020babe:	000dd363          	bgez	s11,ffffffffc020bac4 <vprintfmt+0x1b4>
ffffffffc020bac2:	4781                	li	a5,0
ffffffffc020bac4:	00078d9b          	sext.w	s11,a5
ffffffffc020bac8:	8466                	mv	s0,s9
ffffffffc020baca:	b55d                	j	ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020bacc:	0008041b          	sext.w	s0,a6
ffffffffc020bad0:	fd340793          	addi	a5,s0,-45
ffffffffc020bad4:	01b02733          	sgtz	a4,s11
ffffffffc020bad8:	00f037b3          	snez	a5,a5
ffffffffc020badc:	8ff9                	and	a5,a5,a4
ffffffffc020bade:	000ab703          	ld	a4,0(s5)
ffffffffc020bae2:	008a8693          	addi	a3,s5,8
ffffffffc020bae6:	e436                	sd	a3,8(sp)
ffffffffc020bae8:	12070563          	beqz	a4,ffffffffc020bc12 <vprintfmt+0x302>
ffffffffc020baec:	12079d63          	bnez	a5,ffffffffc020bc26 <vprintfmt+0x316>
ffffffffc020baf0:	00074783          	lbu	a5,0(a4)
ffffffffc020baf4:	0007851b          	sext.w	a0,a5
ffffffffc020baf8:	c78d                	beqz	a5,ffffffffc020bb22 <vprintfmt+0x212>
ffffffffc020bafa:	00170a93          	addi	s5,a4,1
ffffffffc020bafe:	547d                	li	s0,-1
ffffffffc020bb00:	000d4563          	bltz	s10,ffffffffc020bb0a <vprintfmt+0x1fa>
ffffffffc020bb04:	3d7d                	addiw	s10,s10,-1
ffffffffc020bb06:	008d0e63          	beq	s10,s0,ffffffffc020bb22 <vprintfmt+0x212>
ffffffffc020bb0a:	020c1863          	bnez	s8,ffffffffc020bb3a <vprintfmt+0x22a>
ffffffffc020bb0e:	864e                	mv	a2,s3
ffffffffc020bb10:	85ca                	mv	a1,s2
ffffffffc020bb12:	9482                	jalr	s1
ffffffffc020bb14:	000ac783          	lbu	a5,0(s5)
ffffffffc020bb18:	0a85                	addi	s5,s5,1
ffffffffc020bb1a:	3dfd                	addiw	s11,s11,-1
ffffffffc020bb1c:	0007851b          	sext.w	a0,a5
ffffffffc020bb20:	f3e5                	bnez	a5,ffffffffc020bb00 <vprintfmt+0x1f0>
ffffffffc020bb22:	01b05a63          	blez	s11,ffffffffc020bb36 <vprintfmt+0x226>
ffffffffc020bb26:	864e                	mv	a2,s3
ffffffffc020bb28:	85ca                	mv	a1,s2
ffffffffc020bb2a:	02000513          	li	a0,32
ffffffffc020bb2e:	3dfd                	addiw	s11,s11,-1
ffffffffc020bb30:	9482                	jalr	s1
ffffffffc020bb32:	fe0d9ae3          	bnez	s11,ffffffffc020bb26 <vprintfmt+0x216>
ffffffffc020bb36:	6aa2                	ld	s5,8(sp)
ffffffffc020bb38:	b539                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020bb3a:	3781                	addiw	a5,a5,-32
ffffffffc020bb3c:	05e00713          	li	a4,94
ffffffffc020bb40:	fcf777e3          	bgeu	a4,a5,ffffffffc020bb0e <vprintfmt+0x1fe>
ffffffffc020bb44:	03f00513          	li	a0,63
ffffffffc020bb48:	864e                	mv	a2,s3
ffffffffc020bb4a:	85ca                	mv	a1,s2
ffffffffc020bb4c:	9482                	jalr	s1
ffffffffc020bb4e:	000ac783          	lbu	a5,0(s5)
ffffffffc020bb52:	0a85                	addi	s5,s5,1
ffffffffc020bb54:	3dfd                	addiw	s11,s11,-1
ffffffffc020bb56:	0007851b          	sext.w	a0,a5
ffffffffc020bb5a:	d7e1                	beqz	a5,ffffffffc020bb22 <vprintfmt+0x212>
ffffffffc020bb5c:	fa0d54e3          	bgez	s10,ffffffffc020bb04 <vprintfmt+0x1f4>
ffffffffc020bb60:	bfe9                	j	ffffffffc020bb3a <vprintfmt+0x22a>
ffffffffc020bb62:	000aa783          	lw	a5,0(s5)
ffffffffc020bb66:	46e1                	li	a3,24
ffffffffc020bb68:	0aa1                	addi	s5,s5,8
ffffffffc020bb6a:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020bb6e:	8fb9                	xor	a5,a5,a4
ffffffffc020bb70:	40e7873b          	subw	a4,a5,a4
ffffffffc020bb74:	02e6c663          	blt	a3,a4,ffffffffc020bba0 <vprintfmt+0x290>
ffffffffc020bb78:	00004797          	auipc	a5,0x4
ffffffffc020bb7c:	35878793          	addi	a5,a5,856 # ffffffffc020fed0 <error_string>
ffffffffc020bb80:	00371693          	slli	a3,a4,0x3
ffffffffc020bb84:	97b6                	add	a5,a5,a3
ffffffffc020bb86:	639c                	ld	a5,0(a5)
ffffffffc020bb88:	cf81                	beqz	a5,ffffffffc020bba0 <vprintfmt+0x290>
ffffffffc020bb8a:	873e                	mv	a4,a5
ffffffffc020bb8c:	00000697          	auipc	a3,0x0
ffffffffc020bb90:	2b468693          	addi	a3,a3,692 # ffffffffc020be40 <etext+0x2c>
ffffffffc020bb94:	864a                	mv	a2,s2
ffffffffc020bb96:	85ce                	mv	a1,s3
ffffffffc020bb98:	8526                	mv	a0,s1
ffffffffc020bb9a:	0f2000ef          	jal	ffffffffc020bc8c <printfmt>
ffffffffc020bb9e:	b365                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020bba0:	00003697          	auipc	a3,0x3
ffffffffc020bba4:	55068693          	addi	a3,a3,1360 # ffffffffc020f0f0 <etext+0x32dc>
ffffffffc020bba8:	864a                	mv	a2,s2
ffffffffc020bbaa:	85ce                	mv	a1,s3
ffffffffc020bbac:	8526                	mv	a0,s1
ffffffffc020bbae:	0de000ef          	jal	ffffffffc020bc8c <printfmt>
ffffffffc020bbb2:	bb51                	j	ffffffffc020b946 <vprintfmt+0x36>
ffffffffc020bbb4:	4785                	li	a5,1
ffffffffc020bbb6:	008a8c13          	addi	s8,s5,8
ffffffffc020bbba:	00b7c363          	blt	a5,a1,ffffffffc020bbc0 <vprintfmt+0x2b0>
ffffffffc020bbbe:	cd81                	beqz	a1,ffffffffc020bbd6 <vprintfmt+0x2c6>
ffffffffc020bbc0:	000ab403          	ld	s0,0(s5)
ffffffffc020bbc4:	02044b63          	bltz	s0,ffffffffc020bbfa <vprintfmt+0x2ea>
ffffffffc020bbc8:	86a2                	mv	a3,s0
ffffffffc020bbca:	8ae2                	mv	s5,s8
ffffffffc020bbcc:	4729                	li	a4,10
ffffffffc020bbce:	b5a5                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020bbd0:	2585                	addiw	a1,a1,1
ffffffffc020bbd2:	8466                	mv	s0,s9
ffffffffc020bbd4:	bb71                	j	ffffffffc020b970 <vprintfmt+0x60>
ffffffffc020bbd6:	000aa403          	lw	s0,0(s5)
ffffffffc020bbda:	b7ed                	j	ffffffffc020bbc4 <vprintfmt+0x2b4>
ffffffffc020bbdc:	000ae683          	lwu	a3,0(s5)
ffffffffc020bbe0:	4721                	li	a4,8
ffffffffc020bbe2:	8ab2                	mv	s5,a2
ffffffffc020bbe4:	bd89                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020bbe6:	000ae683          	lwu	a3,0(s5)
ffffffffc020bbea:	4729                	li	a4,10
ffffffffc020bbec:	8ab2                	mv	s5,a2
ffffffffc020bbee:	b5a1                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020bbf0:	000ae683          	lwu	a3,0(s5)
ffffffffc020bbf4:	4741                	li	a4,16
ffffffffc020bbf6:	8ab2                	mv	s5,a2
ffffffffc020bbf8:	bd3d                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020bbfa:	864e                	mv	a2,s3
ffffffffc020bbfc:	85ca                	mv	a1,s2
ffffffffc020bbfe:	02d00513          	li	a0,45
ffffffffc020bc02:	e042                	sd	a6,0(sp)
ffffffffc020bc04:	9482                	jalr	s1
ffffffffc020bc06:	6802                	ld	a6,0(sp)
ffffffffc020bc08:	408006b3          	neg	a3,s0
ffffffffc020bc0c:	8ae2                	mv	s5,s8
ffffffffc020bc0e:	4729                	li	a4,10
ffffffffc020bc10:	b51d                	j	ffffffffc020ba36 <vprintfmt+0x126>
ffffffffc020bc12:	eba1                	bnez	a5,ffffffffc020bc62 <vprintfmt+0x352>
ffffffffc020bc14:	02800793          	li	a5,40
ffffffffc020bc18:	853e                	mv	a0,a5
ffffffffc020bc1a:	00003a97          	auipc	s5,0x3
ffffffffc020bc1e:	4cfa8a93          	addi	s5,s5,1231 # ffffffffc020f0e9 <etext+0x32d5>
ffffffffc020bc22:	547d                	li	s0,-1
ffffffffc020bc24:	bdf1                	j	ffffffffc020bb00 <vprintfmt+0x1f0>
ffffffffc020bc26:	853a                	mv	a0,a4
ffffffffc020bc28:	85ea                	mv	a1,s10
ffffffffc020bc2a:	e03a                	sd	a4,0(sp)
ffffffffc020bc2c:	0e4000ef          	jal	ffffffffc020bd10 <strnlen>
ffffffffc020bc30:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020bc34:	6702                	ld	a4,0(sp)
ffffffffc020bc36:	01b05b63          	blez	s11,ffffffffc020bc4c <vprintfmt+0x33c>
ffffffffc020bc3a:	864e                	mv	a2,s3
ffffffffc020bc3c:	85ca                	mv	a1,s2
ffffffffc020bc3e:	8522                	mv	a0,s0
ffffffffc020bc40:	e03a                	sd	a4,0(sp)
ffffffffc020bc42:	3dfd                	addiw	s11,s11,-1
ffffffffc020bc44:	9482                	jalr	s1
ffffffffc020bc46:	6702                	ld	a4,0(sp)
ffffffffc020bc48:	fe0d99e3          	bnez	s11,ffffffffc020bc3a <vprintfmt+0x32a>
ffffffffc020bc4c:	00074783          	lbu	a5,0(a4)
ffffffffc020bc50:	0007851b          	sext.w	a0,a5
ffffffffc020bc54:	ee0781e3          	beqz	a5,ffffffffc020bb36 <vprintfmt+0x226>
ffffffffc020bc58:	00170a93          	addi	s5,a4,1
ffffffffc020bc5c:	b54d                	j	ffffffffc020bafe <vprintfmt+0x1ee>
ffffffffc020bc5e:	8466                	mv	s0,s9
ffffffffc020bc60:	b36d                	j	ffffffffc020ba0a <vprintfmt+0xfa>
ffffffffc020bc62:	85ea                	mv	a1,s10
ffffffffc020bc64:	00003517          	auipc	a0,0x3
ffffffffc020bc68:	48450513          	addi	a0,a0,1156 # ffffffffc020f0e8 <etext+0x32d4>
ffffffffc020bc6c:	0a4000ef          	jal	ffffffffc020bd10 <strnlen>
ffffffffc020bc70:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020bc74:	02800793          	li	a5,40
ffffffffc020bc78:	00003717          	auipc	a4,0x3
ffffffffc020bc7c:	47070713          	addi	a4,a4,1136 # ffffffffc020f0e8 <etext+0x32d4>
ffffffffc020bc80:	853e                	mv	a0,a5
ffffffffc020bc82:	fbb04ce3          	bgtz	s11,ffffffffc020bc3a <vprintfmt+0x32a>
ffffffffc020bc86:	00170a93          	addi	s5,a4,1
ffffffffc020bc8a:	bd95                	j	ffffffffc020bafe <vprintfmt+0x1ee>

ffffffffc020bc8c <printfmt>:
ffffffffc020bc8c:	7139                	addi	sp,sp,-64
ffffffffc020bc8e:	02010313          	addi	t1,sp,32
ffffffffc020bc92:	f03a                	sd	a4,32(sp)
ffffffffc020bc94:	871a                	mv	a4,t1
ffffffffc020bc96:	ec06                	sd	ra,24(sp)
ffffffffc020bc98:	f43e                	sd	a5,40(sp)
ffffffffc020bc9a:	f842                	sd	a6,48(sp)
ffffffffc020bc9c:	fc46                	sd	a7,56(sp)
ffffffffc020bc9e:	e41a                	sd	t1,8(sp)
ffffffffc020bca0:	c71ff0ef          	jal	ffffffffc020b910 <vprintfmt>
ffffffffc020bca4:	60e2                	ld	ra,24(sp)
ffffffffc020bca6:	6121                	addi	sp,sp,64
ffffffffc020bca8:	8082                	ret

ffffffffc020bcaa <snprintf>:
ffffffffc020bcaa:	711d                	addi	sp,sp,-96
ffffffffc020bcac:	15fd                	addi	a1,a1,-1
ffffffffc020bcae:	95aa                	add	a1,a1,a0
ffffffffc020bcb0:	03810313          	addi	t1,sp,56
ffffffffc020bcb4:	f406                	sd	ra,40(sp)
ffffffffc020bcb6:	e82e                	sd	a1,16(sp)
ffffffffc020bcb8:	e42a                	sd	a0,8(sp)
ffffffffc020bcba:	fc36                	sd	a3,56(sp)
ffffffffc020bcbc:	e0ba                	sd	a4,64(sp)
ffffffffc020bcbe:	e4be                	sd	a5,72(sp)
ffffffffc020bcc0:	e8c2                	sd	a6,80(sp)
ffffffffc020bcc2:	ecc6                	sd	a7,88(sp)
ffffffffc020bcc4:	cc02                	sw	zero,24(sp)
ffffffffc020bcc6:	e01a                	sd	t1,0(sp)
ffffffffc020bcc8:	c515                	beqz	a0,ffffffffc020bcf4 <snprintf+0x4a>
ffffffffc020bcca:	02a5e563          	bltu	a1,a0,ffffffffc020bcf4 <snprintf+0x4a>
ffffffffc020bcce:	75dd                	lui	a1,0xffff7
ffffffffc020bcd0:	86b2                	mv	a3,a2
ffffffffc020bcd2:	00000517          	auipc	a0,0x0
ffffffffc020bcd6:	c2450513          	addi	a0,a0,-988 # ffffffffc020b8f6 <sprintputch>
ffffffffc020bcda:	871a                	mv	a4,t1
ffffffffc020bcdc:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020bce0:	0030                	addi	a2,sp,8
ffffffffc020bce2:	c2fff0ef          	jal	ffffffffc020b910 <vprintfmt>
ffffffffc020bce6:	67a2                	ld	a5,8(sp)
ffffffffc020bce8:	00078023          	sb	zero,0(a5)
ffffffffc020bcec:	4562                	lw	a0,24(sp)
ffffffffc020bcee:	70a2                	ld	ra,40(sp)
ffffffffc020bcf0:	6125                	addi	sp,sp,96
ffffffffc020bcf2:	8082                	ret
ffffffffc020bcf4:	5575                	li	a0,-3
ffffffffc020bcf6:	bfe5                	j	ffffffffc020bcee <snprintf+0x44>

ffffffffc020bcf8 <strlen>:
ffffffffc020bcf8:	00054783          	lbu	a5,0(a0)
ffffffffc020bcfc:	cb81                	beqz	a5,ffffffffc020bd0c <strlen+0x14>
ffffffffc020bcfe:	4781                	li	a5,0
ffffffffc020bd00:	0785                	addi	a5,a5,1
ffffffffc020bd02:	00f50733          	add	a4,a0,a5
ffffffffc020bd06:	00074703          	lbu	a4,0(a4)
ffffffffc020bd0a:	fb7d                	bnez	a4,ffffffffc020bd00 <strlen+0x8>
ffffffffc020bd0c:	853e                	mv	a0,a5
ffffffffc020bd0e:	8082                	ret

ffffffffc020bd10 <strnlen>:
ffffffffc020bd10:	4781                	li	a5,0
ffffffffc020bd12:	e589                	bnez	a1,ffffffffc020bd1c <strnlen+0xc>
ffffffffc020bd14:	a811                	j	ffffffffc020bd28 <strnlen+0x18>
ffffffffc020bd16:	0785                	addi	a5,a5,1
ffffffffc020bd18:	00f58863          	beq	a1,a5,ffffffffc020bd28 <strnlen+0x18>
ffffffffc020bd1c:	00f50733          	add	a4,a0,a5
ffffffffc020bd20:	00074703          	lbu	a4,0(a4)
ffffffffc020bd24:	fb6d                	bnez	a4,ffffffffc020bd16 <strnlen+0x6>
ffffffffc020bd26:	85be                	mv	a1,a5
ffffffffc020bd28:	852e                	mv	a0,a1
ffffffffc020bd2a:	8082                	ret

ffffffffc020bd2c <strcpy>:
ffffffffc020bd2c:	87aa                	mv	a5,a0
ffffffffc020bd2e:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd32:	0585                	addi	a1,a1,1
ffffffffc020bd34:	0785                	addi	a5,a5,1
ffffffffc020bd36:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020bd3a:	fb75                	bnez	a4,ffffffffc020bd2e <strcpy+0x2>
ffffffffc020bd3c:	8082                	ret

ffffffffc020bd3e <strcmp>:
ffffffffc020bd3e:	00054783          	lbu	a5,0(a0)
ffffffffc020bd42:	e791                	bnez	a5,ffffffffc020bd4e <strcmp+0x10>
ffffffffc020bd44:	a01d                	j	ffffffffc020bd6a <strcmp+0x2c>
ffffffffc020bd46:	00054783          	lbu	a5,0(a0)
ffffffffc020bd4a:	cb99                	beqz	a5,ffffffffc020bd60 <strcmp+0x22>
ffffffffc020bd4c:	0585                	addi	a1,a1,1
ffffffffc020bd4e:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd52:	0505                	addi	a0,a0,1
ffffffffc020bd54:	fef709e3          	beq	a4,a5,ffffffffc020bd46 <strcmp+0x8>
ffffffffc020bd58:	0007851b          	sext.w	a0,a5
ffffffffc020bd5c:	9d19                	subw	a0,a0,a4
ffffffffc020bd5e:	8082                	ret
ffffffffc020bd60:	0015c703          	lbu	a4,1(a1)
ffffffffc020bd64:	4501                	li	a0,0
ffffffffc020bd66:	9d19                	subw	a0,a0,a4
ffffffffc020bd68:	8082                	ret
ffffffffc020bd6a:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd6e:	4501                	li	a0,0
ffffffffc020bd70:	b7f5                	j	ffffffffc020bd5c <strcmp+0x1e>

ffffffffc020bd72 <strncmp>:
ffffffffc020bd72:	ce01                	beqz	a2,ffffffffc020bd8a <strncmp+0x18>
ffffffffc020bd74:	00054783          	lbu	a5,0(a0)
ffffffffc020bd78:	167d                	addi	a2,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020bd7a:	cb91                	beqz	a5,ffffffffc020bd8e <strncmp+0x1c>
ffffffffc020bd7c:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd80:	00f71763          	bne	a4,a5,ffffffffc020bd8e <strncmp+0x1c>
ffffffffc020bd84:	0505                	addi	a0,a0,1
ffffffffc020bd86:	0585                	addi	a1,a1,1
ffffffffc020bd88:	f675                	bnez	a2,ffffffffc020bd74 <strncmp+0x2>
ffffffffc020bd8a:	4501                	li	a0,0
ffffffffc020bd8c:	8082                	ret
ffffffffc020bd8e:	00054503          	lbu	a0,0(a0)
ffffffffc020bd92:	0005c783          	lbu	a5,0(a1)
ffffffffc020bd96:	9d1d                	subw	a0,a0,a5
ffffffffc020bd98:	8082                	ret

ffffffffc020bd9a <strchr>:
ffffffffc020bd9a:	a021                	j	ffffffffc020bda2 <strchr+0x8>
ffffffffc020bd9c:	00f58763          	beq	a1,a5,ffffffffc020bdaa <strchr+0x10>
ffffffffc020bda0:	0505                	addi	a0,a0,1
ffffffffc020bda2:	00054783          	lbu	a5,0(a0)
ffffffffc020bda6:	fbfd                	bnez	a5,ffffffffc020bd9c <strchr+0x2>
ffffffffc020bda8:	4501                	li	a0,0
ffffffffc020bdaa:	8082                	ret

ffffffffc020bdac <memset>:
ffffffffc020bdac:	ca01                	beqz	a2,ffffffffc020bdbc <memset+0x10>
ffffffffc020bdae:	962a                	add	a2,a2,a0
ffffffffc020bdb0:	87aa                	mv	a5,a0
ffffffffc020bdb2:	0785                	addi	a5,a5,1
ffffffffc020bdb4:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020bdb8:	fef61de3          	bne	a2,a5,ffffffffc020bdb2 <memset+0x6>
ffffffffc020bdbc:	8082                	ret

ffffffffc020bdbe <memmove>:
ffffffffc020bdbe:	02a5f163          	bgeu	a1,a0,ffffffffc020bde0 <memmove+0x22>
ffffffffc020bdc2:	00c587b3          	add	a5,a1,a2
ffffffffc020bdc6:	00f57d63          	bgeu	a0,a5,ffffffffc020bde0 <memmove+0x22>
ffffffffc020bdca:	c61d                	beqz	a2,ffffffffc020bdf8 <memmove+0x3a>
ffffffffc020bdcc:	962a                	add	a2,a2,a0
ffffffffc020bdce:	fff7c703          	lbu	a4,-1(a5)
ffffffffc020bdd2:	17fd                	addi	a5,a5,-1
ffffffffc020bdd4:	167d                	addi	a2,a2,-1
ffffffffc020bdd6:	00e60023          	sb	a4,0(a2)
ffffffffc020bdda:	fef59ae3          	bne	a1,a5,ffffffffc020bdce <memmove+0x10>
ffffffffc020bdde:	8082                	ret
ffffffffc020bde0:	00c586b3          	add	a3,a1,a2
ffffffffc020bde4:	87aa                	mv	a5,a0
ffffffffc020bde6:	ca11                	beqz	a2,ffffffffc020bdfa <memmove+0x3c>
ffffffffc020bde8:	0005c703          	lbu	a4,0(a1)
ffffffffc020bdec:	0585                	addi	a1,a1,1
ffffffffc020bdee:	0785                	addi	a5,a5,1
ffffffffc020bdf0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020bdf4:	feb69ae3          	bne	a3,a1,ffffffffc020bde8 <memmove+0x2a>
ffffffffc020bdf8:	8082                	ret
ffffffffc020bdfa:	8082                	ret

ffffffffc020bdfc <memcpy>:
ffffffffc020bdfc:	ca19                	beqz	a2,ffffffffc020be12 <memcpy+0x16>
ffffffffc020bdfe:	962e                	add	a2,a2,a1
ffffffffc020be00:	87aa                	mv	a5,a0
ffffffffc020be02:	0005c703          	lbu	a4,0(a1)
ffffffffc020be06:	0585                	addi	a1,a1,1
ffffffffc020be08:	0785                	addi	a5,a5,1
ffffffffc020be0a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020be0e:	feb61ae3          	bne	a2,a1,ffffffffc020be02 <memcpy+0x6>
ffffffffc020be12:	8082                	ret
