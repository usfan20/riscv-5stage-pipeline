module top_module #(
    parameter w = 32,
    parameter r_addr_w = 5,
    parameter addr_w = 32,
    parameter addrlen = 32,
    parameter width = 8
)(
    input  logic clk,
    input  logic reset,
    output logic [w-1:0] alu_result,
    output logic [w-1:0] data1_out,
    output logic [w-1:0] data2_out,
    output logic [w-1:0] imm_out_top,
    output logic [w-1:0] data2_reg_top,
    output logic [w-1:0] inst_val_top,
    output logic [w-1:0] data_for_rd,
    output logic [addr_w-1:0] pc_addr_out,
    output alu_src_top,
    output logic branch_1
);

    // Internal signals
    logic [31:0] pc, pc4, nxt_pc,pc_imm;
    logic [r_addr_w-1:0] rs1, rs2, rs3;
    logic [w-1:0] data1, data2, data2_m_i, dataW;
    logic [w-1:0] inst_val;
    logic [w-1:0] imms_val;
    logic [2:0] fun3;
    logic [6:0] fun7, opcode;
    logic ALUsrc, zero_flag;
    logic branch, mem_write, mem_read, mem_to_reg, reg_write;
    logic [1:0] alu_op,imm_src;
    logic [3:0] alu_control;
    logic [31:0] mem_out;
    logic [31:0] mux_out;   
    logic [1:0] sig; 
    // pipelining
     // IF ? ID
    logic [31:0] pc_id, inst_id;

    // ID ? EXE
    logic [31:0] pc_exe, data1_exe, data2_exe, imm_exe;
    logic [4:0] rd_exe,rs1_exe,rs2_exe;
    logic [2:0]fun3_exe;
    logic    bit30;
        /// control signals
        logic ALUsrc_dec,Branch_dec,Memread_dec,Memwrite_dec,Memtoreg_dec,Regwrite_dec;
        logic [1:0] ALUop_dec;
        logic ALUsrc_exe,Branch_exe,Memread_exe,Memwrite_exe,Memtoreg_exe,Regwrite_exe;
        logic [1:0] ALUop_exe;
    // EXE ? MEM
    logic [31:0] pc_mem, alu_result_mem, write_data_mem;
    logic [4:0] rd_mem,rs1_mem,rs2_mem;
    logic zero_mem;
        // control signals
//        logic Branch,Memead,Memwrite,Memtoreg,Regwrite;
        logic Branch_mem,Memread_mem,Memwrite_mem,Memtoreg_mem,Regwrite_mem;

    // MEM ? WB
    logic [31:0] mem_data_wb, alu_result_wb;
    logic [4:0] rd_wb,rs1_wb,rs2_wb;
        //control
        logic Memtoreg_wb,Regwrite_wb;
    /// forwasding unit signals
    logic[1:0] sigA,sigB;
    logic[31:0] data2_exef,data1_exef;
    // Hazard detection signals
logic PCWrite;
logic IF_ID_Write;
logic ControlNOP;

