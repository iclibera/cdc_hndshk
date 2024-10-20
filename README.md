# CDC Handshake Module and Testbench
## Example simulation on Questa/ModelSim
### On Windows Command Prompt (assuming QuestaSim/ModelSim installed)
```
git clone https://github.com/iclibera/common_rtl.git
git clone https://github.com/iclibera/cdc_hndshk.git
cd cdc_hndshk/
vsim -c -do sim/questa/questa.do
```
### Explanation
There are one RTL and 3 testbench files: \
\
RTL = `hdl/cdc_handshake_ss.sv` \
Testbench = `sim/testbench.sv` \
Submodules = `sim/stimulus_sim.sv` and `sim/checker_sim.sv` \
\
`questa.do` file is run on Questa/ModelSim to create and run a simulation. \
\
Testbench wrapps RTL and stimulus/checker files under it. \
\
Test pseudo-randomizes integer clock periods in between 1000ns and 10ns. \
\
This achieves frequencies in between 1MHz and 100MHz varying for source/destination clocks. \
\
After 5 (parameter PULSE_LIMIT in TB) consecutive generated pulse and receiving via dest_stall (acknowledge), the test asserts resets and restarts again with another set of random frequencies. \
\
In order to change the random set of clock periods, apply different seed values to the simulator (via -sv_seed = $random or such).
## Usage on Verilator
Not supported yet. (some progress)
## Usage on Vivado Simulator (XSim)
Not supported yet. (some progress)
## HDL and Simulatiomn folders
### hdl
CDC Handshake module lives under hdl/
### sim
Testbench and other files regarding simulation live under sim/ folder
## Snapshot of waves
![wave_snapshot](https://github.com/user-attachments/assets/cd69bb2f-38cd-4d33-9fa3-8e6f2914cc9b)
