// SPDX-License-Identifier: GPL-2.0

	.arch armv8-a
	.file	"ebc_transition.c"
	.text
	.align	2
	.p2align 5,,15
	.type	xy_to_angle, %function
xy_to_angle:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4672
	.align	3
	.8byte	.LPFE4672
	.text
.LPFE4672:
	nop
	nop
	cmp	w1, 0
	neg	w4, w0
	csneg	w2, w1, w1, ge
	mov	w3, w0
	orr	w0, w4, w2
	cbz	w0, .L1
	sub	w0, w2, w3
	cmp	w4, w2
	bge	.L3
	mov	w3, 1300
	cmp	w1, 0
	mul	w2, w2, w3
	sdiv	w2, w2, w0
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	sub	w2, w2, #650
	ldrb	w0, [x0, w2, sxtw]
	sub	w2, w0, #1024
	csneg	w0, w2, w0, le
.L1:
	ret
	.p2align 2,,3
.L3:
	mov	w2, -1300
	cmp	w1, 0
	mul	w3, w3, w2
	sdiv	w3, w3, w0
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	sub	w3, w3, #650
	ldrb	w2, [x0, w3, sxtw]
	mov	w0, -512
	sub	w3, w2, #512
	sub	w0, w0, w2
	csel	w0, w0, w3, le
	ret
	.size	xy_to_angle, .-xy_to_angle
	.align	2
	.p2align 5,,15
	.type	make_tmask_butterfly, %function
make_tmask_butterfly:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	ldr	w1, [x0, 8]
	cmp	w1, 1
	ble	.L19
	stp	x29, x30, [sp, -112]!
	asr	w4, w1, 1
	mov	x29, sp
	ldr	w3, [x0, 4]
	str	w4, [sp, 104]
	cmp	w3, 1
	ble	.L10
	stp	x19, x20, [sp, 16]
	add	w3, w3, w3, lsr 31
	stp	x21, x22, [sp, 32]
	mov	w22, 0
	stp	x23, x24, [sp, 48]
	asr	w23, w3, 1
	stp	x25, x26, [sp, 64]
	sub	w25, w23, #1
	stp	x27, x28, [sp, 80]
	ldr	w21, [x2]
	ldr	w2, [x0, 12]
	ldr	x26, [x0, 40]
	str	w2, [sp, 108]
	mul	w1, w1, w2
	add	w1, w1, w1, lsr 31
	asr	w0, w1, 1
	sub	w27, w0, w23
	add	w25, w25, w0
	add	w0, w27, w25
	str	w0, [sp, 100]
	.p2align 5,,15
.L13:
	ldr	w0, [sp, 100]
	add	x20, x26, w25, sxtw
	neg	w24, w22
	mov	x28, 0
	sub	w19, w0, w25
	mov	x27, 1
	sub	w19, w19, #1
	add	x19, x26, w19, sxtw
	.p2align 5,,15
.L14:
	mov	w1, w24
	mov	w0, w28
	bl	xy_to_angle
	add	w0, w0, 1024
	mul	w0, w0, w21
	cmp	w0, 0
	add	w1, w0, 1023
	csel	w0, w1, w0, lt
	mov	w1, w22
	asr	w0, w0, 10
	strb	w0, [x19, x27]
	strb	w0, [x20, x28]
	mov	w0, w28
	bl	xy_to_angle
	add	w0, w0, 1024
	mul	w0, w0, w21
	add	w1, w0, 1023
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 10
	strb	w0, [x19, x28]
	strb	w0, [x20, x27]
	add	x27, x27, 1
	sub	w0, w27, #1
	sub	x28, x28, #1
	cmp	w23, w0
	bgt	.L14
	ldr	w0, [sp, 108]
	add	w22, w22, 1
	add	w25, w25, w0
	ldr	w0, [sp, 104]
	cmp	w0, w22
	bgt	.L13
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
.L10:
	ldp	x29, x30, [sp], 112
	ret
.L19:
	ret
	.size	make_tmask_butterfly, .-make_tmask_butterfly
	.align	2
	.p2align 5,,15
	.type	make_tmask_ripples, %function
