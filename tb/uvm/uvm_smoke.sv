module uvm_smoke;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "fifo_item.sv"
    class smoke_test extends uvm_test;

        `uvm_component_utils(smoke_test)

        function new(string name = "smoke_test",
                     uvm_component parent = null);
            super.new(name, parent);
        endfunction

    task run_phase(uvm_phase phase);
    
        fifo_item tx;

        phase.raise_objection(this);

        // Request a fifo_item object from the UVM factory
        tx = fifo_item::type_id::create("tx");

        // Assign values to the transaction
        tx.write   = 1;
        tx.read    = 0;
        tx.data_in = 8'hA5;
        tx.reset   = 1;

        // Print the transaction's values
        `uvm_info("FIFO_ITEM",
            $sformatf("write=%0b read=%0b data_in=%h reset=%0b",
                        tx.write, tx.read, tx.data_in, tx.reset),
            UVM_LOW)

        phase.drop_objection(this);

    endtask

    endclass

    initial begin
        run_test("smoke_test");
    end

endmodule