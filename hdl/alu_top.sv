module alu_top
    (
        input  logic clk,
        input  logic [15:0] sw,
        input  logic [4:0] btn,
        output logic [7:0] an,
        output logic [7:0] sseg,
        output logic [2:0] led
    );
    
    // signal declaration
    logic [31:0] x, y, z;
    logic [2:0] op;
    logic [7:0] xled0, xled1, yled0, yled1;
    logic [7:0] zled0, zled1;

    assign x = sw[7:0];
    assign y = sw[15:8];
    assign op = {{btn[3], btn[4]}, btn[1]}; // left, center, right
    
    alu alu_unit (.x, .y, .z, .op, .equal(led[0]), .zero(led[1]), .overflow(led[2]));

    // instantiate four instances of hex decoders
    // instance for 4 LSBs of z
    hex_to_sseg sseg_unit_0
      (.hex(z[3:0]), .dp(1'b0), .sseg(zled0));
    // instance for 4 MSBs of z
    hex_to_sseg sseg_unit_1
      (.hex(z[7:4]), .dp(1'b0), .sseg(zled1));
    // instance for 4 LSBs of x
    hex_to_sseg sseg_unit_2
      (.hex(x[3:0]), .dp(1'b0), .sseg(xled0));
    // instance for 4 MSBs of x
    hex_to_sseg sseg_unit_3
      (.hex(x[7:4]), .dp(1'b0), .sseg(xled1));
    // instance for 4 LSBs of y
    hex_to_sseg sseg_unit_4
      (.hex(y[3:0]), .dp(1'b0), .sseg(yled0));
    // instance for 4 MSBs of y
    hex_to_sseg sseg_unit_5
      (.hex(y[7:4]), .dp(1'b0), .sseg(yled1));

    
    // instantiate 7-seg LED display time-multiplexing module
    disp_mux disp_unit
        (.clk, .rst(1'b0), .in0(xled0), .in1(xled1),
        .in2(yled0), .in3(yled1), .in4(zled0), .in5(zled1), 
        .an, .sseg);  
endmodule
