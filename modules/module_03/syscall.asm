# Module 03 Demo D
# Program to demonstrate SYSCALL

.data

promptInput:    .asciiz "Enter an Integer: "
outputMsg:      .asciiz "All your integer are belong to us: "


.text

inputNum:
    li      $v0, 4              # Load print string syscall code into $v0
    la      $a0, promptInput    # Load address of null-terminated prompt string to print into $a0
    syscall                     # Syscall to print string in $a0

    li      $v0, 5              # Load read integer syscall code into $v0
    syscall                     # Syscall to store read integer in $v0
    add     $t0, $v0, $zero     # Move $v0 to $t0 to store for later
    
    li      $v0, 4              # Load print string syscall code into $v0
    la      $a0, outputMsg      # Load address of null-terminated message string to print into $a0
    syscall                     # Syscall to print string in $a0

    li      $v0, 1              # Load print integer syscall code into $v0
    add     $a0, $t0, $zero     # Move $t0 to $a0 to serve as new argument
    syscall                     # Syscall to print the read integer in $a0

exit:
    li      $v0, 10             # Load exit syscall code into $v0
    syscall                     # Syscall
