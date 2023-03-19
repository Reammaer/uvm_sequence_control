
// Slow interface
interface dut_if (input clk);

    logic           i_reset         ;
    logic [7:0]     i_data_A = 0    ;
    logic [7:0]     i_data_B = 0    ;
    logic           i_sel_op = 0    ;   
    logic [15:0]    o_data          ;

endinterface: dut_if


// Fast interface
interface dut_fast_if (input clk_fast);

    logic [7:0]     i_data_fast ;
    logic [7:0]     o_data_fast ;

endinterface: dut_fast_if