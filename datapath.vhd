--created by ceng-tire-35

library ieee;
use ieee.std_logic_1164.all;

entity dataPath is port(
clk10 : in std_logic;
reset : in std_logic;

pcen: in std_logic;
den1: in std_logic;
den2: in std_logic;
aen: in std_logic;

SPload: in std_logic;
PCload : in std_logic;

Psel : in std_logic_vector(1 downto 0);
Ssel : in std_logic_vector(1 downto 0);
Rsel : in std_logic_vector(1 downto 0);

sub2: in std_logic;
jmpMux : in std_logic;
opfetch : out std_logic;

IR : out std_logic_vector (4 downto 0);
IRload : in std_logic;

zero: out std_logic;
ALUsel : in std_logic_vector (4 downto 0);

regWa : in std_logic_vector(2 downto 0);
regRaa: in std_logic_vector(2 downto 0);
regRba: in std_logic_vector(2 downto 0);
regWe : in std_logic;
regRbe : in std_logic;
regRae : in std_logic;

outDataBus: out std_logic_vector(15 downto 0);
inDataBus: in std_logic_vector(15 downto 0);
outAddressBus: out std_logic_vector(15 downto 0)
);
end dataPath;

architecture struct of dataPath is

-----------------SIGNALS-------------------
signal alumuxout : std_logic_vector(15 downto 0);
signal irSignal : std_logic_vector (15 downto 0);

---------------------------------------------------

signal aluSignal : std_logic_vector (15 downto 0);
signal portaMux0 : std_logic_vector (15 downto 0);
signal portbMux0: std_logic_vector (15 downto 0);
signal portbout : std_logic_vector (15 downto 0);
signal inputdata : std_logic_vector (15 downto 0);
signal outputdata : std_logic_vector (15 downto 0);

signal selection : std_logic_vector(1 downto 0);

signal alusigned_overflow : std_logic;
signal aluunsigned_overflow :  std_logic;
signal alucarry : std_logic;

signal regD: std_logic_vector(15 downto 0);
signal PCout: std_logic_vector(15 downto 0);
signal pselMuxout: std_logic_vector(15 downto 0);
signal PCsubsout: std_logic_vector(15 downto 0);
signal outpcen: std_logic_vector(15 downto 0);
signal instruction: std_logic_vector(15 downto 0);
signal outdown: std_logic_vector(15 downto 0);
signal dummysignal: std_logic_vector(15 downto 0);

signal SPaddsub16: std_logic_vector(15 downto 0);
signal SPoutsignal: std_logic_vector(15 downto 0);
signal SSelMuxout: std_logic_vector(15 downto 0);
signal RSelconcat: std_logic_vector(15 downto 0);
signal PSelconcat: std_logic_vector(15 downto 0);
signal aaen: std_logic_vector(1 downto 0);
signal aeninsignal: std_logic_vector(15 downto 0);




