// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_wffpu_frame.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC wffpu E timeout waiting for index\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wffpu_make_frame
	.type	wffpu_make_frame, %function
wffpu_make_frame:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -192]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	mov	x21, x0
	add	x0, x0, 536
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	mov	w28, w3
	mov	x27, x1
	ldp	x2, x3, [x1, 72]
	stp	x2, x3, [sp, 176]
	ldr	x1, [x1, 40]
	ldr	x19, [x21, 24]
	mov	x24, x1
	bl	ebc_mm_get_indexmap
	mov	x3, x0
	ldr	w2, [x21, 168]
	add	x1, x19, 1024
	add	x0, x21, 1512
	ldr	x3, [x3, 40]
	str	x3, [sp, 96]
	bl	wf_lut_frameoffset_value
	mov	w22, w0
	ldr	w0, [sp, 184]
	cbz	w0, .L104
	ldr	w0, [sp, 188]
	cbz	w0, .L104
	add	x0, sp, 176
	mov	w2, 1
	mov	w1, 16
	bl	area_align
	ldr	w23, [sp, 180]
	mov	w20, 500
	add	w23, w23, 4
	b	.L3
	.p2align 2,,3
.L6:
	mov	x0, 36284
	movk	x0, 0x6, lsl 16
	bl	__const_udelay
	subs	w20, w20, #1
	beq	.L177
.L3:
	add	x0, x21, 176
#APP
// 23 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu_frame.c" 1
	ldar w0, [x0]
// 0 "" 2
#NO_APP
	cmp	w0, w23
	blt	.L6
.L5:
	ldr	w1, [sp, 180]
	ldr	w8, [sp, 188]
	mov	w20, w1
	add	w0, w1, w8
	cmp	w0, w1
	ble	.L8
	mov	w12, -1
	mov	w0, 2112
	mov	x9, x24
	orr	w22, w22, w0
	mov	w5, w28
	mov	x3, 0
	mov	x2, 0
	mov	w23, 34952
	mov	w26, -2004353024
	stp	w12, w12, [sp, 136]
	stp	w12, w12, [sp, 144]
	stp	x27, x25, [sp, 152]
	b	.L60
	.p2align 2,,3
.L12:
	add	w20, w20, 1
	add	w0, w1, w8
	cmp	w0, w20
	ble	.L178
.L60:
	ldr	w28, [x21, 16]
	ldr	w4, [sp, 176]
	ldr	w6, [sp, 184]
	mul	w28, w20, w28
	adds	w7, w28, w4
	add	w0, w7, 3
	csel	w0, w0, w7, mi
	asr	w0, w0, 2
	add	x25, x9, w0, sxtw
	cmp	w20, 0
	ble	.L9
	tst	x20, 3
	bne	.L9
	cmp	x2, 0
	ccmp	x3, x2, 0, ne
	bhi	.L179
.L9:
	cmp	w20, 0
	add	w0, w20, 3
	csel	w0, w0, w20, lt
	ubfx	x0, x0, 2, 1
	asr	w0, w5, w0
	tbz	x0, 0, .L12
	cbz	x2, .L13
.L16:
	ldr	x0, [sp, 96]
	sxtw	x24, w4
	add	x24, x24, w28, sxtw
	sbfiz	x6, x6, 2, 32
	add	x24, x0, x24, lsl 2
	add	x28, x24, x6
	cmp	x24, x28
	bcs	.L180
	mov	x8, x25
	mov	x0, x24
	mov	x17, 0
	mov	x18, 0
	stp	x6, x2, [sp, 104]
	str	w20, [sp, 120]
	str	x9, [sp, 128]
	b	.L54
	.p2align 2,,3
.L184:
	cmp	w1, 0
	add	x8, x8, 4
	csel	x17, x17, x0, eq
	add	x0, x0, 64
	cmp	x28, x0
	bls	.L181
