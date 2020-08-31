////////////////////////////////////////////////////////////////////////////////
//
//     Auther:        Shou-Li Hsu
//     Entity Name:   dff_ce_rstn_0
//                    dff_ce_rstn_1
//                    dff_ce
//                    dff_rstn_0
//                    dff_rstn_1
//                    latch
//     Purpose:       These serve as registers with different functionaility.
//     
//     Version:       1.0
//     Filename:      dffs.v
//     Date Created:  29 Aug, 2020
//     Last Modified: 29 Aug, 2020
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// D flip-flop with clock enable and asynchronous reset
// Default reset value is 0
////////////////////////////////////////////////////////////////////////////////

module dff_ce_rstn_0 # (
    parameter DW = 1
) (
    input  wire          clk,
    input  wire          ce,
    input  wire          rst_n,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        q_o <= {DW{1'b0}};
    else if (ce)
        q_o <= #TCQ d_i;
end

`ifndef DISABLE_SV_ASSERTION
xchecker #(
    .DW(1)
) xchecker_inst (
    .clk(clk),
    .dat_i(ce)
);
`endif

endmodule // dff_ce_rstn_0


////////////////////////////////////////////////////////////////////////////////
// D flip-flop with clock enable and asynchronous reset
// Default reset value is 1
////////////////////////////////////////////////////////////////////////////////

module dff_ce_rstn_1 # (
    parameter DW = 1
) (
    input  wire          clk,
    input  wire          ce,
    input  wire          rst_n,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        q_o <= {DW{1'b1}};
    else if (ce)
        q_o <= #TCQ d_i;
end

`ifndef DISABLE_SV_ASSERTION
xchecker #(
    .DW(1)
) xchecker_inst (
    .clk(clk),
    .dat_i(ce)
);
`endif

endmodule // dff_ce_rstn_1


////////////////////////////////////////////////////////////////////////////////
// D flip-flop with clock enable without reset
////////////////////////////////////////////////////////////////////////////////

module dff_ce # (
    parameter DW = 1
) (
    input  wire          clk,
    input  wire          ce,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(posedge clk) begin
    if (ce)
        q_o <= #TCQ d_i;
end

`ifndef DISABLE_SV_ASSERTION
xchecker #(
    .DW(1)
) xchecker_inst (
    .clk(clk),
    .dat_i(ce)
);
`endif

endmodule // dff_ce


////////////////////////////////////////////////////////////////////////////////
// D flip-flop with asynchronous reset without clock enable
// Default reset value is 0
////////////////////////////////////////////////////////////////////////////////

module dff_rstn_0 # (
    parameter DW = 1
) (
    input  wire          clk,
    input  wire          rst_n,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(posedge clk) begin
    if (~rst_n)
        q_o <= {DW{1'b0}};
    else
        q_o <= #TCQ d_i;
end

endmodule // dff_rstn_0


////////////////////////////////////////////////////////////////////////////////
// D flip-flop with asynchronous reset without clock enable
// Default reset value is 1
////////////////////////////////////////////////////////////////////////////////

module dff_rstn_1 # (
    parameter DW = 1
) (
    input  wire          clk,
    input  wire          rst_n,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(posedge clk) begin
    if (~rst_n)
        q_o <= {DW{1'b1}};
    else
        q_o <= #TCQ d_i;
end

endmodule // dff_rstn_1


////////////////////////////////////////////////////////////////////////////////
// Verilog module for general latch
////////////////////////////////////////////////////////////////////////////////

module latch # (
    parameter DW = 1
) (
    input  wire          en,
    input  wire [DW-1:0] d_i,
    output reg  [DW-1:0] q_o
);

localparam TCQ = 1;

always @(*) begin
    if (en)
        q_o <= d_i;
end

`ifndef DISABLE_SV_ASSERTION
xchecker #(
    .DW(1)
) xchecker_inst (
    .clk(clk),
    .dat_i(ce)
);
`endif

endmodule // latch
