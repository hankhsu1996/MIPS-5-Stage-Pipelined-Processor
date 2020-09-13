////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex_alu
//    ║ 1 9 9 6 ║     Purpose:         This is the arithmetic logic unit for 
//    ╚═════════╝                      the execution stage.
//
//                    Version:         1.0
//                    Filename:        mips_ex_alu.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_ex_alu (
    // ID to EX stage interface
    input wire [`MIPS_DATA_WIDTH-1:0] id2ex_rs,
    input wire [`MIPS_DATA_WIDTH-1:0] id2ex_rt,
    input wire [`MIPS_DATA_WIDTH-1:0] id2ex_imm,
    input wire [`MIPS_ADDR_WIDTH-1:0] id2ex_pc_incr,

    input wire [`MIPS_DECINFO_WIDTH-1:0] id2ex_dec_info,

    input wire [`MIPS_RFIDX_WIDTH-1:0] id2ex_rd_idx,
    input wire id2ex_rd_wen,

    // EX to MEM interface
    output wire ex2mem_mem_read,
    output wire ex2mem_mem_write,
    output wire [`MIPS_ADDR_WIDTH-1:0] ex2mem_mem_addr,
    output wire [`MIPS_DATA_WIDTH-1:0] ex2mem_mem_wdat,

    output wire [`MIPS_RFIDX_WIDTH-1:0] ex2mem_rd_idx,
    output wire [ `MIPS_DATA_WIDTH-1:0] ex2mem_rd_wdat,
    output wire ex2mem_rd_wen
);


