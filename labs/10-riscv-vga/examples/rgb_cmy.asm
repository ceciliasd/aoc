.text	# 0x00000000 
.globl _start
_start:
	la s0, frame_buffer
	la s1, frame_end
	li s2, 0x10c
loop:
	li a0, 0x1000000
delay:
	addi a0, a0, -1
	sw a0, 0(s2)
	bne a0, x0, delay
	lw t0, 0(s0)
	lw t1, 4(s0)
	sw t1, 0(s0)
	sw t0, 4(s0)
	addi s0, s0, 4
	bne s0, s1, loop
	j _start
	
.data	# 0x00000080 
frame_buffer: # black, rgb, cmy, white
	.word 0x000000, 0x300c03, 0x0f333c, 0xffffff
	.space 300-16
frame_end:
