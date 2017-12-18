----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:58 12/05/2017 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
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

entity fsm is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
			  button: in STD_LOGIC;
           hs : out STD_LOGIC;
           vs : out STD_LOGIC;
           R_out : out  STD_LOGIC_VECTOR(2 downto 0);
           G_out : out STD_LOGIC_VECTOR(2 downto 0);
           B_out : out STD_LOGIC_VECTOR(1 downto 0));
end fsm;

architecture Behavioral of fsm is

COMPONENT counter is
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
end COMPONENT;

COMPONENT floppy_hitbox is
	Generic( default_pos_x : INTEGER := 79; 
				default_pos_y : INTEGER := 300);
    Port ( clk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  en : in STD_LOGIC;
			  x : in unsigned ( 9 downto 0 );
			  y : in unsigned ( 9 downto 0 );
           floppy_v : in  unsigned ( 9 downto 0 );	--Floppy's "velocity"
           floppy_pos_x : out  unsigned ( 9 downto 0 );	--Floppy x position / Floppy's left hitbox boundary
           floppy_pos_y : out  unsigned ( 9 downto 0 );	--Floppy y position / Floppy's bottom hitbox boundary
			  floppy_right : out unsigned( 9 downto 0 );	--Floppy 's right hitbox boundary
			  floppy_top : out unsigned( 9 downto 0 );	--Floppy 's top hitbox boundary
			  inside_floppy : out STD_LOGIC);	--The VGA coordinates are in the hitbox
end COMPONENT;

COMPONENT pipe_hitbox is
	Generic( default_pos_x : INTEGER := 639;
				default_pos_y : INTEGER := 259; 
				default_gap : INTEGER := 80);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           x : in  unsigned( 9 downto 0 );
           y : in  unsigned( 9 downto 0 );
           pipe_v : in  unsigned( 9 downto 0 ); --Debug purposed, pipe_vel is actually non variable, it should be a generic
           pipe_pos_x : out  unsigned( 9 downto 0 );
           pipe_right : out  unsigned( 9 downto 0 );
           pipe_pos_y : out  unsigned( 9 downto 0 );
           pipe_top : out  unsigned( 9 downto 0 );
           inside_pipe : out  STD_LOGIC);
end COMPONENT;

COMPONENT artist is
    Port ( --rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           --x : in  STD_LOGIC;
           --y : in  STD_LOGIC;
           inside_floppy : in  STD_LOGIC;
           inside_pipe : in  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR( 2 downto 0);
           G : out  STD_LOGIC_VECTOR( 2 downto 0);
           B : out  STD_LOGIC_VECTOR( 1 downto 0));
end COMPONENT;

COMPONENT screener is
    Port ( in_scn_H : in  STD_LOGIC;	--blank_h.	%IF blank_H and blanck_V == 1 => all '0'.	
           in_scn_V : in  STD_LOGIC;	--blank_v.	
           R : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input red (color mux)
			  G : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input green (color mux)
           B : in  STD_LOGIC_VECTOR(1 downto 0);	--rgb input blue (color mux)
           red_out : out  STD_LOGIC_VECTOR(2 downto 0);	--rgb outnput red
           blue_out : out STD_LOGIC_VECTOR(1 downto 0);	--rgb output blue
           green_out : out  STD_LOGIC_VECTOR(2 downto 0));	--rgb input gren
end COMPONENT;

--Freq dividider stuff
Signal clk_pixel, next_clk_pixel : STD_LOGIC;

--FSM related signals
--Type states is (stop, run);
--Signal state : states;

--Wires (the signals, not the magazine)
Signal blank_h, blank_v, h_sat, v_enable : STD_LOGIC;
signal x,y : UNSIGNED ( 9 downto 0 );

signal floppy_v, floppy_pos_x, floppy_right, floppy_pos_y, floppy_top : UNSIGNED ( 9 downto 0 );
signal inside_floppy : STD_LOGIC;

signal pipe_v, pipe_pos_x, pipe_right, pipe_pos_y, pipe_top : UNSIGNED ( 9 downto 0 );
signal inside_pipe : STD_LOGIC;

