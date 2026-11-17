// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_drm.c"
	.text
#APP
	.section	".initcallrootfs.init", "a"		
__initcall__kmod_ebc_drm__345_460_vebc_initrootfs:			
.long	vebc_init - .	
.previous					

#NO_APP
	.align	2
	.p2align 5,,15
	.type	vebc_plane_atomic_update, %function
vebc_plane_atomic_update:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4218
	.align	3
	.8byte	.LPFE4218
	.text
.LPFE4218:
	nop
	nop
	ret
	.size	vebc_plane_atomic_update, .-vebc_plane_atomic_update
	.align	2
	.p2align 5,,15
	.type	vebc_connector_destroy, %function
vebc_connector_destroy:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4220
	.align	3
	.8byte	.LPFE4220
	.text
.LPFE4220:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x0, [sp, 24]
	bl	drm_connector_unregister
	ldr	x0, [sp, 24]
	bl	drm_connector_cleanup
	ldp	x29, x30, [sp], 32
	ret
	.size	vebc_connector_destroy, .-vebc_connector_destroy
	.align	2
	.p2align 5,,15
	.type	vebc_unbind, %function
vebc_unbind:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4230
	.align	3
	.8byte	.LPFE4230
	.text
.LPFE4230:
	nop
	nop
	stp	x29, x30, [sp, -64]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	ldr	x21, [x0, 120]
	ldr	x0, [x21, 8]
	add	x23, x0, 776
	ldr	x19, [x0, 776]
	cmp	x23, x19
	beq	.L5
	ldr	x20, [x19]
	sub	x19, x19, #16
	mov	w22, 1
	sub	x20, x20, #16
	b	.L8
	.p2align 2,,3
.L7:
	add	x0, x20, 16
	mov	x19, x20
	ldr	x1, [x20, 16]
	cmp	x23, x0
	beq	.L5
.L9:
	sub	x20, x1, #16
.L8:
	ldr	w0, [x19, 144]
	ldr	w1, [x21, 4920]
	lsl	w0, w22, w0
	tst	w0, w1
	beq	.L7
	add	x0, x19, 2936
	bl	drm_encoder_cleanup
	add	x0, x19, 3056
	bl	drm_connector_unregister
	add	x0, x19, 3056
	bl	drm_connector_cleanup
	add	x0, x19, 1640
	bl	drm_plane_cleanup
	ldr	w1, [x19, 144]
	ldr	w0, [x21, 4920]
	lsl	w1, w22, w1
	bic	w0, w0, w1
	str	w0, [x21, 4920]
	mov	x0, x19
	mov	x19, x20
	bl	drm_crtc_cleanup
	add	x0, x20, 16
	ldr	x1, [x20, 16]
	cmp	x23, x0
	bne	.L9
.L5:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	ret
	.size	vebc_unbind, .-vebc_unbind
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"%dx%d"
	.align	3
.LC1:
	.string	"\0016[drm] add mode: name(%s) hdisplay(%d) vdisplay(%d) clock(%d KHz)\n"
	.align	3
.LC2:
	.string	"Fail to add mode\n"
	.align	3
.LC3:
	.string	"\0016[drm] num_modes=%d\n"
	.section	.text.unlikely,"ax",@progbits
	.align	2
	.type	vebc_conn_get_modes, %function
vebc_conn_get_modes:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4221
	.align	3
	.8byte	.LPFE4221
	.section	.text.unlikely
