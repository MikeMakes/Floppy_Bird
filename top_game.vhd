library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_game is
    Port ( clk : in  STD_LOGIC;	--Clock (External clock on pin M6)
           rst : in  STD_LOGIC;	--Async reset
			  btn : in STD_LOGIC;	--Jump button
           hs : out STD_LOGIC;	--VGA synchronize signals
           vs : out STD_LOGIC;
			  config0 :in STD_LOGIC;	--Switch=1; Increase pipes speed
			  config1 : in STD_LOGIC;	--Switch=0; Hide pipes
           R_out : out  STD_LOGIC_VECTOR(2 downto 0);	--RGB outputs
           G_out : out STD_LOGIC_VECTOR(2 downto 0);
           B_out : out STD_LOGIC_VECTOR(1 downto 0));
end top_game;

architecture Behavioral of top_game is

------------------------COMPONENT DECLARATION-----------------------
COMPONENT VGA is	--Driver VGA
	Port (	clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				R : in STD_LOGIC_VECTOR ( 2 downto 0 );	--RGB to paint on pixel x_out,y_out
				G : in STD_LOGIC_VECTOR ( 2 downto 0 );	
				B : in STD_LOGIC_VECTOR ( 1 downto 0 );
				x_out : out UNSIGNED ( 9 downto 0 );		--Actual cursor position
				y_out : out UNSIGNED ( 9 downto 0 );
				screen_refresh : out STD_LOGIC;				-- ='1' every screen refresh
				HS	: out STD_LOGIC;								--VGA synchronize signals
				VS : out STD_LOGIC;
				RED_out : out STD_LOGIC_VECTOR ( 2 downto 0 );--RGB outputs
				GRN_out : out STD_LOGIC_VECTOR ( 2 downto 0 );
				BLUE_out : out STD_LOGIC_VECTOR ( 1 downto 0 ) );
end COMPONENT;

COMPONENT inside_fl0ppy is	--Check that x,y (cursor) are inside floppy
    Port ( x : in unsigned ( 9 downto 0 );		--Actual cursor position
			  y : in unsigned ( 9 downto 0 );
           pos_x : in  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           pos_y : in  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  right : in unsigned( 9 downto 0 );	--Floppy's right hitbox boundary
			  top : in unsigned( 9 downto 0 );		--Floppy's top hitbox boundary
			  inside : out STD_LOGIC;					-- ='1' when cursor are inside floppy
			  index : out unsigned ( 9 downto 0));	--Memory address index
end COMPONENT;

COMPONENT rng is	--Pseudo Random NUmber Generator
	Port ( clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			seed : in STD_LOGIC_VECTOR( 9 downto 0);
			random : out STD_LOGIC_VECTOR ( 9 downto 0));	--Random output 
END COMPONENT rng;

COMPONENT pipe_hitbox is	--This blocks defines the shape and the movement of pipes
	Generic( default_pos_x : INTEGER := 639;	--Position x at reset
				default_pos_y : INTEGER := 190; 	--Position y at reset
				default_gap : INTEGER := 128);	--Gap beetween upper and bottom pipes at reset
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  sr	: in	STD_LOGIC;					--Screen Refresh
			  rnd_number : in STD_LOGIC_VECTOR (9 DOWNTO 0);	--Random number input, determines new pipe gap
           pipe_v : in  unsigned( 9 downto 0 ); 				--Speed of pipe
           pipe_pos_x : out  unsigned( 9 downto 0 );			--Pipe x position / Pipe's left hitbox boundary
           pipe_pos_y : out  unsigned( 9 downto 0 );			--Pipe y position / Upper pipe's bottom hitbox boundary
           pipe_right : out  unsigned( 9 downto 0 );			--Pipe's right hitbox boundary
           pipe_top : out  unsigned( 9 downto 0 ));			--Bottom pipe's top hitbox boundary
end COMPONENT;

COMPONENT inside_pipe is	--Check that x,y (cursor) are inside floppy
    Port ( x : in unsigned ( 9 downto 0 );		--Actual cursor position
			  y : in unsigned ( 9 downto 0 );
           pos_x : in  unsigned ( 9 downto 0 );	--PIPE x position / PIPE's left hitbox boundary
           pos_y : in  unsigned ( 9 downto 0 );	--PIPE y position / Upper pipe aperture
			  right : in unsigned( 9 downto 0 );	--Pipe's right hitbox boundary
			  top : in unsigned( 9 downto 0 );		--Bottom pipe's top hitbox boundary
			  inside : out STD_LOGIC;	--The VGA coordinates are in the hitbox
			  index : out unsigned ( 11 downto 0)); --Memory addres
end COMPONENT;

