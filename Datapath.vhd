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

    --Reservation Station
    signal stall1,stall2: std_logic;
    signal instr1_out,instr2_out: std_logic_vector(50 downto 0);

    --Register File
    signal a1, a2, a3, a4, a5, a6 : std_logic_vector(2 downto 0);
    signal d5, d6, pci : std_logic_vector(15 downto 0);
    signal d1, d2, d3, d4 : std_logic_vector(15 downto 0);
    signal regWr1, regWr2, pcWr : std_logic;

    --register Pipeline2
    signal p21_instr_in,p21_instr_out,p22_instr_in,p22_instr_out : std_logic_vector(50 downto 0);
    signal p21_instr_d1_in,p21_instr_d2_in,p22_instr_d1_in,p22_instr_d2_in : std_logic_vector(15 downto 0);
    signal p21_instr_d1_out,p21_instr_d2_out,p22_instr_d1_out,p22_instr_d2_out : std_logic_vector(15 downto 0);
    signal p21_enable, p22_enable : std_logic;

    --ALU
    signal alux1, aluy1, alu_out1, alux2, aluy2, alu_out2 : std_logic_vector(15 downto 0);
    signal aluop1, aluc1, aluz1, aluop2, aluc2, aluz2 : std_logic;

    --register Pipeline3
    signal p31_instr_in,p31_instr_out,p32_instr_in,p32_instr_out : std_logic_vector(50 downto 0);
    signal p31_instr_d1_in,p31_instr_d2_in,p32_instr_d1_in,p32_instr_d2_in : std_logic_vector(15 downto 0);
    signal p31_instr_d1_out,p31_instr_d2_out,p32_instr_d1_out,p32_instr_d2_out : std_logic_vector(15 downto 0);
    signal p31_instr_d_in,p31_instr_d_out,p32_instr_d_in,p32_instr_d_out : std_logic_vector(15 downto 0);
    signal p31_enable, p32_enable : std_logic;

    --data Memory
    signal A, B, Din1, Din2, Dout1, Dout2 : std_logic_vector(15 downto 0);
    signal memWR1, memWR2 : std_logic;

    --ROB
    signal rob_instr1, rob_instr2 : std_logic_vector(114 downto 0);
    signal rob_stall1, rob_stall2 : std_logic;

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

    --Reservation Station
    reservationStation: ReserveStation
	port map(p11_instr_out, p11_pc_out, id1_rs1, id1_rs2, id1_rd, id1_branch, id1_dec_brloc, id1_rr_brloc,
                id1_br_st, id1_mr, id1_mw, id1_rfw, p12_instr_out, p12_pc_out, id2_rs1, id2_rs2, id2_rd, id2_branch,
                id2_dec_brloc, id2_rr_brloc, id2_br_st, id2_mr, id2_mw, id2_rfw, clk, rst, instr1_out,
		instr2_out, stall1, stall2);

    --Register File                          (Inputs later)
    a1 <= instr1_out(34 downto 32);
    a2 <= instr1_out(37 downto 35);
    a3 <= instr2_out(34 downto 32);
    a4 <= instr2_out(37 downto 35);
    a5 <= rob_instr1(40 downto 38);
    a6 <= rob_instr2(40 downto 38);
    d5 <= rob_instr1(114 downto 99);
    d6 <= rob_instr2(114 downto 99);
    regWr1 <= rob_instr1(48);
    regWr2 <= rob_instr2(48);
    RF: regfile
	port map(a1, a2, a3, a4, a5, a6, d5, d6, pci, d1, d2, d3, d4, regWr1, regWr2, pcWr, clk, rst);

    --Pipeline Register P2 
    p21_instr_in <= instr1_out;
    p21_instr: dataRegister generic map (data_width => 51)
	port map (Din => p21_instr_in, Dout => p21_instr_out, enable => p21_enable, clk => clk);
    p22_instr_in <= instr2_out;
    p22_instr: dataRegister generic map (data_width => 51)
	port map (Din => p22_instr_in, Dout => p22_instr_out, enable => p22_enable, clk => clk);
    p21_instr_d1_in <= d1;
    p21_instr_d1: dataRegister generic map (data_width => 16)
	port map (Din => p21_instr_d1_in, Dout => p21_instr_d1_out, enable => p21_enable, clk => clk);
    p21_instr_d2_in <= d2;
    p21_instr_d2: dataRegister generic map (data_width => 16)
	port map (Din => p21_instr_d2_in, Dout => p21_instr_d2_out, enable => p21_enable, clk => clk);
    p22_instr_d1_in <= d3;
    p22_instr_d1: dataRegister generic map (data_width => 16)
	port map (Din => p22_instr_d1_in, Dout => p22_instr_d1_out, enable => p22_enable, clk => clk);
    p22_instr_d2_in <= d4;
    p22_instr_d2: dataRegister generic map (data_width => 16)
	port map (Din => p22_instr_d2_in, Dout => p22_instr_d2_out, enable => p22_enable, clk => clk);
 
    --ALU1
    alux1 <= p21_instr_d1_out;
    aluy1 <= p21_instr_d2_out;
    aluop1 <= p21_instr_out(13);
    exec1_alu: ALU port map(alux1, aluy1, alu_out1, aluop1, aluc1, aluz1);

    --exexse2: SixBitSignExtender port map(p3_instr_out(5 downto 0), alu_ext);

    --ALU2
    alux2 <= p22_instr_d1_out;
    aluy2 <= p22_instr_d2_out;
    aluop2 <= p22_instr_out(13);
    exec2_alu: ALU port map(alux2, aluy2, alu_out2, aluop2, aluc2, aluz2);

    --exexse2: SixBitSignExtender port map(p3_instr_out(5 downto 0), alu_ext);

    --Pipeline Register P3
    p31_instr_in <= p21_instr_out;
    p31_instr: dataRegister generic map (data_width => 51)
	port map (Din => p31_instr_in, Dout => p31_instr_out, enable => p31_enable, clk => clk);
    p32_instr_in <= p22_instr_out;
    p32_instr: dataRegister generic map (data_width => 51)
	port map (Din => p32_instr_in, Dout => p32_instr_out, enable => p32_enable, clk => clk);
    p31_instr_d1_in <= p21_instr_d1_out;
    p31_instr_d1: dataRegister generic map (data_width => 16)
	port map (Din => p31_instr_d1_in, Dout => p31_instr_d1_out, enable => p31_enable, clk => clk);
    p31_instr_d2_in <= p21_instr_d2_out;
    p31_instr_d2: dataRegister generic map (data_width => 16)
	port map (Din => p31_instr_d2_in, Dout => p31_instr_d2_out, enable => p31_enable, clk => clk);
    p32_instr_d1_in <= p22_instr_d1_out;
    p32_instr_d1: dataRegister generic map (data_width => 16)
	port map (Din => p32_instr_d1_in, Dout => p32_instr_d1_out, enable => p32_enable, clk => clk);
    p32_instr_d2_in <= p22_instr_d2_out;
    p32_instr_d2: dataRegister generic map (data_width => 16)
	port map (Din => p32_instr_d2_in, Dout => p32_instr_d2_out, enable => p32_enable, clk => clk);
    p31_instr_d_in <= alu_out1;
    p31_instr_d: dataRegister generic map (data_width => 16)
	port map (Din => p31_instr_d_in, Dout => p31_instr_d_out, enable => p31_enable, clk => clk);
    p32_instr_d_in <= alu_out2;
    p32_instr_d: dataRegister generic map (data_width => 16)
	port map (Din => p32_instr_d_in, Dout => p32_instr_d_out, enable => p32_enable, clk => clk);
   
    --Data Memory
    A <= p31_instr_d_out;
    Din1 <= p31_instr_d1_out;
    B <= p32_instr_d_out;
    Din2 <= p32_instr_d1_out;
    memWR1 <= '1' when ((p31_instr_out(15 downto 12)="0101")or(p31_instr_out(15 downto 12)="1000")or(p31_instr_out(15 downto 12)="1001")) else '0';
    memWR2 <= '1' when ((p32_instr_out(15 downto 12)="0101")or(p32_instr_out(15 downto 12)="1000")or(p32_instr_out(15 downto 12)="1001")) else '0';
    dataMem: dataMemory
	port map (A, B, Din1, Din2, Dout1, Dout2, memWR1, memWR2, clk);

    --ROB
    reorderbuffer: ROB
	port map (p31_instr_out, p32_instr_out, p31_instr_d1_out, p31_instr_d2_out, p32_instr_d1_out,
	p32_instr_d2_out, p31_instr_d_out, p32_instr_d_out, Dout1, Dout2, clk, rst, rob_instr1, rob_instr2,
        pci, pcWr, rob_stall1, rob_stall2);

end Mixed;
