// Assignment 11 test program

/**
 * A brief refresher on how C stores matrices in memory
 *
 * Suppose we have a matrix:
 * int **A[2][3]; // (two high and three wide)
 * and accessed like A[row][col]
 *
 * |0,0|0,1|0,2|
 * |1,0|1,1|1.2|
 *
 * It is stored in memory like:
 *
 * |0,0|0,1|0,2|1,0|1,1|1.2|
 *
 * Elements in the same row are stored next to eachother, but elements in the
 * same column are not!
 */

void gather(int **A, int **B) {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8000; j++) {
            A[i][j] = B[i][0] + A[j][i];
        }
    }
}