// SPDX-License-Identifier: GPL-2.0

	.arch armv8-a
	.file	"ebc_area.c"
	.text
	.align	2
	.p2align 5,,15
	.global	area_check
	.type	area_check, %function
area_check:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4672
	.align	3
	.8byte	.LPFE4672
	.text
.LPFE4672:
	nop
	nop
	ldr	w1, [x0]
	mov	w2, 0
	tbnz	w1, #31, .L2
	ldr	w3, [x0, 4]
	mov	w2, 0
	tbnz	w3, #31, .L2
	ldr	w4, [x0, 8]
	cmp	w4, 0
	ble	.L2
	adrp	x5, g_ebc
	add	w1, w1, w4
	ldr	x5, [x5, #:lo12:g_ebc]
	ldr	w4, [x5, 384]
	cmp	w1, w4
	bhi	.L2
	ldr	w0, [x0, 12]
	cmp	w0, 0
	ble	.L2
	add	w3, w3, w0
	ldr	w0, [x5, 388]
	cmp	w3, w0
	cset	w2, ls
.L2:
	mov	w0, w2
	ret
	.size	area_check, .-area_check
	.align	2
	.p2align 5,,15
	.global	area_align
	.type	area_align, %function
area_align:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	cmp	w1, 1
	ble	.L10
	ldr	w3, [x0]
	sub	w5, w1, #1
	and	w4, w5, w3
	bic	w3, w3, w5
	str	w3, [x0]
	add	w4, w1, w4
	ldr	w3, [x0, 8]
	neg	w1, w1
	sub	w3, w3, #1
	add	w3, w3, w4
	and	w3, w3, w1
	str	w3, [x0, 8]
.L10:
	cmp	w2, 1
	ble	.L9
	ldr	w3, [x0, 4]
	sub	w1, w2, #1
	neg	w2, w2
	and	w4, w3, w1
	bic	w3, w3, w1
	str	w3, [x0, 4]
	ldr	w3, [x0, 12]
	add	w1, w1, w3
	add	w1, w1, w4
	and	w1, w1, w2
	str	w1, [x0, 12]
.L9:
	ret
	.size	area_align, .-area_align
	.align	2
	.p2align 5,,15
	.global	area_set_fullscreen
	.type	area_set_fullscreen, %function
area_set_fullscreen:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	adrp	x1, g_ebc
	str	xzr, [x0]
	ldr	x1, [x1, #:lo12:g_ebc]
	ldr	w2, [x1, 384]
	str	w2, [x0, 8]
	ldr	w1, [x1, 388]
	str	w1, [x0, 12]
	ret
	.size	area_set_fullscreen, .-area_set_fullscreen
	.align	2
	.p2align 5,,15
	.global	area_join
	.type	area_join, %function
area_join:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	ldr	w2, [x1, 8]
	cbz	w2, .L13
	ldr	w3, [x1, 12]
	cbnz	w3, .L26
.L13:
	ret
	.p2align 2,,3
.L26:
	ldr	w4, [x0, 8]
	cbz	w4, .L15
	ldr	w6, [x0, 12]
	cbz	w6, .L15
	ldp	w8, w7, [x1]
	ldp	w5, w1, [x0]
	add	w2, w2, w8
	add	w3, w3, w7
	cmp	w8, w5
	csel	w10, w8, w5, le
	cmp	w7, w1
	add	w5, w5, w4
	csel	w9, w7, w1, le
	cmp	w2, w5
	add	w1, w1, w6
	csel	w2, w2, w5, ge
	cmp	w3, w1
	csel	w3, w3, w1, ge
	sub	w2, w2, w10
	sub	w3, w3, w9
	stp	w10, w9, [x0]
	stp	w2, w3, [x0, 8]
	ret
	.p2align 2,,3
.L15:
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0]
	ret
	.size	area_join, .-area_join
	.align	2
	.p2align 5,,15
	.global	area_join_multi
	.type	area_join_multi, %function
area_join_multi:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	stp	xzr, xzr, [x0]
	cmp	w2, 0
	ble	.L27
	add	x2, x1, w2, uxtw 4
	b	.L32
	.p2align 2,,3
.L43:
	ldr	w6, [x0, 12]
	cbz	w6, .L30
	ldp	w10, w8, [x1]
	ldp	w9, w7, [x0]
	add	w3, w3, w10
	add	w4, w4, w8
	cmp	w10, w9
	add	w5, w5, w9
	csel	w12, w10, w9, le
	cmp	w8, w7
	csel	w11, w8, w7, le
	add	w6, w6, w7
	cmp	w3, w5
	stp	w12, w11, [x0]
	csel	w3, w3, w5, ge
	cmp	w4, w6
	csel	w4, w4, w6, ge
	sub	w3, w3, w12
	sub	w4, w4, w11
	stp	w3, w4, [x0, 8]
	.p2align 5,,15
.L29:
	add	x1, x1, 16
	cmp	x2, x1
	beq	.L27
.L32:
	ldr	w3, [x1, 8]
	cbz	w3, .L29
	ldr	w4, [x1, 12]
	cbz	w4, .L29
	ldr	w5, [x0, 8]
	cbnz	w5, .L43
.L30:
	ldp	x4, x5, [x1]
	add	x1, x1, 16
	stp	x4, x5, [x0]
	cmp	x2, x1
	bne	.L32
.L27:
	ret
	.size	area_join_multi, .-area_join_multi
	.align	2
	.p2align 5,,15
	.global	area_overlaps
	.type	area_overlaps, %function
area_overlaps:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4677
	.align	3
	.8byte	.LPFE4677
	.text
.LPFE4677:
	nop
	nop
	ldr	w2, [x0, 8]
	mov	w3, 0
	cbz	w2, .L45
	ldr	w4, [x0, 12]
	mov	w3, 0
	cbnz	w4, .L56
.L45:
	mov	w0, w3
	ret
	.p2align 2,,3
.L56:
	ldr	w5, [x1, 8]
	cbz	w5, .L45
	ldr	w6, [x1, 12]
	cbz	w6, .L45
	ldr	w8, [x0]
	ldr	w7, [x1]
	add	w2, w8, w2
	cmp	w2, w7
	ble	.L45
	add	w7, w7, w5
	cmp	w8, w7
	bge	.L45
	ldr	w2, [x0, 4]
	ldr	w0, [x1, 4]
	add	w4, w2, w4
	cmp	w4, w0
	ble	.L45
	add	w0, w0, w6
	cmp	w2, w0
	cset	w3, lt
	b	.L45
	.size	area_overlaps, .-area_overlaps
	.align	2
	.p2align 5,,15
	.global	area_covers
	.type	area_covers, %function
area_covers:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4678
	.align	3
	.8byte	.LPFE4678
	.text
.LPFE4678:
	nop
	nop
	ldr	w3, [x0, 8]
	mov	w2, 0
	cbz	w3, .L58
	ldr	w4, [x0, 12]
	mov	w2, 0
	cbnz	w4, .L69
.L58:
	mov	w0, w2
	ret
	.p2align 2,,3
.L69:
	ldr	w5, [x1, 8]
	mov	w2, 1
	cbz	w5, .L58
	ldr	w6, [x1, 12]
	cbz	w6, .L58
	ldr	w8, [x0]
	mov	w2, 0
	ldr	w7, [x1]
	cmp	w8, w7
	bgt	.L58
	add	w8, w8, w3
	add	w7, w7, w5
	cmp	w8, w7
	blt	.L58
	ldr	w3, [x0, 4]
	ldr	w0, [x1, 4]
	cmp	w3, w0
	bgt	.L58
	add	w3, w3, w4
	add	w0, w0, w6
	cmp	w3, w0
	cset	w2, ge
	b	.L58
	.size	area_covers, .-area_covers
	.align	2
	.p2align 5,,15
	.global	area_cut
	.type	area_cut, %function
area_cut:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4679
	.align	3
	.8byte	.LPFE4679
	.text
.LPFE4679:
	nop
	nop
	mov	x2, x0
	ldp	w0, w3, [x0, 8]
	cmp	w3, 0
	ccmp	w0, 0, 4, ne
	bne	.L71
	ldp	x4, x5, [x1]
	stp	x4, x5, [x2]
	stp	xzr, xzr, [x1]
	ldr	w0, [x2, 8]
	cbnz	w0, .L111
	ret
	.p2align 2,,3
.L111:
	ldr	w0, [x2, 12]
	cmp	w0, 0
	cset	w0, ne
	ret
	.p2align 2,,3
.L71:
	ldp	w4, w5, [x1, 8]
	cmp	w5, 0
	ccmp	w4, 0, 4, ne
	bne	.L112
.L107:
	mov	w0, 1
	ret
	.p2align 2,,3
.L112:
	ldr	w7, [x1]
	ldr	w6, [x2]
	add	w14, w4, w7
	sub	w11, w14, #1
	add	w0, w0, w6
	sub	w13, w0, #1
	cmp	w6, w11
	ccmp	w13, w7, 1, le
	blt	.L108
	ldr	w10, [x1, 4]
	ldr	w8, [x2, 4]
	add	w15, w5, w10
	sub	w12, w15, #1
	add	w3, w3, w8
	sub	w9, w3, #1
	cmp	w8, w12
	ccmp	w9, w10, 1, le
	blt	.L108
	cmp	w6, w7
	ccmp	w0, w14, 0, eq
	bne	.L77
	cmp	w8, w10
	csel	w8, w8, w10, le
	cmp	w9, w12
	csel	w0, w9, w12, ge
	str	w8, [x2, 4]
	sub	w0, w0, w8
	add	w0, w0, 1
	str	w0, [x2, 12]
	stp	xzr, xzr, [x1]
	b	.L107
	.p2align 2,,3
.L108:
	mov	w0, 2
	ret
	.p2align 2,,3
.L77:
	cmp	w8, w10
	ccmp	w3, w15, 0, eq
	bne	.L79
	cmp	w6, w7
	csel	w6, w6, w7, le
	cmp	w13, w11
	csel	w0, w13, w11, ge
	str	w6, [x2]
	sub	w0, w0, w6
	add	w0, w0, 1
	str	w0, [x2, 8]
	stp	xzr, xzr, [x1]
	b	.L107
.L79:
	cmp	w6, w7
	stp	x29, x30, [sp, -32]!
	cset	w16, le
	cmp	w13, w11
	mov	x29, sp
	cset	w18, ge
	cmp	w8, w10
	cset	w17, le
	cmp	w9, w12
	cset	w30, ge
	cmp	w17, 0
	ccmp	w30, 0, 4, ne
	str	x19, [sp, 16]
	cset	w19, ne
	cmp	w16, 0
	ccmp	w18, 0, 4, ne
	beq	.L80
	cbnz	w19, .L78
	cmp	w17, 0
	ccmp	w9, w12, 0, ne
	blt	.L90
	cmp	w30, 0
	sub	w0, w8, #1
	ccmp	w8, w10, 4, ne
	csel	w12, w0, w12, gt
.L81:
	add	w0, w11, 1
	add	w2, w12, 1
	sub	w0, w0, w7
	sub	w2, w2, w10
	stp	w7, w10, [x1]
	stp	w0, w2, [x1, 8]
	mov	w0, 2
.L70:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
.L82:
	cmp	w6, w7
	cset	w17, ge
	cmp	w13, w11
	cset	w16, le
	cmp	w8, w10
	cset	w30, ge
	cmp	w9, w12
	cset	w18, le
	cmp	w30, 0
	ccmp	w18, 0, 4, ne
	cset	w19, ne
	cmp	w17, 0
	ccmp	w16, 0, 4, ne
	beq	.L84
	cbz	w19, .L85
	stp	w7, w10, [x2]
	stp	w4, w5, [x2, 8]
.L78:
	mov	w0, 1
	stp	xzr, xzr, [x1]
	b	.L70
.L80:
	cbz	w19, .L82
	cmp	w16, 0
	ccmp	w13, w11, 0, ne
	blt	.L91
	cmp	w18, 0
	sub	w0, w6, #1
	ccmp	w6, w7, 4, ne
	csel	w11, w0, w11, gt
	b	.L81
.L90:
	mov	w10, w3
	b	.L81
.L91:
	mov	w7, w0
	b	.L81
.L84:
	cbz	w19, .L81
	cmp	w17, 0
	ccmp	w13, w11, 4, ne
	ble	.L89
	sub	w0, w0, w14
	str	w14, [x2]
	str	w0, [x2, 8]
	b	.L81
.L85:
	cmp	w30, 0
	ccmp	w9, w12, 4, ne
	ble	.L86
	sub	w3, w3, w15
	str	w15, [x2, 4]
	str	w3, [x2, 12]
	b	.L81
.L89:
	cmp	w16, 0
	ccmp	w6, w7, 0, ne
	bge	.L81
	sub	w6, w7, w6
	str	w6, [x2, 8]
	b	.L81
.L86:
	cmp	w18, 0
	ccmp	w8, w10, 0, ne
	bge	.L81
	sub	w8, w10, w8
	str	w8, [x2, 12]
	b	.L81
	.size	area_cut, .-area_cut
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