COMPONENT artist is
    Port ( clk :in STD_LOGIC;
				en : in  STD_LOGIC;							--Enable='0'; RGB<="000 000 00"
           inside_floppy : in  STD_LOGIC;				--Cursor is in floppy
           inside_pipe : in  STD_LOGIC;				--Cursor is in some pipe (we dont care which one since the addres index is managed from process indx)
			  y : in unsigned ( 9 downto 0 );			--Cursor Y position (used to draw the background)
			  pipe_index : in unsigned(11 downto 0);	--Output of ROM with the image
			  floppy_index : in unsigned(9 downto 0);	--Output of ROM with the image
           R : out  STD_LOGIC_VECTOR( 2 downto 0);	--Vga driver input
           G : out  STD_LOGIC_VECTOR( 2 downto 0);
           B : out  STD_LOGIC_VECTOR( 1 downto 0));
end COMPONENT;

---------------------------SIGNAL DECLARATION-------------------------
--FSM related signals;
Type states is (reset, sleep, fly_up, mv_floppy, update_v, dead);
Signal state,n_state : states;

Constant gravity : INTEGER :=1;
Signal p_flying,flying: STD_LOGIC;	--Is floppy flying?
signal btn_last : STD_LOGIC;			--Used to store the previous value of button
SIGNAL INSIDE_PIPES : STD_LOGIC;		--Inside some pipe
signal smashed, smashed0, smashed1, smashed2 : STD_LOGIC; --Floppy smashed into some pipe (0,1or2) 

signal floppy_v, floppy_pos_y, floppy_top : UNSIGNED ( 9 downto 0 );	--Floppys boundarys and speed
signal p_floppy_v, p_floppy_pos_y : UNSIGNED ( 9 downto 0 );			--Nexts Floppys boundarys
signal in_floppy : STD_LOGIC;			--1 when cursor is inside floppy
constant floppy_pos_x : UNSIGNED ( 9 downto 0 ) := to_unsigned(100,10);	--Floppy x position
constant floppy_right : UNSIGNED ( 9 downto 0 ) := to_unsigned(132,10);	-- (100+32)
signal floppy_index : unsigned (9 downto 0);		--Floppy memory address index

--Pipes Signals;
Signal rnd_number : STD_LOGIC_VECTOR ( 9 downto 0 );
Signal pipes_indexs : unsigned ( 11 downto 0);
Signal pipe_v : UNSIGNED ( 9 downto 0 ) := to_unsigned(1,10); --Speed of pipes
--Pipe 0 
signal pipe_pos_x, pipe_right, pipe_pos_y, pipe_top : UNSIGNED (9 downto 0); --Pipe 0 boundarys
signal in_pipe0 : STD_LOGIC;	--Cursor inside pipe 0
signal pipe0_index : unsigned ( 11 downto 0);	--Pipe 0 memory address index
--Pipe 1
signal pipe1_pos_x, pipe1_right, pipe1_pos_y, pipe1_top : UNSIGNED (9 downto 0);
signal in_pipe1 : STD_LOGIC;
signal pipe1_index : unsigned ( 11 downto 0);
--Pipe 2
signal pipe2_pos_x, pipe2_right, pipe2_pos_y, pipe2_top : UNSIGNED (9 downto 0);
signal in_pipe2 : STD_LOGIC;
signal pipe2_index : unsigned ( 11 downto 0);

--Wires (the signals, not the magazine)
signal x,y : UNSIGNED ( 9 downto 0 );	--Actual position of cursor
signal screen_refresh : STD_LOGIC;		-- ='1' Every time screen refresh

--RGB to paint
signal R: STD_LOGIC_VECTOR(2 downto 0);
signal G: STD_LOGIC_VECTOR(2 downto 0);
signal B: STD_LOGIC_VECTOR(1 downto 0);

