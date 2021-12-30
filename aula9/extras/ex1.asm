	.data
	.eqv SIZE, 11
	.eqv print_string, 4
	.eqv print_double, 3
	.eqv read_double, 7
	.eqv TRUE,1
	.eqv FALSE,0
arr:	.space	88
	.align 3
str1:	.asciiz "Introduza um número: "
str2:	.asciiz "\nValor mediano: "
str3:	.asciiz "\nArray ordenado: "
str4:	.asciiz ", "
	.text
	.globl main
	
# Mapa de Registos
# $t0 - i
# $t1 - &arr
	
main:	addiu	$sp, $sp, -8		# poem espaco na pilha
	sw	$ra, 0($sp)		# guarda o $ra
	sw	$s0, 4($sp)		# guarda o $s0
	li	$t0, 0			# i = 0;
	la	$t1, arr		# $t1 = &arr;
	move	$s0, $t1		# $s0 = &arr;
	
# PREENCHER ARRAY
for:	bge	$t0, SIZE, endfor	# for(i = 0; i < SIZE; i++) {
	la	$a0, str1		# $a0 = str1;
	li	$v0, print_string	# $v0 = 4;
	syscall				# print_string(str1);
	li	$v0, read_double	# $v0 = 7;		
	syscall				# read_double();
	sll	$t3, $t0, 3		# n = i*8
	addu	$t2, $t1, $t3		# $t2 = &(arr[n])
	s.d	$f0, 0($t2)		# arr[n] = read_double();
	addi	$t0, $t0, 1		# i++;
	j	for			

# CALCULO DA MEDIANA	
endfor:	move	$a0, $t1		# arg1 = &arr;
	li	$a1, SIZE		# arg2 = SIZE;
	jal	median			# median(arr, SIZE);
	la	$a0, str2		# $a0 = str2;
	li	$v0, print_string	# $v0 = 4;
	syscall				# print_string(str2);
	mov.d	$f12, $f0		# $f12 = return(median);
	li	$v0, print_double	# $v0 = 3
	syscall				# print_double(return(max));
	
# ARRAY ORDENADO
	li	$t0, 0			# i = 0;
	move	$t1, $s0		
	la	$a0, str3		# $a0 = str3;
	li	$v0, print_string	# $v0 = 4;
	syscall				# print_string(str3);
	
for1:	bge	$t0, 88, endfor1	# for(i = 0; i < SIZE; i++) {
	addu	$t4, $t1, $t0		# $t4 = &(array[i]);
	l.d	$f12, 0($t4)		
	li	$v0, print_double	
	syscall				# print_double(array[i]);
	la	$a0, str4		# $a0 = str4
	li	$v0, print_string	# $v0 = 4
	syscall				# print_string(str4);
	addi	$t0, $t0, 8		# i++;
	j	for1			
	
endfor1:lw	$ra, 0($sp)		# repoem o valor de $ra
	lw	$s0, 4($sp)		# report valor de $s0
	addiu	$sp, $sp, 8		# repoem o tamnhao da pilha
	li	$v0, 0			# return 0;
	jr	$ra			# } fim do programa

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