.L54:
	ldp	w11, w10, [x0, 16]
	ldp	w13, w12, [x0, 8]
	ldp	w15, w14, [x0]
	lsr	w2, w11, 6
	ldp	w9, w7, [x0, 24]
	lsr	w4, w10, 6
	lsr	w1, w13, 6
	ldrb	w2, [x19, w2, uxtw]
	lsr	w20, w15, 6
	lsr	w16, w14, 6
	ldrb	w6, [x19, w4, uxtw]
	lsr	w3, w12, 6
	ldrb	w1, [x19, w1, uxtw]
	lsr	w4, w9, 6
	lsr	w27, w7, 6
	lsl	w2, w2, 8
	ldrb	w20, [x19, w20, uxtw]
	lsl	w6, w6, 8
	orr	w1, w2, w1, lsl 4
	ldrb	w4, [x19, w4, uxtw]
	ldrb	w3, [x19, w3, uxtw]
	ldrb	w16, [x19, w16, uxtw]
	ldrb	w2, [x19, w27, uxtw]
	orr	w4, w20, w4, lsl 12
	orr	w3, w6, w3, lsl 4
	orr	w1, w1, w4
	orr	w2, w16, w2, lsl 12
	orr	w3, w3, w2
	orr	w2, w1, w3
	tst	w2, w23
	bne	.L182
.L18:
	ldp	w14, w13, [x0, 40]
	ldp	w16, w15, [x0, 32]
	lsr	w4, w14, 6
	lsr	w2, w13, 6
	ldp	w10, w9, [x0, 56]
	lsr	w7, w16, 6
	ldp	w12, w11, [x0, 48]
	lsr	w27, w15, 6
	ldrb	w20, [x19, w4, uxtw]
	lsr	w6, w10, 6
	ldrb	w7, [x19, w7, uxtw]
	lsr	w4, w9, 6
	ldrb	w2, [x19, w2, uxtw]
	ldrb	w30, [x19, w27, uxtw]
	lsl	w20, w20, 20
	orr	w7, w20, w7, lsl 16
	lsr	w27, w12, 6
	lsr	w20, w11, 6
	lsl	w2, w2, 20
	ldrb	w6, [x19, w6, uxtw]
	orr	w2, w2, w30, lsl 16
	ldrb	w4, [x19, w4, uxtw]
	orr	w1, w7, w1
	orr	w2, w2, w3
	ldrb	w7, [x19, w27, uxtw]
	ldrb	w3, [x19, w20, uxtw]
	lsl	w6, w6, 28
	lsl	w4, w4, 28
	orr	w7, w6, w7, lsl 24
	orr	w3, w4, w3, lsl 24
	orr	w7, w7, w1
	orr	w3, w3, w2
	orr	w1, w7, w3
	tst	w1, w26
	bne	.L183
.L36:
	lsl	w3, w3, 2
	and	w7, w7, 858993459
	and	w3, w3, -858993460
	ands	w1, w1, -858993460
	orr	w3, w3, w7
	str	w3, [x8]
	ccmp	x18, 0, 0, ne
	bne	.L184
	mov	x18, x0
	mov	x17, x0
	add	x0, x0, 64
	add	x8, x8, 4
	cmp	x28, x0
	bhi	.L54
.L181:
	ldp	x6, x2, [sp, 104]
	add	x0, x25, 4
	cmp	x18, 0
	ldr	w20, [sp, 120]
	ldr	x9, [sp, 128]
	ccmp	x17, 0, 4, ne
	sub	x3, x6, #1
	lsr	x3, x3, 6
	add	x3, x0, x3, lsl 2
	beq	.L185
	ldr	w1, [sp, 136]
	sub	x18, x18, x24
	ldr	w0, [sp, 176]
	tbnz	w1, #31, .L186
	ldr	w6, [sp, 136]
	sxtw	x1, w0
	add	x4, x1, x18, asr 2
	cmp	x4, w6, sxtw
	bge	.L58
	asr	x18, x18, 2
	add	w4, w0, w18
	str	w4, [sp, 136]
