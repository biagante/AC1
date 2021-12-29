	.data
str1:	.space 101
str2:	.space 51
stra:	.asciiz "Enter a string: "
strb:	.asciiz "Enter a string to insert: "
strc:	.asciiz "Enter the position: "
strd:	.asciiz "Original string: "
stre:	.asciiz "\nModified string: "
strs:	.asciiz "\n"

	.eqv print_string,4
	.eqv read_string,8
	.eqv read_int, 5
	
	.text
	#.globl main
	
main:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	
	la $a0, stra
	li $v0, print_string
	syscall			# print_string("Enter a string: "); 
	
	la $a0, str1
	li $a1, 50
	li $v0, read_string
	syscall			# read_string(str1, 50); 
	
	la $a0, strb
	li $v0, print_string
	syscall			# print_string("Enter a string to insert: "); 
	
	la $a0, str2
	li $a1, 50
	li $v0, read_string
	syscall			# read_string(str2, 50); 
	
	la $a0, strc
	li $v0, print_string
	syscall			# print_string("Enter the position: ");
	
	li $v0, read_int
	syscall			# read_int()
	move $t0, $v0		# insert_pos = read_int
	
	la $a0, strd
	li $v0, print_string
	syscall			# print_string("Original string: "); 
	
	la $a0, str1
	li $v0, print_string
	syscall			# print_string(str1)
	
	la $a0, str1
	la $a1, str2
	move $a2, $t0		# $t0 = insert_pos
	jal insert		# insert(str1 , str2, insert_pos)
	
	la $a0, stre
	li $v0, print_string
	syscall			# print_string("\nModified string: "); 
	
	la $a0, str1
	li $v0, print_string
	syscall			# print_string(str1)
	
	la $a0, strs
	li $v0, print_string
	syscall			# print_string("\n"); 
	
	lw $ra, 0($sp)
	addiu $sp,$sp,4
	
	li $v0,0		# return 0
	jr $ra