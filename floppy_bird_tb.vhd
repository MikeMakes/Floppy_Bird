--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:32:34 12/02/2017
-- Design Name:   
-- Module Name:   /home/usuario/Floppy_Bird/floppy_bird_tb.vhd
-- Project Name:  Floppy_Bird
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: floppy_hitbox
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
 
ENTITY floppy_bird_tb IS
END floppy_bird_tb;
 
ARCHITECTURE behavior OF floppy_bird_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT floppy_hitbox
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         x : IN  unsigned(9 downto 0);
         y : IN  unsigned(9 downto 0);
         floppy_v : IN  unsigned(9 downto 0);
         floppy_pos_x : OUT  unsigned(9 downto 0);
         floppy_pos_y : OUT  unsigned(9 downto 0);
         floppy_right : OUT  unsigned(9 downto 0);
         floppy_top : OUT  unsigned(9 downto 0);
         inside_floppy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal x : unsigned(9 downto 0) := (others => '0');
   signal y : unsigned(9 downto 0) := (others => '0');
   signal floppy_v : unsigned(9 downto 0) := (others => '0');

 	--Outputs
   signal floppy_pos_x : unsigned(9 downto 0);
   signal floppy_pos_y : unsigned(9 downto 0);
   signal floppy_right : unsigned(9 downto 0);
   signal floppy_top : unsigned(9 downto 0);
   signal inside_floppy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: floppy_hitbox PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          x => x,
          y => y,
          floppy_v => floppy_v,
          floppy_pos_x => floppy_pos_x,
          floppy_pos_y => floppy_pos_y,
          floppy_right => floppy_right,
          floppy_top => floppy_top,
          inside_floppy => inside_floppy
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*20;

      -- insert stimulus here 
		rst<='1';
		en<='1';
		x<="0000000000";
		y<="0000000000";
		floppy_v<="0000010100";
		
		wait for clk_period*10;
		rst<='0';
		x<=to_unsigned(79,10);
		y<=to_unsigned(300,10);
		
		wait for clk_period*10;
		floppy_v<="0000001010";

      wait;
   end process;

END;
