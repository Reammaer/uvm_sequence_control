
`uvm_analysis_imp_decl(_first)
`uvm_analysis_imp_decl(_second)

// Check analysis port connection
`define CHECK_PORT_CONNECTION(PORT) \
    begin   \
        uvm_port_list list;  \
        PORT.get_provided_to(list);   \
        if (!list.size()) begin \
            `uvm_fatal("Scoreboard Analysis Port Connection",   \
                $sformatf("Analysis port %s not connected", PORT.get_full_name())); \
        end \
        else begin  \
            `uvm_info("Scoreboard Analysis Port Connection",    \
               $sformatf("Analysis port %s is connected", PORT.get_full_name()),  \
                UVM_LOW)    \
        end \
    end     \

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    // analysis port handle
    uvm_analysis_imp_first #(base_transaction, scoreboard) m_analysis_imp;
    uvm_analysis_imp_second #(transaction_fast, scoreboard) m_analysis_imp_fast;

    // Main phases
    extern function      new        (string name = "scoreboard", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    // Writes
    extern function void write_first(base_transaction pkg);
    extern function void write_second(transaction_fast pkg);

    // Elaboration
    extern function void end_of_elaboration_phase(uvm_phase phase); 

endclass: scoreboard


function scoreboard::new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
endfunction: new


function void scoreboard::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // If the component is enable, then
    `CHECK_PORT_CONNECTION(m_analysis_imp)
    `CHECK_PORT_CONNECTION(m_analysis_imp_fast)
endfunction: end_of_elaboration_phase


function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create a new analysis port
    m_analysis_imp      = new("m_analysis_imp", this);
    m_analysis_imp_fast = new("m_analysis_imp_fast", this); 
endfunction: build_phase


function void scoreboard::write_first(base_transaction pkg);    
    if (pkg.o_data != pkg.i_data) begin
        `uvm_error("scoreboard", 
                    $sformatf("pkg.idata=%0d pkg.odata=%0d", pkg.i_data, pkg.o_data));
    end else begin
        `uvm_info("scoreboard", 
                    $sformatf("pkg.idata=%0d pkg.odata=%0d", pkg.i_data, pkg.o_data),
                    UVM_HIGH)
    end

endfunction: write_first


function void scoreboard::write_second(transaction_fast pkg);    
    if (pkg.o_data_fast != pkg.i_data_fast) begin
        `uvm_error("scoreboard", 
                    $sformatf("pkg.idata=%0d pkg.odata=%0d", pkg.i_data_fast, pkg.o_data_fast));
    end else begin
        `uvm_info("scoreboard", 
                    $sformatf("pkg.idata=%0d pkg.odata=%0d", pkg.i_data_fast, pkg.o_data_fast),
                    UVM_HIGH)
    end

endfunction: write_second