	.data
str0:	.asciiz ", "	
	.text
	.eqv print_string, 4
	.eqv print_int10, 1
	
	.globl insert
	.globl print_array

#A função insert() insere o valor "value" na posição "pos" do "array" 
#de inteiros de dimensão "size
insert:	addiu $sp,$sp,-24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	move $s5, $a0		#$s5 = array
	ble $a2,$a3,ielse	#if(pos > size)
	li $v0, 1		#return 1;
	j iend
	
ielse:	sll $s0, $a3,2		#size*4
	sub $s0,$s0,4		#i = size - 1
	sll $s3, $a2, 2		#pos*4

ifor:	blt $s0, $s3, iendf	#for(i >= pos)
	sll $s1,$s0, 2		#i * 4
	addu $s1,$s5, $s1	#array + i
	lw $s2, 0($s1)		#array[i]
	sw $s2,4($s1)		#array[i + 1] = array[i]
	sub $s0,$s0,4		#i--;
	j ifor

iendf:	sll $s3,$a2,2		#pos*4
	add $s3,$s5,$s3		#array+pos
	sw $a1,0($s3)		#array[pos] = value
	li $v0, 0		#return 0

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addiu $sp,$sp,24

iend:	jr $ra	

# A função print_array() imprime os valores de um array "a" de
#"n" elementos inteiros
print_array:
	move $t7, $a0		#$t0 = a
	sll $a1,$a1,2		#n * 4
	add $t8, $t7, $a1	#p = a + n

ptafor:	bge $t7, $t8, ptaend	#for( a < p )
	lw $t9, 0($t7)		#*a = $t2
	
	move $a0,$t9
	li $v0, print_int10
	syscall			#print_int10(*a);
	
	la $a0, str0
	li $v0, print_string
	syscall			#print_String(", ");
	
	addi $t7,$t7,4		#a++;
	j ptafor

ptaend:	jr $ra			#termina a sub-rotina
