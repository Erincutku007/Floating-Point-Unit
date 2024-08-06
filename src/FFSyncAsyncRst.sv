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
module FFSyncAsyncRst #(parameter WIDTH = 32)(
    input wire clk,
    input wire reset,
    input wire rst_sync,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q);
    always_ff @(posedge clk or negedge reset)
        if (~reset) 
            q <= 0;
        else begin 
            if (rst_sync)
                q <= 0;
            else
                q <= d;
        end
    endmodule

