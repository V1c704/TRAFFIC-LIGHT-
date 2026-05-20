`timescale 1ns / 1ps

module MUX(
        input logic  in0,
        input logic  in1,
        input logic  sel,
        output logic out
    );
    
    always_comb begin
        case(sel)
            1'b0: begin
                  out = in0;
                  end
            1'b1: begin
                  out = in1;  
                  end
            default: begin
                  out = 1'bx;      
                  end
        endcase
    end
    
endmodule
