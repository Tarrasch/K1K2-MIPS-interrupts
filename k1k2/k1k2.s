# k1k2.s
#
# Testa escape-hårdvaruavbrottet
# OBS - main är ej färdigskriven ännu.

#include <iregdef.h>

		.text
        .globl main
main:
		addiu	sp, sp, -24		# allocate stack frame
		sw		ra, 16(sp)		# save return address
		li		a0, 0
loop:
		jal		print_number
		jal		delay
		addi	a0, 1
		j	    loop

#
# Put your program here
#

main_ret:
		lw		ra, 16(sp)		# restore return address
		addiu	sp, sp, 24		# remove stack frame
		jr		ra				# return from main

############################################################
# print_number - skriv ut ett heltal samt byt rad
#
# Args:	$a0 = number to print

		.data
newline:
		.asciiz "\n"

		.text
		.globl print_number
print_number:
		addiu	sp, sp, -32		# allocate stack frame
		sw		v0, 4(sp)		# save $v0
		sw		a0, 8(sp)		# save $a0
		
		# First, print number using syscall 1 (a0 already contains number)
		li		v0, 100
		syscall
		
		# Then print new line using syscall 4
		li		v0, 4
		la		a0, newline
		syscall
		
		lw		a0, 8(sp)		# restore $a0
		lw		v0, 4(sp)		# restore $v0
		addiu	sp, sp, 32		# remove stack frame
		jr		ra

############################################################
# delay - Fördröj exekveringen lite lagom mycket

		.text
		.globl delay
delay:
		li		t0, 50000		# Do many iterations
dloop:	addi	t0, t0, -1
		bnez	t0, dloop
		jr		ra
