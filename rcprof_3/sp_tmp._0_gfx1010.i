# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-799214\\input\\CompileCLSource"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 372 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-799214\\input\\CompileCLSource" 2




kernel void add(global float *a, global float *b, global float *c,
                                      unsigned int M, unsigned int N, unsigned int K)
{
    int i = get_global_id(0);
    int j = get_global_id(1);
    int local_i = get_local_id(0);
    int local_j = get_local_id(1);
    local union {
        float mat[16][16 + 4];
        float4 vec[16][(16 / 4 + 1)];
    } tileA;
    local float4 tileB[16][(16 / 4 + 1)];
    float4 sum = 0.0;
    for (int tileK = 0; tileK * 16 < K; ++tileK) {
        tileA.vec[local_j][local_i] = vload4(0, &a[j * K + tileK * 16 + local_i * 4]);
        tileB[local_j][local_i] = vload4(0, &b[(tileK * 16 + local_j) * N + i * 4]);
        barrier(CLK_LOCAL_MEM_FENCE);
        for (int k = 0; k < 16; ++k) {
            sum += tileA.mat[local_j][k] * tileB[k][local_i];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    vstore4(sum, 0, &c[j * N + i * 4]);
}
