# Module 10 Memory Mapped I/O Demo
# put character procedure
# $a0 = byte to transmit

# Memory mapped addresses of device fields.
.eqv dispOutCtl 0xFFFF0008      # 0xFFFF0008 tx contrl
.eqv dispOutData 0xFFFF000C     # 0xFFFF000c tx data

.text
.globl putc

putc:

pcloop:
    lw      $t1, dispOutCtl         # Read output ctrl memory address
    andi    $t1, $t1, 0x0001        # Extract ready bit
    beq     $t1, $zero, pcloop      # Poll till ready
    sw      $a0, dispOutData        # When ready write character to output register.

# Not done yet, need to wait until the character is actually written out
ccloop:
    lw      $t1, dispOutCtl         # Read output control memory address
    andi    $t1, $t1, 0x0001        # Extract ready bit
    beq     $t1, $zero, ccloop      # Keep polling until character written out
    jr      $ra                     # Return to caller
