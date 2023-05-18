 /**
  * File: decoder.sv
  *
  * Author1:  Nathan Fox (njfox4@buffalo.edo)
  * Author2:
  * Date:     2023-05-08
  * Partner:  N/A
  * Course:   CSE241 - Digital Systems
  *
  * Summary of File:
  * 
  * This file encapsulates a 1:2 decoder up to a 3:8 decoder.  This is the same code from Lab 6 just
  * encapsulated all into one file.
  */


module decoder1to2(EN,i,o1,o2);
  // declare variables
  input i, EN;
  output o1,o2;
  wire not1;
  
  not(not1,i); // o1 will always be inverse of i, as long as EN is 1
  and(o1,not1,EN);
  
  
  // o2 will always be whatever i, but needs ENABLE to be active
  and(o2,i,EN);
  
  
endmodule

module decoder2to4(EN,i1,i2,o1,o2,o3,o4);
  // declare variables
  input i1,i2,EN;
  output o1,o2,o3,o4;

  // we are appling shannons expansion theorem, using i2 as the enable
  decoder1to2 name(i2', i1, o1, o2);
  decoder1to2 name(i2, i1, o3, o4);


endmodule



module decoder3to8(i1,i2,i3,o1,o2,o3,o4,o5,o6,o7,o8);

    input i1, i2, i3;
    output o1,o2,o3,o4,o5,o6,o7,o8;

    // using shannon's expansion theory, making 3:8 out of 2:4 decoders and using i3 as Enable
    decoder2to4 name(i3', i1, i2, o1, o2, o3, o4);
    decoder2to4 name(i3 , i1, i2, o5, o6, o7, o8);
endmodule