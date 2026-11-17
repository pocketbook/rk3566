// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_tcon.c"
	.text
	.align	2
	.p2align 5,,15
	.type	_tcon_get_line_count, %function
_tcon_get_line_count:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3952
	.align	3
	.8byte	.LPFE3952
	.text
.LPFE3952:
	nop
	nop
	ldr	w0, [x0, 72]
	ret
	.size	_tcon_get_line_count, .-_tcon_get_line_count
	.align	2
	.p2align 5,,15
	.type	tcon_is_volatile_reg, %function
tcon_is_volatile_reg:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3955
	.align	3
	.8byte	.LPFE3955
	.text
.LPFE3955:
	nop
	nop
	mov	x0, 273
	cmp	w1, 9
	lsr	x0, x0, x1
	and	w0, w0, 1
	eor	w0, w0, 1
	csinc	w0, w0, wzr, cc
	ret
	.size	tcon_is_volatile_reg, .-tcon_is_volatile_reg
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_is_volatile_reg, %function
rk3576_tcon_is_volatile_reg:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3956
	.align	3
	.8byte	.LPFE3956
	.text
.LPFE3956:
	nop
	nop
	cmp	w1, 32
	bhi	.L7
	mov	x0, 273
	movk	x0, 0x1, lsl 32
	lsr	x0, x0, x1
	and	w0, w0, 1
	eor	w0, w0, 1
	ret
	.p2align 2,,3
.L7:
	sub	w1, w1, #92
	tst	w1, -5
	cset	w0, ne
	ret
	.size	rk3576_tcon_is_volatile_reg, .-rk3576_tcon_is_volatile_reg
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_frame_addr_set, %function
rk3576_tcon_frame_addr_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3940
	.align	3
	.8byte	.LPFE3940
	.text
.LPFE3940:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	w2, w1
	mov	w1, 88
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0, 48]
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk3576_tcon_frame_addr_set, .-rk3576_tcon_frame_addr_set
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_image_addr_set, %function
rk3576_tcon_image_addr_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3939
	.align	3
	.8byte	.LPFE3939
	.text
.LPFE3939:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w20, w2
	ldr	x0, [x0, 48]
	mov	w2, w1
	mov	w1, 36
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, w20
	mov	w1, 40
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk3576_tcon_image_addr_set, .-rk3576_tcon_image_addr_set
	.align	2
	.p2align 5,,15
	.type	_tcon_get_current_line, %function
_tcon_get_current_line:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3953
	.align	3
	.8byte	.LPFE3953
	.text
.LPFE3953:
	nop
	nop
	sub	sp, sp, #32
	mrs	x1, sp_el0
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	ldr	x2, [x1, 1280]
	str	x2, [sp, 8]
	mov	x2, 0
	ldr	x1, [x0]
	ldr	w2, [x1, 452]
	cbz	w2, .L14
	ldrh	w2, [x1, 440]
	mov	w1, -1
	tst	x2, 7
	bne	.L14
