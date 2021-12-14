	.data
	.eqv read_int, 5
	.eqv print_string, 4
	.eqv print_int10, 1
str1:	.asciiz "Size of array: "
str2:	.asciiz "array["
str3: 	.asciiz "] = "
str4:	.asciiz "Enter the value to be inserted: "
str5:	.asciiz "Enter the position: "
str6:	.asciiz "\nOriginal array: "
str7:	.asciiz "\nModified array: "
	.text
	
	.globl main
	
main:	la $a0, st