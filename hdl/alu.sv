module alu
    (
        input logic [31:0] x,
        input logic [31:0] y,
        input logic [2:0] op,
        output logic [31:0] z,
        output logic zero, equal, overflow
    );
    
    logic [32:0] c;
    logic [32:0] and_res;
    logic [32:0] add_res;
    logic [32:0] slt_res;
    logic [32:0] srl_res;
    logic [32:0] sra_res;
    logic [32:0] sll_res;
    logic [32:0] res_res;
    logic [3:0] res_tmp;
    logic [1:0] eq_tmp;
    logic zer_tmp;
    
    // add and subtract multiplex
    assign c[0] = op[0] ? 1'b0 : 1'b1;
    assign y = op[0] ? y : ~y;

	logic [3:0] tmp;
    
    // and
    assign and_res = x & y;

    // add and subtract
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            xor mid1 (tmp[0], x[i], y[i]);
            xor mid2 (add_res[0], c[i], tmp[0]);
            and ca (tmp[1], x[i], y[i]);
            and cb (tmp[2], x[i], c[i]);
            and cc (tmp[3], y[i], c[i]);
            or fin (c[i+1], tmp[1], tmp[2], tmp[3]);
        end
    endgenerate
    
    // multiplex
    assign z = op[2] ? (op[1] ? (op[0] ? res_res: sll_res) : (op[0] ? sra_res : srl_res)) : (op[1] ? ( op[0] ? slt_res: add_res) : (op[0] ? add_res: and_res));
    
    // reserve checker for 000, 001, 010
    assign res_tmp[0] = op[0] && op[1];
    assign res_tmp[1] = res_tmp[0] || op[2];
    // ovfl res checker for 001, 010
    assign res_tmp[2] = ~op[0] && ~op[1];
    assign res_tmp[3] = ~(res_tmp[1] && res_tmp[2]);
    
    // equal flag
    assign eq_tmp[0] = x ~^ y;
    assign eq_tmp[1]  = & eq_tmp[0];
    assign equal = eq_tmp[1] & ~res_tmp[1];
    
    // zero flag
    assign zer_tmp = ~| z;
    assign zero = zer_tmp & ~res_tmp[1];
    
    // overflow flag
    assign overflow = c[32] && res_tmp[3];

endmodule
