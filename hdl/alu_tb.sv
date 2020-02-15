`include "alu.svh"

// The following module is made for SIMULATION ONLY - most of the language
// constructs used here will not synthesize, but will simulate
module alu_tb;
	// Inputs
	logic signed [31:0] x;
	logic signed [31:0] y;
	logic [2:0] op;

	// Outputs
	logic signed [31:0] z;
	logic equal;
	logic overflow;
	logic zero;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.x, 
		.y,
		.z, 
		.op, 
		.equal, 
		.overflow, 
		.zero
	);

	int i, j;
	int error = 0;

	initial begin
		// Initialize Inputs
		x = 0;
		y = 0;

		for (int i = 0; i <= 4'b0111; i++) begin
            // test all zero's
            op = i;
            x = 32'b00000000000000000000000011111111;
            y = 32'b00000000000000000000000011111111;
            #10;
            x = 32'b00000000000000000000000000000000;
            y = 32'b00000000000000000000000000000000;
            #10;
    
            // test all one's for overflow
            x = 32'b11111111111111111111111111111111;
            y = 32'b00000000000000000000000000000000;
            #10;
            
            // test all one's for overflow
            x = 32'b00000000000000000000000000000000;
            y = 32'b11111111111111111111111111111111;
            #10;
            
            // test all one's for overflow
            x = 32'b11111111111111111111111111111111;
            y = 32'b11111111111111111111111111111111;
            #10;

        end
		// this triggers the always block
		$finish;
	end
	
	// an 'always' block is executed whenever any of the variables in the sensitivity
	// list are changed (X, Y, or op in this case)
	always @(x, y, op) begin
		#1;
		case (op)
			`ALU_AND: begin
				if (z != (x & y)) begin
					$display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_ADD: begin
			    if (z != (x + y)) begin
					$display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
			    end
			    if (z[7:0]!= 8'b00000000 && x[7:0] == 8'b11111111 && y[7:0] == 8'b11111111) begin
			        $display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
			    end
            end
			`ALU_SUB: begin
			    if (z != (x - y)) begin
					$display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
				if (z[7:0]!= 8'b00000000 && x[7:0] == 8'b11111111 && y[7:0] == 8'b11111111) begin
			        $display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
			    end
			end
			`ALU_SLT: begin
			end
			`ALU_SRL: begin
			end
			`ALU_SLL: begin
			end
			`ALU_SRA: begin
			end
			default : begin
				if ((op!== (3'b000 || 3'b001 || 3'b010)) && (z!= 8'b00000000)) begin
			        $display("ERROR: op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
			    end
			end
		endcase
	end
	
endmodule

