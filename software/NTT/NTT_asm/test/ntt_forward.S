.text

.equ Prime, 3329
.equ Prime_inv_neg, 1806234369
.equ LenN_inv_R2_Rfield, 2208
.equ BarrettV, 1290167
.equ INV2, 1665


.macro mon_butterfly a, b, c, prime_inv_neg, prime, tmp1
    mulh    \tmp1, \a, \b
    mul     \b, \a, \b

    mul     \b, \b, \prime_inv_neg

    mulhsu    \b, \b, \prime
    sub     \tmp1, \tmp1, \b

    sub     \b, \c, \tmp1
    add     \c, \c, \tmp1
.endm

.macro mon_butterfly_inv a, b, c, prime_inv_neg, prime, tmp1
    sub     \tmp1, \c, \b
    add     \c, \c, \b

    mulh    \b, \a, \tmp1
    mul     \tmp1, \a, \tmp1

    mul     \tmp1, \tmp1, \prime_inv_neg

    mulhsu    \tmp1, \tmp1, \prime
    sub     \b, \b, \tmp1
.endm

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

.macro finalReduce a, LenN_inv_Rfield, prime_inv_neg, prime, BarrettV, INV2, tmp1
    Montgomery  \LenN_inv_Rfield, \a, \prime_inv_neg, \prime, \tmp1
//    Barrett     \a, \prime, \BarrettV, \tmp1
//    sltu        \tmp1, \INV2, \a
//    mul         \tmp1, \tmp1, \prime
//    sub         \a, \a, \tmp1
.endm

//void NTT_forward(int16_t *coefficients, int16_t *root_table)
//coefficients in a0, root_table in a1

.global NTT_forward
.type NTT_forward, %function

