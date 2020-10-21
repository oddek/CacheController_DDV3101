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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity Memory is
    Generic(    addressBits : Integer;
                BlockSize : Integer); 
    Port ( clk :            in STD_LOGIC;
           readOrWrite :    in STD_LOGIC;
           operation :      in STD_LOGIC;
           addr :           in STD_LOGIC_VECTOR (31 downto 0);
           --Må være 128 bit:
           dataFromCache :  in STD_LOGIC_VECTOR (127 downto 0);
           dataToCache :    out STD_LOGIC_VECTOR (127 downto 0);
           ready : out STD_LOGIC);
end Memory;

architecture Behavioral of Memory is
    --Vivado won't let me have arrays of the intended size (2**32)-1.
    --This smaller array lets me at least use addresses of the first and second "modulodegree", so I have been able to test the cache. 
    type memory_type is array(0 to (2**16)-1) of std_logic_vector(127 downto 0);
    signal RAM : memory_type := (others => (others => '1'));
begin
    
    process(clk, operation, readOrWrite, addr)
    begin
        if(operation = '1') then
            ready <= '0';
            case readOrWrite is
                when '0' => 
                    dataToCache <= RAM(to_integer(unsigned(addr(31 downto 4))));
                when others =>
                    RAM(to_integer(unsigned(addr(31 downto 4)))) <= dataFromCache;
            end case;
        end if;
        ready <= '1';
    end process; 
end Behavioral;
