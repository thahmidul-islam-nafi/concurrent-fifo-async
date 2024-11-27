module async_read_pointer #(parameter DEPTH = 16, ADDR_WIDTH = 4) (
    input wire rd_clk,
    input wire reset,
    input wire read_en,
    output reg [ADDR_WIDTH-1:0] read_addr,
    output reg [ADDR_WIDTH:0] gray_read_ptr
);
    reg [ADDR_WIDTH:0] binary_read_ptr;

    always @(posedge rd_clk or posedge reset) begin
        if (reset) begin
            binary_read_ptr <= 0;
            gray_read_ptr <= 0;
        end else if (read_en) begin
            binary_read_ptr <= binary_read_ptr + 1;
            gray_read_ptr <= (binary_read_ptr >> 1) ^ binary_read_ptr;
        end
    end

    always @(*) begin
        read_addr = binary_read_ptr[ADDR_WIDTH-1:0];
    end
endmodule
