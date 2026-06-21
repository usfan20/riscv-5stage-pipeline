`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2025 10:19:02 PM
// Design Name: 
// Module Name: muxA
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


module muxA(
    input logic[31:0] data1,data2,datar,
    input logic[1:0] sigA,
    output logic[31:0] data
    );
    always_comb begin
        if(sigA==2'b10)begin
            data = data1;
        end
        else if(sigA==2'b01) begin
            data = data2;
        end
        else begin
            data = datar;
        end
    end
endmodule
