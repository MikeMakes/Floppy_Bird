--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:28:46 12/21/2017
-- Design Name:   
-- Module Name:   /home/usuario/Desktop/test1/pipe_hitbox_tb.vhd
-- Project Name:  test1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pipe_hitbox
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
 
ENTITY pipe_hitbox_tb IS
END pipe_hitbox_tb;
 
ARCHITECTURE behavior OF pipe_hitbox_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pipe_hitbox
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         pipe_v : IN  unsigned(9 downto 0);
         pipe_pos_x : OUT  unsigned(9 downto 0);
         pipe_pos_y : OUT  unsigned(9 downto 0);
         pipe_right : OUT  unsigned(9 downto 0);
         pipe_top : OUT  unsigned(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal pipe_v : unsigned(9 downto 0) := to_unsigned(10,10);

 	--Outputs
   signal pipe_pos_x : unsigned(9 downto 0);
   signal pipe_pos_y : unsigned(9 downto 0);
   signal pipe_right : unsigned(9 downto 0);
   signal pipe_top : unsigned(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipe_hitbox PORT MAP (
          clk => clk,
          rst => rst,
          pipe_v => pipe_v,
          pipe_pos_x => pipe_pos_x,
          pipe_pos_y => pipe_pos_y,
          pipe_right => pipe_right,
          pipe_top => pipe_top
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
		pipe_v <= to_unsigned(10,10);
		
		wait for clk_period*10;
		rst <= '0';
		
		wait for clk_period*10;
		pipe_v <= to_unsigned(100,10);
		
		wait for clk_period*10;
		rst <= '1';
		
      wait;
   end process;

END;
