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
	Generic( default_pos_x : INTEGER := 639; default_pos_y : INTEGER := 259; default_gap : INTEGER := 80 );
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           pipe_vel : in  STD_LOGIC; --Debug purposed, pipe_vel is actually non variable, it should be a generic
           pipe_pos_x : out  STD_LOGIC;
           pipe_right : out  STD_LOGIC;
           pipe_pos_y : out  STD_LOGIC;
           pipe_top : out  STD_LOGIC;
           inside_pipe : out  STD_LOGIC);
end pipe_hitbox;

architecture Behavioral of pipe_hitbox is
	Signal pipe_pos_y_clone, pipe_top_clone : unsigned( 9 downto 0 );	--Signal clone, needed for reading and writing it ( floppy_pos_y is out ) 
	Constant pipe_pos_y_clone : unsigned( 9 downto 0 ) := to_unsigned(default_pos_y,10);	--Y position never change for pipes (for now)
	Constant pipe_top_clone : unsigned( 9 downto 0 ) := to_unsigned(default_pos_y,10) - to_unsigned(default_gap,10);	--So pipe's top (bottom-pipe top) boundary never does
	
begin
	pipe_pos_x <= pipe_pos_x_clone;
	pipe_right <= pipe_right_clone;
	
	pipe_pos_y <= pipe_pos_y_clone;
	pipe_top <= pipe_top_clone;
	
	process( rst, clk, x, y, pipe_pos_x_clone, pipe_right_clone )	--Sync. process
	begin
		if ( rst = '1') then	--Reset to initial positions
			pipe_pos_x_clone <= to_unsigned(default_pos_x,10);
			pipe_right_clone <= pipe_pos_x_clone + to_unsigned(64,10);
			inside_pipe <= '0';
			
		elsif ( rising_edge(clk) ) then		--
			pipe_pos_x_clone <= pipe_pos_x_clone;
			pipe_right_clone <= pipe_pos_x_clone - to_unsigned(default_gap,10);
			
			inside_pipe <= '0';
			
			if ( en = '1' ) then
				pipe_pos_x_clone <= pipe_pos_x_clone + unnamed;	--
				
				if (( pipe_pos_x_clone < x ) AND ( x < pipe_right_clone )) AND (( pipe_pos_y_clone < y ) AND ( y < pipe_top_clone )) then
					inside_pipe <= '1';	--We should be painting pipes
					
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

