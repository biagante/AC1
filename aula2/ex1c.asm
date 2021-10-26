 	.data
 	.text
 	.globl main
main: 	ori $t0,$0,0xe543		# substituir val_1 e val_2 pelos
 	ori $t1,$0,0			# valores de entrada desejados
 	#MIPS implements NOT using a NOR with one operand being zero. 
 	nor $t4, $t0, $t1		# $t4 = ~($t0 | $t1) (nor bit a bit)
 	jr $ra 				# fim do programa
