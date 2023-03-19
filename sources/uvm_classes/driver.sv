

class driver extends uvm_driver#(base_transaction);
    `uvm_component_utils(driver)

    // Interface handle
    virtual dut_if vif;

    extern function      new        (string name = "driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task          run_phase  (uvm_phase phase);

endclass: driver


function driver::new(string name = "driver", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void driver::build_phase(uvm_phase phase);
    // Check interface connection
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_if", vif)) begin
        `uvm_fatal("Driver", "Could not get interface connection")
    end
endfunction: build_phase

task driver::run_phase(uvm_phase phase);
    // Trasnaction handle
    base_transaction base_transaction_h;

    forever begin
        @(posedge vif.clk)
            // Get a new transaction                         
            seq_item_port.get_next_item(base_transaction_h);
            vif.i_data_A   <= base_transaction_h.i_data_A;
            vif.i_data_B   <= base_transaction_h.i_data_B;
            vif.i_sel_op   <= base_transaction_h.i_sel_op;
            // Waiting for the new data
            seq_item_port.item_done();
    end

endtask: run_phase