	.data
five:	.double 5.0
nine:	.double 9.0
ttwo:	.double 32.0
zero:	.double 0.0
	.text
	.globl f2c
	.globl average
	.globl max
	.globl median
	
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