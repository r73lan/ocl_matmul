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
	s_load_dwordx4 s[12:15], s[6:7], 0x18
	s_load_dwordx4 s[16:19], s[6:7], 0x28
	s_load_dwordx4 s[0:3], s[6:7], 0x10
	global_load_ushort v2, v[2:3], off offset:6
	s_mov_b32 s20, s10
                                        ; implicit-def: $vcc_hi
	s_mov_b32 s32, s20
	s_waitcnt lgkmcnt(0)
	s_and_b32 s2, s4, 0xffff
	s_cmp_lg_u32 s14, 0
	s_mul_i32 s8, s8, s2
	v_add3_u32 v4, s16, s8, v0
	s_cbranch_scc0 BB0_3
; %bb.1:
	v_mul_lo_u32 v5, v1, s13
	v_mul_lo_u32 v6, v1, s12
	s_load_dwordx4 s[4:7], s[6:7], 0x0
	v_lshlrev_b32_e32 v7, 4, v0
	v_lshlrev_b32_e32 v8, 2, v0
	s_lshl_b32 s10, s9, 4
	s_movk_i32 s11, 0x400
	v_lshlrev_b32_e32 v0, 2, v4
	v_mov_b32_e32 v9, 0
	v_lshl_add_u32 v10, v1, 6, v7
	s_lshl_b32 s2, s13, 4
	s_lshl_b32 s3, s12, 4
	s_mov_b32 s8, 0
	v_lshl_or_b32 v11, v1, 2, s11
	v_mov_b32_e32 v3, v9
	v_add_nc_u32_e32 v12, s11, v10
	v_mov_b32_e32 v4, v9
	v_add_nc_u32_e32 v13, v5, v0
	v_add3_u32 v8, v6, s10, v8
	v_mov_b32_e32 v5, v9
	v_mov_b32_e32 v6, v9
