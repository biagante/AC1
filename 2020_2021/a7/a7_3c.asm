#Mapa de Registos
#$a0 -> argumento da fun��o
#$a1 -> argumento da fun��o
#$v0 -> retorno da fun��o
	.data
stro:	.asciiz "Arquitetura de Computadores I"
strc:	.space 50
	.eqv print_string, 4
	.text
	#.globl main

main:	addiu $sp, $sp, -4	#reservar espa�o na Stack
	sw $ra, 0($sp)		#
	
	la  $a0, strc		#
	la  $a1, stro		#
	jal strcopy		#strcopy(strc, stro);
	
	move $a0, $v0		#
	li  $v0, print_string	#print_string(strcopy(strc, stro); 
	syscall			#
	
	lw  $ra, 0($sp)		#
	addiu $sp, $sp, 4	#Libertar espa�o na Stack
	jr  $ra			#fim do programa

#Mapa de Registos strcopy
#dst:	$t0
#src:	$t1
#*src:	$t2
strcopy:
	move $t0, $a0		#$t0 = dst;
	move $t1, $a1		#$t1 = src;
	
stcdo:	lb $t2, 0($t1)		#$t2 = *src
	sb $t2, 0($t0)		#guardar o caracter em dst
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1	#src++;
	bne $t2, '\0', stcdo	#while(*src!='\0');
	
	move $v0, $a0		#return dst
	jr  $ra			#fim da sub-rotina