`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:44:38 PM
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
input  logic       clk,
    input  logic       reset,
    // Data signals
    input  logic [31:0] mem_data_in,
    input  logic [31:0] alu_result_in,
    input  logic [4:0]  rd_in,
    //control signa;
    input logic Memtoreg_in,Regwrite_in,
    // source registers 
    input logic[4:0] rs1_in,rs2_in,
    output logic[4:0] rs1_out,rs2_out,

    output logic [31:0] mem_data_out,
    output logic [31:0] alu_result_out,
    output logic [4:0]  rd_out,
    output logic Memtoreg_out,Regwrite_out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data_out   <= 0;
            alu_result_out <= 0;
            rd_out         <= 0;
             Memtoreg_out <= 0;
            Regwrite_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
        end else begin
            mem_data_out   <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out         <= rd_in;
            Memtoreg_out <= Memtoreg_in;
            Regwrite_out <= Regwrite_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
        end
    end
endmodule
