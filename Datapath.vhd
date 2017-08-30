library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
library work;
use work.Microprocessor_project.all;

-- Datapath upto ROB without branch predictor
entity Datapath is
    port(
        R0,R1,R2,R3,R4,R5,R6,R7: out std_logic_vector(15 downto 0);
        clk,rst: in std_logic);
end entity;

architecture Mixed of Datapath is
    
    --PC
    signal pc_in,pc1_out,pc_alu_in,pc_alu_out,pc2_in,pc2_out: std_logic_vector(15 downto 0);
 
    --Instruction Memory
    signal Instr_Mem_A,Instr_Mem_B,Instr1_Mem_out,Instr2_Mem_out: std_logic_vector(15 downto 0);

    --register Pipeline1
    signal p11_instr_out,p11_instr_in,p11_pc_out,p11_pc_in,p12_instr_out,p12_instr_in,p12_pc_out,p12_pc_in: std_logic_vector(15 downto 0);
    signal p11_enable,p11_stall_out,p12_enable,p12_stall_out: std_logic;

    --Instruction Decoder
    signal id1_in,id2_in: std_logic_vector(15 downto 0);
    signal id1_mdr,id1_rs1,id1_rs2,id1_rd,id2_mdr,id2_rs1,id2_rs2,id2_rd: std_logic_vector (2 downto 0);
    signal id1_branch,id1_dec_brloc,id1_rr_brloc,id1_mr,id1_mw,id1_rfw: std_logic;
    signal id2_branch,id2_dec_brloc,id2_rr_brloc,id2_mr,id2_mw,id2_rfw: std_logic;
    signal id1_br_st,id2_br_st: std_logic_vector (1 downto 0);

    --ROB
    signal stall1,stall2: std_logic;

    constant one: std_logic_vector(15 downto 0) := "0000000000000001";
    constant zero: std_logic_vector(15 downto 0) := "0000000000000000";
    constant two: std_logic_vector(15 downto 0) := "0000000000000010";

begin

    --PC
    pc_in <= pc_alu_out;    
    pc: dataRegister generic map (data_width => 16)
        port map (Din => pc_in, Dout => pc1_out, enable => '1', clk => clk);

    --PC Incrementer1
    pc2_in <= pc1_out;
    incrementer1: ALU
    	port map (IP1=>pc2_in,IP2=>one,OP=>pc2_out,aluOP=>'0');

    --PC Incrementer2
    pc_alu_in <= pc1_out;
    incrementer2: ALU
    	port map (IP1=>pc_alu_in,IP2=>two,OP=>pc_alu_out,aluOP=>'0');

    --Instruction Memory
    Instr_Mem_A <= pc1_out;
    Instr_Mem_B <= pc2_out;
    instr_mem: instrMemory
    	port map(Instr_Mem_A,Instr_Mem_B,Instr1_Mem_out,Instr2_Mem_out,'0',clk);

    --Pipeline Register P1
    p11_instr_in <= Instr1_Mem_out;    
    p11_instr: dataRegister generic map (data_width => 16)
        port map (Din => p11_instr_in, Dout => p11_instr_out, enable => p11_enable, clk => clk);
    p11_pc_in <= pc1_out;    
    p11_pc: dataRegister generic map (data_width => 16)
        port map (Din => p11_pc_in, Dout => p11_pc_out, enable => p11_enable, clk => clk);

    p12_instr_in <= Instr2_Mem_out;    
    p12_instr: dataRegister generic map (data_width => 16)
        port map (Din => p12_instr_in, Dout => p12_instr_out, enable => p12_enable, clk => clk);
    p12_pc_in <= pc2_out;    
    p12_pc: dataRegister generic map (data_width => 16)
        port map (Din => p12_pc_in, Dout => p12_pc_out, enable => p12_enable, clk => clk);

    --Instruction Decoder
    id1_in <= p11_instr_out;
    id1: InstructionDecoder
        port map(id1_in, id1_rs1, id1_rs2, id1_rd, id1_branch, id1_dec_brloc, id1_rr_brloc,
                id1_br_st, id1_mr, id1_mw, id1_rfw);    

    id2_in <= p12_instr_out;
    id2: InstructionDecoder
        port map(id2_in, id2_rs1, id2_rs2, id2_rd, id2_branch, id2_dec_brloc, id2_rr_brloc,
                id2_br_st, id2_mr, id2_mw, id2_rfw);

    --ROB
    reorderbuffer: ROB
	port map(p11_instr_out, p11_pc_out, id1_rs1, id1_rs2, id1_rd, id1_branch, id1_dec_brloc, id1_rr_brloc,
                id1_br_st, id1_mr, id1_mw, id1_rfw, p12_instr_out, p12_pc_out, id2_rs1, id2_rs2, id2_rd, id2_branch,
                id2_dec_brloc, id2_rr_brloc, id2_br_st, id2_mr, id2_mw, id2_rfw, clk, rst, stall1, stall2);
    
end Mixed;
