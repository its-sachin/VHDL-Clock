`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2019 02:59:19 PM
// Design Name: 
// Module Name: binarytoBCD
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


module binarytoBCD(
    input [11:0] binary, //12 bit input data that would come-in
    output reg [3:0] thos, //outputs thousands
    output reg [3:0] huns,//hundreds,
    output reg [3:0] tens,//tens
    output reg [3:0] ones//ones
    );
    
    reg [11:0] bcd_data=0;
    
    always @(binary) //1250
    begin
    bcd_data=binary; //1250
    thos=bcd_data/1000;//1250/1000=1, ""1""
    bcd_data=bcd_data%1000;//1250/1000= 250
    huns =bcd_data/100;//250/100 =2, ""2""
    bcd_data=bcd_data%100;//250/100, remainder here is 50
    tens = bcd_data/10;//50/10 = ""5""
    ones = bcd_data%10; //5/10 = ""0""
    end
    endmodule
