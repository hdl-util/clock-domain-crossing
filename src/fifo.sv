module fifo #(
    // The width of the data in the buffer
    parameter int WIDTH,
    // The length of the buffer, must be a power of 2
    parameter int LENGTH,
    // Sender chain length
    parameter int RECEIVER_DELAY_CHAIN_LENGTH = 1,
    // Delay chain length
    parameter int SENDER_DELAY_CHAIN_LENGTH = 1
) (
    input logic sender_clock,
    input logic data_in_enable,
    output logic [$clog2(LENGTH)-1:0] data_in_used,
    input logic [WIDTH-1:0] data_in,

    input logic receiver_clock,
    output logic [$clog2(LENGTH)-1:0] data_out_used,
    input logic data_out_acknowledge,
    output logic [WIDTH-1:0] data_out
);

localparam POINTER_WIDTH = $clog2(LENGTH);

logic [WIDTH-1:0] buffer [0:LENGTH-1];

logic [POINTER_WIDTH-1:0] sender, receiver, moved_sender, moved_receiver;
gray_code_chain #(.WIDTH(POINTER_WIDTH), .CHAIN_LENGTH(SENDER_DELAY_CHAIN_LENGTH)) gray_code_chain_sender(.destination_clock(receiver_clock), .value(sender), .captured_value(moved_sender));
gray_code_chain #(.WIDTH(POINTER_WIDTH), .CHAIN_LENGTH(RECEIVER_DELAY_CHAIN_LENGTH)) gray_code_chain_receiver(.destination_clock(sender_clock), .value(receiver), .captured_value(moved_receiver));

// Sending logic
assign data_in_used = sender >= moved_receiver ? (sender - moved_receiver) : ~(moved_receiver - sender);

always_ff @(posedge sender_clock)
begin
    if (data_in_enable && data_in_used < POINTER_WIDTH'(LENGTH - 1))
    begin
        buffer[sender] <= data_in;
        sender <= sender + 1'd1;
    end
end 

// Receiving logic
assign data_out_used = moved_sender >= receiver ? (moved_sender - receiver) : ~(receiver - moved_sender);
assign data_out = buffer[receiver];

always_ff @(posedge receiver_clock)
    if (data_out_used > 0 && data_out_acknowledge)
        receiver <= receiver + 1'd1;

endmodule
