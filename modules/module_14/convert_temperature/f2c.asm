# Module 14 convert temperature demo
# To convert Fahrenheit to celsius, the formula used is °C = 5/9(°F – 32)
# Input farenheight is in $f12
# Return value is in $f0
# For simplicity we have not saved and restored registers

.data

const5:     .float 5
const9:     .float 9
const32:    .float 32


.text
.globl f2c

# Procedure to convert the Fahrenheit input in $f12 to a Celsius output in $f0
f2c:
    lwc1    $f16, const5        # Load 5.0f into $f16
    lwc1    $f18, const9        # Load 9.0f into $f18
    div.s   $f16, $f16, $f18    # Store 5.0f / 9.0f in $f16
    lwc1    $f18, const32       # Load 32.0f into $f18
    sub.s   $f18, $f12, $f18    # Store input - 32.0f in $f18
    mul.s   $f0,  $f16, $f18    # Store 5.0f / 9.0f * (input - 32.0f) in $f0
    jr      $ra                 # Return to caller
