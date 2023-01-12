.text

.macro	mulinvLen a, tmp1, zero, invLen		
		nswapll	\tmp1, \zero, \a
		ibutterfly \tmp1, \tmp1, \invLen
		nswaphh	\a, \a, \tmp1
.endm

//void NTT_backward(int16_t *coefficients, int16_t *root_table)
//coefficients in a0, root_table in a1

.global NTT_backward
.type NTT_backward, %function

NTT_backward:
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
    sw      t0, 64(sp)

	li    t0,  -8	//the flag to run NTT_backward_765_LOOP
	NTT_backward_765_LOOP: 
		//Load coefficients
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
		
		//level-7
		lh		a3, 3*2(a1) //Load twiddle-factors at level-7		
		nswapll	t1, s1, s0
		nswaphh	t2, s1, s0
		ibutterfly	t1, t1, a3
		ibutterfly	t2, t2, a3
		lh		a3, 4*2(a1) //Load twiddle-factors at level-7	
		nswapll	s0, s3, s2
		nswaphh	s1, s3, s2
		ibutterfly	s0, s0, a3
		ibutterfly	s1, s1, a3
		lh		a3, 5*2(a1) //Load twiddle-factors at level-7	
		nswapll	s2, s5, s4
		nswaphh	s3, s5, s4
		ibutterfly	s2, s2, a3
		ibutterfly	s3, s3, a3
		lh		a3, 6*2(a1) //Load twiddle-factors at level-7	
		nswapll	s4, s7, s6
		nswaphh	s5, s7, s6
		ibutterfly	s4, s4, a3
		ibutterfly	s5, s5, a3
		lh		a3, 10*2(a1) //Load twiddle-factors at level-7	
		nswapll	s6, s9, s8
		nswaphh	s7, s9, s8
		ibutterfly	s6, s6, a3
		ibutterfly	s7, s7, a3
		lh		a3, 11*2(a1) //Load twiddle-factors at level-7	
		nswapll	s8, s11, s10
		nswaphh	s9, s11, s10
		ibutterfly	s8, s8, a3
		ibutterfly	s9, s9, a3
		lh		a3, 12*2(a1) //Load twiddle-factors at level-7	
		nswapll	s10, t4, t3
		nswaphh	s11, t4, t3
		ibutterfly	s10, s10, a3
		ibutterfly	s11, s11, a3
		lh		a3, 13*2(a1) //Load twiddle-factors at level-7	
		nswapll	t3, t6, t5
		nswaphh	t4, t6, t5
		ibutterfly	t3, t3, a3
		ibutterfly	t4, t4, a3
		
		//Level-6
		lh		a3, 1*2(a1) //Load twiddle-factors at level-6	
		nswapll	t5, s0, t1
		nswaphh	t6, s0, t1
		ibutterfly	t5, t5, a3
		ibutterfly	t6, t6, a3	
		nswapll	t1, s1, t2
		nswaphh	s0, s1, t2
		ibutterfly	t1, t1, a3
		ibutterfly	s0, s0, a3
		lh		a3, 2*2(a1) //Load twiddle-factors at level-6	
		nswapll	t2, s4, s2
		nswaphh	s1, s4, s2
		ibutterfly	t2, t2, a3
		ibutterfly	s1, s1, a3	
		nswapll	s2, s5, s3
		nswaphh	s4, s5, s3
		ibutterfly	s2, s2, a3
		ibutterfly	s4, s4, a3
		lh		a3, 8*2(a1) //Load twiddle-factors at level-6	
		nswapll	s3, s8, s6
		nswaphh	s5, s8, s6
		ibutterfly	s3, s3, a3
		ibutterfly	s5, s5, a3	
		nswapll	s6, s9, s7
		nswaphh	s8, s9, s7
		ibutterfly	s6, s6, a3
		ibutterfly	s8, s8, a3
		lh		a3, 9*2(a1) //Load twiddle-factors at level-6	
		nswapll	s7, t3, s10
		nswaphh	s9, t3, s10
		ibutterfly	s7, s7, a3
		ibutterfly	s9, s9, a3	
		nswapll	s10, t4, s11
		nswaphh	t3, t4, s11
		ibutterfly	s10, s10, a3
		ibutterfly	t3, t3, a3
		
		//Level-5
		lh		a3, 0*2(a1) //Load twiddle-factors at level-5	
		nswapll	s11, t2, t5
		nswaphh	t4, t2, t5
		ibutterfly	s11, s11, a3
		ibutterfly	t4, t4, a3	
		nswapll	t5, s2, t1
		nswaphh	t2, s2, t1
		ibutterfly	t5, t5, a3
		ibutterfly	t2, t2, a3
		nswapll	t1, s1, t6
		nswaphh	s2, s1, t6
		ibutterfly	t1, t1, a3
		ibutterfly	s2, s2, a3
		nswapll	t6, s4, s0
		nswaphh	s1, s4, s0
		ibutterfly	t6, t6, a3
		ibutterfly	s1, s1, a3
		lh		a3, 7*2(a1) //Load twiddle-factors at level-5	
		nswapll	s0, s7, s3
		nswaphh	s4, s7, s3
		ibutterfly	s0, s0, a3
		ibutterfly	s4, s4, a3
		nswapll	s3, s10, s6
		nswaphh	s7, s10, s6
		ibutterfly	s3, s3, a3
		ibutterfly	s7, s7, a3
		nswapll	s6, s9, s5
		nswaphh	s10, s9, s5
		ibutterfly	s6, s6, a3
		ibutterfly	s10, s10, a3
		nswapll	s5, t3, s8
		nswaphh	s9, t3, s8
		ibutterfly	s5, s5, a3
		ibutterfly	s9, s9, a3 
		
		//Swap
		nswapll	s8, t5, s11
		nswaphh	t3, t5, s11
		nswapll	s11, t6, t1
		nswaphh	t5, t6, t1
		nswapll	t1, t2, t4
		nswaphh	t6, t2, t4
		nswapll	t4, s1, s2
		nswaphh	t2, s1, s2
		nswapll	s2, s3, s0
		nswaphh	s1, s3, s0
		nswapll	s0, s5, s6
		nswaphh	s3, s5, s6
		nswapll	s6, s7, s4
		nswaphh	s5, s7, s4
		nswapll	s4, s9, s10
		nswaphh	s7, s9, s10
		
		
		//Store coefficients
		sw      s8, 0(a0)
		sw      s11, 1*4(a0)
		sw      t1, 2*4(a0)
		sw      t4, 3*4(a0)
		sw      t3, 4*4(a0)
		sw      t5, 5*4(a0)
		sw      t6, 6*4(a0)
		sw      t2, 7*4(a0)
		sw      s2, 8*4(a0)
		sw      s0, 9*4(a0)
		sw      s6, 10*4(a0)
		sw      s4, 11*4(a0)
		sw      s1, 12*4(a0)
		sw      s3, 13*4(a0)
		sw      s5, 14*4(a0)
		sw      s7, 15*4(a0)
		
		addi	a0, a0, 16*4
		//addi	a2, a2, 16*4
		addi	a1, a1, 2*14
		addi	t0, t0, 1
		blt     t0, x0, NTT_backward_765_LOOP
		
	addi a0, a0, -8*16*4
	//addi a2, a2, -8*16*4
	
	li 		a2, 512
	li      t0, -8          //the flag to run NTT_backward_4321_LOOP
	//Load twiddle-factors
	lw		a7, 0(a1)
	lw		a6, 1*4(a1)
	lw		a5, 2*4(a1)
	lw		a4, 3*4(a1)
	
    NTT_backward_4321_LOOP:	
		//Load coefficients
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
		
		//Level-4
		nswaphh	a3, x0, a4		//twiddle-factors at level-4
		nswapll	t1, s1, s0
		nswaphh	t2, s1, s0
		ibutterfly	t1, t1, a3
		ibutterfly	t2, t2, a3
		lh	a3, 8*2(a1)			//twiddle-factors at level-4
		nswapll	s0, s3, s2
		nswaphh	s1, s3, s2
		ibutterfly	s0, s0, a3
		ibutterfly	s1, s1, a3
		lh	a3, 9*2(a1)			//twiddle-factors at level-4
		nswapll	s2, s5, s4
		nswaphh	s3, s5, s4
		ibutterfly	s2, s2, a3
		ibutterfly	s3, s3, a3
		lh	a3, 10*2(a1)			//twiddle-factors at level-4
		nswapll	s4, s7, s6
		nswaphh	s5, s7, s6
		ibutterfly	s4, s4, a3
		ibutterfly	s5, s5, a3
		lh	a3, 11*2(a1)			//twiddle-factors at level-4
		nswapll	s6, s9, s8
		nswaphh	s7, s9, s8
		ibutterfly	s6, s6, a3
		ibutterfly	s7, s7, a3
		lh	a3, 12*2(a1)			//twiddle-factors at level-4
		nswapll	s8, s11, s10
		nswaphh	s9, s11, s10
		ibutterfly	s8, s8, a3
		ibutterfly	s9, s9, a3
		lh	a3, 13*2(a1)			//twiddle-factors at level-4
		nswapll	s10, t4, t3
		nswaphh	s11, t4, t3
		ibutterfly	s10, s10, a3
		ibutterfly	s11, s11, a3
		lh	a3, 14*2(a1)			//twiddle-factors at level-4
		nswapll	t3, t6, t5
		nswaphh	t4, t6, t5
		ibutterfly	t3, t3, a3
		ibutterfly	t4, t4, a3
		
		//Level-3
		nswaphh	a3, x0, a6		//twiddle-factors at level-3
		nswapll	t5, s0, t1
		nswaphh	t6, s0, t1
		ibutterfly	t5, t5, a3
		ibutterfly	t6, t6, a3
		nswapll	t1, s1, t2
		nswaphh	s0, s1, t2
		ibutterfly	t1, t1, a3
		ibutterfly	s0, s0, a3
		nswapll	a3, x0, a5		//twiddle-factors at level-3
		nswapll	t2, s4, s2
		nswaphh	s1, s4, s2
		ibutterfly	t2, t2, a3
		ibutterfly	s1, s1, a3
		nswapll	s2, s5, s3
		nswaphh	s4, s5, s3
		ibutterfly	s2, s2, a3
		ibutterfly	s4, s4, a3
		nswaphh	a3, x0, a5		//twiddle-factors at level-3
		nswapll	s3, s8, s6
		nswaphh	s5, s8, s6
		ibutterfly	s3, s3, a3
		ibutterfly	s5, s5, a3
		nswapll	s6, s9, s7
		nswaphh	s8, s9, s7
		ibutterfly	s6, s6, a3
		ibutterfly	s8, s8, a3
		nswapll	a3, x0, a4		//twiddle-factors at level-3
		nswapll	s7, t3, s10
		nswaphh	s9, t3, s10
		ibutterfly	s7, s7, a3
		ibutterfly	s9, s9, a3
		nswapll	s10, t4, s11
		nswaphh	t3, t4, s11
		ibutterfly	s10, s10, a3
		ibutterfly	t3, t3, a3
		
		//Level-2
		nswaphh	a3, x0, a7		//twiddle-factors at level-2
		nswapll	s11, t2, t5
		nswaphh	t4, t2, t5
		ibutterfly	s11, s11, a3
		ibutterfly	t4, t4, a3
		nswapll	t5, s2, t1
		nswaphh	t2, s2, t1
		ibutterfly	t5, t5, a3
		ibutterfly	t2, t2, a3
		nswapll	t1, s1, t6
		nswaphh	s2, s1, t6
		ibutterfly	t1, t1, a3
		ibutterfly	s2, s2, a3
		nswapll	t6, s4, s0
		nswaphh	s1, s4, s0
		ibutterfly	t6, t6, a3
		ibutterfly	s1, s1, a3
		nswapll	a3, x0, a6		//twiddle-factors at level-2
		nswapll	s0, s7, s3
		nswaphh	s4, s7, s3
		ibutterfly	s0, s0, a3
		ibutterfly	s4, s4, a3
		nswapll	s3, s10, s6
		nswaphh	s7, s10, s6
		ibutterfly	s3, s3, a3
		ibutterfly	s7, s7, a3
		nswapll	s6, s9, s5
		nswaphh	s10, s9, s5
		ibutterfly	s6, s6, a3
		ibutterfly	s10, s10, a3 
		nswapll	s5, t3, s8
		nswaphh	s9, t3, s8
		ibutterfly	s5, s5, a3
		ibutterfly	s9, s9, a3
		
		//Level-1
		nswapll	a3, x0, a7		//twiddle-factors at level-1, twiddle-factor is merged with inv128=3303		
		nswapll	s8, s0, s11
		nswaphh	t3, s0, s11
		ibutterfly	s8, s8, a3
		ibutterfly	t3, t3, a3
		nswapll	s11, s3, t5
		nswaphh	s0, s3, t5
		ibutterfly	s11, s11, a3
		ibutterfly	s0, s0, a3
		nswapll	t5, s6, t1
		nswaphh	s3, s6, t1
		ibutterfly	t5, t5, a3
		ibutterfly	s3, s3, a3
		nswapll	t1, s5, t6
		nswaphh	s6, s5, t6
		ibutterfly	t1, t1, a3
		ibutterfly	s6, s6, a3
		nswapll	t6, s4, t4
		nswaphh	s5, s4, t4
		ibutterfly	t6, t6, a3
		ibutterfly	s5, s5, a3
		nswapll	t4, s7, t2
		nswaphh	s4, s7, t2
		ibutterfly	t4, t4, a3
		ibutterfly	s4, s4, a3
		nswapll	t2, s10, s2
		nswaphh	s7, s10, s2
		ibutterfly	t2, t2, a3
		ibutterfly	s7, s7, a3
		nswapll	s2, s9, s1
		nswaphh	s10, s9, s1
		ibutterfly	s2, s2, a3
		ibutterfly	s10, s10, a3
		
		//multiply inv128=3303, mod(13^(2)*2285, 3329)=1, mod(3303*2285, 1)=512, a2=512
		mulinvLen s8, s1, x0, a2		
		//nswapll	s1, x0, s8
		//ibutterfly	s1, s1, a2
		//nswaphh	s8, s8, s1
		mulinvLen s11, s1,x0, a2
		mulinvLen t5, s1, x0, a2
		mulinvLen t1, s1, x0, a2
		mulinvLen t6, s1, x0, a2
		mulinvLen t4, s1, x0, a2
		mulinvLen t2, s1, x0, a2
		mulinvLen s2, s1, x0, a2
		mulinvLen t3, s1, x0, a2
		mulinvLen s0, s1, x0, a2
		mulinvLen s3, s1, x0, a2
		mulinvLen s6, s1, x0, a2
		mulinvLen s5, s1, x0, a2
		mulinvLen s4, s1, x0, a2
		mulinvLen s7, s1, x0, a2
		mulinvLen s10, s1, x0, a2		
		
		//Swap
		nswapll	s1, s11, s8
		nswaphh	s9, s11, s8
		nswapll	s8, t1, t5
		nswaphh	s11, t1, t5
		nswapll	t5, t4, t6
		nswaphh	t1, t4, t6
		nswapll	t6, s2, t2
		nswaphh	t4, s2, t2
		nswapll	t2, s0, t3
		nswaphh	s2, s0, t3
		nswapll	t3, s6, s3
		nswaphh	s0, s6, s3
		nswapll	s3, s4, s5
		nswaphh	s6, s4, s5
		nswapll	s5, s10, s7
		nswaphh	s4, s10, s7
		
		//Store coefficients
		sw      s1, 0(a0)
		sw      s8, 16*2(a0)
		sw      t5, 32*2(a0)
		sw      t6, 48*2(a0)
		sw      t2, 64*2(a0)
		sw      t3, 80*2(a0)
		sw      s3, 96*2(a0)
		sw      s5, 112*2(a0)
		sw      s9, 128*2(a0)
		sw      s11, 144*2(a0)
		sw      t1, 160*2(a0)
		sw      t4, 176*2(a0)
		sw      s2, 192*2(a0)
		sw      s0, 208*2(a0)
		sw      s6, 224*2(a0)
		sw      s4, 240*2(a0)
		
		addi	a0, a0, 4
		//addi	a2, a2, 4
		addi	t0, t0, 1
		blt     t0, x0, NTT_backward_4321_LOOP
		
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
    lw      t0, 64(sp)
    addi    sp, sp, 4*17

    ret
