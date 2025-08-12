# Module 01 Demo A
# Helloworld test program

.data                   # The static data section of the program

msg:                    # A message to be printed out
    .asciiz "Hello CSC250 class"


.text                   # The executable text section of the program

.globl main             # Make the main label globally accessible
main:                   # The start of the main program
    li      $v0, 4      # Load syscall code 4 (print_str) into $v0
    la      $a0, msg    # Load the address of msg into $a0
    syscall             # Execute the syscall to print the string

    li      $v0, 10     # Load syscall code 10 (exit) into $v0
    syscall             # Execute the syscall to exit the program gracefully
