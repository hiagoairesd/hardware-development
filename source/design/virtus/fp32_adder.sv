module fp32_adder (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result,
    output logic flag_invalid,
    output logic flag_overflow,
    output logic flag_underflow,
    output logic flag_inexact
);
    //===============================================================================
    // 1) Local parameters declaration
    //===============================================================================
    
    localparam int EXP_W   = 8;
    localparam int FRAC_W  = 23;
    localparam int BIAS    = 127;

    // Special Representation of Floating Point Numbers
    localparam logic [EXP_W-1:0]  EXP_ZERO  = 8'h00;        // zero / subnormal
    localparam logic [EXP_W-1:0]  EXP_ONES  = 8'hFF;        // inf / NaN
    localparam logic [FRAC_W-1:0] FRAC_ZERO = 23'h00_0000;
    localparam int                QNAN_BIT  = FRAC_W - 1;   // frac[22]: 1 = quiet, 0 = signaling

    // ------------------------------------------------------------------
    // Special Values
    // ------------------------------------------------------------------
    localparam logic [31:0] POS_ZERO     = 32'h0000_0000;   // +0
    localparam logic [31:0] NEG_ZERO     = 32'h8000_0000;   // -0
    localparam logic [31:0] POS_INF      = 32'h7F80_0000;   // +inf (exp=FF, frac=0)
    localparam logic [31:0] NEG_INF      = 32'hFF80_0000;   // -inf
    localparam logic [31:0] QNAN         = 32'h7FC0_0000;   // NaN quiet canônico (resultado de operação inválida)
    localparam logic [31:0] SNAN         = 32'h7FA0_0000;   // exemplo de NaN signaling (exp=FF, frac[22]=0, frac!=0)

    // Range limits
    localparam logic [31:0] POS_MAX_NORM = 32'h7F7F_FFFF;   // largest normal: (2 - 2^-23) * 2^127
    localparam logic [31:0] NEG_MAX_NORM = 32'hFF7F_FFFF;
    localparam logic [31:0] POS_MIN_NORM = 32'h0080_0000;   // smallest normal: 2^-126
    localparam logic [31:0] NEG_MIN_NORM = 32'h8080_0000;
    localparam logic [31:0] POS_MAX_SUB  = 32'h007F_FFFF;   // largest subnormal: (1 - 2^-23) * 2^-126
    localparam logic [31:0] NEG_MAX_SUB  = 32'h807F_FFFF;
    localparam logic [31:0] POS_MIN_SUB  = 32'h0000_0001;   // smallest subnormal: 2^-149
    localparam logic [31:0] NEG_MIN_SUB  = 32'h8000_0001;

//==============================================================================
// 2) Variables declaration
//==============================================================================

    logic              a_signal;
    logic [EXP_W-1:0]  a_expo;
    logic [FRAC_W-1:0] a_fract;

    logic              b_signal;
    logic [EXP_W-1:0]  b_expo;
    logic [FRAC_W-1:0] b_frac;
    
//==============================================================================
// 3) Assignments and always blocks
//==============================================================================
    //--------------------------------------------------------------------------------
    // A Signal
    //--------------------------------------------------------------------------------
    assign a_signal = a[31];
    assign a_expo   = a[30:23];
    assign a_fract  = a[22:0];

    //--------------------------------------------------------------------------------
    // B Signal
    //--------------------------------------------------------------------------------
    assign b_signal = b[31];
    assign b_expo   = b[30:23];
    assign b_frac   = b[22:0];
endmodule