`timescale 1ns / 1ps

module cdc_handshake_ss (
    input  logic source_clk,
    input  logic source_reset_n,
    input  logic source_strobe,
    output logic source_stall,
    input  logic dest_clk,
    input  logic dest_reset_n,
    output logic dest_strobe,
    input  logic dest_stall
);

    // Internal Signals / Synchronization registers
    logic pulse_stretched, pulse_registered;
    logic source_strobe_sync1, source_strobe_sync2, source_stall_sync;

    // Stretch pulse for clock domain crossing
    always_ff @(posedge source_clk or negedge source_reset_n) begin
        if (!source_reset_n) begin
            pulse_stretched   <= 1'b0;
            source_stall_sync <= 1'b1;
            source_stall      <= 1'b1;
        end else begin
            // Reflect stall condition back to the source domain
            source_stall_sync <= dest_stall;
            source_stall      <= source_stall_sync;
            // Stretch incoming pulse as long as there is stall
            if (source_strobe && !pulse_stretched) begin
                pulse_stretched <= 1'b1;  // Stretch the pulse until acknowledged
            end else if (!source_stall) begin
                pulse_stretched <= 1'b0;  // Reset the pulse on stall or ack
            end
        end
    end

    // Synchronize stretched pulse to destination domain
    always_ff @(posedge dest_clk or negedge dest_reset_n) begin
        if (!dest_reset_n) begin
            source_strobe_sync1 <= 1'b0;
            source_strobe_sync2 <= 1'b0;
            dest_strobe         <= 1'b0;
        end else begin
            // Default values
            dest_strobe         <= 1'b0;
            // 2-FF Synchronizer
            source_strobe_sync1 <= pulse_stretched;
            source_strobe_sync2 <= source_strobe_sync1;
            // Destination logic
            if (!dest_strobe && source_strobe_sync2 && dest_stall) begin
                dest_strobe     <= 1'b1;  // Register pulse on first detection
            end
        end
    end

endmodule
