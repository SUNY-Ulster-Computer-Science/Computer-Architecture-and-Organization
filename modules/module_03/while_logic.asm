# Module 03 Demo C
# Program to demonstrate while statement logic in machine language
#   Pseudo code for program
#       i = 0;
#       while (save[i] == k)
#           i += 1;
#
#   i is in $s3, k in $s5, base address of save, save[0], in $s6
#

.data

save:   .word 3, 3, 4, 5, 6, 7, 8, 9    # Allocate/initialize a vector array of numbers, save = [3, 3, 4, ...]
i:      .word 0
k:      .word 3

.text

main:
# Set up registers by loading in values
    lw      $s3, i
    lw      $s5, k
    la      $s6, save

# Perform the logic
loop:
# Get offset dynamically instead of hard coding
    sll     $t1, $s3, 2                 # Multiply i by 4 to get the offset address (shift left by 2 places)
    add     $t1, $t1, $s6               # Add offset addr and base addr, get element addr
    lw      $t0, 0($t1)                 # Load element (save[i]) into t0
    
    bne     $t0, $s5, exit              # Compare $t0 (save[i]) and $s5 (k), if save[i] != k, exit
    addi    $s3, $s3, 1                 # Increment i and loop
    sw      $s3, i                      # Save value of $s3 to memory location of i
    j       loop                        # Loop since we have not yet exited

exit:     
    li      $v0, 10                     # Load exit syscall code into $v0
    syscall                             # Syscall
