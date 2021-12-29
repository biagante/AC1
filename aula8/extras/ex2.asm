	.globl insert
#"insert()" permite inserir a string "src" na string "dst", a partir da posição "pos"
# *insert(char *dst, char *src, int pos)	
insert:	addiu $sp,$sp,-36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	move $s0, $a0			# $s0 = dst
	jal strlen			# strlen(dst)
	move $s3, $v0			# len_dst = strlen(dst)
	
	move $s1, $a1			# $s1 = src
	move $a0, $a1			
	jal strlen			# strlen(src)
	move $s4, $v0			# len_src = strlen(src)
	
	bgt $a2, $s3, in_endi		# if (pos <= len_dst)
	move $s2,$s3			# i = len_dst
	
in_for:	blt $s2, $a2, in_endf		# for(i = len_dst, i >= pos)
	add $s5, $s0, $s2 		# dst + i
	lb $s6, 0($s5)			# dst[i]
	add $s7,$s5, $s4		# dst + i + len_src
	sb $s6,0($s7)			# dst[i + len_src] = dst[i]
	sub $s2, $s2,1			# i--
	j in_for
	
in_endf:li $s2,0			# i = 0

in_for2:bge $s2,$s4,in_endi		# for (i < len_src)
	add $s5,$s2,$s1			# src + i
	lb $s6,0($s5)			# src[i]
	add $s7,$s2,$a2			# i + pos
	add $s7,$s7,$s0			# dst + i + pos
	sb $s6, 0($s7)			# dst[i + pos] = src[i]
	addi $s2,$s2,1			# i++
	j in_for2
	
in_endi:move $v0, $s0			#return p
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addiu $sp,$sp,36
	jr $ra