# Module 04 Demo A
# Example of simple procedure call in section 2.8
#
# Pseudo code for program
#	int leaf_example (int g, int h, int i, int j) {
#		int f;
#		f = (g + h) - (i + j);
#		return f;
#	}
#
# Notes on register usage
#		Arguments g, h, i, j in $a0, $a1, $a2, $a3
#		f will use $s0 so need to save $s0 on stack
#		Result in $v0
#

.data
f:	.word	0
g:	.word	1
h:	.word	2
i:	.word	3
j: 	.word	4

.text
main:
# Set up parameters
	la	$a0, g			# Load addess of g into $a0
	lw	$a0, 0($a0)		# Load value at $a0 into $a0
	la	$a1, h			# Load addess of h into $a0
	lw	$a1, 0($a1)		# Load value at $a0 into $a0
	la	$a2, i			# Load addess of i into $a0
	lw	$a2, 0($a2)		# Load value at $a0 into $a0
	la	$a3, j			# Load addess of j into $a0
	lw	$a3, 0($a3)		# Load value at $a0 into $a0

	# Call leaf_example
	jal	leaf_example		# Jump to label, storing address of next instruction in $ra
	
	# Return from Call here
	sw	$v0, f			# Save returned value in memory at f
	li	$v0, 10			# Load code for exit syscall into $v0
	syscall				# Syscall


# The leaf procedure
leaf_example:
	# "prolog"
	addi $sp, $sp, -4		# Adjust stack pointer by one word
	sw   $s0, 0($sp) 		# Save value of $s0 at the top of the stack, 0($sp)

	# Procedure body
	add  $t0, $a0, $a1		# Store g + h in $t0
	add  $t1, $a2, $a3		# Store i + j in $t1
	sub  $s0, $t0, $t1		# Store (g + h) - (i + j)
	add  $v0, $s0, $zero 		# Store result in $v0

	# "epilog" (although it is not often called that)
	lw   $s0, 0($sp) 		# Restore $s0 from top of stack
	addi $sp, $sp, 4		# Reset the stack pointer
	jr   $ra			# Return to caller


