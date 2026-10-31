class fifo_item extends uvm_sequence_item;
   
    `uvm_object_utils(fifo_item) 
    
    rand logic [7:0] data_in;
    rand bit write;
    rand bit read;
    logic reset;
    logic [7:0] data_out;
    logic full;
    logic empty;
    logic read_valid;

    function new(string name = "fifo_item");
        super.new(name);
    endfunction
endclass