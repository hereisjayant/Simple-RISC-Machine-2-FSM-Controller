

module ALU(Ain,Bin,ALUop,out,Z);
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output [15:0] out;
  output Z;

  reg Z;
  reg [15:0] out;

  always @(*) begin
    case(ALUop)
      2'b00: out = Ain+Bin;//ADDing the input
      2'b01: out = Ain-Bin;//SUBTRACTing the input
      2'b10: out = Ain&Bin;//ANDing the input
      2'b11: out = ~Bin;//INVERSE of the input
      default: out =  {16{1'bx}} ; //to catch errors
    endcase
  end

//ALU output: if out=0 Z=1, otherwise Z=0
 always @(*) begin
   if(out==16'd0)
     Z=1'b1;
   else
     Z=1'b0;
 end

endmodule
