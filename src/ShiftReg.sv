`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 04:54:37 PM
// Design Name: 
// Module Name: ShiftReg
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

module ShiftReg #(parameter WIDTH = 32)(
    input wire clk,
    input wire reset,
    input wire rst_sync,
    input wire shift_en,
    input wire parallel_en,
    input wire parallel_input,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q);
    
    always_ff @(posedge clk, negedge reset)
            if (~reset)
                q <= 1<<(WIDTH-1);
            else begin
                if (rst_sync)
                    q <= 1<<(WIDTH-1);
                else begin
                    if (parallel_en)
                        q <= d;
                    else if (shift_en) begin
                        q <= {parallel_input,q[WIDTH-1:1]};
                    end
                end
            end
    endmodule
