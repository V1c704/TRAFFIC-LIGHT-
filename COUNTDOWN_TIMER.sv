`timescale 1ns / 1ps

module COUNTDOWN_TIMER(
        input logic        clk,
        input logic        rst,
        input logic        load,
        input logic  [3:0] timer_value,
        output logic       timer_done
    );
    
    logic [3:0] count;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst)begin
            count <= 4'b1111;
        end
        else begin
            if(load) begin
                count <= timer_value;
            end
            else begin
                if(count > 0)begin
                    count <= count - 1;
                end
            end   
        end
    end
    
    assign timer_done = (count == 4'b0000);
    
endmodule
