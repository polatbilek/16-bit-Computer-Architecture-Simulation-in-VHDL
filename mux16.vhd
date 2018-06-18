--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;

entity mux4_16bit is port(
S : in std_logic_vector(1 downto 0);
 x0,x1,x2,x3 : in std_logic_vector (15 downto 0);
    y : out std_logic_vector (15 downto 0)
    );
end mux4_16bit;

Architecture behavioral of mux4_16bit is
signal dummy: std_logic;
Begin



Process(S,x0,x1,x2,x3)
           
begin
case S is
		when "00" => y<= x0;
		when "01" => y<= x1;
		when "10" => y<= x2;
		when "11" => y<= x3;
		when others     => y <= "XXXXXXXXXXXXXXXX";
		    
		end case; 
		        
end Process;
end behavioral;
