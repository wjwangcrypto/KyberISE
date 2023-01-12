.text

//.macro	add_result s1, a4, a5, a6, x0
.macro	add_result a, b, tmp1, tmp2, zero
		nswapll	\tmp1, \a, \b
		ibutterfly	\tmp1, \tmp1, \zero
		nswaphh	\tmp2, \a, \b
		ibutterfly	\tmp2, \tmp2, \zero
		nswapll	\a, \tmp2, \tmp1
.endm


// void polyAdd(int16_t *resultC, int16_t *inputA, int16_t *inputB)
// resultC in a0, inputA in a1, inputB in a2

.global polyAdd
.type polyAdd, %function

polyAdd:
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
	
	li      t0, -16 //the flag to run polyAdd_LOOP
	polyAdd_LOOP:
		// load Matrix_A
		lw	s0, 0(a1)
		lw	s2, 1*4(a1)
		lw	s4, 2*4(a1)
		lw	s6, 3*4(a1)
		lw	s8, 4*4(a1)
		lw	s10, 5*4(a1)
		lw	t6, 6*4(a1)
		lw	t4, 7*4(a1)
				
		// load Matrix_B
		lw 	s1, 0(a2)
		lw	s3, 1*4(a2)	
		lw	s5, 2*4(a2)
		lw	s7, 3*4(a2)
		lw	s9, 4*4(a2)
		lw	s11, 5*4(a2)
		lw	t5, 6*4(a2)
		lw	t3, 7*4(a2)
		
		
		// add resultC
		add_result s0, s1, a5, a6, x0
		//nswapll	a5, s1, a4
		//ibutterfly	a5, a5, x0
		//nswaphh	a6, s1, a4
		//ibutterfly	a6, a6, x0
		//nswapll	s1, a6, a5		
		// store resultC
		sw    s0,   0(a0)

		add_result s2, s3, a5, a6, x0
		sw    s2,  1*4(a0)

		add_result s4, s5, a5, a6, x0
		sw    s4,  2*4(a0)
		
		add_result s6, s7, a5, a6, x0
		sw    s6,  3*4(a0)
		
		add_result s8, s9, a5, a6, x0
		sw    s8,  4*4(a0)
		
		add_result s10, s11, a5, a6, x0
		sw   s10,  5*4(a0)
		
		add_result t6, t5, a5, a6, x0
		sw    t6,  6*4(a0)
		
		add_result t4, t3, a5, a6, x0
		sw    t4,  7*4(a0)
		
		
		addi	a0, a0, 8*4
		addi	a1, a1, 8*4
		addi	a2, a2, 8*4
		addi	t0, t0, 1
		blt   	t0, x0, polyAdd_LOOP		
		
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
		
		