// Overridden control signals (after mux)
logic ALUsrc_mux, Branch_mux, Memread_mux, Memwrite_mux;
logic Memtoreg_mux, Regwrite_mux;
logic [1:0] ALUop_mux;


    // PC
    pc u_pc (
        .clk(clk),
        .reset(reset),
        .nxt_pc(nxt_pc),
        .pc(pc)
    );

    // PC + 4
    pc_plus4 u_pc_plus4 (
        .pc(pc),
        .pc4(pc4)
    );
    pc_plus_immediate u_pc_plus_immediate(
    .pc(pc_exe),
    .imme(imm_exe),
    .pc_imm(pc_imm)
    );

    // Instrucetion memory
    inst_mem #(.r_addr_w(r_addr_w), .addr_w(addr_w)) u_inst_mem (
        .addr(pc),
        .val(inst_val)
    );

    // Register file
    reg_file #(.n(w), .r_addr_w(r_addr_w)) u_reg_file (
        .clk(clk),
        .RegWEn(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rs3(rd_wb),
        .data1(data1),
        .data2_m_i(data2_m_i),
        .dataW(mux_out)
    );

    // Immediate generator
    immediate u_immediate (
       .instr(inst_val),
       .imm_src(imm_src),
       .imm_ext(imms_val)
       
    );
    hazard_detection_unit u_hazard_detection (
    .ID_EX_MemRead(Memread_exe),
    .ID_EX_rd(rd_exe),
    .IF_ID_rs1(rs1),
    .IF_ID_rs2(rs2),

    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .ControlNOP(ControlNOP)
);


    // Control logic
    control_logic u_control_logic (
        .opcode(opcode),
        .branch(branch),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .alu_src(ALUsrc),
        .alu_op(alu_op),
        .sig(sig), 
        .imm_src(imm_src)
    );
    control_mux u_control_mux (
    .ControlNOP(ControlNOP),

    // inputs from control unit
    .RegWrite_in(reg_write),
    .MemRead_in(mem_read),
    .MemWrite_in(mem_write),
    .MemToReg_in(mem_to_reg),
    .ALUSrc_in(ALUsrc),
    .ALUOp_in(alu_op),
    .Branch_in(branch),

    // outputs to ID/EX
    .RegWrite_out(Regwrite_mux),
    .MemRead_out(Memread_mux),
    .MemWrite_out(Memwrite_mux),
    .MemToReg_out(Memtoreg_mux),
    .ALUSrc_out(ALUsrc_mux),
    .ALUOp_out(ALUop_mux),
    .Branch_out(Branch_mux)
);


    // ALU control
    alu_control_logic u_alu_control_logic (
        .alu_op(alu_op),
        .fun3(fun3),
        .thirty_bit(bit30),
        .alu_control(alu_control)
    );
    muxA uut_muxA(
        .data1(alu_result_mem),
        .data2(alu_result_wb),
        .datar(data1_exe),
        .data(data1_exef),
        .sigA(sigA)
    );
    muxB uut_muxB(
        .data1(alu_result_mem),
        .data2(alu_result_wb),
        .datar(data2_exe),
        .data(data2_exef),
        .sigB(sigB)
    );

    // ALU second operand mux
    mux imm_mux (
        .reg_inp(data2_exef),
        .imm_inp(imm_exe),
        .mux_out(data2),
        .signal(ALUsrc)
    );

    // ALU
    alu #(.n(w)) u_alu (
        .data1(data1_exef),
        .data2(data2),
        .alu_control(alu_control),
        .dataW(dataW),
        .zero_flag(zero_flag)
    );
    // forwarding unit is here
    forwarding_unit uut_forwarding_unit(
        .reg_write1(Regwrite_mem),
        .reg_write2(Regwrite_wb),
        .rs1(rs1),
        .rs2(rs2),
        .rd1(rd_mem),
        .rd2(rd_wb),
        .sigA(sigA),
        .sigB(sigB)
    );

    // Data memory
    data_memory #(.n(w), .addrlen(addrlen), .width(width)) u_data_memory (
        .clk(clk),
        .d_mem_addr(alu_result_mem),
        .data2(write_data_mem),
        .memR(mem_read),
        .memW(mem_write),
        .fun3(fun3),
        .mem_out(mem_out)
    );
    // Writeback mux
    writeback_mux WBmux (
        .pc_4(pc4),
        .alu_out(alu_result_wb),
        .mem_out(mem_data_wb),
        .sig(sig),
        .mux_out(mux_out)
    );

    // PC mux for branch (nxt_pc selection)
    pc_mux u_pc_mux (
        .pc_plus4(pc4),
        .pc_imm(pc_mem), 
        .branch(branch),
        .zero_flag(zero_mem),
        .nxt_pc(nxt_pc)
    );
    id_if u_id_if (
        .clk(clk),
        .reset(reset),
        .pc_in(pc),
        .instr_in(inst_val),
        .pc_out(pc_id),
        .instr_out(inst_id)
    );
    id_exe u_id_exe (
        .clk(clk),
        .reset(reset),
        .rs1_in(rs1),
        .rs2_in(rs2),
        .rs1_out(rs1_exe),
        .rs2_out(rs2_exe),
        .pc_in(pc_id),
        .read_data1_in(data1),
        .read_data2_in(data2_m_i),
        .imm_in(imms_val),
        .rd_in(rs3),
        .fun3_in(fun3),
        .fun3(fun3_exe),
        .fun7_30in(fun7[5]),
        .bit30(bit30),
        .pc_out(pc_exe),
        .read_data1_out(data1_exe),
        .read_data2_out(data2_exe),
        .imm_out(imm_exe),
        .rd_out(rd_exe),
        //control signals
        .ALUsrc_in(ALUsrc_mux),
        .ALUop_in(ALUop_mux),
        .Branch_in(Branch_mux),
        .Memread_in(Memread_mux),
        .Memwrite_in(Memwrite_mux),
        .Memtoreg_in(Memtoreg_mux),
        .Regwrite_in(Regwrite_mux),

        .ALUsrc_out(ALUsrc_exe),
        .ALUop_out(ALUop_exe),
        .Branch_out(Branch_exe),
        .Memread_out(Memread_exe),
        .Memwrite_out(Memwrite_exe),
        .Memtoreg_out(Memtoreg_exe),
        .Regwrite_out(Regwrite_exe)
    );
    exe_mem u_exe_mem (
        .clk(clk),
        .reset(reset),
        .rs1_in(rs1_exe),
        .rs2_in(rs2_exe),
        .rs1_out(rs1_mem),
        .rs2_out(rs2_mem),
        .pc_imm_in(pc_imm),
        .alu_result_in(dataW),
        .write_data_in(data2_exe),
        .rd_in(rd_exe),
        .zero_in(zero_flag),
        .zero_out(zero_mem),
        .pc_imm_out(pc_mem),
        .alu_result_out(alu_result_mem),
        .write_data_out(write_data_mem),
        .rd_out(rd_mem),
        //control
        .Branch_in(Branch_exe),
        .Memread_in(Memread_exe),
        .Memwrite_in(Memwrite_exe),
        .Memtoreg_in(Memtoreg_exe),
        .Regwrite_in(Regwrite_exe),
        .Branch_out(Branch_mem),
        .Memread_out(Memread_mem),
        .Memwrite_out(Memwrite_mem),
        .Memtoreg_out(Memtoreg_mem),
        .Regwrite_out(Regwrite_mem)
    );
    mem_wb u_mem_wb (
        .clk(clk),
        .reset(reset),
        .rs1_in(rs1_mem),
        .rs2_in(rs2_mem),
        .rs1_out(rs1_wb),
        .rs2_out(rs2_wb),
        .mem_data_in(mem_out),
        .alu_result_in(alu_result_mem),
        .rd_in(rd_mem),
        .mem_data_out(mem_data_wb),
        .alu_result_out(alu_result_wb),
        .rd_out(rd_wb),
        .Memtoreg_in(Memtoreg_mem),
        .Regwrite_in(Regwrite_mem),
        .Memtoreg_out(Memtoreg_wb),
        .Regwrite_out(Regwrite_wb)
    );
    
    
    
    
    
// Instruction decoding 
    assign opcode = inst_id[6:0];
    assign rs3 = inst_id[11:7];
    assign fun3 = inst_id[14:12];
    assign rs1 = inst_id[19:15];
    assign rs2 = inst_id[24:20];
    assign fun7 = inst_id[31:25];



    // Outputs
    assign alu_result = dataW;
    assign data1_out = data1_exe;
    assign data2_out = data2;
    assign imm_out_top = imm_exe;
    assign data2_reg_top = data2_m_i;
    assign inst_val_top = inst_id;
    assign  data_for_rd= mux_out;
    assign pc_addr_out = pc;
    assign alu_src_top = ALUsrc;
    assign branch_1 = branch;

endmodule
