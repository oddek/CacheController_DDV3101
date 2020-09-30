----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 10:36:29 AM
-- Design Name: 
-- Module Name: CacheTagArray - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CacheTagArray is
    Port ( index : in STD_LOGIC_VECTOR (9 downto 0);
           inputTag : in STD_LOGIC_VECTOR (18 downto 0);
           output : out STD_LOGIC_VECTOR (20 downto 0);
           enWriteTag : in STD_LOGIC;
           setValid : in STD_LOGIC;
           setNotValid : in STD_LOGIC;
           setDirty : in STD_LOGIC;
           setNotDirty : in STD_LOGIC);
end CacheTagArray;

architecture Behavioral of CacheTagArray is

    constant ValidBitIndex : Integer := 20;
    constant DirtyBitIndex : Integer := 19;

    type tag_array_type is array(0 to 1023) of std_logic_vector(ValidBitIndex downto 0);
    signal tag_array : tag_array_type := (others => (others => '0'));
   
begin
    output <= tag_array(to_integer(unsigned(index)));

    process
    begin
        if(enWriteTag = '1') then
            tag_array(to_integer(unsigned(index)))(ValidBitIndex-2 downto 0) <= inputTag;
        end if;
        if(setValid = '1') then
            tag_array(to_integer(unsigned(index)))(ValidBitIndex) <= '1';
        end if;
        if(setNotValid = '1') then
            tag_array(to_integer(unsigned(index)))(ValidBitIndex) <= '0';
        end if;
        if(setDirty = '1') then
            tag_array(to_integer(unsigned(index)))(DirtyBitIndex) <= '1';
        end if;
        if(setNotdirty = '1') then
            tag_array(to_integer(unsigned(index)))(DirtyBitIndex) <= '0';
        end if;
    end process;

        

end Behavioral;
