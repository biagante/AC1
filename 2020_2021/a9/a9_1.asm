	.data
k:	.float 2.59375
zero:	.float 0.0
line:	.asciiz "\n"
	.eqv print_float, 2
	.eqv print_string, 4
	.eqv read_int, 5 
	.text
	#.globl main
main:				
do:	li $v0, read_int
	syscall			#val = read_int();
	
	la $t0,k
	l.s $f4,0($t0)		#$f4 = 2.59375;
	mtc1 $v0,$f6		#$f6 = val inteiro
	cvt.s.w $f6,$f6		#f6 = (float)val
	mul.s $f12,$f6,$f4	#res = (float)val * 2.59375;
	
	li $v0, print_float
	syscall			#print_float( res );
	la $a0, line
	li $v0, print_string
	syscall
	
	la $t0,zero		
	l.s $f8,0($t0)		#f8 = 0.0
	c.eq.s $f12,$f8		#} while(res != 0.0);
	bc1f do
	li $v0,0		#return 0;
	jr $ra			# termina o programa