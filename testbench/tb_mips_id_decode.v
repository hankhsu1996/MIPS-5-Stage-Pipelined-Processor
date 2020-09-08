////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     tb_mips_id_decode
//    ║ 1 9 9 6 ║     Purpose:         This is the testbench for the decoder in  
//    ╚═════════╝                      instruction decode stage.
//
//                    Version:         1.0
//                    Filename:        tb_mips_id_decode.v
//                    Date Created:    September 9, 2020
//                    Last Modified:   September 9, 2020
//
////////////////////////////////////////////////////////////////////////////////


`default_nettype none


module tb_mips_id_decode;

reg [`MIPS_INST_WIDTH-1:0] inst;
reg [`MIPS_ADDR_WIDTH-1:0] pc_incr;

reg prdt_taken;

wire dec_rs_x0;
wire dec_rt_x0;
wire dec_rs_en;
wire dec_rt_en;
wire dec_rd_wen;

wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rs_idx;
wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rt_idx;
wire [  `MIPS_RFIDX_WIDTH-1:0] dec_rd_idx;
wire [`MIPS_DECINFO_WIDTH-1:0] dec_info;
wire [   `MIPS_ADDR_WIDTH-1:0] dec_imm;

wire dec_bjp;
wire dec_j;
wire dec_jr;
wire dec_jal;
wire dec_jalr;
wire dec_bxx;

wire [`MIPS_ADDR_WIDTH-1:0] dec_j_imm;
wire [`MIPS_ADDR_WIDTH-1:0] dec_b_imm;


