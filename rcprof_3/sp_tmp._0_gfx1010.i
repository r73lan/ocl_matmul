# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-fbf721\\input\\CompileCLSource"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 372 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-fbf721\\input\\CompileCLSource" 2




kernel void add(global float *a, global float *b, global float *c,
                                      unsigned int M, unsigned int N, unsigned int K)
{
    uint i = get_global_id(0);
    uint j = get_global_id(1);
    uint local_i = get_local_id(0);
    uint local_j = get_local_id(1);
    uint group_i = get_group_id(0);
    uint group_j = get_group_id(1);

    local union {
        float mat[16][16];
        float4 vec[16][(16 / 4)];
    } tileA;
    local float4 tileB[16][(16 / 4)];
    float4 sum = 0.0;
    for (int tileK = 0; tileK * 16 < K; ++tileK) {


        tileA.vec[local_j][local_i] = vload4(0, &a[(local_j + tileK * 16) * M + local_i * 4 + group_j * 16]);
        tileB[local_j][local_i] = vload4(0, &b[(tileK * 16 + local_j) * N + i * 4]);
        barrier(CLK_LOCAL_MEM_FENCE);
        for (int k = 0; k < 16; ++k) {
            sum += tileA.mat[k][local_j] * tileB[k][local_i];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    vstore4(sum, 0, &c[j * N + i * 4]);
}
