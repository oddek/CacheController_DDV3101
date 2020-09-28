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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CacheController is
    Generic(tagSize :   Integer;
            indexSize : Integer);
    Port (  clk :       in STD_LOGIC;
            tag :       in STD_LOGIC_VECTOR (tagSize-1 downto 0);
            index :     in STD_LOGIC_VECTOR (indexSize-1 downto 0);
            read :      in STD_LOGIC;
            write :     in STD_LOGIC;
            flush :     in STD_LOGIC;
            stall :     out STD_LOGIC;
            refill :    out STD_LOGIC;
            update :    out STD_LOGIC;
            memRead :   out STD_LOGIC := '0';
            memWrite :  out STD_LOGIC := '0';
            memReady :  in STD_LOGIC := '0');
end CacheController;

architecture Behavioral of CacheController is

constant ValidBitIndex : Integer := tagSize - 1 + 2;
constant DirtyBitIndex : Integer := tagSize - 1 + 1;


type state_type is (Idle, CompareTag, Allocate, WriteBack);
signal state : state_type := idle;
signal state_next : state_type;
--Array of std_logic_vectors with: VALID BIT, DIRTY BIT and the TAG (LSB);
type tag_array_type is array((2**indexSize)-1 to 0) of std_logic_vector(ValidBitIndex downto 0);
signal tag_array : tag_array_type := (others => (others => '0'));



function ValidCpURequest(write : STD_LOGIC; read : STD_LOGIC) return Boolean is
begin
    return (write = '1' XOR read = '1');
end function;
    





begin
    
    --State register part
    process(clk, flush)
    begin
        if(flush = '1') then
            --Do something
        elsif(rising_edge(clk)) then
            state <= state_next;
        end if;
    end process;
    
    
    -- Next state Logic
    process(state, tag_array)
    begin
        case state is
            when Idle =>
                if (ValidCPURequest(write, read)) then
                    state_next <= compareTag;
                end if;
            when CompareTag =>
                --If cache hit, return to Idle
                --If valid bit in index is equal to 1 (IE VALID):
                if((tag_array(to_integer(unsigned(index)))(ValidBitIndex)) = '1') then
                    --If tag is equal to input tag, we have a hit!
                    if(tag_array(to_integer(unsigned(index)))(tagSize-1 downto 0) = tag) then
                        if(write = '1') then
                        elsif(read = '1') then
                            
                        
                        state_next <= idle;
                        end if;
                    end if;
                
                        
                    
                --If cache miss and old block is clean, goto allocate
                elsif(false) then
                    state_next <= Allocate;
                    
                --If cache miss and old block is dirty, goto writeBack
                elsif(false) then
                    state_next <= WriteBack;
                
                --Else,stay in current state (should never happen)
                else
                    state_next <= state;
                end if;
     
                
            when Allocate =>
                --If Memory ready, return to compare tag
                if(true) then
                    state_next <= CompareTag;
                
                --Memory not ready, stay in current state
                else
                    state_next <= state;
                end if;
                
            when WriteBack =>
                --If memory ready, return to allocate
                if(true) then
                    state_next <= Allocate;
                --If not ready, stay in current state
                else
                    state_next <= state;
                end if;
        end case;
    end process;
    
    --Output logic;
    process(state) is
    begin
        case state is
            when Idle =>
                stall <= '0';
                refill <= '0';
                update <= '0';
                memRead <= '0';
                memWrite <= '0';
            when CompareTag =>
                --If hit, set valid and set tag
                --If valid bit in index is equal to 1 (IE we have a hit):
                --if(tag_array[unsigned(index)](DataBits downto DataBits-1) = '1') then
                    --null;
               -- end if;
                    
                
                --If not return stall = '1', do stuff?
            when Allocate =>
                --Stall = 1???
                
            when WriteBack =>
                --Stall = 1?
            
        end case;
   end process;
            
            
 
end Behavioral;
