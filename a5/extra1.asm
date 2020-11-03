#Mapa de registos:
#$t0 - i
#$t1 - j
#$t2 - aux
#$t3 - list[0]
#$t4 - list[i]
#$t5 - list[j]
#$t6 - index list i
#$t7 - index list j
	.data
lista: 	.space 40
str1:   .asciiz "Introduza um número: "
str2: 	.asciiz "; "
str3:	.asciiz "\nConteúdo do array:\n"
	.text
	.eqv SIZE, 10
	.eqv print_string,4
	.eqv read_int, 5
	.eqv print_int10, 1
	.globl main

main:	li $t0,0     			#i=0
	la $t3,lista    
	la $t6,lista 
		
input:	bge $t0,SIZE,prepare_for	#while(
	la $a0,str1
	li $v0,print_string
	syscall				#print_str(str)
	li $v0,read_int
	syscall				#read_int()
	sll $t6,$t0,2
	add $t6,$t6,$t3
	sw $v0,0($t6)
	addi $t0,$t0,1 			#i++
	j input

prepare_for:
	ori $t0,$0,0 			#i=0

first_for:
	bge $t0,9,print
	addi $t1,$t0,1  		#j=i+1
	
second_for:
	bge $t1,10,end_first_for
	sll $t6,$t0,2
	add $t6,$t6,$t3
	sll $t7,$t1,2
	add $t7,$t7,$t3
	lw $t4,0($t6)
	lw $t5,0($t7)
	ble $t4,$t5,end_second_for
	or $t2,$t4,$0
	sw $t5,0($t6)
	sw $t2,0($t7)
	
end_second_for:
	addi $t1,$t1,1 			#j++
	j second_for
	
end_first_for:
	addi $t0,$t0,1 			#i++
	j first_for

print:
	la $t6,lista
	li $t0,0 			#i=0
	la $a0,str3
	li $v0, print_string
	syscall				#print_str()
	
for_print:
	bge $t0,10,end
	sll $t6,$t0,2
	add $t6,$t6,$t3
	lw $a0,0($t6)
	li $v0, print_int10
	syscall				#print_int10()
	la $a0,str2
	li $v0, print_string
	syscall				#print_str("; ")
	addi $t0,$t0,1
	j for_print

end:	jr $ra				#termina programa