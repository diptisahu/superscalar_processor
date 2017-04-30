library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Microprocessor_project.all;

--there is mux before the pipeline at C2, Z2, Rs21, and Rs22.
--if the previous instruction writes to C, Z or Rs21 or Rs22; corresponding mux control will get high. Control signal given by dispatcher1.
--the first entry (0) to the mux is from the ARF. The second one is the new tag coming as free_TagC1 or free_tagZ1 or free_tag1.
--this is because for the second instruction, the ARF doesnt has the correct tag.

--NO STALL ASSUMPTION MADE. TO HANDLE STALL, LOOK FOR SOME OTHER MECHANISM OR MAKE SUITABLE CHANGES (like using tag_valid bits coming frm the RRF).

entity dispatcher1 is

port(	Rd1, Rd2: in std_logic_vector(2 downto 0);
		Rs21, Rs22: in std_logic_vector(2 downto 0);
		RF1_en, RF2_en : in std_logic;		
		free_tag1_in, free_tag2_in : in std_logic_vector(3 downto 0);	--free tags given by RRF to assign
		free1_valid, free2_valid: in std_logic;
		
		--address to write is directly taken from the pipeline
		tag1_out, tag2_out : out std_logic_vector(3 downto 0);
		tag1_write_en, tag2_write_en : out std_logic; 
		--busy is set whenever write occurs (implemented as part of ARF)		
			
		Rs21_tag_mux_ctrl, Rs22_tag_mux_ctrl, busy21, busy22: out std_logic;
		Rs21_tag, Rs22_tag: out std_logic_vector(3 downto 0);

		free_tag1_used, free_tag2_used : out std_logic;

		C1_en, Z1_en, C2_en, Z2_en : in std_logic;
		C2_dep, Z2_dep : in std_logic; --not used. to be taken care by scheduler.
		free_tagC1_in, free_tagC2_in, free_tagZ1_in, free_tagZ2_in : in std_logic_vector(3 downto 0);
		tagZ1_valid, tagZ2_valid, tagC1_valid, tagC2_valid : in std_logic;
		
		--address to write is directly taken from the pipeline
		tagC_out, tagZ_out : out std_logic_vector(3 downto 0);
		tagC_write_en, tagZ_write_en : out std_logic; 

		--busy is set whenever write occurs (implemented as part of ARF)

		C2_tag_mux_ctrl, Z2_tag_mux_ctrl, busyC2, busyZ2: out std_logic;
		C2_tag, Z2_tag: out std_logic_vector(3 downto 0);

		tagC1_used, tagZ1_used, tagC2_used, tagZ2_used : out std_logic
	
	);

end dispatcher1;

architecture behave of dispatcher1 is


begin
	
	process(Rd1, Rs21, Rs22, RF1_en, RF2_en, free_tag1_in, free_tag2_in, free1_valid, free2_valid)
		variable vtag1_write_en, vtag2_write_en : std_logic;
		variable vRs21_tag_mux_ctrl, vRs22_tag_mux_ctrl : std_logic;
	begin
		vtag1_write_en := '0'; vtag2_write_en := '0';
		vRs21_tag_mux_ctrl := '0'; vRs22_tag_mux_ctrl := '0';

		if(RF1_en = '1' and free1_valid = '1') then
			vtag1_write_en := '1';
		end if;

		if(RF2_en = '1' and free2_valid = '1') then
			vtag2_write_en := '1';	
		end if;
		
		if(Rs21 = Rd1) then		
			vRs21_tag_mux_ctrl := '1';
		end if;

		if(Rs22 = Rd1) then		
			vRs22_tag_mux_ctrl := '1';
		end if;

		tag1_write_en <= vtag1_write_en;
		free_tag1_used <= vtag1_write_en;
		tag2_write_en <= vtag2_write_en;
		free_tag2_used <= vtag2_write_en;
		Rs21_tag_mux_ctrl <= vRs21_tag_mux_ctrl;
		Rs22_tag_mux_ctrl <= vRs22_tag_mux_ctrl;
		busy21 <= vRs21_tag_mux_ctrl;
		busy22 <= vRs22_tag_mux_ctrl;

	end process;

	tag1_out <= free_tag1_in; tag2_out <= free_tag2_in;
	Rs21_tag <= free_tag1_in; Rs22_tag <= free_tag1_in;


--now for the C and Z flags

	tagC1_used <= C1_en or C2_en;
	tagZ1_used <= Z1_en or Z2_en;
	tagC2_used <= C1_en and C2_en;
	tagZ2_used <= Z1_en and Z2_en;

	tagC_write_en <= C1_en or C2_en;
	tagZ_write_en <= Z1_en or Z2_en;		

	process(C1_en, C2_en, Z1_en, Z2_en, tagC1_valid, tagZ1_valid)
		variable vtagC_out, vtagZ_out : std_logic_vector(3 downto 0);
		variable vtagC2_mux_ctrl, vtagZ2_mux_ctrl : std_logic;
	begin
		vtagC_out := "0000"; vtagZ_out := "0000";
		vtagC2_mux_ctrl := '0'; vtagZ2_mux_ctrl := '0';
		if(C1_en = '1' and tagC1_valid = '1') then
			vtagC_out := free_tagC1_in;
		end if;
		if(C2_en = '1' and tagC2_valid = '1') then
			vtagC_out := free_tagC2_in;
		elsif(C2_en = '1' and C1_en = '0' and tagC1_valid = '1') then
			vtagC_out := free_tagC1_in;
		end if;
		
		if(Z1_en = '1' and tagZ1_valid = '1') then
			vtagZ_out := free_tagZ1_in;
		end if;
		if(Z2_en = '1' and tagZ2_valid = '1') then
			vtagZ_out := free_tagZ2_in;
		elsif(Z2_en = '1' and Z1_en = '0' and tagZ1_valid = '1') then
			vtagZ_out := free_tagZ1_in;
		end if;
		
		if(C1_en = '1') then
			vtagC2_mux_ctrl := '1';
		end if;
		if(Z1_en = '1') then
			vtagZ2_mux_ctrl := '1';
		end if;

	tagC_out <= vtagC_out; tagZ_out <= vtagZ_out;
	C2_tag_mux_ctrl <= vtagC2_mux_ctrl; Z2_tag_mux_ctrl <= vtagZ2_mux_ctrl;
	busyC2 <= vtagC2_mux_ctrl; busyZ2 <= vtagZ2_mux_ctrl;
	end process;

end behave;














