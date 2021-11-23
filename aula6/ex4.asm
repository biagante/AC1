# Mapa de registos
# i: $t0
# argc: $t1
# argv: $t2
 	.eqv print_str,4
 	.eqv print_int10, 1
 	.data
str1: 	.asciiz "Nr. de parametros: "
str2: 	.asciiz "\nP"
str3: 	.asciiz ": "

	.text
	.globl main
	
main:	move $t1, $a0		# $t1 = argc
	move $t2, $a1		# $t2 = argv
	
	la $a0, str1
	li $v0, print_str
	syscall			# print_str
	
	move $a0, $t1
	li $v0, print_int10
	syscall			# print_int10(argc)
	
	li $t0, 0		# i = 0
for:	bge $t0, $t1, endf	# while(i < argc)
	
	la $a0, str2
	li $v0, print_str
	syscall			# print_str2
	
	move $a0, $t0
	li $v0, print_int10
	syscall			# print_int10(i)
	
	la $a0, str3
	li $v0, print_str
	syscall			# print_str3
	
	sll $t4, $t0,2		# i * 4
	addu $t4, $t2, $t4 	# $t4 = &(argv[i*4])
	lw $t4, 0($t4)		# $t4 = argv[i*4]
	
	move $a0, $t4
	li $v0, print_str
	syscall			# print_str3
	
	addi $t0,$t0, 1		# i++
	j for

endf:	li $v0, 0		# return 0
	jr $ra
