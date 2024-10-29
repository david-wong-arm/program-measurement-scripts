# Using David Wong's 'in codelet' repetitions

.file	"codelet.s"
.section .data
	.p2align 4,,15
	data:
		.ascii "Mary had a little lamb"
.text
.p2align 4,,15

.globl scale_
	.type	scale_, @function


scale_:
.LFB22:
	.cfi_startproc
	sub $32, %rsp
	#Store r10~r11 .. maybe unnecessary as those are dedicated temps registers
	mov %r10, 0(%rsp)
	mov %r11, 8(%rsp)

	# Save RDI being used in main loop
	mov %rdi, %r11

	

	# Compute n/8 in %rcx - used %rdx
	mov %rdx, %r10 # Save RDX first
	xor %rdx, %rdx
	mov %rdi, %rax
	mov $32, %rcx
	div %rcx 
	mov %rax, %rcx
	mov %r10, %rdx  # Restore rdx


	#Reset rax - to be used as return value
	xor %rax, %rax
 
	#Reset r9 - to be used as fake offset value
	xor %r9, %r9
 
	# Save RSI being used in main loop
	mov %rsi, %r10

	vmovups 0(%rsi), %ymm0
	vmovaps %ymm0, %ymm1
	vmovaps %ymm0, %ymm2
	vmovaps %ymm0, %ymm3
	vmovaps %ymm0, %ymm4
	vmovaps %ymm0, %ymm5
	vmovaps %ymm0, %ymm6
	vmovaps %ymm0, %ymm7
	vmovaps %ymm0, %ymm8
	vmovaps %ymm0, %ymm9
	vmovaps %ymm0, %ymm10
	vmovaps %ymm0, %ymm11
	vmovaps %ymm0, %ymm12
	vmovaps %ymm0, %ymm13
	vmovaps %ymm0, %ymm14
	vmovaps %ymm0, %ymm15

.DL1:
	# Restore RSI and RDI in each repetition
	mov %r10, %rsi
	mov %r11, %rdi

	#Alignment adjustment
#	add $8, %rsi

	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE

		vdivps %ymm0, %ymm0, %ymm0
		vdivps %ymm1, %ymm1, %ymm1
		vdivps %ymm2, %ymm2, %ymm2
		vdivps %ymm3, %ymm3, %ymm3
		vdivps %ymm4, %ymm4, %ymm4
		vdivps %ymm5, %ymm5, %ymm5
		vdivps %ymm6, %ymm6, %ymm6
		vdivps %ymm7, %ymm7, %ymm7
		vdivps %ymm8, %ymm8, %ymm8
		vdivps %ymm9, %ymm9, %ymm9
		vdivps %ymm10, %ymm10, %ymm10
		vdivps %ymm11, %ymm11, %ymm11
		vdivps %ymm12, %ymm12, %ymm12
		vdivps %ymm13, %ymm13, %ymm13
		vdivps %ymm14, %ymm14, %ymm14
		vdivps %ymm15, %ymm15, %ymm15
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $512, %rsi
		sub $512, %rdi
		jg  .L6
	# add n/$8 to eax
	add %rcx, %rax

	sub $1, %rdx
	testq %rdx, %rdx
	jne .DL1

.L3:
	mov 0(%rsp), %r10
	mov 8(%rsp), %r11
	add $32, %rsp

	ret
	.cfi_endproc

.LFE22:
	.size	scale_, .-scale_
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

