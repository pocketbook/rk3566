// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_wffpu_index.c"
	.text
	.align	2
	.p2align 5,,15
	.type	make_index_line_gu_first, %function
make_index_line_gu_first:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4672
	.align	3
	.8byte	.LPFE4672
	.text
.LPFE4672:
	nop
	nop
	ldr	x2, [x0]
	mov	x8, x0
	ldr	x0, [x1]
	add	x11, x1, 8
	mov	x9, x11
	eor	x1, x2, x0
	and	x0, x0, -1085102592571150096
	and	x6, x1, x6
	and	x1, x2, -1085102592571150096
	eor	x2, x2, x6
	and	x10, x6, -1085102592571150096
	and	x2, x2, -1085102592571150096
	str	x2, [x8], 8
	tst	x6, 240
	beq	.L2
	lsl	w2, w0, 3
	lsl	w12, w1, 8
	and	w2, w2, 1984
	and	w12, w12, 65535
	orr	w2, w2, w4
	orr	w2, w2, w12
	str	w2, [x3]
.L2:
	tst	x6, 61440
	beq	.L3
	lsr	x2, x0, 11
	and	w12, w1, 63488
	orr	w12, w12, w4
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w12
	str	w2, [x3, 4]
.L3:
	tst	x6, 15728640
	beq	.L4
	lsr	x2, x0, 19
	lsr	x12, x1, 19
	ubfiz	w2, w2, 6, 5
	lsl	w12, w12, 11
	orr	w2, w2, w4
	and	w12, w12, 65535
	orr	w2, w2, w12
	str	w2, [x3, 8]
.L4:
	tst	x6, 4026531840
	beq	.L5
	lsr	x2, x0, 27
	lsr	x12, x1, 27
	ubfiz	w2, w2, 6, 5
	lsl	w12, w12, 11
	orr	w2, w2, w4
	and	w12, w12, 65535
	orr	w2, w2, w12
	str	w2, [x3, 12]
.L5:
	tst	x6, 1030792151040
	beq	.L6
	lsr	x2, x0, 35
	lsr	x12, x1, 35
	ubfiz	w2, w2, 6, 5
	lsl	w12, w12, 11
	orr	w2, w2, w4
	and	w12, w12, 65535
	orr	w2, w2, w12
	str	w2, [x3, 16]
.L6:
	tst	x6, 263882790666240
	beq	.L7
	lsr	x2, x0, 43
	lsr	x12, x1, 43
	ubfiz	w2, w2, 6, 5
	lsl	w12, w12, 11
	orr	w2, w2, w4
	and	w12, w12, 65535
	orr	w2, w2, w12
	str	w2, [x3, 20]
.L7:
	tst	x6, 67553994410557440
	beq	.L8
	lsr	x2, x0, 51
	lsr	x6, x1, 51
	ubfiz	w2, w2, 6, 5
	lsl	w6, w6, 11
	orr	w2, w2, w4
	and	w6, w6, 65535
	orr	w2, w2, w6
	str	w2, [x3, 24]
.L8:
	mov	x2, 72057594037927935
	cmp	x10, x2
	bls	.L9
	lsr	x0, x0, 59
	lsr	x1, x1, 59
	orr	w0, w4, w0, lsl 6
	orr	w0, w0, w1, lsl 11
	str	w0, [x3, 28]
.L9:
	sub	w10, w5, #8
	add	x3, x3, 32
	cmp	w10, 8
	ble	.L10
	mov	x12, 72057594037927935
	.p2align 5,,15
.L19:
	ldr	x0, [x8]
	ldr	x1, [x9], 8
	and	x2, x0, -1085102592571150096
	eor	x0, x0, x1
	and	x1, x1, -1085102592571150096
	str	x1, [x8], 8
	and	x13, x0, -1085102592571150096
	tst	x0, 240
	beq	.L11
	lsl	w6, w1, 3
	lsl	w14, w2, 8
	and	w6, w6, 1984
	and	w14, w14, 65535
	orr	w6, w6, w4
	orr	w6, w6, w14
	str	w6, [x3]
.L11:
	tst	x0, 61440
	beq	.L12
	lsr	x6, x1, 11
	and	w14, w2, 63488
	ubfiz	w6, w6, 6, 5
	orr	w6, w6, w4
	orr	w6, w6, w14
	str	w6, [x3, 4]
.L12:
	tst	x0, 15728640
	beq	.L13
	lsr	x6, x1, 19
	lsr	x14, x2, 19
	ubfiz	w6, w6, 6, 5
	lsl	w14, w14, 11
	orr	w6, w6, w4
	and	w14, w14, 65535
	orr	w6, w6, w14
	str	w6, [x3, 8]
.L13:
	tst	x0, 4026531840
	beq	.L14
	lsr	x6, x1, 27
	lsr	x14, x2, 27
	ubfiz	w6, w6, 6, 5
	lsl	w14, w14, 11
	orr	w6, w6, w4
	and	w14, w14, 65535
	orr	w6, w6, w14
	str	w6, [x3, 12]
.L14:
	tst	x0, 1030792151040
	beq	.L15
	lsr	x6, x1, 35
	lsr	x14, x2, 35
	ubfiz	w6, w6, 6, 5
	lsl	w14, w14, 11
	orr	w6, w6, w4
	and	w14, w14, 65535
	orr	w6, w6, w14
	str	w6, [x3, 16]
.L15:
	tst	x0, 263882790666240
	beq	.L16
	lsr	x6, x1, 43
	lsr	x14, x2, 43
	ubfiz	w6, w6, 6, 5
	lsl	w14, w14, 11
	orr	w6, w6, w4
	and	w14, w14, 65535
	orr	w6, w6, w14
	str	w6, [x3, 20]
.L16:
	tst	x0, 67553994410557440
	beq	.L17
	lsr	x0, x1, 51
	lsr	x6, x2, 51
	ubfiz	w0, w0, 6, 5
	lsl	w6, w6, 11
	orr	w0, w0, w4
	and	w6, w6, 65535
	orr	w0, w0, w6
	str	w0, [x3, 24]
.L17:
	cmp	x13, x12
	bls	.L18
	lsr	x1, x1, 59
	lsr	x2, x2, 59
	orr	w1, w4, w1, lsl 6
	orr	w2, w1, w2, lsl 11
	str	w2, [x3, 28]
.L18:
	add	w0, w9, 8
	add	x3, x3, 32
	sub	w0, w0, w11
	cmp	w10, w0
	bgt	.L19
.L10:
	cmp	w5, 8
	ble	.L1
	ldr	x1, [x8]
	ldr	x0, [x9]
	and	x2, x1, -1085102592571150096
	and	x5, x0, -1085102592571150096
	eor	x0, x1, x0
	and	x0, x0, x7
	eor	x1, x1, x0
	and	x6, x0, -1085102592571150096
	and	x1, x1, -1085102592571150096
	str	x1, [x8]
	tst	x0, 240
	beq	.L22
	lsl	w1, w2, 8
	lsl	w7, w5, 3
	and	w1, w1, 65535
	and	w7, w7, 1984
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3]
.L22:
	tst	x0, 61440
	beq	.L23
	lsr	x1, x5, 11
	and	w7, w2, 63488
	orr	w7, w7, w4
	ubfiz	w1, w1, 6, 5
	orr	w1, w1, w7
	str	w1, [x3, 4]
.L23:
	tst	x0, 15728640
	beq	.L24
	lsr	x1, x2, 19
	lsr	x7, x5, 19
	lsl	w1, w1, 11
	ubfiz	w7, w7, 6, 5
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 8]
.L24:
	tst	x0, 4026531840
	beq	.L25
	lsr	x1, x2, 27
	lsr	x7, x5, 27
	lsl	w1, w1, 11
	ubfiz	w7, w7, 6, 5
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 12]
.L25:
	tst	x0, 1030792151040
	beq	.L26
	lsr	x1, x2, 35
	lsr	x7, x5, 35
	lsl	w1, w1, 11
	ubfiz	w7, w7, 6, 5
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 16]
.L26:
	tst	x0, 263882790666240
	beq	.L27
	lsr	x1, x2, 43
	lsr	x7, x5, 43
	lsl	w1, w1, 11
	ubfiz	w7, w7, 6, 5
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 20]
.L27:
	tst	x0, 67553994410557440
	beq	.L28
	lsr	x0, x2, 51
	lsr	x1, x5, 51
	lsl	w0, w0, 11
	ubfiz	w1, w1, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w1
	orr	w0, w0, w4
	str	w0, [x3, 24]
