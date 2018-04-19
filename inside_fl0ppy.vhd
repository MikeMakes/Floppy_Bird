library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity inside_fl0ppy is
    Port ( x : in unsigned ( 9 downto 0 );--Cursor actual position
			  y : in unsigned ( 9 downto 0 );
           pos_x : in  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           pos_y : in  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  right : in unsigned( 9 downto 0 );	--Floppy 's right hitbox boundary
			  top : in unsigned( 9 downto 0 );	--Floppy 's top hitbox boundary
			  inside : out STD_LOGIC;	--The VGA coordinates are in the hitbox
			  index : out unsigned ( 9 downto 0));--Memory addres
end inside_fl0ppy;

architecture Behavioral of inside_fl0ppy is
	Signal index_clone : unsigned ( 9 downto 0 ) := to_unsigned(0,10);
	Signal x_index : unsigned ( 9 downto 0 ) := to_unsigned(0,10);
	Signal y_index : unsigned ( 9 downto 0 ) := to_unsigned(0,10);
begin
	--Memory address index
	x_index <= x-pos_x;
	y_index <= shift_left(unsigned(y-top),5);	-- Y position x32 (2^5)
	index_clone<=x_index+y_index;
	--Is the cursor in floppy?
	comb:process( index_clone, x, y, pos_x, pos_y, right, top )
	begin
		inside <= '0';
		index <= to_unsigned(0,10);
		if (( pos_x < x ) AND ( x < right )) AND (( top < y ) AND ( y < pos_y )) then
			inside <= '1';			--We should be painting floppy..
			index <= index_clone;--with the RGB values stored in this memory address
		end if;
	end process comb;

end Behavioral;