BB0_2:                                  ; =>This Inner Loop Header: Depth=1
	v_lshlrev_b64 v[15:16], 2, v[8:9]
	v_mov_b32_e32 v14, v9
	s_add_i32 s8, s8, 16
	v_add_nc_u32_e32 v8, s3, v8
	v_lshlrev_b64 v[17:18], 2, v[13:14]
	v_add_nc_u32_e32 v13, s2, v13
	s_cmp_lt_u32 s8, s14
	s_waitcnt lgkmcnt(0)
	v_add_co_u32_e64 v14, vcc_lo, s4, v15
	v_add_co_ci_u32_e32 v15, vcc_lo, s5, v16, vcc_lo
	v_add_co_u32_e64 v19, vcc_lo, s6, v17
	v_add_co_ci_u32_e32 v20, vcc_lo, s7, v18, vcc_lo
	global_load_dwordx4 v[14:17], v[14:15], off
	global_load_dwordx4 v[18:21], v[19:20], off
	s_waitcnt vmcnt(1)
	ds_write2_b64 v12, v[14:15], v[16:17] offset1:1
	s_waitcnt vmcnt(0)
	ds_write2_b64 v10, v[18:19], v[20:21] offset1:1
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	ds_read2_b32 v[38:39], v11 offset1:16
	ds_read2_b64 v[14:17], v7 offset1:1
	ds_read2_b64 v[18:21], v7 offset0:8 offset1:9
	ds_read2_b32 v[40:41], v11 offset0:32 offset1:48
	ds_read2_b64 v[22:25], v7 offset0:16 offset1:17
	ds_read2_b64 v[26:29], v7 offset0:24 offset1:25
	ds_read2_b32 v[42:43], v11 offset0:64 offset1:80
	ds_read2_b64 v[30:33], v7 offset0:32 offset1:33
	ds_read2_b64 v[34:37], v7 offset0:40 offset1:41
	ds_read2_b32 v[44:45], v11 offset0:96 offset1:112
	s_waitcnt lgkmcnt(8)
	v_fmac_f32_e32 v6, v38, v17
	v_fma_f32 v5, v38, v16, v5
	v_fma_f32 v4, v38, v15, v4
	v_fma_f32 v3, v38, v14, v3
	ds_read2_b64 v[14:17], v7 offset0:48 offset1:49
	s_waitcnt lgkmcnt(8)
	v_fmac_f32_e32 v6, v39, v21
	v_fmac_f32_e32 v5, v39, v20
	v_fmac_f32_e32 v4, v39, v19
	v_fmac_f32_e32 v3, v39, v18
	ds_read2_b64 v[18:21], v7 offset0:56 offset1:57
	s_waitcnt lgkmcnt(7)
	v_fmac_f32_e32 v6, v40, v25
	v_fmac_f32_e32 v5, v40, v24
	v_fmac_f32_e32 v4, v40, v23
	v_fmac_f32_e32 v3, v40, v22
	ds_read2_b32 v[38:39], v11 offset0:128 offset1:144
	s_waitcnt lgkmcnt(7)
	v_fmac_f32_e32 v6, v41, v29
	v_fmac_f32_e32 v5, v41, v28
	v_fmac_f32_e32 v4, v41, v27
	v_fmac_f32_e32 v3, v41, v26
	ds_read2_b64 v[22:25], v7 offset0:64 offset1:65
	s_waitcnt lgkmcnt(6)
	v_fmac_f32_e32 v6, v42, v33
	v_fmac_f32_e32 v5, v42, v32
	v_fmac_f32_e32 v4, v42, v31
	v_fmac_f32_e32 v3, v42, v30
	ds_read2_b64 v[26:29], v7 offset0:72 offset1:73
	s_waitcnt lgkmcnt(6)
	v_fmac_f32_e32 v6, v43, v37
	v_fmac_f32_e32 v5, v43, v36
	v_fmac_f32_e32 v4, v43, v35
	v_fmac_f32_e32 v3, v43, v34
	ds_read2_b32 v[40:41], v11 offset0:160 offset1:176
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v6, v44, v17
	v_fmac_f32_e32 v5, v44, v16
	v_fmac_f32_e32 v4, v44, v15
	v_fmac_f32_e32 v3, v44, v14
	ds_read2_b64 v[30:33], v7 offset0:80 offset1:81
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v6, v45, v21
	v_fmac_f32_e32 v5, v45, v20
	v_fmac_f32_e32 v4, v45, v19
	v_fmac_f32_e32 v3, v45, v18
	ds_read2_b64 v[34:37], v7 offset0:88 offset1:89
	s_waitcnt lgkmcnt(4)
	v_fmac_f32_e32 v6, v38, v25
	v_fmac_f32_e32 v5, v38, v24
	v_fmac_f32_e32 v4, v38, v23
	v_fmac_f32_e32 v3, v38, v22
	ds_read2_b32 v[42:43], v11 offset0:192 offset1:208
	ds_read2_b64 v[14:17], v7 offset0:96 offset1:97
	s_waitcnt lgkmcnt(5)
	v_fmac_f32_e32 v6, v39, v29
	v_fmac_f32_e32 v5, v39, v28
	v_fmac_f32_e32 v4, v39, v27
	v_fmac_f32_e32 v3, v39, v26
	ds_read2_b64 v[18:21], v7 offset0:104 offset1:105
	ds_read2_b32 v[44:45], v11 offset0:224 offset1:240
	ds_read2_b64 v[22:25], v7 offset0:112 offset1:113
	ds_read2_b64 v[26:29], v7 offset0:120 offset1:121
	s_waitcnt lgkmcnt(7)
	v_fmac_f32_e32 v6, v40, v33
	v_fmac_f32_e32 v5, v40, v32
	v_fmac_f32_e32 v4, v40, v31
	v_fmac_f32_e32 v3, v40, v30
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	v_fmac_f32_e32 v6, v41, v37
	v_fmac_f32_e32 v5, v41, v36
	v_fmac_f32_e32 v4, v41, v35
	v_fmac_f32_e32 v3, v41, v34
	s_waitcnt lgkmcnt(0)
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	v_fmac_f32_e32 v6, v42, v17
	v_fmac_f32_e32 v5, v42, v16
	v_fmac_f32_e32 v4, v42, v15
	v_fmac_f32_e32 v3, v42, v14
	v_fmac_f32_e32 v6, v43, v21
	v_fmac_f32_e32 v5, v43, v20
	v_fmac_f32_e32 v4, v43, v19
	v_fmac_f32_e32 v3, v43, v18
	v_fmac_f32_e32 v6, v44, v25
	v_fmac_f32_e32 v5, v44, v24
	v_fmac_f32_e32 v4, v44, v23
	v_fmac_f32_e32 v3, v44, v22
	v_fmac_f32_e32 v6, v45, v29
	v_fmac_f32_e32 v5, v45, v28
	v_fmac_f32_e32 v4, v45, v27
	v_fmac_f32_e32 v3, v45, v26
	s_cbranch_scc1 BB0_2
	s_branch BB0_4
BB0_3:
	v_mov_b32_e32 v3, 0
	v_lshlrev_b32_e32 v0, 2, v4
	v_mov_b32_e32 v4, v3
	v_mov_b32_e32 v5, v3
	v_mov_b32_e32 v6, v3
BB0_4:                                  ; %.loopexit
	s_waitcnt vmcnt(0)
	v_and_b32_e32 v2, 0xffff, v2
	v_mul_lo_u32 v2, s9, v2
	v_add3_u32 v1, s18, v2, v1
	v_mul_lo_u32 v2, v1, s13
	v_mov_b32_e32 v1, 0
	v_add_nc_u32_e32 v0, v0, v2
	v_lshlrev_b64 v[0:1], 2, v[0:1]
	v_add_co_u32_e64 v0, vcc_lo, s0, v0
	v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo
	global_store_dwordx4 v[0:1], v[3:6], off
	s_endpgm
	.section	.rodata,#alloc
	.p2align	6
	.amdhsa_kernel add
		.amdhsa_group_segment_fixed_size 2048
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
		.amdhsa_next_free_vgpr 46
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
; codeLenInByte = 968
; NumSgprs: 35
; NumVgprs: 46
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 2048 bytes/workgroup (compile time only)
; SGPRBlocks: 4
; VGPRBlocks: 5
; NumSGPRsForWavesPerEU: 35
; NumVGPRsForWavesPerEU: 46
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
    .group_segment_fixed_size: 2048
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
    .vgpr_count:     46
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.version:
  - 1
  - 0
...

	.end_amdgpu_metadata
