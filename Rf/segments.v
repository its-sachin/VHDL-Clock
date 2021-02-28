`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:19 11/22/2016 
// Design Name: 
// Module Name:    segments 
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
module segments(
	input 	[5:0] 	number,
	output reg [13:0]	segments
    );

/*
	7'h0: leds = 7'b1111110;
	7'h1: leds = 7'b0110000;
	7'h2: leds = 7'b1101101;
	7'h3: leds = 7'b1111001;
	7'h4: leds = 7'b0110011;
	7'h5: leds = 7'b1011011;
	7'h6: leds = 7'b1011111;
	7'h7: leds = 7'b1110000;
	7'h8: leds = 7'b1111111;
	7'h9: leds = 7'b1111011;
*/	
	
always@*
	case(number)
	6'd00: segments = 14'b1111110_1111110;
	6'd01: segments = 14'b1111110_0110000;
	6'd02: segments = 14'b1111110_1101101;
	6'd03: segments = 14'b1111110_1111001;
	6'd04: segments = 14'b1111110_0110011;
	6'd05: segments = 14'b1111110_1011011;
	6'd06: segments = 14'b1111110_1011111;
	6'd07: segments = 14'b1111110_1110000;
	6'd08: segments = 14'b1111110_1111111;
	6'd09: segments = 14'b1111110_1111011;

	6'd10: segments = 14'b0110000_1111110;
	6'd11: segments = 14'b0110000_0110000;
	6'd12: segments = 14'b0110000_1101101;
	6'd13: segments = 14'b0110000_1111001;
	6'd14: segments = 14'b0110000_0110011;
	6'd15: segments = 14'b0110000_1011011;
	6'd16: segments = 14'b0110000_1011111;
	6'd17: segments = 14'b0110000_1110000;
	6'd18: segments = 14'b0110000_1111111;
	6'd19: segments = 14'b0110000_1111011;

	6'd20: segments = 14'b1101101_1111110;
	6'd21: segments = 14'b1101101_0110000;
	6'd22: segments = 14'b1101101_1101101;
	6'd23: segments = 14'b1101101_1111001;
	6'd24: segments = 14'b1101101_0110011;
	6'd25: segments = 14'b1101101_1011011;
	6'd26: segments = 14'b1101101_1011111;
	6'd27: segments = 14'b1101101_1110000;
	6'd28: segments = 14'b1101101_1111111;
	6'd29: segments = 14'b1101101_1111011;

	6'd30: segments = 14'b1111001_1111110;
	6'd31: segments = 14'b1111001_0110000;
	6'd32: segments = 14'b1111001_1101101;
	6'd33: segments = 14'b1111001_1111001;
	6'd34: segments = 14'b1111001_0110011;
	6'd35: segments = 14'b1111001_1011011;
	6'd36: segments = 14'b1111001_1011111;
	6'd37: segments = 14'b1111001_1110000;
	6'd38: segments = 14'b1111001_1111111;
	6'd39: segments = 14'b1111001_1111011;

	6'd40: segments = 14'b0110011_1111110;
	6'd41: segments = 14'b0110011_0110000;
	6'd42: segments = 14'b0110011_1101101;
	6'd43: segments = 14'b0110011_1111001;
	6'd44: segments = 14'b0110011_0110011;
	6'd45: segments = 14'b0110011_1011011;
	6'd46: segments = 14'b0110011_1011111;
	6'd47: segments = 14'b0110011_1110000;
	6'd48: segments = 14'b0110011_1111111;
	6'd49: segments = 14'b0110011_1111011;

	6'd50: segments = 14'b1011011_1111110;
	6'd51: segments = 14'b1011011_0110000;
	6'd52: segments = 14'b1011011_1101101;
	6'd53: segments = 14'b1011011_1111001;
	6'd54: segments = 14'b1011011_0110011;
	6'd55: segments = 14'b1011011_1011011;
	6'd56: segments = 14'b1011011_1011111;
	6'd57: segments = 14'b1011011_1110000;
	6'd58: segments = 14'b1011011_1111111;
	6'd59: segments = 14'b1011011_1111011;
	
	endcase
	
endmodule
