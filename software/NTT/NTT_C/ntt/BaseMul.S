.text

.macro montgomery_reduce a, b, qinv, kyberq
		mul		\b,  \a, \qinv
		mul     \b,  \b, \kyberq
		sub     \b,  \a, \b
		srai    \b,  \b, 16	
.endm
// void POLYMUL(int16_t *result, int16_t *inputA, int16_t *inputB, int16_t *zeta)
// result  in a0, inputA in a1,  inputB in a2 zeta in a3

.global BaseMul
.type BaseMul, %function

BaseMul:
		addi 	sp, sp, -(4*12)
		sw      s0,  0(sp)
		sw   	s1,  4(sp)
		sw   	s2,  8(sp)
		sw      s3, 12(sp)
    	sw      s4, 16(sp)
    	sw      s5, 20(sp)
    	sw      s6, 24(sp)
        sw      t3, 28(sp)
		sw      t4, 32(sp)
		sw      t5, 36(sp)
		sw      t6, 40(sp)
        

	
	// load qinv
	li    t1,  62209
	// load kyberq
	li    t2,  3329

	
		// load Matrix_A
		lh    s0,  0(a1)
		lh    s1,  2(a1)
		// load Matrix_B
		lh    s2,  0(a2)
		lh    s3,  2(a2)
		// load resultC
		lh    s5,  0(a0)
		lh    s6,  2(a0)

		mul  t3, s1, s3
		montgomery_reduce t3, s5, t1, t2
		mul  t4, s5, a3
		montgomery_reduce t4, s5, t1, t2
		mul  t5, s0, s2
		montgomery_reduce t5, t6, t1, t2
		add  s5, s5, t6

		mul  t3, s0, s3
		montgomery_reduce t3, s6, t1, t2
		mul  t4, s1, s2
		montgomery_reduce t4, t6, t1, t2
		add s6, s6, t6
		

		
		// store resultC
		sh   s5,   0(a0)
		sh   s6,   2(a0)

		
    lw      s0,  0(sp)
    lw      s1,  4(sp)
    lw      s2,  8(sp)
    lw      s3, 12(sp)
    lw      s4, 16(sp)
    lw      s5, 20(sp)
    lw      s6, 24(sp)
    lw      t3, 28(sp)
	lw      t4, 32(sp)
	lw      t5, 32(sp)
	lw      t6, 32(sp)
    addi    sp, sp, (4*12)

    ret
		
		