.L28:
	mov	x0, 72057594037927935
	cmp	x6, x0
	bls	.L1
	lsr	x1, x5, 59
	lsr	x0, x2, 59
	lsl	w1, w1, 6
	orr	w0, w1, w0, lsl 11
	orr	w0, w0, w4
	str	w0, [x3, 28]
.L1:
	ret
	.size	make_index_line_gu_first, .-make_index_line_gu_first
	.align	2
	.p2align 5,,15
	.type	make_index_line_gu_next, %function
make_index_line_gu_next:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	ldr	x2, [x0]
	mov	x8, x0
	ldr	x0, [x1]
	add	x10, x1, 8
	and	x11, x2, -1085102592571150096
	mov	x9, x10
	eor	x1, x2, x0
	and	x0, x0, -1085102592571150096
	and	x6, x1, x6
	eor	x2, x2, x6
	and	x12, x6, -1085102592571150096
	and	x2, x2, -1085102592571150096
	str	x2, [x8], 8
	tst	x6, 240
	beq	.L96
	ldr	w2, [x3]
	tst	x2, 63
	beq	.L97
	lsr	x1, x0, 3
	and	w2, w2, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w2
	orr	w1, w1, 1
	str	w1, [x3]
.L96:
	tst	x6, 61440
	beq	.L99
	ldr	w13, [x3, 4]
	lsr	x2, x0, 11
	tst	x13, 63
	beq	.L100
	ubfiz	w1, w2, 1, 5
	and	w13, w13, -63
	orr	w1, w1, w13
	orr	w1, w1, 1
	str	w1, [x3, 4]
.L99:
	tst	x6, 15728640
	beq	.L102
	ldr	w13, [x3, 8]
	lsr	x2, x0, 19
	tst	x13, 63
	beq	.L103
	ubfiz	w1, w2, 1, 5
	and	w13, w13, -63
	orr	w1, w1, w13
	orr	w1, w1, 1
	str	w1, [x3, 8]
.L102:
	tst	x6, 4026531840
	beq	.L105
	ldr	w13, [x3, 12]
	lsr	x2, x0, 27
	tst	x13, 63
	beq	.L106
	ubfiz	w1, w2, 1, 5
	and	w13, w13, -63
	orr	w1, w1, w13
	orr	w1, w1, 1
	str	w1, [x3, 12]
.L105:
	tst	x6, 1030792151040
	beq	.L108
	ldr	w13, [x3, 16]
	lsr	x2, x0, 35
	tst	x13, 63
	beq	.L109
	ubfiz	w1, w2, 1, 5
	and	w13, w13, -63
	orr	w1, w1, w13
	orr	w1, w1, 1
	str	w1, [x3, 16]
.L108:
	tst	x6, 263882790666240
	beq	.L111
	ldr	w13, [x3, 20]
	lsr	x2, x0, 43
	tst	x13, 63
	beq	.L112
	ubfiz	w1, w2, 1, 5
	and	w13, w13, -63
	orr	w1, w1, w13
	orr	w1, w1, 1
	str	w1, [x3, 20]
.L111:
	tst	x6, 67553994410557440
	beq	.L114
	ldr	w6, [x3, 24]
	lsr	x2, x0, 51
	tst	x6, 63
	beq	.L115
	ubfiz	w1, w2, 1, 5
	and	w6, w6, -63
	orr	w1, w1, w6
	orr	w1, w1, 1
	str	w1, [x3, 24]
.L114:
	mov	x1, 72057594037927935
	cmp	x12, x1
	bls	.L117
	ldr	w1, [x3, 28]
	lsr	x0, x0, 59
	tst	x1, 63
	beq	.L118
	and	w1, w1, -63
	orr	w0, w1, w0, lsl 1
	orr	w0, w0, 1
	str	w0, [x3, 28]
.L117:
	sub	w6, w5, #8
	add	x3, x3, 32
	cmp	w6, 8
	ble	.L120
	mov	x11, 72057594037927935
	.p2align 5,,15
.L145:
	ldr	x0, [x8]
	ldr	x2, [x9], 8
	and	x13, x0, -1085102592571150096
	and	x12, x2, -1085102592571150096
	eor	x0, x0, x2
	str	x12, [x8], 8
	and	x14, x0, -1085102592571150096
	tst	x0, 240
	beq	.L121
	ldr	w2, [x3]
	tst	x2, 63
	beq	.L122
	lsr	x1, x12, 3
	and	w2, w2, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w2
	orr	w1, w1, 1
.L123:
	str	w1, [x3]
.L121:
	tst	x0, 61440
	beq	.L124
	ldr	w1, [x3, 4]
	lsr	x2, x12, 11
	tst	x1, 63
	beq	.L125
	ubfiz	w2, w2, 1, 5
	and	w1, w1, -63
	orr	w2, w2, w1
	orr	w2, w2, 1
.L126:
	str	w2, [x3, 4]
.L124:
	tst	x0, 15728640
	beq	.L127
	ldr	w1, [x3, 8]
	lsr	x2, x12, 19
	tst	x1, 63
	beq	.L128
	and	w1, w1, -63
	ubfiz	w2, w2, 1, 5
	orr	w2, w2, w1
	orr	w1, w2, 1
.L129:
	str	w1, [x3, 8]
.L127:
	tst	x0, 4026531840
	beq	.L130
	ldr	w1, [x3, 12]
	lsr	x2, x12, 27
	tst	x1, 63
	beq	.L131
	and	w1, w1, -63
	ubfiz	w2, w2, 1, 5
	orr	w2, w2, w1
	orr	w1, w2, 1
.L132:
	str	w1, [x3, 12]
.L130:
	tst	x0, 1030792151040
	beq	.L133
	ldr	w1, [x3, 16]
	lsr	x2, x12, 35
	tst	x1, 63
	beq	.L134
	and	w1, w1, -63
	ubfiz	w2, w2, 1, 5
	orr	w2, w2, w1
	orr	w1, w2, 1
.L135:
	str	w1, [x3, 16]
.L133:
	tst	x0, 263882790666240
	beq	.L136
	ldr	w1, [x3, 20]
	lsr	x2, x12, 43
	tst	x1, 63
	beq	.L137
	and	w1, w1, -63
	ubfiz	w2, w2, 1, 5
	orr	w2, w2, w1
	orr	w1, w2, 1
.L138:
	str	w1, [x3, 20]
.L136:
	tst	x0, 67553994410557440
	beq	.L139
	ldr	w0, [x3, 24]
	lsr	x1, x12, 51
	tst	x0, 63
	beq	.L140
	and	w0, w0, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w0
	orr	w0, w1, 1
.L141:
	str	w0, [x3, 24]
.L139:
	cmp	x14, x11
	bls	.L142
	ldr	w1, [x3, 28]
	lsr	x0, x12, 59
	tst	x1, 63
	beq	.L143
	and	w1, w1, -63
	orr	w0, w1, w0, lsl 1
	orr	w0, w0, 1
.L144:
	str	w0, [x3, 28]
.L142:
	add	w0, w9, 8
	add	x3, x3, 32
	sub	w0, w0, w10
	cmp	w6, w0
	bgt	.L145
.L120:
	cmp	w5, 8
	ble	.L95
	ldr	x1, [x8]
	ldr	x2, [x9]
	and	x6, x1, -1085102592571150096
	and	x5, x2, -1085102592571150096
	eor	x2, x1, x2
	and	x0, x2, x7
	eor	x1, x1, x0
	and	x2, x0, -1085102592571150096
	and	x1, x1, -1085102592571150096
	str	x1, [x8]
	tst	x0, 240
	beq	.L148
	ldr	w7, [x3]
	tst	x7, 63
	beq	.L149
	lsr	x1, x5, 3
	and	w7, w7, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w7
	orr	w1, w1, 1
	str	w1, [x3]
