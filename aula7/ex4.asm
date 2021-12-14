	.data
	.eqv print_string,4
str1:	.asciiz "Arquitetura de "
str2:	.space 50
str3: 	.asciiz "Computadores I"
str4:	.asciiz "\n"
	.text
	.globl main

main:	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, str2
	la $a1, str1
	jal strcpy
	move $t0, $v0
	
	la $a0, str2
	li $v0, print_string
	syscall
	
	la $a0, str4
	li $v0, print_string
	syscall
	
	la $a0, str2
	la $a1, str3
	jal strcat
	
	move $a0, $v0
	li $v0, print_string
	syscall	
	
	lw $ra, 0($sp)
	addiu $sp,$sp,4
	
	li $v0, 0
	jr $ra

# funcao strcat() -> (string concatenate) permite concatenar duas strings
strcat:	addiu $sp,$sp,-16 	#reserva espaço na stack
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	
	move $s0, $a0		#p = dst
	move $s1, $a1		#$s1 = src
 	
stcw:	lb $s2, 0($s0)		#*p = dst[0]
	beq $s2, '\0', stcendw	#while(*p != '\0')
	addi $s0,$s0,1		#p++;
        j stcw
 	
stcendw: move $a0,$s0 		# 
 	move $a1, $s1
 	jal strcpy
 	
 	lw $ra,0($sp) 		# repõe endereço de retorno
 	lw $s0,4($sp) 		# repõe o valor dos registos
 	lw $s1, 8($sp)
 	lw $s2, 12($sp)
 	addiu $sp,$sp,16	# liberta espaço da stack
 	jr $ra 			# termina a sub-rotina 
