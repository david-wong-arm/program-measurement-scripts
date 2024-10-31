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

	movupd 0(%rsi), %xmm0
	movapd %xmm0, %xmm1
	movapd %xmm0, %xmm2
	movapd %xmm0, %xmm3
	movapd %xmm0, %xmm4
	movapd %xmm0, %xmm5
	movapd %xmm0, %xmm6
	movapd %xmm0, %xmm7
	movapd %xmm0, %xmm8
	movapd %xmm0, %xmm9
	movapd %xmm0, %xmm10
	movapd %xmm0, %xmm11
	movapd %xmm0, %xmm12
	movapd %xmm0, %xmm13
	movapd %xmm0, %xmm14
	movapd %xmm0, %xmm15

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

		divpd %xmm0, %xmm1
		divpd %xmm1, %xmm2
		divpd %xmm2, %xmm3
		divpd %xmm3, %xmm4
		divpd %xmm4, %xmm5
		divpd %xmm5, %xmm6
		divpd %xmm6, %xmm7
		divpd %xmm7, %xmm8
		divpd %xmm8, %xmm9
		divpd %xmm9, %xmm10
		divpd %xmm10, %xmm11
		divpd %xmm11, %xmm12
		divpd %xmm12, %xmm13
		divpd %xmm13, %xmm14
		divpd %xmm14, %xmm15
		divpd %xmm15, %xmm0
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

