----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:31:18 10/25/2017 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counter is
	Generic ( MAXSAT : INTEGER :=1024 );
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  sync_rst : in STD_LOGIC;
           en : in  STD_LOGIC;
           sat : out  STD_LOGIC;
			  count : out UNSIGNED ( 9 downto 0 ));
end counter;

architecture Behavioral of counter is
	Signal next_value, value : UNSIGNED ( 9 downto 0 );
	begin
	
	comb: process (en, value)
	begin
		sat <= '0';
		next_value <= value;
		if ( en = '1' ) then
				next_value <= value+1;
				if ( value = MAXSAT ) then
					sat <= '1';
					next_value <= to_unsigned(0,10);
				end if;			
		end if;
	end process comb;
	
	sync: process (clk, rst)
	begin
		if ( rst = '1' ) then
			value <= to_unsigned(0,10);	
		elsif rising_edge(clk) then
			value <= next_value;
			if sync_rst = '1' then
				value <= to_unsigned(0,10);
			end if;
		end if;
	end process sync;
	
	count <= value;

end Behavioral;