begin
---------------------------COMPONENTS INSTANCES-------------------------
	driver : VGA	--VGA driver
	Port Map(clk => clk,
				rst => rst,
				R => R,
				G => G,
				B => B,
				x_out => x,	--Cursor position
				y_out => y,
				screen_refresh => screen_refresh,	-- ='1' Every time screen refresh
				HS	=> HS,
				VS => VS,
				RED_out => R_out,
				GRN_out => G_out,
				BLUE_out => B_out);
	
	ins_floppy : inside_fl0ppy
		Port Map(x => x,
					y => y,
					pos_x => floppy_pos_x,	--Floppy x position / Floppy's left hitbox boundary
					pos_y => floppy_pos_y,	--Floppy y position / Floppy's bottom hitbox boundary
					right => floppy_right,	--Floppy 's right hitbox boundary
					top =>	floppy_top,		--Floppy 's top hitbox boundary
					inside => in_floppy,		--The cursor is in the hitbox
					index => floppy_index);	--Memory address index
				  
	random:rng	--Pseudo random number generator
	Port Map	(	clk => clk,
					rst => rst,
					seed => "0010001010",
					random => rnd_number);
				  
	ins_pipe0 : inside_pipe	--Is the cursor inside pipe 0?
		Port Map(x => x,
					y => y,
					pos_x => pipe_pos_x,
					pos_y => pipe_pos_y,
					right => pipe_right,
					top =>	pipe_top,
					inside => in_pipe0,	-- Yes ='1'
					index => pipe0_index);
					
	ins_pipe1 : inside_pipe
		Port Map(x => x,
					y => y,
					pos_x => pipe1_pos_x,
					pos_y => pipe1_pos_y,
					right => pipe1_right,
					top =>	pipe1_top,
					inside => in_pipe1,	
					index => pipe1_index);
					
	ins_pipe2 : inside_pipe
		Port Map(x => x,
					y => y,
					pos_x => pipe2_pos_x,
					pos_y => pipe2_pos_y,
					right => pipe2_right,
					top =>	pipe2_top,
					inside => in_pipe2,	
					index => pipe2_index);

	pipe0 : pipe_hitbox	--Pipe 0 movement, shape and position
		Generic Map( default_pos_x  => 342,	--Default position on reset
						default_pos_y  => 300, 
						default_gap  => 150)
    Port Map( clk => clk,
           rst => rst,
			  sr => screen_refresh,
			  rnd_number => rnd_number,
           pipe_v => pipe_v,
           pipe_pos_x => pipe_pos_x,
           pipe_pos_y => pipe_pos_y,
           pipe_right => pipe_right,		  
           pipe_top => pipe_top);
			  
	pipe1 : pipe_hitbox	--Pipe 1 movement, shape and position
		Generic Map( default_pos_x  => 682,
						default_pos_y  => 190, 
						default_gap  => 150)
    Port Map( clk => clk,
           rst => rst,
			  sr => screen_refresh,
			  rnd_number => rnd_number,
           pipe_v => pipe_v, 
           pipe_pos_x => pipe1_pos_x,
           pipe_pos_y => pipe1_pos_y,
           pipe_right => pipe1_right,		  
           pipe_top => pipe1_top);
			  
	pipe2 : pipe_hitbox	--Pipe 2 movement, shape and position
		Generic Map( default_pos_x  => 959,	--THE GAME USE THIS GENERICS!!
						default_pos_y  => 50, 
						default_gap  => 150)
    Port Map( clk => clk,
           rst => rst,
			  sr => screen_refresh,
			  rnd_number => rnd_number,
           pipe_v => pipe_v, 
           pipe_pos_x => pipe2_pos_x,
           pipe_pos_y => pipe2_pos_y,
           pipe_right => pipe2_right,		  
           pipe_top => pipe2_top);

	inside_pipes<=(in_pipe0 or in_pipe1 or in_pipe2) and config1; --Inside some pipe (deactivable with config1 input so we can stop painting pipes)
	indx:process(in_pipe0, in_pipe1, in_pipe2, pipe0_index, pipe1_index, pipe2_index)
	begin	--The memory address index passed to artist is the one from the pipe we should be painting
		pipes_indexs<=pipe0_index;	--Default case, might be any pipe__index or to_unsigned(0,12)
		if (in_pipe0 = '1') then	--If cursor is in pipe0
			pipes_indexs <= pipe0_index;	--Pipe Memory address index to artist is the index of pipe0
		elsif (in_pipe1 = '1') then	--So on...
			pipes_indexs <= pipe1_index;
		elsif (in_pipe2 = '1') then
			pipes_indexs <= pipe2_index;
		end if;
	end process indx;
			  
	dali : artist	--This block paint the screen
		Port Map(clk => clk,
					en => '1',	--We could stop drawing using this signal (when en='0' the screen is black)
					inside_floppy => in_floppy,	--Inside floppy
					inside_pipe => inside_pipes,	--Inside some pipe
					y => y,
					pipe_index => pipes_indexs,	--Memory address indexs
					floppy_index => floppy_index,
					R => R,		--RGB values to paint
					G => G,
					B => B);
					
	cvelpipe:process(config0)	--Speed of pipes
	begin
		pipe_v<=to_unsigned(1,10);	--Default speed
		if config0='1' then
			pipe_v<=to_unsigned(3,10);	--3x speed when config0='1'
		end if;
	end process;
	
	smashed <= smashed0 OR smashed1 OR smashed2;	--Check if floppy crash against some pipe
	smash:process(floppy_top, floppy_pos_y, pipe_pos_x, pipe_right, pipe_pos_y, pipe_top, pipe1_pos_x, pipe1_right, pipe1_pos_y, pipe1_top, pipe2_pos_x, pipe2_right, pipe2_pos_y, pipe2_top)
	begin
		smashed0 <= '1';	--By default we suppose floppy crashed into pipes
		smashed1 <= '1';	--Sry floppy
		smashed2 <= '1';
		if ((floppy_right<pipe_pos_x) OR (floppy_pos_x>pipe_right) OR (floppy_top>pipe_pos_y AND floppy_pos_y<pipe_top))then
			smashed0 <= '0';	--Check that floppy is in a free-pipe region of space
		end if;
		if ((floppy_right<pipe1_pos_x) OR (floppy_pos_x>pipe1_right) OR (floppy_top>pipe1_pos_y AND floppy_pos_y<pipe1_top))then
			smashed1 <= '0';
		end if;
		if ((floppy_right<pipe2_pos_x) OR (floppy_pos_x>pipe2_right) OR (floppy_top>pipe2_pos_y AND floppy_pos_y<pipe2_top))then
			smashed2 <= '0';
		end if;
	end process smash;

