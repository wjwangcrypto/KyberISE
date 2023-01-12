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

.global polyBaseMul
.type polyBaseMul, %function

polyBaseMul:
    
    addi    sp, sp, -(4*20)
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

    li      a5, Prime_inv_neg
    li      a4, Prime
    li      t1, -128
    polyBaseMul_LOOP:

        lh  s1, 0(a0) //涔嬪墠璇敤浜嗗瘎瀛樺櫒s0锛屽鑷寸▼搴忓嚭闂
        lh  s2, 2(a0)
        mv  s3, s1
        mv  s4, s2

        lh  s5, 0(a1) //娉ㄦ剰a1鏄痬atrixS鐨勫�� 闇�瑕佸啀娆¤鍒╃敤锛屽洜姝1鐨勫�间笉鑳借淇敼
        lh  s6, 2(a1)


        lh  s7, 0(a3)//娉ㄦ剰a5鏄痳oot_table_Rfield_pairwise鐨勫�� 闇�瑕佸啀娆¤鍒╃敤锛屽洜姝5鐨勫�间笉鑳借淇敼

        lh  s8, 0(a2)
        lh  s9, 2(a2)

        Montgomery  s5, s1, a5, a4, t6
        Montgomery  s6, s2, a5, a4, t6
        Montgomery  s7, s2, a5, a4, t6
        add         s8, s8, s2
        add         s8, s8, s1

        Montgomery  s6, s3, a5, a4, t6
        Montgomery  s5, s4, a5, a4, t6
        add         s9, s9, s3
        add         s9, s9, s4

        sh  s8, 0(a2)
        sh  s9, 2(a2)

    addi    a2, a2, 2*2
	addi    a1, a1, 2*2
	addi    a0, a0, 2*2
	addi    a3, a3, 2
	addi    t1, t1, 1
	blt     t1, x0, polyBaseMul_LOOP
    

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
    addi    sp, sp, (4*20)


ret

