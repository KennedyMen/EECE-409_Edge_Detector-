module arc_tan(
  input   logic   signed [10:0]  Gx, Gy,
  output  logic          [1:0]   angle // 0: 0, 1:45, 2:90, 3:135
);

  logic [10:0] Gx_u, Gy_u;

  always_comb begin
    angle = 2'b00; 
    Gx_u  = Gx[10] ? (~Gx + 1'b1) : Gx;//if statement to confirm Gx[10] is 1 or not 
    //This is the two's complement operation, which converts a negative number to its absolute value. mainly checking if the 
    // number is negative or not 
    Gy_u  = Gy[10] ? (~Gy + 1'b1) : Gy;// absolute value of G value 

    if (Gx == 0 && Gy == 0) begin
      angle = 2'b00; 
    end
    else if (Gx == 0) begin 
      angle = 2'b10; // no matter what if the X value of Gx is 0 then output 90degree 
    end
    else if (Gy == 0) begin
      angle = 2'b00; // Gy gives 0 degrees
    end
    else begin
      if ((!Gx[10]) && (!Gy[10])) begin
        angle = (Gy_u > Gx_u) ? 2'b01 : 2'b00; // 45 degrees for if the absolute of y is larger than x
      end
      else if ((Gx[10]) && (Gy[10])) begin
        angle = (Gy_u > Gx_u) ? 2'b01 : 2'b00;
      end
      else if ((!Gx[10]) && (Gy[10])) begin   // if there is a negative x or y with a posistive complement then it is
        angle = (Gy_u > Gx_u) ? 2'b11 : 2'b00;
      end
      else begin
        angle = (Gy_u > Gx_u) ? 2'b11 : 2'b00;
      end
    end
  end
  
endmodule: arc_tan