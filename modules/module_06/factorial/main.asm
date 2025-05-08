# Module 06 Factorial Demo
# Example of simple non-leaf procedure call in section 2.8
#
# Pseudo code for program
#	int fact (int n) {
#		if (n < 1) return f;
#		else return n * fact(n - 1);
#	}
# 	Argument n in $a0
# 	Result in $v0

.globl main

.data
f:		.word 0
g:		.word 0
promptmsg: 	.asciiz "Enter a number to calculate the factorial"
outmsg: 	.asciiz "The factorial is: "

.text
main:
	li	$v0, 51			# Load code for integer input in $v0
	la	$a0, promptmsg		# Load address of prompt message in $a0
        syscall				# Syscall to ask for input using address in argument

        jal	fact			# Call factorial procedure
	move	$a1, $v0		# Move returned value into $v0
	
	li	$v0, 56			# Load code for integer output in $v0
	la	$a0, outmsg		# Load address of output message in $a0
	syscall				# Syscall to output an integer with a message
	
	li	$v0, 10			# Load code for exit
	syscall				# Syscall
