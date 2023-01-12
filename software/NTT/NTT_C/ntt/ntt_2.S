# extern void ntt_2(int16_t *p,int16_t *zetas, int32_t KQ<<16, int32_t qinv,const int32_t barret_constant);

.text

.macro montgomery_2 a,qinv,kyb_Q,temp0,temp1
  #qinv is quinv<<16
  #q is q<<16    
  mul \temp0,\a,\qinv               #uint16_t u = a * QINV;
  mulh  \temp1,\temp0,\kyb_Q

  sub \a,\a,\temp1                  #t = a - t;
  srai \a,\a,16                     #return t >>= 16; 
.endm


.macro barrett_2_4l a0,a1,a2,a3,kyb_Q,const,temp0,temp1,temp2,temp3,temp4
 mul \temp0,\const,\a0           #t = const*a;
   mul \temp2,\const,\a1
     mul \temp3,\const,\a2
       mul \temp4,\const,\a3
 srai \temp0,\temp0,26          #t >>= 26; !!!!!!!!! ARITHMETIC SHIFT!
   srai \temp2,\temp2,26
     srai \temp3,\temp3,26 
        srai \temp4,\temp4,26  
 mul \temp1,\temp0,\kyb_Q       #t *= KYBER_Q;
   mul \temp0,\temp2,\kyb_Q
     mul \temp2,\temp3,\kyb_Q
       mul \temp3,\temp4,\kyb_Q 
 sub \a0,\a0,\temp1               #return a - t;
   sub \a1,\a1,\temp0
     sub \a2,\a2,\temp2
       sub \a3,\a3,\temp3
.endm

.macro butter left,right,zeta,qinv,kyb_Q,temp0,temp1,temp2  
  mul \temp0,\zeta,\right
  montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1  
  sub \right,\left,\temp0
  add \left,\left,\temp0
.endm

.macro butter_2 left0,right0,left1,right1,zeta,qinv,kyb_Q,temp0,temp1,temp2,temp99
  mul \temp0,\zeta,\right0
  montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1  
    mul \temp99,\zeta,\right1
  sub \right0,\left0,\temp0
  add \left0,\left0,\temp0
    montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1      
    sub \right1,\left1,\temp99
    add \left1,\left1,\temp99      
.endm


.macro butter_4 left0,right0,left1,right1,left2,right2,left3,right3,zeta,qinv,kyb_Q,temp0,temp1,temp2,temp99
  mul \temp0,\zeta,\right0
  montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1  
    mul \temp99,\zeta,\right1
  sub \right0,\left0,\temp0
  add \left0,\left0,\temp0
    montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
      mul \temp0,\zeta,\right2
    sub \right1,\left1,\temp99
    add \left1,\left1,\temp99
      montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1
        mul \temp99,\zeta,\right3  
      sub \right2,\left2,\temp0
      add \left2,\left2,\temp0
        montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
        sub \right3,\left3,\temp99
        add \left3,\left3,\temp99
.endm


.macro butter_8 left0,right0,left1,right1,left2,right2,left3,right3,left4,right4,left5,right5,left6,right6,left7,right7,zeta,qinv,kyb_Q,temp0,temp1,temp2,temp99
  mul \temp0,\zeta,\right0
  montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1  
    mul \temp99,\zeta,\right1
  sub \right0,\left0,\temp0
  add \left0,\left0,\temp0
    montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
      mul \temp0,\zeta,\right2
    sub \right1,\left1,\temp99
    add \left1,\left1,\temp99
      montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1
        mul \temp99,\zeta,\right3  
      sub \right2,\left2,\temp0
      add \left2,\left2,\temp0
        montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
          mul \temp0,\zeta,\right4 
        sub \right3,\left3,\temp99
        add \left3,\left3,\temp99
          montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1  
            mul \temp99,\zeta,\right5
          sub \right4,\left4,\temp0
          add \left4,\left4,\temp0
            montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
              mul \temp0,\zeta,\right6
            sub \right5,\left5,\temp99
            add \left5,\left5,\temp99
              montgomery_2 \temp0,\qinv,\kyb_Q,\temp2,\temp1
                mul \temp99,\zeta,\right7  
              sub \right6,\left6,\temp0
              add \left6,\left6,\temp0
                montgomery_2 \temp99,\qinv,\kyb_Q,\temp2,\temp1
                sub \right7,\left7,\temp99
                add \left7,\left7,\temp99

.endm