.L148:
	tst	x0, 61440
	beq	.L151
	ldr	w8, [x3, 4]
	lsr	x7, x5, 11
	tst	x8, 63
	beq	.L152
	ubfiz	w1, w7, 1, 5
	and	w8, w8, -63
	orr	w1, w1, w8
	orr	w1, w1, 1
	str	w1, [x3, 4]
.L151:
	tst	x0, 15728640
	beq	.L154
	ldr	w8, [x3, 8]
	lsr	x7, x5, 19
	tst	x8, 63
	beq	.L155
	ubfiz	w1, w7, 1, 5
	and	w8, w8, -63
	orr	w1, w1, w8
	orr	w1, w1, 1
	str	w1, [x3, 8]
.L154:
	tst	x0, 4026531840
	beq	.L157
	ldr	w8, [x3, 12]
	lsr	x7, x5, 27
	tst	x8, 63
	beq	.L158
	ubfiz	w1, w7, 1, 5
	and	w8, w8, -63
	orr	w1, w1, w8
	orr	w1, w1, 1
	str	w1, [x3, 12]
.L157:
	tst	x0, 1030792151040
	beq	.L160
	ldr	w8, [x3, 16]
	lsr	x7, x5, 35
	tst	x8, 63
	beq	.L161
	ubfiz	w1, w7, 1, 5
	and	w8, w8, -63
	orr	w1, w1, w8
	orr	w1, w1, 1
	str	w1, [x3, 16]
.L160:
	tst	x0, 263882790666240
	beq	.L163
	ldr	w8, [x3, 20]
	lsr	x7, x5, 43
	tst	x8, 63
	beq	.L164
	ubfiz	w1, w7, 1, 5
	and	w8, w8, -63
	orr	w1, w1, w8
	orr	w1, w1, 1
	str	w1, [x3, 20]
.L163:
	tst	x0, 67553994410557440
	beq	.L166
	ldr	w7, [x3, 24]
	lsr	x1, x5, 51
	tst	x7, 63
	beq	.L167
	ubfiz	w0, w1, 1, 5
	and	w7, w7, -63
	orr	w0, w0, w7
	orr	w0, w0, 1
	str	w0, [x3, 24]
.L166:
	mov	x0, 72057594037927935
	cmp	x2, x0
	bls	.L95
	ldr	w1, [x3, 28]
	lsr	x0, x5, 59
	tst	x1, 63
	beq	.L170
	and	w1, w1, -63
	orr	w0, w1, w0, lsl 1
	orr	w0, w0, 1
	str	w0, [x3, 28]
.L95:
	ret
	.p2align 2,,3
.L143:
	lsr	x1, x13, 59
	orr	w0, w4, w0, lsl 6
	orr	w0, w0, w1, lsl 11
	b	.L144
	.p2align 2,,3
.L140:
	lsr	x0, x13, 51
	ubfiz	w1, w1, 6, 5
	orr	w1, w1, w4
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w1
	b	.L141
	.p2align 2,,3
.L137:
	lsr	x1, x13, 43
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	b	.L138
	.p2align 2,,3
.L134:
	lsr	x1, x13, 35
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	b	.L135
	.p2align 2,,3
.L131:
	lsr	x1, x13, 27
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	b	.L132
	.p2align 2,,3
.L128:
	lsr	x1, x13, 19
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	b	.L129
	.p2align 2,,3
.L122:
	lsl	w1, w12, 3
	lsl	w2, w13, 8
	and	w1, w1, 1984
	and	w2, w2, 65535
	orr	w1, w1, w4
	orr	w1, w1, w2
	b	.L123
	.p2align 2,,3
.L125:
	ubfiz	w2, w2, 6, 5
	and	w1, w13, 63488
	orr	w2, w2, w4
	orr	w2, w2, w1
	b	.L126
	.p2align 2,,3
.L118:
	lsr	x1, x11, 59
	orr	w0, w4, w0, lsl 6
	orr	w0, w0, w1, lsl 11
	str	w0, [x3, 28]
	b	.L117
	.p2align 2,,3
.L115:
	lsr	x1, x11, 51
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 24]
	b	.L114
	.p2align 2,,3
.L112:
	lsr	x1, x11, 43
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 20]
	b	.L111
	.p2align 2,,3
.L109:
	lsr	x1, x11, 35
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 16]
	b	.L108
	.p2align 2,,3
.L106:
	lsr	x1, x11, 27
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 12]
	b	.L105
	.p2align 2,,3
.L103:
	lsr	x1, x11, 19
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 8]
	b	.L102
	.p2align 2,,3
.L100:
	and	w1, w11, 63488
	ubfiz	w2, w2, 6, 5
	orr	w1, w1, w4
	orr	w1, w1, w2
	str	w1, [x3, 4]
	b	.L99
	.p2align 2,,3
.L97:
	lsl	w1, w0, 3
	lsl	w2, w11, 8
	and	w1, w1, 1984
	and	w2, w2, 65535
	orr	w1, w1, w4
	orr	w1, w1, w2
	str	w1, [x3]
	b	.L96
	.p2align 2,,3
.L149:
	lsl	w1, w6, 8
	lsl	w7, w5, 3
	and	w1, w1, 65535
	and	w7, w7, 1984
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3]
	b	.L148
	.p2align 2,,3
.L152:
	and	w1, w6, 63488
	ubfiz	w7, w7, 6, 5
	orr	w1, w1, w4
	orr	w1, w1, w7
	str	w1, [x3, 4]
	b	.L151
	.p2align 2,,3
.L155:
	lsr	x1, x6, 19
	ubfiz	w7, w7, 6, 5
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 8]
	b	.L154
	.p2align 2,,3
.L158:
	lsr	x1, x6, 27
	ubfiz	w7, w7, 6, 5
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 12]
	b	.L157
	.p2align 2,,3
.L161:
	lsr	x1, x6, 35
	ubfiz	w7, w7, 6, 5
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 16]
	b	.L160
	.p2align 2,,3
.L164:
	lsr	x1, x6, 43
	ubfiz	w7, w7, 6, 5
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w7
	orr	w1, w1, w4
	str	w1, [x3, 20]
	b	.L163
	.p2align 2,,3
.L167:
	lsr	x0, x6, 51
	ubfiz	w1, w1, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w1
	orr	w0, w0, w4
	str	w0, [x3, 24]
	b	.L166
	.p2align 2,,3
.L170:
	lsr	x6, x6, 59
	lsl	w0, w0, 6
	orr	w0, w0, w6, lsl 11
	orr	w0, w0, w4
	str	w0, [x3, 28]
	b	.L95
	.size	make_index_line_gu_next, .-make_index_line_gu_next
	.align	2
	.p2align 5,,15
	.type	make_index_line_gc_first, %function
make_index_line_gc_first:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x17, x0
	add	x30, x1, 8
	mov	x29, sp
	mov	x18, x30
	stp	x19, x20, [sp, 16]
	mov	w19, w5
	ldr	x8, [x0]
	ldr	x0, [x1]
	and	x2, x8, -1085102592571150096
	eor	x1, x8, x0
	and	x0, x0, -1085102592571150096
	and	x1, x1, x6
	eor	x1, x1, x8
	and	x1, x1, -1085102592571150096
	str	x1, [x17], 8
	tst	w6, 255
	beq	.L237
	lsl	w1, w0, 3
	lsl	w5, w2, 8
	and	w1, w1, 1984
	and	w5, w5, 65535
	orr	w1, w1, w4
	orr	w1, w1, w5
	str	w1, [x3]
.L237:
	tst	x6, 65280
	beq	.L238
	lsr	x1, x0, 11
	and	w5, w2, 63488
	orr	w5, w5, w4
	ubfiz	w1, w1, 6, 5
	orr	w1, w1, w5
	str	w1, [x3, 4]
.L238:
	tst	x6, 16711680
	beq	.L239
	lsr	x1, x0, 19
	lsr	x5, x2, 19
	ubfiz	w1, w1, 6, 5
	lsl	w5, w5, 11
	orr	w1, w1, w4
	and	w5, w5, 65535
	orr	w1, w1, w5
	str	w1, [x3, 8]
