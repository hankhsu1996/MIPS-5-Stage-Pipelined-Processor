# MIPS 5-Stage Pipelined Processor
This is a simplified classic MIPS 5-stage pipelined processor, supporting limited instructions as follow. 

## Instruction Set
### Instruction Formats
<table>
    <thead>
        <tr>
            <th>Type</th>
            <th style="font-family: consolas;">31:26</th>
            <th style="font-family: consolas;">25:21</th>
            <th style="font-family: consolas;">20:16</th>
            <th style="font-family: consolas;">15:11</th>
            <th style="font-family: consolas;">10:6</th>
            <th style="font-family: consolas;">5:0</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>R-Type</td>
            <td style="font-family: consolas;">opcode</td>
            <td style="font-family: consolas;">$rs</td>
            <td style="font-family: consolas;">$rt</td>
            <td style="font-family: consolas;">$rd</td>
            <td style="font-family: consolas;">shamt</td>
            <td style="font-family: consolas;">funct</td>
        </tr>
        <tr>
            <td>I-Type</td>
            <td style="font-family: consolas;">opcode</td>
            <td style="font-family: consolas;">$rs</td>
            <td style="font-family: consolas;">$rt</td>
            <td style="font-family: consolas;" colspan=3>imm</td>
        </tr>
        <tr>
            <td>J-Type</td>
            <td style="font-family: consolas;">opcode</td>
            <td style="font-family: consolas;" colspan=5>address</td>
        </tr>
    </tbody>
</table>

### R-Type Instructions
<table>
    <thead>
        <tr>
            <td colspan="2">Instruction</td>
            <td>funct</td>
            <td>Description</td>
            <td>Supported</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sll</td>
            <td>rd, rt, sa</td>
            <td>000000</td>
            <td>Shift left logical</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>srl</td>
            <td>rd, rt, sa</td>
            <td>000010</td>
            <td>Shift right logical</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>sra</td>
            <td>rd, rt, sa</td>
            <td>000011</td>
            <td>Shift right arithmetic</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>sllv</td>
            <td>rd, rt, rs</td>
            <td>000100</td>
            <td>Shift left logical variable</td>
            <td>no</td>
        </tr>
        <tr>
            <td>srlv</td>
            <td>rd, rt, rs</td>
            <td>000110</td>
            <td>Shift right logical variable</td>
            <td>no</td>
        </tr>
        <tr>
            <td>srav</td>
            <td>rd, rt, rs</td>
            <td>000111</td>
            <td>Shift right arithmetic variable</td>
            <td>no</td>
        </tr>
        <tr>
            <td>jr</td>
            <td>rs</td>
            <td>001000</td>
            <td>Jump register</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>jalr</td>
            <td>rd, rs</td>
            <td>001001</td>
            <td>Jump and link register</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>mfhi</td>
            <td>rd</td>
            <td>010000</td>
            <td>Move from HI</td>
            <td>no</td>
        </tr>
        <tr>
            <td>mthi</td>
            <td>rs</td>
            <td>010001</td>
            <td>Move to HI</td>
            <td>no</td>
        </tr>
        <tr>
            <td>mflo</td>
            <td>rd</td>
            <td>010010</td>
            <td>Move from LO</td>
            <td>no</td>
        </tr>
        <tr>
            <td>mtlo</td>
            <td>rs</td>
            <td>010011</td>
            <td>Move to LO</td>
            <td>no</td>
        </tr>
        <tr>
            <td>mult</td>
            <td>rs, rt</td>
            <td>011000</td>
            <td>Multiply</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>multu</td>
            <td>rs, rt</td>
            <td>011001</td>
            <td>Multiply unsigned</td>
            <td>no</td>
        </tr>
        <tr>
            <td>div</td>
            <td>rs, rt</td>
            <td>011010</td>
            <td>Divide</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>divu</td>
            <td>rs, rt</td>
            <td>011011</td>
            <td>Divide unsigned</td>
            <td>no</td>
        </tr>
        <tr>
            <td>add</td>
            <td>rd, rs, rt</td>
            <td>100000</td>
            <td>Add (with overflow)</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>addu</td>
            <td>rd, rs, rt</td>
            <td>100001</td>
            <td>Add immediate (with overflow)</td>
            <td>no</td>
        </tr>
        <tr>
            <td>sub</td>
            <td>rd, rs, rt</td>
            <td>100010</td>
            <td>Subtract</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>subu</td>
            <td>rd, rs, rt</td>
            <td>100011</td>
            <td>Subtract unsigned</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>and</td>
            <td>rd, rs, rt</td>
            <td>100100</td>
            <td>Bitwise and</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>or</td>
            <td>rd, rs, rt</td>
            <td>100101</td>
            <td>Bitwise or</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>xor</td>
            <td>rd, rs, rt</td>
            <td>100110</td>
            <td>Bitwise xor</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>nor</td>
            <td>rd, rs, rt</td>
            <td>100111</td>
            <td>Bitwise nor</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>slt</td>
            <td>rd, rs, rt</td>
            <td>101010</td>
            <td>Set on less than (signed)</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>sltu</td>
            <td>rd, rs, rt</td>
            <td>101011</td>
            <td>Set on less than unsigned</td>
            <td>no</td>
        </tr>
    </tbody>
