	.data
str1: 	.asciiz "Introduza 2 numeros\n"
str2: 	.asciiz "A soma dos dois numeros é: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_int10,1
	.text
	.globl main
main: 	la $a0,str1
	ori $v0,$0,print_string
	syscall 		# print_string(str1);
	
	ori $v0,$0,read_int 	#ler o primeiro valor
	syscall 		# valor lido é retornado em $v0
	or $t0,$v0,$0 		# $t0=read_int() = a
	ori $v0,$0,read_int 	#ler o segundo valor
	syscall 		# valor lido é retornado em $v0
	or $t1,$v0,$0 		# $t1=read_int() = b
	
	la $a0,str2
	ori $v0,$0,print_string
	syscall 		# print_string(str2);
	
	add $t2,$t0,$t1		# (a + b)
	move $a0,$t2
	ori $v0,$0,print_int10	#print_int10(a + b);
	syscall 

	jr $ra # fim do programa

