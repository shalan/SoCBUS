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
        A quick and rough AHB master multiplexor. Each master is given the 
        bus till it gives it up.
*/

`timescale              1ns/1ps
`default_nettype        none

module AHB_MUX_2M1S #(parameter SZ=64) (
	input HCLK,
	input HRESETn,
	
    // Port 1
	input  wire [31:0] 	    HADDR_M1,
	input  wire [1:0] 	    HTRANS_M1,
	input  wire       	    HWRITE_M1,
	input  wire [2:0] 	    HSIZE_M1,
	input  wire [SZ-1:0]	HWDATA_M1,
	output wire             HREADY_M1,
	output wire [SZ-1:0]    HRDATA_M1,
	
    // Port 2
	input  wire [31:0] 	    HADDR_M2,
	input  wire [1:0] 	    HTRANS_M2,
	input  wire       	    HWRITE_M2,
	input  wire [2:0] 	    HSIZE_M2,
	input  wire [SZ-1:0]	HWDATA_M2,
	output wire		        HREADY_M2,
	output wire [SZ-1:0]	HRDATA_M2,
	
    // Master Port
	input  wire		        HREADY,
	input  wire [SZ-1:0]	HRDATA,
	output wire [31:0] 	    HADDR,
	output wire [1:0] 	    HTRANS,
	output wire       	    HWRITE,
	output wire [2:0] 	    HSIZE,
	output wire [SZ-1:0]	HWDATA
);
	
	localparam [4:0] S0 = 1;
	localparam [4:0] S1 = 2;
	localparam [4:0] S2 = 4;
	localparam [4:0] S3 = 8;
	localparam [4:0] S4 = 16;

	reg [4:0] 		state, nstate;
	always @(posedge HCLK or negedge HRESETn)
		if(!HRESETn) state <= S2;
		else state <= nstate;

	always @* begin
		nstate = S0;
		case (state)
		  S0  : if(HTRANS_M1[1]) nstate = S1; else if(HTRANS_M2[1]) nstate = S2; else nstate = S0;
		  S1  : if(!HTRANS_M1[1] & HREADY) nstate = S2; else nstate = S1;
		  S2  : if(!HTRANS_M2[1] & HREADY) nstate = S1; else nstate = S2;
		endcase
	end

	assign HREADY_M1 = (state == S0) ? 1'b1 : (state == S1) ? HREADY : ((state == S2) && (HTRANS_M2[1] == 1'b0)) ? HREADY : 1'b0;
	assign HREADY_M2 = (state == S0) ? 1'b1 : (state == S2) ? HREADY : ((state == S1) && (HTRANS_M1[1] == 1'b0)) ? HREADY : 1'b0;
	
	assign HRDATA_M1 = HRDATA;
	assign HRDATA_M2 = HRDATA;
	
	reg [1:0] htrans;
	always @*
		case (state)
			S0:     htrans = (HTRANS_M1[1]) ? HTRANS_M1 : 2'b00;
			S1:     htrans = (HTRANS_M1[1]) ? HTRANS_M1 : HTRANS_M2;
			S2:     htrans = (HTRANS_M2[1]) ? HTRANS_M2 : HTRANS_M1;
            default:htrans = 2'b00;
		endcase
	
	reg [31:0] haddr;
	always @*
		case (state)
			S0:     haddr = (HTRANS_M1[1]) ? HADDR_M1 : 32'b0;
			S1:     haddr = (HTRANS_M1[1]) ? HADDR_M1 : HADDR_M2;
			S2:     haddr = (HTRANS_M2[1]) ? HADDR_M2 : HADDR_M1;
            default:haddr = 32'b0;
		endcase
	
	reg [0:0] hwrite;
	always @*
		case (state)
			S0:     hwrite = (HTRANS_M1[1]) ? HWRITE_M1 : 1'b0;
			S1:     hwrite = (HTRANS_M1[1]) ? HWRITE_M1 : HWRITE_M2;
			S2:     hwrite = (HTRANS_M2[1]) ? HWRITE_M2 : HWRITE_M1;
            default:hwrite = 1'b0;
		endcase
		
	reg [2:0] hsize;
	always @*
		case (state)
			S0:     hsize = (HTRANS_M1[1]) ? HSIZE_M1 : 3'b0;
			S1:     hsize = (HTRANS_M1[1]) ? HSIZE_M1 : HSIZE_M2;
			S2:     hsize = (HTRANS_M2[1]) ? HSIZE_M2 : HSIZE_M1;
            default:hsize = 3'b0;
		endcase
			
	reg [SZ-1:0] hwdata;
	always @*
		case (state)
			S0:     hwdata = 'b0;
			S1:     hwdata = HWDATA_M1;
			S2:     hwdata = HWDATA_M2;
            default:hwdata = 'b0;
		endcase
			
	assign HTRANS   = htrans;
	assign HADDR    = haddr;
	assign HWDATA   = hwdata;
	assign HSIZE    = hsize;
	assign HWRITE   = hwrite;
	
endmodule