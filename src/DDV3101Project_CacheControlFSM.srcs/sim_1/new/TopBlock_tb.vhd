----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2020 08:25:54 AM
-- Design Name: 
-- Module Name: TopBlock_tb - Behavioral
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

entity TopBlock_tb is
--  Port ( );
end TopBlock_tb;

architecture Behavioral of TopBlock_tb is

    signal clk, ready, operation, readOrWrite : STD_LOGIC;
    signal rData, wData, addr : STD_LOGIC_VECTOR(31 downto 0);

    constant clk_period : time := 10 ns;

    signal address0 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(1, 28)) & "0000";
    signal address1 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(2, 28)) & "0000";
    signal address2 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(5, 28)) & "0000";


    constant writeData1 : std_logic_vector(31 downto 0) := "00001111000011110000111100001111";

    component TopBlock is
    Port (  clk :       in STD_LOGIC := '1';
            ready : out STD_LOGIC := '1';
            operation : in STD_LOGIC := '0';
            rData :     out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');--(Word-1 downto 0);
            addr :      in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');--(AddressBits-1 downto 0);
            wData :     in STD_LOGIC_VECTOR (31 downto 0):= (others => '0');--(Word-1 downto 0);
            readOrWrite :      in STD_LOGIC);
end component TopBlock;



begin
    UUT: TopBlock
    Port Map(    clk => clk, ready => ready, operation => operation, readOrWrite => readOrWrite,
                rData => rData, wData => wData, addr => addr);
                
    
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    
    stim_proc : process
    begin
    --Read from addr0: MISS, 
        wait for clk_period*4;
        readOrWrite <= '0';
        
        wait for clk_period*4;
        addr <= address0;

        operation <= '1';
        
        wait until ready = '1';
        operation <= '0';
        report "JackPot!";
        
    --Read from addr0: HIT
        wait for clk_period*4;
        addr <= address0;

        operation <= '1';
        
        wait until ready = '1';
        operation <= '0';
        
        
    --Write 1 to addr1: MISS, NOT DIRTY
        wait for clk_period*4;
        addr <= address1;
        wData <= writeData1;
        
        readOrWrite <= '1';
        operation <= '1';
        wait until ready = '1';
        operation <= '0';
        
        
        
    --Read from addr1: HIT
        wait for clk_period*4;
        addr <= address1;

        readOrWrite <= '0';
        operation <= '1';
        
        wait until ready = '1';
        operation <= '0';
        
    --read from addr2: MISS
        wait for clk_period*4;
        addr <= address2;

        operation <= '1';
        
        wait until ready = '1';
        operation <= '0';
        
    
        
        

        
    
        wait;
    end process;

end Behavioral;
