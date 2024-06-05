/* Compiler options:
-c -emit-llvm -target amdgcn-amd-amdhsa -x cl -cl-kernel-arg-info -O3 -D__OPENCL_VERSION__=200 -D__IMAGE_SUPPORT__=1 -Xclang -cl-ext=+cl_khr_fp64,+cl_khr_global_int32_base_atomics,+cl_khr_global_int32_extended_atomics,+cl_khr_local_int32_base_atomics,+cl_khr_local_int32_extended_atomics,+cl_khr_int64_base_atomics,+cl_khr_int64_extended_atomics,+cl_khr_3d_image_writes,+cl_khr_byte_addressable_store,+cl_khr_fp16,+cl_khr_gl_sharing,+cl_khr_gl_depth_images,+cl_amd_device_attribute_query,+cl_amd_media_ops,+cl_amd_media_ops2,+cl_khr_d3d10_sharing,+cl_khr_d3d11_sharing,+cl_khr_dx9_media_sharing,+cl_khr_image2d_from_buffer,+cl_khr_subgroups,+cl_khr_gl_event,+cl_khr_mipmap_image,+cl_khr_mipmap_image_writes,+cl_amd_liquid_flash,+cl_amd_copy_buffer_p2p,+cl_amd_planar_yuv -mllvm -amdgpu-prelink  -include opencl-c.h 
*/

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