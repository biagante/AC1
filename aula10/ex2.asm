	.data
one:	.double 1.0
zero:	.double 0.0
half:	.double 0.5
	.eqv read_double,7
	.eqv print_string,4
	.eqv print_double,3
num:	.asciiz "Insira um número: "
res:	.asciiz "A sua raíz quadrada é: "
	.text
	#.globl main

main:	addiu $sp,$sp,-4	#reserva espaço na stack
	sw $ra,0($sp)
	la $a0,num
	li $v0,print_string
	syscall
	li $v0,read_double
	syscall			#x = read_double()
	mov.d $f12,$f0
	
	jal sqrt		#sqrt(x)
	mov.d $f12,$f0
	la $a0,res
	li $v0,print_string
	syscall
	li $v0,print_double
	syscall			#print_double(sqrt(x))
	
	lw $ra,0($sp)
	addiu $sp,$sp,4		#repoem espaço na stack
	li $v0,0		#return 0
	jr $ra			#termina o programa

#função sqrt() -> cálculo da raiz quadrada - "Babylonian method"
#Mapa de registos
# $f12 -> val
# $f2 -> aux
# $f4 -> xn
# $f6 -> 0.5
# $t0 -> i
sqrt:	la $t0, one
	l.d $f4,0($t0)		#xn = 1.0
	la $t0,half
	l.d $f6,0($t0)		#$f6 = 0.5
	la $t0,zero
	l.d $f8, 0($t0)		#$f8 = 0.0
	li $t0, 0		#i = 0
sqrif:	c.le.d $f12,$f8		#if(val > 0.0)
	bc1t sqrelse	
sqrdo:	mov.d $f2,$f4		#aux = xn
	div.d $f4,$f12,$f2	#xn = val/xn
	add.d $f4,$f4,$f2	#xn = (val/xn) + xn
	mul.d $f4,$f6,$f4	#xn = ((val/xn)+xn) * 0.5
sqrwhile:
	c.eq.d $f2,$f4		#while(aux != xn)
	bc1t sqrendif
	addi $t0,$t0,1		#++i
	blt $t0,25,sqrdo	#while( ++i < 25)
	j sqrendif
sqrelse:	
	mov.d $f4,$f8 		#xn = 0.0
sqrendif:
	mov.d $f0,$f4		#return xn
	jr $ra 			#termina a sub-rotina
	
	