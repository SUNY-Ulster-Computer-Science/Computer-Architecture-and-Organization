# Command Table Definition and use example

.data

table:
    .asciiz "Help"
    .word  Help
    .asciiz "Echo"
    .word Echo
    .asciiz "Exit"
    .word Exit
endTbl:
    .word 0


.text

# initialize table addresses in registers
Main:
    la      $t0, table          # load start of table into $t0
    la      $t1, endTbl         # load end of table into $t1

loop:
    lw      $t2, 8($t0)
    jalr    $t2
    addi    $t0, $t0, 12
    bne     $t0, $t1, loop
    li      $v0, 10             # exit
    syscall