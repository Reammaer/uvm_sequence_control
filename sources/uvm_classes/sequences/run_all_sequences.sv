

class run_all_sequences extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(run_all_sequences)

    // Sequence handles
    base_sequence       base_sequence_h;
    base_sequence_nsel  base_sequence_nsel_h;

    // Constructor
    extern function new     (string name = "run_all_sequences");

    // Main phases
    extern task     pre_body();
    extern task     body    ();

endclass: run_all_sequences


function run_all_sequences::new(string name = "run_all_sequences");
    super.new(name);       
endfunction: new


// The *_body() callbacks are designed to be skipped for child sequences,
// while *_start() callbacks are executed for all sequences
task run_all_sequences::pre_body();
    base_sequence_h         = base_sequence::type_id::create("base_sequence_h");
    base_sequence_nsel_h    = base_sequence_nsel::type_id::create("base_sequence_nsel_h");
endtask: pre_body


task run_all_sequences::body();
    base_sequence_h.start(m_sequencer);
    base_sequence_nsel_h.start(m_sequencer);
endtask