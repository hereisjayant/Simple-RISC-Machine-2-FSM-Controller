// state encoding for control FSM
`define SW          5
`define sWait       5'd0
`define sDecode     5'd1
`define sGetB       5'd2
`define sGetA       5'd3
`define sAND_ADD    5'd4
`define sMVN_MOV    5'd5
`define sGetStatus  5'd6
`define sResultToRd 5'd7
`define sMovImToRn  5'd8


module control_tb();

//Regs and Wires
 reg err;
 reg clk;
 reg reset;
 reg s;
 reg [2:0] opcode;
 reg [1:0] op;
               //input to the first multiplexer b4 regfile
 wire [1:0] vsel;
               //input to the REGFILE
 wire write;
               //pipeline registers a & b
 wire loada;
 wire loadb;
               //Select to mux before ALU
 wire asel;
 wire bsel;
               //pipeline c
 wire loadc;
               //status register
 wire loads;
               //Use the 1-HOT-select for Rn | Rd | Rm
 wire [2:0] nsel;
               //signal for wait state
 wire w;

//------------------------------------------------------------------------------

  //instantiating the dut
  control dut(   //inputs to fsm
                clk,
                reset,
                s,
                opcode,
                op,
                    //input to the first multiplexer b4 regfile
                vsel,
                    //input to the REGFILE
                write,
                    //pipeline registers a & b
                loada,
                loadb,
                    //Select to mux before ALU
                asel,
                bsel,
                    //pipeline c
                loadc,
                    //status register
                loads,
                    //Use the 1-HOT select for Rn | Rd | Rm
                nsel,
                    //signal for wait state
                w);

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
      reset = 1'b0; //resets the FSM to sWait
      s= 1'b0; //stays in state in the begining

//------------------------------------------------------------------------------

    //testing ADD operation
      opcode = 3'b101;
      op = 2'b00;
      #10;

      s= 1'b1;
      #10; //turns on s for 1 Cycle
      s= 1'b0;
      #60;//turns s off for 6 cycles


      // check whether in expected state
      if( dut.w !== 1'b1 ) begin // checks the reset
        $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
        err = 1'b1;
      end

    if( ~err ) $display("PASSED the test for ADD command");
    else $stop;

//------------------------------------------------------------------------------
   //testing MVN Rd,Rm{,<sh_op>} operation
     opcode = 3'b101;
     op = 2'b11;
     #10;

     s= 1'b1;
     #10; //turns on s for 1 Cycle
     s= 1'b0;
     #50;//turns s off for 5 cycles


     // check whether in expected state
     if( dut.w !== 1'b1 ) begin // checks the reset
       $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
       err = 1'b1;
     end

    if( ~err ) $display("PASSED the test for MVN Rd,Rm{,<sh_op>} command");
    else $stop;


//------------------------------------------------------------------------------

   //testing MOV Rn,#<im8> operation
     opcode = 3'b110;
     op = 2'b10;
     #10;

     s= 1'b1;
     #10; //turns on s for 1 Cycle
     s= 1'b0;
     #20;//turns s off for 2 cycles


     // check whether in expected state
     if( dut.w !== 1'b1 ) begin // checks the reset
       $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
       err = 1'b1;
     end

    if( ~err ) $display("PASSED the test for MOV Rn,#<im8> command");
    else $stop;


//------------------------------------------------------------------------------

  //testing CMP Rn,Rm{,<sh_op>}  operation
    opcode = 3'b101;
    op = 2'b01;
    #10;

    s= 1'b1;
    #10; //turns on s for 1 Cycle
    s= 1'b0;
    #50;//turns s off for 5 cycles


    // check whether in expected state
    if( dut.w !== 1'b1 ) begin // checks the reset
      $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
      err = 1'b1;
    end

   if( ~err ) $display("PASSED the test for CMP Rn,Rm{,<sh_op>}  command");
   else $stop;


//------------------------------------------------------------------------------

  //testing MOV Rd,Rm{,<sh_op>}  operation
    opcode = 3'b110;
    op = 2'b00;
    #10;

    s= 1'b1;
    #10; //turns on s for 1 Cycle
    s= 1'b0;
    #50;//turns s off for 5 cycles


    // check whether in expected state
    if( dut.w !== 1'b1 ) begin // checks the reset
      $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
      err = 1'b1;
    end

   if( ~err ) $display("PASSED the test for MOV Rd,Rm{,<sh_op>}  command");
   else $stop;


//------------------------------------------------------------------------------

  //testing AND Rd,Rn,Rm{,<sh_op>}  operation
    opcode = 3'b101;
    op = 2'b10;
    #10;

    s= 1'b1;
    #10; //turns on s for 1 Cycle
    s= 1'b0;
    #50;//turns s off for 5 cycles


    // check whether in expected state
    if( dut.w !== 1'b1 ) begin // checks the reset
      $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
      err = 1'b1;
    end

   if( ~err ) $display("PASSED the test for AND Rd,Rn,Rm{,<sh_op>}  command");
   else $stop;


//------------------------------------------------------------------------------

    $display("**PASSED ALL TESTS**");
    $stop;
    end

endmodule
