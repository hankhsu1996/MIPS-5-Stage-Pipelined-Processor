////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex
//    ║ 1 9 9 6 ║     Purpose:         This is the execution stage of the MIPS 
//    ╚═════════╝                      pipelined processor.
//
//                    Version:         1.0
//                    Filename:        mips_ex.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 13, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_ex (
    input wire clk,
    input wire rst_n,

    // ID to EX interface
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

wire ex2mem_mem_read_nxt;
wire ex2mem_mem_write_nxt;

wire [`MIPS_ADDR_WIDTH-1:0] ex2mem_mem_addr_nxt;
wire [`MIPS_DATA_WIDTH-1:0] ex2mem_mem_wdat_nxt;

wire [`MIPS_RFIDX_WIDTH-1:0] ex2mem_rd_idx_nxt;
wire [ `MIPS_DATA_WIDTH-1:0] ex2mem_rd_wdat_nxt;
wire ex2mem_rd_wen_nxt;


wire ex2mem_mem_read_reg;
wire ex2mem_mem_write_reg;

wire [`MIPS_ADDR_WIDTH-1:0] ex2mem_mem_addr_reg;
wire [`MIPS_DATA_WIDTH-1:0] ex2mem_mem_wdat_reg;

wire [`MIPS_RFIDX_WIDTH-1:0] ex2mem_rd_idx_reg;
wire [ `MIPS_DATA_WIDTH-1:0] ex2mem_rd_wdat_reg;
wire ex2mem_rd_wen_reg;


mips_ex_alu mips_ex_alu_inst (
    // ID to EX stage interface
    .id2ex_rs       (id2ex_rs),
    .id2ex_rt       (id2ex_rt),
    .id2ex_imm      (id2ex_imm),
    .id2ex_pc_incr  (id2ex_pc_incr),

    .id2ex_dec_info (id2ex_dec_info),

    .id2ex_rd_idx   (id2ex_rd_idx),
    .id2ex_rd_wen   (id2ex_rd_wen),

    // EX to MEM interface
    .ex2mem_mem_read  (ex2mem_mem_read_nxt),
    .ex2mem_mem_write (ex2mem_mem_write_nxt),
    .ex2mem_mem_addr  (ex2mem_mem_addr_nxt),
    .ex2mem_mem_wdat  (ex2mem_mem_wdat_nxt),

    .ex2mem_rd_idx    (ex2mem_rd_idx_nxt),
    .ex2mem_rd_wdat   (ex2mem_rd_wdat_nxt),
    .ex2mem_rd_wen    (ex2mem_rd_wen_nxt)
);


////////////////////////////////////////////////////////////////////////////////
// Registered output
////////////////////////////////////////////////////////////////////////////////

// mem_read
dffr dffr_mem_read (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_mem_read_nxt), 
    .q_o   (ex2mem_mem_read_reg)
);

// mem_write
dffr dffr_mem_write (
    .clk   (clk), 
    .rst_n (rst_n),
    .d_i   (ex2mem_mem_write_nxt),
    .q_o   (ex2mem_mem_write_reg)
);

// mem_addr
dffr #(`MIPS_ADDR_WIDTH ) dffr_mem_addr (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_mem_addr_nxt), 
    .q_o   (ex2mem_mem_addr_reg)
);

// mem_wdat
dffr #(`MIPS_DATA_WIDTH ) dffr_mem_wdat (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_mem_wdat_nxt), 
    .q_o   (ex2mem_mem_wdat_reg)
);

// rd_idx
dffr #(`MIPS_RFIDX_WIDTH ) dffr_rd_idx (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_rd_idx_nxt), 
    .q_o   (ex2mem_rd_idx_reg)
);

// rd_wdat
dffr #(`MIPS_DATA_WIDTH ) dffr_rd_wdat (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_rd_wdat_nxt), 
    .q_o   (ex2mem_rd_wdat_reg)
);

// rd_wen
dffr dffr_rd_wen (
    .clk   (clk), 
    .rst_n (rst_n), 
    .d_i   (ex2mem_rd_wen_nxt), 
    .q_o   (ex2mem_rd_wen_reg)
);

assign ex2mem_mem_read  = ex2mem_mem_read_reg;
assign ex2mem_mem_write = ex2mem_mem_write_reg;
assign ex2mem_mem_addr  = ex2mem_mem_addr_reg;
assign ex2mem_mem_wdat  = ex2mem_mem_wdat_reg;
assign ex2mem_rd_idx    = ex2mem_rd_idx_reg;
assign ex2mem_rd_wdat   = ex2mem_rd_wdat_reg;
assign ex2mem_rd_wen    = ex2mem_rd_wen_reg;

endmodule // mips_ex
