module concurrent_fifo_tb;

// Parameters
parameter DATA_WIDTH = 8;
parameter DEPTH = 16;
parameter ADDR_WIDTH = 4;

// Signals
reg wr_clk;
reg rd_clk;
reg reset;
reg write_en;
reg read_en;
reg [DATA_WIDTH-1:0] write_data;
wire [DATA_WIDTH-1:0] read_data;
wire full;
wire empty;

// Instantiate the asynchronous FIFO
concurrent_fifo_async_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) fifo (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .write_data(write_data),
    .read_data(read_data),
    .full(full),
    .empty(empty)
);

// Write clock generation
initial begin
    wr_clk = 0;
    forever #10 wr_clk = ~wr_clk; // 20ns write clock period
end

// Read clock generation
initial begin
    rd_clk = 0;
    forever #15 rd_clk = ~rd_clk; // 30ns read clock period
end

// Test sequence
initial begin
    // Initialize signals
    reset = 1;
    write_en = 0;
    read_en = 0;
    write_data = 0;

    // Apply reset
    #50 reset = 0;

    // Write data into FIFO
    #20;
    write_data = 8'hA1; 
    write_en = 1; 
    #20 write_en = 0;

    #20;
    write_data = 8'hB2; 
    write_en = 1; 
    #20 write_en = 0;

    #20;
    write_data = 8'hC3; 
    write_en = 1; 
    #20 write_en = 0;

    // Read data from FIFO
    #60 read_en = 1; 
    #30 read_en = 0;

    #60 read_en = 1; 
    #30 read_en = 0;

    #60 read_en = 1; 
    #30 read_en = 0;

    // Finish simulation
    #300 $finish;
end

// Monitor signals
initial begin
    $monitor("Time=%0t wr_clk=%b rd_clk=%b reset=%b write_en=%b read_en=%b write_data=%h read_data=%h full=%b empty=%b",
             $time, wr_clk, rd_clk, reset, write_en, read_en, write_data, read_data, full, empty);
end

endmodule
