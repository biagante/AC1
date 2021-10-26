	.data
	.text
	.globl main
main: 	li $t0,4		#load número a converter

 	srl  $t1,$t0,1 		# bin >> 1
 	xor $t1,$t0,$t1		# bin ^(bin >> 1)
 				# gray = bin ^(bin >> 1)
 	jr $ra 			# fim do programa