make_tmask_ripples:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	stp	x29, x30, [sp, -112]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	ldp	w28, w21, [x0, 4]
	ldr	w1, [x0, 12]
	ldp	w22, w27, [x2]
	ldp	w25, w23, [x2, 8]
	str	w1, [sp, 100]
	mul	w1, w28, w28
	mul	w2, w21, w21
	ldr	x24, [x0, 40]
	cmp	w1, 0
	add	w0, w1, 3
	csel	w0, w0, w1, lt
	add	w1, w2, 3
	cmp	w2, 0
	csel	w1, w1, w2, lt
	asr	w1, w1, 2
	add	w0, w1, w0, asr 2
	sxtw	x0, w0
	bl	int_sqrt
	mov	w1, 3264
	mov	x20, x0
	sxtw	x0, w0
	bl	__kmalloc
	mov	x19, x0
	cmp	w20, 0
	ble	.L30
	mul	w3, w25, w20
	sdiv	w3, w3, w20
	and	w3, w3, 255
	strb	w3, [x0]
	cmp	w20, 1
	beq	.L27
	mov	w8, -100
	mul	w23, w25, w23
	lsl	w22, w22, 8
	adrp	x7, .LANCHOR0
	mul	w8, w8, w20
	add	x7, x7, :lo12:.LANCHOR0
	mov	w6, w27
	mov	w5, w23
	mov	w4, w22
	add	x7, x7, 656
	mov	x0, 1
	.p2align 5,,15
.L28:
	sdiv	w2, w4, w20
	add	w4, w4, w22
	sdiv	w9, w5, w8
	add	w5, w5, w23
	negs	w1, w2
	and	w2, w2, 255
	and	w1, w1, 255
	csneg	w1, w2, w1, mi
	add	w9, w9, w25
	ldrsb	w2, [x7, w1, sxtw]
	mul	w2, w2, w9
	cmp	w2, 0
	add	w1, w2, 127
	csel	w1, w1, w2, lt
	sub	w2, w20, w0
	madd	w2, w2, w9, w6
	add	w6, w6, w27
	sdiv	w2, w2, w20
	add	w1, w2, w1, asr 7
	and	w1, w1, 255
	strb	w1, [x19, x0]
	cmp	w3, w1
	add	x0, x0, 1
	csel	w1, w3, w1, cc
	and	w3, w1, 255
	cmp	w20, w0
	bgt	.L28
.L27:
	add	x2, x19, 1
	sub	w20, w20, #1
	mov	x0, x19
	add	x2, x2, x20
	.p2align 5,,15
.L29:
	ldrb	w1, [x0]
	sub	w1, w1, w3
	strb	w1, [x0], 1
	cmp	x2, x0
	bne	.L29
.L30:
	cmp	w21, 1
	ble	.L26
	asr	w0, w21, 1
	str	w0, [sp, 108]
	cmp	w28, 1
	ble	.L26
	ldr	w0, [sp, 100]
	add	w28, w28, w28, lsr 31
	mov	w22, 0
	asr	w20, w28, 1
	sub	w23, w20, #1
	mul	w21, w21, w0
	add	w21, w21, w21, lsr 31
	asr	w0, w21, 1
	sub	w25, w0, w20
	add	w23, w23, w0
	add	w0, w25, w23
	str	w0, [sp, 104]
	.p2align 5,,15
.L31:
	ldr	w0, [sp, 104]
	mul	w21, w22, w22
	add	x26, x24, w23, sxtw
	mov	x27, 0
	sub	w2, w0, w23
	mov	x28, 1
	sub	w2, w2, #1
	mov	w0, 0
	add	x25, x24, w2, sxtw
	.p2align 5,,15
.L32:
	madd	w0, w0, w0, w21
	sxtw	x0, w0
	bl	int_sqrt
	ldrb	w0, [x19, w0, sxtw]
	strb	w0, [x25, x27]
	strb	w0, [x25, x28]
	strb	w0, [x26, x27]
	sub	x27, x27, #1
	strb	w0, [x26, x28]
	add	x28, x28, 1
	sub	w0, w28, #1
	cmp	w20, w0
	bgt	.L32
	ldr	w0, [sp, 100]
	add	w22, w22, 1
	add	w23, w23, w0
	ldr	w0, [sp, 108]
	cmp	w22, w0
	blt	.L31
.L26:
	mov	x0, x19
	bl	kfree
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 112
	ret
	.size	make_tmask_ripples, .-make_tmask_ripples
	.align	2
	.p2align 5,,15
	.type	make_tmask_turn, %function
