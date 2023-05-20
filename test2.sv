module test2(ZBUT, OBUT, SECI, ENBL, SECV, RSTO, LOCK, ULCK, CLK);

    input reg ZBUT;
    input reg OBUT;
    input SECI;
    input ENBL;
    input CLK;
    output RSTO, LOCK, ULCK, SECV;
    wire dig0;

    and(RSTO, ZBUT, OBUT);
    nand(dig0, ZBUT, OBUT);

    initial
      begin
        
      end

endmodule