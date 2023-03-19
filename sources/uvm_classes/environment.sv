

class environment extends uvm_env;
    `uvm_component_utils(environment)

    // Agent handle
    agent       agent_h;
    // Agent fast handle
    agent_fast  agent_fast_h;

    // Scoreboard handle
    scoreboard  scoreboard_h;

    uvm_active_passive_enum is_active = UVM_PASSIVE;

    extern function      new            (string name, uvm_component parent);
    extern function void build_phase    (uvm_phase phase);
    extern function void connect_phase  (uvm_phase phase); 

endclass: environment


function environment::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction: new


function void environment::build_phase(uvm_phase phase);
    super.build_phase(phase);     
    // Create a new agent
    agent_h = agent::type_id::create("agent_h", this);  
    agent_fast_h = agent_fast::type_id::create("agent_fast_h", this);
    // Create a new scoreboard
    scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);

endfunction: build_phase


function void environment::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Connect monitor and scoreboard
    agent_h.monitor_h.analysis_port_h.connect(scoreboard_h.m_analysis_imp);
    agent_fast_h.monitor_fast_h.analysis_port_fast_h.connect(scoreboard_h.m_analysis_imp_fast);
endfunction: connect_phase