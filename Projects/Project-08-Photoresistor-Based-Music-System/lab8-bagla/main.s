#include <wiringPi.h>
#include <softPwm.h>

.section	.data
yesString:
	.asciz "yes"
formatString:
	.asciz "%s"
dataString:
	.asciz "%d\n"
userInput:
	.space 128

.section	.text
.global main
main:
	ldr r0, =formatString
	ldr r1, =userInput
	bl scanf		@ scanf("%s", userInput)
	ldr r0, =userInput
	ldr r1, =yesString
	bl strcmp 
	cmp r0, #0
	beq yes
	
	b no

yes:
	@ This playSoundtion call sets up wiringPi, just like Lab 5
	bl wiringPiSetup	@ wiringPiSetup()

	@ we need to call this next setup to use the ADC w/ SPI
	mov r0, #100
	mov r1, #0
	bl mcp3004Setup		@ mcp3004Setup(100, 0);
	@ At this point, you can use analogRead(100) to read
	@ the value of the first ADC channel, 101 to read the second, etc
	
		

	@mov r0, #28
	@mov r1, #0
	@bl pinMode 		@ pinmode(28, 0)

	bl changeVolume		@ r0 holds the process id of the volume script.
	mov r10, r0
	
	@ r8, is the counter variable
	@ r6, is the value variable

	mov r0, #24		@ call for softPwmCreate for creating the LED pin
	mov r1, #1
	mov r2, #100
	bl softPwmCreate

AvgFunc:		
		
	add  	r8, r8, $1	@ Increasing the counter variable by 1
	mov  	r0, $100
	bl   	analogRead	@ calling the analogRead function by parameter: analogRead(100)
	add  	r6, r6, r0	@ add the analogRead value: value = analogRead(100) + val

	cmp   	r8, $8		@ comparing the counter by 8
	blt	AvgFunc		@ if (counter > 8) then branch back to loop - AvgFunc
	asr	r6, r6, $3 	@ dividing the value by 8: val = val/8
	mov 	r1, r6		@ move the value variable in register r1
	sub 	r8, r8, $8	@ decrease the counter variable by 8 and reset it to 0
	mov 	r6, $0		@ reset the value variable to 0

	mov	r5, r1 		@ move the value to register r5

	cmp	r5, #500	@compare r5 by 500
	movgt	r0, #24		
	movgt 	r1, #75
	movgt	r1, #1
	blgt	softPwmWrite	@ if greater than then its dark and ligh the LED

	cmp 	r5, #300	@compare r5 by 300
	movlt 	r0, #24
	movlt	r1, #0
	bllt 	softPwmWrite	@ if less than then call softPwmWrite and switch off the LED
	movlt 	r0, #1
	bllt	playSound	@ call the function to play a song
	
	movlt	r0, r10		@ Kill the volume process
	movlt 	r1, $9
	bllt	kill

	cmp 	r5, #500	@ compare r5 by 500
	movlt 	r0, #24
	movlt	r1, #0
	bllt 	softPwmWrite	@ if less than call softPwmWrite and switcj off the LED
	movlt	r0, $0
	bllt	playSound	@ call the function and play a song
	
	movlt	r0, r10		@ Kill the volume process
	movlt 	r1, $9
	bllt	kill
	
	b 	AvgFunc		@ Regardless, branch back to loop - AvgFunc	
no:
	mov r7, #1
	swi 0
