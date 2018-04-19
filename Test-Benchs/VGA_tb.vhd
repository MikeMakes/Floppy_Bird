--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:35:22 12/16/2017
-- Design Name:   
-- Module Name:   /home/usuario/Desktop/Sist. Electronicos/P2_cdc/VGA_tb.vhd
-- Project Name:  P2_cdc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: VGA
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

-- Uncomment the following library declaration if you want to
-- write VGA values to a file for simulation, simulator here;
-- http://ericeastwood.com/blog/8/vga-simulator-getting-started
use ieee.std_logic_textio.all;
use std.textio.all;
 
ENTITY VGA_tb IS
END VGA_tb;
 
ARCHITECTURE behavior OF VGA_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT VGA
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         dir_raquet : IN  std_logic;
         HS : OUT  std_logic;
         VS : OUT  std_logic;
         RED_out : OUT  std_logic_vector(2 downto 0);
         GRN_out : OUT  std_logic_vector(2 downto 0);
         BLUE_out : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal dir_raquet : std_logic := '0';

 	--Outputs
   signal HS : std_logic;
   signal VS : std_logic;
   signal RED_out : std_logic_vector(2 downto 0);
   signal GRN_out : std_logic_vector(2 downto 0);
   signal BLUE_out : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
	
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: VGA PORT MAP (
          clk => clk,
          rst => rst,
          dir_raquet => dir_raquet,
          HS => HS,
          VS => VS,
          RED_out => RED_out,
          GRN_out => GRN_out,
          BLUE_out => BLUE_out
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
		dir_raquet <= '1';
		wait for clk_period*10;
		rst <= '0';
		
		wait on VS until VS ='1';
		dir_raquet <= '0';
		
		wait on VS until VS ='1';
		dir_raquet <= '1';
		
		wait on VS until VS ='1';
		rst <= '1';
		dir_raquet <= '0';
		
      wait;
   end process;

	vga_values : process (clk)
    file file_pointer: text is out "write.txt";
    variable line_el: LINE;
	begin

    if rising_edge(clk) then

        -- Write the time
        write(line_el, now); -- write the line.
        write(line_el, ":"); -- write the line.

        -- Write the hsync
        write(line_el, " ");
        write(line_el, HS); -- write the line.

        -- Write the vsync
        write(line_el, " ");
        write(line_el, VS); -- write the line.

        -- Write the red
        write(line_el, " ");
        write(line_el, RED_out); -- write the line.

        -- Write the green
        write(line_el, " ");
        write(line_el, GRN_out); -- write the line.

        -- Write the blue
        write(line_el, " ");
        write(line_el, BLUE_out); -- write the line.

        writeline(file_pointer, line_el); -- write the contents into the file.

    end if;
	end process;

END;
