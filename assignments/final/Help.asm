
.data
msg:	.asciiz	"Help cmd invoked\n"
.globl Help 

.text

Help: 	li  	$v0, 4   # service 4 is print null terminated string
    	la 	$a0, msg  # load msg address
    	syscall
    	
    	jr	$ra 
