.text

.macro Montgomery a, b, prime_inv_neg, prime, tmp1
    mulh    \tmp1, \a, \b
    mul     \b, \a, \b

    mul     \b, \b, \prime_inv_neg

    mulhsu    \b, \b, \prime
    sub     \b, \tmp1, \b
.endm

.macro Barrett a, prime, BarrettV, tmp1
    mulhsu    \tmp1, \a, \BarrettV
    mul     \tmp1, \tmp1, \prime
    sub     \a, \a, \tmp1
.endm

//void NTT_forward(int16_t *coefficients, int16_t *root_table)
//coefficients in a0, root_table in a1

.global BaseMul
.type BaseMul, %function

BaseMul:
    
    addi    sp, sp, -(4*25)
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
    sw	    a4, 72(sp)
    sw      a5, 76(sp)
    sw      a0, 80(sp)
    sw      a1, 84(sp)
    sw      a2, 88(sp)
    sw      a3, 92(sp)
    sw      x0, 96(sp)

    li      a5, 1806234369
    li      a4, 3329
    li      t1, -128
    BaseMul_LOOP:

        lh  s1, 0(a0) 
        lh  s2, 2(a0)
        mv  s3, s1
        mv  s4, s2
	//lh  s3, 0(a0)
	//lh  s4, 2(a0)

        lh  s5, 0(a1) 
        lh  s6, 2(a1)


        lh  s7, 0(a2)

        //lh  s8, 0(a3)
        //lh  s9, 2(a3)

        Montgomery  s5, s1, a5, a4, t6
        Montgomery  s6, s2, a5, a4, t6
        Montgomery  s7, s2, a5, a4, t6
        //add         s8, s8, s2
        //add         s8, s8, s1
        add    s8, s2, s1

        Montgomery  s6, s3, a5, a4, t6
        Montgomery  s5, s4, a5, a4, t6
        //add         s9, s9, s3
        //add         s9, s9, s4
        add    s9, s3, s4
	
	li a5, 1290167
        Barrett  s8,  a4, a5, t6
        Barrett  s9,  a4, a5, t6

        sh  s8, 0(a3)
        sh  s9, 2(a3)

    	addi    a2, a2, 2
	addi    a1, a1, 2*2
	addi    a0, a0, 2*2
	addi    a3, a3, 2*2
	addi    t1, t1, 1
	blt     t1, x0, BaseMul_LOOP
    

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
    lw	    a4, 72(sp)
    lw      a5, 76(sp)
    lw      a0, 80(sp)
    lw      a1, 84(sp)
    lw      a2, 88(sp)
    lw      a3, 92(sp) 
    lw      x0, 96(sp)

    addi    sp, sp, (4*25)


ret

