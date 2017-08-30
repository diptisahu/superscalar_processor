library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package Microprocessor_project is
    type arr1 is array(natural range <>) of std_logic_vector(15 downto 0);

    --ALU for add, nand
    --aluOP=0 means add, =1 means nand
    component alu is
        port(
            IP1, IP2 : in std_logic_vector(15 downto 0);
            OP : out std_logic_vector(15 downto 0);
            aluOP : in std_logic;
            C: out std_logic);
    end component;
    
    --Memory for data
    --A - address
    --Din - data to write
    --Dout - read data
    --To read - address in A, memR high. Dout will have data
    --To write - address in A, data in Din, memWR high
    component dataMemory is
        port(
            A, Din : in std_logic_vector(15 downto 0);
            Dout : out std_logic_vector(15 downto 0);
            memWR : in std_logic;
            clk : in std_logic);
    end component;

    --Memory for instruction
    --A - address
    --Dout - read data
    --To read - address in A, memR high. Dout will have data
    --To write - address in A, data in Din, memWR high
    component instrMemory is
        port(
            A,B : in std_logic_vector(15 downto 0);
	    Dout1,Dout2 : out std_logic_vector(15 downto 0);
	    memWR : in std_logic;
	    clk : in std_logic);
    end component;
    
    --Generic register
    component dataRegister is
        generic (data_width:integer);
        port(
            Din : in std_logic_vector(data_width-1 downto 0);
            Dout : out std_logic_vector(data_width-1 downto 0);
            clk, enable : in std_logic);
    end component;

    --Register File
    component RF is
        port(RF_write, PC_write: in std_logic;
            A1,A2,A3: in std_logic_vector (2 downto 0);
            D3,PC_in: in std_logic_vector(15 downto 0);
            D1,D2,PC_out: out std_logic_vector(15 downto 0);
            R0,R1,R2,R3,R4,R5,R6,R7: out std_logic_vector(15 downto 0);
            rst, clk: in std_logic);
    end component;

    --Comparator
    component Comparator is
        port(
		    Comp_D1,Comp_D2: in std_logic_vector(15 downto 0);
			Comp_out: out std_logic);
    end component;

    --sign extender 6 to 16
    component sign_extender_6to16 is
    	port(
	    x: in std_logic_vector(5 downto 0);
	    y: out std_logic_vector( 15 downto 0)
    	);
    end component;

    --sign extender 9 to 16
    component sign_extender_9to16 is
        port(
	    x: in std_logic_vector(8 downto 0);
	    y: out std_logic_vector( 15 downto 0)
        );
    end component;

    component InstructionDecoder is
    	port(instr: in std_logic_vector(15 downto 0);
             rs1,rs2,rd: out std_logic_vector(2 downto 0);
             branch, decode_br_loc, regread_br_loc: out std_logic;
             branch_state: out std_logic_vector (1 downto 0);
             mem_read, mem_write, rf_write: out std_logic);
    end component;

    component ROB is
	port(
		instr1,pc1: in std_logic_vector(15 downto 0);
		instr1_rs1,instr1_rs2,instr1_rd: in std_logic_vector(2 downto 0);
		instr1_branch,instr1_decode_br_loc,instr1_regread_br_loc: in std_logic;
		instr1_branch_state: in std_logic_vector (1 downto 0);
		instr1_mem_read,instr1_mem_write,instr1_rf_write: in std_logic;
		instr2,pc2: in std_logic_vector(15 downto 0);
		instr2_rs1,instr2_rs2,instr2_rd: in std_logic_vector(2 downto 0);
		instr2_branch,instr2_decode_br_loc,instr2_regread_br_loc: in std_logic;
		instr2_branch_state: in std_logic_vector (1 downto 0);
		instr2_mem_read,instr2_mem_write,instr2_rf_write: in std_logic;
		clk,reset: in std_logic;
		stall1,stall2: out std_logic);
    end component;

end package;
