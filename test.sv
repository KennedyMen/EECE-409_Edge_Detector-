module Convolution
    // global module params 
    #( 	parameter COLDepth = 8,
        parameter File_size = 160,
        parameter Out_Size = 27,
        parameter Gaussian_Anch=15,
        parameter Gauss_Size=(Gaussian_Anch+1)/4,
        parameter Matrix_Scale = 5,
        parameter Matrix_Size = Matrix_Scale*Matrix_Scale
    )
    // IO for module 
    (input clk,
    input reset,
    input startC,
    input [COLDepth-1:0] BufferInput [0:File_size-1],
    output reg [COLDepth-1:0] bufferOutput [0:Out_Size-1]
    );
    // starting 
   typedef struct {
        logic[COLDepth-1:0] Red,Green,Blue;} Color;
    reg[Gauss_Size-1:0] filter_matrix [0:Matrix_Size-1]= 
    {   4'd2, 4'd4, 4'd5, 4'd4, 4'd2,
        4'd4, 4'd9, 4'd12, 4'd9, 4'd4,
        4'd5, 4'd12, 4'd15, 4'd12, 4'd5,
        4'd4, 4'd9, 4'd12, 4'd9, 4'd4,
        4'd2, 4'd4, 4'd5, 4'd4, 4'd2
    }
    
    
    
endmodule 