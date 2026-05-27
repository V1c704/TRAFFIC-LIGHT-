`timescale 1ns / 1ps

module TRAFFIC_LIGHT_FSM(
        input logic  clk,
        input logic  rst,
        input logic  walk,
        input logic  timer_done,
        output logic green,
        output logic red,
        output logic flash
    );
    
    localparam GREEN_STATE = 2'b00;
    localparam YELLOW_STATE = 2'b01;
    localparam RED_STATE = 2'b10;
    localparam FLASH_STATE = 2'b11;
    
    logic [1:0] state, state_next;
    
    
    always_ff @(posedge clk) begin
        if(rst)
            state <= GREEN_STATE;
        else
            state <= state_next;
    end
    
    always_comb begin
        state_next = state;
        case(state)
            GREEN_STATE: begin
                            if(walk == 0) state_next = GREEN_STATE;
                            else if(walk == 1) state_next = YELLOW_STATE;
                         end
            YELLOW_STATE: begin
                            if(timer_done == 0) state_next = YELLOW_STATE;
                            else if(timer_done == 1) state_next = RED_STATE;
                         end
            RED_STATE: begin
                            if(timer_done == 0) state_next = RED_STATE;
                            else if(timer_done == 1) state_next = FLASH_STATE;
                         end
            FLASH_STATE: begin
                            if(timer_done == 0) state_next = FLASH_STATE;
                            else if(timer_done == 1) state_next = GREEN_STATE;
                         end
            default: state_next = GREEN_STATE;                                                    
        endcase              
    end
    
    assign green = (state == GREEN_STATE || state == YELLOW_STATE);
    assign red = ~(state == GREEN_STATE);
    assign flash = (state == FLASH_STATE); 
    
endmodule
