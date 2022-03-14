----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 

-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
Port( Digit: in std_logic_vector(15 downto 0);
      cat: out std_logic_vector(6 downto 0);
      an: out std_logic_vector(3 downto 0);
      clk: in std_logic);
end SSD;

architecture Behavioral of SSD is

signal decbit: std_logic_vector(6 downto 0):="0000000"; -- iesirile de la 7 segmente
signal rez: std_logic_vector(3 downto 0):="0000"; --rez e iesirea de la mux 4:1
signal rez2: std_logic_vector(3 downto 0):="0000"; --rez2 e iesirea de la mux 4:1 catre anozi
signal sel: std_logic_vector(1 downto 0):="00";
signal count: std_logic_vector(15 downto 0):="0000000000000000";

begin

process(clk)
begin
    if clk'event and clk='1' then
        count<=count+1;
    end if;
end process;

sel<=count(15 downto 14);

process(Digit,sel)
begin
    case sel is
        when "00"=> rez<=Digit(3 downto 0);
        when "01"=> rez<=Digit(7 downto 4);
        when "10"=> rez<=Digit(11 downto 8);
        when others=> rez<=Digit(15 downto 12);
    end case;
end process;

process(sel)
begin
    case sel is 
        when "00"=> rez2<="1110";
        when "01"=> rez2<="1101";
        when "10"=> rez2<="1011";
        when others=> rez2<="0111";  
    end case;
end process;

process(rez)
begin
    case rez is
        when "0001"=> decbit<="1111001";    --1
        when "0010"=> decbit<="0100100";    --2
        when "0011"=> decbit<="0110000";    --3
        when "0100"=> decbit<="0011001";    --4
        when "0101"=> decbit<="0010010";    --5
        when "0110"=> decbit<="0000010";    --6
        when "0111"=> decbit<="1111000";    --7
        when "1000"=> decbit<="0000000";    --8
        when "1001"=> decbit<="0010000";    --9
        when "1010"=> decbit<="0001000";    --A
        when "1011"=> decbit<="0000011";    --b
        when "1100"=> decbit<="1000110";    --C
        when "1101"=> decbit<="0100001";    --d
        when "1110"=> decbit<="0000110";    --E
        when "1111"=> decbit<="0001110";    --F
        when others=> decbit<="1000000";    --0
    end case;
end process;
	
cat<=decbit;  --catozii
an<=rez2; --anozii

end Behavioral;
