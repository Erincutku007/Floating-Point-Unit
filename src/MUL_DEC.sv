`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 04:20:10 PM
// Design Name: 
// Module Name: MUL_DECODE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUL_DEC(
    input  wire [31:0]a,
    input  wire [31:0]b,
    output reg [(16*16-1):0]y
    );
    reg [15:0]products[15:0];
    genvar i,j,k;
    always_comb begin
    end
    generate
        for (i=0;i<4;i=i+1)begin
            for (j=0;j<4;j=j+1)begin
                assign products[(4*i+j)] = a[(8*(j+1)-1):(8*j)]*b[(8*(i+1)-1):(8*i)];
            end
        end
    endgenerate
    generate
        for (k=0;k<16;k=k+1)begin
            assign y[(16*(k+1)-1):16*k] = products[k];
        end
    endgenerate
endmodule
