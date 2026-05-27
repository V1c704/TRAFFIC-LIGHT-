`timescale 1ns / 1ps


module testbench();

logic clk;
logic rst;
logic walk;
logic green;
logic red;
logic blue;

TRAFFIC_LIGHT dut(
    .clk(clk),  
    .rst(rst),  
    .walk(walk), 
    .green(green),
    .red(red),  
    .blue(blue)    
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    walk = 0;
    
    @(posedge clk);
    rst = 0;
    
    @(posedge clk);
    walk = 1;
    
    @(posedge clk);
    walk = 0;
    
    repeat(20) @(posedge clk);
    walk = 1;
    
    @(posedge clk);
    walk = 0;
    
    repeat(20) @(posedge clk);
    $stop;
end

endmodule
