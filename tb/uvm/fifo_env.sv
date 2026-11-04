class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    function new(string name = "fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    fifo_agent agent;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
    endfunction

endclass //fifo_env extends uvm_env