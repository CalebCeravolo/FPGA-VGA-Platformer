module physics (x, y, collided_object, move_right, move_left, jump, upC, downC, leftC, rightC , go, clk, reset, initialize);
    input logic clk;
	parameter signed gravity = 1; 
	parameter movespeed = 2;
	parameter signed char_height = 20;
	parameter signed char_width = 10;
	input logic reset, initialize;
	logic [3:0] gravity_delay;
	logic [3:0] next_gravity_delay;
	logic signed [7:0] currentVelocity_y;
	logic signed [7:0] nextVelocity_y;
	output logic signed [10:0] x;
	output logic signed [9:0] y;
	input logic [43:0] collided_object;
	logic signed [10:0] nx, send_x;
	logic signed [9:0] ny, send_y;
	
	
	input logic move_right, move_left, jump, upC, downC, leftC, rightC, go;
	
	always_comb begin
	   next_gravity_delay = 0;
	   if (!downC) next_gravity_delay = gravity_delay+1'b1;
		nextVelocity_y = currentVelocity_y;
		if ((currentVelocity_y<6)&(&gravity_delay))
			nextVelocity_y = currentVelocity_y+gravity;
		ny=y+currentVelocity_y;
		nx=x;
		if (downC) begin 
			nextVelocity_y=0;
			ny=collided_object[32:22]-(1'b1+char_height);
			if (jump) begin 
			   nextVelocity_y=(-3);
			   ny=collided_object[32:22]-(2'd2+char_height);
			end
		end
		if (upC) begin 
			nextVelocity_y=2;
			ny=collided_object[10:0]+2'd2;
		end
		
		if (leftC) begin
			nx=collided_object[21:11]+1'b1;
		end
		if (rightC) begin
			nx=collided_object[43:33]-(1'b1+char_width);
		end
		if (move_left&!leftC) nx = x-movespeed;
		if (move_right&!rightC) nx = x+movespeed;
	end
	always_ff @(posedge go) begin
	   gravity_delay<=next_gravity_delay;
		currentVelocity_y<=nextVelocity_y;
		send_x<=nx;
		send_y<=ny;
		if (reset|initialize) begin
			gravity_delay<=0;
			currentVelocity_y<=0;
			send_x<=30;
			send_y<=50;
		end
	end	
	always_ff @(posedge clk) begin
		x<=send_x;
		y<=send_y;
		if (reset|initialize) begin
			x<=30;
			y<=50;
		end
	end
endmodule 