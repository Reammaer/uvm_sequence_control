

class sequence_fast extends uvm_sequence#(transaction_fast);
    `uvm_object_utils(sequence_fast)

    // Transaction handle
    transaction_fast transaction_fast_h;

    
    extern function new     (string name = "sequence_fast");
    extern task     body    ();

endclass: sequence_fast


function sequence_fast::new(string name = "sequence_fast");
    super.new(name);
endfunction


task sequence_fast::body();
    forever begin
        // Create a new transaction
        transaction_fast_h = transaction_fast::type_id::create("transaction_fast_h");
        // Start transaction
        `uvm_do(transaction_fast_h)
    end
endtask: body