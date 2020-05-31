module fifo_tb();

localparam WIDTH = 16;
localparam LENGTH = 256;

fifo #(.WIDTH(WIDTH), .LENGTH(LENGTH)) fifo();

endmodule
