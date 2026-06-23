module riscv_cpu(

    input clk,
    input rst,
    input [31:0] instruction

);

reg [31:0] regfile [0:7];

reg [2:0] opcode;
reg [2:0] rs1;
reg [2:0] rs2;
reg [2:0] rd;

reg [31:0] result;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        regfile[0] <= 0;
        regfile[1] <= 10;
        regfile[2] <= 5;
        regfile[3] <= 0;
        regfile[4] <= 0;
        regfile[5] <= 0;
        regfile[6] <= 0;
        regfile[7] <= 0;
    end
    else
    begin

        opcode = instruction[31:29];
        rs1    = instruction[28:26];
        rs2    = instruction[25:23];
        rd     = instruction[22:20];

        case(opcode)

            3'b000:
                result = regfile[rs1] + regfile[rs2];

            3'b001:
                result = regfile[rs1] - regfile[rs2];

            3'b010:
                result = regfile[rs1] & regfile[rs2];

            3'b011:
                result = regfile[rs1] | regfile[rs2];

            default:
                result = 32'd0;

        endcase

        regfile[rd] <= result;

    end

end

endmodule
