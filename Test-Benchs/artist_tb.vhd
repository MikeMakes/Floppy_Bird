--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:57:55 12/20/2017
-- Design Name:   
-- Module Name:   /home/usuario/Desktop/test1/artist_tb.vhd
-- Project Name:  test1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: artist
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
 
ENTITY artist_tb IS
END artist_tb;
 
ARCHITECTURE behavior OF artist_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT artist
    PORT(
         en : IN  std_logic;
         inside_floppy : IN  std_logic;
         inside_pipe : IN  std_logic;
         R : OUT  std_logic_vector(2 downto 0);
         G : OUT  std_logic_vector(2 downto 0);
         B : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal en : std_logic := '0';
   signal inside_floppy : std_logic := '0';
   signal inside_pipe : std_logic := '0';

 	--Outputs
   signal R : std_logic_vector(2 downto 0);
   signal G : std_logic_vector(2 downto 0);
   signal B : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 --  constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: artist PORT MAP (
          en => en,
          inside_floppy => inside_floppy,
          inside_pipe => inside_pipe,
          R => R,
          G => G,
          B => B
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for 100 ns;

      -- insert stimulus here 
		en <= '0';
		inside_floppy <= '0';
		inside_pipe <= '0';
		
		wait for 100 ns;
		en <= '1';

		wait for 100 ns;
		inside_floppy <= '1';

		wait for 100 ns;
		inside_floppy <= '0';
		inside_pipe <= '1';
		
		wait for 100 ns;
		inside_floppy <= '1';

		wait for 100 ns;
		en <= '0';
		
      wait;
   end process;

END;
