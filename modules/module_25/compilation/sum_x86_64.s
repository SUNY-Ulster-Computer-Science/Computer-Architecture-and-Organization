# Module 25 x86_64 assembled instruction sets Demo

    .file       "sum.c"
    .text
    .section    .rodata
.LC0:                                   # The output format string
    .string     "The sum is: %u \n"
    .text
    .globl      main                    # the label for the main function
    .type       main, @function
main:
.LFB0:
    .cfi_startproc
    pushq   %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register 6
    subq    $16, %rsp
    movl    $10, -4(%rbp)               # Move long immediate 10 into -4 offset from %rbp
    movl    $22, -8(%rbp)               # Move long immediate 22 into -8 offset from %rbp
    movl    -4(%rbp), %edx              # Move 10 (-4 offset from %rbp) into %edx
    movl    -8(%rbp), %eax              # Move 22 (-8 offset from %rbp) into %eax
    addl    %edx, %eax                  # Add the values of %edx and %eax and store in %eax
    movl    %eax, -12(%rbp)             # Move 32 in %eax into -12 offset from %rbp
    movl    -12(%rbp), %eax             # Move value back to %eax
    movl    %eax, %esi                  # Move value in %eax to %esi
    movl    $.LC0, %edi                 # Load address of .LC0 into %edi
    movl    $0, %eax                    # Clear %eax with zeroes
    call    printf                      # Call the printf function
    movl    $0, %eax                    # Clear %eax with zeroes
    leave
    .cfi_def_cfa 7, 8
    ret
    .cfi_endproc
.LFE0:
    .size       main, .-main
    .ident      "GCC: (GNU) 15.0.1 20250329 (Red Hat 15.0.1-0)"
    .section    .note.GNU-stack,"",@progbits