.L239:
	tst	x6, 4278190080
	beq	.L240
	lsr	x1, x0, 27
	lsr	x5, x2, 27
	ubfiz	w1, w1, 6, 5
	lsl	w5, w5, 11
	orr	w1, w1, w4
	and	w5, w5, 65535
	orr	w1, w1, w5
	str	w1, [x3, 12]
.L240:
	tst	x6, 1095216660480
	beq	.L241
	lsr	x1, x0, 35
	lsr	x5, x2, 35
	ubfiz	w1, w1, 6, 5
	lsl	w5, w5, 11
	orr	w1, w1, w4
	and	w5, w5, 65535
	orr	w1, w1, w5
	str	w1, [x3, 16]
.L241:
	tst	x6, 280375465082880
	beq	.L242
	lsr	x1, x0, 43
	lsr	x5, x2, 43
	ubfiz	w1, w1, 6, 5
	lsl	w5, w5, 11
	orr	w1, w1, w4
	and	w5, w5, 65535
	orr	w1, w1, w5
	str	w1, [x3, 20]
.L242:
	tst	x6, 71776119061217280
	beq	.L243
	lsr	x1, x0, 51
	lsr	x5, x2, 51
	ubfiz	w1, w1, 6, 5
	lsl	w5, w5, 11
	orr	w1, w1, w4
	and	w5, w5, 65535
	orr	w1, w1, w5
	str	w1, [x3, 24]
.L243:
	mov	x1, 72057594037927935
	cmp	x6, x1
	bls	.L244
	lsr	x0, x0, 59
	lsr	x1, x2, 59
	orr	w0, w4, w0, lsl 6
	orr	w0, w0, w1, lsl 11
	str	w0, [x3, 28]
.L244:
	sub	w5, w19, #8
	add	x3, x3, 32
	cmp	w5, 8
	ble	.L245
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.p2align 5,,15
.L246:
	add	x3, x3, 32
	ldr	x10, [x18], 8
	ldr	x0, [x17]
	and	x10, x10, -1085102592571150096
	add	w20, w18, 8
	str	x10, [x17], 8
	and	x0, x0, -1085102592571150096
	lsr	x8, x10, 19
	lsr	x2, x10, 11
	lsr	x13, x10, 27
	lsr	x6, x0, 19
	lsr	x1, x0, 27
	lsr	x23, x0, 35
	lsr	x16, x0, 43
	lsr	x15, x0, 51
	lsr	x11, x10, 35
	lsr	x12, x10, 43
	lsr	x9, x10, 51
	lsl	w14, w10, 3
	lsr	x21, x10, 59
	and	w24, w0, 63488
	lsl	w22, w0, 8
	ubfiz	w8, w8, 6, 5
	ubfiz	w2, w2, 6, 5
	ubfiz	w13, w13, 6, 5
	ubfiz	w11, w11, 6, 5
	ubfiz	w12, w12, 6, 5
	ubfiz	w9, w9, 6, 5
	and	w14, w14, 1984
	lsl	w6, w6, 11
	lsl	w1, w1, 11
	lsl	w23, w23, 11
	lsl	w16, w16, 11
	lsl	w15, w15, 11
	lsr	x0, x0, 59
	and	w6, w6, 65535
	and	w1, w1, 65535
	orr	w8, w8, w4
	orr	w2, w2, w4
	orr	w13, w13, w4
	orr	w11, w11, w4
	orr	w12, w12, w4
	orr	w9, w9, w4
	orr	w14, w14, w4
	orr	w21, w4, w21, lsl 6
	and	w23, w23, 65535
	and	w16, w16, 65535
	and	w15, w15, 65535
	and	w22, w22, 65535
	orr	w8, w8, w6
	orr	w13, w13, w1
	orr	w2, w2, w24
	orr	w11, w11, w23
	orr	w12, w12, w16
	orr	w6, w9, w15
	orr	w14, w14, w22
	orr	w0, w21, w0, lsl 11
	sub	w1, w20, w30
	stp	w14, w2, [x3, -32]
	stp	w8, w13, [x3, -24]
	stp	w11, w12, [x3, -16]
	stp	w6, w0, [x3, -8]
	cmp	w5, w1
	bgt	.L246
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
.L245:
	cmp	w19, 8
	ble	.L236
	ldr	x5, [x17]
	ldr	x0, [x18]
	and	x1, x5, -1085102592571150096
	and	x2, x0, -1085102592571150096
	eor	x0, x5, x0
	and	x0, x0, x7
	eor	x0, x0, x5
	and	x0, x0, -1085102592571150096
	str	x0, [x17]
	tst	w7, 255
	beq	.L249
	lsl	w0, w1, 8
	lsl	w5, w2, 3
	and	w0, w0, 65535
	and	w5, w5, 1984
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3]
.L249:
	tst	x7, 65280
	beq	.L250
	lsr	x0, x2, 11
	and	w5, w1, 63488
	orr	w5, w5, w4
	ubfiz	w0, w0, 6, 5
	orr	w0, w0, w5
	str	w0, [x3, 4]
.L250:
	tst	x7, 16711680
	beq	.L251
	lsr	x0, x1, 19
	lsr	x5, x2, 19
	lsl	w0, w0, 11
	ubfiz	w5, w5, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 8]
.L251:
	tst	x7, 4278190080
	beq	.L252
	lsr	x0, x1, 27
	lsr	x5, x2, 27
	lsl	w0, w0, 11
	ubfiz	w5, w5, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 12]
.L252:
	tst	x7, 1095216660480
	beq	.L253
	lsr	x0, x1, 35
	lsr	x5, x2, 35
	lsl	w0, w0, 11
	ubfiz	w5, w5, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 16]
.L253:
	tst	x7, 280375465082880
	beq	.L254
	lsr	x0, x1, 43
	lsr	x5, x2, 43
	lsl	w0, w0, 11
	ubfiz	w5, w5, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 20]
.L254:
	tst	x7, 71776119061217280
	beq	.L255
	lsr	x0, x1, 51
	lsr	x5, x2, 51
	lsl	w0, w0, 11
	ubfiz	w5, w5, 6, 5
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 24]
.L255:
	mov	x0, 72057594037927935
	cmp	x7, x0
	bls	.L236
	lsr	x2, x2, 59
	lsr	x0, x1, 59
	lsl	w1, w2, 6
	orr	w0, w1, w0, lsl 11
	orr	w0, w0, w4
	str	w0, [x3, 28]
.L236:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	ret
	.size	make_index_line_gc_first, .-make_index_line_gc_first
	.align	2
	.p2align 5,,15
	.type	make_index_line_gc_next, %function
make_index_line_gc_next:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	ldr	x2, [x0]
	mov	x8, x0
	ldr	x0, [x1]
	add	x10, x1, 8
	mov	x9, x10
	and	x11, x2, -1085102592571150096
	eor	x1, x2, x0
	and	x0, x0, -1085102592571150096
	and	x1, x1, x6
	eor	x1, x1, x2
	and	x1, x1, -1085102592571150096
	str	x1, [x8], 8
	tst	w6, 255
	beq	.L302
	ldr	w2, [x3]
	tst	x2, 63
	beq	.L303
	lsr	x1, x0, 3
	and	w2, w2, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w2
	orr	w1, w1, 1
	str	w1, [x3]
.L302:
	tst	x6, 65280
	beq	.L305
	ldr	w12, [x3, 4]
	lsr	x2, x0, 11
	tst	x12, 63
	beq	.L306
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 4]
.L305:
	tst	x6, 16711680
	beq	.L308
	ldr	w12, [x3, 8]
	lsr	x2, x0, 19
	tst	x12, 63
	beq	.L309
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 8]
.L308:
	tst	x6, 4278190080
	beq	.L311
	ldr	w12, [x3, 12]
	lsr	x2, x0, 27
	tst	x12, 63
	beq	.L312
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 12]
.L311:
	tst	x6, 1095216660480
	beq	.L314
	ldr	w12, [x3, 16]
	lsr	x2, x0, 35
	tst	x12, 63
	beq	.L315
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 16]
.L314:
	tst	x6, 280375465082880
	beq	.L317
	ldr	w12, [x3, 20]
	lsr	x2, x0, 43
	tst	x12, 63
	beq	.L318
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 20]
.L317:
	tst	x6, 71776119061217280
	beq	.L320
	ldr	w12, [x3, 24]
	lsr	x2, x0, 51
	tst	x12, 63
	beq	.L321
	ubfiz	w1, w2, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
	str	w1, [x3, 24]
