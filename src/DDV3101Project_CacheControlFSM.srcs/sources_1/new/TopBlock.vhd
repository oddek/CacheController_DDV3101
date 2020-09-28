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

library work;
use work.DesignSpecs.all;

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
    Port (  clk :       in STD_LOGIC;
            ready : out STD_LOGIC;
            operation : in STD_LOGIC;
            rData :     out STD_LOGIC_VECTOR (Word-1 downto 0);
            addr :      in STD_LOGIC_VECTOR (AddressBits-1 downto 0);
            wData :     in STD_LOGIC_VECTOR (Word-1 downto 0);
            readOrWrite :      in STD_LOGIC);
end TopBlock;
architecture Behavioral of TopBlock is
    --Constants
--    constant Byte : Integer := 8; --(2^3)
--    constant Kibi : Integer := 1024; --(2^10)
--    constant Word : Integer := 32; --(2^5)
--    constant BlockSize : Integer := 4 * Word; --128 (2^7)
--    constant CacheSizeBits : Integer := 16 * Kibi * Byte; --16KiB
--    constant CacheBlockSize : Integer := CacheSizeBits / BlockSize; --1024 (2^10) 
--    constant AddressBits : Integer := 32 * byte; --32 Bytes
--    constant ValidBitSize : Integer := 1;
--    constant DirtyBitSize : Integer := 1;
--    constant N : Integer := Integer(log2(Real(CacheBlockSize))); --10
--    constant M : Integer := Integer(log2(Real(BlockSize/Word))); -- 2
    
--    constant DataBits : Integer := 8;
--    constant indexSize : Integer := N;
--    constant tagSize : Integer := 32 - (n + m + 2); 
    
--    constant offsetSize : Integer := 2;
    --Internal Signals
--    signal tag : STD_LOGIC_VECTOR(tagsize-1 downto 0);
--    signal index : STD_LOGIC_VECTOR(indexSize-1 downto 0);
--    signal offset : STD_LOGIC_VECTOR(offsetSize-1 downto 0);
    
    --Output from cacheController
    signal cache2MemReadOrWrite : STD_LOGIC;
    signal cache2MemAddress : STD_LOGIC_VECTOR(addressBits-1 downto 0);
    signal cache2MemData : STD_LOGIC_VECTOR(BlockSize -1 downto 0);
    signal cache2MemOperation : STD_LOGIC;
    
    --Output from Memory
    signal mem2CacheReady : STD_LOGIC;
    --Må være 128
    signal mem2CacheData : STD_LOGIC_VECTOR(BlockSize-1 downto 0);
    
    --Components
    Component Memory
        Generic(    addressBits : Integer;
                    BlockSize : Integer); 
        Port ( readOrWrite :    in STD_LOGIC;
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
--    Component CacheController
--        Generic(    tagSize : Integer := tagSize;
--                    indexSize : Integer := indexSize);
--        Port ( clk :       in STD_LOGIC;
--               tag : in STD_LOGIC_VECTOR (tagSize-1 downto 0);
--               index : in STD_LOGIC_VECTOR (indexSize-1 downto 0);
--               read : in STD_LOGIC;
--               write : in STD_LOGIC;
--               flush : in STD_LOGIC;
--               stall : out STD_LOGIC;
--               refill : out STD_LOGIC;
--               update : out STD_LOGIC;
--               memRead : out STD_LOGIC;
--               memWrite : out STD_LOGIC;
--               memReady : in STD_LOGIC);
--    end Component CacheController;   
    
--    Component CPU
--        Generic(    addressBits : Integer := 8;
--                    dataBits : Integer := 8); 
--        Port (  stall :     in STD_LOGIC;
--                rData :     in STD_LOGIC_VECTOR (dataBits-1 downto 0);
--                address :   out STD_LOGIC_VECTOR (addressBits-1 downto 0);
--                wData :     out STD_LOGIC_VECTOR (dataBits-1 downto 0);
--                read :      out STD_LOGIC;
--                write :     out STD_LOGIC;
--                flush :     out STD_LOGIC);
--    end Component CPU;
begin


--    CPUInst : CPU
--    Generic Map(addressBits => AddressBits, dataBits => DataBits)
--    Port Map(stall => TopBlock.Stall, rData => TopBlock.rData, address => TopBlock.address, wData => TopBlock.wData, read => TopBlock.read, write => TopBlock.write, flush => TopBlock.flush);

--    CacheControllerInst : CacheController
--    Port Map(   clk => clk,
--                tag => tag, 
--                index => index, 
--                read => read, 
--                write => write, 
--                flush => flush, 
--                stall => stall, 
--                refill => cacheControl2CacheRefill,
--                update => cachecontrol2CacheUpdate,
--                memRead => cacheControl2MemRead,
--                memWrite => cacheControl2MemWrite,
--                memReady => Mem2CacheControlReady);

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
    Port Map(   readOrWrite => cache2MemReadOrWrite,
                operation => cache2MemOperation,
                addr => cache2MemAddress,
                dataFromCache => cache2MemData,
                dataToCache => mem2CacheData,
                ready => mem2CacheReady);


end Behavioral;
