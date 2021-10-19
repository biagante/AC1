	.data
str:	.asciiz "ITED - orievA ed edadisrevinU"
	.eqv print_string, 4
	.text
	#.globl main	

#fun��o strrev() -> inverte o conte�do de uma string
# Mapa de registos:
# str: $a0 -> $s0 (argumento � passado em $a0)
# p1: $s1 (registo callee-saved)
# p2: $s2 (registo callee-saved)
strrev:	addiu $sp,$sp,-16 	# reserva espa�o na stack
	sw $ra,0($sp) 		# guarda endere�o de retorno
	sw $s0,4($sp) 		# guarda valor dos registos
	sw $s1,8($sp) 		# $s0, $s1 e $s2
	sw $s2,12($sp) 		#
	move $s0,$a0 		# registo "callee-saved"
	move $s1,$a0 		# p1 = str
	move $s2,$a0 		# p2 = str
	
strvw1: lb $s3, 0($s2)		
	beq $s3,'\0',strvendw1	# while( *p2 != '\0' ) {
	addi $s2,$s2,1		# p2++;
	j strvw1 		# }
	
strvendw1: 
	sub $s2,$s2,1		# p2--;
	
strvw2: bge $s1,$s2,strvendw2	# while(p1 < p2) {
	move $a0,$s1		#$a0 - 1� argumento de exchange
	move $a1,$s2 		#$a1 - 2� argumento de exchange
	jal exchange 		# exchange(p1,p2)
	addi $s1,$s1,1		# p1++
	sub $s2,$s2,1          # p2--
	j strvw2 		# }
	
strvendw2: 
	move $v0,$s0 		# return str
	lw $ra,0($sp) 		# rep�e endere�o de retorno
	lw $s0,4($sp)  		# rep�e o valor dos registos
	lw $s1,8($sp)  		# $s0, $s1 e $s2
	lw $s2,12($sp) 		#
	addiu $sp,$sp,16	# liberta espa�o da stack
	jr $ra 			# termina a sub-rotina
	
#fun��o exchange() -> troca a posi��o de dois registos
exchange:			#void exchange(char* c1, char* c2)
	lb $t0,0($a0)		#$t0 = $a0  || char aux = *c1;
	lb $t1,0($a1)		#$t1 = $a1
	sb $t1, 0($a0)		#$t1 = $a0  || *c1 = *c2;
	sb $t0,0($a1)		#$t0 = $a1  || *c2 = aux; 	
	jr $ra			#termina a sub-rotina
	
#fun��o main()
main: 	addiu $sp,$sp,16	#reserva espa�o
	sw $ra,0($sp)
 	sw $s0,4($sp)
 	sw $s1,8($sp)
 	sw $s2,12($sp)
	
	la $a0,str		#$a0 = str
 	jal strrev		#strev(str)
 	
 	move $a0,$v0
 	li $v0,print_string	#print_string( strrev(str) );
	syscall	
	
	lw $ra,0($sp)
 	lw $s0,4($sp)
 	lw $s1,8($sp)
 	lw $s2,12($sp)
 	addiu $sp,$sp,-16	#liberta espa�o reservado
 	
	jr $ra

	