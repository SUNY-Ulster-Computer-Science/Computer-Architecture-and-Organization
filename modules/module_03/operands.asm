# Module 03 Demo A
# Program to demonstrate operands in memory (a variation of the example in Section 2.3)
#
#	Pseudo code for program
#                      A[12] = h + A[8];
#

.data
A:	.word 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15	# Allocate/initialize a vector array of numbers, A = [0, 1, 2, 3, 4, ...]
h:	.word 6						# Constant used in program, h = 6

.text
	la  $s0, A					# Load base address of array A (address of A[0]) into $s0
	lw  $t0, 32($s0) 				# Load A[8] into $t0, offset 32 = 8 * 4
	lw  $s1, h					# Load h into $s1
	add $t1, $s1, $t0				# Add h + A[8] and store in $t1
	sw  $t1, 48($s0)				# Store from $t1 into A[12], A[12] = h + A[8]

exit:
	li $v0, 10					# Load exit syscall code into $v0
	syscall						# Syscall
