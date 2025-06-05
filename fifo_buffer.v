// File: fifo_buffer.v
module fifo_buffer( clk_wr,clk_rd,EN,WR_EN,RD_EN,Rst,dataOut, dataIn, EMPTY,FULL  );
    input clk_wr;              // Write clock
    input clk_rd;             // Read clock
    input EN;                 // Global enable
    input WR_EN;                 // Write enable
    input RD_EN;                 // Read enable
    input Rst;                // Reset
    input [31:0] dataIn;      // 32-bit data input
    output reg [31:0] dataOut; // 32-bit data output
    output reg EMPTY;         // Empty flag
    output reg FULL ;           // Full flag

    reg [31:0] queue [0:7];    // 8-slot FIFO queue (each 32 bits)
    reg [3:0] write_ptr;       // 4-bit write pointer
    reg [3:0] read_ptr;        // 4-bit read pointer

    always @(posedge clk_wr or posedge Rst) begin
        if (Rst) begin
            write_ptr <= 0;
        end
        else if (EN && WR_EN && !FULL) begin
            queue[write_ptr[2:0]] <= dataIn;  // write to queue
            write_ptr <= write_ptr + 1;
        end
    end

    always @(posedge clk_rd or posedge Rst) begin
        if (Rst) begin
            read_ptr <= 0;
            dataOut <= 0;
        end
        else if (EN && RD_EN && !EMPTY) begin
            dataOut <= queue[read_ptr[2:0]];  // read from queue
            read_ptr <= read_ptr + 1;
        end
    end

    always @(*) begin
        EMPTY = (write_ptr == read_ptr);
        FULL  = (write_ptr[2:0] == read_ptr[2:0]) &&
                (write_ptr[3] != read_ptr[3]);
    end

endmodule
 