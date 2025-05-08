# Module 04 Demo C
# String Copy Example in section 2.9
#
# Pseudo code for program (note this is slightly different than text for simplicity)
#	void strcpy (char x[], char y[]) {
#		int i;
#		i = 0;
#		while (y[i] != '\0’) { 	// check the last character moved
#	        	x[i] = y[i];
#			i += 1;
#		}
#	}
#		Addresses of x, y in $a1, $a0
#		i in $s0

.data
source:	.asciiz "123456789"			# The string to copy from
.word 	0					# Added to force word boundary
target: .space 	1024				# The empty space to copy to

.text
main:
	la $a1, source				# Load address of source into $a1
	la $a0, target				# Load address of target into $a0
	jal strcpy				# Call strCpy(source, target)
	
	li $v0, 10				# Load code for exit syscall into $v0
	syscall					# Syscall


# String Copy Procedure
# Copy string pointed to by $a0 and space pointed to by $a1 (do not check overflow)
strcpy:
	addi $sp, $sp, -4      			# Adjust stack for 1 item
        sw   $s0, 0($sp)       			# Save $s0 on top of stack
        add  $s0, $zero, $zero			# i = 0
# While loop
loop:
	add  $t1, $s0, $a1     			# Load address of y[i] in $t1
        lbu  $t2, 0($t1)       			# Load byte (character) at y[i] into $t2
        add  $t3, $s0, $a0     			# Load address of x[i] in $t3
        sb   $t2, 0($t3)       			# Assign x[i] = y[i]
        beq  $t2, $zero, ret   			# Exit loop if y[i] == 0, the null character (EOS)
        addi $s0, $s0, 1       			# i = i + 1; only increment by one, we are working with bytes, not words!
        j    loop              			# Next iteration of loop
ret:
	lw   $s0, 0($sp)       			# Restore saved $s0
        addi $sp, $sp, 4       			# Pop 1 item from stack
        jr   $ra               			# Return to caller

