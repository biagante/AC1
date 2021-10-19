# Mapa de registos -> main()
# res: $v0
# s: $a0
# digit: $t1
	.data
str:	.asciiz "2016 e 2020 são anos bissextos"
	.eqv print_int10, 1
	.text
	#.globl main
main:	addiu $sp,$sp,-4		#reserva espaço na stack
	sw $ra,0($sp)
	
	la $a0,str		#s = str
	jal atoi		#atoi(str)
	
	move $a0, $v0
	li $v0, print_int10	#print_int10( atoi(str) ); 
	syscall
	
	li $v0,0
	lw $ra,0($sp)
	addiu $sp,$sp,4		#liberta espaço
	
	jr $ra			#termina o programa

# Mapa de registos -> atoi()
#converte para um inteiro de 32 bits a quantidade representada por uma
#string numérica em que cada carater representa o código ASCII de
#um dígito decimal 
# res: $v0
# s: $a0
# *s: $t0
# digit: $t1
# Sub-rotina terminal: não devem ser usados registos $sx
atoi: 	li $v0,0 		# res = 0;
atw: 	lb $t0,0($a0) 		# while( (*s >= '0') && (*s <= '9'))
 	blt $t0, '0', atendw 	#
 	bgt $t0, '9', atendw 	# {
 	sub $t1,$t0,'0' 	# digit = *s – '0'
 	addiu $a0,$a0,1 	# s++;
 	mul $v0,$v0,10 		# res = 10 * res;
 	add $v0,$v0,$t1 	# res = 10 * res + digit;
 	j atw 			# }
atendw:	jr $ra 			# termina sub-rotina 
