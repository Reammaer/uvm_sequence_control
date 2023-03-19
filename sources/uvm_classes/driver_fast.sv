

class driver_fast extends uvm_driver#(transaction_fast);
    `uvm_component_utils(driver_fast)

    // Interface handle
    virtual dut_fast_if v_fast_if;

    extern function      new        (string name = "driver_fast", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task          run_phase  (uvm_phase phase);


endclass: driver_fast


function driver_fast::new(string name = "driver_fast", uvm_component parent);
    super.new(name, parent);
endfunction: new


function void driver_fast::build_phase(uvm_phase phase);
    // Check interface connection
    if (!uvm_config_db#(virtual dut_fast_if)::get(this, "", "dut_fast_if", v_fast_if)) begin
        `uvm_fatal("Driver", "Could not get interface connection")
    end
endfunction: build_phase


task driver_fast::run_phase(uvm_phase phase);
    // Trasnaction handle
    transaction_fast transaction_fast_h;

    forever begin
        @(posedge v_fast_if.clk_fast);
            // Get a new transaction                         
            seq_item_port.get_next_item(transaction_fast_h);
            v_fast_if.i_data_fast   <= transaction_fast_h.i_data_fast;
            // // Waiting for the new data
            seq_item_port.item_done();
    end

endtask: run_phase