.L320:
	mov	x1, 72057594037927935
	cmp	x6, x1
	bls	.L323
	ldr	w1, [x3, 28]
	lsr	x0, x0, 59
	tst	x1, 63
	beq	.L324
	and	w1, w1, -63
	orr	w0, w1, w0, lsl 1
	orr	w0, w0, 1
	str	w0, [x3, 28]
.L323:
	sub	w11, w5, #8
	add	x3, x3, 32
	cmp	w11, 8
	ble	.L326
	.p2align 5,,15
.L343:
	ldr	x0, [x9], 8
	ldr	x2, [x8]
	and	x0, x0, -1085102592571150096
	ldr	w6, [x3]
	str	x0, [x8], 8
	and	x2, x2, -1085102592571150096
	tst	x6, 63
	beq	.L327
.L413:
	lsr	x1, x0, 3
	and	w6, w6, -63
	ldr	w12, [x3, 4]
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w6
	lsr	x6, x0, 11
	orr	w1, w1, 1
	str	w1, [x3]
	tst	x12, 63
	beq	.L329
.L414:
	ubfiz	w1, w6, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	ldr	w12, [x3, 8]
	orr	w1, w1, 1
	str	w1, [x3, 4]
	lsr	x6, x0, 19
	tst	x12, 63
	beq	.L331
.L415:
	and	w12, w12, -63
	ubfiz	w6, w6, 1, 5
	orr	w6, w6, w12
	ldr	w12, [x3, 12]
	orr	w1, w6, 1
	str	w1, [x3, 8]
	lsr	x6, x0, 27
	tst	x12, 63
	beq	.L333
.L416:
	and	w12, w12, -63
	ubfiz	w6, w6, 1, 5
	orr	w6, w6, w12
	ldr	w12, [x3, 16]
	orr	w6, w6, 1
	str	w6, [x3, 12]
	lsr	x1, x0, 35
	tst	x12, 63
	beq	.L335
.L417:
	and	w12, w12, -63
	ubfiz	w1, w1, 1, 5
	orr	w1, w1, w12
	ldr	w12, [x3, 20]
	orr	w1, w1, 1
	str	w1, [x3, 16]
	lsr	x6, x0, 43
	tst	x12, 63
	beq	.L337
.L418:
	and	w12, w12, -63
	ubfiz	w6, w6, 1, 5
	orr	w6, w6, w12
	ldr	w12, [x3, 24]
	orr	w6, w6, 1
	str	w6, [x3, 20]
	lsr	x1, x0, 51
	tst	x12, 63
	beq	.L339
.L419:
	ubfiz	w1, w1, 1, 5
	and	w12, w12, -63
	orr	w1, w1, w12
	orr	w1, w1, 1
.L340:
	ldr	w6, [x3, 28]
	lsr	x0, x0, 59
	str	w1, [x3, 24]
	tst	x6, 63
	beq	.L341
	and	w6, w6, -63
	add	w1, w9, 8
	orr	w0, w6, w0, lsl 1
	sub	w1, w1, w10
	orr	w0, w0, 1
	str	w0, [x3, 28]
	add	x3, x3, 32
	cmp	w11, w1
	bgt	.L343
.L326:
	cmp	w5, 8
	ble	.L301
	ldr	x5, [x8]
	ldr	x0, [x9]
	and	x2, x5, -1085102592571150096
	and	x1, x0, -1085102592571150096
	eor	x0, x5, x0
	and	x0, x0, x7
	eor	x0, x0, x5
	and	x0, x0, -1085102592571150096
	str	x0, [x8]
	tst	w7, 255
	beq	.L346
	ldr	w5, [x3]
	tst	x5, 63
	beq	.L347
	lsr	x0, x1, 3
	and	w5, w5, -63
	ubfiz	w0, w0, 1, 5
	orr	w0, w0, w5
	orr	w0, w0, 1
	str	w0, [x3]
.L346:
	tst	x7, 65280
	beq	.L349
	ldr	w6, [x3, 4]
	lsr	x5, x1, 11
	tst	x6, 63
	beq	.L350
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 4]
.L349:
	tst	x7, 16711680
	beq	.L352
	ldr	w6, [x3, 8]
	lsr	x5, x1, 19
	tst	x6, 63
	beq	.L353
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 8]
.L352:
	tst	x7, 4278190080
	beq	.L355
	ldr	w6, [x3, 12]
	lsr	x5, x1, 27
	tst	x6, 63
	beq	.L356
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 12]
.L355:
	tst	x7, 1095216660480
	beq	.L358
	ldr	w6, [x3, 16]
	lsr	x5, x1, 35
	tst	x6, 63
	beq	.L359
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 16]
.L358:
	tst	x7, 280375465082880
	beq	.L361
	ldr	w6, [x3, 20]
	lsr	x5, x1, 43
	tst	x6, 63
	beq	.L362
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 20]
.L361:
	tst	x7, 71776119061217280
	beq	.L364
	ldr	w6, [x3, 24]
	lsr	x5, x1, 51
	tst	x6, 63
	beq	.L365
	ubfiz	w0, w5, 1, 5
	and	w6, w6, -63
	orr	w0, w0, w6
	orr	w0, w0, 1
	str	w0, [x3, 24]
.L364:
	mov	x0, 72057594037927935
	cmp	x7, x0
	bls	.L301
	ldr	w0, [x3, 28]
	lsr	x1, x1, 59
	tst	x0, 63
	beq	.L368
	and	w0, w0, -63
	orr	w1, w0, w1, lsl 1
	orr	w0, w1, 1
	str	w0, [x3, 28]
.L301:
	ret
	.p2align 2,,3
.L341:
	lsr	x2, x2, 59
	orr	w0, w4, w0, lsl 6
	add	x3, x3, 32
	orr	w2, w0, w2, lsl 11
	add	w0, w9, 8
	sub	w0, w0, w10
	str	w2, [x3, -4]
	cmp	w0, w11
	bge	.L326
	ldr	x0, [x9], 8
	ldr	x2, [x8]
	and	x0, x0, -1085102592571150096
	ldr	w6, [x3]
	str	x0, [x8], 8
	and	x2, x2, -1085102592571150096
	tst	x6, 63
	bne	.L413
.L327:
	lsl	w1, w0, 3
	lsl	w6, w2, 8
	and	w1, w1, 1984
	ldr	w12, [x3, 4]
	and	w6, w6, 65535
	orr	w1, w1, w4
	orr	w1, w1, w6
	str	w1, [x3]
	lsr	x6, x0, 11
	tst	x12, 63
	bne	.L414
.L329:
	ubfiz	w1, w6, 6, 5
	ldr	w12, [x3, 8]
	and	w6, w2, 63488
	orr	w1, w1, w4
	orr	w1, w1, w6
	str	w1, [x3, 4]
	lsr	x6, x0, 19
	tst	x12, 63
	bne	.L415
.L331:
	lsr	x1, x2, 19
	ubfiz	w6, w6, 6, 5
	ldr	w12, [x3, 12]
	orr	w6, w6, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w6
	str	w1, [x3, 8]
	lsr	x6, x0, 27
	tst	x12, 63
	bne	.L416
.L333:
	lsr	x1, x2, 27
	ubfiz	w6, w6, 6, 5
	ldr	w12, [x3, 16]
	orr	w6, w6, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w6, w6, w1
	str	w6, [x3, 12]
	lsr	x1, x0, 35
	tst	x12, 63
	bne	.L417
.L335:
	lsr	x6, x2, 35
	ubfiz	w1, w1, 6, 5
	ldr	w12, [x3, 20]
	orr	w1, w1, w4
	lsl	w6, w6, 11
	and	w6, w6, 65535
	orr	w1, w1, w6
	str	w1, [x3, 16]
	lsr	x6, x0, 43
	tst	x12, 63
	bne	.L418
