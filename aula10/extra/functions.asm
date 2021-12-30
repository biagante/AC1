	.data
five:	.double 5.0
nine:	.double 9.0
ttwo:	.double 32.0
zero:	.double 0.0
one:	.double 1.0
half:	.double 0.5
	.eqv TRUE, 1
	.eqv FALSE, 0
	.text
	.globl f2c
	.globl average
	.globl max
	.globl median
	.globl absl
	.globl xtoy
	.globl sqrt
	.globl var
	.globl stdev
	
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
	
#função average() -> calcula o valor médio de um array
average: la $t0, zero		# sum = 0.0
	 l.d $f0, 0($t0)
	 move $t0, $a0		# $t0 = array
	 move $t1, $a1		# $t1 = n
	 
avgf:	ble $t1, $0, avgend	# for (i > 0)
	addi $t3, $t1, -1	# [i - 1]
	sll $t3,$t3,3		# [i - 1] * 8
	addu $t2,$t0, $t3	# $t2 = &(array[i-1])
	l.d $f2, 0($t2)		# $f4 = (double)array[i-1]
	add.d $f0, $f0,$f2	# sum += array[i - 1]
	addi $t1, $t1, -1	# i--
	j avgf
	
avgend:	mtc1 $a1, $f4
	cvt.d.w	$f4, $f4
	div.d $f12, $f0, $f4	# return sum / (double) n
	
	jr $ra
	
# max() calcula o valor máximo de um array de "n" elementos
# max(double *p, unsigned int n)
max:	move $t0,$a0		# &(p)
	move $t1,$a1		# n
	addi $t1,$t1,-1		# n--
	sll $t1,$t1,3		# n * 8
	addu $t2,$t0,$t1	# u = &(p+[n-1])
	l.d $f0,0($t0)		# max = *p
	addiu $t0,$t0,8		# p++
	
maxfor:	bgt $t0,$t2, maxend	# while(p <= u)
	l.d $f2, 0($t0)		# $f2 = *p
maxif:	c.le.d $f2,$f0		# *p <= max
	bc1t maxfin		# if(*p > max)
	mov.d $f0,$f2		# max = *p
maxfin:	addiu $t0,$t0,8		# p++
	j maxfor
maxend:	jr $ra			# fim da sub-rotina

# calcula a mediana dos valores de um array de quantidades reais,
# codificadas em precisão dupla
median:	move	$t0, $a0		# $t0 = &array
	move	$t1, $a1		# $t1 = nval
	
m_do:	li	$t2, FALSE		# houveTroca = FALSE;
	li	$t3, 0			# i = 0;
	addi	$t4, $t1, -1		# $t4 = nval-1;
	sll	$t4, $t4, 3		# $t4 = (nval-1)*8;
	
m_for:	bge	$t3, $t4, m_w		# for(i = 0; i < nval-1; i++) {

m_if:	addu	$t5, $t0, $t3		# $t5 = &(array[i]);
	l.d	$f2, 0($t5)		# $f2 = array[i];
	l.d	$f4, 8($t5)		# $f4 = array[i+1];
	c.le.d	$f2, $f4		# if(array[i} > array[i+1]) {
	bc1t	m_endi			
	mov.d	$f6, $f2		# aux = array[i];
	s.d	$f4, 0($t5) 		# array{i] = array[i+1];
	s.d	$f6, 8($t5)		# array[i+1] = aux;
	li	$t2, TRUE		# houveTroca = TRUE;
	
m_endi:	addi	$t3, $t3, 8		# i++;
	j	m_for							
		
m_w:	beq	$t2, TRUE, m_do		# while(houveTroca == TRUE);
	rem	$t6, $t1, 2		# nval % 2
m_if2:	beq	$t6, 0, m_endi2		# if (nval % 2 != 0) {
	addi	$t1, $t1, -1		# nval --
	
m_endi2:sll	$t1, $t1, 3		# nval = nval * 8
	srl	$t1, $t1, 1		# nval/2
	addu	$t5, $t0, $t1		# $t5 = &(array[nval/2]);
	l.d	$f0, 0($t5)		# return array[nval/2];
	
	jr	$ra			# } fim do programa
	
# funcao absl()
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
	
#função sqrt() -> cálculo da raiz quadrada - "Babylonian method"
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
	
#função var() -> calcula a variância
var:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	la $t0,zero 		#$t0 = 0.0
	l.d $f2,0($t0)
	li $t0, 0		#i = 0
	jal average		#average(array,nval)
	mov.d $f4,$f0		#media = average(array, nval);
	move $t1,$a0		#$t1 = &array
	
vfor:	bge $t0,$a1,vendfor	#while(i < nval)
	sll $t2,$t0,3		# i = i*8
	addu $t3,$t1,$t2	#$t3 = &(array[i])
	l.d $f12,0($t3)
	sub.d $f12,$f12,$f4
	li $a0,2
	jal xtoy
	add.d $f2,$f2,$f0
	addi $t0,$t0,1
	j vfor
vendfor:
	lw $ra,0($sp)
	addiu $sp,$sp,4
	jr $ra			#fim da sub-rotina
	
#função stdev() -> calcula o desvio padrão
stdev:	addiu $sp,$sp,-4	#reseva espaço na stack
	sw $ra,0($sp)
	jal var			#var(double *array, int nval)
	mov.d $f12,$f0
	jal sqrt		#sqrt( var(array, nval)
	lw $ra,0($sp)
	addiu $sp,$sp,4		#repoem espaço na stack
	jr $ra			#fim da sub-rotina
