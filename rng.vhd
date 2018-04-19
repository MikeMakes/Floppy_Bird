library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rng is	--Pseudo Random Number Generator
	Port ( clk : in STD_LOGIC;
			rst : in STD_LOGIC;									--Async reset
			seed : in STD_LOGIC_VECTOR( 9 downto 0);		--We start getting random numbers from this
			random : out STD_LOGIC_VECTOR ( 9 downto 0));--Output
end rng;

architecture Behavioral of rng is
	signal number, next_number : STD_LOGIC_VECTOR( 9 downto 0);
begin

	random <= number;

	comb:process( number)	--10 bit Shift register re-alimented with xor gate
	begin
		next_number(8 downto 0) <= number (9 downto 1);
		next_number(9) <= number(4) XOR number(0);
	end process comb;

	sync:process ( clk, rst, seed)
	begin
		if (rst = '1') then	--We start from a seed
			number <= seed;
		elsif ( rising_edge(clk) ) then
			number <= next_number;
		end if;
	end process sync;

end Behavioral;

