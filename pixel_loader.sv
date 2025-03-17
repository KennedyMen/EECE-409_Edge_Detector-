module pixel_loader
  import definitions_pkg::*;
  #(parameter ITEM_SIZE = 8)
(
  input   logic                   clk, 
  input   logic                   rstN,
  input   logic [ITEM_SIZE-1:0]   pixel_in,
  input   logic                   pixel_in_valid,
  output  logic [9*ITEM_SIZE-1:0] pixel_data_out,
  output  logic                   pixel_data_out_valid
);

  logic [1:0] wr_buffer_enable;
  logic [3:0] wr_buffer_data_valid;
  logic [$clog2(IMAGE_WIDTH)-1:0] pixel_counter;
  logic [$clog2(IMAGE_WIDTH)-1:0] rd_counter;
  logic [10:0] buffer_pixel_count;
  logic rd_buffer_enable;
  logic [1:0] curr_rd_buffer;
  logic [3:0] rd_buffer_data_valid;
  logic [3*ITEM_SIZE-1:0] buffer0_out, buffer1_out, buffer2_out, buffer3_out;

  typedef enum logic [0:0]  {
                              IDLE = 1'b0,
                              READ = 1'b1
                            } rd_buffer_enable_t;
  
  rd_buffer_enable_t curr_state;

  // pixel counter for write buffer switch every 512 pixels
  always @(posedge clk) begin
    if (!rstN) begin
      pixel_counter <= '0;
    end
    else if (pixel_in_valid) begin
      pixel_counter <= pixel_counter + 1;
    end
  end

  // changing the buffer being written into every 512 valid pixel inputs 
  always @(posedge clk) begin
    if (!rstN)
      wr_buffer_enable <= '0;
    else if ((pixel_counter == 511) & (pixel_in_valid))
      wr_buffer_enable <= wr_buffer_enable + 1;
  end

  always_comb begin
    wr_buffer_data_valid = '0;
    wr_buffer_data_valid[wr_buffer_enable] = pixel_in_valid;
  end

  // we can only enable reading when at least 3 of the 4 available line buffers are filled
  // we fill a line buffer while we read from the other 3 simultaneously
  always @(posedge clk) begin
    if (!rstN) begin
      buffer_pixel_count <= '0;
    end
    else begin
      if (pixel_in_valid & !rd_buffer_enable) 
        buffer_pixel_count <= buffer_pixel_count + 1;
      else if (!pixel_in_valid & rd_buffer_enable) 
        buffer_pixel_count <= buffer_pixel_count - 1;
    end
  end

  // state machine for rd_buffer_enable signal
  always @(posedge clk) begin
    if (!rstN) begin 
      curr_state <= IDLE;
      rd_buffer_enable <= '0;
    end
    else begin       
      case (curr_state) 
        IDLE: begin
          if (buffer_pixel_count >= 1536) begin
            rd_buffer_enable <= 1'b1;
            curr_state <= READ;
          end
        end
        READ: begin
          if (rd_counter == 511) begin            
            curr_state <= IDLE;
            rd_buffer_enable <= 1'b0;
          end
        end
      endcase
    end
  end 

  // read counter logic for read buffer switch every 512 pixels
  always @(posedge clk) begin
    if (!rstN) begin
      rd_counter <= '0;
    end
    else if (rd_buffer_enable) begin
      rd_counter <= rd_counter + 1;
    end
  end

  // assigning output based on rd_buffer_enable
  // each 512 pixel reads, we change the set of read buffers which are being read
  always @(posedge clk) begin
    if (!rstN) begin
      curr_rd_buffer <= '0;
    end
    else if (rd_counter == 511 & rd_buffer_enable) begin
      curr_rd_buffer <= curr_rd_buffer + 1;
    end
  end

  always_comb begin
    case (curr_rd_buffer) 
      0: pixel_data_out = {buffer2_out, buffer1_out, buffer0_out};
      1: pixel_data_out = {buffer3_out, buffer2_out, buffer1_out};
      2: pixel_data_out = {buffer0_out, buffer3_out, buffer2_out};
      3: pixel_data_out = {buffer1_out, buffer0_out, buffer3_out};
    endcase
  end

  //output of pixel loader is valid whenever the rd_buffer_enable is set
  assign pixel_data_out_valid = rd_buffer_enable;

  // setting read enable control signal for which buffers to read
  always_comb begin
    rd_buffer_data_valid = {4{rd_buffer_enable}};
    case (curr_rd_buffer) 
      0: rd_buffer_data_valid[3] = 1'b0;
      1: rd_buffer_data_valid[0] = 1'b0;
      2: rd_buffer_data_valid[1] = 1'b0;
      3: rd_buffer_data_valid[2] = 1'b0;
    endcase
  end

  line_buffer #(.SIZE(ITEM_SIZE)) buffer0 (
    .clk(clk),
    .rstN(rstN),
    .i_data(pixel_in),
    .i_data_valid(wr_buffer_data_valid[0]),
    .rd_enable(rd_buffer_data_valid[0]),
    .o_data(buffer0_out)
  );

  line_buffer #(.SIZE(ITEM_SIZE)) buffer1 (
    .clk(clk),
    .rstN(rstN),
    .i_data(pixel_in),
    .i_data_valid(wr_buffer_data_valid[1]),
    .rd_enable(rd_buffer_data_valid[1]),
    .o_data(buffer1_out)
  );

  line_buffer #(.SIZE(ITEM_SIZE)) buffer2 (
    .clk(clk),
    .rstN(rstN),
    .i_data(pixel_in),
    .i_data_valid(wr_buffer_data_valid[2]),
    .rd_enable(rd_buffer_data_valid[2]),
    .o_data(buffer2_out)
  );

  line_buffer #(.SIZE(ITEM_SIZE)) buffer3 (
    .clk(clk),
    .rstN(rstN),
    .i_data(pixel_in),
    .i_data_valid(wr_buffer_data_valid[3]),
    .rd_enable(rd_buffer_data_valid[3]),
    .o_data(buffer3_out)
  );


endmodule: pixel_loader