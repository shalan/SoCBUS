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
    Example AHB-lite Bus Metrix for a single master and 4 slaves
*/

`default_nettype         none

`include "./include/ahb_util.vh"

module AHB_BUS (
    input wire HCLK,
    input wire HRESETn,

    `AHB_MASTER_BUS_IFC( ),
    
    `AHB_SLAVE_BUS_IFC(S0),
    `AHB_SLAVE_BUS_IFC(S1),
    `AHB_SLAVE_BUS_IFC(S2),
    `AHB_SLAVE_BUS_IFC(S3)
);

    // The salves bases addresses
    localparam S0_PAGE = 8'h40;
    localparam S1_PAGE = 8'h41;
    localparam S2_PAGE = 8'h42;
    localparam S3_PAGE = 8'h43;

   `AHB_SYS_EPILOGUE(31:24, 8, 4)

   `HSEL_GEN(S0)
   `HSEL_GEN(S1)
   `HSEL_GEN(S2)
   `HSEL_GEN(S3)
   
    `AHB_MUX
        `AHB_MUX_SLAVE(S0)
        `AHB_MUX_SLAVE(S1)
        `AHB_MUX_SLAVE(S2)
        `AHB_MUX_SLAVE(S3)
        `AHB_MUX_DEFAULT

endmodule