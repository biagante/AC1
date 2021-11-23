# size: $t0
# p : $t1
# pultimo: $t2 
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
 	
main:	la $t1,array 		# $t1 = p = &array[0] = array
 	li $t0,SIZE 		#
 	sll $t0,$t0,2 		# size * 4
 	addu $t2,$t1,$t0	# $t2 = pultimo = array + SIZE
 
for: 	bge $t1,$t2, endf	# while( p < pultimo)
 	
 	lw $a0, 0($t1)
 	 		
 	li $v0, print_str
 	syscall			#print_str
 	li $a0, '\n'
 	li $v0, print_char
 	syscall			#print_char('\n')
 	
 	addi $t1,$t1,4		# p++
 	j for
 	
endf: 	jr $ra 