make_tmask_turn:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -128]!
	mov	x29, sp
	stp	x27, x28, [sp, 80]
	ldr	w27, [x0, 8]
	cmp	w27, 0
	ble	.L40
	stp	x19, x20, [sp, 16]
	sub	w20, w27, #1
	adrp	x19, .LANCHOR0
	stp	x21, x22, [sp, 32]
	add	x19, x19, :lo12:.LANCHOR0
	add	x19, x19, 656
	stp	x23, x24, [sp, 48]
	mov	w28, 0
	stp	x25, x26, [sp, 64]
	mov	w25, 0
	ldr	x26, [x0, 40]
	ldr	w1, [x0, 12]
	ldrsw	x0, [x0, 4]
	str	x0, [sp, 104]
	str	w1, [sp, 116]
	mul	w20, w20, w1
	ldp	w22, w21, [x2, 8]
	lsl	w0, w22, 8
	str	w0, [sp, 124]
	mul	w22, w21, w27
	ldp	w24, w23, [x2]
	sub	w2, w23, w21
	mov	w23, w0
	str	w2, [sp, 120]
	mov	w2, 0
	b	.L43
	.p2align 2,,3
.L47:
	sdiv	w1, w23, w27
	ldr	w0, [sp, 116]
	add	w28, w28, w0
	ldr	w0, [sp, 120]
	add	w22, w22, w0
	negs	w0, w1
	and	w0, w0, 255
	and	w1, w1, 255
	csneg	w0, w1, w0, mi
	ldrsb	w2, [x19, w0, sxtw]
	ldr	w0, [sp, 124]
	add	w23, w23, w0
.L43:
	mul	w2, w2, w21
	cmp	w24, 0
	sub	w0, w20, w28
	add	w25, w25, 1
	csel	w0, w0, w28, ne
	add	w7, w2, 127
	sdiv	w1, w22, w27
	cmp	w2, 0
	csel	w7, w7, w2, lt
	add	x0, x26, w0, sxtw
	ldr	x2, [sp, 104]
	add	w1, w1, w7, asr 7
	bl	memset
	cmp	w27, w25
	bne	.L47
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
.L40:
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 128
	ret
	.size	make_tmask_turn, .-make_tmask_turn
	.align	2
	.p2align 5,,15
	.global	ebc_make_tmask
	.type	ebc_make_tmask, %function
ebc_make_tmask:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	cmp	w1, 2
	bhi	.L51
	adrp	x4, .LANCHOR0
	add	x4, x4, :lo12:.LANCHOR0
	add	x4, x4, 912
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	ldr	x3, [x4, w1, sxtw 3]
	str	x19, [sp, 16]
	mov	x19, x0
	blr	x3
	mov	w0, 128
	str	w0, [x19, 28]
	add	x0, x19, 72
	bl	area_set_fullscreen
	ldr	x0, [x19, 88]
	bl	area_set_fullscreen
	mov	w0, 1
	str	w0, [x19, 96]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L51:
	ret
	.size	ebc_make_tmask, .-ebc_make_tmask
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
	.type	atan2_ar_table, %object
	.size	atan2_ar_table, 651
