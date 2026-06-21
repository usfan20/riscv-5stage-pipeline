`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2025 10:19:42 PM
// Design Name: 
// Module Name: muxB
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


module muxB(
input logic[31:0] data1,data2,datar,
    input logic[1:0] sigB,
    output logic[31:0] data
    );
    always_comb begin
        if(sigB==2'b10)begin
            data = data1;
        end
        else if(sigB==2'b01) begin
            data = data2;
        end
        else begin
            data = datar;
        end
    end
endmodule
