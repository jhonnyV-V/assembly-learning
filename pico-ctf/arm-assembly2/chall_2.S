	.arch armv8-a
	.file	"chall_2.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #32 //put sp - 32
	str	w0, [sp, 12] //store argv[1] in sp +12
	str	wzr, [sp, 24] //set sp+24 to 0
	str	wzr, [sp, 28] //set sp+28 to 0
	b	.L2 //call l2
.L3:
	ldr	w0, [sp, 24] //load 0 into w0
	add	w0, w0, 3 //increment w0 by 3
	str	w0, [sp, 24] // increment sp +24 by 3
	ldr	w0, [sp, 28] //load 0 to w0
	add	w0, w0, 1 // set w0 to 1
	str	w0, [sp, 28] //increment sp +28 by 1
.L2:
	ldr	w1, [sp, 28] //load 0 to w1
	ldr	w0, [sp, 12] //load argv[1] to w0
	cmp	w1, w0 //compare
	bcc	.L3 // call l3 if no overflow or underflow (carry flag is clear)//bcc = branch if carry flag clear
	ldr	w0, [sp, 24] //set w0 sp+24
	add	sp, sp, 32 //increment sp by 32
	ret //loop
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0:
	.string	"Result: %ld\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]! //store pair, into x29(frame pointer) and x30(return address) into the stack minus a 48 offset
	add	x29, sp, 0 //save sp in x29
	str	w0, [x29, 28] //store  argv[0] in x29 +28
	str	x1, [x29, 16] //store argv[1] in x29 +16
	ldr	x0, [x29, 16] //load in again
	add	x0, x0, 8 //increment the pointer by 8
	ldr	x0, [x0] //load it again
	bl	atoi //convert it to string
	bl	func1 //function call
	str	w0, [x29, 44] //store 0 or 3 in x29 +44
	adrp	x0, .LC0 //print result
	add	x0, x0, :lo12:.LC0
	ldr	w1, [x29, 44]
	bl	printf
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
