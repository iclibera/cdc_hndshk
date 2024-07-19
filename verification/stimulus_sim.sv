`timescale 1ns / 1ps

module stimulus_sim (
    output logic source_clk,
    output logic source_reset_n,
    output logic source_strobe,
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic source_stall,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic dest_clk,
    output logic dest_reset_n,
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic dest_strobe,
    /* verilator lint_on UNUSEDSIGNAL */
    output logic dest_stall
);
    initial begin
        source_clk = 0;
        dest_clk = 0;
        source_reset_n = 0;
        dest_reset_n = 0;
        source_strobe = 0;
        dest_stall = 0;
        // Reset sequence
        #20ns source_reset_n = 1;
        dest_reset_n = 1;

        // Generate a single clock pulse
        @(posedge source_clk);
        source_strobe = 1;
        @(posedge source_clk);
        source_strobe = 0;

        // Vary clock speed for the next test after a delay
        #1000ns;
        source_clk = 0;
        dest_clk = 0;
        repeat (2) begin
            /* verilator lint_off BLKSEQ */
            #7ns source_clk = ~source_clk;  // Approximately 71 MHz
            #13ns dest_clk  = ~dest_clk;    // Approximately 38 MHz
            /* verilator lint_on BLKSEQ */
        end
    end

    // Clock generation logic for source and destination
    /* verilator lint_off BLKSEQ */
    always #5ns source_clk = ~source_clk;  // Default 100 MHz
    always #10ns dest_clk = ~dest_clk;    // Default 50 MHz
    /* verilator lint_on BLKSEQ */
endmodule
