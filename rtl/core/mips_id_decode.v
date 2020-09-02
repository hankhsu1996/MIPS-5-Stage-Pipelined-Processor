////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_id_decode
//    ║ 1 9 9 6 ║     Purpose:         This is the decoder for instruction 
//    ╚═════════╝                      decode stage.
//
//                    Version:         1.0
//                    Filename:        mips_id_decode.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   August 31, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_id_decode (
    // IF to ID information
    input wire [`MIPS_INST_WIDTH-1:0] if2id_inst,
    input wire [`MIPS_ADDR_WIDTH-1:0] if2id_pc_incr,

    input wire if2id_prdt_taken,  // todo

    // Decoded rs, rt info and info-bus
    output wire dec_rs_x0,
    output wire dec_rt_x0,
    output wire dec_rs_en,
    output wire dec_rt_en,
    output wire dec_rd_wen,

    output wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rs_idx,
    output wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rt_idx,
    output wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rd_idx,
    output wire [`MIPS_DECINFO_WIDTH-1:0] dec_info,
    output wire [   `MIPS_ADDR_WIDTH-1:0] dec_imm,

    // Decoded BJP info
    output wire dec_bjp,
    output wire dec_j,
    output wire dec_jr,
    output wire dec_jal,
    output wire dec_jalr,
    output wire dec_bxx,

    output wire [`MIPS_ADDR_WIDTH-1:0] dec_j_imm,
    output wire [`MIPS_ADDR_WIDTH-1:0] dec_b_imm
);

////////////////////////////////////////////////////////////////////////////////
// Decode instruction
////////////////////////////////////////////////////////////////////////////////

// Instruction formats
wire [5:0] opcode = if2id_inst[31:26];
wire [4:0] rs     = if2id_inst[25:21];
wire [4:0] rt     = if2id_inst[20:16];
wire [4:0] rd     = if2id_inst[15:11];
wire [4:0] shamt  = if2id_inst[10: 6];
wire [5:0] funct  = if2id_inst[ 5: 0];

// Opcode

wire opcode_000000 = opcode == 6'b000000;
wire opcode_000010 = opcode == 6'b000010;
wire opcode_000011 = opcode == 6'b000011;

wire opcode_5_3_000 = opcode[5:3] == 3'b000;
wire opcode_5_3_001 = opcode[5:3] == 3'b001;
wire opcode_5_3_010 = opcode[5:3] == 3'b010;
wire opcode_5_3_011 = opcode[5:3] == 3'b011;
wire opcode_5_3_100 = opcode[5:3] == 3'b100;
wire opcode_5_3_101 = opcode[5:3] == 3'b101;
wire opcode_5_3_110 = opcode[5:3] == 3'b110;
wire opcode_5_3_111 = opcode[5:3] == 3'b111;

wire opcode_2_0_001 = opcode[2:0] == 3'b001;
wire opcode_2_0_100 = opcode[2:0] == 3'b100;
wire opcode_2_0_101 = opcode[2:0] == 3'b101;
wire opcode_2_0_110 = opcode[2:0] == 3'b110;
wire opcode_2_0_111 = opcode[2:0] == 3'b111;

// Funct

wire funct_5_3_000 = funct[5:3] == 3'b000;
wire funct_5_3_001 = funct[5:3] == 3'b001;
wire funct_5_3_010 = funct[5:3] == 3'b010;
wire funct_5_3_011 = funct[5:3] == 3'b011;
wire funct_5_3_100 = funct[5:3] == 3'b100;
wire funct_5_3_101 = funct[5:3] == 3'b101;
wire funct_5_3_110 = funct[5:3] == 3'b110;
wire funct_5_3_111 = funct[5:3] == 3'b111;

wire funct_2_0_000 = funct[2:0] == 3'b000;
wire funct_2_0_001 = funct[2:0] == 3'b001;
wire funct_2_0_010 = funct[2:0] == 3'b010;
wire funct_2_0_011 = funct[2:0] == 3'b011;
wire funct_2_0_100 = funct[2:0] == 3'b100;
wire funct_2_0_101 = funct[2:0] == 3'b101;
wire funct_2_0_110 = funct[2:0] == 3'b110;
wire funct_2_0_111 = funct[2:0] == 3'b111;

wire rs_x0 = rs == `MIPS_RFIDX_WIDTH'b0;
wire rt_x0 = rt == `MIPS_RFIDX_WIDTH'b0;
wire rt_x1 = rt == `MIPS_RFIDX_WIDTH'b1;
wire rd_x0 = rd == `MIPS_RFIDX_WIDTH'b0;
assign dec_rs_x0 = rs_x0;
assign dec_rt_x0 = rt_x0;

