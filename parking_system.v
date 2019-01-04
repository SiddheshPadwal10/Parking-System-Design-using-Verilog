 `timescale 1ns / 1ps
module parking_system(sensor_entrance,sensor_exit,password_1,password_2,Clock_KEY1,Reset_KEY0,GREEN_LED,RED_LED,HEX_7,HEX_6,HEX_5,HEX_4,HEX_3,HEX_2, HEX_1, HEX_0, Clk_50);

input sensor_entrance;
input Clock_KEY1,Reset_KEY0,Clk_50;
input sensor_exit;
input [1:0]password_1, password_2;
output [6:0] HEX_7,HEX_6,HEX_5,HEX_4,HEX_3,HEX_2,HEX_1,HEX_0;
output  GREEN_LED; 
output  RED_LED;

//Using Debounce for generate 1 Clock
wire clk;
DeBounce De1 (Clk_50,Clock_KEY1,clk);
wire reset_n;
DeBounce De0 (Clk_50,Reset_KEY0,reset_n);

parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASS = 3'b010, RIGHT_PASS = 3'b011,STOP = 3'b100;
 // Moore FSM : output just depends on the current state
reg[2:0] current_state, next_state;
reg[31:0] counter_wait;
reg red_tmp;
reg green_tmp;
reg [6:0] HEX_7,HEX_6,HEX_5,HEX_4,HEX_3,HEX_2,HEX_1, HEX_0;
 // Next state
 always @(posedge clk or negedge reset_n)
 begin
 if(~reset_n) 
 current_state = IDLE;
 else
 current_state = next_state;
 end
 always @(posedge clk or negedge reset_n)
 begin
 case(current_state)
 IDLE: begin
         if(sensor_entrance == 1)
 next_state = WAIT_PASSWORD;
 else
 next_state = IDLE;
 end
 WAIT_PASSWORD: begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 WRONG_PASS: begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = WRONG_PASS;
 end
 RIGHT_PASS: begin
 if(sensor_entrance==1 && sensor_exit == 1)
 next_state = STOP;
 else if(sensor_exit == 1)
 next_state = IDLE;
 else
 next_state = RIGHT_PASS;
 end
 STOP: begin
 if((password_1==2'b01)&&(password_2==2'b10))
 next_state = RIGHT_PASS;
 else
 next_state = STOP;
 end
 default: next_state = IDLE;
 endcase
 end
 // LEDs and output, change the period of blinking LEDs here
 always @(posedge clk or negedge reset_n) begin 
 case(current_state)
 IDLE: begin
 green_tmp = 1'b0;
 red_tmp =   1'b0;
 HEX_0 = 7'b1111111; // off
 HEX_1 = 7'b1111111; // off
 HEX_2 = 7'b1111111;
 HEX_3 = 7'b1111111;
 HEX_4 = 7'b1111111;
 HEX_5 = 7'b1111111;
 HEX_6 = 7'b1111111;
 HEX_7 = 7'b1111111;

 end
 WAIT_PASSWORD: begin
 green_tmp = 1'b0;
 red_tmp =   1'b1;
 HEX_7 = 7'b0000110; // E
 HEX_6 = 7'b0101011; // n
 HEX_5 = 7'b0000111; //t
 HEX_4 = 7'b0000110; //e
 HEX_3 = 7'b0001000; //r
 HEX_2 = 7'b0001100; //p
 HEX_1 = 7'b1101111; //i
 HEX_0 = 7'b0101011; //n
  
 end
 WRONG_PASS: begin
 green_tmp = 1'b0;
 red_tmp =   1'b1;
 HEX_7 = 7'b1001111; //i
 HEX_6 = 7'b0101011; // n
 HEX_5 = 7'b0100111; // c
 HEX_4 = 7'b1000000; // o
 HEX_3 = 7'b0001000; // r
 HEX_2 = 7'b0000110; // e
 HEX_1 = 7'b0100111; // c
 HEX_0 = 7'b0000111; // t 
 end
 RIGHT_PASS: begin
 green_tmp = 1'b1;
 red_tmp = 1'b0;
 HEX_7 = 7'b1111111; // 
 HEX_6 = 7'b1111111; // 
 HEX_5 = 7'b0000010; // 6
 HEX_4 = 7'b1000000; // 0
 HEX_3 = 7'b1111111; // 
 HEX_2 = 7'b1111111; //
 HEX_1 = 7'b1111111; // 
 HEX_0 = 7'b1111111; // 
 end
 STOP: begin
 green_tmp = 1'b0;
 red_tmp =  1'b1;
 HEX_2 = 7'b0001100; //p
 HEX_1 = 7'b1101111; //i
 HEX_0 = 7'b0101011; //n
 HEX_3 = 7'b1111111; //
 HEX_7 = 7'b0010010; // 5
 HEX_6 = 7'b0000111; // t
 HEX_5 = 7'b1000000; // o
 HEX_4 = 7'b0001100; // P 
 end
 endcase
 end
 assign RED_LED = red_tmp  ;
 assign GREEN_LED = green_tmp;
 
 endmodule