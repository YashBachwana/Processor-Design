`timescale 1ns / 1ps

module tb();
    reg clk;
    reg [3:0] Indexing ;
    wire [7:0]accumulator ;
    wire [7:0]regis ;
    Control_Unit uut(clk,Indexing,accumulator,regis);
    
    initial begin
    clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
    Indexing = 0 ;   
    #20 ;
    Indexing = 3 ;   
    #20 ;
    Indexing = 5 ;   
    #20 ;
    $finish;
    end
    
endmodule