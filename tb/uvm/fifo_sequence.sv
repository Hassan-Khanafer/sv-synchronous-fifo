class fifo_sequence extends uvm_sequence #(fifo_item);
    `uvm_object_utils(fifo_sequence)

    //Class constructor, unlike components, this is an object, so it takes no 'parent' parameter
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction

    

    virtual task body();
    
        fifo_item tx;
        tx = fifo_item::type_id::create("tx");
    
        //Here we attempt to send transactions to the sequencer
        start_item(tx);
        tx.data_in = 8'd111;
        tx.write = 1;
        tx.read = 0;
        tx.reset = 1;
        finish_item(tx);
    endtask

endclass //fifo_sequence extends uvm_sequence