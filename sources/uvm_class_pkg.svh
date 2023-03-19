

package uvm_class_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "uvm_classes/base_transaction.sv"
    `include "uvm_classes/transaction_fast.sv"
    typedef uvm_sequencer #(base_transaction) sequencer;
    typedef uvm_sequencer #(transaction_fast) sequencer_fast;

    `include "uvm_classes/sequences/base_sequence.sv"
    `include "uvm_classes/sequences/base_sequence_nsel.sv"
    `include "uvm_classes/sequences/run_all_sequences.sv"
    `include "uvm_classes/sequences/sequence_fast.sv"
    `include "uvm_classes/driver.sv"
    `include "uvm_classes/driver_active.sv"
    `include "uvm_classes/driver_fast.sv"
    `include "uvm_classes/scoreboard.sv"
    `include "uvm_classes/monitor_fast.sv"
    `include "uvm_classes/monitor.sv"
    `include "uvm_classes/agent.sv"
    `include "uvm_classes/agent_fast.sv"
    `include "uvm_classes/environment.sv"
    `include "uvm_classes/base_test.sv"

endpackage: uvm_class_pkg