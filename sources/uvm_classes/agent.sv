

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    // Driver handle
    driver  driver_h;
    // Monitor handle
    monitor monitor_h;    
    // uvm_sequencer handle
    sequencer uvm_sequencer_h; 
    // factory print enable/disable
    int print_factory = 0;

    extern function      new            (string name = "agent", uvm_component parent);
    extern function void build_phase    (uvm_phase phase);
    extern function void connect_phase  (uvm_phase phase); 

endclass: agent

function agent::new(string name = "agent", uvm_component parent);
    super.new(name, parent);
endfunction: new

function void agent::build_phase(uvm_phase phase);
    // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();

    super.build_phase(phase); 

    // Set factory to override "driver" by "driver_active"
    if (get_is_active() == UVM_ACTIVE) begin
        factory.set_type_override_by_name("driver", "driver_active");
    end 
    // Create a new driver
    driver_h = driver::type_id::create("driver_h", this);
    // Create a new uvm_sequencer
    uvm_sequencer_h = sequencer::type_id::create("uvm_sequencer", this);
    // Create a new monitor
    monitor_h = monitor::type_id::create("monitor_h", this);

    // Print factory configuration
    if (!uvm_config_db#(uvm_bitstream_t)::get(this, "", "print_factory", print_factory)) begin
        `uvm_fatal("Agent", "Can't get print_factory")
    end else begin
        if (print_factory) begin
            factory.print();
        end
    end    

endfunction: build_phase

function void agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect driver with sequencer
    driver_h.seq_item_port.connect(uvm_sequencer_h.seq_item_export);

endfunction: connect_phase