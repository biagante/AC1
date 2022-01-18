	.data
	
	.eqv print_string,4
	.eqv print_intu10,36
	.eqv print_char,11
	.eqv print_float,2
	
	.eqv read_string,8
	.eqv read_float,6
	.eqv read_int,5
	
	.eqv offset_id,0
	.eqv offset_fn,4
	.eqv offset_ln,22
	.eqv offset_g,40
	
stg:	.space 44
	
str1:	.asciiz "N. Mec: "
str2:	.asciiz "Nome: "
str3:	.asciiz "\nNota: "
str4:	.asciiz "\nPrimeiro Nome: "
str5:	.asciiz "Ultimo Nome: "

	.text
	.globl main

main:	la $t0, stg

	la $a0, str1
	li $v0, print_string
	syscall			# print_string("\nN. Mec: ");
	
	li $v0, read_int
	syscall			# read_int()
	sw $v0, offset_id($t0)	# stg.id_number = read_int()
	
	la $a0, str1
	li $v0, print_string
	syscall			# print_string("\nN. Mec: ");
	
	lw $a0, offset_id($t0)
	li $v0, print_intu10
	syscall			# print_intu10(stg.id_number);

	la $a0, str4
	li $v0, print_string
	syscall			# print_string("\nPrimeiro Nome: ");
	
	addiu $a0, $t0,offset_fn # stg.first_name = read_string()
	li $a1, 17
	li $v0, read_string
	syscall			# read_string(first_name, 17)
	
	la $a0, str5
	li $v0, print_string
	syscall			# print_string("\nUltimo Nome: ");
	
	addiu $a0, $t0,offset_ln # stg.last_name = read_string()
	li $a1, 14
	li $v0, read_string
	syscall			# read_string(last_name, 17)
	
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
	
	li $v0, read_float
	syscall			# print_float(stg.grade);
	s.s $f0, offset_g($t0)

	la $a0, str3
	li $v0, print_string
	syscall			# print_string(("\nNota: ");
	
	l.d $f12, offset_g($t0)
	li $v0, print_float
	syscall			# print_float(stg.grade);
	
	
	li $v0, 0		# return 0
	jr $ra
