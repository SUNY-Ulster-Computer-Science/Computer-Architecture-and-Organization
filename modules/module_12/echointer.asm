# Very simple interrupt driven I/O
# CP0 $12 is status register
# CP0 $13 is cause register

.text

main:					# Main user program
	la	$t7, enable_rxint	# Load address of interrupt enable procedure
   	jalr 	$t7			# Jump to enable interrupts (need to use jalr here, j would fail since label is beyond 26-bit range)
   	
   	ori	$t1, $0, 0		# Initalize $t1
loop:	                    		# This is a simulated 'busy on other things', infinite loop
	addi	$t1, $t1, 1
	beq	$0, $0, loop
exit:                       		# After we are busy long enough we will exit.
	li      $v0, 10			# Load code for exit into $v0
	syscall				# Syscall


.ktext 0x80000180		    	# Forces interrupt routine below to be located at address 0x80000180 (kernel space)

# Interrupt Handler - all registers are precious
interp:

	# Save registers.  Remember, this is an interrupt routine so it has to save anything it touches, including $t registers.
	
	la	$k0, ihrSaveArea    	# Save registers used in interupt, use save area similar to stack in procedure call
	sw	$t0, 0($k0)	        # Store $t0
	sw      $t1, 4($k0)		# Save $t1
	sw	$t2, 8($k0)		# Save $t2
	
	lui     $t0, 0xffff		# Get control word base address
	lw	$t1, 0($t0)	        # Get input ctrl word
	andi	$t1, $t1, 0x0001	# Extract rcv ready bit
	
	beq	$t1, $0, intDone	# Branch out if input ready bit is zero
	lw	$t2, 4($t0)		# Get keyboard entered ASCII value
	
	lw	$t1, 8($t0)		# Get output ctrl word
	andi	$t1, $t1, 0x0001  	# Extract ready bit 
	beq	$t1, $0, intDone	# Branch out if output ready bit is zero
	sw	$t2, 12($t0)		# Set keyboard value for output
	# Fall through to interrupt handling complete
	
intDone:
	
	# Clear Cause register
	mfc0	$t0, $13		# Save cause register into $t0
	mtc0	$0, $13			# Set cause register to zero

	# Restore registers 
	lw	$t0, 0($k0)	        # Load $t0
	lw      $t1, 4($k0)		# Load $t1
	lw	$t2, 8($k0)		# Load $t2
	eret			        # Return from interrupt and reenable interrupts


# Interrupt procedure
enable_rxint:
	
	addiu	$sp, $sp, -4	    	# Adjust Stack pointer
	sw	$t0, 0($sp)	        # Save $t0 on the stack
		
	mfc0	$t0, $12		# Move interrupt status in $12 to $t0
	andi	$t0, $t0, 0xFFFE	# Clear interrupt enable flag (keep all bits as they are, except last which gets cleared)
	mtc0    $t0, $12		# Move new status with cleared enable flag back into $12
	
	lui     $t0, 0xffff		# Get control word base address
	lw	$t1, 0($t0)	        # Read input control word
	ori	$t1, $t1, 0x0002	# Set the *input* interrupt enable bit in control word
	sw	$t1, 0($t0)	        # Update input control word
	
	mfc0	$t0, $12		# Move interrupt status in $12 to $t0
	ori	$t0, $t0, 0x0001	# Set interrupt enable flag (keep all bits as they are, except last which gets set)
	mtc0    $t0, $12		# Move new status with set enable flag back into $12
	jr	$ra			# Return to caller

.kdata

# You can save any data needed by the interrupt handler here
ihrSaveArea:	.space	12