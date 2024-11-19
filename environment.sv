//`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	drv;
  monitor_in    monin;
  monitor_out   monout;
  scoreboard    scb;
  
  //mailbox handles
  mailbox gen2drv;
  mailbox monin2scb;
  mailbox monout2scb;
  //virtual interface
  virtual inf vinf;
  
  //constructor
  function new(virtual inf vinf);
    //get the interface from test
    this.vinf = vinf;

    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2drv = new();
    monin2scb = new();
    monout2scb = new();
     
    //create generator and driver
    gen = new(gen2drv);
    drv = new(vinf,gen2drv);
    monin = new(vinf,monin2scb);
    monout = new(vinf,monout2scb);
    scb = new(monin2scb,monout2scb);
  
  endfunction
  
  //test activity
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      drv.main();
      monin.main();
      monout.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.num_transactions); 
    wait(gen.repeat_count == scb.num_transactions); 
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    //post_test();
    #1000
    $finish;
  endtask
  
endclass