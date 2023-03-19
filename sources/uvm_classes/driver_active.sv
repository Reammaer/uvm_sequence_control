

class driver_active extends driver;
    `uvm_component_utils(driver_active)

    extern function new         (string name = "driver_active", 
                                    uvm_component parent);

    extern task     run_phase   (uvm_phase phase);

endclass: driver_active


function driver_active::new(string name = "driver_active",
                                uvm_component parent);
    super.new(name, parent);
endfunction: new


task driver_active::run_phase(uvm_phase phase);

    // Trasnaction handle
    base_transaction base_transaction_h;

    forever begin
        @(posedge vif.clk)
            // Get a new transaction                         
            seq_item_port.get_next_item(base_transaction_h);
            vif.i_data   <= 'hFF;
            // Waiting for the new data
            seq_item_port.item_done();
    end
        
endtask: run_phase