.LPFE4221:
	nop
	nop
	sub	sp, sp, #160
	mov	x2, 108
	stp	x29, x30, [sp, 128]
	add	x29, sp, 128
	stp	x19, x20, [sp, 144]
	mov	x19, x0
	mrs	x0, sp_el0
	ldr	x1, [x0, 1280]
	str	x1, [sp, 120]
	mov	x1, 0
	add	x0, sp, 12
	ldr	x20, [x19]
	bl	memset
	adrp	x0, .LANCHOR0
	add	x1, x0, :lo12:.LANCHOR0
	ldr	w2, [x0, #:lo12:.LANCHOR0]
	ldr	w3, [x1, 4]
	mov	w1, 60
	strh	w2, [sp, 4]
	strh	w2, [sp, 6]
	strh	w2, [sp, 8]
	mul	w0, w2, w3
	strh	w2, [sp, 10]
	strh	w3, [sp, 14]
	strh	w3, [sp, 16]
	strh	w3, [sp, 18]
	mul	w0, w0, w1
	mov	w1, 1000
	strh	w3, [sp, 20]
	udiv	w0, w0, w1
	adrp	x1, .LC0
	add	x1, x1, :lo12:.LC0
	str	w0, [sp]
	mov	w0, 5
	str	w0, [sp, 24]
	mov	w0, 64
	strb	w0, [sp, 62]
	add	x0, sp, 80
	bl	sprintf
	ldrh	w3, [sp, 14]
	ldrh	w2, [sp, 4]
	add	x1, sp, 80
	ldr	w4, [sp]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printk
	mov	x1, sp
	mov	x0, x20
	bl	drm_mode_duplicate
	cbz	x0, .L15
	mov	x1, x0
	mov	w0, 8
	strb	w0, [x1, 62]
	mov	x0, x19
	mov	w19, 1
	bl	drm_mode_probed_add
	b	.L16
.L15:
	mov	w19, 0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	__drm_err
.L16:
	mov	w1, w19
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printk
	mrs	x0, sp_el0
	ldr	x1, [sp, 120]
	ldr	x2, [x0, 1280]
	subs	x1, x1, x2
	mov	x2, 0
	beq	.L17
	bl	__stack_chk_fail
.L17:
	ldp	x29, x30, [sp, 128]
	mov	w0, w19
	ldp	x19, x20, [sp, 144]
	add	sp, sp, 160
	ret
	.size	vebc_conn_get_modes, .-vebc_conn_get_modes
	.text
	.align	2
	.p2align 5,,15
	.type	vebc_crtc_atomic_enable, %function
vebc_crtc_atomic_enable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4222
	.align	3
	.8byte	.LPFE4222
	.text
.LPFE4222:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	drm_crtc_vblank_on
	ldp	x29, x30, [sp], 16
	ret
	.size	vebc_crtc_atomic_enable, .-vebc_crtc_atomic_enable
	.align	2
	.p2align 5,,15
	.type	vebc_remove, %function
vebc_remove:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4232
	.align	3
	.8byte	.LPFE4232
	.text
.LPFE4232:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	add	x0, x0, 16
	adrp	x1, .LANCHOR1
	mov	x29, sp
	add	x1, x1, :lo12:.LANCHOR1
	bl	component_del
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	vebc_remove, .-vebc_remove
	.align	2
	.p2align 5,,15
	.type	vebc_probe, %function
vebc_probe:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4231
	.align	3
	.8byte	.LPFE4231
	.text
.LPFE4231:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	add	x0, x0, 16
	adrp	x1, .LANCHOR1
	mov	x29, sp
	add	x1, x1, :lo12:.LANCHOR1
	bl	component_add
	ldp	x29, x30, [sp], 16
	ret
	.size	vebc_probe, .-vebc_probe
	.section	.exit.text,"ax",@progbits
	.align	2
	.type	vebc_exit, %function
vebc_exit:
	stp	x29, x30, [sp, -16]!
	adrp	x0, .LANCHOR0+8
	mov	x29, sp
	ldr	x0, [x0, #:lo12:.LANCHOR0+8]
	bl	platform_device_unregister
	ldp	x29, x30, [sp], 16
	ret
	.size	vebc_exit, .-vebc_exit
	.section	.rodata.str1.8
	.align	3
.LC4:
	.string	"virtula-ebc"
	.align	3
.LC5:
	.string	"failed to register platform device %s\n"
	.section	.init.text,"ax",@progbits
	.align	2
	.type	vebc_init, %function
vebc_init:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4233
	.align	3
	.8byte	.LPFE4233
	.section	.init.text
.LPFE4233:
	nop
	nop
	sub	sp, sp, #128
	mrs	x0, sp_el0
	mov	x2, 80
	stp	x29, x30, [sp, 96]
	add	x29, sp, 96
	stp	x19, x20, [sp, 112]
	adrp	x19, .LANCHOR0
	add	x19, x19, :lo12:.LANCHOR0
	ldr	x1, [x0, 1280]
	str	x1, [sp, 88]
	mov	x1, 0
	add	x0, sp, 8
	bl	memset
	adrp	x20, .LC4
	mov	w0, -1
	add	x20, x20, :lo12:.LC4
	str	xzr, [sp]
	str	x20, [sp, 24]
	str	w0, [sp, 32]
	mov	x0, sp
	bl	platform_device_register_full
	str	x0, [x19, 8]
	cmn	x0, #4096
	bls	.L31
	mov	x1, x20
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	__drm_err
	ldr	w0, [x19, 8]
	b	.L27
.L31:
	mov	w0, 0
.L27:
	mrs	x1, sp_el0
	ldr	x3, [sp, 88]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L29
	bl	__stack_chk_fail
.L29:
	ldp	x29, x30, [sp, 96]
	ldp	x19, x20, [sp, 112]
	add	sp, sp, 128
	ret
	.size	vebc_init, .-vebc_init
	.section	.rodata.str1.8
	.align	3
.LC8:
	.string	"unable to find compatible in dtb\n"
	.align	3
.LC9:
	.string	"panel,width"
	.align	3
.LC10:
	.string	"panel,height"
	.align	3
.LC11:
	.string	"\0016[drm] panel: %dx%d\n"
	.align	3
.LC12:
	.string	"Failed to init CRTC\n"
	.align	3
.LC13:
	.string	"Failed to init crtc-%d\n"
	.align	3
.LC14:
	.string	"IS_VIRTUAL"
	.align	3
.LC15:
	.string	"SOC_ID"
	.align	3
.LC16:
	.string	"rockchip,rk3588"
	.align	3
.LC17:
	.string	"rockchip,rk3568"
	.align	3
.LC18:
	.string	"rockchip,rk3566"
	.align	3
.LC19:
	.string	"rockchip,rk3562"
	.align	3
.LC20:
	.string	"rockchip,rk3528"
	.align	3
.LC21:
	.string	"rockchip,px30"
	.align	3
.LC22:
	.string	"Failed to init connector-%d\n"
	.align	3
.LC23:
	.string	"Failed to register connector-%d\n"
	.align	3
.LC24:
	.string	"Failed to init encoder-%d\n"
	.align	3
.LC25:
	.string	"Failed to attach connector-%d to encoder-%d\n"
	.align	3
.LC26:
	.string	"\0016[drm] Create %d(total: %d) virtual crtcs\n"
	.align	3
.LC27:
	.string	"\0014[drm] Failed to create virtual crtc, index = %d\n"
	.align	3
.LC28:
	.string	"Failed to init primary plane for crtc-%d\n"
	.text
	.align	2
	.p2align 5,,15
	.type	vebc_bind, %function
vebc_bind:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4229
	.align	3
	.8byte	.LPFE4229
	.text
.LPFE4229:
	nop
	nop
	stp	x29, x30, [sp, -80]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	mrs	x0, sp_el0
	stp	x23, x24, [sp, 48]
	sub	sp, sp, #624
	mov	x24, x2
	mov	x2, 600
	ldr	x1, [x0, 1280]
	str	x1, [sp, 616]
	mov	x1, 0
	add	x0, sp, 16
	bl	memset
	adrp	x1, .LC6
	add	x1, x1, :lo12:.LC6
	ldr	x2, [x1]
	str	x2, [sp, 80]
	ldr	x0, [x1, 5]
	mov	x2, 115
	mov	w1, 0
	str	x0, [sp, 85]
	add	x0, sp, 93
	bl	memset
	adrp	x1, .LC7
	add	x1, x1, :lo12:.LC7
	ldp	x2, x3, [x1]
	ldr	w0, [x1, 15]
	add	x1, sp, 280
	stp	x2, x3, [x1]
	add	x1, sp, 295
	mov	x2, 109
	str	w0, [x1]
	mov	w1, 0
	add	x0, sp, 299
	bl	memset
	mov	x0, x20
	mov	w2, 3520
	mov	x1, 4928
	bl	devm_kmalloc
	cbz	x0, .L53
	mov	x19, x0
	add	x1, sp, 16
	mov	x2, 0
	mov	x0, 0
	str	x21, [sp, 656]
	str	x22, [sp, 664]
	bl	of_find_matching_node_and_match
	mov	x21, x0
	cbz	x0, .L61
	adrp	x23, .LANCHOR0
	add	x22, x23, :lo12:.LANCHOR0
	adrp	x1, .LC9
	mov	x2, x22
	add	x1, x1, :lo12:.LC9
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .L37
.L36:
	ldr	x21, [sp, 656]
	mov	w0, -22
	ldr	x22, [sp, 664]
.L33:
	mrs	x1, sp_el0
	ldr	x3, [sp, 616]
	ldr	x2, [x1, 1280]
	subs	x3, x3, x2
	mov	x2, 0
	bne	.L62
	add	sp, sp, 624
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	ret
	.p2align 2,,3
.L37:
	adrp	x1, .LC10
	add	x2, x22, 4
	add	x1, x1, :lo12:.LC10
	mov	x0, x21
	mov	x4, 0
	mov	x3, 1
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .L36
	ldr	w1, [x23, #:lo12:.LANCHOR0]
	adrp	x0, .LC11
	ldr	w2, [x22, 4]
	add	x0, x0, :lo12:.LC11
	add	x23, x19, 1664
	bl	printk
	stp	x20, x24, [x19]
	mov	x0, x24
	str	x19, [x20, 120]
	adrp	x20, .LANCHOR1
	str	xzr, [sp]
	add	x20, x20, :lo12:.LANCHOR1
	mov	x1, x23
	add	x4, x20, 16
	add	x3, x20, 56
	mov	w7, 1
	mov	x6, 0
	mov	w5, 9
	mov	w2, 0
	bl	drm_universal_plane_init
	cbnz	w0, .L39
	add	x0, x20, 160
	str	x0, [x23, 1232]
	add	x21, x19, 24
	add	x4, x20, 216
	ldr	x0, [x19, 8]
	mov	x2, x23
	mov	x1, x21
	mov	x5, 0
	mov	x24, x0
	mov	x3, 0
	bl	drm_crtc_init_with_planes
	cbnz	w0, .L63
	add	x0, x20, 408
	mov	w1, 4
	str	x0, [x21, 432]
	movk	w1, 0x8000, lsl 16
	mov	w3, -858993460
	mov	x0, x24
	adrp	x2, .LC14
	add	x2, x2, :lo12:.LC14
	bl	drm_property_create_object
	mov	x1, x0
	str	x1, [x21, 4880]
	add	x0, x19, 120
	mov	x2, 1
	add	x22, x19, 3080
	bl	drm_object_attach_property
	adrp	x2, .LC15
	mov	w1, 4
	add	x2, x2, :lo12:.LC15
	mov	x0, x24
	mov	w3, -858993460
	movk	w1, 0x8000, lsl 16
	bl	drm_property_create_object
	str	x0, [x21, 4888]
	mov	x24, x0
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	of_machine_is_compatible
	cbnz	w0, .L54
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	bl	of_machine_is_compatible
	cbnz	w0, .L55
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	bl	of_machine_is_compatible
	cbnz	w0, .L56
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	bl	of_machine_is_compatible
	cbnz	w0, .L57
	adrp	x0, .LC20
	add	x0, x0, :lo12:.LC20
	bl	of_machine_is_compatible
	cbnz	w0, .L58
	adrp	x0, .LC21
	add	x0, x0, :lo12:.LC21
	bl	of_machine_is_compatible
	cmp	w0, 0
	mov	x2, 13094
	csel	x2, xzr, x2, eq
.L42:
	mov	x1, x24
	add	x0, x19, 120
	bl	drm_object_attach_property
	ldr	x0, [x19, 8]
	add	x2, x20, 536
	mov	x1, x22
	mov	w3, 15
	bl	drm_connector_init
	cbnz	w0, .L64
	add	x0, x20, 648
	str	x0, [x19, 4520]
	mov	x0, x22
	bl	drm_connector_register
	cbnz	w0, .L65
	ldr	x0, [x19, 8]
	add	x2, x20, 728
	add	x1, x19, 2960
	mov	x4, 0
	mov	w3, 5
	bl	drm_encoder_init
	cbnz	w0, .L66
	mov	w20, 1
	str	w20, [x19, 3032]
	add	x1, x19, 2960
	mov	x0, x22
	bl	drm_connector_attach_encoder
	cbnz	w0, .L67
	ldr	w1, [x19, 168]
	ldr	w0, [x19, 4920]
	lsl	w1, w20, w1
	orr	w0, w0, w1
	mov	w1, w20
	str	w0, [x19, 4920]
.L50:
	mov	w2, 1
	adrp	x0, .LC26
	add	x0, x0, :lo12:.LC26
	bl	printk
	ldr	x21, [sp, 656]
	mov	w0, 0
	ldr	x22, [sp, 664]
	b	.L33
	.p2align 2,,3
.L61:
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	__drm_err
	b	.L36
.L53:
	mov	w0, -12
	b	.L33
.L62:
	str	x21, [sp, 656]
	str	x22, [sp, 664]
	str	x25, [sp, 688]
	bl	__stack_chk_fail
.L39:
	adrp	x0, .LC28
	mov	w1, 0
	add	x0, x0, :lo12:.LC28
	bl	__drm_err
.L51:
	mov	w1, 0
	adrp	x0, .LC27
	add	x0, x0, :lo12:.LC27
	bl	printk
	mov	w1, 0
	b	.L50
.L63:
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	__drm_err
	adrp	x0, .LC13
	mov	w1, 0
	add	x0, x0, :lo12:.LC13
	bl	__drm_err
.L41:
	mov	x0, x23
	bl	drm_plane_cleanup
	b	.L51
.L54:
	mov	x2, 13704
	b	.L42
.L55:
	mov	x2, 13672
	b	.L42
.L56:
	mov	x2, 13670
	b	.L42
.L57:
	mov	x2, 13666
	b	.L42
.L58:
	mov	x2, 13608
	b	.L42
.L64:
	adrp	x0, .LC22
	mov	w1, 0
	add	x0, x0, :lo12:.LC22
	bl	__drm_err
.L44:
	mov	x0, x21
	bl	drm_crtc_cleanup
	b	.L41
.L65:
	adrp	x0, .LC23
	mov	w1, 0
	add	x0, x0, :lo12:.LC23
	bl	__drm_err
.L46:
	mov	x0, x22
	bl	drm_connector_cleanup
	b	.L44
.L66:
	adrp	x0, .LC24
	mov	w1, 0
	add	x0, x0, :lo12:.LC24
	bl	__drm_err
.L48:
	mov	x0, x22
	bl	drm_connector_unregister
	b	.L46
.L67:
	mov	w2, 0
	mov	w1, 0
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	__drm_err
	add	x0, x19, 2960
	bl	drm_encoder_cleanup
	b	.L48
	.size	vebc_bind, .-vebc_bind
	.section	.rodata.str1.8
	.align	3
.LC6:
	.string	"rockchip,ebc"
	.align	3
.LC7:
	.string	"rockchip,ebc-linux"
	.text
	.align	2
	.p2align 5,,15
	.type	__raw_spin_lock_irqsave, %function
__raw_spin_lock_irqsave:
	mov	x3, x0
#APP
// 72 "./arch/arm64/include/asm/irqflags.h" 1
	.if 1 == 1
661:
	mrs	x4, daif
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 42
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
		.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
	.equ	.L__reg_num_x\num, \num
	.endr
	.equ	.L__reg_num_xzr, 31
	.macro	mrs_s, rt, sreg
.inst (0xd5200000|(\sreg)|(.L__reg_num_\rt))
		.endm
	mrs_s x4, (((3) << 19) | ((0) << 16) | ((4) << 12) | ((6) << 8) | ((0) << 5))
	.purgem	mrs_s

664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
// 87 "./arch/arm64/include/asm/irqflags.h" 1
	.if 1 == 1
661:
	and	w0, w4, #0x00000080
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 42
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
	eor	w0, w4, #0xe0
664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	cbz	w0, .L82
.L69:
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L71		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L71 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L71		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L71 - .	
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
	cbnz	w0, .L83
.L79:
	mov	x0, x4
	ret
	.p2align 2,,3
.L71:
	mov	x1, 0
	mov	w2, 1
#APP
// 284 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
		prfm	pstl1strm, [x3]
1:	ldaxr	w0, [x3]
	eor	w5, w0, w1
	cbnz	w5, 2f
	stxr	w5, w2, [x3]
	cbnz	w5, 1b
	
2:
// 0 "" 2
#NO_APP
	cbz	w0, .L79
.L83:
	stp	x29, x30, [sp, -32]!
	mov	w1, w0
	mov	x0, x3
	mov	x29, sp
	str	x4, [sp, 24]
	bl	queued_spin_lock_slowpath
	ldr	x4, [sp, 24]
	ldp	x29, x30, [sp], 32
	mov	x0, x4
	ret
	.p2align 2,,3
.L82:
#APP
// 21 "./arch/arm64/include/asm/jump_label.h" 1
	1:	nop					
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L74 - .	
		.quad		gic_nonsecure_priorities - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x0, 96
.L70:
#APP
// 56 "./arch/arm64/include/asm/irqflags.h" 1
	.if 1 == 1
661:
	msr	daifset, #2		// arch_local_irq_disable
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 42
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
		.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
	.equ	.L__reg_num_x\num, \num
	.endr
	.equ	.L__reg_num_xzr, 31
	.macro	msr_s, sreg, rt
.inst (0xd5000000|(\sreg)|(.L__reg_num_\rt))
		.endm
	msr_s (((3) << 19) | ((0) << 16) | ((4) << 12) | ((6) << 8) | ((0) << 5)), x0
	.purgem	msr_s

664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
#NO_APP
	b	.L69
	.p2align 2,,3
.L74:
	mov	x0, 160
	b	.L70
	.size	__raw_spin_lock_irqsave, .-__raw_spin_lock_irqsave
	.align	2
	.p2align 5,,15
	.type	vebc_crtc_atomic_disable, %function
vebc_crtc_atomic_disable:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4223
	.align	3
	.8byte	.LPFE4223
	.text
.LPFE4223:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	bl	drm_crtc_vblank_off
	ldr	x0, [x19, 1472]
	ldr	x1, [x0, 304]
	cbz	x1, .L84
	ldrb	w0, [x0, 9]
	tbz	x0, 0, .L94
.L84:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L94:
	ldr	x0, [x19]
	add	x0, x0, 376
	bl	__raw_spin_lock_irqsave
	mov	x2, x0
	str	x2, [sp, 40]
	ldr	x0, [x19, 1472]
	ldr	x1, [x0, 304]
	mov	x0, x19
	bl	drm_crtc_send_vblank_event
	ldr	x0, [x19]
	mov	w1, 0
	add	x0, x0, 376
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w1, [x0]
// 0 "" 2
#NO_APP
	ldr	x2, [sp, 40]
#APP
// 124 "./arch/arm64/include/asm/irqflags.h" 1
	.if 1 == 1
661:
	msr	daif, x2
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 42
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
		.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
	.equ	.L__reg_num_x\num, \num
	.endr
	.equ	.L__reg_num_xzr, 31
	.macro	msr_s, sreg, rt
.inst (0xd5000000|(\sreg)|(.L__reg_num_\rt))
		.endm
	msr_s (((3) << 19) | ((0) << 16) | ((4) << 12) | ((6) << 8) | ((0) << 5)), x2
	.purgem	msr_s

664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
// 21 "./arch/arm64/include/asm/jump_label.h" 1
	1:	nop					
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L86 - .	
		.quad		gic_pmr_sync - .			
		.popsection				
	
// 0 "" 2
#NO_APP
.L88:
	ldr	x0, [x19, 1472]
	str	xzr, [x0, 304]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L86:
#APP
// 132 "./arch/arm64/include/asm/irqflags.h" 1
	dsb sy
// 0 "" 2
#NO_APP
	b	.L88
	.size	vebc_crtc_atomic_disable, .-vebc_crtc_atomic_disable
	.align	2
	.p2align 5,,15
	.type	vebc_crtc_atomic_flush, %function
vebc_crtc_atomic_flush:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4224
	.align	3
	.8byte	.LPFE4224
	.text
.LPFE4224:
	nop
	nop
	ldr	x1, [x0, 1472]
	ldr	x1, [x1, 304]
	cbz	x1, .L107
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0]
	add	x0, x0, 376
	bl	__raw_spin_lock_irqsave
	mov	x20, x0
	mov	x0, x19
	bl	drm_crtc_vblank_get
	ldr	x1, [x19, 1472]
	ldr	x1, [x1, 304]
	cbnz	w0, .L110
	mov	x0, x19
	bl	drm_crtc_arm_vblank_event
.L98:
	ldr	x0, [x19]
	mov	w1, 0
	add	x0, x0, 376
#APP
// 99 "./include/asm-generic/qspinlock.h" 1
	stlrb w1, [x0]
// 0 "" 2
// 124 "./arch/arm64/include/asm/irqflags.h" 1
	.if 1 == 1
661:
	msr	daif, x20
662:
.pushsection .altinstructions,"a"
 .word 661b - .
 .word 663f - .
 .hword 42
 .byte 662b-661b
 .byte 664f-663f
.popsection
.subsection 1
663:
		.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
	.equ	.L__reg_num_x\num, \num
	.endr
	.equ	.L__reg_num_xzr, 31
	.macro	msr_s, sreg, rt
.inst (0xd5000000|(\sreg)|(.L__reg_num_\rt))
		.endm
	msr_s (((3) << 19) | ((0) << 16) | ((4) << 12) | ((6) << 8) | ((0) << 5)), x20
	.purgem	msr_s

664:
	.org	. - (664b-663b) + (662b-661b)
	.org	. - (662b-661b) + (664b-663b)
	.previous
.endif

// 0 "" 2
// 21 "./arch/arm64/include/asm/jump_label.h" 1
	1:	nop					
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L99 - .	
		.quad		gic_pmr_sync - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	ldr	x0, [x19, 1472]
	str	xzr, [x0, 304]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L110:
	mov	x0, x19
	bl	drm_crtc_send_vblank_event
	b	.L98
	.p2align 2,,3
.L107:
	ret
	.p2align 2,,3
.L99:
#APP
// 132 "./arch/arm64/include/asm/irqflags.h" 1
	dsb sy
// 0 "" 2
#NO_APP
	ldr	x0, [x19, 1472]
	str	xzr, [x0, 304]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	vebc_crtc_atomic_flush, .-vebc_crtc_atomic_flush
	.global	vebc_platform_driver
	.global	vebc_component_ops
	.section	.rodata
	.align	3
	.set	.LANCHOR1,. + 0
	.type	vebc_component_ops, %object
	.size	vebc_component_ops, 16
vebc_component_ops:
	.xword	vebc_bind
	.xword	vebc_unbind
	.type	vebc_formats, %object
	.size	vebc_formats, 36
vebc_formats:
	.word	875713112
	.word	875709016
	.word	875714642
	.word	875714626
	.word	875710290
	.word	875710274
	.word	909199186
	.word	909199170
	.word	538982482
	.zero	4
	.type	vebc_plane_funcs, %object
	.size	vebc_plane_funcs, 104
vebc_plane_funcs:
	.xword	drm_atomic_helper_update_plane
	.xword	drm_atomic_helper_disable_plane
	.xword	drm_plane_cleanup
	.xword	drm_atomic_helper_plane_reset
	.zero	8
	.xword	drm_atomic_helper_plane_duplicate_state
	.xword	drm_atomic_helper_plane_destroy_state
	.zero	48
	.type	vebc_plane_helper_funcs, %object
	.size	vebc_plane_helper_funcs, 56
vebc_plane_helper_funcs:
	.zero	24
	.xword	vebc_plane_atomic_update
	.zero	24
	.type	vebc_crtc_funcs, %object
	.size	vebc_crtc_funcs, 192
vebc_crtc_funcs:
	.xword	drm_atomic_helper_crtc_reset
	.zero	32
	.xword	drm_crtc_cleanup
	.xword	drm_atomic_helper_set_config
	.xword	drm_atomic_helper_page_flip
	.zero	16
	.xword	drm_atomic_helper_crtc_duplicate_state
	.xword	drm_atomic_helper_crtc_destroy_state
	.zero	96
	.type	vebc_crtc_helper_funcs, %object
	.size	vebc_crtc_helper_funcs, 128
vebc_crtc_helper_funcs:
	.zero	96
	.xword	vebc_crtc_atomic_flush
	.xword	vebc_crtc_atomic_enable
	.xword	vebc_crtc_atomic_disable
	.zero	8
	.type	vebc_connector_funcs, %object
	.size	vebc_connector_funcs, 112
vebc_connector_funcs:
	.zero	8
	.xword	drm_atomic_helper_connector_reset
	.zero	16
	.xword	drm_helper_probe_single_connector_modes
	.zero	24
	.xword	vebc_connector_destroy
	.xword	drm_atomic_helper_connector_duplicate_state
	.xword	drm_atomic_helper_connector_destroy_state
	.zero	24
	.type	vebc_conn_helper_funcs, %object
	.size	vebc_conn_helper_funcs, 80
vebc_conn_helper_funcs:
	.xword	vebc_conn_get_modes
	.zero	72
	.type	vebc_encoder_funcs, %object
	.size	vebc_encoder_funcs, 32
vebc_encoder_funcs:
	.zero	8
	.xword	drm_encoder_cleanup
	.zero	16
	.data
	.align	3
	.type	vebc_platform_driver, %object
	.size	vebc_platform_driver, 200
vebc_platform_driver:
	.xword	vebc_probe
	.xword	vebc_remove
	.zero	24
	.xword	.LC4
	.zero	136
	.zero	16
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	ebc_hdisplay, %object
	.size	ebc_hdisplay, 4
ebc_hdisplay:
	.zero	4
	.type	ebc_vdisplay, %object
	.size	ebc_vdisplay, 4
ebc_vdisplay:
	.zero	4
	.type	vebc_pdev, %object
	.size	vebc_pdev, 8
vebc_pdev:
	.zero	8
	.section	.discard.addressable,"aw"
	.align	3
	.type	__UNIQUE_ID___addressable_vebc_init346, %object
	.size	__UNIQUE_ID___addressable_vebc_init346, 8
__UNIQUE_ID___addressable_vebc_init346:
	.xword	vebc_init
	.section	.exitcall.exit,"aw"
	.align	3
	.type	__exitcall_vebc_exit, %object
	.size	__exitcall_vebc_exit, 8
__exitcall_vebc_exit:
	.xword	vebc_exit
	.section	.modinfo,"a"
	.type	__UNIQUE_ID_license349, %object
	.size	__UNIQUE_ID_license349, 20
__UNIQUE_ID_license349:
	.string	"ebc_drm.license=GPL"
	.type	__UNIQUE_ID_file348, %object
	.size	__UNIQUE_ID_file348, 46
__UNIQUE_ID_file348:
	.string	"ebc_drm.file=drivers/gpu/drm/rockchip/ebc_drm"
	.type	__UNIQUE_ID_author347, %object
	.size	__UNIQUE_ID_author347, 42
__UNIQUE_ID_author347:
	.string	"ebc_drm.author=Andy Yan <rock-chips@.com>"
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
