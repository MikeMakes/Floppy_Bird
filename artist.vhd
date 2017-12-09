----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:31:44 12/04/2017 
-- Design Name: 
-- Module Name:    artist - Behavioral 
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

entity artist is
    Port ( --rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           --x : in  STD_LOGIC;
           --y : in  STD_LOGIC;
           inside_floppy : in  STD_LOGIC;
           inside_pipe : in  STD_LOGIC;
           R : out  UNSIGNED( 2 downto 0);
           G : out  UNSIGNED( 2 downto 0);
           B : out  UNSIGNED( 1 downto 0));
end artist;

architecture Behavioral of artist is
	Signal background : STD_LOGIC;
begin
	background <= inside_floppy NOR inside_pipe;

	process( en, inside_floppy, inside_pipe, background )
	begin
		R <= "000"; G <= "000"; B <= "00";
		if ( en = '1' ) then
			R <= "111"; G <= "111"; B <= "01"; --Whatever is YELLOW (?). IS YELLOW. I LOVE YELLOW. WE MUST LOVE YELLOW. YELLOW IS LIKE A BIG BLACK COCK.
			if ( inside_floppy = '1' ) then --Floppy is
				R <= "111"; G <= "000"; B <= "00";	--RED
			elsif ( inside_pipe = '1' ) then	--Pipes are
				R <= "000"; G <= "111"; B <= "00"; --GREEN
			elsif ( background = '1' ) then --Background is
				R <= "000"; G <= "000"; B <= "11";	--BLUE
			end if;
		end if;
	end process; --And this is a VHDL file, not a poem, go seek art in its proper form
	
end Behavioral;

