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
	#Store r10~r13
	mov %r10, 0(%rsp)
	mov %r11, 8(%rsp)
	#Reset eax
	xorl %eax, %eax

	# Save RSI and RDI being used in main loop
	mov %rsi, %r10
	mov %rdi, %r11

.DL1:
	# Restore RSI and RDI in each repetition
	mov %r10, %rsi
	mov %r11, %rdi

	#Alignment adjustment
	add $0, %rsi

	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE

		vmovaps %ymm0, 0(%rsi)
		vmovaps %ymm1, 32(%rsi)
		vmovaps %ymm2, 64(%rsi)
		vmovaps %ymm3, 96(%rsi)
		#INSERT_INSTRUCTION_ABOVE

		add $1, %eax
		add $128, %rsi
		sub $16, %rdi
		jge .L6

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

