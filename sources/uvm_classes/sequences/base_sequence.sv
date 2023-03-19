

class base_sequence extends uvm_sequence#(base_transaction);
    `uvm_object_utils(base_sequence)

    // Transaction handle
    base_transaction base_transaction_h;

    // Sequence length
    int s_length = 20;

    extern function new     (string name = "base_sequence");
    extern task     body    ();

endclass: base_sequence


function base_sequence::new(string name = "base_sequence");
    super.new(name);
endfunction


task base_sequence::body();
    repeat(s_length) begin
        // Create a new transaction
        base_transaction_h = base_transaction::type_id::create("base_transaction_h");
        // Start transaction
        `uvm_do_with(base_transaction_h, 
                    { i_sel_op == 1; } )
    end
endtask: body