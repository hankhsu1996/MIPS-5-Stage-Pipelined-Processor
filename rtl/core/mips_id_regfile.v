////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_id_regfile
//    ║ 1 9 9 6 ║     Purpose:         This is the register file for instruction 
//    ╚═════════╝                      decode stage.
//
//                    Version:         1.0
//                    Filename:        mips_id_regfile.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 13, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_id_regfile (
    input wire clk,

    // Read port
    input  wire [`MIPS_RFIDX_WIDTH-1:0] read_rs_idx,
    input  wire [`MIPS_RFIDX_WIDTH-1:0] read_rt_idx,
    output wire [ `MIPS_DATA_WIDTH-1:0] read_rs_dat,
    output wire [ `MIPS_DATA_WIDTH-1:0] read_rt_dat,

    // Write port
    input wire                         wb_dest_en,
    input wire [`MIPS_RFIDX_WIDTH-1:0] wb_dest_idx,
    input wire [ `MIPS_DATA_WIDTH-1:0] wb_dest_dat
);

wire [`MIPS_DATA_WIDTH-1:0] rf_r [0:`MIPS_RFREG_NUM-1];
wire [`MIPS_RFREG_NUM-1:0] rf_wen;

genvar i;
generate 
    for (i = 0; i<`MIPS_RFREG_NUM; i=i+1) begin
        
        if (i == 0) begin
            assign rf_wen[i] = 1'b0;
            assign rf_r[i] = `MIPS_DATA_WIDTH'b0;
        end 
        else begin
            assign rf_wen[i] = wb_dest_en & wb_dest_idx == i;
            dffc #(
                .DW(`MIPS_DATA_WIDTH)
            ) dffc_rf (
                .clk(clk),
                .ce(rf_wen[i]),
                .d_i(wb_dest_dat),
                .q_o(rf_r[i])
            );
        end
    end
endgenerate

assign read_rs_dat = rf_r[read_rs_idx];
assign read_rt_dat = rf_r[read_rt_idx];

endmodule
