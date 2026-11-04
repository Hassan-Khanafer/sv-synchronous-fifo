package fifo_uvm_pkg;

    // Import UVM classes and definitions
    import uvm_pkg::*;

    // Import UVM macros
    `include "uvm_macros.svh"

    // Transaction definition
    `include "fifo_item.sv"
    `include "fifo_sequence.sv"

    // UVM agent components
    `include "fifo_sequencer.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"

    // UVM hierarchy
    `include "fifo_agent.sv"
    `include "fifo_env.sv"

    // Test
    `include "fifo_test.sv"

endpackage : fifo_uvm_pkg