.L58:
	sub	x17, x17, x24
	ldr	w4, [sp, 140]
	str	w20, [sp, 148]
	asr	x17, x17, 2
	ldr	w8, [sp, 188]
	add	x1, x1, x17
	add	w0, w0, w17
	cmp	x1, w4, sxtw
	ldr	w1, [sp, 180]
	csel	w0, w0, w4, gt
	str	w0, [sp, 140]
	ldr	w0, [sp, 144]
	tbz	w0, #31, .L12
	add	w0, w1, w8
	str	w20, [sp, 144]
	add	w20, w20, 1
	cmp	w0, w20
	bgt	.L60
	.p2align 5,,15
.L178:
	ldp	w13, w12, [sp, 144]
	ldp	x27, x25, [sp, 152]
	ldp	w6, w5, [sp, 136]
	tbnz	w13, #31, .L8
	add	w0, w5, 16
	add	w1, w12, 1
	sub	w0, w0, w6
	sub	w1, w1, w13
	and	w0, w0, -16
	stp	w6, w13, [x25]
	stp	w0, w1, [x25, 8]
.L61:
	ldr	x0, [x27, 32]
	mov	w1, 1
	bl	dma_buf_end_cpu_access
.L104:
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	ret
	.p2align 2,,3
.L183:
	tbz	x7, 19, .L37
	ubfiz	w2, w16, 5, 11
	ands	w16, w16, 1
	orr	w2, w2, w22
	csel	w16, w2, w16, ne
	str	w16, [x0, 32]
.L37:
	tbz	x3, 19, .L39
	ubfiz	w2, w15, 5, 11
	ands	w15, w15, 1
	orr	w2, w2, w22
	csel	w15, w2, w15, ne
	str	w15, [x0, 36]
.L39:
	tbz	x7, 23, .L41
	ubfiz	w2, w14, 5, 11
	ands	w14, w14, 1
	orr	w2, w2, w22
	csel	w14, w2, w14, ne
	str	w14, [x0, 40]
.L41:
	tbz	x3, 23, .L43
	ubfiz	w2, w13, 5, 11
	ands	w13, w13, 1
	orr	w2, w2, w22
	csel	w13, w2, w13, ne
	str	w13, [x0, 44]
.L43:
	tbz	x7, 27, .L45
	ubfiz	w2, w12, 5, 11
	ands	w12, w12, 1
	orr	w2, w2, w22
	csel	w12, w2, w12, ne
	str	w12, [x0, 48]
.L45:
	tbz	x3, 27, .L47
	ubfiz	w2, w11, 5, 11
	ands	w11, w11, 1
	orr	w2, w2, w22
	csel	w11, w2, w11, ne
	str	w11, [x0, 52]
.L47:
	tbz	w7, #31, .L49
	ubfiz	w2, w10, 5, 11
	ands	w10, w10, 1
	orr	w2, w2, w22
	csel	w10, w2, w10, ne
	str	w10, [x0, 56]
.L49:
	tbz	w3, #31, .L36
	ubfiz	w2, w9, 5, 11
	ands	w9, w9, 1
	orr	w2, w2, w22
	csel	w9, w2, w9, ne
	str	w9, [x0, 60]
	b	.L36
	.p2align 2,,3
.L182:
	tbz	x1, 3, .L19
	ubfiz	w2, w15, 5, 11
	ands	w15, w15, 1
	orr	w2, w2, w22
	csel	w15, w2, w15, ne
	str	w15, [x0]
.L19:
	tbz	x3, 3, .L21
	ubfiz	w2, w14, 5, 11
	ands	w14, w14, 1
	orr	w2, w2, w22
	csel	w14, w2, w14, ne
	str	w14, [x0, 4]
.L21:
	tbz	x1, 7, .L23
	ubfiz	w2, w13, 5, 11
	ands	w13, w13, 1
	orr	w2, w2, w22
	csel	w13, w2, w13, ne
	str	w13, [x0, 8]
.L23:
	tbz	x3, 7, .L25
	ubfiz	w2, w12, 5, 11
	ands	w12, w12, 1
	orr	w2, w2, w22
	csel	w12, w2, w12, ne
	str	w12, [x0, 12]
