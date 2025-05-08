.data
msg:	.asciiz	"Exit cmd invoked\n"

.globl Exit 

.text

Exit: 	li  	$v0, 4   # service 4 is print null terminated string
    	la 	$a0, msg  # load msg address
    	syscall
    	
    	jr	$ra 
