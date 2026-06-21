`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 07:28:32 PM
// Design Name: 
// Module Name: zero_flag_check
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


module zero_flag_check #(parameter n=32)(
    input logic [n-1:0] alu_out,
    input logic[2:0] fun3,
    output logic zero_flag
);
    always_comb begin
    case(fun3)
        3'b000: begin   //  branch equal
        if (alu_out == {n{1'b0}})
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
        end
        3'b001: begin   //branch not equal
            if(alu_out == {n{1'b0}}) 
                zero_flag = 1'b0;
            else
                zero_flag = 1'b1;
        end
        3'b100: begin   //branch less than
            if(alu_out == {n{1'b1}})
                zero_flag = 1'b1;
            else 
                zero_flag = 1'b0;
        end
    endcase
    end
endmodule

