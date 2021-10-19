# Mapa de registos
# p - $t0
# *p - $t1
 	.data
str:	.space 20
str1:	.asciiz "Introduza uma string: "
 	.eqv print_string, 4
 	.eqv read_string, 8
 	.eqv SIZE, 20
 	.text
 	.globl main
 	
main: 	la $a0, str1
	li $v0, print_string		#print_string(str1);
	syscall
	
	la $a0, str
	li $a1, SIZE
	li $v0, read_string		#read_string(str, SIZE);
	syscall
	
	la $t0, str			#p = str
	
while:	
	lb $t1, 0($t0)			#*p
	beqz $t1, endw			#while (*p != '\0'){
	blt $t1, 0x61, else		#aqui verificamos se a letra
	bgt $t1, 0x7a, else		#já é minúscula
					#*p = *p – 'a' + 'A';
	sub $t1, $t1, 0x20		#*p=*p-('a'-'A');//'a'-'A'=0x20		
	sb $t1, 0($t0)
	
else:	addi $t0, $t0, 1		#p++
	j while				#}
	
endw:
	la $a0, str
	li $v0, print_string		# print_string(str);
	syscall
	jr $ra				# termina o programa