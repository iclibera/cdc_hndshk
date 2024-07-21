`timescale 1ns / 1ps

module tb_cdc_handshake_ss;

    logic source_clk, source_reset_n, source_strobe, source_stall, dest_clk, dest_reset_n, dest_strobe, dest_stall, sim_done;
    logic [31:0] error_count;
    localparam int PULSE_LIMIT = 'd5;

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
    stimulus_sim #(.PULSE_LIMIT(PULSE_LIMIT))
    stimulus_inst(
        .source_clk(source_clk),
        .source_reset_n(source_reset_n),
        .source_strobe(source_strobe),
        .source_stall(source_stall),
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .dest_stall(dest_stall),
        .sim_done(sim_done)
    );

    // Instantiate checker    
    checker_sim #(.PULSE_LIMIT(PULSE_LIMIT))
    checker_inst(
        .dest_clk(dest_clk),
        .dest_reset_n(dest_reset_n),
        .dest_strobe(dest_strobe),
        .error_count(error_count)
    );

    // Monitoring and finishing condition
    initial begin
        $monitor("Time=%t, source_strobe=%b, dest_strobe=%b, Errors=%d", $time, source_strobe, dest_strobe, error_count);
    end
    always @(posedge sim_done) begin
        $finish;
    end
endmodule
