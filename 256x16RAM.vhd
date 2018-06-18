--created by ceng-tire-35
-- copyright  ©  2016
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.opcodes.all;

entity ram_256_16 is port(
   resett:     in std_logic;
   cs:         in std_logic; --chip select
   csstack:    in std_logic;--chip select stack
   csint:      in std_logic;--chip select interrupt
   wr:         in std_logic; --write enable
   rd:         in std_logic;--read enable
   addr:       in std_logic_vector(15 downto 0);
   di:         in std_logic_vector(15 downto 0); -- data in
   do:         out std_logic_vector(15 downto 0) --data out
);
end ram_256_16;

architecture imp of ram_256_16 is
    
    subtype cell is std_logic_vector(15 downto 0);
    type ram_type is array(64512 to 65535) of cell;
    signal RAM: ram_type;

    subtype reg is 	std_logic_vector (15 downto 0);
    type regArray is array(0 to 15) of reg;
    signal SF :regArray;

    subtype ISR is std_logic_vector(15 downto 0);
    type int_type is array(0 to 5) of ISR;

    constant INT : int_type :=(
	movi&A&"00000000",
	mov&C&D&"00000",
	add&A&A&D&"00",
	dec&C&C&"00000",
	jnz&"10000000010",
	ret&"00000000000"
	);
    
    signal push: std_logic;
    signal dummysignal: std_logic;
    signal ccsint: std_logic;
    signal ccsstack: std_logic;
    signal ccs: std_logic;

    begin
	process(csstack, cs, csint, di, resett, addr)

    variable index 	: integer :=15;
    variable ctrl:      std_logic_vector(2 downto 0);

	begin

    ccs <= addr(15) and addr(14) and addr(13) and addr(12) and addr(11) and addr(10);
    ccsstack <= addr(15) and addr(14) and addr(13) and addr(12) and addr(11) and addr(10) and addr(9) and addr(8) and addr(7) and addr(6) and addr(5) and addr(4) and (addr(3) or addr(2) or addr(1) or addr(0));
    ccsint <= addr(15) and addr(14) and addr(13) and addr(12) and addr(11) and addr(10) and addr(9) and addr(8) and addr(7) and ((not addr(6)) or (not addr(5)) or (not addr(4)));
   
	ctrl := cs & wr & rd;
			if(csstack='0' and csint = '0' and cs= '1' and addr(7)='0' and addr(4)='0') then
			    if(cs = '1') then
                                case ctrl is
                                    when "110" => 
                                              RAM(conv_integer(addr)) <= di;
                                    when "101" =>
                                              do <= RAM(conv_integer(addr));
                                    when others =>
                                              dummysignal <= '0';
                                end case;
			    end if;
			end if;
dummysignal <= '0';
 			if(addr(15) = '1' and addr(14) = '1' and addr(13) = '1' and addr(12) = '1' and addr(11) = '1' and addr(10) = '1' and addr(9) = '1' and addr(8) = '1' and addr(7) = '1' and (not (addr(6) = '1' and addr(5) = '1' and addr(4) = '1')) and (not ((not addr(6) = '1') and (not addr(5) = '1') and (not addr(4) = '1')))) then
			   dummysignal <= '1';
			    do <= INT(conv_integer(addr(3 downto 0)));
			end if;

	if (resett='1') then
		SF(0) <= "0000000000000000";
		SF(1) <= "0000000000000000";
		SF(2) <= "0000000000000000";
		SF(3) <= "0000000000000000";
		SF(4) <= "0000000000000000";
		SF(5) <= "0000000000000000";
		SF(6) <= "0000000000000000";
		SF(7) <= "0000000000000000";
		SF(8) <= "0000000000000000";
		SF(9) <= "0000000000000000";
		SF(10) <= "0000000000000000";
		SF(11) <= "0000000000000000";
		SF(12) <= "0000000000000000";
		SF(13) <= "0000000000000000";
		SF(14) <= "0000000000000000";
		SF(15) <= "0000000000000000";
	
	
	index :=15;
	elsif(WR='1' and addr(15) = '1' and addr(14) = '1' and addr(13) = '1' and addr(12) = '1' and addr(11) = '1' and addr(10) = '1' and addr(9) = '1' and addr(8) = '1' and addr(7) = '1' and addr(6) = '1' and addr(5) = '1' and addr(4) = '1') then

		SF(index) <= std_logic_vector(to_unsigned(to_integer(unsigned( di  )) + 1, 16));
		index :=index -1;

		if (index= -1) then 
			index :=0;
		end if;

	elsif(RD='1' and addr(15) = '1' and addr(14) = '1' and addr(13) = '1' and addr(12) = '1' and addr(11) = '1' and addr(10) = '1' and addr(9) = '1' and addr(8) = '1' and addr(7) = '1' and addr(6) = '1' and addr(5) = '1' and addr(4) = '1') then
		index := index +1;

		if (index = 16) then
			index :=15;
		end if;

		if(csint = '0') then
			do <= SF(index);
			SF(index) <= "0000000000000000";
		end if;
	end if;
       end process;
end imp;




