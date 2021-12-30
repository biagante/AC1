	.data
zero:	.double 0.0
	.eqv SIZE, 11
	.eqv read_int, 5
	.eqv print_double, 3
	.eqv print_string, 4
a:	.space 80
	.text
	#.globl main
main:	addiu	$sp, $sp, -20	#reserva espaço na stack
	sw $ra, 0($sp)		#guarda o $ra
	la $t1, a		#$t1 = &a;
	li $t0, 0		#i = 0;
	
for:	bge $t0, SIZE, endfor	#for(i = 0; i < SIZE; i++) {
	sll $t2, $t0, 3		#aux = i*8;
	addu $t3, $t1, $t2	#$t3 = &(a[i]);
	
	li $v0, read_int			
	syscall			
	mtc1 $v0, $f2		#$f2 = $v0
	cvt.d.w	$f2, $f2	#$f2 = (double)$v0
	s.d $f2, 0($t3)		#a[i} = (double)$v0;
	
	addi $t0, $t0, 1	#i++;
	j for
				
endfor:	la $a0, a		#$a0 = a;
	li $a1, SIZE		#$a1 = SIZE;
	jal average		#average(a, SIZE);
	li $v0, print_double			
	syscall			#print_double();
					
	lw $ra, 0($sp)	
	addiu $sp, $sp, 20	#repoe stack
	li $v0, 0		#return 0;
	jr $ra			# fim do programa
	
	
#função var() -> calcula a variância
# Mapa de registos
# $t0 - i
# $t1 - &array
# $t2 - i*8
# $t3 - &(array[i])
# $f2 - soma
# $f4 - media
# $f12 - array[i] - media
# $f0 - res
var:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	la $t0,zero 		#$t0 = 0.0
	l.d $f2,0($t0)
	li $t0, 0		#i = 0
	jal average		#average(array,nval)
	mov.d $f4,$f0		#media = average(array, nval);
	move $t1,$a0		#$t1 = &array
	
vfor:	bge $t0,$a1,endfor	#while(i < nval)
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
