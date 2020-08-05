

module datapath(datapath_in,  //input to datapath

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

//-------------------------------------------------------------

  //inputs and outputs

    input [15:0] datapath_in;  //input to datapath

    input vsel; //input to the first multiplexer b4 regfile

    input [2:0] writenum;  //inputs to register file
    input write;
    input [2:0] readnum;
    input clk;

    input loada;  //pipeline registers a & b
    input loadb;

    input [1:0] shift; //input to shifter unit

    input asel;   //source opperand multiplexers
    input bsel;

    input [1:0] ALUop;  //ALU input

    input loadc;  //pipeline c
    input loads; //status register

    output Z_out;  //status output
    output [15:0] datapath_out; //datapath output

//--------------------------------------------------------------

  //Wires

    //into the regfile
    wire [15:0] data_in;
    //out of regfile
    wire [15:0] data_out;

    //wire out of LoadA (3->6)
    wire [15:0] loadaToMux;

    //wire into shifter
    wire [15:0] in;
    //wire out of shifter
    wire [15:0] sout;

    //wires into ALU
    wire[15:0] Ain, Bin;
    //wires out of the ALU
    wire Z;
    wire[15:0]out;


//------------------------------------------------------------------

    //instantiating the main datapath Modules
    regfile REGFILE(data_in,writenum,write,readnum,clk,data_out);

    ALU alu(Ain,Bin,ALUop,out,Z);

    shifter SHIFTER(in,shift,sout);

//------------------------------------------------------------------

  //following is the code for the remaining logical blocks
  //check figure 1 of lab 5 for the numerical codes of the components
  //NOTE: the vDFFE is defined in the regfile.v file

  //Registers
    //Component3: Loada register
    vDFFE #(16) RegLoadA(.clk(clk), .en(loada),
                         .in(data_out), .out(loadaToMux));

   //Component4: Loadb register
   vDFFE #(16) RegLoadB(.clk(clk), .en(loadb),
                        .in(data_out), .out(in));

   //Component5: Loadc register
   vDFFE #(16) RegLoadC(.clk(clk), .en(loadc),
                        .in(out), .out(datapath_out));

   //Component10: Status register
   vDFFE #(1) RegStatus(.clk(clk), .en(loads),
                        .in(Z), .out(Z_out));

  //Multiplexers
    //Component9: Multiplexer before the regfile
    Mux2a #(16) BeforeRegfile(.a1(datapath_in), .a0(datapath_out),
                              .s(vsel), .b(data_in));

    //Component6: Multiplexer after LoadA
    Mux2a #(16) toAin(.a1(16'b0), .a0(loadaToMux),
                              .s(asel), .b(Ain));

    //Component7: Multiplexer after LoadB and shifter
    Mux2a #(16) toBin(.a1({11'b0,datapath_in[4:0]}), .a0(sout),
                              .s(bsel), .b(Bin));

//--------------------------------------------------------------

endmodule



//-------------------------------------------------------------------

  //following are the modules made for the datapath

  module Mux2a(a1, a0, s, b);
   parameter k = 1 ;
   input [k-1:0] a0, a1;  // inputs
   input s ; // one-hot select
   output[k-1:0] b ;

   assign b = (s) ? a1 : a0;


endmodule
