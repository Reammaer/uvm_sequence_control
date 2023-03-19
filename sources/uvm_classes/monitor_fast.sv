

class monitor_fast extends uvm_monitor;
    `uvm_component_utils(monitor_fast)

    extern function      new        (string name = "monitor_fast", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task          run_phase  (uvm_phase phase);

    // Analysis port handle
    uvm_analysis_port #(transaction_fast) analysis_port_fast_h;

    // Interface handle
    virtual dut_fast_if v_fast_if;

endclass: monitor_fast


function monitor_fast::new(string name = "monitor_fast", uvm_component parent);
    super.new(name, parent);
endfunction: new


function void monitor_fast::build_phase(uvm_phase phase);
    // Connect interface
    if (!uvm_config_db#(virtual dut_fast_if)::get(this, "", "dut_fast_if", v_fast_if)) begin
        `uvm_fatal("monitor_fast", "Could not get interface connection")
    end
    // Create a new analysis port
    analysis_port_fast_h = new("analysis_port_fast_h", this);

endfunction: build_phase


task monitor_fast::run_phase(uvm_phase phase);
    // Creatre a new transaction
    transaction_fast item_fast_h;
    item_fast_h = transaction_fast::type_id::create("item_fast_h");
    forever begin
        @(posedge v_fast_if.clk_fast);
            item_fast_h.i_data_fast = v_fast_if.i_data_fast;
            @(posedge v_fast_if.clk_fast);
                item_fast_h.o_data_fast = v_fast_if.o_data_fast;
        analysis_port_fast_h.write(item_fast_h);
    end 
endtask: run_phase