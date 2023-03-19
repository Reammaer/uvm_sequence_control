

class transaction_fast extends uvm_sequence_item;
    `uvm_object_utils(transaction_fast)

    randc logic [7:0]   i_data_fast;
    logic [7:0]         o_data_fast;

    extern function new (string name = "");

endclass: transaction_fast


function transaction_fast::new(string name = "");
    super.new(name);
endfunction: new