	.data
	.eqv print_int10,1
str:	.asciiz "Arquitetura de Computadores I"
	.text
	#.globl main
	
main:	addiu $sp,$sp,-4	# reserva o espaço
        sw $ra, 0($sp)		# guarda o valor de $a0

	la $a0, str
	jal strlen
	move $a0, $v0
	li $v0, print_int10
	syscall     		# print_int10(strlen(str));
	 
	lw $ra,0($sp)		# atualiza o valor de $a0
	addiu $sp,$sp,4 	# liberta o espaco reservado
	
	li $v0, 0		# return 0;
	jr $ra

# O argumento da função é passado em $a0
# O resultado é devolvido em $v0
# Sub-rotina terminal: não devem ser usados registos $sx
strlen: li $t1,0 		# len = 0;
while: 	lb $t0,0($a0)		# while(*s++ != '\0')
 	addiu $a0,$a0,1 	#
 	beq $t0,'\0',endw 	# {
 	addi $t1,$t1, 1		# len++;
 	j while		# }
endw: 	move $v0,$t1 		# return len;
     	jr $ra 			#	 
