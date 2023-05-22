 /**
  * File: fsm-tb.sv
  *
  * Author1:  Nathan Fox (njfox4@buffalo.edo)
  * Author2:
  * Date:     2023-5-08
  * Partner:  N/A
  * Course:   CSE241 - Digital Systems
  *
  * Summary of File:
  * 
  *   This file will instantiate the keypad module and actually implement it, while also 
  *   providing a clock signal to the keypad.  
  */
//  `define nott
`define print
// `define nodump
// `define dbg // enable this macro for debugging output
`define tick #1 clk = ~clk;

`timescale 1ms/1ms

module fsmtb;
  reg zbuttb, obuttb, secitb, enbltb;
  reg clk;
  wire reset, seled, locked, unlocked;
  wire [2:0] fftb, ostatetb;

    keypad fsm(.ZBUT(zbuttb),
            .OBUT(obuttb),
            .ENBL(enbltb),
            .SECI(secitb),
            .RSTO(reset),
            .LOCK(locked),
            .ULCK(unlocked),
            .SECO(secvled),
            .CLK(clk)
            `ifdef dbg
            , // yes i know this syntax is atrocious, and that i'm abusing define macros, but it works and it makes it easy to go from debugging mode to release mode
            .ostate(ostatetb),
            .offin(fftb)
            `endif
          );

  
  initial 
    begin
      // set initial state
      zbuttb = 0; obuttb = 0; secitb = 0; enbltb = 1;
      clk = 0;

      `ifndef nott
      // setup output display
      `ifdef dbg
      $display("seci   obuttb zbuttb  enbl\tclk |  lock\tulck\tseco\trsto\tostatetb  fftb");
      $monitor("%d \t %d \t %d \t %d \t %d  |  %d\t%d\t%d\t  %d\t %d%d%d\t  %d%d%d", secitb, obuttb, zbuttb, enbltb, clk, locked, unlocked, secvled, reset, ostatetb[0], ostatetb[1], ostatetb[2], fftb[0], fftb[1], fftb[2]);
      `else
      $display("seci  obuttb zbuttb   enbl\tclk |  lock\tulck\tseco\trsto");
      $monitor("%d \t %d \t %d \t %d \t %d  |  %d\t%d\t%d\t  %d\t", secitb ,obuttb, zbuttb, enbltb, clk, locked, unlocked, secvled, reset);
      `endif
      `endif
      

      `ifndef nodump
      // setup wave output
      $dumpfile("fsmtb.lxt");
      $dumpvars;
      `endif

      // stop simulation
      #100 $finish;
    end

  always 
    begin
        `tick; obuttb = 1; enbltb = 1; secitb = 0;
        `tick; 
        `tick; obuttb = 0;
        `tick; 
        `tick;
        `tick; zbuttb = 1;
        `tick; 
        `tick; 
        `tick;
        `tick;
        `tick; zbuttb = 0;
        `tick;
        `tick; enbltb = 0;
        `tick;
        `tick;
        `tick; enbltb = 1;
        `tick;
        `tick;
        `tick; secitb = 1;
        `tick;
        `tick;
        `tick;
        `tick;
        `tick; secitb = 0;
        `tick;
        `tick; 
        `tick;
        `tick; obuttb = 1;
        `tick; 
        `tick; obuttb = 0;
        `tick; 
        `tick;
        `tick; zbuttb = 1;
        `tick; 
        `tick;
        `tick; zbuttb = 0;
        `tick;
        `tick;
        `tick;
        `tick; zbuttb = 1; obuttb = 1;
        `tick;
        `tick;
        `tick;
        `tick; zbuttb = 0;
        `tick;
        `tick;
        `tick; secitb = 1;
        `tick;
        `tick;
        `tick; 
        `tick; enbltb = 0;
        `tick; enbltb = 1;
        `tick; enbltb = 0;
        `tick;
        `tick; 
        `tick;


      end
    

endmodule