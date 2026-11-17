// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"tcon.c"
	.text
	.align	2
	.p2align 5,,15
	.type	hard_tcon_enable, %function
hard_tcon_enable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4691
	.align	3
	.8byte	.LPFE4691
	.text
.LPFE4691:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	adrp	x1, g_ebc
	mov	x29, sp
	ldr	x0, [x0]
	ldr	x1, [x1, #:lo12:g_ebc]
	ldr	x2, [x0, 80]
	add	x1, x1, 384
	blr	x2
	ldp	x29, x30, [sp], 16
	ret
	.size	hard_tcon_enable, .-hard_tcon_enable
	.align	2
	.p2align 5,,15
	.type	hard_tcon_disable, %function
hard_tcon_disable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4692
	.align	3
	.8byte	.LPFE4692
	.text
.LPFE4692:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0]
	ldr	x1, [x0, 88]
	blr	x1
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	hard_tcon_disable, .-hard_tcon_disable
	.align	2
	.p2align 5,,15
	.type	hard_tcon_set_vsync_callback, %function
hard_tcon_set_vsync_callback:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4693
	.align	3
	.8byte	.LPFE4693
	.text
.LPFE4693:
	nop
	nop
	ldr	x0, [x0]
	str	x1, [x0, 168]
	mov	w0, 0
	ret
	.size	hard_tcon_set_vsync_callback, .-hard_tcon_set_vsync_callback
	.align	2
	.p2align 5,,15
	.type	hard_tcon_set_line_callback, %function
hard_tcon_set_line_callback:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4694
	.align	3
	.8byte	.LPFE4694
	.text
.LPFE4694:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x3, x1
	mov	w1, w2
	mov	x29, sp
	mov	w2, 1
	ldr	x0, [x0]
	str	x3, [x0, 176]
	ldr	x3, [x0, 160]
	blr	x3
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	hard_tcon_set_line_callback, .-hard_tcon_set_line_callback
	.align	2
	.p2align 5,,15
	.type	hard_tcon_get_line_count, %function
hard_tcon_get_line_count:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4695
	.align	3
	.8byte	.LPFE4695
	.text
.LPFE4695:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0]
	ldr	x1, [x0, 144]
	blr	x1
	ldp	x29, x30, [sp], 16
	ret
	.size	hard_tcon_get_line_count, .-hard_tcon_get_line_count
	.align	2
	.p2align 5,,15
	.type	hard_tcon_get_current_line, %function
hard_tcon_get_current_line:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4696
	.align	3
	.8byte	.LPFE4696
	.text
.LPFE4696:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0]
	ldr	x1, [x0, 152]
	blr	x1
	ldp	x29, x30, [sp], 16
	ret
	.size	hard_tcon_get_current_line, .-hard_tcon_get_current_line
	.align	2
	.p2align 5,,15
	.type	hard_tcon_start_frame, %function
hard_tcon_start_frame:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4697
	.align	3
	.8byte	.LPFE4697
	.text
.LPFE4697:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	w4, 0
	mov	w3, 0
	mov	x29, sp
	mov	w2, 0
	stp	x19, x20, [sp, 16]
	mov	x20, x1
	mov	w1, 0
	ldr	x19, [x0]
	mov	x0, x19
	ldr	x5, [x19, 96]
	blr	x5
	ldr	x3, [x19, 104]
	mov	w1, w20
	mov	x0, x19
	mov	w2, 0
	blr	x3
	ldr	x2, [x19, 136]
	mov	x0, x19
	mov	w1, 1
	blr	x2
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	hard_tcon_start_frame, .-hard_tcon_start_frame
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC tcon  T slow-motion empty frame %d\n"
	.align	3
.LC1:
	.string	"\0016EBC tcon  D frame is not rendered\n"
	.align	3
.LC2:
	.string	"\0016EBC tcon  D frame is not completed\n"
	.align	3
.LC3:
	.string	"\0016EBC tcon  T ** frame start %d, frame time %u ms\n"
	.text
	.align	2
	.p2align 5,,15
	.type	vsync_callback_handler, %function
vsync_callback_handler:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4683
	.align	3
	.8byte	.LPFE4683
	.text
.LPFE4683:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	adrp	x0, g_ebc
	mov	x29, sp
	ldr	x3, [x0, #:lo12:g_ebc]
	adrp	x0, .LANCHOR0
	stp	x19, x20, [sp, 16]
	ldr	w2, [x0, #:lo12:.LANCHOR0]
	ldr	w4, [x3, 180]
	add	w1, w2, 1
	str	w1, [x0, #:lo12:.LANCHOR0]
	ldr	x19, [x3, 112]
	ldr	x20, [x3, 528]
	cmp	w2, w4
	blt	.L28
	str	wzr, [x0, #:lo12:.LANCHOR0]
	ldrb	w0, [x19, 104]
	tbnz	x0, 0, .L19
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L29
.L20:
	ldr	x0, [x3, 120]
	stp	x0, x19, [x3, 112]
	add	x0, x3, 172
#APP
// 42 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	ldar w0, [x0]
// 0 "" 2
#NO_APP
	cmp	w0, 1
	beq	.L21
	ldr	x0, [x3, 112]
	ldrb	w0, [x0, 104]
	and	w1, w0, 1
	tbnz	x0, 0, .L21
	add	x0, x3, 172
#APP
// 43 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	stlr w1, [x0]
// 0 "" 2
#NO_APP
.L22:
	ldr	x2, [x19, 16]
	mov	w1, 0
	ldr	x0, [x19, 40]
	bl	memset
	strh	wzr, [x19, 104]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L19:
	ldrb	w0, [x19, 105]
	tbnz	x0, 0, .L20
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L20
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	str	x3, [sp, 32]
	bl	printk
	ldr	x3, [sp, 32]
	b	.L20
	.p2align 2,,3
.L21:
	str	x3, [sp, 32]
	bl	ktime_get
	mov	x1, 63439
	lsr	x0, x0, 3
	movk	x1, 0xe353, lsl 16
	movk	x1, 0x9ba5, lsl 32
	movk	x1, 0x20c4, lsl 48
	ldr	x3, [sp, 32]
	umulh	x0, x0, x1
	adrp	x1, ebc_loglevel
	ldr	w1, [x1, #:lo12:ebc_loglevel]
	lsr	x0, x0, 4
	mov	w4, w0
	cmp	w1, 3
	bgt	.L30
.L23:
	str	w4, [x3, 184]
	ldr	x0, [x3, 112]
	ldr	x1, [x20, 8]
	ldr	x2, [x1, 48]
	ldr	x1, [x0, 48]
	mov	x0, x20
	blr	x2
	b	.L22
	.p2align 2,,3
.L28:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 3
	bgt	.L31
.L17:
	ldr	x0, [x19, 32]
	mov	w1, 1
	bl	dma_buf_end_cpu_access
	ldr	x0, [x20, 8]
	ldr	x1, [x19, 48]
	ldr	x2, [x0, 48]
	mov	x0, x20
	blr	x2
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L29:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	str	x3, [sp, 32]
	bl	printk
	ldr	x3, [sp, 32]
	b	.L20
.L30:
	ldr	x1, [x3, 112]
	str	w4, [sp, 44]
	ldr	w2, [x3, 184]
	ldr	w1, [x1]
	sub	w2, w0, w2
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printk
	ldr	w4, [sp, 44]
	ldr	x3, [sp, 32]
	b	.L23
.L31:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	b	.L17
	.size	vsync_callback_handler, .-vsync_callback_handler
	.section	.rodata.str1.8
	.align	3
.LC4:
	.string	"\0016EBC tcon  D TCON start\n"
	.text
	.align	2
	.p2align 5,,15
	.global	tcon_start
	.type	tcon_start, %function
tcon_start:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4684
	.align	3
	.8byte	.LPFE4684
	.text
.LPFE4684:
	nop
	nop
	ldr	x2, [x0, 528]
	mov	x1, x0
	add	x0, x0, 172
#APP
// 62 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	ldar w0, [x0]
// 0 "" 2
#NO_APP
	cbnz	w0, .L36
	stp	x29, x30, [sp, -32]!
	adrp	x0, .LANCHOR0
	add	x3, x1, 172
	mov	x29, sp
	str	wzr, [x0, #:lo12:.LANCHOR0]
	mov	w0, 1
#APP
// 68 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	stlr w0, [x3]
// 0 "" 2
#NO_APP
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L39
.L34:
	stp	x2, x1, [sp, 16]
	bl	ktime_get
	mov	x3, 63439
	movk	x3, 0xe353, lsl 16
	lsr	x0, x0, 3
	ldp	x2, x1, [sp, 16]
	movk	x3, 0x9ba5, lsl 32
	movk	x3, 0x20c4, lsl 48
	umulh	x0, x0, x3
	lsr	x0, x0, 4
	str	w0, [x1, 184]
	ldr	x0, [x1, 112]
	ldr	x1, [x2, 8]
	ldr	x3, [x1, 48]
	ldr	x1, [x0, 48]
	mov	x0, x2
	blr	x3
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L36:
	ret
.L39:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	stp	x2, x1, [sp, 16]
	bl	printk
	ldp	x2, x1, [sp, 16]
	b	.L34
	.size	tcon_start, .-tcon_start
	.section	.rodata.str1.8
	.align	3
.LC5:
	.string	"\0016EBC tcon  D TCON stop\n"
	.align	3
.LC6:
	.string	"\0016EBC tcon  E timeout waiting for TCON stop\n"
	.text
	.align	2
	.p2align 5,,15
	.global	tcon_stop
	.type	tcon_stop, %function
tcon_stop:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4685
	.align	3
	.8byte	.LPFE4685
	.text
.LPFE4685:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	add	x1, x20, 172
	mov	w0, 2
	str	x21, [sp, 32]
#APP
// 77 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	stlr w0, [x1]
// 0 "" 2
#NO_APP
	adrp	x21, ebc_loglevel
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L49
.L41:
	mov	w19, 1000
	b	.L42
	.p2align 2,,3
.L45:
	mov	x0, 36284
	movk	x0, 0x6, lsl 16
	bl	__const_udelay
	subs	w19, w19, #1
	beq	.L50
.L42:
	add	x0, x20, 172
#APP
// 79 "drivers/gpu/drm/rockchip/ebc-linux/tcon/tcon.c" 1
	ldar w0, [x0]
// 0 "" 2
#NO_APP
	cbnz	w0, .L45
.L40:
	ldr	x21, [sp, 32]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
.L50:
	ldr	w0, [x21, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L40
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printk
	b	.L40
.L49:
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printk
	b	.L41
	.size	tcon_stop, .-tcon_stop
	.align	2
	.p2align 5,,15
	.global	tcon_get_current_line
	.type	tcon_get_current_line, %function
tcon_get_current_line:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4686
	.align	3
	.8byte	.LPFE4686
	.text
.LPFE4686:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0, 528]
	ldr	x1, [x0, 8]
	ldr	x1, [x1, 40]
	blr	x1
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_get_current_line, .-tcon_get_current_line
	.align	2
	.p2align 5,,15
	.global	tcon_get_line_count
	.type	tcon_get_line_count, %function
tcon_get_line_count:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4687
	.align	3
	.8byte	.LPFE4687
	.text
.LPFE4687:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0, 528]
	ldr	x1, [x0, 8]
	ldr	x1, [x1, 32]
	blr	x1
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_get_line_count, .-tcon_get_line_count
	.align	2
	.p2align 5,,15
	.global	tcon_set_vsync_callback
	.type	tcon_set_vsync_callback, %function
tcon_set_vsync_callback:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4688
	.align	3
	.8byte	.LPFE4688
	.text
.LPFE4688:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0, 528]
	ldr	x2, [x0, 8]
	ldr	x2, [x2, 16]
	blr	x2
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_set_vsync_callback, .-tcon_set_vsync_callback
	.align	2
	.p2align 5,,15
	.global	tcon_set_line_callback
	.type	tcon_set_line_callback, %function
tcon_set_line_callback:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4689
	.align	3
	.8byte	.LPFE4689
	.text
.LPFE4689:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	ldr	x0, [x0, 528]
	ldr	x3, [x0, 8]
	ldr	x3, [x3, 24]
	blr	x3
	ldp	x29, x30, [sp], 16
	ret
	.size	tcon_set_line_callback, .-tcon_set_line_callback
	.section	.rodata.str1.8
	.align	3
.LC7:
	.string	"ebc_tcon"
	.align	3
.LC8:
	.string	"\0016EBC tcon  E cannot find tcon node\n"
	.align	3
.LC9:
	.string	"\0016EBC tcon  E Get TCON device failed, probe defer.\n"
	.align	3
.LC10:
	.string	"panel,width"
	.align	3
.LC11:
	.string	"panel,height"
	.align	3
.LC12:
	.string	"panel,sdck"
	.align	3
.LC13:
	.string	"panel,lsl"
	.align	3
.LC14:
	.string	"panel,lbl"
	.align	3
.LC15:
	.string	"panel,ldl"
	.align	3
.LC16:
	.string	"panel,lel"
	.align	3
.LC17:
	.string	"panel,gdck-sta"
	.align	3
.LC18:
	.string	"panel,lgonl"
	.align	3
.LC19:
	.string	"panel,fsl"
	.align	3
.LC20:
	.string	"panel,fbl"
	.align	3
.LC21:
	.string	"panel,fdl"
	.align	3
.LC22:
	.string	"panel,fel"
	.align	3
.LC23:
	.string	"panel,mirror"
	.align	3
.LC24:
	.string	"panel,width-mm"
	.align	3
.LC25:
	.string	"panel,height-mm"
	.align	3
.LC26:
	.string	"panel,panel_16bit"
	.align	3
.LC27:
	.string	"panel,panel_color"
	.align	3
.LC28:
	.string	"panel,rearrange"
	.align	3
.LC29:
	.string	"panel,sdoe_mode"
	.align	3
.LC30:
	.string	"panel,sdce_width"
	.align	3
.LC31:
	.string	"panel,vcom-mv"
	.align	3
.LC32:
	.string	"panel,tcor_start"
	.align	3
.LC33:
	.string	"panel,tcor_percent"
	.align	3
.LC34:
	.string	"\0016EBC tcon  D tcon setup:\n"
	.align	3
.LC35:
	.string	"\0016EBC tcon  D   WIDTH:%u HEIGHT:%u SDCK:%u %uHz\n"
	.align	3
.LC36:
	.string	"\0016EBC tcon  D   VIRWIDTH:%u VIRHEIGHT:%u\n"
	.align	3
.LC37:
	.string	"\0016EBC tcon  D   FSL:%u FBL:%u FDL:%u FEL:%u VTOTAL:%u\n"
	.align	3
.LC38:
	.string	"\0016EBC tcon  D   LSL:%u LBL:%u LDL:%u LEL:%u HTOTAL:%u\n"
	.align	3
.LC39:
	.string	"\0016EBC tcon  D   GDCK_STA:%u LGONL:%u\n"
	.align	3
.LC40:
	.string	"\0016EBC tcon  D   TEMP CORRECTION: %u %u\n"
	.text
	.align	2
	.p2align 5,,15
	.global	tcon_setup_device
	.type	tcon_setup_device, %function
tcon_setup_device:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4698
	.align	3
	.8byte	.LPFE4698
	.text
.LPFE4698:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	adrp	x1, .LC7
	mov	w2, 0
	mov	x29, sp
	add	x1, x1, :lo12:.LC7
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x20, [x0]
	ldr	x0, [x20, 648]
	bl	of_parse_phandle
	cbz	x0, .L102
	bl	of_find_device_by_node
	cbz	x0, .L64
	stp	x21, x22, [sp, 32]
	adrp	x22, .LANCHOR1
	ldr	x0, [x0, 136]
	str	x0, [x22, #:lo12:.LANCHOR1]
	cbz	x0, .L103
	ldr	x0, [x20, 648]
	add	x21, x19, 384
	adrp	x1, .LC10
	mov	x2, x21
	add	x1, x1, :lo12:.LC10
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC11
	add	x2, x19, 388
	add	x1, x1, :lo12:.LC11
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC12
	add	x2, x19, 408
	add	x1, x1, :lo12:.LC12
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC13
	add	x2, x19, 416
	add	x1, x1, :lo12:.LC13
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC14
	add	x2, x19, 420
	add	x1, x1, :lo12:.LC14
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC15
	add	x2, x19, 424
	add	x1, x1, :lo12:.LC15
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC16
	add	x2, x19, 428
	add	x1, x1, :lo12:.LC16
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC17
	add	x2, x19, 432
	add	x1, x1, :lo12:.LC17
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC18
	add	x2, x19, 436
	add	x1, x1, :lo12:.LC18
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC19
	add	x2, x19, 440
	add	x1, x1, :lo12:.LC19
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC20
	add	x2, x19, 444
	add	x1, x1, :lo12:.LC20
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC21
	add	x2, x19, 448
	add	x1, x1, :lo12:.LC21
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC22
	add	x2, x19, 452
	add	x1, x1, :lo12:.LC22
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L101
	ldr	x0, [x20, 648]
	adrp	x1, .LC23
	add	x2, x19, 472
	add	x1, x1, :lo12:.LC23
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L104
	ldr	x0, [x20, 648]
	adrp	x1, .LC24
	add	x2, x19, 400
	add	x1, x1, :lo12:.LC24
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L105
.L82:
	ldr	x0, [x20, 648]
	adrp	x1, .LC25
	add	x2, x19, 404
	add	x1, x1, :lo12:.LC25
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L106
.L83:
	ldr	x0, [x20, 648]
	adrp	x1, .LC26
	add	x2, x19, 480
	add	x1, x1, :lo12:.LC26
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L107
.L84:
	ldr	x0, [x20, 648]
	adrp	x1, .LC27
	add	x2, x19, 484
	add	x1, x1, :lo12:.LC27
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L108
.L85:
	ldr	x0, [x20, 648]
	adrp	x1, .LC28
	add	x2, x19, 476
	add	x1, x1, :lo12:.LC28
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L109
.L86:
	ldr	x0, [x20, 648]
	adrp	x1, .LC29
	add	x2, x19, 488
	add	x1, x1, :lo12:.LC29
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L110
.L87:
	ldr	x0, [x20, 648]
	adrp	x1, .LC30
	add	x2, x19, 492
	add	x1, x1, :lo12:.LC30
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L111
.L88:
	ldr	x0, [x20, 648]
	add	x2, x19, 468
	mov	x4, 0
	mov	x3, 1
	adrp	x1, .LC31
	add	x1, x1, :lo12:.LC31
	bl	of_property_read_variable_u32_array
	adrp	x0, ebc_tcor_start
	add	x2, x0, :lo12:ebc_tcor_start
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	adrp	x1, .LC32
	add	x1, x1, :lo12:.LC32
	bl	of_property_read_variable_u32_array
	adrp	x0, ebc_tcor_percent
	add	x2, x0, :lo12:ebc_tcor_percent
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	adrp	x1, .LC33
	add	x1, x1, :lo12:.LC33
	adrp	x20, ebc_loglevel
	bl	of_property_read_variable_u32_array
	ldr	w0, [x19, 384]
	ldr	w1, [x21, 4]
	add	w0, w0, 63
	and	w0, w0, -64
	stp	w0, w1, [x21, 8]
	ldp	w5, w0, [x21, 64]
	add	w5, w5, w0
	ldp	w0, w1, [x21, 56]
	add	w0, w0, w1
	add	w5, w5, w0
	ldp	w0, w1, [x21, 40]
	add	w0, w0, w1
	ldp	w1, w2, [x21, 32]
	add	w1, w1, w2
	mov	w2, 19923
	add	w0, w0, w1
	stp	w5, w0, [x21, 72]
	mov	w1, 1000
	movk	w2, 0x1062, lsl 16
	mul	w0, w5, w0
	mul	w0, w0, w1
	ldr	w1, [x21, 24]
	umull	x1, w1, w2
	lsr	x1, x1, 38
	udiv	w0, w0, w1
	str	w0, [x21, 80]
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	bgt	.L112
.L68:
	ldr	x1, [x22, #:lo12:.LANCHOR1]
	adrp	x0, vsync_callback_handler
	add	x0, x0, :lo12:vsync_callback_handler
	add	x2, x22, :lo12:.LANCHOR1
	str	w5, [x1, 72]
	str	x0, [x1, 168]
	mov	w0, 0
	str	x2, [x19, 528]
	ldp	x21, x22, [sp, 32]
.L59:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L111:
	str	wzr, [x21, 108]
	b	.L88
	.p2align 2,,3
.L110:
	str	wzr, [x21, 104]
	adrp	x1, .LC30
	add	x2, x19, 492
	add	x1, x1, :lo12:.LC30
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L88
	b	.L111
	.p2align 2,,3
.L109:
	str	wzr, [x21, 92]
	adrp	x1, .LC29
	add	x2, x19, 488
	add	x1, x1, :lo12:.LC29
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L87
	b	.L110
	.p2align 2,,3
.L108:
	str	wzr, [x21, 100]
	adrp	x1, .LC28
	add	x2, x19, 476
	add	x1, x1, :lo12:.LC28
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L86
	b	.L109
	.p2align 2,,3
.L107:
	str	wzr, [x21, 96]
	adrp	x1, .LC27
	add	x2, x19, 484
	add	x1, x1, :lo12:.LC27
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L85
	b	.L108
	.p2align 2,,3
.L106:
	str	wzr, [x21, 20]
	adrp	x1, .LC26
	add	x2, x19, 480
	add	x1, x1, :lo12:.LC26
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L84
	b	.L107
	.p2align 2,,3
.L105:
	str	wzr, [x21, 16]
	adrp	x1, .LC25
	add	x2, x19, 404
	add	x1, x1, :lo12:.LC25
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L83
	b	.L106
	.p2align 2,,3
.L104:
	str	wzr, [x21, 88]
	adrp	x1, .LC24
	add	x2, x19, 400
	add	x1, x1, :lo12:.LC24
	ldr	x0, [x20, 648]
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L82
	b	.L105
.L112:
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L101
	ldr	w0, [x21, 80]
	mov	w4, 16960
	movk	w4, 0xf, lsl 16
	ldr	w1, [x19, 384]
	ldr	w2, [x21, 4]
	ldr	w3, [x21, 24]
	udiv	w4, w4, w0
	adrp	x0, .LC35
	add	x0, x0, :lo12:.LC35
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L101
	ldp	w1, w2, [x21, 8]
	adrp	x0, .LC36
	add	x0, x0, :lo12:.LC36
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	ldr	w5, [x21, 72]
	cmp	w0, 2
	ble	.L68
	ldp	w3, w4, [x21, 64]
	adrp	x0, .LC37
	ldp	w1, w2, [x21, 56]
	add	x0, x0, :lo12:.LC37
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L101
	ldp	w3, w4, [x21, 40]
	adrp	x0, .LC38
	ldp	w1, w2, [x21, 32]
	add	x0, x0, :lo12:.LC38
	ldr	w5, [x21, 76]
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L101
	ldp	w1, w2, [x21, 48]
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	bl	printk
	ldr	w0, [x20, #:lo12:ebc_loglevel]
	cmp	w0, 2
	ble	.L101
	adrp	x0, ebc_tcor_percent
	ldr	w2, [x0, #:lo12:ebc_tcor_percent]
	adrp	x0, ebc_tcor_start
	ldr	w1, [x0, #:lo12:ebc_tcor_start]
	adrp	x0, .LC40
	add	x0, x0, :lo12:.LC40
	bl	printk
	.p2align 5,,15
.L101:
	ldr	w5, [x19, 456]
	b	.L68
.L103:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L113
	ldp	x21, x22, [sp, 32]
.L64:
	mov	w0, -517
	b	.L59
.L102:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L114
	mov	w0, -19
	b	.L59
.L114:
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printk
	mov	w0, -19
	b	.L59
.L113:
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printk
	mov	w0, -517
	ldp	x21, x22, [sp, 32]
	b	.L59
	.size	tcon_setup_device, .-tcon_setup_device
	.data
	.align	3
	.set	.LANCHOR1,. + 0
	.type	hard_tcon, %object
	.size	hard_tcon, 16
hard_tcon:
	.zero	8
	.xword	hard_tcon_ops
	.type	hard_tcon_ops, %object
	.size	hard_tcon_ops, 56
hard_tcon_ops:
	.xword	hard_tcon_enable
	.xword	hard_tcon_disable
	.xword	hard_tcon_set_vsync_callback
	.xword	hard_tcon_set_line_callback
	.xword	hard_tcon_get_line_count
	.xword	hard_tcon_get_current_line
	.xword	hard_tcon_start_frame
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	sm_counter, %object
	.size	sm_counter, 4
sm_counter:
	.zero	4
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
