module edge_track_hysteresis
(
    input   logic           clk,
    input   logic           rstN,
    input   logic   signed [89:0]   NMS_Gradiant_Magnitude_Pixels,
    input   logic   signed [17:0]   Direction_Pixels,
    input   logic                   NMS_Gradiant_valid_in,
    input   logic                   Direction_valid_in,
    output  logic   signed [10:0]   processed_pixels [0:8],
    output  logic                   valid_out
);

// Parameters
parameter dThresHigh = 15;
parameter dThresLow  = 10;

// Pipeline registers
logic signed [10:0] gradient_array [0:8];
logic signed [1:0]  direction_array [0:8];
logic signed [10:0] gradient_filtered [0:8];

logic stage1_valid, stage2_valid;
logic Out_bThres;

// Pipeline Stage 1: Input Storage
always @(posedge clk) begin
  if (!rstN) begin
    stage1_valid <= 0;
  end 
  else if (NMS_Gradiant_valid_in && Direction_valid_in) begin
    for (int i = 0; i < 9; i++) begin
      gradient_array[i]  <= NMS_Gradiant_Magnitude_Pixels[i*10 +: 10]; 
      direction_array[i] <= Direction_Pixels[i*2 +: 2];
    end
    stage1_valid <= 1;
  end 
  else begin
    stage1_valid <= 0;
  end
end

// Pipeline Stage 2: Thresholding & Suppression Logic
always @(posedge clk) begin
  if (!rstN) begin
    stage2_valid <= 0;
  end 
  else if (stage1_valid) begin
    // Copy gradient values
    for (int i = 0; i < 9; i++) begin
      gradient_filtered[i] <= gradient_array[i];
    end

    // Apply thresholding and suppression logic
    case (direction_array[4])
      2'b00: begin
        if (gradient_array[4] >= gradient_array[3] && gradient_array[4] >= gradient_array[5]) begin
          gradient_filtered[3] <= 0;
          gradient_filtered[5] <= 0;
        end
      end
      2'b01: begin
        if (gradient_array[4] >= gradient_array[7] && gradient_array[4] >= gradient_array[1]) begin
          gradient_filtered[7] <= 0;
          gradient_filtered[1] <= 0;
        end
      end
      2'b10: begin
        if (gradient_array[4] >= gradient_array[2] && gradient_array[4] >= gradient_array[6]) begin
          gradient_filtered[2] <= 0;
          gradient_filtered[6] <= 0;
        end
      end
      2'b11: begin
        if (gradient_array[4] >= gradient_array[0] && gradient_array[4] >= gradient_array[8]) begin
          gradient_filtered[0] <= 0;
          gradient_filtered[8] <= 0;
        end
      end
    endcase

    stage2_valid <= 1;
  end 
  else begin
    stage2_valid <= 0;
  end
end

// Pipeline Stage 3: Output Assignment
always @(posedge clk) begin
  if (!rstN) begin
    valid_out <= 0;
  end 
  else if (stage2_valid) begin
    for (int i = 0; i < 9; i++) begin
        processed_pixels[i] <= 0;
      end
    for (int i = 0; i < 9; i++) begin
      processed_pixels[i] <= gradient_filtered[i];
    end
    valid_out <= 1;
  end 
  else begin
    valid_out <= 0;
  end
end

endmodule: edge_track_hysteresis