.L337:
	lsr	x1, x2, 43
	ubfiz	w6, w6, 6, 5
	ldr	w12, [x3, 24]
	orr	w6, w6, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w6, w6, w1
	str	w6, [x3, 20]
	lsr	x1, x0, 51
	tst	x12, 63
	bne	.L419
.L339:
	lsr	x6, x2, 51
	ubfiz	w1, w1, 6, 5
	orr	w1, w1, w4
	lsl	w6, w6, 11
	and	w6, w6, 65535
	orr	w1, w1, w6
	b	.L340
	.p2align 2,,3
.L324:
	lsr	x1, x11, 59
	orr	w0, w4, w0, lsl 6
	orr	w0, w0, w1, lsl 11
	str	w0, [x3, 28]
	b	.L323
	.p2align 2,,3
.L321:
	lsr	x1, x11, 51
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 24]
	b	.L320
	.p2align 2,,3
.L318:
	lsr	x1, x11, 43
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 20]
	b	.L317
	.p2align 2,,3
.L315:
	lsr	x1, x11, 35
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 16]
	b	.L314
	.p2align 2,,3
.L312:
	lsr	x1, x11, 27
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 12]
	b	.L311
	.p2align 2,,3
.L309:
	lsr	x1, x11, 19
	ubfiz	w2, w2, 6, 5
	orr	w2, w2, w4
	lsl	w1, w1, 11
	and	w1, w1, 65535
	orr	w1, w1, w2
	str	w1, [x3, 8]
	b	.L308
	.p2align 2,,3
.L306:
	and	w1, w11, 63488
	ubfiz	w2, w2, 6, 5
	orr	w1, w1, w4
	orr	w1, w1, w2
	str	w1, [x3, 4]
	b	.L305
	.p2align 2,,3
.L303:
	lsl	w1, w0, 3
	lsl	w2, w11, 8
	and	w1, w1, 1984
	and	w2, w2, 65535
	orr	w1, w1, w4
	orr	w1, w1, w2
	str	w1, [x3]
	b	.L302
	.p2align 2,,3
.L347:
	lsl	w0, w2, 8
	lsl	w5, w1, 3
	and	w0, w0, 65535
	and	w5, w5, 1984
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3]
	b	.L346
	.p2align 2,,3
.L350:
	and	w0, w2, 63488
	ubfiz	w5, w5, 6, 5
	orr	w0, w0, w4
	orr	w0, w0, w5
	str	w0, [x3, 4]
	b	.L349
	.p2align 2,,3
.L353:
	lsr	x0, x2, 19
	ubfiz	w5, w5, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 8]
	b	.L352
	.p2align 2,,3
.L356:
	lsr	x0, x2, 27
	ubfiz	w5, w5, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 12]
	b	.L355
	.p2align 2,,3
.L359:
	lsr	x0, x2, 35
	ubfiz	w5, w5, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 16]
	b	.L358
	.p2align 2,,3
.L362:
	lsr	x0, x2, 43
	ubfiz	w5, w5, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 20]
	b	.L361
	.p2align 2,,3
.L365:
	lsr	x0, x2, 51
	ubfiz	w5, w5, 6, 5
	lsl	w0, w0, 11
	and	w0, w0, 65535
	orr	w0, w0, w5
	orr	w0, w0, w4
	str	w0, [x3, 24]
	b	.L364
	.p2align 2,,3
.L368:
	lsr	x0, x2, 59
	lsl	w1, w1, 6
	orr	w0, w1, w0, lsl 11
	orr	w0, w0, w4
	str	w0, [x3, 28]
	b	.L301
	.size	make_index_line_gc_next, .-make_index_line_gc_next
	.align	2
	.p2align 5,,15
	.type	make_index_line_gc_tmask, %function
make_index_line_gc_tmask:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	stp	x29, x30, [sp, -96]!
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	mov	x22, x1
	stp	x23, x24, [sp, 48]
	mov	x23, x0
	stp	x25, x26, [sp, 64]
	add	x25, x2, 8
	mov	x24, x25
	stp	x27, x28, [sp, 80]
	mov	w27, w5
	mov	x28, x7
	ldr	x0, [x0]
	ldr	x1, [x22], 8
	ldr	x8, [x2]
	eor	x2, x0, x1
	and	x2, x2, x6
	and	x1, x1, -1085102592571150096
	eor	x2, x2, x0
	and	x0, x0, -1085102592571150096
	and	x2, x2, -1085102592571150096
	str	x2, [x23], 8
	tst	w6, 255
	beq	.L421
	ubfiz	w2, w8, 16, 8
	lsl	w7, w1, 3
	sub	w2, w4, w2
	and	w7, w7, 1984
	lsl	w5, w0, 8
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3]
.L421:
	tst	x6, 65280
	beq	.L422
	lsr	x2, x8, 8
	lsr	x5, x1, 11
	and	w7, w0, 63488
	ubfiz	w2, w2, 16, 8
	ubfiz	w5, w5, 6, 5
	sub	w2, w4, w2
	orr	w2, w2, w7
	orr	w2, w2, w5
	str	w2, [x3, 4]
.L422:
	tst	x6, 16711680
	beq	.L423
	lsr	x2, x1, 19
	lsr	x5, x0, 19
	and	w7, w8, 16711680
	ubfiz	w2, w2, 6, 5
	sub	w7, w4, w7
	lsl	w5, w5, 11
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3, 8]
.L423:
	tst	x6, 4278190080
	beq	.L424
	lsr	x2, x8, 24
	lsr	x7, x1, 27
	lsr	x5, x0, 27
	ubfiz	w2, w2, 16, 8
	ubfiz	w7, w7, 6, 5
	sub	w2, w4, w2
	lsl	w5, w5, 11
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3, 12]
.L424:
	tst	x6, 1095216660480
	beq	.L425
	lsr	x2, x8, 32
	lsr	x7, x1, 35
	lsr	x5, x0, 35
	ubfiz	w2, w2, 16, 8
	ubfiz	w7, w7, 6, 5
	sub	w2, w4, w2
	lsl	w5, w5, 11
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3, 16]
.L425:
	tst	x6, 280375465082880
	beq	.L426
	lsr	x2, x8, 40
	lsr	x7, x1, 43
	lsr	x5, x0, 43
	ubfiz	w2, w2, 16, 8
	ubfiz	w7, w7, 6, 5
	sub	w2, w4, w2
	lsl	w5, w5, 11
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3, 20]
.L426:
	tst	x6, 71776119061217280
	beq	.L427
	lsr	x2, x8, 48
	lsr	x7, x1, 51
	lsr	x5, x0, 51
	ubfiz	w2, w2, 16, 8
	ubfiz	w7, w7, 6, 5
	sub	w2, w4, w2
	lsl	w5, w5, 11
	orr	w2, w2, w7
	and	w5, w5, 65535
	orr	w2, w2, w5
	str	w2, [x3, 24]
.L427:
	mov	x2, 72057594037927935
	cmp	x6, x2
	bls	.L428
	lsr	x8, x8, 56
	lsr	x1, x1, 59
	lsr	x0, x0, 59
	sub	w8, w4, w8, lsl 16
	orr	w1, w8, w1, lsl 6
	orr	w0, w1, w0, lsl 11
	str	w0, [x3, 28]
.L428:
	sub	w26, w27, #8
	add	x3, x3, 32
	cmp	w26, 8
	ble	.L429
	stp	x19, x20, [sp, 16]
	.p2align 5,,15
