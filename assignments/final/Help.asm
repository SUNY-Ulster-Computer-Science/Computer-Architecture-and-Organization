# Command Table Definition and use example

.data

msg:    .asciiz "Help cmd invoked\n"


.text
.globl Help

Help:
    li      $v0, 4      # service 4 is print null terminated string
    la      $a0, msg    # load msg address
    syscall

    jr      $ra
