--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity LE16 is port(
      S:         in std_logic_vector(2 downto 0);
      A, B:      in std_logic_vector(15 downto 0);
      x:         out std_logic_vector(15 downto 0)
);
end LE16;


architecture imp of LE16 is

    component LE is port(
      S:         in std_logic_vector(2 downto 0);
      a, b:      in std_logic;
      x:         out std_logic
    );
    end component;
   
   begin
       
      U0  : LE port map(S, A(0),  B(0),  X(0)); 
      U1  : LE port map(S, A(1),  B(1),  X(1));
      U2  : LE port map(S, A(2),  B(2),  X(2));
      U3  : LE port map(S, A(3),  B(3),  X(3));
      U4  : LE port map(S, A(4),  B(4),  X(4));
      U5  : LE port map(S, A(5),  B(5),  X(5));
      U6  : LE port map(S, A(6),  B(6),  X(6));
      U7  : LE port map(S, A(7),  B(7),  X(7));
      U8  : LE port map(S, A(8),  B(8),  X(8));
      U9  : LE port map(S, A(9),  B(9),  X(9));
      U10 : LE port map(S, A(10), B(10), X(10));
      U11 : LE port map(S, A(11), B(11), X(11));
      U12 : LE port map(S, A(12), B(12), X(12));
      U13 : LE port map(S, A(13), B(13), X(13));
      U14 : LE port map(S, A(14), B(14), X(14));
      U15 : LE port map(S, A(15), B(15), X(15));   
      
end imp;

