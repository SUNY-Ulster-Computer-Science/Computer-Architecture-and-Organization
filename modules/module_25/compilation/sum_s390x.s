        .file   "demo25.c"
        .machinemode zarch
        .machine "z13"
.text
        .section        .rodata
        .align  2
.LC0:
        .string "The sum is: %u \n"
.text
        .align  8
.globl main
        .type   main, @function
main:
.LFB0:
        .cfi_startproc
        stmg    %r11,%r15,88(%r15)
        .cfi_offset 11, -72
        .cfi_offset 12, -64
        .cfi_offset 13, -56
        .cfi_offset 14, -48
        .cfi_offset 15, -40
        lay     %r15,-176(%r15)
        .cfi_def_cfa_offset 336
        lgr     %r11,%r15
        .cfi_def_cfa_register 11
        mvhi    164(%r11),10
        mvhi    168(%r11),22
        l       %r1,164(%r11)
        a       %r1,168(%r11)
        st      %r1,172(%r11)
        lgf     %r1,172(%r11)
        lgr     %r3,%r1
        larl    %r2,.LC0
        brasl   %r14,printf@PLT
        lhi     %r1,0
        lgfr    %r1,%r1
        lgr     %r2,%r1
        lmg     %r11,%r15,264(%r11)
        .cfi_restore 15
        .cfi_restore 14
        .cfi_restore 13
        .cfi_restore 12
        .cfi_restore 11
        .cfi_def_cfa 15, 160
        br      %r14
        .cfi_endproc
.LFE0:
        .size   main, .-main
        .ident  "GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
        .section        .note.GNU-stack,"",@progbits