library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

package Microprocessor_project is
    type arr1 is array(natural range <>) of std_logic_vector(15 downto 0);

    --ALU for add, nand
    component ALU is
        port(
            IP1, IP2 : in std_logic_vector(15 downto 0);
            OP : out std_logic_vector(15 downto 0);
            aluOP : in std_logic;
	    C,Z : out std_logic);
    end component;
    
    --Memory for data
    component dataMemory is
        port(
            A,B,Din1,Din2 : in std_logic_vector(15 downto 0);
            Dout1,Dout2 : out std_logic_vector(15 downto 0);
            memWR1,memWR2 : in std_logic;
            clk : in std_logic);
    end component;

    --Memory for instruction
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
    component regFile is
        port(
	    a1, a2, a3, a4, a5, a6 : in std_logic_vector(2 downto 0);
            d5, d6, pci : in std_logic_vector(15 downto 0);
            d1, d2, d3, d4 : out std_logic_vector(15 downto 0);
            regWr1, regWr2, pcWr : in std_logic;
            clk, reset : in std_logic);
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

    component ReserveStation is
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
		instr1_out,instr2_out: out std_logic_vector(50 downto 0);
		stall1,stall2: out std_logic);
    end component;
 
    component ROB is
	port(
		instr1,instr2 : in std_logic_vector(50 downto 0);
		instr1_d1,instr1_d2,instr2_d1,instr2_d2 : in std_logic_vector(15 downto 0);
		instr1_d, instr2_d, Dout1, Dout2 : in std_logic_vector(15 downto 0);
		clk,reset: in std_logic;
		rob_instr1, rob_instr2 : out std_logic_vector(114 downto 0);
		pci : out std_logic_vector(15 downto 0);
		pcWr : out std_logic;
        	stall1, stall2 : out std_logic);
    end component;

end package;
