# Module 26 buffer overflow demo
# A Simple demonstration of a buffer overflow exploit in MIPS
#
# In memory, a user input buffer is stored immediatley before
# a sensitive password that is checked for login.
# The user input has a well-defined space, but lacks proper
# bounds checking.
#
# An attacker can submit an incorrect password that overruns
# the buffer, ensuring that the null terminator falls after
# the pointer to the password.
# Next, the attacker enters a password again, this time
# with the overrun data from the first attempt.


.data

pwdMsg: .asciiz "Enter your password: "
incorrectMsg: .asciiz "Incorrect password!\n"
correctMsg: .asciiz "Correct password!\n"

# Note the spatial relationship between the buffer and the password.
userInput: .space 12
password: .asciiz "1234"

.text

## Print String Macro ##
.macro printString($msg)            # Print message macro

    li      $v0, 4                  # Load code for print string into $v0
    la      $a0, $msg               # Load address of message into $a0
    syscall                         # Print message

.end_macro


## Read String Macro ##
.macro readString($addr)

    la      $t0, $addr              # Load address of $addr into $a0

loop:
    li      $v0, 12                 # Load code for read character into $v0
    syscall                         # Read character

    beq     $v0, 10, exit           # If character is newline, exit loop

    sb      $v0, 0($t0)             # Store character in $t0
    addi    $t0, $t0, 1             # Increment $t0

    j       loop                    # Repeat loop

exit:
    sb      $zero, 0($t0)           # Null terminate string

.end_macro


## Check Password Macro ##
.macro checkPw

    la      $t0, userInput          # Load address of userInput into $t0
    la      $t1, password           # Load address of password into $t1

loop:                               # Loop through each character of the password

    lb      $t2, 0($t0)             # Load byte from userInput into $t2
    lb      $t3, 0($t1)             # Load byte from password into $t3

    beq     $t3, $zero, correct     # If end of password, correct
    bne     $t2, $t3, incorrect     # If characters don't match, incorrect

    addi    $t0, $t0, 1             # Increment $t0
    addi    $t1, $t1, 1             # Increment $t1
    j       loop                    # Repeat loop for next character

correct:                            # Correct password

    printString(correctMsg)         # Print correct message
    j       exit                    # Exit program

incorrect:                          # Incorrect password

    printString(incorrectMsg)       # Print incorrect message

.end_macro


## Main ##
main:

    printString(pwdMsg)             # Print password message

    readString(userInput)           # Read password

    checkPw                         # Check password
    j      main                     # Return to main if incorrect

exit:                               # Exit program

    li      $v0, 10                 # Exit program
    syscall

