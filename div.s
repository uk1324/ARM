.global _start

.data

text:
	.ascii " \n"

.balign 4

.text

_start:
	mov r7, #4

	mov r0, #185
	mov r1, #5
	bl div

	mov r4, r0

@	mov r4, #128
	ldr r5, =text
	
loop:
	mov r0, r4
	mov r1, #10
	
	cmp r0, #0
	beq exit

	bl div
	mov r4, r0

	add r6, r1, #48
	strb r6, [r5]

	mov r0, #1 
	mov r1, r5
	mov r2, #2
	swi 0

	b loop

exit:
	mov r7, #1	
	swi 0

div:
	push {r3-r10, r11, lr}
	https://community.arm.com/developer/tools-software/oss-platforms/f/dev-platforms-forum/5436/i-want-to-know-meaning-of-r12-register
	clz r2, r0			@ r2 - number of bits in dividend
	@ could store the result of lsl in diffrent register and then
	@ the result (r4) in r0 so the result is already in the return register
	lsl r0, r2
	rsb r2, r2, #32
	
	clz r3, r1			@ r3 - number of bits in divisor
	rsb r3, r3, #32
	
	mov r4, #0			@ r4 - result

	mov r5, #0			@ r5, remainder

	mov r6, #1			@ you can't bitshift a constant so i just store 1 there

	mov r7, #0

div_loop:
	@ if no more bits can be borrowed return 
	subs r2, r2, #1

	blt div_end

	@ borrow bit
@	lsl r5, r5, #1

	lsls r0, r0, #1

	adc r5, r7, r5, lsl #1


	@ if the number is smaller than the divident borrow bit and loop again
	cmp r5, r1
	blt div_loop

	@ add to result
	add r4, r4, r6, lsl r2

	@ subtract from remainder
	sub r5, r5, r1

	b div_loop
	
div_end:
	mov r0, r4
	mov r1, r5
	pop {r3-r10, r11, pc}
	bx lr	


