--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:16:02 12/03/2017
-- Design Name:   
-- Module Name:   /home/usuario/Floppy_Bird/insider_tb.vhd
-- Project Name:  Floppy_Bird
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: insider
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
 
ENTITY insider_tb IS
END insider_tb;
 
ARCHITECTURE behavior OF insider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT insider
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         hit0_pos_x : IN  unsigned(9 downto 0);
         hit0_pos_y : IN  unsigned(9 downto 0);
         hit0_right : IN  unsigned(9 downto 0);
         hit0_top : IN  unsigned(9 downto 0);
         hit1_pos_x : IN  unsigned(9 downto 0);
         hit1_pos_y : IN  unsigned(9 downto 0);
         hit1_right : IN  unsigned(9 downto 0);
         hit1_top : IN  unsigned(9 downto 0);
         x : IN  unsigned(9 downto 0);
         y : IN  unsigned(9 downto 0);
         inside_hit0 : OUT  std_logic;
         inside_hit1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal hit0_pos_x : unsigned(9 downto 0) := (others => '0');
   signal hit0_pos_y : unsigned(9 downto 0) := (others => '0');
   signal hit0_right : unsigned(9 downto 0) := (others => '0');
   signal hit0_top : unsigned(9 downto 0) := (others => '0');
   signal hit1_pos_x : unsigned(9 downto 0) := (others => '0');
   signal hit1_pos_y : unsigned(9 downto 0) := (others => '0');
   signal hit1_right : unsigned(9 downto 0) := (others => '0');
   signal hit1_top : unsigned(9 downto 0) := (others => '0');
   signal x : unsigned(9 downto 0) := (others => '0');
   signal y : unsigned(9 downto 0) := (others => '0');

 	--Outputs
   signal inside_hit0 : std_logic;
   signal inside_hit1 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: insider PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          hit0_pos_x => hit0_pos_x,
          hit0_pos_y => hit0_pos_y,
          hit0_right => hit0_right,
          hit0_top => hit0_top,
          hit1_pos_x => hit1_pos_x,
          hit1_pos_y => hit1_pos_y,
          hit1_right => hit1_right,
          hit1_top => hit1_top,
          x => x,
          y => y,
          inside_hit0 => inside_hit0,
          inside_hit1 => inside_hit1
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

      wait for clk_period*10;

      -- insert stimulus here 
		    rst <= '1';
          en <= '1';
          hit0_pos_x <= "0000000000";
          hit0_pos_y <= "0000000000";
          hit0_right <= "0000000000" + to_unsigned(32,10);
          hit0_top <= "0000000000" + to_unsigned(32,10);
          hit1_pos_x <= "0011001000";
          hit1_pos_y <= "0011001000";
          hit1_right <= "0011001000" + to_unsigned(32,10);
          hit1_top <= "0011001000" + to_unsigned(32,10);
          x <= "0000000001";
          y <= "0000000001";
		wait for clk_period*10; --inside hit1
			rst <= '0';
		
		wait for clk_period*10; --inside nothing
			 x <= "0001100100";
          y <= "0001100100";
			 
		wait for clk_period*10; --inside hit2
			x <= "0011001001";
         y <= "0011001001";
			
			
      wait;
   end process;

END;