wire need_rs = ~rs_x0 & 
    ~mips_lui & 
    ~mips_sll & ~mips_srl & ~mips_sra & 
    ~mips_mfhi & ~mips_mflo & 
    ~mips_jmpreg;
wire need_rt = ~rt_x0 & (
    mips_beq | mips_bne | 
    mips_op_imm | 
    mips_load | mips_store | 
    mips_shift | mips_muldiv | mips_op | mips_set);
wire need_rd = ~rd_x0 & 
    mips_shift & 
    mips_mfhi & mips_mflo & 
    mips_op & mips_set;

assign dec_rs_en = need_rs;
assign dec_rt_en = need_rt;
assign dec_rd_wen = need_rd;


assign dec_rs_idx = rs;
assign dec_rt_idx = rt;
assign dec_rd_idx = rd;


////////////////////////////////////////////////////////////////////////////////
// R-type
////////////////////////////////////////////////////////////////////////////////

wire mips_r_type = opcode_000000;
wire mips_shift  = mips_r_type & funct_5_3_000;
wire mips_jmpreg = mips_r_type & funct_5_3_001;
wire mips_move   = mips_r_type & funct_5_3_010;
wire mips_muldiv = mips_r_type & funct_5_3_011;
wire mips_op     = mips_r_type & funct_5_3_100;
wire mips_set    = mips_r_type & funct_5_3_101;

// Shift instruction
wire mips_sll   = mips_shift & funct_2_0_000;
wire mips_srl   = mips_shift & funct_2_0_010;
wire mips_sra   = mips_shift & funct_2_0_011;
wire mips_sllv  = mips_shift & funct_2_0_100;
wire mips_srlv  = mips_shift & funct_2_0_110;
wire mips_srav  = mips_shift & funct_2_0_111;

// Jump register
wire mips_jr    = mips_jmpreg & funct_2_0_000;
wire mips_jalr  = mips_jmpreg & funct_2_0_001;

// Move
wire mips_mfhi  = mips_move & funct_2_0_000;
wire mips_mthi  = mips_move & funct_2_0_001;
wire mips_mflo  = mips_move & funct_2_0_010;
wire mips_mtlo  = mips_move & funct_2_0_011;

// Multiplication and division
wire mips_mult  = mips_muldiv & funct_2_0_000;
wire mips_multu = mips_muldiv & funct_2_0_001;
wire mips_div   = mips_muldiv & funct_2_0_010;
wire mips_divu  = mips_muldiv & funct_2_0_011;

// ALU
wire mips_add   = mips_op & funct_2_0_000;
wire mips_addu  = mips_op & funct_2_0_001;
wire mips_sub   = mips_op & funct_2_0_010;
wire mips_subu  = mips_op & funct_2_0_011;
wire mips_and   = mips_op & funct_2_0_100;
wire mips_or    = mips_op & funct_2_0_101;
wire mips_xor   = mips_op & funct_2_0_110;
wire mips_nor   = mips_op & funct_2_0_111;

// Set 
wire mips_slt   = mips_set & funct_2_0_010;
wire mips_sltu  = mips_set & funct_2_0_011;


////////////////////////////////////////////////////////////////////////////////
// J-type
////////////////////////////////////////////////////////////////////////////////

wire mips_j   = opcode_000010;
wire mips_jal = opcode_000011;


////////////////////////////////////////////////////////////////////////////////
// I-type
////////////////////////////////////////////////////////////////////////////////

wire mips_branch = opcode_5_3_000;
wire mips_op_imm = opcode_5_3_001;
wire mips_load   = opcode_5_3_100;
wire mips_store  = opcode_5_3_101;

// Branch instructions
wire mips_bgez = mips_branch & opcode_2_0_001 & rt_x1;
wire mips_bltz = mips_branch & opcode_2_0_001 & rt_x0;
wire mips_beq  = mips_branch & opcode_2_0_100;
wire mips_bne  = mips_branch & opcode_2_0_101;
wire mips_blez = mips_branch & opcode_2_0_110 & rt_x0;
wire mips_bgtz = mips_branch & opcode_2_0_111 & rt_x0;

// ALU immediate
wire mips_addi  = mips_op_imm & funct_2_0_000;
wire mips_addiu = mips_op_imm & funct_2_0_001;
wire mips_slti  = mips_op_imm & funct_2_0_010;
wire mips_sltiu = mips_op_imm & funct_2_0_011;
wire mips_andi  = mips_op_imm & funct_2_0_100;
wire mips_ori   = mips_op_imm & funct_2_0_101;
wire mips_xori  = mips_op_imm & funct_2_0_110;
wire mips_lui   = mips_op_imm & funct_2_0_111;

// Load
wire mips_lb    = mips_load & funct_2_0_000;
wire mips_lw    = mips_load & funct_2_0_011;
wire mips_lbu   = mips_load & funct_2_0_100;

