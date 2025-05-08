# Get n character procedure

# Memory mapped addresses of device fields.
.eqv kbInCtl 0xFFFF0000		# 0xFFFF0000 rcv contrl
.eqv kbInData 0xFFFF0004	# 0xFFFF0004 rcv data
.eqv dispOutCtl 0xFFFF0008	# 0xFFFF0008 tx contrl
.eqv dispOutData 0xFFFF000c	# 0xFFFF000c tx data
	
# Pseudo code
#	$t0 = 0
#	while ($t0 < &a1) {
#		loop until character is available
#		move character to buffer address offset by $t0
#		$t0+=1
#		} 
#	return		

# buffer address in $a0
# number of characters to read in $a1

.globl getNChar

.text			
getNChar:		
	 
	la    	$t1, kbInCtl		# Load address of input control word into $t1
	li	$t2, 0			# Initialize counter

# Loop until all character have been read
loop:
	lw	$t3, 0($t1)	        # Read control word
	andi	$t3, $t3, 0x0001	# Extract ready bit
	beq	$t3, $0, loop		# Keep polling till ready
	
	lb	$t4, kbInData		# Read character into temporary register from input data word
	add	$t5, $a0, $t2		# Get store address of character, offset from base buffer address
	sb 	$t4, 0($t5)		# Store the byte into the buffer at the offset
	addi	$t2, $t2, 1		# Increment counter
	slt	$t5, $t2, $a1		# Check if the correct number of character has been read
	bne	$t5, $zero, loop  	# Loop if more character need to be read
	jr	$ra			# Return to caller
