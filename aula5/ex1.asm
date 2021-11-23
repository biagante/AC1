# Mapa de registos
# i: $t0
# lista: $t1
# offset: $t2
# &lista[i]: $t3
 	.data
 	.eqv SIZE,5
 	.eqv read_int, 5
 	.eqv print_string, 4
str:	.asciiz "Introduza um numero: "
	.align 2
lista:	.space 20			# SIZE*4 = 20
 	.text
 	.globl main
 	
main: 	li $t0, 0			# i = 0

for: 	bge $t0, SIZE, endf		# for(i < SIZE)
 	
 	la $a0, str
 	li $v0,print_string
 	syscall 			# print_string(str)
 	 	
 	li $v0, read_int		# read_int()
 	syscall
 	
 	la $t1, lista
 	sll $t2, $t0, 2			# offset = i * 4
 	
 	addu $t3,$t2,$t1		# &lista[i] = offset + lista
 	
 	sw $v0, 0($t3)

 	addiu $t0,$t0,1			# i++;
 	j for				# }
 	
endf: 	jr $ra 				# termina o programa 
