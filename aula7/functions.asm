	.globl strlen
	.globl strrev
	.globl exchange
	.globl strcpy
	.globl strcat
	
# O argumento da função é passado em $a0
# O resultado é devolvido em $v0
# Sub-rotina terminal: não devem ser usados registos $sx
strlen: li $t1,0 		# len = 0;
strlw: 	lb $t0,0($a0)		# while(*s++ != '\0')
 	addiu $a0,$a0,1 	#
 	beq $t0,'\0',strlendw 	# {
 	addi $t1,$t1, 1		# len++;
 	j strlw		# }
strlendw: move $v0,$t1 		# return len;
     	jr $ra 			#	
     	
# Mapa de registos:
# str: $a0 -> $s0 (argumento é passado em $a0)
# p1: $s1 (registo callee-saved)
# p2: $s2 (registo callee-saved)
#
strrev: addiu $sp,$sp,-16  	# reserva espaço na stack
 	sw $ra,0($sp)	 	# guarda endereço de retorno
 	sw $s0,4($sp)		# guarda valor dos registos
 	sw $s1,8($sp) 		# $s0, $s1 e $s2
 	sw $s2,12($sp) 		#
 	move $s0,$a0 		# registo "callee-saved"
 	move $s1,$a0 		# p1 = str
 	move $s2,$a0 		# p2 = str
 	
 strrw1: lb $t3, 0($s2)
	beq $t3, '\0', strrendw1 # while( *p2 != '\0' ) {
 	addi $s2,$s2,1		# p2++;
 	j strrw1		# }
 	
strrendw1: addi $s2,$s2,-1 	# p2--;

strrw2: bge $s1,$s2, strrendw2	# while(p1 < p2) {
 	move $a0,$s1 		#
 	move $a1,$s2 		#
 	jal exchange 		# exchange(p1,p2)
 	addi $s1,$s1,1		# p1++;
 	addi $s2,$s2,-1		# p2--; 	
 	j strrw2
 	
strrendw2: move $v0,$s0 		# return str
 	lw $ra,0($sp) 		# repõe endereço de retorno
 	lw $s0,4($sp) 		# repõe o valor dos registos
 	lw $s1,8($sp) 		# $s0, $s1 e $s2
 	lw $s2,12($sp)   	#
 	addiu $sp,$sp,16	# liberta espaço da stack
 	jr $ra 			# termina a sub-rotina 
 	
# funcao strcpy():A função strcpy() (string copy) copia uma string 
#residente numa zona de memória para outra zona de memória
strcpy:	addiu $sp,$sp,-8 	# reserva espaço na stack
 	sw $ra,0($sp)	 	# guarda endereço de retorno
 	sw $s0,4($sp)		# guarda valor dos registos
 	
 	move $s0,$a0 		# *dst
 	move $s1,$a1 		# *src
 	
 	li $t0, 0		# i = 0
 	
strcdo:	addu $t1,$s0,$t0	# dst + i
        addu $t2, $s1, $t0	# src + i
        lb $t3, 0($t2) 		# src[i]
        sb $t3, 0($t1) 		# dst[i]
        addi $t0,$t0,1		# i++
        bne $t3, '\0', strcdo	# while(src[i++] != '\0')
         
 	
 	move $v0,$s0 		# return str
 	lw $ra,0($sp) 		# repõe endereço de retorno
 	lw $s0,4($sp) 		# repõe o valor dos registos
 	addiu $sp,$sp,8	# liberta espaço da stack
 	jr $ra 			# termina a sub-rotina 
 
 	
# função exchange()
exchange: lb $t0,0($a0)
	  lb $t1,0($a1)
	  
	  sb $t1,0($a0)
	  sb $t0,0($a1)
	  jr $ra     	  
	  
# funcao strcat() -> (string concatenate) permite concatenar duas strings
strcat:	addiu $sp,$sp,-16 	#reserva espaço na stack
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	
	move $s0, $a0		#p = dst
	move $s1, $a1		#$s1 = src
 	
stcw:	lb $s2, 0($s0)		#*p = dst[0]
	beq $s2, '\0', stcendw	#while(*p != '\0')
	addi $s0,$s0,1		#p++;
        j stcw
 	
stcendw: move $a0,$s0 		# 
 	move $a1, $s1
 	jal strcpy
 	
 	lw $ra,0($sp) 		# repõe endereço de retorno
 	lw $s0,4($sp) 		# repõe o valor dos registos
 	lw $s1, 8($sp)
 	lw $s2, 12($sp)
 	addiu $sp,$sp,16	# liberta espaço da stack
 	jr $ra 			# termina a sub-rotina 

