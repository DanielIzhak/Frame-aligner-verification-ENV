
class monitor_in;

  virtual inf vinf;                 // Virtual interface to connect to the DUT
  mailbox monin2scb;
  
  // Constructor to initialize virtual interface and mailbox
  function new(virtual inf vinf, mailbox monin2scb);
    this.vinf = vinf;
    this.monin2scb = monin2scb; 
  endfunction
  
  

  // Main monitoring task
  task main;
    transaction trans;
    forever begin
      trans = new();
      
      // Capture 16 bits of header (8 bits at a time)
      @(negedge vinf.clk) begin
      trans.rx_data = vinf.rx_data; end   // Capture the upper 8 bits of the header      
      trans.display("[-- Monitor In --]");

      // Send the transaction to the scoreboard through the mailbox
      monin2scb.put(trans);
    end
  endtask

endclass