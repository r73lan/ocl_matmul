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
	v_mov_b32_e32 v47, 0
                                        ; implicit-def: $vcc_hi
	s_mov_b32 s32, s11
	s_and_b32 s5, s4, 0xffff
	s_mov_b32 s4, 0
	s_waitcnt lgkmcnt(0)
	s_cmp_eq_u32 s3, 0
	s_mul_i32 s8, s8, s5
	s_waitcnt vmcnt(0)
	v_mul_lo_u32 v3, s9, v2
	v_mov_b32_e32 v2, 0
	v_add3_u32 v3, s14, v3, v1
	s_cbranch_scc1 BB0_3
; %bb.1:
	v_mul_lo_u32 v11, v1, s2
	v_mul_lo_u32 v7, v3, s3
	s_load_dwordx4 s[16:19], s[6:7], 0x0
	s_movk_i32 s6, 0x44
	v_lshlrev_b32_e32 v35, 2, v0
	s_lshl_b32 s5, s2, 4
	v_mov_b32_e32 v8, 0
	v_mov_b32_e32 v47, 0
	v_mad_u32_u24 v6, v1, s6, 0x440
	v_mad_u32_u24 v1, v1, s6, v35
	v_add_nc_u32_e32 v9, v6, v35
	v_add_nc_u32_e32 v4, v0, v11
	v_add_nc_u32_e32 v10, v0, v7
	v_add3_u32 v11, s12, s8, v4
BB0_2:                                  ; =>This Inner Loop Header: Depth=1
	v_add_nc_u32_e32 v7, s4, v10
	v_mov_b32_e32 v12, v8
	s_add_i32 s4, s4, 16
	v_lshlrev_b64 v[13:14], 2, v[7:8]
	v_lshlrev_b64 v[15:16], 2, v[11:12]
	v_add_nc_u32_e32 v11, s5, v11
	s_cmp_lt_u32 s4, s3
	s_waitcnt lgkmcnt(0)
	v_add_co_u32_e64 v12, vcc_lo, s16, v13
	v_add_co_ci_u32_e32 v13, vcc_lo, s17, v14, vcc_lo
	v_add_co_u32_e64 v14, vcc_lo, s18, v15
	v_add_co_ci_u32_e32 v15, vcc_lo, s19, v16, vcc_lo
	global_load_dword v7, v[12:13], off
	global_load_dword v12, v[14:15], off
	s_waitcnt vmcnt(1)
	ds_write_b32 v9, v7
	s_waitcnt vmcnt(0)
	ds_write_b32 v1, v12
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	ds_read2_b32 v[12:13], v35 offset1:17
	ds_read2_b32 v[14:15], v6 offset1:1
	ds_read2_b32 v[16:17], v35 offset0:34 offset1:51
	ds_read2_b32 v[18:19], v6 offset0:2 offset1:3
	ds_read2_b32 v[20:21], v6 offset0:4 offset1:5
	ds_read2_b32 v[22:23], v35 offset0:68 offset1:85
	ds_read2_b32 v[24:25], v35 offset0:102 offset1:119
	ds_read2_b32 v[26:27], v6 offset0:6 offset1:7
	ds_read2_b32 v[28:29], v6 offset0:8 offset1:9
	ds_read2_b32 v[30:31], v6 offset0:10 offset1:11
	ds_read2_b32 v[33:34], v35 offset0:136 offset1:153
	ds_read2_b32 v[43:44], v35 offset0:170 offset1:187
	ds_read2_b32 v[36:37], v6 offset0:12 offset1:13
	ds_read2_b32 v[38:39], v6 offset0:14 offset1:15
	ds_read2_b32 v[41:42], v35 offset0:204 offset1:221
	ds_read2_b32 v[45:46], v35 offset0:238 offset1:255
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	s_barrier
	s_waitcnt vmcnt(0) lgkmcnt(0)
	s_waitcnt_vscnt null, 0x0
	buffer_gl0_inv
	v_fmac_f32_e32 v47, v14, v12
	v_fmac_f32_e32 v47, v15, v13
	v_fmac_f32_e32 v47, v18, v16
	v_fmac_f32_e32 v47, v19, v17
	v_fmac_f32_e32 v47, v20, v22
	v_fmac_f32_e32 v47, v21, v23
	v_fmac_f32_e32 v47, v26, v24
	v_fmac_f32_e32 v47, v27, v25
	v_fmac_f32_e32 v47, v28, v33
	v_fmac_f32_e32 v47, v29, v34
	v_fmac_f32_e32 v47, v30, v43
	v_fmac_f32_e32 v47, v31, v44
	v_fmac_f32_e32 v47, v36, v41
	v_fmac_f32_e32 v47, v37, v42
	v_fmac_f32_e32 v47, v38, v45
	v_fmac_f32_e32 v47, v39, v46
	s_cbranch_scc1 BB0_2
BB0_3:                                  ; %.loopexit
	v_mul_lo_u32 v1, v3, s2
	s_add_i32 s2, s12, s8
	v_add3_u32 v1, s2, v0, v1
	v_lshlrev_b64 v[0:1], 2, v[1:2]
	v_add_co_u32_e64 v0, vcc_lo, s0, v0
	v_add_co_ci_u32_e32 v1, vcc_lo, s1, v1, vcc_lo
	global_store_dword v[0:1], v47, off
	s_endpgm
	.section	.rodata,#alloc
	.p2align	6
	.amdhsa_kernel add
		.amdhsa_group_segment_fixed_size 2176
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
		.amdhsa_next_free_vgpr 48
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
; codeLenInByte = 608
; NumSgprs: 35
; NumVgprs: 48
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 2176 bytes/workgroup (compile time only)
; SGPRBlocks: 4
; VGPRBlocks: 5
; NumSGPRsForWavesPerEU: 35
; NumVGPRsForWavesPerEU: 48
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
        .is_const:       true
        .name:           a
        .offset:         0
        .size:           8
        .type_name:      'float*'
        .value_kind:     global_buffer
        .value_type:     f32
      - .address_space:  global
        .is_const:       true
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
    .group_segment_fixed_size: 2176
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
    .vgpr_count:     48
    .vgpr_spill_count: 0
    .wavefront_size: 32
amdhsa.version:
  - 1
  - 0
...

	.end_amdgpu_metadata
