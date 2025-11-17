# Assignment 14 assembled x86_64 test program

	.file	"assgn_14.c"
	.text
	.section	.rodata
.LC0:
	.string	"The string is: %s\n"   # Format string for printf
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	# Function prologue - set up stack frame
	pushq	%rbp                      # Save old base pointer
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp                # Set up new base pointer
	.cfi_def_cfa_register 6
	subq	$80, %rsp                 # Allocate 80 bytes on stack for local variables
	
	# Initialize s1[] = "ABCDEFGH"
	# Load the string as a 64-bit immediate value (8 chars packed)
	movabsq	$5208208757389214273, %rax  # Load "ABCDEFGH" as packed bytes
	movq	%rax, -9(%rbp)              # Store at s1 location (rbp-9)
	movb	$0, -1(%rbp)                # Store null terminator
	
	# Initialize s2[] = "IJKLMNOPQRST"
	# Load first 8 characters
	movabsq	$5786930140093827657, %rax  # Load "IJKLMNOP" as packed bytes
	movq	%rax, -22(%rbp)             # Store first part at s2 location (rbp-22)
	# Load remaining characters
	movabsq	$23735511060336462, %rax    # Load "QRST" and null terminator
	movq	%rax, -17(%rbp)             # Store second part at s2+5
	
	# Initialize s0[50] as empty string
	movb	$0, -80(%rbp)               # Store null terminator at beginning of s0
	
	# Call strcat(s0, s1) - first concatenation
	leaq	-9(%rbp), %rdx              # Load address of s1 (source)
	leaq	-80(%rbp), %rax             # Load address of s0 (destination)
	movq	%rdx, %rsi                  # Second argument: source string
	movq	%rax, %rdi                  # First argument: destination string
	call	strcat                      # Call strcat function
	
	# Call strcat(s0, s2) - second concatenation
	leaq	-22(%rbp), %rdx             # Load address of s2 (source)
	leaq	-80(%rbp), %rax             # Load address of s0 (destination)
	movq	%rdx, %rsi                  # Second argument: source string
	movq	%rax, %rdi                  # First argument: destination string
	call	strcat                      # Call strcat function
	
	# Print the result using printf
	leaq	-80(%rbp), %rax             # Load address of concatenated string s0
	movq	%rax, %rsi                  # Second argument: string to print
	movl	$.LC0, %edi                 # First argument: format string
	movl	$0, %eax                    # Clear %eax (no vector registers used)
	call	printf                      # Call printf function
	
	# Return 0
	movl	$0, %eax                    # Set return value to 0
	
	# Function epilogue - clean up and return
	leave                               # Restore stack frame (mov %rbp, %rsp; pop %rbp)
	.cfi_def_cfa 7, 8
	ret                                 # Return to caller
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20250110 (Red Hat 14.2.1-7)"
	.section	.note.GNU-stack,"",@progbits
