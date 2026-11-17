// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_wffpu.c"
	.text
	.align	2
	.p2align 5,,15
	.type	check_incremental, %function
check_incremental:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4678
	.align	3
	.8byte	.LPFE4678
	.text
.LPFE4678:
	nop
	nop
	ldr	w2, [x1, 28]
	mov	w3, 0
	and	w2, w2, 112
	sub	w2, w2, #16
	tst	w2, -32
	bne	.L2
	ldr	w2, [x0, 8]
	mov	w3, 0
	ldr	w4, [x1, 80]
	add	w2, w2, w2, lsr 31
	cmp	w4, w2, asr 1
	bgt	.L2
	ldr	w0, [x0, 12]
	ldr	w1, [x1, 84]
	add	w0, w0, w0, lsr 31
	cmp	w1, w0, asr 1
	cset	w3, le
.L2:
	mov	w0, w3
	ret
	.size	check_incremental, .-check_incremental
	.align	2
	.p2align 5,,15
	.type	wffpu_frame_thread, %function
wffpu_frame_thread:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	sub	sp, sp, #112
	stp	x29, x30, [sp, 48]
	add	x29, sp, 48
	stp	x19, x20, [sp, 64]
	mov	x19, x0
	adrp	x20, .LANCHOR0
	mrs	x0, sp_el0
	add	x20, x20, :lo12:.LANCHOR0
	ldr	x1, [x0, 1280]
	str	x1, [sp, 40]
	mov	x1, 0
	add	x20, x20, 24
	b	.L7
	.p2align 2,,3
.L9:
	bl	kthread_should_stop
	tbnz	x0, 0, .L15
.L14:
	ldr	x1, [x19, 104]
	add	x2, x19, 68
	mov	x0, x19
	mov	w3, 2
	bl	wffpu_make_frame
	str	xzr, [x19, 104]
	mov	w2, 1
	mov	x0, x20
	mov	w1, w2
	mov	x3, 0
	bl	__wake_up
.L7:
	bl	kthread_should_stop
	tbnz	x0, 0, .L15
	bl	_cond_resched
	ldr	x0, [x19, 104]
	cbnz	x0, .L9
	bl	kthread_should_stop
	tbnz	x0, 0, .L9
	mov	x0, sp
	mov	w1, 0
	stp	xzr, xzr, [sp]
	stp	xzr, xzr, [sp, 16]
	str	xzr, [sp, 32]
	stp	x21, x22, [sp, 80]
	str	x23, [sp, 96]
	adrp	x23, .LANCHOR0
	bl	init_wait_entry
	add	x23, x23, :lo12:.LANCHOR0
	b	.L13
	.p2align 2,,3
.L22:
	bl	kthread_should_stop
	tbnz	x0, 0, .L11
	cbnz	x21, .L21
	bl	schedule
.L13:
	mov	x1, sp
	mov	x0, x23
	mov	w2, 1
	bl	prepare_to_wait_event
	mov	x21, x0
	ldr	x0, [x19, 104]
	cbz	x0, .L22
.L11:
	mov	x0, x23
	mov	x1, sp
	bl	finish_wait
	ldr	x23, [sp, 96]
	ldp	x21, x22, [sp, 80]
	bl	kthread_should_stop
	tbz	x0, 0, .L14
	.p2align 5,,15
.L15:
	mrs	x0, sp_el0
	ldr	x2, [sp, 40]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L23
	ldp	x29, x30, [sp, 48]
	mov	w0, 0
	ldp	x19, x20, [sp, 64]
	add	sp, sp, 112
	ret
.L12:
.L21:
	ldr	x23, [sp, 96]
	ldp	x21, x22, [sp, 80]
	b	.L9
.L23:
	stp	x21, x22, [sp, 80]
	str	x23, [sp, 96]
	bl	__stack_chk_fail
	.size	wffpu_frame_thread, .-wffpu_frame_thread
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC wffpu T #%d index processing started\n"
	.align	3
.LC1:
	.string	"\0016EBC wffpu D #%d index: %d areas %s.%s, %d pixels processed in %d us\n"
	.text
	.align	2
	.p2align 5,,15
	.type	wffpu_index_thread, %function
wffpu_index_thread:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	sub	sp, sp, #160
	stp	x29, x30, [sp, 64]
	add	x29, sp, 64
	stp	x19, x20, [sp, 80]
	mov	x19, x0
	mrs	x0, sp_el0
	stp	x21, x22, [sp, 96]
	stp	x23, x24, [sp, 112]
	add	x23, x19, 176
	stp	x25, x26, [sp, 128]
	stp	x27, x28, [sp, 144]
	adrp	x27, ebc_loglevel
	ldr	x1, [x0, 1280]
	str	x1, [sp, 56]
	mov	x1, 0
	b	.L25
	.p2align 2,,3
