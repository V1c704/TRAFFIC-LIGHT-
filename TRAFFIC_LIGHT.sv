`timescale 1ns / 1ps

module TRAFFIC_LIGHT(
        input logic  clk,
        input logic  rst,
        input logic  walk,
        output logic green,
        output logic red,
        output logic blue
    );
    
    logic flash;
    logic timer_done;
    logic [3:0] timer_value;
    logic change;
    
    TRAFFIC_LIGHT_FSM FSM0(
        .clk(clk),       
        .rst(rst),       
        .walk(walk),      
        .timer_done(timer_done),
        .green(green),     
        .red(red),       
        .flash(flash)
    );
    
    ROM rom0(
        .in({green, red, flash}),
        .out(timer_value)
    );
    
    CHANGE_DETECTOR change_det0(
        .clk(clk),  
        .rst(rst),  
        .in({green, red, flash}),   
        .change(change)
    );
    
    COUNTDOWN_TIMER timer0(
        .clk(clk),        
        .rst(rst),        
        .load(change),       
        .timer_value(timer_value),
        .timer_done(timer_done)  
    );
    
    MUX mux0(
        .in0(~green),
        .in1(clk),
        .sel(flash),
        .out(blue) 
    );
    
    
endmodule
