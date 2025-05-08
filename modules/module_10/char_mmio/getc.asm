# Module 10 memeory mapped I/O demo
# Get character procedure
# Return the received character in $v0

.text
.globl getc

getc:
    lui     $t0, 0xffff         # Load address of memory mapped control words into $t0

gcloop:
    lw      $t1, 0($t0)         # Read rcv ctrl
    andi    $t1, $t1, 0x0001    # Extract ready bit
    beq     $t1, $0, gcloop     # Keep polling till ready

    lw      $v0, 4($t0)         # Get input character from memory location into $v0
    jr      $ra                 # Return to caller
