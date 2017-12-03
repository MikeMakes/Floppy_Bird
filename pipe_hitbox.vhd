----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:38 12/02/2017 
-- Design Name: 
-- Module Name:    pipe_hitbox - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipe_hitbox is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           unnamed : in  STD_LOGIC;
           pipe_pos_x : out  STD_LOGIC;
           pipe_right : out  STD_LOGIC;
           pipe_pos_y : out  STD_LOGIC;
           pipe_top : out  STD_LOGIC;
           inside_pipe : out  STD_LOGIC);
end pipe_hitbox;

architecture Behavioral of pipe_hitbox is
	Signal pipe_pos_y_clone, pipe_top_clone : unsigned( 9 downto 0 );	--Signal clone, needed for reading and writing it ( floppy_pos_y is out ) 
	Constant pipe_pos_x_clone : unsigned( 9 downto 0 ) := to_unsigned(default_pos_x,10);	--X position never change for floppy
	Constant pipe_right_clone : unsigned( 9 downto 0 ) := to_unsigned(default_pos_x,10) + to_unsigned(32,10);	--So floppy's right boundary never does
	
begin
	pipe_pos_x <= pipe_pos_x_clone;
	pipe_right <= pipe_right_clone;
	
	pipe_pos_y <= pipe_pos_y_clone;
	pipe_top <= pipe_top_clone;
	
	process( rst, clk, x, y, pipe_pos_y_clone, pipe_top_clone )	--Sync. process
	begin
		if ( rst = '1') then	--Reset to initial positions
			pipe_pos_y_clone <= to_unsigned(default_pos_y,10);
			pipe_top_clone <= pipe_pos_y_clone + to_unsigned(32,10);
			inside_floppy <= '0';
			
		elsif ( rising_edge(clk) ) then		--Change possition based on floppy's "velocity"
			pipe_pos_y_clone <= pipe_pos_y_clone;
			pipe_top_clone <= pipe_pos_y_clone + to_unsigned(32,10);
			
			inside_floppy <= '0';
			
			if ( en = '1' ) then
				pipe_pos_y_clone <= pipe_pos_y_clone + floppy_v;	--Floppy pos(k+1)= floppy pos(k) + v(k);
				
				if (( pipe_pos_x_clone < x ) OR ( x < pipe_right_clone )) AND (( pipe_pos_y_clone < y ) OR ( y < pipe_top_clone )) then
					inside_pipe <= '1';	--We should be painting floppy
					
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

