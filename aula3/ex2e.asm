# Mapa de registos:
# $t0 – value
# $t1 – bit
# $t2 - i
# $t3 - flag

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
 	li $t3, 0			# flag = 0
 	
for: 	bge $t2,32,endfor 		# while(i < 32) {
	srl $t1,$t0,31			# bit = value >> 31; 

if:	seq $t4,$t3,1			# flag == 1
	sne $t5,$t1,0			# bit != 0
	or $t6,$t4,$t5			# (flag == 1 || bit != 0) 
	bne $t6,1, endif		# if this not 1	
	ori $t3,$t3,1			# flag = 1

divif:	rem $t7,$t2,4			# i % 4
	bne $t7,$0,enddiv		# if(i % 4)==0{
	li $a0, ' '
	li $v0, print_char
	syscall				# print_char(' ')
	
enddiv:	
 	addi $t1,$t1,0x30		# 0x30 + bit
 	move $a0,$t1 
 	li $v0, print_char
 	syscall				# print_char(0x30 + bit);
 	
endif: 	sll $t0,$t0,1			#value = value << 1
 	addi $t2,$t2,1			# i++;
 	j for 				# }
 	
endfor: 				#
 	jr $ra 				# fim do programa