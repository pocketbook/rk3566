// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_wflut.c"
	.text
	.align	2
	.p2align 5,,15
	.type	spread_sequences, %function
spread_sequences:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4679
	.align	3
	.8byte	.LPFE4679
	.text
.LPFE4679:
	nop
	nop
	mov	x3, x0
	and	w2, w2, 255
	cbz	w1, .L1
	ubfiz	x1, x1, 10, 32
	add	x9, x0, x1
	.p2align 5,,15
.L3:
	mov	w8, 33
	mov	w7, 0
	.p2align 5,,15
.L10:
	cmp	w7, 0
	ccmp	w2, 0, 4, eq
	cset	w6, ne
	bne	.L9
	mov	w0, w8
	mov	w4, 0
	b	.L5
	.p2align 2,,3
.L4:
	sub	w1, w0, #33
	sub	w5, w0, #32
	add	w4, w4, 2
	ldrb	w1, [x3, w1, sxtw]
	strb	w1, [x3, w0, sxtw]
	strb	w1, [x3, w5, sxtw]
	sub	w5, w0, #1
	strb	w1, [x3, w5, sxtw]
	cmp	w4, 32
	beq	.L19
	add	w0, w0, 2
	cbnz	w6, .L4
.L5:
	cmp	w2, 0
	ccmp	w7, 30, 0, ne
	ccmp	w4, 30, 0, eq
	bne	.L4
.L7:
	add	x3, x3, 1024
	cmp	x3, x9
	bne	.L3
.L1:
	ret
	.p2align 2,,3
.L9:
	add	w0, w8, 2
	mov	w4, 2
	b	.L4
	.p2align 2,,3
.L19:
	add	w7, w7, 2
	add	w8, w8, 64
	cmp	w7, 32
	bne	.L10
	b	.L7
	.size	spread_sequences, .-spread_sequences
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC wflut E waveform checksum error\n"
	.align	3
.LC1:
	.string	"\0016EBC wflut E waveform too large, no space to unpack\n"
	.align	3
.LC2:
	.string	"\0016EBC wflut E waveform sequence is empty\n"
	.text
	.align	2
	.p2align 5,,15
	.type	pvi_decode_waveform, %function