.L34:
	add	x0, x19, 176
	mov	w1, 2147483647
#APP
// 124 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu.c" 1
	stlr w1, [x0]
// 0 "" 2
#NO_APP
	mov	x1, x28
	add	x0, x19, 536
	bl	ebc_mm_release_buffer
	mov	x1, x24
	add	x0, x19, 536
	bl	ebc_mm_release_tmask
.L25:
	bl	kthread_should_stop
	tbnz	x0, 0, .L41
	bl	_cond_resched
	ldr	x0, [x19, 88]
	cbz	x0, .L52
.L30:
.L27:
	bl	kthread_should_stop
	tbnz	x0, 0, .L41
.L32:
	ldp	x28, x24, [x19, 88]
	stp	xzr, xzr, [x19, 88]
	ldr	w0, [x28, 96]
	cmp	w0, 0
	ble	.L34
	ldr	x22, [x28, 40]
	mov	x21, 0
	cbz	x24, .L35
	ldr	x21, [x24, 40]
.L35:
	bl	ktime_get
	str	x0, [sp, 8]
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	cmp	w0, 3
	bgt	.L53
.L36:
	ldr	w0, [x28, 96]
	cmp	w0, 0
	ble	.L45
	ldr	x3, [x28, 88]
	mov	x26, 0
	mov	w20, 0
	.p2align 5,,15
.L39:
	sub	w0, w0, #1
	ldr	w4, [x28, 28]
	cmp	w0, w26
	add	x3, x3, x26, lsl 4
	mov	x1, x22
	csel	x5, x23, xzr, eq
	mov	x2, x21
	mov	x0, x19
	bl	wffpu_make_index
	ldr	x3, [x28, 88]
	add	x0, x3, x26, lsl 4
	add	x26, x26, 1
	ldp	w1, w0, [x0, 8]
	madd	w20, w1, w0, w20
	ldr	w0, [x28, 96]
	cmp	w0, w26
	bgt	.L39
	bl	ktime_get
	mov	x21, x0
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L34
.L56:
	mov	x0, x19
	bl	tcon_get_current_line
	ldr	x1, [sp, 8]
	mov	x4, 63439
	movk	x4, 0xe353, lsl 16
	lsr	x6, x21, 3
	movk	x4, 0x9ba5, lsl 32
	ldr	w3, [x28, 28]
	lsr	x2, x1, 3
	movk	x4, 0x20c4, lsl 48
	and	w1, w3, 3
	adrp	x5, wf_mode_strings
	umulh	x6, x6, x4
	add	x5, x5, :lo12:wf_mode_strings
	umulh	x2, x2, x4
	ubfx	x3, x3, 4, 3
	adrp	x4, wf_qual_strings
	add	x4, x4, :lo12:wf_qual_strings
	lsr	x6, x6, 4
	lsr	x2, x2, 4
	ldr	x4, [x4, w1, sxtw 3]
	sub	w6, w6, w2
	ldr	x3, [x5, w3, sxtw 3]
	mov	w1, w0
	ldr	w2, [x28, 96]
	mov	w5, w20
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printk
	b	.L34
	.p2align 2,,3
.L52:
	bl	kthread_should_stop
	tbnz	x0, 0, .L27
	adrp	x22, .LANCHOR0
	add	x22, x22, :lo12:.LANCHOR0
	add	x0, sp, 16
	add	x21, x22, 48
	mov	w1, 0
	stp	xzr, xzr, [sp, 16]
	stp	xzr, xzr, [sp, 32]
	str	xzr, [sp, 48]
	bl	init_wait_entry
	b	.L31
	.p2align 2,,3
.L54:
	bl	kthread_should_stop
	tbnz	x0, 0, .L29
	cbnz	x20, .L27
	bl	schedule
.L31:
	add	x1, sp, 16
	mov	x0, x21
	mov	w2, 1
	bl	prepare_to_wait_event
	mov	x20, x0
	ldr	x0, [x19, 88]
	cbz	x0, .L54
.L29:
	add	x1, sp, 16
	add	x0, x22, 48
	bl	finish_wait
	bl	kthread_should_stop
	tbz	x0, 0, .L32
	.p2align 5,,15
