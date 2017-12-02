----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:59:38 12/02/2017 
-- Design Name: 
-- Module Name:    pipe_hitbox - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipe_hitbox is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           x : in  STD_LOGIC;
           y : in  STD_LOGIC;
           unnamed : in  STD_LOGIC;
           pipe_pos_x : out  STD_LOGIC;
           pipe_right : out  STD_LOGIC;
           pipe_pos_y : out  STD_LOGIC;
           pipe_top : out  STD_LOGIC;
           inside_pipe : out  STD_LOGIC);
end pipe_hitbox;

architecture Behavioral of pipe_hitbox is

begin


end Behavioral;

