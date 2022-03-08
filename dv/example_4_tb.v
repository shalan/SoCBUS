/*
	Copyright 2020 Mohamed Shalan
	
	Licensed under the Apache License, Version 2.0 (the "License"); 
	you may not use this file except in compliance with the License. 
	You may obtain a copy of the License at:

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.
*/
/*
    A testbench for example-3.v (a simple AHB system with 4 slaves)
*/

`include "include/ahb_util.vh"

module example_4_tb;

    reg HCLK;
    reg HRESETn;

    reg [31:0]  HADDR;
    reg [1:0]   HTRANS;
    reg [2:0] 	HSIZE;
    reg         HWRITE;
    reg [31:0]  HWDATA;
    wire        HREADY;
    wire [31:0] HRDATA; 

APB_SYS DUV (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    
    .HSEL(1),
    .HADDR(HADDR),
    .HTRANS(HTRANS),
    .HSIZE(HSIZE),
    .HWRITE(HWRITE),
    .HWDATA(HWDATA),
    .HREADY(HREADY),
    .HREADYOUT(HREADY),
    .HRDATA(HRDATA)
);


`include "AHB_tasks.vh"

always #5 HCLK = !HCLK;

    initial begin
        $dumpfile("example_4_tb.vcd");
        $dumpvars;
        # 1_500 $finish;
    end

    // RESET
    initial begin
        HCLK = 0;
        HRESETn = 1;
        //HREADY = 1;
		#10;
		@(posedge HCLK);
		HRESETn = 0;
		#100;
		@(posedge HCLK);
		HRESETn = 1;
    end

    // text case
    reg [31:0] rdata;
    initial begin
        #1000;
        AHB_WRITE_WORD(32'h4000_0000, 32'h000D_EEEE);
        #25;
        AHB_WRITE_WORD(32'h4200_0004, 32'h000D_DDDD);
        #25;
        AHB_READ_WORD(32'h4000_0000, rdata);
        #25;
        if(rdata == 32'h000D_EEEE) $display("Test 1 passed"); else $display("Test 1 failed");
        #25;
        AHB_READ_WORD(32'h4200_0004, rdata);
        #25;
        if(rdata == 32'h0000_00DD) $display("Test 2 passed"); else $display("Test 2 Failed");
    end

endmodule