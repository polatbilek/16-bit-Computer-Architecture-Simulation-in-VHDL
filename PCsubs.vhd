--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PCsubs is port(
   input:  in std_logic_vector(15 downto 0); 
   IR: in std_logic_vector(10 downto 0); 
   jmpMux: in std_logic;
   output: out std_logic_vector(15 downto 0) 
);
end PCsubs;

architecture imp of PCsubs is
    signal uunsigned_overflow: std_logic;
    signal ssigned_overflow: std_logic;
    signal ccarry:  std_logic;
    signal zzero:  std_logic;
    signal dummysignal: std_logic_vector(15 downto 0);
    signal alusel: std_logic_vector(4 downto 0 );
    signal tmp: std_logic;
    signal muxout: std_logic_vector(15 downto 0);
    signal Sconcact:std_logic_vector(1 downto 0);
    signal x1concact:std_logic_vector(15 downto 0);
    
component ALU is port (
     S:                   in std_logic_vector(4 downto 0);
     A, B:               in std_logic_vector(15 downto 0);
     F:                   out std_logic_vector(15 downto 0);
     unsigned_overflow:   out std_logic;
     signed_overflow:     out std_logic;
     carry:               out std_logic;
     zeroo:                out std_logic
);
end component;

component mux4_16bit is port(
    S : in std_logic_vector(1 downto 0);
    x0, x1, x2, x3 : in std_logic_vector (15 downto 0);
    y : out std_logic_vector (15 downto 0)
    );
end component;

begin
 tmp <= jmpMux and IR(10);
 alusel <= ("0010" & tmp);
 Sconcact <= ("0"&jmpMux);
 x1concact <= ("000000"&IR(9 downto 0));
 
 U0 : mux4_16bit port map(S=>Sconcact, x0=>"0000000000000001", x1=>x1concact, x2=>dummysignal, x3=>dummysignal, y=>muxout); 
 U1 : ALU port map( S=>alusel , A=>input , B=>muxout, F=>output, unsigned_overflow=>uunsigned_overflow, signed_overflow=>ssigned_overflow, carry=>ccarry, zeroo=>zzero );
 end imp; 

