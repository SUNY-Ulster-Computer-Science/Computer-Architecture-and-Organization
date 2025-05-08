// Assignment 14 test program

#include <stdio.h>
#include <string.h>

int main() {
    char s1[] = "ABCDEFGH";
    char s2[] = "IJKLMNOPQRST";
    char s0[50];
    s0[0] = '\0';

    strcat(s0, s1);
    strcat(s0, s2);

    printf("The string is: %s\n", s0);

    return 0;
}