.L430:
	add	x3, x3, 32
	ldr	x2, [x24], 8
	ldr	x6, [x22], 8
	and	w12, w2, 16711680
	ldr	x0, [x23]
	and	x6, x6, -1085102592571150096
	lsr	x13, x2, 8
	lsr	x11, x2, 24
	and	x0, x0, -1085102592571150096
	lsr	x9, x2, 32
	lsr	x21, x6, 19
	lsr	x20, x6, 11
	lsr	x10, x2, 40
	lsr	x8, x2, 48
	lsr	x19, x6, 27
	lsr	x7, x6, 35
	ubfiz	w13, w13, 16, 8
	lsr	x30, x2, 56
	ubfiz	w21, w21, 6, 5
	ubfiz	w20, w20, 6, 5
	lsr	x18, x0, 19
	lsr	x17, x0, 27
	lsr	x16, x0, 35
	lsr	x15, x0, 43
	lsr	x14, x0, 51
	lsr	x5, x6, 43
	lsr	x1, x6, 51
	ubfiz	w11, w11, 16, 8
	ubfiz	w9, w9, 16, 8
	sub	w12, w4, w12
	sub	w13, w4, w13
	ubfiz	w19, w19, 6, 5
	ubfiz	w7, w7, 6, 5
	orr	w12, w21, w12
	orr	w13, w13, w20
	ubfiz	w10, w10, 16, 8
	ubfiz	w8, w8, 16, 8
	ubfiz	w2, w2, 16, 8
	sub	w11, w4, w11
	sub	w9, w4, w9
	lsl	w21, w6, 3
	lsr	x20, x6, 59
	ubfiz	w1, w1, 6, 5
	orr	w11, w11, w19
	orr	w9, w9, w7
	lsl	w19, w0, 8
	lsr	x7, x0, 59
	ubfiz	w5, w5, 6, 5
	sub	w10, w4, w10
	sub	w8, w4, w8
	sub	w2, w4, w2
	sub	w30, w4, w30, lsl 16
	and	w21, w21, 1984
	lsl	w18, w18, 11
	lsl	w17, w17, 11
	lsl	w16, w16, 11
	lsl	w15, w15, 11
	lsl	w14, w14, 11
	orr	w8, w8, w1
	orr	w10, w10, w5
	orr	w21, w2, w21
	orr	w20, w30, w20, lsl 6
	add	w1, w24, 8
	and	w18, w18, 65535
	and	w17, w17, 65535
	and	w0, w0, 63488
	and	w16, w16, 65535
	and	w15, w15, 65535
	and	w14, w14, 65535
	and	w19, w19, 65535
	str	x6, [x23], 8
	orr	w12, w12, w18
	orr	w0, w13, w0
	orr	w11, w11, w17
	orr	w9, w9, w16
	orr	w10, w10, w15
	orr	w8, w8, w14
	orr	w21, w21, w19
	orr	w7, w20, w7, lsl 11
	sub	w1, w1, w25
	stp	w21, w0, [x3, -32]
	stp	w12, w11, [x3, -24]
	stp	w9, w10, [x3, -16]
	stp	w8, w7, [x3, -8]
	cmp	w26, w1
	bgt	.L430
	ldp	x19, x20, [sp, 16]
.L429:
	cmp	w27, 8
	ble	.L420
	ldr	x6, [x23]
	ldr	x0, [x22]
	and	x2, x6, -1085102592571150096
	ldr	x5, [x24]
	and	x1, x0, -1085102592571150096
	eor	x0, x6, x0
	and	x0, x0, x28
	eor	x0, x0, x6
	and	x0, x0, -1085102592571150096
	str	x0, [x23]
	tst	w28, 255
	beq	.L433
	ubfiz	w0, w5, 16, 8
	lsl	w7, w2, 8
	sub	w0, w4, w0
	and	w7, w7, 65535
	lsl	w6, w1, 3
	orr	w0, w0, w7
	and	w6, w6, 1984
	orr	w0, w0, w6
	str	w0, [x3]
.L433:
	tst	x28, 65280
	beq	.L434
	lsr	x0, x5, 8
	lsr	x6, x1, 11
	ubfiz	w0, w0, 16, 8
	ubfiz	w6, w6, 6, 5
	sub	w0, w4, w0
	orr	w0, w0, w6
	and	w6, w2, 63488
	orr	w0, w0, w6
	str	w0, [x3, 4]
.L434:
	tst	x28, 16711680
	beq	.L435
	lsr	x0, x2, 19
	lsr	x7, x1, 19
	and	w6, w5, 16711680
	lsl	w0, w0, 11
	ubfiz	w7, w7, 6, 5
	and	w0, w0, 65535
	sub	w6, w4, w6
	orr	w0, w0, w7
	orr	w0, w0, w6
	str	w0, [x3, 8]
.L435:
	tst	x28, 4278190080
	beq	.L436
	lsr	x0, x5, 24
	lsr	x6, x2, 27
	ubfiz	w0, w0, 16, 8
	lsl	w6, w6, 11
	and	w6, w6, 65535
	sub	w0, w4, w0
	orr	w0, w0, w6
	lsr	x6, x1, 27
	ubfiz	w6, w6, 6, 5
	orr	w0, w0, w6
	str	w0, [x3, 12]
.L436:
	tst	x28, 1095216660480
	beq	.L437
	lsr	x0, x5, 32
	lsr	x6, x2, 35
	ubfiz	w0, w0, 16, 8
	lsl	w6, w6, 11
	and	w6, w6, 65535
	sub	w0, w4, w0
	orr	w0, w0, w6
	lsr	x6, x1, 35
	ubfiz	w6, w6, 6, 5
	orr	w0, w0, w6
	str	w0, [x3, 16]
.L437:
	tst	x28, 280375465082880
	beq	.L438
	lsr	x0, x5, 40
	lsr	x6, x2, 43
	ubfiz	w0, w0, 16, 8
	lsl	w6, w6, 11
	and	w6, w6, 65535
	sub	w0, w4, w0
	orr	w0, w0, w6
	lsr	x6, x1, 43
	ubfiz	w6, w6, 6, 5
	orr	w0, w0, w6
	str	w0, [x3, 20]
.L438:
	tst	x28, 71776119061217280
	beq	.L439
	lsr	x0, x5, 48
	lsr	x6, x2, 51
	ubfiz	w0, w0, 16, 8
	lsl	w6, w6, 11
	and	w6, w6, 65535
	sub	w0, w4, w0
	orr	w0, w0, w6
	lsr	x6, x1, 51
	ubfiz	w6, w6, 6, 5
	orr	w0, w0, w6
	str	w0, [x3, 24]
.L439:
	mov	x0, 72057594037927935
	cmp	x28, x0
	bls	.L420
	lsr	x5, x5, 56
	lsr	x2, x2, 59
	lsr	x1, x1, 59
	sub	w5, w4, w5, lsl 16
	orr	w2, w5, w2, lsl 11
	orr	w1, w2, w1, lsl 6
	str	w1, [x3, 28]
.L420:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	ret
	.size	make_index_line_gc_tmask, .-make_index_line_gc_tmask
	.align	2
	.p2align 5,,15
	.global	wffpu_scan_area
	.type	wffpu_scan_area, %function
wffpu_scan_area:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4677
	.align	3
	.8byte	.LPFE4677
	.text
.LPFE4677:
	nop
	nop
	ldr	w2, [x0, 20]
	cbz	w2, .L485
	ldr	w2, [x1, 8]
	cbnz	w2, .L496
.L485:
	ret
	.p2align 2,,3
.L496:
	ldr	w2, [x1, 12]
	cbz	w2, .L485
	ldr	w0, [x0, 12]
	ldr	w3, [x1, 4]
	sub	w0, w0, w3
	sub	w0, w0, w2
	str	w0, [x1, 4]
	ret
	.size	wffpu_scan_area, .-wffpu_scan_area
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC index E unsupported mode %x\n"
	.align	3
.LC1:
	.string	"\0016EBC index D could not apply tmask (mode=%x clean=%d)\n"
	.text
	.align	2
	.p2align 5,,15
	.global	wffpu_make_index
	.type	wffpu_make_index, %function
wffpu_make_index:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4678
	.align	3
	.8byte	.LPFE4678
	.text
.LPFE4678:
	nop
	nop
	stp	x29, x30, [sp, -176]!
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	mov	x23, x3
	mov	x24, x2
	stp	x25, x26, [sp, 64]
	mov	x25, x0
	add	x0, x0, 536
	str	x5, [sp, 112]
	str	w4, [sp, 124]
	str	x1, [sp, 128]
	stp	xzr, xzr, [sp, 160]
	bl	ebc_mm_get_bg
	mov	x1, x0
	add	x0, x25, 536
	ldr	x22, [x1, 40]
	bl	ebc_mm_get_indexmap
	ldr	w1, [x23, 8]
	cbz	w1, .L498
	ldr	w1, [x23, 12]
	cbnz	w1, .L570
.L498:
	mov	w0, 0
