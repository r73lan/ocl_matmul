# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-87740d\\input\\CompileCLSource"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 372 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Users\\OCL_US~1\\AppData\\Local\\Temp\\comgr-87740d\\input\\CompileCLSource" 2
kernel void add(global const float* A, global const float* B, global float* C, uint M, uint N, uint K)
{
    uint x = get_global_id(0);
    uint y = get_global_id(1);
    float sum = 0.0;
    for (uint i = 0; i < K; ++i)
    {
     sum += A[y * K + i] * B[i * N + x];
    }
    C[y * N + x] = sum;
}
