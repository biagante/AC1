# Mapa de registos
# $t0 - p
# $t1 - pultimo

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

main:	la $t0, array		#$t0 = p = array;
	addiu $t1,$t0,12	#$t1 = pultimo  = array + SIZE * 4

for:	bge $t0,$t1,endfor	#while( p < pultimo)
 
	lw $a0, 0($t0) 		# $t2 = array[i]
	li $v0,print_string
	syscall			#print_string(array[i])
	
	li $a0,'\n'		
	li $v0, print_char
	syscall			#print_char('\n')
	
	addiu $t0,$t0,4		#p += 4
	j for
	
endfor:	jr $ra			#termina o programa