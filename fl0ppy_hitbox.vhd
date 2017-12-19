----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:00 12/19/2017 
-- Design Name: 
-- Module Name:    fl0ppy_hitbox - Behavioral 
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

entity fl0ppy_hitbox is
	Generic( default_pos_x : INTEGER := 79; default_pos_y : INTEGER := 300);
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  en : in STD_LOGIC;
           floppy_v : in  unsigned ( 9 downto 0 );	--Floppy's "velocity"
           floppy_pos_x : out  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           floppy_pos_y : out  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  floppy_right : out unsigned( 9 downto 0 );	--Floppy 's right hitbox boundary
			  floppy_top : out unsigned( 9 downto 0 ));	--Floppy 's top hitbox boundary

end fl0ppy_hitbox;

architecture Behavioral of fl0ppy_hitbox is
	Signal a_floppy_pos_y, n_floppy_pos_y : UNSIGNED ( 9 downto 0 );
	
begin
	floppy_pos_x <= to_unsigned(default_pos_x,10);
	floppy_right <= to_unsigned(default_pos_x,10) + to_unsigned(32,10);
	floppy_pos_y <= a_floppy_pos_y;
	floppy_top <= a_floppy_pos_y  + to_unsigned(32,10);
	
	comb: process( en, a_floppy_pos_y, floppy_v)
	begin
		n_floppy_pos_y <= a_floppy_pos_y + floppy_v;
		
		if ( en = '0' ) then
			n_floppy_pos_y <= a_floppy_pos_y;
		end if;
	end process comb;

	sync: process( clk, rst, n_floppy_pos_y )
	begin
		if ( rst = '1') then
			a_floppy_pos_y <= to_unsigned(default_pos_y,10);
		elsif ( rising_edge(clk) ) then
			a_floppy_pos_y <= n_floppy_pos_y;
		end if;
	end process sync;
end Behavioral;

