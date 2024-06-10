	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx1010"
	.protected	add             ; -- Begin function add
	.globl	add
	.p2align	8
	.type	add,@function
add:                                    ; @add
; %bb.0:
	v_mov_b32_e32 v2, s4
	v_mov_b32_e32 v3, s5
	s_load_dword s4, s[4:5], 0x4
	s_load_dwordx4 s[0:3], s[6:7], 0x10
	s_waitcnt lgkmcnt(0)
	s_load_dwordx2 s[2:3], s[6:7], 0x1c
	s_load_dwordx4 s[12:15], s[6:7], 0x28
	global_load_ushort v2, v[2:3], off offset:6
	s_mov_b32 s11, s10
                                        ; implicit-def: $vcc_hi
	s_mov_b32 s32, s11
	s_and_b32 s4, s4, 0xffff
	s_waitcnt lgkmcnt(0)
	s_cmp_lg_u32 s3, 0
	s_mul_i32 s8, s8, s4
	v_add3_u32 v3, s12, s8, v0
	s_waitcnt vmcnt(0)
	v_mul_lo_u32 v2, s9, v2
	v_add3_u32 v2, s14, v2, v1
	s_cbranch_scc0 BB0_3
; %bb.1:
	v_mul_lo_u32 v4, v1, s2
	v_mul_lo_u32 v5, v2, s3
	s_load_dwordx4 s[4:7], s[6:7], 0x0
	v_mov_b32_e32 v10, 0
	s_movk_i32 s10, 0x50
	v_lshlrev_b32_e32 v3, 2, v3
	v_lshlrev_b32_e32 v8, 4, v0
	s_lshl_b32 s8, s2, 4
	v_mov_b32_e32 v9, v10
	v_mad_u32_u24 v13, v1, s10, 0x500
	v_mov_b32_e32 v11, v10
	v_mov_b32_e32 v12, v10
	s_mov_b32 s9, 0
	v_mad_u32_u24 v1, v1, s10, v8
	v_add_nc_u32_e32 v14, v13, v8
	v_add_nc_u32_e32 v15, v4, v3
	v_lshl_add_u32 v0, v0, 2, v5
	v_mov_b32_e32 v4, v9
	v_mov_b32_e32 v5, v10
	v_mov_b32_e32 v6, v11
	v_mov_b32_e32 v7, v12
