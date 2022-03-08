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

module AHB_SYS (
    input wire HCLK,
    input wire HRESETn,

    `AHB_MASTER_BUS_IFC()
);

    `AHB_SLAVE_SIGNALS(S0)
    `AHB_SLAVE_SIGNALS(S1)
    `AHB_SLAVE_SIGNALS(S2)
    `AHB_SLAVE_SIGNALS(S3)

    AHB_BUS BUS (
        .HCLK(HCLK),
        .HRESETn(HRESETn),

        `AHB_MASTER_CONN,

        `AHB_SLAVE_BUS_CONN(S0),
        `AHB_SLAVE_BUS_CONN(S1),
        `AHB_SLAVE_BUS_CONN(S2),
        `AHB_SLAVE_BUS_CONN(S3)
);


    AHB_SLAVE_0 S0 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        `AHB_SLAVE_INST_CONN(S0)   
    );

    AHB_SLAVE_1 S1 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        `AHB_SLAVE_INST_CONN(S1)   
    );

    AHB_SLAVE_0 S2 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        `AHB_SLAVE_INST_CONN(S2)   
    );

    AHB_SLAVE_1 S3 (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        `AHB_SLAVE_INST_CONN(S3)   
    );

   
endmodule