// Store 
wire mips_sb = mips_store & funct_2_0_000;
wire mips_sw = mips_store & funct_2_0_011;

// Signals handled by BJP
assign dec_j    = mips_j;
assign dec_jr   = mips_jr;
assign dec_jal  = mips_jal;
assign dec_jalr = mips_jalr;
assign dec_bxx  = mips_branch;
assign dec_bjp = dec_j | dec_jr | dec_jal | dec_jalr | dec_bxx;


wire alu_op = mips_op | mips_op_imm | mips_lui;
wire bjp_op = mips_branch | mips_j | mips_jr | mips_jalr | mips_jalr;


// ALU info
wire [`MIPS_DECINFO_ALU_WIDTH-1:0] alu_info_bus;
assign alu_info_bus[`MIPS_DECINFO_GRP     ] = `MIPS_DECINFO_GRP_ALU;
assign alu_info_bus[`MIPS_DECINFO_ALU_ADD ] = mips_add  | mips_addi;
assign alu_info_bus[`MIPS_DECINFO_ALU_ADDU] = mips_addu | mips_addiu;
assign alu_info_bus[`MIPS_DECINFO_ALU_SUB ] = mips_sub;
assign alu_info_bus[`MIPS_DECINFO_ALU_SUBU] = mips_subu;
assign alu_info_bus[`MIPS_DECINFO_ALU_AND ] = mips_and  | mips_andi;
assign alu_info_bus[`MIPS_DECINFO_ALU_OR  ] = mips_or   | mips_ori;
assign alu_info_bus[`MIPS_DECINFO_ALU_XOR ] = mips_xor  | mips_xori;
assign alu_info_bus[`MIPS_DECINFO_ALU_NOR ] = mips_nor;
assign alu_info_bus[`MIPS_DECINFO_ALU_SLT ] = mips_slt  | mips_slti;
assign alu_info_bus[`MIPS_DECINFO_ALU_SLTU] = mips_sltu | mips_sltiu;
assign alu_info_bus[`MIPS_DECINFO_ALU_LUI ] = mips_lui;

// BJP info
wire [`MIPS_DECINFO_BJP_WIDTH-1:0] bjp_info_bus;
assign bjp_info_bus[`MIPS_DECINFO_GRP     ] = `MIPS_DECINFO_GRP_BJP;
assign bjp_info_bus[`MIPS_DECINFO_BJP_JUMP] = mips_j | mips_jr | mips_jal | mips_jalr;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BGEZ] = mips_bgez;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BLTZ] = mips_bltz;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BEQ ] = mips_beq;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BNE ] = mips_bne;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BLEZ] = mips_blez;
assign bjp_info_bus[`MIPS_DECINFO_BJP_BGTZ] = mips_bgtz;

assign dec_info = 
    {`MIPS_DECINFO_WIDTH{alu_op}} & {{`MIPS_DECINFO_WIDTH-`MIPS_DECINFO_ALU_WIDTH{1'b0}}, alu_info_bus} |
    {`MIPS_DECINFO_WIDTH{bjp_op}} & {{`MIPS_DECINFO_WIDTH-`MIPS_DECINFO_BJP_WIDTH{1'b0}}, bjp_info_bus};

// load and store to AGU bus ?

// Immediate
wire [31:0] mips_i_imm  = {{16{if2id_inst[15]}}, if2id_inst[15:0]};
wire [31:0] mips_b_imm  = {{14{if2id_inst[15]}}, if2id_inst[15:0], 2'b0};
wire [31:0] mips_u_imm  = {16'b0, if2id_inst[15:0]};
wire [31:0] mips_up_imm = {if2id_inst[15:0], 16'b0};
wire [31:0] mips_j_imm  = {if2id_pc_incr[31:28], if2id_inst[25:0], 2'b0};

wire mips_imm_sel_i  = mips_addi | mips_slti | mips_load | mips_store;
wire mips_imm_sel_b  = mips_branch;
wire mips_imm_sel_u  = mips_addiu | mips_sltiu | mips_andi | mips_ori | mips_xori;
wire mips_imm_sel_up = mips_lui;
wire mips_imm_sel_j  = mips_j | mips_jal;

wire [31:0] mips_imm = 
    {32{mips_imm_sel_i}} & mips_i_imm | 
    {32{mips_imm_sel_b}} & mips_b_imm | 
    {32{mips_imm_sel_u}} & mips_u_imm | 
    {32{mips_imm_sel_up}} & mips_up_imm | 
    {32{mips_imm_sel_j}} & mips_j_imm;

assign dec_imm = mips_imm;

assign dec_j_imm = mips_j_imm;
assign dec_b_imm = mips_b_imm;

endmodule  // mips_id_decode
