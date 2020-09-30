----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2020 07:52:37 PM
-- Design Name: 
-- Module Name: FourToOneMux - Behavioral
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

entity FourToOneMux is
    Generic (BlockSize : Integer;
                WordSize : Integer);
    Port ( i0 : in STD_LOGIC_VECTOR (BlockSize - 1 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           Y : out STD_LOGIC_VECTOR (WordSize - 1 downto 0));
end FourToOneMux;

architecture Behavioral of FourToOneMux is

begin
    
    Y <=    i0(127 downto 96) when sel = "00" else
            i0(95 downto 64) when sel = "01" else
            i0(63 downto 32) when sel = "10" else
            i0(31 downto 0);
    
--    Y <=    i0((blocksize-1)-(1-1)*blocksize downto blocksize - 1 * WordSize) when sel = "00" else
--            i0((blocksize-1)-(2-1)*blocksize downto blocksize - 2 * WordSize) when sel = "01" else
--            i0((blocksize-1)-(3-1)*blocksize downto blocksize - 3 * WordSize) when sel = "10" else
--            i0((blocksize-1)-(4-1)*blocksize downto blocksize - 4 * WordSize);

end Behavioral;
