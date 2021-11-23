# i : $t0
# j: $t1
# array[i][j]: $t3 

 	.eqv SIZE,3
 	.eqv print_str,4
 	.eqv print_char,11
 	.eqv print_int10, 1
 	.data
array:	.word str1,str2,str3
str1: 	.asciiz "Array"
str2: 	.asciiz "de"
str3: 	.asciiz "ponteiros"

str:	.asciiz "\nString #"
symbol:	.asciiz ": "
 	.text
 	.globl main
 	
main:	li $t0, 0		# i = 0
 
for: 	bge $t0,SIZE, endf	# while( i < size)
	
	la $a0, str
	li $v0, print_str
	syscall			# print_str
	move $a0, $t0
	li $v0, print_int10
	syscall			# print_int10(i)
	la $a0, symbol
	li $v0, print_str	# print_str(': ')
	syscall
	
	li $t1,0		# j = 0
 	 		
while:	la $t3,array 		# $t3 = &array[0]
 	sll $t2,$t0,2 		# i * 4
 	addu $t3,$t3,$t2 	# $t3 = &array[i]
 	lw $t3,0($t3) 		# $t3 = array[i] = &array[i][0]
 	addu $t3,$t3,$t1 	# $t3 = &array[i][j]
 	lb $t3,0($t3) 		# $t3 = array[i][j] 
 	
 	beq $t3, '\0', endw	# while $t3 != '\0'
 	move $a0, $t3
  	li $v0, print_char
 	syscall			# print_char()
 	li $a0, '-'
 	li $v0, print_char
 	syscall			# print_char('-')
 	
 	addi $t1,$t1,1		# j++
 	j while
 	
endw: 	addi $t0,$t0,1		# i++
 	j for
 	
endf: 	jr $ra 
