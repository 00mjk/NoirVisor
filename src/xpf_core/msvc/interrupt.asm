; NoirVisor - Hardware-Accelerated Hypervisor solution
; 
; Copyright 2018-2022, Zero Tang. All rights reserved.
;
; This file is the host interrupt handler for NoirVisor.
;
; This program is distributed in the hope that it will be successful, but
; without any warranty (no matter implied warranty of merchantability or
; fitness for a particular purpose, etc.).
;
; File location: ./xpf_core/msvc/interrupt.asm

.code

include noirhv.inc

extern nvc_vt_inject_nmi_to_subverted_host:proc

nvc_vt_host_nmi_handler proc

	; In Intel VT-x, the NMI is not blocked while in Host Context.
	; Transfer the NMI to the guest if the host receives an NMI.
	; In other words, no registers can be destroyed in NMI handler of Intel VT-x.
	pushaq
	popaq
	jmp fword ptr [rsp]

nvc_vt_host_nmi_handler endp

; Note that the Host NMI handler (iret emulation) destroys the rax register!
; The NMI must be triggered in a way that rax is considered totally volatile.
nvc_svm_host_nmi_handler proc

	; We do not handle NMI on ourself. NMI should be forwarded.
	; First of all, immediately disable interrupts globally.
	clgi
	; Do not use the iret instruction to return in that it would
	; remove the blocking of Non-Maskable Interrupts.
	; Emulate the iret instruction instead.
	mov rax,rsp
	add rsp,10h
	popf
	mov ss,word ptr [rax+20h]
	mov rsp,qword ptr [rax+18h]
	jmp fword ptr [rax]

nvc_svm_host_nmi_handler endp

nvc_svm_host_ready_nmi proc

	; Set the GIF to unblock the NMI due to GIF.
	stgi
	; NMI should incur immediately after this instruction.
	; NMI has completed without unblocking NMIs here.
	; The return value is the stack.
	; Hypervisor must inject NMI to the guest once the
	; nested hypervisor enters vGIF=1 state.
	ret

nvc_svm_host_ready_nmi endp

noir_general_protection_handler proc

	; #GP might occur when switching to invalid Guest state.
	pushaq
	popaq
	; #GP has an error code. It must be popped out before the exception returns.
	add rsp,8
	iret

noir_general_protection_handler endp

end