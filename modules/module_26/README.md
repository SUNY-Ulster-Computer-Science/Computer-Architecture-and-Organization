# MIPS Exploit Demos

A series of common exloits implemented using MIPS.

## Buffer Overflow

This example presents a buffer overflow.
It is a simple program that checks if a user input matches
a secret password.  However, the user input memory area
is set right before the password without any bounds checking.

This allows a user to present a sufficently long input and overflow
their buffer into the password memory, overwriting it.  Exploiting
this properly allows an attacker to be allowed access without knowing
the secret password.

## Heartbleed

This is a simple example of the famous *Heartbleed* vulnerability.
It implements the *heartbeat* functionality of a server, allowing
a user to specify a phrase and its length, then echoing the phrase
of that length to the user.  This was originally intended to show
that the server is alive and functioning properly.

However, since the user is allowed to specify any arbitrary length,
they can instruct the server to read out portions of its memory that
are not part of the echo functionality.  This leaks potentially
sensitive information back to the attacker.
