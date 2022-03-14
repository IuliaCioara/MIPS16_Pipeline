----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 

-- Design Name: 
-- Module Name: IFetch - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
      Port ( rst: in std_logic;
        en: in std_logic;
        clk: in std_logic;
        branch: in std_logic_vector(15 downto 0);
        jumpAddr: in std_logic_vector(15 downto 0);
        jump: in std_logic;
        PCSrc: in std_logic;
        Instruction: out std_logic_vector(15 downto 0);
        NextAddr: out std_logic_vector(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
type ROM_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal A: ROM_type:=(
B"001_000_001_0000001",      --X"2081"    ADDI $1,$0,1                   
B"001_000_010_0000001",      --X"2101"    ADDI $2,$0,1                   
B"001_000_100_0000010",      --X"2202"    ADDI $4,$0,2                   
B"010_000_110_0000000",      --X"4300"    LW $6,0($0)          
B"001_000_101_0000001",      --X"2281"    ADDI $5,$0,1                 
B"000_000_000_000_0_000",    --NOOP
B"000_000_000_000_0_000",    --NOOP
B"100_110_101_0001101",      --X"9A8d"    BEQ $5,$6,13                  
B"000_000_000_000_0_000",    --NOOP
B"000_000_000_000_0_000",    --NOOP
B"000_000_000_000_0_000",    --NOOP
B"000_001_010_011_0_000",    --X"0530"    ADD $3,$1,$2              
B"000_000_010_001_0_000",    --X"0110"    ADD $1,$0,$2                 
B"000_000_000_000_0_000",    --NOOP
B"000_000_011_010_0_000",    --X"01A0"    ADD $2,$0,$3                 
B"011_000_011_0000001",      --X"6181"    SW $3,1($0)                   
B"010_000_111_0000001",      --X"4381"    LW $7,1($0)                            
B"001_101_101_0000001",      --X"3681"    ADDI $5,$5,1                 
B"000_000_000_000_0_000",    --NOOP
B"000_111_100_100_0_000",    --X"1E40"    ADD $4,$7,$4                 
B"111_0000000000111",        --X"E007"    J 7                           
B"000_000_000_000_0_000",    --NOOP
B"011_000_100_0000001",      --X"6201"    SW $4,1($0)                   
B"010_000_111_0000001",      --X"4381"    LW $7,1($0)                  
others=>x"0000"
);

signal PC: std_logic_vector(15 downto 0):=x"0000";
signal D: std_logic_vector(15 downto 0):=x"0000";
signal iesireMux: std_logic_vector(15 downto 0);
signal cnt: std_logic_vector(15 downto 0);

begin
  
process(clk,D)
begin
    if rst='1' then
        PC<=(others=>'0');
    else    
    if clk'event and clk='1' then
        if en='1' then
            PC<=D;
        end if;
    end if;       
    end if;
end process;
  
cnt<=PC+1;
NextAddr<=cnt;
  
Instruction<=A(conv_integer(PC));
  
process(cnt,PCSrc,branch)
begin  
    case PCSrc is
        when '0'=> iesireMux<=cnt;
        when '1'=> iesireMux<=branch;
        when others=> iesireMux<=x"0000";
    end case;
end process;

process(jump,jumpAddr,iesireMux)
begin
    case jump is
        when '1'=>D<=jumpAddr;
        when '0'=>D<=iesireMux;
        when others=> iesireMux<=x"0000";
    end case;
end process;
  
end Behavioral;
