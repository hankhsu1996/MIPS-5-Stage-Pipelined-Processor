////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_core
//    ║ 1 9 9 6 ║     Purpose:         This is a classic 5-stage pipelined MIPS 
//    ╚═════════╝                      processor.
// 
//                    Version:         1.0
//                    Filename:        mips_core.v
//                    Date Created:    August 29, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none

module mips_core (
    input  wire clk,
    input  wire rst_n,

    // Instruction cache interface
    output wire I_read,
    output wire I_write,

    output wire [`MIPS_ADDR_WIDTH-3:0] I_addr,
    input  wire [`MIPS_DATA_WIDTH-1:0] I_rdata,
    output wire [`MIPS_DATA_WIDTH-1:0] I_wdata,

    input  wire I_stall,

    // Data cache interface
    output wire D_read,
    output wire D_write,

    output wire [`MIPS_ADDR_WIDTH-3:0] D_addr,
    input  wire [`MIPS_DATA_WIDTH-1:0] D_rdata,
    output wire [`MIPS_DATA_WIDTH-1:0] D_wdata,

    input  wire D_stall
);


////////////////////////////////////////////////////////////////////////////////
// IF stage 
////////////////////////////////////////////////////////////////////////////////

wire stall_if;

wire [`MIPS_INST_WIDTH-1:0] if2id_inst;
wire [`MIPS_ADDR_WIDTH-1:0] if2id_pc_incr;

wire if2id_prdt_taken;

wire [`MIPS_RFIDX_WIDTH-1:0] if2id_rs_idx;
wire [`MIPS_RFIDX_WIDTH-1:0] if2id_rt_idx;


mips_if mips_if_inst (
    .clk   (clk),
    .rst_n (rst_n),
    .stall (stall_if),

    // Instruction cache interface
    .I_read  (I_read),
    .I_write (I_write),
    .I_addr  (I_addr),
    .I_rdata (I_rdata),
    .I_wdata (I_wdata),

    // IF to ID interface
    .if2id_inst    (if2id_inst),
    .if2id_pc_incr (if2id_pc_incr),

    .if2id_prdt_taken (if2id_prdt_taken),

    .if2id_rs_idx (if2id_rs_idx),
    .if2id_rt_idx (if2id_rt_idx)
);


////////////////////////////////////////////////////////////////////////////////
// ID stage 
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] id2ex_rs;
wire [`MIPS_DATA_WIDTH-1:0] id2ex_rt;
wire [`MIPS_DATA_WIDTH-1:0] id2ex_imm;

wire [`MIPS_DECINFO_WIDTH-1:0] id2ex_dec_info;

wire [`MIPS_RFIDX_WIDTH-1:0] id2ex_rd_idx;
wire id2ex_rd_wen;


mips_id mips_id_inst (
    .clk   (clk),
    .rst_n (rst_n),

    // IF to ID interface
    .if2id_inst    (if2id_inst),
    .if2id_pc_incr (if2id_pc_incr),

    .if2id_prdt_taken (if2id_prdt_taken),

    .if2id_rs_idx (if2id_rs_idx),
    .if2id_rt_idx (if2id_rt_idx),

    // TODO: flush interface 
    
    // ID to EX interface
    .id2ex_rs  (id2ex_rs),
    .id2ex_rt  (id2ex_rt),
    .id2ex_imm (id2ex_imm),

    .id2ex_dec_info (id2ex_dec_info),

    .id2ex_rd_idx (id2ex_rd_idx),
    .id2ex_rd_wen (id2ex_rd_wen)

    // TODO: id2ex pc, inst?
);

endmodule
