module collision (up, down, left, right, done, start, redo, x, y, collided_object, clk, objects);
	parameter object_num = 5;
	parameter height = 20, width=10;
	input logic [9:0] x;
	input logic [8:0] y;
	input logic clk, start, redo;
	output logic up, down, left, right, done;
	logic upc, downc, leftc, rightc;
	enum logic [2:0] {idle, check, read, done_state} ps, ns;
	logic initialize = 1;
	logic calc, reset, read_sig;
	logic [$clog2(object_num)-1:0] addr = 0;
	input logic [43:0] objects [object_num-1:0];
	output logic [43:0] collided_object;
	logic [10:0] left_x, top_y, 
					right_x, bottom_y;
					
	logic nextDone;
	always_comb begin
		ns=ps;
		{calc, reset, read_sig} = 0;
		case (ps)
			idle: begin
				if (start) ns=read;
			end // idle case
			check: begin
				ns=read;
				calc=1;
				if (done) begin
					ns=done_state; // if done
				end
			end // check case
			read: begin
				read_sig=1;
				ns=check;
			end
			done_state: begin
				ns=idle;
				if (!redo) ns=done_state;
				else reset=1;
			end
		endcase // case ps
	end //always_comb
	logic contain_x, contain_y, within_x, within_y;
	assign within_x = ((x<=right_x)&((x+width)>=left_x));
	assign within_y = ((y<=bottom_y)&((y+height)>=top_y));
	
	//assign contain_x = ((x>=left_x)&(x<=right_x))&(((x+width)>=left_x)&((x+width)<=right_x));
	//assign contain_y = ((y>=bottom_y)&(y<=top_x))&(((y+hight)>=top_y)&((y+height)<=right_x));
	
	assign upc = (y<=(bottom_y+1'b1))&(y>=(bottom_y-4'd10))&within_x;
	assign downc = ((y+height+1'b1)>=top_y)&((y+height)<=top_y+4'd10)&within_x;
	assign leftc = (x<=(right_x+1'b1))&(x>=(right_x-2))&within_y;
	assign rightc = ((x+width+1'b1)>=left_x)&((x+width)<=(left_x+2))&within_y;
	assign nextDone = (addr==(object_num-1));
	always_ff @(posedge clk) begin
		ps<=ns;
		if (initialize) begin
			ps<=idle;
			initialize<=0;
			up<=0;
			down<=0;
			left<=0;
			right<=0;
			done<=0;
			addr<=0;
		end
		if (read_sig) begin
			{left_x, top_y, right_x, bottom_y}<=objects[addr];
		end
		if (calc) begin
			addr<=addr+1'b1;
			up<=upc|up;
			down<=downc|down;
			left<=leftc|left;
			right<=rightc|right;
			done<=nextDone;
			if (downc) collided_object[32:22]<=top_y;
			if (upc) collided_object[10:0]<=bottom_y;
			if (rightc) collided_object[43:33]<=left_x;
			if (leftc) collided_object[21:11]<=right_x;
		end
		if (reset) begin
			up<=0;
			down<=0;
			left<=0;
			right<=0;
			done<=0;
			addr<=0;
		end	
	end // always_ff
endmodule 