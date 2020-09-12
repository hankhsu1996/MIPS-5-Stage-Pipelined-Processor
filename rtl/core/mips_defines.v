////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     N/A
//    ║ 1 9 9 6 ║     Purpose:         This defines static values for the MIPS
//    ╚═════════╝                      processor.
//
//                    Version:         1.0
//                    Filename:        mips_defines.v
//                    Date Created:    August 29, 2020
//                    Last Modified:   August 30, 2020
//
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// Data width and address width
////////////////////////////////////////////////////////////////////////////////

// Address and data width
`define MIPS_INST_WIDTH        32
`define MIPS_ADDR_WIDTH        32
`define MIPS_DATA_WIDTH        32
`define MEM_ADDR_WIDTH         28
`define MEM_DATA_WIDTH         128

// Register file
`define MIPS_RFIDX_WIDTH       5
`define MIPS_RFREG_NUM         32

// ALU adder
`define MIPS_ALU_ADDER_WIDTH   `MIPS_DATA_WIDTH+1
`define MIPS_ALU_ADDER_SIGNEXT `MIPS_ALU_ADDER_WIDTH-`MIPS_DATA_WIDTH

////////////////////////////////////////////////////////////////////////////////
// Decode info groups
////////////////////////////////////////////////////////////////////////////////

`define MIPS_DECINFO_GRP_WIDTH       2
`define MIPS_DECINFO_GRP_ALU         `MIPS_DECINFO_GRP_WIDTH'd0
`define MIPS_DECINFO_GRP_AGU         `MIPS_DECINFO_GRP_WIDTH'd1
`define MIPS_DECINFO_GRP_BJP         `MIPS_DECINFO_GRP_WIDTH'd2

`define MIPS_DECINFO_GRP_LSB         0
`define MIPS_DECINFO_GRP_MSB         `MIPS_DECINFO_GRP_LSB+`MIPS_DECINFO_GRP_WIDTH-1
`define MIPS_DECINFO_GRP             `MIPS_DECINFO_GRP_MSB:`MIPS_DECINFO_GRP_LSB

`define MIPS_DECINFO_SUBDEC_LSB      `MIPS_DECINFO_GRP_MSB+1


////////////////////////////////////////////////////////////////////////////////
// Decode info ALU group
////////////////////////////////////////////////////////////////////////////////

`define MIPS_DECINFO_ALU_ADD_LSB     `MIPS_DECINFO_SUBDEC_LSB
`define MIPS_DECINFO_ALU_ADD_MSB     `MIPS_DECINFO_ALU_ADD_LSB+1-1
`define MIPS_DECINFO_ALU_ADD         `MIPS_DECINFO_ALU_ADD_MSB:`MIPS_DECINFO_ALU_ADD_LSB

`define MIPS_DECINFO_ALU_ADDU_LSB    `MIPS_DECINFO_ALU_ADD_MSB+1
`define MIPS_DECINFO_ALU_ADDU_MSB    `MIPS_DECINFO_ALU_ADDU_LSB+1-1
`define MIPS_DECINFO_ALU_ADDU        `MIPS_DECINFO_ALU_ADDU_MSB:`MIPS_DECINFO_ALU_ADDU_LSB

`define MIPS_DECINFO_ALU_SUB_LSB     `MIPS_DECINFO_ALU_ADDU_MSB+1
`define MIPS_DECINFO_ALU_SUB_MSB     `MIPS_DECINFO_ALU_SUB_LSB+1-1
`define MIPS_DECINFO_ALU_SUB         `MIPS_DECINFO_ALU_SUB_MSB:`MIPS_DECINFO_ALU_SUB_LSB

`define MIPS_DECINFO_ALU_SUBU_LSB    `MIPS_DECINFO_ALU_SUB_MSB+1
`define MIPS_DECINFO_ALU_SUBU_MSB    `MIPS_DECINFO_ALU_SUBU_LSB+1-1
`define MIPS_DECINFO_ALU_SUBU        `MIPS_DECINFO_ALU_SUBU_MSB:`MIPS_DECINFO_ALU_SUBU_LSB

`define MIPS_DECINFO_ALU_AND_LSB     `MIPS_DECINFO_ALU_SUBU_MSB+1
`define MIPS_DECINFO_ALU_AND_MSB     `MIPS_DECINFO_ALU_AND_LSB+1-1
`define MIPS_DECINFO_ALU_AND         `MIPS_DECINFO_ALU_AND_MSB:`MIPS_DECINFO_ALU_AND_LSB

`define MIPS_DECINFO_ALU_OR_LSB      `MIPS_DECINFO_ALU_AND_MSB+1
`define MIPS_DECINFO_ALU_OR_MSB      `MIPS_DECINFO_ALU_OR_LSB+1-1
`define MIPS_DECINFO_ALU_OR          `MIPS_DECINFO_ALU_OR_MSB:`MIPS_DECINFO_ALU_OR_LSB

