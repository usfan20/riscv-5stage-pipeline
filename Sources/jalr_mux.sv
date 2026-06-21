`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2025 02:45:37 PM
// Design Name: 
// Module Name: jalr_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Multiplexer to select between PC+4 and ALU/memory output for JALR
//////////////////////////////////////////////////////////////////////////////////

module writeback_mux(
    input logic [31:0] pc_4,
    input logic [31:0] alu_out,
    input logic [31:0] mem_out,
    input logic [1:0] sig,
    output logic [31:0] mux_out
);

    always_comb begin
        case(sig)
            2'b01: mux_out = alu_out;      // ALU result (e.g., JALR target)
            2'b10: mux_out = mem_out;      // Memory read value (if needed)
        endcase
    end

endmodule

