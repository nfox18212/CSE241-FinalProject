 /**
  * File: dff-tb.sv
  *
  * Author1:  Nathan Fox (njfox4@buffalo.edo)
  * Author2:
  * Date:     2023-5-08
  * Partner:  N/A
  * Course:   CSE241 - Digital Systems
  *
  * Summary of File:
  * 
  *   Test the flip-flop, should be pretty self explanatory.
  */

  module dfftb;

  reg dtb, clk;
  wire qtb;

  dflipflop dff(dtb, clk, qtb);

  initial 
    begin
      $dumpfile("dff.vcd");
      $dumpvars;
      // standard test bench stuff, display vars, init everything, set up finish.  not much to say
      dtb = 0;
      clk = 0;
      $display("dtb \t clk |   qtb");
      $monitor(" %d  \t  %d  |    %d",dtb,clk,qtb);
     

      #15 $finish;
    end

  always
    begin
      #1 dtb = 1; clk = ~clk;
      #1 dtb = 0; clk = ~clk;
      #1 clk = ~clk;
    end

endmodule


