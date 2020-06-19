module gray_code_chain #(
    parameter int WIDTH,
    parameter int CHAIN_LENGTH = 1,
    parameter logic [WIDTH-1:0] INITIAL_VALUE = WIDTH'(0)
) (
    input logic destination_clock,
    input logic [WIDTH-1:0] value,
    output logic [WIDTH-1:0] captured_value = INITIAL_VALUE
);

logic [WIDTH-1:0] gray_value, degray_value;
logic [WIDTH-1:0] value_chain [CHAIN_LENGTH-1:0] = '{CHAIN_LENGTH{INITIAL_VALUE}};

gray_code #(.WIDTH(WIDTH)) gray_code_receiver(.in(value), .out(gray_value));
gray_code #(.WIDTH(WIDTH), .INVERT(1)) degray_code_receiver(.in(value_chain[0]), .out(degray_value));

always_ff @(posedge destination_clock)
begin
    if (CHAIN_LENGTH > 1)
    begin
        value_chain[CHAIN_LENGTH-1] <= gray_value;
        value_chain[CHAIN_LENGTH-2:0] <= value_chain[CHAIN_LENGTH-1:1];
    end
    else
        value_chain <= '{gray_value};
    captured_value <= degray_value;
end

endmodule
