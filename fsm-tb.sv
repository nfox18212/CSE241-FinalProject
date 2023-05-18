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
  wire [2:0] statetb; // declare array of len 3 to use for state
  reg [2:0] dispstr;
  
  //
  initial 
    begin
      // set initial state
      0buttb = 0; 1buttb = 0; secitb = 0; enbltb = 1;
      clk = 0;
      // setup formatting to print array all at once
      dispstr = $sformatf("%p", state);

      // setup output display
      $display("0but \t 1but \t seci \t enbl | \t state   ");
      $monitor("%d \t %d \t %d \t %d | \t %s", 0buttb, 1buttb, secitb, enbltb, dispstr);
    end
    

endmodule