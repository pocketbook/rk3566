// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_mm.c"
	.text
	.align	2
	.p2align 5,,15
	.type	get_order, %function
get_order:
	sub	x1, x0, #1
	mov	x0, 63
	lsr	x1, x1, 12
	clz	x1, x1
	sub	x0, x0, x1
	add	w0, w0, 1
	ret
	.size	get_order, .-get_order
	.align	2
	.p2align 5,,15
	.type	ebc_mm_alloc_buffer, %function
ebc_mm_alloc_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	mul	w21, w4, w5
	mov	w22, w4
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	x0, x2
	mul	w21, w21, w3
	mov	w2, 2
	mov	w20, w3
	movk	w2, 0x8, lsl 16
	mov	w3, 0
	stp	x23, x24, [sp, 48]
	sxtw	x21, w21
	mov	w24, w5
	mov	w23, w6
	lsr	x21, x21, 3
	str	x25, [sp, 64]
	mov	x25, x1
	mov	x1, x21
	bl	dma_heap_buffer_alloc
	str	x0, [x19, 32]
	cbz	x0, .L4
	bl	dma_buf_vmap
	mov	x1, x0
	ldr	x0, [x19, 32]
	cbz	x1, .L11
	stp	wzr, w20, [x19]
	mul	w20, w20, w24
	str	x1, [x19, 40]
	cmp	w20, 0
	add	w1, w20, 7
	csel	w1, w1, w20, lt
	str	x21, [x19, 16]
	asr	w1, w1, 3
	stp	w22, w1, [x19, 8]
	mov	x1, x25
	bl	dma_buf_attach
	str	x0, [x19, 56]
	mov	w1, 3264
	ubfiz	x0, x23, 4, 32
	bl	__kmalloc
	str	x0, [x19, 88]
	mov	w0, 0
	stp	wzr, w23, [x19, 96]
.L3:
	ldr	x25, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
.L11:
	bl	dma_buf_put
	str	xzr, [x19, 32]
.L4:
	mov	w0, -12
	b	.L3
	.size	ebc_mm_alloc_buffer, .-ebc_mm_alloc_buffer
	.align	2
	.p2align 5,,15
	.type	ebc_mm_free_buffer.part.0, %function
ebc_mm_free_buffer.part.0:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4697
	.align	3
	.8byte	.LPFE4697
	.text
.LPFE4697:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0, 88]
	bl	kfree
	ldr	x1, [x19, 40]
	cbz	x1, .L13
	ldr	x0, [x19, 32]
	bl	dma_buf_vunmap
.L13:
	ldr	x0, [x19, 56]
	cbz	x0, .L15
	ldr	x1, [x19, 64]
	cbz	x1, .L16
	mov	w2, 1
	bl	dma_buf_unmap_attachment
	ldr	x0, [x19, 56]
	cbz	x0, .L15
.L16:
	mov	x1, x0
	ldr	x0, [x19, 32]
	bl	dma_buf_detach
.L15:
	ldr	x0, [x19, 32]
	bl	dma_buf_put
	str	xzr, [x19, 32]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_mm_free_buffer.part.0, .-ebc_mm_free_buffer.part.0
	.align	2
	.p2align 5,,15
	.type	ebc_mm_free_to_sys, %function
ebc_mm_free_to_sys:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0, 720]
	bl	vfree
	ldr	x0, [x19, 832]
	bl	vfree
	ldr	x0, [x19, 384]
	bl	vfree
	ldr	x1, [x19, 40]
	add	x0, x19, 8
	cbz	x1, .L29
	bl	ebc_mm_free_buffer.part.0
.L29:
	ldr	x1, [x19, 152]
	add	x0, x19, 120
	cbz	x1, .L30
	bl	ebc_mm_free_buffer.part.0
.L30:
	ldr	x1, [x19, 264]
	add	x0, x19, 232
	cbz	x1, .L28
	bl	ebc_mm_free_buffer.part.0
.L28:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_mm_free_to_sys, .-ebc_mm_free_to_sys
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC mm    E updates are coming too fast!\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_mm_copy_areas.part.0, %function
ebc_mm_copy_areas.part.0:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4698
	.align	3
	.8byte	.LPFE4698
	.text
.LPFE4698:
	nop
	nop
	sub	sp, sp, #96
	stp	x29, x30, [sp, 32]
	add	x29, sp, 32
	stp	x19, x20, [sp, 48]
	mov	x20, x0
	mrs	x0, sp_el0
	stp	x21, x22, [sp, 64]
	mov	x21, x1
	ldr	x1, [x0, 1280]
	str	x1, [sp, 24]
	mov	x1, 0
	ldr	w0, [x20, 96]
	ldr	w1, [x21, 28]
	cbz	w0, .L43
	ldr	w2, [x20, 28]
	and	w4, w1, 3
	and	w1, w1, 112
	and	w3, w2, 112
	and	w2, w2, 3
	cmp	w3, 32
	csel	w3, w1, w3, eq
	cmp	w2, w4
	csel	w2, w2, w4, ge
	orr	w1, w2, w3
.L43:
	str	w1, [x20, 28]
	mov	x22, 0
	ldr	w1, [x21, 96]
	cmp	w1, 0
	ble	.L42
	stp	x23, x24, [sp, 80]
	ldr	x1, [x21, 88]
	add	x1, x1, x22, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [sp, 8]
	ldr	w1, [x20, 100]
	cmp	w1, w0
	beq	.L47
	.p2align 5,,15
.L73:
	ldr	w1, [sp, 20]
	cmp	w1, 0
	ble	.L49
	ldp	w0, w3, [sp, 8]
	mov	w24, 0
	ldr	w19, [x21, 12]
	ldr	x1, [x21, 40]
	madd	w19, w3, w19, w0
	add	x19, x1, w19, sxtw
	ldr	w1, [x20, 12]
	madd	w3, w3, w1, w0
	ldr	x0, [x20, 40]
	add	x3, x0, w3, sxtw
	.p2align 5,,15
