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

		movaps 0(%rsi,%r9,8), %xmm0
		movaps 16(%rsi,%r9,8), %xmm1
		movaps 32(%rsi,%r9,8), %xmm2
		movaps 48(%rsi,%r9,8), %xmm3
		movaps 64(%rsi,%r9,8), %xmm4
		movaps 80(%rsi,%r9,8), %xmm5
		movaps 96(%rsi,%r9,8), %xmm6
		movaps 112(%rsi,%r9,8), %xmm7
		movaps 128(%rsi,%r9,8), %xmm8
		movaps 144(%rsi,%r9,8), %xmm9
		movaps 160(%rsi,%r9,8), %xmm10
		movaps 176(%rsi,%r9,8), %xmm11
		movaps 192(%rsi,%r9,8), %xmm12
		movaps 208(%rsi,%r9,8), %xmm13
		movaps 224(%rsi,%r9,8), %xmm14
		movaps 240(%rsi,%r9,8), %xmm15

		movaps 256(%rsi,%r9,8), %xmm0
		movaps 272(%rsi,%r9,8), %xmm1
		movaps 288(%rsi,%r9,8), %xmm2
		movaps 304(%rsi,%r9,8), %xmm3
		movaps 320(%rsi,%r9,8), %xmm4
		movaps 336(%rsi,%r9,8), %xmm5
		movaps 352(%rsi,%r9,8), %xmm6
		movaps 368(%rsi,%r9,8), %xmm7
		movaps 384(%rsi,%r9,8), %xmm8
		movaps 400(%rsi,%r9,8), %xmm9
		movaps 416(%rsi,%r9,8), %xmm10
		movaps 432(%rsi,%r9,8), %xmm11
		movaps 448(%rsi,%r9,8), %xmm12
		movaps 464(%rsi,%r9,8), %xmm13
		movaps 480(%rsi,%r9,8), %xmm14
		movaps 496(%rsi,%r9,8), %xmm15
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
		add $512, %rsi
		sub $512, %rdi
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

