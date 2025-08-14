# Module 16 Demo A
# Floating Point Adding Machine

.data

prompt:     .asciiz   "Enter a floating point number or 0 to get the sum"
outputMsg:  .asciiz   "The sum is "
fltPtZero:  .float 0            # A constant zero to compare to before exiting


.text

# set up registers
main:
    la      $t0, fltPtZero      # Load a constant zero into $t0
    lwc1    $f1, ($t0)          # Set $f1 reg to fp zero
    lwc1    $f12, ($t0)         # Set total reg ($f12) to fp zero

# Loop: read number, check for zero and branch, add to total
# Note:    $f0 will contain floating point number read

input:
    li      $v0, 52             # Load code for input dialog float into $v0
    la      $a0, prompt         # Load address of prompt into $a0
    syscall                     # Syscall to get float, message to user result returned in $f0

    c.eq.s  $f0, $f1            # Compare input to zero and set coproc 1 condition flag 0
    bc1t    exit                # Branch if coproc 1 condition flag 0 is true

    add.s   $f12, $f0, $f12     # Add new number in $f0 to total in $f12
    j       input               # Jump back to the begining of the input loop

# Print outputMsg and exit
exit:
    li      $v0, 57             # Load code for output dialog float into $v0
    la      $a0, outputMsg      # Load address of output message into $a0
    syscall                     # Syscall to send the sum in $f12 to the dialog

    li      $v0, 10             # Load code for system exit into $v0
    syscall                     # Syscall
