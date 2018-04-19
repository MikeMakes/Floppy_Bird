--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:57:30 01/02/2018
-- Design Name:   
-- Module Name:   C:/Documents and Settings/Marco Montes/Escritorio/FloppyBird_async/Floppy_Bird_ayncr/fsm_async_tb.vhd
-- Project Name:  Floppy_Bird
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fsm
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fsm_async_tb IS
END fsm_async_tb;
 
ARCHITECTURE behavior OF fsm_async_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_game
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         btn : IN  std_logic;
         hs : OUT  std_logic;
         vs : OUT  std_logic;
         R_out : OUT  std_logic_vector(2 downto 0);
         G_out : OUT  std_logic_vector(2 downto 0);
         B_out : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal btn : std_logic := '0';

 	--Outputs
   signal hs : std_logic;
   signal vs : std_logic;
   signal R_out : std_logic_vector(2 downto 0);
   signal G_out : std_logic_vector(2 downto 0);
   signal B_out : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_game PORT MAP (
          clk => clk,
          rst => rst,
          btn => btn,
          hs => hs,
          vs => vs,
          R_out => R_out,
          G_out => G_out,
          B_out => B_out
        );

 
 -- 5. Generar los estimulos
	clk <= not clk after 50 ns;
	
	estimulos: process
	begin	
		rst <= '1';
		btn <= '0';
		wait for 100 ns;
		rst <= '0';
		btn <= '0';
		wait for 200 ms;
		btn <= '1';
		rst <= '0';
		wait for 10000 ns;
		btn <= '0';
		rst <= '0';
		wait;
	end process;	  

END;