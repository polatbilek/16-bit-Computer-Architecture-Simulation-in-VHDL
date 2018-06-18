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
use work.opcodes.all;

entity decoder is port(
   address: in std_logic_vector(15 downto 0);
   cs1: out std_logic;--ROM
   cs2: out std_logic;--8255
   cs3: out std_logic;--RAM
   cs4: out std_logic--stack
);
end decoder;

architecture imp of decoder is
    begin
    cs1 <= (not address(15)) and (not address(14)) and (not address(13)) and (not address(12)) and (not address(11)) and (not address(10));
    cs2 <= address(15) and (not address(14)) and (not address(13)) and (not address(12)) and (not address(11)) and (not address(10)) and (not address(9)) and (not address(8)) and (not address(7)) and (not address(6)) and (not address(5)) and (not address(4)) and (not address(3)) and (not address(2));
    cs3 <= address(15) and address(14) and address(13) and address(12) and address(11) and address(10);
    cs4 <= address(15) and address(14) and address(13) and address(12) and address(11) and address(10) and address(9) and address(8) and address(7) and address(6) and address(5) and address(4) and (address(3) or address(2) or address(1) or address(0));
end imp;
