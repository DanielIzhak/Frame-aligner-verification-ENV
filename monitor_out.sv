class monitor_out;

  virtual inf vinf;                 // Virtual interface to connect to the DUT
  mailbox monout2scb;               // Mailbox to send transactions to the scoreboard

  // Constructor to initialize virtual interface and mailbox
  function new(virtual inf vinf, mailbox monout2scb);
    this.vinf = vinf;
    this.monout2scb = monout2scb;
  endfunction

  // Main monitoring task
  task main;
    transaction trans;
   
    forever begin
      // Create a new transaction object for each frame output
      trans = new(); 
      
      // Wait for a positive clock edge
      @(negedge vinf.clk) begin

        trans.fr_byte_position = vinf.fr_byte_position;
        trans.frame_detect = vinf.frame_detect;
      end          
        trans.display("[-- Monitor Out --]");

      // Send the transaction to the scoreboard through the mailbox
      monout2scb.put(trans);
    end
  endtask

endclass