# Module 13 Demo A
# Important: do not put any other data before the frameBuffer
# Also: the Bitmap Display tool must be connected to MARS and set to
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 (static data)

.data
frameBuffer:	.space 0x80000		# Size of bit mapped display in words (512 x 256 x 4)
color:		.word 0x0014fed0	# The color of the pointer (red)
# The bit-mapped display reads pixels with a bit-depth of 24 (3 bytes)
# The first byte (from the left) in the word is unused, the second ir red, third green, and fourth blue

.text

# Example of drawing a rectangle; left x-coordinate is 100, width is 100
# top y-coordinate is 50, height is 50. The coordinate system starts with
# (0,0) at the display's upper left corner and increases to the right
# and down.  (Notice that the y direction is the opposite of math tradition.)
main:

	# Set up agruments
	li 	$a0, 100		# Left x coordinate
	li 	$a1, 100		# Width
	li 	$a2, 50			# Top y coordinate (y increases downward)
	li 	$a3, 50			# Height
	
	jal 	rectangle		# Call rectangle procedure
	
	li 	$v0, 10			# Load exit code into $v0
	syscall				# Syscall


# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)
rectangle:

	bltz	$a1, rectReturn 	# Zero or less width: draw nothing
	bltz 	$a3, rectReturn 	# Zero or less height: draw nothing

	lw 	$t0, color		# Load the color value into $t0
	la 	$t1, frameBuffer	# Load the address of the frame buffer into $t1
	
	add 	$a1, $a1, $a0         	# Add width to xmin to get xmax
	add 	$a3, $a3, $a2		# Add height to ymin to get ymax
	
	sll 	$a0, $a0, 2             # Scale x value to bytes (4 bytes per pixel)
	sll 	$a1, $a1, 2		# Scale width value to bytes (4 bytes per pixel)
	sll 	$a2, $a2, 11            # Scale y value to bytes (512*4 bytes per display row)
	sll 	$a3, $a3, 11		# Scale height value to bytes (512*4 bytes per display row)
	
	addu 	$a3, $a3, $t1		# Store address of first pixel of ymax row in $a3
	addu 	$a3, $a3, $a0		# Store address of the bottom left pixel in the row after rectangle in $a3
	
	addu 	$t2, $a2, $t1         	# Store address of first pixel of ymin row in $t2
	addu 	$a2, $t2, $a0         	# Store address of the top left pixel in the rectangle in $a2
	addu 	$t2, $t2, $a1         	# Store address of the top right pixel of the rectangle in $t2
	li 	$t4, 0x800              # Store number of byter per row in $t4
	
rectYloop:				# The start of the outer loop that iterates over rows
	move 	$t3, $a2 		# Store address of leftmost pixel in the current row in $t3
	
rectXloop:				# The start of the inner loop that iterates over columns in a row
	sw 	$t0, ($t3)		# Store the drawing color at the current pixel
	addiu 	$t3, $t3, 4		# Move to the next pixel
	
	move	$t5, $a0		# Save contents of $a0 in $t5
	li	$a0, 1			# Load delay in miliseconds into $a0
	li	$v0, 32			# Load code for sleep syscall into $v0
	syscall				# Syscall to pause slightly for each pixel drawn
	move	$a0, $t5		# Restore contents of $a0 from $t5
	
	bne 	$t3, $t2, rectXloop    	# Loop while not at the rightmost pixel in the row
	
	addu 	$a2, $a2, $t4           # Advance one row's worth for the left edge pointer in $a2
	addu 	$t2, $t2, $t4           # Advance one row's worth for the right edge pointer in $t2
	bne 	$a2, $a3, rectYloop     # Loop while not at the bottom rightmost pixel in the rectangle

rectReturn:
	jr 	$ra			# Return to caller
