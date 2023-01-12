.text

//void NTT_forward_1234(int16_t *coefficients, int16_t *root_table, int16_t *coefficientsTmp,)
//coefficients in a0, root_table in a1, coefficientsTmp in a2

.global NTT_forward
.type NTT_forward, %function

NTT_forward:
    addi    sp, sp, -(4*17)
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
	
	li      t0, -8 //the flag to run NTT_forward_1234_LOOP
	NTT_forward_1234_LOOP:
		//Load thirty-two coefficients
		lw      s0, 0(a0)
		lw      s1, 16*2(a0)
		lw      s2, 32*2(a0)
		lw      s3, 48*2(a0)
		lw      s4, 64*2(a0)
		lw      s5, 80*2(a0)
		lw      s6, 96*2(a0)
		lw      s7, 112*2(a0)
		lw      s8, 128*2(a0)
		lw      s9, 144*2(a0)
		lw      s10, 160*2(a0)
		lw      s11, 176*2(a0)
		lw      t3, 192*2(a0)
		lw      t4, 208*2(a0)
		lw      t5, 224*2(a0)
		lw      t6, 240*2(a0) 		
		
		//level-1
		lh		a3, 0(a1) //Load twiddle-factors at level-1		
		nswapll	t1, s8, s0
		nswaphh	t2, s8, s0
		ibutterfly	t1, t1, a3
		ibutterfly	t2, t2, a3 
		lh		a3, 1*2(a1) //Load twiddle-factors at level-1	
		nswapll	s0, s9, s1
		nswaphh	s8, s9, s1
		ibutterfly	s0, s0, a3
		ibutterfly	s8, s8, a3
		lh		a3, 2*2(a1) //Load twiddle-factors at level-1	
		nswapll	s1, s10, s2
		nswaphh	s9, s10, s2
		ibutterfly	s1, s1, a3
		ibutterfly	s9, s9, a3
		lh		a3, 3*2(a1) //Load twiddle-factors at level-1	
		nswapll	s2, s11, s3
		nswaphh	s10, s11, s3
		ibutterfly	s2, s2, a3
		ibutterfly	s10, s10, a3
		lh		a3, 4*2(a1) //Load twiddle-factors at level-1	
		nswapll	s3, t3, s4
		nswaphh	s11, t3, s4
		ibutterfly	s3, s3, a3
		ibutterfly	s11, s11, a3
		lh		a3, 5*2(a1) //Load twiddle-factors at level-1	
		nswapll	s4, t4, s5
		nswaphh	t3, t4, s5
		ibutterfly	s4, s4, a3
		ibutterfly	t3, t3, a3
		lh		a3, 6*2(a1) //Load twiddle-factors at level-1	
		nswapll	s5, t5, s6
		nswaphh	t4, t5, s6
		ibutterfly	s5, s5, a3
		ibutterfly	t4, t4, a3
		lh		a3, 7*2(a1) //Load twiddle-factors at level-1	
		nswapll	s6, t6, s7
		nswaphh	t5, t6, s7
		ibutterfly	s6, s6, a3
		ibutterfly	t5, t5, a3		
		
		//level-2
		lh		a3, 8*2(a1) //Load twiddle-factors at level-2	
		nswapll	s7, s3, t1
		nswaphh	t6, s3, t1
		ibutterfly	s7, s7, a3
		ibutterfly	t6, t6, a3
		nswapll	t1, s11, t2
		nswaphh	s3, s11, t2
		ibutterfly	t1, t1, a3
		ibutterfly	s3, s3, a3
		lh		a3, 9*2(a1) //Load twiddle-factors at level-2	
		nswapll	t2, s4, s0
		nswaphh	s11, s4, s0
		ibutterfly	t2, t2, a3
		ibutterfly	s11, s11, a3
		nswapll	s0, t3, s8
		nswaphh	s4, t3, s8
		ibutterfly	s0, s0, a3
		ibutterfly	s4, s4, a3
		lh		a3, 10*2(a1) //Load twiddle-factors at level-2	
		nswapll	s8, s5, s1
		nswaphh	t3, s5, s1
		ibutterfly	s8, s8, a3
		ibutterfly	t3, t3, a3
		nswapll	s1, t4, s9
		nswaphh	s5, t4, s9
		ibutterfly	s1, s1, a3
		ibutterfly	s5, s5, a3
		lh		a3, 11*2(a1) //Load twiddle-factors at level-2	
		nswapll	s9, s6, s2
		nswaphh	t4, s6, s2
		ibutterfly	s9, s9, a3
		ibutterfly	t4, t4, a3
		nswapll	s2, t5, s10
		nswaphh	s6, t5, s10
		ibutterfly	s2, s2, a3
		ibutterfly	s6, s6, a3
		
		//Level-3
		lh		a3, 12*2(a1) //Load twiddle-factors at level-3
		nswapll	s10, s8, s7
		nswaphh	t5, s8, s7
		ibutterfly	s10, s10, a3
		ibutterfly	t5, t5, a3
		nswapll	s7, t3, t6
		nswaphh	s8, t3, t6
		ibutterfly	s7, s7, a3
		ibutterfly	s8, s8, a3
		nswapll	t6, s1, t1
		nswaphh	t3, s1, t1
		ibutterfly	t6, t6, a3
		ibutterfly	t3, t3, a3
		nswapll	t1, s5, s3
		nswaphh	s1, s5, s3
		ibutterfly	t1, t1, a3
		ibutterfly	s1, s1, a3
		lh		a3, 13*2(a1) //Load twiddle-factors at level-3
		nswapll	s3, s9, t2
		nswaphh	s5, s9, t2
		ibutterfly	s3, s3, a3
		ibutterfly	s5, s5, a3
		nswapll	t2, t4, s11
		nswaphh	s9, t4, s11
		ibutterfly	t2, t2, a3
		ibutterfly	s9, s9, a3
		nswapll	s11, s2, s0
		nswaphh	t4, s2, s0
		ibutterfly	s11, s11, a3
		ibutterfly	t4, t4, a3
		nswapll	s0, s6, s4
		nswaphh	s2, s6, s4
		ibutterfly	s0, s0, a3
		ibutterfly	s2, s2, a3
		
		//Level-4
		lh		a3, 14*2(a1) //Load twiddle-factors at level-4
		nswapll	s4, s3, s10
		nswaphh	s6, s3, s10
		ibutterfly	s4, s4, a3
		ibutterfly	s6, s6, a3
		nswapll	s10, s5, t5
		nswaphh	s3, s5, t5
		ibutterfly	s10, s10, a3
		ibutterfly	s3, s3, a3
		nswapll	t5, t2, s7
		nswaphh	s5, t2, s7
		ibutterfly	t5, t5, a3
		ibutterfly	s5, s5, a3
		nswapll	s7, s9, s8
		nswaphh	t2, s9, s8
		ibutterfly	s7, s7, a3
		ibutterfly	t2, t2, a3
		nswapll	s8, s11, t6
		nswaphh	s9, s11, t6
		ibutterfly	s8, s8, a3
		ibutterfly	s9, s9, a3
		nswapll	t6, t4, t3
		nswaphh	s11, t4, t3
		ibutterfly	t6, t6, a3
		ibutterfly	s11, s11, a3
		nswapll	t3, s0, t1
		nswaphh	t4, s0, t1
		ibutterfly	t3, t3, a3
		ibutterfly	t4, t4, a3
		nswapll	t1, s2, s1
		nswaphh	s0, s2, s1
		ibutterfly	t1, t1, a3
		ibutterfly	s0, s0, a3
		
		//swap
		nswapll	s1, s8, s4
		nswaphh s2, s8, s4
		nswapll	s4, s9, s6
		nswaphh s8, s9, s6
		nswapll	s6, t6, s10
		nswaphh s9, t6, s10
		nswapll	s10, s11, s3
		nswaphh t6, s11, s3
		nswapll	s3, t3, t5
		nswaphh s11, t3, t5
		nswapll	t5, t4, s5
		nswaphh t3, t4, s5
		nswapll	s5, t1, s7
		nswaphh t4, t1, s7
		nswapll	s7, s0, t2
		nswaphh t1, s0, t2
		
		//Store Coefficients
		sw      s1, 0(a0)
		sw      s2, 16*2(a0)
		sw      s4, 32*2(a0)
		sw      s8, 48*2(a0)
		sw      s6, 64*2(a0)
		sw      s9, 80*2(a0)
		sw      s10, 96*2(a0)
		sw      t6, 112*2(a0)
		sw      s3, 128*2(a0)
		sw      s11, 144*2(a0)
		sw      t5, 160*2(a0)
		sw      t3, 176*2(a0)
		sw      s5, 192*2(a0)
		sw      t4, 208*2(a0)
		sw      s7, 224*2(a0)
		sw      t1, 240*2(a0) 
		
		addi	a0, a0, 4
		//addi	a2, a2, 4
		addi	a1, a1, 2*15
		addi	t0, t0, 1
		blt     t0, x0, NTT_forward_1234_LOOP
		
	addi a0, a0, -8*4
	//addi a2, a2, -8*4
	addi a1, a1, -15*2*8
	
	li      t0, -8 //the flag to run NTT_forward_567_LOOP
	//Load twiddle-factors
	lh		a7, 0(a1)
	lh		a6, 2*2(a1)
	lh		a5, 4*2(a1)
	lh		a4, 6*2(a1)
    NTT_forward_567_LOOP:
		//Load thirty-two coefficients
		lw      s0, 0(a0)
		lw      s1, 1*4(a0)
		lw      s2, 2*4(a0)
		lw      s3, 3*4(a0)
		lw      s4, 4*4(a0)
		lw      s5, 5*4(a0)
		lw      s6, 6*4(a0)
		lw      s7, 7*4(a0)
		lw      s8, 8*4(a0)
		lw      s9, 9*4(a0)
		lw      s10, 10*4(a0)
		lw      s11, 11*4(a0)
		lw      t3, 12*4(a0)
		lw      t4, 13*4(a0)
		lw      t5, 14*4(a0)
		lw      t6, 15*4(a0)
		
		//Level-5
		nswapll	t1, s4, s0
		nswaphh t2, s4, s0
		ibutterfly	t1, t1, a7
		ibutterfly	t2, t2, a7
		nswapll	s0, t3, s8
		nswaphh s4, t3, s8
		ibutterfly	s0, s0, a7
		ibutterfly	s4, s4, a7
		nswapll	s8, s5, s1
		nswaphh t3, s5, s1
		ibutterfly	s8, s8, a6
		ibutterfly	t3, t3, a6
		nswapll	s1, t4, s9
		nswaphh s5, t4, s9
		ibutterfly	s1, s1, a6
		ibutterfly	s5, s5, a6
		nswapll	s9, s6, s2
		nswaphh t4, s6, s2
		ibutterfly	s9, s9, a5
		ibutterfly	t4, t4, a5
		nswapll	s2, t5, s10
		nswaphh s6, t5, s10
		ibutterfly	s2, s2, a5
		ibutterfly	s6, s6, a5
		nswapll	s10, s7, s3
		nswaphh t5, s7, s3
		ibutterfly	s10, s10, a4
		ibutterfly	t5, t5, a4
		nswapll	s3, t6, s11
		nswaphh s7, t6, s11
		ibutterfly	s3, s3, a4
		ibutterfly	s7, s7, a4
		
		//Level-6
		nswapll	s11, s9, t1
		nswaphh t6, s9, t1
		ibutterfly	s11, s11, a7
		ibutterfly	t6, t6, a7
		nswapll	t1, t4, t2
		nswaphh s9, t4, t2
		ibutterfly	t1, t1, a7
		ibutterfly	s9, s9, a7
		nswapll	t2, s2, s0
		nswaphh t4, s2, s0
		ibutterfly	t2, t2, a7
		ibutterfly	t4, t4, a7
		nswapll	s0, s6, s4
		nswaphh s2, s6, s4
		ibutterfly	s0, s0, a7
		ibutterfly	s2, s2, a7
		nswapll	s4, s10, s8
		nswaphh s6, s10, s8
		ibutterfly	s4, s4, a5
		ibutterfly	s6, s6, a5
		nswapll	s8, t5, t3
		nswaphh s10, t5, t3
		ibutterfly	s8, s8, a5
		ibutterfly	s10, s10, a5
		nswapll	t3, s3, s1
		nswaphh t5, s3, s1
		ibutterfly	t3, t3, a5
		ibutterfly	t5, t5, a5
		nswapll	s1, s7, s5
		nswaphh s3, s7, s5
		ibutterfly	s1, s1, a5
		ibutterfly	s3, s3, a5 
		
		//Level-7
		nswapll	s5, s4, s11
		nswaphh s7, s4, s11
		ibutterfly	s5, s5, a7
		ibutterfly	s7, s7, a7
		nswapll	s11, s6, t6
		nswaphh s4, s6, t6
		ibutterfly	s11, s11, a7
		ibutterfly	s4, s4, a7
		nswapll	t6, s8, t1
		nswaphh s6, s8, t1
		ibutterfly	t6, t6, a7
		ibutterfly	s6, s6, a7
		nswapll	t1, s10, s9
		nswaphh s8, s10, s9
		ibutterfly	t1, t1, a7
		ibutterfly	s8, s8, a7
		nswapll	s9, t3, t2
		nswaphh s10, t3, t2
		ibutterfly	s9, s9, a7
		ibutterfly	s10, s10, a7
		nswapll	t2, t5, t4
		nswaphh t3, t5, t4
		ibutterfly	t2, t2, a7
		ibutterfly	t3, t3, a7
		nswapll	t4, s1, s0
		nswaphh t5, s1, s0
		ibutterfly	t4, t4, a7
		ibutterfly	t5, t5, a7
		nswapll	s0, s3, s2
		nswaphh s1, s3, s2
		ibutterfly	s0, s0, a7
		ibutterfly	s1, s1, a7
		
		//swap
		nswapll	s2, t6, s5
		nswaphh s3, t6, s5
		nswapll	s5, s6, s7
		nswaphh t6, s6, s7
		nswapll	s6, t1, s11
		nswaphh s7, t1, s11
		nswapll	t1, s8, s4
		nswaphh s11, s8, s4
		nswapll	s8, t4, s9
		nswaphh s4, t4, s9
		nswapll	t4, t5, s10
		nswaphh s9, t5, s10
		nswapll	t5, s0, t2
		nswaphh s10, s0, t2
		nswapll	s0, s1, t3
		nswaphh t2, s1, t3
		
		//Store Coefficients
		sw      s2, 0(a0)
		sw      s3, 1*4(a0)
		sw      s5, 2*4(a0)
		sw      t6, 3*4(a0)
		sw      s6, 4*4(a0)
		sw      s7, 5*4(a0)
		sw      t1, 6*4(a0)
		sw      s11, 7*4(a0)
		sw      s8, 8*4(a0)
		sw      s4, 9*4(a0)
		sw      t4, 10*4(a0)
		sw      s9, 11*4(a0)
		sw      t5, 12*4(a0)
		sw      s10, 13*4(a0)
		sw      s0, 14*4(a0)
		sw      t2, 15*4(a0)
		
		//addi	a2, a2, 16*4
		addi	a0, a0, 16*4
		addi	t0, t0, 1
		blt     t0, x0, NTT_forward_567_LOOP

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
    addi    sp, sp, (4*17)

    ret

