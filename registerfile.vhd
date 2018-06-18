--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity regfile is port(
   clk6:           in std_logic;
   reset:          in std_logic;      
   we:             in std_logic;
   WA:             in std_logic_vector(2 downto 0);
   D:              in std_logic_vector(15 downto 0);
   rbe:            in std_logic;
   rae:            in std_logic;
   RAA:            in std_logic_vector(2 downto 0);
   RBA:            in std_logic_vector(2 downto 0);
   portA:          out std_logic_vector(15 downto 0);
   portB:          out std_logic_vector(15 downto 0)
       );
   
end regfile;

architecture imp of regfile is
   
    subtype reg is std_logic_vector(15 downto 0);
    type regArray is array(0 to 7) of reg;
    signal RF: regArray;

begin 
      WritePort:Process(clk6,reset)
      begin
               if(reset='1') then
                            RF(0) <= (others => '0');
                            RF(1) <= (others => '0');
                            RF(2) <= (others => '0');
                            RF(3) <= (others => '0');
                            RF(4) <= (others => '0');
                            RF(5) <= (others => '0');
                            RF(6) <= (others => '0');
                            RF(7) <= (others => '1');
               elsif(we='1') then
                               RF(conv_integer(WA)) <= D;
              end if;
end process;


ReadPortA: Process(rae,RAA)

begin
       if(rae='1') then
              PortA <= RF(conv_integer(RAA));
       else   
              PortA <=(others =>'X');
   end if;
   
 end process;

 


ReadPortB: Process(rbe,RBA)

begin
       if(rbe='1') then
              PortB <= RF(conv_integer(RBA));
       else
              PortB <=(others =>'X');
   end if;
   
 end process;

 


end imp;
 

