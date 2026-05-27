`timescale 1ns / 1ps


module CLK_DELAY(
        input logic  clk,
        input logic  rst_clk,
        output logic clk_delay
    );
    
    logic [31:0] count;
    
    always_ff @(posedge clk) begin
        if(rst_clk) begin
            count <= 32'd0;
        end
        else begin
            count <= count + 32'd1;
        end
    end
    
    assign clk_delay = count[27];
    
endmodule
