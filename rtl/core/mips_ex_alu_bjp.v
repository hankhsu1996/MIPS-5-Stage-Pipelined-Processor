////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex_alu_bjp
//    ║ 1 9 9 6 ║     Purpose:         This module implement the conditional  
//    ╚═════════╝                      branch instructions in EX stage.
//
//                    Version:         1.0
//                    Filename:        mips_ex_alu_bjp.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////

module mips_ex_alu_bjp (
    input wire [`MIPS_DATA_WIDTH-1:0] bjp_rs,
    input wire [`MIPS_DATA_WIDTH-1:0] bjp_rt,
    input wire [`MIPS_DATA_WIDTH-1:0] bjp_imm,
    input wire [`MIPS_ADDR_WIDTH-1:0] bjp_pc_incr,

    input wire [`MIPS_DECINFO_WIDTH-1:0] bjp_info,

    // Shared ALU datapath interface
    output wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op1,
    output wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op2,

    output wire bjp_req_alu_cmp_gez,
    output wire bjp_req_alu_cmp_ltz,
    output wire bjp_req_alu_cmp_eq,
    output wire bjp_req_alu_cmp_ne,
    output wire bjp_req_alu_cmp_lez,
    output wire bjp_req_alu_cmp_gtz
);

assign bjp_req_alu_op1 = bjp_rs;
assign bjp_req_alu_op1 = bjp_rt;

assign bjp_req_alu_cmp_gez = bjp_info [`MIPS_DECINFO_BJP_BGEZ];
assign bjp_req_alu_cmp_ltz = bjp_info [`MIPS_DECINFO_BJP_BLTZ];
assign bjp_req_alu_cmp_eq  = bjp_info [`MIPS_DECINFO_BJP_BEQ];
assign bjp_req_alu_cmp_ne  = bjp_info [`MIPS_DECINFO_BJP_BNE];
assign bjp_req_alu_cmp_lez = bjp_info [`MIPS_DECINFO_BJP_BLEZ];
assign bjp_req_alu_cmp_gtz = bjp_info [`MIPS_DECINFO_BJP_BGTZ];

endmodule  // mips_ex_alu_bjp
