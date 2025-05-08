# Module 26 heartbleed demo
# A simplified implementation of the Heartbleed vulnerability in MIPS.
# See: https://xkcd.com/1354
#
# As a part of its "heartbeat" implementation, OpenSSL used to
# echo back a user-supplied phrase of a user-supplied length.
# Check to make sure the server was still "alive".
#
# The OpenSSL implementation never checked to make sure the
# payload was really the same size as the length field!
# This missing bounds check allowed attackers to read raw memory data.
#
# The attacker would send a request to the server's "heartbeat" route.
# This request would contain a phrase and a length field much larger
# then the given phrase.
# This caused the server to echo back a contiguous block of memory
# the same size as the requested length, regardless of what it
# contained!


.data

newLine:            .asciiz "\n"
heartbeatPrompt:    .asciiz "Enter phrase used to confirm heartbeat: "
heartbeatLenPrompt: .asciiz "Enter length of heartbeat phrase: "

# Memory space for user-submitted data
heartbeatLen:       .word 0     # User specified length
heartbeat:          .space 16   # User specified heartbeat phrase

# Memory statically set for demonstration purposes.
# In reality, this would be a snapshot of memory at the time of attack.
.asciiz "You know who else has a critical security vulnerability? My mom!"
.word 42 69 37 1024
.asciiz "Authorization: Basic admin:@dm1n_Pa$$w0rd"
.space 8
.asciiz "-----BEGIN RSA PRIVATE KEY-----\nMIIBOgIBAAJBAKj34GkxFhD90vcNLYLInFEX6Ppy1tPf9Cnzj4p4WGeKLs1Pt8Qu"

.text

## Print String Macro ##
.macro printString($msg)                # Print message macro

    li      $v0, 4                      # Load code for print string into $v0
    la      $a0, $msg                   # Load address of message into $a0
    syscall                             # Print message

.end_macro


## Print Length String Macro ##
.macro printLenString($msg, $len)       # Print message macro

    la      $t1, $msg                   # Load address of $msg into $t1

    la      $t0, $len                   # Load address of $len into $t0
    lw      $t0, 0($t0)                 # Load length into $t0
    add     $t0, $t0, $t1               # Add length to address of $msg

loop:
    lb      $t2, 0($t1)                 # Load byte from $msg into $t2

    beq     $t1, $t0, exit              # If end of message, exit loop

    li      $v0, 11                     # Load code for print character into $v0
    move    $a0, $t2                    # Load character into $a0
    syscall                             # Print character

    addi    $t1, $t1, 1                 # Increment $t1

    j       loop                        # Repeat loop

exit:
    nop                                 # Do nothing after loop

.end_macro


## Read String Macro ##
.macro readString($addr)

    la      $t0, $addr                  # Load address of $addr into $a0

loop:
    li      $v0, 12                     # Load code for read character into $v0
    syscall                             # Read character

    beq     $v0, 10, exit               # If character is newline, exit loop

    sb      $v0, 0($t0)                 # Store character in $t0
    addi    $t0, $t0, 1                 # Increment $t0

    j       loop                        # Repeat loop

exit:
    nop                                 # Do nothing after loop

.end_macro


## Read Integer Macro ##
.macro readInt($addr)

    li      $t1, 0                      # Initialize $t1 to 0, use to store final integer
    la      $t0, $addr                  # Load address of $addr into $a0

    li      $t3, 10                     # Initialize $t3 to 10, use to shift digits left

loop:
    li      $v0, 12                     # Load code for read character into $v0
    syscall                             # Read character

    beq     $v0, 10, exit               # If character is newline, exit loop

    mul     $t1, $t1, $t3               # Shift digits left

    subi    $v0, $v0, 48                # Convert ASCII to integer
    add     $t1, $t1, $v0               # Add integer to $t1

    j       loop                        # Repeat loop

exit:
    sw      $t1, 0($t0)                 # Store integer in $t0

.end_macro

## Heartbeat Macro ##
.macro heartbeat
    printString(heartbeatLenPrompt)     # Print prompt for heartbeat length
    readInt(heartbeatLen)               # Read integer for heartbeat length

    printString(heartbeatPrompt)        # Print prompt for heartbeat
    readString(heartbeat)               # Read string for heartbeat

    printLenString(heartbeat, heartbeatLen) # Print heartbeat

.end_macro


## Main ##
main:

loop:
    heartbeat                           # Heartbeat macro

    printString(newLine)                # Print newline
    j       loop                         # Repeat loop for next character
