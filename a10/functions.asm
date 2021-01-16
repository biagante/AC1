#functions
	.data
one:	.double 1.0
zero:	.double 0.0
half:	.double 0.5
five:	.double 5.0
nine:	.double 9.0
trintad:.double 32.0
	.text
	.globl absl
	.globl xtoy
	.globl sqrt
	.globl average
	.globl f2c
	.globl max
	
#função absl()
absl:	move $v0,$a0		
aif:	bge $v0,0,aendif		#if(val >0)
	mul $v0,$v0,-1		#val = -val
aendif:	jr $ra			#fim da sub-rotina

#função xtoy()
#-> calcula o valor de xy , com "x" real e "y" inteiro (positivo ou negativo)
# Mapa de Registos
# $s0 - i
# $s1 - y
# $f20 - result
# $f22 - x
xtoy:	addiu $sp,$sp,-28	#reserva espaço na stack
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
	jal absl		#abs(y)
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
	addiu $sp,$sp,28	#repoem o espaço na stack
	
	jr $ra			#termina a sub-rotina

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
	
#função average() -> calcula o valor médio de um array
#formato vírfula flutuante, precisão dupla
average:			#double average(double *array, int n)
	la $t0,zero		#sum = 0.0
	l.d $f0,0($t0)  	#precisão dupla
	move $t0, $a0		# $t0 = array
	move $t1, $a1		# $t1 = n
	
avgfor:	ble $t1,$0, avgend
	addi $t3, $t1,-1	#[i-1]
	sll $t3,$t3,3		#[i-1]*8
	addu $t2,$t0,$t3	#$t2 = &(array[i-1])
	l.d $f2,0($t2)		#$f4 = (double)array[i-1]
	add.d $f0,$f0,$f2	#sum += array[i - 1]
	addi $t1,$t1,-1		#i--;
	j avgfor
	
avgend:	mtc1 $a1,$f4
	cvt.d.w $f4,$f4
	div.d $f12,$f0,$f4	#return sum / (double)n;
	jr $ra 			#end sub-rotina
	
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
	
#double max(double *array, unsigned int n) 
#->calcula o valor máximo de um array de "n"
#elementos em formato vírgula flutuante, precisão dupla
max:	move $t0,$a0		# &(p)
	move $t1,$a1		# n
	addi $t1,$t1,-1		# n--
	sll $t1,$t1,3
	addu $t2,$t0,$t1	#u = &(p[n-1])
	l.d $f0,0($t0)		#max = *p
	addiu $t0,$t0,8		#p++
	
maxfor:	bgt $t0,$t2, maxend	#while(p <= u)
	l.d $f2, 0($t0)		#$f2 = *p
maxif:	c.le.d $f2,$f0		# *p <= max
	bc1t maxfin		#if(*p > max)
	mov.d $f0,$f2		#max = *p
maxfin:	addiu $t0,$t0,8		#p++
	j maxfor
maxend:	jr $ra			#fim da sub-rotina