signal R: STD_LOGIC_VECTOR(2 downto 0);
signal G: STD_LOGIC_VECTOR(2 downto 0);
signal B: STD_LOGIC_VECTOR(1 downto 0);


begin

	floppy_v <= to_unsigned(10,10);
	pipe_v <= to_unsigned(10,10);

	h_counter : counter
		Generic Map(Nbit => 10,
						End_Of_Screen => 639,
						Start_Of_Pulse =>655, 
						End_Of_Pulse => 751,
						End_Of_Line => 799)
	 
		Port Map ( clk => clk,
						reset => rst,
						enable => en,
						pulse_screen => hs,	--Connected to HS and VS in top module.
						in_screen => blank_h,	--Draw screen	
						end_screen => h_sat,		--Reset counter
						Q => x);
						
						
	v_enable <= h_sat AND clk_pixel;
	v_counter : counter
		Generic Map(Nbit => 10,
						End_Of_Screen =>639,
						Start_Of_Pulse =>655, 
						End_Of_Pulse => 751,
						End_Of_Line =>799)
		Port Map ( clk => clk,
						reset => rst,
						enable => v_enable,
						pulse_screen => vs,	--Connected to HS and VS in top module.
						in_screen => blank_v,	--Draw screen	
						end_screen => open,		--Reset counter
						Q => y);

	floppy : floppy_hitbox
		Generic Map( default_pos_x  => 79,
						default_pos_y  => 300)
		Port Map( clk => clk,
					rst => rst,
					en => en,
					x => x,
					y => y,
					floppy_v => floppy_v,	--Floppy's "velocity"
					floppy_pos_x => floppy_pos_x,	--Floppy x position / Floppy's left hitbox boundary
					floppy_pos_y => floppy_pos_y,	--Floppy y position / Floppy's bottom hitbox boundary
					floppy_right => floppy_right,	--Floppy 's right hitbox boundary
					floppy_top => floppy_top,	--Floppy 's top hitbox boundary
					inside_floppy => inside_floppy);	--The VGA coordinates are in the hitbox

	pipe : pipe_hitbox
		Generic Map( default_pos_x  => 639,
						default_pos_y  => 259, 
						default_gap  => 80 )
    Port Map( clk => clk,
           rst => clk,
           en => en,
           x => x,
           y => y,
           pipe_v => pipe_v, --Debug purposed, pipe_vel is actually non variable, it should be a generic
           pipe_pos_x => pipe_pos_x,
           pipe_right => pipe_right,
           pipe_pos_y => pipe_pos_y,
           pipe_top => pipe_top,
           inside_pipe => inside_pipe);
			  
	dali : artist
	    Port Map( --rst : in  STD_LOGIC;
           en => en,
           --x : in  STD_LOGIC;
           --y : in  STD_LOGIC;
           inside_floppy => inside_floppy,
           inside_pipe => inside_pipe,
           R => R,
           G => G,
           B => B);
			  
	vga : screener
	    Port Map( in_scn_H => blank_h,	--blank_h
           in_scn_V => blank_v,	--blank_v.	
           R => R,	--rgb input red 
           G => G,	--rgb input blue
			  B => B,	--rgb input green
           red_out => R_out,	--rgb outnput red
           blue_out => B_out,	--rgb output blue
           green_out => G_out);	--rgb input gren

	next_clk_pixel <= not clk_pixel;
	pixel_freq:process( clk, rst )
	begin
		if ( rst = '1' ) then
			clk_pixel <= '0' ;
		elsif ( rising_edge(clk) ) then
			clk_pixel <= next_clk_pixel;
		end if;
	end process;

--	fsm:process(button)
--	begin
--		case state is
--			when stop =>
--				en <= '0';
--			
--				state <= stop;				
--				if ( button = '1' ) then
--					state <= run;
--				end if;
--				
--			when run =>
--				en <= '1';
--			
--				state <= stop;
--				if ( button = '1' ) then
--					state <= run;
--				end if;
--				
--			when others =>
--				state <= stop;
--		end case;
--	end process fsm;

end Behavioral;

