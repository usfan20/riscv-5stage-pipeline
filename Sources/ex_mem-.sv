`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:32:11 PM
// Design Name: 
// Module Name: ex_mem
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


module exe_mem(
   input  logic       clk,
    input  logic       reset,
    // Data signals
    input logic[31:0] pc_imm_in,
    input  logic [31:0] alu_result_in,
    input logic zero_in,
    input  logic [31:0] write_data_in,
    input  logic [4:0]  rd_in,
    //control signal
    
    input logic Branch_in,Memread_in,Memwrite_in,Memtoreg_in,Regwrite_in,
    // source registers 
    input logic[4:0] rs1_in,rs2_in,
    output logic[4:0] rs1_out,rs2_out,
    

    output logic [31:0] alu_result_out,
    output logic [31:0] write_data_out,
    output logic [4:0]  rd_out,
    output logic zero_out,
    output logic[31:0] pc_imm_out,
    output logic Branch_out,Memread_out,Memwrite_out,Memtoreg_out,Regwrite_out
    
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out  <= 0;
            write_data_out  <= 0;
            rd_out          <= 0;
            pc_imm_out <= 0;
            zero_out       <=1'b0;
            Branch_out <= 0;
            Memread_out <= 0;
            Memwrite_out <= 0;
            Memtoreg_out <= 0;
            Regwrite_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
        end else begin
            alu_result_out  <= alu_result_in;
            write_data_out  <= write_data_in;
            rd_out          <= rd_in;
            zero_out       <=zero_in;
            pc_imm_out <= pc_imm_in;
            Branch_out <= Branch_in;
            Memread_out <= Memread_in;
            Memwrite_out <= Memwrite_in;
            Memtoreg_out <= Memtoreg_in;
            Regwrite_out <= Regwrite_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
        end
    end
endmodule