pvi_decode_waveform:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	adrp	x6, .LANCHOR0
	lsl	w3, w3, 2
	mov	x29, sp
	ldr	x6, [x6, #:lo12:.LANCHOR0]
	ldr	w7, [x6, 32]
	and	x7, x7, 16777215
	add	x3, x7, w3, sxtw
	add	x8, x6, x3
	ldrb	w7, [x6, x3]
	ldrb	w10, [x8, 1]
	ldrb	w9, [x8, 3]
	ldrb	w8, [x8, 2]
	add	w7, w7, w10
	add	w7, w7, w8
	cmp	w9, w7, uxtb
	bne	.L25
	ldr	w7, [x6, x3]
	lsl	w3, w4, 2
	and	x7, x7, 16777215
	add	x3, x7, w3, sxtw
	add	x7, x6, x3
	ldrb	w4, [x6, x3]
	ldrb	w9, [x7, 1]
	ldrb	w8, [x7, 3]
	ldrb	w7, [x7, 2]
	add	w4, w4, w9
	add	w4, w4, w7
	cmp	w8, w4, uxtb
	bne	.L25
	ldr	w3, [x6, x3]
	cmp	w2, 4
	cset	w4, eq
	and	w7, w3, 16777215
	and	x3, x3, 16777215
	add	x15, x6, x3
	add	w4, w4, 1
	ldrb	w6, [x6, w7, sxtw]
	cmp	w6, 255
	beq	.L27
	mov	w16, 1
	add	x7, x15, 1
	mov	w11, w16
	sub	w17, w1, #2
	mov	w3, 0
	mov	w2, 0
	mov	w10, 0
	.p2align 5,,15
.L39:
	cmp	w6, 252
	bne	.L28
	ldrb	w6, [x15, 1]
	eor	w16, w16, 1
	add	x7, x15, 2
.L28:
	mov	x15, x7
	mov	w9, 1
	tbz	x16, 0, .L29
	ldrb	w9, [x15], 1
	add	w9, w9, 1
.L29:
	cmp	w10, 255
	bhi	.L30
	cmp	w17, w10
	bls	.L30
	and	w14, w6, 3
	ubfx	x13, x6, 2, 2
	ubfx	x12, x6, 4, 2
	lsr	w8, w6, 6
	mov	w7, 0
	.p2align 5,,15
.L31:
	add	w1, w2, w4, lsl 2
	lsl	w6, w11, w3
	tst	w6, w5
	bne	.L36
	ands	w2, w1, 31
	bne	.L35
.L65:
	add	w3, w4, w3
	ands	w3, w3, 31
	bne	.L35
	add	w7, w7, 1
	add	w10, w10, 1
	add	x0, x0, 1024
	cmp	w9, w7
	beq	.L37
.L36:
	add	w1, w3, w2, lsl 5
	add	w2, w4, w2
	strb	w14, [x0, w1, uxtw]
	add	w1, w3, w2, lsl 5
	add	w2, w4, w2
	strb	w13, [x0, w1, uxtw]
	add	w1, w3, w2, lsl 5
	add	w2, w4, w2
	strb	w12, [x0, w1, uxtw]
	add	w1, w3, w2, lsl 5
	strb	w8, [x0, w1, uxtw]
	add	w1, w4, w2
	ands	w2, w1, 31
	beq	.L65
.L35:
	add	w7, w7, 1
	cmp	w7, w9
	bne	.L31
.L37:
	mov	x7, x15
	ldrb	w6, [x7], 1
	cmp	w6, 255
	bne	.L39
	cbz	w10, .L27
	sub	x0, x0, #1024
	cmn	w5, #1
	beq	.L43
	mov	x1, 0
	mov	w3, 1
	mov	w4, 8
	.p2align 5,,15
.L45:
	lsl	w2, w3, w1
	tst	w2, -1073741821
	beq	.L44
	strb	w4, [x0, x1]
.L44:
	add	x1, x1, 1
	cmp	x1, 2048
	bne	.L45
	add	w0, w10, 1
.L67:
	ldp	x29, x30, [sp], 32
	ret
.L30:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L66
.L32:
	mov	w0, -28
.L20:
	ldp	x29, x30, [sp], 32
	ret
.L43:
	mov	x2, 2048
	mov	w1, 8
	str	w10, [sp, 28]
	bl	memset
	ldr	w10, [sp, 28]
	add	w0, w10, 1
	b	.L67
.L25:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L22
	mov	w0, -22
	b	.L20
	.p2align 2,,3
.L27:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L68
	mov	w0, -61
	b	.L20
.L68:
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printk
	mov	w0, -61
	b	.L20
.L22:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	mov	w0, -22
	b	.L20
.L66:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printk
	b	.L32
	.size	pvi_decode_waveform, .-pvi_decode_waveform
	.section	.rodata.str1.8
	.align	3
.LC3:
	.string	"\0016EBC wflut E temperature value is wrong: %d\n"
	.align	3
.LC4:
	.string	"\0016EBC wflut E wf_load_luts: no waveform!\n"
	.align	3
.LC5:
	.string	"\0016EBC wflut E wf_load_luts: lut buffer is not initialized!\n"
	.align	3
.LC6:
	.string	"\0016EBC wflut I LUTs for %dC (index %d) ready\n"
	.align	3
.LC7:
	.string	"\0016EBC wflut I loading LUTs for %dC (index %d)\n"
	.align	3
.LC8:
	.string	"\0016EBC wflut D * %s %2d\n"
	.align	3
.LC9:
	.string	"\0016EBC wflut D transform_a2_waveform: DU=%d A2=%d\n"
	.align	3
.LC10:
	.string	"\0016EBC wflut D * %s %2d %4d %4d\n"
	.align	3
.LC11:
	.string	"\0016EBC wflut D unpacked waveform size: %d bytes\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wf_load_luts
	.type	wf_load_luts, %function
wf_load_luts:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4686
	.align	3
	.8byte	.LPFE4686
	.text
.LPFE4686:
	nop
	nop
	stp	x29, x30, [sp, -128]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	w19, w1
	stp	x21, x22, [sp, 32]
	adrp	x21, ebc_loglevel
	stp	x27, x28, [sp, 80]
	mov	x27, x0
	cmp	w1, 60
	ble	.L70
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L260
.L71:
	ldr	w19, [x27, 128]
.L70:
	adrp	x0, .LANCHOR0
	ldr	x1, [x0, #:lo12:.LANCHOR0]
	cbz	x1, .L261
	cbz	x27, .L75
	ldr	x0, [x27]
	cbz	x0, .L75
	stp	x25, x26, [sp, 64]
	ldrb	w3, [x1, 38]
	cbz	w3, .L187
	add	x1, x1, 48
	mov	w26, 0
	b	.L80
.L262:
	add	w26, w26, 1
	add	x1, x1, 1
	cmp	w3, w26
	beq	.L81
.L80:
	ldrb	w2, [x1]
	cmp	w19, w2
	bgt	.L262
	cmp	w3, w26
	beq	.L81
.L82:
	ldr	w1, [x27, 132]
	cmp	w1, w26
	beq	.L83
	tbnz	w1, #31, .L84
	ldr	w1, [x27, 128]
	add	w1, w1, 1
	cmp	w1, w19
	beq	.L83
.L84:
	stp	x23, x24, [sp, 48]
	mov	x2, 1024
	mov	w1, 8
	stp	w19, w26, [x27, 128]
	bl	memset
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L263
.L87:
	mov	w24, 1
	add	x20, x27, 64
	mov	w25, w24
	mov	x23, 0
	mov	w22, 1024
.L180:
	ldr	x1, [x27]
	ldr	w0, [x20]
	str	w0, [sp, 108]
	lsl	w0, w24, 10
	add	x19, x1, w0, sxtw
	ldp	w0, w1, [x27, 8]
	str	w1, [sp, 112]
	add	w10, w0, 1023
	cmp	w0, 0
	csel	w10, w10, w0, lt
	asr	w10, w10, 10
	sub	w28, w10, w24
	cmp	x23, 3
	beq	.L264
	sub	w8, w23, #2
	cmp	w8, 1
	bls	.L265
.L92:
	ldp	w3, w2, [sp, 108]
	str	wzr, [x20, 12]
	mov	w4, w26
	mov	w1, w28
	mov	x0, x19
	mov	w5, -1
	str	w8, [sp, 116]
	bl	pvi_decode_waveform
	mov	w9, w0
	tbnz	w0, #31, .L94
	ldr	w8, [sp, 116]
	cmp	x23, 1
	beq	.L266
.L95:
	ldr	w0, [sp, 108]
	cmp	x23, 0
	ccmp	w0, 1, 4, eq
	beq	.L267
	ldr	w2, [sp, 112]
	mov	w1, w28
	mov	w4, w26
	mov	x0, x19
	mov	w5, -1
	mov	w3, 1
	stp	w8, w9, [sp, 116]
	bl	pvi_decode_waveform
	mov	w1, w0
	cmp	w0, 0
	ble	.L94
	ldp	w8, w9, [sp, 116]
	add	w9, w0, w9
	cmp	w9, 31
	bgt	.L189
	add	w9, w9, w9, lsr 31
	asr	w2, w9, 1
	sub	w13, w2, #1
.L100:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	add	x28, x21, :lo12:ebc_loglevel
	cmp	w0, 2
	bgt	.L268
.L101:
	sub	w10, w1, #1
	add	x0, x19, 1054
	ubfiz	x13, x13, 10, 32
	add	x12, x19, 30
	add	x14, x13, 1024
	mov	x9, 30
	umaddl	x10, w10, w22, x0
	mov	w11, 8
.L110:
	sub	w15, w9, #30
	mov	x3, x12
	orr	w15, w15, 32
	mov	w0, w1
	add	w5, w15, 1
	mov	x16, x19
	sxtw	x5, w5
	.p2align 5,,15
.L103:
	sub	x17, x3, x9
	ldrb	w4, [x3]
	strb	w4, [x17, x5]
	mov	w17, w0
	sub	w0, w0, #1
	tbnz	x4, 3, .L190
	add	x16, x16, 1024
	add	x3, x3, 1024
	cbnz	w0, .L103
	mov	w4, -1
.L102:
	add	x3, x16, x5
	add	x17, x14, x3
	.p2align 5,,15
.L104:
	strb	w25, [x3]
	add	x3, x3, 1024
	cmp	x17, x3
	bne	.L104
	cbz	w0, .L109
	add	x16, x16, x13
	add	x0, x5, 1024
	add	x3, x5, 2048
	add	x0, x0, x16
	umaddl	x4, w4, w22, x16
	add	x3, x3, x4
	.p2align 5,,15
.L108:
	strb	w11, [x0]
	add	x0, x0, 1024
	cmp	x3, x0
	bne	.L108
.L109:
	add	w5, w15, 31
	mov	x0, x12
	sxtw	x5, w5
	.p2align 5,,15
.L107:
	sub	x3, x0, x9
	ldrb	w4, [x0]
	add	x0, x0, 1024
	strb	w4, [x3, x5]
	cmp	x10, x0
	bne	.L107
	add	x9, x9, 64
	add	x12, x12, 64
	add	x10, x10, 64
	cmp	x9, 1054
	bne	.L110
	adds	w9, w2, w1
	beq	.L112
	ubfiz	x3, x9, 10, 32
	sub	w4, w9, #1
	add	x3, x19, x3
	mov	x0, x19
	mov	w5, 8
.L113:
	strb	w5, [x0]
	add	x0, x0, 1024
	cmp	x0, x3
	bne	.L113
	mov	x0, x19
	mov	w5, 8
.L114:
	add	x0, x0, 1024
	strb	w5, [x0, -34]
	cmp	x0, x3
	bne	.L114
	mov	x0, x19
	mov	w5, 8
.L117:
	add	x0, x0, 1024
	strb	w5, [x0, -1]
	cmp	x0, x3
	bne	.L117
	mov	w0, w2
	neg	w1, w1
	mov	x3, x19
	mov	w5, 8
	cmp	w0, 0
	ble	.L269
.L118:
	sub	w0, w0, #1
	mov	w6, 2
	strb	w6, [x3, 30]
.L250:
	add	x3, x3, 1024
	cmp	w0, 0
	bgt	.L118
.L269:
	sub	w0, w0, #1
	strb	w5, [x3, 30]
	cmp	w0, w1
	bne	.L250
	mov	w0, w2
	mov	x3, x19
	mov	w5, 8
	cmp	w0, 0
	ble	.L270
.L121:
	sub	w0, w0, #1
	mov	w6, 2
	strb	w6, [x3, 62]
.L251:
	add	x3, x3, 1024
	cmp	w0, 0
	bgt	.L121
.L270:
	sub	w0, w0, #1
	strb	w5, [x3, 62]
	cmp	w0, w1
	bne	.L251
	mov	x3, x19
	mov	w0, w2
	mov	w10, 8
.L122:
	cmp	w0, 0
	ble	.L271
.L123:
	sub	w0, w0, #1
	strb	w25, [x3, 960]
	add	x3, x3, 1024
	cmp	w0, 0
	bgt	.L123
.L271:
	sub	w5, w0, #1
	strb	w10, [x3, 960]
	cmp	w1, w5
	beq	.L194
	add	x3, x3, 1024
	mov	w0, w5
	b	.L122
.L190:
	mov	w4, w0
	mov	w0, w17
	b	.L102
.L267:
	stp	w24, w9, [x20, 4]
	add	w24, w24, w9
	cbz	w9, .L272
.L98:
	adrp	x28, ebc_loglevel
	sub	w4, w9, #1
	add	x28, x28, :lo12:ebc_loglevel
.L131:
	mov	w5, 0
	mov	w3, 0
	mov	w2, 0
	mov	w0, 0
	b	.L139
.L135:
	cmp	w1, 1
	beq	.L273
	tbnz	x1, 3, .L138
.L136:
	add	w0, w0, 1
	cmp	w0, w9
	beq	.L138
.L139:
	lsl	w1, w0, 10
	ldrb	w1, [x19, w1, sxtw]
	cmp	w1, 2
	bne	.L135
	cmp	w3, 0
	add	w0, w0, 1
	cset	w1, gt
	add	w2, w2, 1
	orr	w5, w5, w1
	cmp	w0, w9
	bne	.L139
.L138:
	cbz	w5, .L144
	sub	w0, w0, #1
	cmp	w3, 0
	ble	.L145
	sub	w3, w0, w3
	b	.L146
.L147:
	lsl	w1, w0, 10
	sub	w0, w0, #1
	strb	w25, [x19, w1, sxtw]
	cmp	w3, w0
	beq	.L145
.L146:
	cmn	w0, #1
	bne	.L147
	cmn	w2, #1
	bge	.L144
.L149:
	lsl	w1, w0, 10
	sub	w0, w0, #1
	strb	wzr, [x19, w1, sxtw]
	cmp	w0, w2
	bne	.L149
.L150:
	cmp	w0, 0
	ccmp	w2, 0, 4, ge
	ble	.L144
	sub	w2, w2, w0
.L152:
	lsl	w1, w0, 10
	sub	w0, w0, #1
	mov	w3, 2
	strb	w3, [x19, w1, sxtw]
	add	w1, w2, w0
	cmp	w1, 0
	ccmn	w0, #1, 4, gt
	bne	.L152
.L144:
	cmp	w8, 1
	bls	.L115
	cmp	x23, 1
	beq	.L134
.L143:
	add	x0, x19, 2048
	add	x3, x19, 1024
	mov	x2, x3
	umaddl	x4, w4, w22, x0
.L174:
	mov	x0, x19
	.p2align 5,,15
.L173:
	ldrb	w1, [x0]
	tbnz	x1, 3, .L172
	orr	w1, w1, 4
	strb	w1, [x0]
.L172:
	add	x0, x0, 1
	cmp	x2, x0
	bne	.L173
	add	x2, x2, 1024
	mov	x19, x3
	cmp	x2, x4
	beq	.L116
	add	x3, x3, 1024
	b	.L174
.L273:
	add	w3, w3, 1
	b	.L136
.L272:
	cmp	w8, 1
	bls	.L274
	adrp	x28, ebc_loglevel
	add	x28, x28, :lo12:ebc_loglevel
	cmp	x23, 1
	beq	.L275
.L116:
	ldr	w0, [x28]
	cmp	w0, 2
	bgt	.L175
.L177:
	add	x23, x23, 1
	cmp	x23, 4
	beq	.L276
	add	x20, x20, 16
	b	.L180
.L194:
	mov	x3, x19
	mov	w1, w2
	mov	w5, 8
	b	.L124
.L125:
	strb	w25, [x3, 992]
.L252:
	sub	w1, w1, #1
	add	x3, x3, 1024
.L124:
	cmp	w1, 0
	bgt	.L125
	strb	w5, [x3, 992]
	cmp	w1, w0
	bne	.L252
	mov	x3, x19
	mov	w1, w2
	mov	w5, 8
	b	.L126
.L127:
	strb	w25, [x3, 961]
.L253:
	sub	w1, w1, #1
	add	x3, x3, 1024
.L126:
	cmp	w1, 0
	bgt	.L127
	strb	w5, [x3, 961]
	cmp	w1, w0
	bne	.L253
	mov	x1, x19
	mov	w3, 8
	b	.L128
.L129:
	strb	w25, [x1, 993]
.L254:
	sub	w2, w2, #1
	add	x1, x1, 1024
.L128:
	cmp	w2, 0
	bgt	.L129
	strb	w3, [x1, 993]
	cmp	w2, w0
	bne	.L254
	stp	w24, w9, [x20, 4]
	add	w24, w24, w9
	cmp	w9, 0
	bgt	.L131
	cmp	w8, 1
	bls	.L115
	cbnz	w9, .L143
	b	.L116
.L264:
	ldr	w2, [x27, 96]
	ldr	w0, [sp, 108]
	cmp	w2, w0
	beq	.L277
	mov	w8, 1
.L89:
	cmp	w26, 4
	ble	.L92
	mov	x3, 261120
	mov	x2, 261120
	mov	x0, x19
	mov	w1, 4
	add	x19, x19, x3
	str	w8, [sp, 116]
	bl	memset
	sub	w28, w28, #255
	ldp	w3, w2, [sp, 108]
	mov	w0, 255
	str	w0, [x20, 12]
	mov	w4, w26
	mov	w1, w28
	mov	x0, x19
	mov	w5, -1
	bl	pvi_decode_waveform
	ldr	w8, [sp, 116]
	mov	w9, w0
	tbnz	w0, #31, .L94
	add	w24, w24, 255
	b	.L95
	.p2align 2,,3
.L189:
	mov	w13, 14
	mov	w2, 15
	b	.L100
.L145:
	cmp	w0, w2
	ble	.L150
	lsl	w1, w0, 10
	sub	w0, w0, #1
	strb	wzr, [x19, w1, sxtw]
	cmp	w0, w2
	bne	.L149
	b	.L150
.L83:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 1
	bgt	.L278
.L86:
	ldp	x25, x26, [sp, 64]
	mov	w0, 0
.L69:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
.L276:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
.L91:
	cmp	w0, 2
	bgt	.L279
.L249:
	ldp	x23, x24, [sp, 48]
	b	.L86
.L81:
	sub	w26, w26, #1
	b	.L82
.L275:
	mov	w4, -1
.L134:
	mov	w1, w9
	mov	x0, x19
	mov	w2, 0
	stp	w9, w4, [sp, 112]
	bl	spread_sequences
	ldp	w9, w4, [sp, 112]
	cbnz	w9, .L143
	ldr	w0, [x28]
	cmp	w0, 2
	bgt	.L175
	add	x20, x20, 16
	mov	x23, 2
	b	.L180
	.p2align 2,,3
.L266:
	ldr	w2, [sp, 112]
	mov	w4, w26
	mov	w3, w23
	mov	w1, w28
	mov	x0, x19
	mov	w5, -1073741821
	stp	w8, w9, [sp, 116]
	bl	pvi_decode_waveform
	ldp	w8, w9, [sp, 116]
	tbnz	w0, #31, .L94
	stp	w24, w9, [x20, 4]
	add	w24, w24, w9
	cbnz	w9, .L98
	adrp	x28, ebc_loglevel
	mov	w4, -1
	add	x28, x28, :lo12:ebc_loglevel
	cmp	w8, 1
	bhi	.L134
	b	.L115
	.p2align 2,,3
.L277:
	ldr	x0, [x27, 100]
	str	x0, [x27, 116]
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L249
	adrp	x0, .LANCHOR1+24
	ldr	x1, [x0, #:lo12:.LANCHOR1+24]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printk
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	b	.L91
	.p2align 2,,3
.L112:
	stp	w24, wzr, [x27, 68]
	cmp	w8, 1
	bhi	.L116
	mov	w4, -1
.L115:
	ldr	w3, [x27, 12]
	mov	w1, w9
	mov	x0, x19
.L154:
	cbz	w1, .L280
	ldrb	w2, [x0]
	sub	w1, w1, #1
	strb	w2, [x0, 1]
	add	x0, x0, 1024
	b	.L154
	.p2align 2,,3
.L94:
	ldp	x23, x24, [sp, 48]
	mov	w0, -5
	ldp	x25, x26, [sp, 64]
	b	.L69
.L187:
	mov	w26, -1
	b	.L82
.L75:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L281
	mov	w0, -22
	b	.L69
.L280:
	mov	w1, w9
	mov	x0, x19
.L156:
	cbz	w1, .L282
	ldrb	w2, [x0, 32]
	sub	w1, w1, #1
	and	w2, w2, -4
	strb	w2, [x0, 32]
	add	x0, x0, 1024
	b	.L156
.L274:
	adrp	x28, ebc_loglevel
	mov	w4, -1
	add	x28, x28, :lo12:ebc_loglevel
	b	.L115
.L265:
	mov	w8, 0
	b	.L89
	.p2align 2,,3
.L261:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L283
	mov	w0, -19
	b	.L69
.L282:
	mov	w1, w9
	mov	x0, x19
.L158:
	cbz	w1, .L284
	ldrb	w2, [x0, 33]
	sub	w1, w1, #1
	and	w2, w2, -4
	strb	w2, [x0, 33]
	add	x0, x0, 1024
	b	.L158
.L284:
	mov	w1, w9
	mov	x0, x19
	cmp	w3, 4
	beq	.L160
.L161:
	cbz	w1, .L285
	ldrb	w2, [x0, 957]
	sub	w1, w1, #1
	add	x0, x0, 1024
	strb	w2, [x0, -34]
	b	.L161
.L160:
	cbz	w1, .L163
	ldrb	w2, [x0, 990]
	sub	w1, w1, #1
	add	x0, x0, 1024
	strb	w2, [x0, -2]
	b	.L160
.L163:
	mov	w1, w9
	mov	x0, x19
.L167:
	cbz	w1, .L286
	ldrb	w2, [x0, 991]
	sub	w1, w1, #1
	add	x0, x0, 1024
	and	w2, w2, -4
	strb	w2, [x0, -33]
	b	.L167
.L285:
	mov	w1, w9
	mov	x0, x19
.L165:
	cbz	w1, .L163
	ldrb	w2, [x0, 957]
	sub	w1, w1, #1
	add	x0, x0, 1024
	strb	w2, [x0, -2]
	b	.L165
.L286:
	mov	w1, w9
	mov	x0, x19
.L169:
	cbz	w1, .L287
	ldrb	w2, [x0, 1023]
	sub	w1, w1, #1
	add	x0, x0, 1024
	and	w2, w2, -4
	strb	w2, [x0, -1]
	b	.L169
.L287:
	mov	w1, w9
	mov	x0, x19
	mov	w2, 1
	stp	w9, w4, [sp, 112]
	bl	spread_sequences
	ldp	w9, w4, [sp, 112]
	cbnz	w9, .L143
	b	.L116
.L278:
	mov	w2, w26
	mov	w1, w19
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printk
	b	.L86
.L281:
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printk
	mov	w0, -22
	b	.L69
.L283:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printk
	mov	w0, -19
	b	.L69
.L263:
	mov	w2, w26
	mov	w1, w19
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printk
	b	.L87
.L279:
	lsl	w1, w24, 10
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printk
	ldp	x23, x24, [sp, 48]
	b	.L86
.L268:
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	stp	w1, w2, [sp, 112]
	stp	w8, w13, [sp, 120]
	bl	printk
	ldp	w1, w2, [sp, 112]
	ldp	w8, w13, [sp, 120]
	b	.L101
.L260:
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printk
	b	.L71
.L175:
	adrp	x0, .LANCHOR1
	add	x0, x0, :lo12:.LANCHOR1
	ldp	w3, w4, [x20, 4]
	ldr	x1, [x0, x23, lsl 3]
	adrp	x0, .LC10
	ldr	w2, [sp, 108]
	add	x0, x0, :lo12:.LC10
	bl	printk
	b	.L177
	.size	wf_load_luts, .-wf_load_luts
	.section	.rodata.str1.8
	.align	3
.LC12:
	.string	"\0016EBC wflut E waveform file is too small\n"
	.align	3
.LC13:
	.string	"\0016EBC wflut E unknown waveform mode version %02x\n"
	.align	3
.LC14:
	.string	"\0016EBC wflut I waveform name: %s\n"
	.align	3
.LC15:
	.string	"\0016EBC wflut I mode version:  %02x\n"
	.align	3
.LC16:
	.string	"\0016EBC wflut I bit count:     %d\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wf_lut_setup
	.type	wf_lut_setup, %function
wf_lut_setup:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4687
	.align	3
	.8byte	.LPFE4687
	.text
.LPFE4687:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	adrp	x7, ebc_loglevel
	mov	x29, sp
	ldr	w8, [x7, #:lo12:ebc_loglevel]
	cmp	w2, 1071
	bls	.L307
	mov	x6, x1
	adrp	x4, .LANCHOR2
	ldrb	w1, [x1, 16]
	mov	x5, x0
	add	x4, x4, :lo12:.LANCHOR2
	mov	w3, 7
	b	.L293
	.p2align 2,,3
.L309:
	ldrb	w3, [x4, 6]!
	cbz	w3, .L308
.L293:
	cmp	w1, w3
	bne	.L309
	ldrb	w0, [x4, 1]
	str	w0, [x5, 12]
	ldrb	w0, [x4, 2]
	str	w0, [x5, 64]
	ldrb	w0, [x4, 3]
	str	w0, [x5, 80]
	ldrb	w0, [x4, 4]
	str	w0, [x5, 96]
	ldrb	w0, [x4, 5]
	str	w0, [x5, 112]
	ldrb	w1, [x6, 29]
	ldrb	w0, [x6, 30]
	add	w0, w1, w0, lsl 8
	ldrb	w1, [x6, 28]
	add	w0, w1, w0, lsl 8
	cmp	w0, 63
	ccmp	w2, w0, 4, gt
	bgt	.L310
	strb	wzr, [x5, 16]
.L295:
	cmp	w8, 1
	bgt	.L311
.L298:
	adrp	x0, .LANCHOR0
	str	x6, [x0, #:lo12:.LANCHOR0]
	mov	x0, -65511
	movk	x0, 0x0, lsl 16
	str	x0, [x5, 128]
	mov	w0, 0
.L288:
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L310:
	ldrb	w2, [x6, w0, sxtw]
	add	w0, w0, 1
	mov	x1, 47
	stp	x5, x6, [sp, 16]
	cmp	w2, 47
	csel	x2, x2, x1, le
	add	x1, x6, w0, sxtw
	add	x0, x5, 16
	str	x2, [sp, 32]
	str	w8, [sp, 44]
	bl	memcpy
	ldp	x5, x6, [sp, 16]
	ldr	x2, [sp, 32]
	ldr	w8, [sp, 44]
	add	x2, x5, x2
	strb	wzr, [x2, 16]
	b	.L295
	.p2align 2,,3
.L308:
	cmp	w8, 0
	bgt	.L312
	mov	w0, -8
	b	.L288
.L307:
	cmp	w8, 0
	bgt	.L313
	mov	w0, -22
	b	.L288
.L313:
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printk
	mov	w0, -22
	b	.L288
.L312:
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	printk
	mov	w0, -8
	b	.L288
.L311:
	add	x1, x5, 16
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	stp	x5, x6, [sp, 16]
	bl	printk
	adrp	x7, ebc_loglevel
	ldp	x5, x6, [sp, 16]
	ldr	w0, [x7, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L298
	ldrb	w1, [x6, 16]
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	stp	x6, x5, [sp, 16]
	bl	printk
	adrp	x7, ebc_loglevel
	ldp	x6, x5, [sp, 16]
	ldr	w0, [x7, #:lo12:ebc_loglevel]
	cmp	w0, 1
	ble	.L298
	ldr	w1, [x5, 12]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	stp	x5, x6, [sp, 16]
	bl	printk
	ldp	x5, x6, [sp, 16]
	b	.L298
	.size	wf_lut_setup, .-wf_lut_setup
	.align	2
	.p2align 5,,15
	.global	wf_lut_initial_pointer
	.type	wf_lut_initial_pointer, %function
wf_lut_initial_pointer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4688
	.align	3
	.8byte	.LPFE4688
	.text
.LPFE4688:
	nop
	nop
	ldrsw	x1, [x0, 8]
	mov	x2, -67108864
	ldr	x0, [x0]
	add	x1, x1, x2
	add	x0, x0, x1
	ret
	.size	wf_lut_initial_pointer, .-wf_lut_initial_pointer
	.align	2
	.p2align 5,,15
	.global	wf_lut_pointer_valid
	.type	wf_lut_pointer_valid, %function
wf_lut_pointer_valid:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4689
	.align	3
	.8byte	.LPFE4689
	.text
.LPFE4689:
	nop
	nop
	ldr	x0, [x0]
	add	x1, x1, 1024
	cmp	x0, x1
	cset	w0, hi
	ret
	.size	wf_lut_pointer_valid, .-wf_lut_pointer_valid
	.align	2
	.p2align 5,,15
	.global	wf_lut_frameoffset_value
	.type	wf_lut_frameoffset_value, %function
wf_lut_frameoffset_value:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4690
	.align	3
	.8byte	.LPFE4690
	.text
.LPFE4690:
	nop
	nop
	ubfiz	x2, x2, 4, 2
	add	x2, x0, x2
	ldr	x0, [x0]
	ldr	w2, [x2, 68]
	lsl	w2, w2, 10
	add	x0, x0, x2
	sub	x0, x0, x1
	lsl	w0, w0, 6
	ret
	.size	wf_lut_frameoffset_value, .-wf_lut_frameoffset_value
	.align	2
	.p2align 5,,15
	.global	wf_lut_can_use_tmask
	.type	wf_lut_can_use_tmask, %function
wf_lut_can_use_tmask:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4691
	.align	3
	.8byte	.LPFE4691
	.text
.LPFE4691:
	nop
	nop
	and	w2, w1, 112
	cmp	w2, 16
	beq	.L320
	mov	w0, 0
	ret
	.p2align 2,,3
.L320:
	ubfiz	x1, x1, 4, 2
	add	x0, x0, x1
	ldr	w0, [x0, 76]
	cmp	w0, 0
	cset	w0, ne
	ret
	.size	wf_lut_can_use_tmask, .-wf_lut_can_use_tmask
	.global	wf_qual_strings
	.section	.rodata.str1.8
	.align	3
.LC17:
	.string	"DF"
	.align	3
.LC18:
	.string	"UI"
	.align	3
.LC19:
	.string	"TX"
	.align	3
.LC20:
	.string	"IM"
	.global	wf_mode_strings
	.align	3
.LC21:
	.string	"0"
	.align	3
.LC22:
	.string	"GC"
	.align	3
.LC23:
	.string	"GU"
	.align	3
.LC24:
	.string	"GLD"
	.align	3
.LC25:
	.string	"GLN"
	.align	3
.LC26:
	.string	"5"
	.align	3
.LC27:
	.string	"IN"
	.align	3
.LC28:
	.string	"7"
	.section	.rodata
	.align	3
	.set	.LANCHOR2,. + 0
	.type	wf_modes, %object
	.size	wf_modes, 78
wf_modes:
	.byte	7
	.byte	4
	.base64	"BAMCAg=="
	.byte	9
	.byte	4
	.base64	"BAICAg=="
	.byte	18
	.byte	4
	.base64	"BAMCAg=="
	.byte	22
	.byte	5
	.base64	"BgIDBA=="
	.byte	24
	.byte	5
	.base64	"BgIEBA=="
	.byte	25
	.byte	5
	.base64	"BgIEBA=="
	.byte	32
	.byte	5
	.base64	"BgIEBA=="
	.byte	35
	.byte	4
	.base64	"BAICAg=="
	.byte	67
	.byte	5
	.base64	"BgIEBQ=="
	.byte	72
	.byte	5
	.base64	"BgIEBA=="
	.byte	84
	.byte	4
	.base64	"BQICBA=="
	.byte	114
	.byte	5
	.base64	"BgIEBA=="
	.byte	0
	.zero	5
	.data
	.align	3
	.set	.LANCHOR1,. + 0
	.type	wf_qual_strings, %object
	.size	wf_qual_strings, 32
wf_qual_strings:
	.xword	.LC17
	.xword	.LC18
	.xword	.LC19
	.xword	.LC20
	.type	wf_mode_strings, %object
	.size	wf_mode_strings, 64
wf_mode_strings:
	.xword	.LC21
	.xword	.LC22
	.xword	.LC23
	.xword	.LC24
	.xword	.LC25
	.xword	.LC26
	.xword	.LC27
	.xword	.LC28
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	pvi_global_waveform, %object
	.size	pvi_global_waveform, 8
pvi_global_waveform:
	.zero	8
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
