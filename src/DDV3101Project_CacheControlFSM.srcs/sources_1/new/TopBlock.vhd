----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 02:42:37 PM
-- Design Name: 
-- Module Name: TopBlock - Behavioral
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

--library work;
--use work.DesignSpecs.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopBlock is
    Port (  clk :       in STD_LOGIC := '1';
            ready : out STD_LOGIC := '1';
            operation : in STD_LOGIC := '0';
            rData :     out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');--(Word-1 downto 0);
            addr :      in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');--(AddressBits-1 downto 0);
            wData :     in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');--(Word-1 downto 0);
            readOrWrite :      in STD_LOGIC);
end TopBlock;


architecture Behavioral of TopBlock is
    --Constants
    constant Byte : Integer := 8; --(2^3)
    constant Kibi : Integer := 1024; --(2^10)
    constant Word : Integer := 32; --(2^5)
    constant BlockSize : Integer := 4 * Word; --128 (2^7)
    constant CacheSizeBits : Integer := 16 * Kibi * Byte; --16KiB
    constant CacheBlockSize : Integer := CacheSizeBits / BlockSize; --1024 (2^10) 
    constant AddressBits : Integer := 32; --32 Bytes
    constant ValidBitSize : Integer := 1;
    constant DirtyBitSize : Integer := 1;
    constant N : Integer := Integer(log2(Real(CacheBlockSize))); --10
    constant M : Integer := Integer(log2(Real(BlockSize/Word))); -- 2
    
    constant indexSize : Integer := N; -- 10
    constant tagSize : Integer := 18;--32 - (n + m + 2);  --18
    
    constant offsetSize : Integer := 4;
    
    --Output from cacheController
    signal cache2MemReadOrWrite : STD_LOGIC := '0';
    signal cache2MemAddress : STD_LOGIC_VECTOR(addressBits-1 downto 0) := (others => '0');
    signal cache2MemData : STD_LOGIC_VECTOR(BlockSize -1 downto 0) := (others => '0');
    signal cache2MemOperation : STD_LOGIC := '0';
    
    --Output from Memory
    signal mem2CacheReady : STD_LOGIC := '0';
    --Må være 128
    signal mem2CacheData : STD_LOGIC_VECTOR(BlockSize-1 downto 0) := (others => '0');
    
    --Components
    Component Memory
        Generic(    addressBits : Integer;
                    BlockSize : Integer); 
        Port ( clk :            in STD_LOGIC;
               readOrWrite :    in STD_LOGIC;
               operation :      in STD_LOGIC;
               addr :           in STD_LOGIC_VECTOR (addressBits-1 downto 0);
               --Må være 128 bit:
               dataFromCache :  in STD_LOGIC_VECTOR (BlockSize-1 downto 0);
               dataToCache :    out STD_LOGIC_VECTOR (BlockSize-1 downto 0);
               ready : out STD_LOGIC);
    end Component Memory;
    
    Component Cache
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
               --Skal være 32 bit
               dataToCPU :          out STD_LOGIC_VECTOR (Word-1 downto 0);
               dataFromCPU :        in STD_LOGIC_VECTOR (Word-1 downto 0);
               readyToCPU :         out STD_LOGIC;
               
               --Disse må være 128 bit
               dataFromMemory :     in STD_LOGIC_VECTOR(BlockSize-1 downto 0);
               dataToMemory :       out STD_LOGIC_VECTOR(BlockSize-1 downto 0);
               addressToMemory :    out STD_LOGIC_VECTOR(addressBits-1 downto 0);
               operationToMemory :  out STD_LOGIC;
               readOrWriteToMemory: out STD_LOGIC := '0';
               readyFromMemory :    in STD_LOGIC);
    end Component Cache; 

begin

    CacheInst : Cache
    Generic Map(addressBits => AddressBits, BlockSize => BlockSize, WordSize => Word, indexSize => indexSize, offsetSize => offsetSize, tagSize => tagSize)
    Port Map(   clk => clk,
                readOrWriteFromCPU => readOrWrite,
                operationFromCPU => operation,
                addressFromCPU => addr, 
                dataToCPU => rData,
                dataFromCPU => wData, 
                readyToCPU => ready,
                dataFromMemory => mem2CacheData,
                dataToMemory => cache2MemData, 
                addressToMemory => cache2MemAddress,
                operationToMemory => cache2MemOperation,
                readOrWriteToMemory => cache2MemReadOrWrite,
                readyFromMemory => mem2CacheReady);
    
    
    MemoryInst : Memory
    Generic Map(addressBits => AddressBits, BlockSize => BlockSize)
    Port Map(   clk => clk,
                readOrWrite => cache2MemReadOrWrite,
                operation => cache2MemOperation,
                addr => cache2MemAddress,
                dataFromCache => cache2MemData,
                dataToCache => mem2CacheData,
                ready => mem2CacheReady);


end Behavioral;
