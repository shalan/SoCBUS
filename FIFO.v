module FIFO #(parameter DWIDTH=8, 
                        AWIDTH=4)
    (
        input wire                  clk,
        input wire                  rst_n,
        input wire                  rd,
        input wire                  wr,
        input wire  [DWIDTH-1:0]    w_data,
        output wire                 empty,
        output wire                 full,
        output wire [DWIDTH-1:0]    r_data,
        output wire [AWIDTH-1:0]    level
    );

//Internal Signal declarations

    reg [DWIDTH-1:0] array_reg [2**AWIDTH-1:0];
    reg [AWIDTH-1:0] w_ptr_reg;
    reg [AWIDTH-1:0] w_ptr_next;
    reg [AWIDTH-1:0] w_ptr_succ;
    reg [AWIDTH-1:0] r_ptr_reg;
    reg [AWIDTH-1:0] r_ptr_next;
    reg [AWIDTH-1:0] r_ptr_succ;

    // Level
    reg [AWIDTH-1:0] level_reg;
    reg [AWIDTH-1:0] level_next; 

    reg full_reg;
    reg empty_reg;
    reg full_next;
    reg empty_next;

    wire w_en;
  
    always @ (posedge clk)
        if(w_en)
            array_reg[w_ptr_reg] <= w_data;

    assign r_data = array_reg[r_ptr_reg];   

    assign w_en = wr & ~full_reg;           

    //State Machine
    always @ (posedge clk, negedge rst_n)
    if(!rst_n) begin
        w_ptr_reg   <= 0;
        r_ptr_reg   <= 0;
        full_reg    <= 1'b0;
        empty_reg   <= 1'b1;
        level_reg   <= 4'd0;
    end else begin
        w_ptr_reg   <= w_ptr_next;
        r_ptr_reg   <= r_ptr_next;
        full_reg    <= full_next;
        empty_reg   <= empty_next;
        level_reg   <= level_next;
    end

    //Next State Logic
    always @* begin
        w_ptr_succ = w_ptr_reg + 1;
        r_ptr_succ = r_ptr_reg + 1;
        w_ptr_next = w_ptr_reg;
        r_ptr_next = r_ptr_reg;
        full_next  = full_reg;
        empty_next = empty_reg;
        level_next = level_reg;

        case({w_en,rd})
            2'b01:  if(~empty_reg) begin
                        r_ptr_next = r_ptr_succ;
                        full_next = 1'b0;
                        level_next = level_reg - 1;
                        if (r_ptr_succ == w_ptr_reg)
                            empty_next = 1'b1;
                    end
            2'b10:  if(~full_reg) begin
                        w_ptr_next = w_ptr_succ;
                        empty_next = 1'b0;
                        level_next = level_reg + 1;
                        if (w_ptr_succ == r_ptr_reg)
                            full_next = 1'b1;
                    end
            2'b11:  begin
                        w_ptr_next = w_ptr_succ;
                        r_ptr_next = r_ptr_succ;
                    end
        endcase
        
    end

    //Set Full and Empty
    assign full     = full_reg;
    assign empty    = empty_reg;
    assign level    = level_reg;
  
endmodule
