--created by ceng-tire-35

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use IEEE.math_complex.all;


entity SPsubs is port(
   input: in std_logic_vector(15 downto 0); -- sp den gelen input 
   sub2: in std_logic;
   output: out std_logic_vector(15 downto 0) --SP e döndürülcek olan de?er.
);
end SPsubs;

architecture imp of SPsubs is
    signal ret: std_logic_vector (15 downto 0);
    signal temp: std_logic_vector(4 downto 0);
    signal uunsigned_overflow: std_logic;
    signal ssigned_overflow: std_logic;
    signal ccarry:  std_logic;
    signal zzero:  std_logic;
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
begin
   -- process(sub2)
        --begin
        --if(sub2 = '1') then--ARTTIR
            --temp <= "00110";
        --elsif(sub2 = '0') then--AZALT
            --temp <= "00111";
    --end if;
--end process;
temp <= "0010"&(not sub2);
 U1 : ALU port map( S=>temp , A=>input , B=>"0000000000000001", F=>output, unsigned_overflow=>uunsigned_overflow, signed_overflow=>ssigned_overflow, carry=>ccarry, zeroo=>zzero );
 end imp;        



