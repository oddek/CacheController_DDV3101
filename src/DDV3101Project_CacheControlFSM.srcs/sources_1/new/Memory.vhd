----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 02:20:39 PM
-- Design Name: 
-- Module Name: Memory - Behavioral
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


entity Memory is
    Generic(    addressBits : Integer;
                dataBits : Integer); 
    Port ( clk :       in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (addressBits-1 downto 0);
           wData : in STD_LOGIC_VECTOR (dataBits-1 downto 0);
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           ready : out STD_LOGIC;
           DataBlock : out STD_LOGIC_VECTOR (dataBits-1 downto 0));
end Memory;

architecture Behavioral of Memory is
    --type memory_type is array(0 to (2**addressBits)-1) of std_logic_vector(dataBits-1 downto 0);
    --signal RAM : memory_type := (others => (others => '0'));
begin


end Behavioral;
