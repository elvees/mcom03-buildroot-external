################################################################################
#
# Simple Linux starter
#
# According to [1] performing of some steps are mandatory
# and this starter is designed to prepare a minimal boot environment.
#
# The starter assumes that a Linux image and a DTB have been loaded into special
# addresses:
#
# * Linux image has been loaded by address 0xC0080000.
# * DTB has been loaded by address 0xD0000000.
# * Itself has been loaded by address 0xC0000000.
#
# The starter performs:
#
# * fulfills conditions required for Linux.
# * marks that CPU timer has 10MHz clock speed.
# * jumps to the Linux image on primary CPU.
# * parks all secondary CPUs until the Linux resumes them.
#
# [1] https://www.kernel.org/doc/Documentation/arm64/booting.txt
#
################################################################################

.equ CPUs,		4		/* CPU count */
.equ SCR_NS,		1 << 0		/* Non-secure EL1 */
.equ SCR_HCE,		1 << 8		/* HVC enable */
.equ SCR_RW,		1 << 10		/* 64-bit EL2 */
.equ CPU_OSC,		10000000	/* CPU timer frequency is 10 MHz */
.equ SPSR_D,		1 << 9
.equ SPSR_A,		1 << 8
.equ SPSR_I,		1 << 7
.equ SPSR_F,		1 << 6
.equ SPSR_EL2h, 	((1 << 3) | (1 << 0))
.equ SCTLR_def, 	0x30C50838	/* MMU is Off, stack allign check is On */
.equ SMPEN, 		(1 << 6)	/* Coherence enable */

.equ DTB_addr,		0xD0000000
.equ IMG_addr,		0xC0080000
.equ IMG_sz_offset,	16

.section ".text.boot"

	.globl _start
_start:

	mrs	x0, CurrentEL
	cmp	x0, #0xc
	b.ne	el2_switched		/* skip EL3 initialization */

/* Linux boot conditionals: */

/* - CPU mode: DAIF masked.
	       CPU on EL2 */
	ldr	x1, =(SPSR_D | SPSR_A | SPSR_I | SPSR_F | SPSR_EL2h)
	msr	spsr_el3, x1
	adr	x0, el2_switched
	msr	elr_el3, x0

/* - Caches, MMUs: MMU is Off.
		   D cache should be invalidated for a kernel VA */
	ldr	x0, =SCTLR_def
	msr	sctlr_el2, x0
	isb
	ldr	x0, =IMG_addr
	ldr	x1, [x0, #IMG_sz_offset]
	bl	inval_d_cache

/* - Architected timers: */
	ldr	x0, =CPU_OSC
	msr	cntfrq_el0, x0
	msr	cntvoff_el2, xzr

/* - Coherency: Must be On for CPU's domain. */
	mrs	x0, S3_1_C15_C2_1
	orr	x0, x0, #(SMPEN)
	msr	S3_1_C15_C2_1, x0
	isb

/* - System registers: SCR_EL3.FIQ is same for all CPUs.
		       ICC_SRE_EL3.Enable and ICC_SRE_EL3.SRE are set to 0b1 */
	ldr	x0, =(SCR_RW | SCR_HCE | SCR_NS)
	msr	scr_el3, x0
	isb
	msr	cptr_el3, xzr		/* disable trapping to EL3 */

	mrs	x0, S3_6_C12_C12_5
	orr	x0, x0, #(1 << 0)
	orr	x0, x0, #(1 << 3)
	msr	S3_6_C12_C12_5, x0
	isb

	/* switch to EL2 */
	eret

el2_switched:

	/* Required for RTL simulation */
	mov	x0, xzr
	msr	cntp_ctl_el0, x0
	isb
	mrs	x0, cntp_ctl_el0
	isb

	/* Required for RTL simulation */
	mov	x0, xzr
	msr	cntv_ctl_el0, x0
	isb
	mrs	x0, cntv_ctl_el0
	isb

	/* split CPUs */
	mrs 	x4, MPIDR_EL1
	and 	x4, x4, #0xff

	/* park secondary CPUs */
	cbnz 	x4, secondary_cpu

	/* Primary CPU */
	ldr	x21, =IMG_addr
	ldr	x0, =DTB_addr
	mov	x1, xzr
	mov	x2, xzr
	mov	x3, xzr

	/* jump to kernel */
	blr	x21

/* x0 - base address, x1 - len */
inval_d_cache:
	add	x1, x0, x1	/* x1 = end of region */
	mrs	x2, ctr_el0
	ubfx	x2, x2, #16, #4
	mov	x3, #4
	lsl	x2, x3, x2	/* x2 = cache line size */
	sub	x3, x2, #1
	bic	x3, x0, x3	/* x3 = line alligned base address */
d_cache_loop:
	dc ivac,x3		/* invalidate by VA to PoC */
	add	x3, x3, x2
	cmp	x3, x1
	b.lt	d_cache_loop
	dsb	ish
	ret

/* cpu_release_array has predefined address, because it is used in DTB */
/* 0xC0000000 + 0x800 represents CPU0 spin addr. Not used.
 * 0xC0000000 + 0x808 represents CPU1 spin addr. Used.
 * 0xC0000000 + 0x810 represents CPU2 spin addr. Used.
 * 0xC0000000 + 0x818 represents CPU3 spin addr. Used.
 */

.org 0x800
cpu_release_array:
	.rep	CPUs
	.quad	0
	.endr

secondary_cpu:
	adr	x5, cpu_release_array

secondary_wait:
	wfe
	ldr	x6, [x5, x4, lsl 3]
	cbz	x6, secondary_wait
	mov	x0, xzr
	mov	x1, xzr
	mov	x2, xzr
	mov	x3, xzr

	/* jump to kernel */
	blr	x6
