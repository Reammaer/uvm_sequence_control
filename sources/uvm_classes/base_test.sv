

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    // Interface handle
    virtual dut_if      vif;
    virtual dut_fast_if v_fast_if;

    // Sequence handle
    run_all_sequences   run_all_sequences_h;
    sequence_fast       sequence_fast_h;

    // Environment handle
    environment     env_h;

    // Enable/disbable printing topology
    int print_topology          = 0;
    // Enable/disable printing connections
    int print_port_connection   = 0;
    typedef enum int {  PRINT_DRIVER        = 'd0,
                        PRINT_DRIVER_FAST   = 'd1,
                        PRINT_MONITOR       = 'd2,
                        PRINT_MONITOR_FAST  = 'd3,
                        PRINT_ALL           = 'd4} print_ports_t;
    int print_ports = PRINT_ALL;

    extern function      new                        (string name = "base_test", uvm_component parent = null);
    extern function void build_phase                (uvm_phase phase);
    extern function void end_of_elaboration_phase   (uvm_phase phase);
    extern task          run_phase                  (uvm_phase phase);

endclass: base_test


function base_test::new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
endfunction: new


function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create a new environment
    env_h = environment::type_id::create("env_h", this);
    // Get interface from the tb
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "dut_if", vif)) begin
        `uvm_fatal("Base test", "Interface vif is not connected to the test!")
    end
    if (!uvm_config_db#(virtual dut_fast_if)::get(this, "", "dut_fast_if", v_fast_if)) begin
        `uvm_fatal("Base test", "Interface v_fast_if is not connected to the test!")
    end
    // Connect interface to other uvm components
    uvm_config_db#(virtual dut_if)::set(this, "*", "dut_if", vif);
    uvm_config_db#(virtual dut_fast_if)::set(this, "*", "dut_fast_if", v_fast_if);
    // Create new sequences
    run_all_sequences_h = run_all_sequences::type_id::create("run_all_sequences_h"); 
    sequence_fast_h = sequence_fast::type_id::create("sequence_fast_h");

endfunction: build_phase


function void base_test::end_of_elaboration_phase(uvm_phase phase);
    if (!uvm_config_db#(uvm_bitstream_t)::get(this, "", "print_topology", print_topology)) begin
            `uvm_fatal("Base_test", "Can't get print_topology")
    end else begin
        if (print_topology) begin
            uvm_top.print_topology();
        end
    end

    // Check driver port connection working
    if (!uvm_config_db#(uvm_bitstream_t)::get(this, "", "print_port_connection", print_port_connection)) begin
            `uvm_fatal("Base_test", "Can't get print_port_connection")
    end else begin
        if (print_port_connection) begin
            uvm_report_info(get_full_name(), "Debugging Port Connection", UVM_LOW);

            if (!uvm_config_db#(uvm_bitstream_t)::get(this, "", "print_ports", print_ports)) begin
                `uvm_fatal("Base_test", "Can't get print_ports")
            end else begin
                case(print_ports)
                    PRINT_DRIVER: begin
                        `uvm_info("Base_test", "PRINT_DRIVER", UVM_LOW)
                        env_h.agent_h.driver_h.seq_item_port.debug_connected_to();
                        env_h.agent_h.driver_h.seq_item_port.debug_provided_to();
                    end
                    PRINT_DRIVER_FAST: begin
                        `uvm_info("Base_test", "PRINT_DRIVER_FAST", UVM_LOW)
                        env_h.agent_fast_h.driver_fast_h.seq_item_port.debug_connected_to();
                        env_h.agent_fast_h.driver_fast_h.seq_item_port.debug_provided_to();
                    end
                    PRINT_MONITOR: begin
                        `uvm_info("Base_test", "PRINT_MONITOR", UVM_LOW)
                        env_h.agent_h.monitor_h.analysis_port_h.debug_connected_to();
                        env_h.agent_h.monitor_h.analysis_port_h.debug_provided_to();
                    end
                    PRINT_MONITOR_FAST: begin
                        `uvm_info("Base_test", "PRINT_MONITOR_FAST", UVM_LOW)
                        env_h.agent_fast_h.monitor_fast_h.analysis_port_fast_h.debug_connected_to();
                        env_h.agent_fast_h.monitor_fast_h.analysis_port_fast_h.debug_provided_to();
                    end
                    PRINT_ALL: begin
                        `uvm_info("Base_test", "PRINT_DRIVER", UVM_LOW)
                        env_h.agent_h.driver_h.seq_item_port.debug_connected_to();
                        env_h.agent_h.driver_h.seq_item_port.debug_provided_to();
                        `uvm_info("Base_test", "PRINT_DRIVER_FAST", UVM_LOW)
                        env_h.agent_fast_h.driver_fast_h.seq_item_port.debug_connected_to();
                        env_h.agent_fast_h.driver_fast_h.seq_item_port.debug_provided_to();
                        `uvm_info("Base_test", "PRINT_MONITOR", UVM_LOW)
                        env_h.agent_h.monitor_h.analysis_port_h.debug_connected_to();
                        env_h.agent_h.monitor_h.analysis_port_h.debug_provided_to();
                        `uvm_info("Base_test", "PRINT_MONITOR_FAST", UVM_LOW)
                        env_h.agent_fast_h.monitor_fast_h.analysis_port_fast_h.debug_connected_to();
                        env_h.agent_fast_h.monitor_fast_h.analysis_port_fast_h.debug_provided_to();
                    end
                endcase
            end
        end
    end

endfunction: end_of_elaboration_phase


task base_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    // Starting transactions
    phase.raise_objection(this);
    fork
        // Slow transactions
        for (int i = 0; i < 10; i++) begin
            run_all_sequences_h.start(env_h.agent_h.uvm_sequencer_h);
        end
        // Fast transaction
        begin
            sequence_fast_h.start(env_h.agent_fast_h.sequencer_fast_h);            
        end
    join_any  
    // Finishing transactions
    phase.drop_objection(this);  

endtask: run_phase