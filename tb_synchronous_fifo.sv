module testbench;

    logic clk, rst, wr_en, rd_en;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic full, empty;

    synchronous_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(4)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        repeat (2) @(negedge clk);
        rst = 0;

        // Write data
        @(negedge clk);
        wr_en = 1;
        data_in = 8'd10;

        @(negedge clk);
        data_in = 8'd20;

        @(negedge clk);
        data_in = 8'd30;

        @(negedge clk);
        wr_en = 0;

        // Read data
        @(negedge clk);
        rd_en = 1;

        @(posedge clk);
        #1;
        $display("Read Data: %0d", data_out);

        @(posedge clk);
        #1;
        $display("Read Data: %0d", data_out);

        @(posedge clk);
        #1;
        $display("Read Data: %0d", data_out);

        @(negedge clk);
        rd_en = 0;
        #2;

        $display("FIFO Empty: %b", empty);

        $finish;
    end

endmodule
