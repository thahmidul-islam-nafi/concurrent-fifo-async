module async_write_pointer #(parameter DEPTH = 16, ADDR_WIDTH = 4) (
    input wire wr_clk,
    input wire reset,
    input wire write_en,
    output reg [ADDR_WIDTH-1:0] write_addr,
    output reg [ADDR_WIDTH:0] gray_write_ptr
);
    reg [ADDR_WIDTH:0] binary_write_ptr;

    always @(posedge wr_clk or posedge reset) begin
        if (reset) begin
            binary_write_ptr <= 0;
            gray_write_ptr <= 0;
        end else if (write_en) begin
            binary_write_ptr <= binary_write_ptr + 1;
            gray_write_ptr <= (binary_write_ptr >> 1) ^ binary_write_ptr;
        end
    end

    always @(*) begin
        write_addr = binary_write_ptr[ADDR_WIDTH-1:0];
    end
endmodule
