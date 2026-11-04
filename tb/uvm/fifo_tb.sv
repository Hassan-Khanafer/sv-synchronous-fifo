timeunit 1ns;
timeprecision 1ps;

module fifo_tb;
    import uvm_pkg::*;
    
    fifo_if fifo_bus();
    initial fifo_bus.clk = 0;
    always #5 fifo_bus.clk = ~fifo_bus.clk;

    sync_fifo dut(
        .data_in(fifo_bus.data_in),
        .clk(fifo_bus.clk),
        .reset(fifo_bus.reset),
        .full(fifo_bus.full),
        .empty(fifo_bus.empty),
        .read(fifo_bus.read),
        .write(fifo_bus.write),
        .data_out(fifo_bus.data_out),
        .read_valid(fifo_bus.read_valid)
    );
   
    initial begin
        
        //"Set" function for driver to be able to connect to DUT
        uvm_config_db#(virtual fifo_if)::set(
        null,
        "uvm_test_top.env.agent.driver",
        "vif",
        fifo_bus
        );
        //"Set" function for monitor to be able to connect to DUT
        uvm_config_db#(virtual fifo_if)::set(
        null,
        "uvm_test_top.env.agent.monitor",
        "vif",
        fifo_bus
        );

        //Once we've done both, we can start our test class
        run_test("fifo_test");
    end
endmodule