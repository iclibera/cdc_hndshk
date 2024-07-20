# Sets up the directory and log file
cd ./simulation
vlog -work work -sv tb_cdc_handshake_ss.sv cdc_handshake_ss.sv
echo "Compilation Complete"

# Loads the simulation
vsim -novopt work.tb_cdc_handshake_ss
echo "Simulation Model Loaded"

# Sets simulation resolution and time
vlib work
vtimeformat -unit ns -precision 1
echo "Time format set to nanoseconds"

# Applies simulation runtime options
add wave -position end sim:/*
log -r /*

# Runs the simulation
run -all
echo "Simulation run complete"

# Optional
# stop
# quit

