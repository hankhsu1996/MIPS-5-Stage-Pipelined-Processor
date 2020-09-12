////////////////////////////////////////////////////////////////////////////////
//
//    ╔═════════╗     Auther:          Shou-Li Hsu
//    ║ H A N K ║     Website:         www.hankhsu.tw
//    ║ H S U   ║     Entity Name:     mips_ex_alu_dpath
//    ║ 1 9 9 6 ║     Purpose:         This module implement the datapath in
//    ╚═════════╝                      EX stage.
//
//                    Version:         1.0
//                    Filename:        mips_ex_alu_dpath.v
//                    Date Created:    August 30, 2020
//                    Last Modified:   September 12, 2020
//
////////////////////////////////////////////////////////////////////////////////


module mips_ex_alu_dpath (
    // Regular ALU request
    input wire alu_req_alu,

    input wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op1,
    input wire [`MIPS_DATA_WIDTH-1:0] alu_req_alu_op2,

    input wire alu_req_alu_add,
    input wire alu_req_alu_addu,
    input wire alu_req_alu_sub,
    input wire alu_req_alu_subu,
    input wire alu_req_alu_and,
    input wire alu_req_alu_or,
    input wire alu_req_alu_xor,
    input wire alu_req_alu_nor,
    input wire alu_req_alu_sll,
    input wire alu_req_alu_srl,
    input wire alu_req_alu_sra,
    input wire alu_req_alu_slt,
    input wire alu_req_alu_sltu,
    input wire alu_req_alu_lui,

    // AGU request
    input wire agu_req_alu,

    input wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op1,
    input wire [`MIPS_DATA_WIDTH-1:0] agu_req_alu_op2,

    // BJP request
    input wire bjp_req_alu,

    input wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op1,
    input wire [`MIPS_DATA_WIDTH-1:0] bjp_req_alu_op2,

    input wire bjp_req_alu_cmp_gez,
    input wire bjp_req_alu_cmp_ltz,
    input wire bjp_req_alu_cmp_eq,
    input wire bjp_req_alu_cmp_ne,
    input wire bjp_req_alu_cmp_lez,
    input wire bjp_req_alu_cmp_gtz
);

wire [`MIPS_DATA_WIDTH-1:0] mux_op1;
wire [`MIPS_DATA_WIDTH-1:0] mux_op2;
wire [`MIPS_DATA_WIDTH-1:0] misc_op1 = mux_op1;
wire [`MIPS_DATA_WIDTH-1:0] misc_op2 = mux_op2;



wire op_add;
wire op_addu;
wire op_sub;
wire op_subu;
wire op_addsub = op_add | op_sub;

wire op_and;
wire op_or;
wire op_xor;
wire op_nor;

wire op_sll;
wire op_srl;
wire op_sra;
wire op_shift = op_sll | op_srl | op_sra;

wire op_slt;
wire op_sltu;
wire op_lui;

wire op_cmp_gez;
wire op_cmp_ltz;
wire op_cmp_eq;
wire op_cmp_ne;
wire op_cmp_lez;
wire op_cmp_gtz;


////////////////////////////////////////////////////////////////////////////////
// Implement the shifter
////////////////////////////////////////////////////////////////////////////////

// Only the regular ALU use shifter
wire [`MIPS_DATA_WIDTH-1:0] shifter_op1 = alu_req_alu_op1;
wire [`MIPS_DATA_WIDTH-1:0] shifter_op2 = alu_req_alu_op2;
wire [`MIPS_DATA_WIDTH-1:0] shifter_op1_rev;
wire [`MIPS_DATA_WIDTH-1:0] shifter_in1;

// For SLLV and SRLV, only the lowest 5 bits are used 
wire [4:0] shifter_in2;
wire [`MIPS_DATA_WIDTH-1:0] shifter_res;
wire [`MIPS_DATA_WIDTH-1:0] sll_res;
wire [`MIPS_DATA_WIDTH-1:0] srl_res;
wire [`MIPS_DATA_WIDTH-1:0] sra_res;

genvar i;
generate
    for (i=0; i<`MIPS_DATA_WIDTH; i=i+1) 
        assign shifter_op1_rev[i] = shifter_op1[`MIPS_DATA_WIDTH-1-i];
endgenerate

// Only use left shifter
assign shifter_in1 = {`MIPS_DATA_WIDTH{op_shift}} & 
    (op_srl | op_sra) ? shifter_op1_rev : 
    shifter_op1;
assign shifter_in2 = {5{op_shift}} & shifter_op2;
assign shifter_res = shifter_in1 << shifter_in2;

// Assign SLL result
assign sll_res = shifter_res;

// Assign SRL result
generate
    for (i=0; i<`MIPS_DATA_WIDTH; i=i+1)
        assign srl_res[i] = shifter_res[`MIPS_DATA_WIDTH-1-i];
endgenerate

// Assign SRA result
wire eff_mask = {`MIPS_DATA_WIDTH{1'b1}} >> shifter_in2;
assign sra_res = 
    srl_res & eff_mask | 
    {`MIPS_DATA_WIDTH{shifter_op1[`MIPS_DATA_WIDTH-1]}} & ~eff_mask;


////////////////////////////////////////////////////////////////////////////////
// Implement the adder
////////////////////////////////////////////////////////////////////////////////

wire op_usign = op_addu | op_subu | op_sltu;

wire [`MIPS_ALU_ADDER_SIGNEXT-1:0] misc_op1_sign_ext = 
    {`MIPS_ALU_ADDER_SIGNEXT{~op_usign & misc_op1[`MIPS_DATA_WIDTH-1]}};
wire [`MIPS_ALU_ADDER_SIGNEXT-1:0] misc_op2_sign_ext = 
    {`MIPS_ALU_ADDER_SIGNEXT{~op_usign & misc_op2[`MIPS_DATA_WIDTH-1]}};

wire [`MIPS_ALU_ADDER_WIDTH-1:0] adder_op1 = {misc_op1_sign_ext, misc_op1};
wire [`MIPS_ALU_ADDER_WIDTH-1:0] adder_op2 = {misc_op1_sign_ext, misc_op2};

wire adder_cin;
wire [`MIPS_ALU_ADDER_WIDTH-1:0] adder_in1;
wire [`MIPS_ALU_ADDER_WIDTH-1:0] adder_in2;
wire [`MIPS_ALU_ADDER_WIDTH-1:0] adder_res;

wire adder_add = op_add | op_addu;
wire adder_sub = op_sub | op_subu;
wire adder_addsub = adder_add | adder_sub;

assign adder_in1 = {`MIPS_ALU_ADDER_WIDTH{1'b1}} & adder_op1;
assign adder_in2 = {`MIPS_ALU_ADDER_WIDTH{1'b1}} & (adder_sub ? ~adder_op2 : adder_op2);
assign adder_cin = adder_sub;

assign adder_res = adder_in1 + adder_in2 + adder_cin;


////////////////////////////////////////////////////////////////////////////////
// Implement the XOR-er
////////////////////////////////////////////////////////////////////////////////

wire [`MIPS_DATA_WIDTH-1:0] xorer_in1; 
wire [`MIPS_DATA_WIDTH-1:0] xorer_in2; 
wire [`MIPS_DATA_WIDTH-1:0] xorer_res; 

wire op_xorer = op_xor | op_cmp_eq | op_cmp_ne;

assign xorer_in1 = {`MIPS_DATA_WIDTH{op_xorer}} & misc_op1;
assign xorer_in2 = {`MIPS_DATA_WIDTH{op_xorer}} & misc_op2;
assign xorer_res = xorer_in1 ^ xorer_in2;

// AND, OR and NOR are light-weighted, so gating is not needed
wire [`MIPS_DATA_WIDTH-1:0] ander_res = misc_op1 & misc_op2;
wire [`MIPS_DATA_WIDTH-1:0] orer_res  = misc_op1 | misc_op2;
wire [`MIPS_DATA_WIDTH-1:0] norer_res = ~(misc_op1 | misc_op2);


////////////////////////////////////////////////////////////////////////////////
// Implement the comparator
////////////////////////////////////////////////////////////////////////////////

wire cmp_res;

wire cmp_neq = |xorer_res;
wire rs_neqz = |bjp_req_alu_op1;
wire rs_eqz = ~rs_neqz;
wire rs_gez = ~bjp_req_alu_op1[`MIPS_DATA_WIDTH-1];
wire rs_ltz = bjp_req_alu_op1[`MIPS_DATA_WIDTH-1];

wire cmp_res_gez = op_cmp_gez & rs_gez;
wire cmp_res_ltz = op_cmp_ltz & rs_ltz;
wire cmp_res_eq  = op_cmp_eq  & ~cmp_neq;
wire cmp_res_ne  = op_cmp_ne  & cmp_neq;
wire cmp_res_lez = op_cmp_lez & (rs_ltz | rs_eqz);
wire cmp_res_gtz = op_cmp_gtz & (rs_neqz & rs_gez);

assign cmp_res = cmp_res_gez | cmp_res_ltz | cmp_res_eq | cmp_res_ne | cmp_res_lez | cmp_res_gtz;


endmodule