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
    
    
    --Divide input address:
    signal tag : STD_LOGIC_VECTOR(tagsize-1 downto 0);-- := addressFromCPU(addressBits-1 downto addressBits-tagSize);
    signal index : STD_LOGIC_VECTOR(indexSize-1 downto 0);-- := addressFromCPU(addressBits-1-tagSize downto addressBits-tagSize - indexSize);
    signal offset : STD_LOGIC_VECTOR(1 downto 0);-- := addressFromCPU(3 downto 2); --Maybe make this 2 generic, and add byte offset support?
    
    type state_type is (Idle, CompareTag, Allocate, WriteBack);
    signal state : state_type := Idle;
    signal state_next : state_type;
    
    --Array of std_logic_vectors with: VALID BIT, DIRTY BIT and the TAG (LSB);
    type tag_array_type is array(0 to (2**indexSize)-1 ) of std_logic_vector(ValidBitIndex downto 0);
    signal tag_array : tag_array_type := (others => (others => '1'));

    --Databits må plusses med andre ting kanskje??? I størrelse, validbit osv?? Eller kanskje det ligger i controller?
    type memory_type is array(0 to (indexSize-1)) of std_logic_vector(BlockSize-1 downto 0);
    signal data_array : memory_type := (others => (others => '0'));
    
    signal current_data : std_logic_vector(BlockSize-1 downto 0);
begin

    tag <= addressFromCPU(addressBits-1 downto (addressBits-tagSize));
    index <= addressFromCPU((addressBits-1-tagSize) downto (addressBits-tagSize - indexSize));
    offset <= addressFromCPU(offsetSize-1 downto 2); --Maybe make this 2 generic, and add byte offset support?

    current_data <= data_array(to_integer(unsigned(index)));

    Mux : FourToOneMux
    Generic Map(BlockSize => BlockSize, WordSize => WordSize)
    Port Map(i0 => current_data, sel => offset, Y => dataToCPU);

    --State register part
    process(clk)
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
                if((tag_array(to_integer(unsigned(index)))(ValidBitIndex) = '1') and
                    (tag_array(to_integer(unsigned(index)))(tagSize-1 downto 0) = tag)) then
                    
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
                
                --Memory not ready, stay in current state
                else
                    state_next <= state;
                end if;
                
                
            when WriteBack =>
                --If memory ready, return to allocate
                if(readyFromMemory = '1') then
                    state_next <= Allocate;
                --If not ready, stay in current state
                else
                    state_next <= state;
                end if;
        end case;
    end process;
    
    
    --Output logic;
    process(state, state_next, OperationFromCPU, addressFromCPU, dataFromCPU, dataFromMemory, readyFromMemory) is
    begin
        case state is
            when Idle =>
            --Let cpu know we are idle, and let Memory know that there is no current operation.
                operationToMemory <= '0';
                readyToCPU <= '1';
            when CompareTag =>
                --Tell the processor that we are ready if we are on our way back to idle.
                if(state_next = idle) then
                    --Checking if we were writing
                    if(readOrWriteFromCPU = '1') then
                        --Set Dirty Bit:
                        tag_array(to_integer(unsigned(index)))(DirtyBitIndex) <= '1'; 
                        --The book says that we also have to set the tag and valid bit, but this is due to some strange implementation i believe. In this solution I don't think this is necessary.
                        
                        --Write the data from CPU into cache
                        --Should really be generalized or put into a separate function or component
                        case offset is
                            when "00" =>
                                data_array(to_integer(unsigned(index)))(127 downto 96) <= dataFromCPU;
                            when "01" =>
                                data_array(to_integer(unsigned(index)))(95 downto 64) <= dataFromCPU;
                            when "10" =>
                                data_array(to_integer(unsigned(index)))(63 downto 32) <= dataFromCPU;
                            when "11" =>
                                data_array(to_integer(unsigned(index)))(31 downto 0) <= dataFromCPU;
                        end case;
                    end if;
                    readyToCPU <= '1';
                --If not, it means we are moving to either writeBack or Allocate:
                else
                    --Tell memory that an operation is underway:
                    operationToMemory <= '1';
                    if(readOrWriteFromCPU = '1') then
                        tag_array(to_integer(unsigned(index))) <= "11" & tag;
                    end if;
                    --Handle read or write stuff
                    
                end if;
                    
                    
                
                --If not return stall = '1', do stuff?
            when Allocate =>
                --Stall = 1???
                
            when WriteBack =>
                --Stall = 1?
            
        end case;
   end process;
            











end Behavioral;