.L51:
	ldrsw	x2, [sp, 16]
	mov	x1, x19
	mov	x0, x3
	add	w24, w24, 1
	bl	memcpy
	mov	x3, x0
	ldrsw	x0, [x21, 12]
	add	x19, x19, x0
	ldrsw	x0, [x20, 12]
	add	x3, x3, x0
	ldr	w0, [sp, 20]
	cmp	w24, w0
	blt	.L51
	ldr	w0, [x20, 96]
.L49:
	cmp	w0, 0
	ble	.L52
	mov	x19, 0
	.p2align 5,,15
.L53:
	ldr	x1, [x20, 88]
	add	x0, sp, 8
	add	x1, x1, x19, lsl 4
	bl	area_cut
	ldr	w0, [x20, 96]
	add	x19, x19, 1
	cmp	w0, w19
	bgt	.L53
.L52:
	ldr	w1, [sp, 16]
	cbz	w1, .L54
	ldr	w1, [sp, 20]
	cbz	w1, .L54
	ldr	x1, [x20, 88]
	add	w2, w0, 1
	str	w2, [x20, 96]
	ldp	x2, x3, [sp, 8]
	add	x0, x1, w0, sxtw 4
	add	x1, sp, 8
	stp	x2, x3, [x0]
	add	x0, x20, 72
	bl	area_join
.L54:
	ldr	w0, [x21, 96]
	add	x22, x22, 1
	cmp	w0, w22
	ble	.L72
	ldr	x1, [x21, 88]
	ldr	w0, [x20, 96]
	add	x1, x1, x22, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [sp, 8]
	ldr	w1, [x20, 100]
	cmp	w1, w0
	bne	.L73
.L47:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L74
.L72:
	ldp	x23, x24, [sp, 80]
.L42:
	mrs	x0, sp_el0
	ldr	x2, [sp, 24]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L75
	ldp	x29, x30, [sp, 32]
	ldp	x19, x20, [sp, 48]
	ldp	x21, x22, [sp, 64]
	add	sp, sp, 96
	ret
.L75:
	stp	x23, x24, [sp, 80]
	bl	__stack_chk_fail
.L74:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	ldp	x23, x24, [sp, 80]
	b	.L42
	.size	ebc_mm_copy_areas.part.0, .-ebc_mm_copy_areas.part.0
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"system"
	.align	3
.LC2:
	.string	"\0016EBC mm    E Failed to get system heap\n"
	.align	3
.LC3:
	.string	"\0016EBC mm    I LUT buffer:      %lx %d\n"
	.align	3
.LC4:
	.string	"\0016EBC mm    I indexmap buffer: %lx %d\n"
	.align	3
.LC5:
	.string	"\0016EBC mm    I image buf 0:     %lx %d\n"
	.align	3
.LC6:
	.string	"\0016EBC mm    I image buf 1:     %lx %d\n"
	.align	3
.LC7:
	.string	"\0016EBC mm    I image buf 2:     %lx %d\n"
	.align	3
.LC8:
	.string	"\0016EBC mm    I background buf:  %lx %d\n"
	.align	3
.LC9:
	.string	"cma"
	.align	3
.LC10:
	.string	"\0016EBC mm    E Failed to get cma heap\n"
	.align	3
.LC11:
	.string	"\0016EBC mm    I waveform buffer 0: %lx %lx %d\n"
	.align	3
.LC12:
	.string	"\0016EBC mm    I waveform buffer 1: %lx %lx %d\n"
	.align	3
.LC13:
	.string	"&mm->waitq_image_ready"
	.align	3
.LC14:
	.string	"\0016EBC mm    E could not allocate page array\n"
	.align	3
.LC15:
	.string	"\0016EBC mm    D LUT vmap zero area %lx, LUT start %lx\n"
	.align	3
.LC16:
	.string	"\0016EBC mm    E vmap error\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_init
	.type	ebc_mm_init, %function
ebc_mm_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4681
	.align	3
	.8byte	.LPFE4681
	.text
