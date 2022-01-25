	.eqv offset_a1,0
	.eqv offset_i,16
	.eqv offset_a2,20
	.eqv offset_g,40
	
	.eqv print, 3		#print_double

	
	.data
	
s1:	.asciiz "Str_1"
	.space 8		# 14 - 6 = 8
	.word 2021
	.asciiz "Str_2"
	.space	11		# 17 - 6 = 11
	.double 2.718281828459045
	
	.text
	.globl main
	
main:	la $t0, s1

	l.d $f12, offset_g($t0)
	li $v0, print
	syscall
	
	jr $ra
	
	
	