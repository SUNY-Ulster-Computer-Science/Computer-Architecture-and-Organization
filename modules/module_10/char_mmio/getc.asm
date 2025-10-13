# Module 10 memeory mapped I/O demo
# Get character procedure
# Return the received character in $v0

# Memory mapped addresses of device fields.
.eqv kbInCtl 0xFFFF0000         # 0xFFFF0000 rcv contrl
.eqv kbInData 0xFFFF0004        # 0xFFFF0004 rcv data

.text
.globl getc

getc:

gcloop:
    lw      $t1, kbInCtl        # Read rcv ctrl
    andi    $t1, $t1, 0x0001    # Extract ready bit
    beq     $t1, $zero, gcloop  # Keep polling till ready

    lw      $v0, kbInData       # Get input character from memory location into $v0
    jr      $ra                 # Return to caller
