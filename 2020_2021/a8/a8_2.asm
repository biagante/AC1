# Mapa de registos
# str: $s0
# val: $s1
# aux: $s2
# O main é, neste caso, uma sub-rotina intermédia
 	.data
str: 	.space 33
str1:	.asciiz "\nInsira um número: "
str2:	.asciiz "Número em binário: "
str3:	.asciiz "\nNúmero em octal: " 
str4:	.asciiz "\nNúmero em hexadecimal: "
 	.eqv STR_MAX_SIZE,33
 	.eqv read_int,5
 	.eqv print_string,4
 	.text
 	#.globl main
main: 	addiu $sp,$sp,-16	# reserva espaço na stack
 	sw $s0,4($sp)		# guarda registos $sx na stack
 	sw $s1,8($sp)
 	sw $s2,12($sp)
 	sw $ra,0($sp) 		# guarda $ra na stack
	la $a0,str		# do {
 	
do:	la  $a0, str1		
	li  $v0, print_string	#print_string(str1);
	syscall			
	
	li  $v0, read_int	
	syscall			
	move $s1, $v0		#val = read_int();
	
	move $a0, $s1		
	li  $a1, 2		
	la  $a2, str		
	jal itoa		#itoa(val, 2, str);
	move $s2, $v0					
	
	la  $a0, str2		
	li  $v0, print_string	#print_string(str2)
	syscall			
	
	move $a0, $s2		
	li  $v0, print_string	
	syscall			
	
	move $a0, $s1		
	li  $a1, 8		
	la  $a2, str		
	jal itoa		#itoa(val, 8, str);
	move $s2, $v0		
	
	la  $a0, str3		
	li  $v0, print_string	#print_string(str3);
	syscall			
	
	move $a0, $s2		
	li  $v0, print_string	#print_string(itoa(val,8,str));)
	syscall			
	
	move $a0, $s1		
	li  $a1, 16		
	la  $a2, str		
	jal itoa		#itoa(val, 16, str);
	move $s2, $v0		
	
	la  $a0, str4		
	li  $v0, print_string	#print_string(str4);
	syscall			
	
	move $a0, $s2		
	li  $v0, print_string	#print_string(itoa(val,16,str));
	syscall			
 	
 	bne $s1,0,do		# } while(val != 0)
	li $s1,0		# return 0;
 	
 	lw $ra,0($sp)		# repõe registo $ra
 	lw $s0,4($sp)		# repoe registos $sx
 	lw $s1,8($sp)
 	lw $s2,12($sp)
 	addiu $sp,$sp,16	# liberta espaço na stack
end: 	jr $ra 			# termina programa 


#função itoa()-> representação do inteiro "n"
#na base "b" (b pode variar entre 2 e 16), colocando o resultado 
#no array de carateres "s",em ASCII
# Mapa de registos -> itoa()
# n: $a0 -> $s0
# b: $a1 -> $s1
# s: $a2 -> $s2
# p: $s3
# digit: $t0
# Sub-rotina intermédia
itoa: 	addiu $sp,$sp,-20	# reserva espaço na stack
	sw $ra,0($sp)
 	sw $s0,4($sp) 		# guarda registos $sx e $ra
 	sw $s1,8($sp)
 	sw $s2,12($sp) 
 	sw $s3,16($sp)  
 	
 	move $s0,$a0 		# copia n, b e s para registos
 	move $s1,$a1		# "callee-saved"
 	move $s2,$a2
 	move $s3,$a2 		# p = s;
itdo: 				# do {
 	rem $t0,$s0,$s1		# digit = n % b;
 	div $s0,$s0,$s1		# n = n / b; 
 	move $a0, $t0		
 	jal toascii		#toascii(digit)
 	sb $v0,0($s3)		#*p++ = toascii(digit)
 	addi $s3,$s3,1		#p++
 	bgt $s0,0,itdo		# } while(n > 0);
 	
 	li $t0,'\0'
 	sb $0,0($s3)		# *p = 0;
 	move $a0,$s2		#
 	jal strrev 		# strrev( s );
 	move $v0,$s2		# return s;
 	
 	lw $ra,0($sp)
 	lw $s0,4($sp)		# repõe registos $sx e $ra
 	lw $s1,8($sp)
 	lw $s2,12($sp)
 	lw $s3,16($sp)
 	addiu $sp,$sp,20	# liberta espaço na stack
 	jr $ra 			# 

#função ascii -> converte os figitos para ASCII 	
#Mapa de registos-> toascii()
#$s0 : v
toascii:addi $a0,$a0,'0'	#v += '0'
	ble $a0, '9', toaend	#if( v > '9' ) 
	addi $a0,$a0,7		#v += 7; // 'A' - '9' - 1 
toaend:	move $v0,$a0		#return v
	jr $ra			#termina a sub-rptina
	
