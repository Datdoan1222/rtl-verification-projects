// ── Module Declaration ──────────
module alu_8bit (
  input  [7:0] a,
  input  [7:0] b,
  input  [2:0] op,
  output reg [7:0] result,
  output zero,
  output carry
);

// ── Parameters ──────────────────
  parameter ADD = 3'b000;
  parameter SUB = 3'b001;
  parameter AND = 3'b010;
  parameter OR  = 3'b011;
  parameter XOR = 3'b100;
  parameter SHL = 3'b101;
  parameter SHR = 3'b110;
  parameter NOT = 3'b111;

// ── Internal signals ────────────
  reg [8:0] temp;

// ── Combinational Logic ─────────
  always @(*) begin
    temp = 9'b0;
    case (op)
      ADD: temp = {1'b0,a} + {1'b0,b};
      SUB: temp = {1'b0,a} - {1'b0,b};
      AND: temp = {1'b0, a & b};
      OR:  temp = {1'b0, a | b};
      XOR: temp = {1'b0, a ^ b};
      SHL: temp = {1'b0, a} << 1;
      SHR: temp = {1'b0, a} >> 1;
      NOT: temp = {1'b0, ~a};
      default: temp = 9'b0;
    endcase
    result = temp[7:0];
  end

// ── Output Flags ────────────────
  assign zero  = (result == 8'b0);
  assign carry = temp[8];

endmodule