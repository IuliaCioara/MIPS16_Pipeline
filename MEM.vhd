----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 

-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity RAM is
Port(MemWr: in std_logic;
     Adress: in std_logic_vector(15 downto 0);
     RD: out std_logic_vector(15 downto 0);
     WD: in std_logic_vector(15 downto 0);
     clk:in std_logic;
     en: in std_logic);
end RAM;

architecture Behavioral of RAM is

type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file: reg_array:=(B"0000_0000_0000_1010",others=>x"0000");
signal addr: std_logic_vector(3 downto 0);

begin

addr<=Adress(3 downto 0);

process(clk)
begin
  if en='1' then 
   if clk'event and clk='1' then
    if MemWr='1' then       
        reg_file(conv_integer(addr))<=WD;       
    end if;
   end if;
   RD<=reg_file(conv_integer(addr)); 
  end if; 
end process;

end Behavioral;