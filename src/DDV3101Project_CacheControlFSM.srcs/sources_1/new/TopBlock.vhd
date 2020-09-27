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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopBlock is
    Port (  clk :       in STD_LOGIC;
            stall :     out STD_LOGIC;
            rData :     out STD_LOGIC_VECTOR (7 downto 0);
            addr :   in STD_LOGIC_VECTOR (7 downto 0);
            wData :     in STD_LOGIC_VECTOR (7 downto 0);
            read :      in STD_LOGIC;
            write :     in STD_LOGIC;
            flush :     in STD_LOGIC);
end TopBlock;
architecture Behavioral of TopBlock is

    --Constants
    constant AddressBits : Integer := 8;
    constant DataBits : Integer := 8;
    constant tagSize : Integer := 2;
    constant indexSize : Integer := 3;
    constant offsetSize : Integer := 2;
    --Internal Signals
    signal tag : STD_LOGIC_VECTOR(tagsize-1 downto 0);
    signal index : STD_LOGIC_VECTOR(indexSize-1 downto 0);
    signal offset : STD_LOGIC_VECTOR(offsetSize-1 downto 0);
    
    --Output from cacheController
    signal cacheControl2MemRead, cacheControl2MemWrite : STD_LOGIC;
    signal cacheControl2CacheUpdate, cacheControl2CacheRefill : STD_LOGIC;
    
    --Output from Memory
    signal mem2CacheControlReady : STD_LOGIC;
    signal mem2CacheDataBlock : STD_LOGIC_VECTOR(DataBits-1 downto 0);
    
    --Components
    Component Memory
        Generic(    addressBits : Integer := 8;
                    dataBits : Integer := 8); 
        Port ( addr : in STD_LOGIC_VECTOR (addressBits-1 downto 0);
               wData : in STD_LOGIC_VECTOR (dataBits-1 downto 0);
               write : in STD_LOGIC;
               read : in STD_LOGIC;
               ready : out STD_LOGIC;
               DataBlock : out STD_LOGIC_VECTOR (dataBits-1 downto 0));
    end Component Memory;
    
    Component Cache
        Generic(    addressBits : Integer := AddressBits;
                    dataBits : Integer := DataBits; 
                    offsetSize : Integer := offsetSize;
                    indexSize : Integer := indexSize); 
                  
        Port ( index : in STD_LOGIC_VECTOR(indexSize-1 downto 0);
               offset : in STD_LOGIC_VECTOR(offsetSize-1 downto 0); 
               wData : in STD_LOGIC_VECTOR (dataBits-1 downto 0);
               dataBlock : in STD_LOGIC_VECTOR (dataBits-1 downto 0);
               refill : in STD_LOGIC;
               update : in STD_LOGIC;
               rData : out STD_LOGIC_VECTOR (dataBits-1 downto 0));
    end Component Cache; 
    Component CacheController
        Generic(    tagSize : Integer := tagSize;
                    indexSize : Integer := indexSize);
        Port ( tag : in STD_LOGIC_VECTOR (tagSize-1 downto 0);
               index : in STD_LOGIC_VECTOR (indexSize-1 downto 0);
               read : in STD_LOGIC;
               write : in STD_LOGIC;
               flush : in STD_LOGIC;
               stall : out STD_LOGIC;
               refill : out STD_LOGIC;
               update : out STD_LOGIC;
               memRead : out STD_LOGIC;
               memWrite : out STD_LOGIC;
               memReady : in STD_LOGIC);
    end Component CacheController;   
    
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
    tag <= addr(7 downto 6);

--    CPUInst : CPU
--    Generic Map(addressBits => AddressBits, dataBits => DataBits)
--    Port Map(stall => TopBlock.Stall, rData => TopBlock.rData, address => TopBlock.address, wData => TopBlock.wData, read => TopBlock.read, write => TopBlock.write, flush => TopBlock.flush);

    CacheControllerInst : CacheController
    Port Map(   tag => tag, 
                index => index, 
                read => read, 
                write => write, 
                flush => flush, 
                stall => stall, 
                refill => cacheControl2CacheRefill,
                update => cachecontrol2CacheUpdate,
                memRead => cacheControl2MemRead,
                memWrite => cacheControl2MemWrite,
                memReady => Mem2CacheControlReady);

    CacheInst : Cache
    Generic Map(addressBits => AddressBits, dataBits => DataBits, indexSize => indexSize, offsetSize => offsetSize)
    Port Map(   index => index, 
                offset => offset, 
                wData => wData, 
                rData => rData, 
                refill => cacheControl2CacheRefill, 
                update => cacheControl2CacheUpdate, 
                DataBlock => mem2CacheDataBlock);
    
    
    MemoryInst : Memory
    Generic Map(addressBits => AddressBits, dataBits => DataBits)
    Port Map(   addr => addr, 
                wData => wData, 
                read => cacheControl2MemRead, 
                write => cacheControl2MemWrite, 
                ready => Mem2CacheControlReady, 
                DataBlock => Mem2CacheDataBlock);


end Behavioral;
