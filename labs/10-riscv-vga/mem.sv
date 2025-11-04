module mem (
  input  logic        clk, we,
  input  logic [31:0] a, wd,
  output logic [31:0] rd,
  input  logic [31:0] va,
  output logic [31:0] vd);

  logic  [31:0] RAM [0:255];

  // initialize memory with instructions or data
  initial
    $readmemh("riscv.hex", RAM);

  always_ff @(posedge clk)
  begin
    if (we)
      RAM[a[31:2]] <= wd;
    rd <= RAM[a[31:2]]; // word aligned
  end

  always_ff @(posedge clk)
    vd <= RAM[va[31:2]]; // word aligned
endmodule