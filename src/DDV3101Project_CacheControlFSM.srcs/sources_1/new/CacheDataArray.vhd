----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 10:36:29 AM
-- Design Name: 
-- Module Name: CacheDataArray - Behavioral
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

entity CacheDataArray is
    Port (  address : in STD_LOGIC_VECTOR(9 downto 0);
            enWrite : in STD_LOGIC;
            inputCPU : in STD_LOGIC_VECTOR(31 downto 0);
            outputCPU : out STD_LOGIC_VECTOR(31 downto 0);
            inputRAM : in STD_LOGIC_VECTOR(127 downto 0);
            outputRAM : out STD_LOGIC_VECTOR(127 downto 0);
            ready : out STD_LOGIC
            );
end CacheDataArray;





architecture Behavioral of CacheDataArray is

    type memory_type is array(0 to 1023) of std_logic_vector(127 downto 0);
    signal data_array : memory_type := (others => (others => '0'));


begin


end Behavioral;
