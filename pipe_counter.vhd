----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:51 01/21/2018 
-- Design Name: 
-- Module Name:    pipe_counter - Behavioral 
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

entity pipe_counter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  floppy_right : in UNSIGNED ( 9 downto 0 );
			  pipe_right : in UNSIGNED ( 9 downto 0 );
			  count : out UNSIGNED ( 9 downto 0 ));
end pipe_counter;

architecture Behavioral of pipe_counter is
	Signal next_value, value : UNSIGNED ( 9 downto 0 );
begin
	
	comb: process ( value, floppy_right, pipe_right)
	begin
		next_value <= value;
		if ( floppy_right = pipe_right ) then
			next_value <= value+1;
		end if;			
	end process comb;
	
	sync: process (clk, rst)
	begin
		if ( rst = '1' ) then
			value <= to_unsigned(0,10);	
		elsif rising_edge(clk) then
			value <= next_value;
		end if;
	end process sync;
	
	count <= value;

end Behavioral;