.LPFE4681:
	nop
	nop
	stp	x29, x30, [sp, -112]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	ldr	x20, [x0, 120]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	ldr	w22, [x20, 384]
	ldr	w21, [x20, 388]
	bl	dma_heap_find
	cbz	x0, .L124
	stp	x23, x24, [sp, 48]
	mov	x2, x0
	mov	x24, x0
	ldr	x1, [x20]
	add	x19, x20, 536
	mov	w4, w21
	mov	w3, w22
	add	x0, x20, 544
	mov	w6, 36
	mov	w5, 8
	bl	ebc_mm_alloc_buffer
	cbnz	w0, .L80
	ldr	x1, [x20]
	mov	w4, w21
	mov	w3, w22
	mov	x2, x24
	add	x0, x20, 656
	mov	w6, 36
	mov	w5, 8
	bl	ebc_mm_alloc_buffer
	cbnz	w0, .L80
	ldr	x1, [x20]
	mov	w4, w21
	mov	w3, w22
	mov	x2, x24
	add	x0, x20, 768
	mov	w6, 36
	mov	w5, 8
	bl	ebc_mm_alloc_buffer
	cbnz	w0, .L80
	mul	w22, w22, w21
	mov	w0, 1
	stp	x25, x26, [sp, 64]
	adrp	x23, ebc_loglevel
	str	wzr, [x19, 8]
	sxtw	x22, w22
	str	w0, [x19, 120]
	mov	w0, 2
	str	w0, [x19, 232]
	mov	x0, x22
	bl	vmalloc
	str	x22, [x19, 360]
	str	x0, [x19, 384]
	ldr	w0, [x20, 392]
	mul	w0, w21, w0
	lsl	w0, w0, 2
	bl	vmalloc
	str	x0, [x19, 832]
	ldr	w0, [x20, 392]
	mul	w21, w21, w0
	mov	x0, 1048576
	lsl	w21, w21, 2
	str	x21, [x19, 808]
	bl	vmalloc
	str	x0, [x19, 720]
	mov	x2, 1048576
	str	x2, [x19, 696]
	mov	w1, 0
	bl	memset
	ldr	x2, [x19, 808]
	mov	w1, 0
	ldr	x0, [x19, 832]
	bl	memset
	ldr	x2, [x19, 24]
	mov	w1, 240
	ldr	x0, [x19, 48]
	bl	memset
	ldr	x2, [x19, 136]
	mov	w1, 240
	ldr	x0, [x19, 160]
	bl	memset
	ldr	x2, [x19, 248]
	mov	w1, 240
	ldr	x0, [x19, 272]
	bl	memset
	ldr	x2, [x19, 360]
	mov	w1, 240
	ldr	x0, [x19, 384]
	bl	memset
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L125
.L111:
	mov	x0, x24
	bl	dma_heap_put
	adrp	x0, .LC9
	ldr	w26, [x20, 388]
	ldr	w24, [x20, 392]
	add	x0, x0, :lo12:.LC9
	bl	dma_heap_find
	mov	x21, x0
	cbz	x0, .L126
	ldr	x1, [x20]
	add	x22, x20, 992
	mov	x2, x0
	mov	w4, w26
	mov	w3, w24
	mov	x0, x22
	mov	w6, 1
	mov	w5, 2
	add	x25, x20, 1104
	bl	ebc_mm_alloc_buffer
	cbnz	w0, .L89
	str	wzr, [x20, 992]
	mov	w1, 1
	ldr	x0, [x22, 56]
	bl	dma_buf_map_attachment
	str	x0, [x22, 64]
	ldr	x0, [x0]
	ldr	x2, [x0, 16]
	str	x2, [x22, 48]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L127
.L90:
	ldr	x1, [x20]
	add	x25, x20, 1104
	mov	w4, w26
	mov	w3, w24
	mov	x2, x21
	mov	x0, x25
	mov	w6, 1
	mov	w5, 2
	bl	ebc_mm_alloc_buffer
	str	w0, [sp, 100]
	cbnz	w0, .L89
	stp	x27, x28, [sp, 80]
	mov	w1, 1
	str	w1, [x20, 1104]
	ldr	x0, [x25, 56]
	bl	dma_buf_map_attachment
	str	x0, [x25, 64]
	ldr	x0, [x0]
	ldr	x2, [x0, 16]
	str	x2, [x25, 48]
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L128
.L91:
	mov	x0, x21
	bl	dma_heap_put
	str	wzr, [x19, 972]
	add	x0, x20, 1480
	str	x20, [x20, 536]
	adrp	x2, .LANCHOR0
	adrp	x1, .LC13
	add	x2, x2, :lo12:.LANCHOR0
	add	x1, x1, :lo12:.LC13
	bl	__init_waitqueue_head
	str	wzr, [x20, 1504]
	mov	x22, 4095
	movk	x22, 0x400, lsl 16
	mov	w1, 3264
	ldr	x4, [x19, 696]
	ldr	x26, [x19, 720]
	sub	x22, x22, x4
	add	x4, x4, 4095
	lsr	x22, x22, 12
	lsr	x4, x4, 12
	mov	w21, w22
	add	w0, w4, w22
	add	w25, w4, w22
	str	x4, [sp, 104]
	lsl	x0, x0, 3
	bl	__kmalloc
	mov	x28, x0
	cbz	x0, .L129
	mov	w1, 0
	mov	x3, 0
	mov	w2, 0
	mov	w0, 3520
	bl	__alloc_pages_nodemask
	ldr	x4, [sp, 104]
	mov	w1, 0
	cbz	w22, .L102
	.p2align 5,,15
.L101:
	str	x0, [x28, w1, sxtw 3]
	add	w1, w1, 1
	cmp	w1, w22
	bne	.L101
.L102:
	mov	w27, 0
	cbz	w4, .L100
	.p2align 5,,15
.L103:
	ubfiz	x24, x21, 3, 32
	add	x0, x26, w27, sxtw
	add	w21, w21, 1
	bl	vmalloc_to_page
	add	w27, w27, 4096
	str	x0, [x28, x24]
	cmp	w25, w21
	bne	.L103