sync: process(rst,clk, btn)
	begin
		if( rst='1' ) then	--Async reset
			state <= reset;	--Default values;
			flying <= '0';		--Not flying
			floppy_v <= to_unsigned(gravity,10);	--Falling
			floppy_pos_y <= to_unsigned(100,10);	--Reset floppy pos y
			floppy_top <= floppy_pos_y - to_unsigned(32,10);
		elsif ( rising_edge(clk) ) then	--FSM change state
			state <= n_state;
			flying <= p_flying;
			floppy_v <= p_floppy_v;
			floppy_pos_y <= p_floppy_pos_y;
			floppy_top <= p_floppy_pos_y - to_unsigned(32,10);
			btn_last <= btn;
		end if;
	end process;	

---------------------------FINITE STATES MACHINE-------------------------
	comb:process (state, btn,btn_last, screen_refresh, flying, floppy_v, floppy_pos_y, floppy_top, pipe_pos_x, pipe_right, pipe_pos_y, pipe_top, smashed)
	begin	
		p_floppy_pos_y <= floppy_pos_y;
		p_flying <= flying;
		p_floppy_v <= floppy_v;
		
		case state is
		
			--Does nothing until player jumps OR screen is refreshed --
			when sleep =>
				n_state <= sleep;	--Next state = Sleep (This state)
				
				if ( btn ='1' AND flying ='0' AND btn_last='0') then	--(Button pressed AND floppy falling down):
					n_state <= fly_up;	--Next state = Jump
				end if;
				if ( screen_refresh = '1' ) then	--(Screen refreshed):
					n_state <= mv_floppy;	--Next state = Update floppy's position (move floppy along Y axis)
				
				end if;
				
			--Jump--
			when fly_up =>	
				p_flying <='1';	--Floppy is going up (flying)
				p_floppy_v <= to_unsigned(13,10);	--Update floppy's Y axis velocity 
				n_state <= sleep;	--Next state = Sleep
			
			--Update floppy's position (move floppy along Y axis)--
			when mv_floppy =>
				if (floppy_pos_y >= 419 OR 5 >= floppy_pos_y ) OR smashed='1' then
					n_state <= dead;
				else
				
					if ( flying ='1' ) then	--(Floppy is going up):
						p_floppy_pos_y <= floppy_pos_y - floppy_v;	--Floppy goes up (Minus velocity because y=0 is the top)
					else
						p_floppy_pos_y <= floppy_pos_y + floppy_v;	--Floppy falls down (Plus velocity because y=0 is the top)
					end if;
	
				n_state <= update_v;	--Next state = Update Floppy's Y axis velocity
				end if;
			
			--If Floppy touch ground, up limit or pipes is dead.
			when dead =>
				n_state <= dead;
				p_flying <= '0';
				p_floppy_v <= (others => '0');
				p_floppy_pos_y <= to_unsigned(100,10);
				
				if (btn='1') then
					n_state <= sleep;
				end if;
			
			--Update Floppy's Y axis velocity--
			when update_v =>
				p_flying <= '0';	--Floppy is falling until proven it is flying up
				
				if ( flying ='1' ) then --(Floppy is going up):
				
					if ( floppy_v > to_unsigned(gravity,10) ) then	--(Floppy's velocity is greater than "gravity"): [Floppy proven it is flying up]
						p_floppy_v <= floppy_v - to_unsigned(gravity,10);	--Floppy's Y axis velocity -= 3
						p_flying <='1';	--Floppy continues her flight
					else
						p_floppy_v <= to_unsigned(0,10);	--Floppy is in this jump highest point (velocity=0)
						p_flying <= '0';	--Floppy is not flying anymore
					end if;
				else
					p_floppy_v <= to_unsigned(gravity,10)+floppy_v;
				end if;
				n_state <= sleep;	--Next state = Sleep
			
			--Default case ( Reset here )--
			when others =>
				p_floppy_pos_y <= to_unsigned(79,10);
				p_floppy_v <= to_unsigned(0,10);
				n_state <= sleep;
				
			end case;
		end process;	--THE (FSM) END

end Behavioral;