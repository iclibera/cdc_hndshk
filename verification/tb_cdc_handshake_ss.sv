`timescale 1ns / 1ps

module tb_cdc_handshake_ss;

    logic source_clk, source_reset_n, source_strobe, source_stall, dest_clk, dest_reset_n, dest_strobe, dest_stall;

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
    stimulus_sim stimulus_inst(
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
    logic [31:0] error_count;
    checker_sim checker_inst(
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .error_count(error_count)
    );

    // Monitoring and finishing condition
    initial begin
        $monitor("Time=%t, source_strobe=%b, dest_strobe=%b, Errors=%d", $time, source_strobe, dest_strobe, error_count);
        #2000ns;
        $finish;
    end
endmodule
