.text

.global read_ra
.type read_ra, %function

read_ra:
  addi sp, sp, (-4*2)
  sw   x3, 0(sp)
  sw   x1, 4(sp)
  
  lw  x3, 532(sp)
  
  lw   x3, 0(sp)
  lw   x1, 4(sp)
  addi sp, sp, (4*2)

  ret
   
