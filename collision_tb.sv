module collision_tb ();
	logic up, down, left, right, done, start, clk, redo;
	logic [43:0] objects [1:0];
	logic [9:0] x;
	logic [8:0] y;
	logic [43:0] collided_object;
	always_comb begin
		objects[0][43:33] = 20; // left_x
		objects[0][32:22] = 20; // top_y
		objects[0][21:11] = 40; // right_x
		objects[0][10:0]  = 25; // bottom_y
		
		objects[1][43:33] = 20; // left_x
		objects[1][32:22] = 50; // top_y
		objects[1][21:11] = 40; // right_x
		objects[1][10:0]  = 55; // bottom_y
	end
	collision dut (.*);
	defparam dut.object_num = 2;
	initial begin
		clk=0;
		forever #(5) clk<=~clk;
	end
	
	initial begin
		start<=0;
		x<=40;
		y<=0;
		redo<=0;
		@(posedge clk)
		start<=1;
		@(posedge clk)
		start<=0;
		@(posedge done)
		redo<=1;
		@(posedge clk)
		@(posedge clk)
		repeat (40) begin
			start<=1;
			@(posedge clk)
			@(posedge done)
			@(posedge clk)
			@(posedge clk)
			{x,y} <={x,y} + 1'b1;
			start<=0;
		end
		$stop;
	end
	
endmodule 