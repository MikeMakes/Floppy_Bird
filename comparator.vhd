library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
	Generic (End_Of_Screen: integer :=10;
				Start_Of_Pulse: integer :=20;
				End_Of_Pulse: integer := 30;
				End_Of_Line: integer := 40);
	Port (clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			data : in UNSIGNED ( 9 downto 0 );
			O1 : out STD_LOGIC;
			O2 : out STD_LOGIC);
end comparator;

architecture Behavioral of comparator is
Signal P1, Q1, P2, Q2 : STD_LOGIC;
begin

	O1 <= Q1;
	O2 <= Q2;

	comb: process ( data )
	begin
		P1 <= '0';
		P2 <= '1';
		if ( data > End_Of_Screen ) then
			P1 <= '1';
		end if;
		if ( data > Start_Of_Pulse ) and ( data < End_Of_Pulse ) then
			P2 <= '0';
		end if;
	end process comb;
		
	sync: process ( clk, rst )
	begin
		if ( rst = '1') then
			Q1 <= '0';
			Q2 <= '1';
		elsif rising_edge( clk ) then
			Q1 <= P1;
			Q2 <= P2;
		end if;
	end process sync;

end Behavioral;

