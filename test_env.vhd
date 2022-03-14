----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 

-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;

component SSD is
    Port( Digit: in std_logic_vector(15 downto 0);
      cat: out std_logic_vector(6 downto 0);
      an: out std_logic_vector(3 downto 0);
      clk: in std_logic);
end component;

component RF is
 Port( RA1: in std_logic_vector(3 downto 0);
       RA2: in std_logic_vector(3 downto 0);
       WD: in std_logic_vector(15 downto 0);
       WA: in  std_logic_vector(3 downto 0);
       RegWr: in std_logic;
       clk: in std_logic;
       RD1: out std_logic_vector(15 downto 0);
       RD2: out std_logic_vector(15 downto 0));
end component;

component RAM is
    Port(MemWr: in std_logic;
     Adress: in std_logic_vector(15 downto 0);
     RD: out std_logic_vector(15 downto 0);
     WD: in std_logic_vector(15 downto 0);
     clk:in std_logic;
     en: in std_logic);
end component;

component IFetch is
      Port ( rst: in std_logic;
        en: in std_logic;
        clk: in std_logic;
        branch: in std_logic_vector(15 downto 0);
        jumpAddr: in std_logic_vector(15 downto 0);
        jump: in std_logic;
        PCSrc: in std_logic;
        Instruction: out std_logic_vector(15 downto 0);
        NextAddr: out std_logic_vector(15 downto 0));
end component;

component IDec is
 Port ( clk: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        iesireMux: in std_logic_vector(2 downto 0);
        WD: in std_logic_vector(15 downto 0);
        RegWrite: in std_logic;
        en: in std_logic;
        RegDst: in std_logic;
        ExtOp: in std_logic; 
        Rs: out std_logic_vector(15 downto 0);
        Rt: out std_logic_vector(15 downto 0);
        Ext_imm: out std_logic_vector(15 downto 0);
        func: out std_logic_vector(2 downto 0);
        sa: out std_logic);
end component;

component IExe is
  Port ( next_addr: in std_logic_vector(15 downto 0);
         RD1: in std_logic_vector(15 downto 0);
         RD2: in std_logic_vector(15 downto 0);
         Imm_ext: in std_logic_vector(15 downto 0);
         func: in std_logic_vector(2 downto 0);
         sa: in std_logic;
         ALUSrc: in std_logic;
         ALUOp: in std_logic_vector(2 downto 0);
         BranchAdress: out std_logic_vector(15 downto 0);
         ALURes: out std_logic_vector(15 downto 0);
         Zero: out std_logic);
end component;

signal en1: std_logic; -- enable pentru numarator
signal en2: std_logic; --enable pentru blocul de registrii
signal catod: std_logic_vector(6 downto 0);
signal anod: std_logic_vector(3 downto 0);

signal catod1: std_logic_vector(6 downto 0);
signal anod1: std_logic_vector(3 downto 0);

signal cnt: std_logic_vector(3 downto 0):="0000"; --counter pe 4 biti
signal rez: std_logic_vector(15 downto 0);--iesire ALU / iesire dupa adunare a RD1 si RD2 din blocul de registri

signal counter8: std_logic_vector(7 downto 0):="00000000";--counter 8 biti

signal WDo: std_logic_vector(15 downto 0);--intrare bloc reg si RAM

signal instr: std_logic_vector(15 downto 0);
signal addr: std_logic_vector(15 downto 0);
signal iesire: std_logic_vector(15 downto 0);
signal br: std_logic_vector(15 downto 0):=x"0000";
signal jr: std_logic_vector(15 downto 0):=x"0010";

--semnale de control
signal extop: std_logic;
signal RegWr: std_logic;
signal RegDst: std_logic;
signal AluSrc: std_logic;
signal AluCtrl: std_logic;
signal MemWr: std_logic;
signal MemtoReg: std_logic;
signal branch: std_logic;
signal jump: std_logic;
signal opcode: std_logic_vector(2 downto 0);
signal AluOp: std_logic_vector(2 downto 0);
signal PCSrc: std_logic;

--semnale de iesire din ID
signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal extins_imm: std_logic_vector(15 downto 0);
signal functie: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal WD: std_logic_vector(15 downto 0);

