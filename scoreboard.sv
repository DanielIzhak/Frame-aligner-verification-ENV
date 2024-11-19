class scoreboard;
  
  
   // Define frame_aligner_state_e inside the scoreboard
  typedef enum logic [1:0] {
      FR_IDLE ,
      FR_HLSB ,
      FR_HMSB ,
      FR_DATA 
  } frame_aligner_state_e;

  mailbox monin2scb;
  mailbox monout2scb;
 
  
  int legal_frame_counter_scb = 0;
  int na_byte_counter_scb = 0;
  int fr_byte_position_scb ;
  frame_aligner_state_e expected_state = FR_IDLE;
  int num_transactions;
  int num_repeat_count;
  int recive_data;
  int frame_detect_scb;
  
  function new(mailbox monin2scb, mailbox monout2scb);
    this.monin2scb = monin2scb;
    this.monout2scb = monout2scb;
  endfunction

  task main;
    transaction transin;
    transaction transout;
    num_repeat_count++;

    forever begin
      
      monin2scb.get(transin);
      monout2scb.get(transout);
    
      case (expected_state)
        FR_IDLE: begin
          
          fr_byte_position_scb = 0;
          if(transin.rx_data == 8'hAA || transin.rx_data ==8'h55)
            begin
              //$display("print recive data : %h, FR_IDLE ",transin.rx_data);
              expected_state = FR_HLSB;
              recive_data = transin.rx_data;
              na_byte_counter_scb++;
            end 
          else begin
            na_byte_counter_scb++;
             if (na_byte_counter_scb == 47) begin
            na_byte_counter_scb = 0;
            frame_detect_scb = 1'b0;
                  expected_state = FR_IDLE;
      end    
          end
        end

        FR_HLSB: begin
 
          if((transin.rx_data == 8'hAF && recive_data == 8'hAA) || (transin.rx_data == 8'hBA && recive_data == 8'h55))
            begin
              //$display("print recive data : %h, FR_HLSB",transin.rx_data);
              expected_state = FR_HMSB;
              legal_frame_counter_scb++;
              //$display("print legal frame counter scb : %d",legal_frame_counter_scb);
              fr_byte_position_scb =1;
           //   if( legal_frame_counter_scb == 3)
             //   begin
          //frame_detect_scb = 1;
       // end
                   
          end
          else begin 
            legal_frame_counter_scb = 0;
             na_byte_counter_scb++;
            expected_state = FR_IDLE;   
            fr_byte_position_scb = 0;
        end
        end

        FR_HMSB: begin
                if( legal_frame_counter_scb == 3)
                begin
          frame_detect_scb = 1;
        end
                  expected_state = FR_DATA;
                  na_byte_counter_scb= 0;
                  fr_byte_position_scb++;    
         // $display("print recive data : %h, FR_HMSB,FR_byte position = %d ",transin.rx_data,fr_byte_position_scb);
              
        end
          
        FR_DATA: begin 
          
        if (fr_byte_position_scb == 11) begin
          if(transin.rx_data == 8'hAA || transin.rx_data ==8'h55)
            begin
          //    $display("print recive data : %h, FR_DATA ",transin.rx_data);
              expected_state = FR_HLSB;
              recive_data = transin.rx_data;
              fr_byte_position_scb = 0;
            end
              else begin
               expected_state = FR_IDLE;
               fr_byte_position_scb = 0;
               legal_frame_counter_scb = 0; 
                
              end
        end
        else begin
        fr_byte_position_scb++;
        expected_state = FR_DATA;  
        end
        end
      endcase
  
      
   //   if ((transout.frame_detect == frame_detect_scb) && (transout.fr_byte_position == fr_byte_position_scb)) begin
     //   $display("Scoreboard: frame_detect status as expected,frame_detect_scb =%d,frame_detect= %d,fr_byte_position_scb=%d,fr_byte_position=%d",frame_detect_scb,transout.frame_detect,fr_byte_position_scb,transout.fr_byte_position);
      //end
      //else begin 
        //$error("Scoreboard Error:frame detect mismach Expected %d, Got %d or fr_byte_position mismatch! Expected %d, Got %d, time = %t",frame_detect_scb,transout.frame_detect,fr_byte_position_scb,transout.fr_byte_position,$time);
      //end
   //end
    
      
      if ((transout.frame_detect != frame_detect_scb) || (transout.fr_byte_position != fr_byte_position_scb)) begin
       $error("Scoreboard Error:frame detect mismach Expected %d, Got %d or fr_byte_position mismatch! Expected %d, Got %d, time = %t",frame_detect_scb,transout.frame_detect,fr_byte_position_scb,transout.fr_byte_position,$time);
      end
   end    
    
    num_transactions++;
  endtask

endclass
