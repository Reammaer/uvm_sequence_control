

module dut_test
(
    // First interface
    input logic         i_clk
,   input logic         i_reset
,   input logic [7:0]   i_data_A
,   input logic [7:0]   i_data_B
,   input logic         i_sel_op
,   output logic [15:0] o_data

    // Second interface
,   input logic         i_clk_fast
,   input logic  [7:0]  idata_fast
,   output logic [7:0]  odata_fast
);

    always_ff @(posedge i_clk) begin
        if (!i_reset) begin
            if (i_sel_op) begin
                o_data <= i_data_A + i_data_B;
            end else begin
                o_data <= i_data_A * i_data_B;
            end
        end
        else begin
            o_data <= 0;
        end
    end

    always_ff @(posedge i_clk_fast) begin
        odata_fast <= idata_fast;
    end

endmodule: dut_test