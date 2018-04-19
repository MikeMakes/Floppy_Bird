library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA is
	Port (	clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				R : in STD_LOGIC_VECTOR ( 2 downto 0 );
				G : in STD_LOGIC_VECTOR ( 2 downto 0 );
				B : in STD_LOGIC_VECTOR ( 1 downto 0 );
				x_out : out UNSIGNED ( 9 downto 0 );
				y_out : out UNSIGNED ( 9 downto 0 );
				screen_refresh : out STD_LOGIC;
				HS	: out STD_LOGIC;
				VS : out STD_LOGIC;
				RED_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
				GRN_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
				BLUE_out : out STD_LOGIC_VECTOR ( 1 downto 0 ) );
end VGA;

architecture Behavioral of VGA is
------------------------COMPONENT DECLARATION-----------------------
	component counter
		Generic ( MAXSAT : INTEGER :=67108863 );
		Port ( 	clk : in  STD_LOGIC;
					rst : in  STD_LOGIC;
					sync_rst : in STD_LOGIC;
					en : in  STD_LOGIC;
					sat : out  STD_LOGIC;
					count : out UNSIGNED ( 9 downto 0 ));
	end component counter;
	
	component comparator
		Generic (	End_Of_Screen: integer :=10;
						Start_Of_Pulse: integer :=20;
						End_Of_Pulse: integer := 30;
						End_Of_Line: integer := 40);
		Port ( 	clk : in STD_LOGIC;
					rst : in STD_LOGIC;
					data : in UNSIGNED ( 9 downto 0 );
					O1 : out STD_LOGIC;
					O2 : out STD_LOGIC);
	end component comparator;

---------------------------SIGNAL DECLARATION-------------------------	
Signal en_cont_v, sync_rst_cont_h, sync_rst_cont_v : STD_LOGIC;
Signal x,y : UNSIGNED ( 9 downto 0 );
Signal Blank_H, Blank_V : STD_LOGIC;

--Freq dividider stuff
Signal clk_pixel, next_clk_pixel : STD_LOGIC;

begin
	
	x_out <= x;
	y_out <= y;
	
	en_cont_v <= clk_pixel AND sync_rst_cont_h;
	screen_refresh <= sync_rst_cont_v;
	
	counter_h: counter
		Generic Map ( MAXSAT => 799 )
		Port Map (	clk => clk,
						rst => rst,
						sync_rst => sync_rst_cont_h,
						en => clk_pixel,
						sat => sync_rst_cont_h,
						count => x);
						
	counter_v: counter
		Generic Map ( MAXSAT => 520 )
		Port Map (	clk => clk,
						rst => rst,
						sync_rst => sync_rst_cont_v,
						en => en_cont_v,
						sat => sync_rst_cont_v,
						count => y);
						
	comp_h: comparator
		Generic Map (	End_Of_Screen => 639, 
							Start_Of_Pulse => 655, 
							End_Of_Pulse => 751, 
							End_Of_Line => 799 )
		Port Map (	clk  => clk,
					rst  => rst,
					data  => x,
					O1  => Blank_H,
					O2  => HS);

	comp_v: comparator
		Generic Map (	End_Of_Screen => 479,
							Start_Of_Pulse => 489,
							End_Of_Pulse => 491,
							End_Of_Line => 520 )
		Port Map(	clk  => clk,
						rst  => rst,
						data  => y,
						O1  => Blank_V,
						O2  => VS );

-----FRECUENCY DIVISOR TO OBTAIN A 25MHz FRECUENCY.------
	next_clk_pixel <= not clk_pixel;
	div_frec:process( clk, rst )
	begin
		if ( rst='1' ) then
			clk_pixel <= '0';
		elsif ( rising_edge(clk) ) then
		clk_pixel <= next_clk_pixel;
		end if;
	end process;

	color: process( Blank_H, Blank_V, R, G, B )
	begin
		if (Blank_H='1' or Blank_V='1') then
			RED_out<=(others => '0');
			GRN_out<=(others => '0');
			BLUE_out<=(others => '0');
		else
			RED_out<=R; 
			GRN_out<=G;
			BLUE_out<=B;
		end if;
	end process;


end Behavioral;

