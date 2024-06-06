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
	v_mov_b32_e32 v14, 0
	s_movk_i32 s8, 0x60
	v_lshlrev_b32_e32 v3, 3, v3
	v_lshlrev_b32_e32 v12, 5, v0
	s_mov_b32 s9, 0
	v_mov_b32_e32 v13, v14
	v_mad_u32_u24 v21, v1, s8, 0x600
	v_mov_b32_e32 v15, v14
	v_mov_b32_e32 v16, v14
	v_mov_b32_e32 v17, v14
	v_mov_b32_e32 v18, v14
	v_mov_b32_e32 v19, v14
	v_mov_b32_e32 v20, v14
	v_mad_u32_u24 v1, v1, s8, v12
	v_add_nc_u32_e32 v23, v4, v3
	v_lshl_add_u32 v0, v0, 3, v5
	v_mov_b32_e32 v4, v13
	v_add_nc_u32_e32 v22, v21, v12
	s_lshl_b32 s8, s2, 4
	v_mov_b32_e32 v5, v14
	v_mov_b32_e32 v6, v15
	v_mov_b32_e32 v7, v16
	v_mov_b32_e32 v8, v17
	v_mov_b32_e32 v9, v18
	v_mov_b32_e32 v10, v19
	v_mov_b32_e32 v11, v20
