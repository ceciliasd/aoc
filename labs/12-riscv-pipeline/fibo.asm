.text
.globl _start
_start:
    la   s0, fib_data      # ponteiro para RAM (dados)
    la   s1, fib_out       # endereço de saída (ex: memória mapeada ou RAM)

    lw   t0, 0(s0)         # t0 = fib[0]
    lw   t1, 4(s0)         # t1 = fib[1]

loop:
    add  t2, t0, t1        # t2 = fib(n) = fib(n-1) + fib(n-2)

    sw   t2, 8(s0)         # guarda próximo fib na RAM
    sw   t2, 0(s1)         # opcional: escreve saída (LED, VGA, etc)

    add  t0, zero, t1
    add  t1, zero, t2
    addi s0, s0, 4         # avança vetor

    j loop

.data
.align 2

fib_data:
    .word 0
    .word 1
    .space 64              # espaço para a sequência

fib_out:
    .word 0

