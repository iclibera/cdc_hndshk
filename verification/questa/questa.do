# Sets up the directory
vlog -work work -sv verification/checker_sim.sv verification/stimulus_sim.sv verification/tb_cdc_handshake_ss.sv hdl/cdc_handshake_ss.sv
echo "Compilation Complete"

# Loads the simulation
vopt work.tb_cdc_handshake_ss -o optimized_tb +acc
echo "Simulation loaded"

# Sets simulation library
vlib work

# Runs the simulation
vsim -vopt optimized_tb

# Applies simulation runtime options
add wave -position end -radix unsigned /tb_cdc_handshake_ss/error_count
add wave -position end -radix unsigned /tb_cdc_handshake_ss/stimulus_inst/*
# Leaf toggle
config wave -signalnamewidth 1

run -all
echo "Simulation run complete"

# stop
# quit