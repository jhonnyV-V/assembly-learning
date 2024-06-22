	.arch armv8-a //arm version 64bits
	.file	"chall.c"
	.text
	.align	2
	.global	func1
	.type	func1, %function
func1:
	sub	sp, sp, #16 //move stack pointer back by 16
	str	w0, [sp, 12] //store argv[1]
	str	w1, [sp, 8]	 //store argv[2]
	ldr	w1, [sp, 12] //save argv[1] in w1
	ldr	w0, [sp, 8]  //save argv[2] in w0
	cmp	w1, w0 //compare an set a flag for bls
	bls	.L2 //if w0 < w1
	ldr	w0, [sp, 12] //load again agrv[1] in w0
	b	.L3 //always runs
.L2:
	ldr	w0, [sp, 8] //load argv[2] in w0
.L3:
	add	sp, sp, 16 //reset the stack
	ret  //return func1
	.size	func1, .-func1
	.section	.rodata
	.align	3
.LC0: //prints the result
	.string	"Result: %ld\n"
	.text
	.align	2
	.global	main
	.type	main, %function
	; argv[0] argv[1] argv[2]
	; ldr <instruction> <src> [<dst>, <offset>, <shift>]
	; example
	; str r1,[r0,r3,lsl#2]
	; The instruction above basically says: r0 + (r3 << 2) = r1, or if we manually "expand" the bit-shift: r0 + (r3 * 4) = r1
main:
	//store stack pointer - 48 in both register
	stp	x29, x30, [sp, -48]! //store pair, into x29(frame pointer) and x30(return address) into the stack minus a 48 offset
	add	x29, sp, 0 //saving the current stack pointer in x29
	str	x19, [sp, 16] //this looks like it does nothing
	str	w0, [x29, 44] //store program name as a int32 in the sp + 44
	//x0-x7 are registers for arguments and return values
	str	x1, [x29, 32] //store argv[1] in the stack at sp + 32
	ldr	x0, [x29, 32] //load from the stack argv[1] that was previusly x1
	add	x0, x0, 8 //sets the 0x pointing to the start of the 8 char string
	ldr	x0, [x0] //reads the string
	bl	atoi //convert the strings to a number and stores it in x0
	mov	w19, w0 //w0 is an alias to x0 but it takes it as an int32 strings
	ldr	x0, [x29, 32] //load the pointer to the argv[1]
	add	x0, x0, 16 //increment it by the length of the 2 string arguments
	ldr	x0, [x0] //load the string
	bl	atoi
	mov	w1, w0 //store argv[2] in w1
	mov	w0, w19 //store argv[1] in w0
	bl	func1 //call func1
	mov	w1, w0 //store result in w1
	adrp	x0, .LC0 //get the LC0 partiall address in x0, don't ask me about this
	add	x0, x0, :lo12:.LC0 //get the full pointer?
	bl	printf //print
	mov	w0, 0 //set 0 as return value of the program
	ldr	x19, [sp, 16] //reset x19 to the initiall value that is unknown
	ldp	x29, x30, [sp], 48 //reset the x29 and x30 to the initial values at line 1 of the main function
	ret //return
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
