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
  `define nodec 

  `ifdef nodec
    `define DIG0 'b000
    `define DIG1 'b001
    `define DIG2 'b011
    `define DIG3 'b010
    `define SECV 'b010
    `define RSTS 'b011
    `define _OFF 'b111
    `define OPEN 'b110
`endif

  module keypad(ZBUT, OBUT, SECI, ENBL, SECV, RSTO, LOCK, ULCK, CLK);

    input reg ZBUT;
    input OBUT;
    input SECI;
    input ENBL;
    input CLK;
    output reg RSTO, LOCK, ULCK, SECV;

    /* Variable that represents the three digits of our state */
    // wire [2:0] state;
    reg [2:0] state;

    /* These variables represent our current state, and are the result of taking the 
     * three output bits from the D flip-flops and are piped through to a 3 to 8 decoder.
     * As such, only one of these variables will ever be 1 at a time, and the one that is on will be our state. */
    `ifndef nodec 
    reg DIG0, DIG1, DIG2, DIG3, SECV, RSTS, _OFF, OPEN;
    `endif

    /* This variable will be passed into the flip-flop, and are the output of the combinational logic equations that
    *  essentially determine what state we are going to go into next.  */
   
    wire [2:0] ffin;

  initial
    begin
      /* default state of the system assumes that ENBL is 1, and SECI is 0, so a normal operating state. 
      *  As a result, */
      RSTO = 0;
      LOCK = 1;
      ULCK = 0;
      SECV = 0;

      `ifndef nodec
      // keypad starts in the DIG0 state
      DIG0 = 1; DIG1 = 0; DIG2 = 0; DIG3 = 0; SECV = 0; RSTS = 0; _OFF = 0;  OPEN = 0;
      `endif
      // the initial state will be 000 or DIG0
      // state = 'b000;
    end


    dflipflop dff1(ffin[0], CLK, state[0]);
    dflipflop dff2(ffin[1], CLK, state[1]);
    dflipflop dff3(ffin[2], CLK, state[2]);


    // ffin1 = D+ AC’ + AB + C’E’F + BEF’ + A’CEF’
    // A = state[0], B = state[1], C = state[2], D = SECI, E = OBUT, F = ZBUT
    // SECI + state[0] * state[2]' + state[2]' * OBUT' * ZBUT + state[1] * OBUT * ZBUT' + state[0]' * state[2] * OBUT * ZBUT'
    // see defines at start of fil
    // first digit of new state
    assign ffin[0] = `D | (`A & ~`C) | (`A & `B) | ((~`C) & (~`E) & `F) | (`B & `E & (~`F)) | ((~`A) & `C & `E & (~`F));
    // ffin2 = BE’ + BF + CE’F
    assign ffin[1] = (`B & (~`E)) | (`B & `F) | (`C & `E & (~`F));
    // ffin3 = AC'D' + ABD' + A'CD'F' + A'CD'E + BD'EF' + A’B’D’E’F
    assign ffin[2] = (`A & (~`C) & (~`D)) + (`A & `B & (~`D)) | ((~`A) & `C & (~`D) & (~`F)) | ((~`A) & `C & (~`D) & `E) | (`B & (~`D) & `E & (~`F)) | ((~`A) & (~`B) & (~`C) & (~`E) & `F);


    
    `ifndef nodec
     decoder3to8 decoder(state[0], state[1], state[2], DIG0, DIG1, DIG2, DIG3, SECV, RSTS, _OFF, OPEN);
    `endif

    always_ff@(posedge CLK)
      begin
        if(ENBL == 0) // If ENBL is low, system shuts down
          begin
            RSTO = 0;
            LOCK = 0;
            ULCK = 0;
            SECV = 0;
            // system goes into _OFF state, represented by 111
            // state = 'b111;
          end

        else 
          begin

            `ifdef nodec
            // change the outputs based on our state
            case(state)
            `DIG0, `DIG1, `DIG2, `DIG3 : begin
              SECV = 0;
              RSTO = 0;
              LOCK = 1;
              ULCK = 0;
            end
            `RSTS : begin
              
              LOCK = 1;
              ULCK = 0;
              SECV = 0;
              RSTO = 1;

            end

            `SECV : begin
              SECV = 1;
              ULCK = 0;
              LOCK = 1;
              RSTO = 0;
            end

            `OPEN : begin
              SECV = 0;
              ULCK = 1;
              LOCK = 0;
              RSTO = 0;
            end

            default:; // no default but should be fine maybe...?;
            endcase
            `endif
          end

      end

  endmodule