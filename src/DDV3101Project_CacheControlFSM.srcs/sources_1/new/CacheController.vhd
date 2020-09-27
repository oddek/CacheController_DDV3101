----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 02:20:39 PM
-- Design Name: 
-- Module Name: CacheController - Behavioral
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

entity CacheController is
    Port ( tag : in STD_LOGIC_VECTOR (1 downto 0);
           index : in STD_LOGIC_VECTOR (2 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           flush : in STD_LOGIC;
           stall : out STD_LOGIC;
           refill : out STD_LOGIC;
           update : out STD_LOGIC);
end CacheController;

architecture Behavioral of CacheController is

begin


end Behavioral;