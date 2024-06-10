# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-1f1ef4\\input\\CompileCLSource"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 372 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-1f1ef4\\input\\CompileCLSource" 2


kernel void add(global const float *a, global const float *b, global float *c,
                                    uint M, uint N, uint K)
{
    int i = get_global_id(0);
    int j = get_global_id(1);
    int local_i = get_local_id(0);
    int local_j = get_local_id(1);
    local float tileA[16][16 + 1];
    local float tileB[16][16 + 1];

    float sum = 0.0;
    for (int tileK = 0; tileK * 16 < K; ++tileK) {
        tileA[local_j][local_i] = a[j * K + (tileK * 16 + local_i)];
        tileB[local_j][local_i] = b[(tileK * 16 + local_j) * N + i];
        barrier(CLK_LOCAL_MEM_FENCE);
        for (int k = 0; k < 16; ++k) {
            sum += tileA[local_j][k] * tileB[k][local_i];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    c[j * N + i] = sum;
}