.L100:
	adrp	x0, arm64_use_ng_mappings
	mov	x2, 4
	ldrb	w1, [x0, #:lo12:arm64_use_ng_mappings]
	mov	x0, 1795
	movk	x0, 0x68, lsl 48
	add	x3, x0, 2048
	tst	x1, 1
	mov	w1, w25
	csel	x3, x0, x3, eq
	mov	x0, x28
	bl	vmap
	mov	x21, x0
	mov	x0, x28
	bl	kfree
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cbz	x21, .L107
	lsl	w2, w22, 12
	add	x2, x21, x2
	cmp	w0, 2
	bgt	.L130
.L109:
	str	x2, [x20, 1512]
	ldr	x0, [x19, 696]
	str	w0, [x20, 1520]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.L76:
	ldr	w0, [sp, 100]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 112
	ret
	.p2align 2,,3
.L80:
	mov	x0, x19
	bl	ebc_mm_free_to_sys
	mov	w0, -12
	str	w0, [sp, 100]
	ldp	x23, x24, [sp, 48]
	b	.L76
.L89:
	ldr	x0, [x22, 32]
	cbz	x0, .L94
	mov	x0, x22
	bl	ebc_mm_free_buffer.part.0
.L94:
	ldr	x0, [x25, 32]
	cbz	x0, .L97
	mov	x0, x25
	bl	ebc_mm_free_buffer.part.0
.L97:
	mov	w0, -12
	str	w0, [sp, 100]
.L96:
	mov	x0, x19
	bl	ebc_mm_free_to_sys
	ldr	w0, [sp, 100]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 112
	ret
	.p2align 2,,3
.L129:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L131
.L105:
	mov	x2, 0
	b	.L109
	.p2align 2,,3
.L107:
	cmp	w0, 0
	ble	.L105
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	printk
	mov	x2, 0
	b	.L109
	.p2align 2,,3
.L124:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L132
.L78:
	mov	w0, -22
	str	w0, [sp, 100]
	b	.L76
.L126:
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L133
.L88:
	mov	w0, -22
	str	w0, [sp, 100]
	b	.L96
.L131:
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printk
	mov	x2, 0
	b	.L109
.L133:
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printk
	b	.L88
.L132:
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printk
	b	.L78
.L127:
	ldr	x1, [x22, 40]
	adrp	x0, .LC11
	ldr	w3, [x22, 16]
	add	x0, x0, :lo12:.LC11
	bl	printk
	b	.L90
.L128:
	ldr	x1, [x25, 40]
	adrp	x0, .LC12
	ldr	w3, [x25, 16]
	add	x0, x0, :lo12:.LC12
	bl	printk
	b	.L91
.L125:
	ldr	x1, [x19, 720]
	adrp	x0, .LC3
	ldr	w2, [x19, 696]
	add	x0, x0, :lo12:.LC3
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L111
	ldr	x1, [x19, 832]
	adrp	x0, .LC4
	ldr	w2, [x19, 808]
	add	x0, x0, :lo12:.LC4
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L111
	ldr	x1, [x19, 48]
	adrp	x0, .LC5
	ldr	w2, [x19, 24]
	add	x0, x0, :lo12:.LC5
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L111
	ldr	x1, [x19, 160]
	adrp	x0, .LC6
	ldr	w2, [x19, 136]
	add	x0, x0, :lo12:.LC6
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L111
	ldr	x1, [x19, 272]
	adrp	x0, .LC7
	ldr	w2, [x19, 248]
	add	x0, x0, :lo12:.LC7
	bl	printk
	ldr	w0, [x23, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L111
	ldr	x1, [x19, 384]
	adrp	x0, .LC8
	ldr	w2, [x19, 360]
	add	x0, x0, :lo12:.LC8
	bl	printk
	b	.L111
.L130:
	mov	x1, x21
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	str	x2, [sp, 104]
	bl	printk
	ldr	x2, [sp, 104]
	b	.L109
	.size	ebc_mm_init, .-ebc_mm_init
	.align	2
	.p2align 5,,15
	.global	ebc_mm_deinit
	.type	ebc_mm_deinit, %function
ebc_mm_deinit:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4682
	.align	3
	.8byte	.LPFE4682
	.text
.LPFE4682:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	bl	ebc_mm_free_to_sys
	add	x0, x19, 456
	ldr	x1, [x0, 32]
	cbz	x1, .L135
	bl	ebc_mm_free_buffer.part.0
.L135:
	ldr	x1, [x19, 600]
	add	x0, x19, 568
	cbz	x1, .L134
	bl	ebc_mm_free_buffer.part.0
.L134:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_mm_deinit, .-ebc_mm_deinit
	.align	2
	.p2align 5,,15
	.global	ebc_mm_copy_areas
	.type	ebc_mm_copy_areas, %function
ebc_mm_copy_areas:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4683
	.align	3
	.8byte	.LPFE4683
	.text
.LPFE4683:
	nop
	nop
	ldr	w2, [x1, 96]
	cbz	w2, .L150
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	ebc_mm_copy_areas.part.0
	ldp	x29, x30, [sp], 16
	ret
	.p2align 2,,3
.L150:
	ret
	.size	ebc_mm_copy_areas, .-ebc_mm_copy_areas
	.section	.rodata.str1.8
	.align	3
.LC17:
	.string	"\0016EBC mm    E %d: no free buffers!\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_get_empty_buffer
	.type	ebc_mm_get_empty_buffer, %function
ebc_mm_get_empty_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4684
	.align	3
	.8byte	.LPFE4684
	.text
.LPFE4684:
	nop
	nop
	ldr	x4, [x0, 904]
	add	x3, x0, 8
	mov	w2, 0
.L156:
	mov	x1, x3
	cmp	x4, x3
	beq	.L154
	ldr	x5, [x0, 912]
	cmp	x5, x3
	beq	.L154
	ldr	x5, [x0, 920]
	cmp	x5, x3
	beq	.L154
	ldr	x5, [x0, 928]
	cmp	x5, x3
	beq	.L154
	ldr	x5, [x0, 936]
	cmp	x5, x3
	beq	.L154
	cbz	x3, .L165
	sbfiz	x3, x2, 3, 32
	sub	x2, x3, w2, sxtw
	add	x2, x0, x2, lsl 4
	str	wzr, [x2, 104]
	stp	xzr, xzr, [x1, 72]
.L165:
	mov	x0, x1
	ret
	.p2align 2,,3
.L154:
	add	w2, w2, 1
	add	x3, x3, 112
	cmp	w2, 3
	bne	.L156
	adrp	x0, ebc_loglevel
	mov	x1, 0
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L165
	stp	x29, x30, [sp, -16]!
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	mov	x29, sp
	ldr	w1, [x0, 1272]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	bl	printk
	mov	x1, 0
	mov	x0, x1
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_mm_get_empty_buffer, .-ebc_mm_get_empty_buffer
	.section	.rodata.str1.8
	.align	3
.LC18:
	.string	"\0016EBC mm    D %d: get %d (%d areas)\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_get_user_buffer
	.type	ebc_mm_get_user_buffer, %function
ebc_mm_get_user_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4685
	.align	3
	.8byte	.LPFE4685
	.text
.LPFE4685:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x4, x0
	mov	x29, sp
	add	x3, x0, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L169		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L169 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L169		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L169 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x3
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w5, w1
	casa	w5, w2, [x3]
	mov	w0, w5
// 0 "" 2
#NO_APP
	cbnz	w0, .L184
.L171:
	ldr	x5, [x4, 904]
	cbz	x5, .L172
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x5, 24]
	ldr	w0, [x0, 1272]
	cmp	w1, w0
	beq	.L173
	str	xzr, [x4, 904]
.L172:
	mov	x0, x4
	str	x4, [sp, 16]
	bl	ebc_mm_get_empty_buffer
	mov	x5, x0
	ldr	x4, [sp, 16]
	cbz	x0, .L175
.L173:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L185
.L174:
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w0, [x0, 1272]
	str	w0, [x5, 24]
	str	x5, [x4, 904]
.L175:
	mov	w0, 0
	add	x1, x4, 972
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	mov	x0, x5
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L169:
	add	x6, x4, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x6]
