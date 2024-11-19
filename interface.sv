interface inf(input logic clk, reset);
  logic [3:0] fr_byte_position; // Byte position in a legal frame
  logic frame_detect;           // Frame alignment indication
  logic [7:0] rx_data;

  modport DUT(input clk, reset, rx_data, output fr_byte_position, frame_detect);

 // Covergroup to track byte positions
  covergroup byte_position_tracking_cg;
    coverpoint fr_byte_position {
      bins valid_byte_tracking[] = {[0:11]};
      ignore_bins invalid_positions = {[12:15]};
    }
  endgroup

  byte_position_tracking_cg byte_position_tracking_cg_inst;

  // Sequences for detecting headers
  sequence header_1;
    (rx_data == 8'hAA) ##1 (rx_data == 8'hAF);
  endsequence

  sequence header_2;
    (rx_data == 8'h55) ##1 (rx_data == 8'hBA);
  endsequence
  

  // Property for valid frame detection
  property valid_frame1;
    @(posedge clk) 
    disable iff (reset)
    (fr_byte_position == 0) ##1 header_1 ##11 header_1 ##11 header_1 |=> (frame_detect == 1);
  endproperty
  
    assert property (valid_frame1)
      else $error("Error: frame_detect did not rise after three valid       headers in time: %0t", $time);
      valid_frame_1_inst: cover property (valid_frame1);

  property valid_frame2;
    @(posedge clk) 
    disable iff (reset)
    (fr_byte_position == 0) ##1 header_1 ##11 header_2 ##11 header_1 |=> (frame_detect == 1);
  endproperty 
        
    assert property (valid_frame2)
    else $error("Error: frame_detect did not rise after three valid headers in time: %0t", $time);
     valid_frame_2_inst: cover property (valid_frame2);
       
        
        
        
  property valid_frame3;
    @(posedge clk) 
    disable iff (reset)
    (fr_byte_position == 0) ##1 header_2 ##11 header_2 ##11 header_2 |=> (frame_detect == 1);
  endproperty  
        
        assert property (valid_frame3)
      else $error("Error: frame_detect did not rise after three valid headers in time: %0t", $time);
          valid_frame_3_inst: cover property (valid_frame3);

            
            
  property valid_frame4;
    @(posedge clk) 
    disable iff (reset)
    (fr_byte_position == 0) ##1 header_2 ##11 header_2 ##11 header_1 |=> (frame_detect == 1);
  endproperty  
        
            assert property (valid_frame4)
              else $error("Error: frame_detect did not rise after three valid headers in time: %0t", $time);
              valid_frame_4_inst: cover property (valid_frame4);
            
            
property valid_frame5;
    @(posedge clk) 
    disable iff (reset)
  (fr_byte_position == 0) ##1 header_2 ##11 header_1 ##11 header_2 |=> (frame_detect == 1);
  endproperty  
        
                assert property (valid_frame5)
      else $error("Error: frame_detect did not rise after three valid headers in time: %0t", $time);
   valid_frame_5_inst: cover property (valid_frame5);
                    
                  
property valid_frame6;
    @(posedge clk) 
    disable iff (reset)
       (fr_byte_position == 0) ##1 header_1 ##11 header_2 ##11 header_2 |=> (frame_detect == 1);
  endproperty  
        
     assert property (valid_frame6)
      else $error("Error: frame_detect did not rise after three valid headers in time: %0t", $time);      
         
         
property invalid_byte1;
    @(posedge clk) 
    disable iff (reset)
  (frame_detect == 0) ##1 (header_1 or header_2) ##11 (rx_data == 8'hAA or rx_data == 8'hAF) ##1 (header_1 or header_2) ##11 (header_1 or header_2);
  endproperty  
        
     assert property (invalid_byte1)
       else $error("Error:invlaid byte1 time: %0t", $time);
       invalid_byte1_inst: cover property (invalid_byte1);        
         
         
          
      
  // Coverage instance for valid_frame1
  initial begin
    byte_position_tracking_cg_inst = new();
    forever @(posedge clk) begin
      byte_position_tracking_cg_inst.sample();
    end
  end

endinterface
