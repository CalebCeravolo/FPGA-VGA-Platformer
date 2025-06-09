module Jumper (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, CLOCK_50, V_GPIO,
			 VGA_R, VGA_G, VGA_B, VGA_BLANK_N,
			 VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	inout [35:0] V_GPIO;
	output [9:0] LEDR;
	wire up;
	wire down;
	wire left;
	wire right;
	wire a;
	wire b2;
   wire lat;
   wire pulse;
	
	assign V_GPIO[27] = pulse;
   assign V_GPIO[26] = lat;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	assign {HEX0, HEX1, HEX2, HEX3, HEX4, HEX5} = '1;
	input CLOCK_50;
	output logic [7:0] VGA_R, VGA_G, VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	logic [9:0] x;
	logic [9:0] cx = 40;
	logic [8:0] cy = 0;
	logic [8:0] y;
	
	
	logic [7:0] r, g, b;
	parameter object_num = 18;
	parameter char_width = 22;
	parameter char_height = 36;
	logic [43:0] objects [object_num-1:0];
	logic [43:0] collided_object;
	logic system_clock;
	assign system_clock = CLOCK_50;
	
	//platform creation
	always_comb begin
		objects[0][43:33] = 80; // left_x
		objects[0][32:22] = 100; // top_y
		objects[0][21:11] = 190; // right_x
		objects[0][10:0]  = 115; // bottom_y
		
		objects[1][43:33] = 500; // left_x
		objects[1][32:22] = 440; // top_y
		objects[1][21:11] = 530; // right_x
		objects[1][10:0]  = 480; // bottom_y
		
		objects[2][43:33] = 200; // left_x
		objects[2][32:22] = 290; // top_y
		objects[2][21:11] = 250; // right_x
		objects[2][10:0]  = 300; // bottom_y
		
		objects[3][43:33] = 0; // left_x
		objects[3][32:22] = 300; // top_y
		objects[3][21:11] = 200; // right_x
		objects[3][10:0]  = 340; // bottom_y
		
		objects[4][43:33] = 0; // left_x
		objects[4][32:22] = 0; // top_y
		objects[4][21:11] = 2; // right_x
		objects[4][10:0]  = 480; // bottom_y
		
		objects[5][43:33] = 0; // left_x
		objects[5][32:22] = 470; // top_y
		objects[5][21:11] = 650; // right_x
		objects[5][10:0]  = 480; // bottom_y
		
		objects[6][43:33] = objects[2][21:11]; // left_x
		objects[6][32:22] = 400; // top_y
		objects[6][21:11] = 280; // right_x
		objects[6][10:0]  = 405; // bottom_y
		
		objects[7][43:33] = objects[6][21:11]; // left_x
		objects[7][32:22] = 410; // top_y
		objects[7][21:11] = 310; // right_x
		objects[7][10:0]  = 415; // bottom_y
		
		objects[8][43:33] = objects[7][21:11]; // left_x
		objects[8][32:22] = 420; // top_y
		objects[8][21:11] = 340; // right_x
		objects[8][10:0]  = 425; // bottom_y
		
		objects[9][43:33] = objects[8][21:11]; // left_x
		objects[9][32:22] = 430; // top_y
		objects[9][21:11] = 370; // right_x
		objects[9][10:0]  = 435; // bottom_y
		
		objects[10][43:33] = objects[9][21:11]; // left_x
		objects[10][32:22] = 440; // top_y
		objects[10][21:11] = 400; // right_x
		objects[10][10:0]  = 445; // bottom_y
		
		objects[11][43:33] = objects[10][21:11]; // left_x
		objects[11][32:22] = 450; // top_y
		objects[11][21:11] = 430; // right_x
		objects[11][10:0]  = 455; // bottom_y
		
		objects[12][43:33] = 450; // left_x
		objects[12][32:22] = 420; // top_y
		objects[12][21:11] = 500; // right_x
		objects[12][10:0]  = 480; // bottom_y
		
		objects[13][43:33] = 500; // left_x
		objects[13][32:22] = 300; // top_y
		objects[13][21:11] = 550; // right_x
		objects[13][10:0]  = 320; // bottom_y
		
		objects[14][43:33] = 400; // left_x
		objects[14][32:22] = 250; // top_y
		objects[14][21:11] = 450; // right_x
		objects[14][10:0]  = 270; // bottom_y
		
		objects[15][43:33] = 500; // left_x
		objects[15][32:22] = 200; // top_y
		objects[15][21:11] = 550; // right_x
		objects[15][10:0]  = 220; // bottom_y
		
		objects[16][43:33] = 200; // left_x
		objects[16][32:22] = 150; // top_y
		objects[16][21:11] = 400; // right_x
		objects[16][10:0]  = 170; // bottom_y
		
		objects[17][43:33] = 400; // left_x
		objects[17][32:22] = 350; // top_y
		objects[17][21:11] = 450; // right_x
		objects[17][10:0]  = 370; // bottom_y
		
	end
	
	logic upC, downC, leftC, rightC, go, Cdone;
	collision collide (.up(upC), .down(downC), .left(leftC), .right(rightC), .done(Cdone), 
							.start(start_collision), .x(cx), .y(cy), .clk(system_clock), .objects, .redo(lag_draw[3]), .collided_object);
							
	logic start_collision;
	on_press activate (.in(div_clk[19]), .out(start_collision), .clk(system_clock), .reset(1'b0));
	defparam collide.object_num = object_num;
	defparam collide.width = char_width;
	defparam collide.height = char_height;
	logic state;
	always_ff @(posedge Cdone) begin
	   LEDR[3:0]<={upC, downC, leftC, rightC};
		state<=downC;
	end
	logic reset;
	assign reset = a;
	physics phys (.x(cx), .y(cy), .move_right(right), .move_left(left), .jump(up), 
						.upC, .downC, .leftC, .rightC ,.go(lag_draw[1]), .collided_object, .clk(system_clock), .reset, .initialize);
	defparam phys.char_height = char_height;
	defparam phys.char_width = char_width;
	draw_screen dr (.x, .y, .objects, .char_x(cx), .char_y(cy), .rgb({r,g,b}), .state);
	defparam dr.object_num = object_num;
	defparam dr.char_width = char_width;
	defparam dr.char_height = char_height;
	logic initialize = 1;
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset(initialize), .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
			 
	logic [31:0] div_clk;
	always_ff @(posedge CLOCK_50) begin
		div_clk<=div_clk+1'b1;
		initialize<=0;
	end
	logic [40:0] debug;
	logic [3:0] lag_draw;
	always_ff @(posedge system_clock) begin
		lag_draw<={lag_draw[2:0], Cdone};
		debug<={debug[39:0], (cy<100)};
	end
	assign LEDR[4] = |debug;
	n8_driver driver(
        .clk(CLOCK_50),
        .data_in(V_GPIO[28]),
        .latch(lat),
        .pulse(pulse),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .select(LEDR[9]),
        .start(LEDR[8]),
        .a(a),
        .b(b2)
    );
	
	
endmodule 