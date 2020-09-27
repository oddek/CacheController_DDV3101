----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 02:20:39 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Generic(    addressBits : Integer := 8;
                dataBits : Integer := 8); 
    Port (  stall :     in STD_LOGIC;
            rData :     in STD_LOGIC_VECTOR (dataBits-1 downto 0);
            address :   out STD_LOGIC_VECTOR (addressBits-1 downto 0);
            wData :     out STD_LOGIC_VECTOR (dataBits-1 downto 0);
            read :      out STD_LOGIC;
            write :     out STD_LOGIC;
            flush :     out STD_LOGIC);
end CPU;

architecture Behavioral of CPU is



begin


end Behavioral;
