// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module TB;
  reg clk,reset,cancel;
  reg [4:0] money;
  reg [5:0] sel_item;
  wire [4:0] change; //change in 5,10,20 denomination
  wire [5:0]item_out; // upto 64 items
 
  vending_machine DUT(.clk(clk),
                      .reset(reset),
                      .money(money),
                      .cancel(cancel),
                      .sel_item(sel_item),
                      .change(change),
                      
                      .item_out(item_out));
 
   initial begin
    clk=0;
    reset=1;
    cancel=0;
    money=4'd0;
    sel_item=6'd0;
     $dumpfile("vending_machine.vcd");
     $dumpvars(0,TB);
  end
  always #15 clk=~clk;
  initial begin
    #1 reset =0;
    #14 money=4'd5;
    #15 money = 4'd0;
   
    #15 money=4'd5;
     
    #15 money = 4'd0;
    
    #15 money=4'd5;
    #3 sel_item = 6'd1;
    #15 money = 4'd0;
    #45 money=4'd5;
     
    #15 money = 4'd0;
    #15 money=4'd5;
    #15 money = 4'd0;
    #15 money = 4'd0;
    #15 money=4'd5;
    #15 money = 4'd0;
    #15 money=4'd5;
    #15 money = 4'd0;
    #15 money=4'd5;
    #15 money = 4'd0;
    #15 money=4'd5;
    #15 money = 4'd0;


    #60 $finish;
  end
endmodule
    
