////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_if_bpu
//    ║ 1 9 9 6 ║     Purpose:         This is the branch prediction unit for 
//    ╚═════════╝                      instruction fetch stage.
//
//                    Version:         1.0
//                    Filename:        mips_if_bpu.v
//                    Date Created:    August 29, 2020
//                    Last Modified:   September 9, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_if_bpu (
    // Next program counter address
    input wire [`MIPS_ADDR_WIDTH-1:0] pc_incr,
    input wire [`MIPS_ADDR_WIDTH-1:0] minidec_j_imm,
    input wire [`MIPS_ADDR_WIDTH-1:0] minidec_b_imm,

    // Mini-decoder info 
    input wire minidec_j,
    input wire minidec_jr,
    input wire minidec_jal,
    input wire minidec_jalr,
    input wire minidec_bxx,

    // Predicted result
    output wire prdt_taken,

    output wire [`MIPS_ADDR_WIDTH-1:0] prdt_pc
);


wire minidec_jmpimm = minidec_j | minidec_jal;
wire minidec_jmpreg = minidec_jr | minidec_jalr;

assign prdt_taken = 
    minidec_jmpimm | minidec_jmpreg |  
    minidec_bxx & minidec_b_imm[`MIPS_ADDR_WIDTH-1];

assign prdt_pc = 
    minidec_jmpimm ? minidec_j_imm : 
    minidec_bxx ? minidec_b_imm : 
    `MIPS_ADDR_WIDTH'b0;

endmodule
