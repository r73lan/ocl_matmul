/* Compiler options:
-c -emit-llvm -target amdgcn-amd-amdhsa -x cl -cl-kernel-arg-info -O3 -D__OPENCL_VERSION__=200 -D__IMAGE_SUPPORT__=1 -Xclang -cl-ext=+cl_khr_fp64,+cl_khr_global_int32_base_atomics,+cl_khr_global_int32_extended_atomics,+cl_khr_local_int32_base_atomics,+cl_khr_local_int32_extended_atomics,+cl_khr_int64_base_atomics,+cl_khr_int64_extended_atomics,+cl_khr_3d_image_writes,+cl_khr_byte_addressable_store,+cl_khr_fp16,+cl_khr_gl_sharing,+cl_khr_gl_depth_images,+cl_amd_device_attribute_query,+cl_amd_media_ops,+cl_amd_media_ops2,+cl_khr_d3d10_sharing,+cl_khr_d3d11_sharing,+cl_khr_dx9_media_sharing,+cl_khr_image2d_from_buffer,+cl_khr_subgroups,+cl_khr_gl_event,+cl_khr_mipmap_image,+cl_khr_mipmap_image_writes,+cl_amd_liquid_flash,+cl_amd_copy_buffer_p2p,+cl_amd_planar_yuv -mllvm -amdgpu-prelink  -include opencl-c.h 
*/

#define TILE_SIZE 16
#define THREAD_WORK 4
#define SIZE_VEC (TILE_SIZE / THREAD_WORK)

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
        float mat[TILE_SIZE][TILE_SIZE];
        float4 vec[TILE_SIZE][SIZE_VEC];
    } tileA;
    local float4 tileB[TILE_SIZE][SIZE_VEC]; 
    float4 sum = 0.0;
    for (int tileK = 0; tileK * TILE_SIZE < K; ++tileK) {
        //tileA.vec[local_j][local_i] = vload4(0, &a[j * N + tileK * TILE_SIZE + local_i * THREAD_WORK]);
        //tileA.vec[local_j][local_i] = vload4(0, &a[(group_j * TILE_SIZE + local_j) * N + tileK * TILE_SIZE + local_i * THREAD_WORK]);
        tileA.vec[local_j][local_i] = vload4(0, &a[(local_j + tileK * TILE_SIZE) * M  + local_i * THREAD_WORK + group_j * TILE_SIZE]);
        tileB[local_j][local_i] = vload4(0, &b[(tileK * TILE_SIZE + local_j) * N + i * THREAD_WORK]);
        barrier(CLK_LOCAL_MEM_FENCE);
        for (int k = 0; k < TILE_SIZE; ++k) { 
            sum += tileA.mat[k][local_j] * tileB[k][local_i];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    vstore4(sum, 0, &c[j * N + i * THREAD_WORK]);
}