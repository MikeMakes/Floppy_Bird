LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY screener_tb IS
END screener_tb;
 
ARCHITECTURE behavior OF screener_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT screener
    PORT(
         in_scn_H : IN  std_logic;
         in_scn_V : IN  std_logic;
         red_mux : IN  std_logic_vector(2 downto 0);
         blue_mux : IN  std_logic_vector(1 downto 0);
         green_mux : IN  std_logic_vector(2 downto 0);
         red_out : OUT  std_logic_vector(2 downto 0);
         blue_out : OUT  std_logic_vector(1 downto 0);
         green_out : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in_scn_H : std_logic := '0';
   signal in_scn_V : std_logic := '0';
   signal red_mux : std_logic_vector(2 downto 0) := (others => '0');
   signal blue_mux : std_logic_vector(1 downto 0) := (others => '0');
   signal green_mux : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal red_out : std_logic_vector(2 downto 0);
   signal blue_out : std_logic_vector(1 downto 0);
   signal green_out : std_logic_vector(2 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: screener PORT MAP (
          in_scn_H => in_scn_H,
          in_scn_V => in_scn_V,
          red_mux => red_mux,
          blue_mux => blue_mux,
          green_mux => green_mux,
          red_out => red_out,
          blue_out => blue_out,
          green_out => green_out
        );


	estimulos: process
	begin	
		wait for 200 ns;
		in_scn_H<= '1';
		in_scn_V<= '0';
		red_mux <= "111";
		green_mux <= "111";
		blue_mux <= "11";
		wait for 50 ns;
		in_scn_H<= '0';
		in_scn_V<= '1';
		red_mux <= "001";
		green_mux <= "101";
		blue_mux <= "00";
		wait for 150 ns;
		--aqui debe pintar
		in_scn_H<= '1';	
		in_scn_V<= '1';
		red_mux <= "111";
		green_mux <= "000";
		blue_mux <= "11";
		wait for 50 ns;
		in_scn_H<= '0';
		in_scn_V<= '0';
		red_mux <= "111";
		green_mux <= "111";
		blue_mux <= "11";
		wait for 150 ns;
		in_scn_H<= '1';
		in_scn_V<= '1';
		red_mux <= "001";
		green_mux <= "111";
		blue_mux <= "00";
		wait for 100 ns;
		in_scn_H<= '0';
		in_scn_V<= '0';
		red_mux <= "001";
		green_mux <= "111";
		blue_mux <= "00";
		wait for 100 ns;
		in_scn_H<= '1';
		in_scn_V<= '1';
		red_mux <= "001";
		green_mux <= "111";
		blue_mux <= "00";
		wait for 100 ns;
		in_scn_H<= '0';
		in_scn_V<= '0';
		red_mux <= "001";
		green_mux <= "111";
		blue_mux <= "00";
		wait;
		

   end process;

END;
