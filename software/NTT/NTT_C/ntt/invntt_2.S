# extern void invntt_2(int16_t *p,int16_t *zetas, int32_t KQ<<16, int32_t qinv,const int32_t barret_constant);

.text


.macro montgomery_2_4 a0,a1,a2,a3,qinv,kyb_Q,temp0,temp1,temp88,temp99
  #qinv is quinv<<16
  #q is q<<16    
  mul \temp0,\a0,\qinv  
   mul \temp88,\a1,\qinv
    mul \temp99,\a2,\qinv                      
  mulh  \temp1,\temp0,\kyb_Q
   mulh  \temp0,\temp88,\kyb_Q
    mulh  \temp88,\temp99,\kyb_Q 
     mul \temp99,\a3,\qinv          
  sub \a0,\a0,\temp1
  srai \a0,\a0,16
   sub \a1,\a1,\temp0
     mulh  \temp1,\temp99,\kyb_Q 
   srai \a1,\a1,16 
    sub \a2,\a2,\temp88 
    srai \a2,\a2,16
     sub \a3,\a3,\temp1 
     srai \a3,\a3,16                       
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


.macro butter2_inv left,right,zeta,qinv,kyb_Q,bar_const,temp0,temp1,temp2,shl16_Q  
 add \temp0,\left,x0                                #t = r[j];
 add \left,\left,\right                             #r[j] = barrett_reduce(t + r[j + len]);

 sub \temp0,\temp0,\right                           #r[j + len] = t - r[j + len];
 mul \right,\temp0,\zeta                            #m = (int32_t)zeta*r[j + len]
       
.endm

.macro butter2_inv_2 left0,right0,left1,right1,zeta,qinv,kyb_Q,bar_const,temp0,temp1,temp2,shl16_Q,temp99  
 add \temp0,\left0,x0                                  #t = r[j];
 add \left0,\left0,\right0                             #r[j] = barrett_reduce(t + r[j + len]);
 sub \temp0,\temp0,\right0                             #r[j + len] = t - r[j + len];
 mul \right0,\temp0,\zeta                              #m = (int32_t)zeta*r[j + len]
   add \temp99,\left1,x0                                
   add \left1,\left1,\right1 
   sub \temp99,\temp99,\right1                           
   mul \right1,\temp99,\zeta
 
.endm

.macro butter2_inv_4 left0,right0,left1,right1,left2,right2,left3,right3,zeta,qinv,kyb_Q,bar_const,temp0,temp1,temp2,shl16_Q,temp99  
 add \temp0,\left0,x0                                  #t = r[j];
 add \left0,\left0,\right0                             #r[j] = barrett_reduce(t + r[j + len]);
 sub \temp0,\temp0,\right0                             #r[j + len] = t - r[j + len];
 mul \right0,\temp0,\zeta                              #m = (int32_t)zeta*r[j + len]
   add \temp99,\left1,x0                                
   add \left1,\left1,\right1 
   sub \temp99,\temp99,\right1                           
   mul \right1,\temp99,\zeta
     add \temp0,\left2,x0                                  #t = r[j];
     add \left2,\left2,\right2
     sub \temp0,\temp0,\right2                             #r[j + len] = t - r[j + len];
     mul \right2,\temp0,\zeta                              #m = (int32_t)zeta*r[j + len]
        add \temp99,\left3,x0                                
        add \left3,\left3,\right3 
         sub \temp99,\temp99,\right3                           
         mul \right3,\temp99,\zeta  
 barrett_2_4l \left0,\left1,\left2,\left3,\kyb_Q,\bar_const,\temp99,\temp1,\temp0,\temp2,\zeta
 montgomery_2_4 \right0,\right1,\right2,\right3,\qinv,\shl16_Q,\temp99,\temp1,\temp0,\temp2
.endm

