	.globl div_i
#funcao div -> divisao de numeros inteiros para operandos de 16 bits
# int div (unsg int dividendo, unsg int divisor)	
div_i:	sll $t1,$a1,16			# divisor = divisor << 16
	andi $t0,$a0, 0xFFFF		# dividendo = dividendo & 0xFFFF
	sll $t0,$t0, 1			# dividendo << 1
	li $t2, 0			# i = 0
	
d_for:	bge $t2, 16, d_endf		# for (i < 16)
	li $t3, 0			# bit = 0
	
d_if:	blt $t0,$t1, d_endi		# if(dividendo >= divisor)
	sub $t0,$t0,$t1			# dividendo = dividendo - divisor
	li $t3, 1			# bit = 1
	
d_endi:	sll $t0,$t0, 1			# dividendo << 1
	or $t0, $t0, $t3		# dividendo | bit 
	j d_for

d_endf:	addi $t2,$t2,1			# i++
	srl $t4, $t0, 1			# resto = dividendo >> 1
	andi $t4, $t4, 0xFFFF0000	# resto and resto
	andi $t5, $t1, 0xFFFF		# quociente = dividendo & 0xFFFF
	or $v0, $t5,$t4			# return (resto | quociente)
	jr $ra
	