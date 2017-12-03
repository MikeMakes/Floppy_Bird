----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:16:48 12/03/2017 
-- Design Name: 
-- Module Name:    insider - Behavioral 
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

entity insider is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           hit0_pos_x : in  UNSIGNED (9 downto 0);
           hit0_pos_y : in  UNSIGNED (9 downto 0);
           hit0_right : in  UNSIGNED (9 downto 0);
           hit0_top : in  UNSIGNED (9 downto 0);
           hit1_pos_x : in  UNSIGNED (9 downto 0);
           hit1_pos_y : in  UNSIGNED (9 downto 0);
           hit1_right : in  UNSIGNED (9 downto 0);
           hit1_top : in  UNSIGNED (9 downto 0);
           x : in  UNSIGNED (9 downto 0);
           y : in  UNSIGNED (9 downto 0);
           inside_hit0 : out  STD_LOGIC;
           inside_hit1 : out  STD_LOGIC);
end insider;

architecture Behavioral of insider is
	Signal sel, inside : STD_LOGIC;
	--Signal hit2comp_pos_x, hit2comp_right, hit2comp_pos_y, hit2comp_top : UNSIGNED ( 9 downto 0 ); --Just a worse code reminiscence (tho we have to investigate it)
	
begin

	inside_hit0 <= inside AND not sel;
	inside_hit1 <= inside AND sel;

	comb:process( sel, x, y )
		Variable hit2comp_pos_x, hit2comp_right, hit2comp_pos_y, hit2comp_top : UNSIGNED ( 9 downto 0 ); --Is this better than signals? I think so	
	begin
		hit2comp_pos_x := hit0_pos_x;
		hit2comp_right := hit0_right;
		hit2comp_pos_y := hit0_pos_y;
		hit2comp_top := hit0_top;
		if ( sel = '1' ) then
			hit2comp_pos_x := hit1_pos_x;
			hit2comp_right := hit1_right;
			hit2comp_pos_y := hit1_pos_y;
			hit2comp_top := hit1_top;
		end if;
		if ( (( hit2comp_pos_x < x ) AND ( x < hit2comp_right )) AND (( hit2comp_pos_y < y ) AND ( y < hit2comp_top )) ) then
			inside <= '1';	--Inside the hitbox <sel>
		end if;
	end process;
	
	sync:process( clk, rst )
	begin
		if ( rst = '1' ) then
			sel <= '0';
		elsif ( rising_edge(clk) ) then
			sel <= sel;
			if ( en = '1' ) then
				sel <= NOT sel;
			end if;
		end if;
	end process;

end Behavioral;

