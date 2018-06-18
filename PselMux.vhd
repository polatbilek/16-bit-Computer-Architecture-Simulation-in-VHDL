--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;

entity psel_mux4 is port(
reset: in std_logic;
S : in std_logic_vector(1 downto 0);
 x0,x1,x2,x3 : in std_logic_vector (15 downto 0);
    y : out std_logic_vector (15 downto 0)
    );
end psel_mux4;

Architecture behavioral of psel_mux4 is
signal dummy: std_logic;
Begin



Process(reset,S,x0,x1,x2,x3)
           
begin
if(reset = '1') then
y <= "0000000000000000";
elsif(reset= '0') then
case S is
		when "00" => y<= x0;
		when "01" => y<= x1;
		when "10" => y<= x2;
		when "11" => y<= x3;
		when others => dummy <= '1';
		    
		end case;
		 
end if;       
end Process;
end behavioral;
