`timescale 1ns / 1ps


module TOP(
    input logic clk,
    input logic rst_clk,
    input logic rst_tf,
    input logic walk,
    output logic clk_delay,
    output logic green,
    output logic red,
    output logic blue
    );
    
    CLK_DELAY clk_delay0(
        .clk(clk),     
        .rst_clk(rst_clk), 
        .clk_delay(clk_delay)
    );
    
    TRAFFIC_LIGHT dut(
        .clk(clk_delay),  
        .rst(rst_tf),  
        .walk(walk), 
        .green(green),
        .red(red),  
        .blue(blue)  
    );    
    
endmodule
