module synch_fifo(
    input logic [7:0] data_in,
    input logic clk,
    input logic reset,
    output logic full,
    output logic empty,
    input logic read,
    input logic write,
    output logic [7:0] data_out,
    output logic read_valid
);
logic [7:0] fifo [15:0];
logic [3:0] read_ptr;
logic [3:0] write_ptr;
logic [4:0] occupancy_counter;


// This deals with synchnronous reset. If reset is '0' at the rising clk edge, counter,
//pointers, and whether the read was valid or not all get reset back to zero
always_ff@(posedge clk) begin
    if (!reset) begin
        occupancy_counter <= 0;
        read_ptr <= 4'd0;
        write_ptr <= 4'd0;
        read_valid <= 0;
        end 
    end
    
// Here I am going to deal with all the potential situations of my FIFO + 
// Potential inputs    


// Deals with full and empty status flags, if count is full then full is high, empty low
//Vice verse if count is empty
    assign full = (occupancy_counter == 16);
    assign empty = (occupancy_counter == 0);
endmodule
