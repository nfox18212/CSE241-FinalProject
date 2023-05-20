`define thing 'b1111

module testtb;

  reg[3:0] arr_tb;
  wire[3:0] out_tb;
  int i;

  // Instantiate the design module
  test tb(arr_tb, out_tb);

  // Add testbench logic
  initial begin
    // Drive inputs
    arr_tb = 4'b0111;
    i = 0;

    // Display outputs
    $monitor("arr = %b, out = %b", tb.arr, tb.out);

    #18 $finish;
  end

  initial
    begin
    #1
    $dumpfile("testfile.vcd");
    $dumpvars(0, testtb);
    end
  
  always
    begin
      #1 i += 1;
      $display("i = %d",i);

      


    end

endmodule