`define MIPS_DECINFO_ALU_XOR_LSB     `MIPS_DECINFO_ALU_OR_MSB+1
`define MIPS_DECINFO_ALU_XOR_MSB     `MIPS_DECINFO_ALU_XOR_LSB+1-1
`define MIPS_DECINFO_ALU_XOR         `MIPS_DECINFO_ALU_XOR_MSB:`MIPS_DECINFO_ALU_XOR_LSB

`define MIPS_DECINFO_ALU_NOR_LSB     `MIPS_DECINFO_ALU_XOR_MSB+1
`define MIPS_DECINFO_ALU_NOR_MSB     `MIPS_DECINFO_ALU_NOR_LSB+1-1
`define MIPS_DECINFO_ALU_NOR         `MIPS_DECINFO_ALU_NOR_MSB:`MIPS_DECINFO_ALU_NOR_LSB

`define MIPS_DECINFO_ALU_SLL_LSB     `MIPS_DECINFO_ALU_NOR_MSB+1
`define MIPS_DECINFO_ALU_SLL_MSB     `MIPS_DECINFO_ALU_SLL_LSB+1-1
`define MIPS_DECINFO_ALU_SLL         `MIPS_DECINFO_ALU_SLL_MSB:`MIPS_DECINFO_ALU_SLL_LSB

`define MIPS_DECINFO_ALU_SRL_LSB     `MIPS_DECINFO_ALU_SLL_MSB+1
`define MIPS_DECINFO_ALU_SRL_MSB     `MIPS_DECINFO_ALU_SRL_LSB+1-1
`define MIPS_DECINFO_ALU_SRL         `MIPS_DECINFO_ALU_SRL_MSB:`MIPS_DECINFO_ALU_SRL_LSB

`define MIPS_DECINFO_ALU_SRA_LSB     `MIPS_DECINFO_ALU_SRL_MSB+1
`define MIPS_DECINFO_ALU_SRA_MSB     `MIPS_DECINFO_ALU_SRA_LSB+1-1
`define MIPS_DECINFO_ALU_SRA         `MIPS_DECINFO_ALU_SRA_MSB:`MIPS_DECINFO_ALU_SRA_LSB

`define MIPS_DECINFO_ALU_SLT_LSB     `MIPS_DECINFO_ALU_SRA_MSB+1
`define MIPS_DECINFO_ALU_SLT_MSB     `MIPS_DECINFO_ALU_SLT_LSB+1-1
`define MIPS_DECINFO_ALU_SLT         `MIPS_DECINFO_ALU_SLT_MSB:`MIPS_DECINFO_ALU_SLT_LSB

`define MIPS_DECINFO_ALU_SLTU_LSB    `MIPS_DECINFO_ALU_SLT_MSB+1
`define MIPS_DECINFO_ALU_SLTU_MSB    `MIPS_DECINFO_ALU_SLTU_LSB+1-1
`define MIPS_DECINFO_ALU_SLTU        `MIPS_DECINFO_ALU_SLTU_MSB:`MIPS_DECINFO_ALU_SLTU_LSB

`define MIPS_DECINFO_ALU_LUI_LSB     `MIPS_DECINFO_ALU_SLTU_MSB+1
`define MIPS_DECINFO_ALU_LUI_MSB     `MIPS_DECINFO_ALU_LUI_LSB+1-1
`define MIPS_DECINFO_ALU_LUI         `MIPS_DECINFO_ALU_LUI_MSB:`MIPS_DECINFO_ALU_LUI_LSB

`define MIPS_DECINFO_ALU_OP2IMM_LSB  `MIPS_DECINFO_ALU_LUI_MSB+1
`define MIPS_DECINFO_ALU_OP2IMM_MSB  `MIPS_DECINFO_ALU_OP2IMM_LSB+1-1
`define MIPS_DECINFO_ALU_OP2IMM      `MIPS_DECINFO_ALU_OP2IMM_MSB:`MIPS_DECINFO_ALU_OP2IMM_LSB

`define MIPS_DECINFO_ALU_OP1PC_LSB   `MIPS_DECINFO_ALU_OP2IMM_MSB+1
`define MIPS_DECINFO_ALU_OP1PC_MSB   `MIPS_DECINFO_ALU_OP1PC_LSB+1-1
`define MIPS_DECINFO_ALU_OP1PC       `MIPS_DECINFO_ALU_OP1PC_MSB:`MIPS_DECINFO_ALU_OP1PC_LSB

`define MIPS_DECINFO_ALU_WIDTH       `MIPS_DECINFO_ALU_OP1PC_MSB+1


////////////////////////////////////////////////////////////////////////////////
// Decode info AGU group
////////////////////////////////////////////////////////////////////////////////

`define MIPS_DECINFO_AGU_LOAD_LSB    `MIPS_DECINFO_SUBDEC_LSB
`define MIPS_DECINFO_AGU_LOAD_MSB    `MIPS_DECINFO_AGU_LOAD_LSB+1-1
`define MIPS_DECINFO_AGU_LOAD        `MIPS_DECINFO_AGU_LOAD_MSB:`MIPS_DECINFO_AGU_LOAD_LSB

`define MIPS_DECINFO_AGU_STORE_LSB   `MIPS_DECINFO_AGU_LOAD_MSB+1
`define MIPS_DECINFO_AGU_STORE_MSB   `MIPS_DECINFO_AGU_STORE_LSB+1-1
`define MIPS_DECINFO_AGU_STORE       `MIPS_DECINFO_AGU_STORE_MSB:`MIPS_DECINFO_AGU_STORE_LSB

