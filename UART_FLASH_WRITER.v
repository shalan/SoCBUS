`timescale              1ns/1ps
`default_nettype        none

`include "./include/ahb_util.vh"

module UART_FLASH_WRITER #(parameter PRESCALE=51) (
    input CLK,
    output TX,
    input RX,
    output SS,
    output SCK,
    output CLK8,
    output CLK32,
    output LED0,
    output LED1,
    output LED2,
    output LED3,
    
    inout [3:0] SIO
      
);
    wire [3:0] state;
    assign {LED3, LED2, LED1, LED0}={HRESETn, 1'b0,TX, RX};
    wire HRESETn ;
    reg [7:0] rst=0;
    reg [5:0] cntr;
    always @(posedge CLK)
        cntr <= cntr + 1;

    always @(posedge CLK)
        if(rst != 255) rst <= rst + 1;

    assign HRESETn = (rst == 255);
    
    //assign CLK8 = cntr[2];
    //assign CLK32 = cntr[4];

    wire HREADY, HWRITE;
    wire [2:0] HSIZE;
    wire [1:0] HTRANS;
    wire [31:0] HADDR, HRDATA, HWDATA;

    wire fm_ce_n,fm_sck;
    wire [3:0] fm_din, fm_dout, fm_douten;

    
    // baud rate = 1228800
    AHB_UART_MASTER #(.PRESCALE(PRESCALE)) UM(
        .HCLK(CLK),
        .HRESETn(HRESETn),

        .HREADY(HREADY),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA),
        .HSIZE(HSIZE),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HADDR(HADDR),

        .RX(RX),
        .TX(TX),

        .st(state)
    );

    //assign CLK8 = HTRANS[1];


    AHB_FLASH_WRITER FW (
        .HCLK(CLK),
        .HRESETn(HRESETn),
    
        // AHB-Lite Slave Interface
        .HSEL(1'b1),
        .HREADYOUT(HREADY),
        .HREADY(HREADY),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA),
        .HSIZE(HSIZE),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HADDR(HADDR),
        
        // FLASH Interface
        .fm_sck(SCK),
        .fm_ce_n(SS),
        .fm_din(fm_din),
        .fm_dout(fm_dout),
        .fm_douten(fm_douten)
);
/*
    assign SIO[0] = fm_douten[0] ? fm_dout[0] : 1'bz;
    assign SIO[1] = fm_douten[1] ? fm_dout[1] : 1'bz;
    assign SIO[2] = fm_douten[2] ? fm_dout[2] : 1'bz;
    assign SIO[3] = fm_douten[3] ? fm_dout[3] : 1'bz;

    assign fm_din = SIO;
*/
    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b 0)
    ) raspi_io [3:0] (
        .PACKAGE_PIN(SIO),
        .OUTPUT_ENABLE(fm_douten),
        .D_OUT_0(fm_dout),
        .D_IN_0(fm_din)
);


endmodule
