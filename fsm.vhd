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
           vs : out STD_LOGIC;
           hs : out STD_LOGIC;
           r : out  UNSIGNED(9 downto 0);
           g : out UNSIGNED(9 downto 0);
           b : out UNSIGNED(9 downto 0));
end fsm;

architecture Behavioral of fsm is

COMPONENT floppy_hitbox is
	Generic( default_pos_x : INTEGER := 79; default_pos_y : INTEGER := 300);
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
	Generic( default_pos_x : INTEGER := 639; default_pos_y : INTEGER := 259; default_gap : INTEGER := 80 );
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           pipe_vel : in  STD_LOGIC; --Debug purposed, pipe_vel is actually non variable, it should be a generic
           pipe_pos_x : out  STD_LOGIC;
           pipe_right : out  STD_LOGIC;
           pipe_pos_y : out  STD_LOGIC;
           pipe_top : out  STD_LOGIC;
           inside_pipe : out  STD_LOGIC);
end COMPONENT;

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
           Q : out  STD_LOGIC_VECTOR (Nbit-1 downto 0));
end COMPONENT;

COMPONENT artist is
    Port ( --rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           --x : in  STD_LOGIC;
           --y : in  STD_LOGIC;
           inside_floppy : in  STD_LOGIC;
           inside_pipe : in  STD_LOGIC;
           R : out  UNSIGNED( 2 downto 0);
           G : out  UNSIGNED( 2 downto 0);
           B : out  UNSIGNED( 1 downto 0));
end COMPONENT;

COMPONENT screener is
    Port ( in_scn_H : in  STD_LOGIC;	--blank_h.	%IF blank_H and blanck_V == 1 => all '0'.	
           in_scn_V : in  STD_LOGIC;	--blank_v.	
           red_mux : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input red (color mux)
           blue_mux : in  STD_LOGIC_VECTOR(1 downto 0);	--rgb input blue (color mux)
			  green_mux : in  STD_LOGIC_VECTOR(2 downto 0);	--rgb input green (color mux)
           red_out : out  STD_LOGIC_VECTOR(2 downto 0);	--rgb outnput red
           blue_out : out STD_LOGIC_VECTOR(1 downto 0);	--rgb output blue
           green_out : out  STD_LOGIC_VECTOR(2 downto 0));	--rgb input gren
end screener;

Signal blank_h, blank_v : STD_LOGIC;
Signal x,y : UNSIGNED ( 9 downto 0 );

begin

	h_counter : counter
		Generic Map(Nbit:= 10,
						End_Of_Screen:= 639,
						Start_Of_Pulse:= 655, 
						End_Of_Pulse:= 751,
						End_Of_Line:= 799);
	 
		Port Map ( clk => clk,
						reset => rst,
						enable => en,
						pulse_screen => hs,	--Connected to HS and VS in top module.
						in_screen => blank_h,	--Draw screen	
						end_screen => open,		--Reset counter
						Q => x);
						
	v_counter : counter
		Generic Map(Nbit:= 10,
						End_Of_Screen:= ,
						Start_Of_Pulse:= , 
						End_Of_Pulse:= ,
						End_Of_Line:= );
	 
		Port Map ( clk => clk,
						reset => rst,
						enable => en,
						pulse_screen => vs,	--Connected to HS and VS in top module.
						in_screen => blank_v,	--Draw screen	
						end_screen => open,		--Reset counter
						Q => y);

	floppy : floppy_hitbox
		Generic Map( default_pos_x := 79,
						default_pos_y := 300);
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
		Generic Map( default_pos_x := 639,
						default_pos_y := 259, 
						default_gap := 80 );
    Port Map( clk => clk,
           rst => clk,
           en => en,
           x => x,
           y => y,
           pipe_vel => pipe_vel, --Debug purposed, pipe_vel is actually non variable, it should be a generic
           pipe_pos_x => pipe_pos_x,
           pipe_right => pipe_right,
           pipe_pos_y => pipe_pos_y,
           pipe_top => pipe_top,
           inside_pipe => inside_pipe);
			  
	dali : artist
	    Port ( --rst : in  STD_LOGIC;
           en => en,
           --x : in  STD_LOGIC;
           --y : in  STD_LOGIC;
           inside_floppy => inside_floppy,
           inside_pipe => inside_pipe,
           R => r,
           G => g,
           B => b);
			  
	vga : screener
	    Port ( in_scn_H => blank_h,	--blank_h.	%IF blank_H and blanck_V == 1 => all '0'.	
           in_scn_V => blank_v,	--blank_v.	
           red_mux => r,	--rgb input red (color mux)
           blue_mux => g,	--rgb input blue (color mux)
			  green_mux => b,	--rgb input green (color mux)
           red_out => r_out,	--rgb outnput red
           blue_out => b_out,	--rgb output blue
           green_out => g_out,);	--rgb input gren


end Behavioral;

