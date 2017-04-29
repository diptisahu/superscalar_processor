library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

entity dispatcher2 is

port(	busy11, busy12, busy21, busy22 : in std_logic;	--from previous pipeline regarding arf
		valid11, valid12, valid21, valid22 : in std_logic; --from rrf regarding the associated tags
		tag11, tag12, tag21, tag22 : in std_logic_vector(3 downto 0);
		broadcast_tag : in std_logic_vector(3 downto 0);
		broadcast_valid : in std_logic;

		Rs11_mux_ctrl, Rs12_mux_ctrl, Rs21_mux_ctrl, Rs22_mux_ctrl : out std_logic_Vector(1 downto 0);
		Rs11_valid, Rs12_valid, Rs21_valid, Rs22_valid : out std_logic	

	);

end dispatcher2;

architecture behave of dispatcher2 is


begin
	
	process(busy11, busy12, busy21, busy22, valid11, valid12, valid21, valid22, tag11, tag12, tag21, tag22, broadcast_tag, broadcast_valid )
		variable vRs11_mux_ctrl, vRs12_mux_ctrl, vRs21_mux_ctrl, vRs22_mux_ctrl : std_logic_vector(1 downto 0);
	begin
		vRs11_mux_ctrl := "00"; vRs12_mux_ctrl := "00"; vRs21_mux_ctrl := "00"; vRs22_mux_ctrl := "00";
		
		if(busy11 = '0') then
			vRs11_mux_ctrl := "00";
		elsif(valid11 = '1') then
			vRs11_mux_ctrl := "10";
		elsif(valid11 = '0' and tag11 = broadcast_tag and broadcast_valid = '1') then
			vRs11_mux_ctrl := "11";
		elsif(valid11 = '0') then
			vRs11_mux_ctrl := "01";
		end if;

		if(busy12 = '0') then
			vRs12_mux_ctrl := "00";
		elsif(valid12 = '1') then
			vRs12_mux_ctrl := "10";
		elsif(valid12 = '0' and tag12 = broadcast_tag and broadcast_valid = '1') then
			vRs12_mux_ctrl := "11";
		elsif(valid12 = '0') then
			vRs12_mux_ctrl := "01";
		end if;

		if(busy21 = '0') then
			vRs21_mux_ctrl := "00";
		elsif(valid21 = '1') then
			vRs21_mux_ctrl := "10";
		elsif(valid21 = '0' and tag21 = broadcast_tag and broadcast_valid = '1') then
			vRs21_mux_ctrl := "11";
		elsif(valid21 = '0') then
			vRs21_mux_ctrl := "01";
		end if;

		if(busy22 = '0') then
			vRs22_mux_ctrl := "00";
		elsif(valid22 = '1') then
			vRs22_mux_ctrl := "10";
		elsif(valid22 = '0' and tag22 = broadcast_tag and broadcast_valid = '1') then
			vRs22_mux_ctrl := "11";
		elsif(valid22 = '0') then
			vRs22_mux_ctrl := "01";
		end if;

		Rs11_mux_ctrl <= vRs11_mux_ctrl;
		Rs12_mux_ctrl <= vRs12_mux_ctrl;
		Rs21_mux_ctrl <= vRs21_mux_ctrl;
		Rs22_mux_ctrl <= vRs22_mux_ctrl;
		
		Rs11_valid <= (not vRs11_mux_ctrl(1)) and vRs11_mux_ctrl(0);
		Rs12_valid <= (not vRs12_mux_ctrl(1)) and vRs12_mux_ctrl(0);	
		Rs21_valid <= (not vRs21_mux_ctrl(1)) and vRs21_mux_ctrl(0);
		Rs22_valid <= (not vRs22_mux_ctrl(1)) and vRs22_mux_ctrl(0);	


	end process;

end behave;