.globl ntt_2
.align 2
ntt_2: 
    # Note the ABI: arguments a0-a7, return value is expected in a0 (and a1 if the case). 
    # If used s0-s11, ra,sp - save to stack and restore after 
    # If the values of t0-t6 needed after calling a fnct, save it before    

    addi sp, sp, -56 	# Make space for 8 words on the stack 48
    sw s0,0(sp)
    sw s1,4(sp)
    sw s2,8(sp)
    sw s3,12(sp)
    sw s4,16(sp)
    sw s5,20(sp)
    sw s6,24(sp)
    sw s7,28(sp)
    sw s8,32(sp)
    sw s9,36(sp)
    sw s10,40(sp)
    sw s11,44(sp)
    sw gp,48(sp) 
    sw ra,52(sp)

##############  LEVEL 7_6_5_4  ##############
    addi a0,a0,32   #p=p[16]
    addi a6,x0,15

do:     
    addi a0,a0,-2   #p-- 


    #load 16 butterflies values 
    lh s0,0(a0)        # s0=p[0]
    lh s1,32(a0)        # s1=p[16]
    lh s2,64(a0)        # s2=p[32]
    lh s3,96(a0)        # s3=p[48]
    lh s4,128(a0)        # s4=p[64]
    lh s5,160(a0)        # s5=p[80]
    lh s6,192(a0)        # s6=p[96]
    lh s7,224(a0)        # s7=p[112]
    lh s8,256(a0)        # s8=p[128]
    lh s9,288(a0)        # s9=p[144]
    lh s10,320(a0)        # s10=p[160]
    lh s11,352(a0)        # s11=p[176]
    lh t3,384(a0)        # t3=p[192]
    lh t4,416(a0)        # t4=p[208]
    lh t5,448(a0)        # t5=p[224]
    lh t6,480(a0)        # t6=p[240]


    #########  LEVEL 7  ###########
    lh a7,2(a1)     #load zeta    
    butter_8 s0,s8,s1,s9,s2,s10,s3,s11,s4,t3,s5,t4,s6,t5,s7,t6,a7,a3,a2,t0,t1,t2,gp
    #########  LEVEL 6  ###########
    lh a7,4(a1)     #load zeta    
    butter_4 s0,s4,s1,s5,s2,s6,s3,s7,a7,a3,a2,t0,t1,t2,gp
    lh a7,6(a1)     #load zeta
    butter_4 s8,t3,s9,t4,s10,t5,s11,t6,a7,a3,a2,t0,t1,t2,gp
    #########  LEVEL 5  ###########
    lh a7,8(a1)     #load zeta
    butter_2 s0,s2,s1,s3,a7,a3,a2,t0,t1,t2,gp
    lh a7,10(a1)     #load zeta
    butter_2 s4,s6,s5,s7,a7,a3,a2,t0,t1,t2,gp 
    lh a7,12(a1)     #load zeta
    butter_2 s8,s10,s9,s11,a7,a3,a2,t0,t1,t2,gp
    lh a7,14(a1)     #load zeta
    butter_2 t3,t5,t4,t6,a7,a3,a2,t0,t1,t2,gp
    #########  LEVEL 4  ###########
    lh a7,16(a1)     #load zeta
    butter s0,s1,a7,a3,a2,t0,t1,t2
    lh a7,18(a1)     #load zeta
    butter s2,s3,a7,a3,a2,t0,t1,t2
    lh a7,20(a1)     #load zeta
    butter s4,s5,a7,a3,a2,t0,t1,t2
    lh a7,22(a1)     #load zeta
    butter s6,s7,a7,a3,a2,t0,t1,t2
    lh a7,24(a1)     #load zeta
    butter s8,s9,a7,a3,a2,t0,t1,t2
    lh a7,26(a1)     #load zeta
    butter s10,s11,a7,a3,a2,t0,t1,t2
    lh a7,28(a1)     #load zeta
    butter t3,t4,a7,a3,a2,t0,t1,t2
    lh a7,30(a1)     #load zeta
    butter t5,t6,a7,a3,a2,t0,t1,t2

    #store 16 butterflies values 
    sh s0,0(a0)        # p[0]=s0
    sh s1,32(a0)        # p[16]=s1
    sh s2,64(a0)        # p[32]=s2
    sh s3,96(a0)        # p[48]=s3
    sh s4,128(a0)        # p[64]=s4
    sh s5,160(a0)        # p[80]=s5
    sh s6,192(a0)        # p[96]=s6
    sh s7,224(a0)        # p[112]=s7
    sh s8,256(a0)        # p[128]=s8
    sh s9,288(a0)        # p[144]=s9
    sh s10,320(a0)        # p[160]=s10
    sh s11,352(a0)        # p[176]=s11
    sh t3,384(a0)        # p[192]=t3
    sh t4,416(a0)        # p[208]=t4
    sh t5,448(a0)        # p[224]=t5
    sh t6,480(a0)        # p[240]=t6


    addi a6,a6,-1
