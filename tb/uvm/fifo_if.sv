interface fifo_if;
    logic clk;
    logic [7:0] data_in;
    logic write;
    logic read;
    logic reset;
    logic [7:0] data_out;
    logic full;
    logic empty;
    logic read_valid;
endinterface //fifo_if  