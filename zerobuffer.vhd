--created by ceng-tire-35
-- copyright  ©  2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity zerobuf is port(
clk1: in std_logic;
reset: in std_logic;
input : in std_logic;
output: out std_logic;
enable: in std_logic
);

end zerobuf;



architecture imp of zerobuf is
signal cache: std_logic;
    begin 

        process(reset, input, enable)
begin
    if(reset='1')then
        output<= '0';
	cache <= '0';
    elsif(reset='0' and enable ='1') then
		output <= input;
		cache <= input;
    elsif(reset = '0' and enable = '0') then
		output <= cache;
	end if;

end process;
end imp;
