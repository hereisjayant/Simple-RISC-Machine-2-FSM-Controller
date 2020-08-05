

module ALU_tb();

  reg [15:0] Ain, Bin;
  reg [1:0] ALUop;
  reg err;
  wire [15:0] out;
  wire [2:0] Z;

  ALU DUT(Ain,Bin,ALUop,out,Z);

  initial begin

  err = 1'b0;
  #5;

//Case 1: Adding
  $display("Adding 5 and 7");
  //Ain = 5
  Ain = 16'b0000_0000_0000_0101;
  //Bin = 7
  Bin = 16'b0000_0000_0000_0111;
  //ALUop = 2'b00 = ADDing
  ALUop = 2'b00;
  //waits for 5 time steps
  #5;
  if( out !== 16'd12 ) begin
    $display("ERROR ** The out is %b, Z is %b, expected %b", out, Z, 16'b00000000_00001100 );
    err = 1'b1;
  end


//Case 2: SUBTRACTing
  $display("SUBTRACTing 3 from 10");
  //Ain = 10
  Ain = 16'd10;
  //Bin = 3
  Bin = 16'd3;
  //ALUop = 2'b01 = SUBTRACTing
  ALUop = 2'b01;
  //waits for 5 time steps
  #5;
  if( out !== 16'd7 && Z[0]!==1'b0 ) begin
    $display("ERROR ** The out is %b, Z is %b, expected %b", out, Z, 16'b00000000_00000111 );
    err = 1'b1;
  end


//Case 3: ANDing
  $display("ANDing 15 = 0b001111 and 60 = 0b111100");
  //Ain = 15 = 0b1111
  Ain = 16'd15;
  //Bin = 60 = 0b111100
  Bin = 16'd60;
  //ALUop = 2'b10 = ANDing
  ALUop = 2'b10;
  //waits for 5 time steps
  #5;
  if( out !== 16'd12 && Z[0]!==1'b0 ) begin
    $display("ERROR ** The out is %b, Z is %b, expected %b", out, Z, 16'b0000_0000_0000_1100 );
    err = 1'b1;
  end


//Case 4: NOT/Inverting operation
  $display("Finding the inverse of 16'b0000_0000_1111_1111");
  //Bin = 16'b0000_0000_1111_1111
  Bin = 16'b0000_0000_1111_1111;
  //ALUop = 2'b00 = ADDing
  ALUop = 2'b11;
  //waits for 5 time steps
  #5;
  if( out !== 16'b1111_1111_0000_0000 && Z[0]!==1'b0 ) begin
    $display("ERROR ** The out is %b, Z is %b, expected %b", out, Z, 16'b1111_1111_0000_0000 );
    err = 1'b1;
  end

//Case 5: Checking Z
  $display("Checking the value for Z");
  //Ain = 45
  Ain = 16'd45;
  //Bin = 45
  Bin = 16'd45;
  //ALUop = 2'b01 = SUBTRACTing
  ALUop = 2'b01;
  //waits for 5 time steps
  #5;
  if( out !== 16'd0 && Z[0]!==1'b1 ) begin
    $display("ERROR ** The out is %b, Z is %b should be 1, expected %b", out, Z, 16'b00000000_00000000 );
    err = 1'b1;
  end



  //Case 6: Checking the status overflow
    $display("Checking the value for Z overflow");
    //Ain
    Ain = 16'b100000000000000;
    //Bin = 45
    Bin = 16'b100000000000000;
    //ALUop = 2'b00 = ADDing
    ALUop = 2'b00;
    //waits for 5 time steps
    #5;
    if( Z[2]!==1'b1 ) begin
      $display("ERROR ** The out is %b, Z[2] is %b should be 1", out, Z );
      err = 1'b1;
      end



  if( ~err ) $display("*ALL THE TESTS HAVE BEEN PASSED*");
  $stop;

  end

endmodule
