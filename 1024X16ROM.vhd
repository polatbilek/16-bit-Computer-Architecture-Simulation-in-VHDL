library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use IEEE.math_complex.all;
use work.opcodes.all;

entity rom1024 is port(
cs : in std_logic;
addr : in std_logic_vector (9 downto 0);
data : out std_logic_vector (15 downto 0)
);
end rom1024;

architecture imp of rom1024 is 
subtype cell is std_logic_vector(15 downto 0);
type rom_type is array(0 to 17) of cell;

constant ROM : rom_type :=(
movi&A&"00001001",--deger alir
call&"00000000011",
mov&A&B&"00000",
halt&"00000000000",
movi&C&"00000001",
movi&E&"00000010",
movi&B&"00000000",
movi&D&"00000001",
dec&A&A&"00000",
jz&"00000000111",
dec&C&C&"00000",
jnz&"10000000011",
add&D&D&E&"00",
mov&C&D&"00000",
inc&B&B&"00000",
jmp&"10000000111",
inc&B&B&"00000",
ret&"00000000000"
);


begin

process(cs, addr)
begin
	if (cs='1' and addr(9)='0') then
		data <= ROM(conv_integer(addr)); 

end if;
end process;

end imp;



