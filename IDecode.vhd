----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 

-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDec is
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
end IDec;

architecture Behavioral of IDec is

component RF is
 Port( RA1: in std_logic_vector(2 downto 0);
       RA2: in std_logic_vector(2 downto 0);
       WD: in std_logic_vector(15 downto 0);
       WA: in  std_logic_vector(2 downto 0);
       en: in std_logic;
       RegWr: in std_logic;
       clk: in std_logic;
       RD1: out std_logic_vector(15 downto 0);
       RD2: out std_logic_vector(15 downto 0));
end component;

signal ext_op: std_logic_vector(15 downto 0);
signal rd1: std_logic_vector(15 downto 0);
signal rd2: std_logic_vector(15 downto 0);

begin

ext_op<="000000000" & instruction(6 downto 0)  when ExtOp='0' or instruction(6)='0' else "111111111" & instruction(6 downto 0) ;
   
Regisfile: RF port map(instruction(12 downto 10),instruction(9 downto 7),WD,iesireMux,en,RegWrite,clk,rd1,rd2);
 
Rs<=rd1;
Rt<=rd2;
func<=instruction(2 downto 0);
sa<=instruction(3);
Ext_imm<=ext_op;

end Behavioral;

