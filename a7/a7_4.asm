#Mapa de registo --> main
#str1 -> $t0
#str2 -> $t1
	.data
str1:	.asciiz "Arquitetura de "
str2:	.space 50
str3:	.asciiz "\n"
str4:	.asciiz "Computadores I"
	.eqv print_string,4
	.text
	#.globl main
	
main:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	
	la $a0, str2
	la $a1, str1
	jal strcpy		#strcopy(str2, str1)
	
	la $a0, str2
	li $v0,print_string
	syscall			#print_string(str2);
	
	la $a0,str3
	li $v0,print_string
	syscall			#print_string("\n");
	
	 la $a0, str2
	 la $a1, str4
	 jal strcat		#strcat(str2, str4);
	 
	 move $a0, $v0
	 li $v0, print_string
	 syscall		#print_string(strcat(str2, str4));
	 
	 lw $ra, 0($sp)
	 addiu $sp,$sp,4	#liberta espaço na stack
	 
	 jr $ra			#termina o programa

#Mapa de registos de strcat
#$a0 -> $0(p)
#$a1 -> $s1
#*p -> $s2
strcat:	addiu $sp,$sp,-16 	#reserva espaço na stack
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	
	move $s0, $a0		#p = dst
	move $s1, $a1		#$s1 = src

while:	lb $s2, 0($s0)		#*p = dst[0]
	beq $s2, '\0', endw	#while(*p != '\0')
	addi $s0,$s0,1		#p++;
	j while

endw:	move $a0,$s0
	move $a1,$s1
	jal strcpy		#strcpy(p,src)
	
	lw $ra,0($sp)		#liberta o espaço na stack
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	addiu $sp,$sp,16
	jr $ra			#termina a sub-rotina