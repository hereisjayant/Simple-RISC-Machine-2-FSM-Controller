

//TODO: make changes according to lab6
//NOTE: The statements to execute are as follows:
// MOV R0, #7 ; this means, take the absolute number 7 and store it in R0
// MOV R1, #2 ; this means, take the absolute number 2 and store it in R1
// ADD R2, R1, R0, LSL#1 ; this means R2 = R1 + (R0 shifted left by 1) = 2+14=16


module datapath_tb();

//Ins and Outs
  reg err;

  reg [15:0] datapath_in;  //reg to datapath

  reg vsel; //input to the first multiplexer b4 regfile

  reg [2:0] writenum;  //inputs to register file
  reg write;
  reg [2:0] readnum;
  reg clk;

  reg loada;  //pipeline registers a & b
  reg loadb;

  reg [1:0] shift; //input to shifter unit

  reg asel;   //source opperand multiplexers
  reg bsel;

  reg [1:0] ALUop;  //ALU input

  reg loadc;  //pipeline c
  reg loads; //status register

  wire Z_out;  //status output
  wire [15:0] datapath_out; //datapath output


//instantiating the datapath
 datapath DUT(datapath_in,  //input to datapath

                 vsel, //input to the first multiplexer b4 regfile

                 writenum,  //inputs to register file
                 write,
                 readnum,
                 clk,

                 loada,  //pipeline registers a & b
                 loadb,

                 shift,  //input to shifter unit

                 asel,   //source opperand multiplexers
                 bsel,

                 ALUop,  //ALU input

                 loadc,  //pipeline c
                 loads,  //status register

                 Z_out,  //status output
                 datapath_out); //datapath output

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
  //Setting signal err to 0
    err = 1'b0;
    #10;

//------------------------------------------------------------------------------

  //Executing the first command
  // MOV R0, #7 ; this means, take the absolute number 7 and store it in R0

    //selects register 0
    writenum = 3'b000;
    //inputs number 7 to the datapath
    datapath_in = 16'd7;
    //selects the input from the first MUX
    vsel = 1'b1;
    //turn on write
    write = 1'b1;
    //waits for 10 time steps = 1cycle
    #10;

//------------------------------------------------------------------------------

  //Executing the second command
  // MOV R1, #2 ; this means, take the absolute number 2 and store it in R1

    //selects register 1
    writenum = 3'b001;
    //inputs number 2 to the datapath
    datapath_in = 16'd2;
    //selects the input from the first MUX
    vsel = 1'b1;
    //turn on write
    write = 1'b1;
    //waits for 10 time steps = 1 cycle
    #10;

//------------------------------------------------------------------------------

  //Executing the third command
  // ADD R2, R1, R0, LSL#1 ; this means R2 = R1 + (R0 shifted left by 1) = 2+14=16

  //Turning write OFF
    write = 1'b0;

  //Cycle1: load R0 in Register B
    readnum = 3'b000;
    loadb = 1'b1;
    #10;

  //Cycle2: load R1 in Register A
    //turning the laodb OFF
    loadb = 1'b0;
    readnum = 3'b001;
    loada = 1'b1;
    #10;

  //Cycle3: Compute the result and store it in C
    //shifting left by 1
    shift = 2'b01;
    asel = 1'b0;
    bsel = 1'b0;
    //Adding
    ALUop = 2'b00;
    //storing in register c
    loadc = 1'b1;
    #10;

  //Cycle4: Storing the result in r2
    //selecting register2
    writenum = 3'b010;
    write = 1'b1;
    vsel = 1'b0;
    #10;

//------------------------------------------------------------------------------

  //Now this command is to verify the output stored in Reg2
    //turning write OFF
    write = 1'b0;

    //turning read on for register2
    readnum = 3'b010;
    loada = 1'b1;
    #10;

    //Checking if the outout stored in reg2 is equal to 16
    if( dut.data_out !== 16'd16 ) begin
       $display("ERROR ** The data_out is %b, expected %b", dut.data_out, 16'b0000_0000_0001_0000 );
       err = 1'b1;
    end

    if( ~err ) $display("*THE TEST HAS BEEN PASSED*");
    $stop;

  end

endmodule
