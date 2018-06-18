library ieee;
use ieee.std_logic_1164.all;

entity SP is port(
clk8 : in std_logic;
reset : in std_logic;
SPload : in std_logic;
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (15 downto 0)
);

end SP;


architecture beh of SP is
signal stackptr: std_logic_vector(15 downto 0);


begin

process(reset, SPload)
begin
	if(reset='1') then
		OUTPUT <= "1111111111111111";
		stackptr <= "1111111111111111";
	elsif(SPload = '1') then
		OUTPUT <= stackptr;
		stackptr <= INPUT;
	elsif(SPload = '0') then
		OUTPUT <= stackptr;
	end if;

end process;
end beh;


