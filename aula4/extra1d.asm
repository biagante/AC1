# Mapa de registos
# p: $t0
# *p: $t1
 	.data
array:	.word 7692,23,5,234
 	.eqv print_string, 4
 	.eqv read_string, 8
 	.eqv SIZE, 20
str: 	.space 21          		# SIZE + 1
str1: 	.asciiz "Introduza uma string: "
 	.text
 	.globl main
 	
main: 	la $a0, str1		
	li $v0, print_string
	syscall				# print_string(str1);
 	
 	la $a0, str
 	li $a1,SIZE 			# $a1=SIZE
 	li $v0,read_string
 	syscall 			# read_string(str,SIZE)
 	
 	la $t0,str 			# p = str;
 	
 	
while: 					# while(*p != '\0')
 	lb $t1,0($t0) 			#
 	beq $t1,0,endw 			# {
 	
 	blt $t1, 0x41, else		# 
 	bgt $t1, 0x5a, else		# vericar se letra é minuscula
 	
 	addi $t1, $t1, 0x20		# *p = *p - ('a' - 'A') => 0x20
 	sb $t1,0($t0)			# guarda na str
 	
else: 	addiu $t0,$t0,1			# p++;
 	j while				# }
 	
endw: 	la $a0, str 	
	li $v0, print_string
	syscall				# print_string(str);
 	jr $ra 				# termina o programa 