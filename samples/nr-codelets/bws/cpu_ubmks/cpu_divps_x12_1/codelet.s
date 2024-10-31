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

	movups 0(%rsi), %xmm0
	movaps %xmm0, %xmm1
	movaps %xmm0, %xmm2
	movaps %xmm0, %xmm3
	movaps %xmm0, %xmm4
	movaps %xmm0, %xmm5
	movaps %xmm0, %xmm6
	movaps %xmm0, %xmm7
	movaps %xmm0, %xmm8
	movaps %xmm0, %xmm9
	movaps %xmm0, %xmm10
	movaps %xmm0, %xmm11
	movaps %xmm0, %xmm12
	movaps %xmm0, %xmm13
	movaps %xmm0, %xmm14
	movaps %xmm0, %xmm15

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

		divps %xmm0, %xmm1
		divps %xmm1, %xmm2
		divps %xmm2, %xmm3
		divps %xmm3, %xmm4
		divps %xmm4, %xmm5
		divps %xmm5, %xmm6
		divps %xmm6, %xmm7
		divps %xmm7, %xmm8
		divps %xmm8, %xmm9
		divps %xmm9, %xmm10
		divps %xmm10, %xmm11
		divps %xmm11, %xmm12
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $256, %rsi
		sub $192, %rdi
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

