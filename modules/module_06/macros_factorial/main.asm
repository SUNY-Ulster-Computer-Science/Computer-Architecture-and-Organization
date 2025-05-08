# Example of simple non-leaf procedure call in section 2.8
#
# Pseudo code for program
#	int fact (int n) {
#		if (n < 1) return f;
#		else return n * fact(n - 1);
#	}
# 	Argument n in $a0
# 	Result in $v0
#

.include "sysmacros.asm"
.globl main

.data
f:		.word 0
g:		.word 0
promptmsg: 	.asciiz "Enter a number to calculate the factorial"
outmsg: 	.asciiz "The factorial is: "

.text
main:
	InputDialogInt (promptmsg)	# Insert input dialog macro
	jal	fact			# Call factorial procedure
	move	$a1, $v0		# Save returned value in memory
	OutputInt(outmsg)		# Insert output dialog macro
    	Finish				# Insert finish macro
