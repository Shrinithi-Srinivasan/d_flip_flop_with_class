class clock;
  task clk_gen(ref logic clk);
    begin
      clk = 1;
      forever #5 clk = ~clk;
    end
  endtask
endclass
class reset;
  task rst_gen(ref logic rst);
    begin
      rst = 1;
      #10 rst = 0;
    end
  endtask
endclass
class stimulus_run;
  task stimulus(ref logic d);
    begin
      d = 0;
      #10 d = $urandom_range(0, 1);
      #20 d = $urandom_range(0, 1);
      #30 d = $urandom_range(0, 1);
      #40 $finish;
    end
  endtask
endclass
module d_flip_flop_tb_top;
  logic d;logic clk;logic rst;logic q;
  d_flip_flop dut( .d(d), .clk(clk),.rst(rst),.q(q) );
  clock clk_inst;
  reset rst_inst;
  stimulus_run stim_inst;
  initial begin
    clk_inst = new();
    rst_inst = new();
    stim_inst = new();
    fork
      clk_inst.clk_gen(clk);
      rst_inst.rst_gen(rst);
      stim_inst.stimulus(d);
    join
  end
  initial begin
    $dumpfile("dumpfile.vcd");
    $dumpvars(1);
  end
  initial begin
    $monitor("At time = %0t: clk = %0b rst = %0b d = %0b q = %0b");
    $display("End of stimulation!");
  end
endmodule
