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
	pushq   %rbp
	movq    %rsp, %rbp
# this function is called like: nb_iters = scale_ (n, tab, tab+n, tab+2*n, tab+3*n, tab+4*n , repetitions);
# %edi = n          (not using full register)
# %rsi = alignedMem (begin of chain 1)
# %edx = repetitions
# %rcx = alignedMem1 (begin of chain 2)

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
	#Reset r9 - to be used as real offset value
	xor %r9, %r9

	.L6:
	
		#INSERT_SWP_PREFETCH_ABOVE
#		lfence
#		lfence
#		lfence
#		lfence

	
#		Pointer trace below
		movsd          (%rsi,%r9,1), %xmm0
#		These 15 loads should hit LFB	
		movsd		(%rsi,%r9,1), %xmm3
		movsd		(%rsi,%r9,1), %xmm4
		movsd		(%rsi,%r9,1), %xmm5
		movsd		(%rsi,%r9,1), %xmm6
		movsd		(%rsi,%r9,1), %xmm7
		movsd		(%rsi, %r9,1), %xmm8
		movsd		(%rsi, %r9,1), %xmm9
		movsd		(%rsi, %r9,1), %xmm10
		movsd		(%rsi, %r9,1), %xmm11
		movsd		(%rsi, %r9,1), %xmm12
		movsd		(%rsi, %r9,1), %xmm13
		movsd		(%rsi, %r9,1), %xmm14
		movsd		(%rsi, %r9,1), %xmm15
		movsd		(%rsi, %r9,1), %xmm3
		movsd		(%rsi, %r9,1), %xmm4

		movq		%xmm0, %rsi
	
		movsd		(%rcx, %r9,1), %xmm1
#		These 15 loads should hit LFB	
		movsd		(%rcx, %r9,1), %xmm3
		movsd		(%rcx, %r9,1), %xmm4
		movsd		(%rcx, %r9,1), %xmm5
		movsd		(%rcx, %r9,1), %xmm6
		movsd		(%rcx, %r9,1), %xmm7
		movsd		(%rcx, %r9,1), %xmm8
		movsd		(%rcx, %r9,1), %xmm9
		movsd		(%rcx, %r9,1), %xmm10
		movsd		(%rcx, %r9,1), %xmm11
		movsd		(%rcx, %r9,1), %xmm12
		movsd		(%rcx, %r9,1), %xmm13
		movsd		(%rcx, %r9,1), %xmm14
		movsd		(%rcx, %r9,1), %xmm15
		movsd		(%rcx, %r9,1), %xmm3
		movsd		(%rcx, %r9,1), %xmm4

	
		movq		%xmm1, %rcx

	
	
#    testing...write 8080 to last data (among with every 4th item)

#		movl		$8088, 8(%rsi)
	

#		movaps          (%rsi,%r10,8), %xmm0
#               movaps          64(%rsi,%r10,8), %xmm1
#               movaps          128(%rsi,%r10,8), %xmm1
#               movaps          192(%rsi,%r10,8), %xmm1

		#INSERT_INSTRUCTION_ABOVE
#		add $1, %rax
#		add     	$64,%r9
#		add     	$192,%r9	
		add     	$2,%r10
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
	.size	scale_, .-scale_

	.align 16
.L_2il0floatpacket.0:
        .long   0x7fffffff,0x00000000,0x00000000,0x00000000
        .type   .L_2il0floatpacket.0,@object
        .size   .L_2il0floatpacket.0,16
	
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

