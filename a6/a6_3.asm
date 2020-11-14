# Mapa de registos
# $t0 - i
# $t1 - i * 4
# $t2 - j
# $t3 - array
# $t4 - array[i]

	.data	
st1:	.asciiz "Array"
st2:	.asciiz "de"	
st3:	.asciiz "ponteiros"
str:	.asciiz "\nString #"
point:	.asciiz ": "
	.align 2

array:	.word st1,st2,st3
		
	.eqv SIZE,3
	.eqv print_string,4
	.eqv print_int10,1 
	.eqv print_char,11
		
	.text
	.globl main

main:	li $t0, 0			#int i = 0;
	la $t3, array			
for:	beq $t0, SIZE, endfor		#while( i < SIZE ) {
	la $a0, str				
	li $v0, print_string	
	syscall				#print_string("\nString #");
	move $a0, $t0			#$a0 = i;
	li $v0, print_int10	
	syscall				#print_int10(i);
	la $a0, point			#$a0 = ": ";
	li $v0, print_string	
	syscall				#print_string(": ");
	li $t2, 0			#int j = 0;
while:	sll $t1, $t0, 2			#$t4 = i * 4;
	addu $t4, $t3, $t1		#$t4 = &(array[i]);	
	lw $t4, 0($t4)			#$t4 = array[i];
	addu $t4, $t4, $t2		#$t4 = &array[i][j];
	lb $t4, 0($t4)			#$t4 = array[i][j];
	beq $t4, '\0', endw		#while(array[i][j] != '\0') {
	move $a0, $t4		
	li $v0, print_char		
	syscall				#print_char(array[i][j]);
	li $a0, '-'					
	li $v0, print_char		
	syscall				#print_char('-');
	addi $t2, $t2, 1		#j++;
	j while			
endw:		
	addi $t0, $t0, 1		#i++;
	j for			
endfor:					
	jr $ra				# } fim do programa
	
