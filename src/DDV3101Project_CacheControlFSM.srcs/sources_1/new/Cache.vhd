----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 02:20:39 PM
-- Design Name: 
-- Module Name: Cache - Behavioral
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

entity Cache is
    Port ( index : in STD_LOGIC;
           offset : in STD_LOGIC;
           wData : in STD_LOGIC_VECTOR (7 downto 0);
           dataBlock : in STD_LOGIC_VECTOR (7 downto 0);
           refill : in STD_LOGIC;
           update : in STD_LOGIC;
           rData : out STD_LOGIC_VECTOR (7 downto 0));
end Cache;

architecture Behavioral of Cache is

begin


end Behavioral;