.L25:
	tbz	x1, 11, .L27
	ubfiz	w2, w11, 5, 11
	ands	w11, w11, 1
	orr	w2, w2, w22
	csel	w11, w2, w11, ne
	str	w11, [x0, 16]
.L27:
	tbz	x3, 11, .L29
	ubfiz	w2, w10, 5, 11
	ands	w10, w10, 1
	orr	w2, w2, w22
	csel	w10, w2, w10, ne
	str	w10, [x0, 20]
.L29:
	tbz	x1, 15, .L31
	ubfiz	w2, w9, 5, 11
	ands	w9, w9, 1
	orr	w2, w2, w22
	csel	w9, w2, w9, ne
	str	w9, [x0, 24]
.L31:
	tbz	x3, 15, .L18
	ubfiz	w2, w7, 5, 11
	ands	w7, w7, 1
	orr	w2, w2, w22
	csel	w7, w2, w7, ne
	str	w7, [x0, 28]
	b	.L18
	.p2align 2,,3
.L185:
	ldr	w1, [sp, 180]
	ldr	w8, [sp, 188]
	b	.L12
.L187:
	adrp	x0, ebc_loglevel
	ldr	w4, [sp, 104]
	ldr	x9, [sp, 120]
	mov	w5, w27
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	ldr	x19, [sp, 168]
	ldr	w6, [sp, 112]
	cmp	w0, 0
	ble	.L175
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	str	w4, [sp, 104]
	str	w6, [sp, 112]
	str	x9, [sp, 120]
	str	w27, [sp, 128]
	bl	printk
	ldr	w5, [sp, 128]
	ubfx	x0, x20, 2, 1
	ldr	x9, [sp, 120]
	ldr	w4, [sp, 104]
	asr	w0, w5, w0
	ldr	w6, [sp, 112]
	tbz	x0, 0, .L63
	.p2align 5,,15
.L13:
	mov	x2, x25
	b	.L16
	.p2align 2,,3
.L8:
	stp	xzr, xzr, [x25]
	b	.L61
	.p2align 2,,3
.L179:
	ldr	x0, [sp, 152]
	str	w4, [sp, 104]
	str	w6, [sp, 112]
	sub	w3, w3, w2
	str	x9, [sp, 120]
	mov	w1, 1
	str	w5, [sp, 128]
	add	w24, w20, 4
	ldp	x0, x7, [x0, 32]
	sub	w2, w2, w7
	bl	dma_buf_end_cpu_access_partial
	ldr	w27, [sp, 128]
	str	x19, [sp, 168]
	mov	w19, 500
	b	.L10
	.p2align 2,,3
.L14:
	mov	x0, 36284
	movk	x0, 0x6, lsl 16
	bl	__const_udelay
	subs	w19, w19, #1
	beq	.L187
.L10:
	add	x0, x21, 176
#APP
// 23 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu_frame.c" 1
	ldar w0, [x0]
// 0 "" 2
#NO_APP
	cmp	w0, w24
	blt	.L14
	ldr	x9, [sp, 120]
	mov	w5, w27
	ldr	x19, [sp, 168]
	ldr	w4, [sp, 104]
	ldr	w6, [sp, 112]
.L175:
	ubfx	x0, x20, 2, 1
	asr	w0, w5, w0
	tbnz	x0, 0, .L13
.L63:
	ldr	w1, [sp, 180]
	mov	x3, 0
	ldr	w8, [sp, 188]
	mov	x2, 0
	b	.L12
	.p2align 2,,3
.L186:
	asr	x18, x18, 2
	sxtw	x1, w0
	add	w4, w0, w18
	str	w4, [sp, 136]
	b	.L58
	.p2align 2,,3
.L180:
	ldr	w1, [sp, 180]
	mov	x3, x25
	ldr	w8, [sp, 188]
	b	.L12
.L177:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L5
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L5
	.size	wffpu_make_frame, .-wffpu_make_frame
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
