`timescale 1ns/1ps

  
module vending_machine(
    input clk,
    input reset,
  input [1:0] money,
  input [7:0] sel_item,
  output reg [1:0] change, //change in 5,10,20 denomination
  output reg [7:0]item_out); // upto 64 items 
  reg [3:0]ps,ns;
  wire [3:0]cnt1,cnt2; // one for every item shift this to control module
  wire ctrl1,ctrl2;  
  reg key_read_reset;
    parameter IDLE=4'd0,
  FIVE=4'd1, 
  TEN=4'd2, 
  FIFTEEN=4'd3, 
  TWENTY=4'd4, 
  HASH=4'd5, 
  STAR=4'd6, 
  A=4'd7,B=4'd8,MASTER=4'd9;// states
    parameter no_sel=8'h00,
    cancel=8'h0F,
    hash = 8'h0E,
    star=8'h0D,
    news_paper = 8'hA1, //5rs
    coffee = 8'hA2; //10rs
    parameter zero=2'b00, 
    fifteen=2'b11,
    five=2'b01,
    ten=2'b10; //money or change
  // let password be #*AB
  control unit1(clk,reset,sel_item,cnt1,cnt2,ctrl1,ctrl2);
    always @(posedge clk) begin
        if(reset) begin
            ps<=IDLE;
        end
        else 
            ps<=ns;            
    end
    // next state and output logic
  always @(money,ps,sel_item)  begin
        case(ps)
            IDLE: begin
                case(money)
                    zero: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=IDLE; end
                            hash: begin item_out=no_sel; change=0; ns=HASH; end
                            star: begin item_out=no_sel; change=0; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=0; ns=IDLE; end
                            news_paper: begin item_out=no_sel; change = (cnt1==0)?zero:zero; ns=IDLE; end
                            coffee: begin item_out=no_sel; change = (cnt2==0)?zero:zero; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    five: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=FIVE; end
                            hash: begin item_out=no_sel; change=five; ns=IDLE; end
                            star: begin item_out=no_sel; change=five; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=five; ns=IDLE; end
                            news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?five:zero; ns=IDLE; end
                            coffee: begin item_out=no_sel; change = (cnt2==0)?five:five; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    ten: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=TEN; end
                            hash: begin item_out=no_sel; change=ten; ns=IDLE; end
                            star: begin item_out=no_sel; change=ten; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=ten; ns=IDLE; end
                            news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?ten:five; ns=IDLE; end
                            coffee: begin item_out=(cnt2==0)?no_sel:coffee; change = (cnt2==0)?ten:zero; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    default:begin ns=IDLE ; item_out=no_sel; change = 0; end
                endcase
                key_read_reset=1;
            end
            FIVE: begin
                case(money)
                    zero: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=FIVE; end
                            hash: begin item_out=no_sel; change=five; ns=IDLE; end
                            star: begin item_out=no_sel; change=five; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=five; ns=IDLE; end
                            news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?five:0; ns=IDLE; end
                            coffee: begin item_out=no_sel; change = (cnt2==0)?five:five; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    five: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=TEN; end
                            hash: begin item_out=no_sel; change=ten; ns=IDLE; end
                            star: begin item_out=no_sel; change=ten; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=ten; ns=IDLE; end
                            news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?10:5; ns=IDLE; end
                            coffee: begin item_out=(cnt2==0)?no_sel:coffee; change = (cnt2==0)?10:0; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                  ten: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=FIFTEEN; end
                            hash: begin item_out=no_sel; change=fifteen; ns=IDLE; end
                            star: begin item_out=no_sel; change=fifteen; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=fifteen; ns=IDLE; end
                            news_paper: begin item_out=news_paper; change = (cnt1==0)?fifteen:ten; ns=IDLE; end
                            coffee: begin item_out=coffee; change = (cnt2==0)?fifteen:five; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    default:begin ns=IDLE ; item_out=no_sel; change = money; end
                endcase
            end
            TEN: begin
                case(money)
                    zero: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=FIVE; end
                            hash: begin item_out=no_sel; change=five; ns=IDLE; end
                            star: begin item_out=no_sel; change=five; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=five; ns=IDLE; end
                            news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?five:zero; ns=IDLE; end
                            coffee: begin item_out=no_sel; change = (cnt2==0)?ten:zero; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    five: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=TEN; end
                            hash: begin item_out=no_sel; change=ten; ns=IDLE; end
                            star: begin item_out=no_sel; change=ten; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=ten; ns=IDLE; end
                             news_paper: begin item_out=(cnt1==0)?no_sel:news_paper; change = (cnt1==0)?fifteen:ten; ns=IDLE; end
                            coffee: begin item_out=(cnt2==0)?no_sel:coffee; change = (cnt2==0)?fifteen:five; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    ten: begin
                        case(sel_item)
                            no_sel: begin item_out=no_sel; change=0; ns=FIFTEEN; end
                            hash: begin item_out=no_sel; change=fifteen; ns=IDLE; end
                            star: begin item_out=no_sel; change=fifteen; ns=IDLE; end
                            cancel: begin item_out = no_sel; change=fifteen; ns=IDLE; end
                            news_paper: begin item_out=news_paper; change = (cnt1==0)?fifteen:zero; ns=IDLE; end // should be twenty actually
                            coffee: begin item_out=coffee; change = (cnt2==0)?fifteen:ten; ns=IDLE; end
                            default: begin change = 0; item_out=no_sel; ns=IDLE; $display("select item from menu"); end
                        endcase
                    end
                    default:begin ns=IDLE ; item_out=no_sel; change = money; end
                endcase
            end
            HASH: begin
                case(sel_item)
                    STAR: ns<=A;
                    default: ns<=IDLE;
                endcase
            end
            STAR: begin
                 case(sel_item)
                    A: ns<=A;
                    default: ns<=IDLE;
                endcase
            end
            A: begin
                case(sel_item)
                    B: ns<=MASTER;
                    default: ns<=IDLE;
                endcase
            end
            MASTER: begin
                 case(sel_item)
                    cancel: ns<=IDLE;
                    default: ns<=MASTER;
                endcase
            end
            default: begin ns=IDLE; item_out=no_sel; change=5'd0; end
        endcase
    end
endmodule
  
  module control (
  input clk,
  inout rst,
  input [7:0]sel_item,
  output wire [3:0] w_cnt1,
  output wire [3:0] w_cnt2,
  output wire w_ctrl1,
    output wire w_ctrl2
);
reg [3:0]cnt1,cnt2;
wire vend_success1,vend_success2;
reg [2:0]ctrl1,ctrl2;
assign w_cnt1 = cnt1;
assign w_cnt2 = cnt2;

   // loadable_down_counter ldc1(clk,load1,ctrl1, ctrl1,vend_success1);
    //loadable_down_counter ldc2(clk,load2,ctrl2, ctrl2,vend_success2);

always @(posedge clk) begin
  if (rst) begin
    cnt1 <= 4'd10;
    cnt2 <= 4'd10;
  end
  else if (sel_item==8'hA1 && cnt1>0) begin
    ctrl1 <= 10 - cnt1 + 1;
     cnt1 <= cnt1 -1;
    end
  else if(sel_item==8'hA2 && cnt2>0)begin
    ctrl2 <=10 - cnt2+1;
    cnt2 <= cnt2-1;
  end
 else begin
   ctrl1=(ctrl1>0)?ctrl1-1:ctrl1;
   ctrl2=(ctrl2>0)?ctrl2-1:ctrl2;

 end
   
   
  end
endmodule


// module loadable_down_counter (
//   input clk,
//   input load,
//   input [2:0] load_data,
//   output wire ctrl,
//   output wire vend_success
// );
// reg r_ctrl,r_vend_success;
//   reg [2:0]count;
//   assign ctrl = r_ctrl;
//   assign vend_success = r_vend_success;
// always @(posedge clk) begin
//     if(r_vend_success)
//         r_vend_success <=0;  
//           if (load) begin
//   r_ctrl<=0;
//         end
//         else if (!load) begin
//             if (count > 0) begin
//             count <= count - 1;
//             r_ctrl <=1;
//             end
//             else begin
//                 r_ctrl<=0;
//                 r_vend_success <=1;
//             end
        
//     end
// end

// endmodule
  
  
