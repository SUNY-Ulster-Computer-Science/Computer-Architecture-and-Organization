# Module 04 Demo B
# Example of Recursive Call, Factorial
#
# Pseudo code for program
#    int fact (int n) {
#       if (n < 1) return f;
#       else return n * fact(n - 1);
#    }
#     Argument n in $a0
#     Result in $v0
#
#    f = fact(g)

.data

f:    .word 0
g:    .word 4


.text

main:
    la      $a0, g                  # Load address of g into $a0
    lw      $a0, 0($a0)             # Load value of $a0 into $a0

    jal     fact                    # Call fact
    
    # Return from Call here
    sw      $v0, f                  # Save returned value in memory at f
    li      $v0, 10                 # Load code for exit syscall into $v0
    syscall                         # Syscall


# The non_leaf procedure
fact:
    # "prolog"
    addi    $sp, $sp, -8            # Adjust stack for 2 words
    sw      $ra, 4($sp)             # Save return address
    sw      $a0, 0($sp)             # Save argument
    
    slti    $t0, $a0, 1             # Test for n < 1 and store in $t0
    beq     $t0, $zero, recurse     # Branch to recursive case if n >= 1
    
    # "epilog" for base case
    addi    $v0, $zero, 1           # Store 1 in $v0 to return
    addi    $sp, $sp, 8             # Pop 2 items from stack, nothing is modified, so nothing is restored
    jr      $ra                     # Return to caller (originall call or recursive ancestor)
recurse:
    addi    $a0, $a0, -1            # Else decrement n
    jal     fact                    # Recursive call to fact(n - 1)
    lw      $a0, 0($sp)             # Restore original n
    lw      $ra, 4($sp)             # Restore return address
    
    # "epilog" for recursive case
    addi    $sp, $sp, 8             # Pop 2 items from stack
    mul     $v0, $a0, $v0           # Multiply to get result and store in $v0
    jr      $ra                     # Return to caller (originall call or recursive ancestor)
