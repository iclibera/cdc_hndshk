VERILATOR = verilator
VERILATOR_FLAGS = -Wall --cc --trace --timing --exe --top-module tb_cdc_handshake_ss

# Source and testbench files
VFILES = ../hdl/cdc_handshake_ss.sv stimulus_sim.sv checker_sim.sv tb_cdc_handshake_ss.sv

# Target executable
EXE = sim

# C++ driver source
CPP_SOURCE = sim_main.cpp

# Additional configurations
CXX = g++
CXX = g++-11  # Adjust the version number as necessary
CXXFLAGS += -Wall -std=c++20 -O2  # Common flags suitable for both GCC and Clang
LDFLAGS += -L/usr/local/lib  # Linker flags if needed

# CXXFLAGS += -std=c++20
# VERILATOR_ROOT = /usr/local/Cellar/verilator/5.026
# INCLUDES = -I. -I$(VERILATOR_ROOT)/share/verilator/include -I$(VERILATOR_ROOT)/share/verilator/include/vltstd
# CXXFLAGS += -Os $(INCLUDES) -MMD -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=1 -faligned-new -fbracket-depth=4096 -fcf-protection=none -Qunused-arguments
# CXXFLAGS += -Wno-bool-operation -Wno-c++11-narrowing -Wno-constant-logical-operand -Wno-non-pod-varargs -Wno-parentheses-equality -Wno-shadow -Wno-sign-compare -Wno-tautological-bitwise-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable

# Build target
all: $(EXE)

$(EXE): $(VFILES) $(CPP_SOURCE)
	$(VERILATOR) $(VERILATOR_FLAGS) --build -o $(EXE) tb_cdc_handshake_ss.sv $(CPP_SOURCE)
	./$(EXE)

clean:
	rm -rf obj_dir
	rm -f $(EXE)

.PHONY: all clean
