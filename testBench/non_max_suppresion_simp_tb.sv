`timescale 1ps/1ps

module non_max_suppresion_simple_tb;

  logic         clk;
  logic         rstN;
  logic [98:0]  gradient_magnitude;
  logic [17:0]  gradient_direction;
  logic         gradient_in_valid;
  logic [98:0]  nms_magnitude;
  logic [17:0]  nms_direction;
  logic         nms_valid;

  // Instantiate the Non_Max_Suppresion module
  Non_Max_Suppresion nms(
    .clk(clk),
    .rstN(rstN),
    .Gradiant_Magnitude_Data(gradient_magnitude),
    .Direction_Data(gradient_direction),
    .Gradiant_Magnitude_in_valid(gradient_in_valid),
    .NMS_pixels(nms_magnitude),
    .NMS_Direction_Data(nms_direction),
    .NMS_Pixels_out_valid(nms_valid)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Reset and drive the inputs with test data
  initial begin
    clk = 1;
    rstN = 0;
    gradient_magnitude = 99'b0;
    gradient_direction = 18'b0;
    gradient_in_valid = 0;

    // Apply reset for a few clock cycles
    #20;
    rstN = 1;

    // Test data
    gradient_magnitude = 99'h3FF_3FF_3FF_3FF_3FF_3FF_3FF_3FF_3FF; // Example gradient magnitude data
    gradient_direction = 18'h3_3_3_3_3_3_3_3_3; // Example gradient direction data
    gradient_in_valid = 1;

    // Wait for a few clock cycles to capture the output
    #50;
    gradient_in_valid = 0;

    // Wait for the output to be valid
    wait(nms_valid);

    // Display the output
    $display("NMS Magnitude: %h", nms_magnitude);
    $display("NMS Direction: %h", nms_direction);

    // Finish the simulation
    $finish;
  end

endmodule: non_max_suppresion_simple_tb