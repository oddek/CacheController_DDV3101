----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2020 05:38:17 PM
-- Design Name: 
-- Module Name: DesignSpecs - Behavioral
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
use IEEE.Math_real.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package DesignSpecs is
    constant Byte : Integer := 8; --(2^3)
    constant Kibi : Integer := 1024; --(2^10)
    constant Word : Integer := 32; --(2^5)
    constant BlockSize : Integer := 4 * Word; --128 (2^7)
    constant CacheSizeBits : Integer := 16 * Kibi * Byte; --16KiB
    constant CacheBlockSize : Integer := CacheSizeBits / BlockSize; --1024 (2^10) 
    constant AddressBits : Integer := 32 * byte; --32 Bytes
    constant ValidBitSize : Integer := 1;
    constant DirtyBitSize : Integer := 1;
    constant N : Integer := Integer(log2(Real(CacheBlockSize))); --10
    constant M : Integer := Integer(log2(Real(BlockSize/Word))); -- 2
    
    constant DataBits : Integer := 8;
    constant indexSize : Integer := N;
    constant tagSize : Integer := 32 - (n + m + 2); 
    
    constant offsetSize : Integer := 2;
end DesignSpecs;

