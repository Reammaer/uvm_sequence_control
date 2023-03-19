

class agent_fast extends uvm_agent;
    `uvm_component_utils(agent_fast)

    // Driver handle
    driver_fast  driver_fast_h;
    // Monitor handle
    monitor_fast monitor_fast_h;    
    // uvm_sequencer handle
    sequencer_fast sequencer_fast_h;

    extern function      new            (string name = "agent_fast", uvm_component parent);
    extern function void build_phase    (uvm_phase phase);
    extern function void connect_phase  (uvm_phase phase);

endclass: agent_fast


function agent_fast::new(string name = "agent_fast", uvm_component parent);
    super.new(name, parent);
endfunction: new


function void agent_fast::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create a new driver
    driver_fast_h = driver_fast::type_id::create("driver_fast_h", this);
    // Create a new uvm_sequencer
    sequencer_fast_h = sequencer_fast::type_id::create("sequencer_fast_h", this);
    // Create a new monitor
    monitor_fast_h = monitor_fast::type_id::create("monitor_fast_h", this);

endfunction: build_phase

function void agent_fast::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect driver with sequencer
    driver_fast_h.seq_item_port.connect(sequencer_fast_h.seq_item_export);

endfunction: connect_phase