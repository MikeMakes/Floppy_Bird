--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:49:19 12/02/2017
-- Design Name:   
-- Module Name:   /home/usuario/Floppy_Bird/pipe_hitbox.vhd
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
--USE ieee.numeric_std.ALL;
 
ENTITY pipe_hitbox IS
END pipe_hitbox;
 
ARCHITECTURE behavior OF pipe_hitbox IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT floppy_hitbox
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         floppy_v : IN  std_logic_vector(9 downto 0);
         floppy_pos_x : OUT  std_logic_vector(9 downto 0);
         floppy_pos_y : OUT  std_logic_vector(9 downto 0);
         floppy_right : OUT  std_logic_vector(9 downto 0);
         floppy_top : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal floppy_v : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal floppy_pos_x : std_logic_vector(9 downto 0);
   signal floppy_pos_y : std_logic_vector(9 downto 0);
   signal floppy_right : std_logic_vector(9 downto 0);
   signal floppy_top : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: floppy_hitbox PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          floppy_v => floppy_v,
          floppy_pos_x => floppy_pos_x,
          floppy_pos_y => floppy_pos_y,
          floppy_right => floppy_right,
          floppy_top => floppy_top
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

      wait;
   end process;

END;
