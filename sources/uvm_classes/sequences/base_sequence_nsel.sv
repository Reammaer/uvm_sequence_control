

class base_sequence_nsel extends uvm_sequence#(base_transaction);
    `uvm_object_utils(base_sequence_nsel)

    // Transaction handle
    base_transaction base_transaction_h;

    // Sequence length
    int s_length = 20;

    extern function new     (string name = "base_sequence_nsel");
    extern task     body    ();

endclass: base_sequence_nsel


function base_sequence_nsel::new(string name = "base_sequence_nsel");
    super.new(name);
endfunction


task base_sequence_nsel::body();
    repeat(s_length) begin
        // Create a new transaction
        base_transaction_h = base_transaction::type_id::create("base_transaction_h");
        // Start transaction
        `uvm_do_with(base_transaction_h, 
                    { i_sel_op == 0; } )
    end
endtask: body