</table>

### I-Type Instructions
<table>
    <thead>
        <tr>
            <td colspan="2">Instruction</td>
            <td>Opcode</td>
            <td>Notes</td>
            <td>Description</td>
            <td>Supported</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>addi</td>
            <td>rt, rs, imm</td>
            <td>001000</td>
            <td></td>
            <td>Add immediate (with overflow)</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>addiu</td>
            <td>rt, rs, imm</td>
            <td>001001</td>
            <td></td>
            <td>Add immediate unsigned (no overflow)</td>
            <td>no</td>
        </tr>
        <tr>
            <td>andi</td>
            <td>rt, rs, imm</td>
            <td>001100</td>
            <td></td>
            <td>Bitwise and immediate</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>beq</td>
            <td>rs, rt, label</td>
            <td>000100</td>
            <td></td>
            <td>Branch on equal</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>bgez</td>
            <td>rs, label</td>
            <td>000001</td>
            <td>rt = 00001</td>
            <td>Branch on greater than or equal to
                zero</td>
            <td>no</td>
        </tr>
        <tr>
            <td>bgtz</td>
            <td>rs, label</td>
            <td>000111</td>
            <td>rt = 00000</td>
            <td>Branch on greater than zero</td>
            <td>no</td>
        </tr>
        <tr>
            <td>blez</td>
            <td>rs, label</td>
            <td>000110</td>
            <td>rt = 00000</td>
            <td>Branch on less than or equal to zero
            </td>
            <td>no</td>
        </tr>
        <tr>
            <td>bltz</td>
            <td>rs, label</td>
            <td>000001</td>
            <td>rt = 00000</td>
            <td>Branch on less than zero</td>
            <td>no</td>
        </tr>
        <tr>
            <td>bne</td>
            <td>rs, rt, label</td>
            <td>000101</td>
            <td></td>
            <td>Branch on not equal</td>
            <td>no</td>
        </tr>
        <tr>
            <td>lb</td>
            <td>rt, imm(rs)</td>
            <td>100000</td>
            <td></td>
            <td>Load byte signed</td>
            <td>no</td>
        </tr>
        <tr>
            <td>lbu</td>
            <td>rt, imm(rs)</td>
            <td>100100</td>
            <td></td>
            <td>Load byte unsigned</td>
            <td>no</td>
        </tr>
        <tr>
            <td>lui</td>
            <td>rt, imm</td>
            <td>001111</td>
            <td></td>
            <td>Load upper immediate</td>
            <td>no</td>
        </tr>
        <tr>
            <td>lw</td>
            <td>rt, imm(rs)</td>
            <td>100011</td>
            <td></td>
            <td>Load word</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>ori</td>
            <td>rt, rs, imm</td>
            <td>001101</td>
            <td></td>
            <td>Bitwise or immediate</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>sb</td>
            <td>rt, imm(rs)</td>
            <td>101000</td>
            <td></td>
            <td>Store byte</td>
            <td>no</td>
        </tr>
        <tr>
            <td>slti</td>
            <td>rt, rs, imm</td>
            <td>001010</td>
            <td></td>
            <td>Set on less than immediate (signed)
            </td>
            <td>yes</td>
        </tr>
        <tr>
            <td>sltiu</td>
            <td>rt, rs, imm</td>
            <td>001011</td>
            <td></td>
            <td>Set on less than immediate unsigned
            </td>
            <td>no</td>
        </tr>
        <tr>
            <td>sw</td>
            <td>rt, imm(rs)</td>
            <td>101011</td>
            <td></td>
            <td>Store word</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>xori</td>
            <td>rt, rs, imm</td>
            <td>001110</td>
            <td></td>
            <td>Bitwise exclusive or immediate</td>
            <td>yes</td>
        </tr>
    </tbody>
</table>

### J-Type Instructions
<table>
    <thead>
        <tr>
            <td colspan="2">Instruction</td>
            <td>Opcode</td>
            <td>Target</td>
            <td>Supported</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>j</td>
            <td>label</td>
            <td>10</td>
            <td>coded address of label</td>
            <td>yes</td>
        </tr>
        <tr>
            <td>jal</td>
            <td>label</td>
            <td>11</td>
            <td>coded address of label</td>
            <td>yes</td>
        </tr>
    </tbody>
</table>