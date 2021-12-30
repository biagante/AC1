	.data
five:	.double 5.0
nine:	.double 9.0
ttwo:	.double 32.0
	
	.eqv read_double, 7
	.eqv print_double, 3
	
	.text
	#.globl main
	
main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, read_double		# ler valor do teclado
	syscall
	mov.d $f12,$f0			# f2c(input)
	jal f2c
	
	li $v0, print_double	
	syscall				# print_double()
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	
	li $v0, 0
	jr $ra
	
#funcção f2c() -> converte temp de fahrenheit para Celsius	
f2c:	la $t0, five
	l.d $f2,0($t0)		# $f2 = 5.0
	la $t0, nine		
	l.d $f4,0($t0)		# $f4 = 9.0
	la $t0, ttwo
	l.d $f8,0($t0)		# $f8 = 32.0
	div.d $f2, $f2, $f4 	# $f2 = 5.0/9.0
	sub.d $f12, $f12, $f8	# $f12 = ft - 32.0
	mul.d $f12, $f12, $f2 	# #f12 = (ft - 32.0) * (5.0/9.0)
	
	jr $ra
	
	
