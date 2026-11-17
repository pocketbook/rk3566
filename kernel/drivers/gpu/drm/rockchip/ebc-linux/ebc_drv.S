// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_drv.c"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_read, %function
ebc_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4685
	.align	3
	.8byte	.LPFE4685
	.text
.LPFE4685:
	nop
	nop
	mov	x0, 0
	ret
	.size	ebc_read, .-ebc_read
	.align	2
	.p2align 5,,15
	.type	ebc_write, %function
ebc_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4686
	.align	3
	.8byte	.LPFE4686
	.text
.LPFE4686:
	nop
	nop
	mov	x0, x2
	ret
	.size	ebc_write, .-ebc_write
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC core  D resume\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_resume, %function
ebc_resume:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4679
	.align	3
	.8byte	.LPFE4679
	.text
.LPFE4679:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	ldr	x19, [x0, 120]
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L11
.L5:
	mov	x0, 3
	bl	ebc_notify
	ldr	x0, [x19, 504]
	cbz	x0, .L6
	ldr	x1, [x0, 48]
	blr	x1
.L6:
	mov	x0, x19
	bl	wffpu_resume
	add	x0, x19, 536
	bl	ebc_mm_resume
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
.L11:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L5
	.size	ebc_resume, .-ebc_resume
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"\0016EBC core  I ebc remove\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_remove, %function
ebc_remove:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4717
	.align	3
	.8byte	.LPFE4717
	.text
.LPFE4717:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	ldr	x1, [x0, 136]
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 1
	bgt	.L15
.L13:
	add	x0, x1, 536
	bl	ebc_mm_deinit
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
.L15:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	str	x1, [sp, 24]
	bl	printk
	ldr	x1, [sp, 24]
	b	.L13
	.size	ebc_remove, .-ebc_remove
	.section	.rodata.str1.8
	.align	3
.LC2:
	.string	"%u %u"
	.text
	.align	2
	.p2align 5,,15
	.type	pixel_monitor_write, %function
pixel_monitor_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4713
	.align	3
	.8byte	.LPFE4713
	.text
.LPFE4713:
	nop
	nop
	sub	sp, sp, #48
	mov	x4, x0
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x20, x3
	add	x3, sp, 4
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	adrp	x1, .LC2
	ldr	x19, [x4, 120]
	mov	x2, sp
	add	x1, x1, :lo12:.LC2
	stp	wzr, wzr, [sp]
	bl	sscanf
	cmp	w0, 2
	bne	.L21
	ldr	w1, [x19, 8]
	ldr	w0, [sp]
	cmp	w1, w0
	bls	.L21
	ldr	w2, [x19, 12]
	ldr	w1, [sp, 4]
	cmp	w2, w1
	bls	.L21
	str	w0, [x19, 372]
	mov	x0, x20
	str	w1, [x19, 376]
.L16:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L23
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L21:
	mov	x0, -22
	b	.L16
.L23:
	bl	__stack_chk_fail
	.size	pixel_monitor_write, .-pixel_monitor_write
	.section	.rodata.str1.8
	.align	3
.LC3:
	.string	"\0016EBC core  D temperature correction: (t >= %u) => -%u%% of t-%u"
	.align	3
.LC4:
	.string	"\0016EBC core  E temperature correction: expected Tstart (0-50) and percent (0-100)"
	.text
	.align	2
	.p2align 5,,15
	.type	temp_correction_write, %function
temp_correction_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4702
	.align	3
	.8byte	.LPFE4702
	.text
