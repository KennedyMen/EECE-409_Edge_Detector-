module line_buffer
  import definitions_pkg::*;
  #(parameter SIZE = 8)
(
  input   logic                clk, 
  input   logic                rstN, 
  input   logic [SIZE-1:0]     i_data, 
  input   logic                i_data_valid,
  input   logic                rd_enable, 
  output  logic [3*SIZE-1:0]   o_data
);

  logic [SIZE-1:0] line [0:IMAGE_WIDTH-1];
  logic [$clog2(IMAGE_WIDTH)-1:0] rdPtr, wrPtr;

  // write to line buffer logic
  always @(posedge clk) begin
    if (!rstN) begin
      wrPtr <= '0;
    end
    else if (i_data_valid) begin
      line[wrPtr] <= i_data;
      wrPtr <= wrPtr + 1; 
    end
  end

  // read from line buffer logic
  always @(posedge clk) begin
    if (!rstN) begin
      rdPtr <= '0;
    end
    else if (rd_enable) begin
      rdPtr <= rdPtr + 1;
    end
  end

  // output is always driven for prefetch
  // output is updated when rd_enable is driven with rd_ptr update
  always_comb begin
    if      (rdPtr == 511)  o_data = {line[rdPtr], line[rdPtr], line[rdPtr]};
    else if (rdPtr == 510)  o_data = {line[rdPtr], line[rdPtr + 1], line[rdPtr]};
    else                    o_data = {line[rdPtr], line[rdPtr + 1], line[rdPtr + 2]};   
  end

endmodule: line_buffer