#define LOC_SIZE_r2 16
#define LOC_SIZE_r3 30
#define THREAD_WORK_X 2
#define THREAD_WORK_Y 3
#define SIZE_VEC_r3 (LOC_SIZE_r3 / THREAD_WORK_X)

#define TILE_SIZE 32
#define SIZE_VEC (TILE_SIZE / THREAD_WORK_X)

#define vloadn vload2
#define vstoren vstore2
#define floatn float2


kernel void globalmem_r1(global const float* A, global const float* B, global float* C, 
                                    uint M, uint N, uint K)
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

kernel void localmem_r2(global const float *A, global const float *B, global float *C,
                                    uint M, uint N, uint K)
{
    uint i = get_global_id(0);
    uint j = get_global_id(1);
    uint local_i = get_local_id(0);
    uint local_j = get_local_id(1);
    local float tileA[LOC_SIZE_r2][LOC_SIZE_r2 + 1];
    local float tileB[LOC_SIZE_r2][LOC_SIZE_r2 + 1]; 

    float sum = 0.0;
    for (int tileK = 0; tileK * LOC_SIZE_r2 < K; ++tileK) {
        tileA[local_j][local_i] = A[j * K + (tileK * LOC_SIZE_r2 + local_i)];
        tileB[local_j][local_i] = B[(tileK * LOC_SIZE_r2 + local_j) * N + i];
        barrier(CLK_LOCAL_MEM_FENCE);
        for (int k = 0; k < LOC_SIZE_r2; ++k) {
            sum += tileA[local_j][k] * tileB[k][local_i];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    C[j * N + i] = sum;
}


/*kernel void localmem_vector_r3(global float *A, global float *B, global float *C,
                                    unsigned int M, unsigned int N, unsigned int K)
{
    uint i = get_global_id(0);
    uint j = get_global_id(1);
    uint local_i = get_local_id(0);
    uint local_j = get_local_id(1);
    uint group_j = get_group_id(1);

    local union {
        float mat[LOC_SIZE_r3][LOC_SIZE_r3];
        floatn vec[LOC_SIZE_r3][SIZE_VEC_r3];
    } tileA;
    local floatn tileB[LOC_SIZE_r3][SIZE_VEC_r3]; 
    floatn sum[3] = {0.0, 0.0, 0.0};
    for (int tileK = 0; tileK * LOC_SIZE_r3 < K; ++tileK) {
        tileA.vec[local_j* THREAD_WORK_Y][local_i] = vloadn(0, &A[(local_j * THREAD_WORK_Y + tileK * LOC_SIZE_r3) * M  + local_i * THREAD_WORK_X + group_j * LOC_SIZE_r3]);
        tileA.vec[local_j* THREAD_WORK_Y+1][local_i] = vloadn(0, &A[(local_j* THREAD_WORK_Y+1 + tileK * LOC_SIZE_r3) * M  + local_i * THREAD_WORK_X + group_j * LOC_SIZE_r3]);
        tileA.vec[local_j* THREAD_WORK_Y+2][local_i] = vloadn(0, &A[(local_j* THREAD_WORK_Y+2 + tileK * LOC_SIZE_r3) * M  + local_i * THREAD_WORK_X + group_j * LOC_SIZE_r3]);
        tileB[local_j* THREAD_WORK_Y][local_i] = vloadn(0, &B[(tileK * LOC_SIZE_r3 + local_j* THREAD_WORK_Y) * N + i * THREAD_WORK_X]);
        tileB[local_j* THREAD_WORK_Y+1][local_i] = vloadn(0, &B[(tileK * LOC_SIZE_r3 + local_j* THREAD_WORK_Y+1) * N + i * THREAD_WORK_X]);
        tileB[local_j* THREAD_WORK_Y+2][local_i] = vloadn(0, &B[(tileK * LOC_SIZE_r3 + local_j* THREAD_WORK_Y+2) * N + i * THREAD_WORK_X]);
        barrier(CLK_LOCAL_MEM_FENCE);        
       
        for (int k = 0; k < LOC_SIZE_r3; ++k) { 
            floatn subtileA = tileA.vec[k][local_j];
            floatn subtileB = tileB[k][local_i];
            sum[0] += subtileA.x * subtileB;
            sum[1] += subtileA.y * subtileB;
            sum[2] += tileA.mat[k][20 + local_j] * subtileB;
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    vstoren(sum[0], 0, &C[j*THREAD_WORK_X * N + i * THREAD_WORK_X]);
    vstoren(sum[1], 0, &C[(j*THREAD_WORK_X + 1) * N + i * THREAD_WORK_X]);
    vstoren(sum[2], 0, &C[(j*THREAD_WORK_X + 20) * N + i * THREAD_WORK_X]);
}*/

kernel void localmem_vector_r3(global float *a, global float *b, global float *c,
                                      unsigned int M, unsigned int N, unsigned int K)
{
    uint i = get_global_id(0);
    uint j = get_global_id(1);
    uint local_i = get_local_id(0);
    uint local_j = get_local_id(1);
    uint group_j = get_group_id(1);

    local floatn tileA[TILE_SIZE][SIZE_VEC]; 	
    local floatn tileB[TILE_SIZE][SIZE_VEC]; 
    floatn sum[2] = {0.0, 0.0};
    for (int tileK = 0; tileK * TILE_SIZE < K; ++tileK) {
        tileA[local_j* THREAD_WORK_Y][local_i] = vloadn(0, &a[(local_j * THREAD_WORK_Y + tileK * TILE_SIZE) * M  + local_i * THREAD_WORK_X + group_j * TILE_SIZE]);
        tileA[local_j* THREAD_WORK_Y+1][local_i] = vloadn(0, &a[(local_j* THREAD_WORK_Y+1 + tileK * TILE_SIZE) * M  + local_i * THREAD_WORK_X + group_j * TILE_SIZE]);
        tileB[local_j* THREAD_WORK_Y][local_i] = vloadn(0, &b[(tileK * TILE_SIZE + local_j* THREAD_WORK_Y) * N + i * THREAD_WORK_X]);
        tileB[local_j* THREAD_WORK_Y+1][local_i] = vloadn(0, &b[(tileK * TILE_SIZE + local_j* THREAD_WORK_Y+1) * N + i * THREAD_WORK_X]);
        barrier(CLK_LOCAL_MEM_FENCE);

        for (int k = 0; k < TILE_SIZE; ++k) { 
            floatn subtileA = tileA[k][local_j];
            floatn subtileB = tileB[k][local_i];
            sum[0] += subtileA.x * subtileB;
            sum[1] += subtileA.y * subtileB;
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    vstoren(sum[0], 0, &c[j*THREAD_WORK_Y * N + i * THREAD_WORK_X]);
    vstoren(sum[1], 0, &c[(j*THREAD_WORK_Y + 1) * N + i * THREAD_WORK_X]);
}