1:	ldaxr	w0, [x6]
	eor	w5, w0, w1
	cbnz	w5, 2f
	stxr	w5, w2, [x6]
	cbnz	w5, 1b
	
2:
// 0 "" 2
#NO_APP
	cbz	w0, .L171
.L184:
	mov	w1, w0
	mov	x0, x3
	str	x4, [sp, 16]
	bl	queued_spin_lock_slowpath
	ldr	x4, [sp, 16]
	b	.L171
.L185:
	ldr	w2, [x5]
	ldr	w3, [x5, 96]
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x0, 1272]
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	stp	x5, x4, [sp, 16]
	bl	printk
	ldp	x5, x4, [sp, 16]
	b	.L174
	.size	ebc_mm_get_user_buffer, .-ebc_mm_get_user_buffer
	.section	.rodata.str1.8
	.align	3
.LC19:
	.string	"fjoin"
	.align	3
.LC20:
	.string	"join"
	.align	3
.LC21:
	.string	"tmask"
	.align	3
.LC22:
	.string	"set"
	.align	3
.LC23:
	.string	""
	.align	3
.LC24:
	.string	"copy"
	.align	3
.LC25:
	.string	"replace"
	.align	3
.LC26:
	.string	"\0016EBC mm    E ebc_mm_put_user_buffer: no buffer\n"
	.align	3
.LC27:
	.string	"\0016EBC mm    E returned buffer doesn't match!!!\n"
	.align	3
.LC28:
	.string	"\0016EBC mm    D %d: ebc suspending, release buffer\n"
	.align	3
.LC29:
	.string	"\0016EBC mm    D %d: put %s [%d,%d,%d,%d] %s.%s\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_put_user_buffer
	.type	ebc_mm_put_user_buffer, %function
ebc_mm_put_user_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4686
	.align	3
	.8byte	.LPFE4686
	.text
.LPFE4686:
	nop
	nop
	sub	sp, sp, #64
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	cbz	x1, .L253
	mov	x8, x0
	mov	x3, x1
	ldr	x0, [x0, 904]
	mov	w4, 1
	cmp	x0, x1
	beq	.L189
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L254
.L190:
	mov	w4, 0
	str	x3, [x8, 904]
.L189:
	ldr	w0, [x8, 968]
	cmp	w0, 1
	beq	.L255
	ldr	w0, [x3, 80]
	cbnz	w0, .L256
.L192:
	ldr	x0, [x8, 904]
	cbz	x0, .L194
	stp	xzr, xzr, [x0, 72]
	str	wzr, [x0, 96]
.L194:
	str	xzr, [x8, 904]
.L219:
	mov	w0, 0
.L186:
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 64
	ret
	.p2align 2,,3
.L256:
	ldr	w0, [x3, 84]
	cbz	w0, .L192
	add	x5, x8, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L197		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L197 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L197		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L197 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x5
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w6, w1
	casa	w6, w2, [x5]
	mov	w0, w6
// 0 "" 2
#NO_APP
.L198:
	cbnz	w0, .L257
.L199:
	ldr	w0, [x3, 28]
	tbz	x0, 7, .L258
	ldr	x0, [x8, 928]
	cbz	x0, .L203
	stp	xzr, xzr, [x0, 72]
	str	wzr, [x0, 96]
.L203:
	adrp	x2, .LC21
	add	x2, x2, :lo12:.LC21
	str	x3, [x8, 928]
.L204:
	adrp	x0, ebc_loglevel
	str	xzr, [x8, 904]
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L259
.L218:
	add	x1, x8, 972
	mov	w0, 0
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	mov	x3, 0
	add	x0, x8, 944
	mov	w2, 1
	mov	w1, 3
	bl	__wake_up
	b	.L219
	.p2align 2,,3
.L255:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L192
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x0, sp_el0
// 0 "" 2
#NO_APP
	ldr	w1, [x0, 1272]
	adrp	x0, .LC28
	add	x0, x0, :lo12:.LC28
	str	x8, [sp, 32]
	bl	printk
	ldr	x8, [sp, 32]
	b	.L192
	.p2align 2,,3
.L197:
	add	x7, x8, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x7]
1:	ldaxr	w0, [x7]
	eor	w6, w0, w1
	cbnz	w6, 2f
	stxr	w6, w2, [x7]
	cbnz	w6, 1b
	
2:
// 0 "" 2
#NO_APP
	b	.L198
	.p2align 2,,3
.L258:
	ldr	x1, [x8, 912]
	cbz	x1, .L205
	add	x0, x3, 72
	add	x1, x1, 72
	str	x3, [sp, 32]
	str	w4, [sp, 40]
	stp	x8, x5, [sp, 48]
	bl	area_covers
	ldr	w4, [sp, 40]
	tst	w0, 255
	ldr	x3, [sp, 32]
	ccmp	w4, 0, 4, ne
	ldp	x8, x5, [sp, 48]
	bne	.L260
	ldp	w1, w2, [x3, 80]
	ldr	x0, [x8, 912]
	mul	w1, w1, w2
	mov	w2, 34464
	movk	w2, 0x1, lsl 16
	cmp	w1, w2
	bgt	.L208
	ldr	w1, [x3, 96]
	cbz	w1, .L211
	mov	x1, x3
	stp	x3, x8, [sp, 32]
	bl	ebc_mm_copy_areas.part.0
	ldp	x3, x8, [sp, 32]
