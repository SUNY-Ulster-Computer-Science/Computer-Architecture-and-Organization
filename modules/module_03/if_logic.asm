# Module 03 Demo B
# Program to demonstrate if statement logic in machine language
#
#    Pseudo code for program
#       if (i == j)
#            f = g + h;
#        else
#            f = g - h;
#        ----------------------------------------------------
#        f, g, h, i, j are in registers $s0, $s1, $s2, $s3, $s4
#


.data

f:    .word 0                   # The final output variable, initalized to 0
g:    .word 6                   # A variable operand, initalized to 6
h:    .word 7                   # A variable operand, initalized to 7
i:    .word 3                   # A variable operand, initalized to 3
j:    .word 3                   # A variable operand, initalized to 3


.text

main:
# Set up registers by loading in values
    lw      $s1, g
    lw      $s2, h
    lw      $s3, i
    lw      $s4, j

    bne     $s3, $s4, else      # Branch to else when i != j, skip over add
# If block
    add     $s0, $s1, $s2       # Add and store f = g + h
    j       exit                # Jump to exit, skip over else block

else:
# Else block
    sub     $s0, $s1, $s2       # Sub and store f = g - h (fall through to exit)

exit:
    sw      $s0, f              # Store value of $s0 into f
    li      $v0, 10             # Load exit syscall code into $v0
    syscall                     # Syscall

