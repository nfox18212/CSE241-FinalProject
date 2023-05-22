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
  *   In an actual application of this keypad-on-a-safe system, the clock would not be external to the keypad, but for the purposes of this project it is simpler to just have the clock be external.
  * 
  *
  *   Mapping of state to number:
  *   DIG0: 000, DIG1: 001, DIG2: 011, DIG3: 010, SECV: 100, RSTS: 101, _OFF: 111, OPEN: 110
  */


  /* The following defines are purely to make it easier to write the formulas from the kmaps, and readability is second in this case */

  // `define ffnotstate
  `ifndef ffnotstate
  `define A state[2]
  `define B state[1]
  `define C state[0]
  
  `else
  `define A ffin[2]
  `define B ffin[1]
  `define C ffin[0]
  `endif

  `define D SECI
  `define E OBUT
  `define F ZBUT
  `define X ENBL

  `define chunkify // toggle declaring state equations through chunks or one large blob

  module keypad(ZBUT, OBUT, SECI, ENBL, SECO, RSTO, LOCK, ULCK, CLK, offin, ostate);


    input ZBUT, OBUT, SECI, ENBL, CLK;
    output wire RSTO, LOCK, ULCK, SECO;

    /* Variable that represents the three digits of our state */
    // wire [2:0] state;
    wire [2:0] state;


    /* This variable will be passed into the flip-flop, and are the output of the combinational 
    * logic equations that essentially determine what state we are going to go into next.  */
   
    wire [2:0] ffin;

    // purely for debugging purposes
    output wire [2:0] ostate;
    assign ostate[0] = state[0];
    assign ostate[1] = state[1];
    assign ostate[2] = state[2];

    // declare just a ton of chunks, 16 bc its a power of 2
    wire [15:0] chunk;

    output wire [2:0] offin;
    assign offin = ffin;

    dflipflop dff1(ffin[0], CLK, state[0]);
    dflipflop dff2(ffin[1], CLK, state[1]);
    dflipflop dff3(ffin[2], CLK, state[2]);


    // read defines to get mapping from letter to variable

    // ffin1 = c'e'f + d + a'cef' + bef' + ac' + ab
    `ifndef chunkify
    assign ffin[2] = (~`X) | (~`C & ~`E & `F) | (`D) | (~`A & `C & `E & ~`F) | (`B & `E & ~`F) | (`A & ~`C) | (`A & `B);
    `else
    // chunk things up so that the expressions are easier to read
    assign chunk[0] = ((~`C) & (~`E) & `F) | `D; // C'E'F + D
    assign chunk[1] = ~`A & `C & `E & ~`F; // A’CEF'
    assign chunk[2] =  `B & `E & ~`F; // BEF'
    assign chunk[3] =  `A & ~`C; // AC'
    assign chunk[4] =  `A & `B; // AB
    assign ffin[2]  = (~`X) | chunk[0] | chunk[1] | chunk[2] | chunk[3] | chunk[4];
    `endif

    `ifndef chunkify
    // ffin2 = x’+a'cd'e'f + a'bd'e' + a'bd'f
    assign ffin[1] = (~`X) | (~`A & `C & ~`D & ~`E & `F) | (~`A & `B & ~`D & ~`E) | (~`A & `B & ~`D & `F);
    `else
    assign chunk[5] = ~`A & `C & ~`D & ~`E & `F; // a'cd'e'f 
    assign chunk[6] = (~`A & `B & ~`D & ~`E); // a'bd'e'
    assign chunk[7] = (~`A & `B & ~`D & `F); // a'bd'f
    assign ffin[1]  = (~`X) | chunk[5] | chunk[6] | chunk[7];
    `endif

    `ifndef chunkify
    // ffin3 = X’+ac'd' + ab + a'b'd'e'f + a'd'ef' + a'cd'f' + a'cd'e
    assign ffin[0] = (~`X) | (`A & ~`C & ~`D) | (`A & `B) | (~`A & ~`B & ~`D & ~`E & `F) | (~`A & ~`D & `E & ~`F) | (~`A & `C & ~`D & ~`F) | (~`A & `C & ~`D & `E);
    `else
    assign chunk[8] =  `A & ~`C & ~`D; // AC'D'
    assign chunk[9] =  `A & `B; //AB
    assign chunk[10]= ~`A & ~`B & ~`D & ~`E & `F; // A'B'D'E'F
    assign chunk[11]= ~`A & ~`D & `E & ~`F; // A'D'EF'
    assign chunk[12]= ~`A & `C & ~`D & ~`F; // A'CD'F'
    assign chunk[13]= ~`A & `C & ~`D & `E; // A'CD'E 
    assign ffin[0]  = ~`X | chunk[8] | chunk[9] | chunk[10] | chunk[11] | chunk[12] | chunk[13];
    `endif

    // output equations
    assign LOCK = (~`B) | (~`A);
    assign ULCK = `A & `B & (~`C);
    assign RSTO = `A & (~`B) & `C;
    assign SECO = `A & (~`B) & (~`C);

    // null the rest of the chunk var out
    assign chunk[15:14] = 0;


  endmodule