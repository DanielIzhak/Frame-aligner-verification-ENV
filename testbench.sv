//include interfcae 
`include "interface.sv"

//include one test at a time
`include "random_test.sv"
//`include "directed_test.sv"

module top;
  
  //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset generation
  initial begin
    reset = 1;
    #15 reset =0;
    
 
  end
  
  
  //interface instance in order to connect DUT and testcase
  inf i_inf(clk,reset);
  
  //testcase instance, interface handle is passed to test 
  test t1(i_inf);
  
  //DUT instance, interface handle is passed to test 
  //frame_aligner a1(i_inf);
  //frame_aligner DUT(
    //.clk(clk),
    //.reset(reset),
    //.rx_data(i_inf.rx_data),
    //.fr_byte_position(i_inf.fr_byte_position),
    //.frame_detect(i_inf.frame_detect));
  frame_aligner a1(i_inf);
  
initial begin 
  $dumpfile("dump.vcd");
  $dumpvars(2);
end
  
endmodule
