        .file   "demo25.c"
        .machinemode zarch
        .machine "z13"
.text
        .section        .rodata
        .align  2
.LC0:                                           # The output format string
        .string "The sum is: %u \n"
.text
        .align  8
.globl main                                     # Label for the main function
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
        mvhi    164(%r11),10                    # Move halfword immediate 10 into the memory location 164 bytes offset from the address in %r11
        mvhi    168(%r11),22                    # Move halfword immediate 22 into the memory location 168 bytes offset from the address in %r11
        l       %r1,164(%r11)                   # Load 10 (stored at the previous offset) into %r1
        a       %r1,168(%r11)                   # Add 22 (stored at the other previous offset) to %r1
        st      %r1,172(%r11)                   # Store the sum from %r1 into an offset of 172 from %r11
        lgf     %r1,172(%r11)                   # Load 32 (stored at the last offset) into %r1
        lgr     %r3,%r1                         # Copies the value in %r1 to %r3
        larl    %r2,.LC0                        # Loads the address of the output string .LC0 into %r2
        brasl   %r14,printf@PLT                 # Branch relative to printf and save long return address to %r14
        lhi     %r1,0                           # load halfword immediate 0 to %r1
        lgfr    %r1,%r1                         # Load lower 32 bits of %r1 and sign extend them to all 64 bits
        lgr     %r2,%r1                         # Load all 64 bits of %r2 with contents of %r1
        lmg     %r11,%r15,264(%r11)             # Load %r11 through %r15 with memory from 264 bytes offset from %r11
        .cfi_restore 15                         # Restore registers
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