module sync_fifo(
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
    read_valid <= 0;
    if (!reset) begin
        occupancy_counter <= 0;
        read_ptr <= 4'd0;
        write_ptr <= 4'd0;
        read_valid <= 0;
        end 
    
    //Here we deal with the different functionalities of the FIFO
    else begin
        //Normal operation - i.e. count is neither full or empty and we perform normal reads and writes
        if (occupancy_counter < 16 && write == 1 && read == 0 ) begin
                occupancy_counter <= occupancy_counter + 1'b1;
                write_ptr <= write_ptr + 1'b1;
                fifo[write_ptr] <= data_in;
            end
        else if ( 0 < occupancy_counter && occupancy_counter <= 16 && write == 0 && read == 1) begin
                occupancy_counter <= occupancy_counter - 1;
                data_out <= fifo[read_ptr];
                read_ptr <= read_ptr + 1;
                read_valid <= 1;
            end
    
        //Now we deal with some edge cases
        //First is what happens if fifo is empty and we try to read. read valid status should go low
        else if (occupancy_counter == 0 && read == 1 && write == 0) begin
                read_valid <= 0;
            end
        
        //If the fifo is neither full or empty and we attempt to read and write simultaneously
        else if ( 0 < occupancy_counter && occupancy_counter < 16 && write == 1 && read == 1) begin
                data_out <= fifo[read_ptr];
                fifo[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                read_ptr <= read_ptr + 1;
                read_valid <= 1;
            end
        
        //If the fifo is empty and we try to read and write at the same time, we bypass the fifo and just set data_out to data_in. read_ptr and write_ptr should stay at the same location
        else if (occupancy_counter == 0 && write == 1 && read == 1)begin
                data_out <= data_in;
                read_valid <= 1;
            end
        
        //If fifo is full and we try to read and write at the same time, data_out gets what read_ptr is at. read_ptr increments. write_ptr writes data_in to where it's at then increments
        else if (occupancy_counter == 16 && write == 1 && read == 1)begin
                data_out <= fifo[read_ptr];
                read_ptr <= read_ptr + 1;
                write_ptr <= write_ptr + 1;
                fifo[write_ptr] <= data_in;
                read_valid <= 1;
            end 
    end
end


// Deals with full and empty status flags, if count is full then full is high, empty low
//Vice verse if count is empty
    assign full = (occupancy_counter == 16);
    assign empty = (occupancy_counter == 0);
endmodule
