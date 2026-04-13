// ── Testbench (không có port) ───
`timescale 1ns/1ps
module alu_tb;

// ── Khai báo tín hiệu ───────────
  reg  [7:0] a, b;
  reg  [2:0] op;
  wire [7:0] result;
  wire zero, carry;

// ── Instantiate DUT ─────────────
  alu_8bit dut (
    .a(a), .b(b), .op(op),
    .result(result),
    .zero(zero),
    .carry(carry)
  );

// ── Task: check kết quả ─────────
  integer pass, fail;
  task check;
    input [7:0] exp_result;
    input       exp_zero;
    input       exp_carry;
    input [31:0] test_num;
    begin
      #1;
      if (result===exp_result &&
          zero===exp_zero &&
          carry===exp_carry) begin
        $display("PASS [T%0d]", test_num);
        pass = pass + 1;
      end else begin
        $display("FAIL [T%0d] got=%0h z=%b c=%b | exp=%0h z=%b c=%b",
          test_num, result,zero,carry,
          exp_result,exp_zero,exp_carry);
        fail = fail + 1;
      end
    end
  endtask

// ── Test Cases ──────────────────
  initial begin
    pass = 0; fail = 0;
    $display("=== ALU 8-bit Testbench ===");

    // T1: ADD bình thường
    a=8'h0F; b=8'h01; op=3'b000;
    check(8'h10, 1'b0, 1'b0, 1);

    // T2: ADD overflow → carry=1
    a=8'hFF; b=8'h01; op=3'b000;
    check(8'h00, 1'b1, 1'b1, 2);

    // T3: SUB bình thường
    a=8'h0A; b=8'h03; op=3'b001;
    check(8'h07, 1'b0, 1'b0, 3);

    // T4: SUB → kết quả = 0
    a=8'h05; b=8'h05; op=3'b001;
    check(8'h00, 1'b1, 1'b0, 4);

    // T5: AND
    a=8'hF0; b=8'h0F; op=3'b010;
    check(8'h00, 1'b1, 1'b0, 5);

    // T6: OR
    a=8'hF0; b=8'h0F; op=3'b011;
    check(8'hFF, 1'b0, 1'b0, 6);

    // T7: XOR
    a=8'hAA; b=8'hAA; op=3'b100;
    check(8'h00, 1'b1, 1'b0, 7);

    // T8: SHL → carry từ MSB
    a=8'h80; b=8'h00; op=3'b101;
    check(8'h00, 1'b1, 1'b1, 8);

    // T9: SHR
    a=8'h0F; b=8'h00; op=3'b110;
    check(8'h07, 1'b0, 1'b0, 9);

    // T10: NOT
    a=8'h00; b=8'h00; op=3'b111;
    check(8'hFF, 1'b0, 1'b0, 10);

    $display("=== RESULT: %0d PASS / %0d FAIL ===",
             pass, fail);
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, alu_tb);
  end

endmodule