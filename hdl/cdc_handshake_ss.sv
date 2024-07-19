`timescale 1ns / 1ps

module cdc_handshake_ss (
    input  logic source_clk,       // Source domain clock
    input  logic source_reset_n,   // Source clock reset active low
    input  logic source_strobe,    // Source pulse signal
    output logic source_stall,     // Source pulse stall signal
    input  logic dest_clk,         // Destination domain clock
    input  logic dest_reset_n,     // Destination reset active low
    output logic dest_strobe,      // Destination pulse signal
    input  logic dest_stall        // Destination stall signal
);

    // Internal signals for handshaking
    logic source_sync_to_dest, dest_sync_to_source, source_to_dest_d1, source_to_dest_d2, dest_to_source_d1, dest_to_source_d2;

    // Synchronizing source control signal to destination
    always_ff @(posedge dest_clk or negedge dest_reset_n) begin
        if (!dest_reset_n) begin
            source_to_dest_d1 <= 0;
            source_to_dest_d2 <= 0;
        end else begin
            source_to_dest_d1 <= source_sync_to_dest;
            source_to_dest_d2 <= source_to_dest_d1;
        end
    end

    assign dest_strobe = source_to_dest_d2;

    // Synchronizing source control signal to destination
    always_ff @(posedge source_clk or negedge source_reset_n) begin
        if (!source_reset_n) begin  // Active-Low reset
            dest_to_source_d1 <= 0;
            dest_to_source_d2 <= 0;
        end else begin
            // 2-FF synchronization logic
            dest_to_source_d1 <= dest_sync_to_source;
            dest_to_source_d2 <= dest_to_source_d1;
        end
    end

    assign source_stall = dest_to_source_d2;

    // Source side control logic for handshaking
    always_ff @(posedge source_clk or negedge source_reset_n) begin
        if (!source_reset_n) begin  // Active-Low reset
            source_sync_to_dest <= 0;
        end else if (source_strobe && !source_stall) begin
            // Toggles to produce 'send' pulse
            source_sync_to_dest <= ~source_sync_to_dest;
        end
    end

    // Destination side control logic for handshaking
    always_ff @(posedge dest_clk or negedge dest_reset_n) begin
        if (!dest_reset_n) begin  // Active-Low reset
            dest_sync_to_source <= 0;
        end else if (dest_strobe && !dest_stall) begin
            // Toggles to produce 'receive' pulse
            dest_sync_to_source <= ~dest_sync_to_source;
        end
    end

endmodule
