

quit -sim

cd ../questa

vlib work

vlog -work work ../sources/dut_if.sv
vlog -work work ../sources/dut_test.sv
vlog -work work ../tb/tb.sv


# UVM Variables
variable UVM_ACTIVE      1
variable UVM_PASSIVE     0
variable TRUE            1
variable FALSE           0
# Set variables for the UVM
# Test
variable TEST_NAME       base_test
variable TOPOLOGY_PRINT  $TRUE
variable DEBUG_CONNECT   $FALSE

variable PRINT_DRIVER        0
variable PRINT_DRIVER_FAST   1
variable PRINT_MONITOR       2
variable PRINT_MONITOR_FAST  3
variable PRINT_ALL           4

# Agent
variable AGENT_TYPE      $UVM_PASSIVE
variable FABRIC_PRINT    $TRUE    

vsim -novopt -t 1ns work.tb \
            +UVM_TESTNAME=$TEST_NAME \
            +uvm_set_config_int=uvm_test_top.env_h.agent_h,is_active,$AGENT_TYPE \
            +uvm_set_config_int=uvm_test_top.env_h.agent_h,print_factory,$FABRIC_PRINT \
            +uvm_set_config_int=uvm_test_top,print_topology,$TOPOLOGY_PRINT \
            +uvm_set_config_int=uvm_test_top,print_port_connection,$DEBUG_CONNECT \
            +uvm_set_config_int=uvm_test_top,print_ports,$PRINT_ALL


add wave -divider "Top-level signals"
add wave -radix unsigned tb/*

add wave -divider "Slow interface"
add wave -radix unsigned tb/_if/*

add wave -divider "Fast interface"
add wave -radix unsigned tb/_fast_if/*

run 10us