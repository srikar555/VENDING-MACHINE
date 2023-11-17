`timescale 1ns/1ps

module testbench;

  // Inputs
  reg clk;
  reg reset;
  reg [1:0] money;
  reg [7:0] sel_item;

  // Outputs
  wire [1:0] change;
  wire [7:0] item_out;

  // Instantiate the module under test
  vending_machine uut(
    .clk(clk),
    .reset(reset),
    .money(money),
    .sel_item(sel_item),
    .change(change),
    .item_out(item_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial values
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    reset = 1;
    money = 0;
    sel_item = 0;
    #10 reset = 0; // De-assert reset after 10 time units

    // Test scenario 1: Insert money, select item
    // Example scenario - You can modify and add your test cases here
    #14 money = 2'b01; // Insert 5 units
    #10 money=0;
    #10 sel_item = 8'hA1;
    #6 sel_item = 8'h00;// Selec news_paper
       #14 money = 2'b01; // Insert 5 units
    #10 money=0;
    #10 sel_item = 8'hA1;
    #6 sel_item = 8'h00;// Selec news_paper
    #100; // Add more test cases or delays as needed
    // End of test scenario

    // You can add more test scenarios here by changing inputs and observing outputs
    // Ensure enough simulation time to observe the behavior of the module

    // Finish simulation after a certain time
    #500;
    $finish;
  end

  // Display outputs during simulation
  always @(change or item_out) begin
    $display("Change: %b, Item Out: %h", change, item_out);
  end

endmodule
