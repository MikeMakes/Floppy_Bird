library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity screener is
    Port ( in_scn_H : in  STD_LOGIC;	--blank_h.
           in_scn_V : in  STD_LOGIC;	--blank_v.	
           R : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input red 
			  G : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input green
           B : in  STD_LOGIC_VECTOR(1 downto 0);	--rgb input blue
           red_out : out  STD_LOGIC_VECTOR(2 downto 0);	--rgb output red
           blue_out : out STD_LOGIC_VECTOR(1 downto 0);	--rgb output blue
           green_out : out  STD_LOGIC_VECTOR(2 downto 0));	--rgb input gren
end screener;

architecture Behavioral of screener is

begin

	draw: process( in_scn_H, in_scn_V, R, G, B )
	begin
		if (in_scn_H = '1' OR in_scn_V='1') then
			red_out <= "000";
			blue_out <=  "00";
			green_out <=  "000";
		else
			red_out <= R;
			green_out <= G;
			blue_out <=  B;
		end if;
	end process;
end Behavioral;
