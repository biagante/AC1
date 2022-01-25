	.eqv offset_a1,0
	.eqv offset_g,16
	.eqv offset_a2_0,24
	.eqv offset_a2_1, 28
	.eqv offset_v,32
	.eqv offset_k,36
	
	.eqv print, 3		#print_double

	
	.data
	
s2:	.asciiz "St1"
	.space 6		# 10 - 4 = 6
	.double 3.141592653589
	.word 291
	.word 756
	.byte 'X'
	.float 1.983
	
	.text
	.globl main
	
main:	la $t0, s2

	l.d $f0, offset_g($t0)
	lw $t1, offset_a2_1($t0)
	mtc1 $t1, $f6
	cvt.d.w $f2, $f6
	
	
	l.s $f4, offset_k($t0)
	cvt.d.s $f4, $f4
	
	mul.d $f8, $f0, $f2
	div.d $f12, $f8, $f4
	
	li $v0, print
	syscall
	
	jr $ra