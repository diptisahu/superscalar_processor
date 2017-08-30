library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Microprocessor_project.all;

--without valid logic and dispatching logic
entity ROB is
    port(
        instr1,pc1 : in std_logic_vector(15 downto 0);
        instr1_rs1,instr1_rs2,instr1_rd: in std_logic_vector(2 downto 0);
        instr1_branch,instr1_decode_br_loc,instr1_regread_br_loc: in std_logic;
        instr1_branch_state: in std_logic_vector (1 downto 0);
        instr1_mem_read,instr1_mem_write,instr1_rf_write: in std_logic;
        instr2,pc2 : in std_logic_vector(15 downto 0);
        instr2_rs1,instr2_rs2,instr2_rd: in std_logic_vector(2 downto 0);
        instr2_branch,instr2_decode_br_loc,instr2_regread_br_loc: in std_logic;
        instr2_branch_state: in std_logic_vector (1 downto 0);
        instr2_mem_read,instr2_mem_write,instr2_rf_write: in std_logic;
        clk,reset: in std_logic;
	stall1, stall2: out std_logic);
end entity;

architecture Behave of ROB is
    type vec51 is array(natural range <>) of std_logic_vector(50 downto 0);
    signal reg : vec51(0 to 15) := (others => (others => '0'));
    signal data1, data2: std_logic_vector(50 downto 0);
begin

    data1(15 downto 0) <= instr1;
    data1(31 downto 16) <= pc1;
    data1(34 downto 32) <= instr1_rs1;
    data1(37 downto 35) <= instr1_rs2;
    data1(40 downto 38) <= instr1_rd;
    data1(41) <= instr1_branch;
    data1(42) <= instr1_decode_br_loc;
    data1(43) <= instr1_regread_br_loc;
    data1(45 downto 44) <= instr1_branch_state;
    data1(46) <= instr1_mem_read;
    data1(47) <= instr1_mem_write;
    data1(48) <= instr1_rf_write;
    data1(49) <= '1';
    data1(50) <= '0';
  
    data2(15 downto 0) <= instr2;
    data2(31 downto 16) <= pc2;
    data2(34 downto 32) <= instr2_rs1;
    data2(37 downto 35) <= instr2_rs2;
    data2(40 downto 38) <= instr2_rd;
    data2(41) <= instr2_branch;
    data2(42) <= instr2_decode_br_loc;
    data2(43) <= instr2_regread_br_loc;
    data2(45 downto 44) <= instr2_branch_state;
    data2(46) <= instr2_mem_read;
    data2(47) <= instr2_mem_write;
    data2(48) <= instr2_rf_write;
    data2(49) <= '1';			--occupied
    data2(50) <= '0';			--valid
  
    process(clk)
        variable wrAddr1,wrAddr2 : integer := 16;
	variable data : std_logic_vector(50 downto 0);
	variable stall_in_1, stall_in_2 : std_logic;
    begin
    	stall_in_1 := '1';
    	stall_in_2 := '1';

	data := reg(15);
	if(data(49)='0') then
	    wrAddr1 := 15;
	    stall_in_1 := '0';
	end if;
	data :=reg(14);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 14;
	    	stall_in_1 := '0';
	    else
		wrAddr2 := 14;
		stall_in_2 := '0';
	    end if;
	end if;
	data :=reg(13);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 13;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 13;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(12);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 12;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 12;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(11);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 11;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 11;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(10);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 10;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 10;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(9);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 9;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 9;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(8);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 8;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 8;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(7);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 7;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 7;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(6);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 6;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 6;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(5);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 5;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 5;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(4);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 4;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 4;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(3);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 3;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 3;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(2);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 2;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 2;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(1);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 1;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 1;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;
	data :=reg(0);
	if(data(49)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 0;
	    	stall_in_1 := '0';
	    else
		if (stall_in_2='1') then
		    wrAddr2 := 0;
		    stall_in_2 := '0';
		end if;
	    end if;
	end if;

        if(rising_edge(Clk)) then
            if(reset='1') then
                reg <= (others => (others => '0'));
            else 					
                reg(wrAddr1) <= data1;
                reg(wrAddr2) <= data2;
            end if;
        stall1 <= stall_in_1;
	stall2 <= stall_in_2;
        end if; 
    end process;

end Behave;
