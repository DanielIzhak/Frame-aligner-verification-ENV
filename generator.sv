`include "transaction.sv"
`include "frame_item.sv"

class generator;
  
  //declare transaction class 
  transaction trans;
  frame_item frame;
  
  //repeat count, to indicate number of items to generate
  int  repeat_count;
  
  //declare mailbox, to send the packet to the driver
  mailbox gen2drv;
  
  //declare event, to indicate the end of transaction generation
  event ended;
  
  //constructor
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
    this.frame = new();
  endfunction
   
  task main();
    repeat(repeat_count) begin
      trans = new();
      
     
      //if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      if( !frame.randomize()) $fatal("Gen:: trans randomization failed");
      

      trans.display("[ --Generator-- ]");
      gen2drv.put(trans);
    
      trans = new();
      trans.rx_data <= frame.header[7:0];
      gen2drv.put(trans);
      
      trans = new();
      trans.rx_data <= frame.header [15:8];
      gen2drv.put(trans);
      
      foreach(frame.payload[i]) begin 
        trans = new();
        trans.rx_data <= frame.payload[i];
       gen2drv.put(trans);
      end
      
    end
    -> ended; //trigger end of generation
  endtask
  
endclass