atan2_ar_table:
	.base64	"/////v79/fz8+/v6+vn5+Pj39/b29fX09PPz8vLx8fDw7+/u7u3t7Ozr6+rq6eno6Ofn5ubl5eTk4+Pi4uHh4ODf397e3d3c3Nvb2trZ2djY19fW1tXV1NTT09LS0dHQ0M/Pz87Ozc3MzMvLysrJycjIx8fGxsXFxMTDw8LCwcHAwMC/vr6+vb28vLu7urq5ubi4t7e2trW1tLSzs7OysrGxsLCvr66ura2srKurq6qqqamoqKenpqalpaSkpKOjoqKhoaCgn5+enp6dnZycm5uampmZmZiYl5eWlpWVlZSUk5OSkpGRkJCQj4+Ojo2NjIyMi4uKiomJiYiIh4eG"
	.ascii	"\206\205\205\205\204\204\203\203\202\202\202\201\201\200\200"
	.ascii	"\177\177\177~~}}|||{{zzzyyxxwwwvvuuuttssrrrqqpppoonnnmmllkkk"
	.ascii	"jjjiihhgggffeeedddccbbbaa```__^^^]]]\\\\[[[ZZYYYXXXWWVVVUUUT"
	.ascii	"TSSSRRRQQPP"
	.string	"POOONNMMMLLLKKKJJIIIHHHGGGFFFEEDDDCCCBBBAAA@@@???>>>==<<<;;;;::9998887776665554443332221111000///...---,,,+++***))))((('''&&&%%%%$$$###\"\"\"!!!    \037\037\037\036\036\036\036\035\035\035\034\034\034\034\033\033\033\032\032\032\032\031\031\031\030\030\030\027\027\027\027\026\026\026\025\025\025\025\024\024\024\024\023\023\023\022\022\022\022\021\021\021\020\020\020\020\017\017\017\017\016\016\016\r\r\r\r\f\f\f\f\013\013\013\013\n\n\n\t\t\t\t\b\b\b\b\007\007\007\007\006\006\006\005\005\005\005\004\004\004\004\003\003\003\003\002\002\002\002\001\001"
	.base64	"AAAAAA=="
	.zero	5
	.type	sin_table, %object
	.size	sin_table, 256
sin_table:
	.byte	0
	.byte	-4
	.byte	-7
	.byte	-11
	.byte	-13
	.byte	-18
	.byte	-20
	.byte	-22
	.byte	-26
	.byte	-29
	.byte	-33
	.byte	-35
	.byte	-37
	.byte	-41
	.byte	-43
	.byte	-48
	.byte	-50
	.byte	-52
	.byte	-56
	.byte	-58
	.byte	-62
	.byte	-63
	.byte	-65
	.byte	-69
	.byte	-71
	.byte	-75
	.byte	-76
	.byte	-78
	.byte	-82
	.byte	-83
	.byte	-87
	.byte	-88
	.byte	-90
	.byte	-93
	.byte	-94
	.byte	-97
	.byte	-99
	.byte	-101
	.byte	-103
	.byte	-104
	.byte	-107
	.byte	-108
	.byte	-110
	.byte	-111
	.byte	-112
	.byte	-114
	.byte	-115
	.byte	-117
	.byte	-118
	.byte	-119
	.byte	-120
	.byte	-121
	.byte	-122
	.byte	-123
	.byte	-123
	.byte	-124
	.byte	-125
	.byte	-125
	.byte	-126
	.byte	-126
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-127
	.byte	-126
	.byte	-126
	.byte	-125
	.byte	-125
	.byte	-124
	.byte	-124
	.byte	-123
	.byte	-122
	.byte	-121
	.byte	-120
	.byte	-119
	.byte	-118
	.byte	-117
	.byte	-116
	.byte	-114
	.byte	-113
	.byte	-111
	.byte	-110
	.byte	-109
	.byte	-107
	.byte	-105
	.byte	-103
	.byte	-101
	.byte	-100
	.byte	-97
	.byte	-96
	.byte	-93
	.byte	-91
	.byte	-90
	.byte	-87
	.byte	-85
	.byte	-82
	.byte	-80
	.byte	-76
	.byte	-75
	.byte	-73
	.byte	-69
	.byte	-67
	.byte	-63
	.byte	-62
	.byte	-60
	.byte	-56
	.byte	-54
	.byte	-50
	.byte	-48
	.byte	-46
	.byte	-41
	.byte	-39
	.byte	-35
	.byte	-33
	.byte	-31
	.byte	-26
	.byte	-24
	.byte	-20
	.byte	-18
	.byte	-15
	.byte	-11
	.byte	-9
	.byte	-4
	.byte	-2
	.base64	"AAIECQsPEhQYGh8hIycpLjAyNjg8PkBDRUlLTFBSVVdaW11gYWRlZ2lrbW5vcXJ0dXZ3eHl6e3x8fX1+fn9/f39/f39/fn59fXx7e3p5eHd2dXNycG9ubGtoZ2VjYV5dWlhXU1JOTEtHRUFAPjo4NDIwKyklIyEdGhYUEg0LBwQ="
	.type	make_tmask_func, %object
	.size	make_tmask_func, 24
make_tmask_func:
	.xword	make_tmask_turn
	.xword	make_tmask_ripples
	.xword	make_tmask_butterfly
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
