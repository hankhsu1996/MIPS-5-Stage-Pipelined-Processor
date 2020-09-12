////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex_alu_rglr
//    ║ 1 9 9 6 ║     Purpose:         This is the regular ALU for 
//    ╚═════════╝                      the execution stage.
//
//                    Version:         1.0
//                    Filename:        mips_ex_alu_rglr.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_ex_alu_rglr (
    input wire [`MIPS_DATA_WIDTH-1:0] alu_rs,
    input wire [`MIPS_DATA_WIDTH-1:0] alu_rt,
    input wire [`MIPS_DATA_WIDTH-1:0] alu_imm,
    input wire [`MIPS_ADDR_WIDTH-1:0] alu_pc_incr,

    input wire [`MIPS_DECINFO_WIDTH-1:0] alu_info,

    // Shared ALU datapath interface
    output wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op1,
    output wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op2,

    output wire alu_req_alu_add,
    output wire alu_req_alu_addu,
    output wire alu_req_alu_sub,
    output wire alu_req_alu_subu,
    output wire alu_req_alu_and,
    output wire alu_req_alu_or,
    output wire alu_req_alu_xor,
    output wire alu_req_alu_nor,
    output wire alu_req_alu_sll,
    output wire alu_req_alu_srl,
    output wire alu_req_alu_sra,
    output wire alu_req_alu_slt,
    output wire alu_req_alu_sltu,
    output wire alu_req_alu_lui
);

wire op2imm = alu_info [`MIPS_DECINFO_ALU_OP2IMM];
wire op1pc  = alu_info [`MIPS_DECINFO_ALU_OP1PC];

assign alu_req_alu_op1 = op1pc ? alu_pc_incr : alu_rs;
assign alu_req_alu_op2 = op2imm ? alu_imm : alu_rt;

assign alu_req_alu_add  = alu_info [`MIPS_DECINFO_ALU_ADD];
assign alu_req_alu_addu = alu_info [`MIPS_DECINFO_ALU_ADDU];
assign alu_req_alu_sub  = alu_info [`MIPS_DECINFO_ALU_SUB];
assign alu_req_alu_subu = alu_info [`MIPS_DECINFO_ALU_SUBU];
assign alu_req_alu_and  = alu_info [`MIPS_DECINFO_ALU_AND];
assign alu_req_alu_or   = alu_info [`MIPS_DECINFO_ALU_OR];
assign alu_req_alu_xor  = alu_info [`MIPS_DECINFO_ALU_XOR];
assign alu_req_alu_nor  = alu_info [`MIPS_DECINFO_ALU_NOR];
assign alu_req_alu_sll  = alu_info [`MIPS_DECINFO_ALU_SLL];
assign alu_req_alu_srl  = alu_info [`MIPS_DECINFO_ALU_SRL];
assign alu_req_alu_sra  = alu_info [`MIPS_DECINFO_ALU_SRA];
assign alu_req_alu_slt  = alu_info [`MIPS_DECINFO_ALU_SLT];
assign alu_req_alu_sltu = alu_info [`MIPS_DECINFO_ALU_SLTU];
assign alu_req_alu_lui  = alu_info [`MIPS_DECINFO_ALU_LUI];

endmodule  // mips_ex_alu_rglr