NTT_forward:
    addi    sp, sp, -(4*21)
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
    sw	    a2, 72(sp)
    sw      a3, 76(sp)
    sw      a7, 80(sp)

	
	li		a2, Prime_inv_neg
	li		a3, Prime
	
    li      t0, -16 //the flag to run NTT_forward_1234_LOOP
    NTT_forward_1234_LOOP:
        //Load coefficients
        lh      s0, 0(a0)
        lh      s1, 16*2(a0)
        lh      s2, 32*2(a0)
        lh      s3, 48*2(a0)
        lh      s4, 64*2(a0)
        lh      s5, 80*2(a0)
        lh      s6, 96*2(a0)
        lh      s7, 112*2(a0)
        lh      s8, 128*2(a0)
        lh      s9, 144*2(a0)
        lh      s10, 160*2(a0)
        lh      s11, 176*2(a0)
        lh      t3, 192*2(a0)
        lh      t4, 208*2(a0)
        lh      t5, 224*2(a0)
        lh      t6, 240*2(a0)

        //Level_1
        lh      t1, 0(a1)   //Load root_table of Level_1

        mon_butterfly t1, s8, s0, a2, a3, a7

        mon_butterfly t1, s9, s1, a2, a3, a7

        mon_butterfly t1, s10, s2, a2, a3, a7

        mon_butterfly t1, s11, s3, a2, a3, a7

        mon_butterfly t1, t3, s4, a2, a3, a7

        mon_butterfly t1, t4, s5, a2, a3, a7

        mon_butterfly t1, t5, s6, a2, a3, a7

        mon_butterfly t1, t6, s7, a2, a3, a7


        //level_2
        lh      t1, 1*2(a1)   //Load root_table of Level_2

        mon_butterfly t1, s4, s0, a2, a3, a7

        mon_butterfly t1, s5, s1, a2, a3, a7

        mon_butterfly t1, s6, s2, a2, a3, a7

        mon_butterfly t1, s7, s3, a2, a3, a7

        lh      t1, 2*2(a1)   //Load root_table of Level_2

        mon_butterfly t1, t3, s8, a2, a3, a7

        mon_butterfly t1, t4, s9, a2, a3, a7

        mon_butterfly t1, t5, s10, a2, a3, a7

        mon_butterfly t1, t6, s11, a2, a3, a7

        //level_3
        lh      t1, 3*2(a1)   //Load root_table of Level_3
        mon_butterfly t1, s2, s0, a2, a3, a7

        mon_butterfly t1, s3, s1, a2, a3, a7

        lh      t1, 4*2(a1)   //Load root_table of Level_3

        mon_butterfly t1, s6, s4, a2, a3, a7

        mon_butterfly t1, s7, s5, a2, a3, a7

        lh      t1, 5*2(a1)   //Load root_table of Level_3
        mon_butterfly t1, s10, s8, a2, a3, a7

        mon_butterfly t1, s11, s9, a2, a3, a7

        lh      t1, 6*2(a1)   //Load root_table of Level_3
        mon_butterfly t1, t5, t3, a2, a3, a7

        mon_butterfly t1, t6, t4, a2, a3, a7

        //level_4
        lh      t1, 7*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s1, s0, a2, a3, a7

        lh      t1, 8*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s3, s2, a2, a3, a7

        lh      t1, 9*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s5, s4, a2, a3, a7

        lh      t1, 10*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s7, s6, a2, a3, a7

        lh      t1, 11*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s9, s8, a2, a3, a7

        lh      t1, 12*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, s11, s10, a2, a3, a7

        lh      t1, 13*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, t4, t3, a2, a3, a7

        lh      t1, 14*2(a1)   //Load root_table of Level_4
        mon_butterfly t1, t6, t5, a2, a3, a7

        //Store coefficients
        sh      s0, 0(a0)
        sh      s1, 16*2(a0)
        sh      s2, 32*2(a0)
        sh      s3, 48*2(a0)
        sh      s4, 64*2(a0)
        sh      s5, 80*2(a0)
        sh      s6, 96*2(a0)
        sh      s7, 112*2(a0)
        sh      s8, 128*2(a0)
        sh      s9, 144*2(a0)
        sh      s10, 160*2(a0)
        sh      s11, 176*2(a0)
        sh      t3, 192*2(a0)
        sh      t4, 208*2(a0)
        sh      t5, 224*2(a0)
        sh      t6, 240*2(a0)


        addi    a0, a0, 2
        addi    t0, t0, 1
        blt     t0, x0, NTT_forward_1234_LOOP

    addi    a0, a0, -16*2
    addi    a1, a1, 15*2

    li      t0, -16 //the flag to run NTT_forward_567_LOOP
    NTT_forward_567_LOOP:
        //Load coefficients
        lh      s0, 0(a0)
        lh      s1, 1*2(a0)
        lh      s2, 2*2(a0)
        lh      s3, 3*2(a0)
        lh      s4, 4*2(a0)
        lh      s5, 5*2(a0)
        lh      s6, 6*2(a0)
        lh      s7, 7*2(a0)
        lh      s8, 8*2(a0)
        lh      s9, 9*2(a0)
        lh      s10, 10*2(a0)
        lh      s11, 11*2(a0)
        lh      t3, 12*2(a0)
        lh      t4, 13*2(a0)
        lh      t5, 14*2(a0)
        lh      t6, 15*2(a0)

        //Level_5
        lh      t1, 0(a1)   //Load root_table of Level_5
        mon_butterfly t1, s8, s0, a2, a3, a7

        mon_butterfly t1, s9, s1, a2, a3, a7

        mon_butterfly t1, s10, s2, a2, a3, a7

        mon_butterfly t1, s11, s3, a2, a3, a7

        mon_butterfly t1, t3, s4, a2, a3, a7

        mon_butterfly t1, t4, s5, a2, a3, a7

        mon_butterfly t1, t5, s6, a2, a3, a7

        mon_butterfly t1, t6, s7, a2, a3, a7

        //level_6
        lh      t1, 1*2(a1)   //Load root_table of Level_6
        mon_butterfly t1, s4, s0, a2, a3, a7

        mon_butterfly t1, s5, s1, a2, a3, a7

        mon_butterfly t1, s6, s2, a2, a3, a7

        mon_butterfly t1, s7, s3, a2, a3, a7

        lh      t1, 2*2(a1)   //Load root_table of Level_6
        mon_butterfly t1, t3, s8, a2, a3, a7

        mon_butterfly t1, t4, s9, a2, a3, a7

        mon_butterfly t1, t5, s10, a2, a3, a7

        mon_butterfly t1, t6, s11, a2, a3, a7

        //level_7
        lh      t1, 3*2(a1)   //Load root_table of Level_7
        mon_butterfly t1, s2, s0, a2, a3, a7

        mon_butterfly t1, s3, s1, a2, a3, a7

        lh      t1, 4*2(a1)   //Load root_table of Level_7
        mon_butterfly t1, s6, s4, a2, a3, a7

        mon_butterfly t1, s7, s5, a2, a3, a7

        lh      t1, 5*2(a1)   //Load root_table of Level_7
        mon_butterfly t1, s10, s8, a2, a3, a7

        mon_butterfly t1, s11, s9, a2, a3, a7

        lh      t1, 6*2(a1)   //Load root_table of Level_7
        mon_butterfly t1, t5, t3, a2, a3, a7

        mon_butterfly t1, t6, t4, a2, a3, a7

        //Store coefficients
        sh      s0, 0(a0)
        sh      s1, 1*2(a0)
        sh      s2, 2*2(a0)
        sh      s3, 3*2(a0)
        sh      s4, 4*2(a0)
        sh      s5, 5*2(a0)
        sh      s6, 6*2(a0)
        sh      s7, 7*2(a0)
        sh      s8, 8*2(a0)
        sh      s9, 9*2(a0)
        sh      s10, 10*2(a0)
        sh      s11, 11*2(a0)
        sh      t3, 12*2(a0)
        sh      t4, 13*2(a0)
        sh      t5, 14*2(a0)
        sh      t6, 15*2(a0)


        addi    a0, a0, 16*2
        addi    a1, a1, 7*2
        addi    t0, t0, 1
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
    lw      t0, 68(sp)
    lw	    a2, 72(sp)
    lw      a3, 76(sp)
    lw      a7, 80(sp)
    addi    sp, sp, (4*21)




    ret
	
