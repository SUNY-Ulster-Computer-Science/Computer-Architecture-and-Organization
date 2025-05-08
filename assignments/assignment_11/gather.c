// Assignment 11 test program

void gather(int **A, int **B) {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8000; j++) {
            A[i][j] = B[i][0] + A[j][i];
        }
    }
}