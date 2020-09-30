----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 09:53:55 AM
-- Design Name: 
-- Module Name: OneToFourDemux - Behavioral
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

entity OneToFourDemux is
    Port ( i0 : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           en : in STD_LOGIC;
           Y0 : out STD_LOGIC_VECTOR (31 downto 0);
           Y1 : out STD_LOGIC_VECTOR (31 downto 0);
           Y2 : out STD_LOGIC_VECTOR (31 downto 0);
           Y3 : out STD_LOGIC_VECTOR (31 downto 0));
end OneToFourDemux;

architecture Behavioral of OneToFourDemux is

begin
    process(i0, sel) is
    begin
        case sel is
            when "00" =>
                Y0 <= i0;
            when "01" =>
                Y1 <= i0;
            when "10" =>
                Y2 <= i0;
            when others =>
                Y3 <= i0;
        end case;
    end process;
    


end Behavioral;
