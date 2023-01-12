
.text
.equ INV2, 512
.equ Prime, 3329
.equ BarrettV, 157

.macro Montgomery INV2, b, c
	ibutterfly  \b, \b, \INV2
	nswaplh     \b, \c, \b 
.endm

.macro Barrett a, prime, BarrettV, tmp1, tmp2
	mul       \tmp2, \a, \BarrettV
	srai      \tmp2, \tmp2, 19
    mul       \tmp1, \tmp2, \prime
    sub       \a, \a, \tmp1
.endm

//void Multiply_2_7_inv(int32_t* coefficients)
//coefficients in a0

.global Multiply_2_7_inv
.type Multiply_2_7_inv, %function

Multiply_2_7_inv:
	addi    sp, sp, -(7*4)
	sw      s2, 0(sp)
	sw      s1, 4(sp)
	sw      t1, 8(sp)
	sw      t2, 12(sp)
	sw      t3, 16(sp)
	sw      t4, 20(sp)
        sw      a2, 24(sp)
	
    li      s1, -256
    MultiplyLenN_inv_LOOP:
        lh  s2, 0(a0)
        li  t2, 512
        li  t1, 3329
        li  a2, 157
	li  a3, 0
	Montgomery t2, s2, a3 
        //Barrett s2, t1, a2, t3, t4

        sh      s2, 0(a0)

        addi    a0, a0, 2
        addi    s1, s1, 1
        blt     s1, x0, MultiplyLenN_inv_LOOP
	
	lw      s2, 0(sp)
	lw      s1, 4(sp)
	lw      t1, 8(sp)
	lw      t2, 12(sp)
	lw      t3, 16(sp)
	lw      t4, 20(sp)
        lw      a2, 24(sp)
	addi    sp, sp, (7*4)
	
    ret
