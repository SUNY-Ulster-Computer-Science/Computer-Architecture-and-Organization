# Command Table Definition and use example

.data
msg:    .asciiz "Echo cmd invoked\n"


.globl Echo

.text

Echo:
    li      $v0, 4      # service 4 is print null terminated string
    la      $a0, msg    # load msg address
    syscall

    jr      $ra
