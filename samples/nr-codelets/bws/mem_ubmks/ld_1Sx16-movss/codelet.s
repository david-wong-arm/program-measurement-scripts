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
	mov $8, %rcx
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

		movss 0(%rsi,%r9,8), %xmm0
		movss 4(%rsi,%r9,8), %xmm1
		movss 8(%rsi,%r9,8), %xmm2
		movss 12(%rsi,%r9,8), %xmm3
		movss 16(%rsi,%r9,8), %xmm4
		movss 20(%rsi,%r9,8), %xmm5
		movss 24(%rsi,%r9,8), %xmm6
		movss 28(%rsi,%r9,8), %xmm7
		movss 32(%rsi,%r9,8), %xmm8
		movss 36(%rsi,%r9,8), %xmm9
		movss 40(%rsi,%r9,8), %xmm10
		movss 44(%rsi,%r9,8), %xmm11
		movss 48(%rsi,%r9,8), %xmm12
		movss 52(%rsi,%r9,8), %xmm13
		movss 56(%rsi,%r9,8), %xmm14
		movss 60(%rsi,%r9,8), %xmm15
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
		add $64,%rsi
		sub $64, %rdi
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

