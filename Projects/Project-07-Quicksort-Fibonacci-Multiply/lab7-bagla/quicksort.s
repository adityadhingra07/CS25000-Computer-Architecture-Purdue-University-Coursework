.section	.data
.section	.text
.global 	quicksort

quicksort:

	@A = r0 = holds the array
	@p = r1 = size

	push 	{r0, r1, r2, lr}

	mov 	r2, r1 			@ moving size in r1 to to r2
	sub	r2,r2,$1 		@ r2 points to the last element
	mov	r1, $0			@ r1 points to the first element
	bl 	quick
					@A = r0 = holds the array
					@p = r1 = points to the first element
					@r = r2 = points to the last element
	pop	{r0-r2, lr}
	bx	lr
	
quick:	
	push	{r0, r1, r2, lr}
	cmp	r1, r2			@ if p>=r 
	
	popge	{r0, r1, r2, lr}	@ then pop
	bxge	lr			@ and return
	
	bllt	partition		@ if p < r then call partition

	cmp 	r1, r2
	
	@popge	{r0, r1, r2, lr}
	@bxge	lr
	
	pop	{r0, r1, r2, lr}	@ pop
	
	push	{r0, r1, r2, r3, lr}	@ push
	sub	r2, r3, $1		@ r3 = q -1 ==> r2
	bl	quick			@ call quick

	pop	{r0, r1, r2, r3, lr}	@ pop
	
	push	{r0, r1, r2, r3, lr}	@ push
	add	r1, r3, $1		@ r3 = q + 1 ==> r1
	bl	quick			@ call quick
	
	pop	{r0, r1, r2, r3, lr}	@ pop
	bx	lr			@ branch lr

partition:
	
	push	{lr}			
	mov	r4, r0			@ put the address of array into r4
	lsl	r3, r2, $2		@ multiplying r2 4 times and store in r3
	add	r4, r4, r3		@ moving r4 to the last element
	ldr	r8, [r4]		@ dereferencing and loading the value in r8  ==> x = A[r] & r4 holds the address
	sub	r5, r1, $1		@ decrementing r5 by 1 ==> i = p - 1

loop:

	cmp 	r1, r2			@ loop condition
	bge 	out_loop		@ if greater than branch to outerloop
	blt	in_loop			@ else inside the loop
				
	
in_loop:

	lsl	r6, r1, $2		@ multiplying r1 2 times and store it in r6
	add 	r6, r0, r6		@ moving r6 to the jth element
	ldr	r9, [r6]		@ dereferencing the value in r9 ==> A[j] & r6 holds the address
	
	cmp	r9, r8


	addle	r5, r5, $1		@ if <= then i = i + 1 

	lslle	r3, r5, $2		
	addle	r3, r0, r3
	ldrle	r10, [r3]		@ dereferencing the value in r10 ==> A[i] & r3 holds the address

	strle 	r9, [r3]		@ swap A[i] and A[j]
	strle 	r10,[r6]
	
	add	r1, r1, $1		@increment j(=p)		
	
	b 	loop

out_loop:

	add	r5, r5, $1		@ check : i + 1 this updates i
	
	mov 	r3, r5			@ r3 = i+1

	lsl	r5, r5, $2		
	add	r5, r0, r5
	ldr	r7, [r5]		@ r7 ==> A[i+1] & r5 hold holds the address
			
	str 	r8, [r5]		@ swap A[i+1] with A[r]
	str	r7, [r4]
	
	pop	{lr}
	bx 	lr