.L211:
	adrp	x2, .LC19
	add	x2, x2, :lo12:.LC19
.L210:
	stp	xzr, xzr, [x3, 72]
	str	wzr, [x3, 96]
	ldr	x3, [x8, 912]
	b	.L204
	.p2align 2,,3
.L260:
	ldr	x0, [x8, 912]
	cbz	x0, .L207
	stp	xzr, xzr, [x0, 72]
	str	wzr, [x0, 96]
.L207:
	adrp	x2, .LC25
	add	x2, x2, :lo12:.LC25
	str	x3, [x8, 912]
	b	.L204
	.p2align 2,,3
.L205:
	cbz	w4, .L216
	adrp	x2, .LC22
	add	x2, x2, :lo12:.LC22
	str	x3, [x8, 912]
	b	.L204
	.p2align 2,,3
.L208:
	add	x1, x8, 972
	str	xzr, [x8, 912]
	str	x0, [x8, 936]
	mov	w0, 0
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	ldr	w0, [x3, 96]
	cbz	w0, .L212
	ldr	x0, [x8, 936]
	mov	x1, x3
	stp	x8, x3, [sp, 32]
	str	x5, [sp, 48]
	bl	ebc_mm_copy_areas.part.0
	ldp	x8, x3, [sp, 32]
	ldr	x5, [sp, 48]
.L212:
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L213		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L213 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L213		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L213 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x5
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w4, w1
	casa	w4, w2, [x5]
	mov	w0, w4
// 0 "" 2
#NO_APP
.L214:
	cbnz	w0, .L261
.L215:
	ldr	x0, [x8, 936]
	adrp	x2, .LC20
	add	x2, x2, :lo12:.LC20
	str	x0, [x8, 912]
	str	xzr, [x8, 936]
	b	.L210
	.p2align 2,,3
.L257:
	mov	w1, w0
	mov	x0, x5
	str	x5, [sp, 32]
	str	w4, [sp, 40]
	stp	x8, x3, [sp, 48]
	bl	queued_spin_lock_slowpath
	ldr	w4, [sp, 40]
	ldr	x5, [sp, 32]
	ldp	x8, x3, [sp, 48]
	b	.L199
	.p2align 2,,3
.L216:
	mov	x0, x8
	stp	x8, x3, [sp, 32]
	bl	ebc_mm_get_empty_buffer
	ldp	x8, x3, [sp, 32]
	str	x0, [x8, 912]
	cbz	x0, .L221
	ldr	w1, [x3, 96]
	cbz	w1, .L217
	mov	x1, x3
	stp	x3, x8, [sp, 32]
	bl	ebc_mm_copy_areas.part.0
	ldp	x3, x8, [sp, 32]
.L217:
	stp	xzr, xzr, [x3, 72]
	adrp	x2, .LC24
	str	wzr, [x3, 96]
	add	x2, x2, :lo12:.LC24
	ldr	x3, [x8, 912]
	b	.L204
	.p2align 2,,3
.L213:
	add	x6, x8, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x6]
1:	ldaxr	w0, [x6]
	eor	w4, w0, w1
	cbnz	w4, 2f
	stxr	w4, w2, [x6]
	cbnz	w4, 1b
	
2:
// 0 "" 2
#NO_APP
	b	.L214
.L221:
	adrp	x2, .LC23
	add	x2, x2, :lo12:.LC23
	b	.L204
.L253:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L262
	mov	w0, -22
	b	.L186
.L261:
	mov	w1, w0
	mov	x0, x5
	stp	x8, x3, [sp, 32]
	bl	queued_spin_lock_slowpath
	ldp	x8, x3, [sp, 32]
	b	.L215
.L262:
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	bl	printk
	mov	w0, -22
	b	.L186
.L254:
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	stp	x8, x1, [sp, 32]
	bl	printk
	ldp	x8, x3, [sp, 32]
	b	.L190
.L259:
	ldr	w0, [x3, 28]
	adrp	x4, wf_qual_strings
	add	x4, x4, :lo12:wf_qual_strings
	str	x8, [sp, 32]
#APP
// 19 "./arch/arm64/include/asm/current.h" 1
	mrs x1, sp_el0
// 0 "" 2
#NO_APP
	ubfx	x5, x0, 4, 3
	and	x0, x0, 3
	ldr	x0, [x4, x0, lsl 3]
	str	x0, [sp]
	adrp	x0, wf_mode_strings
	add	x0, x0, :lo12:wf_mode_strings
	ldr	w1, [x1, 1272]
	ldr	x7, [x0, x5, lsl 3]
	adrp	x0, .LC29
	ldp	w5, w6, [x3, 80]
	add	x0, x0, :lo12:.LC29
	ldp	w3, w4, [x3, 72]
	bl	printk
	ldr	x8, [sp, 32]
	b	.L218
	.size	ebc_mm_put_user_buffer, .-ebc_mm_put_user_buffer
	.align	2
	.p2align 5,,15
	.global	ebc_mm_buffer_by_index
	.type	ebc_mm_buffer_by_index, %function
ebc_mm_buffer_by_index:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4687
	.align	3
	.8byte	.LPFE4687
	.text
.LPFE4687:
	nop
	nop
	mov	w2, 112
	cmp	w1, 3
	umaddl	x0, w1, w2, x0
	add	x0, x0, 8
	csel	x0, x0, xzr, cc
	ret
	.size	ebc_mm_buffer_by_index, .-ebc_mm_buffer_by_index
	.section	.rodata.str1.8
	.align	3
