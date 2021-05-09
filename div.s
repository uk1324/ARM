.global _start

.data

text:
	.ascii " \n"

.balign 4

.text

_start:
	mov r7, #4

	mov r0, #9
	mov r1, #3
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
	
	clz r2, r0			@ r2 - number of bits in dividend
	rsb r2, r2, #32
	
	clz r3, r1			@ r3 - number of bits in divisor
	rsb r3, r3, #32
	
	mov r4, #0			@ r4 - result

	mov r5, #0			@ r5, remainder

	mov r6, #1			@ you can't bitshift a constant so i just store 1 there

div_loop:
	@ if no more bits can be borrowed return 
	sub r2, r2, #1

	cmp r2, #0
	blt div_end

	@ borrow bit
	lsl r5, r5, #1
	and r7, r0, r6, lsl r2		@ r7- result of shift
	add r5, r5, r7, lsr r2

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