`define MIPS_DECINFO_AGU_SIZE_LSB    `MIPS_DECINFO_AGU_STORE_MSB+1
`define MIPS_DECINFO_AGU_SIZE_MSB    `MIPS_DECINFO_AGU_SIZE_LSB+2-1
`define MIPS_DECINFO_AGU_SIZE        `MIPS_DECINFO_AGU_SIZE_MSB:`MIPS_DECINFO_AGU_SIZE_LSB

`define MIPS_DECINFO_AGU_USIGN_LSB   `MIPS_DECINFO_AGU_SIZE_MSB+1
`define MIPS_DECINFO_AGU_USIGN_MSB   `MIPS_DECINFO_AGU_USIGN_LSB+1-1
`define MIPS_DECINFO_AGU_USIGN       `MIPS_DECINFO_AGU_USIGN_MSB:`MIPS_DECINFO_AGU_USIGN_LSB

`define MIPS_DECINFO_AGU_WIDTH       `MIPS_DECINFO_AGU_USIGN_MSB+1


////////////////////////////////////////////////////////////////////////////////
// Decode info BJP group
////////////////////////////////////////////////////////////////////////////////

`define MIPS_DECINFO_BJP_JUMP_LSB    `MIPS_DECINFO_SUBDEC_LSB
`define MIPS_DECINFO_BJP_JUMP_MSB    `MIPS_DECINFO_BJP_JUMP_LSB+1-1
`define MIPS_DECINFO_BJP_JUMP        `MIPS_DECINFO_BJP_JUMP_MSB:`MIPS_DECINFO_BJP_JUMP_LSB

`define MIPS_DECINFO_BJP_BGEZ_LSB    `MIPS_DECINFO_BJP_JUMP_MSB+1
`define MIPS_DECINFO_BJP_BGEZ_MSB    `MIPS_DECINFO_BJP_BGEZ_LSB+1-1
`define MIPS_DECINFO_BJP_BGEZ        `MIPS_DECINFO_BJP_BGEZ_MSB:`MIPS_DECINFO_BJP_BGEZ_LSB

`define MIPS_DECINFO_BJP_BLTZ_LSB    `MIPS_DECINFO_BJP_BGEZ_MSB+1
`define MIPS_DECINFO_BJP_BLTZ_MSB    `MIPS_DECINFO_BJP_BLTZ_LSB+1-1
`define MIPS_DECINFO_BJP_BLTZ        `MIPS_DECINFO_BJP_BLTZ_MSB:`MIPS_DECINFO_BJP_BLTZ_LSB

`define MIPS_DECINFO_BJP_BEQ_LSB     `MIPS_DECINFO_BJP_BLTZ_MSB+1
`define MIPS_DECINFO_BJP_BEQ_MSB     `MIPS_DECINFO_BJP_BEQ_LSB+1-1
`define MIPS_DECINFO_BJP_BEQ         `MIPS_DECINFO_BJP_BEQ_MSB:`MIPS_DECINFO_BJP_BEQ_LSB

`define MIPS_DECINFO_BJP_BNE_LSB     `MIPS_DECINFO_BJP_BEQ_MSB+1
`define MIPS_DECINFO_BJP_BNE_MSB     `MIPS_DECINFO_BJP_BNE_LSB+1-1
`define MIPS_DECINFO_BJP_BNE         `MIPS_DECINFO_BJP_BNE_MSB:`MIPS_DECINFO_BJP_BNE_LSB

`define MIPS_DECINFO_BJP_BLEZ_LSB    `MIPS_DECINFO_BJP_BNE_MSB+1
`define MIPS_DECINFO_BJP_BLEZ_MSB    `MIPS_DECINFO_BJP_BLEZ_LSB+1-1
`define MIPS_DECINFO_BJP_BLEZ        `MIPS_DECINFO_BJP_BLEZ_MSB:`MIPS_DECINFO_BJP_BLEZ_LSB

`define MIPS_DECINFO_BJP_BGTZ_LSB    `MIPS_DECINFO_BJP_BLEZ_MSB+1
`define MIPS_DECINFO_BJP_BGTZ_MSB    `MIPS_DECINFO_BJP_BGTZ_LSB+1-1
`define MIPS_DECINFO_BJP_BGTZ        `MIPS_DECINFO_BJP_BGTZ_MSB:`MIPS_DECINFO_BJP_BGTZ_LSB

`define MIPS_DECINFO_BJP_WIDTH       `MIPS_DECINFO_BJP_BGTZ_MSB+1


////////////////////////////////////////////////////////////////////////////////
// Finalize decode info groups
////////////////////////////////////////////////////////////////////////////////

`define MIPS_DECINFO_WIDTH           `MIPS_DECINFO_ALU_WIDTH
