module mem #(parameter FILENAME = "memfile.hex")
(
    input  logic        clk,
    input  logic        we,               // write enable
    input  logic [31:0] a,                // address
    input  logic [31:0] wd,               // write data
    output logic [31:0] rd,               // read data
    input  logic [3:0]  mem_wmask         // byte enable
);
    (* ramstyle = "M10K" *)
    logic [3:0][7:0] RAM [0:255];

    // Inicialização (ROM ou RAM inicial)
    initial begin
        $readmemh(FILENAME, RAM);
    end
          
    // Endereçamento por palavra (word aligned)
    wire [7:0] word_addr = a[9:2];


    // Porta única: leitura + escrita (estilo Harvard simples)
    always_ff @(posedge clk) begin
        // Escrita com máscara de bytes
        if (we) begin
            if (mem_wmask[0]) RAM[word_addr][0] <= wd[ 7: 0];
            if (mem_wmask[1]) RAM[word_addr][1] <= wd[15: 8];
            if (mem_wmask[2]) RAM[word_addr][2] <= wd[23:16];
            if (mem_wmask[3]) RAM[word_addr][3] <= wd[31:24];
        end

        // Leitura síncrona
        rd <= RAM[word_addr];
    end

endmodule

