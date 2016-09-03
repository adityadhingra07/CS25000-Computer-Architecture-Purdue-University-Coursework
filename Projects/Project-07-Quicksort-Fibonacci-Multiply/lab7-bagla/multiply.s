.section	.data

.section	.text
.global		multiply

multiply:	push	{lr}
		
		cmp 	r0, $0			@ADDING FOR NEGATIVE CASE
		addlt	r4, r4, $1
		cmp 	r1, $0
		addlt	r4, r4, $1
		cmp	r4, $2
		negeq	r0, r0
		negeq	r1, r1

		

		bl	mul
		
		mov	r0, r3
		pop	{lr}
		bx lr
		

mul:
	
	@ n = r0
	@ m = r1
	@ return register = r3
	
	push {lr} @pushing m
	
	cmp 	r1,$0
	moveq 	r3, $0
	popeq 	{lr}
	bxeq 	lr	
	
	cmp 	r1, $0
	bgt	program

program:
		
	sub	r1, r1, $1
	bl	mul
	push	{r3}
	
	pop 	{r2}
	add 	r3, r0, r2
	
	pop	{lr}
	bx 	lr 	
		
	@mov r0, r3
	@bx lr
