library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity artist is	--This block draws the screen
    Port ( clk : in STD_LOGIC;
				en : in  STD_LOGIC;	--Turn off (black) the screen
           inside_floppy : in  STD_LOGIC;	--Cursor is inside floppy
           inside_pipe : in  STD_LOGIC;	--Cursor is inside some pipe
			  y : in unsigned ( 9 downto 0 );--Cursor actual position (used to paint the background)
			  pipe_index : in unsigned(11 downto 0);--Memory addres index for pipes
			  floppy_index : in unsigned(9 downto 0);--Memory addres index for floppy
           R : out  STD_LOGIC_VECTOR( 2 downto 0);--RGB values to pass to the VGA driver
           G : out  STD_LOGIC_VECTOR( 2 downto 0);
           B : out  STD_LOGIC_VECTOR( 1 downto 0));
end artist;

architecture Behavioral of artist is
	--ROM related signals
	signal f_romdata : STD_LOGIC_VECTOR (7 downto 0);	--Floppy rgb values (stored in floppy_rom)
	signal f_romaddr : STD_LOGIC_VECTOR (9 downto 0);	--Floppy image addres. To paint a 32x32 image we need 1024 lenght word(2^10).
	signal p_romdata : STD_LOGIC_VECTOR (7 downto 0);	--3bits RED, 3bits GREEN, 2bits BLUE
	signal p_romaddr : STD_LOGIC_VECTOR (11 downto 0);	--Pipes image address. To paint two 32x64 image we need 4096 lenght word(2^12).
	
	COMPONENT floppy_ROM is	--ip for floppy image
	PORT ( clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	
	component pipe_ROM	--ip for pipes image
	port (clka: IN std_logic;
		addra: IN std_logic_VECTOR(11 downto 0);
		douta: OUT std_logic_VECTOR(7 downto 0));
	end component;
	
begin

	floppy_ROM0 : floppy_ROM
		Port Map (
			clka => clk,
			addra => f_romaddr,
			douta => f_romdata);
			
	pipe_ROM0 : pipe_ROM
		port map (
			clka => clk,
			addra => p_romaddr,
			douta => p_romdata);
	
	mux: process( en, inside_floppy, inside_pipe, y, f_romdata, p_romdata, pipe_index, floppy_index)
		VARIABLE number_index : unsigned(9 downto 0);
	begin
		R <= "000"; G <= "000"; B <= "00"; --When enable='0' the screen is black
		f_romaddr<="0000000000";
		if ( en = '1' ) then
		
			f_romaddr<="0000000000";
			p_romaddr<="000000000000";
		
			if y < 419 then 								--Sky is...
				R <= "000"; G <= "001"; B <= "11";	--blue
			elsif y < 429 then 							--Grass is...
				R <= "001"; G <= "111"; B <= "01";	--green
			else												--Dust is...
				R <= "110"; G <= "100"; B <= "00";	--brown?
			end if;
			
			if ( inside_floppy = '1' ) then --Draw floppy from floppy_ROM
				f_romaddr <= STD_LOGIC_VECTOR(floppy_index);
				r <= f_romdata(7 downto 5);
				g <= f_romdata(4 downto 2);
				b <= f_romdata(1 downto 0);		
			elsif ( inside_pipe = '1' ) then	--Draw pipe from pipe_ROM
				p_romaddr <= STD_LOGIC_VECTOR(pipe_index);
				r <= p_romdata(7 downto 5);
				g <= p_romdata(4 downto 2);
				b <= p_romdata(1 downto 0);
			end if;
			
		end if;
	end process;
	
end Behavioral;

