
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "../sources/uvm_class_pkg.svh"
import uvm_class_pkg::*;

let CLK_PERIOD      = 10;
let RESET_DURATION  = 45;

module tb;

    // Time units
    timeunit        1ns;
    timeprecision   1ns;

    // Initialize global clock
    bit clk;
    always#(CLK_PERIOD) clk = ~clk;
    global clocking @(posedge clk);
    endclocking

    // Initialize fast clock
    bit clk_fast;
    always#(CLK_PERIOD/2) clk_fast = ~clk_fast;

    // Initialize interfaces
    dut_if      _if         (clk);
    dut_fast_if _fast_if    (clk_fast);

    // Initialize global reset
    initial begin
        _if.i_reset = 0;
        #(RESET_DURATION) _if.i_reset = 1;
        #(RESET_DURATION) _if.i_reset = 0;
    end

    // Initialize dut
    dut_test
    dut
    (
    // Slow part
        .i_clk          (clk                )
    ,   .i_reset        (_if.i_reset        )
    ,   .i_data_A       (_if.i_data_A       )
    ,   .i_data_B       (_if.i_data_B       )
    ,   .i_sel_op       (_if.i_sel_op       )
    ,   .o_data         (_if.o_data         )
    // Fast part
    ,   .i_clk_fast     (clk_fast            )
    ,   .idata_fast     (_fast_if.i_data_fast)
    ,   .odata_fast     (_fast_if.o_data_fast)
    );

    // Run stimulus
    initial begin
        // Connect uvm_test_top interface with test
        uvm_config_db#(virtual dut_if)::set(null, "uvm_test_top", "dut_if", _if);
        uvm_config_db#(virtual dut_fast_if)::set(null, "uvm_test_top", "dut_fast_if", _fast_if);
        // Run appropriate test
        run_test();
    end

endmodule: tb