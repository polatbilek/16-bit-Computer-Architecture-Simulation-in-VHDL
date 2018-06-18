--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;

entity IR_16bit is port(
clk4 : in std_logic;
reset : in std_logic;
load : in std_logic;
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (15 downto 0)
);

end IR_16bit;


architecture imp of IR_16bit is

 
begin
process(INPUT, load, reset)
begin
	if(reset='1') then
		OUTPUT <= "0000000000000000";
	elsif(load = '1') then
		OUTPUT <= INPUT;
	end if;
end process;
end imp;

