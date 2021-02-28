`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:31:50 11/22/2016 
// Design Name: 
// Module Name:    clock 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock(
	input 			clk,
	input 			reset,
	output reg [6:0] 	segments,
	output reg [3:0]	anodes
    );

reg [32:0] 	count;
reg			clr_count;
reg [5:0] 	mins;
reg			clr_mins;
reg [4:0] 	hrs;
reg			clr_hrs;

wire [6:0] mins_mss;
wire [6:0] mins_lss;
wire [6:0]  hrs_mss;
wire [6:0]  hrs_lss;

reg  [31:0] seg_count;

// Count	
always@(posedge clk)
	if(reset || clr_count) 	count <= #1 0;
	else					count <= #1 count+1;

always@* clr_count = count == 33'd5_999_999_999;
//always@* clr_count = count == 33'd99_999_999;
// Minutes Counter
always@(posedge clk)
	if(reset || clr_mins) 	mins <= #1 0;
	else if(clr_count)		mins <= #1 mins+1;

always@* clr_mins = clr_count & (mins == 6'd59);

// Hrs Counter
always@(posedge clk)
	if(reset || clr_hrs) 	hrs <= #1 0;
	else if(clr_mins)		hrs <= #1 hrs+1;

always@* clr_hrs = clr_mins & (hrs == 5'd23);

// Segments
segments mins_seg(
	.number		(mins),
	.segments	({mins_mss,mins_lss})
    );	
	
segments hrs_seg(
	.number		({1'b0,hrs}),
	.segments	({hrs_mss,hrs_lss})
    );	
	
// Segments counter
always@(posedge clk)
	if(reset) 	seg_count <= #1 0;
	else		seg_count <= #1 seg_count+1;
	
always@*
	case(seg_count[19:18])
	2'd0: segments = ~mins_lss;
	2'd1: segments = ~mins_mss;
	2'd2: segments =  ~hrs_lss;
	2'd3: segments =  ~hrs_mss;
	endcase
	
	
always@*
	case(seg_count[19:18])
	2'd0: anodes = 4'b1110;
	2'd1: anodes = 4'b1101;
	2'd2: anodes = 4'b1011;
	2'd3: anodes = 4'b0111;
	endcase
	
	
	
	
	
	
	
	
	
	
	
	

endmodule
