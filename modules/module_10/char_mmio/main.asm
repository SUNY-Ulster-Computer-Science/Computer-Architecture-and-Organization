# Module 10 Memory Mapped I/O Demo
# Memory mapped address of device registers.

# rcv -> Receive
# tx -> Transmit

# 0xFFFF0000 rcv contrl
# 0xFFFF0004 rcv data
# 0xFFFF0008 tx contrl
# 0xFFFF000c tx data

.text

main:
    jal     getc            # Get character from the keyboard
    move    $a0, $v0        # Move the character to the "putc" argument register
    jal     putc            # Output the character to the display

exit:
    li      $v0, 10         # Load exit syscall code into $v0
    syscall                 # Syscall
