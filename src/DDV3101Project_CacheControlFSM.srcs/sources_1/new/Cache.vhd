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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Cache is
    Generic(    addressBits : Integer;
                BlockSize : Integer;
                WordSize : Integer;
                offsetSize : Integer;
                indexSize : Integer;
                tagSize : Integer); 
                  
        Port ( clk :                in STD_LOGIC;
               readOrWriteFromCPU : in STD_LOGIC;
               OperationFromCPU :   in STD_LOGIC;
               addressFromCPU :     in STD_LOGIC_VECTOR(addressBits-1 downto 0);
               dataToCPU :          out STD_LOGIC_VECTOR (WordSize-1 downto 0);
               dataFromCPU :        in STD_LOGIC_VECTOR (WordSize-1 downto 0);
               readyToCPU :         out STD_LOGIC;
               
               --Disse må være 128 bit
               dataFromMemory :     in STD_LOGIC_VECTOR(BlockSize-1 downto 0);
               dataToMemory :       out STD_LOGIC_VECTOR(BlockSize-1 downto 0);
               addressToMemory :    out STD_LOGIC_VECTOR(addressBits-1 downto 0);
               operationToMemory :  out STD_LOGIC;
               readOrWriteToMemory: out STD_LOGIC := '0';
               readyFromMemory :      in STD_LOGIC);
end Cache;

