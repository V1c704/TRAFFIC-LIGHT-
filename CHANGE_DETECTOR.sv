`timescale 1ns / 1ps

module CHANGE_DETECTOR(
        input logic       clk,
        input logic       rst,
        input logic [2:0] in,
        output logic      change
    );
    
    logic [2:0] register;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            change <= 1'b0;
            register <= 3'd0;
        end
        else begin
                if(in != register) begin
                        change <= 1'b1;
                end
                else begin
                        change <= 1'b0;
                end
        end 
        register <= in;
    end
    
endmodule

