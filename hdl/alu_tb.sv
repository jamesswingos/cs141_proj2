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
		op = 0;
		j = 0;

		// YOUR CODE HERE
		// loop through all important test vectors
		// this triggers the always block
		$finish;
	end
	
	// an 'always' block is executed whenever any of the variables in the sensitivity
	// list are changed (X, Y, or op in this case)
	always @(x, y, op) begin
		#1;
		case (op)
			`ALU_AND: begin
				if (z !== (x & y)) begin
					$display("ERROR: ADD:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_ADD: begin
            end
			`ALU_SUB: begin
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
				// executes if no op codes are matched
			end
		endcase
	end
endmodule

