# O argumento da fun��o � passado em $a0
# O resultado � devolvido em $v0
# Sub-rotina terminal: n�o devem ser usados registos $sx
	.data
str: 	.asciiz "Arquitetura de Computadores I"
	.eqv print_int10, 1
	.text
	#.globl main

#fun��o strlen() -> determina e devolve a dimens�o de uma string
#Mapa de registos
#$t0: s* 
#$t1: len
strlen:	li $t1,0 		# len = 0;
stlw: 	lb $t0,0($a0)		# $t0 = char[0] da str
	addiu $a0,$a0,1 	# s++
	beq $t0,'\0',stlendw 	# while(*s++ != '\0')
	addi $t1,$t1,1 		# len++;
	j stlw			# }
stlendw: move $v0,$t1 		# return len;
	jr $ra 			# termina a fun��o
	
#fun��o main	
#Mapa de registos
#$a0: argumentos 
#$v0: resultado
main:	addiu $sp, $sp, -4	#reserva espa�o
	sw $ra, 0($sp)		#guarda o valor de $a0
	
	la $a0, str		#$a0 = str
	jal strlen		#strlen(str)
	move $a0, $v0
	li $v0, print_int10	#print_int10(strlen(char))
	syscall
	
	lw $ra, 0($sp)		#atualiza o valor de $a0
	addiu $sp,$sp,4		#liberta o espa�o reservado
	jr $ra			#termina o programa