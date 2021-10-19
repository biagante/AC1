# Mapa de Registos
# $t0 - i
# $t1 - argc
# $t2 - argv;
# $t3 - i*4;
# $t4 - argv[i]
	.data
str1: 	.asciiz "Nr. de parâmetros: "
str2:	.asciiz "\nP"
str3:   .asciiz ": "
	.align 2
	.eqv print_int10,1
	.eqv print_string, 4
	.text
	.globl main
	
main:	li $t0,0		#int i;
	move $t1,$a0		#$t1 = argc
	move $t2,$a1		#$t2 = $(argv[0])
	la $a0, str1
	li $v0,print_string
	syscall			#print_str("Nr. de parametros: ");
	move $a0,$t1
	li $v0, print_int10
	syscall			#print_int(argc);
	
for:	bge $t0,$t1,endfor	#for(i=0; i < argc; i++)
	la $a0,str2
	li $v0,print_string
	syscall			#print_str("\nP");
	move $a0,$t0
	li $v0,print_int10
	syscall			#print_int(i);
	la $a0,str3
	li $v0,print_string
	syscall			#print_str(": ");
	sll $t3,$t0,2		#$t3 = i * 4
	addu $t4,$t2,$t3	#$t4 = &(array[i*4])
	lw $t4,0($t4)		#$t4 = array[i*4]
	move $a0,$t4
	li $v0,print_string
	syscall			#print_str(argv[i]);
	addi $t0,$t0,1
	j for

endfor:	li $v0,0		#return 0;
	jr $ra			#fim do programa