.macro butter2_inv_8 left0,right0,left1,right1,left2,right2,left3,right3,left4,right4,left5,right5,left6,right6,left7,right7,zeta,qinv,kyb_Q,bar_const,temp0,temp1,temp2,shl16_Q,temp99  
 add \temp0,\left0,x0                                  #t = r[j];
 add \left0,\left0,\right0                             #r[j] = barrett_reduce(t + r[j + len]);
 sub \temp0,\temp0,\right0                             #r[j + len] = t - r[j + len];
 mul \right0,\temp0,\zeta                              #m = (int32_t)zeta*r[j + len]
   add \temp99,\left1,x0                                
   add \left1,\left1,\right1
   sub \temp99,\temp99,\right1                           
   mul \right1,\temp99,\zeta
     add \temp0,\left2,x0                                 
     add \left2,\left2,\right2
     sub \temp0,\temp0,\right2                             
     mul \right2,\temp0,\zeta                              
        add \temp99,\left3,x0                                
        add \left3,\left3,\right3 
        sub \temp99,\temp99,\right3                           
        mul \right3,\temp99,\zeta 
             add \temp0,\left4,x0                                  
             add \left4,\left4,\right4 
             sub \temp0,\temp0,\right4                             
             mul \right4,\temp0,\zeta                              
               add \temp99,\left5,x0                                
               add \left5,\left5,\right5 
               sub \temp99,\temp99,\right5                           
               mul \right5,\temp99,\zeta
                 add \temp0,\left6,x0                                  
                 add \left6,\left6,\right6
                 sub \temp0,\temp0,\right6                             
                 mul \right6,\temp0,\zeta                              
                    add \temp99,\left7,x0                                
                    add \left7,\left7,\right7 
                     sub \temp99,\temp99,\right7                           
                     mul \right7,\temp99,\zeta 

  barrett_2_4l \left0,\left1,\left2,\left3,\kyb_Q,\bar_const,\temp99,\temp1,\temp0,\temp2,\zeta
  barrett_2_4l \left4,\left5,\left6,\left7,\kyb_Q,\bar_const,\temp99,\temp1,\temp0,\temp2,\zeta
 montgomery_2_4 \right0,\right1,\right2,\right3,\qinv,\shl16_Q,\temp99,\temp1,\temp0,\temp2
 montgomery_2_4 \right4,\right5,\right6,\right7,\qinv,\shl16_Q,\temp99,\temp1,\temp0,\temp2
.endm


.globl invntt_2
.align 2
invntt_2: 
    # Note the ABI: arguments a0-a7, return value is expected in a0 (and a1 if the case). 
    # If used s0-s11, ra,sp - save to stack and restore after 
    # If the values of t0-t6 needed after calling a fnct, save it before    

    addi sp, sp, -56 	# Make space for 12 words on the stack
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
    sw ra,48(sp)
    sw gp,52(sp) 

    slli gp,a2,16      #gp= Q<<16

##############  LEVEL 3-1  ##############
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

   

##############  LEVEL 1  ##############
    lh a7,0(a5)      #load omega new
    butter2_inv_2 s0,s2,s1,s3,a7,a3,a2,a4,t0,t1,t2,gp,ra
    lh a7,2(a5)      #load omega new
    butter2_inv_2 s4,s6,s5,s7,a7,a3,a2,a4,t0,t1,t2,gp,ra
    lh a7,4(a5)      #load omega new
    butter2_inv_2 s8,s10,s9,s11,a7,a3,a2,a4,t0,t1,t2,gp,ra
    lh a7,6(a5)      #load omega new
    butter2_inv_2 t3,t5,t4,t6,a7,a3,a2,a4,t0,t1,t2,gp,ra

    barrett_2_4l s0,s1,s4,s5,a2,a4,t0,t1,t2,ra,a7
    barrett_2_4l s8,s9,t3,t4,a2,a4,t0,t1,t2,ra,a7
    montgomery_2_4 s2,s3,s6,s7,a3,gp,t0,t1,t2,ra
    montgomery_2_4 s10,s11,t5,t6,a3,gp,t0,t1,t2,ra
##############  LEVEL 2  ##############
    lh a7,8(a5)      #load omega new
    butter2_inv_4 s0,s4,s1,s5,s2,s6,s3,s7,a7,a3,a2,a4,t0,t1,t2,gp,ra
    lh a7,10(a5)      #load omega new
    butter2_inv_4  s8,t3,s9,t4,s10,t5,s11,t6,a7,a3,a2,a4,t0,t1,t2,gp,ra
##############  LEVEL 3  ##############
    lh a7,12(a5)      #load omega new    
    butter2_inv_8  s0,s8,s1,s9,s2,s10,s3,s11,s4,t3,s5,t4,s6,t5,s7,t6,a7,a3,a2,a4,t0,t1,t2,gp,ra

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
    addi a5,a5,14
    addi a6,a6,-1
    bne a6,x0,loop_16  #jump back if >=0
    #p=p[256] now
    addi a0,a0,-512    #p=p[0]

##############  END LEVEL 3-1  ##############

