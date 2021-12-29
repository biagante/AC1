	.data
str:	.asciiz "101101"
	.eqv print_int10, 1
	.text
	#.globl main

main:	addiu $sp,$sp,-4
	sw $ra,0($sp)

	la $a0, str
	jal atoi		#atoi(str)
	move $a0, $v0
	li $v0, print_int10	#print_int10
	syscall
	li $v0, 0		#return 0
	
	lw $ra, 0($sp)
	addiu $sp,$sp,4
	
	jr $ra
	
	

# Mapa de registos
# res: $v0
# s: $a0
# *s: $t0
# digit: $t1
# Sub-rotina terminal: não devem ser usados registos $sx
atoi: 	li $v0,0 		# res = 0;
atwhile: lb $t0, 0($a0)		# while
 	blt $t0,'0', atew	#(*s >= '0')
 	bgt $t0,'1', atew	# (*s <= '1')
 	sub $t1,$t0, '0'	# digit = *s – '0'
 	addiu $a0,$a0,1		# s++;
 	mul $v0,$v0,2 		# res = 2 * res; (binary)
 	add $v0,$v0, $t1	# res = 2 * res + digit;
 	j atwhile 		# }
atew:	 	
 	jr $ra 			# termina sub-rotina 
