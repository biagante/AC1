	.data
	.text
	.globl main
main:	ori $t0,$0,15		#colocar no imm o valor a transformar (gray)
	move $t1,$t0		#num = gray
	srl $t2, $t1, 4 	#num = num >> 4
	xor $t1, $t1, $t2	#num = num ^ (num >> 4)
	srl $t2, $t1, 2		#num = num >> 2
	xor $t1, $t1, $t2	#num = num ^ (num >> 2)
	srl $t2, $t1, 1 	#num = num >> 1
	xor $t1, $t1, $t2	#num = num ^ (num >> 1)
	move $t2, $t1		#bin = num
	jr $ra			#fim do programa
	
	#temos $t0-gray $t1-num $t2-bin 