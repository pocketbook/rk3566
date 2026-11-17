// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_logo.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC logo  I Freeing ebc logo memory: %d bytes\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_logo_free, %function
ebc_logo_free:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	ldr	x1, [x0, 360]
	cbz	x1, .L13
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	mov	x23, x0
	adrp	x0, ebc_loglevel
	stp	x19, x20, [sp, 16]
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	stp	x21, x22, [sp, 32]
	ldr	x22, [x23, 352]
	add	x20, x22, 4095
	add	x22, x22, x1
	lsr	x20, x20, 12
	lsr	x22, x22, 12
	cmp	w0, 1
	bgt	.L17
.L3:
	cmp	x20, x22
	bcs	.L4
	stp	x25, x26, [sp, 64]
	mov	x25, -8589934592
	adrp	x26, memstart_addr
	movk	x25, 0xffe0, lsl 16
	mov	x21, 4096
	mov	w24, 1
	.p2align 5,,15
.L7:
	ldr	x19, [x26, #:lo12:memstart_addr]
	sub	x19, x20, x19, asr 12
	add	x19, x25, x19, lsl 6
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L5		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L5 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L5		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L5 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x1, x21
#APP
// 176 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	stclr	x1, [x19]

// 0 "" 2
#NO_APP
.L6:
	str	w24, [x19, 52]
	mov	x0, x19
	mov	w1, 0
	add	x20, x20, 1
	bl	__free_pages
	mov	x0, x19
	mov	x1, 1
	bl	adjust_managed_page_count
	cmp	x22, x20
	bne	.L7
	ldp	x25, x26, [sp, 64]
.L4:
	stp	xzr, xzr, [x23, 344]
	str	xzr, [x23, 360]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
	.p2align 2,,3
.L13:
	ret
	.p2align 2,,3
.L5:
#APP
// 210 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic64_andnot
	prfm	pstl1strm, [x19]
1:	ldxr	x0, [x19]
	bic	x0, x0, x21
	stxr	w1, x0, [x19]
	cbnz	w1, 1b
// 0 "" 2
#NO_APP
	b	.L6
.L17:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L3
	.size	ebc_logo_free, .-ebc_logo_free
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"\0016EBC logo  D waitting for blanking finish\n"
	.align	3
.LC2:
	.string	"\0016EBC logo  I start kernel logo (mode=%s.%s, count=%d)\n"
	.align	3
.LC3:
	.string	"\0016EBC logo  D sleep %d ms\n"
	.align	3
.LC4:
	.string	"\0016EBC logo  D kernel logo %d/%d @%lx size %d\n"
	.align	3
.LC5:
	.string	"\0016EBC logo  I kernel logo task is complete\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_logo_kernel_thread, %function
ebc_logo_kernel_thread:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4678
	.align	3
	.8byte	.LPFE4678
	.text
.LPFE4678:
	nop
	nop
	stp	x29, x30, [sp, -112]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	adrp	x27, ebc_loglevel
	ldr	x21, [x0, 120]
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	ldr	x20, [x21, 344]
	ldr	w23, [x20, 44]
	cmp	w0, 2
	ble	.L20
	b	.L47
	.p2align 2,,3
.L24:
	ldr	w0, [x21, 368]
	cbnz	w0, .L26
	mov	w0, 10
	bl	msleep
.L20:
	add	x0, x21, 224
	bl	mutex_is_locked
	tbnz	x0, 0, .L24
	stp	x25, x26, [sp, 64]
	add	x25, x20, 44
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	ldr	w3, [x25, 4]
	cmp	w0, 1
	bgt	.L48
	cmp	w3, 0
	ble	.L49
.L39:
	mov	x28, 13531
	add	x23, x20, w23, sxtw
	movk	x28, 0xd7b6, lsl 16
	mov	w22, 1
	movk	x28, 0xde82, lsl 32
	mov	x20, 0
	adrp	x26, ebc_loglevel
	movk	x28, 0x431b, lsl 48
	b	.L27
	.p2align 2,,3
.L29:
	ldr	w0, [x2]
	cmp	w0, 2
	bgt	.L50
.L33:
	bl	ktime_get
	mov	x20, x0
	add	x0, x21, 536
	bl	ebc_mm_get_user_buffer
	mov	x19, x0
	cbz	x0, .L36
	ldr	x2, [x0, 16]
	mov	x1, x23
	ldr	x0, [x0, 40]
	bl	memcpy
	mov	w0, 19
	str	w0, [x19, 28]
	add	x0, x19, 72
	bl	area_set_fullscreen
	ldr	x0, [x19, 88]
	bl	area_set_fullscreen
	mov	w0, 1
	str	w0, [x19, 96]
	mov	x1, x19
	add	x0, x21, 536
	bl	ebc_mm_put_user_buffer
	ldr	x0, [x19, 16]
	cmp	w0, 0
	ble	.L36
	add	x23, x23, w0, sxtw
.L35:
	ldr	w0, [x25, 4]
	add	w22, w22, 1
	cmp	w0, w22
	blt	.L46
.L27:
	ldr	w0, [x21, 368]
	cbnz	w0, .L46
	add	x2, x26, :lo12:ebc_loglevel
	cmp	x20, 0
	ble	.L29
	ldr	w19, [x25, 8]
	add	x2, x26, :lo12:ebc_loglevel
	cmp	w19, 0
	ble	.L29
	bl	ktime_get
	sub	x0, x0, x20
	adrp	x2, ebc_loglevel
	add	x2, x2, :lo12:ebc_loglevel
	smulh	x1, x0, x28
	asr	x1, x1, 18
	sub	x0, x1, x0, asr 63
	sub	w19, w19, w0
	cmp	w19, 0
	ble	.L29
	ldr	w0, [x26, #:lo12:ebc_loglevel]
	add	x2, x26, :lo12:ebc_loglevel
	cmp	w0, 2
	bgt	.L51
.L31:
	str	x2, [sp, 104]
	cmp	w19, 49
	bgt	.L32
	mov	w0, 1000
	mul	w19, w19, w0
	add	w1, w19, 200
	sub	w19, w19, #200
	sxtw	x1, w1
	sxtw	x0, w19
	bl	usleep_range
	ldr	x2, [sp, 104]
	b	.L29
.L48:
	adrp	x0, wf_qual_strings+24
	ldr	x2, [x0, #:lo12:wf_qual_strings+24]
	adrp	x0, wf_mode_strings+8
	ldr	x1, [x0, #:lo12:wf_mode_strings+8]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printk
	ldr	w0, [x25, 4]
	cmp	w0, 0
	bgt	.L39
	.p2align 5,,15
.L46:
	ldp	x25, x26, [sp, 64]
.L26:
	ldr	w0, [x27, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L52
.L38:
	mov	x0, x21
	bl	ebc_logo_free
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.p2align 2,,3
.L36:
	mov	w0, 5
	bl	msleep
	b	.L35
	.p2align 2,,3
.L32:
	mov	w0, w19
	bl	msleep
	ldr	x2, [sp, 104]
	b	.L29
.L49:
	ldp	x25, x26, [sp, 64]
	b	.L38
.L52:
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printk
	b	.L38
.L47:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printk
	b	.L20
.L50:
	ldr	w2, [x25, 4]
	mov	x3, x23
	mov	w1, w22
	mov	w4, 0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printk
	b	.L33
.L51:
	mov	w1, w19
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	str	x2, [sp, 104]
	bl	printk
	ldr	x2, [sp, 104]
	b	.L31
	.size	ebc_logo_kernel_thread, .-ebc_logo_kernel_thread
	.section	.rodata.str1.8
	.align	3
.LC6:
	.string	"\0016EBC logo  E no kernel logo!"
	.align	3
.LC7:
	.string	"ebc_logo_kernel"
	.align	3
.LC8:
	.string	"\0016EBC logo  E failed to run kernel logo thread\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_logo_show_kernel
	.type	ebc_logo_show_kernel, %function
ebc_logo_show_kernel:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4679
	.align	3
	.8byte	.LPFE4679
	.text
.LPFE4679:
	nop
	nop
	sub	sp, sp, #48
	mrs	x2, sp_el0
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	ldr	x20, [x0, 120]
	ldr	x1, [x2, 1280]
	str	x1, [sp, 8]
	mov	x1, 0
	mov	w1, 99
	str	w1, [sp, 4]
	ldr	x2, [x20, 344]
	cbz	x2, .L54
	ldr	w1, [x2, 48]
	cmp	w1, 0
	ble	.L54
	mov	x1, x0
	adrp	x3, .LC7
	mov	w2, -1
	add	x3, x3, :lo12:.LC7
	adrp	x0, ebc_logo_kernel_thread
	add	x0, x0, :lo12:ebc_logo_kernel_thread
	bl	kthread_create_on_node
	mov	x19, x0
	cmn	x0, #4096
	bhi	.L73
	bl	wake_up_process
	add	x2, sp, 4
	mov	x0, x19
	mov	w1, 1
	bl	sched_setscheduler_nocheck
	add	x0, x19, 40
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L61		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L61 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L61		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L61 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 1
#APP
// 52 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	ldadd	w1, w1, [x0]
// 0 "" 2
#NO_APP
.L64:
	cbz	w1, .L74
	add	w2, w1, 1
	orr	w1, w2, w1
	tbnz	w1, #31, .L75
	str	x19, [x20, 152]
.L57:
	mov	w0, 0
.L53:
	mrs	x1, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L76
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L54:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L77
.L56:
	mov	x0, x20
	bl	ebc_logo_free
	b	.L57
	.p2align 2,,3
.L61:
	add	x4, x19, 40
#APP
// 95 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic_fetch_add_relaxed
	prfm	pstl1strm, [x4]
1:	ldxr	w1, [x4]
	add	w2, w1, 1
	stxr	w3, w2, [x4]
	cbnz	w3, 1b
	
// 0 "" 2
#NO_APP
	b	.L64
	.p2align 2,,3
.L75:
	mov	w1, 1
	bl	refcount_warn_saturate
	str	x19, [x20, 152]
	b	.L57
	.p2align 2,,3
.L73:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L78
.L60:
	mov	x0, x20
	bl	ebc_logo_free
	mov	w0, -1
	b	.L53
	.p2align 2,,3
.L74:
	mov	w1, 2
	bl	refcount_warn_saturate
	str	x19, [x20, 152]
	b	.L57
.L76:
	bl	__stack_chk_fail
.L77:
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printk
	b	.L56
.L78:
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printk
	b	.L60
	.size	ebc_logo_show_kernel, .-ebc_logo_show_kernel
	.section	.rodata.str1.8
	.align	3
.LC9:
	.string	"\0016EBC logo  D logo initalize\n"
	.align	3
.LC10:
	.string	"logo-region"
	.align	3
.LC11:
	.string	"\0016EBC logo  E failed to get logo-region mem\n"
	.align	3
.LC12:
	.string	"\0016EBC logo  I no logo store %s (%ld), keeping the staged logo\n"
	.align	3
.LC13:
	.string	"\0016EBC logo  E logo store %s: read failed (%zd)\n"
	.align	3
.LC14:
	.string	"\0016EBC logo  I logo from %s+%lld (%zd bytes)\n"
	.align	3
.LC15:
	.string	"\0016EBC logo  E invalid logo image\n"
	.align	3
.LC16:
	.string	"\0016EBC logo  E logo image large then logo partition: %d > %d\n"
	.align	3
.LC17:
	.string	"\0016EBC logo  E incompatible logo version\n"
	.align	3
.LC18:
	.string	"\0016EBC logo  E invalid image size: %dx%d, screen is: %dx%d\n"
	.align	3
.LC19:
	.string	"\0016EBC logo  E no kernel logo!\n"
	.align	3
.LC20:
	.string	"\0016EBC logo  E kernel logo runs past the %d bytes of logo we have\n"
	.align	3
.LC21:
	.string	"\0016EBC logo  D logo: paddr=0x%lx, vaddr=0x%lx, size=%d\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_logo_init
	.type	ebc_logo_init, %function
ebc_logo_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4681
	.align	3
	.8byte	.LPFE4681
	.text
.LPFE4681:
	nop
	nop
	sub	sp, sp, #208
	mov	x2, 64
	stp	x29, x30, [sp, 112]
	add	x29, sp, 112
	stp	x19, x20, [sp, 128]
	mov	x20, x0
	mrs	x0, sp_el0
	stp	x21, x22, [sp, 144]
	stp	x23, x24, [sp, 160]
	adrp	x23, ebc_loglevel
	ldr	x1, [x0, 1280]
	str	x1, [sp, 104]
	mov	x1, 0
	add	x0, sp, 40
	bl	memset
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	ldr	x22, [x20, 120]
	cmp	w0, 2
	bgt	.L120
.L80:
	ldr	x0, [x20, 648]
	adrp	x1, .LC10
	mov	w2, 0
	add	x1, x1, :lo12:.LC10
	bl	of_parse_phandle
	cbz	x0, .L107
	add	x2, sp, 40
	mov	w1, 0
	bl	of_address_to_resource
	mov	w19, w0
	cbz	w0, .L121
.L79:
	mrs	x0, sp_el0
	ldr	x2, [sp, 104]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L122
	ldp	x29, x30, [sp, 112]
	mov	w0, w19
	ldp	x19, x20, [sp, 128]
	ldp	x21, x22, [sp, 144]
	ldp	x23, x24, [sp, 160]
	add	sp, sp, 208
	ret
	.p2align 2,,3
.L121:
	stp	x25, x26, [sp, 176]
	mov	x0, x20
	mov	x3, 1
	ldp	x25, x21, [sp, 40]
	str	x27, [sp, 192]
	add	x21, x21, 1
	mov	x1, x25
	sub	x21, x21, x25
	mov	w27, w21
	sxtw	x24, w21
	mov	x2, x24
	bl	devm_memremap
	mov	x20, x0
	cbz	x0, .L123
	adrp	x0, .LANCHOR0
	add	x1, x0, :lo12:.LANCHOR0
	ldr	x4, [x0, #:lo12:.LANCHOR0]
	cbz	x4, .L119
	ldr	x26, [x1, 8]
	str	x26, [sp, 32]
	ldrb	w0, [x4]
	cbnz	w0, .L86
.L119:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
.L85:
	stp	x20, x25, [x22, 344]
	mov	w1, 19282
	movk	w1, 0x4c45, lsl 16
	str	x24, [x22, 360]
	str	wzr, [x22, 368]
	ldr	w2, [x20]
	cmp	w2, w1
	bne	.L124
.L91:
	ldr	w1, [x20, 4]
	cmp	w1, w21
	bhi	.L125
	ldr	w1, [x20, 8]
	and	w1, w1, -65536
	cmp	w1, 262144
	beq	.L96
	cmp	w0, 0
	bgt	.L126
.L92:
	mov	w19, -22
	b	.L97
	.p2align 2,,3
.L86:
	mov	x0, x4
	mov	w2, 0
	mov	w1, 0
	str	x4, [sp, 8]
	bl	filp_open
	mov	x5, x0
	ldr	x4, [sp, 8]
	cmn	x0, #4096
	bhi	.L127
	add	x3, sp, 32
	mov	x2, x24
	mov	x1, x20
	stp	x4, x0, [sp, 16]
	bl	kernel_read
	mov	x3, x0
	mov	x1, 0
	ldr	x0, [sp, 24]
	str	x3, [sp, 8]
	bl	filp_close
	ldp	x3, x4, [sp, 8]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	x3, 0
	ble	.L128
	cmp	w0, 1
	bgt	.L129
	mov	w21, w3
.L135:
	stp	x20, x25, [x22, 344]
	mov	w1, 19282
	movk	w1, 0x4c45, lsl 16
	str	x24, [x22, 360]
	str	wzr, [x22, 368]
	ldr	w2, [x20]
	cmp	w2, w1
	beq	.L91
.L124:
	cmp	w0, 0
	ble	.L92
	adrp	x0, .LC15
	mov	w19, -22
	add	x0, x0, :lo12:.LC15
	bl	printk
	b	.L97
	.p2align 2,,3
.L125:
	cmp	w0, 0
	bgt	.L130
.L93:
	mov	w19, -12
.L97:
	mov	x0, x22
	bl	ebc_logo_free
	ldr	x27, [sp, 192]
	ldp	x25, x26, [sp, 176]
	b	.L79
	.p2align 2,,3
.L128:
	cmp	w0, 0
	bgt	.L131
	stp	x20, x25, [x22, 344]
	mov	w1, 19282
	movk	w1, 0x4c45, lsl 16
	str	x24, [x22, 360]
	str	wzr, [x22, 368]
	ldr	w2, [x20]
	cmp	w2, w1
	bne	.L92
	ldr	w1, [x20, 4]
	cmp	w1, w21
	bhi	.L93
	ldr	w1, [x20, 8]
	mov	w21, w27
	and	w1, w1, -65536
	cmp	w1, 262144
	bne	.L92
	.p2align 5,,15
.L96:
	ldr	w1, [x20, 12]
	ldr	w3, [x22, 384]
	cmp	w1, w3
	bne	.L98
	ldr	w4, [x20, 16]
	ldr	w5, [x22, 388]
	cmp	w4, w5
	bne	.L98
	ldr	w5, [x20, 48]
	cmp	w5, 0
	ble	.L132
	smull	x1, w1, w4
	cbz	x1, .L101
	ldr	w2, [x20, 44]
	cmp	w2, 0
	ccmp	w2, w21, 0, gt
	bgt	.L101
	sub	w2, w21, w2
	sxtw	x2, w2
	udiv	x1, x2, x1
	cmp	x1, w5, sxtw
	bcc	.L101
	cmp	w0, 2
	bgt	.L133
	ldr	x27, [sp, 192]
	ldp	x25, x26, [sp, 176]
	b	.L79
	.p2align 2,,3
.L98:
	cmp	w0, 0
	ble	.L92
	ldr	w2, [x20, 16]
	adrp	x0, .LC18
	ldr	w4, [x22, 388]
	add	x0, x0, :lo12:.LC18
	mov	w19, -22
	bl	printk
	b	.L97
	.p2align 2,,3
.L127:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L85
	mov	x2, x5
	mov	x1, x4
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printk
	b	.L119
	.p2align 2,,3
.L101:
	cmp	w0, 0
	ble	.L92
	mov	w1, w21
	adrp	x0, .LC20
	mov	w19, -22
	add	x0, x0, :lo12:.LC20
	bl	printk
	b	.L97
	.p2align 2,,3
.L107:
	mov	w19, -19
	b	.L79
.L132:
	cmp	w0, 0
	ble	.L92
	adrp	x0, .LC19
	mov	w19, -22
	add	x0, x0, :lo12:.LC19
	bl	printk
	b	.L97
	.p2align 2,,3
.L123:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L134
.L83:
	ldr	x27, [sp, 192]
	mov	w19, -12
	ldp	x25, x26, [sp, 176]
	b	.L79
.L122:
	stp	x25, x26, [sp, 176]
	str	x27, [sp, 192]
	bl	__stack_chk_fail
.L130:
	mov	w2, w21
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printk
	b	.L93
.L126:
	adrp	x0, .LC17
	mov	w19, -22
	add	x0, x0, :lo12:.LC17
	bl	printk
	b	.L97
.L120:
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printk
	b	.L80
.L131:
	mov	x2, x3
	mov	x1, x4
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	b	.L85
.L129:
	mov	x2, x26
	mov	x1, x4
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	str	x3, [sp, 8]
	bl	printk
	ldr	x3, [sp, 8]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	mov	w21, w3
	b	.L135
.L133:
	mov	w3, w27
	mov	x1, x25
	mov	x2, x20
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	bl	printk
	ldr	x27, [sp, 192]
	ldp	x25, x26, [sp, 176]
	b	.L79
.L134:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printk
	b	.L83
	.size	ebc_logo_init, .-ebc_logo_init
	.section	.rodata.str1.8
	.align	3
.LC22:
	.string	"\0016EBC logo  D waiting for logo...\n"
	.align	3
.LC23:
	.string	"\0016EBC logo  E logo terminate timed out, forcing teardown\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_logo_terminate
	.type	ebc_logo_terminate, %function
ebc_logo_terminate:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4682
	.align	3
	.8byte	.LPFE4682
	.text
.LPFE4682:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	ldr	x20, [x0, 120]
	ldr	x0, [x20, 344]
	cbz	x0, .L136
	str	x21, [sp, 32]
	adrp	x21, ebc_loglevel
	ldr	w1, [x21, #:lo12:ebc_loglevel]
	cmp	w1, 2
	bgt	.L146
.L139:
	mov	w1, 1
	str	w1, [x20, 368]
	mov	w19, 201
	cbz	x0, .L147
	.p2align 5,,15
.L143:
	subs	w19, w19, #1
	beq	.L148
	mov	w0, 50
	bl	msleep
	ldr	x0, [x20, 344]
	cbnz	x0, .L143
.L147:
	ldr	x0, [x20, 1448]
	cbnz	x0, .L143
	ldr	x0, [x20, 1472]
	cbnz	x0, .L143
	ldr	w0, [x20, 164]
	cbnz	w0, .L143
	.p2align 5,,15
.L145:
	ldr	x21, [sp, 32]
.L136:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L148:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L145
	adrp	x0, .LC23
	add	x0, x0, :lo12:.LC23
	bl	printk
	ldr	x21, [sp, 32]
	b	.L136
.L146:
	adrp	x0, .LC22
	add	x0, x0, :lo12:.LC22
	bl	printk
	ldr	x0, [x20, 344]
	b	.L139
	.size	ebc_logo_terminate, .-ebc_logo_terminate
	.section	.rodata
	.align	3
	.type	__param_str_logo_offset, %object
	.size	__param_str_logo_offset, 12
__param_str_logo_offset:
	.string	"logo_offset"
	.zero	4
	.type	__param_str_logo, %object
	.size	__param_str_logo, 5
__param_str_logo:
	.string	"logo"
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	ebc_logo_path, %object
	.size	ebc_logo_path, 8
ebc_logo_path:
	.zero	8
	.type	ebc_logo_offset, %object
	.size	ebc_logo_offset, 8
ebc_logo_offset:
	.zero	8
	.section	.modinfo,"a"
	.type	__UNIQUE_ID_logo_offset387, %object
	.size	__UNIQUE_ID_logo_offset387, 67
__UNIQUE_ID_logo_offset387:
	.string	"parm=logo_offset:offset of the logo inside the store named by logo"
	.type	__UNIQUE_ID_logo_offsettype386, %object
	.size	__UNIQUE_ID_logo_offsettype386, 27
__UNIQUE_ID_logo_offsettype386:
	.string	"parmtype=logo_offset:ulong"
	.type	__UNIQUE_ID_logo385, %object
	.size	__UNIQUE_ID_logo385, 67
__UNIQUE_ID_logo385:
	.string	"parm=logo:boot logo store: a file, or a partition plus logo_offset"
	.type	__UNIQUE_ID_logotype384, %object
	.size	__UNIQUE_ID_logotype384, 20
__UNIQUE_ID_logotype384:
	.string	"parmtype=logo:charp"
	.section	__param,"a"
	.align	3
	.type	__param_logo_offset, %object
	.size	__param_logo_offset, 40
__param_logo_offset:
	.xword	__param_str_logo_offset
	.xword	__this_module
	.xword	param_ops_ulong
	.hword	0
	.byte	-1
	.byte	0
	.zero	4
	.xword	ebc_logo_offset
	.type	__param_logo, %object
	.size	__param_logo, 40
__param_logo:
	.xword	__param_str_logo
	.xword	__this_module
	.xword	param_ops_charp
	.hword	0
	.byte	-1
	.byte	0
	.zero	4
	.xword	ebc_logo_path
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
