# Module 11 multiple character memeory mapped I/O demo
# Put N Characters procedure

# Memory mapped addresses of device fields.
.eqv kbInCtl 0xFFFF0000		# 0xFFFF0000 rcv contrl
.eqv kbInData 0xFFFF0004	# 0xFFFF0004 rcv data
.eqv dispOutCtl 0xFFFF0008	# 0xFFFF0008 tx contrl
.eqv dispOutData 0xFFFF000C	# 0xFFFF000c tx data
	
# Pseudo code
#	$t2 = 0
#	while ($t2 < &a1) {
#		loop all previous output complete
#		move character from buffer address offset by $t2 to disp out word
#		$t2+=1
#		}
#	loop to be sure last character output before return 
#	return		

# buffer address in $a0
# number of characters to output in $a1

.globl putNChar

.text

putNChar:		

	la      $t1, dispOutCtl		# Load address of output control word into $t1
	la	$t5, dispOutData	# Load address of output data word into $t5
	li	$t2, 0			# Initialize counter

# Loop until last character written out
loop:
	lw	$t3, 0($t1)		# Read control word
	andi	$t3, $t3, 0x0001  	# Extract ready bit 
	beq	$t3, $0, loop 		# Poll till ready for next character
	
	add 	$t4, $a0, $t2		# Get stored address of character, offset from base buffer address
	lbu	$t6, 0($t4)		# Load character into $t6
	sw	$t6, 0($t5)		# Store character into output data word at the offset
	addi 	$t2, $t2, 1		# Increment counter
	slt 	$t7, $t2, $a1		# Check if all characters have been written
	bne	$t7, $zero, loop	# Loop if more character need to be written
	jr	$ra			# Return to caller
	
