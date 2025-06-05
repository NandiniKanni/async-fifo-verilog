// File: fifo_buffer_tb.v
module sfifo_buffer_tb;

    reg clk;
    reg EN, WR_EN, RD_EN, Rst;
    reg [31:0] dataIn;
    wire [31:0] dataOut;
    wire EMPTY, FULL;

    // Instantiate FIFO module (Make sure the module name matches yours)
    sfifo_buffer uut (
        .clk(clk),
        .EN(EN),
        .WR_EN(WR_EN),
        .RD_EN(RD_EN),
        .Rst(Rst),
        .dataIn(dataIn),
        .dataOut(dataOut),
        .EMPTY(EMPTY),
        .FULL(FULL)
    );

    // ? Single clock for synchronous FIFO
    initial clk = 0;
    always #5 clk = ~clk;

    // ? Test sequence
    initial begin
        EN = 1; WR_EN = 0; RD_EN = 0; Rst = 1;
        dataIn = 0;

        #10 Rst = 0;

        // Try reading when FIFO is empty
        RD_EN = 1; #20; RD_EN = 0;

        // Write values
        WR_EN = 1;
        dataIn = 32'hAAAA0001; #10;
        dataIn = 32'hAAAA0002; #10;
        dataIn = 32'hAAAA0003; #10;
        dataIn = 32'hAAAA0004; #10;
        dataIn = 32'hAAAA0005; #10;
        dataIn = 32'hAAAA0006; #10;
        dataIn = 32'hAAAA0007; #10;
        dataIn = 32'hAAAA0008; #10;
        dataIn = 32'hAAAA0009; #10;
        dataIn = 32'hAAAA000A; #10;
        WR_EN = 0;

        // Read values
        #10 RD_EN = 1; 
        #100;
        RD_EN = 0;

        #20 $finish;
    end

endmodule

