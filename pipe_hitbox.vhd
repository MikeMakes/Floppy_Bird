library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipe_hitbox is --Pipes movement and shape
	Generic( default_pos_x : INTEGER := 500; default_pos_y : INTEGER := 100; default_gap : INTEGER := 128); --Defaults values on reset and gap beetween top and bot pipes
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;	--Async reset
			  sr	: in STD_LOGIC;	--Screen refresh
			  rnd_number : in STD_LOGIC_VECTOR (9 DOWNTO 0);	--Random number (used to randomize the position of the gap)
           pipe_v : in  unsigned ( 9 downto 0 );	--Pipe's speed
           pipe_pos_x : out  unsigned ( 9 downto 0 );	--Pipe x position / Pipe's left hitbox boundary
           pipe_pos_y : out  unsigned ( 9 downto 0 );	--Pipe y position / Pipe's bottom hitbox boundary
			  pipe_right : out unsigned( 9 downto 0 );	--Pipe's right hitbox boundary
			  pipe_top : out unsigned( 9 downto 0 ));	--Pipe's top hitbox boundary
			  
end pipe_hitbox;

architecture Behavioral of pipe_hitbox is
	Signal n_pipe_right : UNSIGNED ( 9 downto 0 ) := to_unsigned(default_pos_x+64,10);	--Next pipe right boundary
	Signal a_pipe_right : UNSIGNED ( 9 downto 0 ) := to_unsigned(default_pos_x+64,10);	--Actual pipe right boundary
	Signal n_pipe_pos_y : UNSIGNED ( 9 downto 0 ) := to_unsigned(default_pos_y,10);		--Next top pipe bottom boundary
	Signal a_pipe_pos_y : UNSIGNED ( 9 downto 0 ) := to_unsigned(default_pos_y,10);		--Actual top pipe bottom boundary
	
begin
	--Pipe dimensions;
	pipe_right <= a_pipe_right;	--X dimensions are defined from the right boundary so its easier make it dissapear smoothly
	pipe_pos_x <= a_pipe_right - to_unsigned(64,10);	--64 pixel width
	pipe_pos_y <= a_pipe_pos_y;
	pipe_top <= a_pipe_pos_y + to_unsigned(default_gap,10);
	
	comb: process ( sr, a_pipe_right, a_pipe_pos_y, pipe_v, rnd_number ) --Movement
	begin
		n_pipe_right <= a_pipe_right;
		n_pipe_pos_y <= a_pipe_pos_y;
		if ( sr = '1' ) then  --Every screen refresh...
			n_pipe_right <= a_pipe_right - pipe_v; --pipe moves "pipe_v" pixels to the left
			if (a_pipe_right="0000000000") then	--If pipe has reached left screen limit
				n_pipe_pos_y <= unsigned(rnd_number);	--Determine the new (random) pos y (Get a diffetent gap)
			end if;
		end if;
	end process comb;

	sync: process ( clk, rst, a_pipe_right, a_pipe_pos_y, pipe_v )
	begin
		if ( rst = '1' ) then	--Async rst
			a_pipe_right <= to_unsigned(default_pos_x+64,10);	--Default values on reset
			a_pipe_pos_y <= to_unsigned(default_pos_y,10);
		elsif ( rising_edge(clk) ) then	--Update pos x and y
			a_pipe_pos_y <= n_pipe_pos_y;
			a_pipe_right <= n_pipe_right;
		end if;
	end process sync;

end Behavioral;

