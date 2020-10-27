#Mapa de registos:
# $t0 - res
# $t1 - i
# $t2 - mdor
# $t3 - mdo
      	.eqv print_string,4
      	.eqv read_int,5
      	.eqv print_int10,1	
      	.data
str1: 	.asciiz "Introduza dois números: "
str2: 	.asciiz "\nResultado: "
	.text
	.globl main
main: 	la $a0, str1
      	li $v0,print_string		#print_string
      	syscall

      	li $v0,read_int			#read_int
      	syscall
      	or $t2,$0,$v0			#mdor = nº lido
      	andi $t2, $t2, 0x0F		#mdor = nº and 0x0f
      
      	li $v0, read_int		#read_int
      	syscall
      	or $t3,$0,$v0			#mdo = nº lido
      	andi $t3, $t3, 0x0F		#mdo = nº and 0x0f
      
     	or $t0,$0,$0			#res = 0
     	or $t1,$0,$0			#i = 0
      
while: 	beqz $t2, end_while		#while(mdor != 0)
       	bge $t1,4,end_while		#while(i++ < 4)
       	addi $t1,$t1,1			#i++
       	     	
       	andi $t4, $t2, 0x00000001	#mdor and 0x00000001
       	beqz $t4, endif			#if(p.anterior != 0)
       	
       	add $t0, $t0,$t3		#res = res + mdo
		
endif:	sll $t3,$t3, 1			#mdo = mdo << 1
     	srl $t2,$t2, 1			#mdor = mdor >> 1
     	j while
     	 
end_while: 
	la $a0, str2
        li $v0,print_string		#print_string
        syscall
          
        move $a0, $t0
	li $v0,print_int10		#print_int10
      	syscall
       
	jr $ra     			#fim do programa
  