------------- RegisterFile ---------------
component regfile is port(
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
   
end component;
-------------------------------------------
--------ALU---------
component ALU is port (
     S:                   in std_logic_vector(4 downto 0);
     A, B:                in std_logic_vector(15 downto 0);
     F:                   out std_logic_vector(15 downto 0);
     unsigned_overflow:   out std_logic;
     signed_overflow:     out std_logic;
     carry:               out std_logic;
     zeroo:                out std_logic
);
end component;
-------------------------------
----------------mux4--------------
component mux4 is port(
    S:                in std_logic_vector(1 downto 0);
    x0, x1, x2, x3:   in std_logic;
    y:                out std_logic
);
end component;

----------------------------------------
-------------16_bit_mux4------------------
component mux4_16bit is port(
    S : in std_logic_vector(1 downto 0);
    x0,x1,x2,x3 : in std_logic_vector (15 downto 0);
    y : out std_logic_vector (15 downto 0)
    );
end component;

-----------------------------------------
---------ProgramCounter------------------
component PC is port(
   clk5 : in std_logic;
   reset : in std_logic;
   load : in std_logic;
   INPUT : in std_logic_vector (15 downto 0);
   OUTPUT : out std_logic_vector (15 downto 0)
);

end component;
-------------------------------------------
-----------InstructionRegister-------------
component IR_16bit is port(
clk4 : in std_logic;
reset : in std_logic;
load : in std_logic;
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (15 downto 0)
);
end component;
----------------------------------------
---------------StackPointer-------------
component SP is port(
clk8 : in std_logic;
reset : in std_logic;
SPload : in std_logic;
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (15 downto 0)
);
end component;
----------------------------------------
---------------ADDSUB-------------------
component SPsubs is port(
   input: in std_logic_vector(15 downto 0); -- sp den gelen input 
   sub2: in std_logic;
   output: out std_logic_vector(15 downto 0) --SP e döndürülcek olan de?er.
);
end component;

----------------------------------------

------------BUFFER----------------------
component buf is port(
clk1: in std_logic;
reset: in std_logic;
input : in std_logic_vector (15 downto 0);
output: out std_logic_vector(15 downto 0);
enable: in std_logic
);

end component;
---------------------------------------
----------buffer 2---------------------
component buf2 is port(
clk2: in std_logic;
reset: in std_logic;
dataoutput: in std_logic_vector(15 downto 0);
datainput : out std_logic_vector (15 downto 0);
downin: in std_logic_vector(15 downto 0);
downout: out std_logic_vector(15 downto 0);
den1: in std_logic;
den2: in std_logic
);

end component;
--------------------------------------------
------------3inputbuffer--------------------
component threeinputbuf is port(
clk2: in std_logic;
reset: in std_logic;
portb : in std_logic_vector (15 downto 0);
ins: out std_logic_vector(15 downto 0);
datain: in std_logic_vector(15 downto 0);
dataout: out std_logic_vector(15 downto 0);
den1: in std_logic;
den2: in std_logic
);

end component;
----------------------------------------
----------PCsubs---------------------
component PCsubs is port(
   input:  in std_logic_vector(15 downto 0); 
   IR: in std_logic_vector(10 downto 0);
   jmpMux: in std_logic;
   output: out std_logic_vector(15 downto 0) 
);
end component;
--------------------------------------------
-----------END OF COMPONENTS---------------- 

begin 
RSelconcat <= "00000000"&irSignal(7 downto 0);

IR <= irSignal(15 downto 11);

PSelconcat <= "111111111"&"001"&"0000";
--portbout
InstructionRegister: IR_16bit port map(clk4=>clk10, reset=>reset, load=>IRload, INPUT=>instruction , OUTPUT=>irSignal);

RSelMux: mux4_16bit port map(S=>Rsel,x0=>RSelconcat ,x1=>"0000000000000000" ,x2=>portaMux0 ,x3=>instruction, y=>alumuxout);

AALU: ALU port map(S=>ALUsel, A=>alumuxout, B=>instruction, F=>regD, unsigned_overflow=>aluunsigned_overflow, signed_overflow=>alusigned_overflow, carry=>alucarry, zeroo=>zero);

RegisterFile: regfile port map(clk6=>clk10, reset=>reset, we=>regWe, WA=>irSignal(10 downto 8),D=>regD ,rbe=>regRbe, rae=>regRae, RAA=>irSignal(7 downto 5), RBA=>irSignal(4 downto 2), portA=>portaMux0, portB=>portbout);   

SPaddersubber: SPsubs port map( input=>SPoutsignal,sub2=>sub2,output=>SPaddsub16) ;

StackPointer: SP port map(clk8=>clk10, reset=>reset, SPload=>SPload, INPUT=>SPaddsub16 , OUTPUT=>SPoutsignal) ;

SselMux: mux4_16bit port map(S=>Ssel, x0=>portaMux0, x1=>PCout, x2=>SPoutsignal ,x3 =>dummysignal,y=>SSelMuxout);

aenBuffer: buf port map(clk1=>clk10, reset=>reset, input=>SSelMuxout, output=>outAddressBus, enable=>aen);

DataBusBuffer: buf2 port map(clk2=>clk10, reset=>reset, dataoutput=> outputdata, datainput=>inputdata, downin=>inDataBus, downout=>outdown,  den1=>den1,den2=>den2);

PortBDataBusBuffer: threeinputbuf port map(clk2=>clk10, reset=>reset, portb=>portbout, ins=>instruction, datain=>inputdata, dataout=> outputdata,  den1=>den1, den2=>den2);

ProgramCounter: PC port map(clk5=>clk10, reset=>reset, load=>PCload, INPUT=>pselMuxout, OUTPUT=>PCout);

ProgramCounterSub: PCsubs port map(input=>PCout, IR=>irSignal(10 downto 0), jmpMux=>jmpMux, output=>PCsubsout);

PSelMux: mux4_16bit port map(S=>Psel, x0=>PSelconcat , x1=>instruction, x2=>PCsubsout , x3=>dummysignal, y=>pselMuxout);

PcenBuffer: buf port map(clk1=>clk10, reset=>reset, input=>PCout, output=>outpcen, enable=>pcen);

selection <= '0'&( not pcen);

DataOutMux: mux4_16bit port map(S=>selection, x0=>outpcen, x1=>outdown, x2=>dummysignal ,x3 =>dummysignal,y=>outDataBus); 


end struct;
 


