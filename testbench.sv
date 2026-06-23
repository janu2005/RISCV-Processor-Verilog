
`timescale 1ns/1ps

module tb_riscv_cpu;

reg clk;
reg rst;
reg [31:0] instruction;

integer errors = 0;

riscv_cpu DUT(
    .clk(clk),
    .rst(rst),
    .instruction(instruction)
);

always #5 clk = ~clk;

//-------------------------------------------------------------
// Task
//-------------------------------------------------------------

task run_test(
    input [31:0] instr,
    input [31:0] expected,
    input [2:0] rd_idx,
    input [200:0] op_name
);
begin

    instruction = instr;

    #10;

    if(DUT.regfile[rd_idx] !== expected)
    begin
        errors = errors + 1;

        $display("FAIL : %s Expected=%0d Got=%0d",
                 op_name,
                 expected,
                 DUT.regfile[rd_idx]);
    end
    else
    begin
        $display("PASS : %s Result=%0d",
                 op_name,
                 DUT.regfile[rd_idx]);
    end

end
endtask

//-------------------------------------------------------------
// Test Sequence
//-------------------------------------------------------------

initial begin

    $dumpfile("riscv_cpu.vcd");
    $dumpvars(0,tb_riscv_cpu);

    clk = 0;
    rst = 1;
    instruction = 0;

    #10;
    rst = 0;

    //---------------------------------------------------------
    // ADD
    // R3 = R1 + R2 = 10 + 5 = 15
    //---------------------------------------------------------

    run_test(
        {3'b000,3'd1,3'd2,3'd3,20'd0},
        15,
        3,
        "ADD"
    );

    //---------------------------------------------------------
    // SUB
    // R4 = R1 - R2 = 10 - 5 = 5
    //---------------------------------------------------------

    run_test(
        {3'b001,3'd1,3'd2,3'd4,20'd0},
        5,
        4,
        "SUB"
    );

    //---------------------------------------------------------
    // AND
    //---------------------------------------------------------

    run_test(
        {3'b010,3'd1,3'd2,3'd5,20'd0},
        (10 & 5),
        5,
        "AND"
    );

    //---------------------------------------------------------
    // OR
    //---------------------------------------------------------

    run_test(
        {3'b011,3'd1,3'd2,3'd6,20'd0},
        (10 | 5),
        6,
        "OR"
    );

    //---------------------------------------------------------
    // Final Register Dump
    //---------------------------------------------------------

    $display("--------------------------------");
    $display("R1 = %0d", DUT.regfile[1]);
    $display("R2 = %0d", DUT.regfile[2]);
    $display("R3 = %0d", DUT.regfile[3]);
    $display("R4 = %0d", DUT.regfile[4]);
    $display("R5 = %0d", DUT.regfile[5]);
    $display("R6 = %0d", DUT.regfile[6]);
    $display("--------------------------------");

    if(errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("%0d TESTS FAILED", errors);

    #20;
    $finish;

end

endmodule
