 .data     
	buffer: 
		.space 40
	result: 
		.align 2
		.space 40

	hexresult: 
		.align 2
		.space 40

	str1:  
		.asciiz "Enter string: "     
	str2: 
		.asciiz "HEX: "

.text
.globl main
main:
	li 	$t3, 0
	li 	$t5, 0
	li 	$t6, 0
	li 	$s0, 0


	la 	$a0, str1		# print str1
	li 	$v0, 4
	syscall

	li 	$v0, 8       		# read input string

	la 	$a0, buffer 		# load byte into address

	li 	$a1, 40     		# alloc byte space for string 

	move 	$t0, $a0		# save string 
	syscall      

	la 	$a0, str2 		# print str2
	li 	$v0, 4     
	syscall      

	la 	$a0, buffer  		# reload byte space to primary address     
	
	move 	$a0, $t0		# set string address to $a0     
	li 	$t1, 0

loop:
	lb 	$t2, ($t0)		# get value from enter string

	beq 	$t2, $zero, print   	# end array break loop
	
	li 	$t3, 0
	jal	decToHex
	
	continue:	
	li	$s2, 4
	lw	$s1, hexresult($s2)	
	sw 	$s1, result($s0)	
	add 	$s0, $s0, 4
	sub 	$s2, $s2, 4
	lw	$s1, hexresult($s2)	
	sw 	$s1, result($s0)	
	
	add 	$t0, $t0, 1		# increment enter string
	add 	$s0, $s0, 4

	j 	loop

decToHex:
	li	$t7, 16

	div 	$t2, $t7
	mflo	$t2
	mfhi	$t6

	sw 	$t6, hexresult($t3)	

	add 	$t3, $t3, 4		# increment array index

	beq 	$t2, $zero, continue 

	j	decToHex

print:
	lw 	$t4, result($t5)	# get value from array

	beq 	$t4, $zero, exit	# end array break loop

	move 	$a0, $t4		# move array value for print

	li 	$v0, 1      		# print value
	syscall      

	add 	$t5, $t5, 4	
	lw 	$t4, result($t5)
	move 	$a0, $t4	
	li 	$v0, 1      		# print value
	syscall      

	li 	$a0, ' '		# print space
	li 	$v0, 11      
	syscall      

	add 	$t5, $t5, 4		# increment array index

	j 	print

exit:
	li 	$v0, 10			# end program
	syscall

