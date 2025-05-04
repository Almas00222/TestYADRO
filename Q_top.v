module Q_top #(
  parameter DATA_WIDTH = 16
)
(
  input logic clk, rst,
  input logic input_valid,
  
  input logic signed [DATA_WIDTH - 1:0] a, b, c, d,
  
  output logic output_valid,
  output logic done,
  output logic signed [2*DATA_WIDTH + 2:0] Q  
);
  
  logic signed [DATA_WIDTH - 1:0] a_reg, b_reg, c_reg, d_reg;
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      a_reg <= '0;
      b_reg <= '0;
      c_reg <= '0;
      d_reg <= '0;
      done <= 1'b1;  // ready for new data
    end else if (input_valid) begin
      a_reg <= a;    
      b_reg <= b;    
      c_reg <= c;    
      d_reg <= d;    
      done <= 1'b0;  // in process
    end else if (output_valid) begin
      done <= 1'b1;  // done when output is generated
    end
  end 
  
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Q <= '0;
      output_valid <= 1'b0;
    end else if (!done && !output_valid) begin
      Q <= ((a_reg - b_reg) * (1 + (c_reg << 1) + c_reg) - (d_reg << 2)) >>> 1;
      output_valid <= 1'b1;
    end else if (input_valid) begin  
      output_valid <= 1'b0;
    end
  end
  
endmodule