wire alu_op = id2ex_dec_info[`MIPS_DECINFO_GRP] == `MIPS_DECINFO_GRP_ALU;
wire agu_op = id2ex_dec_info[`MIPS_DECINFO_GRP] == `MIPS_DECINFO_GRP_AGU;
wire bjp_op = id2ex_dec_info[`MIPS_DECINFO_GRP] == `MIPS_DECINFO_GRP_BJP;


////////////////////////////////////////////////////////////////////////////////
// Regular arithmetic logic unit
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] alu_rs      = {`MIPS_DATA_WIDTH {alu_op}} & id2ex_rs;
wire [`MIPS_DATA_WIDTH-1:0] alu_rt      = {`MIPS_DATA_WIDTH {alu_op}} & id2ex_rt;
wire [`MIPS_DATA_WIDTH-1:0] alu_imm     = {`MIPS_DATA_WIDTH {alu_op}} & id2ex_imm;
wire [`MIPS_ADDR_WIDTH-1:0] alu_pc_incr = {`MIPS_ADDR_WIDTH {alu_op}} & id2ex_pc_incr;

wire [`MIPS_DECINFO_WIDTH-1:0] alu_info = {`MIPS_DECINFO_WIDTH {alu_op}} & id2ex_dec_info;

wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op1;
wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op2;

wire alu_req_alu_add;
wire alu_req_alu_addu;
wire alu_req_alu_sub;
wire alu_req_alu_subu;
wire alu_req_alu_and;
wire alu_req_alu_or;
wire alu_req_alu_xor;
wire alu_req_alu_nor;
wire alu_req_alu_sll;
wire alu_req_alu_srl;
wire alu_req_alu_sra;
wire alu_req_alu_slt;
wire alu_req_alu_sltu;
wire alu_req_alu_lui;

mips_ex_alu_rglr mips_ex_alu_rglr_inst (
    .alu_rs      (alu_rs),
    .alu_rt      (alu_rt),
    .alu_imm     (alu_imm),
    .alu_pc_incr (alu_pc_incr),
    .alu_info    (alu_info),

    // Shared ALU datapath interface
    .alu_req_alu_op1 (alu_req_alu_op1),
    .alu_req_alu_op2 (alu_req_alu_op2),

    .alu_req_alu_add  (alu_req_alu_add),
    .alu_req_alu_addu (alu_req_alu_addu),
    .alu_req_alu_sub  (alu_req_alu_sub),
    .alu_req_alu_subu (alu_req_alu_subu),
    .alu_req_alu_and  (alu_req_alu_and),
    .alu_req_alu_or   (alu_req_alu_or),
    .alu_req_alu_xor  (alu_req_alu_xor),
    .alu_req_alu_nor  (alu_req_alu_nor),
    .alu_req_alu_sll  (alu_req_alu_sll),
    .alu_req_alu_srl  (alu_req_alu_srl),
    .alu_req_alu_sra  (alu_req_alu_sra),
    .alu_req_alu_slt  (alu_req_alu_slt),
    .alu_req_alu_sltu (alu_req_alu_sltu),
    .alu_req_alu_lui  (alu_req_alu_lui)
);


////////////////////////////////////////////////////////////////////////////////
// Address generation unit
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] agu_rs  = {`MIPS_DATA_WIDTH {agu_op}} & id2ex_rs;
wire [`MIPS_DATA_WIDTH-1:0] agu_rt  = {`MIPS_DATA_WIDTH {agu_op}} & id2ex_rt;
wire [`MIPS_DATA_WIDTH-1:0] agu_imm = {`MIPS_DATA_WIDTH {agu_op}} & id2ex_imm;

wire [`MIPS_DECINFO_WIDTH-1:0] agu_info = {`MIPS_DECINFO_WIDTH {agu_op}} & id2ex_dec_info;

wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op1;
wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op2;

wire agu_req_alu_add;
wire agu_mem_read;
wire agu_mem_write;

wire [`MIPS_DATA_WIDTH-1:0] agu_mem_wdat;

mips_ex_alu_agu mips_ex_alu_agu_inst (
    .agu_rs   (agu_rs),
    .agu_rt   (agu_rt),
    .agu_imm  (agu_imm),
    .agu_info (agu_info),

    // Shared ALU datapath interface
    .agu_req_alu_op1 (agu_req_alu_op1),
    .agu_req_alu_op2 (agu_req_alu_op2),

    .agu_req_alu_add  (agu_req_alu_add),
    .agu_mem_read     (agu_mem_read),
    .agu_mem_write    (agu_mem_write),
    .agu_mem_wdat     (agu_mem_wdat)
);


////////////////////////////////////////////////////////////////////////////////
// Conditional branch unit
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] bjp_rs      = {`MIPS_DATA_WIDTH {bjp_op}} & id2ex_rs;
wire [`MIPS_DATA_WIDTH-1:0] bjp_rt      = {`MIPS_DATA_WIDTH {bjp_op}} & id2ex_rt;
wire [`MIPS_DATA_WIDTH-1:0] bjp_imm     = {`MIPS_DATA_WIDTH {bjp_op}} & id2ex_imm;
wire [`MIPS_ADDR_WIDTH-1:0] bjp_pc_incr = {`MIPS_ADDR_WIDTH {bjp_op}} & id2ex_pc_incr;

wire [`MIPS_DECINFO_WIDTH-1:0] bjp_info = {`MIPS_DECINFO_WIDTH {bjp_op}} & id2ex_dec_info;

wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op1;
wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op2;

wire bjp_req_alu_cmp_gez;
wire bjp_req_alu_cmp_ltz;
wire bjp_req_alu_cmp_eq;
wire bjp_req_alu_cmp_ne;
wire bjp_req_alu_cmp_lez;
wire bjp_req_alu_cmp_gtz;
wire bjp_req_alu_add;

mips_ex_alu_bjp mips_ex_alu_bjp_inst (
    .bjp_rs      (bjp_rs),
    .bjp_rt      (bjp_rt),
    .bjp_imm     (bjp_imm),
    .bjp_pc_incr (bjp_pc_incr),
    .bjp_info    (bjp_info),

    // Shared ALU datapath interface
    .bjp_req_alu_op1 (bjp_req_alu_op1),
    .bjp_req_alu_op2 (bjp_req_alu_op2),

    .bjp_req_alu_cmp_gez (bjp_req_alu_cmp_gez),
    .bjp_req_alu_cmp_ltz (bjp_req_alu_cmp_ltz),
    .bjp_req_alu_cmp_eq  (bjp_req_alu_cmp_eq),
    .bjp_req_alu_cmp_ne  (bjp_req_alu_cmp_ne),
    .bjp_req_alu_cmp_lez (bjp_req_alu_cmp_lez),
    .bjp_req_alu_cmp_gtz (bjp_req_alu_cmp_gtz),
    .bjp_req_alu_add     (bjp_req_alu_add)
);


////////////////////////////////////////////////////////////////////////////////
// ALU datapath
////////////////////////////////////////////////////////////////////////////////

wire alu_req_alu = alu_op & id2ex_rd_wen;
wire agu_req_alu = agu_op;
wire bjp_req_alu = bjp_op;

wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_res;
wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_res;
wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_add_res;
wire bjp_req_alu_cmp_res;

mips_ex_alu_dpath mips_ex_alu_dpath_inst (
    // Regular ALU request
    .alu_req_alu         (alu_req_alu),

    .alu_req_alu_op1     (alu_req_alu_op1),
    .alu_req_alu_op2     (alu_req_alu_op2),

    .alu_req_alu_add     (alu_req_alu_add),
    .alu_req_alu_addu    (alu_req_alu_addu),
    .alu_req_alu_sub     (alu_req_alu_sub),
    .alu_req_alu_subu    (alu_req_alu_subu),
    .alu_req_alu_and     (alu_req_alu_and),
    .alu_req_alu_or      (alu_req_alu_or),
    .alu_req_alu_xor     (alu_req_alu_xor),
    .alu_req_alu_nor     (alu_req_alu_nor),
    .alu_req_alu_sll     (alu_req_alu_sll),
    .alu_req_alu_srl     (alu_req_alu_srl),
    .alu_req_alu_sra     (alu_req_alu_sra),
    .alu_req_alu_slt     (alu_req_alu_slt),
    .alu_req_alu_sltu    (alu_req_alu_sltu),
    .alu_req_alu_lui     (alu_req_alu_lui),

    .alu_req_alu_res     (alu_req_alu_res),

    // AGU request
    .agu_req_alu         (agu_req_alu),

    .agu_req_alu_op1     (agu_req_alu_op1),
    .agu_req_alu_op2     (agu_req_alu_op2),

    .agu_req_alu_add     (agu_req_alu_add),

    .agu_req_alu_res     (agu_req_alu_res),

    // BJP request
    .bjp_req_alu         (bjp_req_alu),

    .bjp_req_alu_op1     (bjp_req_alu_op1),
    .bjp_req_alu_op2     (bjp_req_alu_op2),

    .bjp_req_alu_cmp_gez (bjp_req_alu_cmp_gez),
    .bjp_req_alu_cmp_ltz (bjp_req_alu_cmp_ltz),
    .bjp_req_alu_cmp_eq  (bjp_req_alu_cmp_eq),
    .bjp_req_alu_cmp_ne  (bjp_req_alu_cmp_ne),
    .bjp_req_alu_cmp_lez (bjp_req_alu_cmp_lez),
    .bjp_req_alu_cmp_gtz (bjp_req_alu_cmp_gtz),
    .bjp_req_alu_add     (bjp_req_alu_add),

    .bjp_req_alu_add_res (bjp_req_alu_add_res),
    .bjp_req_alu_cmp_res (bjp_req_alu_cmp_res)
);


////////////////////////////////////////////////////////////////////////////////
// Generate output data
////////////////////////////////////////////////////////////////////////////////

assign ex2mem_mem_read = agu_mem_read;
assign ex2mem_mem_write = agu_mem_write;
assign ex2mem_mem_addr = {`MIPS_DATA_WIDTH {agu_op}} & agu_req_alu_res;
assign ex2mem_mem_wdat = agu_mem_wdat;

assign ex2mem_rd_idx = id2ex_rd_idx;
assign ex2mem_rd_wdat = 
    {`MIPS_DATA_WIDTH {alu_op}} & alu_req_alu_res |
    {`MIPS_DATA_WIDTH {bjp_op}} & bjp_req_alu_add_res;
assign ex2mem_rd_wen = id2ex_rd_wen;

endmodule
