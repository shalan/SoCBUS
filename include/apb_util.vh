`define APB_SLAVE_CONN(n)\
            .PCLK(PCLK),\
            .PRESETn(PRESETn),\
            .PSEL(PSEL_S[n]),\
            .PADDR(PADDR),\
            .PREADY(PREADY_S[n]),\
            .PWRITE(PWRITE),\
            .PWDATA(PWDATA),\
            .PRDATA(PRDATA_S[n]),\
            .PENABLE(PENABLE),\
            .PIRQ(PIRQ[n])

/*
`define APB_SLAVE_IFC\
            input wire          PSEL,\
            input wire [31:0]   PRDATA,\
            input wire          PREADY,\
            output wire [31:0]  PWDATA,\
            output wire         PENABLE,\
            output wire [31:0]  PADDR,\
            output wire         PWRITE,\
            input wire          PIRQ
*/

`define APB_SLAVE_IFC\
    input wire          PWRITE,\
    input wire [31:0]   PWDATA,\
    input wire [31:0]   PADDR,\
    input wire          PENABLE,\
    input wire          PSEL,\
    output wire         PREADY,\
    output wire [31:0]  PRDATA,\
    output wire         PIRQ

`define APB_MASTER_IFC\
            input wire  [31:0]  PRDATA,\
            input wire          PREADY,\
            output wire [31:0]  PWDATA,\
            output reg          PENABLE,\
            output reg  [31:0]  PADDR,\
            output reg          PWRITE

`define APB_MASTER_S_IFC\
            output wire [31:0]      PRDATA,\
            output wire             PREADY,\
            input wire [31:0]       PWDATA,\
            input wire              PENABLE,\
            input wire [31:0]       PADDR,\
            input wire              PWRITE\

`define APB_REG(name, size, init, prefix)   \
        reg [size-1:0] name; \
        wire ``name``_sel = PENABLE & PWRITE & PREADY & PSEL & (PADDR[7:3] == ``name``_OFF); \
        always @(posedge PCLK or negedge PRESETn) \
            if (~PRESETn) \
                ``name`` <= 'h``init``; \
            else if (``name``_sel) \
                ``name`` <= ``prefix``PWDATA[``size``-1:0];

`define APB_REG_FIELD(reg_name, field_name, from, to)\
    wire    reg_name``field_name``  =   reg_name[``to``:``from``];


`define APB_ICR(offset, size)\
    reg [``size``-1:0] IC_REG;\
    wire IC_REG_sel = (PENABLE & PWRITE & PREADY & PSEL & (PADDR[7:3] == ``offset``));\
    always @(posedge PCLK, negedge PRESETn)\
        if(!PRESETn)\
            IC_REG <= 'b0;\
        else if(IC_REG_sel)\
            IC_REG <= PWDATA[0:0];\
        else if(IC_REG != 'h0)\
            IC_REG <= 'b0;\

`define APB_DEC_MUX_16(base_hex, rdata_default)\
    wire [15:0] PREADY_S;\
    wire [15:0] PSEL_S;\
    wire [31:0] PRDATA_S [15:0];\
    wire PSEL = (PADDR[31:24] == 8'h``base_hex``);\
    wire [3:0] DEC_BITS = PADDR [23:20];\
    wire [15:0] dec  = { \
                            (DEC_BITS  == 4'd15),\
                            (DEC_BITS  == 4'd14),\
                            (DEC_BITS  == 4'd13),\
                            (DEC_BITS  == 4'd12),\
                            (DEC_BITS  == 4'd11),\
                            (DEC_BITS  == 4'd10),\
                            (DEC_BITS  == 4'd9),\
                            (DEC_BITS  == 4'd8),\
                            (DEC_BITS  == 4'd7),\
                            (DEC_BITS  == 4'd6),\
                            (DEC_BITS  == 4'd5),\
                            (DEC_BITS  == 4'd4),\
                            (DEC_BITS  == 4'd3),\
                            (DEC_BITS  == 4'd2),\
                            (DEC_BITS  == 4'd1),\
                            (DEC_BITS  == 4'd0)\
                        };\
    assign PSEL_S = {16{PSEL}} & dec;\
    assign  PREADY =    dec[0] ? PREADY_S[0] :\
                        dec[1] ? PREADY_S[1] :\
                        dec[2] ? PREADY_S[2] :\
                        dec[3] ? PREADY_S[3] :\
                        dec[4] ? PREADY_S[4] :\
                        dec[5] ? PREADY_S[5] :\
                        dec[6] ? PREADY_S[6] :\
                        dec[7] ? PREADY_S[7] :\
                        dec[8] ? PREADY_S[8] :\
                        dec[9] ? PREADY_S[9] :\
                        dec[10] ? PREADY_S[10] :\
                        dec[11] ? PREADY_S[11] :\
                        dec[12] ? PREADY_S[12] :\
                        dec[13] ? PREADY_S[13] :\
                        dec[14] ? PREADY_S[14] :\
                        dec[15] ? PREADY_S[15] : 1'b1;\
    assign PRDATA =     dec[0] ? PRDATA_S[0] :\
                        dec[1] ? PRDATA_S[1] :\
                        dec[2] ? PRDATA_S[2] :\
                        dec[3] ? PRDATA_S[3] :\
                        dec[4] ? PRDATA_S[4] :\
                        dec[5] ? PRDATA_S[5] :\
                        dec[6] ? PRDATA_S[6] :\
                        dec[7] ? PRDATA_S[7] :\
                        dec[8] ? PRDATA_S[8] :\
                        dec[9] ? PRDATA_S[9] :\
                        dec[10] ? PRDATA_S[10] :\
                        dec[11] ? PRDATA_S[11] :\
                        dec[12] ? PRDATA_S[12] :\
                        dec[13] ? PRDATA_S[13] :\
                        dec[14] ? PRDATA_S[14] :\
                        dec[15] ? PRDATA_S[15] : 32'h``rdata_default``;

`define SLAVE_NOT_USED(num, rdata_default)\
    assign  PREADY_S[``num``] = 1'b1;\
    assign  PRDATA_S[``num``] = 32'h``rdata_default``;\
    assign  PIRQ[``num``] = 'b0;