.LC30:
	.string	"\0016EBC mm    D acquire %d  (%d areas)\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_acquire_buffer
	.type	ebc_mm_acquire_buffer, %function
ebc_mm_acquire_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4688
	.align	3
	.8byte	.LPFE4688
	.text
.LPFE4688:
	nop
	nop
	mov	x3, x0
	ldr	x0, [x0, 920]
	cbnz	x0, .L277
	stp	x29, x30, [sp, -48]!
	mov	x4, x1
	mov	x5, x2
	mov	x29, sp
	add	x6, x3, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L268		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L268 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L268		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L268 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x6
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w7, w1
	casa	w7, w2, [x6]
	mov	w0, w7
// 0 "" 2
#NO_APP
.L269:
	cbnz	w0, .L285
.L270:
	ldr	x1, [x3, 912]
	cbz	x1, .L272
	cbz	x4, .L276
	stp	x1, x3, [sp, 24]
	mov	x0, x5
	blr	x4
	ldp	x1, x3, [sp, 24]
	tbz	x0, 0, .L272
.L276:
	adrp	x0, ebc_loglevel
	str	xzr, [x3, 912]
	str	x1, [x3, 920]
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L286
.L272:
	mov	w0, 0
	add	x1, x3, 972
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	ldr	x0, [x3, 920]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L268:
	add	x8, x3, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x8]
1:	ldaxr	w0, [x8]
	eor	w7, w0, w1
	cbnz	w7, 2f
	stxr	w7, w2, [x8]
	cbnz	w7, 1b
	
2:
// 0 "" 2
#NO_APP
	b	.L269
	.p2align 2,,3
.L277:
	mov	x0, 0
	ret
	.p2align 2,,3
.L285:
	mov	w1, w0
	mov	x0, x6
	stp	x3, x4, [sp, 24]
	str	x5, [sp, 40]
	bl	queued_spin_lock_slowpath
	ldr	x5, [sp, 40]
	ldp	x3, x4, [sp, 24]
	b	.L270
.L286:
	ldr	w2, [x1, 96]
	adrp	x0, .LC30
	ldr	w1, [x1]
	add	x0, x0, :lo12:.LC30
	str	x3, [sp, 24]
	bl	printk
	ldr	x3, [sp, 24]
	b	.L272
	.size	ebc_mm_acquire_buffer, .-ebc_mm_acquire_buffer
	.section	.rodata.str1.8
	.align	3
.LC31:
	.string	"\0016EBC mm    D release wffpu %d\n"
	.align	3
.LC32:
	.string	"\0016EBC mm    E trying to release wrong buffer!!!\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_release_buffer
	.type	ebc_mm_release_buffer, %function
ebc_mm_release_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4689
	.align	3
	.8byte	.LPFE4689
	.text
.LPFE4689:
	nop
	nop
	cbz	x1, .L307
	stp	x29, x30, [sp, -32]!
	mov	x3, x0
	mov	x4, x1
	mov	x29, sp
	ldr	x0, [x0, 920]
	cmp	x0, x1
	bne	.L289
	add	x5, x3, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L290		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L290 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L290		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L290 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x5
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w6, w1
	casa	w6, w2, [x5]
	mov	w0, w6
// 0 "" 2
#NO_APP
.L291:
	cbnz	w0, .L310
.L292:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L311
.L293:
	ldr	x0, [x3, 920]
	cbz	x0, .L294
	stp	xzr, xzr, [x0, 72]
	str	wzr, [x0, 96]
.L294:
	mov	w0, 0
	add	x1, x3, 972
	str	xzr, [x3, 920]
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	mov	w0, 0
.L287:
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L290:
	add	x7, x3, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x7]
1:	ldaxr	w0, [x7]
	eor	w6, w0, w1
	cbnz	w6, 2f
	stxr	w6, w2, [x7]
	cbnz	w6, 1b
	
2:
// 0 "" 2
#NO_APP
	b	.L291
	.p2align 2,,3
.L310:
	mov	w1, w0
	mov	x0, x5
	stp	x3, x4, [sp, 16]
	bl	queued_spin_lock_slowpath
	ldp	x3, x4, [sp, 16]
	b	.L292
	.p2align 2,,3
.L289:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L312
	mov	w0, -22
	b	.L287
	.p2align 2,,3
.L307:
	mov	w0, 0
	ret
.L312:
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printk
	mov	w0, -22
	b	.L287
.L311:
	ldr	w1, [x4]
	adrp	x0, .LC31
	add	x0, x0, :lo12:.LC31
	str	x3, [sp, 16]
	bl	printk
	ldr	x3, [sp, 16]
	b	.L293
	.size	ebc_mm_release_buffer, .-ebc_mm_release_buffer
	.section	.rodata.str1.8
	.align	3
.LC33:
	.string	"\0016EBC mm    D acquire tmask %d\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_acquire_tmask
	.type	ebc_mm_acquire_tmask, %function
ebc_mm_acquire_tmask:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4690
	.align	3
	.8byte	.LPFE4690
	.text
.LPFE4690:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x3, x0
	mov	x29, sp
	add	x4, x0, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L314		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L314 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L314		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L314 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x4
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w5, w1
	casa	w5, w2, [x4]
	mov	w0, w5
// 0 "" 2
#NO_APP
	cbnz	w0, .L325
.L316:
	ldr	x2, [x3, 928]
	add	x1, x3, 972
	mov	w0, 0
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	cbz	x2, .L313
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L326
.L313:
	mov	x0, x2
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L314:
	add	x6, x3, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x6]
1:	ldaxr	w0, [x6]
	eor	w5, w0, w1
	cbnz	w5, 2f
	stxr	w5, w2, [x6]
	cbnz	w5, 1b
	
2:
// 0 "" 2
#NO_APP
	cbz	w0, .L316