.LPFE4702:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	str	x19, [sp, 32]
	mov	x19, x3
	add	x3, sp, 4
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	adrp	x1, .LC2
	mov	x2, sp
	add	x1, x1, :lo12:.LC2
	stp	wzr, wzr, [sp]
	bl	sscanf
	adrp	x1, .LANCHOR0
	ldr	w1, [x1, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bne	.L25
	ldr	w3, [sp]
	cmp	w3, 50
	bhi	.L25
	ldr	w2, [sp, 4]
	cmp	w2, 100
	bhi	.L25
	cmp	w1, 2
	bgt	.L31
.L26:
	adrp	x0, ebc_tcor_start
	str	w3, [x0, #:lo12:ebc_tcor_start]
	adrp	x0, ebc_tcor_percent
	str	w2, [x0, #:lo12:ebc_tcor_percent]
	mov	x0, x19
.L24:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L32
	ldr	x19, [sp, 32]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L25:
	cmp	w1, 0
	bgt	.L33
	mov	x0, -22
	b	.L24
.L32:
	bl	__stack_chk_fail
.L33:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printk
	mov	x0, -22
	b	.L24
.L31:
	mov	w1, w3
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printk
	ldp	w3, w2, [sp]
	b	.L26
	.size	temp_correction_write, .-temp_correction_write
	.section	.rodata.str1.8
	.align	3
.LC5:
	.string	"%u %u\n"
	.text
	.align	2
	.p2align 5,,15
	.type	pixel_monitor_read, %function
pixel_monitor_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4712
	.align	3
	.8byte	.LPFE4712
	.text
.LPFE4712:
	nop
	nop
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	mov	x29, sp
	ldr	x1, [x1, 120]
	ldr	w2, [x1, 372]
	ldr	w3, [x1, 376]
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	pixel_monitor_read, .-pixel_monitor_read
	.section	.rodata.str1.8
	.align	3
.LC6:
	.string	"%d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	slow_motion_read, %function
slow_motion_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4710
	.align	3
	.8byte	.LPFE4710
	.text
.LPFE4710:
	nop
	nop
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	mov	x29, sp
	ldr	x1, [x1, 120]
	ldr	w2, [x1, 180]
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	slow_motion_read, .-slow_motion_read
	.section	.rodata.str1.8
	.align	3
.LC7:
	.string	"-gu"
	.align	3
.LC8:
	.string	"[%s] "
	.align	3
.LC9:
	.string	"%s "
	.text
	.align	2
	.p2align 5,,15
	.type	spell_read, %function
spell_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4705
	.align	3
	.8byte	.LPFE4705
	.text
.LPFE4705:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	adrp	x0, .LC7
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	adrp	x20, .LANCHOR1
	add	x20, x20, :lo12:.LANCHOR1
	stp	x21, x22, [sp, 32]
	mov	x21, x2
	adrp	x22, .LC9
	add	x2, x0, :lo12:.LC7
	add	x22, x22, :lo12:.LC9
	stp	x23, x24, [sp, 48]
	adrp	x23, .LC8
	add	x23, x23, :lo12:.LC8
	mov	w19, 0
	adrp	x24, .LANCHOR2
.L40:
	ldr	w1, [x20, 8]
	ldr	w0, [x24, #:lo12:.LANCHOR2]
	tst	w1, w0
	add	x0, x21, w19, sxtw
	csel	x1, x22, x23, eq
	bl	sprintf
	add	w19, w19, w0
	ldr	x2, [x20, 16]!
	cbnz	x2, .L40
	mov	w0, 10
	strh	w0, [x21, w19, sxtw]
	add	w0, w19, 1
	ldp	x21, x22, [sp, 32]
	sxtw	x0, w0
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	spell_read, .-spell_read
	.align	2
	.p2align 5,,15
	.type	temp_correction_read, %function
temp_correction_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4701
	.align	3
	.8byte	.LPFE4701
	.text
.LPFE4701:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x1, ebc_tcor_percent
	mov	x0, x2
	mov	x29, sp
	ldr	w3, [x1, #:lo12:ebc_tcor_percent]
	adrp	x1, ebc_tcor_start
	ldr	w2, [x1, #:lo12:ebc_tcor_start]
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	temp_correction_read, .-temp_correction_read
	.align	2
	.p2align 5,,15
	.type	dump_updates_read, %function
dump_updates_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4696
	.align	3
	.8byte	.LPFE4696
	.text
.LPFE4696:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x1, ebc_dump_updates
	mov	x0, x2
	mov	x29, sp
	ldr	w2, [x1, #:lo12:ebc_dump_updates]
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	dump_updates_read, .-dump_updates_read
	.align	2
	.p2align 5,,15
	.type	debuglevel_read, %function
debuglevel_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4694
	.align	3
	.8byte	.LPFE4694
	.text
.LPFE4694:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x1, .LANCHOR0
	mov	x0, x2
	mov	x29, sp
	ldr	w2, [x1, #:lo12:.LANCHOR0]
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	debuglevel_read, .-debuglevel_read
	.section	.rodata.str1.8
	.align	3
.LC10:
	.string	"%-10s  %s\n"
	.text
	.align	2
	.p2align 5,,15
	.type	transition_read, %function
transition_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4703
	.align	3
	.8byte	.LPFE4703
	.text
.LPFE4703:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	adrp	x21, .LANCHOR1
	add	x21, x21, :lo12:.LANCHOR1
	adrp	x22, .LC10
	add	x22, x22, :lo12:.LC10
	stp	x19, x20, [sp, 16]
	add	x19, x21, 48
	add	x21, x21, 168
	str	x23, [sp, 48]
	mov	x23, x2
	mov	w20, 0
.L51:
	ldp	x2, x3, [x19], 40
	add	x0, x23, w20, sxtw
	mov	x1, x22
	bl	sprintf
	add	w20, w20, w0
	cmp	x19, x21
	bne	.L51
	ldr	x23, [sp, 48]
	sxtw	x0, w20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.size	transition_read, .-transition_read
	.align	2
	.p2align 5,,15
	.type	ebc_state_read, %function
ebc_state_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4693
	.align	3
	.8byte	.LPFE4693
	.text
.LPFE4693:
	nop
	nop
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	mov	x29, sp
	ldr	x1, [x1, 120]
	ldr	w2, [x1, 164]
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_state_read, .-ebc_state_read
	.section	.rodata.str1.8
	.align	3
.LC11:
	.string	"2.0.1-pb"
	.align	3
.LC12:
	.string	"%s\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_version_read, %function
ebc_version_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4692
	.align	3
	.8byte	.LPFE4692
	.text
.LPFE4692:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	adrp	x1, .LC12
	mov	x29, sp
	add	x1, x1, :lo12:.LC12
	adrp	x2, .LC11
	add	x2, x2, :lo12:.LC11
	bl	sprintf
	mov	x0, 9
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_version_read, .-ebc_version_read
	.align	2
	.p2align 5,,15
	.type	pmic_name_read, %function
pmic_name_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4688
	.align	3
	.8byte	.LPFE4688
	.text
.LPFE4688:
	nop
	nop
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	mov	x29, sp
	ldr	x1, [x1, 120]
	ldr	x2, [x1, 504]
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	add	x2, x2, 8
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	pmic_name_read, .-pmic_name_read
	.align	2
	.p2align 5,,15
	.type	waveform_name_read, %function
waveform_name_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4687
	.align	3
	.8byte	.LPFE4687
	.text
.LPFE4687:
	nop
	nop
	mov	x1, x0
	stp	x29, x30, [sp, -16]!
	mov	x0, x2
	mov	x29, sp
	ldr	x2, [x1, 120]
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	add	x2, x2, 1528
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], 16
	ret
	.size	waveform_name_read, .-waveform_name_read
	.align	2
	.p2align 5,,15
	.type	slow_motion_write, %function
slow_motion_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4711
	.align	3
	.8byte	.LPFE4711
	.text
.LPFE4711:
	nop
	nop
	sub	sp, sp, #48
	mov	x4, x0
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x20, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	ldr	x19, [x4, 120]
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L65
	ldr	w0, [sp, 4]
	str	w0, [x19, 180]
	mov	x0, x20
.L62:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L67
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L65:
	mov	x0, -22
	b	.L62
.L67:
	bl	__stack_chk_fail
	.size	slow_motion_write, .-slow_motion_write
	.section	.rodata.str1.8
	.align	3
.LC13:
	.string	"\0016EBC core  D temperature locked to %dC"
	.text
	.align	2
	.p2align 5,,15
	.type	temperature_write, %function
temperature_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4700
	.align	3
	.8byte	.LPFE4700
	.text
.LPFE4700:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	str	x19, [sp, 32]
	mov	x19, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L69
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L73
.L70:
	adrp	x0, ebc_temp_override
	ldr	w1, [sp, 4]
	str	w1, [x0, #:lo12:ebc_temp_override]
.L69:
	mrs	x0, sp_el0
	ldr	x2, [sp, 8]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L74
	ldp	x29, x30, [sp, 16]
	mov	x0, x19
	ldr	x19, [sp, 32]
	add	sp, sp, 48
	ret
.L74:
	bl	__stack_chk_fail
.L73:
	ldr	w1, [sp, 4]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printk
	b	.L70
	.size	temperature_write, .-temperature_write
	.align	2
	.p2align 5,,15
	.type	dump_updates_write, %function
dump_updates_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4697
	.align	3
	.8byte	.LPFE4697
	.text
.LPFE4697:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	str	x19, [sp, 32]
	mov	x19, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L76
	adrp	x0, ebc_dump_updates
	ldr	w1, [sp, 4]
	str	w1, [x0, #:lo12:ebc_dump_updates]
.L76:
	mrs	x0, sp_el0
	ldr	x2, [sp, 8]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L79
	ldp	x29, x30, [sp, 16]
	mov	x0, x19
	ldr	x19, [sp, 32]
	add	sp, sp, 48
	ret
.L79:
	bl	__stack_chk_fail
	.size	dump_updates_write, .-dump_updates_write
	.align	2
	.p2align 5,,15
	.type	debuglevel_write, %function
debuglevel_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4695
	.align	3
	.8byte	.LPFE4695
	.text
.LPFE4695:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	str	x19, [sp, 32]
	mov	x19, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L81
	adrp	x0, .LANCHOR0
	ldr	w1, [sp, 4]
	str	w1, [x0, #:lo12:.LANCHOR0]
.L81:
	mrs	x0, sp_el0
	ldr	x2, [sp, 8]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L84
	ldp	x29, x30, [sp, 16]
	mov	x0, x19
	ldr	x19, [sp, 32]
	add	sp, sp, 48
	ret
.L84:
	bl	__stack_chk_fail
	.size	debuglevel_write, .-debuglevel_write
	.align	2
	.p2align 5,,15
	.type	line_event_write, %function
line_event_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4709
	.align	3
	.8byte	.LPFE4709
	.text
.LPFE4709:
	nop
	nop
	sub	sp, sp, #48
	mov	x4, x0
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x20, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	ldr	x19, [x4, 120]
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L88
	ldr	w2, [sp, 4]
	mov	x0, x19
	adrp	x1, line_event_cb
	add	x1, x1, :lo12:line_event_cb
	bl	tcon_set_line_callback
	mov	x0, x20
.L85:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L90
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L88:
	mov	x0, -22
	b	.L85
.L90:
	bl	__stack_chk_fail
	.size	line_event_write, .-line_event_write
	.align	2
	.p2align 5,,15
	.type	line_event_read, %function
line_event_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4708
	.align	3
	.8byte	.LPFE4708
	.text
.LPFE4708:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x2
	ldr	x0, [x0, 120]
	bl	tcon_get_current_line
	mov	w2, w0
	adrp	x1, .LC6
	mov	x0, x19
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	ldr	x19, [sp, 16]
	sxtw	x0, w0
	ldp	x29, x30, [sp], 32
	ret
	.size	line_event_read, .-line_event_read
	.section	.rodata.str1.8
	.align	3
.LC14:
	.string	"\0016EBC core  E unknown spell: %s\n"
	.text
	.align	2
	.p2align 5,,15
	.type	spell_write, %function
spell_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4706
	.align	3
	.8byte	.LPFE4706
	.text
.LPFE4706:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	sub	w1, w3, #1
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	mov	x22, x2
	mov	x21, x3
	mov	w2, w3
	add	x1, x22, w1, sxtw
	b	.L95
	.p2align 2,,3
.L105:
	ldrb	w4, [x1], -1
	cmp	w4, 32
	bhi	.L104
	sub	w2, w2, #1
.L95:
	cmp	w2, 0
	bgt	.L105
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	bgt	.L99
.L100:
	mov	x0, -22
	b	.L93
	.p2align 2,,3
.L104:
	stp	x23, x24, [sp, 48]
	adrp	x24, .LANCHOR1
	add	x24, x24, :lo12:.LANCHOR1
	adrp	x1, .LC7
	mov	x23, x24
	add	x1, x1, :lo12:.LC7
	stp	x19, x20, [sp, 16]
	sxtw	x19, w2
	mov	w20, 0
	b	.L98
	.p2align 2,,3
.L96:
	ldr	x1, [x23, 16]!
	add	w20, w20, 1
	cbz	x1, .L106
.L98:
	mov	x2, x19
	mov	x0, x22
	bl	strncmp
	cbnz	w0, .L96
	add	x20, x24, w20, sxtw 4
	adrp	x1, .LANCHOR2
	ldp	x23, x24, [sp, 48]
	ldr	w2, [x1, #:lo12:.LANCHOR2]
	ldr	w0, [x20, 8]
	ldp	x19, x20, [sp, 16]
	eor	w0, w0, w2
	str	w0, [x1, #:lo12:.LANCHOR2]
	mov	x0, x21
.L93:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L106:
	adrp	x0, .LANCHOR0
	ldp	x19, x20, [sp, 16]
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	ldp	x23, x24, [sp, 48]
	cmp	w0, 0
	ble	.L100
.L99:
	mov	x1, x22
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printk
	mov	x0, -22
	b	.L93
	.size	spell_write, .-spell_write
	.align	2
	.p2align 5,,15
	.type	dump_waveform_write, %function
dump_waveform_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4698
	.align	3
	.8byte	.LPFE4698
	.text
.LPFE4698:
	nop
	nop
	sub	sp, sp, #48
	mov	x4, x0
	mrs	x1, sp_el0
	mov	x0, x2
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x20, x3
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	mov	w1, 0
	ldr	x19, [x4, 120]
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	kstrtouint
	cbnz	w0, .L110
	ldr	w1, [sp, 4]
	add	x0, x19, 1512
	bl	dump_waveform
	mov	x0, x20
.L107:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L112
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L110:
	mov	x0, -22
	b	.L107
.L112:
	bl	__stack_chk_fail
	.size	dump_waveform_write, .-dump_waveform_write
	.section	.rodata.str1.8
	.align	3
.LC15:
	.string	"%31s %d %d %d %d"
	.align	3
.LC16:
	.string	"turn"
	.align	3
.LC17:
	.string	"ripples"
	.align	3
.LC18:
	.string	"butterfly"
	.align	3
.LC19:
	.string	"\0016EBC core  D transition: %s %d %d %d %d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	transition_write, %function
transition_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4704
	.align	3
	.8byte	.LPFE4704
	.text
.LPFE4704:
	nop
	nop
	sub	sp, sp, #112
	mov	x7, x2
	mrs	x1, sp_el0
	add	x6, sp, 36
	add	x5, sp, 32
	add	x4, sp, 28
	stp	x29, x30, [sp, 80]
	add	x29, sp, 80
	stp	x19, x20, [sp, 96]
	mov	x20, x3
	add	x3, sp, 24
	ldr	x0, [x0, 120]
	ldr	x2, [x1, 1280]
	str	x2, [sp, 72]
	mov	x2, 0
	add	x2, sp, 40
	adrp	x1, .LC15
	mov	x19, x0
	add	x1, x1, :lo12:.LC15
	mov	x0, x7
	stp	xzr, xzr, [sp, 24]
	stp	xzr, xzr, [sp, 40]
	stp	xzr, xzr, [sp, 56]
	bl	sscanf
	cmp	w0, 0
	ble	.L125
	ldr	w2, [sp, 40]
	mov	w1, 30068
	movk	w1, 0x6e72, lsl 16
	cmp	w2, w1
	beq	.L131
.L115:
	ldr	x1, [sp, 40]
	mov	x2, 26994
	movk	x2, 0x7070, lsl 16
	mov	w6, 1
	movk	x2, 0x656c, lsl 32
	movk	x2, 0x73, lsl 48
	cmp	x1, x2
	beq	.L117
	mov	x2, 30050
	movk	x2, 0x7474, lsl 16
	movk	x2, 0x7265, lsl 32
	movk	x2, 0x6c66, lsl 48
	cmp	x1, x2
	beq	.L132
.L125:
	mov	x0, -22
.L113:
	mrs	x1, sp_el0
	ldr	x3, [sp, 72]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L133
	ldp	x29, x30, [sp, 80]
	ldp	x19, x20, [sp, 96]
	add	sp, sp, 112
	ret
	.p2align 2,,3
.L132:
	ldrh	w1, [sp, 48]
	cmp	w1, 121
	bne	.L125
	mov	w6, 2
	.p2align 5,,15
.L117:
	sub	w4, w0, #1
	cmp	w4, 3
	bgt	.L122
	sxtw	x1, w4
	mov	w2, 5
	sub	w2, w2, w0
	add	x0, x1, 5
	mov	w1, 10
	adrp	x3, .LANCHOR1
	add	x3, x3, :lo12:.LANCHOR1
	lsl	x2, x2, 2
	madd	w1, w6, w1, w0
	add	x3, x3, 48
	add	x0, sp, 24
	str	w6, [sp, 8]
	add	x0, x0, w4, uxtw 2
	add	x1, x3, x1, lsl 2
	bl	memcpy
	ldr	w6, [sp, 8]
.L122:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L134
.L123:
	add	x0, x19, 536
	str	w6, [sp, 8]
	bl	ebc_mm_get_user_buffer
	cbz	x0, .L128
	ldr	w6, [sp, 8]
	adrp	x1, .LANCHOR1
	add	x1, x1, :lo12:.LANCHOR1
	add	x2, sp, 24
	and	x6, x6, 3
	str	x0, [sp, 8]
	orr	x6, x6, x6, lsl 2
	add	x6, x1, x6, lsl 3
	ldr	w1, [x6, 64]
	bl	ebc_make_tmask
	ldr	x1, [sp, 8]
	add	x0, x19, 536
	bl	ebc_mm_put_user_buffer
	mov	x0, x20
	b	.L113
	.p2align 2,,3
.L131:
	ldrb	w1, [sp, 44]
	mov	w6, 0
	cbz	w1, .L117
	b	.L115
.L128:
	mov	x0, -16
	b	.L113
.L133:
	bl	__stack_chk_fail
.L134:
	ldp	w2, w3, [sp, 24]
	add	x1, sp, 40
	ldp	w4, w5, [sp, 32]
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	str	w6, [sp, 8]
	bl	printk
	ldr	w6, [sp, 8]
	b	.L123
	.size	transition_write, .-transition_write
	.section	.rodata.str1.8
	.align	3
.LC20:
	.string	"\0016EBC core  D close: pid %d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_release, %function
ebc_release:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4684
	.align	3
	.8byte	.LPFE4684
	.text
.LPFE4684:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR2+8
	mov	x3, x1
	mov	x29, sp
	ldr	x2, [x0, #:lo12:.LANCHOR2+8]
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L139
.L136:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x2, 380]
	ldr	w0, [x0, 1272]
	cmp	w1, w0
	bne	.L137
	str	wzr, [x2, 380]
	strb	wzr, [x2, 1648]
.L137:
	ldr	x0, [x3, 192]
	bl	ebc_close_session
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
.L139:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x0, 1272]
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	stp	x2, x3, [sp, 16]
	bl	printk
	ldp	x2, x3, [sp, 16]
	b	.L136
	.size	ebc_release, .-ebc_release
	.section	.rodata.str1.8
	.align	3
.LC21:
	.string	"\0016EBC core  D open: pid %d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_open, %function
ebc_open:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4683
	.align	3
	.8byte	.LPFE4683
	.text
.LPFE4683:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	adrp	x0, .LANCHOR2+8
	mov	x19, x1
	ldr	x2, [x0, #:lo12:.LANCHOR2+8]
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L145
.L141:
	add	x0, x2, 536
	bl	ebc_open_session
	cbz	x0, .L143
	str	x0, [x19, 192]
	mov	x1, x19
	mov	x0, x20
	bl	nonseekable_open
.L140:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L143:
	mov	w0, -12
	b	.L140
.L145:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x0, 1272]
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	str	x2, [sp, 40]
	bl	printk
	ldr	x2, [sp, 40]
	b	.L141
	.size	ebc_open, .-ebc_open
	.section	.rodata.str1.8
	.align	3
.LC22:
	.string	"\0016EBC core  T *LINE*\n"
	.text
	.align	2
	.p2align 5,,15
	.type	line_event_cb, %function
line_event_cb:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4707
	.align	3
	.8byte	.LPFE4707
	.text
.LPFE4707:
	nop
	nop
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 3
	bgt	.L152
	ret
.L152:
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	mov	x29, sp
	bl	printk
	ldp	x29, x30, [sp], 16
	ret
	.size	line_event_cb, .-line_event_cb
	.section	.rodata.str1.8
	.align	3
.LC23:
	.string	"\0016EBC core  E invalid vcom value %s\n"
	.align	3
.LC24:
	.string	"\0016EBC core  E set vcom value failed\n"
	.text
	.align	2
	.p2align 5,,15
	.type	pmic_vcom_write, %function
pmic_vcom_write:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4691
	.align	3
	.8byte	.LPFE4691
	.text
.LPFE4691:
	nop
	nop
	sub	sp, sp, #64
	mrs	x1, sp_el0
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x20, x3
	str	x21, [sp, 48]
	ldr	x21, [x0, 120]
	ldr	x3, [x1, 1280]
	str	x3, [sp, 8]
	mov	x3, 0
	ldrb	w0, [x2]
	mov	w1, 0
	str	wzr, [sp, 4]
	cmp	w0, 45
	cinc	x19, x2, eq
	add	x2, sp, 4
	mov	x0, x19
	bl	kstrtouint
	cbnz	w0, .L170
	ldr	x0, [x21, 504]
	cbz	x0, .L158
	ldr	x1, [x0, 64]
	blr	x1
.L159:
	ldr	w1, [sp, 4]
	cmp	w1, w0
	bne	.L171
.L160:
	mov	x0, x20
.L153:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L172
	ldr	x21, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 64
	ret
	.p2align 2,,3
.L171:
	ldr	x0, [x21, 504]
	cbz	x0, .L161
	bl	ebc_pmic_set_vcom
	cbz	w0, .L160
.L174:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	bgt	.L173
	.p2align 5,,15
.L157:
	mov	x0, -1
	b	.L153
	.p2align 2,,3
.L158:
	ldr	x0, [x21, 512]
	bl	regulator_get_voltage
	mov	w1, 19923
	movk	w1, 0x1062, lsl 16
	smull	x1, w0, w1
	asr	x1, x1, 38
	sub	w0, w1, w0, asr 31
	b	.L159
	.p2align 2,,3
.L161:
	ldr	x0, [x21, 512]
	bl	ebc_regulator_set_vcom
	cbz	w0, .L160
	b	.L174
	.p2align 2,,3
.L170:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L157
	mov	x1, x19
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	bl	printk
	mov	x0, -1
	b	.L153
.L172:
	bl	__stack_chk_fail
.L173:
	adrp	x0, .LC24
	add	x0, x0, :lo12:.LC24
	bl	printk
	mov	x0, -1
	b	.L153
	.size	pmic_vcom_write, .-pmic_vcom_write
	.section	.rodata.str1.8
	.align	3
.LC25:
	.string	"\0016EBC core  I ebc probe\n"
	.align	3
.LC26:
	.string	"waveform-region"
	.align	3
.LC27:
	.string	"\0016EBC core  E failed to get waveform-region mem\n"
	.align	3
.LC28:
	.string	"\0016EBC core  E fail to parse waveform\n"
	.align	3
.LC29:
	.string	"\0016EBC core  D setup sysfs\n"
	.align	3
.LC30:
	.string	"epd"
	.align	3
.LC31:
	.string	"\0016EBC core  E ebc_blank: no buffers\n"
	.align	3
.LC32:
	.string	"\0016EBC core  D blank\n"
	.align	3
.LC33:
	.string	"\0016EBC core  D ebc probe success\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_probe, %function
ebc_probe:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4716
	.align	3
	.8byte	.LPFE4716
	.text
.LPFE4716:
	nop
	nop
	sub	sp, sp, #176
	mrs	x1, sp_el0
	stp	x29, x30, [sp, 112]
	add	x29, sp, 112
	stp	x19, x20, [sp, 128]
	adrp	x20, .LANCHOR0
	add	x19, x0, 16
	stp	x21, x22, [sp, 144]
	ldr	x2, [x1, 1280]
	str	x2, [sp, 104]
	mov	x2, 0
	ldr	w1, [x20, #:lo12:.LANCHOR0]
	cmp	w1, 1
	bgt	.L214
.L176:
	mov	x0, x19
	mov	w2, 3520
	mov	x1, 1656
	bl	devm_kmalloc
	mov	x21, x0
	cbz	x0, .L177
	str	x19, [x0]
	adrp	x1, .LANCHOR2+8
	str	x0, [x19, 120]
	str	x0, [x1, #:lo12:.LANCHOR2+8]
	bl	tcon_setup_device
	mov	w5, w0
	cbz	w0, .L215
.L175:
	mrs	x0, sp_el0
	ldr	x2, [sp, 104]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L216
	ldp	x29, x30, [sp, 112]
	mov	w0, w5
	ldp	x19, x20, [sp, 128]
	ldp	x21, x22, [sp, 144]
	add	sp, sp, 176
	ret
	.p2align 2,,3
.L215:
	ldr	w2, [x21, 468]
	add	x1, x21, 504
	mov	x0, x19
	bl	pmic_setup_device
	mov	w5, w0
	cbnz	w0, .L175
	mov	x0, x19
	bl	ebc_mm_init
	mov	w5, w0
	cbnz	w0, .L175
	mov	x2, 64
	mov	w1, 0
	add	x0, sp, 40
	str	x23, [sp, 160]
	bl	memset
	ldr	x0, [x19, 120]
	adrp	x1, .LC26
	mov	w2, 0
	add	x1, x1, :lo12:.LC26
	mov	x23, x0
	ldr	x0, [x19, 648]
	bl	of_parse_phandle
	cbz	x0, .L217
	add	x2, sp, 40
	mov	w1, 0
	bl	of_address_to_resource
	mov	w5, w0
	cbnz	w0, .L213
	ldp	x1, x4, [sp, 40]
	mov	x0, x19
	mov	x3, 1
	add	x4, x4, 1
	sub	x4, x4, x1
	str	x4, [sp, 8]
	sxtw	x2, w4
	bl	devm_memremap
	cbz	x0, .L218
	ldr	w2, [sp, 8]
	mov	x1, x0
	add	x0, x23, 1512
	bl	wf_lut_setup
	mov	w5, w0
	tbnz	w0, #31, .L219
	cbnz	w0, .L213
	mov	x0, x21
	bl	wffpu_init
	mov	w5, w0
	cbnz	w0, .L213
	ldr	w0, [x20, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L220
.L188:
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x0, x0, 8
	str	w5, [sp, 8]
	bl	misc_register
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 88
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 120
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 152
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 184
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 216
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 248
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 280
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 312
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 344
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 376
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 408
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 440
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 472
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 504
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 536
	mov	x0, x19
	bl	device_create_file
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x1, x0, 568
	mov	x0, x19
	bl	device_create_file
	mov	x1, x19
	adrp	x2, .LC30
	mov	x0, 0
	add	x2, x2, :lo12:.LC30
	bl	sysfs_create_link
	mov	x0, 68719476704
	add	x1, x21, 264
	str	x0, [x21, 256]
	adrp	x0, ebc_poweroff_worker
	add	x0, x0, :lo12:ebc_poweroff_worker
	str	x1, [x21, 264]
	stp	x1, x0, [x21, 272]
	adrp	x1, delayed_work_timer_fn
	add	x1, x1, :lo12:delayed_work_timer_fn
	add	x0, x21, 288
	mov	x4, 0
	mov	x3, 0
	mov	w2, 2097152
	bl	init_timer_key
	str	wzr, [x21, 160]
	mov	x0, x19
	bl	ebc_logo_init
	ldr	x0, [x21, 504]
	cbz	x0, .L189
	bl	ebc_pmic_verity_vcom
	ldr	w5, [sp, 8]
.L190:
	add	x0, x21, 536
	str	w5, [sp, 20]
	bl	ebc_mm_get_user_buffer
	mov	x3, x0
	add	x0, x21, 536
	str	x3, [sp, 8]
	bl	ebc_mm_get_bg
	mov	x4, x0
	ldr	x3, [sp, 8]
	ldr	w0, [x20, #:lo12:.LANCHOR0]
	cmp	x3, 0
	ldr	w5, [sp, 20]
	ccmp	x4, 0, 4, ne
	beq	.L221
	cmp	w0, 2
	bgt	.L222
.L194:
	ldr	x2, [x3, 16]
	mov	w1, 240
	ldr	x0, [x3, 40]
	str	x3, [sp, 8]
	str	w5, [sp, 20]
	str	x4, [sp, 24]
	bl	memset
	ldr	x4, [sp, 24]
	mov	w1, 0
	ldr	x2, [x4, 16]
	ldr	x0, [x4, 40]
	bl	memset
	ldr	x3, [sp, 8]
	mov	w0, 18
	str	w0, [x3, 28]
	add	x0, x3, 72
	bl	area_set_fullscreen
	ldr	x3, [sp, 8]
	ldr	x0, [x3, 88]
	bl	area_set_fullscreen
	ldr	x3, [sp, 8]
	mov	w0, 1
	mov	x1, x3
	str	w0, [x3, 96]
	add	x0, x21, 536
	bl	ebc_mm_put_user_buffer
	ldr	w5, [sp, 20]
.L193:
	ldr	x0, [x21, 344]
	cbz	x0, .L195
.L198:
	mov	x0, x19
	str	w5, [sp, 8]
	bl	ebc_logo_show_kernel
	ldr	w5, [sp, 8]
.L195:
	ldr	w0, [x20, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L223
	.p2align 5,,15
.L213:
	ldr	x23, [sp, 160]
	b	.L175
	.p2align 2,,3
.L219:
	ldr	w0, [x20, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L213
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	str	w5, [sp, 8]
	bl	printk
	ldr	x23, [sp, 160]
	ldr	w5, [sp, 8]
	b	.L175
	.p2align 2,,3
.L189:
	ldr	x0, [x21, 512]
	bl	ebc_regulator_verity_vcom
	ldr	w5, [sp, 8]
	b	.L190
.L217:
	ldr	x23, [sp, 160]
	mov	w5, -19
	b	.L175
.L218:
	ldr	w0, [x20, #:lo12:.LANCHOR0]
	cmp	w0, 0
	bgt	.L224
	ldr	x23, [sp, 160]
.L177:
	mov	w5, -12
	b	.L175
.L216:
	str	x23, [sp, 160]
	bl	__stack_chk_fail
.L221:
	cmp	w0, 0
	bgt	.L225
	ldr	x0, [x21, 344]
	cbnz	x0, .L198
	ldr	x23, [sp, 160]
	b	.L175
.L220:
	adrp	x0, .LC29
	add	x0, x0, :lo12:.LC29
	str	w5, [sp, 8]
	bl	printk
	ldr	w5, [sp, 8]
	b	.L188
.L225:
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	str	w5, [sp, 8]
	bl	printk
	ldr	w5, [sp, 8]
	b	.L193
.L223:
	adrp	x0, .LC33
	add	x0, x0, :lo12:.LC33
	str	w5, [sp, 8]
	bl	printk
	ldr	x23, [sp, 160]
	ldr	w5, [sp, 8]
	b	.L175
.L222:
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	str	x3, [sp, 8]
	str	w5, [sp, 20]
	str	x4, [sp, 24]
	bl	printk
	ldr	x3, [sp, 8]
	ldr	x4, [sp, 24]
	ldr	w5, [sp, 20]
	b	.L194
.L214:
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	printk
	b	.L176
.L224:
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	bl	printk
	ldr	x23, [sp, 160]
	mov	w5, -12
	b	.L175
	.size	ebc_probe, .-ebc_probe
	.align	2
	.p2align 5,,15
	.type	pmic_vcom_read, %function
pmic_vcom_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4690
	.align	3
	.8byte	.LPFE4690
	.text
.LPFE4690:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x2
	ldr	x1, [x0, 120]
	ldr	x0, [x1, 504]
	cbz	x0, .L227
	ldr	x1, [x0, 64]
	blr	x1
	mov	w2, w0
	adrp	x1, .LC6
	mov	x0, x19
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	ldr	x19, [sp, 16]
	sxtw	x0, w0
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L227:
	ldr	x0, [x1, 512]
	bl	regulator_get_voltage
	mov	w1, 19923
	movk	w1, 0x1062, lsl 16
	smull	x1, w0, w1
	asr	x1, x1, 38
	sub	w2, w1, w0, asr 31
	mov	x0, x19
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	pmic_vcom_read, .-pmic_vcom_read
	.align	2
	.p2align 5,,15
	.type	_copy_to_user, %function
_copy_to_user:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x3, sp_el0
// 0 "" 2
#NO_APP
	ldr	w5, [x3, 44]
	ldr	x4, [x3, 8]
	tbnz	x5, 21, .L231
	ldr	x5, [x3]
	mov	x3, x0
	tbnz	w5, 26, .L231
#APP
// 79 "./arch/arm64/include/asm/uaccess.h" 1
		adds	x3, x3, x2
	csel	x4, xzr, x4, hi
	csinv	x3, x3, xzr, cc
	sbcs	xzr, x3, x4
	cset	x3, ls

// 0 "" 2
#NO_APP
	cbnz	x3, .L243
.L240:
	mov	x0, x2
	ret
	.p2align 2,,3
.L231:
	sbfx	x3, x0, 0, 56
	and	x3, x0, x3
#APP
// 79 "./arch/arm64/include/asm/uaccess.h" 1
		adds	x3, x3, x2
	csel	x4, xzr, x4, hi
	csinv	x3, x3, xzr, cc
	sbcs	xzr, x3, x4
	cset	x3, ls

// 0 "" 2
#NO_APP
	cbz	x3, .L240
.L243:
	stp	x29, x30, [sp, -16]!
	mov	x3, x0
	mov	x29, sp
#APP
// 276 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 10
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (4) << 5) | ((!!0) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	sbfx	x4, x3, 0, 56
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	x5, [x0, 8]
	and	x4, x3, x4
#APP
// 289 "./arch/arm64/include/asm/uaccess.h" 1
		bics	xzr, x4, x5
	csel	x0, x3, xzr, eq

// 0 "" 2
// 297 "./arch/arm64/include/asm/uaccess.h" 1
	hint #20
// 0 "" 2
#NO_APP
	bl	__arch_copy_to_user
#APP
// 271 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 10
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (4) << 5) | ((!!1) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	ldp	x29, x30, [sp], 16
	ret
	.size	_copy_to_user, .-_copy_to_user
	.align	2
	.p2align 5,,15
	.type	_copy_from_user, %function
_copy_from_user:
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w3, [x0, 44]
	ldr	x4, [x0, 8]
	tbnz	x3, 21, .L245
	ldr	x0, [x0]
	mov	x3, x1
	tbnz	w0, 26, .L245
#APP
// 79 "./arch/arm64/include/asm/uaccess.h" 1
		adds	x3, x3, x2
	csel	x4, xzr, x4, hi
	csinv	x3, x3, xzr, cc
	sbcs	xzr, x3, x4
	cset	x3, ls

// 0 "" 2
#NO_APP
	cbz	x3, .L247
.L259:
#APP
// 276 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 10
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (4) << 5) | ((!!0) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	x4, [x0, 8]
	sbfx	x0, x1, 0, 56
	and	x0, x1, x0
#APP
// 289 "./arch/arm64/include/asm/uaccess.h" 1
		bics	xzr, x0, x4
	csel	x3, x1, xzr, eq

// 0 "" 2
// 297 "./arch/arm64/include/asm/uaccess.h" 1
	hint #20
// 0 "" 2
#NO_APP
	mov	x1, x3
	mov	x0, x19
	str	x2, [sp, 40]
	bl	__arch_copy_from_user
#APP
// 271 "./arch/arm64/include/asm/uaccess.h" 1
	.if 1 == 1
661:
	nop
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 10
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	.inst (0xd500401f | ((0) << 16 | (4) << 5) | ((!!1) << 8))
	
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	ldr	x2, [sp, 40]
	cbnz	x0, .L258
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L245:
	sbfx	x3, x1, 0, 56
	and	x3, x1, x3
#APP
// 79 "./arch/arm64/include/asm/uaccess.h" 1
		adds	x3, x3, x2
	csel	x4, xzr, x4, hi
	csinv	x3, x3, xzr, cc
	sbcs	xzr, x3, x4
	cset	x3, ls

// 0 "" 2
#NO_APP
	cbnz	x3, .L259
.L247:
	mov	x0, x19
	mov	w1, 0
	str	x2, [sp, 40]
	bl	memset
	ldr	x19, [sp, 16]
	ldr	x0, [sp, 40]
	ldp	x29, x30, [sp], 48
	ret
.L258:
	sub	x2, x2, x0
	add	x19, x19, x2
	mov	x2, x0
	b	.L247
	.size	_copy_from_user, .-_copy_from_user
	.section	.rodata.str1.8
	.align	3
.LC34:
	.string	"\0016EBC core  E invalid buf index: %d\n"
	.align	3
.LC35:
	.string	"\0016EBC core  E invalid area: (%d,%d,%d,%d)\n"
	.align	3
.LC36:
	.string	"\0016EBC core  D T pmic: %dC battery: %dC avg: %dC\n"
	.align	3
.LC37:
	.string	"\0016EBC core  D T pmic: correction %dC -> %dC"
	.align	3
.LC38:
	.string	"\0016EBC core  E ioctl not supported: 0x%X\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_ioctl, %function
ebc_ioctl:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4682
	.align	3
	.8byte	.LPFE4682
	.text
.LPFE4682:
	nop
	nop
	sub	sp, sp, #208
	stp	x29, x30, [sp, 144]
	add	x29, sp, 144
	stp	x19, x20, [sp, 160]
	mov	w19, w1
	stp	x21, x22, [sp, 176]
	adrp	x22, .LANCHOR2
	stp	x23, x24, [sp, 192]
	mov	x23, x2
	mrs	x2, sp_el0
	ldr	x1, [x2, 1280]
	str	x1, [sp, 136]
	mov	x1, 0
	add	x2, x22, :lo12:.LANCHOR2
	ldr	x0, [x0, 192]
	ldr	x21, [x2, 8]
	mov	x24, x0
	add	x20, x21, 192
	mov	x0, x20
	bl	mutex_lock
	mov	w0, 25866
	movk	w0, 0x8004, lsl 16
	cmp	w19, w0
	beq	.L261
	bls	.L342
	mov	w0, 25857
	movk	w0, 0x8030, lsl 16
	cmp	w19, w0
	beq	.L269
	bhi	.L270
	mov	w0, 25868
	movk	w0, 0x8004, lsl 16
	cmp	w19, w0
	beq	.L271
	mov	w0, 25856
	movk	w0, 0x8014, lsl 16
	cmp	w19, w0
	bne	.L267
	ldr	w0, [x21, 484]
	add	x1, sp, 16
	str	w0, [sp, 32]
	mov	x2, 20
	ldr	x0, [x21, 384]
	str	x0, [sp, 16]
	ldr	x0, [x21, 400]
	str	x0, [sp, 24]
	mov	x0, x23
	bl	_copy_to_user
	sxtw	x19, w0
	.p2align 5,,15
.L274:
	mov	x0, x20
	bl	mutex_unlock
	mrs	x0, sp_el0
	ldr	x2, [sp, 136]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L343
	ldp	x29, x30, [sp, 144]
	mov	x0, x19
	ldp	x19, x20, [sp, 160]
	ldp	x21, x22, [sp, 176]
	ldp	x23, x24, [sp, 192]
	add	sp, sp, 208
	ret
	.p2align 2,,3
.L342:
	mov	w0, 26051
	cmp	w19, w0
	beq	.L263
	bhi	.L264
	mov	w0, 26049
	cmp	w19, w0
	beq	.L265
	mov	w0, 26050
	cmp	w19, w0
	bne	.L267
	mov	w0, 21
	mov	x19, -1
	bl	capable
	tbz	x0, 0, .L274
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w0, [x0, 1272]
	str	w0, [x21, 380]
.L268:
	mov	x19, 0
	b	.L274
	.p2align 2,,3
.L265:
	mov	w0, 21
	mov	x19, -1
	stp	xzr, xzr, [sp, 16]
	stp	xzr, xzr, [sp, 32]
	stp	xzr, xzr, [sp, 48]
	bl	capable
	tbz	x0, 0, .L274
	mov	x0, x24
	bl	ebc_sess_query_lut
	ldp	x4, x5, [x0]
	ldp	x2, x3, [x0, 16]
	ldp	x0, x1, [x0, 32]
	stp	x4, x5, [sp, 16]
	stp	x2, x3, [sp, 32]
	stp	x0, x1, [sp, 48]
.L340:
	add	x1, sp, 16
	mov	x0, x23
	mov	x2, 48
	bl	_copy_to_user
	sxtw	x19, w0
	b	.L274
	.p2align 2,,3
.L271:
	mov	w0, -1
	stp	w0, wzr, [sp, 12]
	adrp	x0, ebc_temp_override
	ldr	w0, [x0, #:lo12:ebc_temp_override]
	tbz	w0, #31, .L344
	ldr	x0, [x21, 504]
	cbz	x0, .L294
	ldr	x2, [x0, 56]
	add	x1, sp, 16
	blr	x2
	ldr	w1, [sp, 16]
.L295:
	adrp	x0, battery_ntc_temp
	mov	w2, 26215
	movk	w2, 0x6666, lsl 16
	ldr	w0, [x0, #:lo12:battery_ntc_temp]
	smull	x2, w0, w2
	asr	x2, x2, 34
	sub	w2, w2, w0, asr 31
	cmp	w0, 9
	ble	.L296
	cmp	w1, 0
	ble	.L297
	add	w0, w1, w1, lsl 2
	add	w3, w0, w0, lsl 2
	mov	w0, 75
	madd	w0, w2, w0, w3
	mov	w3, 34079
	movk	w3, 0x51eb, lsl 16
	smull	x3, w0, w3
	asr	x3, x3, 37
	sub	w0, w3, w0, asr 31
	str	w0, [sp, 12]
.L298:
	adrp	x19, .LANCHOR0
	ldr	w0, [x19, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L345
.L299:
	adrp	x0, ebc_tcor_percent
	ldr	w3, [x0, #:lo12:ebc_tcor_percent]
	cbz	w3, .L293
	adrp	x0, ebc_tcor_start
	ldr	w1, [sp, 12]
	ldr	w0, [x0, #:lo12:ebc_tcor_start]
	mov	w21, w1
	cmp	w1, w0
	blt	.L300
	sub	w0, w1, w0
	mov	w2, 34079
	movk	w2, 0x51eb, lsl 16
	mul	w0, w0, w3
	umull	x0, w0, w2
	lsr	x0, x0, 37
	sub	w21, w1, w0
.L300:
	ldr	w0, [x19, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L346
.L301:
	str	w21, [sp, 12]
.L293:
	add	x1, sp, 12
	mov	x0, x23
	mov	x2, 4
	bl	_copy_to_user
.L341:
	sxtw	x19, w0
	b	.L274
	.p2align 2,,3
.L270:
	mov	w0, 25858
	movk	w0, 0xc030, lsl 16
	cmp	w19, w0
	bne	.L267
	mov	x1, x23
	add	x0, sp, 16
	mov	x2, 48
	mov	x19, -14
	stp	xzr, xzr, [sp, 16]
	stp	xzr, xzr, [sp, 32]
	stp	xzr, xzr, [sp, 48]
	bl	_copy_from_user
	cbnz	x0, .L274
	ldr	w0, [x22, #:lo12:.LANCHOR2]
	tbnz	x0, 0, .L347
.L278:
	tbz	x0, 1, .L279
	ldr	w0, [sp, 28]
	mov	x19, 0
	and	w0, w0, 112
	cmp	w0, 96
	beq	.L274
.L279:
	ldr	w0, [x21, 380]
	cbz	w0, .L280
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x1, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x1, 1272]
	mov	x19, -16
	cmp	w0, w1
	bne	.L274
.L280:
	ldr	w1, [sp, 16]
	cmp	w1, 2
	bhi	.L348
	add	x0, sp, 48
	bl	area_check
	tbz	x0, 0, .L284
	add	x1, sp, 16
	mov	x0, x24
	bl	ebc_sess_put_buffer
	tbz	w0, #31, .L340
	sxtw	x19, w0
	b	.L274
	.p2align 2,,3
.L264:
	mov	w0, 25859
	movk	w0, 0x4030, lsl 16
	cmp	w19, w0
	beq	.L268
.L267:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L268
	mov	w1, w19
	adrp	x0, .LC38
	mov	x19, 0
	add	x0, x0, :lo12:.LC38
	bl	printk
	b	.L274
	.p2align 2,,3
.L261:
	ldr	w0, [x21, 164]
	add	x1, sp, 16
	mov	x2, 4
	str	w0, [sp, 16]
	mov	x0, x23
	bl	_copy_to_user
	ldr	w1, [sp, 16]
	cbz	w1, .L341
	adrp	x1, ebc_wait_flag
	mov	w2, 1
	sxtw	x19, w0
	strb	w2, [x1, #:lo12:ebc_wait_flag]
	b	.L274
	.p2align 2,,3
.L269:
	ldr	x0, [x21]
	bl	ebc_logo_terminate
	ldr	w0, [x21, 380]
	cbz	w0, .L275
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x1, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x1, 1272]
	cmp	w0, w1
	beq	.L275
.L276:
	mov	x19, -16
	b	.L274
	.p2align 2,,3
.L275:
	mov	x0, x24
	bl	ebc_sess_get_buffer
	cbz	x0, .L276
	mov	x1, x0
	mov	x2, 48
	mov	x0, x23
	bl	_copy_to_user
	sxtw	x19, w0
	b	.L274
	.p2align 2,,3
.L263:
	mov	x2, 64
	mov	w1, 0
	add	x0, sp, 72
	bl	memset
	mov	w0, 21
	mov	x19, -1
	bl	capable
	tbz	x0, 0, .L274
	mov	x2, 64
	mov	w1, 0
	add	x0, x21, 1576
	bl	memset
	mov	x1, x23
	add	x0, sp, 72
	mov	x2, 64
	mov	x19, -14
	bl	_copy_from_user
	cbnz	x0, .L274
	add	x0, sp, 72
	add	x1, x21, 1580
	add	x5, sp, 136
	b	.L291
	.p2align 2,,3
.L290:
	add	x0, x0, 8
	add	x1, x1, 16
	cmp	x5, x0
	beq	.L349
.L291:
	ldr	w2, [x0]
	cmp	w2, 0
	ble	.L290
	ldr	w3, [x0, 4]
	sub	w4, w3, #1
	cmp	w4, 254
	bhi	.L290
	stp	w2, w3, [x1]
	b	.L290
	.p2align 2,,3
.L347:
	ldr	w1, [sp, 28]
	mov	x19, 0
	and	w1, w1, 112
	cmp	w1, 32
	bne	.L278
	b	.L274
	.p2align 2,,3
.L294:
	ldr	x0, [x21, 520]
	add	x1, sp, 16
	bl	thermal_zone_get_temp
	ldr	w1, [sp, 16]
	mov	w0, 19923
	movk	w0, 0x1062, lsl 16
	smull	x0, w1, w0
	asr	x0, x0, 38
	sub	w1, w0, w1, asr 31
	str	w1, [sp, 16]
	b	.L295
	.p2align 2,,3
.L344:
	str	w0, [sp, 12]
	b	.L293
	.p2align 2,,3
.L296:
	cmp	w1, 0
	ble	.L298
	str	w1, [sp, 12]
	b	.L298
	.p2align 2,,3
.L349:
	mov	w0, 1
	mov	x19, 0
	strb	w0, [x21, 1648]
	b	.L274
	.p2align 2,,3
.L297:
	str	w2, [sp, 12]
	b	.L298
.L343:
	bl	__stack_chk_fail
.L348:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	bgt	.L350
.L283:
	mov	x19, -22
	b	.L274
.L284:
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L283
	ldp	w1, w2, [sp, 48]
	adrp	x0, .LC35
	ldp	w3, w4, [sp, 56]
	add	x0, x0, :lo12:.LC35
	mov	x19, -22
	bl	printk
	b	.L274
.L350:
	adrp	x0, .LC34
	mov	x19, -22
	add	x0, x0, :lo12:.LC34
	bl	printk
	b	.L274
.L345:
	ldr	w3, [sp, 12]
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printk
	b	.L299
.L346:
	mov	w2, w21
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	printk
	b	.L301
	.size	ebc_ioctl, .-ebc_ioctl
	.align	2
	.p2align 5,,15
	.type	temperature_read, %function
temperature_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4699
	.align	3
	.8byte	.LPFE4699
	.text
.LPFE4699:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x4, x2
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldr	x2, [x1, 1280]
	str	x2, [sp, 24]
	mov	x2, 0
	adrp	x1, ebc_temp_override
	str	wzr, [sp, 20]
	ldr	w3, [x1, #:lo12:ebc_temp_override]
	ldr	x0, [x0, 120]
	tbz	w3, #31, .L352
	add	x2, x0, 504
	str	x4, [sp]
	ldr	x0, [x0, 504]
	cbz	x0, .L353
	ldr	x2, [x0, 56]
	add	x1, sp, 20
	blr	x2
	ldr	w1, [sp, 20]
	ldr	x4, [sp]
.L354:
	adrp	x0, battery_ntc_temp
	mov	w2, 26215
	ldr	w0, [x0, #:lo12:battery_ntc_temp]
	movk	w2, 0x6666, lsl 16
	smull	x2, w0, w2
	asr	x2, x2, 34
	sub	w2, w2, w0, asr 31
	cmp	w0, 9
	ble	.L355
	mov	w3, w2
	cmp	w1, 0
	ble	.L356
	add	w0, w1, w1, lsl 2
	mov	w3, 75
	add	w0, w0, w0, lsl 2
	madd	w3, w2, w3, w0
	mov	w0, 34079
	movk	w0, 0x51eb, lsl 16
	smull	x0, w3, w0
	asr	x0, x0, 37
	sub	w3, w0, w3, asr 31
.L356:
	adrp	x5, .LANCHOR0
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L368
.L357:
	adrp	x0, ebc_tcor_percent
	ldr	w1, [x0, #:lo12:ebc_tcor_percent]
	cbz	w1, .L352
	adrp	x0, ebc_tcor_start
	mov	w2, w3
	ldr	w0, [x0, #:lo12:ebc_tcor_start]
	cmp	w0, w3
	bgt	.L358
	sub	w0, w3, w0
	mul	w0, w0, w1
	mov	w1, 34079
	movk	w1, 0x51eb, lsl 16
	umull	x0, w0, w1
	lsr	x0, x0, 37
	sub	w2, w3, w0
.L358:
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L369
	mov	w3, w2
.L352:
	mov	w2, w3
	mov	x0, x4
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	mrs	x1, sp_el0
	ldr	x3, [sp, 24]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L370
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L355:
	cmp	w1, 0
	csinv	w3, w1, wzr, gt
	b	.L356
	.p2align 2,,3
.L353:
	ldr	x0, [x2, 16]
	add	x1, sp, 20
	bl	thermal_zone_get_temp
	ldr	w1, [sp, 20]
	mov	w0, 19923
	movk	w0, 0x1062, lsl 16
	ldr	x4, [sp]
	smull	x0, w1, w0
	asr	x0, x0, 38
	sub	w1, w0, w1, asr 31
	str	w1, [sp, 20]
	b	.L354
.L370:
	bl	__stack_chk_fail
.L368:
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	str	w3, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	x4, [sp, 8]
	adrp	x5, .LANCHOR0
	ldr	w3, [sp]
	b	.L357
.L369:
	mov	w1, w3
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	str	w2, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	w2, [sp]
	ldr	x4, [sp, 8]
	mov	w3, w2
	b	.L352
	.size	temperature_read, .-temperature_read
	.align	2
	.p2align 5,,15
	.type	pmic_temp_read, %function
pmic_temp_read:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4689
	.align	3
	.8byte	.LPFE4689
	.text
.LPFE4689:
	nop
	nop
	sub	sp, sp, #48
	mrs	x1, sp_el0
	mov	x4, x2
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldr	x2, [x1, 1280]
	str	x2, [sp, 24]
	mov	x2, 0
	adrp	x1, ebc_temp_override
	str	wzr, [sp, 20]
	ldr	w3, [x1, #:lo12:ebc_temp_override]
	ldr	x0, [x0, 120]
	tbz	w3, #31, .L372
	add	x2, x0, 504
	str	x4, [sp]
	ldr	x0, [x0, 504]
	cbz	x0, .L373
	ldr	x2, [x0, 56]
	add	x1, sp, 20
	blr	x2
	ldr	w1, [sp, 20]
	ldr	x4, [sp]
.L374:
	adrp	x0, battery_ntc_temp
	mov	w2, 26215
	ldr	w0, [x0, #:lo12:battery_ntc_temp]
	movk	w2, 0x6666, lsl 16
	smull	x2, w0, w2
	asr	x2, x2, 34
	sub	w2, w2, w0, asr 31
	cmp	w0, 9
	ble	.L375
	mov	w3, w2
	cmp	w1, 0
	ble	.L376
	add	w0, w1, w1, lsl 2
	mov	w3, 75
	add	w0, w0, w0, lsl 2
	madd	w3, w2, w3, w0
	mov	w0, 34079
	movk	w0, 0x51eb, lsl 16
	smull	x0, w3, w0
	asr	x0, x0, 37
	sub	w3, w0, w3, asr 31
.L376:
	adrp	x5, .LANCHOR0
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L388
.L377:
	adrp	x0, ebc_tcor_percent
	ldr	w1, [x0, #:lo12:ebc_tcor_percent]
	cbz	w1, .L372
	adrp	x0, ebc_tcor_start
	mov	w2, w3
	ldr	w0, [x0, #:lo12:ebc_tcor_start]
	cmp	w0, w3
	bgt	.L378
	sub	w0, w3, w0
	mul	w0, w0, w1
	mov	w1, 34079
	movk	w1, 0x51eb, lsl 16
	umull	x0, w0, w1
	lsr	x0, x0, 37
	sub	w2, w3, w0
.L378:
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L389
	mov	w3, w2
.L372:
	mov	w2, w3
	mov	x0, x4
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	bl	sprintf
	sxtw	x0, w0
	mrs	x1, sp_el0
	ldr	x3, [sp, 24]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L390
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L375:
	bic	w3, w1, w1, asr #31
	b	.L376
	.p2align 2,,3
.L373:
	ldr	x0, [x2, 16]
	add	x1, sp, 20
	bl	thermal_zone_get_temp
	ldr	w1, [sp, 20]
	mov	w0, 19923
	movk	w0, 0x1062, lsl 16
	ldr	x4, [sp]
	smull	x0, w1, w0
	asr	x0, x0, 38
	sub	w1, w0, w1, asr 31
	str	w1, [sp, 20]
	b	.L374
.L390:
	bl	__stack_chk_fail
.L388:
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	str	w3, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	x4, [sp, 8]
	adrp	x5, .LANCHOR0
	ldr	w3, [sp]
	b	.L377
.L389:
	mov	w1, w3
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	str	w2, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	w2, [sp]
	ldr	x4, [sp, 8]
	mov	w3, w2
	b	.L372
	.size	pmic_temp_read, .-pmic_temp_read
	.section	.rodata.str1.8
	.align	3
.LC39:
	.string	"on"
	.align	3
.LC40:
	.string	"off"
	.align	3
.LC41:
	.string	"\0016EBC core  D power %s\n"
	.align	3
.LC42:
	.string	"\0016EBC core  D PMIC power enable\n"
	.align	3
.LC43:
	.string	"\0016EBC core  D VCOM enable\n"
	.align	3
.LC44:
	.string	"\0016EBC core  E pmic power on fail %d.\n"
	.align	3
.LC45:
	.string	"\0016EBC core  E tcon power on fail %d.\n"
	.align	3
.LC46:
	.string	"\0016EBC core  E tcon power off fail %d.\n"
	.align	3
.LC47:
	.string	"\0016EBC core  D PMIC power disable\n"
	.align	3
.LC48:
	.string	"\0016EBC core  D VCOM disable\n"
	.align	3
.LC49:
	.string	"\0016EBC core  E pmic power off fail %d.\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_power_set
	.type	ebc_power_set, %function
ebc_power_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4672
	.align	3
	.8byte	.LPFE4672
	.text
.LPFE4672:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x0, 160]
	cmp	w0, w1
	beq	.L414
	str	x21, [sp, 32]
	adrp	x21, .LANCHOR0
	mov	w20, w1
	ldr	w0, [x21, #:lo12:.LANCHOR0]
	ldr	x2, [x19, 528]
	cmp	w0, 2
	bgt	.L417
.L393:
	cmp	w20, 1
	beq	.L418
	ldr	x0, [x2, 8]
	ldr	x1, [x0, 8]
	mov	x0, x2
	blr	x1
	tbnz	w0, #31, .L419
.L405:
	ldr	x0, [x19, 504]
	cbz	x0, .L407
	ldr	w1, [x21, #:lo12:.LANCHOR0]
	cmp	w1, 2
	bgt	.L420
.L408:
	ldr	x2, [x0, 32]
	mov	w1, 0
	blr	x2
.L409:
	mov	w1, 0
.L403:
	str	w20, [x19, 160]
	mov	w0, w1
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L419:
	ldr	w1, [x21, #:lo12:.LANCHOR0]
	cmp	w1, 0
	bgt	.L421
	ldr	x0, [x19, 504]
	cbnz	x0, .L408
	adrp	x1, .LANCHOR2
	add	x1, x1, :lo12:.LANCHOR2
	ldrb	w0, [x1, 16]
	tbz	x0, 0, .L409
.L411:
	ldr	x0, [x19, 512]
	strb	wzr, [x1, 16]
	bl	regulator_disable
	mov	w1, w0
	tbz	w0, #31, .L403
	ldr	w0, [x21, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L403
	adrp	x0, .LC49
	add	x0, x0, :lo12:.LC49
	str	w1, [sp, 48]
	bl	printk
	ldr	w1, [sp, 48]
	b	.L403
	.p2align 2,,3
.L414:
	ldp	x19, x20, [sp, 16]
	mov	w1, 0
	ldp	x29, x30, [sp], 64
	mov	w0, w1
	ret
	.p2align 2,,3
.L407:
	adrp	x1, .LANCHOR2
	add	x1, x1, :lo12:.LANCHOR2
	ldrb	w0, [x1, 16]
	tbz	x0, 0, .L409
	ldr	w0, [x21, #:lo12:.LANCHOR0]
	cmp	w0, 2
	ble	.L411
	adrp	x0, .LC48
	add	x0, x0, :lo12:.LC48
	str	x1, [sp, 48]
	bl	printk
	ldr	x1, [sp, 48]
	b	.L411
	.p2align 2,,3
.L418:
	ldr	x0, [x19, 504]
	cbz	x0, .L396
	ldr	w1, [x21, #:lo12:.LANCHOR0]
	cmp	w1, 2
	bgt	.L422
.L397:
	ldr	x3, [x0, 32]
	mov	w1, 1
	str	x2, [sp, 48]
	blr	x3
	ldr	x2, [sp, 48]
.L398:
	ldr	x0, [x2, 8]
	ldr	x1, [x0]
	mov	x0, x2
	blr	x1
	mov	w1, w0
	tbz	w0, #31, .L403
	ldr	w0, [x21, #:lo12:.LANCHOR0]
	cmp	w0, 0
	ble	.L403
	adrp	x0, .LC45
	add	x0, x0, :lo12:.LC45
	str	w1, [sp, 48]
	bl	printk
	ldr	w1, [sp, 48]
	b	.L403
	.p2align 2,,3
.L396:
	adrp	x1, .LANCHOR2
	add	x1, x1, :lo12:.LANCHOR2
	ldrb	w0, [x1, 16]
	tbnz	x0, 0, .L398
	ldr	w0, [x21, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L423
.L400:
	mov	w0, 1
	strb	w0, [x1, 16]
	ldr	x0, [x19, 512]
	str	x2, [sp, 48]
	bl	regulator_enable
	ldr	x2, [sp, 48]
	tbz	w0, #31, .L398
	ldr	w3, [x21, #:lo12:.LANCHOR0]
	cmp	w3, 0
	ble	.L398
	mov	w1, w0
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	bl	printk
	ldr	x2, [sp, 48]
	b	.L398
.L423:
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
	stp	x2, x1, [sp, 48]
	bl	printk
	ldp	x2, x1, [sp, 48]
	b	.L400
.L422:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	str	x2, [sp, 48]
	bl	printk
	ldr	x2, [sp, 48]
	ldr	x0, [x19, 504]
	b	.L397
.L420:
	adrp	x0, .LC47
	add	x0, x0, :lo12:.LC47
	bl	printk
	ldr	x0, [x19, 504]
	b	.L408
.L421:
	mov	w1, w0
	adrp	x0, .LC46
	add	x0, x0, :lo12:.LC46
	bl	printk
	b	.L405
.L417:
	cmp	w20, 1
	adrp	x0, .LC39
	adrp	x1, .LC40
	add	x0, x0, :lo12:.LC39
	add	x1, x1, :lo12:.LC40
	str	x2, [sp, 48]
	csel	x1, x1, x0, ne
	adrp	x0, .LC41
	add	x0, x0, :lo12:.LC41
	bl	printk
	ldr	x2, [sp, 48]
	b	.L393
	.size	ebc_power_set, .-ebc_power_set
	.align	2
	.p2align 5,,15
	.type	ebc_poweroff_worker, %function
ebc_poweroff_worker:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	w1, 0
	sub	x0, x0, #256
	mov	x29, sp
	bl	ebc_power_set
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_poweroff_worker, .-ebc_poweroff_worker
	.section	.rodata.str1.8
	.align	3
.LC50:
	.string	"\0016EBC core  D suspend\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_suspend, %function
ebc_suspend:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4678
	.align	3
	.8byte	.LPFE4678
	.text
.LPFE4678:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	ldr	x19, [x0, 120]
	adrp	x0, .LANCHOR0
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L433
.L427:
	add	x0, x19, 256
	bl	cancel_delayed_work_sync
	add	x0, x19, 536
	bl	ebc_mm_suspend
	mov	x0, x19
	bl	wffpu_suspend
	add	x0, x19, 256
	bl	cancel_delayed_work_sync
	mov	x0, x19
	mov	w1, 0
	bl	ebc_power_set
	ldr	x0, [x19, 504]
	cbz	x0, .L428
	ldr	x1, [x0, 40]
	blr	x1
.L428:
	mov	x0, 2
	bl	ebc_notify
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L433:
	adrp	x0, .LC50
	add	x0, x0, :lo12:.LC50
	bl	printk
	b	.L427
	.size	ebc_suspend, .-ebc_suspend
	.align	2
	.p2align 5,,15
	.global	ebc_power_on
	.type	ebc_power_on, %function
ebc_power_on:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	add	x0, x0, 256
	bl	cancel_delayed_work_sync
	mov	x0, x19
	mov	w1, 1
	bl	ebc_power_set
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_power_on, .-ebc_power_on
	.align	2
	.p2align 5,,15
	.global	ebc_power_off
	.type	ebc_power_off, %function
ebc_power_off:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	add	x0, x0, 256
	bl	cancel_delayed_work_sync
	mov	x0, x19
	mov	w1, 0
	bl	ebc_power_set
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_power_off, .-ebc_power_off
	.section	.rodata.str1.8
	.align	3
.LC51:
	.string	"\0016EBC core  D power-off later %d ms\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_power_later_off
	.type	ebc_power_later_off, %function
ebc_power_later_off:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x2, x0
	adrp	x0, .LANCHOR0
	mov	x29, sp
	ldr	w0, [x0, #:lo12:.LANCHOR0]
	str	x19, [sp, 16]
	mov	w19, w1
	cmp	w0, 2
	bgt	.L441
.L439:
	add	x2, x2, 256
	str	x2, [sp, 40]
	mov	x0, x2
	bl	cancel_delayed_work_sync
	mov	w0, w19
	bl	__msecs_to_jiffies
	mov	x3, x0
	adrp	x0, system_wq
	ldr	x2, [sp, 40]
	ldr	x1, [x0, #:lo12:system_wq]
	mov	w0, 8
	bl	queue_delayed_work_on
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	ret
.L441:
	adrp	x0, .LC51
	add	x0, x0, :lo12:.LC51
	str	x2, [sp, 40]
	bl	printk
	ldr	x2, [sp, 40]
	b	.L439
	.size	ebc_power_later_off, .-ebc_power_later_off
	.align	2
	.p2align 5,,15
	.global	ebc_update_wf_lut
	.type	ebc_update_wf_lut, %function
ebc_update_wf_lut:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4680
	.align	3
	.8byte	.LPFE4680
	.text
.LPFE4680:
	nop
	nop
	sub	sp, sp, #48
	mov	x2, x0
	mrs	x1, sp_el0
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	ldr	x0, [x1, 1280]
	str	x0, [sp, 24]
	mov	x0, 0
	ldrb	w1, [x2, 1648]
	tbz	x1, 0, .L461
.L442:
	mrs	x1, sp_el0
	ldr	x3, [sp, 24]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L462
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L461:
	adrp	x0, ebc_temp_override
	str	wzr, [sp, 20]
	add	x4, x2, 1512
	ldr	w3, [x0, #:lo12:ebc_temp_override]
	tbz	w3, #31, .L444
	ldr	x0, [x2, 504]
	str	x4, [sp]
	cbz	x0, .L445
	ldr	x2, [x0, 56]
	add	x1, sp, 20
	blr	x2
	ldr	w1, [sp, 20]
	ldr	x4, [sp]
.L446:
	adrp	x0, battery_ntc_temp
	mov	w2, 26215
	ldr	w0, [x0, #:lo12:battery_ntc_temp]
	movk	w2, 0x6666, lsl 16
	smull	x2, w0, w2
	asr	x2, x2, 34
	sub	w2, w2, w0, asr 31
	cmp	w0, 9
	bgt	.L463
	cmp	w1, 0
	mov	w3, 25
	csel	w3, w1, w3, gt
.L448:
	adrp	x5, .LANCHOR0
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L464
.L449:
	adrp	x0, ebc_tcor_percent
	ldr	w1, [x0, #:lo12:ebc_tcor_percent]
	cbz	w1, .L444
	adrp	x0, ebc_tcor_start
	mov	w2, w3
	ldr	w0, [x0, #:lo12:ebc_tcor_start]
	cmp	w0, w3
	bgt	.L450
	sub	w0, w3, w0
	mul	w0, w0, w1
	mov	w1, 34079
	movk	w1, 0x51eb, lsl 16
	umull	x0, w0, w1
	lsr	x0, x0, 37
	sub	w2, w3, w0
.L450:
	ldr	w0, [x5, #:lo12:.LANCHOR0]
	cmp	w0, 2
	bgt	.L465
	mov	w3, w2
.L444:
	mov	w1, w3
	mov	x0, x4
	bl	wf_load_luts
	b	.L442
	.p2align 2,,3
.L463:
	mov	w3, w2
	cmp	w1, 0
	ble	.L448
	add	w0, w1, w1, lsl 2
	mov	w3, 75
	add	w0, w0, w0, lsl 2
	madd	w3, w2, w3, w0
	mov	w0, 34079
	movk	w0, 0x51eb, lsl 16
	smull	x0, w3, w0
	asr	x0, x0, 37
	sub	w3, w0, w3, asr 31
	b	.L448
	.p2align 2,,3
.L445:
	ldr	x0, [x2, 520]
	add	x1, sp, 20
	bl	thermal_zone_get_temp
	ldr	w1, [sp, 20]
	mov	w0, 19923
	movk	w0, 0x1062, lsl 16
	ldr	x4, [sp]
	smull	x0, w1, w0
	asr	x0, x0, 38
	sub	w1, w0, w1, asr 31
	str	w1, [sp, 20]
	b	.L446
.L462:
	bl	__stack_chk_fail
.L465:
	mov	w1, w3
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	str	w2, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	w2, [sp]
	ldr	x4, [sp, 8]
	mov	w3, w2
	b	.L444
.L464:
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	str	w3, [sp]
	str	x4, [sp, 8]
	bl	printk
	ldr	x4, [sp, 8]
	adrp	x5, .LANCHOR0
	ldr	w3, [sp]
	b	.L449
	.size	ebc_update_wf_lut, .-ebc_update_wf_lut
	.section	.init.text,"ax",@progbits
	.align	2
	.type	ebc_init, %function
ebc_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4718
	.align	3
	.8byte	.LPFE4718
	.section	.init.text
.LPFE4718:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	pmic_init
	cbnz	w0, .L466
	bl	tcon_init
	cbnz	w0, .L466
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	adrp	x1, __this_module
	add	x0, x0, 600
	add	x1, x1, :lo12:__this_module
	bl	__platform_driver_register
.L466:
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_init, .-ebc_init
	.global	init_module
	.set	init_module,ebc_init
	.section	.exit.text,"ax",@progbits
	.align	2
	.type	ebc_exit, %function
ebc_exit:
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	add	x0, x0, 600
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	platform_driver_unregister
	bl	tcon_deinit
	bl	pmic_deinit
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_exit, .-ebc_exit
	.global	cleanup_module
	.set	cleanup_module,ebc_exit
	.section	.rodata.str1.8
	.align	3
.LC52:
	.string	"ebc-linux"
	.global	__mod_of__ebc_match_device_table
	.set	__mod_of__ebc_match_device_table,ebc_match
	.align	3
.LC53:
	.string	"pixel_monitor"
	.align	3
.LC54:
	.string	"slow_motion"
	.align	3
.LC55:
	.string	"line_event"
	.align	3
.LC56:
	.string	"spell"
	.align	3
.LC57:
	.string	"-a2in"
	.align	3
.LC58:
	.string	"transition"
	.align	3
.LC59:
	.string	"direction max_delay"
	.align	3
.LC60:
	.string	"num_circles max_delay deviation fadeout"
	.align	3
.LC61:
	.string	"max_delay"
	.align	3
.LC62:
	.string	"temp_correction"
	.align	3
.LC63:
	.string	"temperature"
	.align	3
.LC64:
	.string	"dump_waveform"
	.align	3
.LC65:
	.string	"dump_updates"
	.align	3
.LC66:
	.string	"debuglevel"
	.align	3
.LC67:
	.string	"ebc_state"
	.align	3
.LC68:
	.string	"ebc_version"
	.align	3
.LC69:
	.string	"pmic_vcom"
	.align	3
.LC70:
	.string	"pmic_temp"
	.align	3
.LC71:
	.string	"pmic_name"
	.align	3
.LC72:
	.string	"waveform_name"
	.align	3
.LC73:
	.string	"ebc"
	.global	g_ebc
	.global	active_spells
	.global	ebc_loglevel
	.section	.rodata
	.align	3
	.set	.LANCHOR1,. + 0
	.type	spells, %object
	.size	spells, 48
spells:
	.xword	.LC7
	.word	1
	.zero	4
	.xword	.LC57
	.word	2
	.zero	4
	.xword	0
	.zero	8
	.type	transitions, %object
	.size	transitions, 120
transitions:
	.xword	.LC16
	.xword	.LC59
	.word	0
	.word	0
	.word	10
	.word	7
	.word	3
	.zero	4
	.xword	.LC17
	.xword	.LC60
	.word	1
	.word	6
	.word	50
	.word	10
	.word	70
	.zero	4
	.xword	.LC18
	.xword	.LC61
	.word	2
	.word	30
	.zero	12
	.zero	4
	.type	ebc_match, %object
	.size	ebc_match, 600
ebc_match:
	.zero	64
	.string	"rockchip,ebc"
	.zero	115
	.zero	8
	.zero	64
	.string	"rockchip,ebc-linux"
	.zero	109
	.zero	8
	.zero	200
	.type	ebc_pm, %object
	.size	ebc_pm, 184
ebc_pm:
	.zero	16
	.xword	ebc_suspend
	.xword	ebc_resume
	.zero	152
	.type	ebc_ops, %object
	.size	ebc_ops, 256
ebc_ops:
	.xword	__this_module
	.zero	8
	.xword	ebc_read
	.xword	ebc_write
	.zero	48
	.xword	ebc_ioctl
	.xword	ebc_ioctl
	.zero	16
	.xword	ebc_open
	.zero	8
	.xword	ebc_release
	.zero	120
	.data
	.align	3
	.set	.LANCHOR0,. + 0
	.type	ebc_loglevel, %object
	.size	ebc_loglevel, 4
ebc_loglevel:
	.word	3
	.zero	4
	.type	ebc_misc, %object
	.size	ebc_misc, 80
ebc_misc:
	.word	243
	.zero	4
	.xword	.LC73
	.xword	ebc_ops
	.zero	56
	.type	dev_attr_waveform_name, %object
	.size	dev_attr_waveform_name, 32
dev_attr_waveform_name:
	.xword	.LC72
	.hword	292
	.zero	6
	.xword	waveform_name_read
	.xword	0
	.type	dev_attr_pmic_name, %object
	.size	dev_attr_pmic_name, 32
dev_attr_pmic_name:
	.xword	.LC71
	.hword	292
	.zero	6
	.xword	pmic_name_read
	.xword	0
	.type	dev_attr_pmic_temp, %object
	.size	dev_attr_pmic_temp, 32
dev_attr_pmic_temp:
	.xword	.LC70
	.hword	292
	.zero	6
	.xword	pmic_temp_read
	.xword	0
	.type	dev_attr_pmic_vcom, %object
	.size	dev_attr_pmic_vcom, 32
dev_attr_pmic_vcom:
	.xword	.LC69
	.hword	420
	.zero	6
	.xword	pmic_vcom_read
	.xword	pmic_vcom_write
	.type	dev_attr_ebc_version, %object
	.size	dev_attr_ebc_version, 32
dev_attr_ebc_version:
	.xword	.LC68
	.hword	292
	.zero	6
	.xword	ebc_version_read
	.xword	0
	.type	dev_attr_ebc_state, %object
	.size	dev_attr_ebc_state, 32
dev_attr_ebc_state:
	.xword	.LC67
	.hword	292
	.zero	6
	.xword	ebc_state_read
	.xword	0
	.type	dev_attr_transition, %object
	.size	dev_attr_transition, 32
dev_attr_transition:
	.xword	.LC58
	.hword	420
	.zero	6
	.xword	transition_read
	.xword	transition_write
	.type	dev_attr_debuglevel, %object
	.size	dev_attr_debuglevel, 32
dev_attr_debuglevel:
	.xword	.LC66
	.hword	420
	.zero	6
	.xword	debuglevel_read
	.xword	debuglevel_write
	.type	dev_attr_dump_updates, %object
	.size	dev_attr_dump_updates, 32
dev_attr_dump_updates:
	.xword	.LC65
	.hword	420
	.zero	6
	.xword	dump_updates_read
	.xword	dump_updates_write
	.type	dev_attr_dump_waveform, %object
	.size	dev_attr_dump_waveform, 32
dev_attr_dump_waveform:
	.xword	.LC64
	.hword	128
	.zero	6
	.xword	0
	.xword	dump_waveform_write
	.type	dev_attr_temperature, %object
	.size	dev_attr_temperature, 32
dev_attr_temperature:
	.xword	.LC63
	.hword	420
	.zero	6
	.xword	temperature_read
	.xword	temperature_write
	.type	dev_attr_temp_correction, %object
	.size	dev_attr_temp_correction, 32
dev_attr_temp_correction:
	.xword	.LC62
	.hword	420
	.zero	6
	.xword	temp_correction_read
	.xword	temp_correction_write
	.type	dev_attr_spell, %object
	.size	dev_attr_spell, 32
dev_attr_spell:
	.xword	.LC56
	.hword	420
	.zero	6
	.xword	spell_read
	.xword	spell_write
	.type	dev_attr_line_event, %object
	.size	dev_attr_line_event, 32
dev_attr_line_event:
	.xword	.LC55
	.hword	420
	.zero	6
	.xword	line_event_read
	.xword	line_event_write
	.type	dev_attr_slow_motion, %object
	.size	dev_attr_slow_motion, 32
dev_attr_slow_motion:
	.xword	.LC54
	.hword	420
	.zero	6
	.xword	slow_motion_read
	.xword	slow_motion_write
	.type	dev_attr_pixel_monitor, %object
	.size	dev_attr_pixel_monitor, 32
dev_attr_pixel_monitor:
	.xword	.LC53
	.hword	420
	.zero	6
	.xword	pixel_monitor_read
	.xword	pixel_monitor_write
	.type	ebc_driver, %object
	.size	ebc_driver, 200
ebc_driver:
	.xword	ebc_probe
	.xword	ebc_remove
	.zero	24
	.xword	.LC52
	.zero	32
	.xword	ebc_match
	.zero	72
	.xword	ebc_pm
	.zero	16
	.zero	16
	.bss
	.align	3
	.set	.LANCHOR2,. + 0
	.type	active_spells, %object
	.size	active_spells, 4
active_spells:
	.zero	4
	.zero	4
	.type	g_ebc, %object
	.size	g_ebc, 8
g_ebc:
	.zero	8
	.type	vcom_enabled, %object
	.size	vcom_enabled, 1
vcom_enabled:
	.zero	1
	.section	.modinfo,"a"
	.type	__UNIQUE_ID_alias388, %object
	.size	__UNIQUE_ID_alias388, 22
__UNIQUE_ID_alias388:
	.string	"alias=platform:rk_ebc"
	.type	__UNIQUE_ID_license387, %object
	.size	__UNIQUE_ID_license387, 12
__UNIQUE_ID_license387:
	.string	"license=GPL"
	.type	__UNIQUE_ID_description386, %object
	.size	__UNIQUE_ID_description386, 40
__UNIQUE_ID_description386:
	.string	"description=Rockchip E-Book Core Driver"
	.type	__UNIQUE_ID_author385, %object
	.size	__UNIQUE_ID_author385, 32
__UNIQUE_ID_author385:
	.string	"author=CMY <cmy@rock-chips.com>"
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
