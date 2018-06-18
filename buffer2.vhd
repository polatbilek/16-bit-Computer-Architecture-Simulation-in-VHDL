library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity buf2 is port(
clk2: in std_logic;
reset: in std_logic;
dataoutput: in std_logic_vector(15 downto 0);
datainput : out std_logic_vector (15 downto 0);
downin: in std_logic_vector(15 downto 0);
downout: out std_logic_vector(15 downto 0);
den1: in std_logic;
den2: in std_logic
);

end buf2;

architecture imp of buf2 is
    begin 
        process(reset, downin, dataoutput,den1, den2)
begin
   if(reset ='0') then
	if(den1 = '1') then
		datainput <= downin;
	elsif(den2 = '1') then
		downout <= dataoutput;
	end if;
end if;
end process;

end imp;



