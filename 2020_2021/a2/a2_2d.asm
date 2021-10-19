	.data
	.text
	.globl main
main:	ori $t0,$0,5		#colocar no imm o valor a transformar (bin)
	srl $t2,$t0,1		#Shift Right Logical de $t1 por 1 bit
	xor $t1,$t0,$t2		#xor dos valores de srl e do valor og 
				#obtendo-se assim código gray
	jr $ra			#fim do programa