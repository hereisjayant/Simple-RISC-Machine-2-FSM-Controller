

module cpu(clk,reset,s,load,in,out,N,V,Z,w);

//I/Os
  input clk;
  input reset, s; //input for FSM

  input load; //load for the instruction register

  input [15:0] in; //this goes into the instruction register
  output [15:0] out; //gives out the contents of register C (component 5)
  output N, V, Z, w; //give the value of negative, overflow
                    //and zero status register bits.
                    //w set to 1 if state machine is in the reset state and is waiting for s to be 1

//Wires
  //from instruction register to instruction decoder
  wire [15:0] iRegToiDec;


//Declared modules:

  //Instruction Register
  vDFFE InstructionReg(clk, load, in, iRegToiDec);

  //NOTE: when instantiating datapath set PC and mdata to 0
  

endmodule

//******************************************************************************
