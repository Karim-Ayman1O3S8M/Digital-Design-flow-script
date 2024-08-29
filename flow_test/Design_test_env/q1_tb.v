module Single_sync_RAM_tb ();

// No adress pipelinw while using output pipeline
    localparam MEM_WIDTH = 16 ;
    localparam MEM_DEPTH = 1024 ;
    localparam ADDR_SIZE = 10 ;
reg [MEM_WIDTH-1:0] din;
reg [ADDR_SIZE-1:0] addr;
reg wr_en,rd_en,clk,rst,blk_select,addr_en,dout_en;
wire  [MEM_WIDTH-1:0] dout;
reg  [MEM_WIDTH-1:0] dout_temp;
wire parity_out;

Single_sync_RAM DUT (clk,rst,din,addr,wr_en,rd_en,blk_select,addr_en,dout_en,dout,parity_out);

reg [MEM_WIDTH-1:0] ref_mem [MEM_DEPTH-1:0] ;

initial begin
    clk=0;
    forever #1 clk = ~ clk;
end

integer passed,err;

initial begin
    // Initialization
    {passed,err} = 0;
    $readmemb("mem_file.mem",DUT.mem);
    $readmemb("mem_file.mem",ref_mem);
    // Test the reset alone 
    rst = 1;    
    repeat(100) begin
        din  = $random;
        addr  = $random;
        wr_en  = $random;
        rd_en = $random;
        blk_select = $random;
        addr_en = $random;
        dout_en = $random;
        repeat(3) @(negedge clk);
        if(dout!==0)
            err = err +1;
        else  passed = passed +1;
        if(wr_en)
            if (DUT.mem[addr] === ref_mem[addr])
                passed = passed +1;
            else err = err +1;
    end
    rst = 0; blk_select = 1; dout_temp  = dout;
    // Test the normal operation while activation of the memory
    repeat(1000) begin
        din  = $random;
        addr  = $random;
        wr_en  = $random;
        rd_en = $random;
        addr_en = $random;
        dout_en = $random;
       repeat(2) @(negedge clk);
        //Since no pipeline of address , the address enable is not necessary    
        case ({rd_en,wr_en})
            'b00:   
                begin
                      if(dout!==dout_temp && DUT.mem[addr] !== ref_mem[addr] ) 
                        err = err +1;
                    else passed = passed + 1; 
                end
            'b10: 
                begin
                    if(dout_en)
                        if(dout!==ref_mem[addr])
                            err = err + 1;
                        else passed = passed +1 ;
                    else 
                        if(dout!==dout_temp)
                            err = err + 1;
                        else passed = passed +1 ;
                end
            default:
                begin
                     ref_mem[addr] = din;
                    if(DUT.mem[addr] !== din)
                        err = err +1 ;
                    else passed = passed + 1;
                end 
        endcase
        @(negedge clk);
        dout_temp = dout;
    end
    //Turn off the memory & see the results
    repeat(1000) begin
        din  = $random;
        addr  = $random;
        wr_en  = $random;
        rd_en = $random;
        addr_en = $random;
        dout_en = $random;
        repeat (3) @(negedge clk);
        if(dout!==dout_temp)
            err = err +1;
        else passed = passed +1;
    end
$display("Test ended with %0d passed & %0d failed",passed,err);
$stop;

end

always @(err) begin
    if(err)
        $display("TIme = %0t , din = %d , Address = %d , wr_en = %b , rd_en = %b , dout_en = %b , dout = %0d\n",
        $time,din,addr,wr_en,rd_en,dout_en,dout);
end


endmodule

