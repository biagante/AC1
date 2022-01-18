	.data
	
	.eqv print_string,4
	.eqv print_intu10,36
	.eqv print_char,11
	.eqv print_float,2
	
	.eqv offset_id,0
	.eqv offset_fn,4
	.eqv offset_ln,22
	.eqv offset_g,40
	
stg:	.word 71343
	.asciiz "Napoleao"
	.space 9
	.asciiz "Bonaparte"
	.space 5
	.align 2
	.float 5.1
	
str1:	.asciiz "\nN. Mec: "
str2:	.asciiz "\nNome: "
str3:	.asciiz "\nNota: "

	.text
	#.globl main

main:	la $t0, stg

	la $a0, str1
	li $v0, print_string
	syscall			# print_string("\nN. Mec: ");

	lw $a0, offset_id($t0)
	li $v0, print_intu10
	syscall			# print_intu10(stg.id_number);

	la $a0, str2
	li $v0, print_string
	syscall			# print_string("\nNome: ");
	
	addiu $a0, $t0, offset_ln
	li $v0, print_string
	syscall			# print_string(stg.last_name);
	
	li $a0, ','
	li $v0, print_char
	syscall			# print_char(,)
	
	addiu $a0, $t0, offset_fn
	li $v0, print_string
	syscall			# print_string(stg.first_name);
	
	la $a0, str3
	li $v0, print_string
	syscall			# print_string(("\nNota: ");
	
	l.d $f12, offset_g($t0)
	li $v0, print_float
	syscall			# print_float(stg.grade);
	
	
	li $v0, 0		# return 0
	jr $ra
