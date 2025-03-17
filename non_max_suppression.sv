module Non_Max_Suppresion
(
    input   logic            clk,
    input   logic            rstN,
    input   logic    [98:0]  Gradiant_Magnitude_Data,
    input   logic    [17:0]  Direction_Data,
    input   logic            Gradiant_Magnitude_in_valid,
    input   logic            Direction_Data_in_valid,
    output  logic    [98:0]  NMS_pixels,
    output  logic            NMS_Pixels_out_valid,
    output  logic    [17:0]  NMS_Direction_Data
);

// Pipeline Stage 1: Input Storage
logic unsigned [10:0] gradient_array [0:8];
logic unsigned [1:0]  direction_array [0:8];

logic stage1_valid, stage2_valid, stage3_valid;

// Pipeline Stage 2: Suppression Logic Storage
logic unsigned [10:0] gradient_filtered [0:8];

always @(posedge clk) begin
  if (!rstN) begin
    stage1_valid <= 0;
    stage2_valid <= 0;
  end
  else begin
    // Stage 1: Extract gradient and direction data
    if (Gradiant_Magnitude_in_valid && Direction_Data_in_valid) begin
      for (int i = 0; i < 9; i++) begin
        gradient_array[i]  <= Gradiant_Magnitude_Data[i*11 +: 11]; 
        direction_array[i] <= Direction_Data[i*2 +: 2]; 
      end
    end
    stage1_valid <= Gradiant_Magnitude_in_valid && Direction_Data_in_valid;

    // Stage 2: Non-Maximum Suppression Decision
    if (stage1_valid) begin
      for (int i = 0; i < 9; i++) begin
        gradient_filtered[i] <= gradient_array[i]; // Copy values by default
      end
      case (direction_array[4])
        2'b00: begin
          if (gradient_array[4] >= gradient_array[3] && gradient_array[4] >= gradient_array[5]) begin
            gradient_filtered[3] <= 0;
            gradient_filtered[5] <= 0;
          end
        end
        2'b01: begin
          if (gradient_array[4] >= gradient_array[7] && gradient_array[4] >= gradient_array[1]) begin
            gradient_filtered[1] <= 0;
            gradient_filtered[7] <= 0;
          end
        end
        2'b10: begin
          if (gradient_array[4] >= gradient_array[2] && gradient_array[4] >= gradient_array[6]) begin
            gradient_filtered[2] <= 0;
            gradient_filtered[6] <= 0;
          end
        end
        2'b11: begin
          if (gradient_array[4] >= gradient_array[7] && gradient_array[4] >= gradient_array[0]) begin
            gradient_filtered[0] <= 0;
            gradient_filtered[7] <= 0;
          end
        end
      endcase
    end
    stage2_valid <= stage1_valid;

    // Stage 3: Output Assignment
    if (stage2_valid) begin
      for (int i = 0; i < 9; i++) begin
        NMS_pixels[i*11+:11] <= gradient_filtered[i];
      end
    end
    NMS_Pixels_out_valid <= stage2_valid;
    NMS_Direction_Data <= Direction_Data;
  end
end

endmodule
