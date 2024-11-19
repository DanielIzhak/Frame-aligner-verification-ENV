class driver;

int num_transactions;


virtual inf vinf;

mailbox gen2drv;

function new(virtual inf vinf, mailbox gen2drv);
		//get the interface 
		this.vinf = vinf;
		//get the mailbox handle from env
		this.gen2drv = gen2drv;
	endfunction 

task reset;
  wait(vinf.reset);
$display("[ --DRIVER--] ----RESET START");
vinf.rx_data <= 0;
  wait(!vinf.reset);
$display("[--DRIVER--] --- RESET ENDED ---");
endtask

task main;
forever begin
transaction trans;
gen2drv.get(trans);

  @(negedge vinf.clk)
 vinf.rx_data <= trans.rx_data; 
  $display("driver: rx_data = %h at time = %t", vinf.rx_data, $time);
 
#1

trans.display("[ -- Driver --]");
num_transactions++;
end
endtask  
  
endclass