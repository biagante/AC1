	.data
	.text
	.globl main
main: 	ori $t0,$0,0xe543 # substituir val_1 pelo valor desejado
	#bega��o bit a bit
	not $t1,$t0 #(not) bit inversion yet n�o � instru��o nativa
	jr $ra # fim do programa