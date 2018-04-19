--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:39:05 01/29/2018
-- Design Name:   
-- Module Name:   C:/Floppy_Bird/Test-Benchs/top_game_tb.vhd
-- Project Name:  Floppy_Bird
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_game
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
 
 use ieee.std_logic_textio.all;
use std.textio.all;

ENTITY top_game_tb IS
END top_game_tb;
 
ARCHITECTURE behavior OF top_game_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_game
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         btn : IN  std_logic;
			config0:IN std_logic;
			config1:IN std_logic;
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
signal config0 : std_logic:= '0';
signal config1 : std_logic:= '0';
 	--Outputs
   signal hs : std_logic;
   signal vs : std_logic;
   signal R_out : std_logic_vector(2 downto 0);
   signal G_out : std_logic_vector(2 downto 0);
   signal B_out : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
	--sim
	signal scr : std_logic :='0';
BEGIN
	scr<= (not hs) and (not vs);
	-- Instantiate the Unit Under Test (UUT)
   uut: top_game PORT MAP (
          clk => clk,
          rst => rst,
          btn => btn,
          hs => hs,
          vs => vs,
			 config0 => config0,
			 config1 => config1,
          R_out => R_out,
          G_out => G_out,
          B_out => B_out
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
		rst<='1';
		btn<='0';
		config0<='0';
		config1<='0';
      wait for clk_period*10;
		rst<='0';
		config0<='1';
		config1<='1';
		wait for clk_period*2; 
		btn<= '0';
		config0<='1';
		config1<='1';
		wait for clk_period;
		btn <= '0';
		config0<='1';
		config1<='1';
		wait for 300 ms;
		btn<= '0';
		config0<='1';
		config1<='1';
		wait for clk_period;
		btn <= '0';
		config0<='1';
		config1<='1';
		wait for 300 ms;
		btn<= '0';
		config0<='1';
		config1<='1';
		wait for clk_period;
		btn <= '0';
      config0<='1';
		config1<='1';
		wait;
   end process;


process (clk)
    file file_pointer: text is out "txt.txt";
    variable line_el: line;
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
        write(line_el, R_out); -- write the line.

        -- Write the green
        write(line_el, " ");
        write(line_el, G_out); -- write the line.

        -- Write the blue
        write(line_el, " ");
        write(line_el, B_out); -- write the line.

        writeline(file_pointer, line_el); -- write the contents into the file.

    end if;
end process;

END;
