	.data
	.eqv id_number,0
	.eqv first_name,4
	.eqv last_name, 22
	.eqv grade, 40
	.eqv print_string, 4
	.eqv print_intu10,36
	.eqv print_char,11
	.eqv print_float,2
	
stg:	.word 72343
	.asciiz "Napoleão"
	.space 9
	.asciiz "Bonaparte"
	.space 5
	.float 5.1
nmec:	.asciiz "\nN. Mec: "
nome:	.asciiz "\nNome: "
nota:	.asciiz "\nNota: "
	.text
	#.globl main
	
main:	la $t1,stg
	la $a0, nmec
	li $v0, print_string
	syscall				#print "nmec"
	lw $t0, id_number($t1)  	#stg.id_number
	move $a0, $t0
	li $v0, print_intu10
	syscall
	  
	la $a0, nome
	li $v0, print_string
	syscall				#print "nome"
	
	addiu $a0, $t1, last_name
	li $v0, print_string
	syscall				#stg.last_name
	
	li $a0, ','
	li $v0, print_char
	syscall
	
	addiu $a0, $t1, first_name
	li $v0, print_string
	syscall				#stg.first_name
	  
	la $a0, nota
	li $v0, print_string
	syscall  			#print "nota"
	
	l.s $f12, grade($t1)		#stg.grade
	li $v0, print_float
	syscall
	
	li $v0, 0			#return 0
	jr $ra				#termina o programa