`define AHB_REG(name, size, offset, init, prefix)   \
        reg [size-1:0] name; \
        wire ``name``_sel = wr_enable & (last_HADDR[7:0] == offset); \
        always @(posedge HCLK or negedge HRESETn) \
            if (~HRESETn) \
                ``name`` <= 'h``init``; \
            else if (``name``_sel) \
                ``name`` <= ``prefix``HWDATA[``size``-1:0];\

`define AHB_SLAVE_IFC(prefix)   \
        input               ``prefix``HSEL,\
        input wire [31:0]   ``prefix``HADDR,\
        input wire [1:0]    ``prefix``HTRANS,\
        input wire          ``prefix``HWRITE,\
        input wire          ``prefix``HREADY,\
        input wire [31:0]   ``prefix``HWDATA,\
        input wire [2:0]    ``prefix``HSIZE,\
        output wire         ``prefix``HREADYOUT,\
        output wire [31:0]  ``prefix``HRDATA
        

`define AHB_SLAVE_RO_IFC(prefix)   \
        input               ``prefix``HSEL,\
        input wire [31:0]   ``prefix``HADDR,\
        input wire [1:0]    ``prefix``HTRANS,\
        input wire          ``prefix``HWRITE,\
        input wire          ``prefix``HREADY,\
        output wire         ``prefix``HREADYOUT,\
        output wire [31:0]  ``prefix``HRDATA

`define AHB_MASTER_IFC(prefix) \
        output wire [31:0]  ``prefix``HADDR,\
        output wire [1:0]   ``prefix``HTRANS,\
        output wire [2:0] 	 ``prefix``HSIZE,\
        output wire         ``prefix``HWRITE,\
        output wire [31:0]  ``prefix``HWDATA,\
        input wire          ``prefix``HREADY,\
        input wire [31:0]   ``prefix``HRDATA 
        

`define AHB_SLAVE_EPILOGUE(prefix) \
    reg             last_HSEL; \
    reg [31:0]      last_HADDR; \
    reg             last_HWRITE; \
    reg [1:0]       last_HTRANS; \
    \
    always@ (posedge HCLK) begin\
        if(``prefix``HREADY) begin\
            last_HSEL       <= ``prefix``HSEL;   \
            last_HADDR      <= ``prefix``HADDR;  \
            last_HWRITE     <= ``prefix``HWRITE; \
            last_HTRANS     <= ``prefix``HTRANS; \
        end\
    end\
    \
    wire rd_enable = last_HSEL & (~last_HWRITE) & last_HTRANS[1]; \
    wire wr_enable = last_HSEL & (last_HWRITE) & last_HTRANS[1]; 


`define REG_FIELD(reg_name, fld_name, from, to)\
    wire [``to``-``from``:0] ``reg_name``_``fld_name`` = reg_name[to:from]; 

`define AHB_READ assign HRDATA = 

`define AHB_REG_READ(name, offset) (last_HADDR[7:0] == offset) ? name : 

/*
module TEST(
    input wire HCLK,
    input wire HRESETn,

    `AHB_SLAVE_IFC(S0_),
    `AHB_MASTER_IFC(M0_)
);

    `AHB_SLAVE_EPILOGUE(S0_)

    `AHB_REG(XXX, 20, 8'h20, 0, S0_)

    `REG_FIELD(XXX, xxx, 2, 15)

    `AHB_READ
        `AHB_REG_READ(XXX, 8'h20)
        32'hDEADBEEF;

endmodule
*/