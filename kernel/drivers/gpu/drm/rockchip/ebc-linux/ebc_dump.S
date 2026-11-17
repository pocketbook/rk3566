// SPDX-License-Identifier: GPL-2.0

	.arch armv8-a
	.file	"ebc_dump.c"
	.text
	.align	2
	.p2align 5,,15
	.type	set_fs, %function
set_fs:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x1, sp_el0
// 0 "" 2
#NO_APP
	str	x0, [x1, 8]
#APP
// 40 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	dsb nsh
isb

662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 36
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd5000000 | (((0) << 19) | ((3) << 16) | ((3) << 12) | (((0)) << 8) | (((7)) << 5)) | ((31) & 0x1f))
	nop

664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L2		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L2 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L2		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L2 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x2, 32
#APP
// 177 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	stset	x2, [x1]

// 0 "" 2
#NO_APP
	cmn	x0, #1
	beq	.L7
.L4:
#APP
// 52 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 9
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (3) << 5) | ((!!0) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	ret
	.p2align 2,,3
.L2:
#APP
// 203 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic64_or
	prfm	pstl1strm, [x1]
1:	ldxr	x2, [x1]
	orr	x2, x2, 32
	stxr	w3, x2, [x1]
	cbnz	w3, 1b
// 0 "" 2
#NO_APP
	cmn	x0, #1
	bne	.L4
.L7:
#APP
// 50 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 9
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (3) << 5) | ((!!1) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	ret
	.size	set_fs, .-set_fs
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"_W"
	.align	3
.LC1:
	.string	""
	.align	3
.LC2:
	.string	"/tmp/%04d.%03d_%d_%d.%d_%d.%d_%s.%s%s.bmp"
	.text
	.align	2
	.p2align 5,,15
	.global	dump_update
	.type	dump_update, %function
dump_update:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	sub	sp, sp, #256
	mov	x2, 120
	stp	x29, x30, [sp, 176]
	add	x29, sp, 176
	stp	x19, x20, [sp, 192]
	mov	x20, x0
	mrs	x0, sp_el0
	stp	x21, x22, [sp, 208]
	adrp	x19, .LANCHOR0
	stp	x23, x24, [sp, 224]
	stp	x25, x26, [sp, 240]
	mov	x25, x1
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x26, sp_el0
// 0 "" 2
#NO_APP
	ldr	x1, [x0, 1280]
	str	x1, [sp, 168]
	mov	x1, 0
	add	x0, sp, 48
	bl	memset
	str	xzr, [sp, 40]
	adrp	x0, g_ebc
	ldp	w23, w22, [x25, 8]
	ldr	x0, [x0, #:lo12:g_ebc]
	ldr	w21, [x0, 384]
	mov	w0, 1
	bl	ktime_get_with_offset
	bl	ns_to_timespec64
	ldr	w5, [x20, 28]
	adrp	x6, wf_mode_strings
	add	x6, x6, :lo12:wf_mode_strings
	ldrb	w9, [x19, #:lo12:.LANCHOR0]
	mov	w3, 56963
	ldr	w2, [x25, 12]
	ubfx	x7, x5, 4, 3
	and	w5, w5, 3
	movk	w3, 0x431b, lsl 16
	tst	x9, 1
	ldr	w4, [x26, 1272]
	ldr	x7, [x6, w7, sxtw 3]
	adrp	x6, wf_qual_strings
	add	x6, x6, :lo12:wf_qual_strings
	smull	x3, w1, w3
	ldr	x8, [x6, w5, sxtw 3]
	adrp	x6, .LC0
	adrp	x5, .LC1
	add	x6, x6, :lo12:.LC0
	add	x5, x5, :lo12:.LC1
	str	w2, [sp]
	csel	x5, x5, x6, eq
	stp	x7, x8, [sp, 8]
	asr	x3, x3, 50
	str	x5, [sp, 24]
	sub	w3, w3, w1, asr 31
	mov	w2, w0
	adrp	x1, .LC2
	ldp	w5, w6, [x25]
	add	x1, x1, :lo12:.LC2
	ldr	w7, [x25, 8]
	add	x0, sp, 48
	bl	sprintf
	strb	wzr, [x19, #:lo12:.LANCHOR0]
	add	x0, sp, 48
	mov	w2, 420
	mov	w1, 65
	bl	filp_open
	cmn	x0, #4096
	bhi	.L10
	add	w23, w23, 3
	mov	x19, x0
	and	w24, w23, -4
	mov	x0, -1
	mul	w23, w22, w24
	ldr	x22, [x26, 8]
	bl	set_fs
	adrp	x1, .LANCHOR1
	add	x1, x1, :lo12:.LANCHOR1
	ldr	w0, [x25, 8]
	add	x2, x1, 54
	add	w23, w23, 1078
	strh	w0, [x1, 18]
	strh	w23, [x1, 2]
	ldr	w0, [x25, 12]
	strh	w0, [x1, 22]
	mov	w0, 0
	.p2align 5,,15
.L11:
	and	w3, w0, 255
	mov	w4, 0
	add	w0, w0, 1
	strb	w3, [x2, 2]
	bfi	w4, w3, 0, 8
	add	x2, x2, 4
	bfi	w4, w3, 8, 8
	strh	w4, [x2, -4]
	cmp	w0, 256
	bne	.L11
	add	x3, sp, 40
	mov	x0, x19
	mov	x2, 1078
	bl	kernel_write
	ldr	w0, [x25, 4]
	sxtw	x26, w24
	ldr	w23, [x25, 12]
	add	w23, w0, w23
	sub	w23, w23, #1
	mul	w24, w21, w23
	cmp	w0, w23
	bgt	.L14
	.p2align 5,,15
.L13:
	ldrsw	x0, [x25]
	add	x3, sp, 40
	ldr	x1, [x20, 40]
	mov	x2, x26
	add	x0, x0, w24, sxtw
	sub	w23, w23, #1
	add	x1, x1, x0
	mov	x0, x19
	bl	kernel_write
	sub	w24, w24, w21
	ldr	w0, [x25, 4]
	cmp	w0, w23
	ble	.L13
.L14:
	mov	x1, 0
	mov	x0, x19
	bl	filp_close
	mov	x0, x22
	bl	set_fs
.L10:
	mrs	x0, sp_el0
	ldr	x2, [sp, 168]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L21
	ldp	x29, x30, [sp, 176]
	ldp	x19, x20, [sp, 192]
	ldp	x21, x22, [sp, 208]
	ldp	x23, x24, [sp, 224]
	ldp	x25, x26, [sp, 240]
	add	sp, sp, 256
	ret
.L21:
	bl	__stack_chk_fail
	.size	dump_update, .-dump_update
	.section	.rodata.str1.8
	.align	3
.LC3:
	.string	"\0016 D %d.%d %2d%c - %2d%c %s %d\n"
	.align	3
.LC4:
	.string	"\0016 D \n"
	.text
	.align	2
	.p2align 5,,15
	.global	dump_waveform
	.type	dump_waveform, %function
dump_waveform:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	sub	sp, sp, #400
	mov	x2, 256
	stp	x29, x30, [sp, 304]
	add	x29, sp, 304
	stp	x19, x20, [sp, 320]
	adrp	x20, .LANCHOR2
	add	x20, x20, :lo12:.LANCHOR2
	stp	x21, x22, [sp, 336]
	mov	x22, x0
	mrs	x0, sp_el0
	stp	x23, x24, [sp, 352]
	mov	x23, 2
	movk	x23, 0x8000, lsl 16
	stp	x25, x26, [sp, 368]
	mov	w25, w1
	stp	x27, x28, [sp, 384]
	ldr	x1, [x0, 1280]
	str	x1, [sp, 296]
	mov	x1, 0
	and	w0, w25, 3
	str	w0, [sp, 16]
	ubfiz	x0, x25, 4, 2
	add	x0, x22, x0
	ldr	x28, [x22]
	ldp	w27, w21, [x0, 68]
	add	x0, sp, 40
	bl	memset
	mov	x7, x0
	mov	w10, 0
	adrp	x11, ebc_loglevel
	lsl	w27, w27, 10
	sxtw	x27, w27
.L23:
	lsr	x9, x23, x10
	ldr	w13, [x11, #:lo12:ebc_loglevel]
	lsl	w26, w10, 5
	and	w24, w10, 1
	and	x9, x9, 1
	mov	w19, 0
	cbz	w25, .L27
	.p2align 5,,15
.L24:
	cbz	w24, .L35
	cbz	x9, .L38
.L35:
	and	w0, w19, 1
	tbz	x19, 0, .L37
	lsr	x0, x23, x19
	tbnz	x0, 0, .L25
.L38:
	add	w19, w19, 1
	cmp	w19, 32
	bne	.L24
.L29:
	cmp	w13, 2
	bgt	.L64
.L46:
	add	w10, w10, 1
	cmp	w10, 32
	bne	.L23
	mrs	x0, sp_el0
	ldr	x2, [sp, 296]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L65
	ldp	x29, x30, [sp, 304]
	ldp	x19, x20, [sp, 320]
	ldp	x21, x22, [sp, 336]
	ldp	x23, x24, [sp, 352]
	ldp	x25, x26, [sp, 368]
	ldp	x27, x28, [sp, 384]
	add	sp, sp, 400
	ret
	.p2align 2,,3
.L27:
	sub	w0, w19, #2
	cmp	w0, 27
	bhi	.L25
	cmp	w19, 29
	beq	.L26
	add	w19, w19, 2
	b	.L27
	.p2align 2,,3
.L25:
	sxtw	x6, w21
	mov	w12, 0
	cmp	w21, 0
	ble	.L34
.L30:
	add	w0, w19, w26
	add	x1, x28, x27
	sxtw	x6, w21
	add	x0, x0, x1
	mov	x2, x7
	add	x5, x7, x6
	mov	w12, 0
	b	.L42
	.p2align 2,,3
.L39:
	cmp	w1, 2
	cinc	w12, w12, eq
.L40:
	mov	w4, 33
	tbnz	x3, 3, .L41
	ldrb	w4, [x20, w1, sxtw]
.L41:
	strb	w4, [x2], 1
	add	x0, x0, 1024
	cmp	x2, x5
	beq	.L34
.L42:
	ldrb	w3, [x0]
	and	w1, w3, 3
	cmp	w1, 1
	bne	.L39
	sub	w12, w12, #1
	b	.L40
	.p2align 2,,3
.L34:
	strb	wzr, [x7, x6]
	cmp	w13, 2
	bgt	.L32
.L43:
	add	w19, w19, 1
	cmp	w19, 32
	beq	.L29
	cbnz	w25, .L24
	b	.L27
	.p2align 2,,3
.L26:
	mov	w19, 30
	cmp	w21, 0
	bgt	.L30
	strb	wzr, [x7, w21, sxtw]
	cmp	w13, 2
	bgt	.L52
	mov	w19, 31
	cbnz	w25, .L24
	b	.L27
	.p2align 2,,3
.L37:
	cmp	w21, 0
	bgt	.L30
	strb	wzr, [x7, w21, sxtw]
	cmp	w13, 2
	bgt	.L31
	add	w19, w19, 1
	b	.L24
.L65:
	bl	__stack_chk_fail
.L64:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	str	w10, [sp, 20]
	bl	printk
	adrp	x11, ebc_loglevel
	ldr	w10, [sp, 20]
	add	x7, sp, 40
	b	.L46
.L31:
	ldr	w2, [x22, 132]
	asr	w3, w10, 1
	mov	w12, w24
	mov	w4, 32
	cbnz	w24, .L66
.L44:
	cmp	w0, 0
	mov	w6, 32
	mov	w0, 105
	asr	w5, w19, 1
	csel	w6, w6, w0, eq
.L45:
	ldr	w1, [sp, 16]
	adrp	x0, .LC3
	str	w12, [sp]
	add	x0, x0, :lo12:.LC3
	str	w10, [sp, 20]
	str	x9, [sp, 24]
	bl	printk
	ldr	w10, [sp, 20]
	adrp	x11, ebc_loglevel
	add	x7, sp, 40
	ldr	x9, [sp, 24]
	ldr	w13, [x11, #:lo12:ebc_loglevel]
	b	.L43
.L52:
	mov	w12, 0
.L32:
	ldr	w2, [x22, 132]
	asr	w3, w10, 1
	tbz	x10, 0, .L54
	and	w0, w19, 1
	mov	w4, 105
	b	.L44
.L66:
	asr	w5, w19, 1
	mov	w12, 0
	mov	w4, 105
	mov	w6, 32
	b	.L45
.L54:
	and	w0, w19, 1
	mov	w4, 32
	b	.L44
	.size	dump_waveform, .-dump_waveform
	.global	ebc_wait_flag
	.global	ebc_dump_updates
	.section	.rodata
	.align	3
	.set	.LANCHOR2,. + 0
	.type	transitions.0, %object
	.size	transitions.0, 4
transitions.0:
	.ascii	".@*?"
	.data
	.align	3
	.set	.LANCHOR1,. + 0
	.type	bmheader.1, %object
	.size	bmheader.1, 1078
bmheader.1:
	.string	"BM"
	.base64	"AAAAAAAAADYEAAAoAAAAAAAAAAAAAAABAAgAAAAAAAAAAAAAAAAAAAAAAAABAAAAAQAAAA=="
	.zero	1023
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	ebc_wait_flag, %object
	.size	ebc_wait_flag, 1
ebc_wait_flag:
	.zero	1
	.zero	3
	.type	ebc_dump_updates, %object
	.size	ebc_dump_updates, 4
ebc_dump_updates:
	.zero	4
	.section	.modinfo,"a"
	.type	__UNIQUE_ID_import_ns386, %object
	.size	__UNIQUE_ID_import_ns386, 68
__UNIQUE_ID_import_ns386:
	.string	"import_ns=VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver"
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
