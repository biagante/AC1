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
	
main:	addiu $sp,$sp,-4	#reserva espa�o na stack
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
	addiu $sp,$sp,4		#repoem espa�o na stack
	li $v0,0		#return 0
	jr $ra			#termina o programa
	
#fun��o abs()
absl:	move $v0,$a0		
aif:	bge $v0,0,aendif	#if(val >0)
	mul $v0,$v0,-1		#val = -val
aendif:	jr $ra			#fim da sub-rotina

#fun��o xtoy()
#-> calcula o valor de xy , com "x" real e "y" inteiro (positivo ou negativo)
# Mapa de Registos
# $s0 - i
# $s1 - y
# $f20 - result
# $f22 - x
xtoy:	addiu $sp,$sp,-28	#reserva espa�o na stack
	sw $ra,0($sp)		
	sw $s0,4($sp)
	sw $s1,8($sp)
	s.d $f20,12($sp)
	s.d $f22,20($sp)

	li $s0,0		#i = 0
	la $t0,one		# result = 1.0
	l.d $f20,0($t0)		#$f20 = result
	move $s1,$a0		# $s1 = x
	mov.d $f22,$f12		# $f22 = y
	move $a0,$s1
	jal absl			#abs(y)
	move $t1,$v0		#$t1 = abs(y)
	
xyfor:	bge $s0,$t1,xyendfor	#while(i < abs(y))

xyif:	ble $s1, 0, xyelse	#if(y > 0)
	mul.d $f20,$f20,$f22	#result *= x;
	j xyendif
	
xyelse:	div.d $f20,$f20,$f22	#result /= x;

xyendif:
	addi $s0,$s0,1		#i++;
	j xyfor
	
xyendfor:
	mov.d $f0,$f20		#return result
	lw $ra,0($sp)
	lw $s0,4($sp)
	lw $s1, 8($sp)
	l.d $f20, 12($sp)
	l.d $f22,20($sp)
	addiu $sp,$sp,28	#repoem o espa�o na stack
	
	jr $ra			#termina a sub-rotina
	
	
	