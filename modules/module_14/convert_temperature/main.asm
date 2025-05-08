# Module 14 convert temperature demo
# Convert Farenheit to Centigrade
# Farenheit in $F12
# Result in $F0

.data

zero:   .float 0.0
prompt: .asciiz "\nInput Farenheit or zero to terminate: "
out1:   .asciiz "The temperature "
out2:   .asciiz    " in Farenheit is "
out3:   .asciiz " in Centigrade"


.text

main:

    l.s     $f31, zero      # Initialize fp reg 31 to 0.0 for end test

loop:
    la      $a0, prompt     # Load address of prompt into $a0
    li      $v0, 4          # Load code for print string into $v0
    syscall                 # Syscall to print string

    li      $v0, 6          # Load code for read single precision float into $v0
    syscall                 # Syscall to store read float into $f0

    c.eq.s  $f0, $f31       # Compare input to zero
    bc1t    exit            # Branch to exit if input is zero

    la      $a0, out1       # Load address of first part of output message into $a0
    li      $v0, 4          # Load code for print string into $v0
    syscall                 # Syscall to print the message

    mov.s   $f12, $f0       # Move input float from $f0 to $f12
    li      $v0, 2          # Load code for print float into $v0
    syscall                 # Syscall to print the float

    mov.s   $f12, $f0       # Move input temperature to $f12
    jal     f2c             # Call conversion procedure input parameter in $f12 and return value in $f0

    la      $a0, out2       # Load address of second part of output message into $a0
    li      $v0, 4          # Load code for print string into $v0
    syscall                 # Syscall to print the message

    mov.s   $f12, $f0       # Move result float from $f0 to $f12
    li      $v0, 2          # Load code for print float into $v0
    syscall                 # Syscall to print the float

    la      $a0, out3       # Load address of third part of output message into $a0
    li      $v0, 4          # Load code for print string into $v0
    syscall                 # Syscall to print the message

    j       loop            # Jump back to read another number

exit:
    li      $v0, 10         # Load code for exit into $v0
    syscall                 # Syscall
