////////////////////////////////////////////////////////////////////////////////
//
//     Auther:        Shou-Li Hsu
//     Entity Name:   xchecker
//     Purpose:       These serve as registers with different functionaility.
//     
//     Version:       1.0
//     Filename:      xcheck.v
//     Date Created:  29 Aug, 2020
//     Last Modified: 29 Aug, 2020
//
////////////////////////////////////////////////////////////////////////////////

`ifndef DISABLE_SV_ASSERTION
module xchecker # (
    parameter DATA_WIDTH = 1
) (
    input wire clk,
    // Input data to be checked
    input wire [DATA_WIDTH-1:0] dat_i
);

CHECK_X_VALUE:
    assert property (@(posedge clk) (^dat_i !== 1'bx));
    else $error("X checker failed!\n");

endmodule // xchecker
`endif
