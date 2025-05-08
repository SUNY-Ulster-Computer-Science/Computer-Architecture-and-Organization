# Module 10 Memory Mapped I/O Demo
# put character procedure
# a0 = byte to transmit

.text
.globl putc

putc:
    lui     $t0, 0xffff             # Load address of memory mapped I/O words into register

pcloop:
    lw      $t1, 8($t0)             # Read output ctrl memory address
    andi    $t1, $t1, 0x0001        # Extract ready bit
    beq     $t1, $0, pcloop         # Poll till ready
    sw      $a0, 12($t0)            # When ready write character to output register.

ccloop:
    lw      $t1, 8($t0)             # Read output control memory address
    andi    $t1, $t1, 0x0001        # Extract ready bit
    beq     $t1, $0, ccloop         # Keep polling until character written out
    jr      $ra                     # Return to caller
