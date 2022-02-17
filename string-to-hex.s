# Simple string to hex converter
# Copyright (c) 2022 Leonardo Z. Nunes

.data     
buffer: 
.space 100

array0: 
.align 2
.space 100

array1: 
.align 2
.space 100

str0:  
.asciiz "Enter string: "     
str1: 
.asciiz "hex: "

.text
.globl main
main:
li $s0,	0		
li $s1, 16			

la $a0, str0		
li $v0, 4
syscall

li $v0, 8       	
la $a0, buffer 		
li $a1, 100     	 
move $s0, $a0		
syscall      

la $a0, str1 		
li $v0, 4     
syscall      

la $a0, buffer  	

loop:
lb $t1, ($s0)		

		beq $t1, 10, print	

		li $t2, 0
		jal decToHex

		invert:

lw $t3, array1($t2)	

sw $t3, array0($s2)
		add $s2, $s2, 4

		beq $t2, $zero, continueLoop	
		sub $t2, $t2, 4

		j invert

		continueLoop:

		add $s0, $s0, 1				

		j loop

		decToHex:
		div	$t1, $s1
		mflo $t1
		mfhi $t3

sw $t3, array1($t2)	
		beq $t1, $zero, invert 
		add $t2, $t2, 4				

		j decToHex

		print:
lw $t1, array0($s3)
		beq $t1, $zero, exit	
		move $a0, $t1			

		li $v0, 1      	
		syscall      

		add $s3, $s3, 4	
lw $t1, array0($s3)

		beq $t1, 10, A
		beq $t1, 11, B
		beq $t1, 12, C
		beq $t1, 13, D
		beq $t1, 14, E
		beq $t1, 15, F

		move $a0, $t1	
		jal	printValue

		A:
		li $a0, 'a'
		jal	printLetter

		B:
		li $a0, 'b'
		jal	printLetter

		C:
		li $a0, 'c'
		jal	printLetter

		D:
		li $a0, 'd'
		jal	printLetter

		E:
		li $a0, 'e'
		jal printLetter

		F:
		li $a0, 'f'
		jal printLetter

		printLetter:
		li $v0, 11      
		syscall      
		jal	printSpace

		printValue:
		li $v0, 1  
		syscall      

		printSpace: 
#li $a0, ' '	
#li $v0, 11      
#syscall      

		add	$s3, $s3, 4		

		j print

		exit:
		li $v0, 10		
		syscall
