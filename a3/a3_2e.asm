# Mapa de registos:
# $t0 – value
# $t1 – bit
# $t2 - i
# $t3 - variável temporária
# $t4 - flag
	.data
str1: 	.asciiz "Introduza um numero: "
str2: 	.asciiz "\nO valor em binário é: "
	.eqv print_string,4
	.eqv read_int,5
	.eqv print_char,11
	.text
	.globl main
main: 	la $a0,str1
	li $v0,print_string 	# (instrução virtual)
	syscall 		# print_string(str1);
	
	li $v0,read_int 	# value=read_int();
	syscall
	or $t0,$v0,$0
	
	la $a0, str2
	li $v0,print_string 	# print_string(str2);
	syscall
	
	li $t2,0 		#i = 0
	li $t4,0 		#flag = 0
	
for: 	bge $t2,32,endfor 	# while(i < 32) {
	andi $t1,$t0,0x80000000 # (instrução virtual)
	srl $t1,$t1,31		# bit = v & 0x80 >> 31
	addi $t1,$t1,0x30	#0x30 + bit
	
	bnez $t4, remove	#if(flag == 1) ||
	bne $t1, 0x30,remove	#bit != 0
	
	j endif
	
remove:	ori $t4,$0,1		#flag = 1
	rem $t3,$t2,4		#temp = (i % 4)	
	bnez $t3, not_space	#flag != 0 
	li $a0,' '
	li $v0,print_char	#print_char(' ');
	syscall
	
	j endif
		
not_space: 	
	move $a0,$t1
	li $v0,print_char 	#print_char(bit)
	syscall
	
endif:	sll $t0,$t0,1		# value = value << 1;			
	addi $t2, $t2,1		# i++;
	j for # }
	
endfor: 	#
	jr $ra # fim do programa