architecture Behavioral of Cache is

    Component FourToOneMux
    Generic (BlockSize : Integer;
                WordSize : Integer);
    Port ( i0 : in STD_LOGIC_VECTOR (BlockSize-1 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           Y : out STD_LOGIC_VECTOR (WordSize-1 downto 0));
    end Component FourToOneMux;

    constant ValidBitIndex : Integer := (tagSize - 1 + 2);
    constant DirtyBitIndex : Integer := tagSize - 1 + 1;
    
    --Parse input address:
    signal tag : STD_LOGIC_VECTOR(tagsize-1 downto 0) := (others => '0');
    signal index : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal byteOffset : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    
    type state_type is (Idle, CompareTag, Allocate, WriteBack);
    signal state : state_type := Idle;
    signal state_next : state_type := Idle;
    
    --ARRAY OF TAGS 
    --VALID BIT, DIRTY BIT and the TAG (LSB);
    type tag_array_type is array(0 to (2**index'length)-1 ) of std_logic_vector(ValidBitIndex downto 0);
    signal tag_array : tag_array_type := (others => (others => '0'));

    --ARRAY OF DATA
    type memory_type is array(0 to 1023) of std_logic_vector(BlockSize-1 downto 0);
    signal data_array : memory_type := (others => (others => '0'));
    
    signal current_data : std_logic_vector(BlockSize-1 downto 0);
begin
    --Update all necessary stuff
    tag <= addressFromCPU(31 downto 14);
    index <= addressFromCPU(13 downto 4);
    byteOffset <= addressFromCPU(3 downto 2);
    current_data <= data_array(to_integer(unsigned(index)));
    
    --Setup mux for writing a word from CPU to cache
    Mux : FourToOneMux
    Generic Map(BlockSize => BlockSize, WordSize => WordSize)
    Port Map(i0 => current_data, sel => byteOffset, Y => dataToCPU);
    
    --State register part
    process(clk, addressFromCPU)
    begin
        if(rising_edge(clk)) then
            state <= state_next;
        end if;
    end process;
    
    -- Next state Logic
    process(state, index, tag, tag_array, operationFromCPU, addressFromCPU, dataFromCPU, dataFromMemory, readyFromMemory)
    begin
        case state is
            when Idle =>
                --Checks for an operation from CPU, if not stay in current state
                if (OperationFromCPU = '1') then
                    state_next <= compareTag;
                else
                    state_next <= state;
                end if;
                
                
            when CompareTag =>
                --If valid bit in index is equal to 1 (IE VALID) and TAG Matches:
                --HIT!!!
                if(tag_array(to_integer(unsigned(index)))(ValidBitIndex) = '1') and
                    (tag_array(to_integer(unsigned(index)))(tagSize-1 downto 0) = tag) then
                    
                    --If its a hit, it does not matter whether its a read or write, we are going back either way
                    state_next <= idle;
                        
                --MISS
                else                        
                    --If cache miss and old block is clean, goto allocate
                    if(tag_array(to_integer(unsigned(index)))(DirtyBitIndex) = '0') then
                        state_next <= Allocate;
                        
                    --If dirty bit, we have to write back!!
                    else
                        state_next <= writeBack;
                    end if;
                end if;
                
                
            when Allocate =>
                --If Memory ready, return to compare tag
                if(readyFromMemory = '1') then
                    state_next <= CompareTag;
                    
                --Memory not ready, keep waiting
                else
                    state_next <= state;
                end if;
                
                
            when WriteBack =>
                --If memory ready, goto to allocate
                if(readyFromMemory = '1') then
                    state_next <= Allocate;
                --If not ready, keep waiting
                else
                    state_next <= state;
                end if;
        end case;
    end process;
    
    
    --Output logic;
    process(state, state_next, readOrWriteFromCPU, OperationFromCPU, addressFromCPU, dataFromCPU, dataFromMemory, readyFromMemory, index, tag, byteOffset) is
    begin
        case state is
            when Idle =>
            --Let cpu know we are idle, and let memory know that there is no current operation.
                if(state_next = CompareTag) then
                    readyToCPU <= '0';
                else
                    operationToMemory <= '0';
                    readyToCPU <= '1';
                end if;
                
            when CompareTag =>
                if(state_next = idle) then
                    --Checking if we were writing
                    if(readOrWriteFromCPU = '1') then
                        --Set Dirty Bit, if we were writing
                        tag_array(to_integer(unsigned(index)))(DirtyBitIndex) <= '1'; 
                        --The book says that we also have to set the tag and valid bit, but this is due to some strange implementation i believe. In this solution I don't think this is necessary.
                        
                        --Write the data from CPU into cache
                        case byteOffset is
                            when "00" =>
                                data_array(to_integer(unsigned(index)))(127 downto 96) <= dataFromCPU;
                            when "01" =>
                                data_array(to_integer(unsigned(index)))(95 downto 64) <= dataFromCPU;
                            when "10" =>
                                data_array(to_integer(unsigned(index)))(63 downto 32) <= dataFromCPU;
                            when others =>
                                data_array(to_integer(unsigned(index)))(31 downto 0) <= dataFromCPU;
                        end case;
                    end if;
                    --Tell the processor that we are ready if we are on our way back to idle.
                    readyToCPU <= '1';
                    
                --If next state is allocate, we need to let the memory know what we need
                elsif(state_next = Allocate) then
                                          
                    addressToMemory <= addressFromCPU;
                    readOrWriteToMemory <= '0';
                    --Tell memory that an operation is underway:
                    operationToMemory <= '1';
                    
                --If next state is writeBack, we need to give the memory the stuff it needs
                elsif(state_next = WriteBack) then
                    addressToMemory <= tag_array(to_integer(unsigned(index)))(17 downto 0) & index & "0000";
                    dataToMemory <= data_array(to_integer(unsigned(index)));
                    readOrWriteToMemory <= '1';
                    operationToMemory <= '1';
                    --We also have to set the dirtybit to 0, so that we can write to the cache location after the writeback and allocation
                    tag_array(to_integer(unsigned(index)))(DirtyBitIndex) <= '0';
                else
                    --Should never get here, but for some reason, sometimes we do.
                    null;
                end if;
                    
            when Allocate =>
                if(readyFromMemory = '1') then
                    --When the memory has put the necessary data on the bus, we can read it, and store it in cache.
                    tag_array(to_integer(unsigned(index))) <= '1' & '0' & tag;
                    data_array(to_integer(unsigned(index))) <= dataFromMemory;
                end if;
                
            --Nothing to be outputed in this state. 
            when WriteBack =>
                null;
        end case;
   end process;
end Behavioral;
