

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    extern function      new        (string name = "monitor", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task          run_phase  (uvm_phase phase);

    // Analysis port handle
    uvm_analysis_port #(base_transaction) analysis_port_h;

    // Interface handle
    virtual dut_if vif;

endclass: monitor


function monitor::new(string name = "monitor", uvm_component parent);
    super.new(name, parent);
endfunction: new


function void monitor::build_phase(uvm_phase phase);
    // Connect interface
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_if", vif)) begin
        `uvm_fatal("monitor", "Could not get interface connection")
    end
    // Create a new analysis port
    analysis_port_h = new("analysis_port_h", this);

endfunction: build_phase


task monitor::run_phase(uvm_phase phase);
    // Creatre a new transaction
    base_transaction item_h;
    item_h = base_transaction::type_id::create("item_h");
    forever begin
        @(posedge vif.clk);
            if (!vif.i_reset) begin
                item_h.i_data = vif.i_data;  
                @(posedge vif.clk);
                    item_h.o_data = vif.o_data;              
            end      
        analysis_port_h.write(item_h);
    end 
endtask: run_phase