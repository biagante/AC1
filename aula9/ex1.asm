	.data
k1:	.float 2.59375
k2:	.float 0.0
space:	.asciiz " \n"
	.eqv read_int,5
	.eqv print_float, 2
	.eqv print_string, 4
	.text
	#.globl main
	
main:
do:	li $v0, read_int	# val = read_int();
	syscall			
	move $t0, $v0		# $t0 = val
	l.s $f2, k1		# load single precision
	mtc1 $t0, $f0		# $f0 = val
	cvt.s.w $f0,$f0
	mul.s $f2,$f2,$f0	# $f2 = val * 2.59375
	mov.s $f12,$f2
	li $v0, print_float
	syscall			# print_float( res ); 
	
	la $a0, space
	li $v0, print_string
	syscall			# (for readability)
	
	l.s $f2, k2
	c.eq.s $f0, $f2		# while(res != 0.0)
	bc1t fim
	j do
	
fim:	li $v0, 0		# return 0
	jr $ra
	
