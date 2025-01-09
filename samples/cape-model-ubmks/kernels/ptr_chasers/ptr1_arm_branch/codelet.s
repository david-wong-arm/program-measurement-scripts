	.arch armv8-a
	.file	"codelet.s"
	.text
	.align	2
	.p2align 4,,11
	.global	scale_
	.type	scale_, %function
# This function is like below
# unsigned long long scale(unsigned long long inner_rep, struct item* lst, unsigned int repetition) 
scale_:
.LFB16:
	.cfi_startproc
	# Loading first arg (inner_rep) to x4, freeing up x0 for counting and return
	mov	x4, x0
	# Loading second arg (lst) to x5 for pointer chasing
	mov	x5, x1
	# zeroing loop counter
	mov	x0, 0
	# w2 already contains repetition 
	cbz	w2, .L3
	# Check inner_rep being zero and quit
	cbz	x4, .L3
	# w1 will be used as counter for repetition level
	mov	w1, 0
	.p2align 3,,7
.L5:
	# x3 is counter for inner_rep
	mov	x3, 0
	.p2align 3,,7
.L4:
	add	x3, x3, 1
	# x5 contains lst and lst = *lst 
	ldr	x5, [x5]  
	# x4 is inner_rep
	cmp	x4, x3
	bne	.L4
	# add x4 (inner_rep) to counter to return
	add	x0, x0, x4
	add	w1, w1, 1
	cmp	w2, w1
	bne	.L5
.L3:
	# iteration counts in x0
	ret
	.cfi_endproc
.LFE16:
	.size	scale_, .-scale_
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
