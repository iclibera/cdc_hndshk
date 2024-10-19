VERILATOR = verilator
VERILATOR_FLAGS = -Wall --cc --trace --timing --exe --top-module verification/tb_cdc_handshake_ss

# Source and testbench files
VFILES = hdl/cdc_handshake_ss.sv verification/stimulus_sim.sv verification/checker_sim.sv verification/tb_cdc_handshake_ss.sv

# Target executable
EXE = sim

# C++ driver source
CPP_SOURCE = sim_main.cpp

# Additional configurations
CXX = g++
CXX = g++-11  # Adjust the version number as necessary
CXXFLAGS += -Wall -std=c++20 -O2  # Common flags suitable for both GCC and Clang
LDFLAGS += -L/usr/local/lib  # Linker flags if needed

# Build target
all: $(EXE)

$(EXE): $(VFILES) $(CPP_SOURCE)
	$(VERILATOR) $(VERILATOR_FLAGS) --build -o $(EXE) tb_cdc_handshake_ss.sv $(CPP_SOURCE)
	./$(EXE)

clean:
	rm -rf obj_dir
	rm -f $(EXE)

.PHONY: all clean
