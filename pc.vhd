--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;

entity PC is port(
clk5 : in std_logic;
reset : in std_logic;
load : in std_logic;
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (15 downto 0)
);

end PC;


architecture beh of PC is
signal reg : std_logic_vector (15 downto 0);

begin

process(load,reset)
begin
	if(reset='1') then
		OUTPUT <= "0000000000000000";
	elsif(load = '1') then
		if(INPUT = "XXXXXXXXXXXXXXXX") then
			OUTPUT <= "0000000000000000";
		else 
			OUTPUT <= INPUT;
	end if;
	end if;
end process;
end beh;


