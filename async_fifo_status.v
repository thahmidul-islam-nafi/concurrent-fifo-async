module async_fifo_status #(parameter DEPTH = 16, ADDR_WIDTH = 4) (
    input wire wr_clk,
    input wire rd_clk,
    input wire reset,
    input wire [ADDR_WIDTH:0] gray_write_ptr,
    input wire [ADDR_WIDTH:0] gray_read_ptr,
    output reg full,
    output reg empty
);
    reg [ADDR_WIDTH:0] synched_gray_write_ptr;
    reg [ADDR_WIDTH:0] synched_gray_read_ptr;

    // Synchronize the write pointer to the read clock domain
    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            synched_gray_write_ptr <= 0;
        end else begin
            synched_gray_write_ptr <= gray_write_ptr;
        end
    end

    // Synchronize the read pointer to the write clock domain
    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            synched_gray_read_ptr <= 0;
        end else begin
            synched_gray_read_ptr <= gray_read_ptr;
        end
    end

    // Determine full and empty status
    always @(*) begin
        full = (gray_write_ptr[ADDR_WIDTH-1:0] == synched_gray_read_ptr[ADDR_WIDTH-1:0]) &&
               (gray_write_ptr[ADDR_WIDTH] != synched_gray_read_ptr[ADDR_WIDTH]);
        empty = (gray_write_ptr == synched_gray_read_ptr);
    end
endmodule
