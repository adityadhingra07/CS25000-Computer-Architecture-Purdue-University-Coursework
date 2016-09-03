.section	.data

.section	.text
.global		fibonacci

fibonacci:	push  {r0, lr}
	bl    fib
	pop   {r0, lr}
	mov   r0, r4
	bx lr

fib:

	push {r0,lr} 	@Declaring a variable and pushing it onto the stack
	
	cmp r0, $0	@Checking condition for <= 0
	movle r4, $0
	pople	{r0,lr}
	bxle 	lr
	
	cmp r0, $1	@Checking condition for =1
	moveq r4, $1
	popeq	{r0,lr}
	bxeq 	lr
	
	cmp r0, $1
	bgt else_state

else_state:
	
	sub r0, r0, $1
	bl fib
	push	{r4}

	sub r0, r0, $1
	bl fib
	push	{r4}
	
	pop	{r2,r3}
	
	add r4, r2, r3	
	
	pop {r0, lr}
	bx lr
