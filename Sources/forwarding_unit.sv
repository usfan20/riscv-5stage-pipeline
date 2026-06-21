`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2025 09:55:27 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    input logic reg_write1,reg_write2,
    input logic[4:0] rs1,rs2,rd1,rd2,
    output logic[1:0] sigA,sigB

    );
    always_comb begin
         sigA = 2'b00;
         sigB = 2'b00;
        // this is for the reg_write rs1 from ex/mem
        if(reg_write1 && (rs1==rd1) && rd1!=0)begin
            sigA=2'b10;
        end
        //this is for the reg_write rs1 from mem/wb
        else if(reg_write2 && (rs1==rd2) && rd2!=0)begin
            sigA=2'b01;
        end
        
        if(reg_write1 && (rs2==rd1) && rd1!=0)begin
            sigB=2'b10;
        end
        else if(reg_write2 && (rs2==rd2) && rd2!=0)begin
            sigB=2'b01;
        end
    end
endmodule
