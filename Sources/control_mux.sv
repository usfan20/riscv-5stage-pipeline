`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 01:09:50 PM
// Design Name: 
// Module Name: control_mux
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


module control_mux (
    input  logic        ControlNOP,   // from hazard detection

    // original control signals
    input  logic        RegWrite_in,
    input  logic        MemRead_in,
    input  logic        MemWrite_in,
    input  logic        MemToReg_in,
    input  logic        ALUSrc_in,
    input  logic [1:0]  ALUOp_in,
    input  logic        Branch_in,

    // output to ID/EX
    output logic        RegWrite_out,
    output logic        MemRead_out,
    output logic        MemWrite_out,
    output logic        MemToReg_out,
    output logic        ALUSrc_out,
    output logic [1:0]  ALUOp_out,
    output logic        Branch_out
);

    always_comb begin
        if (ControlNOP) begin
            // Insert bubble (NOP)
            RegWrite_out = 1'b0;
            MemRead_out  = 1'b0;
            MemWrite_out = 1'b0;
            MemToReg_out = 1'b0;
            ALUSrc_out   = 1'b0;
            ALUOp_out    = 2'b00;
            Branch_out   = 1'b0;
        end
        else begin
            // Normal operation
            RegWrite_out = RegWrite_in;
            MemRead_out  = MemRead_in;
            MemWrite_out = MemWrite_in;
            MemToReg_out = MemToReg_in;
            ALUSrc_out   = ALUSrc_in;
            ALUOp_out    = ALUOp_in;
            Branch_out   = Branch_in;
        end
    end

endmodule

