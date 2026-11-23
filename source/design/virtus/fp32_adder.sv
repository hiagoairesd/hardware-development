module fp32_adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result,
    output logic flag_invalid,
    output logic flag_overflow,
    output logic flag_underflow,
    output logic flag_inexact
);
    logic a_signal = a[31];
    logic a_expo   = a[31:23];
    logic a_fract  = a[22:0];

    logic b_signal = b[31];
    logic b_expo   = b[31:23];
    logic b_frac   = b[22:0];
    
    logic bias = 

endmodule