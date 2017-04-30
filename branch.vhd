library ieee;
use ieee.std_logic_1164.all;

entity BranchPredictor is
    port(PC_fetch1, PC_fetch2, PC_execute1, PC_execute2: in std_logic_vector(15 downto 0);
        fetch_valid1, fetch_valid2: out std_logic;
        fetch_target1, fetch_target2: out std_logic_vector(15 downto 0);
        exec_target1, exec_target2: in std_logic_vector(15 downto 0);
        taken1, taken2, write1, write2: in std_logic;
        clk, rst: in std_logic
        );
end entity;

architecture Behave of BranchPredictor is
type arr32 is array (31 downto 0) of std_logic_vector (15 downto 0);
signal PC, target: arr32 := (others => (others => '0'));
signal history, valid: std_logic_vector (31 downto 0) := (others => '0');

begin

process(PC_fetch1, PC_fetch2, clk, rst, PC, target, history, valid)
    variable x_fetch_valid1, x_fetch_valid2: std_logic;
    variable x_fetch_target1, x_fetch_target2: std_logic_vector(15 downto 0);
begin

    x_fetch_target1 := (others => '0'); x_fetch_target2 := (others => '0');
    x_fetch_valid1 := '0'; x_fetch_valid2 := '0';

    if(rst = '0') then
        for i in 0 to 31 loop
            if(valid(i) = '1') then
                if(PC(i) = PC_fetch1) then
                    x_fetch_valid1 := '1';
                    x_fetch_target1 := target(i);
                end if;

                if(PC(i) = PC_fetch2) then
                    x_fetch_valid2 := '1';
                    x_fetch_target2 := target(i);
                end if;
            end if;
        end loop;
    end if;
    
    fetch_target1 <= x_fetch_target1; fetch_target2 <= x_fetch_target2;
    fetch_valid1 <= x_fetch_valid1; fetch_valid2 <= x_fetch_valid2;
end process;

process(PC_execute1, PC_execute2, exec_target1, exec_target2, write1, write2, clk, rst)
    variable check: std_logic;
begin
    if(clk'event and (clk  = '0')) then
        if(rst = '0') then
            if(write1 = '1') then
                check := '0';
                for i in 0 to 31 loop
                    if(PC(i) = PC_execute1) then
                        if (valid(i) = '1') then
                            target(i) <= exec_target1;
                            history(i) <= taken1;
                            check := '1';
                            exit;
                        end if;
                    end if;
                end loop;

                if (check = '0') then
                    for i in 0 to 31 loop
                        if(valid(i) = '0') then
                            valid(i) <= '1';
                            PC(i) <= PC_execute1;
                            target(i) <= exec_target1;
                            history(i) <= taken1;
                            exit;
                        end if;
                    end loop;
                end if;
            end if;


            if(write2 = '1') then
                check := '0';
                for i in 0 to 31 loop
                    if(PC(i) = PC_execute2) then
                        if (valid(i) = '1') then
                            target(i) <= exec_target2;
                            history(i) <= taken2;
                            check := '1';
                            exit;
                        end if;
                    end if;
                end loop;

                if (check = '0') then
                    for i in 0 to 31 loop
                        if(valid(i) = '0') then
                            valid(i) <= '1';
                            PC(i) <= PC_execute2;
                            target(i) <= exec_target2;
                            history(i) <= taken2;
                            exit;
                        end if;
                    end loop;
                end if;
            end if;
        else
            PC <= (others => (others => '0'));
            target <= (others => (others => '0'));
            history <= (others => '0');
            valid <=  (others => '0');
        end if;
    end if;

end process;

end Behave;
