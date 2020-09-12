////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex_alu_agu
//    ║ 1 9 9 6 ║     Purpose:         This is the address generation unit for 
//    ╚═════════╝                      EX stage.
//
//                    Version:         1.0
//                    Filename:        mips_ex_alu_agu.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_ex_alu_agu (
    input wire [`MIPS_DATA_WIDTH-1:0] agu_rs,
    input wire [`MIPS_DATA_WIDTH-1:0] agu_rt,
    input wire [`MIPS_DATA_WIDTH-1:0] agu_imm,

    input wire [`MIPS_DECINFO_WIDTH-1:0] agu_info,

    // Shared ALU datapath interface
    output wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op1,
    output wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op2
);

wire       agu_load  = agu_info [`MIPS_DECINFO_AGU_LOAD];
wire       agu_store = agu_info [`MIPS_DECINFO_AGU_STORE];
wire [1:0] agu_size  = agu_info [`MIPS_DECINFO_AGU_SIZE];
wire       agu_usign = agu_info [`MIPS_DECINFO_AGU_USIGN];


assign agu_req_alu_op1 = agu_rs;
assign agu_req_alu_op2 = agu_imm;

endmodule