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

		vmulpd %ymm0, %ymm0, %ymm1
		vmulpd %ymm1, %ymm1, %ymm2
		vmulpd %ymm2, %ymm2, %ymm3
		vmulps %ymm3, %ymm3, %ymm4
		vmulps %ymm4, %ymm4, %ymm5
		vmulps %ymm5, %ymm5, %ymm6
		vmulps %ymm6, %ymm6, %ymm7
		vmulps %ymm7, %ymm7, %ymm8
		vmulps %ymm8, %ymm8, %ymm9
		vmulps %ymm9, %ymm9, %ymm10
		vmulps %ymm10, %ymm10, %ymm11
		vmulps %ymm11, %ymm11, %ymm12
		vmulps %ymm12, %ymm12, %ymm13
		vmulps %ymm13, %ymm13, %ymm14
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $512, %rsi
		sub $448, %rdi
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

