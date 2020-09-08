////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_if
//    ║ 1 9 9 6 ║     Purpose:         This is the instruction fetch stage of 
//    ╚═════════╝                      the MIPS pipelined processor.
//
//                    Version:         1.0
//                    Filename:        mips_if.v
//                    Date Created:    August 29, 2020
//                    Last Modified:   September 9, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_if (
    input wire clk,
    input wire rst_n,
    input wire stall,

    // Instruction cache interface
    output wire I_read,
    output wire I_write,

    output wire [`MIPS_ADDR_WIDTH-3:0] I_addr,
    output wire [`MIPS_DATA_WIDTH-1:0] I_wdata,
    input  wire [`MIPS_DATA_WIDTH-1:0] I_rdata,
    
    // IF to ID interface
    output wire [`MIPS_ADDR_WIDTH-1:0] if2id_inst,
    output wire [`MIPS_ADDR_WIDTH-1:0] if2id_pc,

    output wire if2id_prdt_taken
);


wire [2:0] pc_incr_ofst = 3'd4;

wire [`MIPS_ADDR_WIDTH-1:0] pc_r;
wire [`MIPS_ADDR_WIDTH-1:0] pc_nxt;
wire [`MIPS_ADDR_WIDTH-1:0] pc_incr = pc_r + pc_incr_ofst;



////////////////////////////////////////////////////////////////////////////////
// Mini instruction decoder
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_ADDR_WIDTH-1:0] ifu_inst_nxt = I_rdata;

wire minidec_rs_en;
wire minidec_rt_en;

wire [`MIPS_RFIDX_WIDTH-1:0] minidec_rs_idx;
wire [`MIPS_RFIDX_WIDTH-1:0] minidec_rt_idx;

wire minidec_bjp;
wire minidec_j;
wire minidec_jr;
wire minidec_jal;
wire minidec_jalr;
wire minidec_bxx;

wire [`MIPS_ADDR_WIDTH-1:0] minidec_j_imm;
wire [`MIPS_ADDR_WIDTH-1:0] minidec_b_imm;

mips_if_minidec mips_if_minidec_inst (
    .inst        (ifu_inst_nxt),
    .pc_incr     (pc_incr),
    .dec_rs_en   (minidec_rs_en),
    .dec_rt_en   (minidec_rt_en),
    .dec_rs_idx  (minidec_rs_idx),
    .dec_rt_idx  (minidec_rt_idx),
    .dec_bjp     (minidec_bjp),
    .dec_j       (minidec_j),
    .dec_jr      (minidec_jr),
    .dec_jal     (minidec_jal),
    .dec_jalr    (minidec_jalr),
    .dec_bxx     (minidec_bxx),
    .dec_j_imm   (minidec_j_imm),
    .dec_b_imm   (minidec_b_imm)
);


////////////////////////////////////////////////////////////////////////////////
// Branch prediction unit
////////////////////////////////////////////////////////////////////////////////



wire prdt_taken;

wire [`MIPS_ADDR_WIDTH-1:0] prdt_pc;


mips_if_bpu mips_if_bpu_inst (
    .pc_incr       (pc_incr),
    .minidec_j_imm (minidec_j_imm),
    .minidec_b_imm (minidec_b_imm),
    .minidec_j     (minidec_j),
    .minidec_jr    (minidec_jr),
    .minidec_jal   (minidec_jal),
    .minidec_jalr  (minidec_jalr),
    .minidec_bxx   (minidec_bxx),
    .prdt_taken    (prdt_taken),
    .prdt_pc       (prdt_pc)
);


////////////////////////////////////////////////////////////////////////////////
// Next program counter calculation
////////////////////////////////////////////////////////////////////////////////



wire bjp_req = minidec_bjp & prdt_taken;



assign pc_nxt = bjp_req ? prdt_pc : pc_incr;


dff_ce_rstn_0 # (
    .DW (`MIPS_ADDR_WIDTH)
) pc_dff_ce_rstn_0 (
    .clk   (clk),
    .rst_n (rst_n),
    .ce    (pc_en),
    .d_i   (pc_nxt),
    .q_o   (pc_r)
);


endmodule  // mips_if
