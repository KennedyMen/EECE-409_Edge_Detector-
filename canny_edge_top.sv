module canny_edge_top
  import definitions_pkg::*;
  (
    // the canny edge interface will use AXI4 Stream protocol for streaming input pixels
    input   logic       clk, 
    input   logic       rstN,
    // canny edge IP as AXI Slave 
    input   logic [7:0] pixel_in,
    input   logic       pixel_in_valid,
    output  logic       in_ready,
    // canny edge IP as AXI Master
    output  logic [7:0] pixel_out,
    output  logic       pixel_out_valid,
    input   logic       out_ready
  );

  
endmodule: canny_edge_top