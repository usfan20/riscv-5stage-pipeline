`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2025 12:57:07 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit (
    input  logic        ID_EX_MemRead,      
    input  logic [4:0]  ID_EX_rd,             
    input  logic [4:0]  IF_ID_rs1,             
    input  logic [4:0]  IF_ID_rs2,             

    output logic        PCWrite,               
    output logic        IF_ID_Write,            
    output logic        ControlNOP              
);

    always_comb begin
        // Default: no stall
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ControlNOP  = 1'b0;

        // Load-use hazard detection
        if (ID_EX_MemRead &&
           ((ID_EX_rd == IF_ID_rs1) ||
            (ID_EX_rd == IF_ID_rs2)) &&
            (ID_EX_rd != 5'd0)) begin

            PCWrite     = 1'b0;   // freeze PC
            IF_ID_Write = 1'b0;   // freeze IF/ID
            ControlNOP  = 1'b1;   // insert bubble in EX
        end
    end

endmodule

