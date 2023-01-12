.text

.macro  trans  a, b, c, d, e
	nswapll		\c,		\e, 	\a
	nswaphh 	\d,		\e,		\a
	ibutterfly  \c,		\c,     \b
	ibutterfly  \d,     \d,     \b
	nswaphh     \a,     \d,		\c
.endm

//void NTT_pre(int16_t *coefficients, int16_t *twist)
// coefficients in a0, twist in a1

.global NTT_pre
.type NTT_pre, %function

NTT_pre: 
	addi    sp, sp, -(4*18)
    sw      s0,  0(sp)
    sw      s1,  4(sp)
    sw      s2,  8(sp)
    sw      s3, 12(sp)
    sw      s4, 16(sp)
    sw      s5, 20(sp)
    sw      s6, 24(sp)
    sw      s7, 28(sp)
    sw      s8, 32(sp)
    sw      s9, 36(sp)
    sw      s10,40(sp)
    sw      s11,44(sp)
    sw      t3, 48(sp)
    sw      t4, 52(sp)
    sw      t5, 56(sp)
    sw      t6, 60(sp)
    sw      t1, 64(sp)
	sw      t0, 68(sp)
	
	li		t0,   -8
	NTT_pre_LOOP:
		// load coefficients
		lw		s0, 	0(a0)
		lw		s1,		4(a0)
		lw		s2,		8(a0)
		lw		s3,		12(a0)
		lw		s4,		16(a0)
		lw		s5, 	20(a0)
		lw		s6, 	24(a0)
		lw		s7, 	28(a0)
		lw		s8, 	32(a0)
		lw		s9,		36(a0)
		lw		s10, 	40(a0)
		lw		s11,	44(a0)
		lw		t3, 	48(a0)
		lw		t4, 	52(a0)
		lw 		t5, 	56(a0)
		lw		t6, 	60(a0)
		
		lh		t1,		0(a1)
		trans   s0, t1, a2, a3, x0 
		
		lh		t1,     2(a1)
		trans	s1, t1, a2, a3, x0
		
		lh		t1,     4(a1)
		trans   s2, t1, a2, a3, x0
		
		lh		t1,     6(a1)
		trans	s3, t1, a2, a3, x0
		
		lh		t1,     8(a1)
		trans 	s4, t1, a2, a3, x0
		
		lh		t1, 	10(a1)
		trans 	s5, t1, a2, a3, x0
		
		lh 		t1,     12(a1)
		trans	s6, t1, a2, a3, x0
		
		lh		t1,     14(a1)
		trans   s7, t1, a2, a3, x0
		
		lh 		t1,     16(a1)
		trans   s8, t1, a2, a3, x0
		
		lh      t1,     18(a1)
		trans   s9, t1, a2, a3, x0
		
		lh      t1,     20(a1)
		trans   s10,t1, a2, a3, x0
		
		lh      t1,     22(a1)
		trans   s11,t1, a2, a3, x0
		
		lh      t1,     24(a1)
		trans   t3, t1, a2, a3, x0
		
		lh      t1,     26(a1)
		trans   t4, t1, a2, a3, x0
		
		lh      t1,     28(a1)
		trans   t5, t1, a2, a3, x0
		
		lh      t1,     30(a1)
		trans   t6, t1, a2, a3, x0
		
		
		// store  coefficients
		sw		s0, 	0(a0)
		sw		s1,		4(a0)
		sw		s2,		8(a0)
		sw		s3,		12(a0)
		sw		s4,		16(a0)
		sw		s5, 	20(a0)
		sw		s6, 	24(a0)
		sw		s7, 	28(a0)
		sw		s8, 	32(a0)
		sw		s9,		36(a0)
		sw		s10, 	40(a0)
		sw		s11,	44(a0)
		sw		t3, 	48(a0)
		sw		t4, 	52(a0)
		sw 		t5, 	56(a0)
		sw		t6, 	60(a0)
		
		addi    a0,  a0,  16*4
		addi    a1,  a1,  16*2
		addi    t0,  t0,  1
		blt     t0,  x0,  NTT_pre_LOOP
		
	lw      s0,  0(sp)
    lw      s1,  4(sp)
    lw      s2,  8(sp)
    lw      s3, 12(sp)
    lw      s4, 16(sp)
    lw      s5, 20(sp)
    lw      s6, 24(sp)
    lw      s7, 28(sp)
    lw      s8, 32(sp)
    lw      s9, 36(sp)
    lw      s10,40(sp)
    lw      s11,44(sp)
    lw      t3, 48(sp)
    lw      t4, 52(sp)
    lw      t5, 56(sp)
    lw      t6, 60(sp)
    lw      t1, 64(sp)
	lw      t0, 68(sp)
    addi    sp, sp, (4*18)

    ret
