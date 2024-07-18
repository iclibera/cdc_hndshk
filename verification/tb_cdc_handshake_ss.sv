module tb_cdc_handshake_ss;
    wire source_clk, source_reset_n, source_strobe, source_stall;
    wire dest_clk, dest_reset_n, dest_strobe, dest_stall;

    // Instantiate DUT
    cdc_handshake_ss DUT (
        .source_clk(source_clk),
        .source_reset_n(source_reset_n),
        .source_strobe(source_strobe),
        .source_stall(source_stall),
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .dest_stall(dest_stall)
    );

    // Instantiate stimulus
    stimulus stimulus_inst(
        .source_clk(source_clk),
        .source_reset_n(source_reset_n),
        .source_strobe(source_strobe),
        .source_stall(source_stall),
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .dest_stall(dest_stall)
    );

    // Instantiate checker
    wire [31:0] error_count;
    checker checker_inst(
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .error_count(error_count)
    );

    // Monitoring and finishing condition
    initial begin
        $monitor("Time=%t, source_strobe=%b, dest_strobe=%b, Errors=%d", $time, source_strobe, dest_strobe, error_count);
        #2000;
        $finish;
    end
endmodule
