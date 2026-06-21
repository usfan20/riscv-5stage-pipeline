`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 02:49:20 PM
// Design Name: 
// Module Name: Reg1
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


module id_if(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_in,
    input  logic [31:0] instr_in,
    output logic [31:0] pc_out,
    output logic [31:0] instr_out

    
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
            
        end else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule