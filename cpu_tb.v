//This Testbench is going to test the following instructions:

//For MOV Rn,#<im8>:
  //



module cpu_tb();

//regs and wires

  reg err;
  reg clk;
  reg reset, s; //input for FSM

  reg load; //load for the instruction register

  reg [15:0] in; //this goes into the instruction register

  wire [15:0] out; //gives out the contents of register C (component 5)
  wire N, V, Z, w; //give the value of negative, overflow
                    //and zero status register bits.
                  //w set to 1 if state machine is in the reset state and is waiting for s to be 1


//instantiating the cpu:
  module cpu(clk,reset,
             s,load,
             in,out,
             N,V,
             Z,w);

//------------------------------------------------------------------------------

  //clock
   initial begin
    clk = 0; #5; //the clock starts with a 0
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
   end

//------------------------------------------------------------------------------


//The tests:
  initial begin
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0;
    #10;

//------------------------------------------------------------------------------

//Instruction 1
//tests for MOV Rn,#<im8>:

  //Test 1: storing a regular value to R0:
    in = 16'b110_10_00000001000; //MOV R0,#8;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R0 !== 16'd8) begin
      err = 1;
      $display("FAILED: MOV R0,#8");
      $stop;
    end

  //Test 2: storing zero to R4:
    in = 16'b110_10_10000000000; //MOV R4,#0;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R4 !== 16'd0) begin
      err = 1;
      $display("FAILED: MOV R4,#0");
      $stop;
    end

  //Test 3: storing max value(256) to R7:
    in = 16'b110_10_111_11111111; //MOV R7,#256;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R7 !== 16'd256) begin
      err = 1;
      $display("FAILED: MOV R7,#256");
      $stop;
    end

//------------------------------------------------------------------------------

//Instruction 2
//tests for MOV Rd,Rm{,<sh_op>}: (1 1 0 0 0 0 0 0 Rd sh Rm)

  //Test 1: storing a regular value of R0 to R3:
    in = 16'b110_00_000_011_00_000; //MOV R3,R0;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R3 !== 16'd8) begin
      err = 1;
      $display("FAILED: MOV R3, R0");
      $stop;
    end

  //Test 2: Moving contents of R7 to R5 while right shifting it(256/2= 128)
    in = 16'b110_00_000_101_10_111; //MOV R5, R7 {,10};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R5 !== 16'd128) begin
      err = 1;
      $display("FAILED: MOV R5, R7 {,10};");
      $stop;
    end

  //Test 3: storing max value(256) to R7:
    in = 16'b110_10_000_001_11_011; //MOV R1, R3 {,11}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (lab6_check.DUT.DP.REGFILE.R1 !== 16'd16) begin
      err = 1;
      $display("FAILED: MOV R1, R3 {,11}");
      $stop;
    end
