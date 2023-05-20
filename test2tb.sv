`define c clk

module test2tb;

  reg zbuttb, obuttb, secitb, enbltb;
  reg clk;
  wire reset, secvled, locked, unlocked;
  
  test2 obj(.ZBUT(zbuttb),
            .OBUT(obuttb),
            .ENBL(enbltb),
            .SECI(secitb),
            .RSTO(reset),
            .LOCK(locked),
            .ULCK(unlocked),
            .SECV(secvled),
            .CLK(clk)
          );

  initial 
    begin
      zbuttb = 0;
      obuttb = 1;
      secitb = 0;
      enbltb = 1;
      `c = 0;

      #5 $finish;

       // setup output display
      // $display("0but \t 1but \t seci \t enbl | \t state   ");
      // $monitor("%d \t %d \t %d \t %d | \t %s", 0buttb, 1buttb, secitb, enbltb, dispstr);
    end
  
  always
    begin
      #1 clk = ~clk;
    end


endmodule