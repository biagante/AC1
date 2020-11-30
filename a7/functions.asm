	.text
	.globl strlen
	.globl strrev
	.globl strcpy
	.globl strcopy
	.globl strcat

#função strlen() -> determina e devolve a dimensão de uma string
#Mapa de registos
#$t0: s* 
#$t1: len
strlen:	li $t1,0 		# len = 0;
stlw: 	lb $t0,0($a0)		# $t0 = char[0] da str
	addiu $a0,$a0,1 	# s++
	beq $t0,'\0',stlendw 	# while(*s++ != '\0')
	addi $t1,$t1,1 		# len++;
	j stlw			# }
stlendw: move $v0,$t1 		# return len;
	jr $ra 			# termina a função

#função strrev() -> inverte o conteúdo de uma string
# Mapa de registos:
# str: $a0 -> $s0 (argumento é passado em $a0)
# p1: $s1 (registo callee-saved)
# p2: $s2 (registo callee-saved)
strrev:	addiu $sp,$sp,-16 	# reserva espaço na stack
	sw $ra,0($sp) 		# guarda endereço de retorno
	sw $s0,4($sp) 		# guarda valor dos registos
	sw $s1,8($sp) 		# $s0, $s1 e $s2
	sw $s2,12($sp) 		#
	move $s0,$a0 		# registo "callee-saved"
	move $s1,$a0 		# p1 = str
	move $s2,$a0 		# p2 = str
	
strvw1: lb $s3, 0($s2)		
	beq $s3,'\0',strvendw1	# while( *p2 != '\0' ) {
	addi $s2,$s2,1		# p2++;
	j strvw1 		# }
	
strvendw1: 
	sub $s2,$s2,1		# p2--;
	
strvw2: bge $s1,$s2,strvendw2	# while(p1 < p2) {
	move $a0,$s1		#$a0 - 1º argumento de exchange
	move $a1,$s2 		#$a1 - 2º argumento de exchange
	jal exchange 		# exchange(p1,p2)
	addi $s1,$s1,1		# p1++
	sub $s2,$s2,1          # p2--
	j strvw2 		# }
	
strvendw2: 
	move $v0,$s0 		# return str
	lw $ra,0($sp) 		# repõe endereço de retorno
	lw $s0,4($sp)  		# repõe o valor dos registos
	lw $s1,8($sp)  		# $s0, $s1 e $s2
	lw $s2,12($sp) 		#
	addiu $sp,$sp,16	# liberta espaço da stack
	jr $ra 			# termina a sub-rotina
	
#função exchange() -> troca a posição de dois registos
exchange:			#void exchange(char* c1, char* c2)
	lb $t0,0($a0)		#$t0 = $a0  || char aux = *c1;
	lb $t1,0($a1)		#$t1 = $a1
	sb $t1, 0($a0)		#$t1 = $a0  || *c1 = *c2;
	sb $t0,0($a1)		#$t0 = $a1  || *c2 = aux; 	
	jr $ra			#termina a sub-rotina
	
#função strcpy() -> copia uma string
#Mapa de Registos
#$a0 -> $s0(dst) 
#$a1 -> $s1(src)
#$t0 -> i
#$t1 -> dist+i
#$t2 -> src+i
#$t3 -> dist[i]
#$t4 -> src[i]
strcpy:	addiu $sp,$sp,-8	#reserva espaço na stack
	sw $s0, 0($sp)		#guarda valor registo $s0
	sw $s1, 4($sp)		#guarda valor registo $s1
	
	li $t0, 0 		#int i = 0
	move $s0,$a0		#$s0 = dst
	move $s1,$a1		#$s1 = src
	
stydo:	addu $t1,$s0,$t0 	#dst + i
	addu $t2,$s1,$t0	#src + i	
	lb $t3, 0($t2)		#src[i]
	sb $t3, 0($t1)		#dst[i]
	addi $t0,$t0,1		#i++
	bne $t3, '\0',stydo	#while(src[i++] != '\0');
	
	move $v0,$s0		#$v0 = dst
	lw $s0, 0($sp)		
	lw $s1, 4($sp)		
	addiu $sp,$sp,8		# liberta espaço na stack
	jr $ra			#termina a sub-rotina
		
#função strcopy() -> copia uma string usando acesso por ponteiro
#Mapa de Registos strcopy
#dst:	$t0
#src:	$t1
#*src:	$t2
strcopy:
	move $t0, $a0		#$t0 = dst;
	move $t1, $a1		#$t1 = src;
	
stcdo:	lb $t2, 0($t1)		#$t2 = *src
	sb $t2, 0($t0)		#guardar o caracter em dst
	
	addi $t0, $t0, 1
	addi $t1, $t1, 1	#src++;
	bne $t2, '\0', stcdo	#while(*src!='\0');
	
	move $v0, $a0		#return dst
	jr  $ra			#fim da sub-rotina

#função strcat() -> permite concatenar duas strings
#Mapa de registos de strcat
#$a0 -> $0(p)
#$a1 -> $s1
#*p -> $s2
strcat:	addiu $sp,$sp,-16 	#reserva espaço na stack
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	
	move $s0, $a0		#p = dst
	move $s1, $a1		#$s1 = src

while:	lb $s2, 0($s0)		#*p = dst[0]
	beq $s2, '\0', endw	#while(*p != '\0')
	addi $s0,$s0,1		#p++;
	j while

endw:	move $a0,$s0
	move $a1,$s1
	jal strcpy		#strcpy(p,src)
	
	lw $ra,0($sp)		#liberta o espaço na stack
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	addiu $sp,$sp,16
	jr $ra			#termina a sub-rotina