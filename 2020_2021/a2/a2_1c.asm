	.data
	.text
	.globl main
main: 	ori $t0,$0,0xe543 # substituir val_1 pelo valor desejado
	#begação bit a bit
	not $t1,$t0 #(not) bit inversion yet não é instrução nativa
	jr $ra # fim do programa