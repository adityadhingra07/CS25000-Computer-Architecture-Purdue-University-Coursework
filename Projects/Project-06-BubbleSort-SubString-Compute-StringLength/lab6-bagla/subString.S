.global 	subString

@ the register r0 points to the address of the 'source'
@ the register r1 points to the address of the 'substring' to be found

subString:
     
        mov     r7, r1 		@ Moving the value in register r1 to register r7 i.e, register r7 is pointing to the address of the 'substring'
        ldr    r3, [r0]    	@ Dereferencing the value in register r0 and loading it into r3, r3 points to the 'source' string 
        cmp     r3, #0		@ Comparing the value in r3 with null character
        beq     end		@ if equal, 'source' string does not exist and branch to end and exit

inner_loop1:

        ldrb    r4, [r1]   	@ Dereferencing the value in register r1 and loading it into r4, register r4 is now pointing to the address of 'substring'
        add    r2, r0, #1	@ incrementing the 'source' string and storing the value in r2. Register r2 points to the current position in 'source' string
        cmp     r3, r4		@ comparing the value in register r3 and register r4
        beq     inner_loop2a	@ if equal, the branch to inner_loop2a

inner_loop1a:

        mov     r5, r2		@ move the current value of register r2 into register r5
        ldrb    r3, [r2]   	@ Dereferencing the value in r2 and loading in register r3 the current position pointed by r2
	add	r2, r2, #1	@ incrementing the value of register r2 by 1 and storing it back in register r1  
        cmp     r3, r4		@ comparing value of register r3 (pointing to source string) with value in register r4 (pointing to substring)
        beq     condition_1	@ if equal, then branch to condition_1
        cmp     r3, #0		@ comparing the value in register r3 (pointing to source string) to 0 (null character)
        bne     inner_loop1a	@ if equal, branch to inner_loop1a

end:
     
	mov 	r0, r3		@ move the value of r3 (pointing to the source string) to the register r0
        bx      lr		@ exit the program

condition_1:

        cmp     r4, #0		@ comparing the value in register r4 with null character  	
        beq     check_2		@ if equal, then branch to check_2

inner_loop2: 

        ldrb    r6, [r7]   	@ dereferencing the value in register r7 and loading it into register r6
        ldrb    r3, [r5]    	@ dereferencing the value in register r5 and loading it into register r3
        mov     r2, r6		@ moving the value in register r6 to register r2
        cmp     r3, r6		@ comparing the value in register r3 and register r6 
        beq     inner_loop2b	@ if equal, then branch to inner_loop2b

condition_2:

        cmp     r2, #0		@ compare the value in register r2 with 0 (null terminator)
        beq     back_cond3	@ if equal, then branch to back_cond3
        mov     r7, r1		@ move the value in register r1 to register r7

condition_3:

	cmp 	r4, #0		@ compare the value in register r4 with 0 (null terminator)
	beq	check_1		@ if equal, then branch to check_1
      
condition_4:

        cmp     r3, #0		@ compare the value in register r3 with 0 (null terminator)
        beq     end		@ if equal then branch to end

main_loop:

        ldrb    r3, [r0]    	@ dereference the value in register r0 and load into r3
        cmp     r3, #0		@ compare the value in register r3 to 0 (null terminator
        bne     inner_loop1	@ if not equal, then branch to inner_loop1	

inner_loop2a:
 
        mov     r5, r0		@ move the value of register r0 in the register r5
        ldr    r6, [r7]   	@ Dereference the value in register r7 and load it into register r6 
        ldr    r3, [r5]    	@ Dereference the value in register r5 and load it into register r3
        mov     r2, r6		@ move the value in register r6 to r2
        cmp     r3, r6		@ compare the value in register r6 to r3
        it      ne		@ conditional statement: if then not equal
        movne   r0, r5		@ if not equal to,then move the value in register r5 to register r0
        bne     condition_2	@ if not equal to then branch to condition_2

inner_loop2b:

        mov     r0, r5		@ move the value in register r5 to register r0
	cmp	r3,$0		@ compare the value in register r3 to 0 (null terminator)
	beq	check		@ if equal, then branch to check
    
        add     r12, r5, #1	@ increment the value in register r5 and store it in register r12
        add    r6, r7, #1	@ increment the value in register r7 and store it in register r6

inner_loop2c:

        mov     r0, r12		@ move the value in register r5 to register r0
        mov     r7, r6		@ move the value in register r5 to register r0
        add    r6, r6, #1	@ increment the value in register r6 by 1 and store it back in register r6
        add     r12, r12, #1	@ increment the value in register r12 by 1 and store it back in register r12
        ldrb    r3, [r0]    	@ dereference the value of r0 and store it in register r3
        ldrb    r2, [r7]    	@ dereference the value of r7 and store it in register r2
        cmp     r3, r2		@ compare the value in register r3 to r2
        bne     condition_2	@ if ne branch to condition_2
        cmp     r3, #0		@ compare the value in register r3 to 0
        bne     inner_loop2c	@ if not equal, then branch to inner_loop2c
        mov     r6, r3		@ move the value in register r5 to register r0

check:
        mov     r4, r6		@ move the value in register r4 to register r6
        mov    r3, #0		@ move the value 0 in register r3 
        cmp     r4, #0		@ compare the value in register r4 to 0
        bne     condition_4	@ if not equal, then branch to condition_4

check_1:
        mov     r3, r5 		@ move the value in register r5 to register r3
        b       end		@ always execute  and branch to end

back_cond3:
        ldrb    r4, [r7]    	@ dereferencing the value in register r7 and loading it in to register r3
        b       condition_3	@ always execute branch to condition_3

check_2:
        mov     r3, r4		@ move the in register r4 to register r3
        b       end		@ always execute branch to end

	
	mov %r0, $0		@ moving the value 0 in register r0
	mov %r1, $0		@ moving the value 0 in register r1
	bl fflush		@ branch link instruction to stdout
	
	mov r7, $1          @exit syscall
	swi $0              @wake kernel
	.end

