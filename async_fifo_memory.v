module async_fifo_memory #(parameter DATA_WIDTH = 8, DEPTH = 16, ADDR_WIDTH = 4) (
    input wire wr_clk,
    input wire rd_clk,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire write_en,
    input wire [ADDR_WIDTH-1:0] write_addr,
    output reg [DATA_WIDTH-1:0] read_data,
    input wire [ADDR_WIDTH-1:0] read_addr
);
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    always @(posedge wr_clk) begin
        if (write_en) begin
            memory[write_addr] <= write_data;
        end
    end

    always @(posedge rd_clk) begin
        read_data <= memory[read_addr];
    end
endmodule
