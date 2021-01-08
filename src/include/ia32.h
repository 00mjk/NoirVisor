/*
  NoirVisor - Hardware-Accelerated Hypervisor solution

  Copyright 2018-2021, Zero Tang. All rights reserved.

  This file defines constants and structures for Intel IA-32 processors.

  This program is distributed in the hope that it will be useful, but
  without any warranty (no matter implied warranty of merchantablity
  or fitness for a particular purpose, etc.).

  File location: /include/ia32.h
*/

#include <nvdef.h>

//
#define ia32_cr4_vmxe			13
#define ia32_cr4_vmxe_bit		0x2000

// This is used for defining MSRs.
#define ia32_feature_control			0x3A
#define ia32_bios_updt_trig				0x79
#define ia32_bios_sign_id				0x8B
#define ia32_sysenter_cs				0x174
#define ia32_sysenter_esp				0x175
#define ia32_sysenter_eip				0x176
#define ia32_debug_control				0x1D9
#define ia32_pat						0x277
#define ia32_perf_global_ctrl			0x38F
#define ia32_vmx_basic					0x480
#define ia32_vmx_pinbased_ctrl			0x481
#define ia32_vmx_priproc_ctrl			0x482
#define ia32_vmx_exit_ctrl				0x483
#define ia32_vmx_entry_ctrl				0x484
#define ia32_vmx_misc					0x485
#define ia32_vmx_cr0_fixed0				0x486
#define ia32_vmx_cr0_fixed1				0x487
#define ia32_vmx_cr4_fixed0				0x488
#define ia32_vmx_cr4_fixed1				0x489
#define ia32_vmx_vmcs_enum				0x48A
#define ia32_vmx_2ndproc_ctrl			0x48B
#define ia32_vmx_ept_vpid_cap			0x48C
#define ia32_vmx_true_pinbased_ctrl		0x48D
#define ia32_vmx_true_priproc_ctrl		0x48E
#define ia32_vmx_true_exit_ctrl			0x48F
#define ia32_vmx_true_entry_ctrl		0x490
#define ia32_vmx_vmfunc					0x491
#define ia32_efer						0xC0000080
#define ia32_star						0xC0000081
#define ia32_lstar						0xC0000082
#define ia32_fmask						0xC0000084
#define ia32_fs_base					0xC0000100
#define ia32_gs_base					0xC0000101
#define ia32_kernel_gs_base				0xC0000102

// This is used for defining IA-32 architectural interrupt vectors.
#define ia32_divide_error				0
#define ia32_debug_exception			1
#define ia32_nmi_interrupt				2
#define ia32_breakpoint					3
#define ia32_overflow					4
#define ia32_exceed_bound_range			5
#define ia32_invalid_opcode				6
#define ia32_no_math_coprocessor		7
#define ia32_double_fault				8
#define ia32_segment_overrun			9
#define ia32_invalid_tss				10
#define ia32_segment_not_present		11
#define ia32_stack_segment_fault		12
#define ia32_general_protection			13
#define ia32_page_fault					14
#define ia32_x87_fp_error				16
#define ia32_alignment_check			17
#define ia32_machine_check				18
#define ia32_simd_exception				19
#define ia32_virtualization_exception	20
#define ia32_control_protection			21

// Index of Standard Leaves
#define ia32_cpuid_std_max_num_vstr		0x0
#define ia32_cpuid_std_proc_feature		0x1
#define ia32_cpuid_std_cache_tlb_ft		0x2
#define ia32_cpuid_std_proc_serialn		0x3
#define ia32_cpuid_std_det_cc_param		0x4
#define ia32_cpuid_std_monitor_feat		0x5
#define ia32_cpuid_std_thermal_feat		0x6
#define ia32_cpuid_std_struct_extid		0x7
#define ia32_cpuid_std_di_cache_inf		0x9
#define ia32_cpuid_std_arch_perfmon		0xA
#define ia32_cpuid_std_ex_proc_topo		0xB
#define ia32_cpuid_std_pestate_enum		0xD
#define ia32_cpuid_std_irdt_mon_cap		0xF
#define ia32_cpuid_std_irdt_alloc_e		0x10
#define ia32_cpuid_std_sgx_cap_enum		0x12
#define ia32_cpuid_std_prtrace_enum		0x14
#define ia32_cpuid_std_tsc_ncc_info		0x15
#define ia32_cpuid_std_proc_frq_inf		0x16
#define ia32_cpuid_std_sys_ocv_attr		0x17
#define ia32_cpuid_std_atrans_param		0x18

// Index of Extended Leaves
#define ia32_cpuid_ext_max_num_vstr		0x80000000
#define ia32_cpuid_ext_proc_feature		0x80000001
#define ia32_cpuid_ext_brand_str_p1		0x80000002
#define ia32_cpuid_ext_brand_str_p2		0x80000003
#define ia32_cpuid_ext_brand_str_p3		0x80000004
#define ia32_cpuid_ext_caching_tlbs		0x80000005
#define ia32_cpuid_ext_l23cache_tlb		0x80000006
#define ia32_cpuid_ext_powermgr_ras		0x80000007
#define ia32_cpuid_ext_pcap_prm_eid		0x80000008

// This is used for defining IA-32 architectural cpuid flags.
#define ia32_cpuid_vmx				5
#define ia32_cpuid_vmx_bit			0x20
#define ia32_cpuid_hv_presence		31
#define ia32_cpuid_hv_presence_bit	0x80000000

// This is used for defining IA-32 RFlags bits.
#define ia32_rflags_cf			0
#define ia32_rflags_pf			2
#define ia32_rflags_af			4
#define ia32_rflags_zf			6
#define ia32_rflags_sf			7
#define ia32_rflags_tf			8
#define ia32_rflags_if			9
#define ia32_rflags_df			10
#define ia32_rflags_of			11
#define ia32_rflags_nt			14
#define ia32_rflags_rf			16
#define ia32_rflags_vm			17
#define ia32_rflags_ac			18
#define ia32_rflags_vif			19
#define ia32_rflags_vip			20
#define ia32_rflags_id			21

#define ia32_rflags_iopl(f)	((f&0x3000)>>12)

// This is used for defining IA-32 architectural cache types.
#define ia32_uncacheable		0
#define ia32_write_back			6

// This is used for defining IA-32 Extended Control Registers (XCR)
typedef union _ia32_xcr0
{
	struct
	{
		u64 x87:1;			// Bit	0
		u64 sse:1;			// Bit	1
		u64 avx:1;			// Bit	2
		u64 bngreg:1;		// Bit	3
		u64 bndcsr:1;		// Bit	4
		u64 opmask:1;		// Bit	5
		u64 zmm_hi256:1;	// Bit	6
		u64 hi16_zmm:1;		// Bit	7
		u64 reserved0:1;	// Bit	8
		u64 pkru:1;			// Bit	9
		u64 reserved1:54;	// Bits	10-63
	};
	struct
	{
		u32 lo;
		u32 hi;
	};
	u64 value;
}ia32_xcr0,*ia32_xcr0_p;