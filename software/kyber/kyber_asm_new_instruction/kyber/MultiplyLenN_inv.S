
.text

//.macro Montgomery a, b, prime_inv_neg, prime, tmp1, tmp2, tmp3
   // mulh    \tmp1, \a, \b
   // mul     \b, \a, \b

   // mul     \b, \b, \prime_inv_neg

   // mulhsu  \b, \b, \prime
    //sub     \b, \tmp1, \b
//.endm

.macro Montgomery a, b, k, x, temp1, temp2, temp3, temp4, temp5
	mul    \temp1, \a, \b
	srai   \temp2, \temp1, 8
        and   \temp3, \temp1, \x
	mul    \temp4, \temp3, \k
	sub    \temp5, \temp4, \temp2
	srai   \temp2, \temp5, 8
	and   \temp3, \temp5, \x
	mul    \temp4, \temp3, \k
	sub    \b, \temp4, \temp2
	
.endm

.macro Barrett a, prime, BarrettV, tmp1, tmp2
	mul       \tmp2, \a, \BarrettV
	srai      \tmp2, \tmp2, 19
    mul       \tmp1, \tmp2, \prime
    sub       \a, \a, \tmp1
.endm

//void MultiplyLenN_inv(int32_t* coefficients, int32_t LenN_inv_Rfield, int32_t prime_inv_neg, int32_t prime, int32_t BarrettV, int32_t INV2)
//coefficients in a0, LenN_inv_Rfield in a1, prime_inv_neg in a2, prime in a3, BarrettV in a4, INV2 in a5
//coefficients in a0, prime in a1, OP1 in a2, BarrettV in a3, INV2 in a4, xornum in a5,
.global MultiplyLenN_inv
.type MultiplyLenN_inv, %function

MultiplyLenN_inv:
	addi    sp, sp, -(4*9)
	sw      s2, 0(sp)
	sw      t2, 4(sp)
	sw      t1, 8(sp)
	sw      s1, 12(sp)
	sw      t3, 16(sp)
	sw      t4, 20(sp)
	sw      t5, 24(sp)
	sw      t6, 28(sp)
	sw      s3, 32(sp)
	
    li      s1, -256
    MultiplyLenN_inv_LOOP:
        lw  s2, 0(a0)
	li  s3, 13
        Montgomery  a4, s2, s3, a5, t1, t2, t3, t4, t5
	//Montgomery a4, s2 
        Barrett s2, a1, a3, t2, t3

        sw      s2, 0(a0)

        addi    a0, a0, 4
        addi    s1, s1, 1
        blt     s1, x0, MultiplyLenN_inv_LOOP
	
	lw      s2, 0(sp)
	lw      t2, 4(sp)
	lw      t1, 8(sp)
	lw      s1, 12(sp)
	lw      t3, 16(sp)
	lw      t4, 20(sp)
	lw      t5, 24(sp)
	lw      t6, 28(sp)
	lw      s3, 32(sp)
	addi    sp, sp, (4*9)
    ret
