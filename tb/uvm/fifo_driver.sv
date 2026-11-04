class fifo_driver extends uvm_driver #(fifo_item);
    `uvm_component_utils(fifo_driver)

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //Declaring virtual interface to connect to our fifo interface we declared in fifo_tb
    virtual fifo_if vif;

    //Build phase: using this vif to connect to the fifo_bus if
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(
        this,
        "",
        "vif",
        vif
    )) begin
        `uvm_fatal("NO_VIF", "Virtual interface not found")
    end     
    endfunction

    task automatic run_phase(uvm_phase phase);
        
        fifo_item tx;

        vif.reset = 0; 
        forever begin
            // Wait for falling edge and take in the new transaction
            @(negedge vif.clk);

            //Try to get next transaction from the sequencer
            seq_item_port.try_next_item(tx);

            //If transaction available, we feed the values to the dut, otherwise we put the dut inputs in idle
            if (tx != null) begin        
                vif.data_in = tx.data_in;
                vif.write   = tx.write;
                vif.read    = tx.read;
                vif.reset   = tx.reset;       
           
            // Wait for FIFO's sampling edge
            @(posedge vif.clk);
            seq_item_port.item_done();
            end else begin
                vif.write = 0;
                vif.read = 0;
                vif.reset = 1;
                end
        end
    endtask 
endclass //fifo_driver extends uvm_driver #(fifo_item)