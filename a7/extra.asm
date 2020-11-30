#Mapa de Registos --> main
#$t0:	i
#$t1:	array_size
#$t2:	insert_value
#$t3:	insert_pos
#$t4:	array+i
#$t5: 	i*4
	.data
array:	.space 50
str0:	.asciiz ", "
str1:	.asciiz "Tamanho do array: "
str2:	.asciiz "array["
str3:	.asciiz "] = "
str4:	.asciiz "Insira o valor a ser introduzido: "
str5:	.asciiz "Insira a posição: "
str6:	.asciiz "\nArray original: "
str7:	.asciiz "\nArray modificado: "
	.eqv print_int10,1
	.eqv print_string,4
	.eqv read_int,5
	.text
	.globl main
	
main:	addiu $sp,$sp,-4	#reserva espaço na stack
	sw $ra, 0($sp)
	
	la $a0,str1
	li $v0, print_string
	syscall			#print_String(str1)
	
	li $v0, read_int
	syscall			#array_size = read_int()
	move $t1, $v0		#$t1 = array_size
	li $t0, 0		# i = 0
	
for:	bge $t0, $t1, endfor	#for(i < array_size)
	la $a0, str2
	li $v0, print_string
	syscall			#print_string(str2)
	
	move $a0, $t0
	li $v0, print_int10
	syscall			#print_int10(i)
	
	la $a0,str3
	li $v0, print_string
	syscall			#print_string(str3)
	
	sll $t5,$t0,2		#i * 4
	la $t4, array		#array
	add $t4,$t4,$t5		#array + i
	li $v0, read_int
	syscall			#read_int()
	sw $v0, 0($t4)		#array[i] = $v0
	
	addi $t0, $t0, 1	#i++;
	j for
	
endfor:	la $a0, str4
	li $v0, print_string
	syscall			#print_string(str4)
	
	li $v0, read_int
	syscall			#read_int()
	move $t2, $v0		#insert_value = read_int()
	
	la $a0,str5
	li $v0, print_string
	syscall			#print_string(str5)
	
	li  $v0, read_int	#read_int
	syscall				
	move $t3, $v0		#insert_pos = read_int();
	
	la $a0, str6
	li $v0, print_string
	syscall			#print_string(str6)
	
	la $a0, array
	move $a1, $t1
	jal print_array		#print_array(array,array_size)
	
	la  $a0, array			
	move $a1, $t2			
	move $a2, $t3			
	move $a3, $t1	
	jal insert		#insert(array, insert_value, insert_pos, array_size);
	
	la  $a0, str7			
	li  $v0, print_string		
	syscall			#print_string(str7);
	
	la  $a0, array			
	move $a1, $t1			
	jal print_array		#print_array(array, array_size);
				
	lw  $ra, 0($sp)		 
	addiu $sp, $sp, 4	#Libertar espaço na stack
	li  $v0, 0		#return 0
	jr  $ra			#Fim do programa

#Mapa de Registos --> insert
#$a0:	array -> $t5
#$a1:	value
#$a2:	pos
#$a3:	size
#$t0:	i
#$t1:	array+i
#$t2:	array[i]
#$t3:	array+pos
#$t4:	array[pos]	
insert:	addiu $sp,$sp,-24	#reserva espaço
	sw  $s0, 0($sp)			
	sw  $s1, 4($sp)			
	sw  $s2, 8($sp)			
	sw  $s3, 12($sp)		
	sw  $s4, 16($sp)		
	sw  $s5, 20($sp)
	
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
	
	lw  $s0, 0($sp)			
	lw  $s1, 4($sp)			
	lw  $s2, 8($sp)			
	lw  $s3, 12($sp)		
	lw  $s4, 16($sp)		
	lw  $s5, 20($sp)
	addiu $sp,$sp,24	#liberta espaço

iend:	jr $ra			#termina a sub-rotina

#Mapa de registos --> print_array
#$a0-> $t7 : a
#$a1: n
#$t8: p
#$t9: *a
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
	
	
	