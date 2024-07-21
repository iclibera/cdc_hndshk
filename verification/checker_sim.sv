`timescale 1ns / 1ps

module checker_sim #(
    parameter int PULSE_LIMIT = 5
)(
    input  logic        dest_clk,
    input  logic        dest_reset_n,
    input  logic        dest_strobe,
    output logic [31:0] error_count
);

    int pulse_count;

    always_ff @(posedge dest_clk or negedge dest_reset_n) begin
        if (!dest_reset_n) begin
            // Reset error counter on reset
            error_count <= 0;
            pulse_count <= 0;
        end else if (dest_strobe) begin
            pulse_count <= pulse_count + 1;
            if (pulse_count > PULSE_LIMIT) begin
                error_count <= error_count + 1; // Error increment
            end            
        end
    end
endmodule
