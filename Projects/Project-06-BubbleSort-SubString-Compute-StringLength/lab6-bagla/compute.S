.section        .data

resultMessage: .asciz "Returned answer:%d\n" 		@ Declaring the result message
invalidMessage: .asciz "Invalid input\n"		@ Declaring the message displayed if the input in invalid

format: .asciz "%s"					@ Declaring the format for taking the input as an integer
	
formatOp: .asciz "%s"					@ Decalring the format for taking the input for the operation to be performed			

@return: .word 0

printFormat: .asciz "%d"				@ Declaring the format for the result to be displayed

messageFirst: .asciz "Enter the first number:"		@ Display message for entering the first number
messageOp:    .asciz "Enter the operator:"		@ Display message for entering the operator
messageSecond: .asciz "Enter the second number:"	@ Display message for entering the second number

formatNum: .asciz "%d"					@ Declaring the format of the integers to be scanned

num1: .word 0						@ Allocating space for the first integer input
num2: .word 0						@ Allocating space for the second integer input
op:   .word 0						@ Allocating space for the operator input
@.lcomm op, 128

.section        .text
addition: 						@ Addition label
	add r1, r0, r1					@ Adding the value stored in register r0 and r1 and storing it into the register r1
	
	ldr r0, =resultMessage				@ Loading the format of the result message in register r0
	bl printf					@ calling the printf function to display the output
	
	 @nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
        @.end


subtraction:						@ Subtraction label
	sub r1, r0, r1					@ Subtracting the value stored in register r1 from the value stored in register r0 and storing it into register r1		
	
	ldr r0, =resultMessage				@ Loading the format of the result message in register r0
	bl printf					@ calling the printf function to display the output

	 @nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
        @.end


multiplication: 					@ Multiplication label
	mul r1, r0, r1					@ Multiplying the values stored in register r0 and register r1 and storing it into r1
	
	ldr r0, =resultMessage				@ Loading the format of the result message in register r0
	bl printf					@ calling the printf function to display the output

	 @nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
        @.end

	 
division: 						@ Division label
	mov r2, r1					@ Moving the value of the second input number from register r1 to register r2 - DENOMINATOR
	mov r1, r0					@ Moving the value of the first input number from register r0 to register r1 - NUMERATOR
		
        cmp r1, $0					@ Comparing the value of the first input integer - numerator with 0
	blt signed					@ if less than 0, then branch to the signed label
        
	cmp r2, $0					@ Comparing the value of the second input integer - denominator with 0
	beq invalid					@ if equal to  0, then branch to the invalid label

	@cmp r1, $0
	@blt signed
	
	bgt unsigned					@ else if greater than, then branch to unsigned
	
invalid:						@ invalid label
	@mov r1, $0
	ldr r0, =invalidMessage				@ Loading the format of the result message in register r0

	bl printf					@ calling the printf function to display the output
       
	@nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
       @.end
	

unsigned:
	mov r0, $0					@ Move the value 0 in register r0
	
	b .Lloop_check					@ Unconditional branch i.e, always take the branch
.Lloop:							@ Lloop label
	add r0, r0, $1					@ Increment the value in register r0(i.e, 0) by 1 and store it back in register r0
	sub r1, r1, r2					@ Subtract the value in register r2 (denominator) from the value in register r1 (numerator) and store the resultant value back in register r1
.Lloop_check:						@ Will always take this branch
	cmp r1,r2					@ compare the value in register r1(numerator) and in register r2(denominator)
	bhs .Lloop					@ if r1>=r2, branch to .Lloop
	
	@ Value in register r0 is quotient (output)
	@ value in register r1 in remainder

	
	mov r1, r0					@ move the value of register r0 to register r1 as we are only require the quotient
        
	ldr r0, =resultMessage				@ Loading the format of the result message in register r0
	bl printf					@ calling the printf function to display the output

       @nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
       @.end