BB0_2:                                  ; =>This Inner Loop Header: Depth=1
	v_add_nc_u32_e32 v9, s9, v0
	v_mov_b32_e32 v16, v10
	s_add_i32 s9, s9, 16
	v_lshlrev_b64 v[11:12], 2, v[9:10]
	v_lshlrev_b64 v[16:17], 2, v[15:16]
	v_add_nc_u32_e32 v15, s8, v15
	s_cmp_lt_u32 s9, s3
	s_waitcnt lgkmcnt(0)
	v_add_co_u32_e64 v11, vcc_lo, s4, v11
	v_add_co_ci_u32_e32 v12, vcc_lo, s5, v12, vcc_lo
	v_add_co_u32_e64 v20, vcc_lo, s6, v16
	v_add_co_ci_u32_e32 v21, vcc_lo, s7, v17, vcc_lo
	global_load_dwordx4 v[16:19], v[11:12], off
	global_load_dwordx4 v[20:23], v[20:21], off
	s_waitcnt vmcnt(1)
	ds_write2_b64 v14, v[16:17], v[18:19] offset1:1
	s_waitcnt vmcnt(0)
	ds_write2_b64 v1, v[20:21], v[22:23] offset1:1
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	ds_read2_b64 v[16:19], v13 offset1:1
	ds_read2_b64 v[20:23], v8 offset1:1
	ds_read2_b64 v[24:27], v8 offset0:10 offset1:11
	ds_read2_b64 v[28:31], v8 offset0:20 offset1:21
	ds_read2_b64 v[32:35], v8 offset0:30 offset1:31
	ds_read2_b64 v[36:39], v13 offset0:2 offset1:3
	ds_read2_b64 v[43:46], v8 offset0:40 offset1:41
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v7, v16, v23
	v_fma_f32 v6, v16, v22, v6
	v_fma_f32 v4, v16, v20, v4
	v_fma_f32 v5, v16, v21, v5
	ds_read2_b64 v[20:23], v8 offset0:50 offset1:51
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v7, v17, v27
	v_fmac_f32_e32 v6, v17, v26
	v_fmac_f32_e32 v4, v17, v24
	v_fmac_f32_e32 v5, v17, v25
	ds_read2_b64 v[24:27], v8 offset0:60 offset1:61
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v7, v18, v31
	v_fmac_f32_e32 v6, v18, v30
	v_fmac_f32_e32 v4, v18, v28
	v_fmac_f32_e32 v5, v18, v29
	ds_read2_b64 v[28:31], v8 offset0:70 offset1:71
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v7, v19, v35
	v_fmac_f32_e32 v6, v19, v34
	v_fmac_f32_e32 v4, v19, v32
	v_fmac_f32_e32 v5, v19, v33
	ds_read2_b64 v[16:19], v13 offset0:4 offset1:5
	s_waitcnt lgkmcnt(4)
	v_fmac_f32_e32 v7, v36, v46
	v_fmac_f32_e32 v6, v36, v45
	v_fmac_f32_e32 v4, v36, v43
	v_fmac_f32_e32 v5, v36, v44
	ds_read2_b64 v[32:35], v8 offset0:80 offset1:81
	s_waitcnt lgkmcnt(4)
	v_fmac_f32_e32 v7, v37, v23
	v_fmac_f32_e32 v6, v37, v22
	v_fmac_f32_e32 v4, v37, v20
	v_fmac_f32_e32 v5, v37, v21
	ds_read2_b64 v[43:46], v8 offset0:90 offset1:91
	s_waitcnt lgkmcnt(4)
	v_fmac_f32_e32 v7, v38, v27
	v_fmac_f32_e32 v6, v38, v26
	v_fmac_f32_e32 v4, v38, v24
	v_fmac_f32_e32 v5, v38, v25
	ds_read2_b64 v[20:23], v8 offset0:100 offset1:101
	s_waitcnt lgkmcnt(4)
	v_fmac_f32_e32 v7, v39, v31
	v_fmac_f32_e32 v6, v39, v30
	v_fmac_f32_e32 v4, v39, v28
	v_fmac_f32_e32 v5, v39, v29
	ds_read2_b64 v[28:31], v8 offset0:110 offset1:111
	ds_read2_b64 v[24:27], v13 offset0:6 offset1:7
	ds_read2_b64 v[39:42], v8 offset0:120 offset1:121
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v4, v16, v32
	v_fmac_f32_e32 v5, v16, v33
	v_fmac_f32_e32 v6, v16, v34
	v_fmac_f32_e32 v7, v16, v35
	ds_read2_b64 v[32:35], v8 offset0:130 offset1:131
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v4, v17, v43
	v_fmac_f32_e32 v5, v17, v44
	v_fmac_f32_e32 v6, v17, v45
	v_fmac_f32_e32 v7, v17, v46
	ds_read2_b64 v[43:46], v8 offset0:140 offset1:141
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v4, v18, v20
	v_fmac_f32_e32 v5, v18, v21
	v_fmac_f32_e32 v6, v18, v22
	v_fmac_f32_e32 v7, v18, v23
	ds_read2_b64 v[20:23], v8 offset0:150 offset1:151
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v4, v19, v28
	v_fmac_f32_e32 v5, v19, v29
	v_fmac_f32_e32 v6, v19, v30
	v_fmac_f32_e32 v7, v19, v31
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	v_fmac_f32_e32 v4, v24, v39
	v_fmac_f32_e32 v5, v24, v40
	v_fmac_f32_e32 v6, v24, v41
	v_fmac_f32_e32 v7, v24, v42
	s_waitcnt lgkmcnt(0)
	s_barrier
	v_fmac_f32_e32 v4, v25, v32
	v_fmac_f32_e32 v5, v25, v33
	v_fmac_f32_e32 v6, v25, v34
	v_fmac_f32_e32 v7, v25, v35
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	v_fmac_f32_e32 v4, v26, v43
	v_fmac_f32_e32 v5, v26, v44
	v_fmac_f32_e32 v6, v26, v45
	v_fmac_f32_e32 v7, v26, v46
	v_fmac_f32_e32 v4, v27, v20
	v_fmac_f32_e32 v5, v27, v21
	v_fmac_f32_e32 v6, v27, v22
	v_fmac_f32_e32 v7, v27, v23
	s_cbranch_scc1 BB0_2
	s_branch BB0_4
