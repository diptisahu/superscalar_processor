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
		Rs11_valid, Rs12_valid, Rs21_valid, Rs22_valid : out std_logic;	

		busyC1, busyC2, busyZ1, busyZ2 : in std_logic; 
		validC1, validC2, validZ1, validZ2 : in std_logic;
		tagC1, tagC2, tagZ1, tagZ2 : in std_logic_Vector(3 downto 0);
		broadcast_tag_C, broadcast_tag_Z : in std_logic_vector(3 downto 0);
		broadcast_C_valid, broadcast_Z_valid : in std_logic;

		C1_mux_ctrl, C2_mux_ctrl, Z1_mux_ctrl, Z2_mux_ctrl : out std_logic_vector(1 downto 0);
		C1_valid, C2_valid, Z1_valid, Z2_valid : out std_logic	

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

	process(busyC1, busyC2, busyZ1, busyZ2, validC1, validC2, validZ1, validZ2, tagC1, tagC2, tagZ1, tagZ2, 
										broadcast_tag_C, broadcast_tag_Z, broadcast_C_valid, broadcast_Z_valid )
		variable vC1_mux_ctrl, vC2_mux_ctrl, vZ1_mux_ctrl, vZ2_mux_ctrl : std_logic_vector(1 downto 0);
	begin
		vC1_mux_ctrl := "00"; vC2_mux_ctrl := "00"; vZ1_mux_ctrl := "00"; vZ2_mux_ctrl := "00";
		
		if(busyC1 = '0') then
			vC1_mux_ctrl := "00";
		elsif(validC1 = '1') then
			vC1_mux_ctrl := "10";
		elsif(validC1 = '0' and tagC1 = broadcast_tag_C and broadcast_C_valid = '1') then
			vC1_mux_ctrl := "11";
		elsif(validC1 = '0') then
			vC1_mux_ctrl := "01";
		end if;

		if(busyC2 = '0') then
			vC2_mux_ctrl := "00";
		elsif(validC2 = '1') then
			vC2_mux_ctrl := "10";
		elsif(validC2 = '0' and tagC2 = broadcast_tag_C and broadcast_C_valid = '1') then
			vC2_mux_ctrl := "11";
		elsif(validC2 = '0') then
			vC2_mux_ctrl := "01";
		end if;

		if(busyZ1 = '0') then
			vZ1_mux_ctrl := "00";
		elsif(validZ1 = '1') then
			vZ1_mux_ctrl := "10";
		elsif(validZ1 = '0' and tagZ1 = broadcast_tag_Z and broadcast_Z_valid = '1') then
			vZ1_mux_ctrl := "11";
		elsif(validZ1 = '0') then
			vZ1_mux_ctrl := "01";
		end if;

		if(busyZ2 = '0') then
			vZ2_mux_ctrl := "00";
		elsif(validZ2 = '1') then
			vZ2_mux_ctrl := "10";
		elsif(validZ2 = '0' and tagZ2 = broadcast_tag_Z and broadcast_Z_valid = '1') then
			vZ2_mux_ctrl := "11";
		elsif(validZ2 = '0') then
			vZ2_mux_ctrl := "01";
		end if;

		C1_mux_ctrl <= vC1_mux_ctrl;
		C2_mux_ctrl <= vC2_mux_ctrl;
		Z1_mux_ctrl <= vZ1_mux_ctrl;
		Z2_mux_ctrl <= vZ2_mux_ctrl;
		
		C1_valid <= (not vC1_mux_ctrl(1)) and vC1_mux_ctrl(0);
		C2_valid <= (not vC2_mux_ctrl(1)) and vC2_mux_ctrl(0);	
		Z1_valid <= (not vZ1_mux_ctrl(1)) and vZ1_mux_ctrl(0);
		Z2_valid <= (not vZ2_mux_ctrl(1)) and vZ2_mux_ctrl(0);	

	end process;

end behave;
