

class base_transaction extends uvm_sequence_item;
    `uvm_object_utils(base_transaction)

    randc logic [7:0]   i_data_A;
    randc logic [7:0]   i_data_B;
    randc logic         i_sel_op;

    logic [15:0]        o_data;

    extern function new (string name = "");

endclass: base_transaction


function base_transaction::new(string name = "");
    super.new(name);
endfunction: new


