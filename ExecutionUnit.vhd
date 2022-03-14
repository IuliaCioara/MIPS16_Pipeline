----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 

-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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

entity IExe is
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
end IExe;

architecture Behavioral of IExe is

signal iesireMux: std_logic_vector(15 downto 0);
signal AluCtrl: std_logic_vector(2 downto 0);
signal isZero: std_logic;
signal ALUResa: std_logic_vector(15 downto 0);

begin

BranchAdress<=next_addr+Imm_ext;
   
process(ALUSrc,RD2,Imm_ext)
begin
 case ALUSrc is
    when '0'=>iesireMux<=RD2;
    when '1'=>iesireMux<=Imm_ext;
 end case; 
end process;

process(ALUOp,func)
begin
    case ALUop is
        when "000" => -- R type 
                case func is
                    when "000" => ALUCtrl <= "000"; -- ADD
                    when "001" => ALUCtrl <= "001"; -- SUB
                    when "010" => ALUCtrl <= "010"; -- SLL
                    when "011" => ALUCtrl <= "011"; -- SRL
                    when "100" => ALUCtrl <= "100"; -- AND
                    when "101" => ALUCtrl <= "101"; -- OR
                    when "110" => ALUCtrl <= "110"; -- XOR
                    when "111" => ALUCtrl <= "111"; -- SRA
                    when others => ALUCtrl <= (others => '0'); -- unknown
                end case;
            when "001" => ALUCtrl <= "000"; -- +
            when "010" => ALUCtrl <= "001"; -- -
            when "101" => ALUCtrl <= "100"; -- &
            when "110" => ALUCtrl <= "101"; -- |
            when others => ALUCtrl <= (others => '0'); -- unknown
        end case;
end process;


process(RD1,iesireMux,sa,AluCtrl)
begin
    case AluCtrl is
      when "000"=> ALUResa<=RD1+iesireMux; --ADD
      when "001"=> ALUResa<=RD1-iesireMuX; --SUB
      when "010"=> --SLL
          if sa='1' then 
            ALUResa<=RD1(14 downto 0) & '0'; 
          else
            ALUResa<=RD1;         
          end if;
     when "011"=> --SRL
          if sa='1' then 
            ALUResa<='0' & RD1(15 downto 1); 
          else
           ALUResa<=RD1;         
          end if;
    when "100"=> ALUResa<=RD1 and iesireMUX; --AND
    when "101"=> ALUResa<=RD1 or iesireMux; --OR
    when "110"=> ALUResa<=RD1 xor iesireMux; --XOR
    when others=> ALUResa<=x"0000";
   end case;
 
 if AluResa=x"0000" then
    isZero<='1';
 else
    isZero<='0';
 end if;
end process;
   
ALURes<=ALUResa;
Zero<=isZero;

end Behavioral;