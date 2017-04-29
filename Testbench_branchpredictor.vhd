library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

entity Testbench_BranchPredictor is
end entity;
architecture Behave of Testbench_BranchPredictor is

    component BranchPredictor is
    port(PC_fetch1, PC_fetch2, PC_execute1, PC_execute2: in std_logic_vector(15 downto 0);
        fetch_valid1, fetch_valid2: out std_logic;
        fetch_target1, fetch_target2: out std_logic_vector(15 downto 0);
        exec_target1, exec_target2: in std_logic_vector(15 downto 0);
        taken1, taken2, write1, write2: in std_logic;
        clk, rst: in std_logic
        );
    end component;


  signal PC_fetch1, PC_fetch2, PC_execute1, PC_execute2: std_logic_vector(15 downto 0);
  signal fetch_target1, fetch_target2, exec_target1, exec_target2: std_logic_vector(15 downto 0);
  signal fetch_valid1, fetch_valid2, taken1, taken2, write1, write2: std_logic;

signal clk: std_logic := '0';
  signal rst: std_logic := '1';
  

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;


function to_std_logic(z: bit) return std_logic is
variable ret_val: std_logic;
begin
if (z = '1') then
ret_val := '1';
else
ret_val := '0';
end if;
return(ret_val);
end to_std_logic;

begin
clk <= not clk after 5 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
     rst <= '0';
     wait;
  end process;

process
variable err_flag : boolean := false;
File INFILE: text open read_mode is "BranchPredictor.txt";
FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

---------------------------------------------------
-- edit the next two lines to customize
variable v_pcf1, v_pcf2, v_pce1, v_pce2, v_ft1, v_ft2, v_et1, v_et2: bit_vector(15 downto 0);
variable v_fv1, v_fv2, v_t1, v_t2, v_w1, v_w2 : bit;

----------------------------------------------------
variable INPUT_LINE: Line;
variable OUTPUT_LINE: Line;
variable LINE_COUNT: integer := 0;

begin
wait until clk = '1';

while not endfile(INFILE) loop
LINE_COUNT := LINE_COUNT + 1;

readLine (INFILE, INPUT_LINE);
read (INPUT_LINE, v_pcf1);
read (INPUT_LINE, v_pcf2);
read (INPUT_LINE, v_pce1);
read (INPUT_LINE, v_pce2);
read (INPUT_LINE, v_et1);
read (INPUT_LINE, v_et2);
read (INPUT_LINE, v_t1);
read (INPUT_LINE, v_t2);
read (INPUT_LINE, v_w1);
read (INPUT_LINE, v_w2);


--read (INPUT_LINE, v_od1);
--read (INPUT_LINE, v_od2);
--read (INPUT_LINE, v_opco);

--------------------------------------
-- from input-vector to DUT inputs
--------------------------------------

taken1 <= to_std_logic(v_t1);
taken2 <= to_std_logic(v_t2);
write1 <= to_std_logic(v_w1);
write2 <= to_std_logic(v_w2);

PC_fetch1 <= to_stdlogicvector(v_pcf1);
PC_fetch2 <= to_stdlogicvector(v_pcf2);
PC_execute1 <= to_stdlogicvector(v_pce1);
PC_execute2 <= to_stdlogicvector(v_pce2);
exec_target1 <= to_stdlogicvector(v_et1);
exec_target2 <= to_stdlogicvector(v_et2);


wait until clk = '1';
end loop;

assert (err_flag) report "SUCCESS, all tests passed." severity note;
assert (not err_flag) report "FAILURE, some tests failed." severity error;

wait;
end process;



  dut: BranchPredictor
     port map (PC_fetch1 => PC_fetch1, PC_fetch2 => PC_fetch2,
            PC_execute1 => PC_execute1, PC_execute2 =>PC_execute2,
        fetch_target1 => fetch_target1, fetch_target2 =>fetch_target2,
        exec_target1 => exec_target1, exec_target2 => exec_target2,
        taken1 => taken1, taken2 => taken2, write1 => write1, write2 =>write2,
        clk => clk, rst => rst, fetch_valid1 => fetch_valid1, fetch_valid2 => fetch_valid2
        );

end Behave;
