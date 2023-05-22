 /**
  * File: dflipflop.sv
  *
  * Author1:  Nathan Fox (njfox4@buffalo.edo)
  * Author2:
  * Date:     2023-5-08
  * Partner:  N/A
  * Course:   CSE241 - Digital Systems
  *
  * Summary of File:
  * 
  * This file implements the basic functionality of a dflip-flop.  It has the inputs 
  * D and CLK and outputs.  Heavily based on the code from lecture 31.  D is D, CLK is the
  * clock input, Q is output.  Clear, Preset, and Q0 (Qnot) are not required for the purposes of this project.
  */



module dflipflop(D, CLK, Q);

  input reg D, CLK;
  output reg Q;
  
  initial
    begin
        Q = 0;
    end

  always@(posedge CLK)
    begin
        Q <= D;
    end



endmodule