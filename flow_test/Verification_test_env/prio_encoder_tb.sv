module prio_encode_tb (
);
logic [3:0] x;
logic [1:0] y,y_tb;

prio DUT(.*);

initial begin
    // Test the x[3]
    y_tb = 2'b11;  
    x[3]=1; check_prio(y_tb);
    x[2]=1; check_prio(y_tb);
    x[1]=1; check_prio(y_tb);
    x[0]=1; check_prio(y_tb);
    // Test the x[2]
     y_tb = 2'b10;
    x[3] = 0; check_prio(y_tb);
    x[1] = 0; check_prio(y_tb);
    x[0] = 0; check_prio(y_tb);
    // Test the x[1]
    y_tb = 2'b01;
    x[2]=0;
    x[1] = 1; check_prio(y_tb);
    x[0] = 1; check_prio(y_tb);
    // Test the x[0]
    y_tb = 0; 
    x[1] = 0;
    check_prio(y_tb);
    x[1]=0; check_prio(y_tb);
    $display("Test ended without errors");
    $stop;
end

task check_prio (input [1:0] a_ref);
#1;
if(y!==a_ref)
    begin
    $display("Error when y_dut = %d & y_ref = %d ",y,a_ref);
    $stop;
    end
endtask

 // Note : The task can see the "y" signal since it has global scope while it can't see the "y_dut" signal since it has local scope inside the initial block    
endmodule