#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_INPUT_LEN 100
#define MAX_HISTORY_LEN 100

/**
 * Adds the paths in argv to the PATH environment variable
*/
void addPaths(int argc, char** argv) {
    const char* path = getenv("PATH");
    int len = strlen(path);

    int sum = 0;
    int argLens[argc];
    for (int i = 1; i < argc; i++) {
        argLens[i] = strlen(argv[i]);
        sum += (argLens[i] + 1);
    }

    char *newpath = malloc(len + sum);
    strcat(newpath, path);
    for (int i = 1; i < argc; i++) {
        strcat(newpath, ":");
        strcat(newpath, argv[i]);
    }
}

/**
 * Gets the input from the user and stores it in input
*/
char* getInput(char* input, int* len) {
    printf("$ ");
    fflush(stdout);

    char c;
    int i = 0;

    while((c = getchar()) != '\n' && c != EOF) {
        input[i++] = c;
    }

    input[i] = '\0';
    *len = i;
}

/**
 * Calls the command given by the user and adds the command to the history
*/
void callCommand(char* input, int* len, char* history, int* pidHistory, int historyLen) {
    int pidOfCommandProcess = getpid();

    strcpy(history + MAX_INPUT_LEN * historyLen, input);
    pidHistory[historyLen] = pidOfCommandProcess;

    char const delim = ' ';
    char *command;
    char *buffer[MAX_INPUT_LEN] = {0};
    int numArgs = 0;

    char *token;
    token = strtok(input, &delim);
    buffer[numArgs++] = token;

    while ((token = strtok(NULL, &delim)) != NULL) {
        buffer[numArgs++] = token;
    }

    command = buffer[0];

    if (strcmp(command, "exit") == 0) {
        exit(0);
    }
    else if (strcmp(command, "cd") == 0) {
        if (chdir(buffer[1]) != 0) {
            perror("chdir failed");
        }
    } else if (strcmp(command, "history") == 0) {
        for (int i = 0; i < historyLen + 1; i++) {
            printf("%d %s\n", pidHistory[i], (history + 100 * i));
        }
    } else {
        int pid = fork();
        if (pid == 0) {
            execvp(buffer[0], buffer);
            perror("execvp failed");
            exit(0);
        } else if (pid < 0) {
            perror("fork failed");
        } else {
            wait(NULL);
            pidHistory[historyLen] = pid;
        }
    }
}

/**
 * Main function
*/
int main(int argc, char** argv) {
    addPaths(argc, argv);

    char* history = malloc(MAX_INPUT_LEN * MAX_HISTORY_LEN * sizeof(char));
    int pidHistory[MAX_HISTORY_LEN];
    int historyLen = 0;


    char input[MAX_INPUT_LEN];
    int len;
    while (1) {
        getInput(input, &len);
        callCommand(input, &len, history, pidHistory, historyLen++);
    }

    free(history);
}