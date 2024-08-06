`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 04:23:39 PM
// Design Name: 
// Module Name: counter_tb
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


module counter_tb(

    );
    reg clk,rst,shift_en,parallel_en;
    wire [7:0]out;
    ShiftReg #(8) DUT(
    .clk(clk),
    .reset(rst),
    .shift_en(shift_en),
    .parallel_en(parallel_en),
    .parallel_input(1'b0),
    .d(8'd6),
    .q(out)
    );
   initial clk = 0;
   always #10 clk = ~clk;
   initial begin
        rst = 0;
        parallel_en = 1;
        shift_en = 0;
        #50;
        rst = 1;
        #100;
        parallel_en = 0;
        rst = 0;
        #30;
        rst = 1;
        shift_en = 1;
   end
endmodule
