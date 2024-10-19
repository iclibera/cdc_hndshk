# Set up the directory and compile the design
xvlog -sv verification/checker_sim.sv verification/stimulus_sim.sv verification/tb_cdc_handshake_ss.sv hdl/cdc_handshake_ss.sv
echo "Compilation Complete"

# Elaborate the design
xelab -debug typical work.tb_cdc_handshake_ss -s sim_snapshot

# Run the simulation with the elaborated design
xsim sim_snapshot -R -gui

# Load and run the simulation
open_waveform setup.wcfg
run all
echo "Simulation run complete"