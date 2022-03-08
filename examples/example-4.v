/*
	Copyright 2022 Mohamed Shalan
	
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
    Example 3:
        AHB-lite sub-syetem with a bus matrix, 4 slaves and a slave AHB port.
*/
`default_nettype         none

`include "./include/ahb_util.vh"
`include "./include/apb_util.vh"

`define APB_SLAVE_OFF_BITS  PADDR[7:0]

module APB_SYS (
    input wire HCLK,
    input wire HRESETn,

    `AHB_SLAVE_IFC
);

    wire    PCLK;
    wire    PRESETn;

    `APB_MASTER_SIGNALS

    AHB_APB_BRIDGE #( .SLOW_PCLK(0) ) APB_BR (
        
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        
        `AHB_SLAVE_INST_CONN_NP,
        
        // APB Master Port
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PCLKEN(1'b1),
        `APB_MASTER_CONN
    );

    `APB_DEC_MUX_16(0, 32'hDEADBEEF)

    Slave_0 S0 (
        `APB_SLAVE_CONN(0)
    );
    generate 
        genvar i;
        for(i=1; i<15; i=i+1) begin : unused_slave
            `SLAVE_NOT_USED(i, 32'hDEADBEEF)
        end
        
    endgenerate

    
endmodule


module Slave_0 (
    input wire    PCLK,
    input wire    PRESETn, 
    `APB_SLAVE_IFC
);

    localparam
        DATA_REG_OFF = 8'd0,
        CTRL_REG_OFF = 8'd4;

    `APB_REG(DATA_REG, 32, 32'd0, DATA_REG_OFF) 
    `APB_REG(CTRL_REG, 8, 8'd0, CTRL_REG_OFF)
    `APB_REG_FIELD(CTRL_REG, EN, 0, 0)
    `APB_REG_FIELD(CTRL_REG, PRE, 1, 7)

    `APB_PRDATA_MUX
        `APB_SLAVE_PRDATA(DATA_REG_OFF, DATA_REG)
        `APB_SLAVE_PRDATA(CTRL_REG_OFF, CTRL_REG)
        32'hDEADBEEF;  

    assign PREADY = 1;
endmodule