----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:24 12/01/2017 
-- Design Name: 
-- Module Name:    floppy_hitbox - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity floppy_hitbox is
	Generic( default_pos_x : INTEGER := 79; default_pos_y : INTEGER := 300);
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  en : in STD_LOGIC;
			  x : in unsigned ( 9 downto 0 );
			  y : in unsigned ( 9 downto 0 );
           floppy_v : in  unsigned ( 9 downto 0 );	--Floppy's "velocity"
           floppy_pos_x : out  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           floppy_pos_y : out  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  floppy_right : out unsigned( 9 downto 0 );	--Floppy 's right hitbox boundary
			  floppy_top : out unsigned( 9 downto 0 );	--Floppy 's top hitbox boundary
			  inside_floppy : out STD_LOGIC);	--The VGA coordinates are in the hitbox
end floppy_hitbox;

architecture Behavioral of floppy_hitbox is
	Signal floppy_pos_x_clone, floppy_right_clone, floppy_pos_y_clone, floppy_top_clone : unsigned( 9 downto 0 );	--Signal clone, needed for reading and writing it ( floppy_pos_y is out ) 
	--x position could be constants
	
begin
	floppy_pos_x <= floppy_pos_x_clone;
	floppy_right <= floppy_right_clone;
	
	floppy_pos_y <= floppy_pos_y_clone;
	floppy_top <= floppy_top_clone;
	
	process( rst, clk, x, y )	--Sync. process
	begin
		if ( rst = '1') then	--Reset to initial positions
			floppy_pos_x_clone <= to_unsigned(default_pos_x,10);
			floppy_right_clone <= floppy_pos_x_clone + to_unsigned(32,10);
			floppy_pos_y_clone <= to_unsigned(default_pos_y,10);
			floppy_top_clone <= floppy_pos_y_clone + to_unsigned(32,10);
			inside_floppy <= '0';
			
		elsif ( rising_edge(clk) ) then		--Change possition based on floppy's "velocity"
			floppy_pos_y_clone <= floppy_pos_y_clone;
			floppy_top_clone <= floppy_pos_y_clone + to_unsigned(32,10);
			
			inside_floppy <= '0';
			
			if ( en = '1' ) then
				floppy_pos_y_clone <= floppy_pos_y_clone + floppy_v;	--Floppy pos(k+1)= floppy pos(k) + v(k);
				
				if (( floppy_pos_x_clone < x ) OR ( x < floppy_right_clone )) AND (( floppy_pos_y_clone < y ) OR ( y < floppy_top_clone )) then
					inside_floppy <= '1';	--We should be painting floppy
					
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