signed:
	mov r3,$-1					@ Moving the value -1 to a register r3
	@mul r1, r1, r3					@ multiplying the value of numerator stored in register r1 with value in r3 and making it positive
	
	den_pos: mul r2, r2, r3				@ function for making denominator positive
	
	num_pos: mul r1, r1, r3				@ function for making numerator positive
	
	cmp r1,$0					@ comparing if the numerator is less than 0
	blt num_pos					@ if numerator less than 0, then branch to num_pos and make the numerator positive
	
	cmp r2, $0					@ comparing if the denominator is less than 0
	blt den_pos					@ if denominator less than 0, then branch to den_pos to make the denominator positive



	mov r0, $0					@ move the value 0 into the register r0
	
	b .Lloop_check_s				@ Unconditional branch i.e, always take this branch
	.Lloop_s:					@ Lloop label
	add r0, r0, $1					@ increment the value in register r0 (i.e, 0)  by 1 and store it back into register r0
	sub r1, r1, r2					@ subtract the value in register r2 (denominator) from the value in register r1 (numerator) and store it back in register r1
	.Lloop_check_s:					@ Will always take this branch
	cmp r1,r2					@ compare the value in register r1 (numerator) and register r2 (denominator)
	bhs .Lloop_s 					@ if r1>=r2, then branch to .Lloop_s

	@ Value in register r0 is quotient (output)
	@ value in register r1 in remainder


	mov r1, r0 					@ move the value of register r0 to register r1 as we are only require the quotient
	mul r1, r1, r3					@ multiply the quotient by -1 to make it neagtive
        
	ldr r0, =resultMessage				@ Loading the format of the result message in register r0
	bl printf					@ calling the printf function to display the output

       @nop                 @no operation
	mov %r0, $0
	bl fflush        
	mov r7, $1          @exit syscall
        svc $0              @wake kernel
       @.end
.global         main
main:

	ldr r0, =messageFirst				@ Loading the message to be displayed for the first input integer in register r0
	bl printf					@ branch link instruction to call printf function to print the message

	ldr r0, =formatNum				@ Loading the format of the first integer in register r0
	ldr r1, =num1					@ Loading the first integer number itself in register r1
	bl scanf					@ branch link instruction to call scanf function to scan first integer

	ldr r0, =messageOp				@ Loading the message to be displayed for the input operator  in register r0
	bl printf					@ branch link instruction to call printf function to print the message

	ldr r0, =formatOp				@ Loading the format of the operator  in register r0
	ldr r1, =op					@ Loading the operator  itself in register r1
	bl scanf					@ branch link instruction to call scanf function to scan the entered operator

	ldr r0, =messageSecond				@ Loading the message to be displayed for the second input integer in register r0
	bl printf					@ branch link instruction to call printf function to print the message
	
	ldr r0, =formatNum				@ Loading the format of the second  integer in register r0
	ldr r1, =num2					@ Loading the second integer number itself in register r1
	bl scanf					@ branch link instruction to call scanf function to scan the second integer

	ldr r0, =num1					@ Loading the value of first integer number in register r0
	ldr r0, [r0]					@ Dereferencing the value in register r0 and loading it back in register r0

	ldr r2, =op					@ Loading the value of the operator in register r2
	ldr r2, [r2]					@ Dereferencing the value of the operator in register r2 and loading it back in register r2
	
	ldr r1, =num2 					@ Loading the value of second integer number in register r1
	ldr r1, [r1]					@ Dereferencing the value in register r1 and loading it back in register r1
 
	
	cmp r2, $42					@ comparing the ASCII value of '*' with operator value stores in registrer r2
	beq multiplication				@ if equal then branch to multiplication label

	cmp r2, $43					@ comparing the ASCII value of '+' with operator value strored in register r2
        beq addition					@ if equal then branch to addition label

	cmp r2, $45					@ comparing the ASCII value of '-' with operator value strored in register r2
        beq subtraction					@ if equal then branch to subtraction label
	
	cmp r2, $47					@ comparing the ASCII value of '/' with operator value strored in register r2
	beq division					@ if equal then branch to diviusion label
	.end