mips_id_decode mips_id_decode_inst (
    // IF to ID information
    .if2id_inst    (inst),
    .if2id_pc_incr (pc_incr),

    .if2id_prdt_taken (prdt_taken),

    // Decoded rs, rt info and info-bus
    .dec_rs_x0  (dec_rs_x0),
    .dec_rt_x0  (dec_rt_x0),
    .dec_rs_en  (dec_rs_en),
    .dec_rt_en  (dec_rt_en),
    .dec_rd_wen (dec_rd_wen),

    .dec_rs_idx (dec_rs_idx),
    .dec_rt_idx (dec_rt_idx),
    .dec_rd_idx (dec_rd_idx),
    .dec_info   (dec_info),
    .dec_imm    (dec_imm),

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


localparam INST_NUM = 45;
reg [`MIPS_INST_WIDTH-1:0] rom [0:INST_NUM-1];

initial begin
    // I-Type
    rom[ 0] = 32'b0000_0100_1010_0001_0000_0000_0011_0001;    // bgez  $5, 0x31
    rom[ 1] = 32'b0000_0100_1110_0000_0000_0000_0110_0111;    // bltz  $7, 0x67
    rom[ 2] = 32'b0001_0000_0110_0010_0000_0000_0011_0011;    // beq   $3, $2, 0x33
    rom[ 3] = 32'b0001_0110_1001_0010_0000_0000_0001_0001;    // bne   $20, $18, 0x11
    rom[ 4] = 32'b0001_1000_1000_0000_0000_1111_0110_0111;    // blez  $4, 0xf67
    rom[ 5] = 32'b0001_1110_1100_0000_0110_1000_1001_0111;    // bgtz  $22, 0x6897
    rom[ 6] = 32'b0010_0000_1100_0101_1000_0111_0110_0101;    // addi  $6, $5, 0x8765
    rom[ 7] = 32'b0010_0100_1010_0100_1000_0111_0110_0101;    // addiu $5, $4, 0x8765
    rom[ 8] = 32'b0010_1001_1000_1101_1001_0000_0000_0100;    // slti  $12, $13, 0x9004
    rom[ 9] = 32'b0010_1111_1000_0100_1001_0100_0011_0101;    // sltiu $28, $4, 0x9435
    rom[10] = 32'b0011_0000_0100_0110_0101_0111_1000_0110;    // andi  $2, $6, 0x5786
    rom[11] = 32'b0011_0100_1110_1110_0110_0011_1001_1011;    // ori   $7, &14, 0x639b
    rom[12] = 32'b0011_1001_0000_1010_1010_1011_1100_1101;    // xori  $8, $10, 0xabcd
    rom[13] = 32'b0011_1100_0000_0100_0001_0011_0101_0111;    // lui   $4, 0x1357
    rom[14] = 32'b1000_0000_0010_0110_0000_0000_0000_0100;    // lb    $1, 4($6)
    rom[15] = 32'b1000_1100_1010_0101_0000_0000_0000_1100;    // lw    $5, 12($5)
    rom[16] = 32'b1010_0000_0010_0010_0000_0000_0010_0000;    // sb    $1, 32($2)
    rom[17] = 32'b1010_1101_0000_0000_0000_0000_0111_1111;    // sw    $8, 127($0)
   
    // R-Type   
    rom[18] = 32'b0000_0000_0000_0011_0010_0100_0100_0000;    // sll   $3, $4, 17
    rom[19] = 32'b0000_0000_0000_0110_1000_0001_1100_0010;    // srl   $6, $16, 0x7
    rom[20] = 32'b0000_0000_0000_1000_0110_1000_0100_0011;    // sra   $8, $13, 1
    rom[21] = 32'b0000_0000_1100_1001_0101_0000_0000_0100;    // sllv  $6, $9, $10
    rom[22] = 32'b0000_0000_0010_0100_0011_1000_0000_0110;    // srlv  $1, $4, $7
    rom[23] = 32'b0000_0000_0010_0010_0001_1000_0000_0111;    // srav  $1, $2, $3
    rom[24] = 32'b0000_0011_1100_0000_0000_0000_0000_1000;    // jr    $30
    rom[25] = 32'b0000_0000_0010_0000_1010_1000_0000_1001;    // jalr  $1, $21
    rom[26] = 32'b0000_0000_0000_0000_0010_1000_0001_0000;    // mfhi  $5
    rom[27] = 32'b0000_0001_0100_0000_0000_0000_0001_0001;    // mthi  $10
    rom[28] = 32'b0000_0000_0000_0000_1010_0000_0001_0010;    // mflo  $20
    rom[29] = 32'b0000_0011_0010_0000_0000_0000_0001_0011;    // mtlo  $25
    rom[30] = 32'b0000_0000_1000_0101_0000_0000_0001_1000;    // mult  $4, $5
    rom[31] = 32'b0000_0000_1100_0111_0000_0000_0001_1001;    // multu $6, $7
    rom[32] = 32'b0000_0001_0100_1011_0000_0000_0001_1010;    // div   $10, $11
    rom[33] = 32'b0000_0001_1011_0001_0000_0000_0001_1011;    // divu  $13, $17
    rom[34] = 32'b0000_0010_0101_0011_1010_0000_0010_0000;    // add   $18, $19, $20
    rom[35] = 32'b0000_0010_1011_0110_1011_1000_0010_0001;    // addu  $21, $22, $23
    rom[36] = 32'b0000_0011_0001_1001_1101_0000_0010_0010;    // sub   $24, $25, $26
    rom[37] = 32'b0000_0011_0111_1100_1110_1000_0010_0011;    // subu  $27, $28, $29
    rom[38] = 32'b0000_0000_0100_0000_0100_0000_0010_0100;    // and   $2, $0, $8
    rom[39] = 32'b0000_0001_0010_1100_0111_0000_0010_0101;    // or    $9, $12, $14
    rom[40] = 32'b0000_0001_1111_0000_0010_1000_0010_0110;    // xor   $15, $16, $5
    rom[41] = 32'b0000_0000_1100_0111_0100_0000_0010_0111;    // nor   $6, $7, $8   
    rom[42] = 32'b0000_0001_0010_1010_0000_1000_0010_1010;    // slt   $9, $10, $1
    rom[43] = 32'b0000_0000_0100_0011_0010_0000_0010_1011;    // sltu  $2, $3, $4

    // J-Type   
    rom[44] = 32'b0000_1010_0101_1011_0111_1010_1001_1100;    // j     0x25b7a9c
    rom[45] = 32'b0000_1111_0011_0011_0001_0001_1011_1010;    // jal   0x33311ba

    // Todo: bgezal bltzal syscall lbu
end

integer i;
initial begin
    prdt_taken = 1'b0;
    pc_incr = 32'b0011_0100_0000_0110_0000_0111_0111_0000;
    for (i=0; i<INST_NUM; i=i+1) begin
        #10
        inst = rom[i];
    end
    #10
    $finish;
end

endmodule
`default_nettype wire
