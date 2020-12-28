	.data
zero:	.double 0.0	
	.eqv SIZE, 10
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
