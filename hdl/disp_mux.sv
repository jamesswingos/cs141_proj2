module disp_mux
    (
        input logic clk, rst,
        input [7:0] in7, in6, in5, in4, in3, in2, in1, in0,
        output logic [7:0] an,   // enable, 1-out-of-8 asserted low
        output logic [7:0] sseg  // led segments
    );

    // refreshing rate around 800 Hz (50 MHz/2^16)
    localparam N = 18;

    // signal declaration
    logic [N-1:0] q_reg;
    logic [N-1:0] q_next;

    // N-bit counter
    // register
    always_ff @(posedge clk,  posedge rst)
        if (rst)
            q_reg <= 0;
        else
            q_reg <= q_next;

    // next-state logic
    assign q_next = q_reg + 1;

    // 3 MSBs of counter to control 8-to-1 multiplexing
    // and to generate active-low enable signal
    always_comb
        case (q_reg[N-1:N-3])
            3'b000: begin
                    an = 8'b11111110;
                    sseg = in0;
                end
            3'b001: begin
                    an =  8'b11111101;
                    sseg = in1;
                end
            3'b010: begin
                    an =  8'b11111011;
                    sseg = in2;
                end
            3'b011: begin
                    an =  8'b11110111;
                    sseg = in3;
                end
            3'b100: begin
                    an =  8'b11101111;
                    sseg = in4;
                end
            3'b101: begin
                    an =  8'b11011111;
                    sseg = in5;
                end
            3'b110: begin
                    an =  8'b10111111;
                    sseg = in6;
                end
            3'b111: begin
                    an =  8'b01111111;
                    sseg = in7;
                end
        endcase
endmodule

