	.data
zero:	.double 0.0
	.eqv SIZE, 10
	.eqv read_int, 5
	.eqv print_double, 3
	.eqv print_string, 4
a:	.space 80

	.text
	#.globl main
	
main:	addiu $sp,$sp, -4
	sw $ra, 0($sp)
	
	la $t1, a			# static double a[SIZE]; 
	li $t0, 0			# i = 0
	
for:	bge $t0, SIZE, endfor		# for(i < SIZE)
	sll $t2,$t0,3			# $t2 = i * 8
	addu $t3, $t1, $t2		# $t3 = a + i
	
	li $v0, read_int
	syscall				# read_int()
	mtc1 $v0, $f2			# move to coprocessor1
	cvt.d.w $f2, $f2		# convert to double
	s.d $f2, 0($t3)			# store as a[i]=(double)read_int()
	
	addi $t0,$t0,1			# i++
	j for
	
endfor: la $a0, a
	li $a1, SIZE
	jal average			# average(a, SIZE)
	li $v0, print_double
	syscall				# print_double(avg)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	
	li $v0, 0
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
