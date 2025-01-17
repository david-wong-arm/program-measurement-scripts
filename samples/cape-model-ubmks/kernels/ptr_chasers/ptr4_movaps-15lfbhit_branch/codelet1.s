# Using David Wong's 'in codelet' repetitions

.file	"codelet.s"
.section .data
	.p2align 4,,15
	data:
		.ascii "Mary had a little lamb"
.text
.p2align 4,,15

.globl scale1_
	.type	scale1_, @function


scale1_:
.LFB22:
	.cfi_startproc
	pushq   %rbp
	movq    %rsp, %rbp
# this function is called like: nb_iters = scale1_ (n, tab, tab+n, tab+2*n, tab+3*n, tab+4*n , repetitions);
# %edi = n          (not using full register)
# %rsi = alignedMem (begin of chain 1)
# %edx = repetitions
# %rcx = alignedMem1 (begin of chain 2)	
# %r8 = alignedMem1 (begin of chain 3)
# %r9 = alignedMem1 (begin of chain 4)
	
	sub $32, %rsp
	#Store r12~r13 ..r10 and r11 are caller save 
	# should be able to use r10-11
	mov %r12, 0(%rsp)
	mov %r13, 8(%rsp)

	# Load repetitions into r11
	xor %rax, %rax
	movl %edx, %eax
	mov %rax, %r11

	# Save starting pointer address in %r13 to be retored in each rep iteration
	mov %rsi, %r13


	# Compute n/8 in %r12 - used %rdx
	mov %rdx, %r10 # Save RDX first
	xor %rdx, %rdx
	mov %rdi, %rax
	mov $16, %r12
	div %r12 
	mov %rax, %r12
	mov %r10, %rdx  # Restore RDX


	#Reset rax - to be used as return value
	xor %rax, %rax
 
.DL1:
	# zero out R10 in each repetition (induction variable)
	xor %r10, %r10
	# restore starting pointer
#	mov %r13, %rsi  

	#Alignment adjustment. Not done here (should have done in driver)

	#INSERT_SOMETHING_BEFORE_THE_LOOP

	.p2align 4,,10
	.p2align 3

	.L6:
		#INSERT_SWP_PREFETCH_ABOVE
#		lfence
#		lfence
#		lfence
#		lfence

#		Pointer trace below
		movaps          (%rsi), %xmm0
#		These 15 loads should hit LFB	
		movaps		(%rsi), %xmm4
		movaps		(%rsi), %xmm5
		movaps		(%rsi), %xmm6
		movaps		(%rsi), %xmm7
		movaps		(%rsi), %xmm8
		movaps		(%rsi), %xmm9
		movaps		(%rsi), %xmm10
		movaps		(%rsi), %xmm11
		movaps		(%rsi), %xmm12
		movaps		(%rsi), %xmm13
		movaps		(%rsi), %xmm14
		movaps		(%rsi), %xmm15
		movaps		(%rsi), %xmm4
		movaps		(%rsi), %xmm5
		movaps		(%rsi), %xmm6
	
	
	
		movq		%xmm0, %rsi
	
		movaps		(%rcx), %xmm1
#		These 15 loads should hit LFB	
		movaps		(%rcx), %xmm4
		movaps		(%rcx), %xmm5
		movaps		(%rcx), %xmm6
		movaps		(%rcx), %xmm7
		movaps		(%rcx), %xmm8
		movaps		(%rcx), %xmm9
		movaps		(%rcx), %xmm10
		movaps		(%rcx), %xmm11
		movaps		(%rcx), %xmm12
		movaps		(%rcx), %xmm13
		movaps		(%rcx), %xmm14
		movaps		(%rcx), %xmm15
		movaps		(%rcx), %xmm4
		movaps		(%rcx), %xmm5
		movaps		(%rcx), %xmm6
	
	
		movq		%xmm1, %rcx

		movaps		(%r8), %xmm2
#		These 15 loads should hit LFB	
		movaps		(%r8), %xmm4
		movaps		(%r8), %xmm5
		movaps		(%r8), %xmm6
		movaps		(%r8), %xmm7
		movaps		(%r8), %xmm8
		movaps		(%r8), %xmm9
		movaps		(%r8), %xmm10
		movaps		(%r8), %xmm11
		movaps		(%r8), %xmm12
		movaps		(%r8), %xmm13
		movaps		(%r8), %xmm14
		movaps		(%r8), %xmm15
		movaps		(%r8), %xmm4
		movaps		(%r8), %xmm5
		movaps		(%r8), %xmm6
	
	
		movq		%xmm2, %r8
	
		movaps		(%r9), %xmm3
#		These 15 loads should hit LFB	
		movaps		(%r9), %xmm4
		movaps		(%r9), %xmm5
		movaps		(%r9), %xmm6
		movaps		(%r9), %xmm7
		movaps		(%r9), %xmm8
		movaps		(%r9), %xmm9
		movaps		(%r9), %xmm10
		movaps		(%r9), %xmm11
		movaps		(%r9), %xmm12
		movaps		(%r9), %xmm13
		movaps		(%r9), %xmm14
		movaps		(%r9), %xmm15
		movaps		(%r9), %xmm4
		movaps		(%r9), %xmm5
		movaps		(%r9), %xmm6
	
	
		movq		%xmm3, %r9
	
#    testing...write 8080 to last data (among with every 4th item)

#		movl		$8088, 8(%rsi)
	

#		movaps          (%rsi,%r10,8), %xmm0
#               movaps          64(%rsi,%r10,8), %xmm1
#               movaps          128(%rsi,%r10,8), %xmm1
#               movaps          192(%rsi,%r10,8), %xmm1

		#INSERT_INSTRUCTION_ABOVE
#		add $1, %rax
		add     	$1,%r10
		cmp     	%rdi,%r10
		jb     	.L6

	# add n to eax
	add %rdi, %rax

	sub $1, %r11
	testq %r11, %r11
	jne .DL1

.L3:
	mov 0(%rsp), %r12
	mov 8(%rsp), %r13
#	add $32, %rsp

	leave
	ret
	.cfi_endproc

.LFE22:
	.size	scale1_, .-scale1_
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