BB0_3:
	v_mov_b32_e32 v4, 0
	v_lshlrev_b32_e32 v3, 2, v3
	v_mov_b32_e32 v5, v4
	v_mov_b32_e32 v6, v4
	v_mov_b32_e32 v7, v4
BB0_4:                                  ; %.loopexit
	v_mul_lo_u32 v0, v2, s2
	v_mov_b32_e32 v1, 0
	v_add_nc_u32_e32 v0, v3, v0
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	v_add_co_u32_e64 v0, vcc_lo, s0, v0
	v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo
	global_store_dwordx4 v[0:1], v[4:7], off
	s_endpgm
	.section	.rodata,#alloc
	.p2align	6
	.amdhsa_kernel add
		.amdhsa_group_segment_fixed_size 2560
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_user_sgpr_private_segment_buffer 1
		.amdhsa_user_sgpr_dispatch_ptr 1
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_flat_scratch_init 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_wavefront_size32 1
		.amdhsa_system_sgpr_private_segment_wavefront_offset 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 1
		.amdhsa_next_free_vgpr 47
		.amdhsa_next_free_sgpr 33
		.amdhsa_reserve_flat_scratch 0
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_workgroup_processor_mode 1
		.amdhsa_memory_ordered 1
		.amdhsa_forward_progress 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
.Lfunc_end0:
	.size	add, .Lfunc_end0-add
                                        ; -- End function
	.section	.AMDGPU.csdata
; Kernel info:
; codeLenInByte = 940
; NumSgprs: 35
; NumVgprs: 47
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 2560 bytes/workgroup (compile time only)
; SGPRBlocks: 4
; VGPRBlocks: 5
; NumSGPRsForWavesPerEU: 35
; NumVGPRsForWavesPerEU: 47
; Occupancy: 20
; WaveLimiterHint : 1
; COMPUTE_PGM_RSRC2:USER_SGPR: 8
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 0
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 1
	.text
	.p2alignl 6, 3214868480
	.fill 48, 4, 3214868480

	.ident	"clang version 8.0 "
	.section	".note.GNU-stack"
	.addrsig
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .name:           a
        .offset:         0
        .size:           8
        .type_name:      'float*'
        .value_kind:     global_buffer
        .value_type:     f32
      - .address_space:  global
        .name:           b
        .offset:         8
        .size:           8
        .type_name:      'float*'
        .value_kind:     global_buffer
        .value_type:     f32
      - .address_space:  global
        .name:           c
        .offset:         16
        .size:           8
        .type_name:      'float*'
        .value_kind:     global_buffer
        .value_type:     f32
      - .name:           M
        .offset:         24
        .size:           4
        .type_name:      uint
        .value_kind:     by_value
        .value_type:     u32
      - .name:           N
        .offset:         28
        .size:           4
        .type_name:      uint
        .value_kind:     by_value
        .value_type:     u32
      - .name:           K
        .offset:         32
        .size:           4
        .type_name:      uint
        .value_kind:     by_value
        .value_type:     u32
      - .offset:         40
        .size:           8
        .value_kind:     hidden_global_offset_x
        .value_type:     i64
      - .offset:         48
        .size:           8
        .value_kind:     hidden_global_offset_y
        .value_type:     i64
      - .offset:         56
        .size:           8
        .value_kind:     hidden_global_offset_z
        .value_type:     i64
      - .address_space:  global
        .offset:         64
        .size:           8
        .value_kind:     hidden_none
        .value_type:     i8
      - .address_space:  global
        .offset:         72
        .size:           8
        .value_kind:     hidden_none
        .value_type:     i8
      - .address_space:  global
        .offset:         80
        .size:           8
        .value_kind:     hidden_none
        .value_type:     i8
      - .address_space:  global
        .offset:         88
        .size:           8
        .value_kind:     hidden_multigrid_sync_arg
        .value_type:     i8
    .group_segment_fixed_size: 2560
    .kernarg_segment_align: 8
    .kernarg_segment_size: 96
    .language:       OpenCL C
    .language_version:
      - 1
      - 2
    .max_flat_workgroup_size: 256
    .name:           add
    .private_segment_fixed_size: 0
    .sgpr_count:     35
    .sgpr_spill_count: 0
    .symbol:         add.kd
    .vgpr_count:     47
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.version:
  - 1
  - 0
...

	.end_amdgpu_metadata
