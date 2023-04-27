#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main() {
    char** a = {NULL, NULL, NULL};
    execvp("ls", a);
}