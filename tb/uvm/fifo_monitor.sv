class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)


    function new(string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //Declaring vif to connect to DUT interface created in fifo_tb. Declaring analysis port to allow broadcasting DUT outputs
    virtual fifo_if vif;
    uvm_analysis_port #(fifo_item) fifo_item_broadcast;
    
    //Build phase: using this vif to connect to the fifo_bus if
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        //Mechanism that recieves transactions and broadcasts them to listeners such as the scoreboard or the coverage collector
        fifo_item_broadcast = new("fifo_item_broadcast", this);

        //Assigns our vif handle to the right interface
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
        
        //Creating a fifo_item handle to store all the DUT values in
       fifo_item tx;
        
        forever begin         
            //Each transaction gets its own fifo_item
            tx = fifo_item::type_id::create("tx");
            
            //At each posedge of our clock, we wait 2ns for the DUT results to settle, then we sample and distribute
            @(posedge vif.clk)begin
                #2ns; //This ensures fifo results have settled and we can sample appropriate values
                tx.data_in = vif.data_in;    
                tx.write = vif.write;
                tx.read = vif.read;
                tx.reset = vif.reset;
                tx.full = vif.full;
                tx.empty = vif.empty;
                tx.data_out = vif.data_out;
                tx.read_valid = vif.read_valid;

                //This prints the results 
                `uvm_info("FIFO_MON", $sformatf("write=%0b, data_in=%0d, empty=%0b",tx.write, tx.data_in, tx.empty),UVM_LOW);

                //Write to all listeners
                fifo_item_broadcast.write(tx);
                end
            end
    endtask 
endclass //fifo_monitor extends uvm_monitor 