while:
    bge a6,zero,do     #loop while a6>=0 //16 loops


##############  END LEVEL 7_6_5_4  ##############


##############  LEVEL 3-1  ##############
    srli ra,a2,16
    addi a6,x0,16

loop_16:
    #load 16 butterflies values 
    lh s0,0(a0)        # s0=p[0]
    lh s1,2(a0)        # s1=p[1]
    lh s2,4(a0)        # s2=p[2]
    lh s3,6(a0)        # s3=p[3]
    lh s4,8(a0)        # s4=p[4]
    lh s5,10(a0)        # s5=p[5]
    lh s6,12(a0)        # s6=p[6]
    lh s7,14(a0)        # s7=p[7]
    lh s8,16(a0)        # s8=p[8]
    lh s9,18(a0)        # s9=p[9]
    lh s10,20(a0)        # s10=p[10]
    lh s11,22(a0)        # s11=p[11]
    lh t3,24(a0)        # t3=p[12]
    lh t4,26(a0)        # t4=p[13]
    lh t5,28(a0)        # t5=p[14]
    lh t6,30(a0)        # t6=p[15]


##############  LEVEL 3  ##############
    lh a7,0(a4)      #load zeta new
     butter_8 s0,s8,s1,s9,s2,s10,s3,s11,s4,t3,s5,t4,s6,t5,s7,t6,a7,a3,a2,t0,t1,t2,gp
##############  LEVEL 2  ##############
    lh a7,2(a4)      #load zeta new
    butter_4 s0,s4,s1,s5,s2,s6,s3,s7,a7,a3,a2,t0,t1,t2,gp
    lh a7,4(a4)      #load zeta new
    butter_4 s8,t3,s9,t4,s10,t5,s11,t6,a7,a3,a2,t0,t1,t2,gp
##############  LEVEL 1  ##############
    lh a7,6(a4)      #load zeta new
    butter_2 s0,s2,s1,s3,a7,a3,a2,t0,t1,t2,gp
    lh a7,8(a4)      #load zeta new
    butter_2 s4,s6,s5,s7,a7,a3,a2,t0,t1,t2,gp
    lh a7,10(a4)      #load zeta new
    butter_2 s8,s10,s9,s11,a7,a3,a2,t0,t1,t2,gp
    lh a7,12(a4)      #load zeta new
    butter_2 t3,t5,t4,t6,a7,a3,a2,t0,t1,t2,gp
   
    barrett_2_4l s0,s1,s2,s3,ra,a5,t0,t1,t2,gp,a7
    barrett_2_4l s4,s5,s6,s7,ra,a5,t0,t1,t2,gp,a7
    barrett_2_4l s8,s9,s10,s11,ra,a5,t0,t1,t2,gp,a7
    barrett_2_4l t3,t4,t5,t6,ra,a5,t0,t1,t2,gp,a7
    
    
    
    #store 16 butterflies values 
    sh s0,0(a0)        # p[0]=s0
    sh s1,2(a0)        # p[1]=s1
    sh s2,4(a0)        # p[2]=s2
    sh s3,6(a0)        # p[3]=s3
    sh s4,8(a0)        # p[4]=s4
    sh s5,10(a0)        # p[5]=s5
    sh s6,12(a0)        # p[6]=s6
    sh s7,14(a0)        # p[7]=s7
    sh s8,16(a0)        # p[8]=s8
    sh s9,18(a0)        # p[9]=s9
    sh s10,20(a0)        # p[10]=s10
    sh s11,22(a0)        # p[11]=s11
    sh t3,24(a0)        # p[12]=t3
    sh t4,26(a0)        # p[13]=t4
    sh t5,28(a0)        # p[14]=t5
    sh t6,30(a0)        # p[15]=t6


    addi a0,a0,32      #p+=16
    addi a4,a4,14
    addi a6,a6,-1
    bne a6,x0,loop_16  #jump back if >=0
##############  END LEVEL 3-1  ##############
    lw s0,0(sp)
    lw s1,4(sp)
    lw s2,8(sp)
    lw s3,12(sp)
    lw s4,16(sp)
    lw s5,20(sp)
    lw s6,24(sp)
    lw s7,28(sp)
    lw s8,32(sp)
    lw s9,36(sp)
    lw s10,40(sp)
    lw s11,44(sp)
    lw gp,48(sp)
    lw ra,52(sp) 
    addi sp, sp, 56 	# Clear 8 words from the stack
    ret
