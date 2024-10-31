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

		vmulpd %zmm0, %zmm0, %zmm1
		vmulpd %zmm1, %zmm1, %zmm2
		vmulpd %zmm2, %zmm2, %zmm3
		vmulpd %zmm3, %zmm3, %zmm12
		vmulpd %zmm4, %zmm4, %zmm5
		vmulpd %zmm5, %zmm5, %zmm6
		vmulpd %zmm6, %zmm6, %zmm7
		vmulpd %zmm7, %zmm7, %zmm8
		vmulpd %zmm8, %zmm8, %zmm9
		vmulpd %zmm9, %zmm9, %zmm10
		vmulpd %zmm10, %zmm10, %zmm11
		vmulpd %zmm11, %zmm11, %zmm12
		vmulpd %zmm12, %zmm12, %zmm4
		vmulpd %zmm13, %zmm13, %zmm14
		vmulpd %zmm14, %zmm14, %zmm15
		vmulpd %zmm15, %zmm15, %zmm0
		#INSERT_INSTRUCTION_ABOVE

#		add $1, %rax
#		add $512, %rsi
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

