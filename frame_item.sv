class frame_item;

typedef enum bit [1:0] {HEAD_1, HEAD_2, ILLEGAL} header_type_t;
  
 rand header_type_t header_type;       // headet type
 rand bit [15:0] header;               //16 bits of header
 rand bit [7:0] payload[];     // daynme array for payload
  
  
     constraint header_value_c {
    if (header_type == HEAD_1) {
        header == 16'hAFAA;
    } else if (header_type == HEAD_2) {
        header == 16'hBA55;
    } else if (header_type == ILLEGAL) {
        header inside {[16'h0000 : 16'hFFFF]} &&
               header != 16'hAFAA && header != 16'hBA55; // ILLEGAL but not HEAD_1 or HEAD_2
    }
  }
  constraint header_type_c {
    header_type dist {HEAD_1 := 30, HEAD_2 := 30, ILLEGAL := 40};
  }
    constraint payload_c {
      if (header_type == HEAD_1 || header_type == HEAD_2)  
        payload.size() == 9;  
      else 
        payload.size() inside {[0:46]};
    foreach (payload[i]) payload[i] inside {[8'h00 : 8'hFF]}; 
}
    endclass
  