.L41:
	mrs	x0, sp_el0
	ldr	x2, [sp, 56]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L55
	ldp	x29, x30, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 80]
	ldp	x21, x22, [sp, 96]
	ldp	x23, x24, [sp, 112]
	ldp	x25, x26, [sp, 128]
	ldp	x27, x28, [sp, 144]
	add	sp, sp, 160
	ret
	.p2align 2,,3
.L45:
	bl	ktime_get
	mov	x21, x0
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	mov	w20, 0
	cmp	w0, 2
	ble	.L34
	b	.L56
.L55:
	bl	__stack_chk_fail
.L53:
	mov	x0, x19
	bl	tcon_get_current_line
	mov	w1, w0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L36
	.size	wffpu_index_thread, .-wffpu_index_thread
	.section	.rodata.str1.8
	.align	3
.LC2:
	.string	"/MT"
	.align	3
.LC3:
	.string	""
	.align	3
.LC4:
	.string	"\0016EBC wffpu T #%d %c%s start frame processing [%d,%d,%d,%d] T%d %04x:%u:%u:%u:%u %c\n"
	.align	3
.LC5:
	.string	"\0016EBC wffpu E frame processing error: timeout\n"
	.align	3
.LC6:
	.string	"\0016EBC wffpu T #%d frame %3d  %d pixels generated in %d us\n"
	.text
	.align	2
	.p2align 5,,15
	.type	generate_next_frame, %function
generate_next_frame:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4677
	.align	3
	.8byte	.LPFE4677
	.text
.LPFE4677:
	nop
	nop
	sub	sp, sp, #240
	stp	x29, x30, [sp, 144]
	add	x29, sp, 144
	stp	x21, x22, [sp, 176]
	mov	x21, x1
	stp	x19, x20, [sp, 160]
	mov	x19, x0
	mrs	x0, sp_el0
	stp	x23, x24, [sp, 192]
	add	x24, x19, 52
	and	w20, w2, 255
	str	x27, [sp, 224]
	adrp	x23, ebc_loglevel
	mov	x27, 0
	ldr	x1, [x0, 1280]
	str	x1, [sp, 136]
	mov	x1, 0
	mov	w0, 1
	strb	w0, [x21, 104]
	ldp	x0, x1, [x24]
	stp	x0, x1, [sp, 80]
	add	x1, x19, 36
	add	x0, sp, 80
	bl	area_join
	ldp	x0, x1, [sp, 80]
	stp	x0, x1, [x21, 72]
	ldp	w22, w0, [sp, 88]
	mul	w22, w22, w0
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 3
	bgt	.L82
.L59:
	mov	w0, 16959
	movk	w0, 0xf, lsl 16
	cmp	w22, w0
	ble	.L63
	stp	x25, x26, [sp, 208]
	adrp	x26, .LANCHOR0
	add	x26, x26, :lo12:.LANCHOR0
	str	x21, [x19, 104]
	mov	w2, 1
	mov	x0, x26
	mov	w1, w2
	mov	x3, 0
	bl	__wake_up
	mov	x1, x21
	add	x2, sp, 80
	mov	w3, 1
	mov	x0, x19
	bl	wffpu_make_frame
	bl	_cond_resched
	ldr	x0, [x19, 104]
	cbz	x0, .L65
	add	x0, sp, 96
	add	x25, x26, 24
	mov	w1, 0
	mov	x20, 15
	stp	xzr, xzr, [sp, 96]
	stp	xzr, xzr, [sp, 112]
	str	xzr, [sp, 128]
	bl	init_wait_entry
	b	.L68
	.p2align 2,,3
.L83:
	cmp	x20, 0
	ccmp	x0, 0, 4, ne
	beq	.L77
	cbnz	x2, .L67
	mov	x0, x20
	bl	schedule_timeout
	mov	x20, x0
.L68:
	add	x1, sp, 96
	mov	w2, 1
	mov	x0, x25
	bl	prepare_to_wait_event
	mov	x2, x0
	ldr	x0, [x19, 104]
	orr	x1, x0, x20
	cbnz	x1, .L83
	mov	x2, 1
.L66:
	add	x1, sp, 96
	add	x0, x26, 24
	str	x2, [sp, 72]
	bl	finish_wait
	ldr	x2, [sp, 72]
.L67:
	cmp	x2, 0
	ble	.L84
.L65:
	add	x1, x19, 68
	add	x0, sp, 80
	bl	area_join
	ldp	x0, x1, [sp, 80]
	ldp	x25, x26, [sp, 208]
	stp	x0, x1, [x24]
	mov	w0, 1
	strb	w0, [x21, 105]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 3
	ble	.L72
