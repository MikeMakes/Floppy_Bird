----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:28:53 12/19/2017 
-- Design Name: 
-- Module Name:    inside_fl0ppy - Behavioral 
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

entity inside_fl0ppy is
    Port ( --clk : in  STD_LOGIC;
			  --rst : in STD_LOGIC;
			  --en : in STD_LOGIC;
			  x : in unsigned ( 9 downto 0 );
			  y : in unsigned ( 9 downto 0 );
           pos_x : in  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           pos_y : in  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  right : in unsigned( 9 downto 0 );	--Floppy 's right hitbox boundary
			  top : in unsigned( 9 downto 0 );	--Floppy 's top hitbox boundary
			  inside : out STD_LOGIC);	--The VGA coordinates are in the hitbox
end inside_fl0ppy;

architecture Behavioral of inside_fl0ppy is
begin
	comb:process( x, y, pos_x, pos_y, right, top )
	begin
		inside <= '0';
		if (( pos_x < x ) AND ( x < right )) AND (( pos_y > y ) AND ( y > top )) then
			inside <= '1';	--We should be painting floppy	
		end if;
	end process comb;

end Behavioral;

