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

		cvtps2pd %xmm0, %xmm0
		cvtps2pd %xmm1, %xmm1
		cvtps2pd %xmm2, %xmm2
		cvtps2pd %xmm3, %xmm3
		cvtps2pd %xmm4, %xmm4
		cvtps2pd %xmm5, %xmm5
		cvtps2pd %xmm6, %xmm6
		cvtps2pd %xmm7, %xmm7
		cvtps2pd %xmm8, %xmm8
		cvtps2pd %xmm9, %xmm9
		cvtps2pd %xmm10, %xmm10
		cvtps2pd %xmm11, %xmm11
		cvtps2pd %xmm12, %xmm12
		cvtps2pd %xmm13, %xmm13
		cvtps2pd %xmm14, %xmm14
		cvtps2pd %xmm15, %xmm15
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $256, %rsi
		sub $256, %rdi
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

