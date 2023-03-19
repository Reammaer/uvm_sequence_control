

class cmdline_processor extends uvm_report_object;
    `uvm_object_utils(cmdline_processor)

    extern function         new(string name = "cmdline_processor");

    extern function void    build_phase(uvm_phase phase);

endclass: cmdline_processor


function cmdline_processor::new(string name = "cmdline_processor");
    super.new(name);
endfunction: new


function void cmdline_processor::build_phase(uvm_phase phase);
    uvm_cmdline_processor cmd_line;
    cmd_line = uvm_cmdline_processor::get_inst();

endfunction: build_phase