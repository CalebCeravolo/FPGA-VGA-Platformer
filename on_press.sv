module on_press (in, out, clk, reset);
	input logic in, clk, reset;
	output logic out;
	logic next_out;
	enum {not_pressed, pressed} state, ns;
	always_comb begin
		case (state)
			not_pressed:
				if (in) begin 
					ns = pressed;
					next_out = 1;
				end
				else begin 
					ns = not_pressed;
					next_out = 0;
				end
			pressed:
				if (in) begin 
					ns = pressed;
					next_out = 0;
				end
				else begin 
					ns = not_pressed;
					next_out = 0;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= 0;
			state <= not_pressed;
			end
		else begin
			state <= ns;
			out <= next_out;
			end
	end
endmodule
