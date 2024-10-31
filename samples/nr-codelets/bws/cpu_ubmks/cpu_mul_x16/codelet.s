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
	# Save RDI being used in main loop
	mov %rdi, %rcx
	mov %rdx, %rbx

.DL1:
	# Restore RSI and RDI in each repetition
	mov %r10, %rsi
	mov %rcx, %rdi

	#Alignment adjustment
#	add $8, %rsi

	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE

		imul %r8, %r8
		imul %r9, %r9
		imul %r10, %r10
		imul %r11, %r11
		imul %r12, %r12
		imul %r12, %r13
		imul %r14, %r14
		imul %r15, %r15

		imul %r8, %r8
		imul %r9, %r9
		imul %r10, %r10
		imul %r11, %r11
		imul %r12, %r12
		imul %r12, %r13
		imul %r14, %r14
		imul %r15, %r15
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
		add $128, %rsi
		sub $128, %rdi
		jg  .L6
	# add n/$8 to eax
	add %rcx, %rax

	sub $1, %rbx
	testq %rbx, %rbx
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

