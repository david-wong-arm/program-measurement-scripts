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

		mulss %xmm0, %xmm0
		mulss %xmm1, %xmm1
		mulss %xmm2, %xmm2
		mulss %xmm3, %xmm3
		mulss %xmm4, %xmm4
		mulss %xmm5, %xmm5
		mulss %xmm6, %xmm6
		mulss %xmm7, %xmm7
		mulss %xmm8, %xmm8
		mulss %xmm9, %xmm9
		mulss %xmm10, %xmm10
		mulss %xmm11, %xmm11
		mulss %xmm12, %xmm12
		mulss %xmm13, %xmm13
		mulss %xmm14, %xmm14
		mulss %xmm15, %xmm15
		andss %xmm0, %xmm0
		andss %xmm1, %xmm1
		andss %xmm2, %xmm2
		andss %xmm3, %xmm3
		andss %xmm4, %xmm4
		andss %xmm5, %xmm5
		andss %xmm6, %xmm6
		andss %xmm7, %xmm7
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $1, %rsi
		sub $1, %rdi
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

