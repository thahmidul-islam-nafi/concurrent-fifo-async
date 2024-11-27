module concurrent_fifo_async_top #(parameter DATA_WIDTH = 8, DEPTH = 16) (
    input wire wr_clk,
    input wire rd_clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input wire [DATA_WIDTH-1:0] write_data,
    output wire [DATA_WIDTH-1:0] read_data,
    output wire full,
    output wire empty
);
    localparam ADDR_WIDTH = $clog2(DEPTH);

    wire [ADDR_WIDTH-1:0] write_addr, read_addr;
    wire [ADDR_WIDTH:0] gray_write_ptr, gray_read_ptr;

    async_fifo_memory #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) fifo_mem (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .write_data(write_data),
        .write_en(write_en),
        .write_addr(write_addr),
        .read_data(read_data),
        .read_addr(read_addr)
    );

    async_write_pointer #(.DEPTH(DEPTH)) wr_ptr (
        .wr_clk(wr_clk),
        .reset(reset),
        .write_en(write_en),
        .write_addr(write_addr),
        .gray_write_ptr(gray_write_ptr)
    );

    async_read_pointer #(.DEPTH(DEPTH)) rd_ptr (
        .rd_clk(rd_clk),
        .reset(reset),
        .read_en(read_en),
        .read_addr(read_addr),
        .gray_read_ptr(gray_read_ptr)
    );

    async_fifo_status #(.DEPTH(DEPTH)) status (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .reset(reset),
        .gray_write_ptr(gray_write_ptr),
        .gray_read_ptr(gray_read_ptr),
        .full(full),
        .empty(empty)
    );

endmodule
