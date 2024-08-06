`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2024 04:16:39 PM
// Design Name: 
// Module Name: counter
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


module counter #(SIZE = 8)(
    input  wire clk,rst,sync_rst,en,
    output reg [SIZE-1:0]counter
    );
    always_ff@(posedge clk or negedge rst) begin
        if (~rst)
            counter <= 0;
        else begin
            if (sync_rst)
                counter <= 0;
            else if (en)
                counter <= counter + 1;
        end
    end
    
endmodule
