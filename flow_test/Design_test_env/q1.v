module Single_sync_RAM (
    clk,rst,din,addr,wr_en,rd_en,blk_select,addr_en,dout_en,dout,parity_out
);
    parameter MEM_WIDTH = 16 ;
    parameter MEM_DEPTH = 1024 ;
    parameter ADDR_SIZE = 10 ;
    parameter  ADDR_PIPELINE = "FALSE" ;
    parameter DOUT_PIPELINE = "TRUE" ;
    parameter PARITY_ENABLE = 1; 

input [MEM_WIDTH-1:0] din;
input [ADDR_SIZE-1:0] addr;
reg [ADDR_SIZE-1:0] addr_piped;
wire [ADDR_SIZE-1:0] addr_in;
input wr_en,rd_en,clk,rst,blk_select,addr_en,dout_en;
output  [MEM_WIDTH-1:0] dout;
reg [MEM_WIDTH-1:0] dout_piped;
reg [MEM_WIDTH-1:0] dout_not_piped;
output parity_out;

reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0] ;

assign addr_in = (ADDR_PIPELINE == "TRUE" )? addr_piped : addr;
assign dout = (DOUT_PIPELINE == "FALSE")? dout_not_piped : dout_piped;

// Assume for case of selecting write & read together --> Then , write 

always @(posedge clk or posedge rst) begin
    if(rst)
        begin
            dout_piped <=0;
            dout_not_piped <=0;
            addr_piped <=0;
        end
    else if (blk_select)
        begin
             if(addr_en)
                begin
                    addr_piped <= addr;
                end
            // If the address enable is off , use the previous address (complete the info retreival)
             if (wr_en)
                begin
                    mem[addr_in] <= din;
                end
            else if(rd_en)
                begin
                    dout_not_piped <= mem[addr_in];
                end
            if (dout_en) 
                begin
                    dout_piped <= dout_not_piped;
                end
        end
end

assign parity_out = (PARITY_ENABLE)? ^dout : 0 ;

endmodule