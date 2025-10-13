# Module 12 Demo A
# Very simple interrupt driven I/O
# CP0 $12 is status register
# CP0 $13 is cause register

# rcv -> Receive
# tx -> Transmit

# Memory mapped addresses of device fields.
.eqv kbInCtl 0xFFFF0000         # 0xFFFF0000 rcv contrl
.eqv kbInData 0xFFFF0004        # 0xFFFF0004 rcv data
.eqv dispOutCtl 0xFFFF0008      # 0xFFFF0008 tx contrl
.eqv dispOutData 0xFFFF000c     # 0xFFFF000c tx data

.text

main:                               # Main user program
    la      $t7, enable_rxint       # Load address of interrupt enable procedure
    jalr    $t7                     # Jump to enable interrupts (need to use jalr here, j would fail since label is beyond 26-bit range, we need all 32 bits!)

    ori     $t1, $0, 0              # Initalize $t1 as our counter

loop:                               # This is a simulated 'busy on other things', infinite loop
    addi    $t1, $t1, 1
    beq     $zero, $zero, loop

exit:                               # Dummy exit block
    li      $v0, 10                 # Load code for exit into $v0
    syscall                         # Syscall


.ktext 0x80000180                   # Forces interrupt routine below to be located at address 0x80000180 (kernel space)

# ---BEGIN Interrupt Handler --- #
# All registers are precious
interp:
    # Save registers.  Remember, this is an interrupt routine so it has to save anything it touches, including $t registers.
    # We also cannot use the stack to save variables. That must be preserved as well.

    la      $k0, ihrSaveArea        # Save registers used in interupt, use save area similar to stack in procedure call (not the stack)
    sw      $t0, 0($k0)             # Store $t0
    sw      $t1, 4($k0)             # Save $t1
    sw      $t2, 8($k0)             # Save $t2

    lw      $t1, kbInCtl            # Get input ctrl word
    andi    $t1, $t1, 0x0001        # Extract ready bit

    beq     $t1, $zero, intDone     # Branch out if input ready bit is zero

    lw      $t2, kbInData           # Get keyboard entered ASCII value

    lw      $t1, dispOutCtl         # Get output ctrl word
    andi    $t1, $t1, 0x0001        # Extract ready bit

    beq     $t1, $zero, intDone     # Branch out if output ready bit is zero

    sw      $t2, dispOutData        # Set keyboard value for output

# Fall through to interrupt handling complete

intDone:
    # Clear Cause register
    mfc0    $t0, $13                # Save cause register into $t0
    mtc0    $zero, $13              # Set cause register to zero

    # Restore registers 
    lw      $t0, 0($k0)             # Load $t0
    lw      $t1, 4($k0)             # Load $t1
    lw      $t2, 8($k0)             # Load $t2
    eret                            # Return from interrupt and reenable interrupts
# ---END Interrupt Handler --- #


# Interrupt Enable Procedure
# Regular procedure
enable_rxint:
    addiu   $sp, $sp, -4            # Adjust Stack pointer
    sw      $t0, 0($sp)             # Save $t0 on the stack

    # We don't want to be interrupted here, so disable for now
    mfc0    $t0, $12                # Move interrupt status in $12 to $t0
    andi    $t0, $t0, 0xFFFE        # Clear interrupt enable flag (keep all bits as they are, except last which gets cleared)
    mtc0    $t0, $12                # Move new status with cleared enable flag back into $12

    lw      $t1, kbInCtl            # Read input control word
    ori     $t1, $t1, 0x0002        # Set the *input* interrupt enable bit in control word
    sw      $t1, kbInCtl            # Update input control word

    # Re-enable interrupts
    mfc0    $t0, $12                # Move interrupt status in $12 to $t0
    ori     $t0, $t0, 0x0001        # Set interrupt enable flag (keep all bits as they are, except last which gets set)
    mtc0    $t0, $12                # Move new status with set enable flag back into $12

    jr      $ra                     # Return to caller


.kdata

# You can save any data needed by the interrupt handler here (used to save registers)
ihrSaveArea:    .space 12
