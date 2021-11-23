# i: $t0
#
 	.eqv SIZE,3
 	.eqv print_str,4
 	.eqv print_char,11
 	.data
array:	.word str1,str2,str3
str1: 	.asciiz "Array"
str2: 	.asciiz "de"
str3: 	.asciiz "ponteiros"
 	.text
 	.globl main
 	
main:	li $t0, 0		# i = 0	
 	
for: 	bge $t0,SIZE, endf	# while( i < SIZE)
 	la $t1,array 		# $t1 = &array[0]
 	sll $t2,$t0,2 		# i * 4
 	addu $t2,$t1,$t2	# $t2 = &array[i] => (array + i*4)
 	lw $a0,0($t2) 		# $a0 = array[i] || carrega elemento i do array
 	
 	li $v0, print_str
 	syscall
 	li $a0, '\n'
 	li $v0, print_char
 	syscall
 	
 	addi $t0,$t0,1		# i++
 	j for
 	
endf: 	jr $ra 
