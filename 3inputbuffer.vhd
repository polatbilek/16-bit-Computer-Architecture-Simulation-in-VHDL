--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity threeinputbuf is port(
clk2: in std_logic;
reset: in std_logic;
portb : in std_logic_vector (15 downto 0);
ins: out std_logic_vector(15 downto 0);
datain: in std_logic_vector(15 downto 0);
dataout: out std_logic_vector(15 downto 0);
den1: in std_logic;
den2: in std_logic
);

end threeinputbuf;

architecture imp of threeinputbuf  is
    begin 
        process(reset, datain, portb, den1, den2)
begin
   if(reset ='0') then
	if(den1 = '1') then
		ins <= datain;
	elsif(den2 = '1') then
		dataout <= portb;
	elsif(den1='0' and den2='0') then
		ins <= portb;
	end if;
end if;
end process;

end imp;



