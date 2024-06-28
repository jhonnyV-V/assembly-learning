	.arch armv8-a
	.file	"chall_1.c"
	.text
	.align	2
	.global	func
	.type	func, %function
func:
	sub	sp, sp, #32 //stack pointer - 32
	str	w0, [sp, 12] // save probably argv[1] in sp + 12
	mov	w0, 87 //put 87 in w0
	str	w0, [sp, 16] //put 87 in sp + 16
	mov	w0, 3 //put 3 in w0
	str	w0, [sp, 20] //put 3 in sp + 16
	mov	w0, 3 //put 3 in w0
	str	w0, [sp, 24] //put 3 in sp + 24
	ldr	w0, [sp, 20] //load 3 in w0
	ldr	w1, [sp, 16] //load 87 w1
	lsl	w0, w1, w0 //bitshift w1 by w0 // 696
	str	w0, [sp, 28] //put result in sp +28
	ldr	w1, [sp, 28] // load result in w1
	ldr	w0, [sp, 24] // load 3 in w0
	sdiv	w0, w1, w0 // divide w1 / w0 / 232
	str	w0, [sp, 28] //store results in sp +28 overwriting the results of the bitshifting
	ldr	w1, [sp, 28] // load result in w1
	ldr	w0, [sp, 12] // load argv[1]
	sub	w0, w1, w0 // w1 - w0
	str	w0, [sp, 28] //store result in sp+28 again
	ldr	w0, [sp, 28] //load it again
	add	sp, sp, 32 // reset the sp pointer
	ret
	.size	func, .-func
	.section	.rodata
	.align	3
.LC0:
	.string	"You win!"
	.align	3
.LC1:
	.string	"You Lose :("
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -48]! //store pair, into x29(frame pointer) and x30(return address) into the stack minus a 48 offset
	add	x29, sp, 0 //store sp in x29
	str	w0, [x29, 28] // store argv[0](program name) in sp +28
	str	x1, [x29, 16] // store argv[1] in sp +16
	ldr	x0, [x29, 16] // load 87 in x0
	add	x0, x0, 8 //add 87 + 8 = 95
	ldr	x0, [x0] //load from the stack probably the pointer to the start of the string of the first argument
	bl	atoi //convert it to a number
	str	w0, [x29, 44] //store the value in x29 + 44
	ldr	w0, [x29, 44] //load the same value again
	bl	func
	cmp	w0, 0 //compare result to 0
	bne	.L4 // w0 != 0
	adrp	x0, .LC0 //get the addres of the function and calling it
	add	x0, x0, :lo12:.LC0
	bl	puts
	b	.L6 //always executes
.L4:
	adrp	x0, .LC1 //get the addres of the function and calling it 
	add	x0, x0, :lo12:.LC1
	bl	puts
.L6:
	nop
	ldp	x29, x30, [sp], 48
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
