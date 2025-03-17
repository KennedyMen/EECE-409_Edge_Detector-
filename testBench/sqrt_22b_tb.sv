`timescale 1ps/1ps

module sqrt_22b_tb;
  logic [20:0] value;
  logic [10:0] sqrt;

  sqrt_22b s1(
    .value(value),
    .sqrt(sqrt)
  );

  initial begin
    for (int i=0; i < 20808; i++) begin
      value = i * 100;
      #10;
    end
    $finish;
  end

endmodule: sqrt_22b_tb