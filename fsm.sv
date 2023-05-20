 /**
  * File: fsm.sv
  *
  * Author1:  Nathan Fox (njfox4@buffalo.edo)
  * Author2:
  * Date:     2023-5-08
  * Partner:  N/A
  * Course:   CSE241 - Digital Systems
  *
  * Summary of File:
  * 
  *   This is the top-level file that represents the complete finite state machine
  *   for the final lab.  The report details the design of the state machine in more detail,
  *   but to keep it short it essentially loops in a state DIG0 until one of four things happen:
  *   A) the correct first digit (1) of the passcode (1000) is entered, moving to state DIG1
  *   B) the incorrect first digit (0) of the passcode is entered, moving to the reset state RSTS
  *   C) the ENABLE input is turned off, shutting the whole system down and moving into _OFF
  *   D) a security violation is triggered, moving into the Security Violation state.  This pattern continues 
  *   until the passcode has been entered completely correctly and the system moves into OPEN.  After one clock pulse in OPEN,
  *   the system will move back into reset state and then back into DIG0.
  *   
  *   This FSM keypad will use 3 flip-flops to cycle between 7 different states.  The ENABLE state does not need
  *   to be handled with the D-flip-flops and can be easily handled with a if-else block since it does not care
  *   about the current state.  
  * 
  *   In an actual application of this keypad-on-a-safe system, the clock would not be external to the keypad, but for the purposes of this
  *   project it is simpler to just have the clock be external.
  * 
  *
  *   Mapping of state to number:
  *   DIG0: 000, DIG1: 001, DIG2: 011, DIG3: 010, SECV: 100, RSTS: 101, _OFF: 111, OPEN: 110
  */


  /* The following defines are purely to make it easier to write the formulas from the kmaps, and readability is second in this case */
  `define A state[0]
  `define B state[1]
  `define C state[2]
  `define D SECI
  `define E OBUT
  `define F ZBUT


  module keypad(ZBUT, OBUT, SECI, ENBL, SECV, RSTO, LOCK, ULCK, CLK, offin, ostate);

    input ZBUT, OBUT, SECI, ENBL, CLK;
    output wire RSTO, LOCK, ULCK, SECV;

    /* Variable that represents the three digits of our state */
    // wire [2:0] state;
    wire [2:0] state;

    // purely for debugging purposes
    output wire [2:0] ostate;
    assign ostate[0] = state[0];
    assign ostate[1] = state[1];
    assign ostate[2] = state[2];

    output wire [2:0] offin;
    assign offin = ffin;

    /* This variable will be passed into the flip-flop, and are the output of the combinational 
    * logic equations that essentially determine what state we are going to go into next.  */
   
    wire [2:0] ffin;


    dflipflop dff1(ffin[0], CLK, state[0]);
    dflipflop dff2(ffin[1], CLK, state[1]);
    dflipflop dff3(ffin[2], CLK, state[2]);


    // ffin1 = D+ AC’ + AB + C’E’F + BEF’ + A’CEF’
    // first digit of new state
    assign ffin[0] = `D | (`A & ~`C) | (`A & `B) | ((~`C) & (~`E) & `F) | (`B & `E & (~`F)) | ((~`A) & `C & `E & (~`F));
    // ffin2 = BE’ + BF + CE’F
    assign ffin[1] = (`B & (~`E)) | (`B & `F) | (`C & `E & (~`F));
    // ffin3 = AC'D' + ABD' + A'CD'F' + A'CD'E + BD'EF' + A’B’D’E’F
    assign ffin[2] = (`A & (~`C) & (~`D)) + (`A & `B & (~`D)) | ((~`A) & `C & (~`D) & (~`F)) | ((~`A) & `C & (~`D) & `E) | (`B & (~`D) & `E & (~`F)) | ((~`A) & (~`B) & (~`C) & (~`E) & `F);

    // continuous assignment was the least painful, all equations are derived on spreadsheet
    assign LOCK = (~`B) | (~`A);
    assign ULCK = `A & `B & (~`C);
    assign RSTO = `A & (~`B) & `C;
    assign SECV = `A & (~`B) & (~`C);

  endmodule