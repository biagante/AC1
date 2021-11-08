# Mapa de registos:
# $t0 – value
# $t1 – bit
# $t2 - i
 	.data
str1: 	.asciiz "Introduza um numero: "
str2: 	.asciiz "\nO valor em binário e': "
 	.eqv print_string,4
 	.eqv read_int,5
 	.eqv print_char,11
 	.text
 	.globl main
main: 	la $a0,str1
 	li $v0,print_string 		# (instrução virtual)
 	syscall 			# print_string(str1);
 	
 	ori $v0,$0,read_int
 	syscall 				
 	or $t0,$v0,$0			# value=read_int();
 	
 	la $a0,str2
 	li $v0,print_string 		# (instrução virtual)
 	syscall  			# print_string("...");
 	
 	li $t2,0 			# i = 0
 	
for: 	bge $t2,32,endfor 		# while(i < 32) {

divif:	rem $t3,$t2,4			# i % 4
	bne $t3,$0,enddiv		# if(i % 4)==0{
	li $a0, ' '
	li $v0, print_char
	syscall
	
enddiv:	andi $t1,$t0,0x80000000 	# (instrução virtual)

 	srl $t1,$t1,31			# bit = (value & 0x80000000) >> 31; 
 	addi $t1,$t1,0x30		# 0x30 + bit
 	move $a0,$t1 
 	li $v0, print_char
 	syscall				# print_char(0x30 + bit);
 	
 	sll $t0,$t0,1
 	addi $t2,$t2,1			# i++;
 	j for 				# }
 	
endfor: 				#
 	jr $ra 				# fim do programa