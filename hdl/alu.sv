module alu
    (
        input logic [31:0] x,
        input logic [31:0] y,
        input logic [2:0] op,
        output logic [31:0] z,
        output logic zero, equal, overflow
    );
    
    logic [32:0] c;
    logic [31:0] ynew;
    logic [32:0] and_res;
    logic [32:0] add_res;
    logic [32:0] slt_res;
    logic [32:0] srl_res;
    logic [32:0] sra_res;
    logic [32:0] sll_res;
    logic [32:0] res_res;
    logic [4:0] res_tmp;
    logic [31:0] eq_tmp0;
    logic eq_tmp1;
    logic [31:0] tmp0;
    logic [31:0] tmp1;
    logic [31:0] tmp2;
    logic [31:0] tmp3;
    logic [31:0] tmp4;
    logic zer_tmp;
	
	//assigning empties 
	assign slt_res = 32'b00000000000000000000000000000000;
    assign srl_res = 32'b00000000000000000000000000000000;
    assign sra_res = 32'b00000000000000000000000000000000;
    assign sll_res = 32'b00000000000000000000000000000000;
    assign res_res = 32'b00000000000000000000000000000000;
    
    // add and subtract multiplex
    assign c[0] = op[0] ? 1'b0 : 1'b1;
    assign ynew = op[0] ? y : ~y;
    
    // and
    assign and_res = x & y;

    // add and subtract
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            xor mid1 (tmp0[i], x[i], ynew[i]);
            xor mid2 (add_res[i], c[i], tmp0[i]);
            and ca (tmp1[i], x[i], ynew[i]);
            and cb (tmp2[i], x[i], c[i]);
            and cc (tmp3[i], ynew[i], c[i]);
            or fin1 (tmp4[i], tmp1[i], tmp2[i]);
            or fin2 (c[i+1], tmp4[i], tmp3[i]);
            end
    endgenerate
    
    // multiplex
    assign z = op[2] ? (op[1] ? (op[0] ? res_res: sll_res) : (op[0] ? sra_res : srl_res)) : (op[1] ? ( op[0] ? slt_res: add_res) : (op[0] ? add_res: and_res));
    
    // reserve checker for 000, 001, 010
    assign res_tmp[0] = op[0] && op[1];
    assign res_tmp[1] = res_tmp[0] || op[2];
    // ovfl res checker for 001, 010 
    assign res_tmp[2] = !op[0] && !op[1];
    assign res_tmp[3] = !(res_tmp[1] || res_tmp[2]);
    
    // equal flag
    assign eq_tmp0 = ~(x ^ y);
    assign eq_tmp1 = &eq_tmp0;
    assign equal = eq_tmp1 && !res_tmp[1];
    
    // zero flag
    assign zer_tmp = ~| z;
    assign zero = zer_tmp && !res_tmp[1];
    
    // overflow flag
    assign res_tmp[4] = c[31] ^ c[32];
    assign overflow = res_tmp[4] && res_tmp[3];

endmodule
