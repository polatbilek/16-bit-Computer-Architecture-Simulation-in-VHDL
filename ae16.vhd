library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity AE16 is port(
      S:          in std_logic_vector(2 downto 0);
      A, B:       in std_logic_vector(15 downto 0);
      Y:          out std_logic_vector(15 downto 0)
);
end AE16;


architecture imp of AE16 is
    
    component AE is port(
      S:          in std_logic_vector(2 downto 0);
      a, b:       in std_logic;
      x:          out std_logic
    );
    end component;

    begin
        U0  : AE port map(S, A(0),  B(0),  Y(0));
        U1  : AE port map(S, A(1),  B(1),  Y(1));
        U2  : AE port map(S, A(2),  B(2),  Y(2));
        U3  : AE port map(S, A(3),  B(3),  Y(3));
        U4  : AE port map(S, A(4),  B(4),  Y(4));
        U5  : AE port map(S, A(5),  B(5),  Y(5));
        U6  : AE port map(S, A(6),  B(6),  Y(6));
        U7  : AE port map(S, A(7),  B(7),  Y(7));
        U8  : AE port map(S, A(8),  B(8),  Y(8));
        U9  : AE port map(S, A(9),  B(9),  Y(9));
        U10 : AE port map(S, A(10), B(10), Y(10));
        U11 : AE port map(S, A(11), B(11), Y(11));
        U12 : AE port map(S, A(12), B(12), Y(12));
        U13 : AE port map(S, A(13), B(13), Y(13));
        U14 : AE port map(S, A(14), B(14), Y(14));
        U15 : AE port map(S, A(15), B(15), Y(15));
        
   end imp;



