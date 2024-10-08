// Generated by CIRCT firtool-1.40.0
module MUL_stage_0(	// <stdin>:3:10
  input  [31:0]  io_a,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:10:14
                 io_b,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:10:14
  output [255:0] io_y	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:10:14
);

  wire [15:0] _GEN = {8'h0, io_a[7:0]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{34,63}
  wire [15:0] _GEN_0 = {8'h0, io_b[7:0]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{63,69}
  wire [15:0] _GEN_1 = {8'h0, io_a[15:8]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{34,63}
  wire [15:0] _GEN_2 = {8'h0, io_a[23:16]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{34,63}
  wire [15:0] _GEN_3 = {8'h0, io_a[31:24]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{34,63}
  wire [15:0] _GEN_4 = {8'h0, io_b[15:8]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{63,69}
  wire [15:0] _GEN_5 = {8'h0, io_b[23:16]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{63,69}
  wire [15:0] _GEN_6 = {8'h0, io_b[31:24]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:{63,69}
  assign io_y =
    {_GEN_3 * _GEN_6,
     _GEN_2 * _GEN_6,
     _GEN_1 * _GEN_6,
     _GEN * _GEN_6,
     _GEN_3 * _GEN_5,
     _GEN_2 * _GEN_5,
     _GEN_1 * _GEN_5,
     _GEN * _GEN_5,
     _GEN_3 * _GEN_4,
     _GEN_2 * _GEN_4,
     _GEN_1 * _GEN_4,
     _GEN * _GEN_4,
     _GEN_3 * _GEN_0,
     _GEN_2 * _GEN_0,
     _GEN_1 * _GEN_0,
     _GEN * _GEN_0};	// <stdin>:3:10, src/main/scala/core/lite/Execute/MUL_Multistage.scala:21:63, :24:20
endmodule

module MUL_stage_1(	// <stdin>:90:10
  input  [255:0] io_MUL_stage_0,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:28:14
  output [127:0] io_MUL_stage_1,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:28:14
  output [7:0]   io_MUL_stage_1_8_bit	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:28:14
);

  wire        co3;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:71:14
  wire        co2;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:70:14
  wire        co1;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:69:14
  wire [32:0] sum1 =
    {1'h0,
     io_MUL_stage_0[223:216],
     io_MUL_stage_0[159:152],
     io_MUL_stage_0[103:96],
     io_MUL_stage_0[87:80]}
    + {1'h0, io_MUL_stage_0[231:224], io_MUL_stage_0[167:160], io_MUL_stage_0[143:128]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:46:38, :53:80, :64:19
  wire [16:0] sum2 =
    {1'h0, io_MUL_stage_0[207:200], io_MUL_stage_0[151:144]}
    + {1'h0, io_MUL_stage_0[215:208], io_MUL_stage_0[199:192]};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:46:38, :64:19, :65:19
  wire [32:0] sum3 = sum1 + {7'h0, co2, sum2, 8'h0};	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:49:168, :64:19, :65:19, :66:{16,30}, :70:14
  assign co1 = sum1[32];	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:64:19, :69:14
  assign co2 = sum2[16];	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:65:19, :70:14
  assign co3 = sum3[32];	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:66:16, :71:14
  assign io_MUL_stage_1 =
    {14'h0,
     co3 + co1,
     sum3,
     16'h0,
     {io_MUL_stage_0[255:248],
      io_MUL_stage_0[191:184],
      io_MUL_stage_0[127:120],
      io_MUL_stage_0[63:56],
      io_MUL_stage_0[47:40],
      io_MUL_stage_0[31:24],
      io_MUL_stage_0[15:8],
      8'h0}
       + {8'h0,
          io_MUL_stage_0[239:232],
          io_MUL_stage_0[175:168],
          io_MUL_stage_0[111:104],
          io_MUL_stage_0[55:48],
          io_MUL_stage_0[39:32],
          io_MUL_stage_0[23:16],
          8'h0}
       + {8'h0,
          io_MUL_stage_0[247:240],
          io_MUL_stage_0[183:176],
          io_MUL_stage_0[119:112],
          io_MUL_stage_0[95:88],
          io_MUL_stage_0[79:64],
          8'h0}};	// <stdin>:90:10, src/main/scala/core/lite/Execute/MUL_Multistage.scala:46:38, :49:168, :51:125, :66:16, :67:14, :69:14, :71:14, :73:{11,38}, :74:22, :75:22, :77:34
  assign io_MUL_stage_1_8_bit = io_MUL_stage_0[7:0];	// <stdin>:90:10, src/main/scala/core/lite/Execute/MUL_Multistage.scala:46:38
endmodule

module MUL_stage_2(	// <stdin>:247:10
  input  [127:0] io_MUL_stage_1,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:84:14
  input  [7:0]   io_MUL_stage_1_8_bit,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:84:14
  output [63:0]  io_MUL_stage_2	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:84:14
);

  wire [63:0] _GEN = io_MUL_stage_1[127:64] + io_MUL_stage_1[63:0];	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:89:{31,40,56}
  assign io_MUL_stage_2 = {_GEN[63:8], io_MUL_stage_1_8_bit};	// <stdin>:247:10, src/main/scala/core/lite/Execute/MUL_Multistage.scala:89:40, :90:{28,35}
endmodule

module MUL_pipelined(	// <stdin>:260:10
  input         clock,	// <stdin>:261:11
                reset,	// <stdin>:262:11
  input  [31:0] io_a,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:94:14
                io_b,	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:94:14
  output [63:0] io_y	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:94:14
);

  wire [127:0] _stage_1_io_MUL_stage_1;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:100:23
  wire [7:0]   _stage_1_io_MUL_stage_1_8_bit;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:100:23
  wire [255:0] _stage_0_io_y;	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:99:23
  MUL_stage_0 stage_0 (	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:99:23
    .io_a (io_a),
    .io_b (io_b),
    .io_y (_stage_0_io_y)
  );
  MUL_stage_1 stage_1 (	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:100:23
    .io_MUL_stage_0       (_stage_0_io_y),	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:99:23
    .io_MUL_stage_1       (_stage_1_io_MUL_stage_1),
    .io_MUL_stage_1_8_bit (_stage_1_io_MUL_stage_1_8_bit)
  );
  MUL_stage_2 stage_2 (	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:101:23
    .io_MUL_stage_1       (_stage_1_io_MUL_stage_1),	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:100:23
    .io_MUL_stage_1_8_bit (_stage_1_io_MUL_stage_1_8_bit),	// src/main/scala/core/lite/Execute/MUL_Multistage.scala:100:23
    .io_MUL_stage_2       (io_y)
  );
endmodule

