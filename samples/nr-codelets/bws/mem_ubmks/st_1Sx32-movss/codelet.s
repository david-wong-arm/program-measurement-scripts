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

		movss %xmm0, 0(%rsi,%r9,8)
		movss %xmm1, 4(%rsi,%r9,8)
		movss %xmm2, 8(%rsi,%r9,8)
		movss %xmm3, 12(%rsi,%r9,8)
		movss %xmm4, 16(%rsi,%r9,8)
		movss %xmm5, 20(%rsi,%r9,8)
		movss %xmm6, 24(%rsi,%r9,8)
		movss %xmm7, 28(%rsi,%r9,8)
		movss %xmm8, 32(%rsi,%r9,8)
		movss %xmm9, 36(%rsi,%r9,8)
		movss %xmm10, 40(%rsi,%r9,8)
		movss %xmm11, 44(%rsi,%r9,8)
		movss %xmm12, 48(%rsi,%r9,8)
		movss %xmm13, 52(%rsi,%r9,8)
		movss %xmm14, 56(%rsi,%r9,8)
		movss %xmm15, 60(%rsi,%r9,8)

		movss %xmm0, 64(%rsi,%r9,8)
		movss %xmm1, 68(%rsi,%r9,8)
		movss %xmm2, 72(%rsi,%r9,8)
		movss %xmm3, 76(%rsi,%r9,8)
		movss %xmm4, 80(%rsi,%r9,8)
		movss %xmm5, 84(%rsi,%r9,8)
		movss %xmm6, 88(%rsi,%r9,8)
		movss %xmm7, 92(%rsi,%r9,8)
		movss %xmm8, 96(%rsi,%r9,8)
		movss %xmm9, 100(%rsi,%r9,8)
		movss %xmm10, 104(%rsi,%r9,8)
		movss %xmm11, 108(%rsi,%r9,8)
		movss %xmm12, 112(%rsi,%r9,8)
		movss %xmm13, 116(%rsi,%r9,8)
		movss %xmm14, 120(%rsi,%r9,8)
		movss %xmm15, 124(%rsi,%r9,8)
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
		add $128,%rsi
		sub $128, %rdi
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

