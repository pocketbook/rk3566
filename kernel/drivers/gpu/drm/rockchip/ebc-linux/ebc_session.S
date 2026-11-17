// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2025 Rockchip Electronics Co., Ltd.
 *
 */

	.arch armv8-a
	.file	"ebc_session.c"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_sess_get_buffer
	.type	ebc_sess_get_buffer, %function
ebc_sess_get_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4672
	.align	3
	.8byte	.LPFE4672
	.text
.LPFE4672:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x29, sp
	str	x19, [sp, 16]
	mov	x19, x0
	ldr	x0, [x0, 192]
	bl	ebc_mm_get_user_buffer
	cbz	x0, .L1
	ldr	w0, [x0]
	mov	w1, 48
	smaddl	x0, w0, w1, x19
.L1:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.size	ebc_sess_get_buffer, .-ebc_sess_get_buffer
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"\0016EBC sess  E put_buffer: wrong buffer index!\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_sess_put_buffer
	.type	ebc_sess_put_buffer, %function
ebc_sess_put_buffer:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4673
	.align	3
	.8byte	.LPFE4673
	.text
.LPFE4673:
	nop
	nop
	stp	x29, x30, [sp, -48]!
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x20, x0
	mov	x19, x1
	ldr	x0, [x0, 192]
	ldr	w1, [x1]
	bl	ebc_mm_buffer_by_index
	cbz	x0, .L23
	ldr	x1, [x0, 88]
	mov	x2, x0
	ldp	x4, x5, [x19, 32]
	stp	x4, x5, [x1]
	mov	w1, 1
	str	w1, [x0, 96]
	ldp	x4, x5, [x19, 32]
	stp	x4, x5, [x0, 72]
	ldr	w1, [x19, 12]
	str	w1, [x0, 28]
	adrp	x1, ebc_dump_updates
	ldr	w1, [x1, #:lo12:ebc_dump_updates]
	cbz	w1, .L12
	ldr	w1, [x0, 80]
	cbz	w1, .L12
	ldr	w1, [x0, 84]
	cbnz	w1, .L24
	.p2align 5,,15
.L12:
	ldr	x0, [x20, 192]
	mov	x1, x2
	bl	ebc_mm_put_user_buffer
.L8:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	ret
	.p2align 2,,3
.L24:
	add	x1, x0, 72
	str	x0, [sp, 40]
	bl	dump_update
	ldr	x2, [sp, 40]
	b	.L12
.L23:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	bgt	.L25
	mov	w0, -22
	b	.L8
.L25:
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printk
	mov	w0, -22
	b	.L8
	.size	ebc_sess_put_buffer, .-ebc_sess_put_buffer
	.align	2
	.p2align 5,,15
	.global	ebc_sess_query_lut
	.type	ebc_sess_query_lut, %function
ebc_sess_query_lut:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4674
	.align	3
	.8byte	.LPFE4674
	.text
.LPFE4674:
	nop
	nop
	add	x0, x0, 144
	ret
	.size	ebc_sess_query_lut, .-ebc_sess_query_lut
	.section	.rodata.str1.8
	.align	3
.LC1:
	.string	"\0016EBC sess  E open session fail!\n"
	.text
	.align	2
	.p2align 5,,15
	.global	ebc_open_session
	.type	ebc_open_session, %function
ebc_open_session:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4675
	.align	3
	.8byte	.LPFE4675
	.text
.LPFE4675:
	nop
	nop
	stp	x29, x30, [sp, -32]!
	mov	x2, 200
	mov	w1, 3520
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	mov	x19, x0
	adrp	x0, kmalloc_caches+64
	ldr	x0, [x0, #:lo12:kmalloc_caches+64]
	bl	kmem_cache_alloc_trace
	mov	x20, x0
	cbz	x0, .L36
	ldr	w0, [x19, 8]
	mov	w1, 524288
	str	w0, [x20]
	ldr	x0, [x19, 24]
	str	w0, [x20, 8]
	ldr	x0, [x19, 40]
	str	x19, [x20, 192]
	bl	dma_buf_fd
	str	w0, [x20, 4]
	ldr	x0, [x19, 40]
	ldr	x1, [x0, 8]
	add	x2, x1, 56
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L30		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L30 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L30		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L30 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x0, 1
#APP
// 179 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	stadd	x0, [x2]

// 0 "" 2
#NO_APP
	b	.L31
	.p2align 2,,3
.L30:
	add	x1, x1, 56
#APP
// 191 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic64_add
	prfm	pstl1strm, [x1]
1:	ldxr	x0, [x1]
	add	x0, x0, 1
	stxr	w2, x0, [x1]
	cbnz	w2, 1b
// 0 "" 2
#NO_APP
.L31:
	ldr	w0, [x19, 120]
	mov	w1, 524288
	str	w0, [x20, 48]
	ldr	x0, [x19, 136]
	str	w0, [x20, 56]
	ldr	x0, [x19, 152]
	bl	dma_buf_fd
	str	w0, [x20, 52]
	ldr	x0, [x19, 152]
	ldr	x1, [x0, 8]
	add	x2, x1, 56
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L32		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L32 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L32		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L32 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x0, 1
#APP
// 179 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	stadd	x0, [x2]

// 0 "" 2
#NO_APP
.L33:
	ldr	w0, [x19, 232]
	mov	w1, 524288
	str	w0, [x20, 96]
	ldr	x0, [x19, 248]
	str	w0, [x20, 104]
	ldr	x0, [x19, 264]
	bl	dma_buf_fd
	str	w0, [x20, 100]
	ldr	x0, [x19, 264]
	ldr	x1, [x0, 8]
	add	x2, x1, 56
#APP
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L34		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L34 - .	
		.quad		arm64_const_caps_ready+1 - .			
		.popsection				
	
// 0 "" 2
// 38 "./arch/arm64/include/asm/jump_label.h" 1
	1:	b		.L34		
		.pushsection	__jump_table, "aw"	
		.align		3			
		.long		1b - ., .L34 - .	
		.quad		cpu_hwcap_keys+81 - .			
		.popsection				
	
// 0 "" 2
#NO_APP
	mov	x0, 1
#APP
// 179 "./arch/arm64/include/asm/atomic_lse.h" 1
	.arch_extension lse
	stadd	x0, [x2]

// 0 "" 2
#NO_APP
.L27:
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L34:
	add	x1, x1, 56
#APP
// 191 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic64_add
	prfm	pstl1strm, [x1]
1:	ldxr	x0, [x1]
	add	x0, x0, 1
	stxr	w2, x0, [x1]
	cbnz	w2, 1b
// 0 "" 2
#NO_APP
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	ret
	.p2align 2,,3
.L32:
	add	x1, x1, 56
#APP
// 191 "./arch/arm64/include/asm/atomic_ll_sc.h" 1
	// atomic64_add
	prfm	pstl1strm, [x1]
1:	ldxr	x0, [x1]
	add	x0, x0, 1
	stxr	w2, x0, [x1]
	cbnz	w2, 1b
// 0 "" 2
#NO_APP
	b	.L33
	.p2align 2,,3
.L36:
	adrp	x0, ebc_loglevel
	ldr	w0, [x0, #:lo12:ebc_loglevel]
	cmp	w0, 0
	ble	.L27
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printk
	b	.L27
	.size	ebc_open_session, .-ebc_open_session
	.align	2
	.p2align 5,,15
	.global	ebc_close_session
	.type	ebc_close_session, %function
ebc_close_session:
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4676
	.align	3
	.8byte	.LPFE4676
	.text
.LPFE4676:
	nop
	nop
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	bl	kfree
	mov	w0, 0
	ldp	x29, x30, [sp], 16
	ret
	.size	ebc_close_session, .-ebc_close_session
	.ident	"GCC: (Arm GNU Toolchain 15.2.Rel1 (Build arm-15.86)) 15.2.1 20251203"
	.section	.note.GNU-stack,"",@progbits
