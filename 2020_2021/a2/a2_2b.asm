	.data
	.text
	.globl main
main:	li $t0,0x862a5c1b	#instrução virtual (decomposta 
				#em duas instruções nativas)
	sll $t2,$t0,4		#Shift Left Logical de $t1 por 4 bit
	srl $t3,$t0,4		#Shift Right Logical de $t1 por 4 bit
	sra $t4,$t0,4		#Shift Right Arithmetic de $t1 por 4 bit
	jr $ra			#fim do programa