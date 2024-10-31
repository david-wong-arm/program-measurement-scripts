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

		movaps %xmm0, 0(%rsi,%r9,8)
		movaps %xmm1, 16(%rsi,%r9,8)
		movaps %xmm2, 32(%rsi,%r9,8)
		movaps %xmm3, 48(%rsi,%r9,8)
		movaps %xmm4, 64(%rsi,%r9,8)
		movaps %xmm5, 80(%rsi,%r9,8)
		movaps %xmm6, 96(%rsi,%r9,8)
		movaps %xmm7, 112(%rsi,%r9,8)
		movaps %xmm8, 128(%rsi,%r9,8)
		movaps %xmm9, 144(%rsi,%r9,8)
		movaps %xmm10, 160(%rsi,%r9,8)
		movaps %xmm11, 176(%rsi,%r9,8)
		movaps %xmm12, 192(%rsi,%r9,8)
		movaps %xmm13, 208(%rsi,%r9,8)
		movaps %xmm14, 224(%rsi,%r9,8)
		movaps %xmm15, 240(%rsi,%r9,8)

		movaps %xmm0, 256(%rsi,%r9,8)
		movaps %xmm1, 272(%rsi,%r9,8)
		movaps %xmm2, 288(%rsi,%r9,8)
		movaps %xmm3, 304(%rsi,%r9,8)
		movaps %xmm4, 320(%rsi,%r9,8)
		movaps %xmm5, 336(%rsi,%r9,8)
		movaps %xmm6, 352(%rsi,%r9,8)
		movaps %xmm7, 368(%rsi,%r9,8)
		movaps %xmm8, 384(%rsi,%r9,8)
		movaps %xmm9, 400(%rsi,%r9,8)
		movaps %xmm10, 416(%rsi,%r9,8)
		movaps %xmm11, 432(%rsi,%r9,8)
		movaps %xmm12, 448(%rsi,%r9,8)
		movaps %xmm13, 464(%rsi,%r9,8)
		movaps %xmm14, 480(%rsi,%r9,8)
		movaps %xmm15, 496(%rsi,%r9,8)
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
		add $512,%rsi
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

