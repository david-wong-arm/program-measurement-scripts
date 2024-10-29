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
	sub $40, %rsp
	#Store r10~r13
	mov %r10, 0(%rsp)
	mov %r11, 8(%rsp)
	mov %r12, 16(%rsp)
	mov %r13, 24(%rsp)
	#Reset eax
	xorl %eax, %eax

	# Save RSI and RDI being used in main loop
	mov %rsi, %r10
	mov %rdi, %r11

	mov %rdi, %r12
	shl $2, %r12
	add %rsi, %r12

	mov %r12, %r13

.DL1:
	# Restore RSI and RDI in each repetition
	mov %r10, %rsi
	mov %r11, %rdi
	mov %r13, %r12

	#Alignment adjustment
	add $0, %rsi

	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE

		movups %xmm0, 0(%rsi)
		movups %xmm0, 0(%r12)
		movups %xmm1, 16(%rsi)
		movups %xmm1, 16(%r12)
		movups %xmm2, 32(%rsi)
		movups %xmm2, 32(%r12)
		movups %xmm3, 48(%rsi)
		movups %xmm3, 48(%r12)
		#INSERT_INSTRUCTION_ABOVE

		add $1, %eax
		add $64, %rsi
		add $64, %r12
		sub $16, %rdi
		jge .L6

	sub $1, %rdx
	testq %rdx, %rdx
	jne .DL1

.L3:
	mov 0(%rsp), %r10
	mov 8(%rsp), %r11
	mov 16(%rsp), %r12
	mov 24(%rsp), %r13
	add $40, %rsp

	ret
	.cfi_endproc

.LFE22:
	.size	scale_, .-scale_
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

