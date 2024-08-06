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


module test(
    input  wire [31:0]a,
    input  wire [31:0]b,
    output wire [7:0]y
    );
    reg [7:0]a0,a1,a2,a3,a4,a5,a6,a7;
    reg [7:0]b0,b1,b2,b3,b4,b5,b6,b7;
    assign y = a0+b0;
endmodule
