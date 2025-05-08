# Program to input and output a 4 character field

# Data area
.globl main

.data

buffer:	.space	32		# Space for our user input characters
	
.text

main:
# Get 4 characters from the keyboard and save them in the buffer

	la	$a0, buffer	# Load the address of the memory buffer into $a0
	li	$a1, 4		# Load the number of character to get into $a1
	jal	getNChar	# Run the getNChar procedure
		
# Put 4 characters from the buffer to the display

	la	$a0, buffer	# Load the address of the memory buffer into $a0
	li	$a1, 4		# Load the number of character to put into $a1
	jal	putNChar	# Run the putNChar procedure
	
# Exit
	li      $v0, 10		# Load exit cde into $v0
	syscall			# Syscall