--semnale iesire /intrare IE
signal ALURes: std_logic_vector(15 downto 0);
signal Zero: std_logic;
signal extinsimediat: std_logic_vector(15 downto 0);
signal functieo: std_logic_vector(2 downto 0);
signal sao: std_logic;
signal ALUReso: std_logic_vector(15 downto 0);
signal instro: std_logic_vector(15 downto 0);
signal RD1o: std_logic_vector(15 downto 0);
signal RD2o: std_logic_vector(15 downto 0);
signal instrou: std_logic_vector(15 downto 0);

--semnale iesire RAM
signal iesireRam: std_logic_vector(15 downto 0);

--registrii intermediari -pipeline 
signal RIf_Id: std_logic_vector(31 downto 0);
signal RId_Ex: std_logic_vector(82 downto 0);
signal REx_Mem: std_logic_vector(55 downto 0);
signal RMem_Wb: std_logic_vector(36 downto 0);

signal iesireMuxRegDst: std_logic_vector(2 downto 0);

begin

mpg_enable_1: MPG port map(clk,btn(2),en1);
mpg_enable_2: MPG port map(clk,btn(4),en2);
  
--initializarea semnalelor de control pentru UC
process(RIf_Id(15 downto 0))
begin
  RegDst<='0';
  RegWr<='0';
  AluSrc<='0';
  extop<='0';
  MemWr<='0';
  MemtoReg<='0';
  branch<='0';
  jump<='0';
  AluOp<="000";
      
  case RIf_Id(15 downto 13) is
      when "000"=>        --instructiune de tip R (add,sub,or,and,sll,srl,xor,sllv)
      RegDst<='1';
      RegWr<='1';
      AluOp<="100";
      
      when "001"=>  --instructiune de tip I -addi
      RegWr<='1';
      AluSrc<='1';
      extop<='1';
      AluOp<="000";
      
      when "010"=>  --instructiune de tip I- lw 
      RegWr<='1';
      AluSrc<='1';
      extop<='1';
      MemtoReg<='1';
      AluOp<="000";
      
      when "011"=> --instructiune de tip I - sw
      AluSrc<='1';
      extop<='1';
      MemWr<='1';
      AluOp<="000";
      
      when "100"=> --instructiune de tip I -beq
      extop<='1';
      branch<='1';
      AluOp<="001";
      
      when "101"=>  --instructiune de tip I-andi
      RegWr<='1';
      AluSrc<='1';
      AluOp<="111";
      
      when "110"=>  --instructiune de tip I -ori
      RegWr<='1';
      AluSrc<='1';
      AluOp<="110";
      
      when "111"=>   --instructiune de tip J- jump
      jump<='1';
      AluOp<="000";     
    end case;	
end process;

PCSrc<=REx_Mem(52) and  REx_Mem(35);
jr<=RIf_Id(31 downto 29) & RIf_Id(12 downto 0);

instrou<=instr;
iful: IFetch port map(en1,en2,clk, REx_Mem(51 downto 36),jr,jump,PcSrc,instr,addr);  --sw(0)-Jump, sw(1)-PcSrc- pentru branch

process(clk,instr,addr)
begin
 if clk='1' and clk'event then
  if en2='1' then
 RIf_Id(31 downto 16)<=addr;
 RIf_Id(15 downto 0)<=instr;
end if;
end if;
end process;

instro<=instr;

idecoder: IDec port map(clk,RIf_Id(15 downto 0),RMem_Wb(2 downto 0),WD,RMem_Wb(35),en2,RegDst,extop,RD1,RD2,extins_imm,functie,sa);

extinsimediat<=extins_imm;
functieo<=functie;
sao<=sa;
RD1o<=RD1;
RD2o<=RD2;

