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

entity tester is port(
   outAddress: out std_logic_vector(15 downto 0)
);
end tester;


architecture imp of tester is
    

component upabs3 is port(
   clk9:       in std_logic;
   reset:      in std_logic;
   opfetch:    out std_logic;
   INT:        in std_logic;
   INTA:       out std_logic;
   WR:         out std_logic;
   RD:         out std_logic;
   A:          out std_logic_vector(15 downto 0);
   Datain:     in std_logic_vector(15 downto 0);
   Dataout:    out std_logic_vector(15 downto 0)
);
end component;

component ram_256_16 is port(
   resett:     in std_logic;
   cs:         in std_logic; --chip select
   csstack:    in std_logic;--stack chip select
   csint:      in std_logic;--chip select interrupt
   wr:         in std_logic; --write enable
   rd:         in std_logic;--read enable
   addr:       in std_logic_vector(15 downto 0);
   di:         in std_logic_vector(15 downto 0); -- data in
   do:         out std_logic_vector(15 downto 0)--data out
); 
end component;


component rom1024 is port(
cs : in std_logic;
addr : in std_logic_vector (9 downto 0);
data : out std_logic_vector (15 downto 0)
);
end component;

component mux4_16bit is port(
    S : in std_logic_vector(1 downto 0);
    x0,x1,x2,x3 : in std_logic_vector (15 downto 0);
    y : out std_logic_vector (15 downto 0)
    );
end component;

component decoder is port(
   address: in std_logic_vector(15 downto 0);
   cs1: out std_logic;
   cs2: out std_logic;
   cs3: out std_logic;
   cs4: out std_logic
);
end component;

signal clksig:  std_logic;
signal reset:   std_logic;
signal oopfetch:std_logic;
signal IINT:    std_logic;
signal IINTA:   std_logic;
signal WWR:     std_logic;
signal RRD:     std_logic;

signal ccs:     std_logic;
signal adress:  std_logic_vector(15 downto 0);
signal dataout: std_logic_vector(15 downto 0);
signal datain:  std_logic_vector(15 downto 0);

signal ccs1:    std_logic;--ROM
signal ccs2:    std_logic;--8255
signal ccs3:    std_logic;--RAM
signal ccs4:    std_logic;--STACK
signal ccs5:    std_logic;--interrupt

signal dummysignal:    std_logic_vector(15 downto 0);
signal Ramout: std_logic_vector(15 downto 0);
signal Romout: std_logic_vector(15 downto 0);
signal selection: std_logic_vector(1 downto 0);



begin
 process(adress)
begin

    ccs1 <= (not adress(15)) and (not adress(14)) and (not adress(13)) and (not adress(12)) and (not adress(11)) and (not adress(10));
    ccs2 <= adress(15) and (not adress(14)) and (not adress(13)) and (not adress(12)) and (not adress(11)) and (not adress(10)) and (not adress(9)) and (not adress(8)) and (not adress(7)) and (not adress(6)) and (not adress(5)) and (not adress(4)) and (not adress(3)) and (not adress(2));
    ccs3 <= adress(15) and adress(14) and adress(13) and adress(12) and adress(11) and adress(10);
    ccs4 <= adress(15) and adress(14) and adress(13) and adress(12) and adress(11) and adress(10) and adress(9) and adress(8) and adress(7) and adress(6) and adress(5) and adress(4) and (adress(3) or adress(2) or adress(1) or adress(0));
    ccs5 <= adress(15) and adress(14) and adress(13) and adress(12) and adress(11) and adress(10) and adress(9) and adress(8) and adress(7) and ((not adress(6)) or (not adress(5)) or (not adress(4)));
   
end process;

    Upubs: upabs3 port map(clk9=>clksig, reset=>reset, opfetch=>oopfetch, INT=>IINT, INTA=> IINTA, WR=> WWR, RD=>RRD, A=>adress, Datain=>datain, Dataout=>dataout);
    outAddress <= adress;
    selection <= '0'&ccs3;
    MUX: mux4_16bit port map(S=>selection, x0=>Romout, x1=>Ramout, x2=>dummysignal, x3=>dummysignal, y=>datain);
    ROM: rom1024 port map(cs=>ccs1, addr=>adress(9 downto 0), data=>Romout);
    RAM: ram_256_16 port map(resett=> reset, cs=>ccs3, csstack=>ccs4, csint=>ccs5, wr=>WWR, rd=>RRD, addr=>adress, di=>dataout, do=>Ramout);

end imp;

