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
  reg 0BUTtb, 1BUTtb, SECItb, ENBLtb;
  wire [3:0] state