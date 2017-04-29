ghdl -a branch.vhd
ghdl -a Testbench_branchpredictor.vhd
ghdl -m Testbench_BranchPredictor
ghdl -r Testbench_BranchPredictor --stop-time=200ns --vcd=run.vcd --wave=waveform.ghw
