	.data
	.eqv read_int, 5
	.eqv print_string, 4
	.eqv print_int10, 1
array:	.space 50
str1:	.asciiz "Size of array: "
str2:	.asciiz "array["
str3: 	.asciiz "] = "
str4:	.asciiz "Enter the value to be inserted: "
str5:	.asciiz "Enter the position: "
str6:	.asciiz "\nOriginal array: "
str7:	.asciiz "\nModified array: "
	.text
	
	.globl main
	
main:	addiu $sp,$sp,-4	#reserva espaço na stack
	sw $ra, 0($sp)
	
	la $a0,str1
	li $v0, print_string
	syscall			#print_String(str1)
	
	li $v0, read_int
	syscall			#array_size = read_int()
	move $t1, $v0		#$t1 = array_size
	li $t0, 0		# i = 0
	
for:	bge $t0, $t1, endfor	#for(i < array_size)
	la $a0, str2
	li $v0, print_string
	syscall			#print_string(str2)
	
	move $a0, $t0
	li $v0, print_int10
	syscall			#print_int10(i)
	
	la $a0,str3
	li $v0, print_string
	syscall			#print_string(str3)
	
	sll $t5,$t0,2		#i * 4
	la $t4, array		#array
	add $t4,$t4,$t5		#array + i
	li $v0, read_int
	syscall			#read_int()
	sw $v0, 0($t4)		#array[i] = $v0
	
	addi $t0, $t0, 1	#i++;
	j for
	
endfor:	la $a0, str4
	li $v0, print_string
	syscall			#print_string(str4)
	
	li $v0, read_int
	syscall			#read_int()
	move $t2, $v0		#insert_value = read_int()
	
	la $a0,str5
	li $v0, print_string
	syscall			#print_string(str5)
	
	li  $v0, read_int	#read_int
	syscall				
	move $t3, $v0		#insert_pos = read_int();
	
	la $a0, str6
	li $v0, print_string
	syscall			#print_string(str6)
	
	la $a0, array
	move $a1, $t1
	jal print_array		#print_array(array,array_size)
	
	la  $a0, array			
	move $a1, $t2			
	move $a2, $t3			
	move $a3, $t1	
	jal insert		#insert(array, insert_value, insert_pos, array_size);
	
	la  $a0, str7			
	li  $v0, print_string		
	syscall			#print_string(str7);
	
	la  $a0, array			
	move $a1, $t1			
	jal print_array		#print_array(array, array_size);
				
	lw  $ra, 0($sp)		 
	addiu $sp, $sp, 4	#Libertar espaço na stack
	li  $v0, 0		#return 0
	jr  $ra			#Fim do programa
	
