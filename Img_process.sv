// edge_detection_top.sv
// Top-level module that connects all edge detection components from convolution.sv

module edge_detection_top
    #(
        parameter COLDepth = 8,
        parameter Block_Size = 9,
        parameter Image_Width = 512,
        parameter Image_Height = 512
    )
    (
        input  logic clk,
        input  logic rstN,
        input  logic start_processing,
        input  logic [7:0] input_image_data,
        input  logic input_data_valid,
        output logic [7:0] output_image_data,
        output logic output_data_ready
    );

    // Internal control signals
    logic BeginWrite, BeginConvolution, BeginGauss, BeginSobel;
    logic BeginStrength, BeginDirection, BeginHysteresis;
    
    // Internal data wires
    logic [71:0] pixel_block;
    logic data_ready;
    logic [7:0] gaussian_output;
    
    // Arrays for intermediate results
    logic [7:0] sobel_x_output [0:Image_Width-1];
    logic [7:0] sobel_y_output [0:Image_Width-1];
    logic [7:0] strength_output [0:Image_Width-1];
    logic [7:0] direction_output [0:Image_Width-1];
    logic [7:0] hysteresis_output [0:Image_Width-1];

    // Simple control signal generation
    // (You'll implement your own logic for sequencing)
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            BeginWrite <= 1'b0;
            BeginConvolution <= 1'b0;
            BeginGauss <= 1'b0;
            BeginSobel <= 1'b0;
            BeginStrength <= 1'b0;
            BeginDirection <= 1'b0;
            BeginHysteresis <= 1'b0;
            output_data_ready <= 1'b0;
        end
        else begin
            if (start_processing) begin
                BeginWrite <= 1'b1;
                // Other signals would be activated in sequence
                // based on your control logic
            end
        end
    end

    // Module instantiations with connections
    
    // Image processing module - builds 3x3 blocks from input pixels
    img_process img_proc_inst (
        .clk(clk),
        .reset(reset),
        .BeginWrite(BeginWrite),
        .BeginConvolution(BeginConvolution),
        .input_image_data(pixel_in),
        .input_data_valid(pixel_valid),
        .image_data(pixel_block),
        .data_ready(data_ready)
    );

    // Convolution module for Gaussian blur
    Convolution #(
        .COLDepth(COLDepth),
        .Gauss_Scale(3),
        .Sobel_Scale(3),
        .Block_Size(Block_Size)
    ) conv_inst (
        .clk(clk),
        .reset(reset),
        .BeginWrite(BeginWrite & data_ready),
        .BeginConvolution(BeginConvolution),
        .BeginGauss(BeginGauss),
        .BeginSobel(BeginSobel),
        .Pixels_In_Grayscale(pixel_block),
        .Output_Pixel(gaussian_output)
    );

    // Gradient calculation modules
    gradient_strength_processing strength_proc_inst (
        .clk(clk),
        .reset(reset),
        .BeginWrite(BeginWrite),
        .BeginStrength(BeginStrength),
        .Full_image_x(sobel_x_output),
        .Full_image_y(sobel_y_output),
        .Stregnth_Image(strength_output)
    );

    gradient_direction_processing direction_proc_inst (
        .clk(clk),
        .reset(reset),
        .BeginWrite(BeginWrite),
        .BeginDirection(BeginDirection),
        .Full_image_x(sobel_x_output),
        .Full_image_y(sobel_y_output),
        .Direction_Image(direction_output)
    );

    // Final hysteresis processing
    hysteresis hysteresis_inst (
        .clk(clk),
        .reset(reset),
        .BeginWrite(BeginWrite),
        .BeginHysteresis(BeginHysteresis),
        .Full_image_Strength(strength_output),
        .Full_image_Direction(direction_output),
        .Hysteresis_Image(hysteresis_output)
    );

    // Connect final output
    assign final_edge_pixel = hysteresis_output[0]; // You'll need proper indexing logic

endmodule