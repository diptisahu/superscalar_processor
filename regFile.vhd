library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.Microprocessor_project.all;

entity regFile is
    port(
        a1, a2, a3, a4, a5, a6 : in std_logic_vector(2 downto 0);
        d5, d6, pci : in std_logic_vector(15 downto 0);
        d1, d2, d3, d4 : out std_logic_vector(15 downto 0);
        regWr1, regWr2, pcWr : in std_logic;
        clk, reset : in std_logic);
end entity;

architecture Behave of regFile is
    type vec16 is array(natural range <>) of std_logic_vector(15 downto 0);
    signal reg : vec16(0 to 7) := (others => (others => '0'));
begin

    d1 <= reg(to_integer(unsigned(a1)));
    d2 <= reg(to_integer(unsigned(a2)));
    d3 <= reg(to_integer(unsigned(a3)));
    d4 <= reg(to_integer(unsigned(a4)));
    
    process(clk)
        variable wrAddr1, wrAddr2: integer := 0;
    begin
        wrAddr1 := to_integer(unsigned(a5));
	wrAddr2 := to_integer(unsigned(a6));
        if(rising_edge(Clk)) then
            if(reset='1') then
                reg <= (others => (others => '0'));
            else 
                if(regWr1='1') then
                    reg(wrAddr1) <= d5;
                end if;
		if(regWr2='1') then
                    reg(wrAddr2) <= d6;
                end if;
                -- Write to PC. R7 not being written through A3,D3.
                if(pcWr='1' and (wrAddr1/=7 or regWr1='0') and (wrAddr2/=7 or regWr2='0')) then 
                    reg(7) <= pci;
                end if;
            end if;
        end if; 
    end process;
end Behave;
