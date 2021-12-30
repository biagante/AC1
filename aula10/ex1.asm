	.data
one:	.double 1.0
	.eqv print_string,4
	.eqv print_double,3
	.eqv read_double,7
	.eqv read_int,5
x:	.asciiz "X (real): "
y:	.asciiz "Y (inteiro): "
res:	.asciiz "Result: "
	.text
	#.globl main
	
main:	addiu $sp,$sp,-4	#reserva espaço na stack
	sw $ra,0($sp)
	la $a0,x
	li $v0,print_string
	syscall
	li $v0,read_double
	syscall			#x = read_double()
	mov.d $f12,$f0
	la $a0,y
	li $v0,print_string
	syscall
	li $v0,read_int
	syscall			#y = read_int()
	move $a0,$v0
	
	jal xtoy
	mov.d $f12,$f0
	la $a0,res
	li $v0,print_string
	syscall
	li $v0,print_double
	syscall
	
	lw $ra,0($sp)
	addiu $sp,$sp,4		#repoem espaço na stack
	li $v0,0		#return 0
	jr $ra			#termina o programa

# funcao abs()
absl:	move $v0, $a0
a_if:	bge $v0,0,a_endi	# if (val < 0)
	mul $v0,$v0, -1		# val = -1 * - val
a_endi:	jr $ra	

#função xtoy() calcula o valor de x^y , com "x" real e "y" inteiro (positivo ou negativo)
# float xtoy(float x, int y)
xtoy:	addiu $sp,$sp,-28
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	s.d $f20,12($sp)
	s.d $f22,20($sp)
	
	li $s0,0		# i = 0
	la $t0, one		# result = 1.0
	l.d $f20, 0($t0)	# $f20 = result
	move $s1,$a0		# $s1 = x
	mov.d $f22, $f12	# $f22 = y
	move $a0, $s1		
	jal absl		# absl(y)
	move $t1, $v0		# $t1 = absl(y)

xy_f:	bge $s0, $t1, xy_endf	# for (i < absl(y))

xy_i:	ble $s1, 0, xy_els	# if(y > 0)
	mul.d $f20,$f20,$f22	# result *= x
	j xy_endi

xy_els:	div.d $f20, $f20, $f22	# result /= x

xy_endi:addi $s0,$s0,1		# i++
	j xy_f
	
xy_endf:mov.d $f0,$f20
	lw $ra,0($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	l.d $f20,12($sp)
	l.d $f22,20($sp)
	addiu $sp,$sp,28
	
	jr $ra
	
