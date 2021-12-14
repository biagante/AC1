	.data
	.eqv print_string, 4
	.eqv print_int10 ,1
	.eqv STR_MAX_SIZE, 30
	.eqv exit_value, $t0
str1:	.asciiz "I serodatupmoC ed arutetiuqrA"
str2:	.space 31		# size + 1 (chars)
str3:	.asciiz "\n"
str4:	.asciiz "String too long: " 
	.text
	#.globl main

main:	addiu $sp,$sp,-4
	sw $ra, 0($sp)
	
	la $a0, str1
	jal strlen

if:	bgt $v0, STR_MAX_SIZE, else
	la $a0, str2
	la $a1, str1
	jal strcpy		# strcpy(str2,str1)
	
	move $t1, $v0
	move $a0, $t1
	li $v0, print_string
	syscall			# print_string(str2)
	
	la $a0, str3
	li $v0, print_string 
	syscall			# print_string("\n")
	
	move $a0, $t1
	jal strrev 		# strrev(str2)
	
	move $a0, $v0
	li $v0, print_string 
	syscall			# print_string(sttrev(str2))
	
	li exit_value, 0	# exit_value = 0
	j end

else:	la $a0, str4
	li $v0, print_string
	syscall
	
	la $a0, str1
	jal strlen
	
	move $a0, $v0
	li $v0, print_int10
	syscall
	
	li exit_value, -1
	
end:	lw $ra, 0 ($sp)
	addiu $sp,$sp,4
	
	move $v0, exit_value	# return exit_value
	jr $ra
		


# funcao strcpy():A função strcpy() (string copy) copia uma string 
#residente numa zona de memória para outra zona de memória
strcpy:	move $t0,$a0 		# dst
 	move $t1,$a1 		# src
 	
stcdo:	lb $t2, 0($t1) 		# $t2 = *src
	sb $t2, 0($t0)		# guarda char em dst
	
        
        addi $t0,$t0,1
        addi $t1,$t1,1		# src++
        bne $t2, '\0', stcdo	# while(*src!= '\0')

	move $v0,$a0 		#  	
 	jr $ra 			# termina a sub-rotina 

