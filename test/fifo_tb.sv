module fifo_tb();

timeunit 1ps;
timeprecision 1ps;

logic sender_clock = 0;
always
begin
    #3969ps; sender_clock = 1;
    #3969ps; sender_clock = 0;
end

logic receiver_clock = 0;
always
begin
    #20ns; receiver_clock = 1;
    #20ns; receiver_clock = 0;
    // #20833333ps; receiver_clock = 1;
    // #20833333ps; receiver_clock = 0;
end

localparam int DATA_WIDTH = 16;
localparam int POINTER_WIDTH = 8; // 2**8 = 256

logic data_in_enable;
logic [POINTER_WIDTH-1:0] data_in_used;
logic [DATA_WIDTH-1:0] data_in;

logic [POINTER_WIDTH-1:0] data_out_used;
logic data_out_acknowledge;
logic [DATA_WIDTH-1:0] data_out;

fifo #(.DATA_WIDTH(DATA_WIDTH), .POINTER_WIDTH(POINTER_WIDTH)) fifo(
    .sender_clock(sender_clock),
    .data_in_enable(data_in_enable),
    .data_in_used(data_in_used),
    .data_in(data_in),

    .receiver_clock(receiver_clock),
    .data_out_used(data_out_used),
    .data_out_acknowledge(data_out_acknowledge),
    .data_out(data_out)
);

assign data_in_enable = data_in_used < 2**POINTER_WIDTH - 1;
logic [DATA_WIDTH-1:0] data_in_last = 0;
assign data_in = data_in_last + (data_in_enable ? 1'b1 : 1'b0);
always_ff @(posedge sender_clock)
    data_in_last <= data_in;

logic [DATA_WIDTH-1:0] last_data_out = 0;
assign data_out_acknowledge = data_out_used > 0;
always_ff @(posedge receiver_clock)
begin
    if (data_out_acknowledge)
    begin
        last_data_out <= data_out;
        assert (last_data_out + 1'd1 == data_out) else $fatal(1, "%d + 1 != %d", last_data_out, data_out);
        if (data_out == 0)
            $finish;
    end
end

endmodule
