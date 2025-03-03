module Single_Port_RAM (
    input  wire           clk,
    input  wire           rst,    // Active low reset
    input  wire           Wr_Rd,  // 1 = Write, 0 = Read
    input  wire           valid,  // Valid operation
    input  wire  [N-1:0]  ADDR,   // Address input
    input  wire  [W-1:0]  WDATA,  // Write data
    output reg   [W-1:0]  RDATA,  // Read data
    output reg            ready   // Ready signal
);
    parameter N = 4;   // No. of Address Lines
    parameter D = 16;  // Depth of Memory
    parameter W = 8;   // Width of Memory
    
    reg [W-1:0] mem [0:D-1]; // Memory array
    integer i;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset memory to zero
            for (i = 0; i < D; i = i + 1)
                mem[i] <= 0;
            RDATA <= 0;
            ready <= 0;
        end else if (valid) begin
            if (Wr_Rd) begin
                // Write operation
                mem[ADDR] <= WDATA;
                ready <= 0; // Ready only for read
            end else begin
                // Read operation
                RDATA <= mem[ADDR];
                ready <= 1;
            end
        end else begin
            ready <= 0;
        end
    end
endmodule