##############  LEVEL 7_6_5_4  ##############
    lh ra,254(a1)     #load zeta_inv[127]

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

    #########  LEVEL 4  ###########
    lh a7,224(a1)     #load zeta_inv 112
    butter2_inv s0,s1,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,226(a1)     #load zeta_inv 113
    butter2_inv s2,s3,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,228(a1)     #load zeta_inv 114
    butter2_inv s4,s5,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,230(a1)     #load zeta_inv 115
    butter2_inv s6,s7,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,232(a1)     #load zeta_inv 116
    butter2_inv s8,s9,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,234(a1)     #load zeta_inv 117
    butter2_inv s10,s11,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,236(a1)     #load zeta_inv 118
    butter2_inv t3,t4,a7,a3,a2,a4,t0,t1,t2,gp
    lh a7,238(a1)     #load zeta_inv 119
    butter2_inv t5,t6,a7,a3,a2,a4,t0,t1,t2,gp

     barrett_2_4l s0,s2,s4,s6,a2,a4,t0,t1,t2,a5,a7
     barrett_2_4l s8,s10,t3,t5,a2,a4,t0,t1,t2,a5,a7             
     montgomery_2_4 s1,s3,s5,s7,a3,gp,t0,t1,t2,a5
     montgomery_2_4 s9,s11,t4,t6,a3,gp,t0,t1,t2,a5
    #########  LEVEL 5  ###########
    lh a7,240(a1)     #load zeta_inv 120
    butter2_inv_2 s0,s2,s1,s3,a7,a3,a2,a4,t0,t1,t2,gp,a5
    lh a7,242(a1)     #load zeta_inv 121
    butter2_inv_2 s4,s6,s5,s7,a7,a3,a2,a4,t0,t1,t2,gp,a5
    lh a7,244(a1)     #load zeta_inv 122
    butter2_inv_2 s8,s10,s9,s11,a7,a3,a2,a4,t0,t1,t2,gp,a5
    lh a7,246(a1)     #load zeta_inv 123
    butter2_inv_2 t3,t5,t4,t6,a7,a3,a2,a4,t0,t1,t2,gp,a5

     barrett_2_4l s0,s1,s4,s5,a2,a4,t0,t1,t2,a5,a7
     barrett_2_4l s8,s9,t3,t4,a2,a4,t0,t1,t2,a5,a7           
     montgomery_2_4 s2,s3,s6,s7,a3,gp,t0,t1,t2,a5
     montgomery_2_4 s10,s11,t5,t6,a3,gp,t0,t1,t2,a5
    #########  LEVEL 6  ###########
    lh a7,248(a1)     #load zeta_inv 124
    butter2_inv_4 s0,s4,s1,s5,s2,s6,s3,s7,a7,a3,a2,a4,t0,t1,t2,gp,a5
    lh a7,250(a1)     #load zeta_inv 125
    butter2_inv_4 s8,t3,s9,t4,s10,t5,s11,t6,a7,a3,a2,a4,t0,t1,t2,gp,a5
    #########  LEVEL 7  ###########
    lh a7,252(a1)     #load zeta_inv 126
    butter2_inv_8  s0,s8,s1,s9,s2,s10,s3,s11,s4,t3,s5,t4,s6,t5,s7,t6,a7,a3,a2,a4,t0,t1,t2,gp,a5

    #store 16 butterflies values 
    # r[j] * zetas_inv[127] 
    # montgomery(r[j] * zetas_inv[127]) 
    # p[i]=t0 
    mul t0,s0,ra     
    mul s0,s1,ra
    mul s1,s2,ra 
    mul s2,s3,ra
    mul s3,s4,ra 
    mul s4,s5,ra
    mul s5,s6,ra 
    mul s6,s7,ra 
    mul s7,s8,ra 
    mul s8,s9,ra  
    mul s9,s10,ra 
    mul s10,s11,ra 
    mul s11,t3,ra  
    mul t3,t4,ra  
    mul t4,t5,ra  
    mul t5,t6,ra
    
    montgomery_2_4 t0,s0,s1,s2,a3,gp,t1,t2,a7,t6
    montgomery_2_4 s3,s4,s5,s6,a3,gp,t1,t2,a7,t6
    montgomery_2_4 s7,s8,s9,s10,a3,gp,t1,t2,a7,t6
    montgomery_2_4 s11,t3,t4,t5,a3,gp,t1,t2,a7,t6     
     
    sh t0,0(a0)
    sh s0,32(a0)
    sh s1,64(a0)
    sh s2,96(a0) 
    sh s3,128(a0)
    sh s4,160(a0)
    sh s5,192(a0)
    sh s6,224(a0) 
    sh s7,256(a0)
    sh s8,288(a0) 
    sh s9,320(a0)
    sh s10,352(a0)
    sh s11,384(a0)
    sh t3,416(a0)
    sh t4,448(a0)
    sh t5,480(a0)
    addi a6,a6,-1
while:
    bge a6,zero,do     #loop while a6>=0 //16 loops

##############  END LEVEL 7_6_5_4  ##############

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
    lw ra,48(sp)
    lw gp,52(sp)
    addi sp, sp, 56 	# Clear 12 words from the stack
    ret
