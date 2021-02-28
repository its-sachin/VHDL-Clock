`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2019 02:19:25 PM
// Design Name: 
// Module Name: Decoder_7-segment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decoder_7_segment(
    input [3:0] in, //4 bits going into the segment
    output reg [6:0] seg //display the the BCD number on a 7-segment
    );
    
    always @(in)
    begin
    case(in)
    4'b0000: seg=7'b0000001; //active low logic here, this displays zero on the seven segment
    4'b0001: seg=7'b1001111; //"1"
    4'b0010: seg=7'b0010010;//"2"
           4'b0011: seg=7'b0000110;//3
               4'b0100: seg=7'b1001100;//4
                4'b0101: seg=7'b0100100;//5
                 4'b0110: seg=7'b0100000;//6
                  4'b0111: seg=7'b0001111;//7
                   4'b1000: seg=7'b0000000;//8
                    4'b1001: seg=7'b0001100;//9
                    4'b1010: seg=7'b0001000; //A
                    4'b1011: seg=7'b0000011;//B
                    4'b1100: seg=7'b1000110;//C
                    4'b1101: seg=7'b0100001;//D
                    4'b1110: seg=7'b0000110;//E
                    4'b1111: seg=7'b0001110;//F
                    endcase
                    end
                    
     
endmodule
