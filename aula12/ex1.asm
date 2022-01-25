
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
	
	.eqv MAX_STUDENTS, 4
	
	.data
	
st_array:.space 176	# 4 * 44 = 176 (data for 4 stg)

media:	.float 0.0
max_grade: .float -20.0
sum:	.float 0.0	
	
str1:	.asciiz "N. Mec: "
str2:	.asciiz "Nome: "
str3:	.asciiz "Nota: "
str4:	.asciiz "Primeiro Nome: "
str5:	.asciiz "Ultimo Nome: "
str6:	.asciiz "Media: "
str1_s:	.asciiz "\nN. Mec: "
str2_s:	.asciiz "\nNome: "
str3_s:	.asciiz "\nNota: "
	
	.text
	.globl main
	
main:	addiu $sp,$sp,-8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	la $a0, st_array
	li $a1, MAX_STUDENTS 
	jal read_data
	
	la $a0, st_array
	li $a1, MAX_STUDENTS
	la $a2, media
	jal max
	move $s0, $v0
	
	la $a0, str6
	li $v0, print_string 	# print_string("Media: ")
	syscall
	
	la $t0, media
	l.s $f12, 0($t0)
	li $v0, print_float
	syscall			# print_float(media);
	
	move $a0, $s0
	jal print_student
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addiu $sp,$sp,8
	
	li $v0, 0			# return 0
	jr $ra
	
read_data:				
	li $t0, 0			# int = 0;
	move $t4, $a1			# $t4 = MAX_STUDENTS
	move $t1, $a0			# $t1 = &st_array;
	
rd_f:	bge $t0, $t4, rd_e		# for(i = 0; i < ns; i++) {
	la $a0, str1		
	li $v0, print_string	
	syscall				# print_str(N. Mec:);
	li $v0, read_int		# read_int();
	syscall
	
	mul $t2, $t0, 44		
	addu $t2, $t1, $t2		# $t2 = &st[i];
	sw $v0, offset_id($t2)		# st[i].id_number = read_int();
					
	la $a0, str4		
	li $v0, print_string	
	syscall				# print_str(Primeiro nome:);
	addiu $a0, $t2, offset_fn	# $a0 = st[i].first_name;
	li $a1, 17			
	li $v0, read_string	  	# read_str();
	syscall
					
	la $a0, str5		
	li $v0, print_string	
	syscall				# print_str(Ultimo nome: );
	addiu	$a0, $t2, offset_ln	# $a0 = st[i].last_name;
	li $a1, 15			
	li $v0, read_string		# read_str();
	syscall
					
	la $a0, str3		
	li $v0, print_string	
	syscall				# print_str(Nota: );				
	li $v0, read_float		# read_float();
	syscall
	
	addiu $t2, $t2, offset_g	# $t2 = st[i].grade;
	s.s $f0, 0($t2)			# st[i].grade = read_float();
					
	addi $t0, $t0, 1		# i++;
	j rd_f			
rd_e:	jr $ra	

max:	la	$t0, sum		# $t0 = &sum;
	l.s	$f4, 0($t0)		# sum = 0.0;
	la	$t0, max_grade		# $t0 = &max_grade;
	l.s	$f6, 0($t0)		# max_grade = -20.0:
	
	move	$t2, $a2		# $t2 = &media;
	move	$t0, $a0		# $t0 = &st = *p;
	move 	$t4, $a1		# $t4 = ns;
	
	mul	$a1, $a1, 44		# ns = ns * 44 => 176
	addu	$t1, $t0, $a1		# $t1 = &(st[ns]);
	li	$t3, 0			# pmax = 0;
	
m_for:	bge	$t0, $t1, m_e		# for(p = st; p < st[ns]; p++) {
	l.s	$f8, offset_g($t0)	# $t3 = p.grade;
	add.s	$f4, $f4, $f8		# sum = sum + p.grade;
	
m_if:	c.lt.s	$f8, $f6		# if (p.grade > max_grade) {
	bc1t	m_eif			
	mov.s	$f6, $f8		# max_grade = p.grade;
	move	$t3, $t0		# pmax = p;
m_eif:					
	addi	$t0, $t0, 44		# p++;
	j	m_for			
m_e:					
	mtc1	$t4, $f10
	cvt.s.w	$f10, $f10		# (float)ns
	div.s	$f10, $f4, $f10		# $f10 = sum/(float)ns;
	s.s	$f10, 0($t2)		# *media = sum/(float)ns;
	
	move	$v0, $t3		# return pmax;
	jr	$ra					

	
print_student:
	move $t0, $a0

	la $a0, str1_s
	li $v0, print_string
	syscall			# print_string("\nN. Mec: ");
	
	lw $a0, offset_id($t0)
	li $v0, print_intu10
	syscall			# print_intu10(stg.id_number);

	la $a0, str2_s
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
	
	la $a0, str3_s
	li $v0, print_string
	syscall			# print_string(("\nNota: ");
	
	l.d $f12, offset_g($t0)
	li $v0, print_float
	syscall			# print_float(stg.grade);