process(clk,MemtoReg,RegWr,MemWr,branch,AluOp,AluSrc,RegDst,extins_imm,functie,RIf_Id(15 downto 0),RIf_Id(31 downto 16),RD1o,RD2o,sa)
begin
    if clk='1' and clk'event then
        if en2='1' then
            RId_Ex(82)<=MemtoReg;
            RId_Ex(81)<=RegWr;
            RId_Ex(80)<=MemWr;
            RId_Ex(79)<=branch;
            RId_Ex(78 downto 76)<=AluOp;
            RId_Ex(75)<=AluSrc;
            RId_Ex(74)<=RegDst;
            RId_Ex(73 downto 58)<=RIf_Id(31 downto 16);
            RId_Ex(57 downto 42)<=RD1o;
            RId_Ex(41 downto 26)<=RD2o;
            RId_Ex(25 downto 10)<=extins_imm;
            RId_Ex(9 downto 7)<=functie;
            RId_Ex(6 downto 4)<=RIf_Id(9 downto 7);
            RId_Ex(3 downto 1)<=RIf_Id(6 downto 4);
            RId_Ex(0)<=sa;
        end if;
    end if;
end process;
   
iexecution: IExe port map(RId_Ex(73 downto 58),RId_Ex(57 downto 42),RId_Ex(41 downto 26),RId_Ex(25 downto 10),RId_Ex(9 downto 7),RId_Ex(0),RId_Ex(75),RId_Ex(78 downto 76),br,ALURes,Zero);
ALUReso<=ALURes;

process(RId_Ex(6 downto 4),RId_Ex(3 downto 1), RId_Ex(74))
begin
   case  RId_Ex(74) is
    when '0'=> iesireMuxRegDst<=RId_Ex(6 downto 4);
    when '1'=> iesireMuxRegDst<=RId_Ex(3 downto 1);
    when others=> iesireMuxRegDst<="000"; 
   end case;
end process;

process(clk,RId_Ex,br,Zero,ALUReso,iesireMuxRegDst)
begin   
    if clk='1' and clk'event then
        if en2='1' then
         REx_Mem(55)<=RId_Ex(82);
         REx_Mem(54)<=RId_Ex(81);
         REx_Mem(53)<=RId_Ex(80);
         REx_Mem(52)<=RId_Ex(79);
         REx_Mem(51 downto 36)<=br;
         REx_Mem(35)<=Zero;
         REx_Mem(34 downto 19)<=ALUReso;
         REx_Mem(18 downto 3)<=RId_Ex(41 downto 26);
         REx_Mem(2 downto 0)<=iesireMuxRegDst;
        end if;
    end if;
end process;

memorieRam: RAM port map(REx_Mem(53),REx_Mem(34 downto 19),iesireRAM,REx_Mem(18 downto 3),clk,en2);

process(clk,REx_Mem,iesireRAM)
begin
  if clk='1' and clk'event then
    if en2='1' then 
        RMem_Wb(36)<=REx_Mem(55);
        RMem_Wb(35)<=REx_Mem(54);
        RMem_Wb(34 downto 19)<=iesireRAM;
        RMem_Wb(18 downto 3)<=REx_Mem(34 downto 19);
        RMem_Wb(2 downto 0)<=REx_Mem(2 downto 0);         
    end if;
  end if;
end process;
   
--  Write back -wb
process( RMem_Wb(36),RMem_Wb(34 downto 19),RMem_Wb(18 downto 3))
begin
 case  RMem_Wb(36) is 
    when '0'=> WD<=RMem_Wb(18 downto 3);
    when '1'=> WD<=RMem_Wb(34 downto 19);
 end case;
end process;
  
process(instr,addr,sw(7 downto 5))
begin
    case sw(7 downto 5) is  --controlam daca afisam  adresa sau instructiunea
        when "000"=> iesire<=instr;
        when "001"=> iesire<=addr;
        when "010"=> iesire<=RD1;
        when "011"=> iesire<=RD2;
        when "100"=> iesire<=extins_imm;
        when "101"=> iesire<=ALURes;
        when "110"=> iesire<=iesireRAM;
        when "111"=>iesire<=WD;
    end case;
end process;

ssd1: SSD port map(iesire,catod,anod,clk);
  
cat<=catod;
an<=anod; 
led(0)<=jump;
led(1)<=branch;
led(2)<=MemtoReg;
led(3)<=MemWr;
led(4)<=extop;
led(5)<=AluSrc;
led(6)<=RegWr;
led(7)<=RegDst;
led(15 downto 13)<=AluOp;
led(11)<=Zero;
    
end Behavioral;
