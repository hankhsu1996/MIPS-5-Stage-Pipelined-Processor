module cache_i (
    input  wire                clk,
    // Processor interface
    input  wire                proc_reset,
    output wire                proc_stall,
    input  wire [`MIPS_AW-3:0] proc_addr,
    input  wire                proc_read,
    output wire [`MIPS_DW-1:0] proc_rdata,
    input  wire                proc_write,
    input  wire [`MIPS_DW-1:0] proc_wdata,
    // Memory interface
    output wire [ `MEM_AW-1:0] mem_addr,
    output wire                mem_read,
    input  wire [ `MEM_DW-1:0] mem_rdata,
    output wire                mem_write,
    output wire [ `MEM_DW-1:0] mem_wdata,
    input  wire                mem_ready
);

endmodule  // cache_i
