#include "Vtb_cdc_handshake_ss.h" // Include the model header file. Adjust the name based on your Verilator output
#include "verilated.h"            // Required for the base Verilator utilities

int main(int argc, char **argv)
{
    // Initialize Verilator's command line arguments (handles plusargs as well)
    Verilated::commandArgs(argc, argv);

    // Create an instance of the Verilated model
    Vtb_cdc_handshake_ss *tb = new Vtb_cdc_handshake_ss;

    // Initialize simulation main loop
    while (!Verilated::gotFinish())
    {
        // At this point, there is no need to manually toggle the clock
        // as it is assumed to be generated internally within the testbench itself

        // Execute simulation steps
        tb->eval();
    }

    // Clean up and exit simulation
    tb->final(); // Required to clean up before exiting the simulation
    delete tb;

    return 0;
}