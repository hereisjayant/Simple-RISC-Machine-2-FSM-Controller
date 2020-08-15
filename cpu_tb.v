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
  cpu DUT(clk,reset,
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
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'd8) begin
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
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd0) begin
      err = 1;
      $display("FAILED: MOV R4,#0");
      $stop;
    end

  //Test 3: storing max value(256) to R7: this would lead to sign extension
    in = 16'b110_10_111_11111111; //MOV R7,#256;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R7 !== 16'd65535) begin
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
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'd8) begin
      err = 1;
      $display("FAILED: MOV R3, R0");
      $stop;
    end

  //Test 2: Moving contents of R3 to R5 while left shifting it(8*2= 16)
    in = 16'b110_00_000_101_01_011; //MOV R5, R3 {,01};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== 16'd16) begin
      err = 1;
      $display("FAILED: MOV R5, R3 {,01};");
      $stop;
    end

  //Test 3: Moving contents of R3 to R1 while right shifting it(256/2= 128) with shift = 11
    in = 16'b110_00_000_001_11_011; //MOV R1, R3 {,11}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd4) begin
      err = 1;
      $display("FAILED: MOV R1, R3 {,11}");
      $stop;
    end

//------------------------------------------------------------------------------

//Instruction 3
//tests for ADD Rd,Rn,Rm{,<sh_op>} (1 0 1 0 0 Rn Rd sh Rm)

  //Test 1: Adding R1(4) and R3(8) and storing the result to R2(12):
    in = 16'b101_00_001_010_00_011; //ADD R2, R1, R3;
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd12) begin
      err = 1;
      $display("FAILED: ADD R2, R1, R3");
      $stop;
    end

  //Test 2: Adding R1(4) and R3(8) with left shift and storing the result to R6(20):
    in = 16'b101_00_001_110_01_011; //ADD R6, R1, R3 {,01};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R6 !== 16'd20) begin
      err = 1;
      $display("FAILED: ADD R6, R1, R3 {,01}");
      $stop;
    end

  //Test 3: Adding R2(12) and R1(4) with left shift and storing the result to R2(20):
    in = 16'b101_00_010_010_01_001; //ADD R2, R2, R1{01};
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd20) begin
      err = 1;
      $display("FAILED: ADD R2, R2, R1{01}");
      $stop;
    end

//------------------------------------------------------------------------------

//Instruction 3
//tests for CMP Rn,Rm{,<sh_op>} (1 0 1 0 1 Rn 0 0 0 sh Rm)

 //Test 1: Comparing R2 with R6 and Displaying Zero flag
   in = 16'b101_01_010_000_00_110; //CMP R2, R6
   load = 1;
   #10;
   load = 0;
   s = 1;
   #10
   s = 0;
   @(posedge w); // wait for w to go high again
   #10;
   if (Z!== 1'b1) begin
     err = 1;
     $display("FAILED: CMP R2, R6");
     $stop;
   end

 //Test 2: Comparing R3 with R5 and Displaying N flag
   in = 16'b101_01_011_000_00_101; //CMP R3, R5
   load = 1;
   #10;
   load = 0;
   s = 1;
   #10
   s = 0;
   @(posedge w); // wait for w to go high again
   #10;
   if (N!== 1'b1) begin
     err = 1;
     $display("FAILED: CMP R3, R5");
     $stop;
   end

  //Test 3: Comparing R4 with R1
   in = 16'b101_01_100_000_11_001; //CMP R4, R1
   load = 1;
   #10;
   load = 0;
   s = 1;
   #10
   s = 0;
   @(posedge w); // wait for w to go high again
   #10;
   if (N!== 1'b1) begin
     err = 1;
     $display("FAILED: CMP R4, R1");
     $stop;
   end

//------------------------------------------------------------------------------
//Instruction 5
//tests for AND Rd,Rn,Rm{,<sh_op>} (1 0 1 1 0 Rn Rd sh Rm)

  //Test 1: AND R6, R2, R1
  in = 16'b101_10_010_110_00_001;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R6 !== 16'd4) begin
    err = 1;
    $display("FAILED: AND R6, R2, R1");
    $stop;
  end

  //Test 2: AND R1, R0, R1{,01}
  in = 16'b101_10_000_001_01_001;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'd8) begin
    err = 1;
    $display("FAILED: AND R1, R0, R1{,01}");
    $stop;
  end

  //Test 3: AND R2, R2, R3{10}
  in = 16'b101_10_010_010_10_011;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd4) begin
    err = 1;
    $display("FAILED: AND R2, R2, R3{10}");
    $stop;
  end

//------------------------------------------------------------------------------
//Instruction 6
//tests for MVN Rd,Rm{,<sh_op>} (1 0 1 1 1 0 0 0 Rd sh Rm)

  //Test 1: MVN R7, R7
  in = 16'b101_11_000_111_00_111;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R7 !== 16'd0) begin
    err = 1;
    $display("FAILED: MVN R7, R7");
    $stop;
  end

  //Test 2: MVN R7, R7
  in = 16'b101_11_000_111_00_111;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R7 !== 16'd65535) begin
    err = 1;
    $display("FAILED TEST 2: MVN R7, R7");
    $stop;
  end

  //Test 3: MVN R0, R1{01}
  in = 16'b101_11_000_000_01_001;
  load = 1;
  #10;
  load = 0;
  s = 1;
  #10
  s = 0;
  @(posedge w); // wait for w to go high again
  #10;
  if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'b1111_1111_1110_1111) begin
    err = 1;
    $display("FAILED: MVN R7, R7");
    $stop;
  end




  if (~err) $display("**PASSED ALL TESTS**");
  $stop;

//------------------------------------------------------------------------------
  end
endmodule
