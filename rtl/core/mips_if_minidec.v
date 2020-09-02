////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_if_minidec
//    ║ 1 9 9 6 ║     Purpose:         This is a mini instruction decoder for  
//    ╚═════════╝                      instruction fetch stage.
//
//                    Version:         1.0
//                    Filename:        mips_if_minidec.v
//                    Date Created:    August 29, 2020
//                    Last Modified:   September 2, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_if_minidec (
    // Input instruction
    input wire [`MIPS_INST_WIDTH-1:0] inst,
    input wire [`MIPS_ADDR_WIDTH-1:0] pc_incr, 

    // Decoded rs and rt info
    output wire dec_rs_en,
    output wire dec_rt_en,

    output wire [`MIPS_RFIDX_WIDTH-1:0] dec_rs_idx,
    output wire [`MIPS_RFIDX_WIDTH-1:0] dec_rt_idx,

    // Decoded BJP info
    output wire dec_j,
    output wire dec_jr,
    output wire dec_jal,
    output wire dec_jalr,
    output wire dec_bxx,

    output wire [`MIPS_ADDR_WIDTH-1:0] dec_j_imm,
    output wire [`MIPS_ADDR_WIDTH-1:0] dec_b_imm
);

mips_id_decode mips_id_decode_inst (
    // IF to ID information
    .if2id_inst    (inst),
    .if2id_pc_incr (pc_incr),

    .if2id_prdt_taken (1'b0),

    // Decoded rs, rt info and info-bus
    .dec_rs_x0  (),
    .dec_rt_x0  (),
    .dec_rs_en  (dec_rs_en),
    .dec_rt_en  (dec_rt_en),
    .dec_rd_wen (),

    .dec_rs_idx (dec_rs_idx),
    .dec_rt_idx (dec_rt_idx),
    .dec_rd_idx (),
    .dec_info   (),
    .dec_imm    (),

    // Decoded BJP info
    .dec_bjp  (dec_bjp),
    .dec_j    (dec_j),
    .dec_jr   (dec_jr),
    .dec_jal  (dec_jal),
    .dec_jalr (dec_jalr),
    .dec_bxx  (dec_bxx),

    .dec_j_imm (dec_j_imm),
    .dec_b_imm (dec_b_imm)
);

endmodule
