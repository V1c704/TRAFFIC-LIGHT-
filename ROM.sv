`timescale 1ns / 1ps

module ROM(
        input logic [2:0]  in,
        output logic [3:0] out
    );
    
    always_comb begin
        case(in)
            3'b100: begin
                        out = 4'b0100;
                    end
            3'b110: begin
                        out = 4'b0010;
                    end
            3'b010: begin
                        out = 4'b0100;
                    end
            3'b011: begin
                        out = 4'b0011;
                    end  
            default: begin
                        out = 4'bxxxx;
                    end
        endcase
    end
    
endmodule