.L85:
	bl	ktime_get
	mov	x20, x0
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 3
	ble	.L72
	mov	x0, x19
	bl	tcon_get_current_line
	mov	x1, 1000
	ldr	w2, [x19, 32]
	mov	w3, w22
	udiv	x4, x20, x1
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	sub	w4, w4, w27
	bl	printk
	b	.L72
	.p2align 2,,3
.L63:
	mov	x1, x21
	add	x2, sp, 80
	mov	x0, x19
	mov	w3, 3
	bl	wffpu_make_frame
	ldp	x0, x1, [sp, 80]
	stp	x0, x1, [x24]
	mov	w0, 1
	strb	w0, [x21, 105]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 3
	bgt	.L85
.L72:
	ldr	x0, [x19, 24]
	add	x0, x0, 1024
	str	x0, [x19, 24]
	ldr	w0, [x19, 32]
	add	w0, w0, 1
	str	w0, [x19, 32]
	mrs	x0, sp_el0
	ldr	x2, [sp, 136]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L86
	ldr	x27, [sp, 224]
	ldp	x29, x30, [sp, 144]
	ldp	x19, x20, [sp, 160]
	ldp	x21, x22, [sp, 176]
	ldp	x23, x24, [sp, 192]
	add	sp, sp, 240
	ret
	.p2align 2,,3
.L82:
	add	x0, x19, 536
	bl	ebc_mm_get_indexmap
	ldr	w2, [x19, 20]
	ldr	w1, [x19, 376]
	cbnz	w2, .L87
