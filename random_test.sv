
`include "environment.sv"
//`include "environment.sv"
program test(inf i_inf);
  
  //declare environment instance
  environment env;
  
  initial begin
    //create environment
    env = new(i_inf);
    
    //set the repeat count of generator as 6, i.e. generat 6 packets
    env.gen.repeat_count = 400;
    
    //call run of env, it calls generator and driver main tasks.
    env.run();
  end
endprogram
