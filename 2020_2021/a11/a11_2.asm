	.data
	.eqv id_number,0
	.eqv first_name,4
	.eqv last_name, 22
	.eqv grade, 40
	.eqv print_string, 4
	.eqv print_intu10,36
	.eqv print_char,11
	.eqv print_float,2
	.eqv read_int, 5
	.eqv read_string, 8
	.eqv read_float, 6
	.eqv MAX_STUDENTS, 4
stg:	.space 44
st_array: .space 
nmec:	.asciiz "\nN. Mec: "
fname:	.asciiz "Primeiro Nome: "
lname:	.asciiz "\nÚltimo Nome: "
nota:	.asciiz "\nNota: "
	.text
	.globl main
	
main:	la $a0, st_array
	li $a1, MAX_STUDENTS
	jal read_data
	jr $ra				#termina o programa

#função read_data(student st, int ns)
read_data:	
	li $t2, 0			#i = 0
	move $t0, $a0			# $t0 = st_array
	move $t1, $a1			# $t1 = ns
	
rdfor:	bge $t2,$t1,rdend	#while(i < ns)
	la $t1,stg
	la $a0, nmec
	li $v0, print_string
	syscall				#print "nmec"
	li $v0, read_int
	syscall				#read_int()
	sw $v0, id_number($t1)		#stg.id_number = read_int() 
	
	la $a0, fname
	li $v0, print_string
	syscall				#print "primeiro nome"
	addiu $a0, $t1, first_name	#buf = stg + offset
	li $a1, 18			#length = 18
	li $v0, read_string
	syscall				#read_string(stg.first_name, 18)
	la $a0, lname
	li $v0, print_string
	syscall				#print "ultimo nome"
	addiu $a0, $t1, last_name	#buf = stg + offset
	li $a1, 15			#length = 15
	li $v0, read_string
	syscall				#read_string(stg.last_name, 15)
	
	la $a0, nota
	li $v0, print_string
	syscall				#print "nota"
	li $v0, read_float
	syscall
	s.s $f0, grade($t1)		#stg.grade = read_float()
	
	addi $t2,$t2,1			#i++
	j rdfor
rdend:	jr $ra		#termina a sub-rotina	