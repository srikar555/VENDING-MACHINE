// Code your design here
// Code your design here
`timescale 1ns/1ps

module vending_machine(
  input clk,
  input reset,
  input [4:0] money,
  input cancel,
  input [5:0] sel_item,
  output reg [4:0] change,//change in 5,10,20 denomination
  output reg [5:0]item_out); // upto 64 items 
  reg [1:0]ps,ns;
  reg [31:0]sum_coin;
  parameter IDLE=2'b0, FIVE=2'b1, TEN=2'd2, FIFTEEN=2'd3; // states
  parameter newspaper = 6'd1, // 5rs
            coffee = 6'd2, //10rs
            lays = 6'd3; //15 rs
  
  parameter one=5'd1,five=5'd5,ten=5'd10; //money
  parameter wait_time = 5'd20; // will wait for max of 20 sec
 initial
    begin
      sum_coin=31'd0;
      ps<=IDLE;
      ns<=IDLE;
    end
 
  always @(posedge clk) begin
      ps <= reset? IDLE : ns;

  end
  // next state logic
  always @(posedge money,ps)
    begin
       case(ps)
       IDLE: begin
            case(money)
              five: begin ns=FIVE; change =0; end
              default:begin ns=ps ; change = money; end
            endcase
          end
        FIVE: begin
              case(money)
              five: begin ns=TEN; change =0;end
              default: begin ns=ps ; change = money; end
            endcase
        end
        TEN: begin
              case(money)
              five: begin ns=FIFTEEN; change =0;end
              default:begin ns=ps; change = money; end
            endcase
        end
        FIFTEEN: begin
              case(money)
                five: begin ns=ps; change=money; end
              default:begin ns=ps ; change = money; end
              endcase
        end
                     
        default: begin ns=IDLE; change=money; end        
          
      endcase 
    end
  
    //output logic: change prod_out ns
  always @(sel_item) begin
       case(ps)
         IDLE: begin ns=ps ; change = money; end            
         FIVE: begin
           case(sel_item)
              newspaper: begin ns=IDLE; change = 0; end
              default: begin ns=ps ; change = 0; $display("select item from menu"); end
              endcase
          end
          TEN: begin
                case(sel_item)
                newspaper: begin ns=FIVE; change = 4'd5; end  
                coffee: begin ns=IDLE; change =0;end
                default:begin ns=ps; change = ps; $display("select item from menu"); end
              endcase
          end
          FIFTEEN: begin
                case(money)
                  newspaper: begin ns=TEN; change = 4'd10; end  
                coffee: begin ns=FIVE; change =4'd5; end
                  lays: begin ns=IDLE; change=4'd0; end
                default:begin ns=ps; change = ps; $display("select item from menu");end  
                endcase
          end

          default: begin ns=IDLE; change=money; end      
          endcase
            
        end
endmodule
  
  
  
