`timescale 1ns/1ps

module tb_Q();
  parameter DATA_WIDTH = 16;
  parameter CLOCK = 10; 
  parameter NUM_TESTS = 8;   
  
  reg clk;
  reg rst;
  reg input_valid;
  reg signed [DATA_WIDTH-1:0] a, b, c, d;
  wire output_valid;
  wire done;
  wire signed [2*DATA_WIDTH+2:0] Q;
  
  reg signed [2*DATA_WIDTH+2:0] expected_Q;
  
  Q_top #(
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .input_valid(input_valid),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .output_valid(output_valid),
    .done(done),
    .Q(Q)
  );
  
  initial begin
    clk = 0;
    forever #(CLOCK/2) clk = ~clk;
  end
  
  reg signed [DATA_WIDTH-1:0] test_a[0:NUM_TESTS-1];
  reg signed [DATA_WIDTH-1:0] test_b[0:NUM_TESTS-1];
  reg signed [DATA_WIDTH-1:0] test_c[0:NUM_TESTS-1];
  reg signed [DATA_WIDTH-1:0] test_d[0:NUM_TESTS-1];
  reg signed [2*DATA_WIDTH+2:0] test_expected_Q[0:NUM_TESTS-1];
  
  integer errors;
  integer i;
  
  initial begin
    // Test 0
    test_a[0] = 16'd10;
    test_b[0] = 16'd5;
    test_c[0] = 16'd2;
    test_d[0] = 16'd3;
    test_expected_Q[0] = ((10-5)*(1+2+2+2)-(3+3+3+3)) >>> 1;
    
    // Test 1
    test_a[1] = 16'd20;
    test_b[1] = 16'd8;
    test_c[1] = 16'd1;
    test_d[1] = 16'd5;
    test_expected_Q[1] = ((20-8)*(1+1+1+1)-(5+5+5+5)) >>> 1;
    
    // Test 2
    test_a[2] = 16'd0;
    test_b[2] = 16'd0;
    test_c[2] = 16'd0;
    test_d[2] = 16'd0;
    test_expected_Q[2] = ((0-0)*(1+0)-0) >>> 1;
    
    // Test 3
    test_a[3] = -16'd5;
    test_b[3] = 16'd10;
    test_c[3] = 16'd3;
    test_d[3] = -16'd2;
    test_expected_Q[3] = ((-5-10)*(1+(3+3+3))-(-2-2-2-2)) >>> 1;
    
    // Test 4
    test_a[4] = 16'd100;
    test_b[4] = 16'd50;
    test_c[4] = -16'd1;
    test_d[4] = 16'd10;
    test_expected_Q[4] = ((100-50)*(1+(-1-1-1))-(10+10+10+10)) >>> 1;
    
    // Test 5
    test_a[5] = 16'h7FFF;
    test_b[5] = 16'h0001;
    test_c[5] = 16'd0;
    test_d[5] = 16'd0;
    test_expected_Q[5] = ((32767-1)*(1+0)-0) >>> 1;
    
    // Test 6
    test_a[6] = 16'h8000;
    test_b[6] = 16'h0000;
    test_c[6] = 16'd0;
    test_d[6] = 16'd0;
    test_expected_Q[6] = ((-32768-0)*(1+0)-4*0) >>> 1;
    
    // Test 7
    test_a[7] = 16'd1000;
    test_b[7] = 16'd500;
    test_c[7] = 16'd100;
    test_d[7] = 16'd200;
    test_expected_Q[7] = ((1000-500)*(1+100+100+100)-4*200) >>> 1;
  end
  
  initial begin
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    input_valid = 0;
    errors = 0;
    
    rst = 0;
    #(CLOCK*2);
    rst = 1;
    #(CLOCK);
    
    $display("\n=======================================================");
    $display("Testing at %0t ns", $time);
    $display("=======================================================");
    
    for (i = 0; i < NUM_TESTS; i = i + 1) begin
      case (i)
        0: $display("\n Test %0d:", i);
        1: $display("\n Test %0d:", i);
        2: $display("\n Test %0d:", i);
        3: $display("\n Test %0d:", i);
        4: $display("\n Test %0d:", i);
        5: $display("\n Test %0d:", i);
        6: $display("\n Test %0d:", i);
        7: $display("\n Test %0d:", i);
      endcase
      
      @(posedge clk);
      a = test_a[i];
      b = test_b[i];
      c = test_c[i];
      d = test_d[i];
      expected_Q = test_expected_Q[i];
      input_valid = 1;
      
      $display("Input: a=%0d, b=%0d, c=%0d, d=%0d", 
               a, b, c, d);
      $display("Expected: Q=%0d", expected_Q);
      
      @(posedge clk);
      input_valid = 0;
      
      @(posedge clk);
      if (!output_valid) begin
        $display("Waiting for output_valid");
        wait(output_valid);
        @(posedge clk);
      end
      
      if (Q !== expected_Q) begin
        $display("ERROR! NO MATCH!", 
                 Q, expected_Q);
        errors = errors + 1;
      end else begin
        $display("SUCCESS! THEY MATCH! Q=%0d", Q);
      end
      
      if (!done) begin
        $display("Waiting for done");
        wait(done);
      end
      @(posedge clk);
    end
    
    $display("\n=======================================================");
    if (errors == 0) begin
      $display("ALL TESTS PASSED!");
    end else begin
      $display("ERRORS DETECTED! %0d TESTS out of %0d FAILED!", 
               errors, NUM_TESTS);
    end
    $display("Test is done at %0t ns", $time);
    $display("=======================================================\n");
    
    #(CLOCK*5);
    $finish;
  end
  
  initial begin
    $dumpfile("tb_Q.vcd");
    $dumpvars(0, tb_Q);
  end
  
  
endmodule

