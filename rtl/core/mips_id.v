////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_id
//    ║ 1 9 9 6 ║     Purpose:         This is the instruction decode stage of 
//    ╚═════════╝                      the MIPS pipelined processor.
//
//                    Version:         1.0
//                    Filename:        mips_id.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   August 30, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_id (
    input wire clk,
    input wire rst_n,

    // IF to ID interface
    input wire [`MIPS_INST_WIDTH-1:0] if2id_inst,
    input wire [`MIPS_ADDR_WIDTH-1:0] if2id_pc_incr,

    input wire if2id_prdt_taken,

    input wire [`MIPS_RFIDX_WIDTH-1:0] if2id_rs_idx,
    input wire [`MIPS_RFIDX_WIDTH-1:0] if2id_rt_idx,

    // TODO: flush interface 
    
    // ID to EX interface
    output wire [`MIPS_DATA_WIDTH-1:0] id2ex_rs,
    output wire [`MIPS_DATA_WIDTH-1:0] id2ex_rt,
    output wire [`MIPS_DATA_WIDTH-1:0] id2ex_imm,

    output wire [`MIPS_DECINFO_WIDTH-1:0] id2ex_dec_info,

    output wire [`MIPS_RFIDX_WIDTH-1:0] id2ex_rd_idx,
    output wire id2ex_rd_wen

    // TODO: id2ex pc, inst?
);


////////////////////////////////////////////////////////////////////////////////
// Register File
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] rf_rs;
wire [`MIPS_DATA_WIDTH-1:0] rf_rt;

wire rf_wb_en;

wire [`MIPS_RFIDX_WIDTH-1:0] rf_wb_idx;
wire [ `MIPS_DATA_WIDTH-1:0] rf_wb_dat;


mips_id_regfile mips_id_regfile_inst (
    .clk         (clk),

    // Read port
    .read_rs_idx (if2id_rs_idx),
    .read_rt_idx (if2id_rt_idx),
    .read_rs_dat (rf_rs),
    .read_rt_dat (rf_rt),

    // Write port
    .wb_dest_en  (rf_wb_en),
    .wb_dest_idx (rf_wb_idx),
    .wb_dest_dat (rf_wb_dat)
);

assign id2ex_rs = rf_rs;
assign id2ex_rt = rf_rt;


////////////////////////////////////////////////////////////////////////////////
// Decoder
////////////////////////////////////////////////////////////////////////////////

wire dec_rs_x0;
wire dec_rt_x0;
wire dec_rs_en;
wire dec_rt_en;
wire dec_rd_wen;

wire [`MIPS_RFIDX_WIDTH-1:0] dec_rd_idx;

wire [`MIPS_DECINFO_WIDTH-1:0] dec_info;

wire [`MIPS_ADDR_WIDTH-1:0] dec_imm;

mips_id_decode mips_id_decode_inst (
    // IF to ID information
    .if2id_inst       (if2id_inst),
    .if2id_pc_incr    (if2id_pc_incr),
    .if2id_prdt_taken (if2id_prdt_taken),

    // Decoded rs, rt info and info-bus
    .dec_rs_x0  (dec_rs_x0),
    .dec_rt_x0  (dec_rt_x0),
    .dec_rs_en  (dec_rs_en),
    .dec_rt_en  (dec_rt_en),
    .dec_rd_wen (dec_rd_wen),

    .dec_rs_idx (),
    .dec_rt_idx (),
    .dec_rd_idx (dec_rd_idx),
    .dec_info   (dec_info),
    .dec_imm    (dec_imm),

    // Decoded BJP info
    .dec_bjp   (),
    .dec_j     (),
    .dec_jr    (),
    .dec_jal   (),
    .dec_jalr  (),
    .dec_bxx   (),
    .dec_j_imm (),
    .dec_b_imm ()
);

assign id2ex_imm = dec_imm;
assign id2ex_dec_info = dec_info;
assign id2ex_rd_idx = dec_rd_idx;
assign id2ex_rd_wen = dec_rd_wen;
endmodule