.L60:
	ldr	w2, [x23, #:lo12:ebc_loglevel]
	cmp	w2, 3
	bgt	.L88
.L61:
	bl	ktime_get
	lsr	x0, x0, 3
	mov	x1, 63439
	movk	x1, 0xe353, lsl 16
	movk	x1, 0x9ba5, lsl 32
	movk	x1, 0x20c4, lsl 48
	umulh	x0, x0, x1
	lsr	x27, x0, 4
	b	.L59
	.p2align 2,,3
.L87:
	ldr	w2, [x19, 12]
	sub	w2, w2, #1
	sub	w1, w2, w1
	b	.L60
	.p2align 2,,3
.L84:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L65
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printk
	b	.L65
	.p2align 2,,3
.L77:
	mov	x2, x20
	b	.L66
.L86:
	stp	x25, x26, [sp, 208]
	bl	__stack_chk_fail
.L88:
	stp	x25, x26, [sp, 208]
	ldr	w3, [x19, 16]
	ldr	w2, [x19, 372]
	ldr	x0, [x0, 40]
	madd	w1, w1, w3, w2
	ldr	w25, [x0, w1, sxtw 2]
	mov	x0, x19
	bl	tcon_get_current_line
	ldr	w7, [sp, 92]
	mov	w1, 16959
	adrp	x6, .LANCHOR1
	ldr	x5, [x19, 24]
	movk	w1, 0xf, lsl 16
	cmp	w22, w1
	lsr	w1, w25, 6
	add	x6, x6, :lo12:.LANCHOR1
	lsr	w4, w25, 6
	and	w4, w4, 67107840
	adrp	x2, .LC2
	ldrb	w5, [x5, x1]
	add	x2, x2, :lo12:.LC2
	str	w4, [sp, 8]
	adrp	x3, .LC3
	and	x5, x5, 15
	ldr	w4, [sp, 80]
	add	x3, x3, :lo12:.LC3
	csel	x3, x3, x2, le
	mov	w2, w20
	ldrb	w1, [x6, x5]
	str	w1, [sp, 48]
	and	w1, w25, 1
	str	w1, [sp, 40]
	ubfx	x1, x25, 1, 5
	str	w1, [sp, 32]
	ubfx	x1, x25, 6, 5
	ubfx	x25, x25, 11, 5
	str	w25, [sp, 16]
	str	w1, [sp, 24]
	ldp	w5, w6, [sp, 84]
	ldr	w1, [x19, 1644]
	str	w1, [sp]
	mov	w1, w0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printk
	ldp	x25, x26, [sp, 208]
	b	.L61
	.size	generate_next_frame, .-generate_next_frame
	.section	.rodata.str1.8
	.align	3
.LC7:
	.string	"\0016EBC wffpu D frame processing complete, %d frames\n"
	.text
	.align	2
	.p2align 5,,15
	.type	wffpu_thread, %function
wffpu_thread:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4679
	.align	3
	.8byte	.LPFE4679
	.text
.LPFE4679:
	nop
	nop
	sub	sp, sp, #192
	stp	x29, x30, [sp, 96]
	add	x29, sp, 96
	stp	x19, x20, [sp, 112]
	mov	x19, x0
	mrs	x0, sp_el0
	stp	x21, x22, [sp, 128]
	mov	w22, 1
	stp	x23, x24, [sp, 144]
	adrp	x23, sysctl_sched_rt_runtime
	stp	x25, x26, [sp, 160]
	adrp	x26, ebc_loglevel
	stp	x27, x28, [sp, 176]
	ldr	x1, [x0, 1280]
	str	x1, [sp, 88]
	mov	x1, 0
	str	xzr, [x19, 52]
	str	xzr, [x19, 60]
	ldr	w0, [x23, #:lo12:sysctl_sched_rt_runtime]
	str	w0, [sp, 32]
	add	x0, x19, 224
	str	x0, [sp, 8]
	bl	mutex_lock
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	str	x0, [sp, 40]
	add	x0, x0, 48
	str	x0, [sp]
.L90:
	bl	kthread_should_stop
	mov	w21, w0
	tbnz	x21, 0, .L151
.L120:
	add	x0, x19, 536
	mov	x2, 0
	mov	x1, 0
	bl	ebc_mm_acquire_buffer
	mov	x27, x0
	cbz	x0, .L152
	ldr	w0, [x0, 28]
	mov	x24, 0
	and	w1, w0, 112
	cmp	w1, 16
	beq	.L153
.L101:
	mov	w0, 1
	str	w0, [x19, 164]
	mov	x0, x19
	bl	ebc_power_on
	tbnz	x22, 0, .L99
.L102:
	add	x0, x19, 1512
	bl	wf_lut_initial_pointer
	str	x0, [x19, 24]
	str	wzr, [x19, 32]
	mov	w0, -1
	str	w0, [x23, #:lo12:sysctl_sched_rt_runtime]
	ldp	x0, x1, [x27, 72]
	stp	x0, x1, [sp, 48]
	mov	x0, x19
	add	x1, sp, 48
	bl	wffpu_scan_area
	stp	x27, x24, [x19, 88]
	add	x1, x19, 176
	ldr	w0, [sp, 52]
#APP
// 143 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu.c" 1
	stlr w0, [x1]
// 0 "" 2
#NO_APP
	add	x28, x19, 36
	mov	w2, 1
	ldp	x0, x1, [sp, 48]
	mov	x3, 0
	stp	x0, x1, [x28]
	mov	w1, w2
	ldr	w0, [x27, 28]
	add	x27, x19, 52
	str	w0, [x19, 168]
	ldr	x0, [sp]
	bl	__wake_up
	ldr	x1, [x19, 112]
	mov	w2, 83
	mov	x0, x19
	bl	generate_next_frame
	mov	x0, x19
	bl	tcon_start
.L111:
	ldr	w0, [x27, 8]
	cbz	w0, .L113
.L157:
	ldr	w0, [x27, 12]
	cbz	w0, .L113
.L114:
	ldr	w24, [x19, 56]
	mov	x0, x19
	bl	tcon_get_current_line
	mov	w2, w0
	ldr	x0, [x19, 168]
	mov	x1, 114
	and	x0, x0, x1
	cmp	x0, 18
	beq	.L154
	cmp	w24, 120
	ble	.L155
	ldr	x1, [x19, 112]
	sub	w3, w24, #120
	and	w0, w21, 255
	sub	w24, w24, #16
.L105:
	cmp	w3, w2
	ccmp	w24, w2, 1, le
	blt	.L108
	ldrb	w2, [x1, 104]
	tbnz	x2, 0, .L108
	tst	x0, 1
	mov	w0, 69
	mov	w2, 76
	csel	w2, w2, w0, eq
	mov	x0, x19
	bl	generate_next_frame
	ldr	w0, [x28, 8]
	cbz	w0, .L108
	ldr	w0, [x28, 12]
	cbnz	w0, .L156
	.p2align 5,,15
.L108:
	ldr	x1, [x19, 24]
	add	x0, x19, 1512
	bl	wf_lut_pointer_valid
	tbz	x0, 0, .L111
.L165:
	mov	x2, x19
	add	x0, x19, 536
	adrp	x1, check_incremental
	add	x1, x1, :lo12:check_incremental
	bl	ebc_mm_acquire_buffer
	mov	x24, x0
	cbz	x0, .L111
	ldp	x0, x1, [x0, 72]
	stp	x0, x1, [sp, 48]
	mov	x0, x19
	add	x1, sp, 48
	bl	wffpu_scan_area
	stp	x24, xzr, [x19, 88]
	add	x1, x19, 176
	ldr	w0, [sp, 52]
#APP
// 143 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu.c" 1
	stlr w0, [x1]
// 0 "" 2
#NO_APP
	ldp	x0, x1, [sp, 48]
	stp	x0, x1, [x28]
	mov	w2, 1
	ldr	w0, [x24, 28]
	mov	w1, w2
	str	w0, [x19, 168]
	mov	x3, 0
	ldr	x0, [sp, 40]
	add	x0, x0, 48
	bl	__wake_up
	ldr	w0, [x27, 8]
	cbnz	w0, .L157
	.p2align 5,,15
.L113:
	ldr	w0, [x28, 8]
	cbz	w0, .L118
	ldr	w0, [x28, 12]
	cbnz	w0, .L114
.L118:
	ldr	w0, [sp, 32]
	str	w0, [x23, #:lo12:sysctl_sched_rt_runtime]
	ldr	w0, [x26, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L158
.L117:
	ldr	x0, [x19, 1448]
	cbz	x0, .L159
.L119:
	and	w22, w21, 255
.L161:
	bl	kthread_should_stop
	mov	w21, w0
	tbz	x21, 0, .L120
.L151:
	mrs	x0, sp_el0
	ldr	x2, [sp, 88]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L160
	ldp	x29, x30, [sp, 96]
	mov	w0, 0
	ldp	x19, x20, [sp, 112]
	ldp	x21, x22, [sp, 128]
	ldp	x23, x24, [sp, 144]
	ldp	x25, x26, [sp, 160]
	ldp	x27, x28, [sp, 176]
	add	sp, sp, 192
	ret
	.p2align 2,,3
.L159:
	ldr	x0, [x19, 1472]
	cbnz	x0, .L119
	mov	x0, x19
	bl	tcon_stop
	mov	x0, x19
	mov	w1, 250
	and	w22, w21, 255
	bl	ebc_power_later_off
	b	.L161
	.p2align 2,,3
.L152:
	ldr	x0, [sp, 8]
	str	wzr, [x19, 164]
	bl	mutex_unlock
	bl	_cond_resched
	ldr	x0, [x19, 1448]
	cbz	x0, .L162
.L94:
.L92:
	ldr	x0, [sp, 8]
	mov	w22, 1
	bl	mutex_lock
	add	x0, x19, 536
	mov	x2, 0
	mov	x1, 0
	bl	ebc_mm_acquire_buffer
	mov	x27, x0
	cbz	x0, .L90
	ldr	w0, [x0, 28]
	and	w1, w0, 112
	cmp	w1, 16
	beq	.L163
.L97:
	str	w22, [x19, 164]
	mov	x0, x19
	mov	x24, 0
	bl	ebc_power_on
.L99:
	mov	x0, x19
	bl	ebc_update_wf_lut
	b	.L102
	.p2align 2,,3
.L153:
	tbz	x0, 1, .L101
	add	x0, x19, 536
	bl	ebc_mm_acquire_tmask
	mov	x24, x0
	b	.L101
	.p2align 2,,3
.L155:
	ldr	x1, [x19, 120]
	mov	x0, x19
	str	x1, [sp, 24]
	str	w2, [sp, 36]
	bl	tcon_get_line_count
	sub	w3, w0, #120
	mov	x0, x19
	str	w3, [sp, 16]
	bl	tcon_get_line_count
	sub	w24, w0, #16
	ldr	x1, [sp, 24]
	mov	w0, 1
	ldr	w3, [sp, 16]
	ldr	w2, [sp, 36]
	b	.L105
	.p2align 2,,3
.L162:
	ldr	x0, [x19, 1472]
	cbnz	x0, .L92
	add	x22, sp, 48
	stp	xzr, xzr, [sp, 48]
	mov	x0, x22
	add	x24, x19, 1480
	mov	w1, 0
	stp	xzr, xzr, [x22, 16]
	mov	x27, 150
	str	xzr, [x22, 32]
	bl	init_wait_entry
	.p2align 5,,15
.L95:
	mov	x1, x22
	mov	x0, x24
	mov	w2, 1
	bl	prepare_to_wait_event
	ldr	x1, [x19, 1448]
	cbz	x1, .L164
.L93:
	mov	x1, x22
	mov	x0, x24
	bl	finish_wait
	b	.L92
	.p2align 2,,3
.L163:
	tbz	x0, 1, .L97
	add	x0, x19, 536
	bl	ebc_mm_acquire_tmask
	str	w22, [x19, 164]
	mov	x24, x0
	mov	x0, x19
	bl	ebc_power_on
	b	.L99
	.p2align 2,,3
.L154:
	ldr	x1, [x19, 120]
	mov	x0, x19
	str	x1, [sp, 16]
	str	w2, [sp, 24]
	bl	tcon_get_line_count
	sub	w24, w0, #16
	ldr	x1, [sp, 16]
	mov	w0, 1
	ldr	w2, [sp, 24]
	mov	w3, 10
	b	.L105
	.p2align 2,,3
.L156:
	mov	x1, x28
	mov	x0, x27
	bl	area_join
	str	xzr, [x19, 36]
	ldr	x1, [x19, 24]
	str	xzr, [x19, 44]
	add	x0, x19, 1512
	bl	wf_lut_pointer_valid
	tbz	x0, 0, .L111
	b	.L165
	.p2align 2,,3
.L164:
	ldr	x1, [x19, 1472]
	cbnz	x1, .L93
	cbz	x27, .L93
	cbnz	x0, .L92
	mov	x0, x27
	bl	schedule_timeout
	mov	x27, x0
	b	.L95
.L160:
	bl	__stack_chk_fail
.L158:
	ldr	w1, [x19, 32]
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printk
	b	.L117
	.size	wffpu_thread, .-wffpu_thread
	.section	.rodata.str1.8
	.align	3
.LC8:
	.string	"\0016EBC wffpu D wffpu suspending, wait for the last frame done...\n"
	.align	3
.LC9:
	.string	"\0016EBC wffpu D wffpu suspended\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wffpu_suspend
	.type	wffpu_suspend, %function
wffpu_suspend:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4680
	.align	3
	.8byte	.LPFE4680
	.text
.LPFE4680:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	adrp	x20, ebc_loglevel
	mov	x19, x0
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L176
.L167:
	add	x0, x19, 224
	bl	mutex_lock
	ldr	w0, [x19, 172]
	cbz	w0, .L168
	.p2align 5,,15
.L169:
	mov	w0, 20
	bl	msleep
	ldr	w0, [x19, 172]
	cbnz	w0, .L169
.L168:
	add	x0, x19, 224
	bl	mutex_unlock
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L177
.L170:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	ret
.L176:
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printk
	b	.L167
.L177:
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printk
	b	.L170
	.size	wffpu_suspend, .-wffpu_suspend
	.section	.rodata.str1.8
	.align	3
.LC10:
	.string	"\0016EBC wffpu D wffpu resume\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wffpu_resume
	.type	wffpu_resume, %function
wffpu_resume:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4681
	.align	3
	.8byte	.LPFE4681
	.text
.LPFE4681:
	nop
	nop
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L184
	mov	w0, 0
	ret
.L184:
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	mov	x29, sp
	bl	printk
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	wffpu_resume, .-wffpu_resume
	.section	.rodata.str1.8
	.align	3
.LC11:
	.string	"\0016EBC wffpu D wffpu init\n"
	.align	3
.LC12:
	.string	"&ebc->user_lock"
	.align	3
.LC13:
	.string	"&ebc->wffpu_lock"
	.align	3
.LC14:
	.string	"\0016EBC wffpu D panel: %dx%d\n"
	.align	3
.LC15:
	.string	"ebc_wffpu"
	.align	3
.LC16:
	.string	"\0016EBC wffpu E failed to create wffpu thread\n"
	.align	3
.LC17:
	.string	"ebc_index"
	.align	3
.LC18:
	.string	"\0016EBC wffpu E failed to create index thread\n"
	.align	3
.LC19:
	.string	"ebc_frame"
	.align	3
.LC20:
	.string	"\0016EBC wffpu E failed to create frame thread\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wffpu_init
	.type	wffpu_init, %function
wffpu_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4682
	.align	3
	.8byte	.LPFE4682
	.text
.LPFE4682:
	nop
	nop
	sub	sp, sp, #64
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x19, x0
	mrs	x0, sp_el0
	str	x21, [sp, 48]
	adrp	x21, ebc_loglevel
	ldr	x1, [x0, 1280]
	str	x1, [sp, 8]
	mov	x1, 0
	mov	w0, 99
	str	w0, [sp, 4]
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L197
.L186:
	add	x0, x19, 192
	adrp	x20, .LANCHOR2
	adrp	x1, .LC12
	add	x2, x20, :lo12:.LANCHOR2
	add	x1, x1, :lo12:.LC12
	bl	__mutex_init
	add	x2, x20, :lo12:.LANCHOR2
	add	x0, x19, 224
	adrp	x1, .LC13
	add	x1, x1, :lo12:.LC13
	bl	__mutex_init
	ldr	x0, [x19, 384]
	str	x0, [x19, 8]
	ldr	w3, [x19, 472]
	ldr	w0, [x19, 392]
	stp	w0, w3, [x19, 16]
	ldr	w1, [x19, 384]
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	ldr	w2, [x19, 388]
	cmp	w0, 2
	bgt	.L198
.L187:
	mov	w1, 0
	add	x0, x19, 536
	bl	ebc_mm_get_waveform_buffer
	str	x0, [x19, 112]
	mov	w1, 1
	add	x0, x19, 536
	bl	ebc_mm_get_waveform_buffer
	str	x0, [x19, 120]
	mov	x1, x19
	adrp	x3, .LC15
	mov	w2, -1
	add	x3, x3, :lo12:.LC15
	adrp	x0, wffpu_thread
	add	x0, x0, :lo12:wffpu_thread
	bl	kthread_create_on_node
	str	x0, [x19, 128]
	cmn	x0, #4096
	bhi	.L199
	add	x2, sp, 4
	mov	w1, 1
	bl	sched_setscheduler_nocheck
	ldr	x0, [x19, 128]
	bl	wake_up_process
	mov	x1, x19
	adrp	x3, .LC17
	mov	w2, -1
	add	x3, x3, :lo12:.LC17
	adrp	x0, wffpu_index_thread
	add	x0, x0, :lo12:wffpu_index_thread
	bl	kthread_create_on_node
	str	x0, [x19, 136]
	cmn	x0, #4096
	bhi	.L200
	add	x2, sp, 4
	mov	w1, 1
	bl	sched_setscheduler_nocheck
	ldr	x0, [x19, 136]
	bl	wake_up_process
	mov	x1, x19
	adrp	x3, .LC19
	mov	w2, -1
	add	x3, x3, :lo12:.LC19
	adrp	x0, wffpu_frame_thread
	add	x0, x0, :lo12:wffpu_frame_thread
	bl	kthread_create_on_node
	str	x0, [x19, 144]
	cmn	x0, #4096
	bhi	.L201
	add	x2, sp, 4
	mov	w1, 1
	bl	sched_setscheduler_nocheck
	ldr	x0, [x19, 144]
	bl	wake_up_process
	mov	w0, 0
.L185:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L202
	ldr	x21, [sp, 48]
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 64
	ret
	.p2align 2,,3
.L199:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L203
.L190:
	mov	w0, -1
	b	.L185
	.p2align 2,,3
.L200:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L190
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	bl	printk
	mov	w0, -1
	b	.L185
	.p2align 2,,3
.L201:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L190
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	bl	printk
	mov	w0, -1
	b	.L185
.L202:
	bl	__stack_chk_fail
.L203:
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printk
	mov	w0, -1
	b	.L185
.L198:
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printk
	b	.L187
.L197:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printk
	b	.L186
	.size	wffpu_init, .-wffpu_init
	.section	.rodata
	.align	3
	.set	.LANCHOR1,. + 0
	.type	lutstates.0, %object
	.size	lutstates.0, 16
lutstates.0:
	.ascii	"    .@*?EEEEEEEE"
	.data
	.align	3
	.set	.LANCHOR0,. + 0
	.type	frame_sync_request_wq, %object
	.size	frame_sync_request_wq, 24
frame_sync_request_wq:
	.word	0
	.zero	4
	.xword	frame_sync_request_wq+8
	.xword	frame_sync_request_wq+8
	.type	frame_sync_done_wq, %object
	.size	frame_sync_done_wq, 24
frame_sync_done_wq:
	.word	0
	.zero	4
	.xword	frame_sync_done_wq+8
	.xword	frame_sync_done_wq+8
	.type	index_request_wq, %object
	.size	index_request_wq, 24
index_request_wq:
	.word	0
	.zero	4
	.xword	index_request_wq+8
	.xword	index_request_wq+8
	.bss
	.align	3
	.set	.LANCHOR2,. + 0
	.type	__key.2, %object
	.size	__key.2, 0
__key.2:
	.type	__key.1, %object
	.size	__key.1, 0
__key.1:
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
