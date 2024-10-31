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
# %r8 = alignedMem1 (begin of chain 3)
# %r9 = alignedMem1 (begin of chain 4)

# Starting from chain 5, pointer will be passed by global variable glo_p*
# Some register book keeping info: (regarding usage in main loop)
# %rax <- return number of iterations at the end
# %rbx (saved below and restored at the end) <- chain 6
# %rcx <- chain 2
# %rdx (will overwrite) <- chain 7
# %rsi <- chain 1
# %rdi <- inner iteration loop bound check (UB)
# %rbp <- saved last stack pointer (saved below and restored at the end) <- chain 5
# %rsp <- stack pointer
# %r8  <- chain 3
# %r9  <- chain 4
# %r10 <- inner iteration loop bound check (loop var)
# %r11 <- outer iteration loop bound check
# %r12 (saved below and restored at the end) <- chain 8
# %r13
# %r14
# %r15
	
#	sub $32, %rsp
	sub $48, %rsp
	#Store r12~r13 ..r10 and r11 are caller save 
	# should be able to use r10-11
	mov %r12, 0(%rsp)
	mov %r13, 8(%rsp)
	mov %rbp, 16(%rsp)
	mov %rbx, 24(%rsp)

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


	# load the pointer streams passed as global variables
	movq	glo_p5(%rip), %rbp
	movq	glo_p6(%rip), %rbx
	movq	glo_p7(%rip), %rdx
	movq	glo_p8(%rip), %r12

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
		 vmovaps            (%rsi), %ymm0 
		 vmovq		%xmm0, %rsi
	
		 vmovaps 		 (%rcx), %ymm1 
		 vmovq		%xmm1, %rcx

		 vmovaps 		 (%r8), %ymm2 
		 vmovq		%xmm2, %r8
	
		 vmovaps 		 (%r9), %ymm3 
		 vmovq		%xmm3, %r9
		
		 vmovaps 		 (%rbp), %ymm4 
		 vmovq		%xmm4, %rbp	
	
		 vmovaps 		 (%rbx), %ymm5 
		 vmovq		%xmm5, %rbx	
	
		 vmovaps 		 (%rdx), %ymm6 
		 vmovq		%xmm6, %rdx	
	
		 vmovaps 		 (%r12), %ymm7 
		 vmovq		%xmm7, %r12	
	
#    testing...write 8080 to last data (among with every 4th item)

#		movl		$8088, 8(%rsi)
	

#		 vmovaps            (%rsi,%r10,8), %ymm0 
#                vmovaps           64 (%rsi,%r10,8), %ymm1 
#                vmovaps           128 (%rsi,%r10,8), %ymm1 
#                vmovaps           192 (%rsi,%r10,8), %ymm1 

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
	mov 16(%rsp), %rbp
	mov 24(%rsp), %rbx
#	add $48, %rsp

	leave
	ret
	.cfi_endproc

.LFE22:
	.size	scale_, .-scale_
	.comm	glo_p5,8,8	
	.comm	glo_p6,8,8	
	.comm	glo_p7,8,8	
	.comm	glo_p8,8,8	
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

