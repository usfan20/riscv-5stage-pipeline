`timescale 1ns / 1ps
module top_module_tb;
    parameter w = 32;
    parameter addr_w = 5;
    logic clk;
    logic reset,branch_1;
    logic [w-1:0] alu_result,data1_out,data2_out,inst_val_top,data_for_rd,imm_value;
    logic [addr_w-1:0] pc_addr_out;

    top_module #(
        .w(w),
        .addr_w(addr_w)
    ) uut (
        .clk(clk),
        .reset(reset),
        .alu_result(alu_result),
        .pc_addr_out(pc_addr_out),
        .data1_out(data1_out),
        .data2_out(data2_out),
        .inst_val_top(inst_val_top),
        .branch_1(branch_1),
        .data_for_rd(data_for_rd),
        .imm_out_top(imm_value)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   
    end
    initial begin
        reset  = 1;
        #20;                 
        reset  = 0;
        #10;                 
        #500;               
        
        $finish;
    end
    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, top_module_tb);
    end

endmodule
