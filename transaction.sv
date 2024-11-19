class transaction;
  rand bit [7:0] rx_data;
 // Output fields from monitor_out
  bit [3:0] fr_byte_position;          // Byte position in a valid frame
  bit frame_detect;  // Frame alignment detection signal
  // display function
 function void display(string name);
   
   
   $display("---- transaction: %s ----", name);
   $display("rx_data = %h, Frame Detect = %b, Byte Position = %0d",rx_data, frame_detect, fr_byte_position);
  endfunction
 

endclass

