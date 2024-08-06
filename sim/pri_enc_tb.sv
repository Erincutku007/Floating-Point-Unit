`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2024 06:27:50 PM
// Design Name: 
// Module Name: pri_enc_tb
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


module pri_enc_tb(
    );
        reg [31:0]pri_dat;
        wire [4:0]pri_index;
//        priority_encoder_16b DUT(	// <stdin>:3:10
//        .data(pri_dat),
//        .index(pri_index));
        
        PriorityEncoder32 UUT(
            .data(pri_dat),
            .index(pri_index));
        integer i;
        integer size = 33;
        initial begin
            pri_dat = 0;
            #10;
            for (i =0 ; i<size; i=i+1)begin
                #10;
                pri_dat = 32'hFF_FF_FF_FF >> (32-i);
            end
            #10;
        end
    endmodule
