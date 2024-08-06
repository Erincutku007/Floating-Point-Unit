`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 06:13:35 PM
// Design Name: 
// Module Name: D_FlipFlop
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
module D_FlipFlop #(parameter WIDTH = 32)(
    input logic clk,
    input logic reset,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q);
always_ff @(posedge clk or negedge reset)
    if (~reset) q <= 0;
    else q <= d;
endmodule

