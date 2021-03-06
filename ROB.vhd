library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Microprocessor_project.all;

--p31_instr_out, p32_instr_out, p31_instr_d1_out, p31_instr_d2_out, p32_instr_d1_out,
	--p32_instr_d2_out, p31_instr_d_out, p32_instr_d_out, Dout1, Dout2, clk, rst, rob_instr1, rob_instr2

--without dispatching logic
entity ROB is
    port(
        instr1, instr2 : in std_logic_vector(50 downto 0);
        instr1_d1,instr1_d2,instr2_d1,instr2_d2 : in std_logic_vector(15 downto 0);
	instr1_d, instr2_d, Dout1, Dout2 : in std_logic_vector(15 downto 0);
        clk,reset: in std_logic;
	rob_instr1, rob_instr2 : out std_logic_vector(114 downto 0);
	pci : out std_logic_vector(15 downto 0);
	pcWr : out std_logic;
        stall1, stall2 : out std_logic);
end entity;

architecture Behave of ROB is
    type vec116 is array(natural range <>) of std_logic_vector(115 downto 0);
    signal reg : vec116(0 to 15) := (others => (others => '0'));
    signal data1, data2: std_logic_vector(115 downto 0);
begin

    data1(50 downto 0) <= instr1;
    data1(66 downto 51) <= instr1_d1;
    data1(82 downto 67) <= instr1_d2;
    data1(98 downto 83) <= instr1_d;
    data1(114 downto 99) <= Dout1;
    data1(115) <= '1';			--occupied
  
    data2(50 downto 0) <= instr2;
    data2(66 downto 51) <= instr2_d1;
    data2(82 downto 67) <= instr2_d2;
    data2(98 downto 83) <= instr2_d;
    data2(114 downto 99) <= Dout2;
    data2(115) <= '1';			--occupied
  
    process(clk)
        variable wrAddr1,wrAddr2 : integer := 16;
	variable data : std_logic_vector(115 downto 0);
	variable stall_in_1, stall_in_2 : std_logic;
    begin
    	stall_in_1 := '1';
    	stall_in_2 := '1';

	data := reg(15);
	if(data(115)='0') then
	    wrAddr1 := 15;
	    stall_in_1 := '0';
	end if;
	data :=reg(14);
	if(data(115)='0') then
	    if (stall_in_1='1') then
	    	wrAddr1 := 14;
	    	stall_in_1 := '0';
	    else
		wrAddr2 := 14;
		stall_in_2 := '0';
	    end if;
	end if;
	data :=reg(13);
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
	if(data(115)='0') then
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
