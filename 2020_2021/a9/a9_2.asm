	.data
five:	.double 5.0
nine:	.double 9.0
trintad:.double 32.0
	.eqv print_double, 3
	.eqv read_double, 7
	.text
	#.globl main
main:	addiu $sp, $sp, -4	#reservar espaço na Stack
	sw $ra, 0($sp)		
	
	li $v0, read_double
	syscall			#val = read_double();		
	mov.d $f12,$f0		
	jal f2c
	
	mov.d $f12,$f0
	li $v0, print_double
	syscall

	lw  $ra, 0($sp)		
	addiu $sp, $sp, 4	#Libertar espaço na Stack
	li $v0, 0		#return 0
	jr $ra			#termina o programa
	
	
#funcção f2c() -> converte temp de fahrenheit para Celsius
#double temp ->  
f2c: 	la $t0,five	
	l.d $f2,0($t0) 		# f4 = 5.0
	la $t0,nine	
	l.d $f4,0($t0) 		# f5 = 9.0
	la $t0,trintad	
	l.d $f6,0($t0) 		# f6 = 32.0
	div.d $f2,$f2,$f4	# 5.0/9.0
	sub.d $f12,$f12,$f6 	# ft - 32.0
	mul.d $f0,$f2,$f12 	#(5.0 / 9.0 * (ft – 32.0)
				# return (5.0 / 9.0 * (ft – 32.0));
	jr $ra			#} fim da sub-rotina
