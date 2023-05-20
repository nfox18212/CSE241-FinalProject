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
// `define print
`define nodump

module fsmtb;
  reg zbuttb, obuttb, secitb, enbltb;
  reg clk;
  wire reset, seled, locked, unlocked;
  wire [2:0] fftb, ostatetb;
  reg  [2:0] dispstr;
  int testno;

  // keypad fsm(zbuttb, zbuttb, secitb, enbltb,  reset, locked, unlocked, clk);
    keypad fsm(.ZBUT(zbuttb),
            .OBUT(obuttb),
            .ENBL(enbltb),
            .SECI(secitb),
            .RSTO(reset),
            .LOCK(locked),
            .ULCK(unlocked),
            .SECV(secvled),
            .CLK(clk),
            .ostate(ostatetb),
            .offin(fftb)
          );

  
  initial 
    begin
      // set initial state
      zbuttb = 0; obuttb = 0; secitb = 0; enbltb = 1;
      clk = 0;

      `ifndef nott
      // setup output display
      $display("obuttb zbuttb  seci   enbl\tclk |  lock\tulck\tsecv\trsto\tostatetb  fftb");
      $monitor("%d \t %d \t %d \t %d \t %d  |  %d\t%d\t%d\t  %d\t %d%d%d\t  %d%d%d",obuttb, zbuttb, secitb, enbltb, clk, locked, unlocked, secvled, reset, ostatetb[0], ostatetb[1], ostatetb[2], fftb[0], fftb[1], fftb[2]);
      `endif

      `ifndef nodump
      // setup wave output
      $dumpfile("fsmtb.vcd");
      $dumpvars;
      `endif

      // test no changes which test we run in the always block
      testno = 0;

      // stop simulation
      #30 $finish;
    end

  always 
    begin
      if(testno <= 1)
        begin
          // esnure clock is 0
          clk = 0;
          // start with attempting to enter a correct combination, so 1000 - set obuttb to 1
          obuttb = 1;
          // read with clock
          #1 clk = 1;
          #1 clk = 0;
          #1 clk = 1;
          // change button inputs so that obuttb is pressed instead
          obuttb = 0; zbuttb = 1;
          #1 clk = 0;
          #1 clk = 1;
          // one zero read
          #1 clk = 0;
          #1 clk = 1;
          // two zeroes read
          #1 clk = 0;
          #1 clk = 1;
          // three zeroes read, should be unlocked

          `ifdef print
          if (unlocked == 1 && locked == 0)
            begin
              $display("Safe unlocked properly");
            end
          else
            begin
              $display("Safe did not unlock properly");
            end
          `endif
          zbuttb = 0; obuttb = 0; testno += 1;
        end
      else if (testno > 1 && testno <= 3)
        begin
          
          // see if the system will correctly reset when a bad pattern is put in
          #1 clk = 0;
          #1 obuttb = 1; zbuttb = 0; // 1
          #1 clk = ~clk; // 1
          #1 clk = ~clk; // 0
          #1 obuttb = 0; zbuttb = 1;
          #1 clk = ~clk; // 1
          #1 clk = ~clk; // 0
          #1 clk = ~clk; // 1 - system read in 100, pass in 1
          #1 clk = ~clk; // 0
          #1 obuttb = 1; zbuttb = 0;
          #1 clk = ~clk; // 1 - system has read in 1001, determine state

          `ifdef print
          if (reset == 1)
            begin
              $display("Keypad correctly reset");
            end
          else 
            begin
              $display("Keypad did not reset");
            end
          `endif
          obuttb = 0; zbuttb = 0; testno += 1;
        end
      end
    

endmodule