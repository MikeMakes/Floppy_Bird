--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:40:05 12/20/2017
-- Design Name:   
-- Module Name:   /home/usuario/Desktop/test1/inside_fl0ppy_tb.vhd
-- Project Name:  test1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: inside_fl0ppy
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
USE ieee.numeric_std.ALL;
 
ENTITY inside_fl0ppy_tb IS
END inside_fl0ppy_tb;
 
ARCHITECTURE behavior OF inside_fl0ppy_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT inside_fl0ppy
    PORT(
         x : IN  unsigned(9 downto 0);
         y : IN  unsigned(9 downto 0);
         pos_x : IN  unsigned(9 downto 0);
         pos_y : IN  unsigned(9 downto 0);
         right : IN  unsigned(9 downto 0);
         top : IN  unsigned(9 downto 0);
         inside : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal x : unsigned(9 downto 0) := to_unsigned(0,10);
   signal y : unsigned(9 downto 0) := to_unsigned(0,10);
   signal pos_x : unsigned(9 downto 0) := to_unsigned(0,10);
   signal pos_y : unsigned(9 downto 0) := to_unsigned(0,10);
   signal right : unsigned(9 downto 0) := to_unsigned(0,10);
   signal top : unsigned(9 downto 0) := to_unsigned(0,10);

 	--Outputs
   signal inside : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: inside_fl0ppy PORT MAP (
          x => x,
          y => y,
          pos_x => pos_x,
          pos_y => pos_y,
          right => right,
          top => top,
          inside => inside
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
		x <= to_unsigned(50,10);
		y <= to_unsigned(50,10);
		pos_x <= to_unsigned(0,10);
		pos_y <= to_unsigned(32,10);
		right <= to_unsigned(32,10);
		top <= to_unsigned(0,10);
		
		wait for 100 ns;
		x <= to_unsigned(5,10);
		y <= to_unsigned(5,10);

		wait for 100 ns;
		x <= to_unsigned(5,10);
		y <= to_unsigned(50,10);

		wait for 100 ns;
		x <= to_unsigned(50,10);
		y <= to_unsigned(5,10);

		wait for 100 ns;
		x <= to_unsigned(50,10);
		y <= to_unsigned(50,10);
		
      wait;
   end process;

END;
