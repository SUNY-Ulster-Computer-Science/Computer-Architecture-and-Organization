# Assignment 14 assembled MIPS test program

.data

s1:     .asciiz "ABCDEFGH"          # First string
s2:     .asciiz "IJKLMNOPQRST"      # Second string
s0:     .space 50                   # Buffer for concatenated string (allocate enough space)
output: .asciiz "The string is: "   # The optput message to show to the user

.text
.globl main

main:
    # Initialize s0 as empty string (just put a null terminator at the beginning)
    la      $t0, s0                 # Load address of s0
    sb      $zero, 0($t0)           # Store null byte at the beginning

    # Call our strcat equivalent for s0 and s1
    la      $a0, s0                 # First argument: destination
    la      $a1, s1                 # Second argument: source
    jal     strcat

    # Call our strcat equivalent for s0 (now containing s1) and s2
    la      $a0, s0                 # First argument: destination (s0 already has s1)
    la      $a1, s2                 # Second argument: source
    jal     strcat

    # Print the result
    li      $v0, 4                  # System call code for print_string
    la      $a0, output             # Load address of output string
    syscall                         # Print "The string is: "

    li      $v0, 4                  # System call code for print_string
    la      $a0, s0                 # Load address of concatenated string
    syscall                         # Print the concatenated string

    # Print newline
    li      $v0, 11                 # System call code for print_char
    li      $a0, 10                 # ASCII code for newline
    syscall

    # Exit program
    li      $v0, 10                 # System call code for exit
    syscall

## == NOTE ==##
# Mips does not have a pre-compiled version of the C standard library like x86 does,
# therefore it is implemented below.  However, this is not relevant to the assignment
# and can be ignored.  Only the above can be compared directly to x86 and s390x.
## ========= ##

# strcat - Concatenate strings
# Arguments:
#   $a0 - Address of destination string
#   $a1 - Address of source string
# Returns: None
strcat:
    # Save return address
    addi    $sp, $sp, -4            # Adjust stack pointer
    sw      $ra, 0($sp)             # Save return address

    # Find end of destination string
    move    $t0, $a0                # Copy destination address to $t0
find_end:
    lb      $t1, 0($t0)             # Load byte from destination
    beqz    $t1, copy_loop          # If null terminator found, start copying
    addi    $t0, $t0, 1             # Move to next byte
    j       find_end

    # Copy source string to end of destination
copy_loop:
    lb      $t1, 0($a1)             # Load byte from source
    sb      $t1, 0($t0)             # Store byte to destination
    beqz    $t1, strcat_done        # If null terminator, we're done
    addi    $t0, $t0, 1             # Move to next byte in destination
    addi    $a1, $a1, 1             # Move to next byte in source
    j       copy_loop

strcat_done:
    # Restore return address and return
    lw      $ra, 0($sp)             # Restore return address
    addi    $sp, $sp, 4             # Restore stack pointer
    jr      $ra                     # Return
