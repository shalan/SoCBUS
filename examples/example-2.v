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
    AHB Slave Examples to demostrats the AHB header file 
*/

`default_nettype         none

`include "./include/ahb_util.vh"

module AHB_SLAVE_0(
    input wire HCLK,
    input wire HRESETn,
    `AHB_SLAVE_IFC
);

    `AHB_SLAVE_EPILOGUE

    // R1 is a 20-bit register @ offset 0x20
    // It has 3 fields:
    // F1 (bit 0), F2 (bit 1), F3 (bits 2:19)
    `AHB_REG(R1, 20, 8'h20, 0)
    `REG_FIELD(R1, F1, 0, 0)
    `REG_FIELD(R1, F2, 1, 1)
    `REG_FIELD(R1, F3, 2, 19)

    `AHB_READ
        `AHB_REG_READ(R1, 8'h20)
        32'hDEADBEEF;

    assign HREADYOUT = 1;

endmodule

module AHB_SLAVE_1(
    input wire HCLK,
    input wire HRESETn,
    `AHB_SLAVE_IFC
);

    `AHB_SLAVE_EPILOGUE

    // R1 is a 8-bit register @ offset 0x0
    // It has 1 field: F1 (bits 7:0)
    // F1 (bit 0), F2 (bit 1), F3 (bits 19:2)
    `AHB_REG(R1, 8, 8'h0, 0)
    `REG_FIELD(R1, F1, 0, 7)
    
    `AHB_READ
        `AHB_REG_READ(R1, 8'h0)
        32'hDEADBEEF;

    assign HREADYOUT = 1;

endmodule
