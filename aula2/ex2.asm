	.data
	.text
	.globl main
main: 	li $t0,0x862A5C1B	# instru��o virtual (decomposta
 				# em duas instru��es nativas)
 	sll $t2,$t0,4 		# shift left logical	
 	srl $t3,$t0,4 		# shift right logical
 	sra $t4,$t0,4 		# shift right arithmetic
 	jr $ra 			# fim do programa