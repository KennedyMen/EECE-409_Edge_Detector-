`timescale 1ps/1ps

module arc_tan_tb;
  logic signed  [10:0] Gx, Gy;
  logic         [1:0]  angle;

  arc_tan atan(
    .Gx(Gx), .Gy(Gy),
    .angle(angle)
  );

  initial begin
    Gx = 0;
    Gy = 0;
    #10;
    Gx = 0;
    Gy = 1;
    #10;
    Gx = 1;
    Gy = 0;
    #10;
    Gx = 52;
    Gy = 64;
    #10;
    Gx = 736;
    Gy = 123;
    #10;
    Gx = -52;
    Gy = -64;
    #10;
    Gx = -736;
    Gy = -123;
    #10;
    Gx = 52;
    Gy = -64;
    #10;
    Gx = 736;
    Gy = -123;
    #10;
    Gx = -52;
    Gy = 64;
    #10;
    Gx = -736;
    Gy = 123;
    #10;
  end

  initial begin
    $monitor("@ time = %t Gx = %d Gy=%d angle = %d", $time, Gx, Gy, angle);
  end

endmodule: arc_tan_tb