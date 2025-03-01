


module Convolution

    // global module params 
    #( 	parameter COLDepth = 8,// bit based color this should be 8bit color for most purposes
        parameter Gauss_Scale = 3,
        parameter Sobel_Scale = 3,// Matrix scale can be i.e 3x3 or 5x5 
        parameter Gauss_Size = Gauss_Scale*Gauss_Scale,
        parameter Sobel_Size = Sobel_Scale*Sobel_Scale, // number of elements needed to make arry work 
        parameter Block_Size = 9

    )
    // IO for module 
    (input logic clk,// clk signal 
    input logic reset,// reset signal 
    input logic BeginWrite,//write enable 
    input logic BeginConvolution,
    input logic BeginGauss,
    input logic BeginSobel,
    input logic [71:0] Pixels_In_Grayscale// the value for the image at the array address
    );
    // star     
    
    
    ting 
    reg[COLDepth-1:0] image_array [0:Image_height-1][0:Image_width-1];// 2D image array 
    // neccesary for making it possible for both the gaussian and sobel filter processing
    reg[3:0] addr_x, addr_y;// the neccesary row and column values for the 2d image array 
    // this should be passed into the module by whatever we are using for image processing 
    reg[3:0] gaussian_filter_matrix [0:Gauss_Size-1]= // creating SizexSize Matrix 
    {   4'd1, 4'd2, 4'd1,
        4'd2, 4'd4, 4'd2,
        4'd1, 4'd2, 4'd1
    };
    reg[3:0] sobel_filter_matrix [0:Sobel_Size-1]= // creating SizexSize Matrix 
    {   4'd2, 4'd1, 4'd1,
        4'd3, 4'd4, 4'd2,
        4'd6, 4'd7, 4'd8
    };
    //p
    //preparing image 
    reg [15:0] pixel_count;// tracking writes 
    bit image_ready;
    always_ff @(posedge clk or posedge reset) begin 
        if (!reset) begin 
            integer i, j;
            for (i = 0; i < Block_Size; i++)
                for (j = 0; j < Block_Size; j++)
                    image_array[i][j] <= 8'd0;
            pixel_count <= 0;
            image_ready <= 0;
        end else begin 
            if (!image_ready) begin
                image_array[addr_x][addr_y] <=Pixel_In_Grayscale;//placing all information into  image array 
                pixel_count <= pixel_count + 1;// counter when done 
            end 
            else if (pixel_count == Total_size-1) begin
                image_ready <=1;// finished sending image to array 
            end
            if (!BeginWrite && !BeginConvolution) begin 
                if(BeginGauss) output_array <= Gaussian_Out;
                for 

                
            end 
        end 
    end 
endmodule 

module img_process
    // IO for module 
    (input logic clk,// clk signal 
    input logic reset,// reset signal 
    input logic BeginWrite,//write enable 
    input logic BeginConvolution,
    input logic input_image_data,//write enable 
    input logic input_data_valid,
    output_image_data [7:0],
    out_data_ready
    );
endmodule
module gradient_processing
    (input logic clk,// clk signal 
    input logic reset,// reset signal 
    input logic BeginWrite,//write enable 
    input logic BeginConvolution,
    input [7:0] Full_image_x [0:512],
    input [7:0] Full_image_y [0:512],
    output [7:0] Final Image [0:512]
    )
hyster
module 