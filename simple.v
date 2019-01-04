
module simple (SW, LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,KEY,CLOCK_50, LEDG); //Main Module
//pin assignment
input [5:0] SW; // Toggle switches
input [1:0] KEY;
input CLOCK_50;
output [7:0]LEDR; //Red LEDs
output [7:0]LEDG;
output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7; //LCD 7-Segment

parking_system instant1(SW[0],SW[1],SW[3:2],SW[5:4],KEY[1],KEY[0],LEDG[0],LEDR[0],HEX7,HEX6,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0,CLOCK_50);

endmodule