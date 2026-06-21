`timescale 1ns / 1ps
module alu #(
    parameter n = 32
)(
    input  logic [n-1:0] data1,
    input  logic [n-1:0] data2,
    input  logic [3:0]   alu_control,  // from alu_control_logic
    output logic [n-1:0] dataW,
    output logic zero_flag
);

    always_comb begin
        unique case (alu_control)
            4'b0010: dataW <= data1 + data2;             // ADD / ADDI
            4'b0110: dataW <= data1 - data2;             // SUB
            4'b0000: dataW <= data1 & data2;             // AND
            4'b0001: dataW <= data1 | data2;             // OR
            4'b0011: dataW <= data1 ^ data2;             // XOR
            4'b0100: dataW <= ($signed(data1) < $signed(data2)) ? 1 : 0; // SLT
            4'b0101: dataW <= data1 << data2[4:0];       // SLL
            4'b0111: dataW <= data1 >> data2[4:0];       // SRL
            // branch material 
            4'b1110: begin          // beq
                dataW <= data1 - data2;
                if(dataW == 0) 
                    zero_flag <= 1'b1;
                else 
                    zero_flag <= 1'b0;
            end
            4'b1010: begin          // bneq
                dataW <= data1 - data2;
                if(dataW == 0) 
                    zero_flag <= 1'b0;
                else 
                    zero_flag <= 1'b1;
            end
            4'b1100: begin          // bles
                dataW <= ($signed(data1) < $signed(data2)) ? 1 : 0; // SLT
                if(dataW == 0) 
                    zero_flag <= 1'b0;
                else 
                    zero_flag <= 1'b1;
            end
            4'b1000: begin          // bgte
                dataW <= ($signed(data1) >= $signed(data2)) ? 1 : 0;
                if(dataW == 0) 
                    zero_flag <= 1'b0;
                else 
                    zero_flag <= 1'b1;
            end
            4'b1001: begin          // bles unsigned
                dataW <= (data1 < data2) ? 1 : 0;
                if(dataW == 0) 
                    zero_flag <= 1'b0;
                else 
                    zero_flag <= 1'b1;
            end
            4'b1011: begin          // bge unsigned
                dataW <= (data1 >= data2) ? 1 : 0;
                if(dataW == 0) 
                    zero_flag <= 1'b0;
                else 
                    zero_flag <= 1'b1;
            end
            default: dataW <= '0;
        endcase
    end

endmodule

