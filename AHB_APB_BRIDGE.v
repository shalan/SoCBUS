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
`timescale               1ns/1ps
`default_nettype         none

`include                "./include/ahb_util.vh"
`include                "./include/apb_util.vh"
/*
    AHB lite to APB Bridge
    SLOW_PCLK:
        0 : Same as HCLK (PCLKEN must be 1)
        1 : Slower than HCLK (PCLKEN is used as PCLK)
*/
module AHB_APB_BRIDGE #(parameter SLOW_PCLK = 1)(
    input wire          HCLK,
    input wire          HRESETn,
    
    // AHB Slave Port
    `AHB_SLAVE_IFC(),

    // APB Master Port
    output wire         PCLK,
    output wire         PRESETn,
    input wire          PCLKEN,

    `APB_MASTER_IFC
);
  
    localparam      ST_IDLE     = 3'h0,
                    ST_WAIT     = 3'h1,
                    ST_SETUP    = 3'h2,
                    ST_ACCESS   = 3'h3;       

    wire            Transfer;
    wire            ACRegEn;

    wire  [31:0]    HADDR_Mux;

    reg   [2:0]     state;
    reg   [2:0]     nstate;

    reg             HREADY_next;  
    wire            PWRITE_next;
    wire            PENABLE_next;
    wire            APBEn;
  
    generate
        if(SLOW_PCLK)
            assign PCLK     =   PCLKEN;
        else 
            assign PCLK     =   HCLK;
    endgenerate

    assign PRESETn  = HRESETn;
    assign Transfer = HSEL & HREADY & HTRANS[1];
    assign ACRegEn  = HSEL & HREADY;

    `AHB_SLAVE_EPILOGUE()
  
    // State Machine
    always @ * 
        case (state)
            ST_IDLE:    if(Transfer & PCLKEN) nstate = ST_SETUP; 
                        else if(Transfer) nstate = ST_WAIT;
                        else nstate = ST_IDLE;      
            ST_WAIT:    if(PCLKEN) nstate = ST_SETUP;
                        else nstate = ST_WAIT;
            ST_SETUP:   if(PCLKEN) nstate = ST_ACCESS; else nstate = ST_SETUP;
            ST_ACCESS:  if(!PREADY) nstate = ST_ACCESS;
                        else begin
                            if(Transfer & PCLKEN) nstate = ST_SETUP; 
                            else if(Transfer) nstate = ST_WAIT;
                            else nstate = ST_IDLE;
                        end
            default:    nstate = ST_IDLE;
        endcase

    always @ (posedge HCLK, negedge HRESETn)
        if(!HRESETn)
            state <= ST_IDLE;
        else
            state <= nstate;
  
    //HREADYOUT
    reg hreadyout;
    always @ *
        case (nstate)
            ST_IDLE:    HREADY_next = 1'b1;
            ST_WAIT:    HREADY_next = 1'b0;
            ST_SETUP:   HREADY_next = 1'b0;
            ST_ACCESS:  HREADY_next = PREADY;
            default:    HREADY_next = 1'b1;
        endcase

    always @(posedge HCLK, negedge HRESETn)
        if(!HRESETn)
            hreadyout <= 1'b1;
        else
            hreadyout <= HREADY_next;
    
    assign HREADYOUT = hreadyout;

    //APBen
    assign APBEn = (state == ST_IDLE) && (nstate == ST_SETUP) || (nstate == ST_WAIT) ;

    // HADDRMux
    assign HADDR_Mux = (APBEn ? HADDR : last_HADDR);

    //PADDR
    always @ (posedge HCLK, negedge HRESETn)
    if (!HRESETn)
        PADDR <= 'h0;
    else if (APBEn)
        PADDR <= HADDR_Mux;

    //PWDATA
    assign PWDATA = HWDATA;

    //PENABLE
    assign PENABLE_next = (nstate == ST_ACCESS);
    always @ (posedge HCLK, negedge HRESETn)
        if(!HRESETn)
            PENABLE <= 1'b0;
        else
            PENABLE <= PENABLE_next;

    //PWRITE
    assign PWRITE_next = (APBEn ? HWRITE : last_HWRITE);
    always @ (posedge HCLK, negedge HRESETn)
    if(!HRESETn)
        PWRITE <= 1'b0;
    else if (APBEn)
        PWRITE <= PWRITE_next;

    //HRDATA
    assign HRDATA = PRDATA;

endmodule


