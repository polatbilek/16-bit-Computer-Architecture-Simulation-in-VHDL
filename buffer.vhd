--created by ceng-tire-35
-- copyright  ©  2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity buf is port(
clk1: in std_logic;
reset: in std_logic;
input : in std_logic_vector (15 downto 0);
output: out std_logic_vector(15 downto 0);
enable: in std_logic
);

end buf;

architecture imp of buf is
    begin 
        process(reset, input, enable)
begin
    if(reset='1')then
        output<="0000000000000000";
    elsif(reset='0' and enable ='1') then
		output<= input;
	end if;

end process;
end imp;
