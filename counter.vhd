library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity counter is
	Generic (Nbit: INTEGER := 10;
	 End_Of_Screen: INTEGER := 639; 
	 Start_Of_Pulse: INTEGER := 655; 
	 End_Of_Pulse: INTEGER := 751;
	 End_Of_Line: INTEGER := 799);
	 
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
			  pulse_screen : out STD_LOGIC;	--Connected to HS and VS in top module.
			  in_screen : out STD_LOGIC;	--Draw screen	
			  end_screen : out STD_LOGIC;		--Reset counter
           Q : out  unsigned (Nbit-1 downto 0));
end counter;

architecture Behavioral of counter is

signal p_cont,cont : unsigned(Nbit-1 downto 0);
begin
	Q <= cont;

	comb:process(cont,enable)
		begin
			p_cont <= cont;
			in_screen <='1';
			pulse_screen <='0';
			end_screen <='0';
				if (enable = '1') then
					p_cont <= cont+1;
					
					if (cont > to_unsigned(End_Of_Screen,Nbit)) then
						in_screen<= '1';
					end if;
					if ((cont > to_unsigned(Start_Of_Pulse,Nbit)) AND (cont < to_unsigned(End_Of_Pulse,Nbit))) then
						pulse_screen <= '0';
					end if;
					if (cont = to_unsigned(End_Of_Line,Nbit)) then
						end_screen <= '1';
						p_cont <= (others => '0');
					end if;
				end if;
	end process;		
		
	sinc: process(clk,reset)
		begin
			if (reset='1') then
				cont <= (others =>'0');
			elsif (rising_edge(clk)) then
				cont <= p_cont;
			end if;
		end process;
end Behavioral;