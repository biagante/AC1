	.data
str1:	.asciiz "I serodatupmoC ed arutetiuqrA"
str2:	.space 31
str3:	.asciiz "\n"
str4:	.asciiz "String demasiado comprida: "
	.eqv SIZE,30	
	.eqv MAX_SIZE, 31
	.eqv print_string,4
	.eqv print_int10,1
	.text
	#.globl main
	
main:	addiu $sp, $sp, -4		#reservar espaço na Stack
	sw  $ra, 0($sp)			#guardar o valor de $ra
	
	la  $a0, str1			#str1
	jal strlen			#strlen(str1);
if:	bgt $v0, MAX_SIZE,else		#if(strlen(str1)) <= MAX_SIZE
	la $a0,str2
	la $a1,str1
	jal strcpy			#strcopy(str2, str1);
	
	move $t1, $v0
	move $a0, $t1
	li $v0, print_string
	syscall				#print_string(strcopy(str2, str1));
	
	la $a0, str3
	li $v0, print_string
	syscall				#print_string("\n")
	
	move $a0,$t1
	jal strrev			#strrev(str2);
	
	move $a0, $v0
	li $v0,print_string
	syscall				#print_string(strrev(str2));
	
	li $t0, 0			#exit_value = 0
	j end
	
else:	la $a0, str4
	li $v0, print_string		
	syscall 			#print_string(str4);
	
	la $a0, str1
	jal strlen			#strlen(str1);
	
	move $a0, $v0
	li $v0,print_int10
	syscall				#print_int10(strlen(str1));
	
	li $t0, -1			#exit_value = -1
	
end:	lw $ra, 0($sp)
	addiu $sp,$sp,4			#reserva espaço na stack
	
	move $v0,$t0			#return exit_value
	jr $ra				#termina o programa

#função strcpy() -> copia uma string
#Mapa de Registos
#$a0 -> $s0(dst) 
#$a1 -> $s1(src)
#$t0 -> i
#$t1 -> dist+i
#$t2 -> src+i
#$t3 -> dist[i]
strcpy:	addiu $sp,$sp,-8	#reserva espaço na stack
	sw $s0, 0($sp)		#guarda valor registo $s0
	sw $s1, 4($sp)		#guarda valor registo $s1
	
	li $t0, 0 		#int i = 0
	move $s0,$a0		#$s0 = dst
	move $s1,$a1		#$s1 = src
	
stydo:	addu $t1,$s0,$t0 	#dst + i
	addu $t2,$s1,$t0	#src + i	
	lb $t3, 0($t2)		#src[i]
	sb $t3, 0($t1)		#dst[i]
	addi $t0,$t0,1		#i++
	bne $t3, '\0',stydo	#while(src[i++] != '\0');
	
	move $v0,$s0		#$v0 = dst
	lw $s0, 0($sp)		
	lw $s1, 4($sp)		
	addiu $sp,$sp,8		# liberta espaço na stack
	jr $ra			#termina a sub-rotina