.L13:
	mrs	x0, sp_el0
	ldr	x3, [sp, 8]
	ldr	x2, [x0, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L23
	ldp	x29, x30, [sp, 16]
	mov	w0, w1
	add	sp, sp, 32
	ret
	.p2align 2,,3
.L14:
	ldr	x0, [x0, 48]
	mov	w1, 84
	add	x2, sp, 4
	str	wzr, [sp, 4]
	bl	regmap_read
	ldrh	w1, [sp, 6]
	b	.L13
.L23:
	bl	__stack_chk_fail
	.size	_tcon_get_current_line, .-_tcon_get_current_line
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"frame count over flow\n"
	.text
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_lut_data_set, %function
rk3576_tcon_lut_data_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3942
	.align	3
	.8byte	.LPFE3942
	.text
.LPFE3942:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	cmp	w2, 256
	ccmp	w3, 0, 0, gt
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	beq	.L25
	cmp	w2, 64
	ccmp	w3, 0, 4, gt
	bne	.L25
	lsl	w0, w2, 6
	cmp	w3, 0
	stp	x19, x20, [sp, 16]
	lsl	w20, w2, 4
	csel	w20, w20, w0, eq
	cmp	w20, 0
	ble	.L30
	mov	w21, 4096
	add	x20, x1, w20, uxtw 2
	mov	x19, x1
	sub	w21, w21, w1
	.p2align 5,,15
.L31:
	ldr	x0, [x22, 48]
	add	w1, w21, w19
	ldr	w2, [x19]
	add	x19, x19, 4
	bl	regmap_write
	cmp	x19, x20
	bne	.L31
.L30:
	ldr	x0, [x22, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
.L24:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L25:
	ldr	x0, [x22]
	adrp	x1, .LC0
	add	x1, x1, :lo12:.LC0
	bl	_dev_err
	mov	w0, -1
	b	.L24
	.size	rk3576_tcon_lut_data_set, .-rk3576_tcon_lut_data_set
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"frame count: %d over flow, lut_32:%d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	tcon_lut_data_set, %function
tcon_lut_data_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3949
	.align	3
	.8byte	.LPFE3949
	.text
.LPFE3949:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	cmp	w2, 256
	ccmp	w3, 0, 0, gt
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	beq	.L35
	cmp	w2, 64
	ccmp	w3, 0, 4, gt
	bne	.L35
	lsl	w0, w2, 6
	cmp	w3, 0
	stp	x19, x20, [sp, 16]
	lsl	w20, w2, 4
	csel	w20, w20, w0, eq
	cmp	w20, 0
	ble	.L40
	mov	w21, 4096
	add	x20, x1, w20, uxtw 2
	mov	x19, x1
	sub	w21, w21, w1
	.p2align 5,,15
.L41:
	ldr	x0, [x22, 48]
	add	w1, w21, w19
	ldr	w2, [x19]
	add	x19, x19, 4
	bl	regmap_write
	cmp	x19, x20
	bne	.L41
.L40:
	ldr	x0, [x22, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldp	x19, x20, [sp, 16]
	mov	w0, 0
.L34:
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	ret
.L35:
	ldr	x0, [x22]
	adrp	x1, .LC1
	add	x1, x1, :lo12:.LC1
	bl	_dev_err
	mov	w0, -22
	b	.L34
	.size	tcon_lut_data_set, .-tcon_lut_data_set
	.align	2
	.p2align 5,,15
	.type	ebc_tcon_remove, %function
ebc_tcon_remove:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3958
	.align	3
	.8byte	.LPFE3958
	.text
.LPFE3958:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	add	x0, x0, 16
	mov	w1, 1
	mov	x29, sp
	bl	__pm_runtime_disable
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_tcon_remove, .-ebc_tcon_remove
	.section	.rodata.str1.8
	.align	3
.LC2:
	.string	"rockchip,ebc_tcon"
	.align	3
.LC3:
	.string	"hclk"
	.align	3
.LC4:
	.string	"\0016EBC tcon  E failed to get hclk: %d\n"
	.align	3
.LC5:
	.string	"dclk"
	.align	3
.LC6:
	.string	"\0016EBC tcon  E failed to get dclk: %d\n"
	.align	3
.LC7:
	.string	"aclk"
	.align	3
.LC8:
	.string	"\0016EBC tcon  E failed to get aclk: %d\n"
	.align	3
.LC9:
	.string	"\0016EBC tcon  E No IRQ resource!\n"
	.align	3
.LC10:
	.string	"\0016EBC tcon  E failed to requeset irq: %d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	ebc_tcon_probe, %function
ebc_tcon_probe:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3957
	.align	3
	.8byte	.LPFE3957
	.text
.LPFE3957:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	add	x20, x0, 16
	stp	x21, x22, [sp, 32]
	mov	x22, x0
	mov	x0, x20
	bl	of_device_get_match_data
	cbz	x0, .L61
	mov	x21, x0
	mov	w2, 0
	add	x19, x21, 8
	mov	w1, 512
	mov	x0, x22
	bl	platform_get_resource
	mov	x1, x0
	mov	x0, x20
	str	x1, [sp, 56]
	bl	devm_ioremap_resource
	str	x0, [x19, 8]
	cmn	x0, #4096
	ldr	x1, [sp, 56]
	bhi	.L63
	ldp	x2, x0, [x1]
	mov	x5, 0
	mov	x4, 0
	add	x0, x0, 1
	sub	x0, x0, x2
	str	w0, [x19, 16]
	adrp	x2, .LANCHOR0
	add	x3, x2, :lo12:.LANCHOR0
	ldp	x1, x0, [x1]
	sub	w0, w0, w1
	mov	x1, 0
	sub	w0, w0, #3
	str	w0, [x3, 124]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	str	x0, [x2, #:lo12:.LANCHOR0]
	ldr	x0, [x21]
	str	x0, [x3, 40]
	mov	x0, x20
	ldr	x2, [x19, 8]
	bl	__devm_regmap_init_mmio_clk
	str	x0, [x19, 48]
	cmn	x0, #4096
	bhi	.L63
	mov	x0, x20
	adrp	x1, .LC3
	add	x1, x1, :lo12:.LC3
	bl	devm_clk_get
	str	x0, [x19, 32]
	cmn	x0, #4096
	bhi	.L64
	mov	x0, x20
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	bl	devm_clk_get
	str	x0, [x19, 40]
	cmn	x0, #4096
	bhi	.L65
	mov	x0, x20
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
	bl	devm_clk_get_optional
	str	x0, [x19, 24]
	cmn	x0, #4096
	bhi	.L66
	mov	x0, x22
	mov	w1, 0
	bl	platform_get_irq
	str	w0, [x19, 20]
	mov	w2, w0
	tbnz	w0, #31, .L67
	mov	x1, 0
	mov	x2, 4096
	bl	irq_modify_status
	ldr	x5, [x20, 80]
	ldr	w1, [x19, 20]
	cbz	x5, .L68
.L58:
	adrp	x2, tcon_irq_hanlder
	add	x2, x2, :lo12:tcon_irq_hanlder
	mov	x6, x19
	mov	x0, x20
	mov	x4, 0
	mov	x3, 0
	bl	devm_request_threaded_irq
	mov	w2, w0
	tbnz	w0, #31, .L69
	str	x20, [x21, 8]
	mov	w0, 1
	str	w0, [x19, 64]
	mov	x0, x20
	str	x19, [x20, 120]
	bl	pm_runtime_enable
	mov	w2, 0
	mov	w0, w2
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L67:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L70
.L46:
	ldp	x19, x20, [sp, 16]
	mov	w0, w2
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L68:
	ldr	x5, [x22, 16]
	b	.L58
	.p2align 2,,3
.L69:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L46
	mov	w1, w2
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	str	w2, [sp, 56]
	bl	printk
	ldr	w2, [sp, 56]
	b	.L46
	.p2align 2,,3
.L63:
	mov	w2, w0
	ldp	x19, x20, [sp, 16]
	mov	w0, w2
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L64:
	adrp	x1, ebc_loglevel
	mov	w2, w0
	ldr	w1, [x1, #:lo12:ebc_loglevel]
	cmp	w1, 0
	ble	.L46
	mov	w1, w0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	str	w2, [sp, 56]
	bl	printk
	ldr	w2, [sp, 56]
	b	.L46
	.p2align 2,,3
.L65:
	adrp	x1, ebc_loglevel
	mov	w2, w0
	ldr	w1, [x1, #:lo12:ebc_loglevel]
	cmp	w1, 0
	ble	.L46
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	str	w2, [sp, 56]
	bl	printk
	ldr	w2, [sp, 56]
	b	.L46
	.p2align 2,,3
.L66:
	adrp	x1, ebc_loglevel
	mov	w2, w0
	ldr	w1, [x1, #:lo12:ebc_loglevel]
	cmp	w1, 0
	ble	.L46
	mov	w1, w0
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	str	w2, [sp, 56]
	bl	printk
	ldr	w2, [sp, 56]
	b	.L46
	.p2align 2,,3
.L61:
	mov	w2, -22
	b	.L46
.L70:
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printk
	ldr	w2, [x19, 20]
	b	.L46
	.size	ebc_tcon_probe, .-ebc_tcon_probe
	.align	2
	.p2align 5,,15
	.type	tcon_frame_addr_set, %function
tcon_frame_addr_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3966
	.align	3
	.8byte	.LPFE3966
	.text
.LPFE3966:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	w2, w1
	mov	w1, 88
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0, 48]
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	tcon_frame_addr_set, .-tcon_frame_addr_set
	.align	2
	.p2align 5,,15
	.type	tcon_image_addr_set, %function
tcon_image_addr_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3964
	.align	3
	.8byte	.LPFE3964
	.text
.LPFE3964:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w20, w2
	ldr	x0, [x0, 48]
	mov	w2, w1
	mov	w1, 36
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, w20
	mov	w1, 40
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	tcon_image_addr_set, .-tcon_image_addr_set
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_data_format_set, %function
rk3576_tcon_data_format_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3941
	.align	3
	.8byte	.LPFE3941
	.text
.LPFE3941:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	and	w3, w1, 7
	mov	w6, 0
	mov	x29, sp
	mov	w5, 0
	str	x19, [sp, 16]
	mov	x19, x0
	mov	x4, 0
	mov	w2, 7
	ldr	x0, [x0, 48]
	mov	w1, 32
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk3576_tcon_data_format_set, .-rk3576_tcon_data_format_set
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_frame_start, %function
rk3576_tcon_frame_start:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3943
	.align	3
	.8byte	.LPFE3943
	.text
.LPFE3943:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	sub	w3, w1, #1
	mov	w6, 0
	mov	x29, sp
	ubfiz	w3, w3, 4, 8
	str	x19, [sp, 16]
	mov	x19, x0
	mov	w5, 0
	mov	x4, 0
	ldr	x0, [x0, 48]
	mov	w2, 4080
	mov	w1, 92
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 0
	bl	regmap_write
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk3576_tcon_frame_start, .-rk3576_tcon_frame_start
	.align	2
	.p2align 5,,15
	.type	tcon_disable, %function
tcon_disable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3945
	.align	3
	.8byte	.LPFE3945
	.text
.LPFE3945:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x0, 20]
	bl	disable_irq
	ldr	x0, [x19, 48]
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	mov	w3, -2147483648
	mov	w2, -2147483647
	mov	w1, 0
	bl	regmap_update_bits_base
	ldr	x0, [x19]
	mov	w1, 4
	bl	__pm_runtime_idle
	ldr	x20, [x19, 40]
	mov	x0, x20
	bl	clk_disable
	mov	x0, x20
	bl	clk_unprepare
	ldr	x19, [x19, 32]
	mov	x0, x19
	bl	clk_disable
	mov	x0, x19
	bl	clk_unprepare
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	tcon_disable, .-tcon_disable
	.align	2
	.p2align 5,,15
	.type	tcon_frame_start, %function
tcon_frame_start:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3950
	.align	3
	.8byte	.LPFE3950
	.text
.LPFE3950:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	sub	w3, w1, #1
	mov	w6, 0
	mov	x29, sp
	ubfiz	w3, w3, 2, 8
	str	x19, [sp, 16]
	mov	x19, x0
	mov	w5, 0
	mov	x4, 0
	ldr	x0, [x0, 48]
	mov	w2, 1021
	mov	w1, 0
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x0, [x19, 48]
	mov	w3, 1
	mov	w6, 0
	mov	w2, w3
	mov	w5, 0
	mov	x4, 0
	mov	w1, 0
	bl	regmap_update_bits_base
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	tcon_frame_start, .-tcon_frame_start
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_disable, %function
rk3576_tcon_disable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3937
	.align	3
	.8byte	.LPFE3937
	.text
.LPFE3937:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	w0, [x0, 20]
	bl	disable_irq
	ldr	x0, [x19, 48]
	mov	w3, 1
	mov	w6, 0
	mov	w2, w3
	mov	w5, 0
	mov	x4, 0
	mov	w1, 92
	bl	regmap_update_bits_base
	ldr	x0, [x19]
	mov	w1, 4
	bl	__pm_runtime_idle
	ldr	x20, [x19, 40]
	mov	x0, x20
	bl	clk_disable
	mov	x0, x20
	bl	clk_unprepare
	ldr	x20, [x19, 24]
	mov	x0, x20
	bl	clk_disable
	mov	x0, x20
	bl	clk_unprepare
	ldr	x19, [x19, 32]
	mov	x0, x19
	bl	clk_disable
	mov	x0, x19
	bl	clk_unprepare
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	rk3576_tcon_disable, .-rk3576_tcon_disable
	.align	2
	.p2align 5,,15
	.type	tcon_dsp_mode_set, %function
tcon_dsp_mode_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3946
	.align	3
	.8byte	.LPFE3946
	.text
.LPFE3946:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	cmp	w2, 0
	mov	w6, 0
	mov	x29, sp
	mov	w5, 0
	str	x21, [sp, 32]
	mov	w21, w3
	cset	w3, ne
	cmp	w1, 0
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	cset	w0, ne
	mov	w20, w4
	mov	w2, 805306368
	lsl	w0, w0, 29
	mov	x4, 0
	orr	w3, w0, w3, lsl 28
	mov	w1, 8
	ldr	x0, [x19, 48]
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	cmp	w21, 0
	cset	w3, ne
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	lsl	w3, w3, 7
	mov	w2, 128
	mov	w1, 4
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	cmp	w20, 0
	cset	w3, ne
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	lsl	w3, w3, 13
	mov	w2, 8193
	mov	w1, 0
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.size	tcon_dsp_mode_set, .-tcon_dsp_mode_set
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_enable, %function
rk3576_tcon_enable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3936
	.align	3
	.8byte	.LPFE3936
	.text
.LPFE3936:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	x21, [x0, 32]
	mov	x0, x21
	bl	clk_prepare
	cbz	w0, .L115
.L89:
	ldr	x21, [x20, 24]
	mov	x0, x21
	bl	clk_prepare
	cbz	w0, .L116
.L92:
	ldr	x21, [x20, 40]
	mov	x0, x21
	bl	clk_prepare
	cbz	w0, .L117
.L95:
	ldr	x0, [x20]
	mov	w1, 4
	bl	__pm_runtime_resume
	ldr	w0, [x19, 92]
	ldp	w22, w21, [x19]
	ldp	w23, w24, [x19, 8]
	cbz	w0, .L97
	lsl	w22, w22, 1
	lsr	w21, w21, 1
	lsl	w23, w23, 1
	lsr	w24, w24, 1
.L97:
	ldrh	w0, [x19, 32]
	mov	w1, 12
	ldr	w2, [x19, 76]
	and	w22, w22, 65535
	orr	w2, w0, w2, lsl 16
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldp	w0, w1, [x19, 32]
	ldr	w2, [x19, 76]
	add	w0, w0, w1
	mov	w1, 16
	sub	w0, w0, #1
	and	w0, w0, 65535
	orr	w2, w0, w2, lsl 16
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldrh	w0, [x19, 56]
	mov	w1, 20
	ldr	w2, [x19, 72]
	orr	w2, w0, w2, lsl 16
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldp	w0, w1, [x19, 56]
	ldr	w2, [x19, 64]
	add	w0, w0, w1
	mov	w1, 24
	add	w2, w0, w2
	and	w0, w0, 65535
	orr	w2, w0, w2, lsl 16
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	and	w2, w23, 65535
	orr	w2, w2, w24, lsl 16
	mov	w1, 28
	bl	regmap_write
	ldr	x0, [x20, 48]
	orr	w2, w22, w21, lsl 16
	mov	w1, 44
	bl	regmap_write
	ldr	x0, [x20, 48]
	orr	w2, w22, w21, lsl 16
	mov	w1, 48
	bl	regmap_write
	ldr	x0, [x20, 48]
	orr	w2, w22, w21, lsl 16
	mov	w1, 52
	bl	regmap_write
	ldp	w2, w0, [x19, 56]
	add	w2, w2, w0
	ldp	w0, w1, [x19, 32]
	add	w0, w0, w1
	mov	w1, 56
	and	w0, w0, 65535
	orr	w2, w0, w2, lsl 16
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 3840
	movk	w2, 0x1f, lsl 16
	mov	w1, 32
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 2067
	mov	w1, 100
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 32
	mov	w1, 104
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 48
	mov	w1, 108
	bl	regmap_write
	ldp	w2, w1, [x19, 48]
	ldr	w0, [x19, 32]
	add	w0, w0, w2
	ldr	w2, [x19, 96]
	ubfiz	w3, w0, 8, 8
	cmp	w2, 0
	add	w0, w0, w1
	cset	w2, ne
	mov	w1, 4
	ubfiz	w0, w0, 16, 11
	orr	w2, w3, w2, lsl 6
	orr	w0, w0, -2147483645
	orr	w2, w2, w0
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 0
	mov	w1, 0
	bl	regmap_write
	ldr	w0, [x19, 108]
	ubfiz	w2, w0, 12, 12
	cbnz	w0, .L99
	ldr	w2, [x19, 40]
	ubfiz	w2, w2, 12, 12
.L99:
	ldr	x0, [x20, 48]
	orr	w2, w2, 2
	mov	w1, 92
	bl	regmap_write
	ldr	w0, [x19, 104]
	mov	w1, -2013265920
	cmp	w0, 1
	ldr	w0, [x19, 96]
	cset	w2, eq
	cmp	w0, 0
	mov	w0, -939524096
	csel	w0, w0, w1, eq
	mov	w1, 8
	orr	w2, w0, w2
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w3, 80
	movk	w3, 0x700, lsl 16
	mov	w6, 0
	add	w2, w3, 32
	mov	w5, 0
	mov	x4, 0
	mov	w1, 60
	bl	regmap_update_bits_base
	ldr	x0, [x20, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	w0, [x20, 20]
	bl	enable_irq
	str	x19, [x20, 56]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L115:
	mov	x0, x21
	bl	clk_enable
	cbz	w0, .L89
	mov	x0, x21
	bl	clk_unprepare
	ldr	x21, [x20, 24]
	mov	x0, x21
	bl	clk_prepare
	cbnz	w0, .L92
	.p2align 5,,15
.L116:
	mov	x0, x21
	bl	clk_enable
	cbz	w0, .L92
	mov	x0, x21
	bl	clk_unprepare
	ldr	x21, [x20, 40]
	mov	x0, x21
	bl	clk_prepare
	cbnz	w0, .L95
	.p2align 5,,15
.L117:
	mov	x0, x21
	bl	clk_enable
	cbz	w0, .L95
	mov	x0, x21
	bl	clk_unprepare
	b	.L95
	.size	rk3576_tcon_enable, .-rk3576_tcon_enable
	.align	2
	.p2align 5,,15
	.type	_tcon_set_line_flag_event, %function
_tcon_set_line_flag_event:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3954
	.align	3
	.8byte	.LPFE3954
	.text
.LPFE3954:
	nop
	nop
	and	w4, w2, 255
	ldr	x2, [x0]
	ldr	w3, [x2, 452]
	cbz	w3, .L119
	ldrh	w2, [x2, 440]
	tst	x2, 7
	beq	.L129
.L119:
	stp	x29, x30, [sp, -32]!
	mov	x7, x0
	mov	w2, w1
	mov	x29, sp
	mov	w1, 84
	ldr	x0, [x0, 48]
	str	x7, [sp, 16]
	str	w4, [sp, 28]
	bl	regmap_write
	ldr	w4, [sp, 28]
	ldr	x7, [sp, 16]
	mov	w6, 0
	mov	w5, 0
	tbnz	x4, 0, .L131
	ldr	x0, [x7, 48]
	mov	w3, 128
	mov	x4, 0
	mov	w2, w3
	mov	w1, 60
	bl	regmap_update_bits_base
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L129:
	ret
	.p2align 2,,3
.L131:
	ldr	x0, [x7, 48]
	mov	x4, 0
	mov	w3, 0
	mov	w2, 128
	mov	w1, 60
	bl	regmap_update_bits_base
	ldp	x29, x30, [sp], 32
	ret
	.size	_tcon_set_line_flag_event, .-_tcon_set_line_flag_event
	.section	.rodata.str1.8
	.align	3
.LC11:
	.string	"Failed to set dclk:%d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	rk3576_tcon_dsp_mode_set, %function
rk3576_tcon_dsp_mode_set:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3938
	.align	3
	.8byte	.LPFE3938
	.text
.LPFE3938:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	mov	w20, w4
	stp	x21, x22, [sp, 32]
	mov	w21, w3
	stp	x23, x24, [sp, 48]
	mov	w23, w1
	mov	w24, w2
	ldr	x22, [x0, 56]
	cbz	x22, .L158
	ldr	w0, [x0, 64]
	cmp	w0, w2
	beq	.L159
	ldr	x0, [x19, 40]
	ldr	w1, [x22, 24]
	cbz	w2, .L160
	ldr	w2, [x22, 96]
	mov	w4, 8
	cmp	w2, 0
	mov	w2, 4
	csel	w2, w2, w4, eq
	mul	w1, w2, w1
	bl	clk_set_rate
	cbnz	w0, .L141
.L137:
	ldr	w0, [x22, 96]
	mov	w22, 458752
	cbz	w0, .L143
.L135:
	ldr	x0, [x19, 48]
	str	w24, [x19, 64]
	mov	w2, 2083
	mov	w1, 104
	bl	regmap_write
	cmp	w21, 0
	cset	w0, ne
	add	w2, w0, 2098
.L145:
	ldr	x0, [x19, 48]
	mov	w1, 108
	bl	regmap_write
	cmp	w24, 0
	mov	w6, 0
	cset	w3, ne
	cmp	w23, 0
	cset	w0, ne
	mov	w5, 0
	mov	x4, 0
	mov	w2, 806289408
	lsl	w0, w0, 29
	mov	w1, 8
	orr	w3, w0, w3, lsl 28
	ldr	x0, [x19, 48]
	orr	w3, w3, w22
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	cmp	w21, 0
	cset	w3, ne
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	lsl	w3, w3, 29
	mov	w2, 536870912
	mov	w1, 4
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	cmp	w20, 0
	cset	w3, ne
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	lsl	w3, w3, 2
	mov	w2, 4
	mov	w1, 92
	bl	regmap_update_bits_base
	ldr	x0, [x19, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.p2align 2,,3
.L159:
	cbnz	w2, .L137
.L146:
	str	wzr, [x19, 64]
	ldr	x0, [x19, 48]
	cbnz	w21, .L144
	mov	w2, 2082
	mov	w1, 104
	bl	regmap_write
	mov	w22, 0
	mov	w2, 2098
	b	.L145
	.p2align 2,,3
.L158:
	cbz	w2, .L146
.L143:
	mov	w22, 196608
	b	.L135
	.p2align 2,,3
.L160:
	uxtw	x1, w1
	bl	clk_set_rate
	cbz	w0, .L146
	mov	w2, w0
	adrp	x1, .LC11
	ldr	x0, [x19]
	add	x1, x1, :lo12:.LC11
	bl	_dev_err
	b	.L146
	.p2align 2,,3
.L144:
	mov	w2, 2083
	mov	w1, 104
	bl	regmap_write
	mov	w22, 0
	mov	w2, 2099
	b	.L145
.L141:
	mov	w2, w0
	adrp	x1, .LC11
	ldr	x0, [x19]
	add	x1, x1, :lo12:.LC11
	bl	_dev_err
	b	.L137
	.size	rk3576_tcon_dsp_mode_set, .-rk3576_tcon_dsp_mode_set
	.align	2
	.p2align 5,,15
	.type	tcon_irq_hanlder, %function
tcon_irq_hanlder:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3951
	.align	3
	.8byte	.LPFE3951
	.text
.LPFE3951:
	nop
	nop
	sub	sp, sp, #48
	mrs	x0, sp_el0
	add	x2, sp, 4
	stp	x29, x30, [sp, 16]
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
	mov	x19, x1
	ldr	x1, [x0, 1280]
	str	x1, [sp, 8]
	mov	x1, 0
	str	wzr, [sp, 4]
	ldr	x0, [x19, 48]
	mov	w1, 60
	bl	regmap_read
	ldr	w20, [sp, 4]
	tbnz	x20, 1, .L176
.L163:
	tbnz	x20, 3, .L177
.L166:
	mrs	x0, sp_el0
	ldr	x2, [sp, 8]
	ldr	x1, [x0, 1280]
	subs	x2, x2, x1
	mov	x1, 0
	bne	.L178
	ldp	x29, x30, [sp, 16]
	mov	w0, 1
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 48
	ret
	.p2align 2,,3
.L176:
	ldr	x0, [x19, 48]
	mov	w3, 512
	mov	w6, 0
	mov	w2, w3
	mov	w5, 0
	mov	x4, 0
	mov	w1, 60
	bl	regmap_update_bits_base
	ldr	x0, [x19, 168]
	cbz	x0, .L163
	blr	x0
	tbz	x20, 3, .L166
.L177:
	ldr	x0, [x19, 48]
	mov	w3, 2048
	mov	w6, 0
	mov	w2, w3
	mov	w5, 0
	mov	x4, 0
	mov	w1, 60
	bl	regmap_update_bits_base
	ldr	x0, [x19, 176]
	cbz	x0, .L166
	blr	x0
	b	.L166
.L178:
	bl	__stack_chk_fail
	.size	tcon_irq_hanlder, .-tcon_irq_hanlder
	.align	2
	.p2align 5,,15
	.type	tcon_enable, %function
tcon_enable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3944
	.align	3
	.8byte	.LPFE3944
	.text
.LPFE3944:
	nop
	nop
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	str	x25, [sp, 64]
	ldr	x21, [x0, 32]
	mov	x0, x21
	bl	clk_prepare
	cbz	w0, .L199
.L181:
	ldr	x21, [x20, 40]
	mov	x0, x21
	bl	clk_prepare
	cbz	w0, .L200
.L184:
	ldr	x0, [x20]
	mov	w1, 4
	bl	__pm_runtime_resume
	ldr	w0, [x19, 92]
	ldp	w24, w21, [x19]
	ldp	w22, w23, [x19, 8]
	cbz	w0, .L186
	lsl	w24, w24, 1
	lsr	w21, w21, 1
	lsl	w22, w22, 1
	lsr	w23, w23, 1
.L186:
	ldr	w0, [x19, 76]
	mov	w1, 12
	ldrb	w2, [x19, 32]
	lsl	w25, w23, 16
	ubfiz	w23, w23, 16, 11
	ubfiz	w21, w21, 16, 11
	ubfiz	w0, w0, 16, 12
	and	w24, w24, 4095
	orr	w2, w0, w2
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldp	w0, w1, [x19, 32]
	ldr	w2, [x19, 40]
	add	w0, w0, w1
	mov	w1, 16
	add	w2, w0, w2
	sub	w0, w0, #1
	and	w0, w0, 255
	ubfiz	w2, w2, 16, 11
	orr	w2, w2, w0
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	w0, [x19, 72]
	mov	w1, 20
	ldrb	w2, [x19, 56]
	ubfiz	w0, w0, 16, 11
	orr	w2, w0, w2
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldp	w0, w1, [x19, 56]
	ldr	w2, [x19, 64]
	add	w0, w0, w1
	mov	w1, 24
	add	w2, w0, w2
	and	w0, w0, 255
	ubfiz	w2, w2, 16, 11
	orr	w2, w2, w0
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	and	w2, w22, 4095
	orr	w2, w23, w2
	mov	w1, 28
	bl	regmap_write
	ldr	x0, [x20, 48]
	and	w2, w22, 65535
	orr	w2, w2, w25
	mov	w1, 44
	bl	regmap_write
	ldr	x0, [x20, 48]
	orr	w2, w21, w24
	mov	w1, 48
	bl	regmap_write
	ldr	x0, [x20, 48]
	orr	w2, w21, w24
	mov	w1, 52
	bl	regmap_write
	ldp	w2, w0, [x19, 56]
	add	w2, w2, w0
	ldp	w0, w1, [x19, 32]
	ubfiz	w2, w2, 16, 11
	add	w0, w0, w1
	mov	w1, 56
	and	w0, w0, 4095
	orr	w2, w2, w0
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w2, 8128
	movk	w2, 0xf84, lsl 16
	mov	w1, 32
	bl	regmap_write
	ldp	w2, w1, [x19, 48]
	ldr	w0, [x19, 32]
	add	w0, w0, w2
	ldr	w2, [x19, 96]
	ubfiz	w3, w0, 8, 8
	cmp	w2, 0
	add	w0, w0, w1
	cset	w2, ne
	mov	w1, 4
	ubfiz	w0, w0, 16, 11
	orr	w2, w3, w2, lsl 6
	orr	w0, w0, -2147483645
	orr	w2, w2, w0
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w1, 0
	ldr	w2, [x19, 40]
	ubfiz	w2, w2, 16, 10
	orr	w2, w2, 4096
	bl	regmap_write
	ldr	w0, [x19, 96]
	mov	w2, -939524096
	mov	w1, 8
	cmp	w0, 0
	mov	w0, -2013265920
	csel	w2, w2, w0, eq
	ldr	x0, [x20, 48]
	bl	regmap_write
	ldr	x0, [x20, 48]
	mov	w6, 0
	mov	w5, 0
	mov	x4, 0
	mov	w3, 80
	mov	w2, 112
	mov	w1, 60
	bl	regmap_update_bits_base
	ldr	x0, [x20, 48]
	mov	w2, 1
	mov	w1, 80
	bl	regmap_write
	ldr	w0, [x20, 20]
	bl	enable_irq
	ldr	x25, [sp, 64]
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
	.p2align 2,,3
.L199:
	mov	x0, x21
	bl	clk_enable
	cbz	w0, .L181
	mov	x0, x21
	bl	clk_unprepare
	ldr	x21, [x20, 40]
	mov	x0, x21
	bl	clk_prepare
	cbnz	w0, .L184
	.p2align 5,,15
.L200:
	mov	x0, x21
	bl	clk_enable
	cbz	w0, .L184
	mov	x0, x21
	bl	clk_unprepare
	b	.L184
	.size	tcon_enable, .-tcon_enable
	.align	2
	.p2align 5,,15
	.global	tcon_init
	.type	tcon_init, %function
tcon_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3959
	.align	3
	.8byte	.LPFE3959
	.text
.LPFE3959:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	mov	x29, sp
	add	x0, x0, 272
	adrp	x1, __this_module
	add	x1, x1, :lo12:__this_module
	bl	__platform_driver_register
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_init, .-tcon_init
	.align	2
	.p2align 5,,15
	.global	tcon_deinit
	.type	tcon_deinit, %function
tcon_deinit:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE3960
	.align	3
	.8byte	.LPFE3960
	.text
.LPFE3960:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR0
	add	x0, x0, :lo12:.LANCHOR0
	mov	x29, sp
	add	x0, x0, 272
	bl	platform_driver_unregister
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_deinit, .-tcon_deinit
	.section	.rodata.str1.8
	.align	3
.LC12:
	.string	"rk-ebc-tcon"
	.global	__mod_of__ebc_tcon_of_match_device_table
	.set	__mod_of__ebc_tcon_of_match_device_table,ebc_tcon_of_match
	.section	.rodata
	.align	3
	.type	ebc_tcon_of_match, %object
	.size	ebc_tcon_of_match, 600
ebc_tcon_of_match:
	.zero	64
	.string	"rockchip,rk3568-ebc-tcon"
	.zero	103
	.xword	rk3568_ebc_data
	.zero	64
	.string	"rockchip,rk3576-ebc-tcon"
	.zero	103
	.xword	rk3576_ebc_data
	.zero	200
	.data
	.align	3
	.set	.LANCHOR0,. + 0
	.type	ebc_regmap_config, %object
	.size	ebc_regmap_config, 272
ebc_regmap_config:
	.zero	8
	.word	32
	.word	4
	.zero	4
	.word	32
	.zero	16
	.xword	tcon_is_volatile_reg
	.zero	140
	.word	1
	.zero	80
	.type	ebc_tcon_driver, %object
	.size	ebc_tcon_driver, 200
ebc_tcon_driver:
	.xword	ebc_tcon_probe
	.xword	ebc_tcon_remove
	.zero	24
	.xword	.LC12
	.zero	32
	.xword	ebc_tcon_of_match
	.zero	96
	.zero	16
	.type	rk3576_ebc_data, %object
	.size	rk3576_ebc_data, 192
rk3576_ebc_data:
	.xword	rk3576_tcon_is_volatile_reg
	.zero	68
	.word	1
	.zero	8
	.xword	rk3576_tcon_enable
	.xword	rk3576_tcon_disable
	.xword	rk3576_tcon_dsp_mode_set
	.xword	rk3576_tcon_image_addr_set
	.xword	rk3576_tcon_frame_addr_set
	.xword	rk3576_tcon_lut_data_set
	.xword	rk3576_tcon_data_format_set
	.xword	rk3576_tcon_frame_start
	.xword	_tcon_get_line_count
	.xword	_tcon_get_current_line
	.xword	_tcon_set_line_flag_event
	.zero	16
	.type	rk3568_ebc_data, %object
	.size	rk3568_ebc_data, 192
rk3568_ebc_data:
	.xword	tcon_is_volatile_reg
	.zero	68
	.word	0
	.zero	8
	.xword	tcon_enable
	.xword	tcon_disable
	.xword	tcon_dsp_mode_set
	.xword	tcon_image_addr_set
	.xword	tcon_frame_addr_set
	.xword	tcon_lut_data_set
	.zero	8
	.xword	tcon_frame_start
	.xword	_tcon_get_line_count
	.xword	_tcon_get_current_line
	.xword	_tcon_set_line_flag_event
	.zero	16
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
