


module InstructionDecoder_tb();

  reg [2:0] nsel; //NOTE: Use the 1-HOT select for Rn | Rd | Rm
  reg [15:0] iRegToiDec;//Inputs to the Decoder
  reg err;

  wire [2:0] opcode;//To FSM
  wire [1:0] op;

  wire [1:0] ALUop;//To datapath
  wire [15:0] sximm5;
  wire [15:0] sximm8;
  wire [1:0] shift;
  wire [2:0] readnum;
  wire [2:0] writenum;

  InstructionDecoder DUT(iRegToiDec,//Inputs to the Decoder
                              nsel,

                              opcode,//To FSM
                              op,

                              ALUop,//To datapath
                              sximm5,
                              sximm8,
                              shift,
                              readnum,
                              writenum);

   initial begin            //R0
     iRegToiDec = 16'b110_10_000_00000111;
     nsel = 3'b100;
     #10;
   end

  endmodule
