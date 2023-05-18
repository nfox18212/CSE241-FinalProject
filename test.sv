`define thing 'b1111




module test(arr, out);


  
  input reg[3:0] arr;
  output reg[3:0] out = 'b0111;


  always
    begin
        #1
        out = arr ~^ out;
        case(out)
        `thing : 
          begin
            $display("boo");
          end
          default : $display("oob");
        endcase

        `ifdef thing
          out = ~out;
        `endif
    end



endmodule