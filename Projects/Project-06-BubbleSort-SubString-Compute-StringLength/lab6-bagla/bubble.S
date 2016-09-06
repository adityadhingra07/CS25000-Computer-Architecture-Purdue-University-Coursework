.section        .data
.section        .text
.global         bubble

@ register r0 corresponds to the size of the array
@ register r1 corresponds to the array itself

bubble:
       	cmp     r0, #0				@ compare the value in register r0 i.e if the size is 0
        ble     .end				@ if size is less than equal to then we end the program
	lsl	r0, r0,#2			@ logical shift left instruction that multiplies the size with (2*2) and stores it into the register r5
        add     r5, r1, r0			@ adding the value in register r1 to the value in register r0 and storing it into register r5
        mov   	r6, #0				@ moving the value 0 in register r6

inner_loop:					@ inner loop of the two nested for loops
        cmp     r0, #1				@ comparing thre size with 1
        beq     outer_loop			@ if size equals 1, then branch to outer loop
        add     r3, r1, #4			@ increment the pointer in the array by 4 and store the current position in register r3

compare:					@ label for comparing and then swapping two integers
        ldr     r2, [r3, $-4]			@ decrementing the value in register r3, dereferencing it and then storing it into register r2 	
        ldr     r4, [r3]			@ dereferencing the value in register r3 and storing it into register r4
	add	r3, r3, $4			@ incrementing the value in register r3 by 4 and storing it back into register r3
        cmp     r2, r4				@ comparing the value in register r2 and register r4
        strgt   r4, [r3, $-8]			@ store greater than instruction: decrement the value in register r3 by 8 and store from the memory into the register r4 
        strgt   r2, [r3, $-4]			@ store greater than instruction: decrement the value in register r3 by 4 and store from the memory into the register r2
        cmp     r3, r5				@ compare the value in register r3 and in register r5
	bne     compare				@ if not equal, then again go back to compare

outer_loop:					@ outer loop of the two nested for loop
        add     r6, r6, #1			@ incrementing the value in register r6 and storing it back in register r6
        cmp     r6, r0				@ comparing the value in register r6 and in register r0
        bne     inner_loop			@ if not equal, then go to inner loop

.end:
        bx      lr
	bl 	fflush
        nop                 @no operation
        mov r7, $1          @exit syscall
        svc $0              @wake kernel
        .end
