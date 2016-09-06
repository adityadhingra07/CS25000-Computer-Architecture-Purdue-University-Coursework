.bss

.lcomm string, 100 		@ Allocating the space for the srtring

.section        .data

fmt: .asciz "%s"		@ Format of the input string
out: .ascii "%d\n"		@ FOrmat of the output string

.section        .text
.global         main		@ Declaring the use of main
.global		printf		@ Declaring the use of printf function
.global 	scanf		@ Declaring the use of scanf function
@.global		gets

fmt_address: 	.word fmt	@ Address of label fmt_address will point to the address of fmt
out_address:	.word out	@ Address of label out_address  will point to the address of out
str_address:	.word string	@ Address of label str_address will point to the address of string


main:
	@ldr %r0, str_address
	@bl gets
	
	ldr r0, =fmt		@ Loading the format of the string to be scanned in register r0
	ldr r1, =string		@ Loading the input string as the first parameter in register r1
	bl scanf		@ branch link instruction to scanf (scanf function called)
	
	ldr r0, str_address	@ Loading the address of the input string into register r0

loop:
	ldr r1, [r0]		@ Dereferencing the value of str_address stored in register ro and loading it into register r1
	cmp %r1, $0		@ Comparing the value in register r1 to 0 i.e. null terminator at the end of the string
	beq done		@ if comparison yields true then branch to the label done, else
	
	add %r0, $1		@ if the comparison yields false then increment the counter by 1 i.e, increase the cvalue in register r1 by 1
	b loop			@ and branch again to the loop

done:
	ldr %r1, str_address	@ Loading the str_address in register r1 i.e, r1 now points to the start of the string 
	sub %r1, %r0, %r1	@ register r0 points to the end of the string, therefore subtracting register r1(start) from register r0(end) and storing the value in register r1
	ldr %r0, =out		@ Loading the format of the output string in register r0, register r1 has the value of the length of the string
	bl printf		@ branch link instruction to printf (printf function called)
	b end			@ branch to end

end:

	mov %r0, $0		@ moving the value 0 in register r0
	mov %r1, $0		@ moving the value 0 in register r1
	bl fflush		@ branch link instruction to stdout
	
	mov r7, $1          @exit syscall
	swi $0              @wake kernel
	.end
