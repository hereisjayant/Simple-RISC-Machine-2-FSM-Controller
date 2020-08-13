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
 reg [2:0] op;
 reg [1:0] opcode;
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
      s= 1'b0; //stays in state sWait
      op = 3'b101;//op for MOV
      opcode = 2'b00;//sximm8 mov
      #10;

      s= 1'b1;
      #5; //turns on s for 1 Cycle

      s= 1'b0;
      #50;


      // check whether in expected state
      if( dut.present_state !== `sWait && dut.w !== 1'b1 ) begin // checks the reset
        $display("ERROR ** state is %b, expected %b",dut.present_state, `sWait );
        err = 1'b1;
      end



    if( ~err ) $display("PASSED");
    $stop;
    end

endmodule
