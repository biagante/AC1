	.data
newline:.asciiz "\n"
	.text
	.globl main
main:	ori $v0,$0,5 #$v0 toma o valor 5 -> read_int()
	syscall #pede que se introduza o valor
	or $t0,$0,$v0 #$t0 = x, obtido do teclado
	
     	ori $t2, $0, 8 #$t2 = 8
     	add $t1, $t0, $t0 #$t1 = $t0 + $t0 = x + x = 2x
     	sub $t1,$t1,$t2 #$t1 = $t1 - $t2 = y = 2x-(+8)
     	
     	or $a0, $0, $t1 #$s0 = y
     	#ori $v0, $0,1 #$v0 toma o valor 1 -> print_int10()
     	#syscall #imprime numero em base 10 (decimal)
     	#ori $v0, $0,34 #$v0 toma o valor 34 ->print_int16() 
     	#syscall #imprime numero em base 16 (hexa)
     	ori $v0,$0,36 #$v0 toma o valor 36 -> print_intu10()
     	syscall #devolve o valor de y
     	
     	jr $ra # termina o programa
