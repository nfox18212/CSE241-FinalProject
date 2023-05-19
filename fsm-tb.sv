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

module fsmtb;
  reg 0buttb, 1buttb, secitb, enbltb;
  reg clk;
  wire reset, seled, locked, unlocked;
  reg  [2:0] dispstr;
  int testno;

  keypad fsm(0buttb, 1buttb, enbltb, secitb, reset, locked, unlocked, clk);
  
  initial 
    begin
      // set initial state
      0buttb = 0; 1buttb = 0; secitb = 0; enbltb = 1;
      clk = 0;

      // setup output display
      $display("0but \t 1but \t seci \t enbl | \t state   ");
      $monitor("%d \t %d \t %d \t %d | \t %s", 0buttb, 1buttb, secitb, enbltb, dispstr);

      // setup wave output
      $dumpfile("fsmtb.vcd");
      $dumpvars;

      // test no changes which test we run in the always block
      testno = 0;

      // stop simulation
      #120 $finish;
    end

  always 
    begin
      if(testno <= 1)
        begin
          // tests the 
          #1 clk = ~clk; // 1
          // start with attempting to enter a correct combination, so 1000
          #1 1buttb = 1; // 1but = 1, 0but = 0
          #1 clk = ~clk; // 0
          #1 clk = ~clk; // 1
          #1 1buttb = 0; 0buttb = 1; // 
          // no need to keep setting 1but to 0, and 0but to 1.  just update the clock
          #1 clk = ~clk; // 0
          #1 clk = ~clk; // 1
          #1 clk = ~clk; // 0
          #1 clk = ~clk; // 1

          if (unlocked == 1 && locked == 0)
            begin
              $display("Safe unlocked properly");
            end
          else
            begin
              $display("Safe did not unlock properly");
            end

          1buttb = 0; 0buttb = 0; testno += 1;
        end
      // else if (testno > 1 && testno <= 3)
    end

endmodule