BB0_2:                                  ; =>This Inner Loop Header: Depth=1
	v_add_nc_u32_e32 v13, s9, v0
	v_mov_b32_e32 v24, v14
	s_add_i32 s9, s9, 16
	v_lshlrev_b64 v[15:16], 2, v[13:14]
	v_lshlrev_b64 v[17:18], 2, v[23:24]
	v_add_nc_u32_e32 v23, s8, v23
	s_cmp_lt_u32 s9, s3
	s_waitcnt lgkmcnt(0)
	v_add_co_u32_e64 v19, vcc_lo, s4, v15
	v_add_co_ci_u32_e32 v20, vcc_lo, s5, v16, vcc_lo
	v_add_co_u32_e64 v32, vcc_lo, s6, v17
	v_add_co_ci_u32_e32 v33, vcc_lo, s7, v18, vcc_lo
	global_load_dwordx4 v[15:18], v[19:20], off offset:16
	global_load_dwordx4 v[24:27], v[19:20], off
	global_load_dwordx4 v[28:31], v[32:33], off offset:16
	global_load_dwordx4 v[32:35], v[32:33], off
	s_waitcnt vmcnt(3)
	ds_write2_b64 v22, v[15:16], v[17:18] offset0:2 offset1:3
	s_waitcnt vmcnt(2)
	ds_write2_b64 v22, v[24:25], v[26:27] offset1:1
	s_waitcnt vmcnt(1)
	ds_write2_b64 v1, v[28:29], v[30:31] offset0:2 offset1:3
	s_waitcnt vmcnt(0)
	ds_write2_b64 v1, v[32:33], v[34:35] offset1:1
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	ds_read2_b64 v[15:18], v21 offset1:1
	ds_read2_b64 v[27:30], v12 offset1:1
	ds_read2_b64 v[43:46], v12 offset0:2 offset1:3
	ds_read2_b64 v[32:35], v21 offset0:2 offset1:3
	ds_read2_b64 v[39:42], v12 offset0:14 offset1:15
	s_waitcnt lgkmcnt(3)
	v_fma_f32 v4, v15, v27, v4
	v_fma_f32 v5, v15, v28, v5
	v_fma_f32 v6, v15, v29, v6
	v_fma_f32 v7, v15, v30, v7
	ds_read2_b64 v[27:30], v12 offset0:12 offset1:13
	s_waitcnt lgkmcnt(3)
	v_fma_f32 v8, v15, v43, v8
	v_fma_f32 v9, v15, v44, v9
	v_fma_f32 v10, v15, v45, v10
	v_fmac_f32_e32 v11, v15, v46
	ds_read2_b64 v[43:46], v12 offset0:24 offset1:25
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v8, v16, v39
	v_fmac_f32_e32 v9, v16, v40
	v_fmac_f32_e32 v10, v16, v41
	v_fmac_f32_e32 v11, v16, v42
	ds_read2_b64 v[39:42], v12 offset0:26 offset1:27
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v4, v16, v27
	v_fmac_f32_e32 v5, v16, v28
	v_fmac_f32_e32 v6, v16, v29
	v_fmac_f32_e32 v7, v16, v30
	ds_read2_b64 v[27:30], v12 offset0:38 offset1:39
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v4, v17, v43
	v_fmac_f32_e32 v5, v17, v44
	v_fmac_f32_e32 v6, v17, v45
	v_fmac_f32_e32 v7, v17, v46
	ds_read2_b64 v[43:46], v12 offset0:36 offset1:37
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v11, v17, v42
	v_fmac_f32_e32 v10, v17, v41
	v_fmac_f32_e32 v9, v17, v40
	v_fmac_f32_e32 v8, v17, v39
	ds_read2_b64 v[39:42], v12 offset0:48 offset1:49
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v11, v18, v30
	v_fmac_f32_e32 v10, v18, v29
	v_fmac_f32_e32 v9, v18, v28
	v_fmac_f32_e32 v8, v18, v27
	ds_read2_b64 v[27:30], v12 offset0:50 offset1:51
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v7, v18, v46
	v_fmac_f32_e32 v6, v18, v45
	v_fmac_f32_e32 v5, v18, v44
	v_fmac_f32_e32 v4, v18, v43
	ds_read2_b64 v[15:18], v12 offset0:62 offset1:63
	ds_read2_b64 v[43:46], v12 offset0:60 offset1:61
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v6, v32, v41
	v_fmac_f32_e32 v5, v32, v40
	v_fmac_f32_e32 v4, v32, v39
	ds_read2_b64 v[38:41], v12 offset0:72 offset1:73
	v_fmac_f32_e32 v7, v32, v42
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v11, v32, v30
	v_fmac_f32_e32 v10, v32, v29
	v_fmac_f32_e32 v9, v32, v28
	v_fmac_f32_e32 v8, v32, v27
	ds_read2_b64 v[27:30], v12 offset0:74 offset1:75
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v11, v33, v18
	v_fmac_f32_e32 v10, v33, v17
	v_fmac_f32_e32 v9, v33, v16
	v_fmac_f32_e32 v8, v33, v15
	ds_read2_b64 v[15:18], v12 offset0:86 offset1:87
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v4, v33, v43
	v_fmac_f32_e32 v5, v33, v44
	v_fmac_f32_e32 v6, v33, v45
	v_fmac_f32_e32 v7, v33, v46
	ds_read2_b64 v[43:46], v12 offset0:84 offset1:85
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v4, v34, v38
	v_fmac_f32_e32 v5, v34, v39
	ds_read2_b64 v[36:39], v21 offset0:4 offset1:5
	v_fmac_f32_e32 v6, v34, v40
	v_fmac_f32_e32 v7, v34, v41
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v8, v34, v27
	v_fmac_f32_e32 v11, v34, v30
	v_fmac_f32_e32 v10, v34, v29
	v_fmac_f32_e32 v9, v34, v28
	ds_read2_b64 v[24:27], v12 offset0:96 offset1:97
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v8, v35, v15
	v_fmac_f32_e32 v11, v35, v18
	v_fmac_f32_e32 v10, v35, v17
	v_fmac_f32_e32 v9, v35, v16
	ds_read2_b64 v[15:18], v12 offset0:98 offset1:99
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v7, v35, v46
	v_fmac_f32_e32 v4, v35, v43
	v_fmac_f32_e32 v5, v35, v44
	v_fmac_f32_e32 v6, v35, v45
	ds_read2_b64 v[28:31], v21 offset0:6 offset1:7
	ds_read2_b64 v[43:46], v12 offset0:110 offset1:111
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v4, v36, v24
	v_fmac_f32_e32 v5, v36, v25
	v_fmac_f32_e32 v6, v36, v26
	v_fmac_f32_e32 v7, v36, v27
	ds_read2_b64 v[24:27], v12 offset0:108 offset1:109
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v8, v36, v15
	v_fmac_f32_e32 v9, v36, v16
	v_fmac_f32_e32 v10, v36, v17
	v_fmac_f32_e32 v11, v36, v18
	ds_read2_b64 v[15:18], v12 offset0:120 offset1:121
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v9, v37, v44
	v_fmac_f32_e32 v10, v37, v45
	v_fmac_f32_e32 v11, v37, v46
	v_fmac_f32_e32 v8, v37, v43
	ds_read2_b64 v[43:46], v12 offset0:122 offset1:123
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v4, v37, v24
	v_fmac_f32_e32 v5, v37, v25
	v_fmac_f32_e32 v6, v37, v26
	v_fmac_f32_e32 v7, v37, v27
	ds_read2_b64 v[34:37], v12 offset0:134 offset1:135
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v4, v38, v15
	v_fmac_f32_e32 v5, v38, v16
	v_fmac_f32_e32 v6, v38, v17
	v_fmac_f32_e32 v7, v38, v18
	ds_read2_b64 v[15:18], v12 offset0:132 offset1:133
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v11, v38, v46
	v_fmac_f32_e32 v10, v38, v45
	v_fmac_f32_e32 v9, v38, v44
	v_fmac_f32_e32 v8, v38, v43
	ds_read2_b64 v[43:46], v12 offset0:144 offset1:145
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v11, v39, v37
	v_fmac_f32_e32 v10, v39, v36
	v_fmac_f32_e32 v9, v39, v35
	v_fmac_f32_e32 v8, v39, v34
	ds_read2_b64 v[34:37], v12 offset0:146 offset1:147
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v7, v39, v18
	v_fmac_f32_e32 v6, v39, v17
	v_fmac_f32_e32 v5, v39, v16
	v_fmac_f32_e32 v4, v39, v15
	ds_read2_b64 v[15:18], v12 offset0:158 offset1:159
	ds_read2_b64 v[38:41], v12 offset0:156 offset1:157
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v6, v28, v45
	v_fmac_f32_e32 v5, v28, v44
	v_fmac_f32_e32 v4, v28, v43
	v_fmac_f32_e32 v7, v28, v46
	ds_read2_b64 v[42:45], v12 offset0:168 offset1:169
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v11, v28, v37
	v_fmac_f32_e32 v10, v28, v36
	v_fmac_f32_e32 v9, v28, v35
	v_fmac_f32_e32 v8, v28, v34
	ds_read2_b64 v[25:28], v12 offset0:170 offset1:171
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v11, v29, v18
	v_fmac_f32_e32 v10, v29, v17
	v_fmac_f32_e32 v9, v29, v16
	v_fmac_f32_e32 v8, v29, v15
	s_waitcnt lgkmcnt(2)
	v_fmac_f32_e32 v7, v29, v41
	v_fmac_f32_e32 v6, v29, v40
	v_fmac_f32_e32 v5, v29, v39
	v_fmac_f32_e32 v4, v29, v38
	ds_read2_b64 v[15:18], v12 offset0:182 offset1:183
	ds_read2_b64 v[38:41], v12 offset0:180 offset1:181
	s_waitcnt lgkmcnt(3)
	v_fmac_f32_e32 v6, v30, v44
	v_fmac_f32_e32 v5, v30, v43
	v_fmac_f32_e32 v4, v30, v42
	v_fmac_f32_e32 v7, v30, v45
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	v_fmac_f32_e32 v11, v30, v28
	v_fmac_f32_e32 v10, v30, v27
	v_fmac_f32_e32 v9, v30, v26
	v_fmac_f32_e32 v8, v30, v25
	v_fmac_f32_e32 v11, v31, v18
	v_fmac_f32_e32 v10, v31, v17
	v_fmac_f32_e32 v9, v31, v16
	v_fmac_f32_e32 v8, v31, v15
	v_fmac_f32_e32 v7, v31, v41
	v_fmac_f32_e32 v6, v31, v40
	v_fmac_f32_e32 v5, v31, v39
	v_fmac_f32_e32 v4, v31, v38
	s_cbranch_scc1 BB0_2
	s_branch BB0_4
BB0_3:
	v_mov_b32_e32 v4, 0
	v_lshlrev_b32_e32 v3, 3, v3
	v_mov_b32_e32 v5, v4
	v_mov_b32_e32 v6, v4
	v_mov_b32_e32 v7, v4
	v_mov_b32_e32 v8, v4
	v_mov_b32_e32 v9, v4
	v_mov_b32_e32 v10, v4
	v_mov_b32_e32 v11, v4
BB0_4:                                  ; %.loopexit
	v_mul_lo_u32 v0, v2, s2
	v_mov_b32_e32 v1, 0
	v_add_nc_u32_e32 v0, v3, v0
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	v_add_co_u32_e64 v0, vcc_lo, s0, v0
	v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo
	global_store_dwordx4 v[0:1], v[8:11], off offset:16
	global_store_dwordx4 v[0:1], v[4:7], off
	s_endpgm
	.section	.rodata,#alloc
	.p2align	6
	.amdhsa_kernel add
		.amdhsa_group_segment_fixed_size 3072
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
; codeLenInByte = 1500
; NumSgprs: 35
; NumVgprs: 47
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 3072 bytes/workgroup (compile time only)
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
    .group_segment_fixed_size: 3072
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
