# Mapa de registos
# k: $t0
# temp_lista: $t1
# temp_lista[k]: $t2 
# houve_troca: $t4
# p: $t5
# pUltimo: $t6 

 	.data
 	.eqv FALSE,0
 	.eqv TRUE,1
 	.eqv SIZE, 10
 	
 	.eqv print_int10,1
 	.eqv print_string,4
 	.eqv read_int, 5

str:	.asciiz "Introduza um numero: "
str1: 	.asciiz "; "
str2: 	.asciiz "\nConteudo do array:\n" 
	.align 2
lista: 	.space 40			# SIZE * 4 (word)	
 	 	 	
 	.text
 	.globl main
main: 	li $t0, 0			# k = 0

 	
for_1: bge $t0, SIZE, endf_1		# for(k < SIZE)

 	la $a0, str
 	li $v0,print_string
 	syscall 			# print_string(str)
 	 	
 	li $v0, read_int		# read_int()
 	syscall 			# código para leitura de valores
 	
 	la $t1, lista			# $t1 = temp_lista
 	sll $t2, $t0, 2			# index = k * 4
 	addu $t2, $t2, $t1		# $t2 = &temp_lista[k]
 	sw $v0, 0($t2)			# save value in array
 	addi $t0, $t0, 1 		# k++
 	j for_1
 	
endf_1: la $t6,lista 			#
	
do: 					# do {
 	li $t4,FALSE			# houve_troca = FALSE;
 	li $t5,0			# i = 0;
 	
for: 	bge $t5,SIZE, endfor		# while(i < SIZE-1){

if: 	sll $t7,$t5,2 			# $t7 = i * 4
 	addu $t7,$t7,$t6 		# $t7 = &lista[i]
 	lw $t8,0($t7) 			# $t8 = lista[i]
 	lw $t9,4($t7) 			# $t9 = lista[i+1]
 	ble $t8,$t9,endif 		# if(lista[i] > lista[i+1]){
 	sw $t8,4($t7) 			# lista[i+1] = $t8
 	sw $t9,0($t7) 			# lista[i] = $t9
 	li $t4,TRUE 			#
 					# }
endif: 	addi $t5,$t5,1			# i++;
 	j for	 			# }
 	
endfor:	beq $t4, TRUE, do		# } while(houve_troca == TRUE);
	la $a0, str2			
	li $v0, print_string
	syscall	 			# codigo de impressao do
 					# conteudo do array
 	li $t5,1
	
print: 	bge $t5, 11, endp
	la $t6, lista
	sll $t2,$t5,2
	addu $t2,$t2,$t6 
	lw $a0, 0($t2)
	
 	li $v0, print_int10
	syscall				# print_int10( *p );
	
	la $a0, str1			
	li $v0, print_string
	syscall	
	
	addi $t5, $t5, 1
	j print
	
 
endp: 	jr $ra 				# termina o programa 
