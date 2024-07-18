module checker(
    input  logic        dest_clk,
    input  logic        dest_reset_n,
    input  logic        dest_strobe,
    output logic [31:0] error_count
);
    initial begin
        error_count = 0;
    end

    always @(posedge dest_clk) begin
        if (!dest_reset_n) begin
            // Reset error counter on reset
            error_count <= 0;
        end else if (dest_strobe) begin
            // Check logic for strobe signal, increase error count if incorrect
            // Assuming some condition checks for now
            error_count <= error_count + 1; // Simplistic error checking
        end
    end
endmodule
