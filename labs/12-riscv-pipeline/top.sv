module top(
    input  CLOCK_50,           // 50 MHz
    input  [9:0] SW,
    input  [3:0] KEY,           // KEY[3] = reset
    output reg [9:0] LEDR
);

    // Clock e Reset
    reg [31:0] counter = 0;

    always @(posedge CLOCK_50)
        counter <= counter + 1;

    wire clk   = counter[21];   // clock lento (~12 Hz)
    wire reset = ~KEY[3];        // reset ativo em nível baixo

    reg [31:0] cycle_counter;
    always @(posedge clk)
    if (!reset)
        cycle_counter <= cycle_counter + 1;  // contar ciclos para calculo de desempenho

    // Sinais do processador
    wire [31:0] pc, instr;
    wire [31:0] addr, writedata;
    wire [31:0] readdata;
    wire        memwrite;
    wire [3:0]  writemask;

    // CPU Pipeline
    riscvpipeline cpu (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .addr(addr),
        .writedata(writedata),
        .memwrite(memwrite),
        .readdata(readdata),
        .writemask(writemask)
    );

    // Memória de Instruções (ROM)
    mem #("text.hex") instr_mem (
    .clk(clk),
    .we(1'b0),              // nunca escreve
    .a(pc),
    .wd(32'b0),
    .rd(instr),
    .mem_wmask(4'b0000)
);

    // Memória de Dados (RAM)
 wire [31:0] MEM_readdata;

mem #("data.hex") data_mem (
    .clk(clk),
    .we(memwrite & isRAM),
    .a(addr),
    .wd(writedata),
    .rd(MEM_readdata),
    .mem_wmask(writemask)
);

// microprocessor multi
// riscvmulti cpu(clk, reset, addr, writedata, memwrite, readdata);

// memory mem for multi
// memmulti ram(clk, memwrite, addr, writedata, readdata, 'h200 + vaddr, vdata);


    // Memory-Mapped I/O
    localparam IO_LEDS_bit = 2;  // 0x00000104
    localparam IO_HEX_bit  = 3;  // 0x00000108
    localparam IO_KEY_bit  = 4;  // 0x00000110
    localparam IO_SW_bit   = 5;  // 0x00000120

    wire [31:0] IO_readdata;

    // Escrita em dispositivos
    always @(posedge clk) begin
        if (memwrite & isIO) begin
            if (addr[IO_LEDS_bit])
                LEDR <= writedata[9:0];

        end
    end

    // Leitura de dispositivos
    assign IO_readdata =
        addr[IO_KEY_bit] ? {28'b0, KEY} :
        addr[IO_SW_bit]  ? {22'b0, SW}  :
                           32'b0;

    // MUX final de leitura (RAM ou I/O)
    assign readdata = isIO ? IO_readdata : MEM_readdata;

endmodule
