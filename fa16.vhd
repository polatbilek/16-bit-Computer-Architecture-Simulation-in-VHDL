--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FA16 is port(
            A :                  in std_logic_vector(15 downto 0);
            B :                  in std_logic_vector(15 downto 0);
            F :                  out std_logic_vector(15 downto 0);
            cIn:                 in std_logic ;
            unsigned_overflow:   out std_logic;
            signed_overflow:     out std_logic
);             
end FA16;

architecture imp of FA16 is
    
    component fa port(
          carryIn:         in std_logic;
          carryOut:        out std_logic;
          x,y:             in std_logic;
          s:               out std_logic
    );
    end component;

   signal C:            std_logic_vector(15 downto 1);
   
begin
   
   U0  : fa port map(cIn,   C(1),  A(0),  B(0),  F(0));
   U1  : fa port map(C(1),  C(2),  A(1),  B(1),  F(1)); 
   U2  : fa port map(C(2),  C(3),  A(2),  B(2),  F(2));
   U3  : fa port map(C(3),  C(4),  A(3),  B(3),  F(3));
   U4  : fa port map(C(4),  C(5),  A(4),  B(4),  F(4));
   U5  : fa port map(C(5),  C(6),  A(5),  B(5),  F(5));
   U6  : fa port map(C(6),  C(7),  A(6),  B(6),  F(6));
   U7  : fa port map(C(7),  C(8),  A(7),  B(7),  F(7));
   U8  : fa port map(C(8),  C(9),  A(8),  B(8),  F(8));
   U9  : fa port map(C(9),  C(10), A(9),  B(9),  F(9));
   U10 : fa port map(C(10), C(11), A(10), B(10), F(10));
   U11 : fa port map(C(11), C(12), A(11), B(11), F(11));
   U12 : fa port map(C(12), C(13), A(12), B(12), F(12));
   U13 : fa port map(C(13), C(14), A(13), B(13), F(13));
   U14 : fa port map(C(14), C(15), A(14), B(14), F(14)); 
   U15 : fa port map(C(15), unsigned_overflow,A(15),B(15),F(15));
   
   signed_overflow <= C(15) xor C(14) ;
   
end imp;
