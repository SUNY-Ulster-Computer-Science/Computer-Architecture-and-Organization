# System macro file


.macro InputDialogInt (%promptAddr)	# Declare input macro with one argument
	li   	$v0, 51			# Load code for integer input in $v0
	la	$a0, %promptAddr	# Load the address of the argument into $a0
	syscall				# Syscall to ask for input using address in argument
.end_macro


.macro OutputInt(%outAddr)		# Declare output macro with one argument
	li   	$v0, 56			# Load code for integer output in $v0
	la	$a0, %outAddr		# Load address of the argument into $a0
					# Output integer already expected in $a1
	syscall				# Syscall to output an integer with a message	
.end_macro


.macro Finish				# Declare finish macro
	li	$v0, 10			# Load code for exit
	syscall				# Syscall
.end_macro
