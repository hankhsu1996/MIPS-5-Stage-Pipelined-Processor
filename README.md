# MIPS 5-Stage Pipeline Processor
##### tags: `Computer Architecture`

## Instruction Set

### Instruction Formats


| Type     | 31:26    | 25:21    | 20:16    | 15:11    | 10:6     | 5:0      |
| -------- | -------- | -------- | -------- | -------- | -------- | -------- |
| R-Type   | opcode   | $rs      | $rt      | $rd      | shamt    | funct    |
| I-Type   | opcode   | $rs      | imm                                       |
| J-Type   | opcode   | address                                              |

<table>
    <thead>
        <tr>
            <th>Layer 1</th>
            <th>Layer 2</th>
            <th>Layer 3</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>L1 Name</td>
            <td rowspan=2>L2 Name A</td>
            <td>L3 Name A</td>
        </tr>
        <tr>
            <td>L3 Name B</td>
        </tr>
        <tr>
            <td rowspan=2>L2 Name B</td>
            <td>L3 Name C</td>
        </tr>
        <tr>
            <td>L3 Name D</td>
        </tr>
    </tbody>
</table>

### R-Type Instructions


|          | Description | Column 3 |
| -------- | ----------- | -------- |
| NOP      |  | Text     |
| |||
||||
||||
||||
||||
||||
||||
||||
||||
