module Convolution
    // global module params 
    #( 	parameter COLDepth = 8,// bit based color this should be 8bit color for most purposes
        parameter Matrix_Scale = 5,// Matrix scale can be i.e 3x3 or 5x5 
        parameter Matrix_Size = Matrix_Scale*Matrix_Scale, // number of elements needed to make arry work 
        parameter Image_height = 20,
        parameter Image_width = 20,
        parameter Total_size = Image_height*Image_width
    )
    // IO for module 
    (input logic clk,// clk signal 
    input logic reset,// reset signal 
    input logic startC,// start convolution value for later pipelining 
    input logic [3:0] addr_x, addr_y,// the neccesary row and column values for the 2d image array 
    // this should be passed into the module by whatever we are using for image processing 
    input logic [7:0] Pixel_In_Grayscale,// the value for the image at the array address
    output reg [7:0] pixel_out // final output pixel 
    );
    // starting 
    logic [COLDepth-1:0] image_array [0:Image_height-1][0:Image_width-1];// 2D image array 
    // neccesary for making it possible for both the gaussian and sobel filter processing
    reg[COLDepth-1:0] Gaussian_Out [0:Image_height-1][0:Image_width-1];
    reg[7:0] gaussian_filter_matrix [0:Matrix_Size-1]= // creating SizexSize Matrix 
    {   4'd2, 4'd4, 4'd5, 4'd4, 4'd2,
        4'd4, 4'd9, 4'd12, 4'd9, 4'd4,
        4'd5, 4'd12, 4'd15, 4'd12, 4'd5,
        4'd4, 4'd9, 4'd12, 4'd9, 4'd4,
        4'd2, 4'd4, 4'd5, 4'd4, 4'd2
    };
    //preparing image 
    reg [15:0] pixel_count;// tracking writes 
    bit image_ready;
    always_ff @(posedge clk or posedge reset) begin 
        if (reset) begin
            integer i, j;
            for (i = 0; i < Image_height; i++)
                for (j = 0; j < Image_width; j++)
                    image_array[i][j] <= 8'd0;
            pixel_count <= 0;
            image_ready <= 0;
        end else begin 
            if (!image_ready) begin
                image_array[addr_x][addr_y] <=Pixel_In_Grayscale;//placing all information into  image array 
                pixel_count <= pixel_count + 1;// counter when done 
            end 
            if (pixel_count == Total_size-1) begin
                image_ready <=1;// finished sending image to array 
            end
        end 
    end 
    
endmodule 