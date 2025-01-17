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
	sub $72, %rsp
	#Store r10~r13
	mov %r10, 0(%rsp)
	mov %r11, 8(%rsp)
	mov %r12, 16(%rsp)
	mov %r13, 24(%rsp)
	mov %r14, 32(%rsp)
	mov %r15, 40(%rsp)
	mov %r8, 48(%rsp)
	mov %r9, 56(%rsp)
	#Reset eax
	xorl %eax, %eax

	# Save RSI and RDI being used in main loop
	mov %rsi, %r10
	mov %rdi, %r11

	mov %rdi, %r12
	shl $2, %r12
	mov %r12, %r8	# r8 = (8n / 2)
	add %rsi, %r12

	mov %rdi, %r14
	shl $1, %r14
	add %r14, %r8	# r8 = (8n / 2) + (8n / 4) = (12n / 2)
	add %rsi, %r14

	add %rsi, %r8	# r8 = tab + 12n / 2

	mov %r12, %r13
	mov %r14, %r15
	mov %r8, %r9
.DL1:
	# Restore RSI and RDI in each repetition
	mov %r10, %rsi
	mov %r11, %rdi
	mov %r13, %r12
	mov %r15, %r14
	mov %r9, %r8

	#Alignment adjustment
	add $0, %rsi
	add $0, %r12
	add $0, %r14
	add $0, %r8


	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE

		movsd 0(%rsi), %xmm0
		movsd 0(%r12), %xmm0
		movsd 0(%r14), %xmm0
		movsd 0(%r8), %xmm0
		movsd 8(%rsi), %xmm1
		movsd 8(%r12), %xmm1
		movsd 8(%r14), %xmm1
		movsd 8(%r8), %xmm1
		movsd 16(%rsi), %xmm2
		movsd 16(%r12), %xmm2
		movsd 16(%r14), %xmm2
		movsd 16(%r8), %xmm2
		movsd 24(%rsi), %xmm3
		movsd 24(%r12), %xmm3
		movsd 24(%r14), %xmm3
		movsd 24(%r8), %xmm3

		movsd data(%rip), %xmm4								
		movsd data(%rip), %xmm5								
		movsd data(%rip), %xmm6								
		movsd data(%rip), %xmm7
		#INSERT_INSTRUCTION_ABOVE

		add $1, %eax
		add $32, %rsi
		add $32, %r12
		add $32, %r14
		add $32, %r8
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
	mov 32(%rsp), %r14
	mov 40(%rsp), %r15
	mov 48(%rsp), %r8
	mov 56(%rsp), %r9
	add $72, %rsp

	ret
	.cfi_endproc

.LFE22:
	.size	scale_, .-scale_
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