.L325:
	mov	w1, w0
	mov	x0, x4
	str	x3, [sp, 24]
	bl	queued_spin_lock_slowpath
	ldr	x3, [sp, 24]
	b	.L316
.L326:
	ldr	w1, [x2]
	adrp	x0, .LC33
	add	x0, x0, :lo12:.LC33
	str	x2, [sp, 24]
	bl	printk
	ldr	x2, [sp, 24]
	b	.L313
	.size	ebc_mm_acquire_tmask, .-ebc_mm_acquire_tmask
	.section	.rodata.str1.8
	.align	3
.LC34:
	.string	"\0016EBC mm    D release tmask %d\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_release_tmask
	.type	ebc_mm_release_tmask, %function
ebc_mm_release_tmask:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4691
	.align	3
	.8byte	.LPFE4691
	.text
.LPFE4691:
	nop
	nop
	cbz	x1, .L347
	stp	x29, x30, [sp, -32]!
	mov	x3, x0
	mov	x4, x1
	mov	x29, sp
	ldr	x0, [x0, 928]
	cmp	x0, x1
	bne	.L329
	add	x5, x3, 972
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L330		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L330 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L330		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L330 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	w1, 0
	mov	x0, x5
	mov	w2, 1
#APP
// 370 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	mov	w6, w1
	casa	w6, w2, [x5]
	mov	w0, w6
// 0 "" 2
#NO_APP
.L331:
	cbnz	w0, .L350
.L332:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L351
.L333:
	ldr	x0, [x3, 928]
	cbz	x0, .L334
	stp	xzr, xzr, [x0, 72]
	str	wzr, [x0, 96]
.L334:
	mov	w0, 0
	add	x1, x3, 972
	str	xzr, [x3, 928]
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w0, [x1]
// 0 "" 2
#NO_APP
	mov	w0, 0
.L327:
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L330:
	add	x7, x3, 972
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x7]
1:	ldaxr	w0, [x7]
	eor	w6, w0, w1
	cbnz	w6, 2f
	stxr	w6, w2, [x7]
	cbnz	w6, 1b
	
2:
// 0 "" 2
#NO_APP
	b	.L331
	.p2align 2,,3
.L350:
	mov	w1, w0
	mov	x0, x5
	stp	x3, x4, [sp, 16]
	bl	queued_spin_lock_slowpath
	ldp	x3, x4, [sp, 16]
	b	.L332
	.p2align 2,,3
.L329:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L352
	mov	w0, -22
	b	.L327
	.p2align 2,,3
.L347:
	mov	w0, 0
	ret
.L352:
	adrp	x0, .LC32
	add	x0, x0, :lo12:.LC32
	bl	printk
	mov	w0, -22
	b	.L327
.L351:
	ldr	w1, [x4]
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	str	x3, [sp, 16]
	bl	printk
	ldr	x3, [sp, 16]
	b	.L333
	.size	ebc_mm_release_tmask, .-ebc_mm_release_tmask
	.align	2
	.p2align 5,,15
	.global	ebc_mm_get_bg
	.type	ebc_mm_get_bg, %function
ebc_mm_get_bg:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4692
	.align	3
	.8byte	.LPFE4692
	.text
.LPFE4692:
	nop
	nop
	add	x0, x0, 344
	ret
	.size	ebc_mm_get_bg, .-ebc_mm_get_bg
	.align	2
	.p2align 5,,15
	.global	ebc_mm_get_indexmap
	.type	ebc_mm_get_indexmap, %function
ebc_mm_get_indexmap:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4693
	.align	3
	.8byte	.LPFE4693
	.text
.LPFE4693:
	nop
	nop
	add	x0, x0, 792
	ret
	.size	ebc_mm_get_indexmap, .-ebc_mm_get_indexmap
	.align	2
	.p2align 5,,15
	.global	ebc_mm_get_waveform_buffer
	.type	ebc_mm_get_waveform_buffer, %function
ebc_mm_get_waveform_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4694
	.align	3
	.8byte	.LPFE4694
	.text
.LPFE4694:
	nop
	nop
	and	w1, w1, 1
	mov	w3, 112
	mov	x2, 456
	umaddl	x1, w1, w3, x2
	add	x0, x0, x1
	ret
	.size	ebc_mm_get_waveform_buffer, .-ebc_mm_get_waveform_buffer
	.section	.rodata.str1.8
	.align	3
.LC35:
	.string	"\0016EBC mm    D mm suspend\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_suspend
	.type	ebc_mm_suspend, %function
ebc_mm_suspend:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4695
	.align	3
	.8byte	.LPFE4695
	.text
.LPFE4695:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L362
.L357:
	mov	w0, 1
	str	w0, [x19, 968]
	b	.L359
	.p2align 2,,3
.L358:
	mov	w0, 5
	bl	msleep_interruptible
.L359:
	ldr	x1, [x19, 912]
	cbnz	x1, .L358
	ldr	x0, [x19, 936]
	cbnz	x0, .L358
	ldr	x19, [sp, 16]
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
.L362:
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	bl	printk
	b	.L357
	.size	ebc_mm_suspend, .-ebc_mm_suspend
	.section	.rodata.str1.8
	.align	3
.LC36:
	.string	"\0016EBC mm    D mm resume\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_mm_resume
	.type	ebc_mm_resume, %function
ebc_mm_resume:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4696
	.align	3
	.8byte	.LPFE4696
	.text
.LPFE4696:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x4, x0
	adrp	x0, ebc_loglevel
	mov	x29, sp
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L366
.L364:
	str	wzr, [x4, 968]
	add	x0, x4, 944
	mov	x3, 0
	mov	w2, 1
	mov	w1, 3
	bl	__wake_up
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
.L366:
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	str	x4, [sp, 24]
	bl	printk
	ldr	x4, [sp, 24]
	b	.L364
	.size	ebc_mm_resume, .-ebc_mm_resume
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	__key.0, %object
	.size	__key.0, 0
__key.0:
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
