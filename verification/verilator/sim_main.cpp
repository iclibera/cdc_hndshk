#include "Vtb_cdc_handshake_ss.h" 
#include "verilated.h"            

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vtb_cdc_handshake_ss *tb = new Vtb_cdc_handshake_ss;

    // Initialize simulation main loop
    while (!Verilated::gotFinish())
    {
        // Execute simulation steps
        tb->eval();
    }

    // Clean up and exit simulation
    tb->final();
    delete tb;

    return 0;
}