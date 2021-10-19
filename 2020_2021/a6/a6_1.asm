# Mapa de registos
# *array: $t0
# i: $t1
# array[i]: $t2
# *i : $t3
	.data
st1:	.asciiz "Array"
st2:	.asciiz "de"	
st3:	.asciiz "ponteiros"

array:	.word st1,st2,st3
		
	.eqv SIZE,3
	.eqv print_string,4
	.eqv print_char,11
		
	.text
	.globl main

main:	li $t3, 0		#$t3 = i = 0;

for:	bge $t3,SIZE,endfor	#while( i < SIZE)

	la $t0, array 		# $t0 = array
	move $t1, $t3 		# $t1 = i
	sll $t1, $t1, 2 	# $t1 = i * 4 
	addu $t1, $t1, $t0	# 
	lw $a0, 0($t1) 		# $t2 = array[i]
	li $v0,print_string
	syscall			#print_string(array[i])
	
	li $a0,'\n'		
	li $v0, print_char
	syscall			#print_char('\n')
	
	addiu $t3,$t3,1		#i++
	j for
	
endfor:	jr $ra			#termina o programa
	
			