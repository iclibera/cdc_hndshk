module stimulus(
    output logic source_clk,
    output logic source_reset_n,
    output logic source_strobe,
    input  logic source_stall,
    output logic dest_clk,
    output logic dest_reset_n,
    input  logic dest_strobe,
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
        #20 source_reset_n = 1;
        dest_reset_n = 1;

        // Generate a single clock pulse
        @(posedge source_clk);
        source_strobe = 1;
        @(posedge source_clk);
        source_strobe = 0;

        // Vary clock speed for the next test after a delay
        #1000;
        source_clk = 0;
        dest_clk = 0;
        repeat (2) begin
            #7 source_clk = ~source_clk;  // Approximately 71 MHz
            #13 dest_clk = ~dest_clk;    // Approximately 38 MHz
        end
    end

    // Clock generation logic for source and destination
    always #5 source_clk = ~source_clk;  // Default 100 MHz
    always #10 dest_clk = ~dest_clk;    // Default 50 MHz
endmodule
