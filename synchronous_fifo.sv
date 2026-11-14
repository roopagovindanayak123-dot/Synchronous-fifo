module synchronous_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 4,
    parameter PTR_WIDTH = $clog2(DEPTH),
    parameter COUNT_WIDTH = $clog2(DEPTH + 1)
)(
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic rd_en,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic full,
    output logic empty
);

    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    logic [PTR_WIDTH-1:0] write_ptr, read_ptr;
    logic [COUNT_WIDTH-1:0] count;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    always_ff @(posedge clk) begin
        if (rst) begin
            write_ptr <= '0;
            read_ptr <= '0;
            count <= '0;
            data_out <= '0;
        end
        else begin
            if (wr_en && !full) begin
                memory[write_ptr] <= data_in;

                if (write_ptr == DEPTH-1)
                    write_ptr <= '0;
                else
                    write_ptr <= write_ptr + 1'b1;
            end

            if (rd_en && !empty) begin
                data_out <= memory[read_ptr];

                if (read_ptr == DEPTH-1)
                    read_ptr <= '0;
                else
                    read_ptr <= read_ptr + 1'b1;
            end

            case ({(wr_en && !full), (rd_en && !empty)})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

endmodule
