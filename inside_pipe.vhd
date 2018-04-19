library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inside_pipe is
    Port ( x : in unsigned ( 9 downto 0 );--Cursor actual position
			  y : in unsigned ( 9 downto 0 );
           pos_x : in  unsigned ( 9 downto 0 );	--PIPE x position / PIPE's left hitbox boundary
           pos_y : in  unsigned ( 9 downto 0 );	--PIPE y position / Upper pipe aperture
			  right : in unsigned( 9 downto 0 );	--PIPE 's right hitbox boundary
			  top : in unsigned( 9 downto 0 );	--Below PIPE aperture
			  inside : out STD_LOGIC;	--The VGA coordinates are in the hitbox
			  index : out unsigned ( 11 downto 0));--Memory addres
end inside_pipe;

architecture Behavioral of inside_pipe is
	Signal index_clone : unsigned ( 11 downto 0 ) := to_unsigned(0,12);
	Signal x_index : unsigned ( 11 downto 0 ) := to_unsigned(0,12);
	Signal y_index : unsigned ( 11 downto 0 ) := to_unsigned(0,12);
	Signal top_y_index : unsigned ( 11 downto 0 );
	Signal bot_y_index : unsigned ( 11 downto 0 );
begin

	top_y_index <= ("00" & (pos_y-y)); 	--Index for top pipe
	bot_y_index <= ("00" & (y-top));		--Index for bottom pipe
	x_index <= ("00" & (x-pos_x));		--X index
	index_clone<=x_index+y_index;			--Memory address index
	
	y_indx:process(y, top, top_y_index, bot_y_index )	--Check if we should be painting top pipe or bottom pipe
	begin
		if (y<top) then	--Top pipe
			y_index <= shift_left(unsigned(to_unsigned(32,12)-top_y_index),6); --Y index = (Image height-(top pipe y -y))x64 	|64=2^6
			if (top_y_index > to_unsigned(32,12)) then	--If cursor is in the pipe but not in the image area
				y_index <= to_unsigned(0,12);					--Paint the first address
			end if;
		else					--Bot pipe
			y_index <= shift_left(unsigned(bot_y_index),6)+to_unsigned(2048,12);	--Y index = ((y- bottom pipe y)x64)+2048 (Bottom pipe image is consecutive to Top pipe image in memory, each one is 2048 length [32x64])
			if (bot_y_index > 32) then				--If cursor is in the pipe but not in the image area
				y_index <= to_unsigned(4096,12);	--Paint the first address
			end if;
		end if;
	end process y_indx;
	
	comb:process( index_clone, x, y, pos_x, right, pos_y, top )	--"Is the cursor inside the pipe?"
	begin
		inside <= '0';
		index <= to_unsigned(0,12);	--2x(32x64pixels) Images managed from the same ip requires larger address (12 bits) 
		if ( ((pos_x < x or pos_x > to_unsigned(960,10))AND x < right) AND ( y < pos_y OR top < y ) )  then --Cursor inside pipe. Note: "or pos_x > to_unsigned(960,10)"; If pipe is in the left screen limit we paint it until it passes completly the x=0 coordinate
			inside <= '1';				--We should be painting pipes	
			index <= index_clone;	--Index is "000000000000" unless we have to paint pipes
		end if;
	end process comb;

end Behavioral;


