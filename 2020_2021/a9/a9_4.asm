#Mapa de registos:
#$t0 -> i
#$t1 -> &array
	.data
	.eqv SIZE,10
	.eqv print_string,4
	.eqv print_double, 3
	.eqv read_double, 7
array:	.space 80
str1:	.asciiz "Introduza um número: "
str2:	.asciiz "\nValor máximo: "
	.text
	.globl main
main:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,0
	la $t1,array
	
for:	bge $t0,SIZE,endfor	#for(i < SIZE)
	la $a0,str1
	li $v0,print_string
	syscall
	li $v0,read_double 	#read_double()
	syscall
	sll $t3,$t0,3		#n= i*8
	addu $t2,$t1,$t3 	#$t2 = &(aray[n])
	s.d $f0,0($t2)		#array[n] = read_double()
	addi $t0,$t0,1		#i++
	j for

endfor:	move $a0,$t1
	li $a1, SIZE
	jal max			#max(array,SIZE)
	la $a0,str2
	la $a0, str2
	li $v0,print_string
	syscall
	mov.d $f12,$f0
	li $v0, print_double
	syscall
	lw $ra,0($sp)
	addiu $sp,$sp,4
	li $v0,0
	jr $ra			#fim do programa
	

#double max(double *array, unsigned int n) 
#->calcula o valor máximo de um array de "n"
#elementos em formato vírgula flutuante, precisão dupla
max:	move $t0,$a0		# &(p)
	move $t1,$a1		# n
	addi $t1,$t1,-1		# n--
	sll $t1,$t1,3
	addu $t2,$t0,$t1	#u = &(p[n-1])
	l.d $f0,0($t0)		#max = *p
	addiu $t0,$t0,8		#p++
	
maxfor:	bgt $t0,$t2, maxend	#while(p <= u)
	l.d $f2, 0($t0)		#$f2 = *p
maxif:	c.le.d $f2,$f0		# *p <= max
	bc1t maxfin		#if(*p > max)
	mov.d $f0,$f2		#max = *p
maxfin:	addiu $t0,$t0,8		#p++
	j maxfor
maxend:	jr $ra			#fim da sub-rotina