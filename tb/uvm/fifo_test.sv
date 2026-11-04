class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test) //Registers class in UVM Factory

    //Class constructor with parent constructor as well.
    function new(string name = "fifo_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    fifo_env env; //Creates a handle that will reference a fifo_env type
    
    //THis builds the env which cause a domino effect of the rest of the UVM infrastructure getting built because env builds agents which builds driver, sequencer, and so on
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Request a fifo_env object from the UVM factory
        env = fifo_env::type_id::create("env", this);
        
    endfunction

    //Initiates the sequence domino effect. As in, starts the sequence -> sequencer -> driver and so on effect
    task run_phase (uvm_phase phase);
        
        fifo_sequence seq;
        super.run_phase(phase);
        seq = fifo_sequence::type_id::create("seq");
        
        phase.raise_objection(this);
        //This tells our sequencer to start the sequence i.e. start the body() task.
        seq.start(env.agent.sequencer);
        #3ns //This causes a delay to ensure monitor has enough time to sample before the objection is dropped and our UVM infrastructure is killed. this is a quick fix, need to change later.
        phase.drop_objection(this);
        
    endtask
endclass //fifo_test extends uvm_test