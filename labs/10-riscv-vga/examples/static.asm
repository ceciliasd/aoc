.text	# 0x00000000 
.globl _start
_start:
	j _start
	
.data	# 0x00000080 
frame_buffer: # wrgb, cmy, white
	.word 0xff300c03, 0x000f333c, 0xaaaaaaaa, 0x000f333c, 0xff300c03
	.space 300-40
	.word 0xff300c03, 0x000f333c, 0xaaaaaaaa, 0x000f333c, 0xff300c03
frame_end:
