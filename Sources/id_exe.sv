`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 03:35:31 PM
// Design Name: 
// Module Name: id_exe
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


module id_exe(
  input  logic        clk,
    input  logic        reset,
    // Data signals
    input  logic [31:0] pc_in,
    input  logic [31:0] read_data1_in,
    input  logic [31:0] read_data2_in,
    input  logic [31:0] imm_in,
    input  logic   fun7_30in,
    input  logic [2:0]  fun3_in,
    input  logic [4:0]  rd_in,
     //control signals
    input logic ALUsrc_in,
    input logic[1:0] ALUop_in,
    input logic Branch_in,Memread_in,Memwrite_in,Memtoreg_in,Regwrite_in,
    // source registers 
    input logic[4:0] rs1_in,rs2_in,
    output logic[4:0] rs1_out,rs2_out,
    
    output logic [31:0] pc_out,
    output logic [31:0] read_data1_out,
    output logic [31:0] read_data2_out,
    output logic [31:0] imm_out,
    output logic   bit30,
    output logic [2:0]  fun3,
    output logic [4:0]  rd_out,
    output logic ALUsrc_out,
    output logic[1:0] ALUop_out,
    output logic Branch_out,Memread_out,Memwrite_out,Memtoreg_out,Regwrite_out
    
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out         <= 0;
            read_data1_out <= 0;
            read_data2_out <= 0;
            imm_out        <= 0;
            bit30        <= 0;
            fun3          <= 0;
            rd_out         <= 0;
            ALUsrc_out <= 0;
            ALUop_out <= 0;
            Branch_out <= 0;
            Memread_out <= 0;
            Memwrite_out <= 0;
            Memtoreg_out <= 0;
            Regwrite_out <= 0;
            rs1_out <= 0;
            rs2_out <= 0;
        end else begin
            pc_out         <= pc_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            imm_out        <= imm_in;
            bit30        <= fun7_30in;
            fun3        <= fun3_in;
            rd_out         <= rd_in;
             ALUsrc_out <= ALUsrc_in;
            ALUop_out <= ALUop_in;
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