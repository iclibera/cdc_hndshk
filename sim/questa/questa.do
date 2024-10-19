# Sets up the directory
vlog -work work -sv sim/checker_sim.sv sim/stimulus_sim.sv sim/testbench.sv hdl/cdc_handshake_ss.sv
echo "Compilation Complete"

# Loads the simulation
vopt work.testbench -o optimized_tb +acc
echo "Simulation loaded"

# Sets simulation library
vlib work

# Runs the simulation
vsim -vopt optimized_tb

# Applies simulation runtime options
add wave -position end -radix unsigned /testbench/error_count
add wave -position end -radix unsigned /testbench/stimulus_inst/*
# Leaf toggle
config wave -signalnamewidth 1

run -all
echo "Simulation run complete"

# stop
# quit