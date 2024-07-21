`timescale 1ns / 1ps

module stimulus_sim #(
    parameter int PULSE_LIMIT = 5
)(
    output logic source_clk,
    output logic source_reset_n,
    output logic source_strobe,
    input  logic source_stall,
    output logic dest_clk,
    output logic dest_reset_n,
    input  logic dest_strobe,
    output logic dest_stall,
    output logic sim_done
);

    int source_clk_period;
    int dest_clk_period;
    int expected_pulse;
    string status;

    task randomize_clocks ();
        source_clk_period = $urandom_range(10, 1000);  // Clock period is selected to be in between 1-100MHz included
        dest_clk_period   = $urandom_range(10, 1000);  // Clock period is selected to be in between 1-100MHz included
    endtask

    task assert_deassert_resets (); 
        // Assert then de-assert active-low resets
        @(posedge source_clk);
        source_reset_n = 0;
        @(posedge dest_clk);
        dest_reset_n   = 0;
        randomize_clocks ();
        $display("Random source clock period: %d ns", source_clk_period);
        $display("Random destination clock period: %d ns", dest_clk_period);
        repeat (3) @(posedge source_clk);
        repeat (3) @(posedge dest_clk);
        @(posedge source_clk);
        source_reset_n = 1;
        @(posedge dest_clk);
        dest_reset_n   = 1;
    endtask

    task manual_deassert_resets ();
        // Assert then de-assert active-low resets
        @(posedge source_clk);
        source_reset_n = 0;
        @(posedge dest_clk);
        dest_reset_n   = 0;
        repeat (3) @(posedge source_clk);
        repeat (3) @(posedge dest_clk);
        @(posedge source_clk);
        source_reset_n = 1;
        @(posedge dest_clk);
        dest_reset_n   = 1;
    endtask

    task gen_strobe (); 
        // Generate a single clock pulse
        @(posedge source_clk);
        source_strobe = 1;
        @(posedge source_clk);
        source_strobe = 0;
    endtask

    task ack_strobe ();
        while (!dest_strobe) begin
            @(posedge dest_clk);
            // $display("Waiting for destination strobe.");
        end
        // $display("Strobe received at destination, exiting loop.");
        dest_stall = 1'b0;
        while (source_stall) begin
            @(posedge source_clk);
            // $display("Waiting for source stall signal go low.");
        end
        // $display("Stall received at source, exiting loop.");
        @(posedge dest_clk);
        @(posedge dest_clk);
        dest_stall = 1'b1;
    endtask

    task gen_stobe_and_ack (input int repetition);
        repeat (repetition) begin
            gen_strobe();
            ack_strobe();
        end
    endtask

    task new_sequence (input int sequence_repetition, input int strobe_repetition);
        repeat (sequence_repetition) begin
            assert_deassert_resets();
            gen_stobe_and_ack(strobe_repetition);
        end
    endtask

    initial begin
        sim_done          = 1'b0;
        source_clk_period = 10;  // Default value is selected to be 10 ns - 100 MHz
        dest_clk_period   = 20;  // Default value is selected to be 20 ns - 50 MHz
        expected_pulse    = PULSE_LIMIT;
        source_clk        = 0;
        dest_clk          = 0;
        source_reset_n    = 0;
        dest_reset_n      = 0;
        source_strobe     = 0;
        dest_stall        = 1;
        // Initializing sequence
        status = "INIT";
        #20ns
        manual_deassert_resets();
        gen_stobe_and_ack(expected_pulse);
        
        status = "RANDOM";
        // Below runs 20 different tests, each with 'expected_pulse' times sending pulse
        new_sequence(20, expected_pulse);

        status = "LIMIT1";
        // Source = 1 MHz / Destination = 100MHz
        source_clk_period = 1000;  // 1 MHz
        dest_clk_period   = 10;    // 100 MHz
        manual_deassert_resets();
        gen_stobe_and_ack(expected_pulse);

        status = "LIMIT2";
        // Source = 100 MHz / Destination = 1MHz
        source_clk_period = 10;    // 100 MHz
        dest_clk_period   = 1000;  // 1 MHz
        manual_deassert_resets();
        gen_stobe_and_ack(expected_pulse);

        status = "END";
        #200ns;
        sim_done = 1'b1;
    end

    // Clock generation logic for source and destination
    /* verilator lint_off BLKSEQ */
    always #(source_clk_period*0.5ns) source_clk = ~source_clk;  // Default 100 MHz
    always #(dest_clk_period*0.5ns)   dest_clk   = ~dest_clk;    // Default 50 MHz
    /* verilator lint_on BLKSEQ */
endmodule
