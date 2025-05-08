# Command Table Definition and use example

.data

msg:    .asciiz "Exit cmd invoked\n"


.text
.globl Exit

Exit:
    li      $v0, 4      # service 4 is print null terminated string
    la      $a0, msg    # load msg address
    syscall

    jr      $ra
