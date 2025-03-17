`timescale 1ps/1ps

module line_buffer_tb;
  import definitions_pkg::*;

  logic clk; 
  logic rstN; 
  logic [7:0] i_data; 
  logic i_data_valid;
  logic rd_data; 
  logic [23:0] o_data;

  line_buffer lb1 (.clk(clk), .rstN(rstN), .i_data(i_data), .i_data_valid(i_data_valid), .rd_data(rd_data), .o_data(o_data));

  always #5 clk = ~clk;

  initial begin
    $monitor("@ time=%0t clk=%0b rstN=%0b i_data=%0h i_data_valid=%0b rd_data=%0b o_data=%0h", $time, clk, rstN, i_data, i_data_valid, rd_data, o_data);
  end

  initial begin
    clk = 1;
    rstN = 0;
    i_data = 0;
    i_data_valid = 0;
    rd_data = 0;
    
    #10;
    rstN = 1;

    //test for writing data into buffer
    i_data_valid = 1;
    for (int i = 0; i < IMAGE_WIDTH; i++) begin
      i_data = i;
      #10;
    end

    i_data_valid = 0;
    #10;
    
    // test for reading data from the buffer
    rd_data = 1;
    for (int i = 0; i < IMAGE_WIDTH; i++) begin
      if (o_data != i) $error("Mismatch at index %0d: Expected = %0d Output = %0d", i, i, o_data); 
      #10;
    end
    $display("TEST PASSED!");
    $finish; 
  end

endmodule: line_buffer_tb