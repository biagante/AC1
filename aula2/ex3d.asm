#Maopa de registos:
# $t0 = a
# $t1 = b
  	.data
str1: 	.asciiz "Introduza 2 numeros\n"
str2: 	.asciiz "A soma dos dois numeros e': "
 	.eqv print_string,4
 	.eqv read_int,5
 	.eqv print_int10,1
 	.text
 	.globl main
main: 	la $a0,str1
 	ori $v0,$0,print_string
 	syscall 				# print_string(str1);
 	
 	ori $v0,$0,read_int
 	syscall 				# valor lido e' retornado em $v0
 	or $t0,$v0,$0 				# $t0=read_int() = a
 	
 	ori $v0,$0,read_int
 	syscall 				# valor lido e' retornado em $v0
 	or $t1,$v0,$0 				# $t0=read_int() = b
 	
 	la $a0,str2
 	ori $v0,$0,print_string
 	syscall					# print_string(str2);
 	
 	add $t1, $t1, $t0
 	
 	or $a0, $0, $t1
 	ori $v0,$0,print_int10
 	syscall 				# print_int(a + b);
 	
 	
 	jr $ra 					# fim do programa