.text

.macro mul_poly  a, b, c, tmp1, tmp2, tmp3, tmp4, tmp5, zero	   
		nswapll	\tmp1, \zero, \a
		nswaphh	\a, \zero, \a
		nswapll	\tmp2, \zero, \b
		nswaphh	\b, \zero, \b
		
		ibutterfly	\tmp3, \tmp1, \b 		 
		ibutterfly	\tmp4, \a, \tmp2		 
		nswaphh	\tmp3, \tmp3, \tmp4 			 
		ibutterfly	\tmp3, \tmp3, \tmp5		  
		
		ibutterfly	\b, \b, \c		 
		nswaphh	\b, \zero, \b			 
		ibutterfly	\b, \b, \a		 
		ibutterfly	\tmp1, \tmp1, \tmp2		 
		nswaphh		\b, \b, \tmp1		 
		ibutterfly	\b, \b, \tmp5		 
		
		// divide out the factor k^2,which can be merged with the divide out procedure of 2^(7) before NTTinv
		// nswapll	b, tmp3, b
		nswapll	\tmp3, \zero, \tmp3			 
		nswapll	\b, \zero, \b			 
		ibutterfly	\tmp3, \tmp3, \tmp5		 
		ibutterfly	\b, \b, \tmp5		 
		nswaphh	\b, \tmp3, \b		
.endm

//.macro	add_result s1, a4, a5, a6, x0
.macro	add_result a, b, tmp1, tmp2, zero
		nswapll	\tmp1, \a, \b
		ibutterfly	\tmp1, \tmp1, \zero
		nswaphh	\tmp2, \a, \b
		ibutterfly	\tmp2, \tmp2, \zero
		nswapll	\a, \tmp2, \tmp1
.endm


// void POLYMUL(int32_t *inputA, int32_t *inputB, int32_t *primitive_root, int32_t *resultC)
// inputA in a0, inputB in a1, primitive_root in a2, resultC in a3

.global BaseMulAdd
.type BaseMulAdd, %function

BaseMulAdd:
	addi    sp, sp, -(4*19)
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
	sw		t2, 72(sp)
	
	li      t0, -16 //the flag to run POLYMUL_LOOP_Add
	li		t1, 1353	//mod(13^(4)*1353, 3329)=1, mod(13^(2)*2285, 3329)=1
	//li		t1, 1441	//mod(1353*3303, 3329)=1441, mod(128*3303, 3329)=1
	POLYMUL_LOOP_Add:
		// load Matrix_A
		lw	s0, 0(a0)
		lw	s2, 1*4(a0)
		lw	s4, 2*4(a0)
		lw	s6, 3*4(a0)
		lw	s8, 4*4(a0)
		lw	s10, 5*4(a0)
		lw	t6, 6*4(a0)
		lw	t4, 7*4(a0)
				
		// load Matrix_B
		lw 	s1, 0(a1)
		lw	s3, 1*4(a1)	
		lw	s5, 2*4(a1)
		lw	s7, 3*4(a1)
		lw	s9, 4*4(a1)
		lw	s11, 5*4(a1)
		lw	t5, 6*4(a1)
		lw	t3, 7*4(a1)
		
		// load primitive_root
		lh    t2,  0(a2)		
		mul_poly  s0, s1, t2, a4, a5, a6, a7, t1, x0
		// load resultC
		lw    a4,   0(a3)
		// add resultC
		add_result s1, a4, a5, a6, x0
		//nswapll	a5, s1, a4
		//ibutterfly	a5, a5, x0
		//nswaphh	a6, s1, a4
		//ibutterfly	a6, a6, x0
		//nswapll	s1, a6, a5		
		// store resultC
		sw    s1,   0(a3)
		
		lh    t2,  1*2(a2)		
		mul_poly  s2, s3, t2, a4, a5, a6, a7, t1, x0
		lw    a4,  1*4(a3)
		add_result s3, a4, a5, a6, x0
		sw    s3,  1*4(a3)
		
		lh    t2,  2*2(a2)		
		mul_poly  s4, s5, t2, a4, a5, a6, a7, t1, x0
		lw	  a4,  2*4(a3)
		add_result s5, a4, a5, a6, x0
		sw    s5,  2*4(a3)
		
		lh    t2,  3*2(a2)		
		mul_poly  s6, s7, t2, a4, a5, a6, a7, t1, x0
		lw    a4,  3*4(a3)
		add_result s7, a4, a5, a6, x0
		sw    s7,  3*4(a3)
		
		lh    t2,  4*2(a2)		
		mul_poly  s8, s9, t2, a4, a5, a6, a7, t1, x0
		lw    a4,  4*4(a3)
		add_result s9, a4, a5, a6, x0
		sw    s9,  4*4(a3)
		
		lh    t2,  5*2(a2)		
		mul_poly  s10, s11, t2, a4, a5, a6, a7, t1, x0
		lw   a4,   5*4(a3)
		add_result s11, a4, a5, a6, x0
		sw   s11,  5*4(a3)
		
		lh    t2,  6*2(a2)		
		mul_poly  t6, t5, t2, a4, a5, a6, a7, t1, x0
		lw    a4,  6*4(a3)
		add_result t5, a4, a5, a6, x0
		sw    t5,  6*4(a3)
		
		lh    t2,  7*2(a2)		
		mul_poly  t4, t3, t2, a4, a5, a6, a7, t1, x0
		lw    a4,  7*4(a3)
		add_result t3, a4, a5, a6, x0
		sw    t3,  7*4(a3)
		
		
		addi	a0, a0, 8*4
		addi	a1, a1, 8*4
		addi	a2, a2, 8*2
		addi	a3, a3, 8*4
		addi	t0, t0, 1
		blt   	t0, x0, POLYMUL_LOOP_Add
		
		
		// nswapll	a4, x0, s0
		// nswaphh	s0, x0, s0
		// nswapll	a5, x0, s1
		// nswaphh	s1, x0, s1		
		// ibutterfly	a6, a4, s1 		// a6=a0b1||a0 (左边高比特位)
		// ibutterfly	a7, s0, a5		// a7=a1b0||a1
		// nswaphh	a6, a6, a7 			// a6=a0b1||a1b0
		// ibutterfly	a6, a6, t1		// a6=(a0b1-a1b0)t1||(a0b1+a1b0) 
		
		// ibutterfly	s1, s1, t2		// s1=b1root||b1
		// nswaphh	s1, x0, s1			// s1=0x0||b1root
		// ibutterfly	s1, s1, s0		// s1=b1roota1||b1root
		// ibutterfly	a4, a4, a5		// a4=a0b0||a0
		// nswaphh		s1, s1, a4		// s1=b1roota1||a0b0
		// ibutterfly	s1, s1, t1		// s1=(a0b0-b1roota1)t1||(a0b0+b1roota1) 
		
		// divide out the factor k^2,which can be merged with the divide out procedure of 2^(7) before NTTinv
		// nswapll	s1, a6, s1
		// nswapll	a6, x0, a6			// a6=0x0||(a0b1+a1b0) with factor k^2
		// nswapll	s1, x0, s1			// s1=0x0||(a0b0+b1roota1) with factor k^2
		// ibutterfly	a6, a6, t1		// a6=(a0b1+a1b0)t1||(a0b1+a1b0)
		// ibutterfly	s1, s1, t1		// s1=(a0b0+b1roota1)t1||(a0b0+b1roota1)
		// nswaphh	s1, a6, s1			// s1=(a0b1+a1b0)t1||a0b0+b1roota1)t1		
		
		
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
	lw      t2, 72(sp)
    addi    sp, sp, (4*19)

    ret
		
		
