# Module 05 Demo A
# Example of addressing
#
# Pseudo code for program
#	while (save[i] == k)
#		i+=1;
# Assume i is in $s3, k is in $s5, and save[] base is in $s6
#

.data
save: 	.word 2,2,2,2,2,4,5,6,7,8,9
k:	.word 2
msg:	.asciiz "The first index not equal to 2 is index: "

.text
main:
	la	$s6, save		# Load the address of save array into $s6
	li	$s3, 0			# Set i to zero (immediate addressing)
	lw	$s5, k			# Load the value of k into $s5

# Loop start label
loop:
	sll    	$t1, $s3, 2		# Store i * 4 in $t1 (register addressing)
      	add	$t1, $t1, $s6		# Store the address of save[i] in $t1
      	lw	$t0, 0($t1)		# Load the value of save[i] into $t0 (base addressing)
      	bne	$t0, $s5, exit		# Exit if save[i] != k (PC-relative addressing)
      	addi	$s3, $s3, 1		# Increment i
      	j	loop			# Jump back to loop (Pseudodirect addressing)
      	
exit:
	li	$v0, 4			# Load code for print string syscall into $v0
	la	$a0, msg		# Load the address of the message into $a0
	syscall				# Syscall to print string
	
	li	$v0, 1			# Load code for print integer syscall into $v0
	add	$a0, $s3, $zero		# Move value of i into $a0
	syscall				# Syscall to print integer
	
	li	$v0, 10			# Load code for exit into $v0
	syscall				# Syscall