.L497:
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 176
	ret
	.p2align 2,,3
.L570:
	stp	x19, x20, [sp, 16]
	stp	x27, x28, [sp, 80]
	ldr	w4, [x25, 20]
	ldp	x2, x3, [x23]
	stp	x2, x3, [sp, 160]
	ldr	x0, [x0, 40]
	str	x0, [sp, 144]
	cbz	w4, .L499
	ldr	w0, [x25, 12]
	ldr	w2, [sp, 164]
	sub	w0, w0, w1
	sub	w0, w0, w2
	str	w0, [sp, 164]
.L499:
	ldr	x1, [sp, 112]
	cbz	x1, .L500
	ldr	w0, [sp, 164]
#APP
// 362 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu_index.c" 1
	stlr w0, [x1]
// 0 "" 2
#NO_APP
.L500:
	add	x1, sp, 160
	add	x0, x25, 52
	bl	area_overlaps
	eor	w2, w0, 1
	and	w2, w2, 255
	add	x1, sp, 160
	add	x0, x25, 52
	str	w2, [sp, 136]
	mov	x21, -1
	bl	area_join
	ldr	w2, [sp, 124]
	ldr	x1, [x25, 24]
	add	x0, x25, 1512
	bl	wf_lut_frameoffset_value
	ldr	w20, [x23, 8]
	ldp	w2, w3, [x23]
	ldr	w4, [x25, 20]
	add	w1, w2, w20
	and	w19, w2, 7
	neg	w1, w1
	add	w20, w20, 7
	add	w20, w20, w19
	lsl	w19, w19, 3
	ubfiz	w1, w1, 3, 3
	and	w5, w20, -8
	str	w5, [sp, 108]
	lsl	x19, x21, x19
	cmp	w5, 8
	lsr	x21, x21, x1
	and	x1, x19, x21
	ldr	w26, [x25, 8]
	csel	x19, x1, x19, eq
	and	w5, w2, -8
	cbnz	w4, .L571
	cmp	w26, 0
	add	w28, w26, 7
	csel	w28, w28, w26, lt
	madd	w26, w3, w26, w5
	asr	w20, w28, 3
.L503:
	ldr	w1, [sp, 124]
	ldr	w3, [x25, 16]
	and	w1, w1, 112
	ldr	w28, [sp, 164]
	cmp	w1, 48
	beq	.L504
	bgt	.L505
	orr	w0, w0, 62
	str	w0, [sp, 120]
	cmp	w1, 16
	beq	.L569
	cmp	w1, 32
	bne	.L508
	ldr	x0, [sp, 136]
	tbz	x0, 0, .L572
	adrp	x23, make_index_line_gu_first
	add	x23, x23, :lo12:make_index_line_gu_first
	cbnz	x24, .L518
	.p2align 5,,15
.L562:
	mov	w27, w28
	b	.L517
	.p2align 2,,3
.L571:
	ldr	w1, [x23, 12]
	cmp	w26, 0
	add	w28, w26, 7
	add	w1, w3, w1
	csel	w28, w28, w26, lt
	sub	w1, w1, #1
	neg	w20, w28, asr 3
	madd	w26, w1, w26, w5
	b	.L503
	.p2align 2,,3
.L505:
	cmp	w1, 64
	beq	.L509
	cmp	w1, 96
	bne	.L508
	mov	w1, 2174
	orr	w0, w0, w1
	str	w0, [sp, 120]
	ldr	x0, [sp, 136]
	tbnz	x0, 0, .L511
.L559:
	adrp	x23, make_index_line_gc_next
	add	x23, x23, :lo12:make_index_line_gc_next
	cbz	x24, .L562
.L516:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L524
	ldr	w27, [sp, 164]
.L517:
	ldr	w0, [sp, 172]
	add	w0, w27, w0
	cmp	w0, w27
	ble	.L531
	ldr	x0, [sp, 128]
	sxtw	x26, w26
	mul	w3, w28, w3
	sbfiz	x28, x20, 3, 32
	add	x20, x0, x26
	sxtw	x2, w5
	ldr	x0, [sp, 144]
	add	x3, x2, w3, sxtw
	add	x22, x22, x26
	add	x26, x24, x26
	add	x24, x0, x3, lsl 2
	ldr	x0, [sp, 112]
	cbnz	x0, .L526
	b	.L527
	.p2align 2,,3
.L573:
	ldr	x0, [sp, 112]
#APP
// 444 "drivers/gpu/drm/rockchip/ebc-linux/ebc_wffpu_index.c" 1
	stlr w27, [x0]
// 0 "" 2
#NO_APP
	ldr	w5, [sp, 164]
	add	w27, w27, 1
	ldr	w2, [sp, 172]
	add	w2, w2, w5
	cmp	w2, w27
	ble	.L531
.L530:
	add	x20, x20, x28
	add	x22, x22, x28
	add	x26, x26, x28
	add	x24, x24, w4, sxtw 2
.L526:
	ldr	w4, [sp, 120]
	mov	x7, x21
	ldr	w5, [sp, 108]
	mov	x6, x19
	mov	x3, x24
	mov	x2, x26
	mov	x1, x20
	mov	x0, x22
	blr	x23
	ldr	w4, [x25, 16]
	tst	x27, 7
	beq	.L573
	ldr	w2, [sp, 164]
	add	w27, w27, 1
	ldr	w5, [sp, 172]
	add	w2, w2, w5
	cmp	w2, w27
	bgt	.L530
.L531:
	ldr	w0, [sp, 124]
	str	w0, [x25, 168]
	ldp	x19, x20, [sp, 16]
	ldp	x27, x28, [sp, 80]
	b	.L498
	.p2align 2,,3
.L504:
	orr	w0, w0, 126
	str	w0, [sp, 120]
.L569:
	ldr	x0, [sp, 136]
	tbz	x0, 0, .L559
.L511:
	adrp	x23, make_index_line_gc_first
	add	x23, x23, :lo12:make_index_line_gc_first
	cbz	x24, .L562
.L518:
	ldr	w1, [sp, 124]
	add	x0, x25, 1512
	stp	w3, w5, [sp, 152]
	bl	wf_lut_can_use_tmask
	ldp	w3, w5, [sp, 152]
	tbz	x0, 0, .L516
	adrp	x23, make_index_line_gc_tmask
	ldr	w27, [sp, 164]
	add	x23, x23, :lo12:make_index_line_gc_tmask
	b	.L517
	.p2align 2,,3
.L527:
	ldr	w5, [sp, 108]
	mov	x2, x26
	ldr	w4, [sp, 120]
	mov	x3, x24
	mov	x1, x20
	mov	x0, x22
	mov	x7, x21
	mov	x6, x19
	add	w27, w27, 1
	add	x20, x20, x28
	blr	x23
	ldr	w5, [sp, 164]
	ldrsw	x4, [x25, 16]
	add	x22, x22, x28
	ldr	w2, [sp, 172]
	add	x26, x26, x28
	add	w2, w2, w5
	add	x24, x24, x4, lsl 2
	cmp	w2, w27
	bgt	.L527
	b	.L531
	.p2align 2,,3
.L508:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L521
.L523:
	ldp	x19, x20, [sp, 16]
	mov	w0, -22
	ldp	x27, x28, [sp, 80]
	b	.L497
	.p2align 2,,3
.L509:
	mov	w1, 2110
	orr	w0, w0, w1
	str	w0, [sp, 120]
	ldr	x0, [sp, 136]
	tbnz	x0, 0, .L511
	b	.L559
	.p2align 2,,3
.L572:
	adrp	x23, make_index_line_gu_next
	add	x23, x23, :lo12:make_index_line_gu_next
	cbnz	x24, .L516
	mov	w27, w28
	b	.L517
.L521:
	ldr	w1, [sp, 124]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L523
.L524:
	ldr	w1, [sp, 124]
	adrp	x0, .LC1
	ldr	w2, [sp, 136]
	add	x0, x0, :lo12:.LC1
	stp	w3, w5, [sp, 152]
	bl	printk
	ldr	w27, [sp, 164]
	ldp	w3, w5, [sp, 152]
	b	.L517
	.size	wffpu_make_index, .-wffpu_make_index
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
